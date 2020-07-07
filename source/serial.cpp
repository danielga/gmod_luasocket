#include <GarrysMod/Lua/Interface.h>
#include <lua.hpp>

extern "C" int luaopen_socket_serial( lua_State *state );

GMOD_MODULE_OPEN( )
{
	if( luaopen_socket_serial( LUA->GetState( ) ) != 1 )
		return 0;

	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );
	LUA->Push( -2 );
	LUA->SetField( -2, "serial" );
	LUA->Pop( 1 );
	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->GetField( GarrysMod::Lua::INDEX_GLOBAL, "socket" );

	LUA->PushNil( );
	LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}
