local aspect = IceHunex:NewModule("AspectFrame", "AceEvent-3.0");
local db;
local GetSpellInfo = GetSpellInfo-- name, rank, texture, ...
local active_icon = "Interface\\Icons\\Spell_Nature_WispSplode"
local MAX_ASPECTS_NUM = 8
local currentSpell = nil
local L = wsLocale:GetLocale("IceHunex")

local defaults = {
	profile = {
		enabled = true,
		locked = true,
	}
}

local aspectsList = {}

do
    local spelllist = {
        13165,  -- hawk
        34074,  --viper
        61846,  --dragon hawk
        13161,  --beast,
        5118,   --cheetah,
        13163,  --monkey
        13159,  --pack
        20043,  -- wild
    }

    for k, v in next, spelllist do
        local spell_name = GetSpellInfo(v)
        aspectsList[spell_name] = 0
    end
end

local options = nil
local function getoptions()
	if not options then
		options = {
			type = "group",
			name = L["守护姿态条"],
			order = 2,
			guiInline = true,
			args = {
				enabled = {
					type = "toggle",
					order = 1,
					name = L["启用"],
					desc = L["启用守护姿态条"],
					get = function() return db.enabled end,
					set = function(_, v)
						db.enabled = v
						if v then
							aspect:Enable()
							aspect.aspectframe:Show()
						else
							aspect:Disable()
						end
					end
				},
				locked = {
					type = "toggle",
					name = L["锁定"],
					desc = L["锁定/解锁守护姿态条"],
					order = 2,
					get = function() return db.locked end,
					set = function(_, v)
						aspect:ToggleLocked()
					end
				},
			},
		}
	end
	return options
end

function aspect:OnInitialize()
	self.db = IceHunex.db:RegisterNamespace("aspect", defaults);
	db = self.db.profile
	self:SetEnabledState(db.enabled)
	if not db.locked then
		db.locked = true
	end

	IceHunex:RegisterModuleOptions("aspectframe", getoptions())
end

function aspect:OnEnable()
	self:CreateAspectFrame();
	self:RegisterEvent("SPELLS_LOADED", "ReleaseFrame");
	self:RegisterEvent("LEARNED_SPELL_IN_TAB", "ReleaseFrame");
	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("UNIT_SPELLCAST_FAILED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateCurrentSpell")
	self:RegisterEvent("PLAYER_LOGIN", "UpdateCurrentSpell");	
	self:ReleaseFrame();
end

function aspect:OnDisable()
	self:UnregisterAllEvents();
	UnregisterStateDriver(self.aspectframe, 'visibility')
	if self.aspectframe then
		self.aspectframe:Hide()
	end
end

--------------------------------------------------------------------------
-- @ button template
--------------------------------------------------------------------------
local aspectButton = CreateFrame("CheckButton");--proto type
local aspectButton_MT = {__index=aspectButton};

local button_OnEnter, button_OnLeave, button_PostClick
do
	button_OnEnter = function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetSpell(self.spellid, SpellBookFrame.bookType)
		GameTooltip:Show();
	end

	button_OnLeave = function(self)
		GameTooltip:Hide();
	end

	button_PostClick = function(self)
		self:Update();
	end
end

function aspectButton:New(id, parent)
	local button = setmetatable(CreateFrame("CheckButton", ("AspectFrameButton_%d"):format(id), parent, "SecureActionButtonTemplate, ActionButtonTemplate"), aspectButton_MT);
	button:SetSize(30, 30);
	button.icon = getglobal(button:GetName().."Icon");
	local normal = getglobal(button:GetName().."NormalTexture");
	if normal then
		normal:SetWidth(52)
		normal:SetHeight(52)
	end

	button:RegisterForClicks("AnyUp");
	button:SetScript("OnEnter", button_OnEnter)
	button:SetScript("OnLeave", button_OnLeave)
	button:SetScript("PostClick", button_PostClick)
	button:SetID(id);
	
	return button
end

function aspectButton:SetSize(w, h)
	self:SetWidth(w);
	self:SetHeight(h or w);
end

function aspectButton:Update()
	if not self:IsShown() then return end;
	local spellid = self.spellid;
	self.icon:SetTexture(self.spellIcon)
	self:SetChecked(0)--ever checked nil
	if self.isActive then
		self.icon:SetTexture(active_icon)
	else
		self.icon:SetTexture(self.spellIcon)
	end
end

function aspect:CreateAspectFrame()
	if self.aspectframe then return end
	local frame = CreateFrame("Frame", "WSAspectFrame", UIParent);
	frame:SetWidth(230)
	frame:SetHeight(40)
	frame:EnableMouse(true)
	
	if not db.pos then
		db.pos = {
			point = "CENTER",
			relpoint = "CENTER",
			x = 100,
			y = -240,
		}
	end
	local pos = db.pos

	frame:SetPoint(pos.point, UIParent, pos.relpoint, pos.x, pos.y);
	
	local mover = CreateFrame("Button", "WSAspectMoverFrame", UIParent);
	mover:EnableMouse(true);
	mover:SetMovable(true);
	mover:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = {left = 5, right = 5, top = 5, bottom = 5},
	});
	mover:SetBackdropColor(0, 1, 0);
	mover:SetAlpha(0.5)
	mover:SetFrameStrata("DIALOG");
	mover:SetFrameLevel(5);
	mover:SetClampedToScreen("true");
	mover:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end)
	mover:SetScript("OnDragStop", function(self)
		aspect:SavePosition(frame)
		self:StopMovingOrSizing()
	end)
	mover:SetScript("OnClick", function(self, button)
		if IsAltKeyDown() and button == "LeftButton" then
			aspect:ToggleLocked()
		end
	end)
	frame.mover = mover
	
	mover:Hide();

	for i =1, MAX_ASPECTS_NUM do
		local button = aspectButton:New(i, UIParent);
		button:SetParent(frame)
		if i == 1 then
			button:SetPoint("LEFT", frame, "LEFT", 0, 0)
		else
			button:SetPoint("LEFT", _G["AspectFrameButton_"..(i-1)], "RIGHT", 1, 0);
		end
	end
	
	frame:RegisterForDrag("LeftButton");
	frame:Hide()
	self.aspectframe = frame
end

function aspect:SavePosition(f)
	local pos = db.pos
	local mover = f.mover
	local point, _, relpoint, x, y = mover:GetPoint();
	pos.point = point
	pos.relpoint = relpoint
	pos.x = x
	pos.y = y
end

function aspect:LoadPosition(f)
	local pos = db.pos
	local mover = f.mover
	f:ClearAllPoints();
	f:SetPoint(pos.point, UIParent, pos.relpoint, pos.x, pos.y)
end

function aspect:ToggleLocked()
	local isLocked = db.locked
	local mover = self.aspectframe.mover
	if isLocked then
		mover:ClearAllPoints();
		mover:SetWidth(self.aspectframe:GetWidth());
		mover:SetHeight(self.aspectframe:GetHeight());
		mover:SetScale(self.aspectframe:GetScale());
		mover:RegisterForDrag("LeftButton");
		mover:SetPoint(self.aspectframe:GetPoint())
		self.aspectframe:ClearAllPoints();
		self.aspectframe:SetPoint("TOPLEFT", mover);
		mover:Show();
		db.locked = false
	else
		aspect:LoadPosition(self.aspectframe)
		mover:RegisterForDrag();
		mover:Hide()
		db.locked = true
	end
end

-----------------
-- event
-----------------

function aspect:ReleaseFrame()
	if not self.aspectframe then self:CreateAspectFrame() end
	
	--reset the available abilities
	for spellid, id in pairs(aspectsList) do
		if id > 0 then
			aspectsList[spellid] = 0
		end
	end

	local numTotalSpells = 0;
	for i=1, MAX_SKILLLINE_TABS do
		local name, texture, offset, numSpells = GetSpellTabInfo(i);
		if (name) then
			numTotalSpells = numTotalSpells + numSpells
		end
	end

	for i = 1, numTotalSpells do
		local spellName, subSpellName = GetSpellBookItemName(i, SpellBookFrame.bookType);
		if (spellName) then
			if aspectsList[spellName] then
				aspectsList[spellName] = i
			end
		end
	end

	local count = 0
	for spellname, id in pairs(aspectsList) do
		if (id > 0 ) then
			count = count + 1
			local button = getglobal("AspectFrameButton_"..count);
			button:SetAttribute("type", "spell");
			button:SetAttribute("spell", spellname)
			local _, _, icon = GetSpellInfo(spellname)
			button.spellIcon = icon;
			button.spellid = id;
			button.isActive = false;
			button:Update();
			button:Show();
		end
	end

	for i = count + 1, MAX_ASPECTS_NUM , 1 do
		local button = getglobal("AspectFrameButton_"..i);
		button:Hide();
	end

	--update StateDriver
	RegisterStateDriver(self.aspectframe, 'visibility', '[target=vehicle, noexists]show;hide')
	self.aspectframe:Show();
end


function aspect:ACTIONBAR_UPDATE_COOLDOWN()
	for i =1, MAX_ASPECTS_NUM, 1 do
		local button = getglobal("AspectFrameButton_"..i);
		local cooldown = getglobal(button:GetName().."Cooldown");
		if button.SpellID ~= nil and button.SpellID ~= 0 then
			local start, duration = GetSpellCooldown(button.SpellID, BOOKTYPE_SPELL);
			CooldownFrame_SetTimer(cooldown, start, duration, 1);
		end
	end
end


function aspect:UNIT_AURA(event, unit)
	if unit == "player" then
		self:UpdateCurrentSpell()
	end
end

function aspect:UNIT_SPELLCAST_FAILED(event, unit)
	if unit == "player" then
		self:UpdateCurrentSpell()
	end
end


function aspect:UpdateCurrentSpell()
	for index = 1, MAX_TARGET_BUFFS do
		local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitAura("player", index, "PLAYER");
		if name then
			if isMine == "player" then
				local _found = nil
				local spellid = aspectsList[name];
				for i = 1, MAX_ASPECTS_NUM , 1 do
					--reset
					local button = getglobal("AspectFrameButton_"..i);
					if button.spellid == spellid then
						button.isActive = true
						_found = 1;
					else
						button.isActive = false
					end
					button:Update();
				end
				if _found then break end
			end
		else
			for i = 1, MAX_ASPECTS_NUM , 1 do
					--reset
				local button = getglobal("AspectFrameButton_"..i);
				button.isActive = false
				button:Update();
			end
			break;
		end
	end
end
