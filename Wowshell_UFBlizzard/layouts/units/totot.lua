local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags;
local db = WSUF.db.profile;
local style = ns.style

local position = ns:RegisterUnitPosition("targettargettarget",{
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_ToT",
	relativPoint = "BOTTOMRIGHT",
	x = 5,
	y = -15,
})

local unitdb = ns:RegisterUnitDB("targettargettarget", {
	parent = {
		width = 93,
		height = 45,
		scale = 1,
	},
	enabled = true,
	tags = {
		name = { tag = "[colorname]"},
		hp = { tag = "[perhp]"},
		mp = { tag = "[perpp]"},
	},
});

local units = "targettargettarget"
ns:setSize(units, unitdb.parent.width, unitdb.parent.height,unitdb.parent.scale)

ns:addLayoutElement(units, function(self, unit)
	local tex = self:CreateTexture(nil, "ARTWORK")
	self.frametexture = tex

	tex:SetTexture[[Interface\TargetingFrame\UI-TargetofTargetFrame]]
	tex:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
	tex:SetAllPoints(self)

	--utils.testBackdrop(self)
end)

ns:addLayoutElement(units, function(self, unit)
	local p = self.bg:CreateTexture(nil, "ARTWORK")
	self.Portrait = p
	self.portrait_2d = p
	utils.setSize(p, 35)
	p:SetPoint("TOPLEFT", 5, -5)
end)

ns:addLayoutElement(units, function(self, unit)
	local p = CreateFrame("PlayerModel", nil, self.bg)
	utils.setSize(p, 30)
	p:SetPoint("CENTER", self.portrait_2d)
	self.portrait_3d = p
end)

ns:addLayoutElement(units, function(self, unit)
	local hp, mp
	hp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(hp, 46, 7)
	hp:SetPoint("TOPRIGHT", -2, -15)


	mp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(mp, 46, 7)
	mp:SetPoint("TOPRIGHT", -2, -23)

	self.Health, self.Power = hp, mp

	hp.colorHealth = true
	mp.colorPower = true
end)

ns:addLayoutElement(units, function(self, unit)
	local t = self.tags

	local name = self:CreateFontString(nil, "OVERLAY")
	name:SetFontObject(GameFontNormalSmall);
	t.name = name;
	do
		local font, size, flag = name:GetFont()
		name:SetFont(font, size-1, flag)
	end
	name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 2)
--	Tags:Register(self, name, "[colorname]");
--	name:UpdateTags();
--	name:Show();

	local hp = self:CreateFontString(nil, "OVERLAY")
	t.hp = hp
	hp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = hp:GetFont()
		hp:SetFont(font, size-3, flag)
	end
	hp:SetPoint("CENTER", self.Health, 0, 0)
--	Tags:Register(self, hp, "[perhp]");
--	hp:UpdateTags();
--	hp:Show();

	local mp = self:CreateFontString(nil, "OVERLAY")
	t.mp = mp
	mp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = mp:GetFont()
		mp:SetFont(font, size-3, flag)
	end
	mp:SetPoint("CENTER", self.Power, 0, 0)
--	Tags:Register(self, mp, "[perpp]");
--	mp:UpdateTags();
--	mp:Show();
end)

ns:addLayoutElement(units, function(self, unit)
	local ricon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon = ricon
	utils.setSize(ricon, 14)
	ricon:SetPoint("CENTER", self, "TOPLEFT", 22, -8)
end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

local frame
ns:addLayoutElement(units, function(self)
	frame = self
end)

ns:spawn(function()
	local f = oUF:Spawn("targettargettarget", "wsUnitFrame_ToToT")
	ns.frameList[f] = true
	ns.unitFrames.totot = f
	if(not unitdb.enabled) then
		f:Disable()
	end
	return f
end)


ns:RegisterUnitOptions("targettargettarget", {
	type = "group",
	name = L["targettargettarget"],
	order = ns.order(),
	args = {
		enabled = {
			type = "toggle",
			name = L["Enabled"],
			desc = L["Enable target of target of target"],
			order = ns.order(),
			width = "full",
			get = function() return unitdb.enabled end,
			set = function(_, v)
				unitdb.enabled = v
				if(v) then
					frame:Enable()
				else
					frame:Disable()
				end
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
					 values = {[""]= L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
--					disabled = function() return not unitdb.enabled end,
					get = function() return unitdb.tags.hp.tag  end,
					set = function(_, v)
						unitdb.tags.hp.tag = v
						ns:Reload("targettargettarget")
					end,
				},
				tagonpowerbar = {
					type = "select",
					name = L["Text on power bar"],
					desc = L["The text show on power bar"],
					order = ns.order(),
				 values = {[""]= L["NONE"],["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},

				--	disabled = function() return not unitdb.enabled end,
					get = function() return unitdb.tags.mp.tag end,
					set = function(_, v)
						unitdb.tags.mp.tag = v
						ns:Reload("targettargettarget")
					end,
				},
			},
		},
	},
})
