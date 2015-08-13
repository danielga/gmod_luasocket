#include <GarrysMod/Lua/Interface.h>

extern "C" int luaopen_mime_core( lua_State *state );

GMOD_MODULE_OPEN( )
{
	if( luaopen_mime_core( state ) == 1 )
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "mime" );

	return 0;
}

GMOD_MODULE_CLOSE( )
{
	if( luaopen_mime_core( state ) == 1 )
		LUA->SetField( GarrysMod::Lua::INDEX_GLOBAL, "mime" );

	return 0;
}
