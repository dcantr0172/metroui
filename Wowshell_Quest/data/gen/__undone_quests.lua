#!/usr/bin/env lua

local mapid2mapfile = {
	[241] = "Moonglade",
	[488] = "Dragonblight",
	[492] = "IcecrownGlacier",
	[607] = "SouthernBarrens",
	[615] = "VashjirRuins",
	[32] = "DeadwindPass",
	[381] = "Darnassus",
	[34] = "Duskwood",
	[35] = "LochModan",
	[9] = "Mulgore",
	[36] = "Redridge",
	[37] = "StranglethornJungle",
	[38] = "SwampOfSorrows",
	[39] = "Westfall",
	[40] = "Wetlands",
	[41] = "Teldrassil",
	[42] = "Darkshore",
	[43] = "Ashenvale",
	[11] = "Barrens",
	[473] = "ShadowmoonValley",
	[477] = "Nagrand",
	[481] = "ShattrathCity",
	[720] = "Uldum",
	[493] = "SholazarBasin",
	[501] = "LakeWintergrasp",
	[382] = "Undercity",
	[673] = "TheCapeOfStranglethorn",
	[689] = "StranglethornVale",
	[610] = "VashjirKelpForest",
	[462] = "EversongWoods",
	[478] = "TerokkarForest",
	[61] = "ThousandNeedles",
	[486] = "BoreanTundra",
	[490] = "GrizzlyHills",
	[4] = "Durotar",
	[16] = "Arathi",
	[510] = "CrystalsongForest",
	[17] = "Badlands",
	[544] = "TheLostIsles",
	[737] = "TheMaelstrom",
	[141] = "Dustwallow",
	[640] = "Deepholm",
	[605] = "Kezan",
	[26] = "Hinterlands",
	[19] = "BlastedLands",
	[504] = "Dalaran",
	[541] = "HrothgarsLanding",
	[496] = "ZulDrak",
	[20] = "Tirisfal",
	[22] = "WesternPlaguelands",
	[161] = "Tanaris",
	[465] = "Hellfire",
	[21] = "Silverpine",
	[479] = "Netherstorm",
	[463] = "Ghostlands",
	[467] = "Zangarmarsh",
	[684] = "RuinsofGilneas",
	[475] = "BladesEdgeMountains",
	[700] = "TwilightHighlands",
	[708] = "TolBarad",
	[181] = "Aszhara",
	[491] = "HowlingFjord",
	[495] = "TheStormPeaks",
	[613] = "Vashjir",
	[24] = "HillsbradFoothills",
	[480] = "SilvermoonCity",
	[182] = "Felwood",
	[772] = "AhnQirajTheFallenKingdom",
	[362] = "ThunderBluff",
	[261] = "Silithus",
	[201] = "UngoroCrater",
	[685] = "RuinsofGilneasCity",
	[281] = "Winterspring",
	[499] = "Sunwell",
	[81] = "StonetalonMountains",
	[709] = "TolBaradDailyArea",
	[27] = "DunMorogh",
	[301] = "StormwindCity",
	[606] = "Hyjal_terrain1",
	[614] = "VashjirDepths",
	[28] = "SearingGorge",
	[23] = "EasternPlaguelands",
	[321] = "Orgrimmar",
	[471] = "TheExodar",
	[29] = "BurningSteppes",
	[101] = "Desolace",
	[464] = "AzuremystIsle",
	[341] = "Ironforge",
	[30] = "Elwynn",
	[476] = "BloodmystIsle",
	[121] = "Feralas",
}

local changeFaction
do
    local faction = ''
    function _G.UnitFactionGroup()
        return faction
    end
    function changeFaction(f)
        faction = f
    end
end

local _DATA = {
--    [mapid] = {
--        Neutral = {
--        },
--        Alliance = {
--        },
--        Horde = {
--        },
--    }
}

QuestHubber = {}
function QuestHubber:RegisterQuests(db)
    local fac = UnitFactionGroup()
    for mapid, mapdata in next, db do
        local mapFile = mapid2mapfile[mapid]
        if(not mapFile) then
            break
            --error('No mapid for ' .. mapid)
        end

        _DATA[mapFile] = _DATA[mapFile] or {}
        mf_data = _DATA[mapFile]
        mf_data[fac] = mf_data[fac] or {}
        local data = mf_data[fac]

        for id, d in next, mapdata do
            data[id] = d
        end
    end
end




local function dof(filepath, faction)
    changeFaction(faction)

    dofile(filepath)
end

local files = [[
./QuestHubber/QuestHubber_Azeroth/Data_Azeroth_Alliance.lua
./QuestHubber/QuestHubber_Azeroth/Data_Azeroth_Horde.lua
./QuestHubber/QuestHubber_Azeroth/Data_Azeroth_Neutral.lua
./QuestHubber/QuestHubber_Cataclysm/Data_Cataclysm_Alliance.lua
./QuestHubber/QuestHubber_Cataclysm/Data_Cataclysm_Horde.lua
./QuestHubber/QuestHubber_Cataclysm/Data_Cataclysm_Neutral.lua
./QuestHubber/QuestHubber_Daily/Data_Daily_Alliance.lua
./QuestHubber/QuestHubber_Daily/Data_Daily_Horde.lua
./QuestHubber/QuestHubber_Daily/Data_Daily_Neutral.lua
./QuestHubber/QuestHubber_Northrend/Data_Northrend_Alliance.lua
./QuestHubber/QuestHubber_Northrend/Data_Northrend_Horde.lua
./QuestHubber/QuestHubber_Northrend/Data_Northrend_Neutral.lua
./QuestHubber/QuestHubber_Outland/Data_Outland_Alliance.lua
./QuestHubber/QuestHubber_Outland/Data_Outland_Horde.lua
./QuestHubber/QuestHubber_Outland/Data_Outland_Neutral.lua
]]

for file in files:gmatch('([^\n]+)') do
    local fac = file:match('_(%w+)%.lua')
    --print(fac, file)

    dof(file, fac)
end

require '__value_dump'
print(dump_value(_DATA))

