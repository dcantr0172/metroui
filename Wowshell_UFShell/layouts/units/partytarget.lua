local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local UnitDB = ns:RegisterUnitDB("partytarget", {
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
		Height = 16, 
	}, 
	tags = {
		Name = {
			enable = true,
			tag = "[colorname]"
		}, 
		Health = {
			enable = true,
			tag = "[curhp]"
		}, 
	}, 
})

local units = "partytarget"

ns:setSize(units, 60, 16)

ns:addLayoutElement(units, function(self, unit)	
	self:SetAttribute("type2", nil)
    self.menu = nil
end)

local function Health_PostUpdate(bar, unit, min, max)
	if UnitIsEnemy("player", unit) then
		bar:SetStatusBarColor(1, 0, 0)
	elseif UnitIsFriend("player", unit) then
		bar:SetStatusBarColor(0, 1, 0)			
	else
		bar:SetStatusBarColor(1, 1, 0)
	end
end
ns:addLayoutElement(units, function(self, unit)
    local Health = CreateFrame("StatusBar", nil, self)
	Health:SetSize(UnitDB.Health.Width, UnitDB.Health.Height)
   	Health:SetStatusBarTexture(UnitDB.Tex.barTex)
	Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	Health.BG = Health:CreateTexture(nil, "BACKGROUND")
	Health.BG:SetAllPoints()
	Health.BG:SetTexture(UnitDB.Tex.barTex)
	Health.BG:SetVertexColor(0, 0, 0, .8)
	Health.Border = CreateFrame("Frame", nil, Health)
	Health.Border:SetPoint("TOPLEFT", -2, 2)
	Health.Border:SetPoint("BOTTOMRIGHT", 2, -2)
	Health.Border:SetBackdrop(UnitDB.Tex.borderTex)
	Health.Border:SetBackdropColor(26/255, 25/255, 31/255)
	Health.Border:SetBackdropBorderColor(70/255, 70/255, 70/255)
	Health.Border:SetFrameLevel(1)

    Health.PostUpdate = Health_PostUpdate
	self.Health = Health
end)

ns:addLayoutElement(units, function(self, unit)
	local Name = self.Health:CreateFontString(nil, "OVERLAY")
	self.tags.Name = Name
	Name:SetFontObject(ChatFontNormal)
	local font, size, flag = Name:GetFont()
	Name:SetFont(font, size-4, "OUTLINE")
	Name:SetPoint("BOTTOM", self.Health, "TOP", 0, -3)
	Tags:Register(self, Name, UnitDB.tags.Name.tag)
	Name:UpdateTags()
	local Health = self.Health:CreateFontString(nil, "OVERLAY")
	self.tags.Health = Health
	Health:SetFontObject(ChatFontNormal)
	local font, size, flag = Health:GetFont()
	Health:SetFont(font, size-4, "OUTLINE")
	Health:SetPoint("BOTTOM")
	Tags:Register(self, Health, UnitDB.tags.Health.tag)	
	Health:UpdateTags();
end)

ns:addLayoutElement(units, function(self, unit)
    local RaidIcon = self:CreateTexture(nil, "OVERLAY")
    RaidIcon:SetSize(16, 16)
    RaidIcon:SetPoint("RIGHT")
    self.RaidIcon = RaidIcon
end)

--add: wendell portrait init function add
-- ns:addLayoutElement(units, function(self, unit)
    -- local p = self.bg:CreateTexture(nil, "ARTWORK")
    -- self.Portrait = p
    -- self.portrait_2d = p
    -- utils.setSize(p, 35)
    -- p:SetPoint("TOPLEFT", 5, -5)
-- end)
--add: wendell portrait style function add
-- ns:addLayoutElement(units, function(self, unit)
    -- local p = CreateFrame("PlayerModel", nil, self.bg)
    -- utils.setSize(p, 30)
    -- p:SetPoint("CENTER", self.portrait_2d)
    -- self.portrait_3d = p
-- end)

--[[local objs = {}
ns.units.partytargets = objs
ns:addLayoutElement(units, function(self, unit)
    tinsert(objs, self)
end)]]

--ns:RegisterInitCallback(function()
--    db = ns.db.profile
--
--    unitdb = ns.db:RegisterNamespace("partytarget", { profile = {
--            enabled = false, 
--            colorbyreaction = true, 
--        }
--    }).profile
--end)
--
----TODO:
---- 需要修正!! 小队目标不需要重新就能关闭
--
--local option_args = {
--    enabled = {
--        type = "toggle", 
--        name = L["Enable"], 
--        desc = L["Enable party target"] .. "\n" .. L["The settings will take effect after reload."], 
--        width = "full", 
--        order = ns.order(), 
--        get = function() return unitdb.enabled end, 
--        set = function(_, v)
--            unitdb.enabled = v
--						
--            --StaticPopup_Show"WOWSHELL_UTIL_CONFIGCHANGED_RELOAD"
--        end, 
--    }, 
--    colorbyreaction = {
--        type = "toggle", 
--        name = L["Color by target\"s reaction"], 
--        desc = L["Color health bar by target\"s reaction"], 
--        width = "full", 
--        disabled = function() return not unitdb.enabled end, 
--        order = ns.order(), 
--        get = function() return unitdb.colorbyreaction end, 
--        set = function(_, v)
--            unitdb.colorbyreaction = v
--            for _, f in ipairs(objs) do
--                    f.Health:ForceUpdate()
--                    --f:UpdateElement("Health")
--            end
--        end, 
--    }, 
--}
--
--ns:RegisterModuleOptions("partytarget", {
--    type = "group", 
--    name = L["partytarget"], 
--    order = ns.order(), 
--    args = option_args, 
--})
