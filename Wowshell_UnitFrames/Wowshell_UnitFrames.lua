--[[
-- Wowshell_UnitFrames
-- Author: Wowshell Develop Team
-- Version: 4.2.2
--]]
WSUF = select(2, ...);
WSUF = LibStub("AceAddon-3.0"):NewAddon(WSUF, "AceEvent-3.0", "AceConsole-3.0");
local L = wsLocale:GetLocale("wsUnitFrame");
local ns = WSUF;
local oUF = ns.oUF;
WSUF.L = L;
ns.playerUnit = "player"
ns.dbReversion = 4;
ns.modules = {};
ns.moduleOrder = {};
ns.styles = {};
ns.enabledUnits = {};

local debugf = tekDebug and tekDebug:GetFrame("WSUF")
function ns.Debug(...) if debugf then debugf:AddMessage(string.join(", ", ...)) end end

ns.unitList = {"player", "pet", "pettarget", "target", "targettarget", "targettargettarget", "focus", "focustarget", "party", "partypet", "partytarget", "boss", "bosstarget","arena", "arenatarget", "arenapet"}
ns.fakeUnits = {["targettarget"] = true, ["targettargettarget"] = true, ["pettarget"] = true, ["arenatarget"] = true, ["focustarget"] = true, ["focustargettarget"] = true, ["partytarget"] = true, ["raidtarget"] = true, ["bosstarget"] = true, ["maintanktarget"] = true, ["mainassisttarget"] = true}
L.units = {["raidpet"] = L["Raid pet"], ["PET"] = L["Pet"], ["VEHICLE"] = L["Vehicle"], ["arena"] = L["Arena"], ["arenapet"] = L["Arena Pet"], ["arenatarget"] = L["Arena Target"], ["boss"] = L["Boss"], ["bosstarget"] = L["Boss Target"], ["focus"] = L["Focus"], ["focustarget"] = L["Focus Target"], ["focustargettarget"] = L["Target of Target of Focus"],  ["mainassist"] = L["Main Assist"], ["mainassisttarget"] = L["Main Assist Target"], ["maintank"] = L["Main Tank"], ["maintanktarget"] = L["Main Tank Target"], ["party"] = L["Party"], ["partypet"] = L["Party Pet"], ["partytarget"] = L["Party Target"], ["pet"] = L["Pet"], ["pettarget"] = L["Pet Target"], ["player"] = L["Player"],["raid"] = L["Raid"], ["target"] = L["Target"], ["targettarget"] = L["Target of Target"], ["targettargettarget"] = L["Target of Target of Target"]}
ns.partyUnits, ns.raidUnits, ns.raidPetUnits, ns.bossUnits, ns.arenaUnits = {}, {}, {}, {}, {}
for i=1, MAX_PARTY_MEMBERS do ns.partyUnits[i] = "party" .. i end
for i=1, MAX_RAID_MEMBERS do ns.raidUnits[i] = "raid" .. i end
for i=1, MAX_RAID_MEMBERS do ns.raidPetUnits[i] = "raidpet" .. i end
for i=1, MAX_BOSS_FRAMES do ns.bossUnits[i] = "boss" .. i end
for i=1, 5 do ns.arenaUnits[i] = "arena" .. i end

local tinsert = table.insert


function ns:OnInitialize()
	--注册全局控制函数
	self.defaults = {
		profile = {
			locked = true,
			advanced = false,
			currentStyle = "Shell",
			tooltipCombat = false,
			tags = {},
			classColors = {
				HUNTER = {r = 0.67, g = 0.83, b = 0.45},
				WARLOCK = {r = 0.58, g = 0.51, b = 0.79},
				PRIEST = {r = 1.0, g = 1.0, b = 1.0},
				PALADIN = {r = 0.96, g = 0.55, b = 0.73},
				MAGE = {r = 0.41, g = 0.8, b = 0.94},
				ROGUE = {r = 1.0, g = 0.96, b = 0.41},
				DRUID = {r = 1.0, g = 0.49, b = 0.04},
				SHAMAN = {r = 0.14, g = 0.35, b = 1.0},
				WARRIOR = {r = 0.78, g = 0.61, b = 0.43},
				DEATHKNIGHT = {r = 0.77, g = 0.12 , b = 0.23},
				PET = {r = 0.20, g = 0.90, b = 0.20},
				VEHICLE = {r = 0.23, g = 0.41, b = 0.23},
			},
			powerColors = {
				MANA = {r = 0.30, g = 0.50, b = 0.85}, 
				RAGE = {r = 0.90, g = 0.20, b = 0.30},
				FOCUS = {r = 1.0, g = 0.50, b = 0.25},
				ENERGY = {r = 1.0, g = 0.85, b = 0.10}, 
				RUNES = {r = 0.50, g = 0.50, b = 0.50}, 
				RUNIC_POWER = {b = 0.60, g = 0.45, r = 0.35},
				ECLIPSE_SUN = {r = 1.0, g = 1.0, b = 0.0},
				ECLIPSE_MOON = {r = 0.30, g = 0.52, b = 0.90},
				AMMOSLOT = {r = 0.85, g = 0.60, b = 0.55},
				FUEL = {r = 0.85, g = 0.47, b = 0.36},
				COMBOPOINTS = {r = 1.0, g = 0.80, b = 0.0},
				HOLYPOWER = {r = 0.96, g = 0.55, b = 0.73},
				SOULSHARDS = {r = 0.58, g = 0.51, b = 0.79},
				ALTERNATE = {r = 0.71, g = 0.0, b = 1.0},
			},
			healthColors = {
				tapped = {r = 0.5, g = 0.5, b = 0.5},
				red = {r = 0.90, g = 0.0, b = 0.0},
				green = {r = 0.20, g = 0.90, b = 0.20},
				static = {r = 0.70, g = 0.20, b = 0.90},
				yellow = {r = 0.93, g = 0.93, b = 0.0},
				inc = {r = 0, g = 0.35, b = 0.23},
				enemyUnattack = {r = 0.60, g = 0.20, b = 0.20},
				hostile = {r = 0.90, g = 0.0, b = 0.0},
				friendly = {r = 0.20, g = 0.90, b = 0.20},
				neutral = {r = 0.93, g = 0.93, b = 0.0},
				offline = {r = 0.50, g = 0.50, b = 0.50}
			},
			castColors = {
				channel = {r = 0.25, g = 0.25, b = 1.0},
				cast = {r = 1.0, g = 0.70, b = 0.30},
				interrupted = {r = 1, g = 0, b = 0},
				uninterruptible = {r = 0.71, g = 0, b = 1},
				finished = {r = 0.10, g = 1.0, b = 0.10},
			},
			xpColors = {
				normal = {r = 0.58, g = 0.0, b = 0.55},
				rested = {r = 0.0, g = 0.39, b = 0.88},
			}
		}
	}
	self.db = LibStub("AceDB-3.0"):New("WSUFDB", self.defaults, true);
	--self.db.RegisterCallback(self, "OnProfileChanged", "ProfilesChanged");
	--self.db.RegisterCallback(self, "OnProfileCopied", "ProfilesChanged");
	--self.db.RegisterCallback(self, "OnProfileReset", "ProfilesReset");

	self.tagFunc = setmetatable({}, {
		__index = function(tbl, index)
			if (not ns.Tags.defaultTags[index]) then
				tbl[index] = false;
				return false;
			end

			local func, msg = loadstring("return " .. (ns.Tags.defaultTags[index] or self.db.profile[self.db.profile.currentStyle].tags[index].func or ""));

			if (func) then
				func = func();
			elseif (msg) then
				error(msg, 3)
			end

			tbl[index] = func;
			return tbl[index];
		end
	});

	--disable old addon
	DisableAddOn("Wowshell_UnitFrame");
	DisableAddOn("Wowshell_UFShell");
	DisableAddOn("Wowshell_UFBlizzard");
end

function ns:OnEnable()
	self:LoadCurrentMode();
	self:FireModuleEvent("OnInitialize");

	self:FireStyleEvent("OnInitialize");
	self:SetupOptions();

	self.modules.movers:Update()
	self:CheckUpgrade();
end

function ns:CheckUpgrade()
	local revision = self.db.profile.revision or 1;
	if (revision < 4) then
		self.db:ResetDB("defaults");
		print("魔兽精灵头像配置已重置!");
	end
	--upgrade
	self.db.profile.revision = self.dbReversion;
end

--register a new style
--[[
	module: StyleObj.
	key: style key. Exp: Blizzard
	name: style name. Exp:暴雪风格
	defaults: [table] style default profiles.
	local addonName, ns = ...
	ns = WSUF:RegisterStyle(ns, "Blizzard", "暴雪风格", {
		profile = {
			units = {},
			positions = {}
		}
	});

function ns:OnInitialize()
	--do some thing
end
--]]
function ns:RegisterStyle(module, key, name, defaults)
	local module = setmetatable(module, {__index = ns.Module});
	self.styles[key] = module;
	module.moduleKey = key;
	module.moduleName = name;
	module.parent = ns;
	module.db = self.db:RegisterNamespace(key, defaults);
	module.exec = ns.exec;

	return module;
end

function ns:FireStyleEvent(event)
	for _, module in pairs(self.styles) do
		if (module[event]) then
			module[event](module);
		end
	end
end

function ns:GetStyleDB(key)
	return (self.db:GetNamespace(key, true)).profile
end

function ns:GetCurrentStyleDB()
	return ns:GetStyleDB(self.db.profile.currentStyle);
end

function ns:LoadCurrentMode()
	local currentStyle = self.db.profile.currentStyle;
	local addonName = "Wowshell_UF" .. currentStyle;
	local _, _, _, enabled, loadable = GetAddOnInfo(addonName);
	if (not enabled) then
		EnableAddOn(addonName);
		self:LoadCurrentMode();
	end

	if (loadable and IsAddOnLoadOnDemand(addonName)) then
		LoadAddOn(addonName);
	end
end

--新增module函数, 更加便于管理
--[[
	module: Module Object
	key: key
	name: name
--]]
function ns:RegisterModule(module, key, name)
	self.modules[key] = module;
	
	module.moduleKey = key;
	module.moduleName = name;

	tinsert(self.moduleOrder, module);

	return module;
end

function ns:FireModuleEvent(event, frame, unit)
	for _, module in pairs(self.moduleOrder) do
		if (module[event]) then
			module[event](module, frame, unit);		
		end
	end
end

ns.noop = function() end

do
    --[[
    --      xpcall safecall implementation from Ace3
    --]]
    local geterrorhandler = geterrorhandler
    local setmetatable = setmetatable
    local next, xpcall = next, xpcall
    local rawset, assert, loadstring = rawset, assert, loadstring
    local tconcat = table.concat

    local function errorhandler(err)
        return geterrorhandler()(err)
    end

    local CreateDispatcher = function(argCount)
        local code = [[
            local xpcall, eh = ...
            local method, ARGS
            local function call() return method(ARGS) end

            local function dispatch(func, ...)
                 method = func
                 if not method then return end
                 ARGS = ...
                 return xpcall(call, eh)
            end

            return dispatch
        ]]

        local ARGS = {}
        for i = 1, argCount do ARGS[i] = "arg"..i end
        code = code:gsub("ARGS", tconcat(ARGS, ", "))
        return assert(loadstring(code, "safecall Dispatcher["..argCount.."]"))(xpcall, errorhandler)
    end

    local Dispatchers = setmetatable({}, {__index=function(self, argCount)
        local dispatcher = CreateDispatcher(argCount)
        rawset(self, argCount, dispatcher)
        return dispatcher
    end})
    Dispatchers[0] = function(func)
        return xpcall(func, errorhandler)
    end

    ns.exec = function( func, ... )
        return Dispatchers[select("#", ...)](func, ...)
    end
end

----------------------------------------------------------------------
--Options
----------------------------------------------------------------------
do
    local count = 0
    ns.order = function()
        count = count + 1
        return count
    end
end

local layoutCord = "";


local options = {
    type = 'group',
    name = L['Wowshell unit frame'],
    desc = L['Options for wowshell unit frame.'],
    args = {
				switch = {
					order = ns.order(),
					type = "select",
					style = "dropdown",
					name = L["风格: "],
					desc = L["点击切换头像风格. 如果显示不正常, 请重载界面"],
					values = {
						Blizzard = L["暴雪风格"],
						Shell = L["现代风格"]
					},
					get = function()
						return ns.db.profile.currentStyle
					end,
					set = function(_, v)
						ns.db.profile.currentStyle = v;
						StaticPopup_Show'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
					end
				},
        general = {
            name = L['General'],
            type = 'group',
            order = ns.order(),
	    				childGroups = "tab",
            args = {
	    				--	general = {
	    				--		type = "group",
	    				--		order = ns.order(),
	    				--		name = L['General'],
	    				--		args = {
	    				--			lock = {
	    				--				type = 'toggle',
	    				--				order = ns.order(),
	    				--				name = L['Lock position'],
	    				--				desc = L['Lock all frames'],
	    				--				get = function() return ns.db.profile.locked end,
	    				--				set = function()
	    				--					ns.db.profile.locked = not ns.db.profile.locked;
	    				--					ns.modules.movers:Update();
	    				--				end,
	    				--			},
	    				--		},
	    				--	},
	    				--	shared = {
	    				--		name = L["Shared"],
	    				--		type = "group",
	    				--		order = ns.order(),
	    				--		args = {
	    				--			layoutInput = {
	    				--				type="input",
	    				--				name=L["Layout Code"],
	    				--				desc=L["Code of your layout."],
	    				--				get=function() return layoutCord end,
	    				--				set=function(info, value) layoutCord = value end,
	    				--				multiline=true,
	    				--				width="full",
	    				--				order=5,
	    				--			},
	    				--			layoutExport = {
	    				--				type="execute",
	    				--				name=L["Export layout"],
	    				--				desc=L["Export your layout code."],
	    				--				func=function()
	    				--					local profile = ns:GetCurrentStyleDB();
	    				--					local t = CopyTable(profile);
	    				--					layoutCord = LibStub("AceSerializer-3.0"):Serialize(t);
	    				--				end,
	    				--				order=15,
	    				--			},
	    				--		},
	    				--	},
            },
        },
				units = {
					name = L["Units"],
					type = "group",
					order = ns.order(),
					args = {},
				},
				help = {
					name = L["Help"],
					type = "group",
					childGroups = "tab",
					order = ns.order(),
					args = {
						tags = {
							type = "group",
							name = L["tags"],
							order = ns.order(),
							args = {
						descs = {
							type = "description",
							name = L["Tags Custom Code"],
							order = ns.order(),
							fontSize = "large",
							width = "full",
						},
						notes = {
							type = "description",
							name = L["Tags notes"],
							order = ns.order(),
							fontSize = "small",
							width = "full",
						},
						healthTagsClass = {
							type = "description",
							name = L["HealthTag"],
							order = ns.order(),
							fontSize = "medium",
							width = "full",
						},
						abscurhp = {
							type = "description",
							order = ns.order(),
							name = L["abscurhp"],
						},
						absmaxhp = {
							type = "description",
							order = ns.order(),
							name = L["absmaxhp"],
						},
						absolutehp = {
							type = "description",
							order = ns.order(),
							name = L["absolutehp"],
						},
						curhp = {
							type = "description",
							order = ns.order(),
							name = L["curhp"],
						},
						curmaxhp = {
							type = "description",
							order = ns.order(),
							name = L["curmaxhp"],
						},
						maxhp = {
							type = "description",
							order = ns.order(),
							name = L["maxhp"],
						},
						perhp = {
							type = "description",
							order = ns.order(),
							name = L["perhp"],
						},
						smartcurmaxhp = {
							type = "description",
							order = ns.order(),
							name = L["smart:curmaxhp"],
						},
						missinghp = {
							type = "description",
							order = ns.order(),
							name = L["missinghp"],
						},
						powerTagsClass = {
							type = "description",
							order = ns.order(),
							name = L["PowerTag"],
							fontSize = "medium",
						},
						abscurpp = {
							type = "description",
							order = ns.order(),
							name = L["abscurpp"],
						},
						absmaxpp = {
							type = "description",
							order = ns.order(),
							name = L["absmaxpp"],
						},
						absolutepp = {
							type = "description",
							order = ns.order(),
							name = L["absolutepp"],
						},
						curmaxpp = {
							type = "description",
							order = ns.order(),
							name = L["curmaxpp"],
						},
						curpp = {
							type = "description",
							order = ns.order(),
							name = L["curpp"],
						},
						maxpp = {
							type = "description",
							order = ns.order(),
							name = L["maxpp"],
						},
						perpp = {
							type = "description",
							order = ns.order(),
							name = L["perpp"],
						},
						smartcurmaxpp = {
							type = "description",
							order = ns.order(),
							name = L["smart:curmaxpp"],
						},
						nameTagsClass = {
							type = "description",
							order = ns.order(),
							name = L["NameTag"],
							fontSize = "medium",
						},
						nameTag = {
							type = "description",
							order = ns.order(),
							name = L["name"],
						},
						colorname = {
							type = "description",
							order = ns.order(),
							name = L["colorname"],
						},
						defname = {
							type = "description",
							order = ns.order(),
							name = L["defname"],
						},
						levelTagsClass = {
							type = "description",
							order = ns.order(),
							name = L["LevelTag"], 
							fontSize = "medium",
						},
						levelTag = {
							type = "description",
							order = ns.order(),
							name = L["level"],
						},
						levelcolor = {
							type = "description",
							order = ns.order(),
							name = L["levelcolor"],
						},
						smartlevel = {
							type = "description",
							order = ns.order(),
							name = L["smartlevel"],
						},
					},
				},
				keybind = {
					type = "group",
					name = L["keybind"],
					order = ns.order(),
					args = {
						descs = {
							type = "description",
							name = L["keybind command"],
							order = ns.order(),
							fontSize = "large",
							width = "full",
						},
						doubleClick = {
							type = "description",
							order = ns.order(),
							name = L["Double click to lock/unlock the unit frame"], 
							fontSize = "medium",
						},
						rightCtrlClick = {
							type = "description",
							order = ns.order(),
							name = L["Press RightCtrl key down will create target's armory or db strings"],
							fontSize = "medium",
						},
						rightAltClick = {
							type = "description",
							order = ns.order(),
							name = L["Press RightAlt key down will create target's name strings"],
							fontSize = "medium",
						},
					},
				},

			},
		},
	},
}

local function getOptions()
    return options
end

function ns:RegisterUnitOptions(key, option)
    if(type(option) == 'function') then
        option = option()
    end
    if(type(option) == 'table') then
        options.args.units.args[key] = option;
    end
end

function ns:SetupOptions()
    local profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
    profiles.order = ns.order() + 5000

		options.args.general.args.profiles = profiles;

		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("WSUnitFrame", getOptions)
		--self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")

    local GetTipAnchor = function(frame)
        local x, y = frame:GetCenter()
        if not x or not y then return 'TOPLEFT', 'BOTTOMLEFT' end
        local hhalf = (x> UIParent:GetWidth()*2/3) and 'RIGHT' or (x<UIParent:GetWidth()/3) and 'LEFT' or ''
        local vhalf = (y>UIParent:GetHeight()/2) and 'TOP' or 'BOTTOM'
        return vhalf..hhalf, frame, (vhalf=='TOP' and 'BOTTOM' or 'TOP') .. hhalf
    end

    self.dataobj = LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject('WowshellUnitFrame', {
        type = 'launcher',
        icon = 'Interface\\Icons\\Spell_Shaman_Hex',
        OnClick = function()
					ns.db.profile.locked = not ns.db.profile.locked;
					ns.modules.movers:Update();
				end,
        OnLeave = function() GameTooltip:Hide() end,
        OnEnter = function(self)
            GameTooltip:SetOwner(self, 'ANCHOR_NONE')
            GameTooltip:SetPoint(GetTipAnchor(self))
            GameTooltip:ClearLines()

            GameTooltip:AddLine(L['Wowshell unit frame'])

            GameTooltip:AddLine(L['Click to toggle lock'])

            GameTooltip:Show()
        end,
    })
    LibStub('LibDBIcon-1.0'):Register('WowshellUnitFrameMinimapIcon', self.dataobj, {})
end
