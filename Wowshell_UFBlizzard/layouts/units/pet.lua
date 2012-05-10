-- by yaroot <yaroot AT gmail.com>
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils;
local L = WSUF.L;
local Tags = WSUF.Tags
local db = WSUF.db.profile;
local style = ns.style

local position = ns:RegisterUnitPosition("pet",{
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_Player",
	relativPoint = "BOTTOMLEFT",
	x = -80,
	y = -50,
})

local unitdb = ns:RegisterUnitDB("pet", {
	parent = {
		width = 128,
		height = 53,
		scale = 1,
	},
	combatfeedback = true,
	auracooldown = true,
	castbyme = true,
	tags = {
		name = { tag = "[colorname]"},
		hp = { tag = "[curmaxhp]"},
		mp = { tag = "[curmaxpp]"},
	},
})

local units = "pet"
ns:setSize(units, unitdb.parent.width, unitdb.parent.height,unitdb.parent.scale)

ns:addLayoutElement(units, function(self, unit)
	local tex = self:CreateTexture(nil, "OVERLAY")
	tex:SetTexture[[Interface\TargetingFrame\UI-SmallTargetingFrame]]
	utils.setSize(tex, 128, 64)
	tex:SetPoint("TOPLEFT", 0, -2)

	self.frametexture = tex
end)

ns:addLayoutElement(units, function(self, unit)
    local p = self.bg:CreateTexture(nil, "BORDER")
    self.Portrait = p
    self.portrait_2d = p
    utils.setSize(p, 37)
    p:SetPoint("TOPLEFT", 7, -6)
end)

ns:addLayoutElement(units, function(self, unit)
    local p = CreateFrame("PlayerModel", nil, self.bg)
    utils.setSize(p, 35)
    p:SetPoint("CENTER", self.portrait_2d)
    self.portrait_3d = p
end)

ns:addLayoutElement(units, function(self, unit)
	local threat = self.bg:CreateTexture(nil, "BACKGROUND")
	self.Threat = threat

	threat:SetTexture[[Interface\TargetingFrame\UI-PartyFrame-Flash]]
	utils.setSize(threat, 128, 64)
	threat:SetPoint("TOPLEFT", -4, 11)
	threat:SetVertexColor(1, 0, 0)
	threat:SetTexCoord(0, 1, 1, 0)
end)

ns:addLayoutElement(units, function(self, unit)
	local hp, mp
	hp = CreateFrame("StatusBar", nil, self.bg)
	mp = CreateFrame("StatusBar", nil, self.bg)
	self.Health, self.Power = hp, mp

	utils.setSize(hp, 69, 8)
	utils.setSize(mp, 69, 8)

	hp:SetPoint("TOPLEFT", 47, -22)
	mp:SetPoint("TOPLEFT", 47, -29)

	hp.Smooth = true
	hp.colorHealth = true
	mp.Smooth = true
	mp.colorPower = true
end)

ns:addLayoutElement(units, function(self, unit)
	local t = self.tags
	local name = self:CreateFontString(nil, "OVERLAY")

	name:SetFontObject(GameFontNormalSmall)
	t.name = name
	do
		local font, size, flag = name:GetFont()
		name:SetFont(font, size-1, flag)
	end
	name:SetPoint("CENTER", self.Health, -2, 10)

	local hp = self:CreateFontString(nil, "OVERLAY")
	t.hp = hp
	hp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = hp:GetFont()
		hp:SetFont(font, size-3, flag)
	end
	hp:SetPoint("CENTER", self.Health, 0, 0)

	local mp = self:CreateFontString(nil, "OVERLAY")
	t.mp = mp
	mp:SetFontObject("TextStatusBarText")
	do
		local font, size, flag = mp:GetFont()
		mp:SetFont(font, size-3, flag)
	end
	mp:SetPoint("CENTER", self.Power, 0, 0)
end)

ns:addLayoutElement(units, function(self, unit)
	local cbt = self:CreateFontString(nil, "OVERLAY")
	self.CombatFeedbackText = cbt

	cbt:SetPoint("CENTER", self.Portrait)
	cbt:SetFontObject(NumberFontNormalHuge)
	do
		local font, size, flag = cbt:GetFont()
		cbt:SetFont(font, size-4, flag)
	end

	cbt.maxAlpha = .8
end)

local function post(icons, button)
	local font, size, flag = button.count:GetFont()
	button.count:SetFont(STANDARD_TEXT_FONT, 10, flag)
	button.oufaura = true
	button.cd:SetDrawEdge(true)
	button.cd:SetReverse(true)
end

local function postUpdateIcon(icons, unit, icon, index, offset)
	utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
end

ns:addLayoutElement(units, function(self, unit)
	local f = CreateFrame("Frame", nil, self)
	self.Auras = f

	f.showType = true
	f.PostCreateIcon = post
	f.PostUpdateIcon = postUpdateIcon

	f.size = 16
	f.numBuffs = 8
	f.numDebuffs = 8

	f.gap = true
	f.spacing = 2
	f.initialAnchor = "TOPLEFT"
	f["growth-x"] = "RIGHT"
	f["growth-y"] = "DOWN"

	f:SetWidth(140)
	f:SetHeight(10)
	f:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", -5, 20)
end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

ns:addLayoutElement(units, function(self, unit)
	local f = self:CreateTexture(nil, "ARTWORK")
	self.Happiness = f

	utils.setSize(f, 24, 23)
	f:SetPoint("LEFT", self, "RIGHT", -7, -4)
end)

local frame, updateCombatFeedback

ns:addLayoutElement(units, function(self)
	frame = self
end)

oUF:RegisterInitCallback(function(self)
	if self == frame then
		local _, class = UnitClass"player"
		if class == "HUNTER" and IceHunex then
			local fb = IceHunex:GetModule"FeedMe"
			if fb then
				fb:UpdateButtonAnchor()
			end
		end
	end
end)

ns:spawn(function()
	local f = oUF:Spawn("pet", "wsUnitFrame_Pet")
	ns.frameList[f] = true
	ns.unitFrames.pet = f
	return f
end)

function updateCombatFeedback(f)
	if unitdb.combatfeedback then
		if not f then
			frame:EnableElement("CombatFeedbackText")
		end
	else
		frame:DisableElement("CombatFeedbackText")
	end
end


ns:RegisterUnitOptions("pet", {
    type = "group",
    name = L["pet"],
    order = ns.order(),
    args = {
        combatfeedback = {
            type = "toggle",
            name = L["Combat feedback text"],
            desc = L["Enable combat feedback test"],
            order = ns.order(),
            width = "full",
            get = function() return unitdb.combatfeedback end,
            set = function(_, v)
                unitdb.combatfeedback = v
                updateCombatFeedback()
            end,
        },
       -- auracooldown = {
       --     type = "toggle",
       --     name = L["Aura cooldown"],
       --     desc = L["Show aura cooldown"],
       --     order = ns.order(),
       --     get = function() return unitdb.auracooldown end,
       --     set = function(_, v)
       --         unitdb.auracooldown = v
       --         utils.updateAuraElement(frame)
       --     end,
       -- },
       -- castbyme = {
       --     type = "toggle",
       --     name = L["Cast by me only"],
       --     desc = L["Only show cooldown on those that cast by me"],
       --     order = ns.order(),
       --     disabled = function() return not unitdb.auracooldown end,
       --     get = function() return unitdb.castbyme end,
       --     set = function(_,v )
       --         unitdb.castbyme = v
       --         if(frame:IsVisible()) then
       --             utils.updateAuraElement(frame)
       --         end
       --     end,
       -- },
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
												ns:Reload("pet")	
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
												ns:Reload("pet")
                    end,
                },
            },
        },
    },
})
