
local parent, ns = ...
local oUF = ns.oUF
local addon = ns.addon
local utils = addon.utils
local L = wsLocale:GetLocale('wsUnitFrame')
local db, unitdb

local arenas = {}

for arenaId =1,5 do
local units = 'arena'..arenaId

addon:setSize(units, 102, 32,1)

addon:addLayoutElement(units, function(self, unit)
    local tex = self:CreateTexture(nil, 'BACKGROUND')
    self.frametexture = tex
    tex:SetTexture[[Interface\ArenaEnemyFrame\UI-ArenaTargetingFrame]]
    tex:SetTexCoord(0, 0.796, 0, 0.5)
	tex:SetAllPoints(self)

end)

addon:addLayoutElement(units, function(self, unit)
    local hp, mp
    hp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(hp, 70, 6,1)
	hp:SetPoint('TOPLEFT', 3, -10)
    --hp:SetPoint('TOPRIGHT', -106, -41)
	--hp:SetPoint('CENTER', 0, 0)
	
    mp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(mp, 70, 6,1)
    mp:SetPoint('TOPLEFT', 3, -17)
    self.Health, self.Power = hp, mp
    hp.colorHealth = true
    hp.frequentUpdates = true
    mp.colorPower = true
    mp.frequentUpdates = true

end)

addon:addLayoutElement(units, function(self, unit)
    local button = CreateFrame('Button', nil, self)

    local icon = button:CreateTexture(nil, 'BACKGROUND')
    icon.button = button
    self.ClassIcon = icon
    utils.setSize(icon, 22)
    icon:SetPoint('RIGHT', self, -6, 0)

    local border = button:CreateTexture(nil, 'BORDER')
    icon.border = border
    utils.setSize(border, 60)
    border:SetPoint('TOPLEFT', icon, 'TOPLEFT', -8, 6)
	--border:SetTexture([[Interface\ArenaEnemyFrame\UI-Arena-Border]])
    border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])  

end)

addon:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local name = self:CreateFontString(nil, 'OVERLAY')
    t.name = name
    name:SetFontObject(ChatFontNormal)
    name:SetPoint('CENTER',self, -0, 22)
    self:Tag(name, '[raidcolor][name]')

    local hp = self:CreateFontString(nil, 'OVERLAY')
    t.hp = hp
	hp:SetFontObject(ChatFontNormal)
    --hp:SetFontObject('TextStatusBarText')
    do
        local font, size, flag = hp:GetFont()
        hp:SetFont(font, size-3, flag)
    end
    hp:SetPoint('CENTER', 93, 12)
    --utils.updateTag(self, hp, unitdb.tagonhealthbarright)
    --self:Tag(hp, '[colorhp][curhp]/[maxhp]')

    local mp = self:CreateFontString(nil, 'OVERLAY')
    t.mp = mp
	mp:SetFontObject(ChatFontNormal)
    do
        local font, size, flag = mp:GetFont()
        mp:SetFont(font, size-3, flag)
    end
    mp:SetPoint('CENTER', 93, 2)
end)

addon:addLayoutElement(units, function(self, unit)
    local parent = self:GetParent()
    parent.frames = parent.frames or {}
    tinsert(parent.frames, self)
end)

local function post(icons, button)
    local font, size, flag = button.count:GetFont()
    button.count:SetFont(font, 8, flag)
    button.oufaura = true

    button.cd:SetDrawEdge(true)
    button.cd:SetReverse(true)
end

local function postUpdateIcon(icons, unit, icon, index, offset)
    utils.postAuraUpdateCooldown(icons, unit, icon, index, offset)
end

addon:addLayoutElement(units, function(self, unit)
    local frame = CreateFrame('Frame', nil, self)
    self.Auras = frame
    frame.PostCreateIcon = post
    frame.showType = true

    frame.size = 16
    frame.numBuffs = 8
    frame.numDebuffs = 2
    --frame.gap = true

    frame.spacing = 2
    frame.initialAnchor = 'TOPLEFT'
    frame['growth-x'] = 'LEFT'
    frame['growth-y'] = 'DOWN'

    frame:SetWidth(200)
    frame:SetHeight(10)
    frame:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', -18, 22)
    frame.PostUpdateIcon = postUpdateIcon

end)

addon:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon = ricon
    utils.setSize(ricon, 14)
    ricon:SetPoint('RIGHT', self.tags['name'], 'LEFT', -5, 0)
end)

addon:addLayoutElement(units, function(self, unit)
    local bar = CreateFrame('StatusBar', nil, self)
    bar:SetScale(1)
    self.Castbar = bar
	bar:SetPoint('TOPRIGHT',self,'BOTTOMRIGHT',0,0)
    --bar:SetPoint('TOPLEFT', self, 'BOTTOMRIGHT', -15, -5)
    bar.__own = self

    utils.setSize(bar, 100, 10)
    bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    bar:SetStatusBarColor(1, .7, 0)

    local icon = bar:CreateTexture(nil, 'ARTWORK')
    bar.Icon = icon
    utils.setSize(icon, 16)
    icon:SetTexture[[Interface\Icons\Spell_Shaman_Hex]]
    icon:SetPoint('RIGHT', bar, 'LEFT', -4, 0)

    local border = bar:CreateTexture(nil, 'ARTWORK')
    bar.Border = border
    utils.setSize(border, 138, 54)
    border:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    border:SetPoint('CENTER', bar)

    local shield = bar:CreateTexture(nil, 'OVERLAY')
    bar.Shield = shield
    utils.setSize(shield, 200, 54)
    shield:SetPoint('CENTER', bar, -3, 0)
    shield:SetTexture[[Interface\CastingBar\UI-CastingBar-Small-Shield]]

    local spark = bar:CreateTexture(nil, 'OVERLAY')
    bar.Spark = spark
    utils.setSize(spark, 26)
    spark:SetBlendMode'ADD'

    local text = bar:CreateFontString(nil, 'OVERLAY')
    bar.Text = text
	text:SetFontObject(ChatFontNormal)
    do
        local f, s, flag = text:GetFont()
        text:SetFont(f, s-2, flag)
    end
    text:SetPoint('TOP', bar, 'TOP', 0, 0)

    local time = bar:CreateFontString(nil, 'OVERLAY')
    bar.Time = time
    time:SetFontObject(ChatFontNormal)
    do
        local f, s, flag = time:GetFont()
        time:SetFont(f, s-2, flag)
    end
    time:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)

    do
        -- 3.2.2 don't have this
        local tex = bar:GetStatusBarTexture()
        if(tex.SetHorizTile) then
            tex:SetHorizTile(true)
        end
    end

local frames = {}
addon:addLayoutElement(units, function(self, unit)
		print(arenaId)
    frames[arenaId] = self
end)


end)

addon:RegisterInitCallback(function()
    db = addon.db.profile

    unitdb = addon.db:RegisterNamespace('arena'..arenaId, { profile = {
            enabled = true,
            --colorbyreaction = true,
        }
    }).profile
end)



addon:spawn(function()
    local f = oUF:Spawn(units, "wsUnitFrame_Arena"..arenaId)
		if not IsAddOnLoaded("Gladius") then
			arenas[arenaId] = f
			if arenaId == 1 then
				arenas[arenaId]:SetPoint("RIGHT", UIParent, 'RIGHT' ,-180, 200)
			else
				arenas[arenaId]:SetPoint('TOPLEFT',arenas[arenaId-1],'BOTTOMLEFT',0,-30)
			end
			addon.units['arena'..arenaId] = f
		end
end)
end

-- addon:RegisterModuleOptions('arena', {
    -- type = 'group',
    -- name = L['arena'],
    -- order = addon.order(),
    -- args = {
        -- enabled = {
            -- type = 'toggle',
            -- name = L['Enabled'],
            -- desc = L['Enable arena'],
            -- order = addon.order(),
            -- width = 'full',
            -- get = function() return unitdb.enabled end,
            -- set = function(_, v)
                -- unitdb.enabled = v
                -- if(v) then
                    -- frame:Enable()
                -- else
                    -- frame:Disable()
                -- end
            -- end,
        -- },
        -- taggroup = {
            -- type = 'group',
            -- name = L['Tag texts'],
            -- order = addon.order(),
            -- inline = true,
            -- args = {
                -- tagonhealthbar = {
                    -- type = 'select',
                    -- name = L['Text on health bar'],
                    -- desc = L['The text show on health bar'],
                    -- order = addon.order(),
                    -- values = utils.tag_select_values,
                    -- disabled = function() return not unitdb.enabled end,
                    -- get = function() return unitdb.tagonhealthbar or 'NONE' end,
                    -- set = function(_, v)
                        -- unitdb.tagonhealthbar = v
                        -- utils.updateTag(frame, 'hp', v)
                    -- end,
                -- },
                -- tagonpowerbar = {
                    -- type = 'select',
                    -- name = L['Text on power bar'],
                    -- desc = L['The text show on power bar'],
                    -- order = addon.order(),
                    -- values = utils.tag_select_values,
                    -- disabled = function() return not unitdb.enabled end,
                    -- get = function() return unitdb.tagonpowerbar or 'NONE' end,
                    -- set = function(_, v)
                        -- unitdb.tagonpowerbar = v
                        -- utils.updateTag(frame, 'mp', v, 1)
                    -- end,
                -- },
            -- },
        -- },
    -- },
-- })

local option_args = {
    enabled = {
        type = 'toggle',
        name = L['Enable'],
        desc = L['Enable arena'] .. '\n' .. L['The settings will take effect after reload.'],
        width = 'full',
        order = addon.order(),
        get = function() return unitdb.enabled end,
        set = function(_, v)
            unitdb.enabled = v
            --StaticPopup_Show'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
        end,
    },
}

addon:RegisterModuleOptions('arena', {
    type = 'group',
    name = L['arena'],
    order = addon.order(),
    args = option_args,
})


