-- susnow 
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local style = ns.style
local preview = ns.preview

local position = ns:RegisterUnitPosition("player",{
	selfPoint = "TOPLEFT",
	anchorTo = "UIParent",
	relativePoint = "TOPLEFT",
	x = "5",
	y = "-25"
})

local unitdb = ns:RegisterUnitDB("player",{
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
		arrowUp = "Interface\\AddOns\\Wowshell_UFShell\\texture\\arrowUp",
		arrowDown = "Interface\\AddOns\\Wowshell_UFShell\\texture\\arrowDown",
	},	
	Parent = {
		width = 216,
		height = 44,
		background = {
			tex = "",
			color = {0,0,0,.8},
		},
		border = {
			value = 0,
			tex = "",
			color = {0.3,0.3,0.3,1},
		},
		scale = 1,
		spacing = 2,
	},
	colors = {
		bgColor = {0,0,0,.8},
		brdBgColor = {0.1,0.1,0.12,1},
		brdColor = {0.28,0.28,0.28,1},
	},
	Portrait = {
		enable = true,
		width = 44,
		height = 44,
		position = {
			point = "LEFT",
			x = 0,
			y = 0,
		},
		background = {
			tex = "",
			color = {0,0,0,.8},
		},
		border = {
			value = 1,
			tex = "",
			color = {0,0,0,1},
		},
		alpha = 1,
		frameLevel = 1,
	},
	Health = {
		width = 166,
		height = 26,
		position = {
			x = 49,
			y = 0,
		},
		color = "colorClass",
		colorH = {0,1,0.36,1},
		tex = "",
		background = {
			tex = "",
			color = {0,0,0,1},
		},
		border = {
			value = 1,
			tex = "",
			color = {0,0,0,1},
		},
		alpha = 1,
		frameLevel = 1,
	},
	Power = {
		width = 166,
		height = 12,
		color = "colorPower",
		colorP = {0.24,0.38,0.6,1},
		tex = "",
		position = {
			x = 49,
			y = -32,
		},
		background = {
			tex = "",
			color = {0,0,0,1},
		},
		border = {
			value = 1,
			tex = "",
			color = {0,0,0,1},
		},
		alpha = 1,
		frameLevel = 1,
	},
	Castbar = {
		width = 216,
		height = 10,
		position = {
			x = 0,
			y = 0,
		},
		color = {1,0.7,0,1},
		tex = "",
		background = {
			value = 1,
			tex = "",
			color = {0,0,0,.8},
		},
		frameLevel = 1,
		Icon = {
			size = 20,
			position = {
				point = "RIGHT",
				x = 0,
				y = 0,
			},
			border = {
				value = 1,
				tex = "",
				color = {0,0,0,1},
			},
		},
		Text = {
			fontSize = 12,
			flag = "OUTLINE",
			position = {
				x = 0,
				y = 0, 
			},
		},
	},
	Auras = {
		width = 216,
		height = 40,
		numBuffs = 16,
		numDebuffs = 16,
		spacing = 6,
		count = 10,
		anchor = "TOPLEFT",
		growthX = "RIGHT",
		growthY = "DOWN",
		highLightMyAuras = true,
		onlyShowMyAuras = false,
		position = {
			x = 0,
			y = -18,
		},
	},
	expBar = {
		enable = true,
		width = 210,
		height = 2,
	},
	Indicators = {
			PvP= {
				enable = true,
				size = 29,
				position = {
					point = "TOP",
					relativePoint = "Portrait",
					anchorTo = "TOPLEFT",
					x = 2,
					y = -1,
				},
			},
			Leader = {
				enable = true,
				size = 15,
				position = {
					point = "CENTER",
					relativePoint = "Health",
					anchorTo = "TOPLEFT",
					x = 4,
					y = 0,
				},
			},
			MasterLooter = {
				enable = true,
				size = 13,
				position = {
					point = "CENTER",
					relativePoint = "Health",
					anchorTo = "TOPLEFT",
					x = 22,
					y = 0,
				},
			},
			Resting = {
				enable = true,
				size = 13,
				position = {
					point = "BOTTOMRIGHT",
					relativePoint = "Portrait",
					anchorTo = "BOTTOMRIGHT",
					x = 0,
					y = 0,
				},
			},
			LFDRole = {
				enable = true,
				size = 13,
				position = {
					point = "BOTTOMLEFT",
					relativePoint = "Portrait",
					anchorTo = "BOTTOMLEFT",
					x = 0,
					y = 0,
				},
			},
			RaidIcon = {
				enable =true,
				size = 16,
				position = {
					point = "CENTER",
					relativePoint = "Health",
					anchorTo = "RIGHT",
					x = 0,
					y = 0,
				},
			},
	},
	tags = {
		HealthLeft = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		HealthRight = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		HealthCenter = {
			enable = true,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "[curhp]",
		},
		PortraitLeft = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		PortraitCenter = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		PortraitRight = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		PowerLeft = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		PowerCenter = {
			enable = true,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "[curpp]",
		},
		PowerRight = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		ParentTopleft = {
			enable = true,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "[colorname][level][close]",
		},
		ParentTop = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		ParentTopright = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottomleft = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottom = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottomright = {
			enable = false,
			fontSize = 12,
			flag = "OUTLINE",
			tag = "",
		},
	},
	CombatFeedbackText = {
		enable = true,
		fontSize = 12,
		flag = "OUTLINE",
		position = {
			point = "CENTER",
			relativePoint = "Portrait",
			anchorTo = "CENTER",
			x = 0,
			y = 0,
		},
	},
	SpecialElement = {
		width = 166,
		height = 2,
		border = {
			value = 1,
			color = {0,0,0,1},
		},
		position = {
			x = 51,
			y = -28,
			xOffset = 1,
			yOffset = 0,
		},
	},
	Combat = {
		size = 32,
		position = {
			point = "BOTTOMRIGHT",
			anchorTo = "BOTTOMRIGHT",
			x = -10,
			y = -3,
		},
	},
})

local units = "player"

ns:setSize(units, unitdb.Parent.width, unitdb.Parent.height,unitdb.Parent.scale)





ns:addLayoutElement(units, function(self, unit)
	self.Portrait = CreateFrame("PlayerModel",nil,self.bg)
	self.Portrait.border = CreateFrame("Frame",nil,self.Portrait)
	self.Portrait.background = self.Portrait:CreateTexture(nil,"BACKGROUND")
	style.SetElementSize(units,unitdb.Portrait.width,"width","Portrait")
	style.SetElementSize(units,unitdb.Portrait.height,"height","Portrait")
	style.SetPortraitPosition(units)
	style.SetElementBackGroundTextrueAndColor(units,"Portrait")
	style.SetElementBorderValueAndTextureAndColor(units,"Portrait")
	style.SetElementFrameLevel(units,"Portrait")
	style.SetElementAlpha(units,"Portrait")	

end)

ns:addLayoutElement(units,function(self,unit)
	self.Health = CreateFrame("StatusBar",nil,self.bg)
	self.Health.border = CreateFrame("Frame",nil,self.Health)
	self.Health.background= self.Health:CreateTexture(nil,"BACKGROUND")
	style.SetElementSize(units,unitdb.Health.width,"width","Health")
	style.SetElementSize(units,unitdb.Health.height,"height","Health")
	style.SetHealthPosition(units)
	style.SetElementBackGroundTextrueAndColor(units,"Health")
	style.SetElementBorderValueAndTextureAndColor(units,"Health")
	style.SetElementFrameLevel(units,"Health")
	style.SetElementAlpha(units,"Health")	
	style.SetElementTexture(units,"Health")
	style.SetHealthColor(units)
	--self.Health.colorReaction = true
	self.Health.frequentUpdates = true
end)

ns:addLayoutElement(units,function(self,unit)
	self.Power = CreateFrame("StatusBar",nil,self.bg)
	self.Power.border = CreateFrame("Frame",nil,self.Power)
	self.Power.background = self.Power:CreateTexture(nil,"BACKGROUND")
	style.SetElementSize(units,unitdb.Power.width,"width","Power")
	style.SetElementSize(units,unitdb.Power.height,"height","Power")
	style.SetPowerPosition(units)
	style.SetElementBackGroundTextrueAndColor(units,"Power")
	style.SetElementBorderValueAndTextureAndColor(units,"Power")
	style.SetElementFrameLevel(units,"Power")
	style.SetElementAlpha(units,"Power")	
	style.SetElementTexture(units,"Power")
	style.SetPowerColor(units)
	self.Power.frequentUpdates = true
	self.Power.Smooth = true
end)

ns:addLayoutElement(units,function(self,unit)
	self.Castbar = CreateFrame("StatusBar",nil,self)
	self.Castbar.background = self.Castbar:CreateTexture(nil,"BACKGROUND")
	self.Castbar.border = CreateFrame("Frame",nil,self.Castbar)
	self.Castbar.Icon = self.Castbar:CreateTexture(nil,"ARTWORK")
	self.Castbar.Icon.border = CreateFrame("Frame",nil,self.Castbar) 
	self.Castbar.Text = self.Castbar:CreateFontString(nil,"OVERLAY")
	style.SetElementSize(units,unitdb.Castbar.width,"width","Castbar")
	style.SetElementSize(units,unitdb.Castbar.height,"height","Castbar")
	style.SetElementTexture(units,"Castbar")
	style.SetElementColor(units,"Castbar")
	style.SetCastbarPosition(units)
	style.SetCastbarBorder(units)
	style.SetCastbarIconSize(units)
	style.SetCastbarIconPosition(units)
	style.SetCastbarIconBorder(units)
	style.SetCastbarText(unit)
	style.SetElementFrameLevel(units,"Castbar")
end)

ns:addLayoutElement(units,function(self,unit)
	self.Combat = self:CreateTexture(nil,"OVERLAY")
	style.AddCombatIcon(units)
	style.SetCombatIconSize(units)
	style.SetCombatIconPosition(units)
end)


--
--local function postCreateIcon(icons, button)
--local font, size, flag = button.count:GetFont()
--    button.count:SetFont(STANDARD_TEXT_FONT, size, flag)
--    button.oufaura = true
--    button.cd:SetDrawEdge(false)
--    button.cd:SetReverse(true)
--		button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
--		button.overlay:SetTexture(unitdb.tex.auraTex)
--    button.overlay:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -2, 2)
--    button.overlay:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 2, -2)		
--		button.overlay:SetTexCoord(0, 1, 0, 1)
--		button.overlay.Hide = function(self) self:SetVertexColor(unpack(unitdb.colors.brdColor)) end	
--
--end
--
----[element auras]
--ns:addLayoutElement(units, function(self,unit)
--	if not unitdb.auras.enable then return end
----local BlizzFrame = _G['BuffFrame']
----		BlizzFrame:UnregisterEvent('UNIT_AURA')
----		BlizzFrame:Hide()
----		BlizzFrame = _G['TemporaryEnchantFrame']
----		BlizzFrame:Hide()
--	local auras = CreateFrame('Frame',nil,self)
--	self.Auras = auras
--	auras.PostCreateIcon = postCreateIcon
--	auras.size = self:GetWidth()/unitdb.auras.count - unitdb.parent.spacing*2
--	auras.gap = true
--	auras.numBuffs = unitdb.auras.numBuffs
--	auras.numDebuffs = unitdb.auras.numDebuffs
--	auras.showType = true
--	auras.spacing = unitdb.auras.spacing
--	auras.initialAnchor = 'TOPLEFT'
--	auras['growth-x'] = 'RIGHT'
--	auras['growth-y'] = 'DOWN'
--
--	auras:SetWidth(self:GetWidth())
--	--auras:SetHeight((auras.size + unitdb.parent.spacing*2) * unitdb.auras.spacing)
--	auras:SetHeight(40)
--	auras:SetPoint('TOPLEFT',self.Castbar,'BOTTOMLEFT',0,0-unitdb.parent.spacing*2)
--end)
--
--
--
--
--

ns:addLayoutElement(units,function(self,unit)
	for key,value in pairs(unitdb.Indicators) do
		self[key] = self:CreateTexture(nil,"OVERLAY")
		style.SetIndicatorsSize(units,key)
		style.SetIndicatorsPosition(units,key)
		style.ToggleIndicators(units,key)
	end
end)


ns:addLayoutElement(units,function(self,unit)
	for key,value in pairs(unitdb.tags) do
		self.tags[key] = self:CreateFontString(nil,"OVERLAY")
		self.tags[key]:SetFontObject(ChatFontNormal)
		style.SetTagsFontSize(units,key)
		style.SetTagsFontFlag(units,key)
	end
	style.SetTagsPosition(units)

end)

ns:addLayoutElement(units,function(self,unit)
	self.CombatFeedbackText = self:CreateFontString(nil,"OVERLAY")
	self.CombatFeedbackText:SetFontObject(ChatFontNormal)
	style.SetCombatFeedbackText(units)
	style.SetCombatFeedbackTextPosition(units)
	style.ToggleCombatFeedbackText(units)
end)

ns:addLayoutElement(units,function(self,unit)
do
	style.AddSpecialElement2(units)
	style.SetSpecialElementSize(units)
	style.SetSpecialElementBorder(units)
	style.SetSpecialElementBorderColor(units)
	style.SetSpecialElementPosition(units)
end
end)


--here for testParentBackground's object using style.testParent function()
ns:addLayoutElement(units,function(self,unit)
	local testParent = CreateFrame("Frame")
	testParent.t = testParent:CreateTexture(nil,"OVERLAY")
	testParent.fs = testParent:CreateFontString(nil,"OVERLAY")

	self.testParent = testParent
	self.testParent.fs = testParent.fs
	self.testParent.t = testParent.t
end)

ns:addLayoutElement(units,function(self,unit)
	style.CopyName(units)
	style.CopyArmory(units)
end)




--here for preview's object using preview.testXXXX function()
--ns:addLayoutElement(units,function(self,unit)
--	local testFrame = CreateFrame("Frame")
--	testFrame.tex = CreateFrame("StatusBar",nil,testFrame)
--	testFrame.bg = CreateFrame("Frame",nil,testFrame)
--	
--	local testPortrait = CreateFrame("PlayerModel",nil,testFrame.bg)
--	testPortrait.background = testPortrait:CreateTexture(nil,"BACKGROUND")
--	testPortrait.border = CreateFrame("Frame",nil,testPortrait)
--
--	local testHealth = CreateFrame("Frame")
--	testHealth.tex = CreateFrame("StatusBar",nil,testHealth)
--	testHealth.background = testHealth:CreateTexture(nil,"BACKGROUND")
--	testHealth.border = CreateFrame("Frame",nil,testHealth)
--	
--	local testPower = CreateFrame("Frame")
--	testPower.tex = CreateFrame("StatusBar",nil,testPower)
--	testPower.background = testPower:CreateTexture(nil,"BACKGROUND")
--	testPower.border = CreateFrame("Frame",nil,testPower)
--
--	local testAuras = CreateFrame("Frame")
--	testAuras.background = testAuras:CreateTexture(nil,"BACKGROUND")
--	
--	local testCastbar = CreateFrame("Frame")
--	testCastbar.tex = CreateFrame("StatusBar",nil,testCastbar)
--	testCastbar.background = testCastbar:CreateTexture(nil,"BACKGROUND")
--	testCastbar.border = CreateFrame("Frame",nil,testCastbar)
--	testCastbar.Icon = testCastbar:CreateTexture(nil,"ARTWORK")
--	testCastbar.Icon.border = testCastbar:CreateTexture(nil,"ARTWORK")
--	testCastbar.Text = testCastbar.tex:CreateFontString(nil,"ARTWORK")
--
--	self.testFrame = testFrame
--	self.testFrame.tex = testFrame.tex
--	self.testFrame.bg = testFrame.bg
--	self.testPortrait = testPortrait
--	self.testPortrait.background = testPortrait.background
--	self.testPortrait.border = testPortrait.border
--	self.testHealth = testHealth
--	self.testHealth.tex = testHealth.tex
--	self.testHealth.border = testHealth.border
--	self.testHealth.background = testHealth.background
--	self.testPower = testPower
--	self.testPower.tex = testPower.tex
--	self.testPower.background = testPower.background
--	self.testPower.border = testPower.border
--	self.testAuras = testAuras
--	self.testAuras.background = testAuras.background
--	self.testCastbar = testCastbar
--	self.testCastbar.tex = testCastbar.tex
--	self.testCastbar.background = testCastbar.background
--	self.testCastbar.border = testCastbar.border
--	self.testCastbar.Icon = testCastbar.Icon
--	self.testCastbar.Icon.border = testCastbar.Icon.border
--	self.testCastbar.Text = testCastbar.Text
--	
--	local testIndicators = CreateFrame("Frame")
--	self.testIndicators = testIndicators
--	for key,value in pairs(unitdb.Indicators) do
--		testIndicators[key] = testIndicators:CreateTexture(nil,"ARTWORK")
--		self.testIndicators[key] = testIndicators[key] 
--	end
--	local testTags = CreateFrame("Frame")
--	self.testTags = testTags
--	for key,value in pairs(unitdb.tags) do
--		testTags[key] = testTags:CreateFontString(nil,"ARTWORK")
--		self.testTags[key] = testTags[key]
--	end
--	
--	local TestList = {} 
--	for key,value in next,self do
--		if string.find(key,"^test%u") then
--			table.insert(TestList,key)	
--		end
--	end
--	self.TestList = TestList
--	
--	preview.testUnit["player"](units)
--	preview.toggleTestObj(units,false)
--end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)

----expbar
--ns:addLayoutElement(units, function(self, unit)
--	if not unitdb.expBar.enable or UnitLevel("player") == MAX_PLAYER_LEVEL then return end
--    local bar = CreateFrame("StatusBar", nil, self.bg)
--		utils.setSize(bar,unitdb.parent.width,unitdb.expBar.height)
--		--print(bar:GetWidth() == unitdb.expBar.width)
--		--print(unitdb.parent.width == self:GetWidth())
--		--print(bar:GetWidth(),self:GetWidth(),unitdb.expBar.width)
--		--bar:SetHeight(unitdb.expBar.height)
--    --bar:SetWidth(unitdb.expBar.width)
--    bar:SetPoint('BOTTOMLEFT',self,'TOPLEFT', 0, 2)
--
--    bar:SetStatusBarTexture(unitdb.tex.barTex)
--		bar:SetStatusBarColor(0, .39, .88)
--
--    local bg = bar:CreateTexture(nil, "BORDER")
--    bar.bg = bg
--    bg:SetVertexColor(.58, 0, .55)
--    bg:SetTexture(unitdb.tex.barTex)
--
--
--    --[[local text = bar:CreateFontString(nil, "OVERLAY")
--    bar.Text = text
--    text:SetFontObject(GameFontNormalSmall)
--    do
--        local font, size, flag = text:GetFont()
--        text:SetFont(font, size-5, flag)
--    end
--    text:SetPoint("CENTER", bar, 0, 1)]]
--	
--	self.expbar = bar
--
--    if UnitLevel"player" ~= MAX_PLAYER_LEVEL then
--        local function onEvent(self)
--            if UnitLevel"player" == MAX_PLAYER_LEVEL then
--                self:DisableElement("Exp")
--                self.Exp = nil
--                self.Faction = bar
--                self:EnableElement("Faction")
--                bar.bg:Hide()
--                self:UnregisterEvent("PLAYER_LEVEL_UP", onEvent)
--            end
--        end
--        self:RegisterEvent("PLAYER_LEVEL_UP", onEvent)
--        self.Exp = bar
--    else
--        self.Faction = bar
--        bar.bg:Hide()
--    end
--end)
--
--[[===Spawn===]]--




--local moveFrame = CreateFrame("Frame")
--	moveFrame:SetPoint(position.selfPoint,position.anchorTo,position.relativePoint,position.x,position.y)
--ns:addLayoutElement(units,function(self)
--	moveFrame.tex = moveFrame:CreateTexture(nil,"OVERLAY")
--	--moveFrame:SetAllPoints(UIParent)
--	moveFrame:SetWidth(unitdb.Parent.width)
--	moveFrame:SetHeight(unitdb.Parent.height)
--	moveFrame:EnableMouse(true)
--	moveFrame:SetMovable(true)
--	moveFrame.tex:SetTexture(1,1,1,.5)
--	moveFrame.tex:SetAllPoints(moveFrame)
--	moveFrame:SetScript("OnMouseDown",function(self,button) 
--		if button == "LeftButton" and IsLeftControlKeyDown() then
--		print(GetMouseFocus():GetName())
--			--	local cX,cY = GetCursorPosition()
--		--print(cX,cY)
--		--moveFrame:StartMoving()
--		--ns.unitFrames.player:SetPoint("TOPLEFT",moveFrame)
--		--elseif button == "RightButton" then
--			--print(GetMouseFocus():GetName())
--	
--		end
--end)
--moveFrame:SetScript("OnMouseUp",function() moveFrame:StopMovingOrSizing() end)
--
--end)



local frame 
ns:addLayoutElement(units,function(self)
	frame = self
end)
ns:spawn(function()
	local f = oUF:Spawn("player", "wsUnitFrame_Player")
	ns.frameList[f] = true
	ns.unitFrames.player = f
	frame = f
	return f;
end)

ns:RegisterUnitOptions("player",{
	type = "group",
	name = L["player"],
	childGroups = "tab",
	order = ns.order(),
	args = {
		--	preview = {
		--		type = "toggle",
		--		name = L["Preview Mode"],
		--		desc = L["Preview Mode"],
		--		get = function() return ns.unitFrames[units].testFrame:IsShown() end,
		--		set = function(_,v)
		--			preview.toggleTestObj(units,v)	
		--		end,
		--	},
			Parent = {
				type = "group",
				order = ns.order(),
				name = L["Parent"],
				desc = L["Parent"],
				args = {
					width = {
						type = "range",
						name = L["Width"],
						desc = L["Width"],
						order = ns.order(),
						min = 1,max = 800,step = 1,
						get = function() return unitdb.Parent.width end,
						set = function(_,v)
							style.TestParent(units)
							style.SetElementSize(units,v,"width","Parent")	
						end,
					},
					height = {
						type = "range",
						name = L["Height"],
						desc = L["Height"],
						order = ns.order(),
						min = 1,max = 800,step = 1,
						get = function() return unitdb.Parent.height end,
						set = function(_,v)
							style.TestParent(units)
							style.SetElementSize(units,v,"height","Parent")
						end,
					},
					--color = {},
					--border = {},
				},
			},
			Portrait = {
				type = "group",
				order = ns.order(),
				name = L["Portrait"],
				desc = L["Portrait"],
				args = {
					size = {
						type = "group",
						inline = true,
						order = ns.order(),
						name = L["Size"],
						desc = L["Size"],
						args = {
							width = {
								type = "range",
								name = L["Width"],
								desc = L["Width"],
								order = ns.order(),
								min = 2,max = 800,step = 1,
								get = function() return unitdb.Portrait.width end,
								set = function(_,v)
									--style.TestParent(units)
									style.SetElementSize(units,v,"width","Portrait")
								end,
							},
							height = {
								type  = "range",
								name = L["Height"],
								desc = L["Height"],
								order = ns.order(),
								min = 2,max = 800,step = 1,
								get = function() return unitdb.Portrait.height end,
								set = function(_,v)
									--style.TestParent(units)
									style.SetElementSize(units,v,"height","Portrait")
								end,
							},
						},
					},
					position = {
						type = "group",
						name = L["Posistion"],
						desc = L["Posistion"],
						inline = true,
						order = ns.order(),
						args = {
						--	point = {
						--		type = "select",
						--		name = L["Point"],
						--		desc = L["Point"],
						--		order = ns.order(),
						--		values = style.PortraitPositionValue(),
						--		get = function() return unitdb.Portrait.position.point end,
						--		set = function(_,v)
						--			style.TestParent(units)
						--			style.SetPortraitPosition(units,_,_,v)
						--		end,
						--	},
							x = {
								type = "range",
								name = L["x"],
								desc = L["x"],
								order = ns.order(),
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Portrait.position.x end,
								set = function(_,v) 
								--	style.TestParent(units)
								style.SetPortraitPosition(units,v,unitdb.Portrait.position.y)
								end,
							},
							y = {
								type = "range",
								name = L["y"],
								desc = L["y"],
								order = ns.order(),
								min = -800, max = 800, step = 1,
								get = function() return unitdb.Portrait.position.y end,
								set = function(_,v)
									--style.TestParent(units)
									style.SetPortraitPosition(units,unitdb.Portrait.position.x,v)
								end,
							},
						},
					},
					frameLevel = {
						type = "range",
						name = L["FrameLevel"],
						desc = L["FrameLevel"],
						order = ns.order(),
						min = 1, max = 99,step = 1,
						get = function() return unitdb.Portrait.frameLevel end,
						set = function(_,v) 
							style.SetElementFrameLevel(units,"Portrait",v)
						end,
					},
					background = {
						type = "group",
						name = L["Background"],
						desc = L["Background"],
						order = ns.order(),
						inline = true,
						args = {
							color = {
								type = "color",
								name = L["Color"],
								desc = L["Color"],
								order = ns.order(),
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Portrait.background.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Portrait","background",r,g,b,a)
								end,
							},
						},
					},
					border = {
						type = "group",
						inline = true,
						order = ns.order(),
						name = L["Border"],
						desc = L["Border"],
						args = {
							thickness = {
								type = "range",
								order = ns.order(),
								name = L["Thickness"],
								desc = L["Thickness"],
								min = 0, max = 10, step =1,
								get = function() return unitdb.Portrait.border.value end,
								set = function(_,v) 
									style.SetElementBorderValueAndTextureAndColor(units,"Portrait",v,unitdb.tex.borderTex,unitdb.Portrait.border.color)
								end,
							},
							color = {
								type = "color",
								order = ns.order(),
								name = L["Color"],
								desc = L["Color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Portrait.border.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Portrait","border",r,g,b,a)
								end,
							},
						},
					},
				},
			},
			Health = {
				type = "group",
				order = ns.order(),
				name = L["Health"],
				desc = L["Health"],
				args = {
					size = {
						type = "group",
						inline = true,
						order = ns.order(),
						name = L["Size"],
						desc = L["Size"],
						args = {
							width = {
								type = "range",
								name = L["Width"],
								desc = L["Width"],
								min = 2,max = 800, step = 1,
								order = ns.order(),
								get = function() return unitdb.Health.width end,
								set = function(_,v)
									style.SetElementSize(units,v,"width","Health")
								end,
							},
							height = {
								type = "range",
								name = L["Height"],
								desc = L["Height"],
								min = 2, max = 800, step = 1,
								get = function() return unitdb.Health.height end,
								set = function(_,v)
									style.SetElementSize(units,v,"height","Health")
								end,
							},
						},
					},
					position = {
						type = "group",
						name = L["Posistion"],
						desc = L["Posistion"],
						order = ns.order(),
						inline = true,
						args = {
							x = {
								type = "range",
								name = L["x"],
								desc = L["y"],
								order = ns.order(),
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Health.position.x end,
								set = function(_,v)
									style.SetHealthPosition(units,unitdb.Portrait.position.point,v,unitdb.Health.position.y)
								end,
							},
							y = {
								type = "range",
								name = L["y"],
								desc = L["y"],
								order = ns.order(),
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Health.position.y end,
								set = function(_,v) 
									style.SetHealthPosition(units,unitdb.Portrait.position.point,unitdb.Health.position.x,v)
								end,
							},
						},
					},
					background = {
						type = "group",
						name = L["Background"],
						desc = L["Background"],
						inline = true,
						order = ns.order(),
						args = {
							color = {
								type = "color",
								name = L["Color"],
								desc = L["Color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Health.background.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Health","background",r,g,b,a)	
								end,
							},
						},
					},
					border = {
						type = "group",
						inline = true,
						name = L["Border"],
						desc = L["Border"],
						order = ns.order(),
						args = {
							thickness = {
								type = "range",
								name = L["Thickness"],
								desc = L["Thickness"],
								order = ns.order(), 
								min = 0, max = 10, step = 1,
								get = function() return unitdb.Health.border.value end,
								set = function(_,v)
									style.SetElementBorderValueAndTextureAndColor(units,"Health",v,unitdb.tex.borderTex,unitdb.Health.border.color)
								end,
							},
							color = {
								type = "color",
								name = L["Color"],
								desc = L["Color"],
								order = ns.order(),
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Health.border.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Health","border",r,g,b,a)
								end,
							},
						},
					},
					frameLevel = {
						type = "range",
						order = ns.order(),
						name = L["FrameLevel"],
						desc = L["FrameLevel"],
						min = 1, max = 99, step = 1,
						get = function() return unitdb.Health.frameLevel end,
						set = function(_,v)
							style.SetElementFrameLevel(units,"Health",v)
						end,
					},
					alpha = {
						type = "range",
						order = ns.order(),
						name = L["Alpha"],
						desc = L["Alpha"],
						min = 0, max = 1, step = 0.01,
						isPercent = true,
						get = function() return unitdb.Health.alpha end,
						set = function(_,v)
							style.SetElementAlpha(units,"Health",v)
						end,
					},
					hpColor = {
						type = "group",
						name = L["Health color"],
						desc = L["Health color"],
						order = ns.order(),
						inline = true,
						args = {
							colorType = {
								type = "select",
								name = L["Color type"],
								desc = L["Color type"],
								values = {["colorClass"] = L["colorClass"],["colorSmooth"] = L["colorSmooth"],["colorHealth"] = L["colorHealth"],},
								get = function() return unitdb.Health.color end,
								set = function(_,v)  
									style.forceUpdateHP(units,v,unitdb.Health.colorH)
								end,
							},
							colorHealth = {
								type = "color",
								name = L["Custom color"],
								desc = L["Custom color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Health.colorH) end,
								set = function(_,r,g,b,a)
									style.setHpColor(units,r,g,b,a)
								end,
							},
						},
					},
					
				},
			},
			Power = {
				type = "group",
				order = ns.order(),
				name = L["Power"],
				desc = L["Power"],
				args = {
					size = {
						type = "group",
						inline = true,
						order = ns.order(),
						name = L["Size"],
						desc = L["Size"],
						args = {
							width = {
								type = "range",
								name = L["Width"],
								desc = L["Width"],
								min = 2, max = 800, step = 1,
								get = function() return unitdb.Power.width end,
								set = function(_,v)
									style.SetElementSize(units,v,"width","Power")
								end,
							},
							height = {
								type = "range",
								name = L["Height"],
								desc = L["Height"],
								min = 2, max = 800, step = 1,
								get = function() return unitdb.Power.height end,
								set = function(_,v)
									style.SetElementSize(units,v,"height","Power")
								end,
							},
						},
					},
					position = {
						type = "group",
						name = L["Posistion"],
						desc = L["Posistion"],
						order = ns.order(),
						inline = true,
						args = {
							x = {
								type = "range",
								name = L["x"],
								desc = L["y"],
								order = ns.order(),
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Power.position.x end,
								set = function(_,v)
									style.SetPowerPosition(units,unitdb.Portrait.position.point,v,unitdb.Power.position.y)
								end,
							},
							y = {
								type = "range",
								name = L["y"],
								desc = L["y"],
								order = ns.order(),
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Power.position.y end,
								set = function(_,v) 
									style.SetPowerPosition(units,unitdb.Portrait.position.point,unitdb.Power.position.x,v)
								end,
							},
						},
					},
					ppColor = {
						type = "group",
						name = L["Power color"],
						desc = L["Power color"],
						order = ns.order(),
						inline = true,
						args = {
							colorType = {
								type = "select",
								name = L["Color type"],
								desc = L["Color type"],
								values = {["colorClass"] = L["colorClass"],["colorPower"] = L["colorPower"],["colorCustom"] = L["colorCustom"]},
								get = function() return unitdb.Power.color end,
								set = function(_,v)  
									style.forceUpdatePower(units,v,unitdb.Power.colorP)
								end,
							},
							colorPower = {
								type = "color",
								name = L["Custom color"],
								desc = L["Custom color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Power.colorP) end,
								set = function(_,r,g,b,a)
									style.setPpColor(units,r,g,b,a)
									--style.setHpColor(units,r,g,b,a)
								end,
							},
						},
					},
					background = {
						type = "group",
						name = L["Background"],
						desc = L["Background"],
						inline = true,
						order = ns.order(),
						args = {
							color = {
								type = "color",
								name = L["Color"],
								desc = L["Color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Power.background.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Power","background",r,g,b,a)	
								end,
							},
						},
					},
					border = {
						type = "group",
						inline = true,
						name = L["Border"],
						desc = L["Border"],
						order = ns.order(),
						args = {
							thickness = {
								type = "range",
								name = L["Thickness"],
								desc = L["Thickness"],
								order = ns.order(), 
								min = 0, max = 10, step = 1,
								get = function() return unitdb.Power.border.value end,
								set = function(_,v)
									style.SetElementBorderValueAndTextureAndColor(units,"Power",v,unitdb.tex.borderTex,unitdb.Power.border.color)
								end,
							},
							color = {
								type = "color",
								name = L["Color"],
								desc = L["Color"],
								order = ns.order(),
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Power.border.color) end,
								set = function(_,r,g,b,a)
									style.setColor(units,"Power","border",r,g,b,a)
								end,
							},
						},
					},
					frameLevel = {
						type = "range",
						order = ns.order(),
						name = L["FrameLevel"],
						desc = L["FrameLevel"],
						min = 1, max = 99, step = 1,
						get = function() return unitdb.Power.frameLevel end,
						set = function(_,v)
							style.SetElementFrameLevel(units,"Power",v)
						end,
					},
					alpha = {
						type = "range",
						order = ns.order(),
						name = L["Alpha"],
						desc = L["Alpha"],
						min = 0, max = 1, step = 0.01,
						isPercent = true,
						get = function() return unitdb.Power.alpha end,
						set = function(_,v)
							style.SetElementAlpha(units,"Power",v)
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
					size  ={
						type = "group",
						order = ns.order(),
						inline = true,
						name = L["Size"],
						desc = L["Size"],
						args = {
							width = {
								type = "range",
								name = L["Width"],
								desc = L["Width"],
								order = ns.order(),
								min = 2,max = 800,step = 1,
								get = function() return unitdb.Castbar.width end,
								set = function(_,v)
									style.SetElementSize(units,v,"width","Castbar")
								end,
							},
							height = {
								type = "range",
								name = L["Height"],
								desc = L["Height"],
								min = 2, max = 800,step = 1,
								get = function() return unitdb.Castbar.height end,
								set = function(_,v) 
									style.SetElementSize(units,v,"height","Castbar")
								end,
							},
						},
					},
					position = {
						type = "group",
						order = ns.order(),
						inline = true,
						name = L["Posistion"],
						desc = L["Posistion"],
						args = {
							x = {
								type = "range",
								name = L["x"],
								desc = L["x"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Castbar.position.x end,
								set = function(_,v)
									style.SetCastbarPosition(units,v,unitdb.Castbar.position.y)
								end,
							},
							y = {
								type = "range",
								name = L["y"],
								desc = L["y"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Castbar.position.y end,
								set = function(_,v)
									style.SetCastbarPosition(units,unitdb.Castbar.position.x,v)
								end,	
							},
						},
					},
					cbColor = {
						type = "group",
						order = ns.order(),
						inline = true,
						name = L["Color"],
						desc = L["Color"],
						args = {
							color = {
								type = "color",
								order = ns.order(),
								name = L["Color"],
								desc = L["Color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Castbar.color) end,
								set = function(_,r,g,b,a)
									style.setCbColor(units,r,g,b,a)
								end,
							},
						},
					},
					border = {
						type = "group",
						order = ns.order(),
						name = L["Background and border"],
						desc = L["Background and border"],
						inline = true,
						args ={
							color = {
								type = "color",
								order = ns.order(),
								name = L["Color"],
								desc = L["Color"],
								hasAlpha = true,
								get = function() return style.getColor(unitdb.Castbar.background.color) end,
								set = function(_,r,g,b,a)
									style.SetCastbarBorder(units,unitdb.Castbar.background.value,r,g,b,a)
								end,
							},
							thickness = {
								type = "range",
								order = ns.order(),
								name = L["Thickness"],
								desc = L["Thickness"],
								min = 0, max = 10, step = 1,
								get = function() return unitdb.Castbar.background.value end,
								set = function(_,v)
										style.SetCastbarBorder(units,v,unitdb.Castbar.background.color[1],unitdb.Castbar.background.color[2],unitdb.Castbar.background.color[3],unitdb.Castbar.background.color[4])
								end,
							},
						},
					},
				
				Icon = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["CastbarIcon"],
					desc = L["CastbarIcon"],
					args = {
						size = {
							type = "group",
							name = L["Size"],
							desc = L["Size"],
							order = ns.order(),
							inline = true,
							args = {
								size = {
									type = "range",
									order = ns.order(),
									name = L["Size"],
									desc = L["Size"],
									min = 1, max = 400,step =1,
									get = function() return unitdb.Castbar.Icon.size end,
									set = function(_,v)
										style.SetCastbarIconSize(units,v)
									end,
								},
							},
						},
						position = {
							type = "group",
							order = ns.order(),
							inline = true,
							name = L["Posistion"],
							desc = L["Posistion"],
							args = {
								x = {
									type = "range",
									order = ns.order(),
									name = L["x"],
									desc = L["x"],
									min = -800, max = 800, step = 1,
									get = function() return unitdb.Castbar.Icon.position.x end,
									set = function(_,v)
										style.SetCastbarIconPosition(units,unitdb.Castbar.Icon.position.point,v,unitdb.Castbar.Icon.position.y)
									end,
								},
								y = {
									type = "range",
									order = ns.order(),
									name = L["y"],
									desc = L["y"],
									min = -800, max = 800, step = 1,
									get = function() return unitdb.Castbar.Icon.position.y end,
									set = function(_,v)
										style.SetCastbarIconPosition(units,unitdb.Castbar.Icon.position.point,unitdb.Castbar.Icon.position.x,v)
									end,
								},
							},
						},
					},
				},
				Text = {
					type = "group",
					order = ns.order(),
					name = L["Castbar Text"],
					desc = L["Castbar Text"],
					inline = true,
					args = {
						flag = {
							type = "select",
							name = L["Text Flag"],
							desc = L["Text Flag"],
							order = ns.order(),
							values = style.FontFlagValue(),
							get = function() return unitdb.Castbar.Text.flag end,
							set = function(_,v)
									style.SetCastbarText(units,unitdb.Castbar.Text.position.x,unitdb.Castbar.Text.position.y,v,unitdb.Castbar.Text.fontSize)
							end,
						},
						fontSize = {
							type = "range",
							order = ns.order(),
							name = L["Font size"],
							desc = L["Font size"],
							min = 1, max = 64,step = 1,
							get = function() return unitdb.Castbar.Text.fontSize end,
							set = function(_,v)
								style.SetCastbarText(units,unitdb.Castbar.Text.position.x,unitdb.Castbar.Text.position.y,unitdb.Castbar.Text.flag,v)
							end,
						},
						position = {
							type = "group",
							name = L["Posistion"],
							desc = L["Posistion"],
							order = ns.order(),
							inline = true,
							args = {
								x = {
									type = "range",
									name = L["x"],
									desc = L["x"],
									order = ns.order(),
									min = -800, max = 800,step = 1,
									get = function() return unitdb.Castbar.Text.position.x end,
									set = function(_,v)
										style.SetCastbarText(units,v,unitdb.Castbar.Text.position.y,unitdb.Castbar.Text.flag,unitdb.Castbar.Text.fontSize)
									end,
								},
								y = {
									type = "range",
									name = L["y"],
									desc = L["y"],
									order = ns.order(),
									min = -800, max = 800,step = 1,
									get = function() return unitdb.Castbar.Text.position.y end,
									set = function(_,v)
										style.SetCastbarText(units,unitdb.Castbar.Text.position.x,v,unitdb.Castbar.Text.flag,unitdb.Castbar.Text.fontSize)
									end,
								},
							},
						},
					},
				},
				},
			},
			Indicators = {
				type = "group",
				order = ns.order(),
				name = L["Indicators"],
				desc = L["Indicators"],
				args = style.IndicatorsConfig(units)
			},
			tags = {
				type = "group",
				order = ns.order(),
				name = L["Tags"],
				desc = L["Tags"],
				args = style.TagsConfig(units),
			},
			CombatFeedbackText = {
				type = "group",
				order = ns.order(),
				name = L["CombatFeedbackText"],
				desc = L["CombatFeedbackText"],
				args = {
				--	enable = {
				--		type = "toggle",
				--		order = ns.order(),
				--		name = L["Enable"],
				--		desc = L["Enable"],
				--		get = function() return unitdb.CombatFeedbackText.enable end,
				--		set = function(_,v)
				--			style.ToggleCombatFeedbackText(units,v)
				--		end,
				--	},
					fontSize = {
						type = "range",
						order = ns.order(),
						name = L["Font size"],
						desc = L["Font size"],
						min = 1, max = 64, step = 1,
						get = function() return unitdb.CombatFeedbackText.fontSize end,
						set = function(_,v)
							style.SetCombatFeedbackText(units,v,unitdb.CombatFeedbackText.flag)
						end,
					},
					flag = {
						type = "select",
						order = ns.order(),
						name = L["Font flag"],
						desc = L["Font flag"],
						values = style.FontFlagValue(),
						get = function() return unitdb.CombatFeedbackText.flag end,
						set = function(_,v) 
							style.SetCombatFeedbackText(units,unitdb.CombatFeedbackText.fontSize,v)
						end,
					},
					position = {
						type = "group",
						order = ns.order(),
						inline = true,
						name = L["Posistion"],
						desc = L["Posistion"],
						args = {
							x = {
								type = "range",
								order = ns.order(),
								name = L["x"],
								desc = L["x"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.CombatFeedbackText.position.x end,
								set = function(_,v)
									style.SetCombatFeedbackTextPosition(units,v,unitdb.CombatFeedbackText.position.y)
								end,
							},
							y = {
								type = "range",
								order = ns.order(),
								name = L["y"],
								desc = L["y"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.CombatFeedbackText.position.y end,
								set = function(_,v)
									style.SetCombatFeedbackTextPosition(units,unitdb.CombatFeedbackText.position.x,v)
								end,
							},
						},
					},
				},
			},
			Combat = {
				type = "group",
				order = ns.order(),
				name = L["Combat Icon"],
				desc = L["Combat Icon"],
				args = {
					size = {
						type = "range",
						order = ns.order(),
						name = L["Size"],
						desc = L["Size"],
						get = function() return unitdb.Combat.size end,
						set = function(_,v)
							style.SetCombatIconSize(units,v)
						end,
					},
					position = {
						type = "group",
						order = ns.order(),
						inline = true,
						name = L["Posistion"],
						desc = L["Posistion"],
						args = {
							x = {
								type = "range",
								order = ns.order(),
								name = L["x"],
								desc = L["x"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Combat.position.x end,
								set = function(_,v)
									style.SetCombatIconPosition(units,v,unitdb.Combat.position.y)
								end,
							},
							y = {
								type = "range",
								order = ns.order(),
								name = L["y"],
								desc = L["y"],
								min = -800,max = 800,step = 1,
								get = function() return unitdb.Combat.position.y end,
								set = function(_,v)
									style.SetCombatIconPosition(units,unitdb.Combat.position.x,v)
								end,
							},
						},
					},
				},
			},
			SpecialElement = {
				disabled = style.showSpecialElementMenu(),
				type = "group",
				order = ns.order(),
				name = L["SpecialElement"],
				desc = L["SpecialElement"],
				args = {
						size = {
							type = "group",
							inline = true,
							order = ns.order(),
							name = L["Size"],
							desc = L["Size"],
							args = {
								width = {
									type = "range",
									order = ns.order(),
									name = L["Width"],
									desc = L["Width"],
									min = 2, max = 800, step = 1,
									get = function() return unitdb.SpecialElement.width end,
									set = function(_,v)
										style.SetSpecialElementSize(units,v,unitdb.SpecialElement.height,unitdb.SpecialElement.border.value)
									end,
								},
								height = {
									type = "range",
									order = ns.order(),
									name = L["Height"],
									desc = L["Height"],
									min = 2, max = 800, step = 1,
									get = function() return unitdb.SpecialElement.height end,
									set = function(_,v)
										style.SetSpecialElementSize(units,unitdb.SpecialElement.width,v,unitdb.SpecialElement.border.value)
									end,
								},
							},
						},
						position = {
							type = "group",
							order = ns.order(),
							name = L["Posistion"],
							desc = L["Posistion"],
							inline = true,
							args = {
								x = {
									type = "range",
									name = L["x"],
									desc = L["x"],
									order = ns.order(),
									min = -800, max = 800, step = 1,
									get = function() return unitdb.SpecialElement.position.x end,
									set = function(_,v)
										style.SetSpecialElementPosition(units,v,unitdb.SpecialElement.position.y,unitdb.SpecialElement.position.xOffset,unitdb.SpecialElement.position.yOffset)
									end,
								},
								y = {
									type = "range",
									name = L["y"],
									desc = L["y"],
									order = ns.order(),
									min = -800, max = 800, step = 1,
									get = function() return unitdb.SpecialElement.position.y end,
									set = function(_,v)
										style.SetSpecialElementPosition(units,unitdb.SpecialElement.position.x,v,unitdb.SpecialElement.position.xOffset,unitdb.SpecialElement.position.yOffset)
									end,
								},
								xOffset = {
									type = "range",
									name = L["xOffset"],
									desc = L["xOffset"],
									order = ns.order(),
									min = 1, max = 400, step = 1,
									get = function() return unitdb.SpecialElement.position.xOffset end,
									set = function(_,v)
										style.SetSpecialElementPosition(units,unitdb.SpecialElement.position.x,unitdb.SpecialElement.position.y,v,unitdb.SpecialElement.position.yOffset)
									end,
								},
							},
						},
						border = {
							type = "group",
							order = ns.order(),
							inline = true,
							name = L["Border"],
							desc = L["Border"],
							args = {
								thickness = {
									type = "range",
									order = ns.order(),
									name = L["Thickness"],
									desc = L["Thickness"],
									min = 0, max = 10, step = 1,
									get = function() return unitdb.SpecialElement.border.value end,
									set = function(_,v)
										style.SetSpecialElementBorder(units,v)
									end,
								},
								color = {
									type = "color",
									order = ns.order(),
									name = L["Color"],
									desc = L["Color"],
									hasAlpha = true,
									get = function() return style.getColor(unitdb.SpecialElement.border.color) end,
									set = function(_,r,g,b,a)
										style.SetSpecialElementBorderColor(units,r,g,b,a)
									end,
								},
							},
						},
				},
			},
	},

})



