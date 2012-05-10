local tags = {
	[ELITE] = "+",
	[GROUP] = "g",
	[LFG_TYPE_DUNGEON] = "d",
	[RAID] = "r",
	[PVP_ENABLED] = "p",
	[DUNGEON_DIFFICULTY2]="d+",
	[DAILY] = "\226\128\162"
}
-- temp patch for foreignese font problem with the circle for dailies
if GetLocale() == "zhTW" or GetLocale() == "zhCN" or GetLocale() == "koKR" then
	tags[DAILY] = "o"
end

local function rgb2hex( r, g, b )
	if type(r) == "table" then
		g = r.g
		b = r.b
		r = r.r
	end
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

local function GetTaggedTitle(i)
	local name, level, tag, group, header, collapsed, complete, daily, questid = GetQuestLogTitle(i)
	if header or not name then return end
	if not group or group == 0 then group = nil end
	return string.format("|cff%s[%s%s%s%s] %s|r", rgb2hex(GetQuestDifficultyColor(level)), level, tag and tags[tag] or "", daily and tags[DAILY] or "", group or "", name), level, tag, group, header, collapsed, complete, daily, questid
end

local env = setmetatable({
    GetQuestLogTitle = function( id )
        return GetTaggedTitle(id)
    end,
--    GetQuestLogLeaderBoard = function( j, index )
--        local text = GetQuestLogLeaderBoard(j, index)
--        if progress[text] then
--          text = string.format("|cff%s%s|r", rgb2hex( ColorGradient( progress[text].perc, 1,0,0, 1,1,0, 0,1,0) ), text )
--        end
--        return text
--    end,
}, {__index = _G})

setfenv(WatchFrame_DisplayTrackedQuests, env)

