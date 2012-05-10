local ButtonBar = Skylark.ButtonBar.prototype
local ActionBar = setmetatable({}, {__index=ButtonBar});
local ActionBar_MT = {__index = ActionBar}

local defaults = Skylark:Merge({}, Skylark.ButtonBar.defaults)

Skylark.ActionBar = {}
Skylark.ActionBar.prototype = ActionBar
Skylark.ActionBar.defaults = defaults
function Skylark.ActionBar:Create(id, cfg, name)
	local bar = setmetatable(Skylark.ButtonBar:Create(id, cfg, name), ActionBar_MT)
	
	return bar
end

local function initBarPosition(bar)
	bar:ClearSetPoints("CENTER", 0, -250 + (bar.id - 1) * 38)
	bar:SavePosition()
end

function ActionBar:ApplyConfig(cfg)
	ButtonBar.ApplyConfig(self, cfg);

	if not self.cfg.position.x then
		initBarPosition(self)
	end

	self:UpdateButtons()
end

function ActionBar:UpdateButtons(numbuttons)
	if numbuttons then
		self.cfg.buttons = min(numbuttons, 12);
	else
		numbuttons = min(self.cfg.buttons, 12)
	end

	local buttons = self.buttons or {}
	for i = (#buttons+1), numbuttons do
		buttons[i] = Skylark.Button:Create(i, self);
	end

	for i = 1, numbuttons do
		buttons[i]:SetParent(self)
		buttons[i]:Show()
		buttons[i]:SetAttribute("statehidden", nil);
	end

	for i = (numbuttons+1), #buttons do
		buttons[i]:Hide()
		buttons[i]:SetParent(UIParent)
		buttons[i]:SetAttribute("statehidden", true)
	end

	self.numbuttons = numbuttons
	self.buttons = buttons
	self:SetGrid()
	self:UpdateButtonLayout()
end

function ActionBar:GetButtons()
	return self.cfg.buttons
end

ActionBar.SetButtons = ActionBar.UpdateButtons

function ActionBar:GetEnabled()
	return true
end

function ActionBar:SetEnabled(state)
	if not state then
		self.module:DisableBar(self.id)
	end
end

function ActionBar:GetGrid()
	return self.cfg.showgrid
end

function ActionBar:SetGrid(state)
	if state ~= nil then
		self.cfg.showgrid = state
	end

	if self.cfg.showgrid then
		self:ForAll("ShowGrid")
	else
		self:ForAll("HideGrid")
	end
	self:ForAll("UpdateGrid")
end