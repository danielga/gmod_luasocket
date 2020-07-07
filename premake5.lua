newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

local gmcommon = assert(_OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON"),
	"you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
include(gmcommon .. "/generator.v2.lua")

local LUASOCKET_FOLDER = "luasocket/src"

CreateWorkspace({name = "socket.core"})
	CreateProject({serverside = true, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/socket.cpp")
		links("socket") -- socket needs to be linked before lua_shared
		IncludeLuaShared()

		filter("system:windows")
			links("ws2_32")

	CreateProject({serverside = false, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/socket.cpp")
		links("socket") -- socket needs to be linked before lua_shared
		IncludeLuaShared()

		filter("system:windows")
			links("ws2_32")

	project("socket")
		kind("StaticLib")
		defines("LUASOCKET_API=extern")
		includedirs({_GARRYSMOD_COMMON_DIRECTORY .. "/include", LUASOCKET_FOLDER})
		files({
			LUASOCKET_FOLDER .. "/auxiliar.c",
			LUASOCKET_FOLDER .. "/auxiliar.h",
			LUASOCKET_FOLDER .. "/buffer.c",
			LUASOCKET_FOLDER .. "/buffer.h",
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/compat.h",
			LUASOCKET_FOLDER .. "/except.c",
			LUASOCKET_FOLDER .. "/except.h",
			LUASOCKET_FOLDER .. "/filter.h",
			LUASOCKET_FOLDER .. "/inet.c",
			LUASOCKET_FOLDER .. "/inet.h",
			LUASOCKET_FOLDER .. "/io.c",
			LUASOCKET_FOLDER .. "/io.h",
			LUASOCKET_FOLDER .. "/luasocket.c",
			LUASOCKET_FOLDER .. "/luasocket.h",
			LUASOCKET_FOLDER .. "/options.c",
			LUASOCKET_FOLDER .. "/options.h",
			LUASOCKET_FOLDER .. "/pierror.h",
			LUASOCKET_FOLDER .. "/select.c",
			LUASOCKET_FOLDER .. "/select.h",
			LUASOCKET_FOLDER .. "/tcp.c",
			LUASOCKET_FOLDER .. "/tcp.h",
			LUASOCKET_FOLDER .. "/timeout.c",
			LUASOCKET_FOLDER .. "/timeout.h",
			LUASOCKET_FOLDER .. "/udp.c",
			LUASOCKET_FOLDER .. "/udp.h"
		})
		vpaths({
			["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
			["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
		})
		IncludeLuaShared()

		filter("system:windows")
			defines("_WINSOCK_DEPRECATED_NO_WARNINGS")
			files({
				LUASOCKET_FOLDER .. "/wsocket.c",
				LUASOCKET_FOLDER .. "/wsocket.h"
			})
			links("ws2_32")

		filter("system:not windows")
			files({
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h"
			})

CreateWorkspace({name = "mime.core"})
	CreateProject({serverside = true, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/mime.cpp")
		links("mime") -- mime needs to be linked before lua_shared
		IncludeLuaShared()

	CreateProject({serverside = false, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/mime.cpp")
		links("mime") -- mime needs to be linked before lua_shared
		IncludeLuaShared()

	project("mime")
		kind("StaticLib")
		defines("LUASOCKET_API=extern")
		includedirs({_GARRYSMOD_COMMON_DIRECTORY .. "/include", LUASOCKET_FOLDER})
		files({
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/compat.h",
			LUASOCKET_FOLDER .. "/mime.c",
			LUASOCKET_FOLDER .. "/mime.h"
		})
		vpaths({
			["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
			["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
		})
		IncludeLuaShared()

CreateWorkspace({name = "socket.unix"})
	CreateProject({serverside = true, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/unix.cpp")
		links("unix") -- unix needs to be linked before lua_shared
		IncludeLuaShared()

	CreateProject({serverside = false, manual_files = true})
		defines("LUASOCKET_API=extern")
		files("source/unix.cpp")
		links("unix") -- unix needs to be linked before lua_shared
		IncludeLuaShared()

	project("unix")
		kind("StaticLib")
		defines("LUASOCKET_API=extern")
		includedirs({_GARRYSMOD_COMMON_DIRECTORY .. "/include", LUASOCKET_FOLDER})
		files({
			LUASOCKET_FOLDER .. "/auxiliar.c",
			LUASOCKET_FOLDER .. "/auxiliar.h",
			LUASOCKET_FOLDER .. "/buffer.c",
			LUASOCKET_FOLDER .. "/buffer.h",
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/compat.h",
			LUASOCKET_FOLDER .. "/inet.c",
			LUASOCKET_FOLDER .. "/inet.h",
			LUASOCKET_FOLDER .. "/io.c",
			LUASOCKET_FOLDER .. "/io.h",
			LUASOCKET_FOLDER .. "/options.c",
			LUASOCKET_FOLDER .. "/options.h",
			LUASOCKET_FOLDER .. "/pierror.h",
			LUASOCKET_FOLDER .. "/timeout.c",
			LUASOCKET_FOLDER .. "/timeout.h",
			LUASOCKET_FOLDER .. "/unix.c",
			LUASOCKET_FOLDER .. "/unix.h",
			LUASOCKET_FOLDER .. "/unixdgram.c",
			LUASOCKET_FOLDER .. "/unixdgram.h",
			LUASOCKET_FOLDER .. "/unixstream.c",
			LUASOCKET_FOLDER .. "/unixstream.h"
		})
		vpaths({
			["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
			["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
		})
		IncludeLuaShared()

		filter("system:windows")
			defines("_WINSOCK_DEPRECATED_NO_WARNINGS")
			includedirs("include")
			files({
				LUASOCKET_FOLDER .. "/wsocket.c",
				LUASOCKET_FOLDER .. "/wsocket.h"
			})
			links("ws2_32")

		filter("system:not windows")
			files({
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h"
			})

if os.istarget("linux") or os.istarget("macosx") then
	CreateWorkspace({name = "socket.serial"})
		CreateProject({serverside = true, manual_files = true})
			defines("LUASOCKET_API=extern")
			files("source/serial.cpp")
			links("serial") -- serial needs to be linked before lua_shared
			IncludeLuaShared()

		CreateProject({serverside = false, manual_files = true})
			defines("LUASOCKET_API=extern")
			files("source/serial.cpp")
			links("serial") -- serial needs to be linked before lua_shared
			IncludeLuaShared()

		project("serial")
			kind("StaticLib")
			defines("LUASOCKET_API=extern")
			includedirs({_GARRYSMOD_COMMON_DIRECTORY .. "/include", LUASOCKET_FOLDER})
			files({
				LUASOCKET_FOLDER .. "/auxiliar.c",
				LUASOCKET_FOLDER .. "/auxiliar.h",
				LUASOCKET_FOLDER .. "/buffer.c",
				LUASOCKET_FOLDER .. "/buffer.h",
				LUASOCKET_FOLDER .. "/compat.c",
				LUASOCKET_FOLDER .. "/compat.h",
				LUASOCKET_FOLDER .. "/io.c",
				LUASOCKET_FOLDER .. "/io.h",
				LUASOCKET_FOLDER .. "/options.c",
				LUASOCKET_FOLDER .. "/options.h",
				LUASOCKET_FOLDER .. "/pierror.h",
				LUASOCKET_FOLDER .. "/timeout.c",
				LUASOCKET_FOLDER .. "/timeout.h",
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/usocket.h",
				LUASOCKET_FOLDER .. "/serial.c"
			})
			vpaths({
				["Source files/*"] = LUASOCKET_FOLDER .. "/*.c",
				["Header files/*"] = LUASOCKET_FOLDER .. "/*.h"
			})
			IncludeLuaShared()
end
