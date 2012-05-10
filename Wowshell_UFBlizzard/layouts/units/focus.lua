local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local style = ns.style

local position = ns:RegisterUnitPosition("focus",{
	selfPoint = "BOTTOMRIGHT",
	anchorTo = "UIParent",
	relativePoint = "BOTTOMRIGHT",
	x = -500,
	y = 300,
})

local unitdb = ns:RegisterUnitDB("focus", {
	parent = {
		width = 160,
		height = 80,
		scale = 1,
	},
	castbar = true,
	auras = true,
	auracooldown = true,
	castbyme = true,
	tags = {
		name = { tag = "[name]"},
		hp = { tag = "[smart:curmaxhp]"},
		mp = { tag = "[smart:curmaxpp]"},
	},
});

local units = 'focus'

ns:setSize(units, unitdb.parent.width, unitdb.parent.height)

local function initScale(self)
	local InitScaleFrm = CreateFrame('Frame',nil)
	InitScaleFrm:RegisterEvent('PLAYER_ENTERING_WORLD')
	InitScaleFrm:SetScript('OnEvent',function(self,event)
		if(event == 'PLAYER_ENTERING_WORLD') then
			local scale = GetCVar('fullSizeFocusFrame') =='1' and 1.2 or 1
			wsUnitFrame_Focus:SetScale(scale)
			--print(GetCVar('fullSizeFocusFrame')) 
		end
	end)
end
local function changeScaleByCVar(self)
	local ChangeScaleFrm = CreateFrame('Frame',nil)
	ChangeScaleFrm:RegisterEvent('CVAR_UPDATE')
	ChangeScaleFrm:SetScript('OnEvent',function(self,event,key,value)
	if(event == 'CVAR_UPDATE') then
		--print(key,value)
		if(key == 'FULL_SIZE_FOCUS_FRAME_TEXT') then
			if(value == '1') then
				wsUnitFrame_Focus:SetScale(1.2)
			else
				wsUnitFrame_Focus:SetScale(1.0)
			end
		end
	end
	end)
end
initScale()
changeScaleByCVar()

ns:addLayoutElement(units, function(self, unit)
    local tex = self:CreateTexture(nil, 'BORDER')
    self.frametexture = tex
    tex:SetTexture[[Interface\TargetingFrame\UI-FocusTargetingFrame]]
    tex:SetTexCoord(1,0, 0,1)
    tex:SetAllPoints(self)
end)

ns:addLayoutElement(units, function(self, unit)
    local p = self.bg:CreateTexture(nil, 'OVERLAY')
    utils.setSize(p, 43)
    self.portrait_2d = p
    self.Portrait = p
    p:SetPoint('TOPRIGHT', -10, -6)
end)

ns:addLayoutElement(units, function(self, unit)
    local p = CreateFrame('PlayerModel', nil, self.bg)
    utils.setSize(p, 38)
    p:SetPoint('CENTER', self.portrait_2d)
    self.portrait_3d = p
end)


ns:addLayoutElement(units, function(self, unit)
    local hp, mp
    hp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(hp, 90, 7)
    mp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(mp, 90, 7)

    hp:SetPoint('TOPLEFT', 12, -28)
    mp:SetPoint('TOPLEFT', 12, -37)

    hp.colorHealth = true
    hp.frequentUpdates = true
    mp.colorPower = true
    mp.frequentUpdates = true

    self.Health, self.Power = hp, mp
end)

ns:addLayoutElement(units, function(self, unit)
    local namebg = CreateFrame('StatusBar', nil, self.bg)
    utils.testBackdrop(namebg)
    self.namebg = namebg
    namebg:SetStatusBarTexture[[Interface\TargetingFrame\UI-TargetingFrame-LevelBackground]]
    namebg:SetMinMaxValues(0, 100)
    namebg:SetValue(100)
    utils.setSize(namebg, 90, 18)
    namebg:SetBackdropColor(0,0,0, .4)
    namebg:SetPoint('CENTER', self, -23, 24)
    --self.Health:Hide()
    --self.Power:Hide()

    tinsert(self.__elements, utils.updateTapedBg)
    self:RegisterEvent('UNIT_FACTION', utils.updateTapedBg)
    self:RegisterEvent('UNIT_CLASSIFICATION_CHANGED', utils.updateTapedBg)
    self:RegisterEvent('UNIT_FLAGS', utils.updateTapedBg)
end)

ns:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local name = self:CreateFontString(nil, 'OVERLAY')
    t.name = name
    name:SetFontObject(GameFontNormalSmall)
    name:SetAllPoints(self.namebg)
		
    local hp = self:CreateFontString(nil, 'OVERLAY')
    t.hp = hp
		hp:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    hp:SetPoint("CENTER", self, -50, 4)
    do
        local font, size, flag = hp:GetFont()
        hp:SetFont(font, size-2, flag)
    end
    hp:SetPoint('CENTER', self.Health, 0, 0)

    local mp = self:CreateFontString(nil, 'OVERLAY')
    t.mp = mp
		mp:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
    mp:SetPoint("CENTER", self, -50, 4)
    do
        local font, size, flag = mp:GetFont()
        mp:SetFont(font, size-2, flag)
    end
    mp:SetPoint('CENTER', self.Power, 0, 0)
end)

ns:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon = ricon
    utils.setSize(ricon, 20)
    ricon:SetPoint('CENTER', self, 'TOPRIGHT', -30, -8)
end)

ns:addLayoutElement(units, function(self, unit)
    local button = CreateFrame('Button', nil, self)
    button:SetScale(.8)

    local icon = button:CreateTexture(nil, 'BACKGROUND')
    icon.button = button
    self.ClassIcon = icon
    utils.setSize(icon, 16)
    icon:SetPoint('CENTER', self, 35, -12)

    local border = button:CreateTexture(nil, 'BORDER')
    icon.border = border
    utils.setSize(border, 45)
    border:SetPoint('TOPLEFT', icon, 'TOPLEFT', -5, 6)
    border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
end)

local function post(icons, button)
    local font, size, flag = button.count:GetFont()
    button.count:SetFont(STANDARD_TEXT_FONT, size-2, flag)
    button.oufaura = true
    button.cd:SetDrawEdge(true)
    button.cd:SetReverse(true)
end


local function postCastStart(element)
    local self = element.__own

    if(unitdb.auraontop) then
        self.Castbar:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 30, 25)
    else
        --auras.visibleAuras = auras.visibleBuffs + auras.visibleDebuffs
        local auras = self.Auras
        local num = auras.visibleAuras

        if(auras.visibleBuffs > 1 and auras.visibleDebuffs > 1) then
            num = num + 1
        end

        local size, width = auras.size + auras.spacing or 0, auras:GetWidth()
        local iconsPerRow = math.floor(width/size + .5)
        local rows = math.ceil(num / iconsPerRow)

        local offsetY = rows * size

        --print(rows, iconsPerRow, size, width)
		--print(offsetY)
		if(offsetY ~= 0) then
			self.Castbar:SetPoint('TOPLEFT', self.Auras, 'TOPLEFT', 15, - offsetY * 1.4)
		else
			self.Castbar:SetPoint('TOPLEFT',self,'BOTTOMLEFT',20,0)
		end
    end
end

local function postAuraUpdate(aura)
    postCastStart(aura)
end

local function updateAuraPosition(self, forceUpdate)
    local frame = self.Auras
    if(unitdb.auraontop) then
        frame.initialAnchor = 'BOTTOMLEFT'
        frame['growth-y'] = 'UP'
        frame:SetPoint('BOTTOMLEFT',self, 'TOPLEFT', 10, 0)
			else
        frame.initialAnchor = 'TOPLEFT'
        frame['growth-y'] = 'DOWN'
       -- frame:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 10, 25)
				frame:SetPoint('BOTTOMLEFT',self,'TOPLEFT',10,-70)
		 end

    if(forceUpdate) then
       -- self:UpdateElement('Aura')
       -- utils.updateAuraElement(ns.unitFrames.focus)
    end
end

local function postUpdateIcon(icons, unit, icon, index, offset)
    utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
end

ns:addLayoutElement(units, function(self, unit)
    local frame = CreateFrame('Frame', nil, self)
    self.Auras = frame
    --utils.testBackdrop(frame)
    frame.PostCreateIcon = post
    frame.__own = self
    frame.showType = true
		
    --print(frame)
    frame.size = 18
    frame.numBuffs = 16
    frame.numDebuffs = 10
    frame.gap = true

    frame.spacing = 2
    frame['growth-x'] = 'RIGHT'
		frame['growth-y'] = 'UP'
   	frame.initialAnchor = 'BOTTOMLEFT'
		
		frame:SetWidth(180)
    frame:SetHeight(20)
		frame:SetPoint('BOTTOMLEFT',self,'TOPLEFT',10,0)
    frame.PostUpdate = postAuraUpdate
    updateAuraPosition(self)
    frame.PostUpdateIcon = postUpdateIcon
    
    if(not unitdb.auras) then
        frame:Hide()
    end
end)

ns:addLayoutElement(units, function(self, unit)
    local bar = CreateFrame('StatusBar', nil, self)
    self.Castbar = bar
    --bar:SetPoint('TOP', self, 'BOTTOM', 0, -20)
    bar.__own = self
    bar:SetScale(1.0)
		

    utils.setSize(bar, 150, 10)
    bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    bar:SetStatusBarColor(1, .7, 0)

    local icon = bar:CreateTexture(nil, 'ARTWORK')
    bar.Icon = icon
    utils.setSize(icon, 16)
    icon:SetTexture[[Interface\Icons\Spell_Shaman_Hex]]
    icon:SetPoint('RIGHT', bar, 'LEFT', -1, 0)

    local border = bar:CreateTexture(nil, 'ARTWORK')
    bar.Border = border
    utils.setSize(border, 200, 54)
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
	text:SetFontObject(SystemFont_Shadow_Small)
    do
        local f, s, flag = text:GetFont()

        text:SetFont(f, s-2, 'OUTLINE')
    end
    text:SetPoint('TOP', bar, 'TOP', 0, 0)

    local time = bar:CreateFontString(nil, 'OVERLAY')
    bar.Time = time
    time:SetFontObject(SystemFont_Shadow_Small)
    do
        local f, s, flag = time:GetFont()
        time:SetFont(f, s-2, 'OUTLINE')
    end
    time:SetPoint('RIGHT', bar, 'RIGHT', -5, 0)

    do
        -- 3.2.2 don't have this
        local tex = bar:GetStatusBarTexture()
        if(tex.SetHorizTile) then
            tex:SetHorizTile(true)
        end
    end

    bar.PostCastStart = postCastStart
end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

local frame
ns:addLayoutElement(units, function(self, unit)
    frame = self
end)


local function toggleCastbar(self)
    local obj = self or frame
    if(unitdb.castbar) then
        if(not self) then
            obj:EnableElement('Castbar')
        end
    else
        obj:DisableElement'Castbar'
        obj.Castbar:Hide()
    end
end

oUF:RegisterInitCallback(function(self)
    if( self == frame ) then
        toggleCastbar(self)
    end
end)


ns:spawn(function()
    local f = oUF:Spawn('focus', 'wsUnitFrame_Focus')
		ns.frameList[f] = true
		ns.unitFrames.focus = f
		return f
end)


--ns:RegisterInitCallback(function()
--    db = ns.db.profile
--    unitdb = ns.db:RegisterNamespace('focus', { profile = {
--            castbar = true,
--            auras = true,
--            auracooldown = true,
--            castbyme = true,
--            tagonhealthbar = 'SMAR',
--            tagonpowerbar = 'SMAR',
--        }
--    }).profile
--end)
--
--
ns:RegisterUnitOptions('focus', {
    type = 'group',
    name = L['focus'],
    order = ns.order(),
    args = {
        auraontop = {
            type = 'toggle',
            name = L['Aura on top'],
            desc = L['Display aura on the top of the frame'],
            order = ns.order(),
            width = 'full',
            get = function() return unitdb.auraontop end,
            set = function(_, v)
                unitdb.auraontop = v
                updateAuraPosition(ns.unitFrames.focus, true)
            end,
        },
        castbar = {
            type = 'toggle',
            name = L['Castbar'],
            desc = L['Enable castbar'],
            order = ns.order(),
            width = 'full',
            get = function() return unitdb.castbar end,
            set = function(_, v)
                unitdb.castbar = v
                toggleCastbar()
            end
        },
        auras = {
            type = 'toggle',
            name = L['Enable auras'],
            order = ns.order(),
            width = 'full',
            get = function() return unitdb.auras end,
            set = function(_, v)
                unitdb.auras = v
                if(v) then
                    frame.Auras:Show()
                else
                    frame.Auras:Hide()
                end
            end
        },
       -- auracooldown = {
       --     type = 'toggle',
       --     name = L['Aura cooldown'],
       --     desc = L['Show aura cooldown'],
       --     order = ns.order(),
       --     get = function() return unitdb.auracooldown end,
       --     set = function(_, v)
       --         unitdb.auracooldown = v
       --         utils.updateAuraElement(frame)
       --         --frame:UpdateElement'Aura'
       --     end,
       -- },
       -- castbyme = {
       --     type = 'toggle',
       --     name = L['Cast by me only'],
       --     desc = L['Only show cooldown on those that cast by me'],
       --     order = ns.order(),
       --     disabled = function() return not unitdb.auracooldown end,
       --     get = function() return unitdb.castbyme end,
       --     set = function(_,v )
       --         unitdb.castbyme = v
       --         if(frame:IsVisible()) then
       --             utils.updateAuraElement(frame)
       --             --frame:UpdateElement'Aura'
       --         end
       --     end,
       -- },
        taggroup = {
            type = 'group',
            name = L['Tag texts'],
            order = ns.order(),
            inline = true,
            args = {
                tagonhealthbar = {
                    type = 'select',
                    name = L['Text on health bar'],
                    desc = L['The text show on health bar'],
                    order = ns.order(),
                   values = {[""]= L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.hp.tag  end,
                    set = function(_, v)
                        unitdb.tags.hp.tag = v
												ns:Reload("pet")	
                    end,
                },
                tagonpowerbar = {
                    type = 'select',
                    name = L['Text on power bar'],
                    desc = L['The text show on power bar'],
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






