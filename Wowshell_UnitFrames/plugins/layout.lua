local parent, ns = ...;
local oUF = ns.oUF;
local L = ns.L
local Module = ns.Module;
local SML = LibStub:GetLibrary("LibSharedMedia-3.0")
local Layout = {};
ns.Layout = Layout;
local anchoringQueued;

function Module:Reload(unit)
	for frame in pairs(Module.frameList) do
		if (frame.unit and (not unit or frame.unitType == unit) and not frame.isHeaderFrame) then
			--frame:SetVisibility();
			Layout:Load(frame);
			frame:FullUpdate();
		end
	end

	for header in pairs(Module.headerFrames) do
		if (header.unitType and (not unit or header.unitType == unit)) then
			local config = Module:GetUnitDB(header.unitType);
		end
	end
end

function Layout:Reload(unit)
	Module:Reload(unit)
end

function Layout:Load(frame)
	local db = WSUF:GetCurrentStyleDB();
	local unitConfig = db.units[frame.unitType];
		
	self:SetupFrame(frame, unitConfig);
	self:SetupText(frame, unitConfig);

	ns:FireModuleEvent("OnLayoutApplied", frame, unitConfig);
end

function Layout:SetupFrame(frame, unitConfig)
	if (not InCombatLockdown()) then
		if (not frame.ignoreAnchor) then
			self:AnchorFrame(frame.parent or UIParent, frame, ns.Module:GetUnitPosition(frame.unitType));
		end
	end

	if (anchoringQueued) then
		for queued in pairs(anchoringQueued) do
			if (queued.queuedName == frame:GetName()) then
				self:AnchorFrame(queued.queuedParent, queued, queued.queuedConfig);

				queued.queuedName = nil;
				queued.queuedConfig = nil;
				queued.queuedParent = nil;

				anchoringQueued[queued] = nil;
			end
		end
	end
end

function Layout:SetupFontString(fontString, extraSize)
	local size = 12 + (extraSize or 0);
	if size <= 0 then size = 1 end
	
	fontString:SetFont(SML:Fetch("font", "Myriad Condensed Web") ,12, "");
	fontString:SetShadowColor(0, 0, 0, 1);
	fontString:SetShadowOffset(0.8, -0.8);
end

local totalWeight = {}
function Layout:SetupText(frame, unitConfig)
	frame.tags = frame.tags or {};
	for _, fontString in pairs(frame.tags) do
		if (fontString.parent) then
			WSUF.Tags:Unregister(fontString);
			fontString:Hide();
		end
	end

	if (unitConfig == nil or (unitConfig and unitConfig.tags == nil)) then
		local type = frame.unitRealType;
		return;
	end
	for id, row in pairs(unitConfig.tags) do
		if (frame.tags[id]) then
			local fontString = frame.tags[id];
			if (fontString:GetFont() == nil) then
				self:SetupFontString(fontString);
			end
			fontString:SetText(row.tag);
			if (row.tag) then
				WSUF.Tags:Register(frame, fontString, row.tag);
				fontString:UpdateTags();
				fontString:Show();
			end
		end
	end
end

function Layout:AnchorFrame(parent, frame, config)
	if (not config or not config.anchorTo or not config.x or not config.y) then
		return 
	end

	local anchorTo = config.anchorTo;
	local prefix = string.sub(config.anchorTo, 0, 1);

	if ( config.anchorTo == "$parent" ) then
		anchorTo = parent;
	elseif (prefix == "$") then
		anchorTo = parent[string.sub(config.anchorTo, 2)];
	elseif (prefix == "#") then
		anchorTo = string.sub(config.anchorTo, 2);

		if (not _G[anchorTo]) then
			frame.queuedParent = parent;
			frame.queuedConfig = config;
			frame.queuedName = anchorTo;

			anchoringQueued = anchoringQueued or {};
			anchoringQueued[frame] = true;
			
			local unit = string.match(anchorTo, "wsUnitFrame_(%w+)");
			unit = unit:lower();
			if (unit and ns.Module:GetUnitPosition(unit)) then
				self:AnchorFrame(parent, frame, ns.Module:GetUnitPosition(unit))
			end
			return;
		end
	end

	local point = config.selfPoint;
	local relativePoint = config.relativePoint and config.relativePoint or "CENTER";
	local scale = 1;

	if (config.anchorTo == "UIParent" and frame.unitType) then
		scale = frame:GetScale() * UIParent:GetScale();
	end
	frame:ClearAllPoints();
	frame:SetPoint(point, anchorTo, relativePoint, config.x / scale, config.y / scale);
end


SML:Register(SML.MediaType.FONT, "Myriad Condensed Web", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\fonts\\Myriad Condensed Web.ttf")
SML:Register(SML.MediaType.BORDER, "Square Clean", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\ABFBorder")
SML:Register(SML.MediaType.BACKGROUND, "Chat Frame", "Interface\\ChatFrame\\ChatFrameBackground")
SML:Register(SML.MediaType.STATUSBAR, "BantoBar", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\banto")
SML:Register(SML.MediaType.STATUSBAR, "Smooth",   "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\smooth")
SML:Register(SML.MediaType.STATUSBAR, "Perl",     "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\perl")
SML:Register(SML.MediaType.STATUSBAR, "Glaze",    "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\glaze")
SML:Register(SML.MediaType.STATUSBAR, "Charcoal", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\Charcoal")
SML:Register(SML.MediaType.STATUSBAR, "Otravi",   "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\otravi")
SML:Register(SML.MediaType.STATUSBAR, "Striped",  "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\striped")
SML:Register(SML.MediaType.STATUSBAR, "LiteStep", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\LiteStep")
SML:Register(SML.MediaType.STATUSBAR, "Aluminium", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\Aluminium")
SML:Register(SML.MediaType.STATUSBAR, "Minimalist", "Interface\\AddOns\\Wowshell_UnitFrames\\media\\textures\\Minimalist")

