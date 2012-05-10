
local _, ns = ...
local CDT = ns.CC:NewModule('CooldownText', "AceEvent-3.0");
local LIBSM = LibStub('LibSharedMedia-3.0')

local onUpdate

local ICON_SIZE = 36 -- normal size
local FONT_SCALE = 1.2
--local MIN_SCALE = 3/4 -- the minimun scale we put cooldown text in the middle of the button, anything bellow this will be put at the right top of the button
local MIN_DURATION = 3
local DURATION_FLASH = 6 -- text will flash under this time

local DAY, HOUR, MINUTE = 24*60*60, 60*60, 60
local HALF_SEC = 1 / 2

CDT.colors = {
    normal = {1, .9, 0},
    red = {1, 0, 0},
}

local format = string.format
local ceil = math.ceil
local floor = math.floor
local max = math.max
local min = math.min


function CDT:OnInitialize()
    self.db = ns.CC.db
		self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
    self:EnableHook()
end

function CDT:EnableHook()
    local methods = getmetatable(ActionButton1Cooldown).__index
    hooksecurefunc(methods, 'SetCooldown', function(frame, start, duration)
        if(frame.noOCC or frame.noCooldownCount) then return end
        if(start > 0 and duration >= MIN_DURATION) then
            CDT:Start(frame, start, duration)
        else
            CDT:Stop(frame)
        end
    end)
		hooksecurefunc("SetActionUIButton", function(button, action, cooldown)
			CDT:action_Add(button, action, cooldown)	
		end);
		for i, button in pairs(ActionBarButtonEventsFrame.frames) do
			CDT:action_Add(button, button.action, button.cooldown)
		end
end

------------------------------------------------------
---- ActionUI button
---- Compat4.3
------------------------------------------------------
local actions = {};
local function action_OnShow(self)
	actions[self] = true;
end

local function action_OnHide(self)
	actions[self] = nil;
end

function CDT:action_Add(button, action, cooldown)
	if not cooldown.wscc_action then
		cooldown:HookScript("OnShow", action_OnShow);
		cooldown:HookScript("OnHide", action_OnHide);
	end
	cooldown.wscc_action = action;
end

local function actions_Update()
	for cooldown in pairs(actions) do
		local start, duration = GetActionCooldown(cooldown.wscc_action);
		CDT:cooldown_Show(cooldown, start, duration);
	end
end

function CDT:ACTIONBAR_UPDATE_COOLDOWN()
	actions_Update();
end

function CDT:cooldown_Show(btn, start, duration)
	if btn.noCooldownCount or not(start and duration) then
		self:Stop(btn)
		return
	end
	if(start > 0 and duration >= MIN_DURATION) then
		self:Start(btn, start, duration)
	else
		self:Stop(btn)
	end
end
-----------------------------------------------------

function CDT:Start(btn, start, duration)
    local cd = self:GetCDText(btn) or self:CreateCDText(btn);
    cd.start = start
    cd.duration = duration
    cd.nextUpdate = 0

    self:AdjustCDText(btn)
    cd:SetScript('OnUpdate', onUpdate)
    cd:Show()
end

function CDT:Stop(btn)
    local text = self:GetCDText(btn, true)
    if(text) then
        text:Hide()
    end
end

function CDT:GetCDText(btn, nocreate)
    return btn.wscc_cd or (not nocreate and self:CreateCDText(btn))
end

function CDT:CreateCDText(btn)
    local f = CreateFrame('Frame', nil, btn)
    f:SetAllPoints(btn)

    f.text = f:CreateFontString(nil, 'OVERLAY')

    btn.wscc_cd = f
    return f
end

function CDT:FormatTime(s)
    if(s >= DAY) then
        return format('%dd', floor(s/DAY + 1)), s % DAY
    elseif(s >= HOUR) then
        return format('%dh', floor(s/HOUR + 1)), s % HOUR
    elseif(s >= MINUTE) then
        return format('%dm', floor(s/MINUTE + 1)), s % MINUTE
    elseif(s > DURATION_FLASH) then
        return format('%d', floor(s+1)), s - floor(s)
    --elseif(s >= HALF_SEC) then
    elseif(s > 0) then
        local nextUpdate = s - floor(s)
        local text = format('%d', floor(s+1))
        local red = false

        if(nextUpdate > HALF_SEC) then
            red = true
            nextUpdate = nextUpdate - HALF_SEC
        end

        return text, nextUpdate, red
--    else
--        return nil
    end
end

function CDT:UpdateCDText(cd)
    local remain = cd.duration - (GetTime() - cd.start)
    local text, nextUpdate, red = self:FormatTime(remain)

    if(text) then
        local c = red and 'red' or 'normal'
        if(cd.color ~= c) then
            cd.color = c
            cd.text:SetTextColor(unpack(self.colors[c]))
        end

        if(remain <= DURATION_FLASH and cd.font_size ~= 'big') then
            self:SetTextButtonFont(cd, true)
        end

        cd.text:SetText(text)
        cd.nextUpdate = nextUpdate
    else
        cd:Hide()
    end
end

function CDT:AdjustCDTextPosition(cd, text)
    text:ClearAllPoints()

    if(cd.scale <= self.db.min_scale and self.db.cd_text_righttop_if_too_small) then
        text:SetPoint('CENTER', cd, 'TOPRIGHT', 0, 0)
    else
        text:SetPoint('CENTER', cd, 'CENTER', 0, 0)
    end
end

function CDT:SetTextButtonFont(cd, bigger)
    local font_path = LIBSM:Fetch('font', self.db.font)
    local font_size = (cd.scale < self.db.min_scale and self.db.font_size_small or self.db.font_size) * cd.scale
    if(bigger) then
        font_size = font_size * FONT_SCALE
    end
		cd.text:SetFontObject(ChatFontNormal)	
		do 
			local font,size,flag = cd.text:GetFont()
			cd.text:SetFont(font,font_size,"OUTLINE")
		end
    --cd.text:SetFont(, font_size, 'OUTLINE')
    cd.font_size = bigger and 'big' or 'normal'
end


function CDT:AdjustCDText(btn)
    local cd = self:GetCDText(btn)
    local text = cd.text
    --local scale = min(btn:GetParent():GetWidth() / ICON_SIZE, 1)
    local scale = btn:GetParent():GetWidth() / ICON_SIZE

    cd.scale = scale

    self:AdjustCDTextPosition(cd, text)
    self:SetTextButtonFont(cd)
end


onUpdate = function(self, elapsed)
    self.nextUpdate = self.nextUpdate - elapsed
    if(self.nextUpdate <= 0) then
        CDT:UpdateCDText(self)
    end
end



