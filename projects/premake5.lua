newoption({
	trigger = "gmcommon",
	description = "Sets the path to the garrysmod_common (https://bitbucket.org/danielga/garrysmod_common) directory",
	value = "path to garrysmod_common dir"
})

local gmcommon = _OPTIONS.gmcommon or os.getenv("GARRYSMOD_COMMON")
if gmcommon == nil then
	error("you didn't provide a path to your garrysmod_common (https://bitbucket.org/danielga/garrysmod_common) directory")
end

include(gmcommon)

local LUASOCKET_FOLDER = "../luasocket"

CreateSolution("socket.core")
	CreateProject(SERVERSIDE, SOURCES_MANUAL)
		AddFiles("socket.cpp")
		IncludeLuaShared()
		links("socket")

		filter("system:windows")
			links("ws2_32")

	CreateProject(CLIENTSIDE, SOURCES_MANUAL)
		AddFiles("socket.cpp")
		IncludeLuaShared()
		links("socket")

		filter("system:windows")
			links("ws2_32")

	project("socket")
		kind("StaticLib")
		warnings("Off")
		includedirs({LUASOCKET_FOLDER .. "/src"})
		files({
			LUASOCKET_FOLDER .. "/src/auxiliar.c",
			LUASOCKET_FOLDER .. "/src/buffer.c",
			LUASOCKET_FOLDER .. "/src/except.c",
			LUASOCKET_FOLDER .. "/src/inet.c",
			LUASOCKET_FOLDER .. "/src/io.c",
			LUASOCKET_FOLDER .. "/src/luasocket.c",
			LUASOCKET_FOLDER .. "/src/options.c",
			LUASOCKET_FOLDER .. "/src/select.c",
			LUASOCKET_FOLDER .. "/src/tcp.c",
			LUASOCKET_FOLDER .. "/src/timeout.c",
			LUASOCKET_FOLDER .. "/src/udp.c"
		})
		vpaths({["Source files"] = LUASOCKET_FOLDER .. "/**.c"})
		IncludeLuaShared()

		filter("system:windows")
			defines({
				"LUASOCKET_API=__declspec(dllexport)",
				"MIME_API=__declspec(dllexport)"
			})
			files({LUASOCKET_FOLDER .. "/src/wsocket.c"})
			links("ws2_32")

		filter("system:not windows")
			defines({
				"LUASOCKET_API='__attribute__((visibility(\"default\")))'",
				"UNIX_API='__attribute__((visibility(\"default\")))'",
				"MIME_API='__attribute__((visibility(\"default\")))'"
			})
			files({LUASOCKET_FOLDER .. "/src/usocket.c"})

CreateSolution("mime.core")
	CreateProject(SERVERSIDE, SOURCES_MANUAL)
		AddFiles("mime.cpp")
		IncludeLuaShared()
		links("mime")

	CreateProject(CLIENTSIDE, SOURCES_MANUAL)
		AddFiles("mime.cpp")
		IncludeLuaShared()
		links("mime")

	project("mime")
		kind("StaticLib")
		warnings("Off")
		includedirs({LUASOCKET_FOLDER .. "/src"})
		files({LUASOCKET_FOLDER .. "/src/mime.c"})
		vpaths({["Source files"] = LUASOCKET_FOLDER .. "/**.c"})
		IncludeLuaShared()

		filter("system:windows")
			defines({
				"LUASOCKET_API=__declspec(dllexport)",
				"MIME_API=__declspec(dllexport)"
			})

		filter("system:not windows")
			defines({
				"LUASOCKET_API='__attribute__((visibility(\"default\")))'",
				"UNIX_API='__attribute__((visibility(\"default\")))'",
				"MIME_API='__attribute__((visibility(\"default\")))'"
			})

if os.is("linux") or os.is("macosx") then
	CreateSolution("unix")
		CreateProject(SERVERSIDE, SOURCES_MANUAL)
			AddFiles("unix.cpp")
			IncludeLuaShared()
			links("_unix")

		CreateProject(CLIENTSIDE, SOURCES_MANUAL)
			AddFiles("unix.cpp")
			IncludeLuaShared()
			links("_unix")

		project("_unix")
			kind("StaticLib")
			warnings("Off")
			defines({
				"LUASOCKET_API='__attribute__((visibility(\"default\")))'",
				"UNIX_API='__attribute__((visibility(\"default\")))'",
				"MIME_API='__attribute__((visibility(\"default\")))'"
			})
			includedirs({LUASOCKET_FOLDER .. "/src"})
			files({
				LUASOCKET_FOLDER .. "/src/auxiliar.c",
				LUASOCKET_FOLDER .. "/src/buffer.c",
				LUASOCKET_FOLDER .. "/src/io.c",
				LUASOCKET_FOLDER .. "/src/options.c",
				LUASOCKET_FOLDER .. "/src/timeout.c",
				LUASOCKET_FOLDER .. "/src/unix.c",
				LUASOCKET_FOLDER .. "/src/usocket.c"
			})
			vpaths({["Source files"] = LUASOCKET_FOLDER .. "/**.c"})
			IncludeLuaShared()

	CreateSolution("serial")
		CreateProject(SERVERSIDE, SOURCES_MANUAL)
			AddFiles("serial.cpp")
			IncludeLuaShared()
			links("_serial")

		CreateProject(CLIENTSIDE, SOURCES_MANUAL)
			AddFiles("serial.cpp")
			IncludeLuaShared()
			links("_serial")

		project("_serial")
			kind("StaticLib")
			warnings("Off")
			defines({
				"LUASOCKET_API='__attribute__((visibility(\"default\")))'",
				"UNIX_API='__attribute__((visibility(\"default\")))'",
				"MIME_API='__attribute__((visibility(\"default\")))'"
			})
			includedirs({LUASOCKET_FOLDER .. "/src"})
			files({
				LUASOCKET_FOLDER .. "/src/auxiliar.c",
				LUASOCKET_FOLDER .. "/src/buffer.c",
				LUASOCKET_FOLDER .. "/src/io.c",
				LUASOCKET_FOLDER .. "/src/options.c",
				LUASOCKET_FOLDER .. "/src/timeout.c",
				LUASOCKET_FOLDER .. "/src/unix.c",
				LUASOCKET_FOLDER .. "/src/serial.c"
			})
			vpaths({["Source files"] = LUASOCKET_FOLDER .. "/**.c"})
			IncludeLuaShared()
end
