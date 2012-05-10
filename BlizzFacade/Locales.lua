--[[
	Project.: BlizzFacade
	File....: Locales.lua
	Version.: 38
	Author..: StormFX
]]

-- This contents of this file are automatically generated.
-- Please use the localization application on WoWAce.com to submit translations.
-- http://www.wowace.com/projects/blizzfacade/localization/

-- [ Private Table ] --

local _, ns = ...

-- Hard-code enUS/enGB.
ns.L = {
	["Action Bars"] = "Action Bars",
	["Allows the default action bars to be skinned by ButtonFacade."] = "Allows the default action bars to be skinned by ButtonFacade.",
	["Allows the default buff frame to be skinned by ButtonFacade."] = "Allows the default buff frame to be skinned by ButtonFacade.",
	["Bar Options"] = "Bar Options",
	["BLF_Desc"] = "Adds ButtonFacade support to the default interface. If you experience any display issues, disable the affected module or element and reload your interface.",
	["Buff Frame"] = "Buff Frame",
	["Enable"] = "Enable",
	["Enable skinning of the action bars."] = "Enable skinning of the action bars.",
	["Enable skinning of the buff frame."] = "Enable skinning of the buff frame.",
	["Main Bar"] = "Main Bar",
	["Multi-Bars"] = "Multi-Bars",
	["Options"] = "Options",
	["Pet Bar"] = "Pet Bar",
	["Possess Bar"] = "Possess Bar",
	["Profiles"] = "Profiles",
	["Skin the buttons of the %s."] = "Skin the buttons of the %s.",
	["Stance Bar"] = "Stance Bar",
	["Vehicle Bar"] = "Vehicle Bar",
}

-- Automatically inject all other locales.
do
	local LOC = GetLocale()
	if LOC == "zhCN" then
ns.L["Action Bars"] = "动作条"
ns.L["Allows the default action bars to be skinned by ButtonFacade."] = "允许默认动作条可以被 ButtonFacade 美化"
ns.L["Allows the default buff frame to be skinned by ButtonFacade."] = "允许默认的 Buff 框体可以被 ButtonFacade 美化。"
ns.L["BLF_Desc"] = "增加 ButtonFacade 支持默认界面的美化。如果你碰到任何问题，禁用受影响的模块或元素并重载你的插件。"
ns.L["Bar Options"] = "动作条选项"
ns.L["Buff Frame"] = "Buff 框体"
ns.L["Enable"] = "启用"
ns.L["Enable skinning of the action bars."] = "启用动作条美化。"
ns.L["Enable skinning of the buff frame."] = "启用 Buff 框体美化。"
ns.L["Main Bar"] = "主动作条"
ns.L["Multi-Bars"] = "额外动作条"
ns.L["Options"] = "选项"
ns.L["Pet Bar"] = "宠物条"
ns.L["Possess Bar"] = "控制条"
ns.L["Profiles"] = "配置文件"
ns.L["Skin the buttons of the %s."] = "美化 %s 的按钮。"
ns.L["Stance Bar"] = "姿态条"
ns.L["Vehicle Bar"] = "载具条"
ns.L["ToC/Adds ButtonFacade support to the default interface."] = "增加 ButtonFacade 支持到默认界面。"

	elseif LOC == "zhTW" then
ns.L["Action Bars"] = "動作條"
ns.L["Allows the default action bars to be skinned by ButtonFacade."] = "允許默認動作條可以被 ButtonFacade 美化"
ns.L["Allows the default buff frame to be skinned by ButtonFacade."] = "允許默認的 Buff 框體可以被 ButtonFacade 美化。"
ns.L["BLF_Desc"] = "增加 ButtonFacade 支持默認界面的美化。如果妳碰到任何問題，禁用受影響的模塊或元素並重載妳的插件。"
ns.L["Bar Options"] = "動作條選項"
ns.L["Buff Frame"] = "Buff 框體"
ns.L["Enable"] = "啟用"
ns.L["Enable skinning of the action bars."] = "啟用動作條美化。"
ns.L["Enable skinning of the buff frame."] = "啟用 Buff 框體美化。"
ns.L["Main Bar"] = "主動作條"
ns.L["Multi-Bars"] = "額外動作條"
ns.L["Options"] = "選項"
ns.L["Pet Bar"] = "寵物條"
ns.L["Possess Bar"] = "控制條"
ns.L["Profiles"] = "設定檔"
ns.L["Skin the buttons of the %s."] = "美化 %s 的按鈕。"
ns.L["Stance Bar"] = "姿態條"
ns.L["Vehicle Bar"] = "載具條"
ns.L["ToC/Adds ButtonFacade support to the default interface."] = "增加 ButtonFacade 支持到默認界面。"

	end
end
