local twQuery = CreateFrame("Frame");
twQuery.Ver = 1.0
local twQueryText

function twQuery:OnEnable(event, ...)
	addon = ...
	if event == "ADDON_LOADED" and addon == "Wowshell_Search" then
		if (not QueryDB) or (tonumber(QueryDB.version) < tonumber(twQuery.Ver)) then
			QueryDB = {}
			QueryDB.version = twQuery.Ver
		end
		self:CreatePopupStaticWindow()
		--target info button
		self:CreateTargetInfoButton()
		--quest query
		self:CreateQuestQueryButton()
		--register event
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
	elseif event == "PLAYER_TARGET_CHANGED" then
		if not self.TargetQueryButton then return end
		local unitName = UnitName("target")
		if (not UnitIsPlayer("target")) and (not UnitPlayerControlled("target")) and unitName ~= UNKNOWNOBJECT then
			self.TargetQueryButton:Show()
		else
			self.TargetQueryButton:Hide()
		end
	end
end

function twQuery:CreatePopupStaticWindow()
	if not self.QueryFrame then
		local frame = CreateFrame("Frame", "PopupStaticWindow", UIParent);
		frame:SetToplevel(true)
		frame:SetFrameStrata("DIALOG");
		frame:EnableMouse(true)
		

		frame:SetWidth(320);
		frame:SetHeight(120);
		
		local backdrop = {
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
			tile = false, tileSize = 16, edgeSize = 16,
			insets = { left = 4, right = 4, top = 4, bottom = 4 }
		}
		frame:SetBackdrop(backdrop);

		local text = frame:CreateFontString("PopupStaticWindowText", "ARTWORK", "GameFontHighlight");
		text:SetWidth(250);
		text:SetPoint("TOP", frame, "TOP", 0, -16);
		frame.text = text
		text:SetText("复制下面URL粘贴到IE中即可资料查询\n(Ctrl+C)")
		
		local closeButton = CreateFrame("Button", "PopupStaticWindowCloseButton", frame, "UIPanelCloseButton");
		closeButton:SetPoint("TOPRIGHT", -3, -3)

		--edit box
		local editbox = CreateFrame("EditBox", "PopupStaticWindowEditBox", frame);
		editbox:SetHistoryLines(1)
		editbox:SetWidth(250);
		editbox:SetHeight(64);
		editbox:SetPoint("CENTER", 0, -16);
		editbox:SetFontObject(ChatFontNormal)

		local left = editbox:CreateTexture(nil, "BACKGROUND");
		left:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left");
		left:SetTexCoord(0, 1, 0, 1)
		left:SetWidth(256);
		left:SetHeight(32);
		left:SetPoint("LEFT", editbox, "LEFT", -10, 0)
		
		local right = editbox:CreateTexture(nil, "BACKGROUND");
		right:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Right");
		right:SetTexCoord(0.70703125, 1, 0, 1)
		right:SetWidth(75)
		right:SetHeight(32);
		right:SetPoint("RIGHT", editbox, "RIGHT", 10, 0);

		local lable = editbox:CreateTexture(nil, "BACKGROUND");
		lable:SetTexture("Interface\\ChatFrame\\UI-ChatInputBorder-Left");
		lable:SetTexCoord(0.29296875, 1, 0, 1);
		lable:SetWidth(5)
		lable:SetHeight(32)
		lable:SetPoint("LEFT", left, "RIGHT", 0, 0)
		lable:SetPoint("RIGHT", right, "LEFT", 0, 0)
		
		editbox:SetScript("OnTextChanged", function(self)
			if (twQueryText) then
				self:SetText(twQueryText)
				self:HighlightText()
			end
		end)
		
		editbox:SetScript("OnEnterPressed", function(self)
			HideUIPanel(self:GetParent())
		end)

		editbox:SetScript("OnEscapePressed", function(self)
			HideUIPanel(self:GetParent())
		end)
		frame.editbox = editbox
		-----
		frame:SetPoint("TOP", UIParent, "TOP", 0, -228)
		self.QueryFrame = frame
	end
	self.QueryFrame:Hide()
end

function twQuery:CreateTargetInfoButton()
	if not self.TargetQueryButton then

		local button = CreateFrame("BUTTON", "TargetInfoQueryButton", TargetFrame);
		--button:SetWidth(179)
		--button:SetHeight(40);
		button:SetWidth(24)
		button:SetHeight(24);
		button:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 0, 1)
        if(wsUnitFrame) then
            local target = wsUnitFrame and wsUnitFrame.units and wsUnitFrame.units.target
            if(target and target.ResetTargetInfoQueryButton) then
                target:ResetTargetInfoQueryButton()
            end
        end

		local mag = button:CreateTexture(nil, "BACKGROUND");
		mag:SetTexture("Interface\\WorldMap\\WorldMap-MagnifyingGlass");
		mag:SetWidth(24);
		mag:SetHeight(24);
		mag:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2);

		--[[local text = button:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall");
		text:SetPoint("TOPLEFT", button, "TOPLEFT", 26, -5);
		text:SetTextHeight(12)
		text:SetText("查询目标资料");
		button.text = text]]
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText("点击查询");
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)

		self.TargetQueryButton = button
		button:Hide()
	end
	self.TargetQueryButton:SetScript("OnClick", function(self)
		local guid = UnitGUID("target");
		local gid = string.sub(guid, 7, 10);
		local id = tonumber(gid, 16)
		twQuery:PopWindow(id, "target")
	end)
end

function twQuery:CreateQuestQueryButton()
	if not self.QuestQueryButton then
		local button = CreateFrame("BUTTON", "QuestQueryButton", QuestLogDetailScrollChildFrame);
		button:SetToplevel(true)
		button:SetWidth(30);
		button:SetHeight(22)
		button:SetPoint("TOPRIGHT", QuestLogDetailScrollChildFrame, "TOPRIGHT", -45, -5)
		local mag = button:CreateTexture(nil, "BACKGROUND");
		mag:SetTexture("Interface\\WorldMap\\WorldMap-MagnifyingGlass")
		mag:SetWidth(22)
		mag:SetHeight(22)
		mag:SetPoint("TOPLEFT", button, "TOPLEFT", 2, 0)
		
		button:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText("点击查询");
			GameTooltip:Show()
		end)
		button:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		self.QuestQueryButton = button
	end

	self.QuestQueryButton:SetScript("OnClick", function(self) 
		--获取任务id
		local uid = GetQuestLogSelection()
		local unique_id = tonumber(string.match(GetQuestLink(uid), 'quest:(%d+)'))
		--print(unique_id)
		twQuery:PopWindow(unique_id, "quest")
	end)
end

--pop
function twQuery:PopWindow(name, type)
	if not name then return end
	if not self.QueryFrame then return end

	if type == "target" then
		twQueryText = nil
		twQueryText = "http://db.wowshell.com/npc="..name;
	elseif type == "quest" then
		twQueryText = nil
		twQueryText = "http://db.wowshell.com/quest="..name;
	end

	--method
	self.QueryFrame.editbox:SetText(twQueryText)
	self.QueryFrame.editbox:HighlightText()
	self.QueryFrame.editbox:Show()
	self.QueryFrame:Show()
end

--handler evnet
twQuery:RegisterEvent("ADDON_LOADED");
twQuery:SetScript("OnEvent", function(self, event, ...) twQuery:OnEnable(event, ...) end)
