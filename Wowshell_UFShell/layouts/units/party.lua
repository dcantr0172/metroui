local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local position = ns:RegisterUnitPosition("party", {
	selfPoint = "TOPLEFT", 
	anchorTo = "UIParent", 
	relativePoint = "TOPLEFT", 
	x = "20", 
	y = "-150"
})

local unitdb = ns:RegisterUnitDB("party", {
	tex = {
		barTex = "Interface\\AddOns\\Wowshell_UFShell\\texture\\statusbarTexture", 
		borderTex =  {
			bgFile = "Interface\\Buttons\\WHITE8x8", 
			edgeFile = "Interface\\Buttons\\WHITE8x8", 
			edgeSize = 1, 
			insert = {
				left= -1, 
				right = -1, 
				top = -1, 
				bottom = -1
			}, 
		},
			auraTex = "Interface\\AddOns\\Wowshell_UFShell\\texture\\dBBorderK",
	}, 
	colors = {
		bgColor = {0,0,0,0.8},
		brdBgColor = {0.1,0.1,0.12,1},
		brdColor = {0.28,0.28,0.28,1},
	},
	group = {
		showParty = true,
		showPlayer = false,
		yOffset = 50,
	},
	parent = {
		width = 128+38, 
		height = 35, 
		scale = 1, 
		attribPoint = "TOP",
		attribAnchorPoint = "LEFT",
		unitsPerColumn = 5,
		columnSpacing = 40,
		offset = 50,
		spacing = 2
	}, 	
	outRangeFade = {
		enable = true, 
	}, 
	showInRaid = {enable = true},
	portrait = {
		enable = true, 
		width = 35, 
		height = 35,
		position = "LEFT",
	}, 
	healthBar = {
		width = 128, 
		height = 24, 
		color = "colorClass", 
	}, 
	powerBar = {
		width = 128, 
		height = 8, 
	},
	indicators = {
		pvp = {
			enable = true,
			size = 29,
		}, 
		leader = {
			enable = true,
			size = 16,
		}, 
		looter = {
			enable = true,
			size = 14,
		}, 
		assistant = {
			enable = true,
			size = 16,
		}, 
		raidIcon = {
			enable = true,
			size = 12,
		}, 
		threatBorder = {
			enable = true
		}, 
		classIcon = {
			enable = true,
			size = 12,
		}, 
		LFD = {
			enable = true,
			size = 14,
		},
	}, 
	auras = {
		enable = true,
		numBuffs = 8,
		numDebuffs = 8,
		spacing = 2,
		count = 9,
	},
	castbar = {enable = true}, 
	tags = {
		lvl = {
			enable = true,
			tag = "[level]",
		},
		name = {
			enable = true,
			tag = "[colorname]",
		},
		hp = {
			enable = true,
			tag = "[curhp]",
		}, 
		mp = {
			enable = true,
			tag = "[curpp]",
		}, 
	}, 
})

local units = "party"
ns:setSize(units, unitdb.parent.width, unitdb.parent.height, unitdb.parent.scale)

--[elements:commonfunc]
--arg[1] self or ns.unitFrames.unit
--arg[2] the key of unitdb with enable options
--arg[3] self.element(oUF) or self.element(custom) 
--arg[4] if not null it will call func()
local function toggleElement(obj, key, element, func)
	if not obj then obj = ns.unitFrames.Party end
	if obj.element then
		if unitdb[key].enable then 
			obj.element:Show()
		else
			obj.element:Hide()
		end
	else 
		return 
	end
	if not func then 
		return
	else
		func()
	end
end

local function toggleBlzRaidFrame(v)
	local CRFM = CompactRaidFrameManager
	local CRFC = CompactRaidFrameContainer
	if not v or v == nil then
		CRFM:UnregisterAllEvents()
		CRFM:Hide()
		CRFC:UnregisterAllEvents()
		CRFC:Hide()
	else
		CRFM:Show()
		CRFC:Show()
	end
end

--[[===Style===]]--

-- Out Range Fade
ns:addLayoutElement(units, function(self, unit)
    if not unitdb.outRangeFade.enable then return end
	self.nextUpdate = 0
	self:SetScript("OnUpdate", function(self, elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate >= 0.5 then
			for i = 1, GetNumPartyMembers() do
				local isInRange = UnitInRange("party"..i)
				local isConnected = UnitIsConnected("party"..i)
				local PartyFrame = WSUFHeader_Party[i]
				if isInRange and isConnected then
					PartyFrame:SetAlpha(1)
				else
					PartyFrame:SetAlpha(0.5)
				end
			end
			self.nextUpdate = 0
		end
	end)
end)

-- Portrait
ns:addLayoutElement(units, function(self, unit)
    if not unitdb.portrait.enable then return end
    local Portrait = CreateFrame("PlayerModel", nil, self.bg)
    Portrait:SetSize(unitdb.portrait.width, unitdb.portrait.height)
		if unitdb.portrait.position == "LEFT" then
			Portrait:SetPoint("TOPLEFT", self.bg, "TOPLEFT", 0, 0)
		elseif unitdb.portrait.position == "RIGHT" then
			Portrait:SetPoint("TOPRIGHT", self.bg, "TOPRIGHT", 0, 0)
		end
		
	Portrait.BG = Portrait:CreateTexture(nil, "BACKGROUND")
	Portrait.BG:SetAllPoints(Portrait)
	Portrait.BG:SetTexture(unitdb.tex.barTex)
	Portrait.BG:SetVertexColor(unpack(unitdb.colors.bgColor))

	Portrait.Border = CreateFrame("Frame", nil, Portrait)
	Portrait.Border:SetPoint("TOPLEFT", -1 , 1)
	Portrait.Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Portrait.Border:SetBackdrop(unitdb.tex.borderTex)
	Portrait.Border:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
	Portrait.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	Portrait.Border:SetFrameLevel(1)
	
	self.Portrait = Portrait
end)

-- Health/Power
ns:addLayoutElement(units, function(self, unit)
	local Health = CreateFrame("StatusBar", nil, self.bg)
	Health:SetSize(unitdb.portrait.enable and unitdb.healthBar.width or unitdb.parent.width, unitdb.healthBar.height)
	Health:SetStatusBarTexture(unitdb.tex.barTex)
	if unitdb.portrait.enable and unitdb.portrait.position == "LEFT" then
		Health:SetPoint("TOPLEFT", self.Portrait, "TOPRIGHT", unitdb.parent.spacing *2,0)
	elseif unitdb.portrait.enable and unitdb.portrait.position == "RIGHT" then
		Health:SetPoint("TOPRIGHT", self.Portrait, "TOPLEFT", 0-unitdb.parent.spacing *2,0)
	elseif not unitdb.portrait.enable then
		Health:SetPoint("TOPLEFT", self.bg, 0, 0)
	end
	
	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetAllPoints(Health)
	Health.BG:SetTexture(unitdb.tex.barTex)
	Health.BG:SetVertexColor(unpack(unitdb.colors.bgColor))

	Health.Border = CreateFrame("Frame", nil, Health)
	Health.Border:SetPoint("TOPLEFT", -1, 1)
	Health.Border:SetPoint("BOTTOMRIGHT", 1, -1)
	Health.Border:SetBackdrop(unitdb.tex.borderTex)
	Health.Border:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
	Health.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	Health.Border:SetFrameLevel(1)
	
	local Power = CreateFrame("StatusBar", nil, self.bg)
	Power:SetSize(unitdb.powerBar.width, unitdb.powerBar.height)
	Power:SetStatusBarTexture(unitdb.tex.barTex)
	Power:SetPoint("TOP", Health, "BOTTOM", 0, 0-unitdb.parent.spacing*2)

	Power.BG = Power:CreateTexture(nil, "BACKGROUND")
	Power.BG:SetAllPoints(Power)
	Power.BG:SetTexture(unitdb.tex.barTex)
	Power.BG:SetVertexColor(unpack(unitdb.colors.bgColor))

	Power.Border = CreateFrame("Frame", nil, Power)	
	Power.Border:SetPoint("TOPLEFT", -2, 2)
	Power.Border:SetPoint("BOTTOMRIGHT", 2, -2)
	Power.Border:SetBackdrop(unitdb.tex.borderTex)
	Power.Border:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
	Power.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	Power.Border:SetFrameLevel(1)

	Health[unitdb.healthBar.color] = true
	Health.frequentUpdates = true
	Power.colorPower = true
	Power.frequentUpdates = true

	self.Health = Health
	self.Power = Power
end)

-- InfoIcon
ns:addLayoutElement(units, function(self, unit)
	if unitdb.indicators.pvp.enable then
		local PvP = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(PvP,unitdb.indicators.pvp.size)
		--PvP:SetSize(unitdb.indicators.PvP.size)
		PvP:SetPoint("CENTER", self, "LEFT", 2, -2)
		self.PvP = PvP
	end

	if unitdb.indicators.leader.enable then	
		local Leader = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(Leader,unitdb.indicators.leader.size)
		--Leader:SetSize(unitdb.indicators.Leader.size)
		Leader:SetPoint("TOPLEFT", -10, 10)
		self.Leader = Leader
	end
	
	if unitdb.indicators.looter.enable then	
		local MasterLooter = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(MasterLooter,unitdb.indicators.looter.size)
		--MasterLooter:SetSize(unitdb.indicators.MasterLooter.size)
		MasterLooter:SetPoint("LEFT", self.Leader, "RIGHT")
		self.MasterLooter = MasterLooter
	end
	
	if unitdb.indicators.assistant.enable then	
		local Assistant = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(Assistant,unitdb.indicators.assistant.size)
		--Assistant:SetSize(unitdb.indicators.Assistant.size)
		Assistant:SetAllPoints(self.Leader)
		self.Assistant = Assistant
	end
end)

-- RaidIcon
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.indicators.raidIcon.enable then return end
    local RaidIcon = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(RaidIcon,unitdb.indicators.raidIcon.size)
		--RaidIcon:SetSize(unitdb.indicators.RaidIcon.size)
    RaidIcon:SetPoint("TOPRIGHT", 5, 5)
    self.RaidIcon = RaidIcon
end)

-- ThreatBorder
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.indicators.threatBorder.enable then return end
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Border:SetBackdropBorderColor(r, g, b, 0.6)
			self.Power.Border:SetBackdropBorderColor(r, g, b, 0.6)
			self.Portrait.Border:SetBackdropBorderColor(r, g, b, 0.6)
		else
			self.Health.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
			self.Power.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
			self.Portrait.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
		end
	end)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", function(self, event, unit, ...)
		if self.unit ~= unit then return end
		local status = UnitThreatSituation(unit)
		unit = unit or self.unit
		if status and status > 1 then
			local r, g, b = GetThreatStatusColor(status)
			self.Health.Border:SetBackdropBorderColor(r, g, b, 0.6)
			self.Power.Border:SetBackdropBorderColor(r, g, b, 0.6)
			self.Portrait.Border:SetBackdropBorderColor(r, g, b, 0.6)
		else
			self.Health.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
			self.Power.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
			self.Portrait.Border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
		end
	end)
end)

-- ClassIcon
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.indicators.classIcon.enable then return end
    local ClassIcon = self:CreateTexture(nil, "OVERLAY")
		utils.setSize(ClassIcon,unitdb.indicators.classIcon.size)
		--ClassIcon:SetSize(unitdb.indicators.ClassIcon.size)
    ClassIcon:SetPoint("BOTTOMRIGHT", self.Portrait, 0, 0)
    self.ClassIcon = ClassIcon
end)

-- LFDRole
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.indicators.LFD.enable then return end
    local LFDRole = self.Portrait:CreateTexture(nil, "OVERLAY")
		utils.setSize(LFDRole,unitdb.indicators.LFD.size)
		--LFDRole:SetSize(unitdb.indicators.LFDRole.size)
    LFDRole:SetPoint("BOTTOMRIGHT",self.Power,"BOTTOMRIGHT", 0, 0)
    self.LFDRole = LFDRole
end)

-- Tags
ns:addLayoutElement(units, function(self, unit)
	local t = self.tags
	local Level = self:CreateFontString(nil, "OVERLAY")
	t.lvl = Level
	Level:SetFontObject(ChatFontNormal)
	do local font,size,flag = Level:GetFont()
		Level:SetFont(font,size-2,"OUTLINE")
	end
	Level:SetPoint("BOTTOMLEFT", self.Portrait)
	Tags:Register(self, Level, unitdb.tags.lvl.tag)
	Level:UpdateTags()
	if unitdb.tags.lvl.enable then
		Level:Show()
	else
		Level:Hide()
	end
	


	local Name = self.Health:CreateFontString(nil, "OVERLAY")
	t.name = Name
	Name:SetFontObject(ChatFontNormal)
	local font, size, flag = Name:GetFont()
	Name:SetFont(font, size-3, 'OUTLINE')
	Name:SetPoint("LEFT", 5, 0)
	Tags:Register(self, Name, unitdb.tags.name.tag)
	Name:UpdateTags()
	if unitdb.tags.name.enable then
		Name:Show()
	else
		Name:Hide()
	end


	local Health = self.Health:CreateFontString(nil, "OVERLAY")
	t.hp = Health
	Health:SetFontObject(ChatFontNormal)
	local font, size, flag = Health:GetFont()
	Health:SetFont(font, size-2, 'OUTLINE')
	Health:SetPoint("RIGHT", -5, 0)
	Tags:Register(self, Health, unitdb.tags.hp.tag)
	Health:UpdateTags()
	if unitdb.tags.hp.enable then
		Health:Show()
	else
		Health:Hide()
	end

	local Power = self.Power:CreateFontString(nil, "OVERLAY")
	t.mp = Power
	Power:SetFontObject(ChatFontNormal)
	local font, size, flag = Power:GetFont()
	Power:SetFont(font, size-4, "OUTLINE")
	Power:SetPoint("CENTER", 0, 1)
	Tags:Register(self, Power, unitdb.tags.mp.tag)
	Power:UpdateTags()
	if unitdb.tags.mp.enable then
		Power:Show()
	else
		Power:Hide()
	end
end)

-- Aura
local function postCreateIcon(icons, button)
   local font, size, flag = button.count:GetFont()
    button.count:SetFont(STANDARD_TEXT_FONT, size, flag)
    button.oufaura = true
    button.cd:SetDrawEdge(false)
    button.cd:SetReverse(true)
		button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		button.overlay:SetTexture(unitdb.tex.auraTex)
    button.overlay:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 1, -1)		
		button.overlay:SetTexCoord(0, 1, 0, 1)
		button.overlay.Hide = function(self) self:SetVertexColor(unpack(unitdb.colors.brdColor)) end	
end

local function PostUpdateIcon(icons, unit, icon, index, offset)
    utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
end
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.auras.enable then return end
	local Auras = CreateFrame("Frame", nil, self)
	self.Auras = Auras
	--Auras.showDebuffType = true
	Auras.PostCreateIcon = postCreateIcon
	Auras.size = self:GetWidth()/unitdb.auras.count - unitdb.parent.spacing *2
	Auras.numDebuffs = unitdb.auras.numDebuffs
	Auras.spacing = unitdb.auras.spacing
	Auras.numBuffs = unitdb.auras.numBuffs 
	Auras.gap = true
	Auras.initialAnchor = "TOPLEFT"
	Auras["growth-x"] = "RIGHT"
	Auras["growth-y"] = "DOWN"
	Auras:SetWidth(self:GetWidth())
	Auras:SetHeight(16*2+2)
	Auras:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, 0-unitdb.parent.spacing*3)
	--Auras.PostUpdateIcon = PostUpdateIcon
	--toggleElement(self, "Aura", Aura)
	
end)

-- Castbar
ns:addLayoutElement(units, function(self, unit)
	if not unitdb.castbar.enable then return end
    local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetAllPoints(self.Power)
    Castbar:SetStatusBarTexture(unitdb.tex.barTex)
    Castbar:SetStatusBarColor(1, 0.7, 0)

	--[[local Icon = Castbar:CreateTexture(nil, "OVERLAY")
    Icon:SetSize(16, 16)
    Icon:SetTexture("Interface\\Icons\\Spell_Shaman_Hex")
    Icon:SetPoint("RIGHT", Castbar, "LEFT", -3, 0)
    Castbar.Icon = Icon	]]

	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
    Spark:SetSize(26, 26)
    Spark:SetBlendMode("ADD")
    Castbar.Spark = Spark
	
    local Text = Castbar:CreateFontString(nil, "OVERLAY")
    Text:SetFontObject(ChatFontNormal)
	local font, size, flag = Text:GetFont()
	Text:SetFont(font, size-3, flag)
    Text:SetPoint("LEFT", 5, 1)
	Castbar.Text = Text	

    local Time = Castbar:CreateFontString(nil, "OVERLAY")
    Time:SetFontObject(SystemFont_Shadow_Small)
	local font, size, flag = Time:GetFont()
	Time:SetFont(font, size-3, flag)
    Time:SetPoint("RIGHT", -15, 0)
    Castbar.Time = Time	
	
	toggleElement(self, "Castbar", Castbar)
    self.Castbar = Castbar
end)

--[[ns:addLayoutElement(units, function(self)
	self:RegisterEvent("PARTY_MEMBERS_CHANGED")
	self:SetScript("OnEvent", function(self) self:UpdateAllElements(event) end)
end)]]

local function UpdateConditions(obj)
    local obj = self or ns.unitFrames.party
    if not self then UnregisterStateDriver(obj, "visibility") end
	if unitdb.showInRaid.enable then
		RegisterStateDriver(obj, "visibility", "show")
	else
		RegisterStateDriver(obj, "visibility", "[nogroup:raid]show;hide")
	end   
end

ns:spawn(function()	
	local party = oUF:SpawnHeader("WSUFHeader_Party", nil, nil, 
		"showParty", true, 
		"showPlayer", false, 
		"point", "TOP", 
		"yOffset", -15, 
		"template", "WowshellUnitFramePartyTemplate", 
		"oUF-initialConfigFunction", ([[
			local header = self:GetParent();
			if header:GetParent():GetName() ~= "UIParent" then
				header = header:GetParent();
			end
			header:CallMethod("initialConfigFunction1", self:GetName())

			local suffix = self:GetAttribute("unitsuffix")
			if suffix == "pet" then
				self:SetWidth(%d)
				self:SetHeight(%d)
			end	
		]]):format(60, 17)
	)

	ns:SetHeaderAttributes(party, "party")
	WSUF.Layout:AnchorFrame(UIParent, party, position);
	party.isHeaderFrame = true;
	party.unitType = "party";
	party.initialConfigFunction1 = function(header, frameName)

		local frame = _G[frameName];
		frame.ignoreAnchor = true;
		local suffix = frame:GetAttribute("unitsuffix")		
		if (suffix) then
			frame.unitType = "party"..suffix;
			local pname = string.gsub(gsub(frame:GetName(), "Pet$", ""), "Target", "");
			frame.parent = _G[pname];
			frame.isChildUnit = frame;
		else
			frame.unitType = header.unitType;
		end
		ns.frameList[frame] = true
	end
	
	ns.unitFrames.party = party
	ns.headerFrames.party = party;
	UpdateConditions(party);
		local flag = 0
	ns.unitFrames.party:SetMovable(true)
	if unitdb.showInRaid.enable then
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
end
end)

-- CVar
local Event = CreateFrame("Frame")
Event:RegisterEvent("CVAR_UPDATE")
Event:SetScript("OnEvent", function(self, event, key, value, ...)
	if event == "CVAR_UPDATE" then 
		if GetCVarBool("useCompactPartyFrames") then
			UpdateConditions()
		else
			UpdateConditions()
		end
	end
end)

local function setElementSize(obj,element,key,value,func)
	if unitdb[element][key] > value then
		unitdb.parent[key] = unitdb.parent[key] + (value - unitdb[element][key])
	else
		unitdb.parent[key] = unitdb.parent[key] - (unitdb[element][key] - value)
	end
	unitdb[element][key] = value
	if not func then 
		return 
	else 
		func()
	end
end


ns:RegisterUnitOptions("party",{
	type = "group",
	name = L["party"],
	childGroups = "tab",
	order = ns.order(),
	args = {
		group = {
			type = "group",
			order = ns.order(),
			name = L["Group"],
			desc = L["Group options"],
			args = {
				hideBlzRaidFrame = {
					type = "toggle",
					order = ns.order(),
					width = "full",
					name = L["Show Blz's raid Frame"],
					get = function() return CompactRaidFrameManager:IsShown() end,
					set = function(_,v)
						toggleBlzRaidFrame(v)
					end,
				},
				showInRaid = {
					type = "toggle",
					order = ns.order(),
					width = "full",
					name = L["Show party frame in raid"],
					desc = L["Show party frame in raid"],
					get = function() return unitdb.showInRaid.enable end,
					set = function(_,v)
						unitdb.showInRaid.enable = v
						UpdateConditions(ns.unitFrames.party)	
					end,
				},
			},
		},
		Portrait = {
			type = "group",
			name = L["Portrait"],
			desc = L["Portrait"],
			order = ns.order(),
			args = {
				enable = {
					type = "toggle",
					width = "full",
					name = L["Enable"],
					desc = L["Enable Portrait"],
					order = ns.order(),
					get = function() return unitdb.portrait.enable end,
					set = function(_,v)
						unitdb.portrait.enable = v	
					end,
				},
				width = {
					type = "range",
					name = L["Width"],
					desc = L["Portrait's width"],
					order = ns.order(),
					min = 20,max = 50,step = 1,
					get = function() return unitdb.portrait.width end,
					set = function(_,v)
							setElementSize(_,"portrait","width",v)	
					end,
				},
				height = {
					type = "range",
					min = 20,max = 50,step = 1,
					name = L["Height"],
					desc = L["Portrait's height"],
					get = function() return unitdb.portrait.height end,
					set = function(_,v)
						setElementSize(_,"portrait","height",v)
					end,
				},
				position = {
					type = "select",
					width = "double",
					order = ns.order(),
					name = L["Portrait's position"],
					desc = L["Set your Portrait position"],
					values = {["LEFT"]= L["LEFT"],["RIGHT"]=L["RIGHT"]},
					get = function() return unitdb.portrait.position end,
					set = function(_,v)
						unitdb.portrait.position = v
					end,
				},
			},
		},
		Health = {
			type = "group",
			order = ns.order(),
			name = L["HealthBar"],
			desc = L["HealthBar"],
			args = {
				width = {
					type = "range",
					min = 80, max = 220, step = 1,
					name = L["Width"],
					desc = L["HealthBar's width"],
					order = ns.order(),
					get = function() return unitdb.healthBar.width end,
					set = function(_,v)
						setElementSize(_,"healthBar","width",v)
					end,
				},
				height = {
					type = "range",
					min = 10, max = 50, step =1,
					name = L["Height"],
					desc = L["HealthBar's height"],
					get = function() return unitdb.healthBar.height end,
					set = function(_,v)
						setElementSize(_,"healthBar","height",v)
					end,
				},
				color = {
					type = "select",
					name = L["HealthBar color"],
					desc = L["HealthBar color"],
					width = "double",
					order = ns.order(),
					values = {["colorClass"] = L["colorClass"],["colorSmooth"] = L["colorSmooth"]},
					get = function() return unitdb.healthBar.color end,
					set =function(_,v)
						unitdb.healthBar.color = v
					end,
				},
			},
		},
		Power = {
				type = "group",
				order = ns.order(),
				name = L["PowerBar"],
				desc = L["PowerBar"],
				args = {
					width = {
						type = "range",
						min = 80, max = 220, step = 1,
						order = ns.order(),
						name = L["Width"],
						desc = L["PowerBar's width"],
						get = function() return unitdb.powerBar.width end,
						set = function(_,v)
							setElementSize(_,"powerBar","width",v)
						end,
					},
					height = {
						type = "range",
						min = 4,max = 20, step = 1,
						order = ns.order(),
						name = L["Height"],
						desc = L["PowerBar's height"],
						get = function() return unitdb.powerBar.height end,
						set = function(_,v)
							setElementSize(_,"powerBar","height",v)
						end,
					},
				},
		},
		Castbar = {
			type = "group",
			order = ns.order(),
			name = L["Castbar"],
			desc = L["Castbar"],
			args = {
				enable = {
					type = "toggle",
					order = ns.order(),
					name = L["Enable"],
					desc = L["Enable Castbar"],
					get = function() return unitdb.castbar.enable end,
					set = function(_,v)
						unitdb.castbar.enable = v
					end,
				},
			},
		},
		Aura = {
			type = "group",
			order = ns.order(),
			name = L["Auras"],
			desc = L["Auras"],
			args = {
				enable = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable auras"],
					order = ns.order(),
					get = function() return unitdb.auras.enable end,
					set = function(_,v)
						unitdb.auras.enable = v
					end,
				},
				numBuffs = {
					type = "range",
					order = ns.order(),
					name = L["The count of Buffs"],
					desc = L["Set the count of Buffs"],
					min = 1, max = 10, step = 1,
					get = function() return unitdb.auras.numBuffs end,
					set = function(_,v)
						unitdb.auras.numBuffs = v
					end,
				},
				numDebuffs = {
					type = "range",
					order = ns.order(),
					name = L["The count of Debuffs"],
					desc = L["Set the count of Debuffs"],
					get = function() return unitdb.auras.numDebuffs end,
					set = function(_,v)
						unitdb.auras.numDebuffs = v
					end,
				},
				spacing = {
					type = "range",
					order = ns.order(),
					min = 1, max = 2, step = 1,
					name = L["Lines of the auras"],
					desc = L["Set how many lines of the auras"],
					get = function() return unitdb.auras.spacing end,
					set = function(_,v)
						unitdb.auras.spacing = v
					end,
				},
				count = {
					type = "range",
					order = ns.order(),
					min = 5, max = 15,step = 1,
					name = L["Auras's count perline"],
					desc = L["Set how many auras in a line"],
					get = function() return unitdb.auras.count end,
					set = function(_,v)
						unitdb.auras.count = v
					end,
				},
			},
		},
		Indicators = {
			type = "group",
			order = ns.order(),
			name = L["Indicators"],
			desc = L["Indicators"],
			args = {
				PvP = {
					type = "group",
					order = ns.order(),
					name = L["PvP icon"],
					desc = L["PvP icon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							width = "full",
							name = L["Enable"],
							desc = L["Enable pvp icon"],
							get = function() return unitdb.indicators.pvp.enable end,
							set = function(_,v)
								unitdb.indicators.pvp.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["PvP icon's size"],
							min = 5, max = 20, step = 1,
							get = function() return unitdb.indicators.pvp.size end,
							set = function(_,v)
								unitdb.indicators.pvp.size = v
							end,
						},
					},
				},
				Leader = {
					type = "group",
					order = ns.order(),
					name = L["Leader icon"],
					desc = L["Leader icon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							width = "full",
							name = L["Enable"],
							desc = L["Enable leader icon"],
							get = function() return unitdb.indicators.leader.enable end,
							set = function(_,v)
								unitdb.indicators.leader.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["Leader icon's size"],
							min = 5, max = 15, step =1,
							get = function() return unitdb.indicators.leader.size end,
							set = function(_,v)
								unitdb.indicators.leader.size = v
							end,
						},
					},
				},
				MasterLooter = {
					type = "group",
					order = ns.order(),
					name = L["MasterLooter icon"],
					desc = L["MasterLooter icon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							name = L["Enable"],
							desc = L["Enable MasterLooter icon"],
							width = "full",
							get = function() return unitdb.indicators.looter.enable end,
							set = function(_,v)
								unitdb.indicators.looter.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							min = 5, max = 15,step = 1,
							name = L["Size"],
							desc = L["MasterLooter icon's size"],
							get = function() return unitdb.indicators.looter.size end,
							set = function(_,v)
								unitdb.indicators.looter.size = v
							end,
						},
					},
				},
				Assistant = {
					type = "group",
					order = ns.order(),
					name = L["Assistant"],
					desc = L["Assistant"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							name = L["Enable"],
							desc = L["Enable Assistant Icon"],
							get = function() return unitdb.indicators.assistant.enable end,
							set = function(_,v)
								unitdb.indicators.assistant.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["Assistant Icon's size"],
							get = function() return unitdb.indicators.assistant.size end,
							set = function(_,v)
								unitdb.indicators.assistant.size = v
							end,
						},
					},
				},
				RaidIcon = {
					type = "group",
					order = ns.order(),
					name = L["RaidIcon"],
					desc = L["RaidIcon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							name = L["Enable"],
							desc = L["Enable RaidIcon"],
							get = function() return unitdb.indicators.raidIcon.enable end,
							set = function(_,v)
								unitdb.indicators.raidIcon.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["RaidIcon's size"],
							get = function() return unitdb.indicators.raidIcon.size end,
							set = function(_,v)
								unitdb.indicators.raidIcon.size = v
							end,
						},
					},
				},
				ClassIcon = {
					type = "group",
					order = ns.order(),
					name = L["ClassIcon"],
					desc = L["ClassIcon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							name = L["Enable"],
							desc = L["Enable ClassIcon"],
							get = function() return unitdb.indicators.classIcon.enable end,
							set = function(_,v)
								unitdb.indicators.classIcon.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["ClassIcon's size"],
							get = function() return unitdb.indicators.classIcon.size end,
							set = function(_,v)
								unitdb.indicators.classIcon.size = v
							end,
						},
					},
				},
				LFDRole = {
					type = "group",
					order = ns.order(),
					name = L["LFDRole icon"],
					desc = L["LFDRole icon"],
					args = {
						enable = {
							type = "toggle",
							order = ns.order(),
							name = L["Enable"],
							desc = L["Enable LFDRole icon"],
							get = function() return unitdb.indicators.LFD.enable end,
							set = function(_,v)
								unitdb.indicators.LFD.enable = v
							end,
						},
						size = {
							type = "range",
							order = ns.order(),
							name = L["Size"],
							desc = L["LFDRole icon's size"],
							get = function() return unitdb.indicators.LFD.size end,
							set = function(_,v)
								unitdb.indicators.LFD.size = v
							end,
						},
					},	
				},
			},
		},
		Tags = {
				type = "group",
				order = ns.order(),
				name = L["Tags"],
				desc = L["Tags"],
				args = {
					nameTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of name"],
						desc = L["Tags of name"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable.Tags.of name"],
								get = function() return unitdb.tags.name.enable end,
								set = function(_,v)
									unitdb.tags.name.enable = v
									ns:Reload("party")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance name's Tags"],
								desc = L["Set custom name's Tags"],
								values = { ["[name]"] = L["name"], ["[colorname]"] = L["colorname"],["[def:name]"] = L["defname"],},
								get = function() return unitdb.tags.name.tag end,
								set = function(_,v) 
									unitdb.tags.name.tag = v
									ns:Reload("party")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance name's tags"],
								desc = L["Set custom name's tags"],
								get = function() return unitdb.tags.name.tag end,
								set = function(_,v)
									unitdb.tags.name.tag = v
									ns:Reload("party")
								end,
							},
						},
					},
					lvlTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of Level"],
						desc = L["Tags of Level"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable.Tags.of Level"],
								get = function() return unitdb.tags.lvl.enable end,
								set = function(_,v)
									unitdb.tags.lvl.enable = v
									ns:Reload("party")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance level's Tags"],
								desc = L["Set custom level's Tags"],
								values = { ["[level]"] = L["level"],["[levelcolor]"] = L["levelcolor"],["[smartlevel]"] = L["smartlevel"],},
								get = function() return unitdb.tags.lvl.tag end,
								set = function(_,v)
									unitdb.tags.lvl.tag = v
									ns:Reload("party")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance level.Tags"],
								desc = L["Set custom level.Tags"],
								get = function() return unitdb.tags.lvl.tag end,
								set = function(_,v)
									unitdb.tags.lvl.tag = v
									ns:Reload("party")
								end,
							},
						},
					},
					hpTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of health"],
						desc = L["Tags of health"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable.Tags.of hp"],
								get = function() return unitdb.tags.hp.enable end,
								set = function(_,v)
									unitdb.tags.hp.enable = v
									ns:Reload("party")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance hp.Tags"],
								desc = L["Set custom hp.Tags"],
								values = {["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
								get = function() return unitdb.tags.hp.tag end,
								set = function(_,v)
									unitdb.tags.hp.tag = v
									ns:Reload("party")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance hp.Tags"],
								desc = L["Set custom hp.Tags"],
								get = function() return unitdb.tags.hp.tag end,
								set = function(_,v) 
									unitdb.tags.hp.tag = v
									ns:Reload("party")
								end,
							},
						},
					},
					ppTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of power"],
						desc = L["Tags of power"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable Tags of mp"],
								get = function() return unitdb.tags.mp.enable end,
								set = function(_,v)
									unitdb.tags.mp.enable = v
									ns:Reload("party")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance mp.Tags"],
								desc = L["Set custom mp.Tags"],
								values = {["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
								get = function() return unitdb.tags.mp.tag end,
								set = function(_,v)
									unitdb.tags.mp.tag = v
									ns:Reload("party")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance mp.Tags"],
								desc = L["Set custom mp.Tags"],
								get = function() return unitdb.tags.mp.tag end,
								set = function(_,v) 
									unitdb.tags.mp.tag = v
									ns:Reload("party")
								end,
							},
						},
					},
				},
			}		
	},
})


--ns:RegisterUnitOptions("party", {
--    type = "group", 
--    name = L["party"],
--		childGroups = "tab",
--    order = ns.order(), 
--    args = {
--		ShowInRaid = {
--				type = "toggle", 
--				name = L["ShowInRaid"], 
--				desc = L["ShowInRaid"], 
--				order = ns.order(), 
--				get = function() return unitdb.ShowInRaid.enable end, 
--				set = function(_, v)
--					unitdb.ShowInRaid.enable = v
--					UpdateConditions()
--				end, 
--		}, 
--		Portrait = {
--				type = "toggle", 
--				name = L["Portrait"], 
--				desc = L["Enable Portrait"], 
--				order = ns.order(), 
--				get = function() return unitdb.Portrait.enable end, 
--				set = function(_, v)
--					unitdb.Portrait.enable= v
--					toggleElement(_, "portrait", ns.unitFrames.Party.Portrait)
--				end, 
--		}, 
--		Castbar = {
--				type = "toggle", 
--				name = L["Castbar"], 
--				desc = L["Enable Castbar"], 
--				order = ns.order(), 
--				get = function() return unitdb.Castbar.enable end, 
--				set = function(_, v)
--					unitdb.Castbar.enable = v
--					toggleElement(_, "Castbar", ns.unitFrames.Party.Castbar)
--				end, 
--		}, 
--		PvP = {
--			type = "toggle", 
--			name = L["PVP icon"], 
--			desc = L["Enable PVP Icon"], 
--			get = function() return unitdb.PvP.enable end, 
--			set = function(_, v)
--				unitdb.PvP.enable = v
--				toggleElement(_, "PvP", ns.unitFrames.Party.PvP)
--			end, 
--		}, 
--		Leader = {
--			type = "toggle", 
--			name = L["Leader Icon"], 
--			desc = L["Enable Leader Icon"], 
--			get = function() return unitdb.Leader.enable end, 
--			set = function(_, v)
--				unitdb.Leader.enable = v
--				toggleElement(_, "Leader", ns.unitFrames.Party.Leader)
--			end, 
--		}, 
--		MasterLooter = {
--			type = "toggle", 
--			name = L["Looter Icon"], 
--			desc = L["Enable Looter Icon"], 
--			get = function() return unitdb.MasterLooter.enable end, 
--			set = function(_, v)
--				unitdb.MasterLooter.enable = v
--				toggleElement(_, "MasterLooter", ns.unitFrames.Party.MasterLooter)
--			end, 
--		},
--		Assistant = {
--			type = "toggle", 
--			name = L["Assistant Icon"], 
--			desc = L["Enable Assistant Icon"], 
--			get = function() return unitdb.Assistant.enable end, 
--			set = function(_, v)
--				unitdb.Assistant.enable = v
--				toggleElement(_, "Assistant", ns.unitFrames.Party.Assistant)
--			end, 
--		}, 
--		LFDRole ={
--			type = "toggle", 
--			name = L["LFDRole Icon"], 
--			desc = L["Enable LFDRole Icon"], 
--			get = function() return unitdb.LFDRole.enable end, 
--			set = function(_, v)
--				unitdb.LFDRole.enable = v
--				toggleElement(_, "LFDRole", ns.unitFrames.Party.LFDRole)
--			end, 
--		}, 
--		RaidIcon = {
--			type = "toggle", 
--			name = L["Raid Icon"], 
--			desc = L["Enable Raid Icon"], 
--			get = function() return unitdb.RaidIcon.enable end, 
--			set = function(_, v) 
--				unitdb.RaidIcon.enable = v
--				toggleElement(_, "RaidIcon", ns.unitFrames.Party.RaidIcon)	
--			end, 
--		},
--		Aura = {
--			type = "toggle", 
--			name = L["Aura"], 
--			desc = L["Enable Aura"], 
--			get = function() return unitdb.Aura.enable end, 
--			set = function(_, v) 
--				unitdb.Aura.enable = v
--				toggleElement(_, "Aura", ns.unitFrames.Party.Aura)	
--			end, 
--		},
--		Castbar = {
--			type = "toggle", 
--			name = L["Castbar"], 
--			desc = L["Enable Castbar"], 
--			get = function() return unitdb.Castbar.enable end, 
--			set = function(_, v) 
--				unitdb.Castbar.enable = v
--				toggleElement(_, "Castbar", ns.unitFrames.Party.Castbar)	
--			end, 
--		},
--	}
--})
