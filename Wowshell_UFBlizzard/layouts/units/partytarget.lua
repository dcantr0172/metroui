-- by yaroot <yaroot AT gmail.com>


local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile


local units = 'partytarget'

ns:setSize(units, 60,16)

--old func
--ns:addLayoutElement(units, function(self, unit)
  --  self:SetAttribute('type2', nil)
    --self.menu = nil
--end)

--new func
ns:addLayoutElement(units, function(self, unit)
   -- local tex = self:CreateTexture(nil, 'ARTWORK')
   -- self.frametexture = tex
	 -- tex:SetTexture[[Interface\AddOns\Wowshell_UnitFrame\texture\StatusBar]]
   --tex:SetTexture[[Interface\TargetingFrame\UI-TargetofTargetFrame]]
   -- tex:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
   -- tex:SetAllPoints(self)
		
	self:SetAttribute('type2', nil)
    self.menu = nil
end)

local function postUpdate(bar, unit, min, max)
    --if(unitdb.colorbyreaction) then
			if true then
        if(UnitIsEnemy('player', unit)) then
            bar:SetStatusBarColor(1, .55, .72)
            bar.__self.framebg:SetVertexColor(1, .2, .2)
			bar:SetStatusBarColor(1, 0, 0)
            bar.__self.framebg:SetVertexColor(1, .2, .2)
        elseif(UnitIsFriend('player', unit)) then
            bar:SetStatusBarColor(1, 1, 1)
            bar.__self.framebg:SetVertexColor(1, 1, 1)
			bar:SetStatusBarColor(0, 1, 0)
            bar.__self.framebg:SetVertexColor(0, 1, 0)
			
        else
            bar:SetStatusBarColor(.65, .9, .85)
            bar.__self.framebg:SetVertexColor(.9, .82, 0)
			bar:SetStatusBarColor(1, 1, 0)
            bar.__self.framebg:SetVertexColor(.9, .82, 0)
        end
    else
        bar:SetStatusBarColor(unpack(bar.__self.colors.health))
    end
end

--edit:
ns:addLayoutElement(units, function(self, unit)
	local hp = CreateFrame('StatusBar', nil, self)
	self.Health = hp
	--hp:SetAllPoints(self)
	hp:SetPoint('TOPLEFT',self,'TOPLEFT',2,4)
	hp:SetPoint('BOTTOMRIGHT',self,'BOTTOMRIGHT',-2,4)
	--hp:SetStatusBarTexture[[Interface\AddOns\Wowshell_UnitFrame\texture\StatusBar]]
	hp:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
	hp.PostUpdate = postUpdate
	hp.__self = self

	local bg = self.Health:CreateTexture(nil, 'OVERLAY')
	self.framebg = bg
	bg:SetTexture[[Interface\Tooltips\UI-StatusBar-Border]]
	bg:SetPoint('TOPLEFT', -2, 2)
	bg:SetPoint('BOTTOMRIGHT', 2, -2)
end)

ns:addLayoutElement(units, function(self, unit)
	local t = self.tags
	local name = self.Health:CreateFontString(nil, 'ARTWORK')
	t.name = name
	name:SetFontObject(ChatFontNormal)
	name:SetPoint('BOTTOM', self, 'TOP', 2, 6)
	Tags:Register(self, name, '[colorname]')
	name:UpdateTags()

	local hp = self.Health:CreateFontString(nil, 'ARTWORK')
	t.hp = hp
	hp:SetFontObject('TextStatusBarText')
	hp:SetPoint('CENTER')
	Tags:Register(self, hp, '[perhp]')
	hp:UpdateTags()
end)

ns:addLayoutElement(units, function(self, unit)
	local ricon = self:CreateTexture(nil, 'OVERLAY')
	self.RaidIcon = ricon
	utils.setSize(ricon, 14)
	ricon:SetPoint('RIGHT', self.tags['name'], 'LEFT', -5, 0)
	--ricon:SetFrameLevel(3)
end)


local objs = {}
ns.units.partytargets = objs
ns:addLayoutElement(units, function(self, unit)
    tinsert(objs, self)
end)


