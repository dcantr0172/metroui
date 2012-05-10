---------------------------------------------
-- FriendMenu Exchant Addon
-- 代码思路参考 WarBabyWoW 的FriendMenuXP
-- $Date: 2010-06-23 13:17:42 +0800 (Wed, 23 Jun 2010) $
-- $Revision: 3236 $
-- $LastChangedBy: 月色狼影 $
---------------------------------------------
wsFRIENDMENU_MANBUTTONS = 20;
tinsert(UIMenus, "wsFriendMenu");
tinsert(UIMenus, "wsFriendMenuSecure");
local wsFrame = CreateFrame("Frame", "wsFriendFrame");
local locales = {
	zhCN = {
		addFriends = "添加好友",
		copy = "复制",
		copyName = "实用Ctrl+C复制玩家名字",
		mailList = "邮件列表",
		toMailList = "已加入邮件列表",
		who = "查询",
		guildAdd = "邀请入会",
	},
	zhTW = {
		addFriends = "添加好友",
		copy = "複製",
		copyName = "使用Ctrl+C複製玩家姓名",
		mailList = "郵件列表",
		toMailList = "已加入郵件列表",
		who = "查詢",
		guildAdd = "邀請入會",
	},
	enUS = {
		addFriends = true,
		copy = true,
		copyName = true,
		mailList = true,
		toMailList = true,
		who = true,
		guildAdd = true,

	},
}

local L = locales[GetLocale()]

-- The current open menu
local wsFriendMenu_open_menu = nil;
wsFriendFrame.wsFriendMenu_open_menu = wsFriendMenu_open_menu
-- The current menu being initialized
local wsFriendMenu_init_menu = nil;
wsFriendFrame.wsFriendMenu_init_menu = wsFriendMenu_init_menu

local wsFriendMenuDelegate = CreateFrame("Frame");
wsFriendFrame.wsFriendMenuDelegate = wsFriendMenuDelegate;
local function wsFriendMenuDelegate_OnAttributeChanged (self, attribute, value)
	if ( attribute == "createframes" and value == true ) then
		UIDropDownMenu_CreateFrames(self:GetAttribute("createframes-level"), self:GetAttribute("createframes-index"));
	elseif ( attribute == "initmenu" ) then
		UIDROPDOWNMENU_INIT_MENU = value;
	elseif ( attribute == "openmenu" ) then
		UIDROPDOWNMENU_OPEN_MENU = value;
	end
end
wsFriendMenuDelegate:SetScript("OnAttributeChanged", wsFriendMenuDelegate_OnAttributeChanged);

local wsFriendMenu_ButtonInfo = {}
local wsFriendMenu_SecureInfo = {}
function wsFriendMenu_CreateInfo()
	local info;
	local secure = issecure();

	if secure then
		info = wsFriendMenu_SecureInfo
	else
		info = wsFriendMenu_ButtonInfo
	end

	for k, v in pairs(info) do
		info[k] = nil
	end
	return info
end

function wsFriendMenu_AddButton(dropdownframe, info, level)
	if not level then level = 1 end
	
	local dropdownframeName
	if level > 1 then
		dropdownframeName = dropdownframe:GetName()..level;
	else
		dropdownframeName = dropdownframe:GetName();
	end
	
	local index = dropdownframeName and dropdownframe.numButtons + 1 or 1
	local width;

	dropdownframe.numButtons = index

	local button = getglobal(dropdownframeName.."Button"..index);
	if (not button) then return end;
	local normalText = getglobal(button:GetName().."NormalText");
	local icon = getglobal(button:GetName().."Icon");
	local invisibleButton = getglobal(button:GetName().."InvisibleButton");

	button:SetDisabledFontObject(GameFontDisableSmallLeft);
	invisibleButton:Hide()
	button:Enable();
	
	if (info.notClickable) then
		info.disabled = 1;
		button:SetDisabledFontObject(GameFontHighlightSmallLeft);
	end

	if (info.isTitle) then
		info.disabled = 1
		button:SetDisabledFontObject(GameFontNormalSmallLeft);
	end

	if ( info.disabled ) then
		button:Disable();
		invisibleButton:Show();
		info.colorCode = nil;
	end

	if (info.text) then
		if (info.colorCode) then
			button:SetText(info.colorCode..info.text.."|r");
		else
			button:SetText(info.text);
		end
		width = normalText:GetWidth() + 40;
		
		if (info.hasArrow or info.hasColorSwatch) then
			width = width + 15
		end
		if (info.notCheckable) then
			width = width - 20
		end
		if (info.icon) then
			icon:SetTexture(info.icon);
			if ( info.tCoordLeft ) then
				icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
			else
				icon:SetTexCoord(0, 1, 0, 1);
			end
			icon:Show();
			width = width + 10;
		else
			icon:Hide();
		end

		if (width > dropdownframe.maxWidth) then
			dropdownframe.maxWidth = width;
		end

		if (info.fontObject) then
			
		else
			button:SetNormalFontObject(GameFontHighlightSmallLeft);
			button:SetHighlightFontObject(GameFontHighlightSmallLeft);
		end
	else
		button:SetText("");
		icon:Hide();
	end
	
	--[[local enable = 1
	if (info.dist and info.dist > 0) then
		if (dropdownframe.unit) then
			if ( not CheckInteractDistance(dropdownframe.unit, info.dist) ) then
				enable = 0;
			end
		end
	end]]
		
	-- Pass through attributes
	button.func = info.func;
	button.owner = info.owner;
	button.hasArrow = info.hasArrow;
	button.notCheckable = info.notCheckable;
	button.tooltipTitle = info.tooltipTitle;
	button.tooltipText = info.tooltipText;

	if ( info.value ) then
		button.value = info.value;
	elseif ( info.text ) then
		button.value = info.text;
	else
		button.value = nil;
	end

	-- Show the expand arrow if it has one
	if ( info.hasArrow ) then
		_G[dropdownframeName.."Button"..index.."ExpandArrow"]:Show();
	else
		_G[dropdownframeName.."Button"..index.."ExpandArrow"]:Hide();
	end
	button.hasArrow = info.hasArrow;
		
	--设定鼠标显示位置
	local xPos=5;
	local yPos=-((button:GetID()-1) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT;
	normalText:ClearAllPoints();
	if ( info.notCheckable ) then
		if (info.justifyH and info.justifyH == "CENTER") then
			normalText:SetPoint("CENTER", button, "CENTER", -7, 0);
		else
			normalText:SetPoint("LEFT", button, "LEFT", 0, 0);
		end
		xPos = xPos + 10
	else
		xPos = xPos + 12;
		normalText:SetPoint("LEFT", button, "LEFT", 20, 0);
	end

	-- Adjust offset if displayMode is menu
	if ( not info.notCheckable ) then
		xPos = xPos - 6;
	end

	button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);
	button:UnlockHighlight();
	
	if (button.attributes and button.attributes ~= "") then
		local att = {strsplit(";", button.attributes)};
		for _, v in pairs(att) do
			if (v and v~="") then
				button:SetAttribute(v, nil)
			end
		end
	end

	button.attributes = "";
	if (info.isSecure and info.attributes) then
		local atts = gsub(info.attributes,"%$name%$", dropdownframe.name);
		local spiltAtt = {strsplit(";", atts)};
		for k, v in pairs(spiltAtt) do
			if (v and v ~= "") then
				local att, val = strsplit(":", v);
				if (att and att~="" and val and val~="") then
					button:SetAttribute(strtrim(att), strtrim(val));
					button.attributes = button.attributes..strtrim(att)..";";
				end
			end
		end
	end
	
	-- Checked can be a function now
	local checked = info.checked;
	if ( type(checked) == "function" ) then
		checked = checked();
	end
	-- Show the check if checked
	if ( checked ) then
		button:LockHighlight();
		_G[dropdownframeName.."Button"..index.."Check"]:Show();
	else
		button:UnlockHighlight();
		_G[dropdownframeName.."Button"..index.."Check"]:Hide();
	end
	button.checked = info.checked;

	--show
	dropdownframe:SetHeight((index * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2))
	button:Show();
end

---wsFriend
local function SelfUnShow(name)
	return UnitName("player") ~= name
end
local wsButtonInfo = {}
wsButtonInfo["WHISPER"] = {
	text = WHISPER,
	dist = 0,
	func = function(name) ChatFrame_SendTell(name); end,
}
wsButtonInfo["INVITE"] = {
	text = INVITE,
	dist = 0,
	func = function(name) InviteUnit(name); end,
	show = SelfUnShow,
}
wsButtonInfo["TARGET"] = {
	text = TARGET,
	isSecure = 1,
	dist = 0,
	attributes = "type:macro;  macrotext: /targetexact $name$",
}
wsButtonInfo["IGNORE"] = {
	text = IGNORE,
	show = SelfUnShow,
	dist = 0,
	func = function(name) AddOrDelIgnore(name); end,
}
wsButtonInfo["REPORT_SPAM"]={
	text = REPORT_SPAM,
	dist = 0,
	func = function(name, flags)
		local dialog = StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", name);
		if (dialog) then
			dialog.data = flags.lineID;
		end
	end,
	show = function(name, flags) return flags.lineID and CanComplainChat(flags.lineID) end
}
wsButtonInfo["FRIEND"]={
	text = L["addFriends"],
	dist = 0,
	func = function(name) AddFriend(name) end,
	show = function(name)
		if (name == UnitName("player")) then return; end
		for i=1, GetNumFriends() do
			if (name == GetFriendInfo(i)) then
				return nil
			end
		end
		return 1;
	end
}
wsButtonInfo["REMOVE_FRIEND"] = {
    text = REMOVE_FRIEND,
	dist = 0,
    func = function(name) RemoveFriend(name)  end,
    show = function(name)
        if (name == UnitName("player")) then return; end
	for i=1, GetNumFriends() do
	    if (name == GetFriendInfo(i)) then
		return 1 
	    end
	end
	return nil;
    end
}
wsButtonInfo["COPY"] = {
	text = L["copy"],
	dist = 0,
	func = function(name)
		getglobal("wsCopyPopupFrameText"):SetText(L["copyName"]);
		getglobal("wsCopyPopupFrameEditBox"):SetText(name);
		getglobal("wsCopyPopupFrameEditBox"):HighlightText();
		getglobal("wsCopyPopupFrameEditBox"):Show();
		getglobal("wsCopyPopupFrame"):Show();
	end,
}
wsButtonInfo["MAIL"]={
	text = L["mailList"],
	dist = 0,
	func = function(name)
		local EasyMail = LibStub("AceAddon-3.0"):GetAddon("EasyMail");
		local db = EasyMail.db.char.mailList
		for k=1, #db do
			if name == db[k] then return end
		end
		table.insert(db, name);
		wsPrint(name..L["toMailList"])
	end,
	show = function(name)
		if (not IsAddOnLoaded("Wowshell_EasyMail")) and (UnitName("player") == name) then
			return nil
		end
		return 1;
	end,
}
wsButtonInfo["GUILD_LEAVE"]={
	text = GUILD_LEAVE,
	dist = 0,
	func = function(name) StaticPopup_Show("CONFIRM_GUILD_LEAVE", GetGuildInfo("player")); end,
	show = function(name)
		if (name ~= UnitName("player") or (GuildFrame and not GuildFrame:IsShown())) then return end;
		return 1;
	end
}
wsButtonInfo["GUILD_PROMOTE"] ={
	text = GUILD_PROMOTE,
	dist = 0,
	func = function(name)
		local dialog = StaticPopup_Show("CONFIRM_GUILD_PROMOTE", name);
		dialog.data = name;
	end;
	show = function(name)
		if ( not IsGuildLeader() or not UnitIsInMyGuild(name) or name == UnitName("player") or not GuildFrame:IsShown() ) then return	end
		return 1;
	end;
}
wsButtonInfo["WHO"]={
	text = L["who"],
	dist = 0,
	func = function(name) SendWho("n-"..name) end
}
wsButtonInfo["GUILD_ADD"]={
	text= L["guildAdd"],
	dist = 0,
	func= function(name) GuildInvite(name) end,
	show = function(name)
		return name ~= UnitName("player") and CanGuildInvite()
	end
}
wsButtonInfo["CANCEL"] = {
	text = CANCEL,
	dist = 0,
}
wsButtonInfo["SET_FOCUS"]={
	text = SET_FOCUS,
	dist = 0,
	isSecure = 1,
	attributes = "type1:macro;macrotext1:/focus $name$",
}
wsButtonInfo["CLEAR_FOCUS"]={
	text = CLEAR_FOCUS,
	dist = 0,
	isSecure = 1,
	attributes = "type1:macro;macrotext1:/clearfocus",
}
wsButtonInfo["ACHIEVEMENTS"]={
	text=COMPARE_ACHIEVEMENTS,
	dist = 1,
	func = function(name) InspectAchievements(name); end,
}
wsButtonInfo["TRADE"]={
	text=TRADE,
	isSecure = 1,
	dist = 2,
	attributes = "type:macro;macrotext:/targetexact $name$",
	func = function(name) InitiateTrade(name); end,
	show = function(name)
		if (name == UnitName("player")) then return; end
		if (UnitIsDeadOrGhost("player") or (not HasFullControl()) or UnitIsDeadOrGhost(name)) and (name==UnitName("player")) then
			return nil
		end
		return 1
	end,
}
wsButtonInfo['SetNote'] = {
    text = SET_NOTE,
    dist = 2,
    func = function ( name )
        FriendsFrame.NotesID = name
        StaticPopup_Show('SET_FRIENDNOTE', name)
        PlaySound('igCharactorInfoClose')
    end,
    show = function(name)
        if ( name == UnitName'player') then return end
        local i
        for i = 1, GetNumFriends() do
            local fname = GetFriendInfo(i)
            if(name == fname) then
                return true
            end
        end
    end,
}
--END **

local function SetOrHookScript(frame, scriptName, func)
	if (frame:GetScript(scriptName)) then
		frame:HookScript(scriptName, func)
	else
		frame:SetScript(scriptName, func)
	end
end

function wsFriendMenu_OnClick(self)
	local func = self.func
	if (func) then
		func(self:GetParent().name, self:GetParent().flags, self:GetParent(), self)
	end

	self:GetParent():Hide()
	if (getglobal("DropDownList1")) then
		DropDownList1:Hide()
	end
end

function wsFriendMenu_ShowDropdown(name, connected, lineID, chatType, chatFrame, friendsList)
        HideDropDownMenu(1);
        if ( connected or friendsList ) then
            if ( connected ) then
                if (InCombatLockdown()) then
					wsFriendMenu_ShowFrame(nil, nil, wsFriendMenu, name, connected, lineID)
				else
					wsFriendMenu_ShowFrame(nil, nil, wsFriendMenuSecure, name, connected, lineID)
				end
			else
                FriendsDropDown.displayMode = "MENU";
				FriendsDropDown.name = name;
				FriendsDropDown.friendsList = friendsList;
				FriendsDropDown.lineID = lineID;
				FriendsDropDown.chatType = chatType;
				FriendsDropDown.chatTarget = name;
				FriendsDropDown.chatFrame = chatFrame;
				FriendsDropDown.presenceID = nil;
				ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor");                
            end
        end
end

--FriendsFrame_ShowDropdown  name, connected, lineID, chatType, chatFrame, friendsList
function wsFriendMenu_ShowFrame(level, value, frame, name, connected, lineID, relativeFrame, buttonMode)
	if not level then
		level = 1
	end

	if ( not frame ) then
		tempFrame = button:GetParent();
	else
		tempFrame = frame;
	end
	
	if ( frame:IsShown() and (wsFriendMenu_open_menu == tempFrame) ) then
		frame:Hide();
	else
		frame.name = name;
		frame.connected = connected;
		frame.lineID = lineID;

		if (relativeFrame) then buttonMode = relativeFrame.buttonMode end
		if (not buttonMode) then buttonMode = "NORMAL" end
		frame.buttonMode = buttonMode

		FriendsMenu_Initialize(frame, buttonMode);

		local scale = UIParent:GetEffectiveScale();
		frame:SetScale(scale);

		frame:Hide()
		frame:ClearAllPoints();

		if (relativeFrame) then
			frame:SetPoint(relativeFrame:GetPoint(1))
			frame:Show()
			return;
		end

		_G[frame:GetName().."Backdrop"]:Hide();
		_G[frame:GetName().."MenuBackdrop"]:Show();

		local cursorX, cursorY = GetCursorPosition();
		cursorX, cursorY = cursorX/scale, cursorY/scale;
		frame:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX, cursorY);

		--检测dropdownFrame中的按钮数量
		if (frame.numButtons == 0) then
			return 
		end

		frame:Show();

		local x, y = frame:GetCenter();
		if (not x or not y) then
			frame:Hide()
			return;
		end

		local oscreenX, oscreenY;
		if ((y - frame:GetHeight()/2) < 0) then
			oscreenY = 1
		end

		if (frame:GetRight() > GetScreenWidth()) then
			oscreenX = 1
		end
		
		local anchorpoint;
		if (oscreenX and oscreenY ) then
			anchorpoint = "BOTTOMRIGHT"
		elseif (oscreenY) then
			anchorpoint = "BOTTOMLEFT"
		elseif (oscreenX) then
			anchorpoint = "TOPRIGHT"
		else
			anchorpoint = "TOPLEFT"
		end

		frame:ClearAllPoints()
		frame:SetPoint(anchorpoint, nil, "BOTTOMLEFT", cursorX, cursorY);
	end
end

function FriendsMenu_Initialize(dropdownframe, displayMode)
	local isInstance, instanceType = IsInInstance();
	local inparty = false;
	local inraid = false;

	if (GetNumPartyMembers() > 0) or (GetNumRaidMembers() >0) then
		inparty = true
	end

	if (GetNumPartyMembers() > 0) and (GetNumRaidMembers() >0) then
		inraid = true
	end

	local isAssistant = false
	if (IsRaidOfficer()) then
		isAssistant = true
	end

	local isInBattleground = false
	if (UnitInBattleground("player")) then
		isInBattleground = true
	end
	
	dropdownframe.flags = {
		["isInInstance"] = isInstance,
		["instanceType"] = instanceType,
		["isInParty"] = inparty,
		["isInRaid"] = inraid,
		["isAssistant"] = isAssistant,
		["isInBattleground"] = isInBattleground,
		["connected"] = dropdownframe.connected,
		["lineID"] = dropdownframe.lineID,
	}

	local button;
	dropdownframe.numButtons = 0
	dropdownframe.maxWidth = 0
	for b=1, wsFRIENDMENU_MANBUTTONS do
		button = getglobal(dropdownframe:GetName().."Button"..b);
		button:Hide();
	end
	
	dropdownframe:Hide()
	local info = wsFriendMenu_CreateInfo();
	info.text = dropdownframe.name
	info.isTitle = 1;
	info.notCheckable = 1;
	wsFriendMenu_AddButton(dropdownframe, info)

	local wsPopupMenu = {}
	
	wsPopupMenu["NORMAL"] = {
		"WHISPER",
		"INVITE",
		"TARGET",
		"IGNORE",
		"REPORT_SPAM",
		"WHO",
		"FRIEND",
		"REMOVE_FRIEND",
		"COPY",
		"MAIL",
		"GUILD_ADD",
		"GUILD_LEAVE",
		"GUILD_PROMOTE",
		"SET_FOCUS",
		"ACHIEVEMENTS",
		"TRADE",
		"CANCEL",
	}

	for _, v in pairs(wsPopupMenu[displayMode]) do
		info = wsButtonInfo[v];
		info.notCheckable = 1
		if (not info.show or info.show(dropdownframe.name, dropdownframe.flags, dropdownframe)) then
			if (not isSecure or strfind(dropdownframe:GetName(), "Secure")) then
				wsFriendMenu_AddButton(dropdownframe, info)
			end
		end
	end
end

--[[    execute code    ]]--
function wsFriendMenu_OnLoad(self)
	hooksecurefunc("FriendsFrame_ShowDropdown", wsFriendMenu_ShowDropdown)
	
	SetOrHookScript(getglobal("DropDownList1"), "OnHide", function()
		wsFriendMenu:Hide();
		if (not InCombatLockdown) then wsFriendMenuSecure:Hide() end
	end)
end

function wsFriendMenu_OnEvent(self, event, ...)
	if event == "PLAYER_LOGIN" then
		wsFriendMenu_OnLoad(self)
	elseif event == "PLAYER_REGEN_DISABLED" then
		if (wsFriendMenuSecure:IsVisible()) then
			wsFriendMenu_ShowFrame(nil, nil, wsFriendMenu, wsFriendMenuSecure.name, wsFriendMenuSecure.connected, wsFriendMenuSecure.lineID, wsFriendMenuSecure)
			wsFriendMenuSecure:Hide()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if (wsFriendMenu:IsVisible()) then
			wsFriendMenu_ShowFrame(nil, nil, wsFriendMenuSecure, wsFriendMenu.name, wsFriendMenu.connected, wsFriendMenu.lineID, wsFriendMenu)
			wsFriendMenu:Hide()
		end
	end
end

wsFrame:RegisterEvent("PLAYER_LOGIN");--onload
wsFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
wsFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
wsFrame:RegisterEvent("ADDON_LOADED");
wsFrame:SetScript("OnEvent", function(self, event, ...) wsFriendMenu_OnEvent(self, event, ...) end);
