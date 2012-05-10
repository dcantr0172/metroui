-- yleaf (yaroot@gmail.com)
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['|cff33ff99AutoGreed: %s >> %s'] = '|cff33ff99自动贪婪: %s >> %s',
} or GetLocale() == 'zhTW' and {
    ['|cff33ff99AutoGreed: %s >> %s'] = '|cff33ff99自動貪婪: %s >> %s',
}, {__index = function(t, i) return i end})
--[[
	0 = Poor
	1 = Common
	2 = Uncommon
	3 = Rare
	4 = Epic
	5 = Legendary
	6 = Artifact
	7 = Heirloom
]]
local addon = LibStub('AceAddon-3.0'):NewAddon('wsAutoGreed', 'AceEvent-3.0')
AutoGreed = addon;
local debug
do
    local debugf = tekDebug and tekDebug:GetFrame('wsAutoGreed')
    if debugf then
        debug = function(...) debugf:AddMessage(string.join(', ', tostringall(...))) end
    else
        debug = function() end
    end
end

local defaults, db = {
    profile = {
        bopOnly = false,
        enabled = false,
        fivemenOnly = true,
        priceLimit = 10,
    }
}

function addon:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('WSAutoGreedDB', defaults, UnitName'player' .. '-' .. GetRealmName())
    db = self.db.profile

    addon:RegisterEvent('START_LOOT_ROLL')
    addon:RegisterEvent('CONFIRM_LOOT_ROLL')
    addon:RegisterEvent('CONFIRM_DISENCHANT_ROLL')
    addon:RegisterEvent('PLAYER_ENTERING_WORLD')
    addon.items = {}

    --self:SetupOption()
end

function addon:OnEnabled()
end
function addon:OnDisabled()
end

local function printf(...)
	print(format(...))
end

function addon:PLAYER_ENTERING_WORLD()
	wipe(self.items)
end

function addon:Add(id, BOP)
	self.items[id] = BOP and 1 or 2
end

function addon:Remove(id)
	if self.items[id] then
		if self.items[id] == 1 then
			self.items[id] = 2
		else
			self.items[id] = nil
		end
	end
end

function addon:IsFiveMen()
    local _, type = IsInInstance()
    if(type and type == 'party') then
        return true
    end
end

local roll_text={
	[2] = GREED,
	[3] = ROLL_DISENCHANT,
}

function addon:START_LOOT_ROLL(event, rollid)
    if(not db.enabled) then return end
    if(db.fivemenOnly and (not self:IsFiveMen())) then return end

	local texture, name, count, quality, BOP, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(rollid)
	if canNeed or (BOP and db.bopOnly) then return end
	
	local link = GetLootRollItemLink(rollid)
	
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(link)
	
	-- 1. need 2. greed 3. de 4. pass
	
	local rollType
	
	if canGreed then
		rollType = 2
		if(canDisenchant and (itemSellPrice<db.priceLimit*10000)) then
			rollType = 3
		end
	end
	
	if rollType then
		debug('AutoRoll', itemName, rollid, rollType)
		printf(L['|cff33ff99AutoGreed: %s >> %s'], roll_text[rollType], itemLink)
		self:Add(rollid, BOP)
		RollOnLoot(rollid, rollType)
	end
end

function addon:CONFIRM_LOOT_ROLL(event, id, rollType)
	debug(event, id, rollType)
	if self.items[id] then
		ConfirmLootRoll(id, rollType)
		self:Remove(id)
	end
end

addon.CONFIRM_DISENCHANT_ROLL = addon.CONFIRM_LOOT_ROLL


hooksecurefunc('StaticPopup_OnShow', function(self)
    if(not db.enabled) then return end
    if(db.fivemenOnly and (not addon:IsFiveMen())) then return end

	if self.which == 'CONFIRM_LOOT_ROLL' then
		local text = _G[self:GetName() .. 'Text']:GetText()
		for id in next, addon.items do
			local _, name = GetLootRollItemInfo(id)
			if name and strfind(text, name) then
				local link = GetLootRollItemLink(id)
				-- debug('StaticPopup, CONFIRM_LOOT_ROLL', name)
				--printf(L['|cff33ff99AutoGreed: confirm >> %s'], link)
				self:Hide()
				addon:Remove(id)
				return
			end
		end
	end
end)


function addon:SetupOption()
end


