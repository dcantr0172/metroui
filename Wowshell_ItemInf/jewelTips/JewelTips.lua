--[[
	JewelTips 0.7.0
]]--

local L = LibStub("AceLocale-3.0"):GetLocale("JewelTips")

--Create Jeweltips frame
JewelTips = {}
local JewelTips = JewelTips

--Localize functions
local tonumber, GetItemInfo, GetItemGem, select = tonumber, GetItemInfo, GetItemGem, select
local RED_GEM, YELLOW_GEM, BLUE_GEM, META_GEM = RED_GEM, YELLOW_GEM, BLUE_GEM, META_GEM
--local INVTYPE_FEET INVTYPE_WRIST INVTYPE_CLOAK INVTYPE_SHIELD = INVTYPE_FEET INVTYPE_WRIST INVTYPE_CLOAK INVTYPE_SHIELD
local strgsub = string.gsub
local strmatch = string.match
--Localize tooltips
local ItemRefTooltip, GameTooltip = ItemRefTooltip, GameTooltip
local currentGemLinkTable = {}
local currentGemTextureTable = {}
local icon
local lastlink = "None"

JewelTips.BUTTON_SIZE = 30
--if IDCard then
	JewelTips.BUTTON_OFFSETY = -40
--end
JewelTips.QUESTIONMARK_ICON = "Interface\\Icons\\INV_Misc_QuestionMark"
JewelTips.ENCHANT_ICON = "Interface\\Icons\\Spell_Holy_GreaterHeal"

function JewelTips.enchantIDtoLink(JewelID, equipLoc)
	local index = tonumber(JewelID)
	if not index then return nil end

	local item = JewelTips.Jewels[index]
	if type(item) == "table" and item.multi == true then
		item = item[equipLoc]
	end

	if item and item ~= 0 then
		if type(item) == "number" then
			return select(2, GetItemInfo(item)) or item
		else
			return "|cffffd000|Henchant:"..item[2].."|h["..item[1].."]|h|r"
		end
	else
		return -1 * index --index is negated to show that the number is the original enchantID
	end
end

function JewelTips.JewelColor(itemLink)
	local subtype = select(7,GetItemInfo( itemLink ))
	local colorString

	if subtype == BLUE_GEM then
		colorString = "0000ff"
	elseif subtype == RED_GEM then
		colorString = "ff0000"
	elseif subtype == YELLOW_GEM then
		colorString = "ffff00"
	elseif subtype == L["Purple"] then
		colorString = "8000ff"
	elseif subtype == L["Orange"] then
		colorString = "ff8040"
	elseif subtype == L["Green"] then
		colorString = "00ff00"
	elseif subtype == META_GEM then
		colorString = "aaaaaa"
	else
		colorString = "ffffff"
	end

	return " (|cff"..colorString..subtype.."|r)"
end

-- Shared Button Functions
local function gemButton_OnClick(self)
	if IsShiftKeyDown() then
		if WIM_EditBoxInFocus then
			WIM_EditBoxInFocus:Insert(self.link);
		elseif ChatFrame1EditBox:IsVisible() then
			ChatFrame1EditBox:Insert(self.link);
		end
	end
end

--This function is only used for gemButtons not used for the enchantButton
local function gemButton_OnEnter(self)
	if self.link then
		local linknum = tonumber(self.link)
		if (not linknum) then
			--self.link is an itemLink
			GameTooltip:SetOwner(self, JewelTips.TOOLTIP_ANCHOR, JewelTips.TOOLTIP_ANCHOR_OFFSETX, JewelTips.TOOLTIP_ANCHOR_OFFSETY)
			GameTooltip:SetHyperlink(self.link)
			GameTooltip:Show()
		elseif (linknum > 0) then
			--self.link is an itemID
			GameTooltip:SetOwner(self, JewelTips.TOOLTIP_ANCHOR, JewelTips.TOOLTIP_ANCHOR_OFFSETX, JewelTips.TOOLTIP_ANCHOR_OFFSETY)
			GameTooltip:SetHyperlink("item:"..self.link)
			GameTooltip:Show()
		end
	end
end
--/script JewelTips.MoveButtons("top")
local enchantButton = CreateFrame("Button",nil,ItemRefTooltip)
local gem1Button = CreateFrame("Button",nil,ItemRefTooltip)
local gem2Button = CreateFrame("Button",nil,ItemRefTooltip)
local gem3Button = CreateFrame("Button",nil,ItemRefTooltip)

local gemButtonTable = {enchantButton, gem1Button, gem2Button, gem3Button}

for index, gemButton in pairs(gemButtonTable) do
	gemButton:SetWidth(JewelTips.BUTTON_SIZE)
	gemButton:SetHeight(JewelTips.BUTTON_SIZE)
	gemButton:SetScript("OnClick", gemButton_OnClick)
	gemButton:SetScript("OnEnter", gemButton_OnEnter)
	gemButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
	gemButton.gemIndex = index - 1
	gemButton:Hide()
end

local function ClearButtons()
	for _, gemButton in pairs(gemButtonTable) do
		gemButton:Hide()
	end
end

function JewelTips:MoveButtons(side)
	if side == "top" then
		self.TOOLTIP_ANCHOR = "ANCHOR_TOPLEFT"
		self.TOOLTIP_ANCHOR_OFFSETX = 0
		self.TOOLTIP_ANCHOR_OFFSETY = 0
		for index, gemButton in pairs(gemButtonTable) do
			gemButton:ClearAllPoints()
			gemButton:SetPoint("BOTTOMLEFT", ItemRefTooltip, "TOPLEFT", 2+(self.BUTTON_SIZE * (index-1)), 0 )
		end
	elseif side == "bottom" then
		self.TOOLTIP_ANCHOR = "ANCHOR_BOTTOMRIGHT"
		self.TOOLTIP_ANCHOR_OFFSETX = -1*(self.BUTTON_SIZE+2)
		self.TOOLTIP_ANCHOR_OFFSETY = 0
		for index, gemButton in pairs(gemButtonTable) do
			gemButton:ClearAllPoints()
			gemButton:SetPoint("TOPLEFT", ItemRefTooltip, "BOTTOMLEFT", 2+(self.BUTTON_SIZE * (index-1)), 0 )
		end
	elseif side == "left" then
		self.TOOLTIP_ANCHOR = "ANCHOR_BOTTOMLEFT"
		self.TOOLTIP_ANCHOR_OFFSETX = 0
		self.TOOLTIP_ANCHOR_OFFSETY = self.BUTTON_SIZE+2
		for index, gemButton in pairs(gemButtonTable) do
			gemButton:ClearAllPoints()
			gemButton:SetPoint("TOPRIGHT", ItemRefTooltip, "TOPLEFT", 0, self.BUTTON_OFFSETY - (self.BUTTON_SIZE * (index-1)) )
		end
	elseif side == "right" then
		self.TOOLTIP_ANCHOR = "ANCHOR_BOTTOMRIGHT"
		self.TOOLTIP_ANCHOR_OFFSETX = 0
		self.TOOLTIP_ANCHOR_OFFSETY = self.BUTTON_SIZE+2
		for index, gemButton in pairs(gemButtonTable) do
			gemButton:ClearAllPoints()
			gemButton:SetPoint("TOPLEFT", ItemRefTooltip, "TOPRIGHT", 0, self.BUTTON_OFFSETY - (self.BUTTON_SIZE *(index-1)) )
		end
	end
end

JewelTips:MoveButtons("left")

--Main Routine------------------------------------------
local function addEnchantLines(tooltip, link)
	--For some tooltips, this Main function will be called continuously. This code keeps us from doing unnecessary work after the first time.
	if link ~= lastlink then--Reuse data from the last call since the tooltip link is the same
		currentGemLinkTable[1], currentGemLinkTable[2], currentGemLinkTable[3], currentGemLinkTable[4] = string.match(link, "item:%d+:(%d+):(%d+):(%d+):(%d+):")

		for index, gemLink in pairs(currentGemLinkTable) do
			if gemLink == "0" then
				currentGemLinkTable[index] = nil
			else
				--Check for an item corresponding to the enchantID
				if index == 1 then
					currentGemLinkTable[1] = JewelTips.enchantIDtoLink(gemLink, select(9, GetItemInfo(link)))
				else
					local newGemLink = select(2,GetItemGem(link, gemButtonTable[index].gemIndex))
					if newGemLink then
						currentGemLinkTable[index] = newGemLink
						currentGemTextureTable[index] = GetItemIcon( currentGemLinkTable[index] )
					else
						currentGemLinkTable[index] = gemLink
						currentGemTextureTable[index] = JewelTips.QUESTIONMARK_ICON
					end
				end
			end
		end
		lastlink = link
	end

	--Add tooltip lines
	for index, gemLink in pairs(currentGemLinkTable) do
		if index == 1 then
			if type(gemLink) == "number" then
				if gemLink < 0 then
					tooltip:AddLine( string.format(L["[Unknown Enchant: %d]"].." (|cffffffff"..L["Enchant"].."|r)", -1 * gemLink) )
				else
					tooltip:AddLine( string.format(L["[Unsafe Link: %d]"].." (|cffffffff"..L["Enchant"].."|r)", gemLink) )
					lastlink = "None"
				end
				tooltip:AddTexture(JewelTips.QUESTIONMARK_ICON)
			else
				tooltip:AddLine( gemLink .. " (|cffffffff"..L["Enchant"].."|r)")
				if strmatch( gemLink, "Henchant:" ) then
					tooltip:AddTexture(JewelTips.ENCHANT_ICON)
				else
					tooltip:AddTexture(GetItemIcon(gemLink) or JewelTips.QUESTIONMARK_ICON)
				end
			end
		else
			if tonumber(gemLink) then
				lastlink = "None"
			else
				tooltip:AddLine(gemLink .. JewelTips.JewelColor(gemLink))
				tooltip:AddTexture(currentGemTextureTable[index])
			end
		end
	end

	tooltip:Show()
end

local function updateItemRefButtons(link)
	--Show/Hide the Buttons for each Gem
	for index, gemButton in pairs(gemButtonTable) do
		gemButton.link = currentGemLinkTable[index]
		if gemButton.link then
			if type(gemButton.link) == "number" then
				gemButton:SetNormalTexture(JewelTips.QUESTIONMARK_ICON)
			else
				icon = select( 10, GetItemInfo( gemButton.link ) )
				gemButton:SetNormalTexture(icon or JewelTips.ENCHANT_ICON)
			end
			gemButton:Show()
		else
			gemButton:Hide()
		end
	end
end

--Thanks to Tekkub for his beautifully simple tekKompare code from which some of this is borrowed
local Orig_GameTooltip_OnTooltipSetItem = GameTooltip:GetScript("OnTooltipSetItem")
GameTooltip:SetScript("OnTooltipSetItem", function(tooltip, ...)
	assert(tooltip, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = tooltip:GetItem()

	--Check if the tooltip is one of our Jewel tooltips
	for _, gemButton in pairs(gemButtonTable) do
		if tooltip:IsOwned(gemButton) then
			-- If we're setting the link for our enchantbutton, check that the icon is good
			local linknum = tonumber(gemButton.link)
			if (linknum and linknum > 0) then
				local _, itemRefItem = ItemRefTooltip:GetItem()
				ItemRefTooltip:ClearLines()
				SetItemRef(itemRefItem)
				addEnchantLines(ItemRefTooltip, link)
				ItemRefTooltip:Show()
				_, gemButton.link, _, _, _, _, _, _, _, icon = GetItemInfo( linknum )
				gemButton:SetNormalTexture(icon)
			end
			return Orig_GameTooltip_OnTooltipSetItem(tooltip, ...)
		end
	end

--	if not ShoppingTooltip1:IsVisible() then SetTips(link, frame, ShoppingTooltip1, ShoppingTooltip2) end
	if link then
		addEnchantLines(tooltip, link)
	end
	if Orig_GameTooltip_OnTooltipSetItem then return Orig_GameTooltip_OnTooltipSetItem(tooltip, ...) end
end)

local Orig_ItemRefTooltip_OnTooltipSetItem = ItemRefTooltip:GetScript("OnTooltipSetItem")
ItemRefTooltip:SetScript("OnTooltipSetItem", function(tooltip, ...)
	assert(tooltip, "arg 1 is nil, someone isn't hooking correctly")

	local _, link = tooltip:GetItem()
	if link then
		addEnchantLines(tooltip, link)
		updateItemRefButtons(link)
--	else
--		ClearButtons()
	end
	if Orig_ItemRefTooltip_OnTooltipSetItem then return Orig_ItemRefTooltip_OnTooltipSetItem(tooltip, ...) end
end)

local Orig_ItemRefTooltip_OnTooltipCleared = ItemRefTooltip:GetScript("OnTooltipCleared")
ItemRefTooltip:SetScript("OnTooltipCleared", function(...)
	ClearButtons()

	if Orig_ItemRefTooltip_OnTooltipCleared then return Orig_ItemRefTooltip_OnTooltipCleared(...) end
end)
