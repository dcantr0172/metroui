local ezIcons = LibStub("AceAddon-3.0"):NewAddon("ezIcons", "AceEvent-3.0", "AceConsole-3.0")
_G["ezIcons"] = ezIcons
local L = wsLocale:GetLocale("ezIcons")

BINDING_HEADER_EZICONS = L["ezIcons"]
BINDING_NAME_EZICONS_SETICON = L["Set Icon"]
BINDING_NAME_EZICONS_REMOVEICON = L["Remove Icon"]
BINDING_NAME_EZICONS_RESETICONS = L["Reset Icons"]

local defaults = {
	profile = {
		radial = true,
		Mouseover = true,
		MassIcon = true,
	}
}
local menu, doubleClick, doubleClickX, doubleClick, playerFaction;
local raidt = {0,0,0,0,0,0,0,0}
local low = 0;

function ezIcons:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ezIconsDB", defaults, UnitName("player"));

	playerFaction, localizedFaction = UnitFactionGroup("player")
end

function ezIcons:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	local options = {
		type = "group",
		name = L["Icon Helper"],
		icon = "Interface\\Icons\\Ability_Hunter_MasterMarksman",
		inline = true,
		args = {
			radial = {
				order = 1,
           		type = 'toggle',
           		name = L["Radial"],
				width = "full",
           		desc = L["Enable/Disable the radial target icon menu"],
            	get = function() return self.db.profile.radial end,
            	set = function(_, v)
					self.db.profile.radial = v
				end,
        	},
        	mouseover = {
				order = 2,
            	type = 'toggle',
            	name = L["Mouseover"],
				width = "full",
            	desc = L["Enable/Disable mouseover set icon keybindings"],
            	get = function() return self.db.profile.Mouseover end,
            	set = function(_, v)
					self.db.profile.Mouseover = v
				end
        	},
			massIcon = {
				order = 3,
				type = 'toggle',
            	name = L["Massicon"],
				width = "full",
            	desc = L["Enable/Disable mass mouseover set icon modifier keys"],
            	get = function() return self.db.profile.MassIcon end,
            	set = function(_, v)
					self.db.profile.MassIcon = v
				end
        	},
			keyboundSet = {
				order = 4,
				type = "group",
				name = L["Key Bound Setting"],
				inline = true,
				args = {
					seticon = {
						order = 5,
						type = "keybinding",
						name = L["Set Icon"],
						width = "full",
						desc = L["Set Key for setting icon"],
						get = function() 
							return GetBindingKey("EZICONS_SETICON");
						end,
						set = function(_, v)
							local key = GetBindingKey("EZICONS_SETICON");
							if key then
								SetBinding(key)
							end
							SetBinding(tostring(v), "EZICONS_SETICON")
							SaveBindings(2)
						end
					},
					removeicon = {
						order = 6,
						type = "keybinding",
						name = L["Remove Icon"],
						width = "full",
						desc = L["Set Key for removing icon"],
						get = function() 
							return GetBindingKey("EZICONS_REMOVEICON");
						end,
						set = function(_, v)
							local key = GetBindingKey("EZICONS_REMOVEICON");
							if key then
								SetBinding(key)
							end
							SetBinding(tostring(v), "EZICONS_REMOVEICON")
							SaveBindings(2)
						end
					},
					reset = {
						order = 7,
						type = "keybinding",
						name = L["Reset Icon"],
						width = "full",
						desc = L["Set Key for reseting icon"],
						get = function() 
							return GetBindingKey("EZICONS_RESETICONS");
						end,
						set = function(_, v)
							local key = GetBindingKey("EZICONS_RESETICONS");
							if key then
								SetBinding(key)
							end
							SetBinding(tostring(v), "EZICONS_RESETICONS")
							SaveBindings(2)
						end
					}
				},
			}
		}
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("ezIcons", options)
end

function ezIcons:OnDisable()
	self:UnregisterAllEvents()
end

function ezIcons:BuildMenu()
	if self.menu then return end
	self.menu = CreateFrame("Button", "radial", UIParent);
	self.menu:SetWidth(100);
	self.menu:SetHeight(100);
	self.menu:SetPoint("CENTER", UIParent, "BOTTOMLEFT", 0, 0);
	self.menu:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	self.menu:RegisterEvent("PLAYER_TARGET_CHANGED");
	self.menu.p = self.menu:CreateTexture("radialPortrait", "BORDER");
	self.menu.p:SetWidth(40);
	self.menu.p:SetHeight(40);
	self.menu.p:SetPoint("CENTER", self.menu, "CENTER", 0, 0);
	self.menu.b = self.menu:CreateTexture("radailBorder", "BACKGROUND");
	self.menu.b:SetTexture("Interface\\Minimap\\UI-TOD-Indicator")
	self.menu.b:SetWidth(80)
	self.menu.b:SetHeight(80);
	self.menu.b:SetTexCoord(0.5, 1, 0, 1);
	self.menu.b:SetPoint("CENTER", self.menu, "CENTER", 10, -10);
	for i =1, 8 do
		self.menu[i] = self.menu:CreateTexture("radial"..i, "OVERLAY")
	end

	self.menu:SetScript("OnUpdate", function(self, elapsed)
		local saved, index = self.i, GetRaidTargetIndex("target");
		local curtime = GetTime();
		if not self.h then
			if (not UnitExists("target") or (not UnitPlayerOrPetInRaid("target") and UnitIsDeadOrGhost("target"))) then
				if (self.portrait) then
					self:Hide()
					return
				else
					self.h = curtime
				end
			elseif (self.portrait) then
				self.portrait = nil
				if not UnitIsUnit("target", "mouseover") then
					self:Hide()
					return;
				end
				PlaySound("igMainMenuOptionCheckBoxOn")
				SetPortraitTexture(self.p, "target");
			end

			local x, y = GetCursorPosition();
			local s = self:GetEffectiveScale();
			local mx, my = self:GetCenter();
			y = y / s
			x = x / s
			
			local a, b = y-my, x-mx
			local dist = floor(math.sqrt(a*a + b*b));
			self.i = nil

			if (dist > 60) then
				if (dist > 200) then
					self.l = nil
					self.h = curtime
					self.s = nil
					PlaySound("igMainMenuOptionCheckBoxOff");
				elseif (not self.l) then
					self.l = curtime
				end
			else
				self.l = nil

				if (dist > 20 and dist < 50) then
					local pos = math.deg(math.atan2( a, b )) + 27.5
					self.i = mod(11 - ceil(pos/45), 8) + 1
				end
			end

			for i = 1, 8 do
				local t = self[i]
				if index == i then
					t:SetTexCoord(0, 1, 0, 1);
					t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
				else
					t:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons")
					SetRaidTargetIconTexture(t, i)
				end
			end
			
			if ((self.c or IsControlKeyDown()) and self.i) then
				self:Click()
			end

			if (self.c == 0 and not IsControlKeyDown()) then
				sekf.c = nil
			end
		end

		if self.s then
			local status = curtime - self.s
			if status > 0.1 then
				self.p:SetAlpha(1);
				self.b:SetAlpha(1);
				for i = 1, 8 do
					local t, radians = self[i], (0.375 - i/8) * 360
					t:SetPoint("CENTER", self, "CENTER", 36*cos(radians), 36*sin(radians));
					t:SetAlpha(0.5);
					t:SetWidth(18)
					t:SetHeight(18)
				end
				self.s = nil
			else
				status = status / 0.1
				self.p:SetAlpha(status)
				self.b:SetAlpha(status)
				for i =1, 8 do
					local t, radians = self[i], (0.375 - i/8) * 360
					t:SetPoint("CENTER", self, "CENTER", (20*status + 16)*cos(radians), (20*status + 16)*sin(radians));
					if (i == index) then
						t:SetAlpha(status)
					else
						t:SetAlpha(0.5*status)
					end
					t:SetWidth(9*status + 9)
					t:SetHeight(9*status + 9)
				end
			end
		elseif (self.h) then
			local status = curtime - self.h
			if (status > 0.1) then
				self.h = nil
				self:Hide()
			else
				status = 1 - status/0.1
				self.p:SetAlpha(status)
				self.b:SetAlpha(status)
				for i = 1, 8 do
					local t, radians = self[i], (0.375 - i/8)*360
					if self.i == i then
						t:SetWidth(36-18*status);
						t:SetHeight(36-18*status);
						t:SetAlpha(min(4*status, 1))
					else
						t:SetPoint("CENTER", self, "CENTER", (20*status + 16)*cos(radians), (20*status + 16)*sin(radians));
						t:SetAlpha(0.75 * status)
						t:SetWidth(18 * status)
						t:SetHeight(18 * status)
					end
				end
			end
		else
			for i = 1, 8 do
				local t = self[i]
				if (i == index) then
					t:SetAlpha(1)
				else
					t:SetAlpha(0.75)
				end
				t:SetWidth(18)
				t:SetHeight(18)
			end
		end
		
		if (self.i) then
			local t = self[self.i]
			local a, w = t:GetAlpha(), t:GetWidth();
				if (not self.t or saved ~= self.i) then
					self.t = curtime
				end
			local s = 1 + min((curtime - self.t)/0.05, 1);

			t:SetAlpha(min(a+0.125*s, 1));
			t:SetWidth(w*s)
			t:SetHeight(w*s)
		end

		if (self.l) then
			local status = curtime - self.l
			if (status > 0.75) then
				self.h = curtime
				self.l = nil
				self.s = nil
				self.i = nil
				PlaySound("igMainMenuOptionCheckBoxOff");
			end
		end
	end);

	self.menu:SetScript("OnClick", function(self, button, down)
		if (not self.h) then
			local index = GetRaidTargetIndex("target");
			if ((button == "RightButton" and index and index > 0 ) or (self.i and self.i == index)) then
				self.i = index
				--PlaySound("igMiniMapZoomOut");
				SetRaidTarget("target", 0)
			elseif (self.i) then
				--PlaySound("igMiniMapZoomIn");
				SetRaidTarget("target", self.i)
			else
				--PlaySound("igMainMenuOptionCheckBoxOff");
			end
			self.s = nil
			self.h = GetTime();
		end
	end)

	self.menu:SetScript("OnEvent", function(self)
		if (self:IsVisible() and not self.e and not self.h ) then
			self.i = nil
			self.s = nil
			self.h = GetTime();
			--PlaySound("igMainMenuOptionCheckBoxOff");
		end
			self.e =nil
	end);

	return self.menu
end

function ezIcons:radial_Show()
	if ( ( not self:IsEnabled() ) or ( not self.db.profile.radial ) ) then return; end
	if ( not IsPartyLeader() ) then
			local num = GetNumRaidMembers();
			if ( num == 0 ) then return; end

			local _, rank = GetRaidRosterInfo(num);
			if ( rank == 0 ) then return; end
	end

	if ( not self.menu ) then
		self.menu = ezIcons:BuildMenu();
	end
	self.menu.s = GetTime();
	self.menu.h = nil;
	self.menu.i = nil;
	self.menu.l = nil;
	self.menu.e = 1;
	self.menu.portrait = 1;

	local x,y = GetCursorPosition();
	local s = self.menu:GetEffectiveScale();
	self.menu:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", x/s, y/s );
	self.menu:Show();
end

local OnMouseUp = WorldFrame:GetScript("OnMouseUp");

WorldFrame:SetScript("OnMouseUp", function(self, button)
		if ( button == "LeftButton" ) then
			local curtime = GetTime();
			local x, y = GetCursorPosition();
			if ( doubleClick and curtime - doubleClick < 0.25 and abs(x-doubleClickX) < 20 and abs(y-doubleClickY) < 20 ) then
				ezIcons:radial_Show();
				if ( menu ) then
					menu.c = 1;
				end
				doubleClick = nil;
			else
				doubleClick = curtime;
			end
			doubleClickX, doubleClickY = x, y;
		end
		if ( OnMouseUp ) then
			OnMouseUp();
		end
end);

function ezIcons:assign_()
	if ( ( not self:IsEnabled() ) or ( not self.db.profile.Mouseover ) ) then return; end
	-- check if party leader
	if UnitIsPartyLeader("player") == 1 then	
		if UnitExists("mouseover") then
			tar = GetRaidTargetIndex("mouseover")
			if tar ~= nil then
				if tar ~=0 then  
					return;
				end
			else
				targ=GetRaidTargetIndex("mouseover")
				targFaction, targLocalzedFaction = UnitFactionGroup("mouseover")
				if ( targFaction == playerFaction ) then
					return;
				else
					low = self:findlow();
					SetRaidTarget("mouseover",low);
					raidt[low] = raidt[low] + 1;
				end
			end		
		end
	end	
end

-----------
function ezIcons:assign_m()
	if ( ( not self:IsEnabled() ) or ( not self.db.profile.MassIcon ) ) then return; end
	-- check if party leader
	if UnitIsPartyLeader("player") == 1 then	
		if UnitExists("mouseover") then
			tar = GetRaidTargetIndex("mouseover")
			if tar ~= nil then
				if tar ~=0 then  
					return;
				end
			else
				targ = GetRaidTargetIndex("mouseover")
				targFaction, targLocalzedFaction = UnitFactionGroup("mouseover")
				if ( targFaction == playerFaction ) then
					return;
				else
					low = self:findlow();
					SetRaidTarget("mouseover",low);
					raidt[low] = raidt[low] + 1;
				end
			end		
		end
	end	
end

function ezIcons:unassign_()
	if ( ( not self:IsEnabled() ) or ( not self.db.profile.Mouseover ) ) then return; end
	-- check if party leader
	if UnitIsPartyLeader("player") == 1 then	
		if UnitExists("mouseover") then
			tar = GetRaidTargetIndex("mouseover")
			if tar ~= nil then
				if tar ~=0 then  
					self:remove()
				end
			end		
		end
	end	
end

function ezIcons:unassign_m()
	if ( ( not self:IsEnabled() ) or ( not self.db.profile.MassIcon ) ) then return; end
	-- check if party leader
	if UnitIsPartyLeader("player") == 1 then	
		if UnitExists("mouseover") then
			tar = GetRaidTargetIndex("mouseover")
			if tar ~= nil then
				if tar ~=0 then  
					self:remove()
				end
			end		
		end
	end	
end

function ezIcons:reset()	
	if ( not self:IsEnabled() ) then return; end
	for x = 8,-1,-1 do
		SetRaidTarget("player",x)
	end
	raidt = {0,0,0,0,0,0,0,0}
end

function ezIcons:remove()
	if ( not self:IsEnabled() ) then return; end
	tar = GetRaidTargetIndex("mouseover");
	if tar  ~= nil then
		if tar ~= 0 then
			SetRaidTarget("mouseover",0);
			raidt[tar] = raidt[tar] - 1;
		end
	end
end

function ezIcons:findlow()
	value = raidt[1]
	mn = 1 
	for x=2,8 do
		if raidt[x] < value then
			value = raidt[x]
			mn = x 
		end
	end
	return mn
end

function ezIcons:PLAYER_REGEN_ENABLED()
	raidt = {0,0,0,0,0,0,0,0}
end

function ezIcons:UPDATE_MOUSEOVER_UNIT()
	if ( IsShiftKeyDown() ) then 
		self:assign_m();
	elseif ( IsControlKeyDown() ) then
		self:unassign_m();
	end

	--assign_
end