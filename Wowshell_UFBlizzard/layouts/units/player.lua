local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags;
local db = WSUF.db.profile
local style = ns.style

local position = ns:RegisterUnitPosition("player", {
	selfPoint = "TOPLEFT",
	anchorTo = "UIParent",
	relativePoint = "TOPLEFT",
	x = 5,
	y = -25,
});

local unitdb = ns:RegisterUnitDB("player", {
	parent = {
		width = 250,
		height = 100,
		scale = 1,
	},
	combatfeedback = true,
	elitetexture = 1,
	sidebar = true,
	indicators = {
		pvp = {},
	},
	tags = {
			lvl = { tag = "[levelcolor]",},
			name = { tag = "[name]",},
			hp = { tag = "[smart:curmaxhp]",},
			mp = { tag = "[smart:curmaxpp]",},
			sb1 = { tag =  "[hp:color][smart:curmaxhp][close]",},
			sb2 = { tag = "[hp:color][perhp][close]",},
			sb3 = { tag = "[perpp]",},
	},
});


local units = "player";
ns:setSize(units, unitdb.parent.width, unitdb.parent.height, unitdb.parent.scale);

local function updateEliteTexture(self)
    if unitdb.elitetexture == 1 then
        self.frametexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite")
        self.frametexture_sidebar:SetTexture("Interface\\AddOns\\Wowshell_UFBlizzard\\images\\PlayerBar_gold")
    elseif unitdb.elitetexture == 2 then
        self.frametexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
        self.frametexture_sidebar:SetTexture("Interface\\AddOns\\Wowshell_UFBlizzard\\images\\PlayerBar_gold")
    else
        self.frametexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
        self.frametexture_sidebar:SetTexture("Interface\\AddOns\\Wowshell_UFBlizzard\\images\\PlayerBar")
    end
end

local function updateCombatFeedback(f)
    local obj = ns.unitFrames.player
    if(unitdb.combatfeedback) then
        if(not f) then
            obj:EnableElement("CombatFeedbackText")
        end
    else
        obj:DisableElement("CombatFeedbackText")
    end
end

local function updateSidebar(obj)
    local exp_fact = obj.Exp or obj.Faction
		ns:Reload("player")
    if unitdb.sidebar then
        obj.frametexture_sidebar:Show()
        obj.tags.sb1:SetAlpha(1)
        obj.tags.sb2:SetAlpha(1)
        obj.tags.sb3:SetAlpha(1)
        exp_fact:Show()
        obj:SetHitRectInsets(0, -80, 0, 0)
    else
        obj.frametexture_sidebar:Hide()
        obj.tags.sb1:SetAlpha(0)
        obj.tags.sb2:SetAlpha(0)
        obj.tags.sb3:SetAlpha(0)
        exp_fact:Hide()
        obj:SetHitRectInsets(0,0,0,0)
    end
end

local function playerStatus_OnUpdate(self, elapsed)
	if self.statusTexture and self.statusTexture:IsShown() then
		local alpha = 255;
		local counter = self.statusCounter + elapsed;
		local sign    = self.statusSign;

		if ( counter > 0.5 ) then
			sign = -sign;
			self.statusSign = sign;
		end
		counter = mod(counter, 0.5);
		self.statusCounter = counter;

		if ( sign == 1 ) then
			alpha = (55  + (counter * 400)) / 255;
		else
			alpha = (255 - (counter * 400)) / 255;
		end
		self.statusTexture:SetAlpha(alpha);
		self.statusGlow:SetAlpha(alpha);
	end
end

local function updatePlayerFrameStatus(obj, event)
	if event == "PLAYER_ENTERING_WORLD" then
		--obj.inCombat = nil;
		obj.onHateList = nil
	--elseif event == "PLAYER_ENTER_COMBAT" then
		--obj.inCombat = 1;
	--elseif event == "PLAYER_LEAVE_COMBAT" then
		--obj.inCombat = nil;
	elseif event == "PLAYER_REGEN_DISABLED" then
		obj.onHateList = 1;
	elseif event == "PLAYER_REGEN_ENABLED" then
		obj.onHateList = nil;
	end

	if (UnitHasVehiclePlayerFrameUI("player")) then
		obj.statusTexture:Hide();
		obj.Resting:Hide();
		obj.Combat:Hide();
		obj.restGlow:Hide();
		obj.attackGlow:Hide();
		obj.statusGlow:Hide();
		obj.attackBackground:Hide();
	elseif (IsResting()) then
		obj.statusTexture:SetVertexColor(1, 0.88, 0.25, 1);
		obj.statusTexture:Show();
		obj.Combat:Hide();
		obj.restGlow:Show();
		obj.attackGlow:Hide();
		obj.statusGlow:Show();
		obj.attackBackground:Hide();
	--elseif (obj.inCombat) then
		--obj.statusTexture:Show();
		--obj.statusTexture:SetVertexColor(1,0 ,0 ,1);
		--obj.Resting:Hide();
		--obj.restGlow:Hide();
		--obj.attackGlow:Show();
		--obj.statusGlow:Show();
		--obj.attackBackground:Show();
	elseif (obj.onHateList) then
		obj.statusTexture:Show()
		obj.statusTexture:SetVertexColor(1,0,0,1)
		obj.Resting:Hide();
		obj.restGlow:Hide()
		obj.tags.lvl:SetAlpha(0)
		obj.Combat:Show();
		obj.attackGlow:Show()
		obj.statusGlow:Show();
		obj.attackBackground:Hide();
	elseif(obj.onHateList == nil) then
		obj.statusTexture:Hide()
		obj.Combat:Hide()
		obj.statusGlow:Hide()
		obj.attackGlow:Hide()
		obj.attackBackground:Hide()
		obj.tags.lvl:SetAlpha(1)
	else
		obj.statusTexture:Hide()
		--obj.statusTexture:SetVertexColor(0,0,0,0);
		obj.Resting:Hide();--rest
		obj.Combat:Hide();--attackIcon
		obj.restGlow:Hide();
		obj.statusGlow:Hide();
		obj.attackGlow:Hide();
		obj.attackBackground:Hide();
	end
end

-- frame texture
ns:addLayoutElement(units, function(self, unit)
		self.unitOwner = "player"

    local tex = self:CreateTexture(nil, "ARTWORK")
    self.frametexture = tex
    tex:SetTexCoord(1, 0.09375, 0, 0.78125)
    tex:SetAllPoints(self)

    local sidebar = self.bg:CreateTexture(nil, "OVERLAY")
    sidebar:SetHeight(128)
    sidebar:SetWidth(256)
    sidebar:SetPoint("TOPLEFT", self, "TOPLEFT", 78, -19)
    self.frametexture_sidebar = sidebar
    if(not unitdb.sidebar) then
        sidebar:Hide()
    end

    updateEliteTexture(self)

    self:SetHitRectInsets(0, -80, 0, 0)
    --utils.testBackdrop(self)
		--

		self.statusCounter = 0;
		self.statusSign = -1;
		self:SetScript("OnUpdate", playerStatus_OnUpdate)
end)

-- health/power bar
ns:addLayoutElement(units, function(self, unit)
	local hp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(hp, 128, 12)
	hp:SetPoint("TOPLEFT", 116, -40)

	local mp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(mp, 128, 12)
	mp:SetPoint("TOP", hp, "BOTTOM", 0, 0)

	--hp.colorHealth = true
	--hp.colorClass = true
	hp.frequentUpdates = true
	hp.colorSmooth = true
	mp.colorPower = true
	mp.frequentUpdates = true
	mp.Smooth = true
	self.Health = hp
	self.Power = mp
end)

ns:addLayoutElement(units, function(self, unit)
    local p = self.bg:CreateTexture(nil, "BORDER")
    self.Portrait = p
    self.portrait_2d = p

    utils.setSize(p, 64)
    p:SetPoint("TOPLEFT", 50, -12)
end)

ns:addLayoutElement(units, function(self, unit)
    local p = CreateFrame("PlayerModel", nil, self.bg)
    utils.setSize(p, 48)
    p:SetPoint("CENTER", self.portrait_2d)
    self.portrait_3d = p
end)

ns:addLayoutElement(units, function(self, unit)
    local pvp = self:CreateTexture(nil, "OVERLAY")
    self.PvP = pvp
    utils.setSize(pvp, 64)
    pvp:SetPoint("TOPLEFT", 18, -20)

    local rest = self:CreateTexture(nil, "OVERLAY")
    self.Resting = rest
    utils.setSize(rest, 31, 33)
    rest:SetPoint("TOPLEFT", 41, -49)
	
    local attack = self:CreateTexture(nil, "OVERLAY")
    self.Combat = attack
    utils.setSize(attack, 32)
    attack:SetPoint("TOPLEFT", rest, 1, 1)

    local leader = self:CreateTexture(nil, "OVERLAY")
    self.Leader = leader
    utils.setSize(leader, 16)
    leader:SetPoint("TOPLEFT", 40, -12)

    local looter = self:CreateTexture(nil, "OVERLAY")
    self.MasterLooter = looter
    utils.setSize(looter, 16)
    looter:SetPoint("TOPLEFT", 80, -10)
	
		local LFD = self:CreateTexture(nil, "OVERLAY")
		LFD:SetPoint("TOPRIGHT", rest, "TOPRIGHT", 0, 0)
		LFD:SetSize(16,16)
		self.LFDRole = LFD

    local vehicle = self:CreateTexture(nil, "ARTWORK")
    self.VehicleTexture = vehicle
    self.VehicleTextureNormal = self.frametexture
    vehicle:SetTexture[[Interface\Vehicles\UI-Vehicle-Frame]]
    utils.setSize(vehicle, 260, 120)
    vehicle:SetPoint("CENTER", self, 25, 0)
	
	self:RegisterEvent("UNIT_EXITED_VEHICLE", function(self, event, ...)
		--print("WSUF:  player exited vehicle")
		local unit = ...;
		if unit ~= "player" then return end
		self.frametexture_sidebar:Show()
		self.expbar:Show()
		self.tags.sb1:Show();--SetPoint("CENTER", self, 150, 19)
	end)
	self:RegisterEvent("UNIT_ENTERED_VEHICLE", function(self, event, ...)
		--print("WSUF:  player entered vehicle")
		local unit = ...;
		if unit ~= "player" then return end
		self.frametexture_sidebar:Hide()
		self.expbar:Hide()
		self.tags.sb1:Hide();--SetPoint("CENTER", self.Health, 0, 0)
	end)
end)

-- player status glow
ns:addLayoutElement(units, function(self, unit)
	local statusTexture = self.Health:CreateTexture(nil, "ARTWORK", self);
	self.statusTexture = statusTexture;
	statusTexture:Hide();
	statusTexture:SetTexture([[Interface\CharacterFrame\UI-Player-Status]]);
	statusTexture:SetBlendMode("ADD");
	utils.setSize(statusTexture, 203, 70);
	statusTexture:SetTexCoord(0, 0.74609375, 0, 0.53125);
	statusTexture:SetPoint("TOPLEFT", self, 40, -7);

	local attackBackground = self:CreateTexture(nil, "ARTWORK");
	self.attackBackground = attackBackground;
	attackBackground:Hide();
	utils.setSize(attackBackground, 32, 32);
	attackBackground:SetPoint("TOPLEFT", 37, -50);
	attackBackground:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-AttackBackground]]);

	local statusGlow = CreateFrame("Frame", nil, self);
	self.statusGlow = statusGlow;
	utils.setSize(statusGlow, 32, 32);
	if self.Resting then
		statusGlow:SetPoint("TOPLEFT", self.Resting, 0, -1);
	end
	statusGlow:SetFrameLevel(statusGlow:GetFrameLevel() + 3);
	
	local restGlow = statusGlow:CreateTexture(nil, "OVERLAY");
	self.restGlow = restGlow;
	utils.setSize(restGlow, 32, 32);
	restGlow:SetTexture([[Interface\CharacterFrame\UI-StateIcon]]);
	restGlow:SetBlendMode("ADD");
	restGlow:SetTexCoord(0, 0.5, 0.5, 1);
	restGlow:SetPoint("TOPLEFT", 1, 1);

	local attackGlow = statusGlow:CreateTexture(nil, "OVERLAY");
	self.attackGlow = attackGlow;
	utils.setSize(attackGlow, 32, 32);
	attackGlow:SetTexture([[Interface\CharacterFrame\UI-StateIcon]]);
	attackGlow:SetBlendMode("ADD");
	attackGlow:SetTexCoord(0.5, 1, 0.5, 1);
	attackGlow:SetPoint("TOPLEFT", 1, 1);

	statusGlow:Hide();
end);

ns:addLayoutElement(units, function(self, unit)
    local group = CreateFrame("Frame", nil, self)
    self.group = group
    group.tex = "Interface\\CharacterFrame\\UI-CharacterFrame-GroupIndicator"

    utils.setSize(group, 10, 16)
    group:SetPoint("TOPLEFT", 140, -6)

    local left = group:CreateTexture(nil, "BACKGROUND")
    group.left = left
    left:SetTexture(group.tex)
    utils.setSize(left, 24, 16)
    left:SetTexCoord(0, 0.1875, 0, 1)
    left:SetPoint("TOPRIGHT", group, -10, 0)

    local right = group:CreateTexture(nil, "BACKGROUND")
    group.right = right
    right:SetTexture(group.tex)
    utils.setSize(right, 24, 16)
    right:SetTexCoord(0.53125, 0.71875, 0, 1)
    right:SetPoint("TOPLEFT", group, 10, 0)

    local middle = group:CreateTexture(nil, "BACKGROUND")
    group.middle = middle
    middle:SetTexture(group.tex)
    middle:SetTexCoord(0.1875, 0.53125, 0, 1)
    middle:SetPoint("LEFT", left, "RIGHT")
    middle:SetPoint("RIGHT", right, "LEFT")
    middle:SetHeight(16)
	
    local text = group:CreateFontString(nil, "OVERLAY")
    group.text = text
    text:SetFontObject(GameFontHighlightSmall)
    text:SetPoint("CENTER", group)
    text:SetText("") -- DEBUG
		group:SetAlpha(0.6);
		local function onevent(self, event)
			local group
			local name = UnitName("player")
			for i = 1, GetNumRaidMembers() do
				local n, _, g = GetRaidRosterInfo(i)
				if n == name then
					group = g
					break
				end
			end

			if group then
				self.group.text:SetText(group)
				self.group:Show()
			else
				self.group:Hide()
			end
		end
		self:RegisterEvent("RAID_ROSTER_UPDATE", onevent)
		tinsert(self.__elements, onevent)
end)

ns:addLayoutElement(units, function(self, unit)
    local t = self.tags
    local lvl = self:CreateFontString(nil, "ARTWORK")
    t.lvl = lvl
    lvl:SetFontObject(GameFontNormalSmall)
    lvl:SetPoint("CENTER", -67, -16)
		--Tags:Register(self, lvl, "[levelcolor][close]")
		--lvl:UpdateTags();

    local namebg = CreateFrame("Frame", nil, self.bg)
    --utils.testBackdrop(namebg)
    self.namebg = namebg
    utils.setSize(namebg, 132, 20)
    namebg:SetBackdropColor(0, 0, 0, .4)
    namebg:SetPoint("CENTER", self, 50, 18)

    local name = self:CreateFontString(nil, "OVERLAY")
    t.name = name
    name:SetFontObject(GameFontNormalSmall)
    name:SetPoint("CENTER", namebg, 7, 2)
		--Tags:Register(self, name, "[name]");
		--name:UpdateTags();
		--name:Show();
		--WSUF.SS = self;
		--WSUF.C = name;

		local hp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
		t.hp = hp
		do local font = hp:GetFont()
			hp:SetFont(font, 12, "THINOUTLINE")
		end
		hp:SetPoint("CENTER", self.Health, 0, 0)
		--Tags:Register(self, hp, unitdb.tags.hp.tag);
		--hp:UpdateTags();
		--hp:Show();
		--reload
	
		local mp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
		t.mp = mp
		do local font = mp:GetFont()
			mp:SetFont(font, 12, "THINOUTLINE")
		end
		mp:SetPoint("CENTER", self.Power, 0, 0)
		--Tags:Register(self, mp, unitdb.tags.mp.tag) 
		--mp:UpdateTags();
		--mp:Show();
		local sb1 = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
		t.sb1 = sb1
		do local font = sb1:GetFont()
			sb1:SetFont(font, 12, "THINOUTLINE")
		end
		sb1:SetPoint("CENTER", self, 150, 19)
		if not unitdb.sidebar then 
			sb1:SetAlpha(0)
		else
			sb1:SetAlpha(1)
		end
		--Tags:Register(self, sb1, unitdb.tags.sb1.tag)
		--sb1:UpdateTags();
		--sb1:Show();

    local sb2 = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.sb2 = sb2
    do local font = sb2:GetFont()
    	sb2:SetFont(font, 12, "THINOUTLINE")
    end
    sb2:SetPoint("CENTER", self, 150, 4)	
		if not unitdb.sidebar then 
			sb2:SetAlpha(0)
		else
			sb2:SetAlpha(1)
		end

		--Tags:Register(self, sb2, unitdb.tags.sb2.tag);
		--sb2:UpdateTags();
		--sb2:Show();

    local sb3 = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.sb3 = sb3
    do local font = sb3:GetFont()
    	sb3:SetFont(font, 12, "THINOUTLINE")
    end
    sb3:SetPoint("CENTER", self, 150, -9)
		if not unitdb.sidebar then 
			sb3:SetAlpha(0)
		else
			sb3:SetAlpha(1)
		end
		--Tags:Register(self, sb3, unitdb.tags.sb3.tag);
		--sb3:UpdateTags();
		--sb3:Show();
end)

--handler rest, lvl.. stuff
ns:addLayoutElement(units, function(self, unit)
	for _, event in next, {"PLAYER_ENTERING_WORLD", "PLAYER_ENTER_COMBAT", "PLAYER_LEAVE_COMBAT", "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "PLAYER_UPDATE_RESTING"} do
		self:RegisterEvent(event, updatePlayerFrameStatus);
	end
end);

ns:addLayoutElement(units, function(self, unit)
		if not unitdb.sidebar then return end
    local bar = CreateFrame("StatusBar", nil, self.bg)
    bar:SetHeight(12)
    bar:SetWidth(200)
    bar:SetPoint("BOTTOMRIGHT", self, 57, 23)

    bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    bar:SetStatusBarColor(0, .39, .88)

    local bg = bar:CreateTexture(nil, "BORDER")
    bar.bg = bg
    bg:SetAllPoints(bar)
    bg:SetVertexColor(.58, 0, .55)
    bg:SetTexture[[Interface\TargetingFrame\UI-StatusBar]]

    local text = bar:CreateFontString(nil, "OVERLAY")
    bar.Text = text
    text:SetFontObject(GameFontNormalSmall)
    do
        local font, size, flag = text:GetFont()
        text:SetFont(font, size-5, flag)
    end
    text:SetPoint("CENTER", bar, 0, 1)
		self.expbar = bar

    if UnitLevel"player" ~= MAX_PLAYER_LEVEL then
        local function onEvent(self)
            if UnitLevel"player" == MAX_PLAYER_LEVEL then
                self:DisableElement("Exp")
                self.Exp = nil
                self.Faction = bar
                self:EnableElement("Faction")
                bar.bg:Hide()
                self:UnregisterEvent("PLAYER_LEVEL_UP", onEvent)
            end
        end
        self:RegisterEvent("PLAYER_LEVEL_UP", onEvent)
        self.Exp = bar
    else
        self.Faction = bar
        bar.bg:Hide()
    end
end)

ns:addLayoutElement(units, function(self, unit)
    local cbt = self:CreateFontString(nil, "OVERLAY")
    self.CombatFeedbackText = cbt

    cbt:SetPoint("CENTER", self.Portrait)
    cbt:SetFontObject(NumberFontNormalHuge)

    cbt.maxAlpha = .8
end)

ns:addLayoutElement(units, function(self, unit)
	--PlayerFrameFlash
    local threat = self.bg:CreateTexture(nil, "BACKGROUND")
    self.Threat = threat
    threat:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Flash]]

    utils.setSize(threat, 350, 117)
    threat:SetPoint("TOPLEFT", self, 0, 2)

    threat:SetVertexColor(1, 0 ,0)
    --threat:SetTexCoord(0.9453125, 0, 0, .181640625);
		threat:SetTexCoord(0.95,0,0,0.19)
end)

ns:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, "OVERLAY")
    self.RaidIcon = ricon
    utils.setSize(ricon, 26)
    ricon:SetPoint("CENTER", self, "TOPLEFT", 73, -14)
end)

ns:addLayoutElement(units, function(self, unit)
    local f = RuneFrame
    f.__ClearAllPoints = f.ClearAllPoints
    f.__SetPoint = f.SetPoint

    f.ClearAllPoints = function() end
    f.SetPoint = f.ClearAllPoints

    f:SetParent(self)
    f:__ClearAllPoints()
    f:__SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, 15)

    local tt = TotemFrame
    tt.__ClearAllPoints = tt.ClearAllPoints
    tt.__SetPoint = tt.SetPoint

    tt.ClearAllPoints = function() end
    tt.SetPoint = tt.ClearAllPoints

    tt:SetParent(self)
    tt:__ClearAllPoints()
    tt:__SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", -40, 15)
end)


if select(2, UnitClass"player") == "DRUID" then
    ns:addLayoutElement(units, function(self, unit)
        local f = PlayerFrameAlternateManaBar
        if f then
            f:ClearAllPoints()
            f:SetParent(self)
						if unitdb.sidebar then
            	f:SetPoint("TOPRIGHT", self.bg, "BOTTOMRIGHT", 40, 22)
						else
							f:SetPoint('TOPRIGHT',self.bg,'BOTTOMRIGHT',38,22)
						end
        end
    end)
    ns:addLayoutElement(units, function(self, unit)
        local f = EclipseBarFrame
        if f then
            f:SetParent(self)
            f:ClearAllPoints()
						if unitdb.sidebar then
            	f:SetPoint("TOPRIGHT", self.bg, "BOTTOMRIGHT", 20, 26)
						else
							f:SetPoint('TOPRIGHT',self.bg,'BOTTOMRIGHT',0,38)
						end
				end
    end)
elseif select(2, UnitClass"player") == "PALADIN" then
    ns:addLayoutElement(units, function(self, unit)
        local f = PaladinPowerBar
        if f then
            f:SetParent(self)
            f:ClearAllPoints()
						if unitdb.sidebar then
							f:SetPoint("TOPRIGHT", self.bg, "BOTTOMRIGHT", 20, 26)
						else
							f:SetPoint('TOPRIGHT',self.bg,'BOTTOMRIGHT',-8,40)
						end
        end
    end)
elseif(select(2, UnitClass"player") == "WARLOCK") then
    ns:addLayoutElement(units, function(self, unit)
        local f = ShardBarFrame
        if f then
            f:SetParent(self)
            f:ClearAllPoints()
						if unitdb.sidebar then
            	f:SetPoint("TOPRIGHT", self.bg, "BOTTOMRIGHT", 0, 21)
        		else
							f:SetPoint('TOPRIGHT',self.bg,'BOTTOMRIGHT',-6,35)
						end
				end
    end)
end

local function updateClassPowerBar(sidebar)
	if select(2, UnitClass"player") == "DRUID" and PlayerFrameAlternateManaBar then
		if sidebar then
			PlayerFrameAlternateManaBar:SetPoint("TOPRIGHT", PlayerFrameAlternateManaBar:GetParent(), "BOTTOMRIGHT", 40, 22)
		else
			PlayerFrameAlternateManaBar:SetPoint("TOPRIGHT", PlayerFrameAlternateManaBar:GetParent(), "BOTTOMRIGHT", -20, 36)				
		end
	end
	if select(2, UnitClass"player") == "DRUID" and EclipseBarFrame then
		if sidebar then
			EclipseBarFrame:SetPoint("TOPRIGHT", EclipseBarFrame:GetParent(), "BOTTOMRIGHT", 20, 26)
		else
			EclipseBarFrame:SetPoint("TOPRIGHT", EclipseBarFrame:GetParent(), "BOTTOMRIGHT", 0, 38)				
		end
	end
	if select(2, UnitClass("player")) == "PALADIN" and PaladinPowerBar then
		if sidebar then
			PaladinPowerBar:SetPoint("TOPRIGHT", PaladinPowerBar:GetParent(), "BOTTOMRIGHT", 20, 26)
		else
			PaladinPowerBar:SetPoint("TOPRIGHT", PaladinPowerBar:GetParent(), "BOTTOMRIGHT", -8, 40)
		end
	end
	if select(2, UnitClass("player")) == "WARLOCK" and ShardBarFrame then
		if sidebar then
			ShardBarFrame:SetPoint("TOPRIGHT", ShardBarFrame:GetParent(), "BOTTOMRIGHT", 0, 21)
		else
			ShardBarFrame:SetPoint("TOPRIGHT", ShardBarFrame:GetParent(), "BOTTOMRIGHT", -6, 35)
		end
	end
end
ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

local frame
ns:addLayoutElement(units,function(self)
	frame = self
end)

ns:spawn(function()
	local f = oUF:Spawn("player","wsUnitFrame_Player")
	ns.frameList[f] = true
	ns.unitFrames.player = f
	frame = f
	return f
end)


ns:RegisterUnitOptions("player", {
    type = "group",
    name = L["player"],
    order = ns.order(),
    args = {
        elitetexture = {
            type = "select",
            name = L["Elite texture"],
            desc = L["Always show elite texture on player frame"],
            order = ns.order(),
			values = { [1] = L["Rare-Elite texture"], [2] = L["Elite texture"] , [3] = L["None"] },
            get = function() return unitdb.elitetexture or 1 end,
            set = function(_, v)
                unitdb.elitetexture = v
                updateEliteTexture(ns.unitFrames.player)
            end,
        },
        sidebar = {
            type = "toggle",
            name = L["Sidebar"],
            desc = L["Enable sidebar"],
            order = ns.order(),
            disabled = function() return InCombatLockdown() end,
            get = function() return unitdb.sidebar end,
            set = function(_,v)
                unitdb.sidebar = v
                updateSidebar(frame)
				updateClassPowerBar(unitdb.sidebar)
            end
        },
        combatfeedback = {
            type = "toggle",
            name = L["Combat feedback text"],
            desc = L["Enable combat feedback test"],
            order = ns.order(),
            width = "full",
            get = function() return unitdb.combatfeedback end,
            set = function(_, v)
                unitdb.combatfeedback = v
                updateCombatFeedback(v)
            end,
        },

        taggroup = {
            type = "group",
            name = L["Tag texts"],
            order = ns.order(),
            inline = true,
            args = {
                tagonhealthbar = {
                    type = "select",
                    name = L["Text on health bar"],
                    desc = L["The text show on health bar"],
                    order = ns.order(),
										--values = utils.tag_select_values,
                    values = {[""]= L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.hp.tag  end,
                    set = function(_, v)
                      unitdb.tags.hp.tag = v
                       ns:Reload("player")
											 updateSidebar(ns.unitFrames.player)
                    end,
                },
                tagonpowerbar = {
                    type = "select",
                    name = L["Text on power bar"],
                    desc = L["The text show on power bar"],
                    order = ns.order(),
                    values = {[""]= L["NONE"],["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
                    get = function() return unitdb.tags.mp.tag end,
                    set = function(_, v)
                        unitdb.tags.mp.tag = v
                       	ns:Reload("player")
												updateSidebar(ns.unitFrames.player)
                    end,
                },
                tagonsb1 = {
                    type = "select",
                    name = L["Text on sidebar 1"],
                    desc = L["The text show on sidebar 1"],
                    order = ns.order(),
                   values = {[""]= L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.sb1.tag end,
                    set = function(_, v)
                        unitdb.tags.sb1.tag = v
                    		ns:Reload("player")
												updateSidebar(ns.unitFrames.player)
											end,
                },
                tagonrow2 = {
                    type = "select",
                    name = L["Text on sidebar 2"],
                    desc = L["The text show on sidebar 2"],
                    order = ns.order(),
                     values = {[""]= L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.sb2.tag end,
                    set = function(_, v)
                        unitdb.tags.sb2.tag = v
                        ns:Reload("player")
												updateSidebar(ns.unitFrames.player)
                    end,
                },
                tagonrow3 = {
                    type = "select",
                    name = L["Text on sidebar 3"],
                    desc = L["The text show on sidebar 3"],
                    order = ns.order(),
                     values = {[""]= L["NONE"],["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
                    get = function() return unitdb.tags.sb3.tag end,
                    set = function(_, v)
                        unitdb.tags.sb3.tag = v
												ns:Reload("player")
												updateSidebar(ns.unitFrames.player)
                    end,
                },
            },
        },
    },
})

