--[[
Name: LibBabble-Zone-3.0
Revision: $Rev: 325 $
Maintainers: ckknight, nevcairiel, Ackis
Website: http://www.wowace.com/projects/libbabble-zone-3-0/
Dependencies: None
License: MIT
]]

--local MAJOR_VERSION = "LibBabble-Zone-3.0"
--local MINOR_VERSION = 90000 + tonumber(("$Rev: 325 $"):match("%d+"))
--
--if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
--local lib = LibStub("LibBabble-3.0"):New(MAJOR_VERSION, MINOR_VERSION)
--if not lib then return end
--
--local GAME_LOCALE = GetLocale()
--
--lib:SetBaseTranslations {
--	["Abyssal Depths"] = "Abyssal Depths",
--	["Ahn'Qiraj"] = "Ahn'Qiraj",
--	["Ahn'Qiraj: The Fallen Kingdom"] = "Ahn'Qiraj: The Fallen Kingdom",
--	["Ahn'kahet: The Old Kingdom"] = "Ahn'kahet: The Old Kingdom",
--	["Alliance Base"] = "Alliance Base",
--	["Alterac Mountains"] = "Alterac Mountains",
--	["Alterac Valley"] = "Alterac Valley",
--	["Amani Pass"] = "Amani Pass",
--	["Arathi Basin"] = "Arathi Basin",
--	["Arathi Highlands"] = "Arathi Highlands",
--	Armory = "Armory",
--	Ashenvale = "Ashenvale",
--	Auberdine = "Auberdine",
--	["Auchenai Crypts"] = "Auchenai Crypts",
--	Auchindoun = "Auchindoun",
--	Azeroth = "Azeroth",
--	["Azjol-Nerub"] = "Azjol-Nerub",
--	Azshara = "Azshara",
--	["Azuremyst Isle"] = "Azuremyst Isle",
--	Badlands = "Badlands",
--	["Baradin Hold"] = "Baradin Hold",
--	["Bash'ir Landing"] = "Bash'ir Landing",
--	["Battle for Gilneas"] = "Battle for Gilneas",
--	["Black Temple"] = "Black Temple",
--	["Blackfathom Deeps"] = "Blackfathom Deeps",
--	["Blackrock Caverns"] = "Blackrock Caverns",
--	["Blackrock Depths"] = "Blackrock Depths",
--	["Blackrock Mountain"] = "Blackrock Mountain",
--	["Blackrock Spire"] = "Blackrock Spire",
--	["Blackwind Lake"] = "Blackwind Lake",
--	["Blackwing Descent"] = "Blackwing Descent",
--	["Blackwing Lair"] = "Blackwing Lair",
--	["Blade's Edge Arena"] = "Blade's Edge Arena",
--	["Blade's Edge Mountains"] = "Blade's Edge Mountains",
--	["Blasted Lands"] = "Blasted Lands",
--	["Bloodmyst Isle"] = "Bloodmyst Isle",
--	["Booty Bay"] = "Booty Bay",
--	["Borean Tundra"] = "Borean Tundra",
--	["Burning Steppes"] = "Burning Steppes",
--	Cathedral = "Cathedral",
--	["Caverns of Time"] = "Caverns of Time",
--	["Champions' Hall"] = "Champions' Hall",
--	["Coilfang Reservoir"] = "Coilfang Reservoir",
--	Coldarra = "Coldarra",
--	["Cosmic map"] = "Cosmic map",
--	["Crystal Spine"] = "Crystal Spine",
--	["Crystalsong Forest"] = "Crystalsong Forest",
--	Dalaran = "Dalaran",
--	["Dalaran Arena"] = "Dalaran Arena",
--	["Dalaran Sewers"] = "Dalaran Sewers",
--	["Darkmoon Faire"] = "Darkmoon Faire",
--	Darkshore = "Darkshore",
--	Darnassus = "Darnassus",
--	Deadmines = "Deadmines",
--	["Deadwind Pass"] = "Deadwind Pass",
--	Deepholm = "Deepholm",
--	["Deeprun Tram"] = "Deeprun Tram",
--	Desolace = "Desolace",
--	["Dire Maul"] = "Dire Maul",
--	["Dire Maul (East)"] = "Dire Maul (East)",
--	["Dire Maul (North)"] = "Dire Maul (North)",
--	["Dire Maul (West)"] = "Dire Maul (West)",
--	Dragonblight = "Dragonblight",
--	["Drak'Tharon Keep"] = "Drak'Tharon Keep",
--	["Dun Morogh"] = "Dun Morogh",
--	Durotar = "Durotar",
--	Duskwood = "Duskwood",
--	["Dustwallow Marsh"] = "Dustwallow Marsh",
--	["Eastern Kingdoms"] = "Eastern Kingdoms",
--	["Eastern Plaguelands"] = "Eastern Plaguelands",
--	["Elwynn Forest"] = "Elwynn Forest",
--	Everlook = "Everlook",
--	["Eversong Woods"] = "Eversong Woods",
--	["Eye of the Storm"] = "Eye of the Storm",
--	Felwood = "Felwood",
--	Feralas = "Feralas",
--	Firelands = "Firelands",
--	["Forge Camp: Terror"] = "Forge Camp: Terror",
--	["Forge Camp: Wrath"] = "Forge Camp: Wrath",
--	["Frostwyrm Lair"] = "Frostwyrm Lair",
--	["Furywing's Perch"] = "Furywing's Perch",
--	Gadgetzan = "Gadgetzan",
--	["Gates of Ahn'Qiraj"] = "Gates of Ahn'Qiraj",
--	Ghostlands = "Ghostlands",
--	Gilneas = "Gilneas",
--	["Gilneas City"] = "Gilneas City",
--	Gnomeregan = "Gnomeregan",
--	Graveyard = "Graveyard",
--	["Grim Batol"] = "Grim Batol",
--	["Grizzly Hills"] = "Grizzly Hills",
--	["Grom'gol Base Camp"] = "Grom'gol Base Camp",
--	["Gruul's Lair"] = "Gruul's Lair",
--	Gundrak = "Gundrak",
--	["Hall of Champions"] = "Hall of Champions",
--	["Hall of Legends"] = "Hall of Legends",
--	["Halls of Lightning"] = "Halls of Lightning",
--	["Halls of Origination"] = "Halls of Origination",
--	["Halls of Reflection"] = "Halls of Reflection",
--	["Halls of Stone"] = "Halls of Stone",
--	["Hellfire Citadel"] = "Hellfire Citadel",
--	["Hellfire Peninsula"] = "Hellfire Peninsula",
--	["Hellfire Ramparts"] = "Hellfire Ramparts",
--	["Hillsbrad Foothills"] = "Hillsbrad Foothills",
--	["Horde Encampment"] = "Horde Encampment",
--	["Howling Fjord"] = "Howling Fjord",
--	["Hrothgar's Landing"] = "Hrothgar's Landing",
--	Hyjal = "Hyjal",
--	["Hyjal Summit"] = "Hyjal Summit",
--	Icecrown = "Icecrown",
--	["Icecrown Citadel"] = "Icecrown Citadel",
--	["Insidion's Perch"] = "Insidion's Perch",
--	Ironforge = "Ironforge",
--	["Isle of Conquest"] = "Isle of Conquest",
--	["Isle of Quel'Danas"] = "Isle of Quel'Danas",
--	Kalimdor = "Kalimdor",
--	Karazhan = "Karazhan",
--	["Kelp'thar Forest"] = "Kelp'thar Forest",
--	Kezan = "Kezan",
--	["Krasus' Landing"] = "Krasus' Landing",
--	Library = "Library",
--	["Loch Modan"] = "Loch Modan",
--	["Lost City of the Tol'vir"] = "Lost City of the Tol'vir",
--	["Lower Blackrock Spire"] = "Lower Blackrock Spire",
--	["Magisters' Terrace"] = "Magisters' Terrace",
--	["Magtheridon's Lair"] = "Magtheridon's Lair",
--	["Mana-Tombs"] = "Mana-Tombs",
--	Maraudon = "Maraudon",
--	["Marshlight Lake"] = "Marshlight Lake",
--	["Menethil Harbor"] = "Menethil Harbor",
--	["Molten Core"] = "Molten Core",
--	["Molten Front"] = "Molten Front",
--	Moonglade = "Moonglade",
--	["Mount Hyjal"] = "Mount Hyjal",
--	Mulgore = "Mulgore",
--	Nagrand = "Nagrand",
--	["Nagrand Arena"] = "Nagrand Arena",
--	Naxxramas = "Naxxramas",
--	Netherstorm = "Netherstorm",
--	["Night Elf Village"] = "Night Elf Village",
--	["Northern Barrens"] = "Northern Barrens",
--	["Northern Stranglethorn"] = "Northern Stranglethorn",
--	Northrend = "Northrend",
--	["Obsidia's Perch"] = "Obsidia's Perch",
--	["Ogri'la"] = "Ogri'la",
--	["Old Hillsbrad Foothills"] = "Old Hillsbrad Foothills",
--	["Old Stratholme"] = "Old Stratholme",
--	["Onyxia's Lair"] = "Onyxia's Lair",
--	Orgrimmar = "Orgrimmar",
--	Outland = "Outland",
--	["Pit of Saron"] = "Pit of Saron",
--	["Plaguelands: The Scarlet Enclave"] = "Plaguelands: The Scarlet Enclave",
--	Plaguewood = "Plaguewood",
--	["Quel'thalas"] = "Quel'thalas",
--	["Ragefire Chasm"] = "Ragefire Chasm",
--	Ratchet = "Ratchet",
--	["Razorfen Downs"] = "Razorfen Downs",
--	["Razorfen Kraul"] = "Razorfen Kraul",
--	["Redridge Mountains"] = "Redridge Mountains",
--	["Ring of Observance"] = "Ring of Observance",
--	["Rivendark's Perch"] = "Rivendark's Perch",
--	["Ruins of Ahn'Qiraj"] = "Ruins of Ahn'Qiraj",
--	["Ruins of Gilneas"] = "Ruins of Gilneas",
--	["Ruins of Gilneas City"] = "Ruins of Gilneas City",
--	["Ruins of Lordaeron"] = "Ruins of Lordaeron",
--	["Scalebeard's Cave"] = "Scalebeard's Cave",
--	["Scarlet Monastery"] = "Scarlet Monastery",
--	Scholomance = "Scholomance",
--	["Searing Gorge"] = "Searing Gorge",
--	["Serpent Lake"] = "Serpent Lake",
--	["Serpentshrine Cavern"] = "Serpentshrine Cavern",
--	["Sethekk Halls"] = "Sethekk Halls",
--	["Shadow Labyrinth"] = "Shadow Labyrinth",
--	["Shadowfang Keep"] = "Shadowfang Keep",
--	["Shadowmoon Valley"] = "Shadowmoon Valley",
--	["Shartuul's Transporter"] = "Shartuul's Transporter",
--	Shattrath = "Shattrath",
--	["Shattrath City"] = "Shattrath City",
--	["Shimmering Expanse"] = "Shimmering Expanse",
--	["Sholazar Basin"] = "Sholazar Basin",
--	Silithus = "Silithus",
--	["Silvermoon City"] = "Silvermoon City",
--	["Silverpine Forest"] = "Silverpine Forest",
--	["Skyguard Outpost"] = "Skyguard Outpost",
--	["Skysong Lake"] = "Skysong Lake",
--	["Southern Barrens"] = "Southern Barrens",
--	["Sporewind Lake"] = "Sporewind Lake",
--	Stonard = "Stonard",
--	["Stonetalon Mountains"] = "Stonetalon Mountains",
--	Stormwind = "Stormwind",
--	["Stormwind City"] = "Stormwind City",
--	["Strand of the Ancients"] = "Strand of the Ancients",
--	["Stranglethorn Vale"] = "Stranglethorn Vale",
--	Stratholme = "Stratholme",
--	["Sunken Temple"] = "Sunken Temple",
--	["Sunwell Plateau"] = "Sunwell Plateau",
--	["Swamp of Sorrows"] = "Swamp of Sorrows",
--	Tanaris = "Tanaris",
--	Teldrassil = "Teldrassil",
--	["Tempest Keep"] = "Tempest Keep",
--	["Temple of Ahn'Qiraj"] = "Temple of Ahn'Qiraj",
--	["Terokk's Rest"] = "Terokk's Rest",
--	["Terokkar Forest"] = "Terokkar Forest",
--	["The Arachnid Quarter"] = "The Arachnid Quarter",
--	["The Arcatraz"] = "The Arcatraz",
--	["The Argent Coliseum"] = "The Argent Coliseum",
--	["The Barrens"] = "The Barrens",
--	["The Bastion of Twilight"] = "The Bastion of Twilight",
--	["The Battle for Gilneas"] = "The Battle for Gilneas",
--	["The Black Morass"] = "The Black Morass",
--	["The Blood Furnace"] = "The Blood Furnace",
--	["The Bone Wastes"] = "The Bone Wastes",
--	["The Botanica"] = "The Botanica",
--	["The Cape of Stranglethorn"] = "The Cape of Stranglethorn",
--	["The Construct Quarter"] = "The Construct Quarter",
--	["The Culling of Stratholme"] = "The Culling of Stratholme",
--	["The Dark Portal"] = "The Dark Portal",
--	["The Deadmines"] = "The Deadmines",
--	["The Descent into Madness"] = "The Descent into Madness",
--	["The Exodar"] = "The Exodar",
--	["The Eye"] = "The Eye",
--	["The Eye of Eternity"] = "The Eye of Eternity",
--	["The Forbidding Sea"] = "The Forbidding Sea",
--	["The Forge of Souls"] = "The Forge of Souls",
--	["The Frozen Halls"] = "The Frozen Halls",
--	["The Frozen Sea"] = "The Frozen Sea",
--	["The Great Sea"] = "The Great Sea",
--	["The Halls of Winter"] = "The Halls of Winter",
--	["The Hinterlands"] = "The Hinterlands",
--	["The Lost Isles"] = "The Lost Isles",
--	["The Maelstrom"] = "The Maelstrom",
--	["The Mechanar"] = "The Mechanar",
--	["The Military Quarter"] = "The Military Quarter",
--	["The Nexus"] = "The Nexus",
--	["The North Sea"] = "The North Sea",
--	["The Obsidian Sanctum"] = "The Obsidian Sanctum",
--	["The Oculus"] = "The Oculus",
--	["The Plague Quarter"] = "The Plague Quarter",
--	["The Prison of Yogg-Saron"] = "The Prison of Yogg-Saron",
--	["The Ring of Valor"] = "The Ring of Valor",
--	["The Ruby Sanctum"] = "The Ruby Sanctum",
--	["The Scarlet Enclave"] = "The Scarlet Enclave",
--	["The Shattered Halls"] = "The Shattered Halls",
--	["The Slave Pens"] = "The Slave Pens",
--	["The Spark of Imagination"] = "The Spark of Imagination",
--	["The Steamvault"] = "The Steamvault",
--	["The Stockade"] = "The Stockade",
--	["The Stonecore"] = "The Stonecore",
--	["The Storm Peaks"] = "The Storm Peaks",
--	["The Temple of Atal'Hakkar"] = "The Temple of Atal'Hakkar",
--	["The Underbog"] = "The Underbog",
--	["The Veiled Sea"] = "The Veiled Sea",
--	["The Violet Hold"] = "The Violet Hold",
--	["The Vortex Pinnacle"] = "The Vortex Pinnacle",
--	["Theramore Isle"] = "Theramore Isle",
--	["Thousand Needles"] = "Thousand Needles",
--	["Throne of the Four Winds"] = "Throne of the Four Winds",
--	["Throne of the Tides"] = "Throne of the Tides",
--	["Thunder Bluff"] = "Thunder Bluff",
--	Tirisfal = "Tirisfal",
--	["Tirisfal Glades"] = "Tirisfal Glades",
--	["Tol Barad"] = "Tol Barad",
--	["Tol Barad Peninsula"] = "Tol Barad Peninsula",
--	["Trial of the Champion"] = "Trial of the Champion",
--	["Trial of the Crusader"] = "Trial of the Crusader",
--	["Twilight Highlands"] = "Twilight Highlands",
--	["Twin Peaks"] = "Twin Peaks",
--	["Twisting Nether"] = "Twisting Nether",
--	Uldaman = "Uldaman",
--	Ulduar = "Ulduar",
--	Uldum = "Uldum",
--	["Un'Goro Crater"] = "Un'Goro Crater",
--	Undercity = "Undercity",
--	["Upper Blackrock Spire"] = "Upper Blackrock Spire",
--	["Utgarde Keep"] = "Utgarde Keep",
--	["Utgarde Pinnacle"] = "Utgarde Pinnacle",
--	["Vashj'ir"] = "Vashj'ir",
--	["Vault of Archavon"] = "Vault of Archavon",
--	["Vortex Pinnacle"] = "Vortex Pinnacle",
--	["Wailing Caverns"] = "Wailing Caverns",
--	["Warsong Gulch"] = "Warsong Gulch",
--	["Western Plaguelands"] = "Western Plaguelands",
--	Westfall = "Westfall",
--	Wetlands = "Wetlands",
--	Wintergrasp = "Wintergrasp",
--	Winterspring = "Winterspring",
--	["Wyrmrest Temple"] = "Wyrmrest Temple",
--	Zangarmarsh = "Zangarmarsh",
--	["Zul'Aman"] = "Zul'Aman",
--	["Zul'Drak"] = "Zul'Drak",
--	["Zul'Farrak"] = "Zul'Farrak",
--	["Zul'Gurub"] = "Zul'Gurub",
--}

BZ = {
	["Abyssal Depths"] = "无底海渊",
	["Ahn'Qiraj"] = "安其拉",
	["Ahn'Qiraj: The Fallen Kingdom"] = "安其拉：堕落王国",
	["Ahn'kahet: The Old Kingdom"] = "安卡赫特：古代王国",
	["Alliance Base"] = "联盟基地",
	["Alterac Mountains"] = "奥特兰克山脉",
	["Alterac Valley"] = "奥特兰克山谷",
	["Amani Pass"] = "阿曼尼小径",
	["Arathi Basin"] = "阿拉希盆地",
	["Arathi Highlands"] = "阿拉希高地",
	Armory = "军械库",
	Ashenvale = "灰谷",
	Auberdine = "奥伯丁",
	["Auchenai Crypts"] = "奥金尼地穴",
	Auchindoun = "奥金顿",
	Azeroth = "艾泽拉斯",
	["Azjol-Nerub"] = "艾卓-尼鲁布",
	Azshara = "艾萨拉",
	["Azuremyst Isle"] = "秘蓝岛",
	Badlands = "荒芜之地",
	["Baradin Hold"] = "巴拉丁监狱",
	["Bash'ir Landing"] = "巴什伊尔码头",
	["Battle for Gilneas"] = "吉尔尼斯之战",
	["Black Temple"] = "黑暗神殿",
	["Blackfathom Deeps"] = "黑暗深渊",
	["Blackrock Caverns"] = "黑石岩窟",
	["Blackrock Depths"] = "黑石深渊",
	["Blackrock Mountain"] = "黑石山",
	["Blackrock Spire"] = "黑石塔",
	["Blackwind Lake"] = "黑风湖",
	["Blackwing Descent"] = "黑翼血环",
	["Blackwing Lair"] = "黑翼之巢",
	["Blade's Edge Arena"] = "刀锋山竞技场",
	["Blade's Edge Mountains"] = "刀锋山",
	["Blasted Lands"] = "诅咒之地",
	["Bloodmyst Isle"] = "秘血岛",
	["Booty Bay"] = "藏宝海湾",
	["Borean Tundra"] = "北风苔原",
	["Burning Steppes"] = "燃烧平原",
	Cathedral = "教堂",
	["Caverns of Time"] = "时光之穴",
	["Champions' Hall"] = "勇士大厅",
	["Coilfang Reservoir"] = "盘牙水库",
	Coldarra = "考达拉",
	["Cosmic map"] = "全部地图",
	["Crystal Spine"] = "水晶之脊",
	["Crystalsong Forest"] = "晶歌森林",
	Dalaran = "达拉然",
	["Dalaran Arena"] = "达拉然竞技场",
	["Dalaran Sewers"] = "达拉然下水道",
	["Darkmoon Faire"] = "暗月马戏团",
	Darkshore = "黑海岸",
	Darnassus = "达纳苏斯",
	Deadmines = "死亡矿井",
	["Deadwind Pass"] = "逆风小径",
	Deepholm = "深岩之洲",
	["Deeprun Tram"] = "矿道地铁",
	Desolace = "凄凉之地",
	["Dire Maul"] = "厄运之槌",
	["Dire Maul (East)"] = "厄运之槌（东）",
	["Dire Maul (North)"] = "厄运之槌（北）",
	["Dire Maul (West)"] = "厄运之槌（西）",
	Dragonblight = "龙骨荒野",
	["Drak'Tharon Keep"] = "达克萨隆要塞",
	["Dun Morogh"] = "丹莫罗",
	Durotar = "杜隆塔尔",
	Duskwood = "暮色森林",
	["Dustwallow Marsh"] = "尘泥沼泽",
	["Eastern Kingdoms"] = "东部王国",
	["Eastern Plaguelands"] = "东瘟疫之地",
	["Elwynn Forest"] = "艾尔文森林",
	Everlook = "永望镇",
	["Eversong Woods"] = "永歌森林",
	["Eye of the Storm"] = "风暴之眼",
	Felwood = "费伍德森林",
	Feralas = "菲拉斯",
	Firelands = "火焰之地",
	["Forge Camp: Terror"] = "铸魔营地：恐怖",
	["Forge Camp: Wrath"] = "铸魔营地：天罚",
	["Frostwyrm Lair"] = "冰霜巨龙的巢穴",
	["Furywing's Perch"] = "弗雷文栖木",
	Gadgetzan = "加基森",
	["Gates of Ahn'Qiraj"] = "安其拉之门",
	Ghostlands = "幽魂之地",
	Gilneas = "吉尔尼斯",
	["Gilneas City"] = "吉尔尼斯城",
	Gnomeregan = "诺莫瑞根",
	Graveyard = "墓地",
	["Grim Batol"] = "格瑞姆巴托",
	["Grizzly Hills"] = "灰熊丘陵",
	["Grom'gol Base Camp"] = "格罗姆高营地",
	["Gruul's Lair"] = "格鲁尔的巢穴",
	Gundrak = "古达克",
	["Hall of Champions"] = "勇士大厅",
	["Hall of Legends"] = "传说大厅",
	["Halls of Lightning"] = "闪电大厅",
	["Halls of Origination"] = "起源大厅",
	["Halls of Reflection"] = "映像大厅",
	["Halls of Stone"] = "岩石大厅",
	["Hellfire Citadel"] = "地狱火堡垒",
	["Hellfire Peninsula"] = "地狱火半岛",
	["Hellfire Ramparts"] = "地狱火城墙",
	["Hillsbrad Foothills"] = "希尔斯布莱德丘陵",
	["Horde Encampment"] = "部落营地",
	["Howling Fjord"] = "嚎风峡湾",
	["Hrothgar's Landing"] = "洛斯加尔登陆点",
	Hyjal = "海加尔山",
	["Hyjal Summit"] = "海加尔峰",
	Icecrown = "冰冠冰川",
	["Icecrown Citadel"] = "冰冠堡垒",
	["Insidion's Perch"] = "因斯迪安栖木",
	Ironforge = "铁炉堡",
	["Isle of Conquest"] = "征服之岛",
	["Isle of Quel'Danas"] = "奎尔丹纳斯岛",
	Kalimdor = "卡利姆多",
	Karazhan = "卡拉赞",
	["Kelp'thar Forest"] = "柯尔普萨之森",
	Kezan = "科赞",
	["Krasus' Landing"] = "克拉苏斯平台",
	Library = "图书馆",
	["Loch Modan"] = "洛克莫丹",
	["Lost City of the Tol'vir"] = "托维尔失落之城",
	["Lower Blackrock Spire"] = "下层黑石塔",
	["Magisters' Terrace"] = "魔导师平台",
	["Magtheridon's Lair"] = "玛瑟里顿的巢穴",
	["Mana-Tombs"] = "法力陵墓",
	Maraudon = "玛拉顿",
	["Marshlight Lake"] = "沼光湖",
	["Menethil Harbor"] = "米奈希尔港",
	["Molten Core"] = "熔火之心",
	["Molten Front"] = "熔火前线",
	Moonglade = "月光林地",
	["Mount Hyjal"] = "海加尔",
	Mulgore = "莫高雷",
	Nagrand = "纳格兰",
	["Nagrand Arena"] = "纳格兰竞技场",
	Naxxramas = "纳克萨玛斯",
	Netherstorm = "虚空风暴",
	["Night Elf Village"] = "暗夜精灵村庄",
	["Northern Barrens"] = "北贫瘠之地",
	["Northern Stranglethorn"] = "北荆棘谷",
	Northrend = "诺森德",
	["Obsidia's Perch"] = "欧比斯迪栖木",
	["Ogri'la"] = "奥格瑞拉",
	["Old Hillsbrad Foothills"] = "旧希尔斯布莱德丘陵",
	["Old Stratholme"] = "旧斯坦索姆",
	["Onyxia's Lair"] = "奥妮克希亚的巢穴",
	Orgrimmar = "奥格瑞玛",
	Outland = "外域",
	["Pit of Saron"] = "萨隆矿坑",
	["Plaguelands: The Scarlet Enclave"] = "东瘟疫之地：血色领地",
	Plaguewood = "病木林",
	["Quel'thalas"] = "奎尔萨拉斯",
	["Ragefire Chasm"] = "怒焰裂谷",
	Ratchet = "棘齿城",
	["Razorfen Downs"] = "剃刀高地",
	["Razorfen Kraul"] = "剃刀沼泽",
	["Redridge Mountains"] = "赤脊山",
	["Ring of Observance"] = "仪式广场",
	["Rivendark's Perch"] = "雷文达克栖木",
	["Ruins of Ahn'Qiraj"] = "安其拉废墟",
	["Ruins of Gilneas"] = "吉尔尼斯废墟",
	["Ruins of Gilneas City"] = "吉尔尼斯城废墟",
	["Ruins of Lordaeron"] = "洛丹伦废墟",
	["Scalebeard's Cave"] = "鳞须海龟洞穴",
	["Scarlet Monastery"] = "血色修道院",
	Scholomance = "通灵学院",
	["Searing Gorge"] = "灼热峡谷",
	["Serpent Lake"] = "毒蛇湖",
	["Serpentshrine Cavern"] = "毒蛇神殿",
	["Sethekk Halls"] = "塞泰克大厅",
	["Shadow Labyrinth"] = "暗影迷宫",
	["Shadowfang Keep"] = "影牙城堡",
	["Shadowmoon Valley"] = "影月谷",
	["Shartuul's Transporter"] = "沙图尔的传送器",
	Shattrath = "沙塔斯",
	["Shattrath City"] = "沙塔斯城",
	["Shimmering Expanse"] = "烁光海床",
	["Sholazar Basin"] = "索拉查盆地",
	Silithus = "希利苏斯",
	["Silvermoon City"] = "银月城",
	["Silverpine Forest"] = "银松森林",
	["Skyguard Outpost"] = "天空卫队哨站",
	["Skysong Lake"] = "天歌湖",
	["Southern Barrens"] = "南贫瘠之地",
	["Sporewind Lake"] = "孢子湖",
	Stonard = "斯通纳德",
	["Stonetalon Mountains"] = "石爪山脉",
	Stormwind = "暴风城",
	["Stormwind City"] = "暴风城",
	["Strand of the Ancients"] = "远古海滩",
	["Stranglethorn Vale"] = "荆棘谷",
	Stratholme = "斯坦索姆",
	["Sunken Temple"] = "沉没的神庙",
	["Sunwell Plateau"] = "太阳之井高地",
	["Swamp of Sorrows"] = "悲伤沼泽",
	Tanaris = "塔纳利斯",
	Teldrassil = "泰达希尔",
	["Tempest Keep"] = "风暴要塞",
	["Temple of Ahn'Qiraj"] = "安其拉神殿",
	["Terokk's Rest"] = "泰罗克之墓",
	["Terokkar Forest"] = "泰罗卡森林",
	["The Arachnid Quarter"] = "蜘蛛区",
	["The Arcatraz"] = "禁魔监狱",
	["The Argent Coliseum"] = "银色试炼场",
	["The Barrens"] = "贫瘠之地",
	["The Bastion of Twilight"] = "暮光堡垒",
	["The Battle for Gilneas"] = "吉尔尼斯之战",
	["The Black Morass"] = "黑色沼泽",
	["The Blood Furnace"] = "鲜血熔炉",
	["The Bone Wastes"] = "白骨荒野",
	["The Botanica"] = "生态船",
	["The Cape of Stranglethorn"] = "荆棘谷海角",
	["The Construct Quarter"] = "构造区",
	["The Culling of Stratholme"] = "净化斯坦索姆",
	["The Dark Portal"] = "黑暗之门",
	["The Deadmines"] = "死亡矿井",
	["The Descent into Madness"] = "疯狂阶梯",
	["The Exodar"] = "埃索达",
	["The Eye"] = "风暴要塞",
	["The Eye of Eternity"] = "永恒之眼",
	["The Forbidding Sea"] = "禁忌之海",
	["The Forge of Souls"] = "灵魂洪炉",
	["The Frozen Halls"] = "冰封大殿",
	["The Frozen Sea"] = "冰冻之海",
	["The Great Sea"] = "无尽之海",
	["The Halls of Winter"] = "寒冬之厅",
	["The Hinterlands"] = "辛特兰",
	["The Lost Isles"] = "失落群岛",
	["The Maelstrom"] = "大漩涡",
	["The Mechanar"] = "能源舰",
	["The Military Quarter"] = "军事区",
	["The Nexus"] = "魔枢",
	["The North Sea"] = "北海",
	["The Obsidian Sanctum"] = "黑曜石圣殿",
	["The Oculus"] = "魔环",
	["The Plague Quarter"] = "瘟疫区",
	["The Prison of Yogg-Saron"] = "尤格-萨隆的监狱",
	["The Ring of Valor"] = "勇气竞技场",
	["The Ruby Sanctum"] = "红玉圣殿",
	["The Scarlet Enclave"] = "血色领地",
	["The Shattered Halls"] = "破碎大厅",
	["The Slave Pens"] = "奴隶围栏",
	["The Spark of Imagination"] = "思想火花",
	["The Steamvault"] = "蒸汽地窟",
	["The Stockade"] = "监狱",
	["The Stonecore"] = "巨石之核",
	["The Storm Peaks"] = "风暴峭壁",
	["The Temple of Atal'Hakkar"] = "阿塔哈卡神庙",
	["The Underbog"] = "幽暗沼泽",
	["The Veiled Sea"] = "迷雾之海",
	["The Violet Hold"] = "紫罗兰监狱",
	["The Vortex Pinnacle"] = "旋云之巅",
	["Theramore Isle"] = "塞拉摩岛",
	["Thousand Needles"] = "千针石林",
	["Throne of the Four Winds"] = "风神王座",
	["Throne of the Tides"] = "潮汐王座",
	["Thunder Bluff"] = "雷霆崖",
	Tirisfal = "提里斯法林地",
	["Tirisfal Glades"] = "提瑞斯法林地",
	["Tol Barad"] = "托尔巴拉德",
	["Tol Barad Peninsula"] = "托尔巴拉德半岛",
	["Trial of the Champion"] = "冠军的试炼",
	["Trial of the Crusader"] = "十字军的试炼",
	["Twilight Highlands"] = "暮光高地",
	["Twin Peaks"] = "双子峰",
	["Twisting Nether"] = "扭曲虚空",
	Uldaman = "奥达曼",
	Ulduar = "奥杜尔",
	Uldum = "奥丹姆",
	["Un'Goro Crater"] = "安戈洛环形山",
	Undercity = "幽暗城",
	["Upper Blackrock Spire"] = "上层黑石塔",
	["Utgarde Keep"] = "乌特加德城堡",
	["Utgarde Pinnacle"] = "乌特加德之巅",
	["Vashj'ir"] = "瓦丝琪尔",
	["Vault of Archavon"] = "阿尔卡冯的宝库",
	["Vortex Pinnacle"] = "漩涡峰",
	["Wailing Caverns"] = "哀嚎洞穴",
	["Warsong Gulch"] = "战歌峡谷",
	["Western Plaguelands"] = "西瘟疫之地",
	Westfall = "西部荒野",
	Wetlands = "湿地",
	Wintergrasp = "冬拥湖",
	Winterspring = "冬泉谷",
	["Wyrmrest Temple"] = "龙眠神殿",
	Zangarmarsh = "赞加沼泽",
	["Zul'Aman"] = "祖阿曼",
	["Zul'Drak"] = "祖达克",
	["Zul'Farrak"] = "祖尔法拉克",
	["Zul'Gurub"] = "祖尔格拉布",
}



--elseif GAME_LOCALE == "zhTW" then
--	lib:SetCurrentTranslations {
--	["Abyssal Depths"] = "地獄深淵",
--	["Ahn'Qiraj"] = "安其拉",
--	["Ahn'Qiraj: The Fallen Kingdom"] = "安其拉: 沒落的王朝",
--	["Ahn'kahet: The Old Kingdom"] = "安卡罕特:古王國",
--	["Alliance Base"] = "聯盟營地",
--	["Alterac Mountains"] = "奧特蘭克山脈",
--	["Alterac Valley"] = "奧特蘭克山谷",
--	["Amani Pass"] = "阿曼尼小俓",
--	["Arathi Basin"] = "阿拉希盆地",
--	["Arathi Highlands"] = "阿拉希高地",
--	Armory = "軍械庫",
--	Ashenvale = "梣谷",
--	Auberdine = "奧伯丁",
--	["Auchenai Crypts"] = "奧奇奈地穴",
--	Auchindoun = "奧齊頓",
--	Azeroth = "艾澤拉斯",
--	["Azjol-Nerub"] = "阿茲歐-奈幽",
--	Azshara = "艾薩拉",
--	["Azuremyst Isle"] = "藍謎島",
--	Badlands = "荒蕪之地",
--	["Baradin Hold"] = "巴拉丁堡",
--	["Bash'ir Landing"] = "貝許爾平臺",
--	["Battle for Gilneas"] = "吉爾尼斯之戰",
--	["Black Temple"] = "黑暗神廟",
--	["Blackfathom Deeps"] = "黑暗深淵",
--	["Blackrock Caverns"] = "黑石洞穴",
--	["Blackrock Depths"] = "黑石深淵",
--	["Blackrock Mountain"] = "黑石山",
--	["Blackrock Spire"] = "黑石塔",
--	["Blackwind Lake"] = "黑風湖",
--	["Blackwing Descent"] = "黑翼陷窟",
--	["Blackwing Lair"] = "黑翼之巢",
--	["Blade's Edge Arena"] = "劍刃競技場",
--	["Blade's Edge Mountains"] = "劍刃山脈",
--	["Blasted Lands"] = "詛咒之地",
--	["Bloodmyst Isle"] = "血謎島",
--	["Booty Bay"] = "藏寶海灣",
--	["Borean Tundra"] = "北風凍原",
--	["Burning Steppes"] = "燃燒平原",
--	Cathedral = "教堂",
--	["Caverns of Time"] = "時光之穴",
--	["Champions' Hall"] = "勇士大廳",
--	["Coilfang Reservoir"] = "盤牙洞穴",
--	Coldarra = "凜懼島",
--	["Cosmic map"] = "宇宙地圖",
--	["Crystal Spine"] = "水晶背脊",
--	["Crystalsong Forest"] = "水晶之歌森林",
--	Dalaran = "達拉然",
--	["Dalaran Arena"] = "達拉然競技場",
--	["Dalaran Sewers"] = "達拉然下水道",
--	["Darkmoon Faire"] = "暗月馬戲團",
--	Darkshore = "黑海岸",
--	Darnassus = "達納蘇斯",
--	Deadmines = "死亡礦坑",
--	["Deadwind Pass"] = "逆風小徑",
--	Deepholm = "地深之源",
--	["Deeprun Tram"] = "礦道地鐵",
--	Desolace = "淒涼之地",
--	["Dire Maul"] = "厄運之槌",
--	["Dire Maul (East)"] = "厄運之槌 - 東",
--	["Dire Maul (North)"] = "厄運之槌 - 北",
--	["Dire Maul (West)"] = "厄運之槌 - 西",
--	Dragonblight = "龍骨荒野",
--	["Drak'Tharon Keep"] = "德拉克薩隆要塞",
--	["Dun Morogh"] = "丹莫洛",
--	Durotar = "杜洛塔",
--	Duskwood = "暮色森林",
--	["Dustwallow Marsh"] = "塵泥沼澤",
--	["Eastern Kingdoms"] = "東部王國",
--	["Eastern Plaguelands"] = "東瘟疫之地",
--	["Elwynn Forest"] = "艾爾文森林",
--	Everlook = "永望鎮",
--	["Eversong Woods"] = "永歌森林",
--	["Eye of the Storm"] = "暴風之眼",
--	Felwood = "費伍德森林",
--	Feralas = "菲拉斯",
--	Firelands = "火源之界",
--	["Forge Camp: Terror"] = "煉冶場:驚駭",
--	["Forge Camp: Wrath"] = "煉冶場:憤怒",
--	["Frostwyrm Lair"] = "冰霜巨龍的巢穴",
--	["Furywing's Perch"] = "狂怒之翼棲所",
--	Gadgetzan = "加基森",
--	["Gates of Ahn'Qiraj"] = "安其拉之門",
--	Ghostlands = "鬼魂之地",
--	Gilneas = "吉爾尼斯",
--	["Gilneas City"] = "吉爾尼斯城",
--	Gnomeregan = "諾姆瑞根",
--	Graveyard = "墓地",
--	["Grim Batol"] = "格瑞姆巴托",
--	["Grizzly Hills"] = "灰白之丘",
--	["Grom'gol Base Camp"] = "格羅姆高營地",
--	["Gruul's Lair"] = "戈魯爾之巢",
--	Gundrak = "剛德拉克",
--	["Hall of Champions"] = "勇士大廳",
--	["Hall of Legends"] = "傳說大廳",
--	["Halls of Lightning"] = "雷光大廳",
--	["Halls of Origination"] = "起源大廳",
--	["Halls of Reflection"] = "倒影大廳",
--	["Halls of Stone"] = "石之大廳",
--	["Hellfire Citadel"] = "地獄火堡壘",
--	["Hellfire Peninsula"] = "地獄火半島",
--	["Hellfire Ramparts"] = "地獄火壁壘",
--	["Hillsbrad Foothills"] = "希爾斯布萊德丘陵",
--	["Horde Encampment"] = "部落營地",
--	["Howling Fjord"] = "凜風峽灣",
--	["Hrothgar's Landing"] = "赫魯斯加臺地",
--	Hyjal = "海加爾山",
--	["Hyjal Summit"] = "海加爾山",
--	Icecrown = "寒冰皇冠",
--	["Icecrown Citadel"] = "冰冠城塞",
--	["Insidion's Perch"] = "印希迪恩棲所",
--	Ironforge = "鐵爐堡",
--	["Isle of Conquest"] = "征服之島",
--	["Isle of Quel'Danas"] = "奎爾達納斯之島",
--	Kalimdor = "卡林多",
--	Karazhan = "卡拉贊",
--	["Kelp'thar Forest"] = "凱波薩爾森林",
--	Kezan = "凱贊",
--	["Krasus' Landing"] = "卡薩斯平臺",
--	Library = "圖書館",
--	["Loch Modan"] = "洛克莫丹",
--	["Lost City of the Tol'vir"] = "托維爾的失落之城",
--	["Lower Blackrock Spire"] = "低階黑石塔",
--	["Magisters' Terrace"] = "博學者殿堂",
--	["Magtheridon's Lair"] = "瑪瑟里頓的巢穴",
--	["Mana-Tombs"] = "法力墓地",
--	Maraudon = "瑪拉頓",
--	["Marshlight Lake"] = "沼澤光之湖",
--	["Menethil Harbor"] = "米奈希爾港",
--	["Molten Core"] = "熔火之心",
--	["Molten Front"] = "熔岩前線",
--	Moonglade = "月光林地",
--	["Mount Hyjal"] = "海加爾山",
--	Mulgore = "莫高雷",
--	Nagrand = "納葛蘭",
--	["Nagrand Arena"] = "納葛蘭競技場",
--	Naxxramas = "納克薩瑪斯",
--	Netherstorm = "虛空風暴",
--	["Night Elf Village"] = "夜精靈村",
--	["Northern Barrens"] = "北貧瘠之地",
--	["Northern Stranglethorn"] = "北荊棘谷",
--	Northrend = "北裂境",
--	["Obsidia's Perch"] = "歐比希迪亞棲所",
--	["Ogri'la"] = "歐格利拉",
--	["Old Hillsbrad Foothills"] = "希爾斯布萊德丘陵舊址",
--	["Old Stratholme"] = "舊斯坦索姆",
--	["Onyxia's Lair"] = "奧妮克希亞的巢穴",
--	Orgrimmar = "奧格瑪",
--	Outland = "外域",
--	["Pit of Saron"] = "薩倫之淵",
--	["Plaguelands: The Scarlet Enclave"] = "東瘟疫之地: 血色領區",
--	Plaguewood = "病木林",
--	["Quel'thalas"] = "奎爾薩拉斯",
--	["Ragefire Chasm"] = "怒焰裂谷",
--	Ratchet = "棘齒城",
--	["Razorfen Downs"] = "剃刀高地",
--	["Razorfen Kraul"] = "剃刀沼澤",
--	["Redridge Mountains"] = "赤脊山",
--	["Ring of Observance"] = "儀式競技場",
--	["Rivendark's Perch"] = "瑞文達科棲所",
--	["Ruins of Ahn'Qiraj"] = "安其拉廢墟",
--	["Ruins of Gilneas"] = "吉爾尼斯廢墟",
--	["Ruins of Gilneas City"] = "吉爾尼斯城廢墟",
--	["Ruins of Lordaeron"] = "羅德隆廢墟",
--	["Scalebeard's Cave"] = "鱗鬚洞穴",
--	["Scarlet Monastery"] = "血色修道院",
--	Scholomance = "通靈學院",
--	["Searing Gorge"] = "灼熱峽谷",
--	["Serpent Lake"] = "毒蛇之湖",
--	["Serpentshrine Cavern"] = "毒蛇神殿洞穴",
--	["Sethekk Halls"] = "塞司克大廳",
--	["Shadow Labyrinth"] = "暗影迷宮",
--	["Shadowfang Keep"] = "影牙城堡",
--	["Shadowmoon Valley"] = "影月谷",
--	["Shartuul's Transporter"] = "夏圖歐的傳送門",
--	Shattrath = "撒塔斯城",
--	["Shattrath City"] = "撒塔斯城",
--	["Shimmering Expanse"] = "閃光瀚洋",
--	["Sholazar Basin"] = "休拉薩盆地",
--	Silithus = "希利蘇斯",
--	["Silvermoon City"] = "銀月城",
--	["Silverpine Forest"] = "銀松森林",
--	["Skyguard Outpost"] = "禦天者崗哨",
--	["Skysong Lake"] = "天歌湖",
--	["Southern Barrens"] = "南貧瘠之地",
--	["Sporewind Lake"] = "孢子風之湖",
--	Stonard = "斯通納德",
--	["Stonetalon Mountains"] = "石爪山脈",
--	Stormwind = "暴風城",
--	["Stormwind City"] = "暴風城",
--	["Strand of the Ancients"] = "遠祖灘頭",
--	["Stranglethorn Vale"] = "荊棘谷",
--	Stratholme = "斯坦索姆",
--	["Sunken Temple"] = "沉沒的神廟",
--	["Sunwell Plateau"] = "太陽之井高地",
--	["Swamp of Sorrows"] = "悲傷沼澤",
--	Tanaris = "塔納利斯",
--	Teldrassil = "泰達希爾",
--	["Tempest Keep"] = "風暴要塞",
--	["Temple of Ahn'Qiraj"] = "安其拉神廟",
--	["Terokk's Rest"] = "泰洛克之墓",
--	["Terokkar Forest"] = "泰洛卡森林",
--	["The Arachnid Quarter"] = "蜘蛛區",
--	["The Arcatraz"] = "亞克崔茲",
--	["The Argent Coliseum"] = "銀白大競技場",
--	["The Barrens"] = "貧瘠之地",
--	["The Bastion of Twilight"] = "暮光堡壘",
--	["The Battle for Gilneas"] = "吉爾尼斯之戰",
--	["The Black Morass"] = "黑色沼澤",
--	["The Blood Furnace"] = "血熔爐",
--	["The Bone Wastes"] = "白骨荒野",
--	["The Botanica"] = "波塔尼卡",
--	["The Cape of Stranglethorn"] = "荊棘谷海角",
--	["The Construct Quarter"] = "傀儡區",
--	["The Culling of Stratholme"] = "斯坦索姆的抉擇",
--	["The Dark Portal"] = "黑暗之門",
--	["The Deadmines"] = "死亡礦坑",
--	["The Descent into Madness"] = "驟狂斜廊",
--	["The Exodar"] = "艾克索達",
--	["The Eye"] = "風暴要塞",
--	["The Eye of Eternity"] = "永恆之眼",
--	["The Forbidding Sea"] = "禁忌之海",
--	["The Forge of Souls"] = "眾魂熔爐",
--	["The Frozen Halls"] = "冰封大廳",
--	["The Frozen Sea"] = "冰凍之海",
--	["The Great Sea"] = "無盡之海",
--	["The Halls of Winter"] = "凜冬之廳",
--	["The Hinterlands"] = "辛特蘭",
--	["The Lost Isles"] = "失落群島",
--	["The Maelstrom"] = "大漩渦",
--	["The Mechanar"] = "麥克納爾",
--	["The Military Quarter"] = "軍事區",
--	["The Nexus"] = "奧核之心",
--	["The North Sea"] = "北海",
--	["The Obsidian Sanctum"] = "黑曜聖所",
--	["The Oculus"] = "奧核之眼",
--	["The Plague Quarter"] = "瘟疫區",
--	["The Prison of Yogg-Saron"] = "尤格薩倫之獄",
--	["The Ring of Valor"] = "勇武之環",
--	["The Ruby Sanctum"] = "晶紅聖所",
--	["The Scarlet Enclave"] = "血色領區",
--	["The Shattered Halls"] = "破碎大廳",
--	["The Slave Pens"] = "奴隸監獄",
--	["The Spark of Imagination"] = "創思之廳",
--	["The Steamvault"] = "蒸汽洞窟",
--	["The Stockade"] = "監獄",
--	["The Stonecore"] = "石岩之心",
--	["The Storm Peaks"] = "風暴群山",
--	["The Temple of Atal'Hakkar"] = "阿塔哈卡神廟",
--	["The Underbog"] = "深幽泥沼",
--	["The Veiled Sea"] = "迷霧之海",
--	["The Violet Hold"] = "紫羅蘭堡",
--	["The Vortex Pinnacle"] = "漩渦尖塔",
--	["Theramore Isle"] = "塞拉摩島",
--	["Thousand Needles"] = "千針石林",
--	["Throne of the Four Winds"] = "四風王座",
--	["Throne of the Tides"] = "海潮王座",
--	["Thunder Bluff"] = "雷霆崖",
--	Tirisfal = "提里斯法林地",
--	["Tirisfal Glades"] = "提里斯法林地",
--	["Tol Barad"] = "托巴拉德",
--	["Tol Barad Peninsula"] = "托巴拉德半島",
--	["Trial of the Champion"] = "勇士試煉",
--	["Trial of the Crusader"] = "十字軍試煉",
--	["Twilight Highlands"] = "暮光高地",
--	["Twin Peaks"] = "雙子峰",
--	["Twisting Nether"] = "扭曲虛空",
--	Uldaman = "奧達曼",
--	Ulduar = "奧杜亞",
--	Uldum = "奧丹姆",
--	["Un'Goro Crater"] = "安戈洛環形山",
--	Undercity = "幽暗城",
--	["Upper Blackrock Spire"] = "黑石塔上層",
--	["Utgarde Keep"] = "俄特加德要塞",
--	["Utgarde Pinnacle"] = "俄特加德之巔",
--	["Vashj'ir"] = "瓦許伊爾",
--	["Vault of Archavon"] = "亞夏梵穹殿",
--	["Vortex Pinnacle"] = "漩渦尖塔",
--	["Wailing Caverns"] = "哀嚎洞穴",
--	["Warsong Gulch"] = "戰歌峽谷",
--	["Western Plaguelands"] = "西瘟疫之地",
--	Westfall = "西部荒野",
--	Wetlands = "濕地",
--	Wintergrasp = "冬握湖",
--	Winterspring = "冬泉谷",
--	["Wyrmrest Temple"] = "龍眠神殿",
--	Zangarmarsh = "贊格沼澤",
--	["Zul'Aman"] = "祖阿曼",
--	["Zul'Drak"] = "祖爾德拉克",
--	["Zul'Farrak"] = "祖爾法拉克",
--	["Zul'Gurub"] = "祖爾格拉布",
--}
