local parent, ns = ...;
local oUF = ns.oUF;
local L = ns.L;

local Module = {
	unitFrames = {},
	unitEvents = {},
	headerFrames = {},
	frameList = {},
	units = {}
};
ns.Module = Module;
--Module.childUnits = {["partytarget"] = "party", ["partypet"] = "party", ["maintanktarget"] = "maintank", ["mainassisttarget"] = "mainassist", ["bosstarget"] = "boss", ["arenatarget"] = "arena", ["arenapet"] = "arena"}
Module.childUnits = {["bosstarget"] = "boss", }--["arenatarget"] = "arena", ["arenapet"] = "arena"}
Module.zoneUnits = {["arena"] = "arena", ["boss"] = "raid"}

local staticMonitor = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate");
Module.staticMonitor = staticMonitor;

do
	local GLOBAL_SCALE = UIParent:GetEffectiveScale();
	local styleFuncs = {
		common = {},
	}

	Module.styleFuncs = styleFuncs
	local function addElement(unit, func)
		local funcs = styleFuncs[unit]
		if(not funcs) then
			funcs = {}
			styleFuncs[unit] = funcs
		end
		tinsert(funcs, func)
	end

	function Module:addLayoutElement(units, func)
		if not (units and func) then
			--oUF.error()
			return
		end
		if(type(units) == 'table') then
			for k, v in pairs(units) do
				addElement(v, func)
			end
		else
			addElement(units, func)
		end
	end

	function Module:addCommonElement(func)
		addElement('common', func)
	end

	function Module:setSize(unit, w, h, scale)
		if(unit and w) then
			local func = function(self, unit)
				self:SetSize(w, h)
				self:SetScale((scale or 1) * GLOBAL_SCALE)
				--self:SetAttribute('initial-width', w)
				--self:SetAttribute('initial-height', h or w)
				--self:SetAttribute('initial-scale', (scale or 1) * GLOBAL_SCALE)
			end
			self:addLayoutElement(unit, func)
		end
	end

	local callbacks = {}
	function Module:spawn(func)
		table.insert(callbacks, func)
	end

	function Module:LoadZoneHeader(type)
		if (self.headerFrames[type]) then
			self.headerFrames[type]:Show();
			return self.headerFrames[type];
		end

		local headerFrame = CreateFrame("Frame", "WSUFHeader_".. type, UIParent);
		headerFrame.isHeaderFrame = true;
		headerFrame.unitType = type;
		headerFrame:SetClampedToScreen(true);
		headerFrame:SetMovable(true);
		headerFrame:SetHeight(0.1);
		headerFrame.children = {};
		self.headerFrames[type] = headerFrame;

		if ( type == "arena") then
			headerFrame:SetScript("OnAttributeChanged", function(self, key, value)
				if( key == "childChanged" and value and self.children[value] and self:IsVisible() ) then
					self.children[value]:FullUpdate()
				end
			end)
			return;
		end

		for id, unit in pairs(WSUF[type .. "Units"]) do
			local f = CreateFrame("Button", "WSUFHeader_"..type.. "UnitButton"..id, headerFrame, "SecureUnitButtonTemplate");
			f.unit = unit;
			f.unitType = headerFrame.unitType;
			f._isChildren = true;
			f.ignoreAnchor = true;

			f = oUF:Spawn(unit, f);
			f:Hide();
			headerFrame.children[id] = f;
			WSUF.Layout:Load(f);
		end

		self:SetHeaderAttributes(headerFrame, type);
		ns.Layout:AnchorFrame(UIParent, headerFrame, self:GetUnitPosition(type))
	end

	function Module:LoadChildUnit(parent, type, id)
		--防止二次加载
		for frame in pairs(self.frameList) do
			if (frame.unitType == type and frame.parent == parent) then
				return;
			end
		end

		parent.hasChildren = true;
		local frame = CreateFrame("Button", "WSUFChild_"..type .. string.match(parent:GetName(), "(%d+)"), parent, "SecureUnitButtonTemplate");
		frame.unitType = type;
		frame.parent = parent;
		frame.isChildUnit = true;
		frame._isChildren = true;
		frame:SetFrameStrata("LOW");
		frame:SetAttribute("useparent-unit", true);
		frame:SetAttribute("unitsuffix", string.match(type, "pet$") and "pet" or "target");
		frame:SetAttribute("oUF-guessUnit", unit);
		local unit = SecureButton_GetModifiedUnit(frame);
		frame:SetAttribute("unitsuffix", nil);
		frame = oUF:Spawn(unit, frame);


		WSUF.Layout:Load(frame);
		ns.Layout:AnchorFrame(parent, frame, self:GetUnitPosition(type));
	end

	function Module:SpawnUnits()
		-- don't spawn twice
		if(not self.spawned) then
			--加载file中有spawn的
			for k, func in ipairs(callbacks) do
				local ok, frame = ns.exec(func);
				if ok and frame then
					if frame.isHeaderFrame then

					else
						WSUF.Layout:Load(frame);
					end
				end
			end

			--load childUnits, ext: bosstarget, arenatarget, arenapet
			--partypet and partytarget has touched oUF for loading
			--clone a frameList, when oUF spawn a childUnit, it will insert childUnit frame into frameList
			--cause frameList table is not right, in other word, the position of the table's elements have been changed.
			--So i have created a temp cache list.
			local tempFrameList = CopyTable(self.frameList);
			for type, _ in pairs(self.childUnits) do
				for frame in pairs(tempFrameList) do
					if (frame.unitType == self.childUnits[type] and frame.unitID) then
						self:LoadChildUnit(frame, type, frame.unitID);
					end
				end
			end
			wipe(tempFrameList);

			self.spawned = true
		end
	end

	-- First register style
	-- load units
	function Module:RegisterOUFStyle(parent)
		oUF:RegisterStyle(parent, function(self, unit)
			if (not unit and self:GetParent().unitType) then
				unit = self:GetParent().unitType;
			end

			if (self._isChildren) then
				unit = self.unitType;
			end

			for _, func in pairs(styleFuncs.common) do
				func(self, unit);
			end
			local funcs = styleFuncs[unit]
			if (funcs) then
				for i = 1, #funcs do
					local func = funcs[i]
					ns.exec(func, self, unit)
				end
			else
				oUF.error("There's no style registered for [%s].", unit)
			end
		end)
		oUF:SetActiveStyle(parent)
	end

	local function merge(dest, src)
		for key, value in pairs(src) do
			if type(value) == "table" then
				if not rawget(dest, key) then rawset(dest, key, {}) end
				if type(dest[key] == "table") then
					merge(dest[key], value);
				end
			else
				if (rawget(dest, key) == nil) then
					rawset(dest, key, value);
				end
			end
		end
	end

	function Module:RegisterUnitDB(unit, defaults)
		local db = WSUF:GetCurrentStyleDB();
		if (not db.units[unit]) then
			db.units[unit] = {};
		end
		--metadata?
		merge(db.units[unit], defaults);
		return db.units[unit]
	end

	function Module:GetUnitDB(unit)
		local db = WSUF:GetCurrentStyleDB();
		return db.units[unit]	
	end

	function Module:RegisterUnitPosition(unit, position)
		local db = WSUF:GetCurrentStyleDB();
		if (not db.positions[unit]) then
			db.positions[unit] = {};
		end
		merge(db.positions[unit], position);
		return db.positions[unit];
	end

	function Module:GetUnitPosition(unit)
		local db = WSUF:GetCurrentStyleDB();
		return db.positions[unit]
	end

	function Module:RegisterUnitOptions(key, option)
		ns:RegisterUnitOptions(key, option);
	end

	function Module:order()
		return ns.order();
	end
end

---------------------------------------------------------------------------
------  Unit Method
---------------------------------------------------------------------------
local function FullUpdate(self)
	for i = 1, #(self.fullUpdates), 2 do
		local handler = self.fullUpdates[i]
		handler[self.fullUpdates[i + 1]](handler, self)
	end
end

local function RegisterNormalEvent(self, event, handler, func)
	self.Handler:RegisterEvent(event)
	self.registeredEvents[event] = self.registeredEvents[event] or {}
	-- Each handler can only register an event once per a frame.
	if( self.registeredEvents[event][handler] ) then
		return
	end
	self.registeredEvents[event][handler] = func
end

local function UnregisterEvent(self, event, handler)
	if( self.registeredEvents[event] ) then
		self.registeredEvents[event][handler] = nil

		local hasHandler
		for handler in pairs(self.registeredEvents[event]) do
			hasHandler = true
			break
		end

		if( not hasHandler ) then
			self.Handler:UnregisterEvent(event)
		end
	end
end

local function RegisterUnitEvent(self, event, handler, func)
	Module.unitEvents[event] = true
	RegisterNormalEvent(self, event, handler, func)
end

local function RegisterUpdateFunc(self, handler, func)
	for i=1, #(self.fullUpdates), 2 do
		local data = self.fullUpdates[i]
		if( data == handler and self.fullUpdates[i + 1] == func ) then
			return
		end
	end

	table.insert(self.fullUpdates, handler)
	table.insert(self.fullUpdates, func)
end

local function UnregisterUpdateFunc(self, handler, func)
	for i=#(self.fullUpdates), 1, -1 do
		if( self.fullUpdates[i] == handler and self.fullUpdates[i + 1] == func ) then
			table.remove(self.fullUpdates, i + 1)
			table.remove(self.fullUpdates, i)
		end
	end
end

local function UnregisterAll(self, handler)
	for i=#(self.fullUpdates), 1, -1 do
		if( self.fullUpdates[i] == handler ) then
			table.remove(self.fullUpdates, i + 1)
			table.remove(self.fullUpdates, i)
		end
	end

	for event, list in pairs(self.registeredEvents) do
		list[handler] = nil

		local hasRegister
		for handler in pairs(list) do
			hasRegister = true
			break
		end

		if( not hasRegister ) then
			self.Handler:UnregisterEvent(event)
		end
	end
end

--self.Handler event
local function OnEvent(self, event, unit, ...)
	local self = self.parent;
	if( not Module.unitEvents[event] or self.unit == unit ) then
		if (not self.registeredEvents[event]) then return end
		for handler, func in pairs(self.registeredEvents[event]) do
			handler[func](handler, self, event, unit, ...)
		end
	end
end

local function ShowMenu(self, unit)
	if( UnitIsUnit(self.unit, "player") ) then
		ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "cursor")
	elseif( self.unit == "pet" or self.unit == "vehicle" ) then
		ToggleDropDownMenu(1, nil, PetFrameDropDown, "cursor")
	elseif( self.unit == "target" ) then
		ToggleDropDownMenu(1, nil, TargetFrameDropDown, "cursor")
	elseif( self.unitType == "boss" ) then
		ToggleDropDownMenu(1, nil, _G["Boss" .. self.unitID .. "TargetFrameDropDown"], "cursor")
	elseif( self.unit == "focus" ) then
		ToggleDropDownMenu(1, nil, FocusFrameDropDown, "cursor")
	elseif( self.unitRealType == "party" ) then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame" .. self.unitID .. "DropDown"], "cursor")
	elseif( self.unitRealType == "raid" ) then
		HideDropDownMenu(1)
		
		local menuFrame = FriendsDropDown
		menuFrame.displayMode = "MENU"
		menuFrame.initialize = RaidFrameDropDown_Initialize
		menuFrame.userData = self.unitID
		menuFrame.unit = self.unitOwner
		menuFrame.name = UnitName(self.unitOwner)
		menuFrame.id = self.unitID
		ToggleDropDownMenu(1, nil, menuFrame, "cursor")
	end	
end

local function TargetUnitUpdate(self, elapsed)
	local self = self.parent;
	self.timeElapsed = self.timeElapsed + elapsed
	if( self.timeElapsed >= 0.50 ) then
		self.timeElapsed = self.timeElapsed - 0.50
		
		-- Have to make sure the unit exists or else the frame will flash offline for a second until it hides
		if( UnitExists(self.unit) ) then
			self:FullUpdate()
		end
	end
end

local function OnAttributeChanged(self, name, unit, ...)
	if( name ~= "unit" or not unit or unit == self.unitOwner ) then return end

	if( self.unit and Module.unitFrames[self.unit] == self ) then Module.unitFrames[self.unit] = nil end

	self.unit = unit;
	self.unitID = tonumber(string.match(unit, "([0-9]+)"));
	self.unitRealType = string.gsub(unit, "([0-9]+)", "");
	self.unitType = self.unitType or self.unitRealType;
	self.unitOwner = unit;
	self.vehicleUnit = self.unitOwner == "player" and "vehicle" or self.unitRealType == "party" and "partypet" .. self.unitID or self.unitRealType == "raid" and "raidpet" .. self.unitID or nil
	self.inVehicle = nil;

	if (self.unitRealType == self.unitType) then
		Module.unitFrames[unit] = self;		
	end

	Module.frameList[self] = true;

	if (self.unitInitialized) then
		self:FullUpdate();
		return;
	end
		
	self.unitInitialized = true;

	if (self.unit == "player" or self.unitRealType == "party") then
		self:RegisterNormalEvent("UNIT_ENTERED_VEHICLE", Module, "CheckVehicleStatus");
		self:RegisterNormalEvent("UNIT_EXITED_VEHICLE", Module, "CheckVehicleStatus");
		self:RegisterUpdateFunc(Module, "CheckVehicleStatus");
	end

	if (self.unit == "player") then
		self:RegisterNormalEvent("PLAYER_ALIVE", self, "FullUpdate");
	elseif (self.unit == "pet" or self.unitType == "partypet") then
		self.unitRealOwner = self.unit == "pet" and "player" or ns.partyUnits[self.unitID]
		self:RegisterNormalEvent("UNIT_PET", Module, "CheckPetUnitUpdated")
	elseif (self.unit == "target") then
		self:RegisterNormalEvent("PLAYER_TARGET_CHANGED", Module, "CheckUnitStatus");
		self:RegisterNormalEvent("PLAYER_TARGET_CHANGED", self, "UpdateAllTags");
	elseif (self.unitRealType == "party") then
		self:RegisterNormalEvent("PARTY_MEMBERS_CHANGED", Module, "CheckGroupedUnitStatus");
		self:RegisterNormalEvent("UNIT_NAME_UPDATE", Module, "CheckUnitStatus");
	elseif (self.unitType == "boss") then
		self:RegisterNormalEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", self, "FullUpdate")
	elseif (self.unit == "focus") then
		self:RegisterNormalEvent("PLAYER_FOCUS_CHANGED", Module, "CheckUnitStatus");
	elseif (ns.fakeUnits[self.unitRealType]) then
		self.timeElapsed = 0;
		self.Handler:SetScript("OnUpdate", TargetUnitUpdate);

		if( self.unitRealType == "partytarget" ) then
			self.unitRealOwner = ns.partyUnits[self.unitID]
		elseif( self.unitRealType == "raid" ) then
			self.unitRealOwner = ns.raidUnits[self.unitID]
		elseif( self.unitRealType == "arenatarget" ) then
			self.unitRealOwner = ns.arenaUnits[self.unitID]
		elseif( self.unit == "focustarget" ) then
			self.unitRealOwner = "focus"
			self:RegisterNormalEvent("PLAYER_FOCUS_CHANGED", Module, "CheckUnitStatus")
		elseif( self.unit == "targettarget" or self.unit == "targettargettarget" ) then
			self.unitRealOwner = "target"
			self:RegisterNormalEvent("PLAYER_TARGET_CHANGED", Module, "CheckUnitStatus")
		end
		self:RegisterNormalEvent("UNIT_TARGET", Module, "CheckPetUnitUpdated")
	end

	self:RegisterUpdateFunc(self, "UpdateAllTags");
	self.menu = ShowMenu;
	self:FullUpdate();
	Module:CheckUnitStatus(self);
end

Module.OnAttributeChanged = OnAttributeChanged;

-- Vehicles do not always return their data right away, a pure OnUpdate check seems to be the most accurate unfortunately
local function checkVehicleData(self, elapsed)
	self.timeElapsed = self.timeElapsed + elapsed
	if( self.timeElapsed >= 0.50 ) then
		self.timeElapsed = 0
		self.dataAttempts = self.dataAttempts + 1

		-- Took too long to get vehicle data, or they are no longer in a vehicle
		if( self.dataAttempts >= 6 or not UnitHasVehicleUI(self.unitOwner) ) then
			self.timeElapsed = nil
			self.dataAttempts = nil
			self:SetScript("OnUpdate", nil)

			self.inVehicle = false
			self.unit = self.unitOwner
			self:FullUpdate()

			-- Got data, stop checking and do a full frame update
		elseif( UnitIsConnected(self.unit) or UnitHealthMax(self.unit) > 0 ) then
			self.timeElapsed = nil
			self.dataAttempts = nil
			self:SetScript("OnUpdate", nil)

			self.unitGUID = UnitGUID(self.unit)
			self:FullUpdate()
		end
	end
end 

function Module:CheckVehicleStatus(frame, event, unit)
	if (event and frame.unitOwner ~= unit) then return end
	if ( (not frame.inVehicle or frame.unitGUID ~= UnitGUID(frame.vehicleUnit)) and UnitHasVehicleUI(frame.unitOwner)) then
		frame.inVehicle = true;
		frame.unit = frame.vehicleUnit;

		if (not UnitIsConnected(frame.unit) or UnitHealthMax(frame.unit) == 0) then
			frame.timeElapsed = 0;
			frame.dataAttempts = 0
			frame:SetScript("OnUpdate", checkVihicleData);
		else
			frame.unitGUID = UnitGUID(frame.unit);
			frame:FullUpdate();
		end
	elseif (frame.inVehicle and (not UnitHasVehicleUI(frame.unitOwner))) then
		frame.inVehicle = false;
		frame.unit = frame.unitOwner;
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate();
	end
end

function Module:CheckUnitStatus(frame)
	local guid = frame.unit and UnitGUID(frame.unit);
	if (guid ~= frame.unitGUID) then
		frame.unitGUID = guid;
		if (guid) then
			frame:FullUpdate();
		end
	end
end

function Module:CheckGroupedUnitStatus(frame)
	if(frame.inVehicle and not UnitExists(frame.unit) and UnitExists(frame.unitOwner) ) then
		frame.inVehicle = false
		frame.unit = frame.unitOwner
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	else
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	end
end

function Module:CheckPetUnitUpdated(frame, event, unit)
	if( unit == frame.unitRealOwner and UnitExists(frame.unit) ) then
		frame.unitGUID = UnitGUID(frame.unit)
		frame:FullUpdate()
	end
end

local function OnShow(self)
	-- Reset the event handler
	self:SetScript("OnEvent", OnEvent)
	Module:CheckUnitStatus(self.parent)
end

local function OnHide(self)
	self:SetScript("OnEvent", nil)
	
	if( self.parent.isUnitVolatile or self:IsShown() ) then
		self.parent.unitGUID = nil
	end
end

local function UpdateAllTags(self)
	for _, tag in pairs(self.tags) do
		if (tag.UpdateTags) then
			tag:UpdateTags();
		end
	end
end

--load and initial
local function CreateUnit(self, unit)
	if (not self.unit) then
		local header = self:GetParent();
		local unitType;
		if (header and header.unitType) then
			unitType = header.unitType;
		end
		if (unitType == "party") then
			unit = unitType;
		end
		local name = self:GetName();
		local id = name:match("^.+(%d+)");
		local suffix = self:GetAttribute("unitsuffix");
		if (suffix) then
			unit = "party"..id..suffix;
		else
			unit = "party"..id;
		end
	end

	local bg = CreateFrame('Frame', nil, self)
	bg:SetAllPoints(self)
	bg:SetFrameStrata('BACKGROUND');
	self.bg = bg
	local Handler = CreateFrame("Frame", nil, self);
	Handler.parent = self;
	self.tags = self.tags or {}
	self.Handler = Handler;
	self.fullUpdates = {};
	self.registeredEvents = {}
	self.visibility = {}
	self.topFrameLevel = 5;
	self.RegisterNormalEvent = RegisterNormalEvent
	self.RegisterUnitEvent = RegisterUnitEvent
	self.RegisterUpdateFunc = RegisterUpdateFunc
	self.UnregisterAll = UnregisterAll
	self.UnregisterSingleEvent = UnregisterEvent
	self.FullUpdate = FullUpdate
	self.UpdateAllTags = UpdateAllTags;
	self:HookScript("OnAttributeChanged", OnAttributeChanged);
	self.Handler:SetScript("OnEvent", OnEvent);
	self.Handler:SetScript("OnShow", OnShow);
	self.Handler:SetScript("OnHide", OnHide);
	self:SetScript('OnEnter', UnitFrame_OnEnter);
	self:SetScript('OnLeave', UnitFrame_OnLeave);
	self:HookScript("OnEvent", function(self, event, unit, ...)
		OnEvent(self.Handler, event, unit, ...);
	end);

	self.menu = ShowMenu;
	if (not InCombatLockdown()) then
		self:RegisterForClicks("AnyUp");
		self:SetAttribute("type2", "menu");
	end

	if(unit=='focus') then
		self:SetAttribute('Shift-type1', 'macro')
		self:SetAttribute('macrotext', '/clearfocus')
	else
		self:SetAttribute('Shift-type1', 'focus')
	end

	if (self:GetAttribute("unit") == nil) then
		--reupdate
		OnAttributeChanged(self, "unit", unit)
	end

	return self
end

function Module:CreateUnit(frame, unit)
	CreateUnit(frame, unit)
end

Module:addCommonElement(CreateUnit)

oUF:AddElement("WSUF_TAGS", function(self, event, unit)
	if self and self.Handler then
		OnEvent(self.Handler, event, unit);
	end
end, function(self,event, unit)
	if self and self.Handler then
		OnEvent(self.Handler, unit);
	end
end)

Module:addCommonElement(function(self, unit)
    self.disallowVehicleSwap = true
    if unit and (
       ( unit == 'pet' )
    or ( unit == 'player' )
    or ( unit == 'partypet' )
    or ( unit == 'party' )
    or ( string.match(unit, '^party(%d)$'))
    or ( string.match(unit, '^party(%d)pet$'))
    ) then
        self.disallowVehicleSwap = nil
    end
end)

oUF:RegisterInitCallback(function(self)
    -- force update after frame create
    -- need for in-game load
    self:UpdateAllElements'OnCreateUpdate'
end)


function Module:SetHeaderAttributes(frame, type)
	local pconfig = self:GetUnitDB(type);
	if (pconfig == nil) then
		return;
	end
	local config = pconfig.parent or pconfig.Parent;	
	local xMod = config.attribPoint == "LEFT" and 1 or config.attribPoint == "RIGHT" and - 1 or 0;
	local yMod = config.attribPoint == "TOP" and -1 or config.attribPoint == "BOTTOM" and 1 or 0;
	local widthMod = (config.attribPoint == "LEFT" or config.attribPoint == "RIGHT") and MEMBERS_PER_RAID_GROUP or 1
	local heightMod = (config.attribPoint == "TOP" or config.attribPoint == "BOTTOM") and MEMBERS_PER_RAID_GROUP or 1

	frame:SetAttribute("point", config.attribPoint)
	frame:SetAttribute("sortMethod", config.sortMethod)
	frame:SetAttribute("sortDir", config.sortOrder)
	
	frame:SetAttribute("xOffset", config.offset * xMod)

	local yOffset = config.offset * yMod;
	frame:SetAttribute("yOffset", yOffset)
	frame:SetAttribute("xMod", xMod)
	frame:SetAttribute("yMod", yMod)

	if (type == "boss" or type == "arena") then
		frame:SetWidth(config.width);
		self:PositionHeaderChildren(frame);	
	elseif (type == "party") then
		frame:SetAttribute("maxColumns", math.ceil((config.showPlayer and 5 or 4) / config.unitsPerColumn))
		frame:SetAttribute("unitsPerColumn", config.unitsPerColumn)
		frame:SetAttribute("columnSpacing", config.columnSpacing)
		frame:SetAttribute("columnAnchorPoint", config.attribAnchorPoint)
	end
end

function Module:PositionHeaderChildren(frame)
	local point = frame:GetAttribute("point") or "TOP"
	local relativePoint = "BOTTOM";
	if( #(frame.children) == 0 ) then return end

	local xMod, yMod = math.abs(frame:GetAttribute("xMod")), math.abs(frame:GetAttribute("yMod"))
	local x = frame:GetAttribute("xOffset") or 0
	local y = frame:GetAttribute("yOffset") or 0

	for id, child in pairs(frame.children) do
		if( id > 1 ) then
			frame.children[id]:ClearAllPoints()
			frame.children[id]:SetPoint(point, frame.children[id - 1], relativePoint, xMod * x, yMod * y)
		else
			frame.children[id]:ClearAllPoints()
			frame.children[id]:SetPoint(point, frame, point, 0, 0)
		end
	end
end

--------------------------------------------------------------
-----  utils
--------------------------------------------------------------
local utils = {}
Module.utils = utils
utils.backdrop = {
    bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
    insets = {top = -1, left = -1, bottom = -1, right = -1},
}

function utils.adjustCoord(bool, texture)
    if(bool and texture.SetTexCoord) then
        texture:SetTexCoord(1,0,0,1)
    end
end

function utils.utf8sub(str, num)
    local i = 1
    while num > 0 and i <= #str do
        local c = strbyte(str, i)
        if(c >= 0 and c <= 127) then
            i = i + 1
        elseif(c >= 194 and c <= 223) then
            i = i + 2
        elseif(c >= 224 and c <= 239) then
            i = i + 3
        elseif(c >= 240 and c <= 224) then
            i = i + 4
        end
        num = num - 1
    end

    return str:sub(1, i - 1)
end

function utils.truncate(value)
    if(value >= 1e6) then
        value = format("%.1fm", value / 1e6)
    elseif(value >= 1e3) then
        value = format("%.1fk", value / 1e3)
    end
    return gsub(value, "%.?0+([km])$", "%1")
end

function utils.setSize(f, w, h)
    if(f and f.SetWidth and f.SetHeight and w) then
        f:SetWidth(w)
        f:SetHeight(h or w)
    end
end

function utils.testBackdrop(f)
    f:SetBackdrop(utils.backdrop)
    --f:SetBackdropColor(0,0,0, .5)
    f:SetBackdropColor(1,0,0,.5)
end

function utils.reverseTexture(tex)
    tex:SetTexCoord(1,0,0,1)
end

function utils.updateTapedBg(self)
    if(not UnitPlayerControlled(self.unit) and UnitIsTapped(self.unit) and not UnitIsTappedByPlayer(self.unit) and not UnitIsTappedByAllThreatList(self.unit)) then
        self.namebg:SetStatusBarColor(.5, .5, .5)
    else
        self.namebg:SetStatusBarColor(UnitSelectionColor(self.unit))
    end
end


do
	local _MINE = {
		player = true,
		pet = true,
		vehicle = true,
	}

	local function isMine(icons, unit, icon, index, offset)
		local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, icon.filter)
		return caster and _MINE[caster]
	end

	function utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, show, mine)
		if(show and icon.cd:IsShown()) then
			if(mine) then
				if(isMine(icons, unit, icon, index, offset)) then
					icon.cd:Show()
				else
					icon.cd:Hide()
				end
			else
				icon.cd:Show()
			end
		else
			icon.cd:Hide()
		end
	end
end

function utils.updateAuraElement(frame)
	local buffs = self.Buffs
	if(buffs) then
		buffs:ForceUpdate()
	end

	local debuffs = self.Debuffs
	if(debuffs) then
		debuffs:ForceUpdate()
	end

	local auras = self.Auras
	if(auras) then
		auras:ForceUpdate()
	end
end
