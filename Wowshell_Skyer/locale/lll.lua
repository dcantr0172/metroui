local localeName = "Skylark";

local files = {
	"ExtraBars.lua",
	"Option.lua",
	"wsSkyer.lua"
}

local baseLocale = "zhCN"

local locale = {
	"enUS",
	"zhTW",
}

local strings = {}
filePrefix = "../"
-- extract data from specified lua files
for idx,filename in pairs(files) do
	local file = io.open(string.format("%s%s", filePrefix or "", filename), "r")
	assert(file, "Could not open " .. filename)
	local text = file:read("*all")

	for match in string.gmatch(text, "L%[\"(.-)\"%]") do
		strings[match] = true
	end
end

local work = {}

for k,v in pairs(strings) do table.insert(work, k) end
table.sort(work)

local AceLocaleHeader = "local L ="
local BabbleFishHeader = "L = {} -- "

local function replaceHeader(content)
	return content:gsub(AceLocaleHeader, BabbleFishHeader):gsub("\\", "\\\\"):gsub("\\\"", "\\\\\"")
end

local localizedStrings = {}

table.insert(locale, baseLocale)
-- load existing data from locale files
for idx, lang in ipairs(locale) do
	local file = io.open(lang .. ".lua", "r")
	assert(file, "Could not open ".. lang .. ".lua for reading")
	local content = file:read("*all")
	content = replaceHeader(content)
	--print(content)
	assert(loadstring(content))()
	localizedStrings[lang] = L
	file:close()
end

-- Write locale files
for idx, lang in ipairs(locale) do
	local file = io.open(lang .. ".lua", "w")
	assert(file, "Could not open ".. lang .. ".lua for writing")
	file:write("-- Locale是自动生成的, 请不要乱加字符. 否则会出现字符串不存在错误.\n")
	if lang == baseLocale then
		file:write("-- 当前为基础本地化文档; 因此默认参数为\"true\" , 也可以重新定义此本地化.\n")
		file:write("--$Revision: 2398 $\n");
		file:write("--$Date: 2009-08-17 11:45:36 +0800 (一, 2009-08-17) $\n")
		file:write(string.format("local L = wsLocale:NewLocale(\"%s\", \"%s\", true)\n", localeName, lang))
		file:write("\n")
	else
		file:write("-- 请将此文件保存为UTF-8, 但是保存是请不要带有UTF-8 BOM头; ¶\n")
		file:write("--$Revision: 2398 $\n");
		file:write("--$Date: 2009-08-17 11:45:36 +0800 (一, 2009-08-17) $\n")
		file:write(string.format("local L = wsLocale:NewLocale(\"%s\", \"%s\")\n", localeName, lang))
		file:write("if not L then return end\n")
	end
	file:write("\n")
	local L = localizedStrings[lang]
	for idx, match in ipairs(work) do
		if type(L[match]) == "string" then
			file:write(string.format("L[\"%s\"] = \"%s\"\n", match, L[match]))
		else
			if lang ~= baseLocale then
				local value = type(localizedStrings[baseLocale][match]) == "string" and localizedStrings[baseLocale][match] or "true"
				file:write(string.format("--L[\"%s\"] = %s\n", match, value))
			else
				file:write(string.format("L[\"%s\"] = true\n", match))
			end
		end
	end
	file:close()
end
