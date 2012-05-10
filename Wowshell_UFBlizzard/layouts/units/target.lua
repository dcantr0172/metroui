local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile;
local style = ns.style

local position = ns:RegisterUnitPosition("target", {
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_Player",
	relativePoint = "TOPRIGHT",
	x = 130,
	y = 0
});

local unitdb = ns:RegisterUnitDB("target", {
	parent = {
		width = 232,
		height = 100,
		scale = 1,
	},
	castbar = true,
	auracooldown = true,
	castbyme = true,
	highlightmydebuff = false,
	indicators = {
		pvp = {enabled = true, },
	},
	tags = {
		lvl = { tag = "[levelcolor]",},
		name = { tag = "[name]",},
		hp = { tag = "[smart:curmaxhp]",},
		mp = { tag = "[smart:curmaxpp]",},
		perhp = { tag = "[hp:color][perhp][close]",},
		perpp = { tag = "[perpp]"},
	}
	})


local units = "target"
ns:setSize(units, unitdb.parent.width, unitdb.parent.height,unitdb.parent.scale)

local function PLAYER_TARGET_CHANGED(self, event, unit)
    if ( UnitExists("target") ) then
        if ( UnitIsEnemy("target", "player") ) then
            PlaySound("igCreatureAggroSelect");
        elseif ( UnitIsFriend("player", "target") ) then
            PlaySound("igCharacterNPCSelect");
        else
            PlaySound("igCreatureNeutralSelect");
        end
    end

    local c = UnitClassification("target")
    if(c == "worldboss" or c == "elite") then
        self.frametexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Elite]]
    elseif(c == "rareelite") then
        self.frametexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Rare-Elite]]
    elseif(c == "rare") then
        self.frametexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Rare]]
    else
        self.frametexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]
		end
end

-- frame texture
ns:addLayoutElement(units, function(self, unit)
    local tex = self:CreateTexture(nil, "BACKGROUND")
    self.frametexture = tex

    tex:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]
    tex:SetTexCoord(0.09375, 1, 0, 0.78125)
    tex:SetAllPoints(self)

    self:RegisterEvent("PLAYER_TARGET_CHANGED", PLAYER_TARGET_CHANGED)
    tinsert(self.__elements, PLAYER_TARGET_CHANGED)
end)


ns:addLayoutElement(units, function(self, unit)
    local p = self.bg:CreateTexture(nil, "ARTWORK")
    self.Portrait = p
    self.portrait_2d = p

    utils.setSize(p, 64)
    p:SetPoint("TOPRIGHT", -42, -12)
end)

ns:addLayoutElement(units, function(self, unit)
    local p = CreateFrame("PlayerModel", nil, self.bg)
    utils.setSize(p, 48)
    p:SetPoint("CENTER", self.portrait_2d)
    self.portrait_3d = p
end)

ns:addLayoutElement(units, function(self, unit)
	oUF.colors.health = {49/255, 207/255, 37/255}
	local hp, mp
	hp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(hp, 119, 12)
	hp:SetPoint("TOPRIGHT", -106, -41)

	mp = CreateFrame("StatusBar", nil, self.bg)
	utils.setSize(mp, 119, 12)
	mp:SetPoint("TOPRIGHT", -106, -52)

	self.Health, self.Power = hp, mp

	hp.Smooth = true
	hp.colorHealth = true
	hp.frequentUpdates = true
	hp.Smooth = true
	mp.colorPower = true
	mp.frequentUpdates = true
end)

ns:addLayoutElement(units, function(self, unit)
    local pvp = self:CreateTexture(nil, "ARTWORK")
    utils.setSize(pvp, 64)
    pvp:SetPoint("TOPRIGHT", 3, -20)
    self.PvP = pvp

    local leader = self:CreateTexture(nil, "OVERLAY")
    self.Leader = leader
    utils.setSize(leader, 16)
    leader:SetPoint("TOPRIGHT", -44, -10)
end)

ns:addLayoutElement(units, function(self, unit)
    local button = CreateFrame("Button", nil, self)

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon.button = button
    self.ClassIcon = icon
    utils.setSize(icon, 16)
    icon:SetPoint("CENTER", self, 12, -17)

    local border = button:CreateTexture(nil, "BORDER")
    icon.border = border
    utils.setSize(border, 45)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -5, 6)
    border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
end)

ns:addLayoutElement(units, function(self, unit)
    local threat = self.bg:CreateTexture(nil, "BACKGROUND")
    self.Threat = threat
    threat:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Flash]]
    utils.setSize(threat, 242, 93)
    threat:SetTexCoord(0, 0.9453125, 0, 0.181640625)
    threat:SetPoint("TOPLEFT", self, -24, 0)
end)

ns:addLayoutElement(units, function(self, unit)
    -- threat text
    local threat = CreateFrame("Frame", nil, self);
    utils.setSize(threat, 49, 18);
    threat:SetPoint("BOTTOM", self, "TOP", -50, -22);
    local text = threat:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    text:SetText("100%");
    text:SetPoint("TOP", 0, -4);
    local bg = threat:CreateTexture(nil, "BACKGROUND");
    bg:SetTexture([[Interface\TargetingFrame\UI-StatusBar]]);
    utils.setSize(bg, 37, 14)
    bg:SetPoint("TOP", 0 , -3);
    local border = threat:CreateTexture("nil", "BORDER");
    border:SetTexture([[Interface\TargetingFrame\NumericThreatBorder]]);
    border:SetTexCoord(0, 0.765625, 0, 0.5625)
    border:SetAllPoints(threat)

    threat:Hide()
    local onevent = function(self)
        if UnitExists"target" and UnitCanAttack("player", "target") then
            threat.nextUpdate = 0
            threat:Show()
        else
            threat:Hide()
        end
    end

    tinsert(self.__elements, onevent)

    threat.nextUpdate = 0
    threat:SetScript("OnUpdate", function(self, elapsed)
			self.nextUpdate = self.nextUpdate - elapsed
			if self.nextUpdate <= 0 then
				self.nextUpdate = .5

				local isTanking, status, pct = UnitDetailedThreatSituation(PlayerFrame.unit, "target")
				if isTanking then
					pct = 100
				end

				if not status then
					status = 0
				end
				pct = pct or 0

				local r,g,b = GetThreatStatusColor(status)
				if r then
					bg:SetVertexColor(r, g, b)
				end

				text:SetFormattedText("%d %%", pct)
			end
		end)
end)

ns:addLayoutElement(units, function(self, unit)
	local cps = CreateFrame("Frame", nil, self)
	self.CPoints = cps

	for i = 1, 5 do
		local bg = cps:CreateTexture(nil, "ARTWORK")
		local hl = cps:CreateTexture(nil, "OVERLAY")
		cps[i] = hl
		hl.bg = bg

		if i == 5 then
			utils.setSize(bg, 15, 18)
			utils.setSize(hl, 9, 17)
		else
			utils.setSize(bg, 12, 16)
			utils.setSize(hl, 8, 16)
		end

		bg:SetTexture[[Interface\ComboFrame\ComboPoint]]
		hl:SetTexture[[Interface\ComboFrame\ComboPoint]]
		bg:SetTexCoord(0, 0.375, 0, 1)
		hl:SetTexCoord(0.375, 0.5625, 0, 1)

		if(i == 1) then
			bg:SetPoint("TOPRIGHT", self, -44, -9)
		elseif(i == 2) then
			bg:SetPoint("TOP", cps[i-1], "BOTTOM", 7, 6)
		elseif(i == 3) then
			bg:SetPoint("TOP", cps[i-1], "BOTTOM", 4, 4)
		elseif(i == 4) then
			bg:SetPoint("TOP", cps[i-1], "BOTTOM", 1, 3)
		elseif(i == 5) then
			bg:SetPoint("TOP", cps[i-1], "BOTTOM", -1, 3)
		end

		hl:SetPoint("TOPLEFT", bg, 2, 0)
	end
	cps:Hide()

	local postUpdate = function()
		local cp = GetComboPoints(UnitHasVehicleUI("player") and "vehicle" or "player", "target")
		if cp and cp > 0 then
			cps:Show()
		else
			cps:Hide()
		end
	end

	self:RegisterEvent("UNIT_COMBO_POINTS", postUpdate)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", postUpdate)
end)

ns:addLayoutElement(units, function(self, unit)
    local t = self.tags
    local lvl = self:CreateFontString(nil, "OVERLAY")
    t.lvl = lvl
    lvl:SetFontObject(GameFontNormalSmall)
    lvl:SetPoint("CENTER", 63, -16)
	--	Tags:Register(self, lvl, "[levelcolor]");
	--	lvl:UpdateTags();
	--	lvl:Show();

    local namebg = CreateFrame("StatusBar", nil, self.bg)
    utils.testBackdrop(namebg)
    self.namebg = namebg
    namebg:SetStatusBarTexture[[Interface\TargetingFrame\UI-TargetingFrame-LevelBackground]]
    namebg:SetMinMaxValues(0, 100)
    namebg:SetValue(100)
    utils.setSize(namebg, 118, 18)
    namebg:SetBackdropColor(0,0,0, .4)
    namebg:SetPoint("CENTER", self, -50, 18)
    --self.Health:Hide()
    --self.Power:Hide()
    tinsert(self.__elements, utils.updateTapedBg)
    self:RegisterEvent("UNIT_FACTION", utils.updateTapedBg)
    self:RegisterEvent("UNIT_CLASSIFICATION_CHANGED", utils.updateTapedBg)
    self:RegisterEvent("UNIT_FLAGS", utils.updateTapedBg)

    local name = self:CreateFontString(nil, "OVERLAY")
    t.name = name
    name:SetFontObject(GameFontNormalSmall)
    --name:SetPoint("CENTER", self, -50, 19)
    name:SetAllPoints(namebg)
	--	Tags:Register(self, name, "[name]");
	--	name:UpdateTags();
	--	name:Show();

    local hp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.hp = hp
    do local font = hp:GetFont()
        hp:SetFont(font, 12, "THINOUTLINE")
    end
    hp:SetPoint("CENTER", self, -50, 4)
	--	Tags:Register(self, hp, "[smart:curmaxhp]");
	--	hp:UpdateTags();
	--	hp:Show();

    local mp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.mp = mp
    do local font = mp:GetFont()
        mp:SetFont(font, 12, "THINOUTLINE")
    end
    mp:SetPoint("CENTER", self, -50, -10)
    mp.frequentUpdates = .1
	--	Tags:Register(self, mp, "[smart:curmaxpp]");
	--	mp:UpdateTags();
	--	mp:Show();

    local perhp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.perhp = perhp
    do local font = perhp:GetFont()
         perhp:SetFont(font, 12, "THINOUTLINE")
    end
    perhp:SetPoint("CENTER", self, -133, 4)
	--	Tags:Register(self, perhp, "[perhp]");
	--	perhp:UpdateTags();
	--	perhp:Show();

    local perpp = self:CreateFontString(nil, "OVERLAY","ChatFontNormal")
    t.perpp = perpp
    do local font = perpp:GetFont()
        perpp:SetFont(font, 12, "THINOUTLINE")
    end
    perpp:SetPoint("CENTER", self, -133, -10)
    perpp.frequentUpdates = .1
	--	Tags:Register(self, perpp, "[perpp]");
	--	perpp:UpdateTags();
	--	perpp:Show();
end)

ns:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, "OVERLAY")
    self.RaidIcon = ricon
    utils.setSize(ricon, 26)
    ricon:SetPoint("CENTER", self, "TOPRIGHT", -73, -14)
end)

ns:addLayoutElement(units, function(self, unit)
    local skull = self:CreateTexture(nil, "OVERLAY")
    self.Skull = skull
    skull:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame-Skull]]
    utils.setSize(skull, 16)
    skull:SetPoint("CENTER", self, 63, -16)

    tinsert(self.__elements, function(self)
        if(UnitIsCorpse(self.unit) or (UnitLevel(self.unit) <= 0)) then
            self.Skull:Show()
            self.tags.lvl:Hide()
        else
            self.Skull:Hide()
            self.tags.lvl:Show()
            self.tags.lvl:UpdateTags()
        end

    end)
end)

ns:addLayoutElement(units, function(self, unit)
    self.ResetTargetInfoQueryButton = function(self)
        local queryBtn = TargetInfoQueryButton
        if(queryBtn) then
            queryBtn:ClearAllPoints()
            queryBtn:SetParent(self)
            queryBtn:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 1)
        end
    end
    self:ResetTargetInfoQueryButton()
end)

local function post(icons, button)
    local font, size, flag = button.count:GetFont()
    button.count:SetFont(STANDARD_TEXT_FONT, size, flag)
    button.oufaura = true
    button.cd:SetDrawEdge(true)
    button.cd:SetReverse(true)
end

local function updateAuraPosition(self, forceUpdate)
    --local frame = self.Auras
    --if(ns.db.target_auraontop) then
    --    frame.initialAnchor = "BOTTOMLEFT"
    --    frame["growth-y"] = "UP"
    --    frame:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 5, -15)
    --else
    --    frame.initialAnchor = "TOPLEFT"
    --    frame["growth-y"] = "DOWN"
    --    frame:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, 25)
    --end

    local buffs = self.Buffs
    local debuffs = self.Debuffs

    local onTop = unitdb.auraontop
    if(onTop)then
        buffs.initialAnchor = "BOTTOMLEFT"
        buffs["growth-y"] = "UP"

        debuffs.initialAnchor = "BOTTOMLEFT"
        debuffs["growth-y"] = "UP"

        buffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 5, -15)
    else
        buffs.initialAnchor = "TOPLEFT"
        buffs["growth-y"] = "DOWN"

        debuffs.initialAnchor = "TOPLEFT"
        debuffs["growth-y"] = "DOWN"

        buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, 25)
    end


    if(forceUpdate) then
        utils.updateAuraElement(self)
        --self:UpdateElement("Aura")
    end
end

local function postCastStart(element)
    local self = element.__own
    local cb = self.Castbar
    local buffs = self.Buffs
    local debuffs = self.Debuffs

    if(unitdb.auraontop) then
        cb:SetPoint("TOP", self, "BOTTOM", -30, 10)
    else

        local rows = cb.buffrows or 0
        local size = cb.buffsize or 0

        local offsetY = rows * size
        cb:SetPoint("TOP", self, "BOTTOM", -30, 10 - offsetY)
    end
end

local function postAuraUpdate(element)
    local self = element.__own
    local buffs = self.Buffs
    local debuffs = self.Debuffs
		--local auras = self.Auras
    local numBuffs = buffs.visibleBuffs
    local numDebuffs = debuffs.visibleDebuffs

    local rows

    local size, width = buffs.size+buffs.spacing or 0, buffs:GetWidth()
    local iconsPerRow = math.floor(width/size + .5)
    rows = math.ceil(numBuffs / iconsPerRow)

    --print(numBuffs, numDebuffs, rows )
    if(unitdb.auraontop) then
        debuffs:SetPoint("BOTTOMLEFT", buffs, 0, rows * size)
    else
        debuffs:SetPoint("TOPLEFT", buffs, 0, -rows * size)
    end

    rows = rows + math.ceil(numDebuffs / iconsPerRow)

    self.Castbar.buffrows = rows
    self.Castbar.buffsize = size
    postCastStart(element)
end

local isMineDebuff = {
    player = true,
    vehicle = true,
    -- FIXME: should we do this?
    --pet = true,
}

local function highlightMyDebuff(icons, unit, icon, index, offset)
	--if(not icon.debuff or not UnitIsEnemy('player',unit)) then return end
	--[[local _,_,_,_,_,_,_, caster = UnitAura(unit,index,icon.filter)
	if(caster ~= 'player' and caster ~='vehicle') then
		icon.overlay:SetVertexColor(0.25,0.25,0.25)
		icon.icon:SetDesaturated(true)
	else
		icon.icon:SetDesaturated(false)
	end]]
    if(icon.debuff and unitdb.highlightmydebuff) then
        local name, rank, texture, count, dtype, duration, timeLeft, caster, isStealable, shouldConsolidate, spellID = UnitAura(unit, index, icon.filter)
        if(caster and isMineDebuff[caster]) then
            icon.stealable:Show()
					end
    end
end

local function postUpdateIcon(icons, unit, icon, index, offset)
    --utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
    highlightMyDebuff(icons, unit, icon, index, offset)
		local self = icons.__own
		if unitdb.castbyme then
			if UnitCanAttack("player","target") then
				self.Buffs.onlyShowPlayer = false
				self.Debuffs.onlyShowPlayer = unitdb.castbyme
			else
				self.Buffs.onlyShowPlayer = unitdb.castbyme
				self.Debuffs.onlyShowPlayer = false
			end
		else
			self.Buffs.onlyShowPlayer = false
			self.Debuffs.onlyShowPlayer = false
		end
end

ns:addLayoutElement(units, function(self, unit)
		
	--	local auras = CreateFrame('Frame',nil,self)
		--self.Auras = auras
		--auras.PostCreateIcon = post
		--
		--auras.size = 20
		--auras.gap = true
		--auras.size = 20
		--auras.numBuffs = 4
		--auras.numDebuffs = 4
		--auras.showType = true
		--auras.spacing = 2
		--auras.initialAnchor = 'TOPLEFT'
		--auras['growth-x'] = 'RIGHT'
		--auras['growth-y'] = 'DOWN'

		--auras:SetWidth(70)
		--auras:SetHeight(100)
		--auras:SetPoint('TOPLEFT',self,'BOTTOMLEFT',0,30)



    local buffs = CreateFrame("Frame", nil, self)
    self.Buffs = buffs
    buffs.PostCreateIcon = post

    buffs.size = 20
    buffs.gap = true

    buffs.spacing = 2
    buffs["growth-x"] = "RIGHT"
    buffs.showType = true

    buffs:SetWidth(140)
    buffs:SetHeight(100)
    buffs.showStealableBuffs = true

    local debuffs = CreateFrame("Frame", nil, self)
    self.Debuffs = debuffs
    debuffs.PostCreateIcon = post

    debuffs.size = 20
    debuffs.gap = true
		
    debuffs.spacing = 2
    debuffs["growth-x"] = "RIGHT"
    debuffs.showType = true

    debuffs:SetWidth(140)
    debuffs:SetHeight(100)

    buffs.PostUpdateIcon = postUpdateIcon
    debuffs.PostUpdateIcon = postUpdateIcon

    -- XXX
    --utils.testBackdrop(buffs)
    --utils.testBackdrop(debuffs)

    debuffs.PostUpdate = postAuraUpdate
    debuffs.__own = self
		buffs.__own = self
    updateAuraPosition(self)
		if unitdb.castbyme then
			if UnitCanAttack("player","target") then
				self.Buffs.onlyShowPlayer = false
				self.Debuffs.onlyShowPlayer = unitdb.castbyme
			else
				self.Buffs.onlyShowPlayer = unitdb.castbyme
				self.Debuffs.onlyShowPlayer = false
			end
		else
			self.Buffs.onlyShowPlayer = false
			self.Debuffs.onlyShowPlayer = false
		end
end)

ns:addLayoutElement(units, function(self, unit)
  if not unitdb.castbar then return end  
	local bar = CreateFrame("StatusBar", nil, self)
    self.Castbar = bar
    bar:SetPoint("TOP", self, "BOTTOM", 0, -20)
    bar.__own = self

    utils.setSize(bar, 150, 10)
    bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    bar:SetStatusBarColor(1, .7, 0)

    local icon = bar:CreateTexture(nil, "ARTWORK")
    bar.Icon = icon
    utils.setSize(icon, 16)
    icon:SetTexture[[Interface\Icons\Spell_Shaman_Hex]]
    icon:SetPoint("RIGHT", bar, "LEFT", -1, 0)

    local border = bar:CreateTexture(nil, "ARTWORK")
    bar.Border = border
    utils.setSize(border, 200, 54)
    border:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
    border:SetPoint("CENTER", bar)

    local shield = bar:CreateTexture(nil, "OVERLAY")
    bar.Shield = shield
    utils.setSize(shield, 200, 54)
    shield:SetPoint("CENTER", bar, -3, 0)
    shield:SetTexture[[Interface\CastingBar\UI-CastingBar-Small-Shield]]

    local spark = bar:CreateTexture(nil, "OVERLAY")
    bar.Spark = spark
    utils.setSize(spark, 26)
    spark:SetBlendMode"ADD"

    local text = bar:CreateFontString(nil, "OVERLAY")
    bar.Text = text
		text:SetFontObject(TextStatusBarText)
		--text:SetFontObject(GameFontNormal)
    do
        local f, s, flag = text:GetFont()
        text:SetFont("Fonts\\ZYKai_T.ttf",16,'THINOUTLINE')
    end
    text:SetPoint("TOP", bar, "TOP", 0, 0)

    local time = bar:CreateFontString(nil, "OVERLAY")
    bar.Time = time
    time:SetFontObject(SystemFont_Shadow_Small)
    do
        local f, s, flag = time:GetFont()
        time:SetFont(f, s-2, flag)
    end
    time:SetPoint("RIGHT", bar, "RIGHT", -5, 0)

    do
        -- 3.2.2 don"t have this
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
ns:addLayoutElement(units,function(self,unit)
	style.CopyName(units)
	style.CopyArmory(units)
end)

local frame
ns:addLayoutElement(units, function(self, unit)
    frame = self
end)

local function toggleCastbar(self)
    local obj = self or frame
    if(unitdb.castbar) then
        if(not self) then
            obj:EnableElement("Castbar")
        end
    else
        obj:DisableElement"Castbar"
        obj.Castbar:Hide()
    end
end

oUF:RegisterInitCallback(function(self)
    if( self == frame ) then
        toggleCastbar(self)
    end
end)

ns:spawn(function()
	local f = oUF:Spawn("target","wsUnitFrame_Target")
	ns.frameList[f] = true
	ns.unitFrames.target = f
	frame = f
	return f
end)

--ns:spawn(function()
--    local f = oUF:Spawn("target", "wsUnitFrame_Target")
--    f:SetPoint("TOPLEFT", UIParent, 370, -25)
--    ns.unitFrames.target = f
--end)

ns:RegisterUnitOptions("target", {
    type = "group",
    name = L["target"],
    order = ns.order(),
    args = {
      --  auraontop = {
      --      type = "toggle",
      --      name = L["Aura on top"],
      --      desc = L["Display aura on the top of the frame"],
      --      order = ns.order(),
      --      width = "full",
      --      get = function() return unitdb.auraontop end,
      --      set = function(_, v)
      --          unitdb.auraontop = v
      --          updateAuraPosition(ns.unitFrames.target, true)
      --      end,
      --  },
        castbar = {
            type = "toggle",
            name = L["Castbar"],
            desc = L["Enable castbar"],
            order = ns.order(),
            width = "full",
            get = function() return unitdb.castbar end,
            set = function(_, v)
                unitdb.castbar = v
                toggleCastbar()
            end
        },
        --auracooldown = {
        --    type = "toggle",
        --    name = L["Aura cooldown"],
        --    desc = L["Show aura cooldown"],
        --    order = ns.order(),
        --    get = function() return unitdb.auracooldown end,
        --    set = function(_, v)
        --        unitdb.auracooldown = v
        --        utils.updateAuraElement(frame)
        --        --frame:UpdateElement"Aura"
        --    end,
        --},
        castbyme = {
            type = "toggle",
            name = L["Cast by me only"],
            desc = L["Only show cooldown on those that cast by me"],
            order = ns.order(),
            --disabled = function() return not unitdb.auracooldown end,
            get = function() return unitdb.castbyme end,
            set = function(_,v )
                unitdb.castbyme = v
               		if unitdb.castbyme then
										if UnitCanAttack("player","target") then
											ns.unitFrames.target.Buffs.onlyShowPlayer = false
											ns.unitFrames.target.Debuffs.onlyShowPlayer = unitdb.castbyme
										else
											ns.unitFrames.target.Buffs.onlyShowPlayer = unitdb.castbyme
											ns.unitFrames.target.Debuffs.onlyShowPlayer = false
										end
									else
										ns.unitFrames.target.Buffs.onlyShowPlayer = false
										ns.unitFrames.target.Debuffs.onlyShowPlayer = false
									end
									ns.unitFrames.target.Buffs:ForceUpdate()
								ns.unitFrames.target.Debuffs:ForceUpdate()
            end,
        },
        --[[highlightmydebuff = {
            type = "toggle",
            name = L["Highlight debuffs cast by me"],
            desc = L["Highlight debuffs cast by me"],
            order = ns.order(),
            get = function() return unitdb.highlightmydebuff end,
            set = function(_,v)
                unitdb.highlightmydebuff = v
                if(frame:IsVisible()) then
                    utils.updateAuraElement(frame)
                    --frame:UpdateElement"Aura"
                end
            end,
        },]]
        taggroup = {
            type = "group",
            name = L["Tag texts"],
            order = ns.order(),
            inline = true,
            args = {
                taghp = {
                    type = "select",
                    name = L["Text on health bar"],
                    desc = L["The text show on health bar"],
                    order = ns.order(),
                     values = {[""] = L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.hp.tag end,
                    set = function(_, v)
                        unitdb.tags.hp.tag = v
                        ns:Reload("target")
												--utils.updateTag(frame, "hp", v)
                    end,
                },
                tagmp = {
                    type = "select",
                    name = L["Text on power bar"],
                    desc = L["The text show on power bar"],
                    order = ns.order(),
                    values = {[""] = L["NONE"],["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
                    get = function() return unitdb.tags.mp.tag end,
                    set = function(_, v)
                        unitdb.tags.mp.tag = v
												ns:Reload("target")
                    end,
                },
                perhp = {
                    type = "select",
                    name = L["Text on health bar left"],
                    desc = L["The text show on health bar left"],
                    order = ns.order(),
                   values = {[""] = L["NONE"],["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
                    get = function() return unitdb.tags.perhp.tag end,
                    set = function(_, v)
                        unitdb.tags.perhp.tag = v
												ns:Reload("target")
                    end,
                },
                permp  ={
                    type = "select",
                    name = L["Text on power bar left"],
                    desc = L["The text show on power bar left"],
                    order = ns.order(),
                    values = {[""] = L["NONE"],["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
                    get = function() return unitdb.tags.perpp.tag  end,
                    set = function(_, v)
                        unitdb.tags.perpp.tag = v
												ns:Reload("target")
                    end,
                },
            },
        }
    },
})
