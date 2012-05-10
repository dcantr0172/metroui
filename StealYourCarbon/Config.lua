
local myname, ns = ...
local L = setmetatable(GetLocale() == 'zhTW' and {
    ["Steal Your Carbon"] = "自動補購",
    ["To add an item drop it in the frame below or type '/carbon add [Item Link] 20'.  Shift-click an arrow to add/remove a full stack.  Set the quantity to 0 to remove the item."] = "你可以拖曳物品到下面的方框里或者使用/carbon add [Item Link] <數量>命令來增加自動補充的物品.  Shift-點擊 來增加/減少一整個堆疊. 數量設置為0可以移除這個物品.",
	["Upgrade water"] = "自動升級水",
    ["Automatically upgrade to better water as player levels."] = "自動按等級升級水.",
	["Chat feedback"] = "聊天反饋",
    ["Give chat feedback when purchasing items."] = "購買物品時在聊天框顯示相關信息.",
    ['normaltext'] = '購買列表, 請拖動物品到按鈕上',
    ["Stack Size: "] = "堆疊: ",
    ["Stack Size: 20"] = "堆疊: 20",
} or GetLocale() == 'zhCN' and {
    ["Steal Your Carbon"] = "自动补购",
    ["To add an item drop it in the frame below or type '/carbon add [Item Link] 20'.  Shift-click an arrow to add/remove a full stack.  Set the quantity to 0 to remove the item."] = "你可以拖曳物品到下面的方框里或者使用/carbon add [Item Link] <数量>命令来增加自动补充的物品. Shift-点击来增加/减少一整个堆叠. 数量设置为0可以移除这个物品.",
    ["Upgrade water"] = "自动升级水",
    ["Automatically upgrade to better water as player levels."] = "自动按等级升级水.",
    ["Chat feedback"] = "聊天反馈",
    ["Give chat feedback when purchasing items."] = "购买物品时在聊天框显示相关信息.",
    ['normaltext'] = '购买列表, 请拖动物品到按钮上',
    ["Stack Size: "] = "堆叠: ",
    ["Stack Size: 20"] = "堆叠: 20",
} or {}, {__index = function(t, i) return i end})

local NUMROWS, NUMCOLS, ICONSIZE, ICONGAP, GAP, EDGEGAP = ns.IHASCAT and 6 or 5, 10, 32, 3, 8, 16
local tekcheck = LibStub("tekKonfig-Checkbox")
local rows, offset, scrollbar, tradeview, grouptext = {}, 0
--local normaltext, tradetext = L["These items are only restocked if you are NOT carrying a tradeskill bag.  They will also restock from the bank."], L["These items are only restocked if you are carrying a tradeskill bag.  Bank restocking will not take place."]


--if AddonLoader and AddonLoader.RemoveInterfaceOptions then AddonLoader:RemoveInterfaceOptions("Steal Your Carbon") end

local frame = CreateFrame("Frame", "StealYourCarbonConfig", InterfaceOptionsFramePanelContainer)
frame.name = L["Steal Your Carbon"]
frame:SetScript("OnShow", function(frame)
	local tektab = LibStub("tekKonfig-TopTab")
	local StealYourCarbon = StealYourCarbon
	local title, subtitle = LibStub("tekKonfig-Heading").new(frame, L["Steal Your Carbon"], L["To add an item drop it in the frame below or type '/carbon add [Item Link] 20'.  Shift-click an arrow to add/remove a full stack.  Set the quantity to 0 to remove the item."])


	local upgradewater = tekcheck.new(frame, nil, L["Upgrade water"], "TOPLEFT", subtitle, "BOTTOMLEFT", -2, -GAP)
	local checksound = upgradewater:GetScript("OnClick")
	upgradewater.tiptext = L["Automatically upgrade to better water as player levels."]
	upgradewater:SetScript("OnClick", function(self) checksound(self); StealYourCarbon.db.upgradewater = not StealYourCarbon.db.upgradewater end)
	upgradewater:SetChecked(StealYourCarbon.db.upgradewater)


	local chatter = tekcheck.new(frame, nil, L["Chat feedback"], "TOP", upgradewater, "TOP")
	chatter:SetPoint("LEFT", frame, "TOP", GAP, 0)
	chatter.tiptext = L["Give chat feedback when purchasing items."]
	chatter:SetScript("OnClick", function(self) checksound(self); StealYourCarbon.db.chatter = not StealYourCarbon.db.chatter end)
	chatter:SetChecked(StealYourCarbon.db.chatter)


	local group = LibStub("tekKonfig-Group").new(frame, nil, "TOP", upgradewater, "BOTTOM", 0, -EDGEGAP-GAP)
	group:SetPoint("LEFT", EDGEGAP, 0)
	group:SetPoint("BOTTOMRIGHT", -EDGEGAP, EDGEGAP)

--	local tab1 = tektab.new(frame, "Normal", "BOTTOMLEFT", group, "TOPLEFT", 0, -4)
--	local tab2 = tektab.new(frame, "Tradeskill", "LEFT", tab1, "RIGHT", -15, 0)
--	tab2:Deactivate()
--	tab1:SetScript("OnClick", function(self)
--		self:Activate()
--		tab2:Deactivate()
--		tradeview = false
--		StealYourCarbon:UpdateConfigList()
--	end)
--	tab2:SetScript("OnClick", function(self)
--		self:Activate()
--		tab1:Deactivate()
--		tradeview = true
--		StealYourCarbon:UpdateConfigList()
--	end)
--
	grouptext = group:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	grouptext:SetHeight(32)
	grouptext:SetPoint("TOPLEFT", group, "TOPLEFT", EDGEGAP, -EDGEGAP)
	grouptext:SetPoint("RIGHT", group, -EDGEGAP-16, 0)
	grouptext:SetNonSpaceWrap(true)
	grouptext:SetJustifyH("LEFT")
	grouptext:SetJustifyV("TOP")
	grouptext:SetText(L["normaltext"])


	local function OnReceiveDrag()
		local infotype, itemid, itemlink = GetCursorInfo()
		local stocklist = --[[tradeview and StealYourCarbon.db.tradestocklist or]] StealYourCarbon.db.stocklist
		if infotype == "item" then stocklist[itemid] = select(8, GetItemInfo(itemid))
		elseif infotype == "merchant" then
			local itemlink = GetMerchantItemLink(itemid)
			itemid = tonumber(itemlink:match("item:(%d+):"))
			stocklist[itemid] = select(8, GetItemInfo(itemid))
		end
		StealYourCarbon:UpdateConfigList()
		return ClearCursor()
	end
	local function OnClick(self)
		PlaySound("UChatScrollButton")
		local diff = (self.up and 1 or -1) * (IsShiftKeyDown() and select(8, GetItemInfo(self.row.id)) or 1)
		local stocklist = --[[tradeview and StealYourCarbon.db.tradestocklist or]] StealYourCarbon.db.stocklist
		stocklist[self.row.id] = stocklist[self.row.id] + (diff)
		if stocklist[self.row.id] <= 0 then
			stocklist[self.row.id] = 0
			self.row.down:Disable()
		else self.row.down:Enable() end
		self.row.count:SetText(stocklist[self.row.id])
	end
	local function OnClick2() if CursorHasItem() then OnReceiveDrag() end end
	local function ShowTooltip(self)
		if not self.row.id then return end
		local _, link = GetItemInfo(self.row.id)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(link)
	end
	local function HideTooltip() GameTooltip:Hide() end
	for i=1,NUMROWS*2 do
		local row = CreateFrame("Frame", nil, group)
		if i == 1 then row:SetPoint("TOP", grouptext, "BOTTOM", 0, -GAP/2)
		elseif i%2 == 0 then row:SetPoint("TOP", rows[i-1], "TOP")
		else row:SetPoint("TOP", rows[i-1], "BOTTOM", 0, -6) end
		if i%2 == 1 then
			row:SetPoint("LEFT", group, EDGEGAP, 0)
			row:SetPoint("RIGHT", group, "CENTER", -GAP/2-16, 0)
		else
			row:SetPoint("LEFT", group, "CENTER", GAP/2-16, 0)
			row:SetPoint("RIGHT", group, -EDGEGAP-16, 0)
		end
		row:SetHeight(ICONSIZE)

		local iconbutton = CreateFrame("Button", nil, row)
		iconbutton:SetPoint("TOPLEFT")
		iconbutton:SetWidth(ICONSIZE)
		iconbutton:SetHeight(ICONSIZE)
		iconbutton.row = row
		iconbutton:SetScript("OnEnter", ShowTooltip)
		iconbutton:SetScript("OnLeave", HideTooltip)
		iconbutton:SetScript("OnReceiveDrag", OnReceiveDrag)
		iconbutton:SetScript("OnClick", OnClick2)

		local buttonback = iconbutton:CreateTexture(nil, "ARTWORK")
		buttonback:SetTexture("Interface\\Buttons\\UI-Quickslot2")
		buttonback:SetPoint("CENTER")
		buttonback:SetWidth(ICONSIZE*64/37) buttonback:SetHeight(ICONSIZE*64/37)

		local icon = iconbutton:CreateTexture(nil, "ARTWORK")
		icon:SetAllPoints()

		local count = iconbutton:CreateFontString(nil, "ARTWORK", "NumberFontNormal")
		count:SetPoint("BOTTOMRIGHT", -2, 2)

		local up = CreateFrame("Button", nil, row)
		up:SetPoint("TOPLEFT", icon, "TOPRIGHT", -6, 7)
		up:SetWidth(ICONSIZE/2 + 12) up:SetHeight(ICONSIZE/2 + 14)
		up:SetHitRectInsets(6, 6, 7, 7)
		up:SetNormalTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Up")
		up:SetPushedTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Down")
		up:SetHighlightTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollUpButton-Highlight")
		up:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled")
		up:GetHighlightTexture():SetBlendMode("ADD")
		up.row = row
		up.up = true
		up:SetScript("OnClick", OnClick)

		local down = CreateFrame("Button", nil, row)
		down:SetPoint("TOPLEFT", up, "BOTTOMLEFT", 0, 14)
		down:SetWidth(ICONSIZE/2 + 12) down:SetHeight(ICONSIZE/2 + 14)
		down:SetHitRectInsets(6, 6, 7, 7)
		down:SetNormalTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Up")
		down:SetPushedTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Down")
		down:SetHighlightTexture("Interface\\MainMenuBar\\UI-MainMenu-ScrollDownButton-Highlight")
		down:SetDisabledTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled")
		down:GetHighlightTexture():SetBlendMode("ADD")
		down.row = row
		down:SetScript("OnClick", OnClick)

		local name = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		name:SetPoint("TOPLEFT", up, "TOPRIGHT", GAP-6, -7)
		name:SetPoint("RIGHT", row)
		name:SetJustifyH("LEFT")

		local stack = row:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		stack:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -2)
		stack:SetPoint("RIGHT", row)
		stack:SetJustifyH("LEFT")
		stack:SetText(L["Stack Size: 20"])

		rows[i], row.icon, row.count, row.name, row.stack, row.down, row.up = row, icon, count, name, stack, down, up
	end

	scrollbar = LibStub("tekKonfig-Scroll").new(group, 6, 1)

	local f = scrollbar:GetScript("OnValueChanged")
	scrollbar:SetScript("OnValueChanged", function(self, value, ...)
		offset = math.floor(value)*2
		StealYourCarbon:UpdateConfigList()
		return f(self, value, ...)
	end)

	frame:EnableMouseWheel()
	frame:SetScript("OnMouseWheel", function(self, val) scrollbar:SetValue(scrollbar:GetValue() - val) end)
	frame:SetScript("OnShow", function() StealYourCarbon:UpdateConfigList() end)
	frame:SetScript("OnHide", function()
		local stocklist = tradeview and StealYourCarbon.db.tradestocklist or StealYourCarbon.db.stocklist
		for i,v in pairs(stocklist) do if v == 0 then stocklist[i] = nil end end
	end)
	StealYourCarbon:UpdateConfigList()
	scrollbar:SetValue(0)
end)


function StealYourCarbon:UpdateConfigList()
	--grouptext:SetText(tradeview and tradetext or normaltext)
	local items = 0
	local stocklist = --[[tradeview and StealYourCarbon.db.tradestocklist or]] StealYourCarbon.db.stocklist
	for i in pairs(stocklist) do items = items + 1 end
	local maxoffset = math.ceil((items - NUMROWS*2 + 1)/2)
	scrollbar:SetMinMaxValues(0, math.max(maxoffset, 0))

	local emptyshown = false
	local id, qty = next(stocklist)
	for i=1,offset do id, qty = next(stocklist, id) end


	for _,row in ipairs(rows) do
		if id then
			row.id = id
			local _, link, _, _, _, _, _, stack = GetItemInfo(id)
			local texture = GetItemIcon(id)
			row.icon:SetTexture(texture)
			row.up:Enable()
			if qty == 0 then row.down:Disable() else row.down:Enable() end
			row.count:SetText(qty)
			row.name:SetText(link)
			row.stack:SetText(L["Stack Size: "]..(stack or "???"))
			row.icon:Show()
			row:Show()
			id, qty = next(stocklist, id)
		elseif not emptyshown then
			emptyshown = true
			row.id = nil
			row.icon:Hide()
			row.count:SetText()
			row.name:SetText()
			row.stack:SetText()
			row.up:Disable()
			row.down:Disable()
			row:Show()
		else
			row:Hide()
		end
	end
end


StealYourCarbon.configframe = frame
InterfaceOptions_AddCategory(frame)


--LibStub("tekKonfig-AboutPanel").new("Steal Your Carbon", "StealYourCarbon")


local orig = IsOptionFrameOpen
function IsOptionFrameOpen(...)
	if not frame:IsVisible() then return orig(...) end
end
