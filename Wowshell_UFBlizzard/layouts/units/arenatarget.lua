
local parent, ns = ...
local oUF = ns.oUF
local addon = ns.addon
local utils = addon.utils
local L = wsLocale:GetLocale('wsUnitFrame')
local db, unitdb
local arenaTargets = {}

for arenaTargetId=1,5 do
local units = 'arenatarget'..arenaTargetId

local gWidth,gHeight,gScale = 76,14,.9
--addon:setSize(units, 80, 16, .9)
addon:setSize(units, gWidth,gHeight,gScale)

--old func
--addon:addLayoutElement(units, function(self, unit)
  --  self:SetAttribute('type2', nil)
    --self.menu = nil
--end)

--new func
addon:addLayoutElement(units, function(self, unit)
   -- local tex = self:CreateTexture(nil, 'ARTWORK')
    --self.frametexture = tex
	--tex:SetTexture[[Interface\AddOns\Wowshell_UnitFrame\texture\StatusBar]]
    --tex:SetTexture[[Interface\TargetingFrame\UI-TargetofTargetFrame]]
    --tex:SetTexCoord(0.015625, 0.7265625, 0, 0.703125)
    --tex:SetAllPoints(self)
		
	self:SetAttribute('type2', nil)
    self.menu = nil
end)



local function postUpdate(bar, unit, min, max)
    if(unitdb.colorbyreaction) then
        if(UnitIsEnemy('player', unit)) then
            --bar:SetStatusBarColor(1, .55, .72)
            --bar.__self.framebg:SetVertexColor(1, .2, .2)
			bar:SetStatusBarColor(1, 0, 0)
            bar.__self.framebg:SetVertexColor(1, .2, .2)
        elseif(UnitIsFriend('player', unit)) then
            --bar:SetStatusBarColor(1, 1, 1)
            --bar.__self.framebg:SetVertexColor(1, 1, 1)
			bar:SetStatusBarColor(0, 1, 0)
            bar.__self.framebg:SetVertexColor(0, 1, 0)
			
        else
            --bar:SetStatusBarColor(.65, .9, .85)
            --bar.__self.framebg:SetVertexColor(.9, .82, 0)
			bar:SetStatusBarColor(1, 1, 0)
            bar.__self.framebg:SetVertexColor(.9, .82, 0)
        end
    else
        bar:SetStatusBarColor(unpack(bar.__self.colors.health))
    end
end

--edit:
addon:addLayoutElement(units, function(self, unit)

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

addon:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local name = self.Health:CreateFontString(nil, 'ARTWORK')
    t.name = name
    --name:SetFontObject(NumberFontNormal)
	name:SetFontObject(ChatFontNormal)
    --do
      --  local font, size, flag = name:GetFont()
        --name:SetFont(STANDARD_TEXT_FONT, size, flag)
    --end
    name:SetPoint('BOTTOM', self, 'TOP', 2, 6)
    self:Tag(name, '[raidcolor][name]')

    local hp = self.Health:CreateFontString(nil, 'ARTWORK')
    t.hp = hp
    hp:SetFontObject('TextStatusBarText')
    --hp:SetPoint('BOTTOMRIGHT',self,'TOPRIGHT',-10,10)
	hp:SetPoint('CENTER')
    self:Tag(hp, '[perhp] %')
	
	
	
end)

addon:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon = ricon
    utils.setSize(ricon, 14)
    ricon:SetPoint('RIGHT', self.tags['name'], 'LEFT', -5, 0)
end)



local objs = {}
addon.units.arenatargets = objs
addon:addLayoutElement(units, function(self, unit)
    tinsert(objs, self)
end)

addon:RegisterInitCallback(function()
    db = addon.db.profile

    unitdb = addon.db:RegisterNamespace('arenatarget'..arenaTargetId, { profile = {
            enabled = true,
            --colorbyreaction = true,
        }
    }).profile
end)

local frame
addon:addLayoutElement(units, function(self, unit)
    frame = self
end)

addon:spawn(function()
    local f = oUF:Spawn(units, "wsUnitFrame_ArenaTarget"..arenaTargetId)
	arenaTargets[arenaTargetId] = f
	--if arenaTargetId == 1 then
		arenaTargets[arenaTargetId]:SetPoint('LEFT','wsUnitFrame_Arena'..arenaTargetId,'RIGHT',10,0)
	--else
		--arenaTargets[arenaTargetId]:SetPoint('TOPLEFT',arenaTargets[arenaTargetId-1],'BOTTOMLEFT',0,-30)
	--end
    --f:SetPoint("LEFT", addon.units.arena,'RIGHT', 10, 0)
    addon.units['arenaTarget'..arenaTargetId] = f

end)
end

local option_args = {
    enabled = {
        type = 'toggle',
        name = L['Enable'],
        desc = L['Enable arena target'] .. '\n' .. L['The settings will take effect after reload.'],
        width = 'full',
        order = addon.order(),
        get = function() return unitdb.enabled end,
        set = function(_, v)
            unitdb.enabled = v
            --StaticPopup_Show'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
        end,
    },
    -- colorbyreaction = {
        -- type = 'toggle',
        -- name = L['Color by target\'s reaction'],
        -- desc = L['Color health bar by target\'s reaction'],
        -- width = 'full',
        -- disabled = function() return not unitdb.enabled end,
        -- order = addon.order(),
        -- get = function() return unitdb.colorbyreaction end,
        -- set = function(_,v)
            -- unitdb.colorbyreaction = v
            -- for _, f in ipairs(objs) do
                    -- f.Health:ForceUpdate()
                    --f:UpdateElement('Health')
            -- end
        -- end,
    -- },
}

addon:RegisterModuleOptions('arenatarget', {
    type = 'group',
    name = L['arenatarget'],
    order = addon.order(),
    args = option_args,
})
