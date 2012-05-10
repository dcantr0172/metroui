local Skylark = Skylark
local Sticky = LibStub("LibSimpleSticky-1.0");
local LibWin = LibStub("LibWindow-1.1");
local snapBars = {WorldFrame, UIParent}

local Bar = CreateFrame("Button");
local Bar_MT = {__index = Bar};

local defaults = {
	alpha = 1,
	fadeout = false,
	fadeoutalpha = 0.1,
	fadeoutdelay = 0.2,
	visibility = {
		vehicle = true,
	},
	position = {
		scale = 1,
		growVertical = "DOWN",
		growHorizontal = "RIGHT",
	},
}


local onAttributeChanged, onUpdateFuncForBar, barOnEnter, barOnLeave, barDragStart, barDragStop, barOnClick

do
	function barOnEnter(self)
		if not self:GetParent().isMoving then
			self:SetBackdropBorderColor(0.5, 0.5, 0, 1)
		end
	end
	function barOnLeave(self)
		self:SetBackdropBorderColor(0, 0, 0, 0)
	end
	function barDragStart(self)
		local parent = self:GetParent();
		local offset = 8 - (parent.cfg.padding or 0)
		Sticky:StartMoving(parent, snapBars, offset, offset, offset, offset);

		self:SetBackdropBorderColor(0, 0, 0, 0);
		parent.isMoving = true
	end
	function barDragStop(self)
		local parent = self:GetParent()
		if parent.isMoving then
			local sticky, stickTo = Sticky:StopMoving(parent)
			parent:SavePosition()
			parent.isMoving = nil
		end
	end

	function barOnClick(self)

	end
	function onUpdateFuncForBar(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed > self.cfg.fadeoutdelay then
			self:ControlFadeOut(self.elapsed);
			self.elapsed = 0
		end
	end

	function onAttributeChanged(self, att, val)
		if att == "fade" then
			if val then
				self:SetScript("OnUpdate", onUpdateFuncForBar);
				self:ControlFadeOut();
			else
				self:SetScript("OnUpdate", nil)
				self.faded = nil
				self:SetConfigAlpha();
			end
		end
	end
end

local barregistry = {}
Skylark.Bar = {}
Skylark.Bar.defaults = defaults
Skylark.Bar.prototype = Bar
Skylark.Bar.barregistry = barregistry

function Skylark.Bar:Create(id, cfg, name)
	id = tostring(id);

	--secure header
	local bar = setmetatable(CreateFrame("Frame", ("LarkBar%s"):format(id), UIParent, "SecureHandlerStateTemplate"), Bar_MT);
	barregistry[id] = bar

	bar.id = id
	bar.name = name or id
	bar.cfg = cfg
	bar:SetMovable(true)
	bar:HookScript("OnAttributeChanged", onAttributeChanged)
	
	bar:SetWidth(1)
	bar:SetHeight(1)

	local overlay = CreateFrame("Button", bar:GetName().."Overlay", bar);
	bar.overlay = overlay
	overlay.bar = bar
	tinsert(snapBars, overlay)
	overlay:EnableMouse(true);
	overlay:RegisterForDrag("LeftButton");
	overlay:RegisterForClicks("LeftButtonUp");
	overlay:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-ToolTip-Background",
		tile=true,
		tileSize=16,
		edgeFile="Interface\\ToolTips\\UI-Tooltip-Border",
		edgeSize=16,
		insets={left=5, right=3,top=3,bottom=5},
	});
	overlay:SetBackdropColor(0, 1, 0, 0.5);
	overlay:SetBackdropBorderColor(0.5, 0.5, 0, 0);
	overlay.Text = overlay:CreateFontString(nil, "ARTWORK");
	overlay.Text:SetFontObject(GameFontNormal);
	overlay.Text:SetText(name);
	overlay.Text:Show();
	overlay.Text:ClearAllPoints();
	overlay.Text:SetPoint("CENTER", overlay, "CENTER");

	overlay:SetScript("OnEnter", barOnEnter);
	overlay:SetScript("OnLeave", barOnLeave);
	overlay:SetScript("OnDragStart", barDragStart);
	overlay:SetScript("OnDragStop", barDragStop);
	overlay:SetScript("OnClick", barOnClick);

	overlay:SetFrameLevel(bar:GetFrameLevel() + 20);
	bar:AnchorOverlay();
	overlay:Hide();

	bar.elapsed = 0
	bar.hideriver = {}

	return bar
end

function Skylark.Bar.GetAll()
	return pairs(barregistry)
end

function Skylark.Bar:ForAll(method, ...)
	for _, bar in self:GetAll() do
		local func = bar[method];
		if func then
			func(bar, ...)
		end
	end
end

--[[
position = {
	x
	y
	point
	relPoint
}
]]
function Bar:ApplyConfig(cfg)
	if cfg then
		self.cfg = cfg
	end
	LibWin.RegisterConfig(self, self.cfg.position);
	
	if self.disabled then return end

	if Skylark.Locked then
		self:Lock()
	else
		self:Unlock()
	end
	self:LoadPosition()
	self:SetConfigScale()
	self:SetConfigAlpha()
	self:InitVisibilityDriver()
end

function Bar:GetAnchor()
	return ((self.cfg.position.growVertical == "DOWN") and "TOP" or "BOTTOM")..((self.cfg.position.growHorizontal == "RIGHT") and "LEFT" or "RIGHT");
end

function Bar:AnchorOverlay()
	self.overlay:ClearAllPoints();
	local anchor = self:GetAnchor();
	self.overlay:SetPoint(anchor, self, anchor)
end

function Bar:Lock()
	if self.disabled or not self.unlocked then return end
	self.unlocked = nil
	self:StopDragging();
	self:ApplyVisibilityDriver()
	self.overlay:Hide();
end

function Bar:Unlock()
	if self.disabled or self.unlocked then return end
	self.unlocked = true
	self:DisableVisibilityDriver()
	self:Show();
	self.overlay:Show();
end

function Bar:StopDragging()
	barDragStop(self.overlay)
end

function Bar:LoadPosition()
	LibWin.RestorePosition(self)
end

function Bar:SavePosition()
	LibWin.SavePosition(self)
end

function Bar:SetSize(width, height)
	self.overlay:SetWidth(width)
	self.overlay:SetHeight(height or width)
end

function Bar:GetConfigAlpha()
	return self.cfg.alpha
end

function Bar:SetConfigAlpha(alpha)
	if alpha then
		self.cfg.alpha = alpha
	end
	if not self.faded then
		self:SetAlpha(self.cfg.alpha)
	end
end

function Bar:GetConfigScale()
	return self.cfg.position.scale
end

function Bar:SetConfigScale(scale)
	if scale then
		LibWin.SetScale(self, scale)
	end
end

function Bar:GetFadeOut()
	return self.cfg.fadeout
end

function Bar:SetFadeOut(fadeout)
	if fadeout ~= nil then
		self.cfg.fadeout = fadeout
		self:InitVisibilityDriver()
	end
end

function Bar:GetFadeOutAlpha()
	return self.cfg.fadeoutalpha
end

function Bar:SetFadeOutAlpha(alpha)
	if alpha ~= nil then
		self.cfg.fadeoutalpha = alpha
	end
	if self.faded then
		self:SetAlpha(self.cfg.fadeoutalpha)
	end
end

function Bar:SetFadeOutDelay(delay)
	if delay ~= nil then
		self.cfg.fadeoutdelay = delay
	end
end

function Bar:GetFadeOutDelay()
	return self.cfg.fadeoutdelay
end

function Bar:ControlFadeOut()
	if self.faded and MouseIsOver(self.overlay) then
		self:SetAlpha(self.cfg.alpha)
		self.faded = nil
	elseif not self.faded and not MouseIsOver(self.overlay) then
		local fade = self:GetAttribute("fade");
		if tonumber(fade) then
			fade = min(max(fade, 0), 100) / 100
			self:SetAlpha(fade)
		else
			self:SetAlpha(self.cfg.fadeoutalpha or 0)
		end
		self.faded = true
	end
end

--secure bar show/hide
local direcrVisCond = {
	combat = true,
	nocombat = true,
	mounted = true,
	pet = true,
	nopet = true
}

function Bar:InitVisibilityDriver(returnonly)
	local tmpDriver
	if returnonly then
		tmpDriver = self.hidedriver
	else
		UnregisterStateDriver(self, "vis")
	end
	self.hidedriver = {}
	
	--params: self, stateid, newstate
	self:SetAttribute("_onstate-vis", [[
		--print(stateid, newstate)
		if not newstate then return end
		if newstate == "show" then
			self:Show();
			self:SetAttribute("fade", false)
		elseif strsub(newstate, 1, 4) == "fade" then
			self:Show();
			self:SetAttribute("fade", (newstate == "fade") and true or strsub(newstate, 6));
		elseif newstate == "hide" then
			self:Hide()
		end
	]]);

	for key, value in pairs(self.cfg.visibility) do
		if value then
			--always, vehicle, combat, nocombat, mounted, pet, nopet
			if key == "vehicle" then
				tinsert(self.hidedriver, "[target=vehicle,exists]hide");
			elseif key == "always" then
				tinsert(self.hidedriver, "hide");
			elseif direcrVisCond[key] then
				tinsert(self.hidedriver, ("[%s]hide"):format(key))
			end
		end
	end
	tinsert(self.hidedriver, self.cfg.fadeout and "fade" or "show");

	if not returnonly then
		self:ApplyVisibilityDriver();
	end
end

function Bar:ApplyVisibilityDriver()
	if self.unlocked then return end
	local driver = table.concat(self.hidedriver, ";");
	RegisterStateDriver(self, "vis", driver)
end

function Bar:DisableVisibilityDriver()
	UnregisterStateDriver(self, "vis");
	self:SetAttribute("state-vis", "show");
	self:Show();
end

function Bar:GetVisibilityOption(opt)
	return self.cfg.visibility[opt]
end

function Bar:SetVisibilityOption(opt, value)
	 self.cfg.visibility[opt] = value
	 self:InitVisibilityDriver();
end

function Bar:CopyCustomConditionals()

end

------------------------------------------------------
function Bar:Enable()
	if not self.disabled then return end
	self.disabled = nil
end

function Bar:Disable()
	if self.disabled then return end;
	self:Lock();
	self.disabled = true
	self:UnregisterAllEvents();
	self:DisableVisibilityDriver();
	self:SetAttribute("state-vis", nil);
	self:Hide();
end

function Bar:ClearSetPoints(...)
	self:ClearAllPoints()
	self:SetPoint(...)
end