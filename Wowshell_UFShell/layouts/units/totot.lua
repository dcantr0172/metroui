-- susnow 
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile
local style = ns.style
local preview = ns.preview


local position = ns:RegisterUnitPosition("targettargettarget",{
	selfPoint = "TOPLEFT",
	anchorTo = "#wsUnitFrame_TargetTarget",
	relativePoint = "BOTTOMLEFT",
	x = "0",
	y = "-5",
})

local unitdb = ns:RegisterUnitDB("targettargettarget",{
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
		enable = true,
		width = 80,
		height = 24,
		background = {
			tex = "",
			color = {0,0,0,.8},
		},
		border = {
			value = 0,
			tex = "",
			color = { .3,.3,.3,1},
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
		width = 24,
		height = 24,
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
		width = 54,
		height = 16 ,
	position = {
			x = 28,
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
		width = 54,
		height = 6,
		color = "colorPower",
		colorP = {0.24,0.38,0.6,1},
		tex = "",
		position = {
			x = 28,
			y = -20,
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
	Auras = {
		width = 80,
		height = 20,
		numBuffs = 3,
		numDebuffs = 3,
		num = 6,
		count = 3,
		spacing = 4,
		anchor = "TOPLEFT",
		growthX = "RIGHT",
		growthY = "DOWN",
		highLightMyAuras = true,
		onlyShowMyAuras = false,
		position = {
			x = 88,
			y = 22,
		},
	},
Indicators = {
			RaidIcon = {
				enable = true,
				size = 14,
				position = {
					point = "TOP",
					relativePoint = "Portrait",
					anchorTo = "TOPLEFT",
					x = 2,
					y = -1,
				},
			},
		},
		tags = {
		HealthLeft = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		HealthRight = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		HealthCenter = {
			enable = true,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "[colorname]",
		},
		PortraitLeft = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		PortraitCenter = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		PortraitRight = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		PowerLeft = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		PowerCenter = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		PowerRight = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentTopleft = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentTop = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentTopright = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottomleft = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottom = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
		ParentBottomright = {
			enable = false,
			fontSize = 10,
			flag = "OUTLINE",
			tag = "",
		},
	},

})

local units = "targettargettarget"

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

--[healthBar,powerBar]
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
--	
--		self.testFrame = testFrame
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
--	preview.testUnit["targettargettarget"](units)
--	preview.toggleTestObj(units,false)
--end)

ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
end)


local frame
ns:addLayoutElement(units, function(self)
    frame = self
end)

oUF:RegisterInitCallback(function(self)
    if(self == frame) then
        local enabled = unitdb.Parent.enable
        if(not enabled) then
            self:Disable()
        end
        self.__enabled = enabled
    end
end)

ns:spawn(function()
	local f = oUF:Spawn("targettargettarget", "wsUnitFrame_TargetTargetTarget")

	ns.frameList[f] = true
	ns.unitFrames.targettargettarget = f
	if not (unitdb.Parent.enable) then
		f:Disable()
	end

	return f;
end)



ns:RegisterUnitOptions("targettargettarget",{
	type = "group",
	name = L["targettargettarget"],
	order = ns.order(),
	childGroups = "tab",
	args = {
		enable={
			type = "toggle",
			order = ns.order(),
			name = L["Enable"],
			desc = L["Enable targettargettarget"],
			get = function() return unitdb.Parent.enable end,
			set = function(_,v)
				unitdb.Parent.enable = v
				if(v and not frame.__enabled) then
					frame:Enable()
				elseif(not v and frame.__enabled) then
					frame:Disable()
				end
				frame.__enabled = v
			end,
		},
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
--Auras = {
--			type = "group",
--			order = ns.order(),
--			name = L["Auras"],
--			desc = L["Auras"],
--			args = {
--				size = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Size"],
--					desc = L["Size"],
--					args = {
--						width = {
--							type = "range",
--							order = ns.order(),
--							name = L["Width"],
--							desc = L["Width"],
--							min = 1, max = 800, step = 1,
--							get = function() return unitdb.Auras.width end,
--							set = function(_,v)
--								style.SetAurasSize(units,v,unitdb.Auras.height)
--							end,
--						},
--						height = {
--							type = "range",
--							order = ns.order(),
--							name = L["Height"],
--							desc = L["Height"],
--							min = 1, max = 800, step = 1,
--							get = function() return unitdb.Auras.height end,
--							set = function(_,v)
--								style.SetAurasSize(units,unitdb.Auras.width,v)
--							end,
--						},
--					},
--				},
--				position = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Position"],
--					desc = L["Position"],
--					args = {
--						x = {
--							type = "range",
--							order = ns.order(),
--							name = L["x"],
--							desc = L["x"],
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Auras.position.x end,
--							set = function(_,v) 
--								style.SetAurasPosition(units,v,unitdb.Auras.position.y)
--							end,
--						},
--						y = {
--							type = "range",
--							order = ns.order(),
--							name = L["y"],
--							desc = L["y"],
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Auras.position.y end,
--							set = function(_,v) 
--								style.SetAurasPosition(units,unitdb.Auras.position.x,v)
--							end,
--						},
--					},
--				},
--				count = {
--					type = "group",
--					name = L["Count"],
--					desc = L["Count"],
--					order = ns.order(),
--					inline = true,
--					args = {
--						buffs = {
--							type = "range",
--							order = ns.order(),
--							name = L["Buffs"],
--							desc = L["Buffs"],
--							min = 1, max = 40,step = 1,
--							get = function() return unitdb.Auras.numBuffs end,
--							set = function(_,v)
--								style.SetAurasBuffsCount(units,v)	
--							end,
--						},
--						debuffs = {
--							type = "range",
--							order = ns.order(),
--							name = L["Debuffs"],
--							desc = L["Debuffs"],
--							min = 1, max = 40,step = 1,
--							get = function() return unitdb.Auras.numDebuffs end,
--							set = function(_,v)
--								style.SetAurasDebuffsCount(units,v)	
--							end,
--						},
--					},
--				},
--				spacing = {
--					type = "range",
--					order = ns.order(),
--					name = L["Spacing"],
--					desc = L["Spacing"],
--					min = 0, max = 20, step = 1,	
--					get = function() return unitdb.Auras.spacing end,
--					set = function(_,v)
--						style.forceUpdateAurasSpacing(units,v)
--					end,
--				},
--				direction = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Direction"],
--					desc = L["Direction"],
--					args = {
--						anchor = {
--							type = "select",
--							order = ns.order(),
--							name = L["anchor"],
--							desc = L["anchor"],
--							values = {["TOPLEFT"] = L["TOPLEFT"],["TOPRIGHT"] = L["TOPRIGHT"],["BOTTOMLEFT"] = L["BOTTOMLEFT"], ["BOTTOMRIGHT"] = L["BOTTOMRIGHT"] },
--							get = function() return unitdb.Auras.anchor end,
--							set = function(_,v)
--								style.forceUpdateAurasDirection(units,v)	
--							end,
--						},
--					},
--				},
--				aurasFilter = {
--					type = "group",
--					order = ns.order(),
--					name = L["Filter"],
--					desc = L["Filter"],
--					inline = true,
--					args = {
--						highLight = {
--							type = "toggle",
--							order = ns.order(),
--							name = L["HighLightMyAuras"],
--							desc = L["HightLightMyAuras"],
--							get = function() return unitdb.Auras.highLightMyAuras end,
--							set = function(_,v)
--								style.forceHighLightMyAuras(units,v)
--							end,
--						},
--						onlyShowMyAuras = {
--							type = "toggle",
--							name = L["OnlyShowMyAuras"],
--							desc = L["OnlyShowMyAuras"],
--							get = function() return unitdb.Auras.onlyShowMyAuras end,
--							set = function(_,v)
--								style.forceOnlyShowMyAuras(units,v)
--							end,
--						},
--					},
--				},
--			},
--		},
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
	},
})
