
local parent, ns = ...
local oUF = ns.oUF
local utils= ns.utils
local L = WSUF.L
local db = WSUF.db.profile

local position = ns:RegisterUnitPosition("arenatarget",{
	selfPoint = "TOPLEFT",
	anchorTo = "$parent",
	relativePoint = "TOPRIGHT",
	x = "-5",
	y = "0",
})


local unitdb = ns:RegisterUnitDB("arenatarget",{
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
		bgColor = {0,0,0,.8},
		brdBgColor = {0.1,0.1,0.12,1},
		brdColor = {0.28,0.28,0.28,1},
	},
	parent = {
		width = 50, 
		height = 25, 
		scale = 1, 
		spacing = 2,
	},
	healthBar = {
		width = 50,
		height = 25,
		color = "colorClass",
	},
	tags = {
		name = {
			tag = "[colorName]",
		},
	},	
})


local units = 'arenatarget'

ns:setSize(units, unitdb.parent.width,unitdb.parent.height,unitdb.paren.scale)

ns:addLayoutElement(units, function(self, unit)
	   local hp = CreateFrame("StatusBar", nil, self.bg)
	
	hp:SetSize(unitdb.healthBar.width, unitdb.healthBar.height);
	hp:SetPoint("TOPLEFT", self.bg, 0, 0);
	hp:SetStatusBarTexture(unitdb.tex.barTex)

	local hpbg = hp:CreateTexture(nil,'BACKGROUND')
	hpbg:SetAllPoints(hp)
	hpbg:SetTexture(unitdb.tex.barTex)
	hpbg:SetVertexColor(unpack(unitdb.colors.bgColor))

	local hpbrd = CreateFrame("Frame",nil,hp)
	hpbrd:SetPoint('TOPLEFT',hp,'TOPLEFT',-1,1)
	hpbrd:SetPoint('BOTTOMRIGHT',hp,'BOTTOMRIGHT',1,-1)
	hpbrd:SetBackdrop(unitdb.tex.borderTex)
	hpbrd:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
	hpbrd:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	hpbrd:SetFrameLevel(1)

	hp[unitdb.healthBar.color] = true
	hp.colorSmooth = true

	self.Health = hp 

end)


ns:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local name = self.Health:CreateFontString(nil, 'ARTWORK')
    t.name = name
		name:SetFontObject(ChatFontNormal)
    do
        local font, size, flag = name:GetFont()
        name:SetFont(font, size, "OUTLINE")
    end
    name:SetPoint('BOTTOM', self, 'TOP', 2, 6)

    local hp = self.Health:CreateFontString(nil, 'ARTWORK')
    t.hp = hp
    hp:SetFontObject(ChatFontNormal)
		hp:SetPoint('CENTER')
end)


