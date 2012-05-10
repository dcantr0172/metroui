--------------------------------------------
---- 猎人助手
---- 包含自动射击记时条, 快速喂食
---- $Revision: 99999$
---- $Date$
--------------------------------------------


if select(2, UnitClass("player")) ~= "HUNTER" then
    local addon = ...
    return DisableAddOn(addon)
end

local addon = LibStub("AceAddon-3.0"):NewAddon("IceHunex", "AceConsole-3.0", "AceEvent-3.0");
_G.IceHunex = addon;
local L = wsLocale:GetLocale("IceHunex")

local defaults = {
	profile = {
	},
}

local options, moduleOptions = nil, {}

local function getoptions()
	if not options then
		options = {
			type = "group",
			name = L["猎人助手"],
			args = {
                blah = {
                    order = 1+99999,
                    type = 'description',
                    fontSize = 'medium',
                    name = [[
快捷的守护姿态条，去除“锁定”选项便可以自由移动它的位置。
                    ]],
                },
			},
		}

		for k, v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end
	end
	return options
end

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("HunterHelperDB", defaults, "Default");
end

function addon:OnEnable()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("IceHunex", getoptions());
end

function addon:RegisterModuleOptions(name, optionTbl)
	moduleOptions[name] = optionTbl
end
