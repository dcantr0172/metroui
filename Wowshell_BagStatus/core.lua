--------------------------------------------------
--  背包状态及一键打开
--  $Revision: 3816 $
--  $Date: 2010-09-23 12:33:04 +0800 (四, 2010-09-23) $
--  作者: 月色狼影@cwdg
--------------------------------------------------
local L = wsLocale:GetLocale("BagStatus")
local addon = LibStub("AceAddon-3.0"):NewAddon("BagStatus", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
BagStatus = addon;
local revision = tonumber(("$Revision: 3816 $"):match("%d+"));
addon.revision = revision;
--local wsInfoBox = LibStub("wsInfoBox");
--register wsInfoBox
--local dataobj = wsInfoBox:RegisterNewPlugin("BagStatus", {
local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('wsBagStatus', {
	label = L["背包"],
	text = "??/??",
	icon = "Interface\\Icons\\INV_Misc_Bag_27"
});

local BS_numSlot = {0, 0, 0, 0, 0}
local BS_UsedSlots = {0, 0, 0, 0}
local BS_AMMO = {L["箭"], L["弹药"]}
local BS_EBAGINFO = {};


local defaults = {
	profile = {
		showBagStatus = true,--显示背包状态
		showStatusBar = true,--显示背包状态条
		BagStatusAlpha = 0.8,--透明度设定
		CountAbb = true,--当数量大于1000时转为 #.# k显示
		--BagOpen = {
		--	merchantOpen = true, --与商人对话
		--	auctionOpen = true,--ah
		--	playerBankOpen = true,--player's bank
		--	guildBankOpen = true, --guildbank
		--},
	}
}

function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BagStatusDB", defaults, "Default");

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self:CreateBagBar()--5bag bar 
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("BAG_UPDATE");

	--update money
	self:RegisterEvent("PLAYER_MONEY", "UpdateStatusBar");
	self:RegisterEvent("PLAYER_TRADE_MONEY", "UpdateStatusBar");
	self:RegisterEvent("TRADE_MONEY_CHANGED", "UpdateStatusBar");
	self:RegisterEvent("SEND_MAIL_MONEY_CHANGED", "UpdateStatusBar");
	self:RegisterEvent("SEND_MAIL_COD_CHANGED", "UpdateStatusBar");

	self:SetupOptions()
end

function addon:ToggleBagStatusCount(flag)
	if flag then
		self:SecureHook("SetItemButtonCount", "BetterItemCount_SetItemButtonCount")
	else
		self:Unhook("SetItemButtonCount", "BetterItemCount_SetItemButtonCount");
	end
end

function addon:OnEnable()
	self:ToggleBagStatusCount(self.db.profile.CountAbb);
	--self:BagOpen()
end

--update setting
function addon:OnProfileChanged()
	local alpha = self.db.profile.BagStatusAlpha
	for i=0, 4 do
		local bar = getglobal("BagStatusBar"..i)
		bar:SetAlpha(alpha);
	end

	self:UpdateBagStatus();
	--self:BagOpen()
end

function addon:PLAYER_ENTERING_WORLD()
	self:GetPlayerContainerNum()
	self:GetPlayerContainerFreeNum()

	self:UpdateStatusBar()
	self:UpdateBagStatus()
end

function addon:BAG_UPDATE()
	self:GetPlayerContainerNum()
	self:GetPlayerContainerFreeNum()

	self:UpdateStatusBar()
	self:UpdateBagStatus()
end

function addon:GetPlayerContainerNum()
	for bag = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		BS_numSlot[bag+1] = GetContainerNumSlots(bag)
	end
end

function addon:GetPlayerContainerFreeNum()
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		BS_UsedSlots[bag+1] = GetContainerNumFreeSlots(bag)
	end
end

function addon:UpdateStatusBar()
	local numSlot, usedSlot, freeSlot = 0, 0, 0
	for bag=0, 4, 1 do
		if (BS_numSlot[bag+1]) then
			numSlot = numSlot + BS_numSlot[bag+1]
		end
		if (BS_UsedSlots[bag+1]) then
			freeSlot = freeSlot + BS_UsedSlots[bag+1]
		end
	end
	
	usedSlot = (numSlot-freeSlot)
	dataobj.text = usedSlot.."/"..numSlot.."  " --..self:UpdateStatusMoney()
end

function addon:UpdateStatusMoney()
	local money = GetMoney()--player money
	local gold =  floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);
	
	local coin = [[|cffffffff%d|r|TInterface\AddOns\Wowshell_BagStatus\textures\%s:0:0:1|t]]
	local costStr = coin:format(copper, "Copper");
	if (silver > 0) then
		costStr = coin:format(silver, "Silver")..costStr;
	end
	if (gold > 0) then
		costStr = coin:format(gold, "Gold")..costStr;
	end
	return costStr
end

local BagButton = {
	"MainMenuBarBackpackButton",
	"CharacterBag0Slot",
	"CharacterBag1Slot",
	"CharacterBag2Slot",
	"CharacterBag3Slot"
}

function addon:CreateBagBar()
	for i = BACKPACK_CONTAINER , NUM_BAG_SLOTS do
		barname = "BagStatusBar"..i
		local statusbar = CreateFrame("StatusBar", barname, getglobal(BagButton[i+1]));
		statusbar:SetFrameLevel(6)
		statusbar:SetToplevel(true);
		statusbar:SetWidth(25);
		statusbar:SetHeight(6);
		statusbar:SetAlpha(self.db.profile.BagStatusAlpha);
		textname = barname.."_text";
		local text = statusbar:CreateFontString(textname, "ARTWORK", "SpellFont_Small");
		text:SetTextHeight(10);
		text:SetPoint("CENTER", 0, 0)
		statusbar:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]]);
		statusbar:SetStatusBarColor(0, 1, 0);
		if i == 0 then
			statusbar:SetPoint("BOTTOMLEFT", getglobal(BagButton[i+1]), "BOTTOMLEFT", 2, 1)
		elseif i == 1 then
			statusbar:SetPoint("BOTTOMLEFT", getglobal(BagButton[i+1]), "BOTTOMLEFT", 2, 1)
		elseif i == 2 then
			statusbar:SetPoint("BOTTOMLEFT", getglobal(BagButton[i+1]), "BOTTOMLEFT", 2, 1)
		elseif i == 3 then
			statusbar:SetPoint("BOTTOMLEFT", getglobal(BagButton[i+1]), "BOTTOMLEFT", 2, 1)
		elseif i == 4 then
			statusbar:SetPoint("BOTTOMLEFT", getglobal(BagButton[i+1]), "BOTTOMLEFT", 2, 1)
		end

		statusbar:Hide();
	end
end

function addon:GetBagNameForHide(bag)
	if not GetBagName(bag) then
		return false
	else
		for i=1, #BS_AMMO do
			if (strfind(GetBagName(bag), BS_AMMO[i])) then
				return false
			end
		end
	end

	return true
end

function addon:UpdateBagStatus()
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local bar = getglobal("BagStatusBar"..i);
		local numSlot = BS_numSlot[i+1];
		local freeSlot = BS_UsedSlots[i+1];
		local usedSlot = numSlot - freeSlot;
		if numSlot > 0 then
			BS_EBAGINFO[i] = usedSlot.."/"..numSlot;
		end
		if self.db.profile.showBagStatus then
		local hasHide = self:GetBagNameForHide(i)
			if hasHide then
				local text = getglobal("BagStatusBar"..i.."_text");
				text:SetText(usedSlot.."/"..numSlot);
				
				bar:SetMinMaxValues(0, numSlot);
				bar:SetValue(usedSlot);

				local percent = usedSlot/numSlot
				if (percent >= 0.5 and percent <= 1) then
					local b = 1 - (percent -0.5) * 2
					if ( b >= 0 and b <= 1) then
						bar:SetStatusBarColor(1, b, 0);
					end
				elseif ( percent > 0) then
					bar:SetStatusBarColor(percent, 1, 0)
				end
				bar:Show();

				if UnitHasVehicleUI("player") then
					bar:Hide()
				else
					bar:Show()
				end
			end
		else
			if bar:IsShown() then
				bar:Hide()
			end
		end
	end
end

--function dataobj.OnLeave(self)
--	GameTooltip:SetClampedToScreen(true)
--	GameTooltip:Hide()
--end

function dataobj.OnTooltipShow(tooltip)
	tooltip:AddLine(L["背包状态"])
	for i, v in pairs(BS_EBAGINFO) do
		tooltip:AddDoubleLine(GetBagName(i), v)
	end
	tooltip:AddLine(" ");
	--GameTooltip:AddLine(CURRENCY..": ");
	--GameTooltip:AddDoubleLine(MONEY, addon:UpdateStatusMoney());

    if(GetCurrencyListSize() > 0) then
        local __icon = '%d|T%s:14:14:3:0|t'
        for i = 1, GetCurrencyListSize() do
            local name, isHeader, isExpanded, usUnused, isWatched, count, icon = GetCurrencyListInfo(i)
            if(name) and not (isHeader or isUnused) then
                tooltip:AddDoubleLine(name, __icon:format(count, icon))
            end
        end
    end
end

--function addon:UpdateCurrencyInfo()
--    if(GetCurrencyListSize() < 1) then return end
--
--	GameTooltip:AddLine(" ");
--    local ICON_SIZE_FS = "%d|T%s:14:14:3:0|t"
--
--    for i = 1, GetCurrencyListSize() do
--        local name, isHeader, isExpanded, isUnused, isWatched, count, icon = GetCurrencyListInfo(i)
--        if(name and (not isHeader) and (not isUnused)) then
--            GameTooltip:AddDoubleLine(name, string.format(ICON_SIZE_FS, count, icon))
--        end
--    end
--
----	for i = 1, currencyNums, 1 do
----		local name, isHeader, isExpanded, isUnused, isWatched, count, extraCurrencyType, icon, itemID =     GetCurrencyListInfo(i)
----		if name and not isHeader and not isExpanded and not isUnused and extraCurrencyType == 0 then
----			GameTooltip:AddDoubleLine(name, ("%d\124T"..icon..":14:14:3:0\124t"):format(count));
----		end
----	end
--end

function dataobj.OnClick(self, button, ...)
    ToggleBackpack()
--	if button == "RightButton" then
--		LibStub("AceConfigDialog-3.0"):Open("BagStatusOptions")
--	end
end

function addon:BetterItemCount_SetItemButtonCount(button, count)
	-- orig by Miyke
	if ( not button ) then return end
	if ( not count ) then
		count = 0
	end

	button.count = count
	local countText = getglobal(button:GetName().."Count")
	if count > 1 or (button.isBag and count > 0) then
		if count > 999 then 
			local fixedCount = count+50
			count = floor((fixedCount)/1000).."."..floor(((mod(fixedCount, 1000))/100)).."k"
		end 
		countText:SetText(count)
		countText:Show()
	else
		countText:Hide()
	end
end

--function addon:BagOpen()
--	if IsAddOnLoaded("Combuctor") then return end;
--	
--	local db = self.db.profile.BagOpen
--	if db.merchantOpen then
--		self:RegisterEvent("MERCHANT_SHOW", "OpenBagAll");
--		self:RegisterEvent("MERCHANT_CLOSED", "OpenBagClose")
--	else
--		self:UnregisterEvent("MERCHANT_SHOW")
--		self:UnregisterEvent("MERCHANT_CLOSED")
--	end
--
--	if db.auctionOpen then
--		self:RegisterEvent("AUCTION_HOUSE_SHOW", "OpenBagAll");
--		self:RegisterEvent("AUCTION_HOUSE_CLOSED", "OpenBagClose")
--	else
--		self:UnregisterEvent("AUCTION_HOUSE_SHOW")
--		self:UnregisterEvent("AUCTION_HOUSE_CLOSED")
--	end
--
--	if db.playerBankOpen then
--		self:RegisterEvent("BANKFRAME_OPENED", "OpenBagAll");
--		self:RegisterEvent("BANKFRAME_CLOSED", "OpenBagClose")
--	else
--		self:UnregisterEvent("BANKFRAME_OPENED")
--		self:UnregisterEvent("BANKFRAME_CLOSED")
--	end
--
--	if db.guildBankOpen then
--		self:RegisterEvent("GUILDBANKFRAME_OPENED", "OpenBagAll");
--		self:RegisterEvent("GUILDBANKFRAME_CLOSED", "OpenBagClose")
--	else
--		self:UnregisterEvent("GUILDBANKFRAME_OPENED")
--		self:UnregisterEvent("GUILDBANKFRAME_CLOSED")
--	end
--end
--
--function addon:OpenBagAll()
--	OpenAllBags(1)
--end
--
--function addon:OpenBagClose()
--	CloseAllBags(1)
--end
