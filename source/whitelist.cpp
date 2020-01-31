#undef getaddrinfo

#include "socket.h"
#include <vector>
#include <map>
#include <fstream>
#include <sstream>
#include <regex>

//Somewhere glua can't read?
const char* whitelistDir = "../gm_socket_whitelist.txt";
std::map<std::string, std::vector<std::regex> > whitelist;

enum : int
{
	PARSE_SUCCESS = 0,
	PARSE_CANT_READ = 1,
	PARSE_NO_ENTRIES = 2
};

int parseWhitelist()
{
	std::ifstream input(whitelistDir);
	if (input)
	{
		std::stringstream filereader;
		filereader << input.rdbuf();
		std::string filedata = filereader.str();
		std::regex line_parser("(?:(?!\r?\n).)+");
		std::regex entry_parser("^[ \\t]*([\\w\\.\\*-]+)\\:(\\d+)[ \\t]*$");
		std::regex wildcard("\\*");
		std::regex dot("\\.");
		for (std::sregex_iterator line = std::sregex_iterator(filedata.begin(), filedata.end(), line_parser), end = std::sregex_iterator(); line != end; ++line)
		{
			const std::string& linestr = line->operator[](0);
			std::smatch match;
			if(std::regex_match(linestr, match, entry_parser))
			{
				std::string domain = match[1];
				domain = std::regex_replace(domain, wildcard, "[\\w-]+");
				domain = std::regex_replace(domain, dot, "\\.");
				whitelist[match[2].str()].push_back(std::regex(domain));
			}
		}
		if (whitelist.empty())
		{
			return PARSE_NO_ENTRIES;
		}
	}
	else
	{
		return PARSE_CANT_READ;
	}
	return PARSE_SUCCESS;
}

void clearWhitelist()
{
	whitelist.clear();
}

bool isSafe(const std::string& pNodeName, const std::string& pServiceName)
{
	std::map<std::string, std::vector<std::regex> >::iterator domains = whitelist.find(pServiceName);
	if (domains != whitelist.end())
	{
		for (auto i = domains->second.begin(), end = domains->second.end(); i != end; ++i)
		{
			if (std::regex_match(pNodeName, *i))
			{
				return true;
			}
		}
		return false;
	}
	else
	{
		return false;
	}
}

extern "C" {

#ifdef _WIN32
	INT WSAAPI __wrap_getaddrinfo(
		_In_opt_        PCSTR               pNodeName,
		_In_opt_        PCSTR               pServiceName,
		_In_opt_        const ADDRINFOA *   pHints,
		_Outptr_result_maybenull_        PADDRINFOA *        ppResult
	)
#else
	int __wrap_getaddrinfo (__const char *__restrict pNodeName,
		__const char *__restrict pServiceName,
		__const struct addrinfo *__restrict pHints,
		struct addrinfo **__restrict ppResult)
#endif
	{
		if(isSafe(pNodeName, pServiceName))
		{
			return getaddrinfo(pNodeName, pServiceName, pHints, ppResult);
		}
		else
		{
			*ppResult = nullptr;
			return EAI_FAIL;
		}
	}

}
