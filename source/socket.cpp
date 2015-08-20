#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_socket_core( lua_State *state );

GMOD_MODULE_OPEN( )
{
	if( luaopen_socket_core( state ) == 1 )
	{
		LUA->Push( -1 );
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->PushNil( );
	LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	return 0;
}
