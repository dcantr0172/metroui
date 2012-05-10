local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local UnitDB = ns:RegisterUnitDB("partypet", {
	Tex = {
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
	}, 	
	Health = {
		Width = 60, 
		Height = 14, 
	}, 
	Power = {
		Width = 60, 
		Height = 3, 
	}, 
	tags = {
		Health = {
			enable = true,
			tag = "[curhp]"
		}, 
		Power = {
			enable = false,
			tag = "[name]"
		}, 
	}, 
})

local units = "partypet"

ns:addLayoutElement(units, function(self, unit)
	local Health = CreateFrame("StatusBar", nil, self)
	local Power = CreateFrame("StatusBar", nil, self)

	Health:SetStatusBarTexture(UnitDB.Tex.barTex)
	Power:SetStatusBarTexture(UnitDB.Tex.barTex)	

	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetAllPoints()
	Health.BG:SetTexture(UnitDB.Tex.barTex)
	Health.BG:SetVertexColor(0, 0, 0, 0.8)

	Health.Border = CreateFrame("Frame", nil, Health)
	Health.Border:SetPoint("TOPLEFT", -2, 2)
	Health.Border:SetPoint("BOTTOMRIGHT", 2, -2)
	Health.Border:SetBackdrop(UnitDB.Tex.borderTex)
	Health.Border:SetBackdropColor(26/255, 25/255, 31/255)
	Health.Border:SetBackdropBorderColor(70/255, 70/255, 70/255)
	Health.Border:SetFrameLevel(1)

	Power.BG = Power:CreateTexture(nil, "BACKGROUND")
	Power.BG:SetAllPoints()
	Power.BG:SetTexture(UnitDB.Tex.barTex)
	Power.BG:SetVertexColor(0, 0, 0, 0.8)

	Power.Border = CreateFrame("Frame", nil, Power)	
	Power.Border:SetPoint("TOPLEFT", -2, 2)
	Power.Border:SetPoint("BOTTOMRIGHT", 2, -2)
	Power.Border:SetBackdrop(UnitDB.Tex.borderTex)
	Power.Border:SetBackdropColor(26/255, 25/255, 31/255)
	Power.Border:SetBackdropBorderColor(70/255, 70/255, 70/255)
	Power.Border:SetFrameLevel(1)

	Health:SetSize(UnitDB.Health.Width, UnitDB.Health.Height)
	Power:SetSize(UnitDB.Power.Width, UnitDB.Power.Height)

	Health:SetPoint("TOP")
	Power:SetPoint("TOP", Health, "BOTTOM")

	Health.colorHealth = true
	Power.colorPower = true

	self.Health = Health
	self.Power = Power
end)

ns:addLayoutElement(units, function(self, unit)
	local Health = self.Health:CreateFontString(nil, "OVERLAY")
	self.tags.Health = Health
	Health:SetFontObject(ChatFontNormal)
	local font, size, flag = Health:GetFont()
	Health:SetFont(font, size-4, "OUTLINE")
	Health:SetPoint("TOP")
	Tags:Register(self, Health, UnitDB.tags.Health.tag);
	Health:UpdateTags()
	
	--local Power = self.Power:CreateFontString(nil, "OVERLAY")
	--self.tags.Power= Power
	--Power:SetFontObject(NumberFontNormal)
	--Power:SetPoint("BOTTOM")
	--Tags:Register(self, Power, UnitDB.Tags.Power.tag)	
end)

