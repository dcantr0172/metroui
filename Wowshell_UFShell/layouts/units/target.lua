-- susnow
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local style = ns.style
local preview = ns.preview

local position = ns:RegisterUnitPosition("target",{
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_Player",
	relativePoint = "TOPRIGHT",
	x = 70,
	y = 0
})

local unitdb = ns:RegisterUnitDB("target",{
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
				point = "LEFT",
				x = -10,
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
		numBuffs = 20,
		numDebuffs = 20,
		spacing = 6,
		count = 8,
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
	CPoints = {
		width = 166,
		height = 2,
		position = {
			x = 49,
			y = -28,
			xOffset = 1,
			yOffset = 0
		},

		border = {
			value = 1,
			color = {0,0,0,1},
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

local units = "target"

ns:setSize(units, unitdb.Parent.width, unitdb.Parent.height,unitdb.Parent.scale)

--[[===Style===]]--
--[Portrait]
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
	self.Health.colorReaction = true
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

--ns:addLayoutElement(units,function(self,unit)
--	self.Combat = self:CreateTexture(nil,"OVERLAY")
--	style.AddCombatIcon(units)
--	style.SetCombatIconSize(units)
--	style.SetCombatIconPosition(units)
--end)

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


--ns:addLayoutElement(units, function(self, unit)
--    -- threat text
--    local threat = CreateFrame("Frame", nil, self);
--    utils.setSize(threat, 32, 14);
--		threat:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 0, 0);
--
--    local text = threat:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
--		do 
--			local font,size,flag = text:GetFont()
--			text:SetFont(font,size-2,'OUTLINE')
--		end
--		text:SetText("100%");
--    text:SetPoint("CENTER", 0, 0);
--    threat:Hide()
--    local onevent = function(self)
--        if UnitExists"target" and UnitCanAttack("player", "target") then
--            threat.nextUpdate = 0
--            threat:Show()
--        else
--            threat:Hide()
--        end
--    end
--
--    tinsert(self.__elements, onevent)
--
--    threat.nextUpdate = 0
--    threat:SetScript("OnUpdate", function(self, elapsed)
--        self.nextUpdate = self.nextUpdate - elapsed
--        if self.nextUpdate <= 0 then
--            self.nextUpdate = .5
--
--            local isTanking, status, pct = UnitDetailedThreatSituation(PlayerFrame.unit, "target")
--            if isTanking then
--				pct = 100
--			end
--
--            if not status then
--                status = 0
--            end
--            pct = pct or 0
--
--            local r,g,b = GetThreatStatusColor(status)
--            if r then
--                text:SetTextColor(r, g, b)
--            end
--
--            text:SetFormattedText("%d %%", pct)
--        end
--    end)
--end)

ns:addLayoutElement(units,function(self,unit)
	self.CPoints = CreateFrame("Frame",nil,self)
	style.AddComboPoints(units)
	style.SetComboPointsSize(units)
	style.SetComboPointsPosition(units)
	style.SetComboPointsBorder(units)
	style.SetComboPointsBorderColor(units)
end)

ns:addLayoutElement(units, function(self, unit)
	self.Auras = CreateFrame('Frame',nil,self)
	self.Auras.PostCreateIcon = style.postCreateIcon
	style.SetAurasSize(units)
	style.SetAurasPosition(units)
	style.SetAurasSpacing(units)
	style.SetAurasGrowth(units)
	self.Auras.PostUpdateIcon = style.postUpdateIcon	
end)

ns:addLayoutElement(units,function(self,unit)
	style.CopyName(units)
	style.CopyArmory(units)
end)

ns:addLayoutElement(units,function(self,unit)
	local testParent = CreateFrame("Frame")
	testParent.t = testParent:CreateTexture(nil,"OVERLAY")
	testParent.fs = testParent:CreateFontString(nil,"OVERLAY")

	self.testParent = testParent
	self.testParent.fs = testParent.fs
	self.testParent.t = testParent.t
end)

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
--	preview.testUnit["target"](units)
--	preview.toggleTestObj(units,false)
--end)

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

ns:spawn(function()
	local f = oUF:Spawn("target", "wsUnitFrame_Target")
	ns.frameList[f] = true
	ns.unitFrames.target = f

	return f;
end)

ns:RegisterUnitOptions("target",{
	type = "group",
	name = L["target"],
	childGroups = "tab",
	order = ns.order(),
	args = {
	--	preview = {
	--			type = "toggle",
	--			name = L["Preview Mode"],
	--			desc = L["Preview Mode"],
	--			get = function() return ns.unitFrames[units].testFrame:IsShown() end,
	--			set = function(_,v)
	--				preview.toggleTestObj(units,v)	
	--			end,
	--		},
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
		ComboPoint = {
			disabled = style.showComboPointMenu(),
			type = "group",
			order = ns.order(),
			name = L["ComboPoint"],
			desc = L["ComboPoint"],
			args = {
				size = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Size"],
					desc = L["Size"],
					args = {
						width = {
							type = "range",
							order = ns.order(),
							name = L["Width"],
							desc = L["Width"],
							min = 1, max = 800, step = 1,
							get = function() return unitdb.CPoints.width end,
							set = function(_,v)
								style.SetComboPointsSize(unit,v,unitdb.CPoints.height)
							end,
						},
						height = {
							type = "range",
							order = ns.order(),
							name = L["Height"],
							desc = L["Height"],
							min = 1, max = 800, step = 1,
							get = function() return unitdb.CPoints.height end,
							set = function(_,v)
								style.SetComboPointsSize(unit,unitdb.CPoints.width,v)
							end,
						},
					},
				},	
				position = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Position"],
					desc = L["Position"],
					args = {
						x = {
							type = "range",
							order = ns.order(),
							name = L["x"],
							desc = L["x"],
							min = -800,max = 800,step = 1,
							get = function() return unitdb.CPoints.position.x end,
							set = function(_,v)
								style.SetComboPointsPosition(units,v,unitdb.CPoints.position.y,unitdb.CPoints.position.xOffset,unitdb.CPoints.position.yOffset)
							end,
						},
						y = {
							type = "range",
							order = ns.order(),
							name = L["y"],
							desc = L["y"],
							min = -800, max = 800, step = 1,
							get = function() return unitdb.CPoints.position.y end,
							set = function(_,v)
								style.SetComboPointsPosition(units,unitdb.CPoints.position.x,v,unitdb.CPoints.position.xOffset,unitdb.CPoints.position.yOffset)
							end,
						},
						xOffset = {
							type = "range",
							order = ns.order(),
							name = L["xOffset"],
							desc = L["xOffset"],
							get = function() return unitdb.CPoints.position.xOffset end,
							set = function(_,v)
								style.SetComboPointsPosition(units,unitdb.CPoints.position.x,unitdb.CPoints.position.y,v,unitdb.CPoints.position.yOffset)
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
							get = function() return unitdb.CPoints.border.value end,
							set = function(_,v) 
								style.SetComboPointsBorder(units,v)	
							end,
						},
						color = {
							type = "color",
							order = ns.order(),
							name = L["Color"],
							desc = L["Color"],
							get = function() return style.getColor(unitdb.CPoints.border.color) end,
							set = function(_,r,g,b,a)
								style.SetComboPointsBorderColor(units,r,g,b,a)
							end,
						},
					},
				},
			},
		},
		Auras = {
			type = "group",
			order = ns.order(),
			name = L["Auras"],
			desc = L["Auras"],
			args = {
				size = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Size"],
					desc = L["Size"],
					args = {
						width = {
							type = "range",
							order = ns.order(),
							name = L["Width"],
							desc = L["Width"],
							min = 1, max = 800, step = 1,
							get = function() return unitdb.Auras.width end,
							set = function(_,v)
								style.SetAurasSize(units,v,unitdb.Auras.height)
							end,
						},
						height = {
							type = "range",
							order = ns.order(),
							name = L["Height"],
							desc = L["Height"],
							min = 1, max = 800, step = 1,
							get = function() return unitdb.Auras.height end,
							set = function(_,v)
								style.SetAurasSize(units,unitdb.Auras.width,v)
							end,
						},
					},
				},
				position = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Position"],
					desc = L["Position"],
					args = {
						x = {
							type = "range",
							order = ns.order(),
							name = L["x"],
							desc = L["x"],
							min = -800,max = 800,step = 1,
							get = function() return unitdb.Auras.position.x end,
							set = function(_,v) 
								style.SetAurasPosition(units,v,unitdb.Auras.position.y)
							end,
						},
						y = {
							type = "range",
							order = ns.order(),
							name = L["y"],
							desc = L["y"],
							min = -800,max = 800,step = 1,
							get = function() return unitdb.Auras.position.y end,
							set = function(_,v) 
								style.SetAurasPosition(units,unitdb.Auras.position.x,v)
							end,
						},
					},
				},
				count = {
					type = "group",
					name = L["Count"],
					desc = L["Count"],
					order = ns.order(),
					inline = true,
					args = {
						buffs = {
							type = "range",
							order = ns.order(),
							name = L["Buffs"],
							desc = L["Buffs"],
							min = 1, max = 40,step = 1,
							get = function() return unitdb.Auras.numBuffs end,
							set = function(_,v)
								style.SetAurasBuffsCount(units,v)	
							end,
						},
						debuffs = {
							type = "range",
							order = ns.order(),
							name = L["Debuffs"],
							desc = L["Debuffs"],
							min = 1, max = 40,step = 1,
							get = function() return unitdb.Auras.numDebuffs end,
							set = function(_,v)
								style.SetAurasDebuffsCount(units,v)	
							end,
						},
					},
				},
				spacing = {
					type = "range",
					order = ns.order(),
					name = L["Spacing"],
					desc = L["Spacing"],
					min = 0, max = 20, step = 1,	
					get = function() return unitdb.Auras.spacing end,
					set = function(_,v)
						style.forceUpdateAurasSpacing(units,v)
					end,
				},
				direction = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Direction"],
					desc = L["Direction"],
					args = {
						anchor = {
							type = "select",
							order = ns.order(),
							name = L["anchor"],
							desc = L["anchor"],
							values = {["TOPLEFT"] = L["TOPLEFT"],["TOPRIGHT"] = L["TOPRIGHT"],["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"] },
							get = function() return unitdb.Auras.anchor end,
							set = function(_,v)
								style.forceUpdateAurasDirection(units,v)	
							end,
						},
					},
				},
				aurasFilter = {
					type = "group",
					order = ns.order(),
					name = L["Filter"],
					desc = L["Filter"],
					inline = true,
					args = {
						highLight = {
							type = "toggle",
							order = ns.order(),
							name = L["HighLightMyAuras"],
							desc = L["HightLightMyAuras"],
							get = function() return unitdb.Auras.highLightMyAuras end,
							set = function(_,v)
								style.forceHighLightMyAuras(units,v)
							end,
						},
						onlyShowMyAuras = {
							type = "toggle",
							name = L["OnlyShowMyAuras"],
							desc = L["OnlyShowMyAuras"],
							get = function() return unitdb.Auras.onlyShowMyAuras end,
							set = function(_,v)
								style.forceOnlyShowMyAuras(units,v)
							end,
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
	},
})



