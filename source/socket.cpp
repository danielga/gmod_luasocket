#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_socket_core( lua_State *state );

int parseWhitelist();
void clearWhitelist();
enum : int
{
	PARSE_SUCCESS = 0,
	PARSE_CANT_READ = 1,
	PARSE_NO_ENTRIES = 2
};

GMOD_MODULE_OPEN( )
{
	#ifdef USE_WHITELIST
		switch (parseWhitelist())
		{
		case PARSE_SUCCESS:
			break;
		case PARSE_CANT_READ:
			LUA->ThrowError("Failed to read whitelist file!");
			break;
		case PARSE_NO_ENTRIES:
			LUA->ThrowError("Didn't find any valid entries in whitelist file!");
			break;
		default:
			break;
		}
	#endif

	if( luaopen_socket_core( LUA->GetState( ) ) == 1 )
	{
		LUA->Push( -1 );
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	#ifdef USE_WHITELIST
		clearWhitelist();
	#endif

	LUA->PushNil( );
	LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	return 0;
}
