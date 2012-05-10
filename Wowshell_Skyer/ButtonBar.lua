local Bar = Skylark.Bar.prototype;
local ButtonBar = setmetatable({}, {__index=Bar});
local ButtonBar_MT = {__index=ButtonBar};

local defaults = Skylark:Merge({
	padding = 2,
	rows = 1,
	hidemacrotext = false,
	hidehotkey = false,
	skin = {
		ID = "Caith",
		Backdrop = false,
		Gloss = 0,
		Zoom = false,
		Colors = {},
	},
}, Skylark.Bar.defaults);

Skylark.ButtonBar = {}
Skylark.ButtonBar.prototype = ButtonBar
Skylark.ButtonBar.defaults = defaults

local LBF = LibStub("LibButtonFacade", true);
local Masque = LibStub("Masque", true);

function Skylark.ButtonBar:Create(id, cfg, name)
	local bar = setmetatable(Skylark.Bar:Create(id, cfg, name), ButtonBar_MT);
	
	if Masque then
		bar.MasqueGroup = Masque:Group("Skylark", tostring(id))
	elseif LBF then
		bar.LBFGroup = LBF:Group("Skylark", tostring(id));
		bar.LBFGroup.SinkID = cfg.skin.ID or "Blizzard";
		bar.LBFGroup.Backdrop = cfg.skin.Backdrop;
		bar.LBFGroup.Gloss = cfg.skin.Gloss
		bar.LBFGroup.Colors = cfg.skin.Colors

		LBF:RegisterSkinCallback("Skylark", self.SkinChanged, self)
	end

	return bar
end

local barregistry = Skylark.Bar.barregistry
function Skylark.ButtonBar:SkinChanged(SkinID, Gloss, Backdrop, Group, Button, Colors)
	local bar = barregistry[tostring(Group)];
	if not bar then return end
	bar:SkinChanged(SkinID, Gloss, Backdrop, Colors, Button)
end

function ButtonBar:UpdateSkin()
	if not self.LBFGroup then return end
	local cfg = self.cfg.skin
	self.LBFGroup:Skin(cfg.ID, cfg.Gloss, cfg.Backdrop, cfg.Colors)
end

function ButtonBar:ApplyConfig(config)
	Bar.ApplyConfig(self, config);
	ButtonBar.UpdateSkin(self)
end

function ButtonBar:GetPadding()
	return self.cfg.padding
end

function ButtonBar:SetPadding(pad)
	if pad ~= nil then
		self.cfg.padding = pad
	end
	self:UpdateButtonLayout()
end

function ButtonBar:GetRows()
	return self.cfg.rows
end

function ButtonBar:SetRows(row)
	if row ~= nil then
		self.cfg.rows = row
	end
	self:UpdateButtonLayout()
end

function ButtonBar:GetZoom()
	return self.cfg.skin.Zoom
end

function ButtonBar:SetZoom(zoom)
	self.cfg.skin.Zoom = zoom
	self:UpdateButtonLayout();
end

function ButtonBar:GetHideMacroText()
	return self.cfg.hidemacrotext
end

function ButtonBar:SetHideMacroText(state)
	if state ~= nil then
		self.cfg.hidemacrotext = state
	end
	self:ForAll("ToggleButtonElements")
end

function ButtonBar:GetHideHotKey()
	return self.cfg.hidehotkey
end

function ButtonBar:SetHideHotKey(state)
	if state ~= nil then
		self.cfg.hidehotkey = state
	end
	self:ForAll("UpdateHotkeys")
end

function ButtonBar:SetHGrowth(val)
	self.cfg.position.growHorizontal = val
	self:AnchorOverlay()
	self:UpdateButtonLayout()
end

function ButtonBar:GetHGrowth()
	return self.cfg.position.growHorizontal
end

function ButtonBar:SetVGrowth(val)
	self.cfg.position.growVertical = val
	self:AnchorOverlay()
	self:UpdateButtonLayout();
end

function ButtonBar:GetVGrowth()
	return self.cfg.position.growVertical
end

ButtonBar.button_width = 36
ButtonBar.button_height = 36
function ButtonBar:UpdateButtonLayout()
	local buttons = self.buttons
	local pad = self:GetPadding();

	local numbuttons = self.numbuttons or #buttons
	if numbuttons == 0 then return end
	
	local Rows = self:GetRows()
	local ButtonPerRow = math.ceil(numbuttons / Rows)
	Rows = math.ceil(numbuttons / ButtonPerRow);
	if Rows > numbuttons then
		Rows = numbuttons
		ButtonPerRow = 1
	end

	local hpad = pad + (self.hpad_offset or 0)
	local vpad = pad + (self.vpad_offset or 0)

	self:SetSize((self.button_width + hpad) * ButtonPerRow - pad + 10, (self.button_height + vpad) * Rows - pad + 10)

	local h1, h2, v1, v2
	local xOff, yOff
	if self.cfg.position.growHorizontal == "RIGHT" then
		h1, h2 = "LEFT", "RIGHT"
		xOff = 5
	else
		h1, h2 = "RIGHT", "LEFT"
		xOff = -3

		hpad = -hpad
	end

	if self.cfg.position.growVertical == "DOWN" then
		v1, v2 = "TOP", "BOTTOM"
		yOff = -3
	else
		v1, v2 = "BOTTOM", "TOP"
		yOff = 5

		vpad = -vpad
	end

	local anchor = self:GetAnchor()
	buttons[1]:ClearSetPoint(anchor, self, anchor, xOff - (self.hpad_offset or 0), yOff - (self.vpad_offset or 0))
	
	for i = 2, numbuttons do
		-- jump into a new row
		if ((i-1) % ButtonPerRow) == 0 then
			buttons[i]:ClearSetPoint(v1 .. h1, buttons[i-ButtonPerRow], v2 .. h1, 0, -vpad)
		-- align to the previous button
		else
			buttons[i]:ClearSetPoint("TOP" .. h1, buttons[i-1], "TOP" .. h2, hpad, 0)
		end
	end
end

function ButtonBar:SkinChanged(SkinId, Gloss, Backdrop, Colors)
	self.cfg.skin.ID = SkinID
	self.cfg.skin.Gloss = Gloss
	self.cfg.skin.Backdrop = Backdrop
	self.cfg.skin.Colors = Colors
end

function ButtonBar:GetAll()
	return pairs(self.buttons)
end

function ButtonBar:ForAll(method, ...)
	if not self.buttons then return end
	for _, button in self:GetAll() do
		local func = button[method];
		if func then
			func(button, ...)
		end
	end
end
