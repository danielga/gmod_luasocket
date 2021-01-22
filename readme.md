# gmod\_luasocket

[![Build Status](https://metamann.visualstudio.com/GitHub%20danielga/_apis/build/status/danielga.gmod_luasocket?branchName=refs%2Ftags%2Fr1)](https://metamann.visualstudio.com/GitHub%20danielga/_build/latest?definitionId=15&branchName=refs%2Ftags%2Fr1)

Modules for Garry's Mod that add bindings for OS sockets through [luasocket][1].

## General information

This project is composed by the Lua modules (in `includes/modules`) and the internal binary modules (`socket.core`, `mime.core`, `unix` and `serial`, where the last two are Unix only).

You can also refer to this project as `gm\_luasocket` or `Luasocket for Garry's Mod`.

The Lua files go into `lua/includes/modules` (just copy the `includes` directory from this repository onto `lua`) and the binary modules go into `lua/bin`.

An optional security wrapper `luasocket_wrapper.lua` is provided, which must be placed in the same place as the binary modules to work.

## Compiling

The only supported compilation platform for this project on Windows is **Visual Studio 2017**. However, it's possible it'll work with *Visual Studio 2015* and *Visual Studio 2019* because of the unified runtime.

On Linux, everything should work fine as is.

For macOS, any **Xcode (using the GCC compiler)** version *MIGHT* work as long as the **Mac OSX 10.7 SDK** is used.

If stuff starts erroring or fails to work, be sure to check the correct line endings (`\n` and such) are present in the files for each OS.

## Requirements

This project requires [garrysmod\_common][2], a framework to facilitate the creation of compilations files (Visual Studio, make, XCode, etc). Simply set the environment variable '**GARRYSMOD\_COMMON**' or the premake option '**gmcommon**' to the path of your local copy of [garrysmod\_common][2].

  [1]: https://github.com/diegonehab/luasocket
  [2]: https://github.com/danielga/garrysmod_common
