-- by yaroot <yaroot AT gmail.com>
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local units = "partypet"

ns:setSize(units, 60, 17, 0.6)
ns:addLayoutElement(units, function(self, unit)
	local hp, mp
	hp = CreateFrame("StatusBar", nil, self)
	mp = CreateFrame("StatusBar", nil, self)
	self.Health, self.Power = hp, mp

	local BG = hp:CreateTexture(nil, "OVERLAY")
	BG:SetTexture[[Interface\Tooltips\UI-StatusBar-Border]]
	BG:SetPoint("TOPLEFT", -2, 2)
	BG:SetPoint("BOTTOMRIGHT", 2, -2)
	self.Health.BG = BG

	local BG = mp:CreateTexture(nil, "OVERLAY")
	BG:SetTexture[[Interface\Tooltips\UI-StatusBar-Border]]
	BG:SetPoint("TOPLEFT", -2, 2)
	BG:SetPoint("BOTTOMRIGHT", 2, -2)
	self.Power.BG = BG

	utils.setSize(hp, 70, 8)
	utils.setSize(mp, 70, 8)

	hp:SetPoint("TOPLEFT", 65, 20)
	mp:SetPoint("TOPLEFT", 65, 10)

	hp.colorHealth = true
	mp.colorPower = true
end)

ns:addLayoutElement(units, function(self, unit)
	local t = self.tags

	--local name = self.Health:CreateFontString(nil, 'ARTWORK')
	--t.name = name
	--name:SetFontObject(ChatFontNormal)
	--name:SetPoint('BOTTOM', self, 'TOP', 2, 6)
	--Tags:Register(self, name, '[colorname]')
	--name:UpdateTags()
	local hp = self.Health:CreateFontString(nil, 'ARTWORK')
	t.hp = hp
	hp:SetFontObject('TextStatusBarText')
	hp:SetPoint('CENTER')
	Tags:Register(self, hp, '[perhp]')
	hp:UpdateTags()
end)

local objs = {}
ns.units.partypets = objs
ns:addLayoutElement(units, function(self, unit)
	local parent = self:GetParent()
	parent.pet = self
	tinsert(objs, self)
end)
