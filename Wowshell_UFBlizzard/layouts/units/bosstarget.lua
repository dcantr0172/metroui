local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local unitdb = ns:RegisterUnitDB("bosstarget",{
	parent = {
		width = 50,
		height = 14,
	},
	tags = {
		name = { tag = "[name]"},
	},

})

local bosses = {}

for bossId = 1, MAX_BOSS_FRAMES do
	local units = "boss"..bossId.."target"

	ns:setSize(units, unitdb.parent.width, unitdb.parent.height)

	ns:addLayoutElement(units, function(self, unit)

		local hp = CreateFrame("StatusBar", nil, self)
		hp:SetFrameLevel(0)
		utils.setSize(hp, 50, 14)
		hp:SetAllPoints()
		hp.colorHealth = true
		hp.frequentUpdates = true
		self.Health = hp
		
		local BG = hp:CreateTexture(nil, "OVERLAY")
		BG:SetTexture[[Interface\Tooltips\UI-StatusBar-Border]]
		BG:SetPoint("TOPLEFT", -2, 2)
		BG:SetPoint("BOTTOMRIGHT", 2, -2)
		self.HealthBG = BG

	end)

	ns:addLayoutElement(units, function(self, unit)
		local Tags = self.tags

		local name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject(GameFontNormalSmall)
		name:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		Tags.name = name

	end)

	ns:spawn(function()
		local temp = oUF:Spawn(units, "wsUnitFrame_BossFrame"..bossId.."target")
		temp:SetPoint("CENTER", ns.units["boss"..bossId], "CENTER", 10, -25)
		ns.units["boss"..bossId.."target"] = temp
	end)
end

--ns:RegisterInitCallback(function()
--    db = ns.db.profile
--    unitdb = ns.db:RegisterNamespace("bosstarget", { profile = {
--            castbar = true,
--            auracooldown = true,
--            castbyme = true,
--            highlightmydebuff = false,
--            taghp = "SMAR",
--            tagmp = "SMAR",
--            perhp = "PERC",
--            perpp = "PERC",
--        }
--    }).profile
--end)
