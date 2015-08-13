#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_socket_serial( lua_State *state );

GMOD_MODULE_OPEN( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	if( luaopen_socket_serial( state ) == 1 )
		LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}

GMOD_MODULE_CLOSE( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	LUA->PushNil( );
	LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}
