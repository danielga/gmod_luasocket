# gmod\_luasocket

Modules for Garry's Mod that add bindings for OS sockets through [luasocket][1].

## General information

This project is composed by the Lua modules (in `includes/modules`) and the internal (binary) modules (socket.core, mime.core, unix and serial, where the last two are Unix only).  
You can also refer to this project as gm\_luasocket or Luasocket for Garry's Mod.  
The Lua files go into `lua/includes/modules` (just copy includes from this repository onto `lua`) and the binary modules go into `lua/bin`.  
An optional security wrapper `luasocket_wrapper.lua` is provided, which must be placed in the same place as the binary modules to work.

## Compiling

The only supported compilation platforms for this project on Windows are **Visual Studio 2015**, **Visual Studio 2017** and **Visual Studio 2019**.  
On Linux, everything should work fine as is.  
For Mac OSX, any **Xcode version (using the GCC compiler)** *MIGHT* work as long as the **Mac OSX 10.7 SDK** is used.  
If stuff starts erroring or fails to work, be sure to check the correct line endings (\n and such) are present in the files for each OS.

## Requirements

This project requires [garrysmod\_common][1], a framework to facilitate the creation of compilations files (Visual Studio, make, XCode, etc). Simply set the environment variable '**GARRYSMOD\_COMMON**' or the premake option '**gmcommon**' to the path of your local copy of [garrysmod\_common][1].  

  [1]: https://github.com/diegonehab/luasocket
  [2]: https://github.com/danielga/garrysmod_common
