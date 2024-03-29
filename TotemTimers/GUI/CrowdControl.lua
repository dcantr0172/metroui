-- Copyright © 2008 Xianghar  <xian@zron.de>
-- All Rights Reserved.
-- This code is not to be modified or distributed without written permission by the author.

local SpellNames = TotemTimers.SpellNames
local SpellIDs = TotemTimers.SpellIDs

local L = LibStub("AceLocale-3.0"):GetLocale("TotemTimers_GUI", true)


TotemTimers.options.args.crowdcontrol = {
    type = "group",
    name = "crowdcontrol",
    args = {
        enable = {
            order = 0,
            type = "toggle",
            name = L["Enable"],
            set = function(info, val) TotemTimers_Settings.CrowdControlEnable = val  TotemTimers.ProcessSetting("CrowdControlEnable") end,
            get = function(info) return TotemTimers_Settings.CrowdControlEnable end,
        }, 
        clickthrough = {
            order = 1,
            type = "toggle", 
            name = L["Clickthrough"],
            desc = L["Clickthrough Desc"],
            set = function(info, val) TotemTimers_Settings.CrowdControlClickthrough = val  TotemTimers.ProcessSetting("CrowdControlClickthrough") end,
            get = function(info) return TotemTimers_Settings.CrowdControlClickthrough end,
        },
        CrowdControlArrange = {
            order = 2,
            type = "select",
            name = L["Arrangement"],
            values ={vertical = L["vertical"], horizontal = L["horizontal"]},
            set = function(info, val) 
                TotemTimers_Settings.CrowdControlArrange = val
                TotemTimers.LayoutCrowdControl()
            end,            
            get = function(info) return TotemTimers_Settings.CrowdControlArrange end,
        },  
        cctimepos = {
            order = 9,
            type = "select",
            name = L["Timer Bar Position"],
            desc = L["Timer Bar Position Desc"],
            values = {	["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["TOP"] = L["Top"], ["BOTTOM"] = L["Bottom"],},
            set = function(info, val)
                        TotemTimers_Settings.CrowdControlTimePos = val  TotemTimers.ProcessSetting("CrowdControlTimePos")	
                  end,
            get = function(info) return TotemTimers_Settings.CrowdControlTimePos end,
        },
        ccSize = {
            order = 11,
            type = "range",
            name = L["Button Size"],
            desc = L["Scales the timer buttons"],
            min = 16,
            max = 96,
            step = 1,
            bigStep = 2,
            set = function(info, val)
                        TotemTimers_Settings.CrowdControlSize = val  TotemTimers.ProcessSetting("CrowdControlSize")	
                  end,
            get = function(info) return TotemTimers_Settings.CrowdControlSize end,
        },
    },
}

local ACD = LibStub("AceConfigDialog-3.0")
local frame = ACD:AddToBlizOptions("TotemTimers", L["Crowd Control"], "TotemTimers", "crowdcontrol")
frame:SetScript("OnEvent", function(self) InterfaceOptionsFrame:Hide() end)
frame:HookScript("OnShow", function(self) if InCombatLockdown() then InterfaceOptionsFrame:Hide() end TotemTimers.LastGUIPanel = self end)
frame:RegisterEvent("PLAYER_REGEN_DISABLED")