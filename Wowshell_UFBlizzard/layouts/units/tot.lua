local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L;
local Tags = WSUF.Tags;
local db = WSUF.db.profile;
local style = ns.style

local position = ns:RegisterUnitPosition("targettarget",{
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_Target",
	relativPoint = "BOTTOMRIGHT",
	x = 30,
	y = -30,
})

local unitdb = ns:RegisterUnitDB("targettarget", {
	parent = {
		width = 93,
		height = 45,
		scale = 1,
	},
	enabled = true,
	auras = true,
	auracooldown = true,
	castbyme = true,
	tags = {
		name = { tag = "[colorname]",},
		hp = { tag = "[perhp]",},
		mp = { tag = "[perpp]"},
	},
});

local units = "targettarget"

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

local function post(icons, button)
	local font, size, flag = button.count:GetFont()
	button.count:SetFont(STANDARD_TEXT_FONT, size-4, flag)
	button.oufaura = true
	button.cd:SetDrawEdge(true)
	button.cd:SetReverse(true)
end

local function postUpdateIcon(icons, unit, icon, index, offset)
	utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
end

ns:addLayoutElement(units, function(self, unit)
	local frame = CreateFrame("Frame", nil, self)
	self.Auras = frame
	--utils.testBackdrop(frame)
	frame.PostCreateIcon = post
	frame.PostUpdateIcon = postUpdateIcon
	frame.showType = true

	frame.size = 16
	frame.numBuffs = 4
	frame.numDebuffs = 4
	frame.gap = true

	frame.spacing = 2
	frame.initialAnchor = "TOPLEFT"
	frame["growth-x"] = "RIGHT"
	frame["growth-y"] = "DOWN"

	frame:SetWidth(70)
	frame:SetHeight(100)
	frame:SetPoint("TOPLEFT", self, "TOPRIGHT", 5, -5)

	if(not unitdb.auras) then
		frame:Hide()
	end
	frame:HookScript("OnShow", function(self)
		if(not unitdb.auras) then
			self:Hide()
		end
	end)
end)

ns:addLayoutElement(units, function(self, unit)
	local t = self.tags

	local name = self:CreateFontString(nil, "OVERLAY")
	t.name = name;
	name:SetFontObject(GameFontNormalSmall)
	name:SetPoint("BOTTOMLEFT", self.Health, "TOPLEFT", 0, 2)
	--Tags:Register(self, name, "[colorname]");
	--name:UpdateTags();
	--name:Show();

	local hp = self:CreateFontString(nil, "OVERLAY")
	t.hp = hp
	hp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = hp:GetFont()
		hp:SetFont(font, size-3, flag)
	end
	hp:SetPoint("CENTER", self.Health, 0, 0)
	--Tags:Register(self, hp, "[perhp]");
	--hp:UpdateTags();
	--hp:Show();

	local mp = self:CreateFontString(nil, "OVERLAY")
	t.mp = mp
	mp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = mp:GetFont()
		mp:SetFont(font, size-3, flag)
	end
	mp:SetPoint("CENTER", self.Power, 0, 0)
	--Tags:Register(self, mp, "[perpp]");
	--mp:UpdateTags();
	--mp:Hide();
end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

ns:addLayoutElement(units, function(self, unit)
	local ricon = self:CreateTexture(nil, "OVERLAY")
	self.RaidIcon = ricon
	utils.setSize(ricon, 14)
	ricon:SetPoint("CENTER", self, "TOPLEFT", 22, -8)
end)

local frame
ns:addLayoutElement(units, function(self)
	frame = self
end)

oUF:RegisterInitCallback(function(self)
	if(self == frame) then
		local enabled = unitdb.enabled
		if(not enabled) then
			self:Disable()
		end
		self.__enabled = enabled
	end
end)

ns:spawn(function()
	local f = oUF:Spawn("targettarget", "wsUnitFrame_ToT")
	ns.frameList[f] = true
	ns.unitFrames.tot = f
	if not (unitdb.enabled) then
		f:Disable()
	end
	return f
end)


ns:RegisterUnitOptions("targettarget", {
    type = "group",
    name = L["targettarget"],
    order = ns.order(),
    args = {
        enabled = {
            type = "toggle",
            name = L["Enabled"],
            desc = L["Enable target of target"],
            order = ns.order(),
            get = function() return unitdb.enabled end,
            set = function(_, v)
                unitdb.enabled = v
                if(v and not frame.__enabled) then
                    frame:Enable()
                elseif(not v and frame.__enabled) then
                    frame:Disable()
                end
                frame.__enabled = v
            end,
        },
        auras = {
            type = "toggle",
            name = L["Enable auras"],
            order = ns.order(),
            width = "full",
            get = function() return unitdb.auras end,
            set = function(_, v)
                unitdb.auras = v
                if(v) then
                    frame.Auras:Show()
                else
                    frame.Auras:Hide()
                end
            end,
        },
        --auracooldown = {
        --    type = "toggle",
        --    name = L["Aura cooldown"],
        --    desc = L["Show aura cooldown"],
        --    order = ns.order(),
        --    width = "full",
        --    get = function() return unitdb.auracooldown end,
        --    set = function(_, v)
        --        unitdb.auracooldown = v
        --        utils.updateAuraElement(frame)
        --        --frame:UpdateElement"Aura"
        --    end,
        --},
        --castbyme = {
        --    type = "toggle",
        --    name = L["Cast by me only"],
        --    desc = L["Only show cooldown on those that cast by me"],
        --    order = ns.order(),
        --    disabled = function() return not unitdb.auracooldown end,
        --    get = function() return unitdb.castbyme end,
        --    set = function(_,v )
        --        unitdb.castbyme = v
        --        if(frame:IsVisible()) then
        --            utils.updateAuraElement(frame)
        --            --frame:UpdateElement"Aura"
        --        end
        --    end,
        --},
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
                    get = function() return unitdb.tags.hp.tag  end,
                    set = function(_, v)
                        unitdb.tags.hp.tag = v
												ns:Reload("targettarget")	
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
                        unitdb.tags.mp.tag= v
												ns:Reload("targettarget")
                    end,
                },
            },
        },
    },
})
--]]
