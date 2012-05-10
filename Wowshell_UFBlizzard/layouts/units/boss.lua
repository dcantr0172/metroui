local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local unitdb = ns:RegisterUnitDB("boss",{
	parent = {
		width = 232,
		height = 100,
	},
					castbar = true,
          auracooldown = true,
          castbyme = true,
          tags = {
						lvl = { tag = "[level]"},
						name = { tag = "[name]"},
						hp = { tag = "[curhp]"},
            mp = { tag = "[curpp]"},
            perhp = { tag = "[perhp]"},
            perpp = { tag = "[perpp]"},
					},
})

local bosses = {}

for bossId = 1, MAX_BOSS_FRAMES do
	local units = "boss"..bossId;
	ns:setSize(units, unitdb.parent.width, unitdb.parent.height)
	-- Border Texture
	ns:addLayoutElement(units, function(self, unit)
		local BorderTexture = self:CreateTexture(nil, "BORDER")
		BorderTexture:SetTexture("Interface\\TargetingFrame\\UI-UnitFrame-Boss")
		BorderTexture:SetAllPoints()
		
		self.BorderTexture = BorderTexture
	end)

	ns:addLayoutElement(units, function(self, unit)
		local hp = CreateFrame("StatusBar", nil, self)
		hp:SetFrameLevel(0)
		utils.setSize(hp, 107, 8)
		hp:SetPoint("TOP", self.BorderTexture, "TOP", -37, -32)
		hp.colorHealth = true
		hp.frequentUpdates = true

		local mp = CreateFrame("StatusBar", nil, self)
		mp:SetFrameLevel(0)
		utils.setSize(mp, 107, 8)
		mp:SetPoint("TOP", hp, "BOTTOM", 0, -2)
		mp.colorPower = true
		mp.frequentUpdates = true
		
		self.Health, self.Power = hp, mp

	end)

	ns:addLayoutElement(units, function(self, unit)
		local Tags = self.tags
		
		local nameBG = self:CreateTexture(nil, "BACKGROUND")
		nameBG:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")
		utils.setSize(nameBG, 107, 15)
		nameBG:SetVertexColor(1, 0, 0)
		nameBG:SetPoint("BOTTOM", self.Health, "TOP", 1, 0)
		self.nameBG = nameBG
		
		local lvl = self:CreateFontString(nil, "OVERLAY")
		Tags.lvl = lvl
		lvl:SetFontObject(GameFontNormalSmall)
		lvl:SetPoint("CENTER", 23, -1)
		--self:Tag(lvl, "[difficulty][level]")

		local name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject(GameFontNormalSmall)
		name:SetPoint("CENTER", self.Health, "CENTER", 0, 12)
		--self:Tag(name, "[name]")
		Tags.name = name

		local hpTag = self:CreateFontString(nil, "OVERLAY")
		Tags.hpTag = hpTag
		hpTag:SetFontObject("TextStatusBarText")
		hpTag:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		--self:Tag(hpTag, "[curhp]/[maxhp]")

		local mpTag = self:CreateFontString(nil, "OVERLAY")
		Tags.mpTag = mpTag
		mpTag:SetFontObject("TextStatusBarText")
		mpTag:SetPoint("CENTER", self.Health, "CENTER", 0, -10)
		mpTag.frequentUpdates = .1
		--self:Tag(mpTag, "[curpp]/[maxpp]")

		local perhp = self:CreateFontString(nil, "OVERLAY")
		Tags.perhp = perhp
		perhp:SetFontObject("TextStatusBarText")
		perhp:SetPoint("LEFT", self.Health, "LEFT", -30, 0)
		--self:Tag(perhp, "[colorhp][perhp]%")

		local perpp = self:CreateFontString(nil, "OVERLAY")
		Tags.perpp = perpp
		perpp:SetFontObject("TextStatusBarText")
		perpp:SetPoint("LEFT", self.Health, "LEFT", -30, -10)
		perpp.frequentUpdates = .1
		--self:Tag(perpp, "[perpp]%")

	end)
	
	local function updateAuraPosition(self, forceUpdate)
		local buffs = self.Buffs
		buffs.initialAnchor = "TOPLEFT"
		buffs["growth-y"] = "DOWN"
		buffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 25, 10)

		if forceUpdate then
			utils.updateAuraElement(self)
		end
	end

	ns:addLayoutElement(units, function(self, unit)
		-- threat text
		local threat = CreateFrame("Frame", nil, self);
		utils.setSize(threat, 49, 18);
		threat:SetPoint("BOTTOM", self, "TOP", -50, -20);
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

	local function postAuraUpdate(element)
		local self = element.__own
		local buffs = self.Buffs

		local numBuffs = buffs.visibleBuffs

		local rows

		local size, width = buffs.size+buffs.spacing or 0, buffs:GetWidth()
		local iconsPerRow = math.floor(width/size + .5)
		rows = math.ceil(numBuffs / iconsPerRow)

	end

	local function postUpdateIcon(icons, unit, icon, index, offset)
		utils.postAuraUpdateCooldown(icons, unit, icon, index, offset, unitdb.auracooldown, unitdb.castbyme)
	end

	ns:addLayoutElement(units, function(self, unit)
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

		buffs.PostUpdateIcon = postUpdateIcon
		updateAuraPosition(self)
	end)
	
	ns:addLayoutElement(units, function(self, unit)
		local bar = CreateFrame("StatusBar", nil, self)
		self.Castbar = bar
		bar:SetPoint("CENTER", self, "CENTER", -58, -25)
		bar.__own = self

		utils.setSize(bar, 70, 10)
		bar:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		bar:SetStatusBarColor(1, .7, 0)

		local icon = bar:CreateTexture(nil, "ARTWORK")
		bar.Icon = icon
		utils.setSize(icon, 16)
		icon:SetTexture[[Interface\Icons\Spell_Shaman_Hex]]
		icon:SetPoint("RIGHT", bar, "LEFT", -1, 0)

		local border = bar:CreateTexture(nil, "ARTWORK")
		bar.Border = border
		utils.setSize(border, 100, 54)
		border:SetTexture[[Interface\CastingBar\UI-CastingBar-Border-Small]]
		border:SetPoint("CENTER", bar)

		local shield = bar:CreateTexture(nil, "OVERLAY")
		bar.Shield = shield
		utils.setSize(shield, 100, 54)
		shield:SetPoint("CENTER", bar, -3, 0)
		shield:SetTexture[[Interface\CastingBar\UI-CastingBar-Small-Shield]]

		local spark = bar:CreateTexture(nil, "OVERLAY")
		bar.Spark = spark
		utils.setSize(spark, 26)
		spark:SetBlendMode"ADD"

		local text = bar:CreateFontString(nil, "OVERLAY")
		bar.Text = text
			text:SetFontObject(TextStatusBarText)
		do
			local f, s, flag = text:GetFont()
			text:SetFont(f, s-2, flag)
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

	end)
	
	ns:addLayoutElement(units, function(self, unit)
		self.RaidIcon = self:CreateTexture('$parentRaidIcon', 'OVERLAY', self)
		self.RaidIcon:SetPoint('CENTER', self, 'TOPRIGHT', -90, -15)
		self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')
		self.RaidIcon:SetSize(24, 24)
	end)

	ns:spawn(function()
		local f = oUF:Spawn(units, "wsUnitFrame_BossFrame"..bossId);
		bosses[bossId] = f;
		if bossId == 1 then
			bosses[bossId]:SetPoint("RIGHT", UIParent, -50, 220);
		else
			bosses[bossId]:SetPoint("TOPLEFT", bosses[bossId-1], "BOTTOMLEFT", 0, -10);
		end
		ns.units["boss"..bossId] = f;
	end)
end

--ns:RegisterInitCallback(function()
--    db = ns.db.profile
--    unitdb = ns.db:RegisterNamespace("boss", { profile = {
--            castbar = true,
--            auracooldown = true,
--            castbyme = true,
--            taghp = "SMAR",
--            tagmp = "SMAR",
--            perhp = "PERC",
--            perpp = "PERC",
--        }
--    }).profile
--end)
