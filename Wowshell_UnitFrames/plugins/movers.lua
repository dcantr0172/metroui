local parent, ns = ...
local oUF = ns.oUF
local L = ns.L
local Movers = {};
local originalEnvs = {};
local unitConfig = {};
local attributeBlacklist = {["showplayer"] = true, ["showraid"] = true, ["showparty"] = true, ["showsolo"] = true, ["initial-unitwatch"] = true}
local playerClass = select(2, UnitClass("player"));
local noop = ns.noop;
local onDragStop, onDragStart, configEnv;

ns:RegisterModule(Movers, "movers");

local function getValue(func, unit, value)
	unit = string.gsub(unit, "(%d+)", "");
	if( unitConfig[func .. unit] == nil ) then unitConfig[func .. unit] = value end
	return unitConfig[func .. unit]
end

local function createConfigEnv()
	if (config) then return end;
	configEnv = setmetatable({
		GetRaidTargetIndex = function(unit) return getValue("GetRaidTargetIndex", unit, math.random(1, 8)) end,
		GetLootMethod = function(unit) return "master", 0, 0 end,
		GetComboPoints = function() return MAX_COMBO_POINTS end,
		UnitInRaid = function() return true end,
		UnitInParty = function() return true end,
		UnitIsUnit = function(unitA, unitB) return unitB == "player" and true or false end,
		UnitIsDeadOrGhost = function(unit) return false end,
		UnitIsConnected = function(unit) return true end,
		UnitLevel = function(unit) return MAX_PLAYER_LEVEL end,
		UnitIsPlayer = function(unit) return unit ~= "boss" and unit ~= "pet" and not string.match(unit, "(%w+)pet") end,
		UnitHealth = function(unit) return getValue("UnitHealth", unit, math.random(20000, 50000)) end,
		UnitHealthMax = function(unit) return 50000 end,
		UnitPower = function(unit, powerType)
			if powerType == SPELL_POWER_HOLY_POWER or powerType == SPELL_POWER_SOUL_SHARDS then
				return 3
			end
			return getValue("UnitPower", unit, math.random(20000, 50000))
		end,
		UnitExists = function(unit) return true end,
		UnitPowerMax = function(unit) return 50000 end,
		UnitIsPartyLeader = function() return true end,
		UnitIsPVP = function(unit) return true end,
		UnitIsDND = function(unit) return false end,
		UnitIsAFK = function(unit) return false end,
		UnitFactionGroup = function(unit) return _G.UnitFactionGroup("player") end,
		UnitAffectingCombat = function() return true end,
		UnitThreatSituation = function() return 0 end,
		UnitDetailedThreatSituation = function() return nil end,
		UnitThreatSituation = function() return 0 end,
		UnitCastingInfo = function(unit)
			-- 1 -> 10: spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible
			local data = unitConfig["UnitCastingInfo" .. unit] or {}
			if( not data[6] or GetTime() < data[6] ) then
				data[1] = L["Test spell"]
				data[2] = L["Rank 1"]
				data[3] = L["Test spell"]
				data[4] = "Interface\\Icons\\Spell_Nature_Rejuvenation"
				data[5] = GetTime() * 1000
				data[6] = data[5] + 60000
				data[7] = false
				data[8] = math.floor(GetTime())
				data[9] = math.random(0, 100) < 25
				unitConfig["UnitCastingInfo" .. unit] = data
			end

			return unpack(data)
		end,
		UnitIsFriend = function(unit) return unit ~= "target" and unit ~= ns.fakeUnits[unit] and unit ~= "arena" end,
		GetReadyCheckStatus = function(unit)
			local status = getValue("GetReadyCheckStatus", unit, math.random(1, 3))
			return status == 1 and "ready" or status == 2 and "notready" or "waiting"
		end,
		GetPartyAssignment = function(type, unit)
			local assignment = getValue("GetPartyAssignment", unit, math.random(1, 2) == 1 and "MAINTANK" or "MAINASSIST")
			return assignment == type
		end,
		UnitGroupRolesAssigned = function(unit)
			local role = getValue("UnitGroupRolesAssigned", unit, math.random(1, 3))
			return role == 1 and "TANK" or (role == 2 and "HEALER" or (role == 3 and "DAMAGER"))
		end,
		UnitPowerType = function(unit)
			local powerType = math.random(0, 4)
			powerType = getValue("UnitPowerType", unit, powerType == 4 and 6 or powerType)

			return powerType, powerType == 0 and "MANA" or powerType == 1 and "RAGE" or powerType == 2 and "FOCUS" or powerType == 3 and "ENERGY" or powerType == 6 and "RUNIC_POWER"
		end,
		UnitAura = function(unit, id, filter)
			if( type(id) ~= "number" or id > 40 ) then return end

			local texture = filter == "HELPFUL" and "Interface\\Icons\\Spell_Nature_Rejuvenation" or "Interface\\Icons\\Ability_DualWield"
			local mod = id % 5
			local auraType = mod == 0 and "Magic" or mod == 1 and "Curse" or mod == 2 and "Poison" or mod == 3 and "Disease" or "none"
			return L["Test Aura"], L["Rank 1"], texture, id, auraType, 0, 0, "player", id % 6 == 0
		end,
		UnitName = function(unit)
			if unit == nil then return UNKNOWN end
			local unitID = string.match(unit, "(%d+)")
			if( unitID ) then
				return string.format("%s #%d", L.units[string.gsub(unit, "(%d+)", "")] or unit, unitID)
			end

			return L.units[unit]
		end,
		UnitClass = function(unit)
			local classToken = getValue("UnitClass", unit, CLASS_SORT_ORDER[math.random(1, #(CLASS_SORT_ORDER))])
			return LOCALIZED_CLASS_NAMES_MALE[classToken], classToken
		end,
	}, {
		__index = _G,
		__newindex = function(tbl, key, value)
			_G[key] = value;
		end
	})
end

local function prepareChildUnits(header, ...)
	for i = 1, select("#", ...) do
		local frame = select(i, ...);
		if (frame == nil)then return end
		if (frame.unitType and not frame.configUnitID) then
			ns.styles[ns.db.profile.currentStyle].frameList[frame] = true;
			frame.configUnitID = header.groupID and (header.groupID * 5) - 5 + i or i;

			frame:SetAttribute("unit", ns[header.unitType.."Units"][frame.configUnitID]);
		end
	end
end

local function OnEnter(self)
	local tooltip = self.tooltipText or self.unitID and string.format("%s #%d", L.units[self.unitType], self.unitID) or L.units[self.unit] or self.unit
	--local additionalText = ShadowUF.Units.childUnits[self.unitType] and L["Child units cannot be dragged, you will have to reposition them through WSUnitFrame configure panel."]
	
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
	GameTooltip:SetText(tooltip, 1, 0.81, 0, 1, true)
	if( additionalText ) then GameTooltip:AddLine(additionalText, 0.90, 0.90, 0.90, 1) end
	GameTooltip:Show()
end

local function OnLeave(self)
	GameTooltip:Hide();
end

local function setupUnits(childrenOnly)
	local currentStyleDB = ns:GetCurrentStyleDB();
	for frame in pairs(ns.styles[ns.db.profile.currentStyle].frameList) do
		if (frame.configMode) then
			--if (frame:IsVisible()) then -- and not currentStyleDB.units[frame.unitType].enabled) then
			--	RegisterUnitWatch(frame, frame.hasStateWatch);
			--	if (not UnitExists(frame.unit)) then
			--		frame:Hide();
			--	end
			--end

			if (not frame:IsVisible()) then
				UnregisterUnitWatch(frame);
				frame:FullUpdate();
				frame:Show();

				frame:UpdateAllElements("OnUpdate");
				frame:UpdateAllElements("ForceUpdate");
				frame:UpdateAllElements('PLAYER_ENTERING_WORLD');
				frame:UpdateAllElements('OnShow');
			end
		elseif (not frame.configMode) then -- and currentStyleDB.units[frame.unitType].enabled) then
			frame.originalUnit = frame:GetAttribute("unit");
			frame.originalOnEnter = frame:GetScript("OnEnter");
			frame.originalOnLeave = frame:GetScript("OnLeave");
			frame.originalOnUpdate = frame:GetScript("OnUpdate");
			frame:SetMovable(true);
			frame:RegisterForDrag("LeftButton")
			frame:SetScript("OnDragStop", OnDragStop);
			frame:SetScript("OnDragStart", OnDragStart);
			frame:SetScript("OnEnter", OnEnter);
			frame:SetScript("OnLeave", OnLeave);
			frame:SetScript("OnEvent", nil);
			frame:SetScript("OnUpdate", nil);
			frame.configMode = true;
			frame.unitOwner = nil;
			frame.originalMenu = frame.menu;
			frame.menu = nil;

			local unit;
			if (frame.isChildUnit) then
				local unitFormat = string.gsub(string.gsub(frame.unitType, "target$", "%%dtarget"), "pet$", "pet%%d")
				if (unitFormat) then
					unit = string.format(unitFormat, frame.parent.configUnitID or "")
				end
			else
				unit = frame.unitType .. (frame.configUnitID or "");
			end

			ns.styles[ns.db.profile.currentStyle].OnAttributeChanged(frame, "unit", unit);

			UnregisterUnitWatch(frame);
			frame:FullUpdate()
			frame:Show();
			frame:UpdateAllElements("OnUpdate");
			frame:UpdateAllElements("ForceUpdate");
			frame:UpdateAllElements('PLAYER_ENTERING_WORLD');
			frame:UpdateAllElements('OnShow');
		end
	end
end

function Movers:Enable()
	createConfigEnv();

	for type, zone in pairs(WSUF.Module.zoneUnits) do
		--ignore blizzard temporary
		if (type == "boss" and ns.db.profile.currentStyle ~= "Blizzard") then
			WSUF.Module:LoadZoneHeader(type)
		end
	end

	for _, header in pairs(WSUF.Module.headerFrames) do
		if (ns[header.unitType.."Units"]) then
			header:SetAttribute("startingIndex", -#(ns[header.unitType.."Units"]) + 1);
		end

		for key in pairs(attributeBlacklist) do
			header:SetAttribute(key, nil);
		end

		header.startingIndex = header:GetAttribute("startingIndex");
		header:SetMovable(true);
		prepareChildUnits(header, header:GetChildren());
	end

	if (not self.isEnabled) then
		for _, func in pairs(ns.tagFunc) do
			if (type(func) == "function") then
				originalEnvs[func] = getfenv(func);
				setfenv(func, configEnv);
			end
		end

		for _, module in pairs(ns.modules) do
			if (module.moduleName) then
				for key , func in pairs(module) do
					if (type(func) == "function") then
						originalEnvs[module[key]] = getfenv(module[key]);
						setfenv(module[key], configEnv);
					end
				end
			end
		end

	end

	setupUnits();
	setupUnits(true);

	if( not self.isConfigModeSpec ) then
		self:CreateInfoFrame()
		self.infoFrame:Show()
	elseif( self.infoFrame ) then
		self.infoFrame:Hide()
	end

	self.isEnabled = true;
end

function Movers:Disable()
	if (not self.isEnabled) then return nil end

	for func, env in pairs(originalEnvs) do
		setfenv(func, env);
		originalEnvs[func] = nil
	end

	for frame in pairs(ns.styles[ns.db.profile.currentStyle].frameList) do
		if (frame.configMode) then
			if (frame.isMoving) then
				frame:GetScript("OnDragStop")(frame);
			end

			frame.configMode = nil;
			frame.unitOwner = nil;
			frame.unit = nil;
			frame.configUnitID = nil;
			frame.menu = frame.originalMenu;
			frame.originalMenu = nil;
			frame:SetAttribute("unit", frame.originalUnit);
			frame:SetScript("OnDragStop", nil);
			frame:SetScript("OnDragStart", nil);
			frame:SetScript("OnEnter", frame.originalOnEnter);
			frame:SetScript("OnLeave", frame.originalOnLeave);
			frame:SetMovable(false);
			frame:RegisterForDrag();
			
			if (frame.isChildUnit) then
				ns.styles[ns.db.profile.currentStyle].OnAttributeChanged(frame, "unit", SecureButton_GetModifiedUnit(frame));
			end

			RegisterUnitWatch(frame);
			
			frame:UpdateAllElements("OnUpdate");
			frame:UpdateAllElements("ForceUpdate");
			frame:UpdateAllElements('PLAYER_ENTERING_WORLD');
			frame:UpdateAllElements('OnShow');
			
			if( not UnitExists(frame.unit) ) then frame:Hide() end
		end
	end
	
	for type, header in pairs(ns.styles[ns.db.profile.currentStyle].headerFrames) do
		header:SetMovable(false)
		header:SetAttribute("startingIndex", 1)
		header:SetAttribute("initial-unitWatch", true)

		if (header.unitType == type or type == "raidParent") then
			if WSUF.Module.headerFrames[type] then
				WSUF.Module:SetHeaderAttributes(WSUF.Module.headerFrames[type], type);
				--WSUF.Layout:AnchorFrame(UIParent, WSUF.Module.headerFrames[type], WSUF.Module:GetUnitPosition(type));
			end
		end
	end

	ns.Layout:Reload();

	if( self.infoFrame ) then
		self.infoFrame:Hide()
	end

	--WSUF.Layout:Reload();
	self.isConfigModeSpec = nil;
	self.isEnabled = nil;
end

OnDragStop = function(self)
	if (not self:IsMovable()) then return end

	--self header or unitFrame
	self = ns.styles[ns.db.profile.currentStyle].headerFrames[self.unitType] or ns.styles[ns.db.profile.currentStyle].unitFrames[self.unitType];
	
	self.isMoving = nil;
	self:StopMovingOrSizing();

	local scale = (self:GetScale() * UIParent:GetScale()) or 1;
	local position = ns.Module:GetUnitPosition(self.unitType);
	local point, _, relativePoint, x, y = self:GetPoint();
	
	if (self.isHeaderFrame) then
		local _unitConfig = ns.Module:GetUnitDB(self.unitType).parent;
		if( _unitConfig.attribAnchorPoint == "RIGHT" ) then
			x = self:GetRight()
			point = "RIGHT"
		else
			x = self:GetLeft()
			point = "LEFT"
		end
		
		if( _unitConfig.attribPoint == "BOTTOM" ) then
			y = self:GetBottom()
			point = "BOTTOM" .. point
		else
			y = self:GetTop()
			point = "TOP" .. point
		end
		
		relativePoint = "BOTTOMLEFT"
		position.bottom = self:GetBottom() * scale
		position.top = self:GetTop() * scale
	end

	position.anchorTo = "UIParent";
	position.movedAnchor = nil;
	position.anchorPoint = "";
	position.selfPoint = point;
	position.relativePoint = relativePoint;
	position.x = x * scale;
	position.y = y * scale;

	WSUF.Layout:AnchorFrame(UIParent, self, ns.Module:GetUnitPosition(self.unitType));

	local ACR = LibStub("AceConfigRegistry-3.0", true)
	if( ACR ) then
		ACR:NotifyChange("WSUnitFrame")
	end
end

OnDragStart = function(self)
	if ( not self:IsMovable()) then return end
	--self header or unitFrame
	self = ns.styles[ns.db.profile.currentStyle].headerFrames[self.unitType] or ns.styles[ns.db.profile.currentStyle].unitFrames[self.unitType];
	
	self.isMoving = true;
	self:StartMoving();
end

function Movers:Update()
	if (not ns.db.profile.locked) then
		self:Enable()
	else
		self:Disable()
	end
end

function Movers:CreateInfoFrame()
	if( self.infoFrame ) then return end
	
	-- Show an info frame that users can lock the frames through
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:SetClampedToScreen(true)
	frame:SetWidth(300)
	frame:SetHeight(145)
	frame:RegisterForDrag("LeftButton")
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:SetScript("OnEvent", function(self)
		if( not ns.db.profile.locked and self:IsVisible() ) then
			ns.db.profile.locked = true
			Movers:Disable()
			
			DEFAULT_CHAT_FRAME:AddMessage(L["You have entered combat, unit frames have been locked."])
		end
	end)
	frame:SetScript("OnShow", OnShow)
	frame:SetScript("OnHide", OnHide)
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	frame:SetBackdrop({
		  bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		  edgeSize = 26,
		  insets = {left = 9, right = 9, top = 9, bottom = 9},
	})
	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 225)

	frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
	frame.titleBar:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	frame.titleBar:SetPoint("TOP", 0, 8)
	frame.titleBar:SetWidth(350)
	frame.titleBar:SetHeight(45)

	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	frame.title:SetPoint("TOP", 0, 0)
	frame.title:SetText(L["Wowshell Unit Frames"])

	frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	frame.text:SetText(L["The unit frames you see are examples, they are not perfect and do not show all the data they normally would.|n|nYou can hide them by locking them through clicking the button below."])
	frame.text:SetPoint("TOPLEFT", 12, -22)
	frame.text:SetWidth(frame:GetWidth() - 20)
	frame.text:SetJustifyH("LEFT")

	frame.lock = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
	frame.lock:SetText(L["Lock frames"])
	frame.lock:SetHeight(20)
	frame.lock:SetWidth(100)
	frame.lock:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -6, 8)
	frame.lock:SetScript("OnEnter", OnEnter)
	frame.lock:SetScript("OnLeave", OnLeave)
	frame.lock.tooltipText = L["Locks the unit frame positionings hiding the mover boxes."]
	frame.lock:SetScript("OnClick", function()
		ns.db.profile.locked = true
		Movers:Update()
		StaticPopup_Show'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
	end)

	self.infoFrame = frame
end
