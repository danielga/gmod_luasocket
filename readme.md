# gmod_luasocket

Modules for Garry's Mod that add bindings for OS sockets through [luasocket][1].

## Info

This project is composed by the Lua modules (in includes/modules) and the internal (binary) modules (socket.core, mime.core, unix and serial, where the last two are Unix only).
You can also refer to this project as gm_luasocket or Luasocket for Garry's Mod.
The Lua files go into lua/includes/modules (just copy includes from this repo onto lua) and the binary modules go into lua/bin.

Mac was not tested at all (sorry but I'm poor).

If stuff starts erroring or fails to work, be sure to check the correct line endings (\n and such) are present in the files for each OS.

This project requires [garrysmod_common][2], a framework to facilitate the creation of compilations files (Visual Studio, make, XCode, etc). Simply set the environment variable 'GARRYSMOD_COMMON' or the premake option 'gmcommon' to the path of your local copy of [garrysmod_common][2].


  [1]: https://github.com/diegonehab/luasocket
  [2]: https://github.com/danielga/garrysmod_common
