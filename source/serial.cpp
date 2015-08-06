#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_serial_core( lua_State *state );

GMOD_MODULE_OPEN( )
{
	LUA->PushSpecial( GarrysMod::Lua::SPECIAL_GLOB );

	if( luaopen_serial_core( state ) == 1 )
		LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}

GMOD_MODULE_CLOSE( )
{
	LUA->PushSpecial( GarrysMod::Lua::SPECIAL_GLOB );
	
	LUA->PushNil( );
	LUA->SetField( -2, "serial" );

	LUA->Pop( 1 );
	return 0;
}
