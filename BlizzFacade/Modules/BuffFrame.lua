--[[
	Project.: BlizzFacade
	File....: Modules/BuffFrame.lua
	Version.: 43
	Author..: StormFX
]]

-- [ Private Table ] --

local AddOn, ns = ...

-- [ Set Up ] --

local assert = assert
local LibStub = assert(LibStub, "BlizzFacade requires LibStub.")
local LBF = LibStub("LibButtonFacade", true);
local Masque = LibStub("Masque", true);
local BLF = LibStub("AceAddon-3.0"):GetAddon(AddOn)
local mod = BLF:NewModule("BuffFrame")

-- [ Locals ] --

local L = ns.L
local format, pairs, wipe = string.format, pairs, wipe
local Group

-- [ Options ] --

local Options = {
	type = "group",
	name = L["Buff Frame"],
	args = {
		Info = {
			type = "description",
			name = L["Allows the default buff frame to be skinned by ButtonFacade."].."\n",
			order = 1,
		},
		Enable = {
			type = "toggle",
			name = L["Enable"],
			desc = L["Enable skinning of the buff frame."],
			get = function() return mod:IsEnabled() end,
			set = function(info, s)	BLF:ToggleModule("BuffFrame", s) end,
			order = 2,
		},
	},
}

-- [ Core Methods ] --

-- Initialize the module.
function mod:OnInitialize()
	self:RegisterModuleOptions("BuffFrame", Options)
end

-- Enable function.
function mod:OnEnable()
	if LBF then
		Group = LBF:Group(AddOn, "BuffFrame")
	elseif Masque then
		Group = Masque:Group(AddOn, "BuffFrame")
	end
	Group:Skin(BLF.db.profile.Skins["BuffFrame"].SkinID, BLF.db.profile.Skins["BuffFrame"].Gloss, BLF.db.profile.Skins["BuffFrame"].Backdrop, BLF.db.profile.Skins["BuffFrame"].Colors)
	hooksecurefunc("BuffFrame_Update", self.BuffFrame_Update)
	self:BuffFrame_Update()
end

do
	local cache = {}
	-- Disable function.
	function mod:OnDisable()
		Group:Delete()
		wipe(cache)
	end

	-- Post-hook that updates the list of buttons to be skinned.
	function mod:BuffFrame_Update()
		-- Buffs
		for i=1, BUFF_ACTUAL_DISPLAY do
			local button = _G[format("BuffButton%d", i)]
			if button and not cache[button] then
				Group:AddButton(button)
				cache[button] = true
			end
		end
		-- Debuffs
		for i=1, DEBUFF_ACTUAL_DISPLAY do
			local button = _G[format("DebuffButton%d", i)]
			if button and not cache[button] then
				Group:AddButton(button)
				cache[button] = true
			end
		end
		-- Enchants
		for i=1, 3 do
			local button = _G[format("TempEnchant%d", i)]
			if button and not cache[button] then
				Group:AddButton(button)
				cache[button] = true
				local border = _G[format("TempEnchant%dBorder", i)]
				if border then
					border:SetVertexColor(0.2, 0, 0.4, 1)
				end
			end
		end
	end
end
