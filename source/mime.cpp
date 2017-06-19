#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_mime_core( lua_State *state );

GMOD_MODULE_OPEN( )
{
	if( luaopen_mime_core( LUA->GetState( ) ) == 1 )
	{
		LUA->Push( -1 );
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "mime" );
	}

	return 1;
}

GMOD_MODULE_CLOSE( )
{
	LUA->PushNil( );
	LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "mime" );
	return 0;
}
