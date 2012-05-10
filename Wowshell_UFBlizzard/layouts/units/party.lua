-- by yaroot <yaroot AT gmail.com>

local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local style = ns.style

local position = ns:RegisterUnitPosition("party",{
	selfPoint = "TOPLEFT", 
	anchorTo = "UIParent", 
	relativePoint = "TOPLEFT", 
	x = "20", 
	y = "-150"
})

local unitdb = ns:RegisterUnitDB("party",{
			enabled = true, 
			showPartyPet = true, 
			showInRaid = true, 
			combatfeedback = true,
			showPartyPet = true,
			castbar = false, 
			sidebar = true, 
			Auras = false, 
			auracooldown = true, 
			castbyme = true, 
			parent = {
				width = 128,
				height = 53,
				scale = 1,
				attribPoint = "TOP",
				attribAnchorPoint = "LEFT",
				unitsPerColumn = 5,
				columnSpacing = 40,
				offset = 10,
				spacing = 2,

			},
			tags = {
				lvl = { tag = "[levelcolor]" },
				name = { tag = "[colorname]" },
				hp = { tag = "[hp:color][smart:curmaxhp][close]"},
				mp = { tag = "[smart:curmaxpp]"},
				pcthp = { tag = "[hp:color][perhp][close]"},
				pctmp = { tag = ""},
			},
			
})

local units = "party"

ns:setSize(units, unitdb.parent.width, unitdb.parent.height,unitdb.parent.scale)

ns:addLayoutElement(units, function(self, unit)
    self.is_party_frame = true
end)

ns:addLayoutElement(units, function(self, unit)
	self.nextUpdate = 0
	self:SetScript("OnUpdate", function(self, elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if(self.nextUpdate >=0.5) then
			if(self.is_party_frame) then
				for i=1, GetNumPartyMembers() do
					local isInRange = UnitInRange("party"..i)
					local isConnected = UnitIsConnected("party"..i)
					local partyFrame = WSUFHeader_Party[i]
					if(isInRange and isConnected) then
						partyFrame:SetAlpha(1.0)
					else
						partyFrame:SetAlpha(0.5)
					end
				end
			end
			self.nextUpdate = 0
		end
	end)
end)

ns:addLayoutElement(units, function(self, unit)
    local tex = self:CreateTexture(nil, "BORDER")
    utils.setSize(tex, 128, 64)
    tex:SetPoint("TOPLEFT", 0, -2)
    tex:SetTexture[[Interface\TargetingFrame\UI-PartyFrame]]

    self.frametexture = tex
    --utils.testBackdrop(self)
end)

local function post2D(self, unit)
    if(UnitIsConnected(unit)) then
        self.discon:Hide()
        self:Show()
    else
        self:Hide()
        self.discon:Show()
    end
end

ns:addLayoutElement(units, function(self, unit)
    local p = self.bg:CreateTexture(nil, "ARTWORK")
    utils.setSize(p, 37)
    p:SetPoint("TOPLEFT", self, "TOPLEFT", 7, -6)

    local discon = self.bg:CreateTexture(nil, "ARTWORK")
    p.discon = discon
    discon:SetTexture[[Interface\CharacterFrame\Disconnect-Icon]]
    discon:SetAllPoints(p)

	p.PostUpdate = post2D
	self.portrait_2d = p
	self.Portrait = p
end)

ns:addLayoutElement(units, function(self, unit)
    local p = CreateFrame("PlayerModel", nil, self.bg)
    utils.setSize(p, 28)
    p:SetPoint("CENTER", self.portrait_2d, -2, 0)
    self.portrait_3d = p
end)

ns:addLayoutElement(units, function(self, unit)
    local hp, mp
    hp = CreateFrame("StatusBar", nil, self.bg)
    mp = CreateFrame("StatusBar", nil, self.bg)
    self.Health, self.Power = hp, mp

    utils.setSize(hp, 70, 8)
    utils.setSize(mp, 70, 8)

    hp:SetPoint("TOPLEFT", 47, -12)
    mp:SetPoint("TOPLEFT", 47, -21)

    hp.colorHealth = true
    hp.frequentUpdates = true
    mp.colorPower = true
    mp.frequentUpdates = true

end)

ns:addLayoutElement(units, function(self, unit)
    local side = self:CreateTexture(nil, "BORDER")
    self.frametexture_sidebar = side
		
		if(unitdb.sidebar) then
    	side:SetWidth(80)
    	side:SetHeight(64)
		else
			side:SetWidth(0)
			side:SetHeight(0)
		end
		--side:SetPoint("CENTER", UIParent, 0, 0)
    side:SetPoint("LEFT", self, "RIGHT", -10, -7)
    --side:SetTexture[[Interface\AddOns\Wowshell_UnitFrame\WS-PartyFrame]]
end)

ns:addLayoutElement(units, function(self, unit)
    local pvp = self:CreateTexture(nil, "OVERLAY")
    self.PvP = pvp
    utils.setSize(pvp, 32)
    pvp:SetPoint("TOPLEFT", -9, -15)

    local leader = self:CreateTexture(nil, "OVERLAY")
    self.Leader = leader
    utils.setSize(leader, 16)
    leader:SetPoint("TOPLEFT", 0, 0)

    local looter = self:CreateTexture(nil, "OVERLAY")
    self.MasterLooter = looter
    utils.setSize(looter, 16)
    looter:SetPoint("TOPLEFT", 32, 0)

    local vehicle = self:CreateTexture(nil, "BORDER")
    self.VehicleTexture = vehicle
    self.VehicleTextureNormal = self.frametexture
    --self.VehicleTextureNormal:Hide()
    utils.setSize(vehicle, 128, 64)
    vehicle:SetPoint("TOPLEFT", -4, 6)
    vehicle:SetTexture[[Interface\Vehicles\UI-Vehicles-PartyFrame]]

    vehicle.__self = self
    vehicle.PostUpdate = function(vehicle, event, toggle)
        local u = vehicle.__self.realUnit
        if(toggle and u) then
            if(UnitVehicleSkin(u) == "Natural") then
                vehicle:SetTexture[[Interface\Vehicles\UI-Vehicles-PartyFrame-Organic]]
            else
                vehicle:SetTexture[[Interface\Vehicles\UI-Vehicles-PartyFrame]]
            end
        end
    end
end)

ns:addLayoutElement(units, function(self, unit)
    local ricon = self:CreateTexture(nil, "OVERLAY")
    self.RaidIcon = ricon
    utils.setSize(ricon, 14)
    ricon:SetPoint("CENTER", self, "TOPLEFT", 25, -8)
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

ns:addLayoutElement(units, function(self, unit)
    local threat = self.bg:CreateTexture(nil, "BACKGROUND")
    self.Threat = threat

    threat:SetTexture[[Interface\TargetingFrame\UI-PartyFrame-Flash]]
    utils.setSize(threat, 128, 64)
    threat:SetPoint("TOPLEFT", -3, 2)
end)

ns:addLayoutElement(units, function(self, unit)
    local button = CreateFrame("Button", nil, self)
    button:SetScale(.6)

    local icon = button:CreateTexture(nil, "BACKGROUND")
    icon.button = button
    self.ClassIcon = icon
    utils.setSize(icon, 16)
    icon:SetPoint("CENTER", self, -77, -28)

    local border = button:CreateTexture(nil, "BORDER")
    icon.border = border
    utils.setSize(border, 45, 45)
    border:SetPoint("TOPLEFT", icon, "TOPLEFT", -5, 6)
    border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])
end)

ns:addLayoutElement(units, function(self, unit)
    local icon = self:CreateTexture(nil, "OVERLAY")
    self.LFDRole = icon
    utils.setSize(icon, 16)
    icon:SetPoint("TOPLEFT", self, 32, -10)
end)

ns:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local lvl = self:CreateFontString(nil, "OVERLAY")
    t.lvl = lvl
    lvl:SetFontObject(NumberFontNormal)
    lvl:SetPoint("CENTER", -28, -16)
    lvl:SetTextColor(1, .82, 0)
		Tags:Register(self, lvl ,unitdb.tags.lvl.tag)
		lvl:UpdateTags()

    local name = self:CreateFontString(nil, "OVERLAY")
    t.name = name
    name:SetFontObject(ChatFontNormal)
    name:SetPoint("CENTER", 17, 22)
		Tags:Register(self, name, unitdb.tags.name.tag)
		name:UpdateTags()

    local hp = self:CreateFontString(nil, "OVERLAY")
    t.hp = hp
    hp:SetFontObject("TextStatusBarText")
    do
        local font, size, flag = hp:GetFont()
        hp:SetFont(font, size-3, flag)
    end
    hp:SetPoint("CENTER" , 93, 12)
		Tags:Register(self, hp, unitdb.tags.hp.tag)
		hp:UpdateTags()

    local mp = self:CreateFontString(nil, "OVERLAY")
    t.mp = mp
    mp:SetFontObject("TextStatusBarText")
    do
        local font, size, flag = mp:GetFont()
        mp:SetFont(font, size-3, flag)
    end
    mp:SetPoint("CENTER", 93, 2)
		Tags:Register(self, mp, unitdb.tags.mp.tag)
		mp:UpdateTags()

    local pcthp = self:CreateFontString(nil, "OVERLAY")
    t.pcthp = pcthp
    pcthp:SetFontObject("TextStatusBarText")
    do
        local font, size, flag = pcthp:GetFont()
        pcthp:SetFont(font, size-3, flag)
    end
    pcthp:SetPoint("CENTER", self.Health)
		Tags:Register(self, pcthp , unitdb.tags.pcthp.tag)
		pcthp:UpdateTags()

    local pctmp = self:CreateFontString(nil, "OVERLAY")
    t.pctmp = pctmp
    pctmp:SetFontObject("TextStatusBarText")
    do
        local font, size, flag = pctmp:GetFont()
        pctmp:SetFont(font, size-3, flag)
    end
    pctmp:SetPoint("CENTER", self.Power)
		Tags:Register(self, pctmp , unitdb.tags.pctmp.tag)
		pctmp:UpdateTags()
end)

ns:addLayoutElement(units, function(self, unit)
    local parent = self:GetParent()
    parent.frames = parent.frames or {}
    tinsert(parent.frames, self)
end)

local function post(icons, button)
    local font, size, flag = button.count:GetFont()
    button.count:SetFont(STANDARD_TEXT_FONT, 8, flag)
    button.oufaura = true

    button.cd:SetDrawEdge(true)
    button.cd:SetReverse(true)
end

local function postUpdateIcon(icons, unit, icon, index, offset)
    utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
end

ns:addLayoutElement(units, function(self, unit)
  local Auras = CreateFrame("Frame", nil, self)
	Auras.showDebuffType = true
	Auras.postCreateIcon = post
	Auras.size = 19
	Auras.num = 18
	Auras.spacing = 2
	Auras.numBuffs = 9
	Auras.gap = true
	Auras.initialAnchor = "TOPLEFT"
	Auras["growth-x"] = "RIGHT"
	Auras["growth-y"] = "DOWN"
	Auras:SetWidth(180)
	Auras:SetHeight(40)
	Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 5)
	Auras.PostUpdateIcon = postUpdateIcon
	Auras.__own = self
	self.Auras = Auras
	if not unitdb.Auras then
		self.Auras:Hide()
	end
end)

ns:addLayoutElement(units, function(self, unit)
    local bar = CreateFrame("StatusBar", nil, self)
    bar:SetScale(0.8)
    self.Castbar = bar
		if unitdb.showPartyPet then 
			bar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 150, 25)
		else	
			bar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 80, 25)
		end
    bar.__own = self

    utils.setSize(bar, 150, 10)
    bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
    bar:SetStatusBarColor(1, .7, 0)

    local icon = bar:CreateTexture(nil, "ARTWORK")
    bar.Icon = icon
    utils.setSize(icon, 16)
    icon:SetTexture[[Interface\Icons\Spell_Shaman_Hex]]
    icon:SetPoint("RIGHT", bar, "LEFT", -4, 0)

    local border = bar:CreateTexture(nil, "ARTWORK")
    bar.Border = border
    utils.setSize(border, 200, 52)
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
	--text:SetFontObject(SystemFont_Shadow_Small)
    text:SetFontObject(ChatFontNormal)
		do
        local f, s, flag = text:GetFont()
        text:SetFont(f, s-2, 'OUTLINE')
    end
    text:SetPoint("TOP", bar, "TOP", 0, 0)

    local time = bar:CreateFontString(nil, "OVERLAY")
    bar.Time = time
    time:SetFontObject(SystemFont_Shadow_Small)
    do
        local f, s, flag = time:GetFont()
        time:SetFont(f, s-2, flag)
    end
    time:SetPoint("RIGHT", bar, "RIGHT", -1, 0)

    do
        -- 3.2.2 don"t have this
        local tex = bar:GetStatusBarTexture()
        if(tex.SetHorizTile) then
            tex:SetHorizTile(true)
        end
    end

end)

do
    local function PARTY_MEMBERS_CHANGED(self, event)
        self:UpdateAllElements(event)
    end
    ns:addLayoutElement(units, function(self)
        self:RegisterEvent("PARTY_MEMBERS_CHANGED", PARTY_MEMBERS_CHANGED)
    end)
end

ns.units.partyframes = {}
ns:addLayoutElement(units, function(self)
    tinsert(ns.units.partyframes, self)
end)

local function iteratePartyFrame()
    return ipairs(ns.units.partyframes)
end

local function toggleSidebar(self)
    if(unitdb.sidebar) then
        self.frametexture_sidebar:Show()
    else
        self.frametexture_sidebar:Hide()
    end
end

local function updateCombatFeedback(self)
    if(unitdb.combatfeedback) then
        self:EnableElement("CombatFeedbackText")
    else
        self:DisableElement("CombatFeedbackText")
    end
end

oUF:RegisterInitCallback(function(self)
    if(self.is_party_frame) then
        toggleSidebar(self)

        if(not unitdb.combatfeedback) then
            updateCombatFeedback(self)
        end
    end
end)

oUF:RegisterInitCallback(function(self)
    if(self.is_party_frame) then
        if(PartyCast) then
            ns.exec(function()
                PartyCast:CreateCastSpellFrame()
            end)
        end
    end
end)

function UpdateConditions(self)
    local obj = self or ns.unitFrames.party
    if(not self) then
        UnregisterStateDriver(obj, "visibility")
			end

    local condition
    if(not unitdb.enabled) then
        condition = "hide"
    else
        if(unitdb.showinraid) then
            condition = "show"
        else
            condition = "[nogroup:raid]show;hide"
        end
    end
    RegisterStateDriver(obj, "visibility", condition)
end

local frame

ns:spawn(function()
	local _template
	if unitdb.enabled then
		_template = "WowshellUnitFramePartyTemplate, oUF_ClickCastUnitTemplate"
	else
		_template = "WowshellUnitFramePartyTemplate_NoTarget, oUF_ClickCastUnitTemplate"
	end
	local _partyPetWidth,_partyPetHeight
	if unitdb.showPartyPet then
		_showPartyPet = unitdb.showPartyPet
		_partyPetWidth = 70
		_partyPetHeight = 8
	else
		_showPartyPet = nil
		_partyPetWidth = 0
		_partyPetHeight = 0
	end
	local _yOffset 
	if unitdb.Auras then
		_yOffset = -35
	else
		_yOffset = -15
	end

--	local header = oUF:SpawnHeader(parent .. "_PartyFrame", nil, nil, 
	local party = oUF:SpawnHeader("WSUFHeader_Party",nil,nil,
		"showParty", true, 
		--"showPlayer", true, 
		"point", "TOP", 
		"yOffset", 0,--_yOffset, 
		"template", "WowshellUnitFramePartyTemplate", --_template, 
		"oUF-initialConfigFunction1", ([[
		local header = self:GetParent()
		if header:GetParent():GetName() ~= "UIParent" then
			header = header:GetParent()
		end
		header:CallMethod("initialConfigFunction1",self:GetName())
		]])
	)
	ns:SetHeaderAttributes(party, "party")
	party.isHeaderFrame = true
	party.unitType = "party"
	party.initialConfigFunction1 = function(header,frameName)
		local frame = _G[frameName]
		frame.ignoreAnchor = true
		local suffix = frame:GetAttribute("unitsuffix")
		if(suffix) then
			frame.unitType = "party"..suffix
			local pname = string.gsub(gsub(frame:GetName(), "Pet$",""),"Target", "")
			frame.parent = _G[pname]
			frame.isChildUnit = frame
			if(suffix == "pet") then
				--frame:SetWidth(60)
				--frame:SetHeight(17)
				--frame:SetScale(0.6)
			end
		else
			frame.unitType = header.unitType
		end
		ns.frameList[frame] = true
	end
	ns.unitFrames.party = party
	ns.headerFrames.party = party
	UpdateConditions(party)
	WSUF.Layout:AnchorFrame(UIParent,party,position)
	local flag = 0
	ns.unitFrames.party:SetMovable(true)
	ns.unitFrames.party:GetChildren():SetScript("OnDoubleClick",function(self,button)
		if UnitAffectingCombat("player") then
			print("|cffe1a500精灵头像|r:|cffff2020战斗中无法设置位置!|r")	
		else
			if button == "RightButton" and flag%2 == 0 then
				ns.unitFrames.party:StartMoving()
				flag = flag +1
				print("|cffe1a500精灵头像|r:|cff69ccf0解锁位置|r")
			elseif button == "RightButton" and flag%2 ~=0 then
				ns.unitFrames.party:StopMovingOrSizing()
				local selfPoint,anchorTo,relativePoint,x,y = ns.unitFrames.party:GetPoint()
				position.selfPoint = selfPoint
				position.anchorTo = "UIParent"
				position.relativePoint = relativePoint
				position.x = x*UIParent:GetEffectiveScale()
				position.y = y*UIParent:GetEffectiveScale()
				flag = 0
				print("|cffe1a500精灵头像|r:|cff69ccf0锁定位置|r")
		end
	end		
end)
end)


-- CVar
local Event = CreateFrame("Frame")
Event:RegisterEvent("CVAR_UPDATE")
Event:SetScript("OnEvent", function(self, event, key, value, ...)
	if event == "CVAR_UPDATE" then 
		if GetCVarBool("useCompactPartyFrames") then
			unitdb.enabled = false
			UpdateConditions()
		else
			unitdb.enabled = true
			UpdateConditions()
		end
	end
end)

local toggleCastbar = function()
    for i, o in iteratePartyFrame() do
        if(unitdb.castbar) then
            o:EnableElement"Castbar"
        else
            o:DisableElement"Castbar"
        end
    end
end

local toggleAuras = function()
	for i, o in iteratePartyFrame() do
		if(unitdb.Auras) then 
			o:EnableElement"Auras"
		else
			o:DisableElement"Auras"
		end
	end
end

oUF:RegisterInitCallback(function(self)
    if(self.is_party_frame) then
        if(not unitdb.castbar) then
            self:DisableElement"Castbar"
        end
				if(not unitdb.Auras) then
					self:DisableElement"Auras"
				end
    end
end)

ns:RegisterUnitOptions("party", {
    type = "group", 
    name = L["party"], 
    order = ns.order(), 
    args = {
        enabled = {
            type = "toggle", 
            name = L["Enabled"], 
            desc = L["Enable party frame"], 
            order = ns.order(), 
            get = function() return unitdb.enabled end, 
            set = function(_, v)
                unitdb.enabled = v
                UpdateConditions()
            end, 
        }, 
				showPartyPet = {
					type = "toggle", 
					name = L["Enable party pet frame"], 
					desc = L["Enable party pet frame, need reload UI"], 
					order = ns.order(), 
					get = function() return unitdb.showPartyPet end, 
					set = function(_, v)
						unitdb.showPartyPet = v
					end, 
				}, 
        showinraid = {
            type = "toggle", 
            name = L["Show party in raid"], 
            desc = L["Show party frame in raid"], 
            order = ns.order(), 
            get = function() return unitdb.showinraid end, 
            set = function(_, v)
                unitdb.showinraid = v
                UpdateConditions()
            end, 
        }, 
				yOffset = {
					type = "range",
					name = L["Party members's yOffset"],
					desc = L["yOffset,need to reloadui"],
					min = 0 , max = 100, step = 1,
					get = function() return unitdb.parent.offset end,
					set = function(_,v) 
						unitdb.parent.offset = v
						ns:LoadZoneHeader("party")
					end,
				},
        combatfeedback = {
            type = "toggle", 
            name = L["Combat feedback text"], 
            desc = L["Enable combat feedback test"], 
            order = ns.order(), 
            width = "full", 
            get = function() return unitdb.combatfeedback end, 
            set = function(_, v)
                unitdb.combatfeedback = v
                for k, v in iteratePartyFrame() do
                    updateCombatFeedback(v)
                end
            end, 
        }, 
        castbar = {
            type = "toggle", 
            name = L["Castbar"], 
            desc = L["Enable castbar"], 
            order = ns.order(), 
            get = function() return unitdb.castbar end, 
            set = function(_, v)
                unitdb.castbar = v
                toggleCastbar()
            end, 
        }, 
        sidebar = {
            type = "toggle", 
            name = L["Side info bar"], 
            desc = L["Toggle side info bar"], 
            order = ns.order(), 
            get = function() return unitdb.sidebar end, 
            set = function(_, v)
                unitdb.sidebar = v
                for k, v in iteratePartyFrame() do
                    toggleSidebar(v)
                end
            end, 
        }, 
        Auras = {
            type = "toggle", 
            name = L["Enable auras"],
						desc = L['Enable auras desc'],
            order = ns.order(), 
            width = "full", 
            get = function() return unitdb.Auras end, 
            set = function(_, v)
                unitdb.Auras= v
								toggleAuras()
               -- for _, obj in iteratePartyFrame() do
               --     if(v) then
							 -- 			StaticPopup_Show 'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD' 
							 -- 			--obj.Auras:Show()
               --     else
							 -- 			StaticPopup_Show 'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
							 -- 			--obj.Auras:Hide()
               --     end
               -- end
            end
        },
        auracooldown = {
            type = "toggle", 
            name = L["Aura cooldown"], 
            desc = L["Show aura cooldown"], 
            order = ns.order(), 
            width = "full", 
            get = function() return unitdb.auracooldown end, 
            set = function(_, v)
                unitdb.auracooldown = v
                for _, frame in iteratePartyFrame() do
                    if(frame:IsVisible()) then
                        utils.updateAuraElement(frame)
                        --frame:UpdateElement"Aura"
                    end
                end
            end, 
        }, 
        castbyme = {
            type = "toggle", 
            name = L["Cast by me only"], 
            desc = L["Only show cooldown on those that cast by me"], 
            order = ns.order(), 
            disabled = function() return not unitdb.auracooldown end, 
            get = function() return unitdb.castbyme end, 
            set = function(_, v )
                unitdb.castbyme = v
                for _, frame in iteratePartyFrame() do
                    if(frame:IsVisible()) then
                        utils.UpdateAuraElement(frame)
                        --frame:UpdateElement"Aura"
                    end
                end
            end, 
        }, 
       -- taggroup = {
       --     type = "group", 
       --     name = L["Tag texts"], 
       --     order = ns.order(), 
       --     inline = true, 
       --     args = {
       --        -- taghp = {
       --        --     type = "select", 
       --        --     name = L["Text on health bar"], 
       --        --     desc = L["The text show on health bar"], 
       --        --     order = ns.order(), 
       --        --     values = utils.tag_select_values, 
       --        --     get = function() return unitdb.tagonhealthbar or "NONE" end, 
       --        --     set = function(_, v)
       --        --         unitdb.tagonhealthbar = v
       --        --         for _, f in iteratePartyFrame() do
       --        --             utils.updateTag(f, "pcthp", v)
       --        --         end
       --        --     end, 
       --        -- }, 
       --        -- tagmp = {
       --        --     type = "select", 
       --        --     name = L["Text on power bar"], 
       --        --     desc = L["The text show on power bar"], 
       --        --     order = ns.order(), 
       --        --     values = utils.tag_select_values, 
       --        --     get = function() return unitdb.tagonpowerbar or "NONE" end, 
       --        --     set = function(_, v)
       --        --         unitdb.tagonpowerbar = v
       --        --         for _, f in iteratePartyFrame() do
       --        --             utils.updateTag(f, "pctmp", v, 1)
       --        --         end
       --        --     end, 
       --        -- }, 
       --        -- taghpr = {
       --        --     type = "select", 
       --        --     name = L["Text beside health bar"], 
       --        --     desc = L["The text besides the health bar"], 
       --        --     order = ns.order(), 
       --        --     values = utils.tag_select_values, 
       --        --     get = function() return unitdb.tagonhealthbarright or "NONE" end, 
       --        --     set = function(_, v)
       --        --         unitdb.tagonhealthbarright = v
       --        --         for _, f in iteratePartyFrame() do
       --        --             utils.updateTag(f, "hp", v)
       --        --         end
       --        --     end, 
       --        -- }, 
       --        -- tagmpr = {
       --        --     type = "select", 
       --        --     name = L["Text besides power bar"], 
       --        --     desc = L["The text besides the power bar"], 
       --        --     order = ns.order(), 
       --        --     values = utils.tag_select_values, 
       --        --     get = function() return unitdb.tagonpowerbarright or "NONE" end, 
       --        --     set = function(_, v)
       --        --         unitdb.tagonpowerbarright = v
       --        --         for _, f in iteratePartyFrame() do
       --        --             utils.updateTag(f, "mp", v, 1)
			 -- 			 -- 					end
       --        --     end, 
       --        -- }, 
       --      },
			 -- 		 

       -- }, 
				 partycast = IsAddOnLoaded"Wowshell_PartyCast" and {
                    type = "toggle", 
                    name = L["Party cast"], 
                    desc = L["Toggle party cast"], 
                    order = ns.order(), 
                    get = function() return PartyCast and PartyCast.db.profile.enable end, 
                    set = function(_, v)
                        if(PartyCast) then
                            PartyCast.db.profile.enable = v
                            PartyCast:ToggleShowCastFrame()
                        end
                    end, 
                }, 
    }, 
})
