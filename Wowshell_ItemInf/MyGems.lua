------------------------------------------------------------
-- MyGems.lua
--
-- Abin
-- 2010/12/29
------------------------------------------------------------

local GetItemInfo = GetItemInfo
local tinsert = tinsert
local ipairs = ipairs
local strfind = strfind
local GetInventoryItemLink = GetInventoryItemLink
local pairs = pairs
local wipe = wipe
local GetInventoryItemGems = GetInventoryItemGems

local JEWELERS_GEM_PATTERN = gsub(gsub(gsub(gsub(ITEM_LIMIT_CATEGORY_MULTIPLE, "%(", "%%("), "%)", "%%)"), "%%s", "(.+)"), "%%d", "(%%d+)") -- Kinda aweful, I know...
local ID_RED, ID_BLUE, ID_YELLOW, ID_PURPLE, ID_GREEN, ID_ORANGE, ID_META, ID_JEWELER = 1, 2, 3, 4, 5, 6, 7, 8
local TEXT_COLORS = { { r = 1, g = 0, b = 0 }, { r = 0, g = 0, b = 1 }, { r = 1, g = 1, b = 0 }, { r = 1, g = 0, b = 1 }, { r = 0, g = 1, b = 0 }, { r = 1, g = 0.5, b = 0 } }
local GEM_COLORS = { GetAuctionItemSubClasses(10) } -- Localized gem color strings
if #GEM_COLORS < 9 then
	GEM_COLORS = { GetAuctionItemSubClasses(8) } -- 4.06 changed jewel class from 10 to 8
end

local currentGems = {}
local jewelerItems = {}
local gemButtons = {}
local jewelerTipLine

-- If there's any better solution on determining whether a meta gem is activated...
local scanTip = CreateFrame("GameTooltip", "MyGemsScanTip", UIParent, "GameTooltipTemplate")
function scanTip:FindLine(pattern, from, to)
	local prefix = self:GetName().."TextLeft"
	local i
	for i = from, to do
		local text = _G[prefix..i]
		text = text and text:GetText()
		if text then
			local a, b, c, d = strfind(text, pattern)
			if a then
				return a, b, c, d
			end
		end
	end
end

local function CheckGem(id, slot)
	if not id then
		return
	end

	local name, link, _, _, _, _, subclass, _, _, texture = GetItemInfo(id)
	if not name or not link or not subclass then
		return
	end

	-- Check for jewelers gem
	scanTip:SetOwner(UIParent, "ANCHOR_NONE")
	scanTip:SetHyperlink(link)
	local _, _, tipLine = scanTip:FindLine(JEWELERS_GEM_PATTERN, 2, 5)
	if tipLine then
		jewelerTipLine = tipLine
		currentGems[ID_JEWELER] = (currentGems[ID_JEWELER] or 0) + 1
		tinsert(jewelerItems, { gem = link, item = GetInventoryItemLink("player", slot) })
	end

	-- Check for regular gem
	local key, color
	for key, color in pairs(GEM_COLORS) do
		if subclass == color then
			currentGems[key] = (currentGems[key] or 0) + 1
			if key == ID_META then
				local button = gemButtons[ID_META]
				button.icon:SetTexture(texture)
				button.link = link
				button.icon:SetDesaturated(not not scanTip:FindLine("cff808080", 3, 5))
			end
		end
	end
end

local function CalcEquippedGems()
	wipe(currentGems)
	wipe(jewelerItems)
	jewelerTipLine = nil
	gemButtons[ID_META].link = nil

	local slot
	for slot = 1, 18 do
		local gem1, gem2, gem3 = GetInventoryItemGems(slot)
		CheckGem(gem1, slot)
		CheckGem(gem2, slot)
		CheckGem(gem3, slot)
	end

	local button
	for _, button in pairs(gemButtons) do
		button:UpdateGemCount()
	end
end

local frame = CreateFrame("Frame", "MyGemsFrame", CharacterModelFrame)
frame:SetWidth(24)
frame:SetHeight(24)
frame:SetPoint("TOPRIGHT", -3, -3)

frame:SetScript("OnShow", function(self)
	self:RegisterEvent("UNIT_INVENTORY_CHANGED")
	CalcEquippedGems()
end)

frame:SetScript("OnHide", function(self)
	self:UnregisterAllEvents()
end)

frame:SetScript("OnEvent", function(self, event, unit)
	if unit == "player" then
		CalcEquippedGems()
	end
end)

local function Button_UpdateGemCount(self)
	local count = 0
	local key
	for _, key in ipairs(self.related) do
		local related = currentGems[key]
		if related then
			count = count + related
		end
	end

	if count > 0 then
		self.text:SetFormattedText(count)
		self:Show()
	else
		self:Hide()
	end
end

local function Button_OnEnter(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()

	local id = self:GetID()
	if id == ID_META then
		if self.link then
			GameTooltip:SetHyperlink(self.link)
		end
	elseif id == ID_JEWELER then
		GameTooltip:AddLine(jewelerTipLine)
		local data
		for _, data in ipairs(jewelerItems) do
			GameTooltip:AddDoubleLine(data.gem, data.item)
		end
	else
		GameTooltip:AddLine(GEM_COLORS[id])
		local key
		for _, key in ipairs(self.related) do
			local related = currentGems[key]
			if related then
				local color = TEXT_COLORS[key]
				GameTooltip:AddDoubleLine(GEM_COLORS[key], related, color.r, color.g, color.b)
			end
		end
	end
	GameTooltip:Show()
end

local function Button_OnLeave(self)
	GameTooltip:Hide()
end

local prevButton
local function CreateGemButton(icon, key, ...)
	local button = CreateFrame("Button", "MyGemsButton"..key, frame)
	gemButtons[key] = button
	button:SetID(key)
	button.related = { key, ... }
	button:SetWidth(24)
	button:SetHeight(24)
	button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

	if prevButton then
		button:SetPoint("TOP", prevButton, "BOTTOM", 0, -1)
	else
		button:SetPoint("TOPRIGHT")
	end
	prevButton = button

	button.icon = button:CreateTexture(button:GetName().."Icon", "BORDER")
	button.icon:SetAllPoints(button)
	button.icon:SetTexture(icon)

	button.text = button:CreateFontString(button:GetName().."Count", "ARTWORK", "TextStatusBarText")
	button.text:SetPoint("BOTTOMRIGHT")

	button.UpdateGemCount = Button_UpdateGemCount

	button:SetScript("OnEnter", Button_OnEnter)
	button:SetScript("OnLeave", Button_OnLeave)
	return button
end

CreateGemButton(nil, ID_META):Hide() -- Meta
CreateGemButton("Interface\\Icons\\Inv_misc_cutgemnormala", ID_RED, ID_PURPLE, ID_ORANGE) -- Red, includes purple and orange
CreateGemButton("Interface\\Icons\\Inv_misc_cutgemnormal6a", ID_YELLOW, ID_GREEN, ID_ORANGE) -- Yellow, includes green and orange
CreateGemButton("Interface\\Icons\\Inv_misc_cutgemnormal4a", ID_BLUE, ID_PURPLE, ID_GREEN) -- Blue, includes purple and green
CreateGemButton("Interface\\Icons\\INV_Misc_Gem_02", ID_JEWELER) -- Jeweler-only gems