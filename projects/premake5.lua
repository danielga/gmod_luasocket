newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://github.com/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common directory"
})

newoption({
	trigger = "whitelist",
	description = "Enables wrapping of getaddrinfo and a whitelist file to filter valid addresses and ports",
	value = "0 or 1"
})

local gmcommon = _OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON")
local whitelist = _OPTIONS.whitelist == "1"
if gmcommon == nil then
	error("you didn't provide a path to your garrysmod_common (https://github.com/danielga/garrysmod_common) directory")
end

include(gmcommon)

local LUASOCKET_FOLDER = "../luasocket/src"

CreateWorkspace({name = "socket.core"})
	CreateProject({serverside = true, manual_files = true})
		files("../source/socket.cpp")
		if whitelist then files("../source/whitelist.cpp") defines({"USE_WHITELIST"}) includedirs(LUASOCKET_FOLDER) end
		IncludeLuaShared()
		links("socket")

		filter("system:windows")
			links("ws2_32")

	CreateProject({serverside = false, manual_files = true})
		files("../source/socket.cpp")
		if whitelist then files("../source/whitelist.cpp") defines({"USE_WHITELIST"}) includedirs(LUASOCKET_FOLDER) end
		IncludeLuaShared()
		links("socket")

		filter("system:windows")
			links("ws2_32")

	project("socket")
		kind("StaticLib")
		warnings("Off")
		includedirs(LUASOCKET_FOLDER)
		files({
			LUASOCKET_FOLDER .. "/auxiliar.c",
			LUASOCKET_FOLDER .. "/buffer.c",
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/except.c",
			LUASOCKET_FOLDER .. "/inet.c",
			LUASOCKET_FOLDER .. "/io.c",
			LUASOCKET_FOLDER .. "/luasocket.c",
			LUASOCKET_FOLDER .. "/options.c",
			LUASOCKET_FOLDER .. "/select.c",
			LUASOCKET_FOLDER .. "/tcp.c",
			LUASOCKET_FOLDER .. "/timeout.c",
			LUASOCKET_FOLDER .. "/udp.c"
		})
		vpaths({["Source files/*"] = LUASOCKET_FOLDER .. "/*.c"})
		IncludeLuaShared()

		filter("system:windows")
			defines({
				"LUASOCKET_API=__declspec(dllexport)",
				"MIME_API=__declspec(dllexport)"
			})
			if whitelist then defines({"getaddrinfo=__wrap_getaddrinfo"}) end
			files(LUASOCKET_FOLDER .. "/wsocket.c")
			links("ws2_32")

		filter("system:not windows")
			defines({
				"LUASOCKET_API=''",
				"UNIX_API=''",
				"MIME_API=''"
			})
			if whitelist then defines({"getaddrinfo=__wrap_getaddrinfo"}) end
			files(LUASOCKET_FOLDER .. "/usocket.c")

CreateWorkspace({name = "mime.core"})
	CreateProject({serverside = true, manual_files = true})
		files("../source/mime.cpp")
		IncludeLuaShared()
		links("mime")

	CreateProject({serverside = false, manual_files = true})
		files("../source/mime.cpp")
		IncludeLuaShared()
		links("mime")

	project("mime")
		kind("StaticLib")
		warnings("Off")
		includedirs(LUASOCKET_FOLDER)
		files({
			LUASOCKET_FOLDER .. "/compat.c",
			LUASOCKET_FOLDER .. "/mime.c"
		})
		vpaths({["Source files/*"] = LUASOCKET_FOLDER .. "/*.c"})
		IncludeLuaShared()

		filter("system:windows")
			defines({
				"LUASOCKET_API=__declspec(dllexport)",
				"MIME_API=__declspec(dllexport)"
			})

		filter("system:not windows")
			defines({
				"LUASOCKET_API=''",
				"UNIX_API=''",
				"MIME_API=''"
			})

if os.is("linux") or os.is("macosx") then
	CreateWorkspace({name = "socket.unix"})
		CreateProject({serverside = true, manual_files = true})
			files("../source/unix.cpp")
			IncludeLuaShared()
			links("unix")

		CreateProject({serverside = false, manual_files = true})
			files("../source/unix.cpp")
			IncludeLuaShared()
			links("unix")

		project("unix")
			kind("StaticLib")
			warnings("Off")
			defines({
				"LUASOCKET_API=''",
				"UNIX_API=''",
				"MIME_API=''"
			})
			includedirs(LUASOCKET_FOLDER)
			files({
				LUASOCKET_FOLDER .. "/auxiliar.c",
				LUASOCKET_FOLDER .. "/buffer.c",
				LUASOCKET_FOLDER .. "/compat.c",
				LUASOCKET_FOLDER .. "/io.c",
				LUASOCKET_FOLDER .. "/options.c",
				LUASOCKET_FOLDER .. "/timeout.c",
				LUASOCKET_FOLDER .. "/unix.c",
				LUASOCKET_FOLDER .. "/usocket.c"
			})
			vpaths({["Source files/*"] = LUASOCKET_FOLDER .. "/*.c"})
			IncludeLuaShared()

	CreateWorkspace({name = "socket.serial"})
		CreateProject({serverside = true, manual_files = true})
			files("../source/serial.cpp")
			IncludeLuaShared()
			links("serial")

		CreateProject({serverside = false, manual_files = true})
			files("../source/serial.cpp")
			IncludeLuaShared()
			links("serial")

		project("serial")
			kind("StaticLib")
			warnings("Off")
			defines({
				"LUASOCKET_API=''",
				"UNIX_API=''",
				"MIME_API=''"
			})
			includedirs(LUASOCKET_FOLDER .. "/src")
			files({
				LUASOCKET_FOLDER .. "/auxiliar.c",
				LUASOCKET_FOLDER .. "/buffer.c",
				LUASOCKET_FOLDER .. "/compat.c",
				LUASOCKET_FOLDER .. "/io.c",
				LUASOCKET_FOLDER .. "/options.c",
				LUASOCKET_FOLDER .. "/timeout.c",
				LUASOCKET_FOLDER .. "/usocket.c",
				LUASOCKET_FOLDER .. "/serial.c"
			})
			vpaths({["Source files/*"] = LUASOCKET_FOLDER .. "/*.c"})
			IncludeLuaShared()
end
