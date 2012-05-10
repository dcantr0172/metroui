local wspickupHandle = CreateFrame("Frame");
local wsPickUp = {};
local _debug = false
local _G = _G
local CreateFrame = CreateFrame
local itemKey
wsPickUp.open = false

local locales = {
	zhCN = {
		setItem = "输入需要批量导入导出的物品: ",
		loadItem = "批量提取",
		saveItem = "批量储存",
		minitools = "小工具",
	},
	zhTW = {
		setItem = " 輸入需要批量導入導出的物品: ",
		loadItem = "批量提取",
		saveItem = "批量存儲",
		minitools = "小工具",
	},
	enUS = {
		setItem = true,
		loadItem = true,
		saveItem = true,
		minitools = true,
	},
}

local L = locales[GetLocale()]

--AutoStoreGuildBankItem(GetCurrentGuildBankTab(), self:GetID());
--UseContainerItem(bag, slot)
function wsPickUp:CreatePickFrame()
	if _debug then print("create frame") end
	local f = CreateFrame("Frame", nil, GuildBankFrame);
	f:EnableMouse(true);
	f:SetToplevel(true);
	f:SetWidth(180);
	f:SetHeight(300);
	f:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", 0, -10);
	
	local bg = f:CreateTexture(nil, "BACKGROUND");
	bg:SetTexture([[Interface\AuctionFrame\AuctionHouseDressUpFrame-Top]]);
	bg:SetWidth(256)
	bg:SetHeight(256)
	bg:SetPoint("TOPLEFT");
	local bg1 = f:CreateTexture(nil, "BACKGROUND");
	bg1:SetTexture([[Interface\AuctionFrame\AuctionHouseDressUpFrame-Bottom]]);
	bg1:SetWidth(256);
	bg1:SetHeight(256);
	bg1:SetPoint("TOPLEFT", bg, "BOTTOMLEFT");

	local closeButton = CreateFrame("Button", nil, f, "UIPanelCloseButton");
	closeButton:SetPoint("CENTER", f, "TOPRIGHT", -8, -16);
	local corner = closeButton:CreateTexture(nil, "BACKGROUND");
	corner:SetTexture([[Interface\AuctionFrame\AuctionHouseDressUpFrame-Corner]]);
	corner:SetWidth(32);
	corner:SetHeight(32);
	corner:SetPoint("TOPRIGHT", f, 0, -5);
	closeButton:SetScript("OnClick", function(self, button)
		wsPickUp:Collapsed()
		wsPickUp.open = false
	end);

	--edit box
	local editbox = CreateFrame("EditBox", nil, f, "InputBoxTemplate");
	editbox:SetFontObject("ChatFontNormal");
	editbox:SetWidth(140);
	editbox:SetHeight(13);
	editbox:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -45);
	editbox:SetAutoFocus(false)
	editbox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus();
	end)
	editbox:SetScript("OnEnterPressed", function(self)
		itemKey = self:GetText();
		self:ClearFocus()
	end)
	editbox:SetScript("OnTextChanged", function(self, ...)
		itemKey = self:GetText();
	end)
	local label = editbox:CreateFontString(nil, "ARTWORK", GameFontHighlightSmall);
	label:SetFont(GameFontHighlightSmall:GetFont(), 16, "OUTLINE")
	label:SetPoint("TOPLEFT", editbox, "TOPLEFT", 0, 18);
	label:SetText(L["setItem"])
	f.editbox = editbox

	local pickbutton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	pickbutton:SetText(L["loadItem"]);
	pickbutton:SetWidth(75)
	pickbutton:SetHeight(20);
	pickbutton:SetPoint("TOPLEFT", f, "TOPLEFT", 15, -80);
	pickbutton:SetScript("OnClick", function(self)
		wsPickUp:PickItem()
	end)

	local savebutton = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
	savebutton:SetText(L["saveItem"])
	savebutton:SetWidth(75);
	savebutton:SetHeight(20);
	savebutton:SetPoint("LEFT", pickbutton, "RIGHT", 5, 0);
	savebutton:SetScript("OnClick", function(self)
		wsPickUp:StorageItem()
	end)
	
	self.pickframe = f
	self.pickframe:Hide()
end

function wsPickUp:CreateFrameHandle()
	local button = CreateFrame("Button", "WS_PickUpGuildBank", GuildBankFrame, "UIPanelButtonTemplate2");
	button:SetWidth(72)
	button:SetHeight(26)
	button:SetText(L["minitools"]);

	button:ClearAllPoints();
	button:SetPoint("TOPRIGHT", GuildBankFrame, "TOPRIGHT", -22, -10);
	button:Show();

	button:SetScript("OnClick", function(self, button)
		if not wsPickUp.open then
			wsPickUp:Expand();
			wsPickUp.open = true
		else
			wsPickUp:Collapsed()
			wsPickUp.open = false
		end
	end);	
end

local function searchItem(itemLink, needItem)
	if itemLink then
		local _,_, itemname = itemLink:find("|c%x+|Hitem:%d+:%d+:%d+:%d+:%d+:%d+:%d+:.-|h%[(.-)%]|h|r")
		if (needItem == itemname or needItem==itemLink) then
			return true
		end
		return false
	end
	return false
end

--次級治療藥水
function wsPickUp:PickItem()
	if _debug then print("start pickup item...") end
	itemKey = itemKey or self.pickframe.editbox:GetText()
	local gIndex = 1
	while true do
		local itemLink = GetGuildBankItemLink(GetCurrentGuildBankTab(), gIndex);
		if searchItem(itemLink, itemKey) then
			if _debug then print("now pickup item...") end
			AutoStoreGuildBankItem(GetCurrentGuildBankTab(), gIndex);
		end
		gIndex = gIndex + 1
		if gIndex > MAX_GUILDBANK_SLOTS_PER_TAB then
			break
		end
	end
end

function wsPickUp:StorageItem()
	if _debug then print("start storage item...") end
	itemKey = itemKey or self.pickframe.editbox:GetText()
	for bag = 0, 4 do
		if GetContainerNumSlots(bag) > 0 then
			for slot = 0, GetContainerNumSlots(bag), 1 do
				local itemLink = GetContainerItemLink(bag, slot);
				if searchItem(itemLink, itemKey) then
					if _debug then print("now storage item...") end
					UseContainerItem(bag, slot)
				end
			end
		end
	end
end

function wsPickUp:Collapsed()
	if not self.pickframe then return end
	self.pickframe:Hide()
	local gtab = _G["GuildBankTab"..1];
	if gtab then
		gtab:ClearAllPoints();
		gtab:SetPoint("TOPLEFT", GuildBankFrame, "TOPRIGHT", -1, -32);
	end
end

function wsPickUp:Expand()
	if not self.pickframe then return end

	self.pickframe:Show();
	local gtab = _G["GuildBankTab"..1];
	if gtab then
		gtab:ClearAllPoints();
		gtab:SetPoint("TOPLEFT", self.pickframe, "TOPRIGHT", -1, -32);
	end
end

function wsPickUp:OnInitialize(event, ...)
	local self = wsPickUp
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == "Blizzard_GuildBankUI" then
			self:CreateFrameHandle();
			if not self.pickframe then
				self:CreatePickFrame()
			end
		end
	end
end

wspickupHandle:SetScript("OnEvent", wsPickUp.OnInitialize);
wspickupHandle:RegisterEvent("ADDON_LOADED");
