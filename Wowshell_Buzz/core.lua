local addon,ns = ...
local tactial = ns.tactial
local tacFunc = ns.tacFunc
local statsFunc = ns.statsFunc

Buzz = LibStub("AceAddon-3.0"):NewAddon("Buzz", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0");
local L = wsLocale:GetLocale("Buzz");


local db
local defaults = {
	profile = {
		chatbar = true,--enable/disable chat bar;
		filter = true,--
		fwords = {
			L["金币"],
			L["代练"],
			L["金库"]
		},
		popup = false,--默认直接举报
		colorname = true,
		mousewheel = true,
        buzzicon = true, -- 聊天表情
        buzzchannel = true,
        chatbar_position_x = false, -- x & y to save the position
        chatbar_position_y = false,
        chatbar_userposition = false, -- let user choose
	}
}
local timer;

-- dummy func
local debug = function() end

local typeCheck = function(e, t)
    return type(e) == t
end

local options;
function Buzz:OnInitialize(event, addon)
	self.db = LibStub("AceDB-3.0"):New("BuzzDB", defaults)
	db = self.db.profile;
	--self:SetupOptions();

	self.moveable = false;
    ChatTypeInfo.WHISPER.sticky = 0

    self.friendList = {}
    self.guideList = {}

    if(IsLoggedIn()) then
        self:setup_tekDebug()
    else
        self:RegisterEvent('PLAYER_LOGIN', 'setup_tekDebug')
    end
end

function Buzz:setup_tekDebug()
    local debugf = tekDebug and tekDebug:GetFrame('wsBuzz')
    --print(debugf)
    if(debugf) then
        debug = function(...) debugf:AddMessage(strjoin(', ', tostringall(...))) end
    end
end


function Buzz:OnEnable()
	if db.filter then
		self:ChannelFilter();
	end
	self:ColorPlayersName();
	
	self:QuickChatButton();
	self:ChatTabEvent();
	self:Chat_EnableMouseWheel();
    self:EditBox_DisableArrowKeyMod();

    self:ToggleBuzzIcon()

    local simpleChat = GetCVar'useSimpleChat'
    if(db.buzzchannel and (simpleChat == '0')) then
        self:CreateFCF()
    end


    self:RegisterEvent('GUILD_ROSTER_UPDATE', 'UpdateGuideRosterList')
    self:RegisterEvent('FRIENDLIST_UPDATE', 'UpdateFriendList')
    GuildRoster() -- query the server
end

--function Buzz:OnDisable()
--end

function Buzz:UpdateFriendList()
    wipe(self.friendList)
    for i = 1, GetNumFriends() do
        local name = GetFriendInfo(i)
        table.insert(self.friendList, name)
    end
end

function Buzz:UpdateGuideRosterList()
    wipe(self.guideList)
    for i = 1, GetNumGuildMembers() do
        local name = GetGuildRosterInfo(i)
        table.insert(self.guideList, name)
    end
end

--local orig, prevReportTime, prevLineId, chatLines, chatPlayers, find, result = _G.COMPLAINT_ADDED, 0, 0, {}, {}, string.find, nil

local result, lastId
local storedChat, storedSender, storedSendTime, storedChannel = {}, {}, {}, {}
local maxStoreLines = 200

local function filter(chatFrame, event, msg, sender, language, channelString, target, flags, unknown1, channelNumber, channelName, unknown2, counter, guid)
    if(counter == lastId) then
        return result
    else
        lastId = counter
    end

    result = false
    local done = false

    for _, name in next, Buzz.friendList do
        if(name == sender) then
            done = true
            break
        end
    end

    if(not done) then
        for _, name in next, Buzz.guideList do
            if(name == sender) then
                done = true
            end
        end
    end

    if(done) then
        return result
    end

    msg = msg:lower()
		if strreplace then
			msg = strreplace(msg, ' ', '')
		else
			msg = gsub(msg, '%s+', '');
		end

    -- compare fword list
    for _, fword in next, db.fwords do
        if(strfind(msg, strlower(fword))) then
            debug('FWORD by', sender, 'channel: ', channelString, 'msg:', msg)
            result = true
            done = true
            break
        end
    end

    -- search stored chats
    if(not done) then
        local matchLine
        for linenum, prevLine in next, storedChat do
            if(prevLineId == msg) then
                if(storedSender[linenum] == sender) and storedSendTime[linenum] and (storedSendTime[linenum] - GetTime() < 2) then
                    debug('DUPLICATED by', sender, 'channel: ', channelString, 'msg: ', msg)
                    matchLine = linenum
                    result = true
                    done = true
                    break
                end
            end
        end

        if(matchLine and done) then
            if(#storedChat >= maxStoreLines) then
                local offset = #storedChat - maxStoreLines + 1
                table.remove(storedChat, offset)
                table.remove(storedSendTime, offset)
                table.remove(storedSender, offset)
                --table.remove(storedChannel, offset)
            end

            table.insert(storedChat, msg)
            table.insert(storedSendTime, GetTime())
            table.insert(storedSender, sender)
            --table.insert(storedChannel, channelString)
        end
    end

    return result

    --debug('chatFrame=', chatFrame:GetName(), 'event=', event, 'msg=', msg, 'sender=', sender, 'language=', language, 'channelString=', channelString, 'target=', target, 'flags=', flags, 'channelNumber=', channelNumber, 'channelName=', channelName, 'counter=', counter, 'guid=', guid)
    --debug('-----------------------')
    --[===[
	if lineId == prevLineId then
		return result
	else
		prevLineId = lineId;
		if event == "CHAT_MSG_CHANNEL" and channelId == 0 then
			result = nil
			return result
		end
		--Don't report ourself/friends
		if not _G.CanComplainChat(lineId) then
			result = nil
			return result
		end
		if UnitInRaid(player) or UnitInParty(player) then
			result = nil
			return result
		end
	end
	--print(msg)
	local str = msg;--orig msg
	--这里要处理 中文是否有问题
	msg = msg:lower();
	msg = strreplace(msg, " ", "") --Remove spaces
	msg = strreplace(msg, ",", ".") --Convert commas to periods
	--START: Art remover
	if find(msg, "^%p%p%p%p+$") then
		result = true
		return true
	end
	--5次喊话 将自动屏蔽
	for k,v in ipairs(chatLines) do
		if v == msg then
			for l,w in ipairs(chatPlayers) do
				if l == k and w == player then
					result = true return true
				end
			end
		end
		if k == 6 then table.remove(chatLines, 1) table.remove(chatPlayers, 1) end
	end
	table.insert(chatLines, msg)
	table.insert(chatPlayers, player)

	--屏蔽关键词
	for k, v in ipairs(db.fwords) do --Scan database
		if find(msg, v) then --Found a match
			--print("|cFF33FF99Buzz|r: ", v, " - ", str, player);
			local now = GetTime();
			if (now - prevReportTime) > 0.5 then
				prevReportTime = now
				--_G.COMPLAINT_ADDED = "|cFF33FF99Buzz|r: "..orig.." |Hplayer:"..player.."|h["..player.."]|h";
				--这里是否要弹出提示
--				if db.popup then
--					--_G.StaticPopupDialogs["CONFIRM_REPORT_SPAM_CHAT"].text = _G.REPORT_SPAM_CONFIRMATION .."\n\n".. strreplace(str, "%", "%%")
--					--local dialog = _G.StaticPopup_Show("CONFIRM_REPORT_SPAM_CHAT", player)
--					--dialog.data = lineId
--				else
--					--_G.ComplainChat(lineId)
--				end
			end
			result = true
			return true
		end
	end

	result = nil
    ]===]
end

local chatMsgChannels = {
    'CHAT_MSG_CHANNEL',
    'CHAT_MSG_SAY',
    'CHAT_MSG_YELL',
    'CHAT_MSG_WHISPER',
    'CHAT_MSG_EMOTE',
}

--频道过滤
function Buzz:ChannelFilter()
	--ChatFrame_AddMessageEventFilter (event, filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter);
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", filter)
--	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", filter)

    for _, chnl in next, chatMsgChannels do
        ChatFrame_AddMessageEventFilter(chnl, filter)
    end
end

--disable filter
function Buzz:RemoveChannelFilter()
    for _, channel in next, chatMsgChannels do
        ChatFrame_RemoveMessageEventFilter(channel, filter)
    end
	--ChatFrame_RemoveMessageEventFilter(event, filter)
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SAY", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_EMOTE", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_DND", filter);
--	ChatFrame_RemoveMessageEventFilter("CHAT_MSG_AFK", filter);
end

do
    local FCF_NAME = L['聊天通道']
    local CHANNELS = {
        'BATTLEGROUND',
        'BATTLEGROUND_LEADER',
        'BG_HORDE',
        'BG_ALLIANCE',
        'BG_NEUTRAL',
        'GUILD',
        'GUILD_OFFICER',
        'GUILD_ACHIEVEMENT',		
        'PARTY',
        'PARTY_LEADER',
        'RAID',
        'RAID_LEADER',
        'RAID_WARNING',
        'SAY',
        'WHISPER',
        'YELL',		
    }

    function Buzz:FindChatFrame(name)
        for i = 1, 10 do
            local f = _G[string.format('ChatFrame%dTab', i)]
            if f then
                --print(f:GetText(), i)
                if f:GetText() == name then
                    return i
                end
            end
        end
    end

    function Buzz:CreateFCF(force)
        local index = self:FindChatFrame(FCF_NAME)
        if(not index) then
            force = true
        end

        if(index) then
            local f = _G[string.format('ChatFrame%d', index)]
            if(f:IsShown()) then
                return
            end
        else
            FCF_OpenNewWindow(FCF_NAME)
            index = self:FindChatFrame(FCF_NAME)
        end

        if(not index) then
            return
        end

        local f = _G[string.format('ChatFrame%d', index)]

        if(force) then
            FCF_DockUpdate()
            ChatFrame_RemoveAllChannels(f)
            ChatFrame_RemoveAllMessageGroups(f)

            for k, v in next, CHANNELS, nil do
                ChatFrame_AddMessageGroup(f, v)
                local g = ChatTypeGroup[v]
                if(g) then
                    for j, l in next, g, nil do
                        ChatFrame_AddMessageEventFilter(l, function(frame, event, msg)
                            local tab = _G[frame:GetName() .. 'Tab']
                            if(tab and tab:GetText() == FCF_NAME) then
                                frame.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME
                                FCF_FlashTab(frame)
                            end
                        end)
                    end
                end
            end

            FCF_DockFrame(f, FCF_GetNumActiveChatFrames(), true)
            FCF_SelectDockFrame(ChatFrame1)
        end
    end

    function Buzz:RemoveFCF()
        local ind = self:FindChatFrame(FCF_NAME)
        if(ind) then
            local f = _G[string.format('ChatFrame%d', ind)]
            FCF_Close(f)

            f.isInitialized = 0
            FCF_SetTabPosition(f, 0)
            ChatFrame_RemoveAllChannels(f)
            ChatFrame_RemoveAllMessageGroups(f)
            FCF_UnDockFrame(f)
            UIParent_ManageFramePositions()
            HideUIPanel(f)
            _G[f:GetName() .. 'Tab']:Hide()
        end
    end
end

function Buzz:EditBox_DisableArrowKeyMod()
    for i = 1, NUM_CHAT_WINDOWS do
        local cf = _G['ChatFrame' .. i]
        local eb = _G['ChatFrame' ..i.. 'EditBox']
        if(eb) then
            eb:SetAltArrowKeyMode(false)
        end
    end
    local eb = _G['ChatFrameEditBox']
    if(eb) then
        eb:SetAltArrowKeyMode(false)
        --eb:ClearAllPoints()
        --eb:SetPoint('TOPLEFT', ChatFrame1, 'BOTTOMLEFT', -5, -28)
    end
end

--color name
function Buzz:ColorPlayersName()
	if db.colorname then
		for k, v in pairs(ChatTypeInfo) do
			SetChatColorNameByClass(k, true)
		end
	else
		for k, v in pairs(ChatTypeInfo) do
			SetChatColorNameByClass(k, false)
		end
	end
end

do
    local NUM_SCROLL_LINES = 5
    local function onMouseWheel(self, delta)
        if delta > 0 then
            if IsShiftKeyDown() then
                self:ScrollToTop()
            elseif IsControlKeyDown() then
                --self:PageUp()
                for i = 1, NUM_SCROLL_LINES do self:ScrollUp() end
            else
                self:ScrollUp()
            end
        elseif delta < 0 then
            if IsShiftKeyDown() then
                self:ScrollToBottom()
            elseif IsControlKeyDown() then
                for i = 1, NUM_SCROLL_LINES do self:ScrollDown() end
            else
                self:ScrollDown();
            end
        end
    end

    function Buzz:Chat_EnableMouseWheel()
        for i =1 , NUM_CHAT_WINDOWS do
            frame = _G[format("ChatFrame%d", i)];

            --if(db.mousewheel) then
                frame:EnableMouseWheel(true);
                frame:SetScript("OnMouseWheel", onMouseWheel)
            --else
            --    frame:EnableMouseWheel(false)
            --    frame:SetScript('OnMouseWheel', nil)
            --end
        end
    end
end

--快捷键
local hiddenButtons = {};
local shownButtons = {};
local chatTypes;
local ChatTab_OnClick;

--use chatbar func
local function UseChatType(chatType, target)
	local chatFrame = SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME;
	local editBox = chatFrame.editBox;
	local chatType, channelIndex = string.gmatch(chatType, "([^%d]*)([%d]*)$")();
		if chatType == "WHISPER" then
		ChatFrame_ReplyTell(chatFrame);
		if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
			ChatFrame_OpenChat(target and "/w "..target or "/w ", chatFrame);
		end
		ChatEdit_UpdateHeader(editBox);
		
	elseif chatType == "CHANNEL" then
		if target then
			if type(target) == "string" then
				target = GetChannelName(target);
			end
		elseif channelIndex then
			target = tonumber(channelIndex);
		else
			return
		end
		--[[ChatEdit_ActivateChat(editBox)]]
		editBox:Show();
        editBox:SetAttribute("chatType", "CHANNEL");
		editBox:SetAttribute("channelTarget", target)
		ChatEdit_UpdateHeader(editBox);
		
	elseif chatType then
		--ChatEdit_ActivateChat(editBox)
		editBox:Show();
		editBox:SetAttribute("chatType", chatType);
		ChatEdit_UpdateHeader(editBox);
	end
    editBox:SetFocus()
end

function ChatTab_OnClick(self, button, target)
	local chatType = chatTypes[self.chatID].type;
	UseChatType(chatType, target);
end

local function ChatTab_ChannelShow(index)
	local channelNum, channelName = GetChannelName(index);
	if channelNum ~= 0 then
		return not hiddenButtons[channelName];
	end
end

local tip = CreateFrame("Frame")
tip.buttons = {}
tip:SetSize(100,100)
tip:SetPoint("BOTTOMLEFT",ChatFrame1,"BOTTOMRIGHT",10,0)
local model = CreateFrame("PlayerModel")
model:SetSize(150,150)
model:SetPoint("LEFT",tip,"RIGHT")
model:Hide()
local opLine = tip:CreateTexture(nil,"BORDER")
local title = tip:CreateFontString(nil,"OVERLAY")
title:SetFontObject(ChatFontNormal)
do
	local font,size,flag = title:GetFont()
	title:SetFont(font,14,"OUTLINE")
end
title:SetText("精灵副本攻略")
title:SetPoint("TOPLEFT",tip,"BOTTOMLEFT",0,-10)
title:SetTextColor(1,1,0,1)
opLine:SetTexture("Interface\\Buttons\\WHITE8x8")
opLine:SetSize(tip:GetWidth()-3, 1)
opLine:SetVertexColor(0.15,0.15,0.15,1)
opLine:SetPoint("TOPLEFT",title,0,3)
local closeButton = CreateFrame("Button",nil,tip)
closeButton:SetSize(20,20)
closeButton:SetPoint("TOPRIGHT",tip,"BOTTOMRIGHT",0,-10)
local btnTex = closeButton:CreateTexture(nil,"OVERLAY")
btnTex:SetAllPoints(closeButton)
btnTex:SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
closeButton:SetScript("OnClick",function(self)
	--btnTex:SetTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")	
	tip:Hide()
	model:Hide()
end)
for i = 1,10 do
	tip.buttons[i] = CreateFrame("Button",nil,tip)
	tip.buttons[i]:SetSize(tip:GetWidth(),10)
	local name = tip.buttons[i]:CreateFontString(nil,"OVERLAY")
	name:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = name:GetFont()
		name:SetFont(font,12,"OUTLINE")
	end
	name:SetText("")
	name:SetPoint("LEFT",tip.buttons[i])
	tip.buttons[i].name = name
	if i == 1 then 
		tip.buttons[i]:SetPoint("BOTTOMLEFT",tip)
	else
		tip.buttons[i]:SetPoint("BOTTOMLEFT",tip.buttons[i-1],"TOPLEFT",0,10)
	end
end
tip:Hide()






chatTypes = {
	{
		type = "SAY",
		short = L["说"],
		text = function() return CHAT_MSG_SAY end,
		click = ChatTab_OnClick,
		show = function()
			return (not hiddenButtons[CHAT_MSG_SAY]);
		end
	},
	{
		type = "YELL",
		short = L["喊"],
		text = function() return CHAT_MSG_YELL; end,
		click = ChatTab_OnClick,
		show = function()
			return (not hiddenButtons[CHAT_MSG_YELL]);
		end
	},
	{
		type = "PARTY",
		short = L["队"],
		text = function() return CHAT_MSG_PARTY; end,
		click = ChatTab_OnClick,
		show = function()
			return UnitExists("party1") and (not hiddenButtons[CHAT_MSG_PARTY]);
		end
	},
	{
		type = "RAID",
		short = L["团"],
		text = function() return CHAT_MSG_RAID; end,
		click = ChatTab_OnClick,
		show = function()
			return (GetNumRaidMembers() > 0) and (not hiddenButtons[CHAT_MSG_RAID]);
		end
	},
	{
		type = "RAID_WARNING",
		short = L["警"],
		text = function() return CHAT_MSG_RAID_WARNING; end,
		click = ChatTab_OnClick,
		show = function()
			return (GetNumRaidMembers() > 0) and (IsRaidLeader() or IsRaidOfficer()) and (not hiddenButtons[CHAT_MSG_RAID_WARNING]);
		end
	},
	{
		type = "BATTLEGROUND",
		short = L["战"],
		text = function() return CHAT_MSG_BATTLEGROUND; end,
		click = ChatTab_OnClick,
		show = function()
			return (select(2, IsInInstance()) == "pvp") and (not hiddenButtons[CHAT_MSG_BATTLEGROUND]);
		end
	},
	{
		type = "GUILD",
		short = L["公"],
		text = function() return CHAT_MSG_GUILD; end,
		click = ChatTab_OnClick,
		show = function()
			return IsInGuild() and (not hiddenButtons[CHAT_MSG_GUILD]);
		end
	},
	{
		type = "OFFICER",
		short = L["官"],
		text = function() return CHAT_MSG_OFFICER; end,
		click = ChatTab_OnClick,
		show = function()
			return CanEditOfficerNote() and (not hiddenButtons[CHAT_MSG_OFFICER]);
		end
	},
	{
		type = "WHISPER",
		short = L["密"],
		text = function() return CHAT_MSG_WHISPER_INFORM; end,
		click = ChatTab_OnClick,
		show = function()
			return (not hiddenButtons[CHAT_MSG_WHISPER_INFORM]);
		end
	},
	{
		type = "EMOTE",
		short = L["表"],
		text = function() return CHAT_MSG_EMOTE; end,
		click = ChatTab_OnClick,
		show = function()
			return (not hiddenButtons[CHAT_MSG_EMOTE]);
		end
	},
	{
		type = "CHANNEL1",
		short = L["综"],
		text = function() return select(2, GetChannelName(1)); end,
		click = function(self, button) ChatTab_OnClick(self, button, 1); end,
		show = function() return ChatTab_ChannelShow(1); end
	},
	{
		type = "CHANNEL2",
		short = L["交"],
		text = function() return select(2, GetChannelName(2)); end,
		click = function(self, button) ChatTab_OnClick(self, button, 2); end,
		show = function() return ChatTab_ChannelShow(2); end
	},--[[
	{
		type = "CHANNEL3",
		short = "本",
		text = function() return select(2, GetChannelName(3)); end,
		click = function(self, button) ChatTab_OnClick(self, button, 3); end,
		show = function() return ChatTab_ChannelShow(3); end
	},]]
	{
		type = "CHANNEL4",
		short = L["寻"],
		text = function() return select(2, GetChannelName(4)); end,
		click = function(self, button) ChatTab_OnClick(self, button, 4); end,
		show = function() return ChatTab_ChannelShow(4); end
	},
    {
        type = 'LFG',
        short = L['转'],
        click = function()
            --SlashCmdList['LFW']()
            if(not IsAddOnLoaded'LFGForwarder') then
                EnableAddOn'LFGForwarder'
                LoadAddOn'LFGForwarder'
            end
            if(IsAddOnLoaded'LFGForwarder' and SlashCmdList['LFW']) then
                SlashCmdList['LFW']()
            end
        end,
        show = function()
            --if(IsAddOnLoaded'LFGForwarder' and SlashCmdList['LFW']) then
            --    return true
            --end
            return true
        end,
    },
		{
			type = 'WORLDCHANNEL',
			short = L['世'],
			click = function()
				local channels = {GetChannelList()}
				local isInCustomChannel = false
				local customChannelName = "大脚世界频道"
				for i = 1, #channels do
					if channels[i] == customChannelName then
						isInCustomChannel = true
					end
				end
				if isInCustomChannel then 
					print("|cffffff00[离开:大脚世界频道]|r")
					LeaveChannelByName(customChannelName)
				else
					JoinPermanentChannel(customChannelName,nil,1)
					print("|cffffff00[加入:大脚世界频道]|r")	
					ChatFrame_AddChannel(ChatFrame1,customChannelName)
					ChatFrame_RemoveMessageGroup(ChatFrame1,"CHANNEL")
				end
			end,
			show = function()
				return true 
			end,
		},
		{
			type = "TACTIAL",
			short = L["攻"],
			click = function()
				if not tip:IsShown() then
					tip:Show()
					model:Show()
					tacFunc.SetTip(tip,model)
				else
					tip:Hide()
					model:Hide()
					tacFunc.ClearTip(tip,model)
				end
			end,
			show = function()
				return true
			end,
		},
	--	{
	--		type = 'BNNOTICE',
	--		short = L["实"],
	--		click = function()
	--			print("|cff7ebff1告诉你的好友你在干什么|r")
	--			ChatFrame1EditBox:Show()
	--			ChatFrame1EditBox:SetFocus()
	--			local notice = ChatFrame1EditBox:GetText()
	--			BNSetCustomMessage(notice)
	--		end,
	--		show = function()
	--			return true
	--		end,
	--	},
    {
        type = 'dice',
        short = '',
        text = '',
        click = function(self, button)
            RandomRoll(1, 100) -- ain't magic
        end,
        show = function() return true end,
        normal = [[Interface\AddOns\Wowshell_Buzz\icons\dice_normal]],
        pushed = [[Interface\AddOns\Wowshell_Buzz\icons\dice_pushed]],
    },
    {
        type = 'stats',
        short = '',
        text = '',
        click = function(self, button)
            statsFunc.InsertPlayerStats(button)
        end,
        show = function() return true end,
        normal = [[Interface\AddOns\Wowshell_Buzz\icons\stats_normal]],
        pushed = [[Interface\AddOns\Wowshell_Buzz\icons\stats_pushed]],
    },
}

local function CreateChatTab(parent)
	local button = CreateFrame("Button", nil, parent);
	button:SetToplevel(true);
	button:EnableMouse(true);
	button:SetWidth(24)
	button:SetHeight(24)
	button:SetAlpha(0.8)
	tinsert(parent.buttons, button)

	local text = button:CreateFontString(nil, "OVERLAY");
	text:SetFontObject("GameFontNormalLarge");
	text:SetTextColor(1, 0.82, 0)
	text:SetPoint("CENTER", -1, 0);
	button.text = text;
	--set script

	button:SetNormalTexture("Interface\\AddOns\\Wowshell_Buzz\\icons\\text_normal");
	button:SetPushedTexture("Interface\\AddOns\\Wowshell_Buzz\\icons\\text_push");
	button:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");

	button:SetScript("OnMouseUp", function(self, button)
		chatTypes[self.chatID].click(self, button)
	end)

	return button
end

local chattabs = {};
function Buzz:QuickChatButton()
	if not self.buzzFrame then
		local parent = CreateFrame("Button", nil, UIParent);
		parent:SetFrameStrata("LOW");
		parent:SetWidth(235);
		parent:SetHeight(27);
		parent:SetClampedToScreen(true);
        --parent:EnableMouse(true);
		--parent:EnableKeyboard(true);
		--parent:SetMovable(true);
		parent.buttons = {};
		
		local mover = CreateFrame("Button", nil, UIParent);
		--mover:EnableMouse(true);
		--mover:SetMovable(true);
		mover:SetWidth(235)
		mover:SetHeight(32);
		mover:SetClampedToScreen(true);
		--mover:RegisterForDrag("LeftButton")
        mover:SetFrameStrata'TOOLTIP'
		mover:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			edgeSize = 16,
			insets = {
				bottom = 5,
				left = 5,
				right = 5,
				top = 5
			},
			tileSize = 8
		});
		mover:SetBackdropBorderColor(0, 0, 0, 0);
		mover:SetBackdropColor(0, 1, 0.2, 0.7);

		mover.parent = parent;
		parent.mover = mover;

        parent:SetAllPoints(mover)
		
        mover:SetScript("OnEnter", function(self)
            self:SetBackdropBorderColor(0.8, 0.35, 0.5, 1)
        end)
        mover:SetScript("OnLeave", function(self)
            self:SetBackdropBorderColor(0, 0, 0, 0)
        end)
        mover:SetScript("OnDoubleClick", function(self)
            Buzz:ChatbarToggleLock()
        end)
        mover:SetScript("OnDragStart", function(self)
            self:StartMoving();
        end);
        mover:SetScript("OnDragStop", function(self)
            self:StopMovingOrSizing();
            --parent:SetPoint(self:GetPoint());
            if(db.chatbar_userposition) then

                local x, y = mover:GetCenter()

                db.chatbar_position_x = x
                db.chatbar_position_y = y

                --print('OnDragStop', x, y)
            end
        end)

		local txt = mover:CreateFontString(nil, "OVERLAY");
		txt:SetPoint("CENTER", mover, "CENTER", 0, 0);
		txt:SetFontObject(ChatFontNormal);
		txt:SetText(L["点击拖动, 双击锁定"])
		mover.txt = txt;
		mover:Hide();
		txt:Hide();

		self.buzzFrame = parent
	end

    -- wipe and clean
    if(db.position) then
        wipe(db.position)
        db.position = nil
        --print('wipe old conf')
    end


    --print('db.chatbar_userposition', db.chatbar_userposition)
    --print('db.chatbar_position_x', db.chatbar_position_x)
    --print('db.chatbar_position_y', db.chatbar_position_y)
    if(db.chatbar_userposition) then
        local x, y
        x = db.chatbar_position_x
        y = db.chatbar_position_y

        --print(x, y)

        -- you never know this
        if(x and y and typeCheck(x, 'number') and typeCheck(y, 'number') and (x~=0 and y~=0)) then
            local mover = self.buzzFrame.mover
            mover:ClearAllPoints()
            mover:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', x, y)
        else
            db.chatbar_userposition = false
            db.chatbar_position_x = false
            db.chatbar_position_y = false
        end
    end


	--reset point
--	if ChatFrame1EditBox and not db.position then
--		local p, rel,relp,x,y= ChatFrame1EditBox:GetPoint()
--		--local chatStyle = GetCVar("chatStyle");
--        --        if chatStyle == "im" then
--        --            self.buzzFrame:SetPoint( p, rel, relp, x , y - 30 )
--        --        else
--        self.buzzFrame:SetPoint( p, rel, relp, x , y - 5 )
--        --        end
--	elseif(db.position) then
--		local position = db.position
--		local rel = UIParent;
--		local p = db.position["p"]
--		local relp = db.position["relp"]
--		local x = db.position["x"]
--		local y = db.position["y"]
--		self.buzzFrame:SetPoint( p, rel, relp, x , y);		
--	end

	--create
	for i, k in ipairs(chatTypes) do
		local button = CreateChatTab(self.buzzFrame);
		button:SetID(i);
		button.chatID = i;
		button.show = k.show
        do -- button.text
            local text = ''
            if(type(k.short) == 'string' or type(k.short) == 'number') then
                text = k.short
            elseif(type(k.short) == 'function') then
                text = k.short
            end
            button.text:SetText(text);
        end

        if(k.pushed and k.normal) then
            button:SetNormalTexture(k.normal)
            button:SetPushedTexture(k.pushed)
        end

		tinsert(chattabs, button);
	end

	--update
	self:UpdateChattab();
    self:UpdateChattabMovability()

	if db.chatbar then
		self.buzzFrame:Show()
	else
		self.buzzFrame:Hide();
	end
end

--调整/更新 tab框体位置
function Buzz:ChatbarToggleLock()
	local chatbar = self.buzzFrame;
	local mover = chatbar.mover;
	
    if(not db.chatbar_userposition) then
        if(mover:IsShown()) then
            mover:Hide()
        end
        return
    end

    if(mover:IsShown()) then
        mover:Hide()
    else
        mover:Show()
    end
end

--调整/更新 tab 按钮
function Buzz:UpdateChattab()
	wipe(shownButtons);
	for _, button in pairs(chattabs) do
		button:Hide();--reset
		if type(button.show) == "function" and button.show() then
			tinsert(shownButtons, button)
		end
	end
	for index, button in pairs(shownButtons) do
		if index == 1 then
			button:SetPoint("TOPLEFT", self.buzzFrame, "TOPLEFT", 0, 0);
		else
			button:SetPoint("LEFT", shownButtons[index - 1], "RIGHT", 3, 0)
		end
		button:Show();
	end
end

function Buzz:UpdateChattabMovability()
    local bar = self.buzzFrame
    local mover = bar.mover

    -- reset position regardless
    --wipe(db.chatbar_position)
    mover:Hide()

    if(db.chatbar_userposition) then
        mover:EnableMouse(true)
        mover:SetMovable(true)
        mover:SetUserPlaced(false)
        --bar:SetMovable(true)
        mover:RegisterForDrag('LeftButton')


    else
        mover:EnableMouse(false)
        mover:SetMovable(false)
        --bar:SetMovable(false)

        local parent = ChatFrame1EditBox

        local offset = (GetCVar'chatStyle' == 'im') and -30 or -5
        mover:ClearAllPoints()
        mover:SetPoint('TOPLEFT', parent, 'TOPLEFT', 5, offset)
    end
end

function Buzz:ChatTabEvent()
	if db.chatbar then
		self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", "ResetTimer");
		self:RegisterEvent("PARTY_MEMBERS_CHANGED", "ResetTimer");
		self:RegisterEvent("RAID_ROSTER_UPDATE", "ResetTimer");
		self:RegisterEvent("PLAYER_GUILD_UPDATE", "ResetTimer");
		timer = self:ScheduleRepeatingTimer("UpdateChattab", 5);
	else
		self:UnregisterEvent("CHAT_MSG_CHANNEL_NOTICE");
		self:UnregisterEvent("PARTY_MEMBERS_CHANGED");
		self:UnregisterEvent("RAID_ROSTER_UPDATE");
		self:UnregisterEvent("PLAYER_GUILD_UPDATE");
		if timer then
			self:CancelTimer(timer, true)
		end
	end
end

function Buzz:ResetTimer()
	self.timerCount = 0;
end



function Buzz:SetupOptions()
end
