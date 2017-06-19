#include <GarrysMod/Lua/Interface.h>
#include <lua.hpp>

extern "C" int luaopen_socket_unix( lua_State *state );

GMOD_MODULE_OPEN( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	if( luaopen_socket_unix( LUA->GetState() ) == 1 )
	{
		lua_replace( LUA->GetState(), 1 );
		lua_settop( LUA->GetState(), 1 );
		LUA->Push( -1 );
		LUA->SetField( -3, "unix" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	LUA->PushNil( );
	LUA->SetField( -2, "unix" );

	LUA->Pop( 1 );
	return 0;
}
