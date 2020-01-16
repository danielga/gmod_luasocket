#include <GarrysMod/Lua/Interface.h>

#include <fstream>
#include <string>
#include <unordered_map>
#include <unordered_set>

#include "filter.h"

extern "C" int luaopen_socket_core( lua_State *state );

namespace filter
{
enum class load_result
{
	success,
	failed_open,
	no_entries
};

#ifdef ENABLE_WHITELIST
static constexpr char s_whitelist_path[] = "luasocket_whitelist.txt";
static std::unordered_map<std::string, std::unordered_set<std::string>> s_whitelist_direct;
static std::unordered_map<std::string, std::unordered_set<std::string>> s_whitelist_wildcard;

static void ParseLine( const std::string &line, std::string &node, std::string &service, bool &hasWildcards )
{
	hasWildcards = false;

	for( size_t k = 0; k < line.size( ); ++k )
	{
		if( line[k] == '*' || line[k] == '?' )
		{
			hasWildcards = true;
		}
		else if( line[k] == ':' )
		{
			node = line.substr( 0, k - 1 );
			service = line.substr( k + 1 );
			return;
		}
	}

	node = line;
}

static load_result LoadWhitelist( )
{
	std::ifstream input( s_whitelist_path );
	if( !input )
	{
		return load_result::failed_open;
	}

	std::string line;
	while( std::getline( input, line ) )
	{
		std::string node;
		std::string service;
		bool hasWildcards = false;
		ParseLine( line, node, service, hasWildcards );

		if( hasWildcards )
		{
			if( service.empty( ) )
			{
				s_whitelist_wildcard.emplace( node, std::unordered_set<std::string>( ) );
			}
			else
			{
				s_whitelist_wildcard[node].insert( service );
			}
		}
		else
		{
			if( service.empty( ) )
			{
				s_whitelist_direct.emplace( node, std::unordered_set<std::string>( ) );
			}
			else
			{
				s_whitelist_direct[node].insert( service );
			}
		}
	}

	return s_whitelist_direct.empty( ) && s_whitelist_wildcard.empty( ) ? load_result::no_entries : load_result::success;
}

static void ClearWhitelist( )
{
	s_whitelist_direct.clear( );
	s_whitelist_wildcard.clear( );
}

// Copyright 2018 IBM Corporation
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Compares two text strings.  Accepts '?' as a single-character wildcard.  
// For each '*' wildcard, seeks out a matching sequence of any characters 
// beyond it.  Otherwise compares the strings a character at a time. 
//
static bool FastWildCompare( const char *pWild, const char *pTame )
{
	const char *pWildSequence = nullptr;  // Points to prospective wild string match after '*'
	const char *pTameSequence = nullptr;  // Points to prospective tame string match

	// Find a first wildcard, if one exists, and the beginning of any  
	// prospectively matching sequence after it.
	do
	{
		// Check for the end from the start.  Get out fast, if possible.
		if( *pTame == '\0' )
		{
			if( *pWild != '\0' )
			{
				while( *++pWild == '*' )
				{
					if( *pWild == '\0' )
					{
						return true;   // "ab" matches "ab*".
					}
				}

				return false;          // "abcd" doesn't match "abc".
			}
			else
			{
				return true;           // "abc" matches "abc".
			}
		}
		else if( *pWild == '*' )
		{
			// Got wild: set up for the second loop and skip on down there.
			while( *++pWild == '*' )
			{
				continue;
			}

			if( *pWild == '\0' )
			{
				return true;           // "abc*" matches "abcd".
			}

			// Search for the next prospective match.
			if( *pWild != '?' )
			{
				while( *pWild != *pTame )
				{
					if( *++pTame == '\0' )
					{
						return false;  // "a*bc" doesn't match "ab".
					}
				}
			}

			// Keep fallback positions for retry in case of incomplete match.
			pWildSequence = pWild;
			pTameSequence = pTame;
			break;
		}
		else if( *pWild != *pTame && *pWild != '?' )
		{
			return false;              // "abc" doesn't match "abd".
		}

		++pWild;                       // Everything's a match, so far.
		++pTame;
	}
	while( true );

	// Find any further wildcards and any further matching sequences.
	do
	{
		if( *pWild == '*' )
		{
			// Got wild again.
			while( *++pWild == '*' )
			{
				continue;
			}

			if( *pWild == '\0' )
			{
				return true;           // "ab*c*" matches "abcd".
			}

			if( *pTame == '\0' )
			{
				return false;          // "*bcd*" doesn't match "abc".
			}

			// Search for the next prospective match.
			if( *pWild != '?' )
			{
				while( *pWild != *pTame )
				{
					if( *++pTame == '\0' )
					{
						return false;  // "a*b*c" doesn't match "ab".
					}
				}
			}

			// Keep the new fallback positions.
			pWildSequence = pWild;
			pTameSequence = pTame;
		}
		else if( *pWild != *pTame && *pWild != '?' )
		{
			// The equivalent portion of the upper loop is really simple.
			if( *pTame == '\0' )
			{
				return false;          // "*bcd" doesn't match "abc".
			}

			// A fine time for questions.
			while( *pWildSequence == '?' )
			{
				++pWildSequence;
				++pTameSequence;
			}

			pWild = pWildSequence;

			// Fall back, but never so far again.
			while( *pWild != *++pTameSequence )
			{
				if( *pTameSequence == '\0' )
				{
					return false;      // "*a*b" doesn't match "ac".
				}
			}

			pTame = pTameSequence;
		}

		// Another check for the end, at the end.
		if( *pTame == '\0' )
		{
			// "*bc" matches "abc", "*bc" doesn't match "abcd".
			return *pWild == '\0';
		}

		++pWild;                       // Everything's still a match.
		++pTame;
	}
	while( true );

	// should never be reached
	return false;
}

static bool IsAcceptableHost( const char *node, const char *service )
{
	{
		auto domain = s_whitelist_direct.find( node );
		if( domain != s_whitelist_direct.end( ) )
		{
			const auto &services = domain->second;
			return service == nullptr || services.empty( ) || services.find( service ) != services.end( );
		}
	}

	for( const auto &whitelist_pair : s_whitelist_wildcard )
	{
		if( FastWildCompare( whitelist_pair.first.c_str( ), node ) )
		{
			const auto &services = whitelist_pair.second;
			if( service == nullptr || services.empty( ) || services.find( service ) != services.end( ) )
			{
				return true;
			}
		}
	}

	return false;
}

extern "C" int filter_isacceptablehost( const char *node, const char *service )
{
	return IsAcceptableHost( node, service ) ? 1 : 0;
}
#else
static load_result LoadWhitelist( )
{
	return load_result::success;
}

static void ClearWhitelist( )
{ }

extern "C" int filter_isacceptablehost( const char *, const char * )
{
	return 1;
}
#endif
}

GMOD_MODULE_OPEN( )
{
	switch( filter::LoadWhitelist( ) )
	{
	case filter::load_result::success:
		break;

	case filter::load_result::failed_open:
		LUA->ThrowError( "Failed to read whitelist file!" );
		break;

	case filter::load_result::no_entries:
		LUA->ThrowError( "Didn't find any valid entries in whitelist file!" );
		break;

	default:
		break;
	}

	if( luaopen_socket_core( LUA->GetState( ) ) == 1 )
	{
		LUA->Push( -1 );
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	filter::ClearWhitelist( );

	LUA->PushNil( );
	LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	return 0;
}
