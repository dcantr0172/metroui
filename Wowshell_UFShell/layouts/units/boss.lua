local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L 
local db = WSUF.db.profile
local style = ns.style

local position = ns:RegisterUnitPosition("boss", {
	selfPoint = "TOPLEFT",
	anchorTo = "UIParent",
	relativePoint = "BOTTOM",
	x = 300,
	y = 500
})


local unitdb = ns:RegisterUnitDB("boss", {
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
	Parent = {
		width = 150,
		height = 20,
		scale = 1,
		spacing = 2,
		background = {
			tex = "",
			color = {0,0,0,.8},
		},
		attribPoint = "TOP",
		attribAnchorPoint = "LEFT",
		unitsPerColumn = 5,
		columnSpacing = 50,
		offset = 20,
	},
	colors = {
		bgColor = {0,0,0,.8},
		brdBgColor = {0.1,0.1,0.12,1},
		brdColor = {0.28,0.28,0.28,1},
	},
	Health = {
		width = 150,
		height = 20,
		position = {
			x = 0,
			y = 0,
		},
		color = "colorReaction",
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
Castbar = {
		width = 150,
		height = 5,
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
		width = 150,
		height = 40,
		numBuffs = 20,
		numDebuffs = 20,
		spacing = 2,
		count = 6,
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
})

local units = "boss";

ns:setSize(units, unitdb.Parent.width, unitdb.Parent.height,unitdb.Parent.scale)

ns:addLayoutElement(units,function(self,unit)
	self.Health = CreateFrame("StatusBar",nil,self.bg)
	self.Health.border = CreateFrame("Frame",nil,self.Health)
	self.Health.background= self.Health:CreateTexture(nil,"BACKGROUND")
	style.SetElementSize(units,unitdb.Health.width,"width","Health")
	style.SetElementSize(units,unitdb.Health.height,"height","Health")
	style.SetHealthPosition(units,"LEFT")
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

ns:addLayoutElement(units, function(self, unit)
	self.Auras = CreateFrame('Frame',nil,self)
	self.Auras.PostCreateIcon = postCreateIcon
	style.SetAurasSize(units)
	style.SetAurasPosition(units)
	style.SetAurasSpacing(units)
	style.SetAurasGrowth(units)
	self.Auras.PostUpdateIcon = postUpdateIcon	
end)


local function postCreateIcon(icons,button)
	button.count:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = button.count:GetFont()
		button.count:SetFont(font,size,flag)
	end
	button.oufaura = true
	button.cd:SetDrawEdge(false)
	button.cd:SetReverse(true)
	button.icon:SetTexCoord(.1,.9,.1,.9)
	button.overlay:SetTexture(unitdb.tex.auraTex)
	button.overlay:SetPoint("TOPLEFT",button.icon,-2,2)
	button.overlay:SetPoint("BOTTOMRIGHT",button.icon,2,-2)
	button.overlay:SetTexCoord(0,1,0,1)
end

local function postUpdateIcon(icons,unit,icon,index,offset)
	local flag = unitdb.Auras.highLightMyAuras and true or false
	--print(unitdb.Auras.highLightMyAuras)
	local _,_,_,_,_,_,_,caster = UnitAura(unit,index,icon.filter)
	if (caster ~= "player" and caster ~= "vehicle" ) then
		icon.icon:SetDesaturated(flag)
		icon.overlay:SetVertexColor(.25,.25,.25)
	else
		icon.icon:SetDesaturated(false)
	end
end

ns:addLayoutElement(units,function(self,unit)
	local testParent = CreateFrame("Frame")
	testParent.t = testParent:CreateTexture(nil,"OVERLAY")
	testParent.fs = testParent:CreateFontString(nil,"OVERLAY")

	self.testParent = testParent
	self.testParent.fs = testParent.fs
	self.testParent.t = testParent.t
end)


ns:addLayoutElement(units,function(self,unit)
	self.tempFlag  = 0
	self:SetScript("OnDoubleClick",function(self,button)
	style.MoveAble(self,button,units,position)	
end)
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


ns:spawn(function()
	local header = ns:LoadZoneHeader("boss");
end)


--ns:RegisterUnitOptions('boss',{
--	type = 'group',
--	childGroups = 'tab',
--	order = ns.order(),
--	name = L["boss"],
--	desc = L["boss"],
--		Parent = {
--			type = "group",
--			order = ns.order(),
--			name = L["Parent"],
--			desc = L["Parent"],
--			args = {
--				width = {
--					type = "range",
--					name = L["Width"],
--					desc = L["Width"],
--					order = ns.order(),
--					min = 1,max = 800,step = 1,
--					get = function() return unitdb.Parent.width end,
--					set = function(_,v)
--						style.TestParent(units)
--						style.SetElementSize(units,v,"width","Parent")	
--					end,
--				},
--				height = {
--					type = "range",
--					name = L["Height"],
--					desc = L["Height"],
--					order = ns.order(),
--					min = 1,max = 800,step = 1,
--					get = function() return unitdb.Parent.height end,
--					set = function(_,v)
--						style.TestParent(units)
--						style.SetElementSize(units,v,"height","Parent")
--					end,
--				},
--				--color = {},
--				--border = {},
--			},
--		},
--Health = {
--			type = "group",
--			order = ns.order(),
--			name = L["Health"],
--			desc = L["Health"],
--			args = {
--				size = {
--					type = "group",
--					inline = true,
--					order = ns.order(),
--					name = L["Size"],
--					desc = L["Size"],
--					args = {
--						width = {
--							type = "range",
--							name = L["Width"],
--							desc = L["Width"],
--							min = 2,max = 800, step = 1,
--							order = ns.order(),
--							get = function() return unitdb.Health.width end,
--							set = function(_,v)
--								style.SetElementSize(units,v,"width","Health")
--							end,
--						},
--						height = {
--							type = "range",
--							name = L["Height"],
--							desc = L["Height"],
--							min = 2, max = 800, step = 1,
--							get = function() return unitdb.Health.height end,
--							set = function(_,v)
--								style.SetElementSize(units,v,"height","Health")
--							end,
--						},
--					},
--				},
--				position = {
--					type = "group",
--					name = L["Posistion"],
--					desc = L["Posistion"],
--					order = ns.order(),
--					inline = true,
--					args = {
--						x = {
--							type = "range",
--							name = L["x"],
--							desc = L["y"],
--							order = ns.order(),
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Health.position.x end,
--							set = function(_,v)
--								style.SetHealthPosition(units,unitdb.Portrait.position.point,v,unitdb.Health.position.y)
--							end,
--						},
--						y = {
--							type = "range",
--							name = L["y"],
--							desc = L["y"],
--							order = ns.order(),
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Health.position.y end,
--							set = function(_,v) 
--								style.SetHealthPosition(units,unitdb.Portrait.position.point,unitdb.Health.position.x,v)
--							end,
--						},
--					},
--				},
--				background = {
--					type = "group",
--					name = L["Background"],
--					desc = L["Background"],
--					inline = true,
--					order = ns.order(),
--					args = {
--						color = {
--							type = "color",
--							name = L["Color"],
--							desc = L["Color"],
--							hasAlpha = true,
--							get = function() return style.getColor(unitdb.Health.background.color) end,
--							set = function(_,r,g,b,a)
--								style.setColor(units,"Health","background",r,g,b,a)	
--							end,
--						},
--					},
--				},
--				border = {
--					type = "group",
--					inline = true,
--					name = L["Border"],
--					desc = L["Border"],
--					order = ns.order(),
--					args = {
--						thickness = {
--							type = "range",
--							name = L["Thickness"],
--							desc = L["Thickness"],
--							order = ns.order(), 
--							min = 0, max = 10, step = 1,
--							get = function() return unitdb.Health.border.value end,
--							set = function(_,v)
--								style.SetElementBorderValueAndTextureAndColor(units,"Health",v,unitdb.tex.borderTex,unitdb.Health.border.color)
--							end,
--						},
--						color = {
--							type = "color",
--							name = L["Color"],
--							desc = L["Color"],
--							order = ns.order(),
--							hasAlpha = true,
--							get = function() return style.getColor(unitdb.Health.border.color) end,
--							set = function(_,r,g,b,a)
--								style.setColor(units,"Health","border",r,g,b,a)
--							end,
--						},
--					},
--				},
--				frameLevel = {
--					type = "range",
--					order = ns.order(),
--					name = L["FrameLevel"],
--					desc = L["FrameLevel"],
--					min = 1, max = 99, step = 1,
--					get = function() return unitdb.Health.frameLevel end,
--					set = function(_,v)
--						style.SetElementFrameLevel(units,"Health",v)
--					end,
--				},
--				alpha = {
--					type = "range",
--					order = ns.order(),
--					name = L["Alpha"],
--					desc = L["Alpha"],
--					min = 0, max = 1, step = 0.01,
--					isPercent = true,
--					get = function() return unitdb.Health.alpha end,
--					set = function(_,v)
--						style.SetElementAlpha(units,"Health",v)
--					end,
--				},
--				hpColor = {
--					type = "group",
--					name = L["Health color"],
--					desc = L["Health color"],
--					order = ns.order(),
--					inline = true,
--					args = {
--						colorType = {
--							type = "select",
--							name = L["Color type"],
--							desc = L["Color type"],
--							values = {["colorClass"] = L["colorClass"],["colorSmooth"] = L["colorSmooth"],["colorHealth"] = L["colorHealth"],},
--							get = function() return unitdb.Health.color end,
--							set = function(_,v)  
--								style.forceUpdateHP(units,v,unitdb.Health.colorH)
--							end,
--						},
--						colorHealth = {
--							type = "color",
--							name = L["Custom color"],
--							desc = L["Custom color"],
--							hasAlpha = true,
--							get = function() return style.getColor(unitdb.Health.colorH) end,
--							set = function(_,r,g,b,a)
--								style.setHpColor(units,r,g,b,a)
--							end,
--						},
--					},
--				},
--
--			},
--		},
--			Castbar = {
--			type = "group",
--			order = ns.order(),
--			name = L["Castbar"],
--			desc = L["Castbar"],
--			args = {
--				size  ={
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Size"],
--					desc = L["Size"],
--					args = {
--						width = {
--							type = "range",
--							name = L["Width"],
--							desc = L["Width"],
--							order = ns.order(),
--							min = 2,max = 800,step = 1,
--							get = function() return unitdb.Castbar.width end,
--							set = function(_,v)
--								style.SetElementSize(units,v,"width","Castbar")
--							end,
--						},
--						height = {
--							type = "range",
--							name = L["Height"],
--							desc = L["Height"],
--							min = 2, max = 800,step = 1,
--							get = function() return unitdb.Castbar.height end,
--							set = function(_,v) 
--								style.SetElementSize(units,v,"height","Castbar")
--							end,
--						},
--					},
--				},
--				position = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Posistion"],
--					desc = L["Posistion"],
--					args = {
--						x = {
--							type = "range",
--							name = L["x"],
--							desc = L["x"],
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Castbar.position.x end,
--							set = function(_,v)
--								style.SetCastbarPosition(units,v,unitdb.Castbar.position.y)
--							end,
--						},
--						y = {
--							type = "range",
--							name = L["y"],
--							desc = L["y"],
--							min = -800,max = 800,step = 1,
--							get = function() return unitdb.Castbar.position.y end,
--							set = function(_,v)
--								style.SetCastbarPosition(units,unitdb.Castbar.position.x,v)
--							end,	
--						},
--					},
--				},
--				cbColor = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["Color"],
--					desc = L["Color"],
--					args = {
--						color = {
--							type = "color",
--							order = ns.order(),
--							name = L["Color"],
--							desc = L["Color"],
--							hasAlpha = true,
--							get = function() return style.getColor(unitdb.Castbar.color) end,
--							set = function(_,r,g,b,a)
--								style.setCbColor(units,r,g,b,a)
--							end,
--						},
--					},
--				},
--				border = {
--					type = "group",
--					order = ns.order(),
--					name = L["Background and border"],
--					desc = L["Background and border"],
--					inline = true,
--					args ={
--						color = {
--							type = "color",
--							order = ns.order(),
--							name = L["Color"],
--							desc = L["Color"],
--							hasAlpha = true,
--							get = function() return style.getColor(unitdb.Castbar.background.color) end,
--							set = function(_,r,g,b,a)
--								style.SetCastbarBorder(units,unitdb.Castbar.background.value,r,g,b,a)
--							end,
--						},
--						thickness = {
--							type = "range",
--							order = ns.order(),
--							name = L["Thickness"],
--							desc = L["Thickness"],
--							min = 0, max = 10, step = 1,
--							get = function() return unitdb.Castbar.background.value end,
--							set = function(_,v)
--								style.SetCastbarBorder(units,v,unitdb.Castbar.background.color[1],unitdb.Castbar.background.color[2],unitdb.Castbar.background.color[3],unitdb.Castbar.background.color[4])
--							end,
--						},
--					},
--				},
--
--				Icon = {
--					type = "group",
--					order = ns.order(),
--					inline = true,
--					name = L["CastbarIcon"],
--					desc = L["CastbarIcon"],
--					args = {
--						size = {
--							type = "group",
--							name = L["Size"],
--							desc = L["Size"],
--							order = ns.order(),
--							inline = true,
--							args = {
--								size = {
--									type = "range",
--									order = ns.order(),
--									name = L["Size"],
--									desc = L["Size"],
--									min = 1, max = 400,step =1,
--									get = function() return unitdb.Castbar.Icon.size end,
--									set = function(_,v)
--										style.SetCastbarIconSize(units,v)
--									end,
--								},
--							},
--						},
--						position = {
--							type = "group",
--							order = ns.order(),
--							inline = true,
--							name = L["Posistion"],
--							desc = L["Posistion"],
--							args = {
--								x = {
--									type = "range",
--									order = ns.order(),
--									name = L["x"],
--									desc = L["x"],
--									min = -800, max = 800, step = 1,
--									get = function() return unitdb.Castbar.Icon.position.x end,
--									set = function(_,v)
--										style.SetCastbarIconPosition(units,unitdb.Castbar.Icon.position.point,v,unitdb.Castbar.Icon.position.y)
--									end,
--								},
--								y = {
--									type = "range",
--									order = ns.order(),
--									name = L["y"],
--									desc = L["y"],
--									min = -800, max = 800, step = 1,
--									get = function() return unitdb.Castbar.Icon.position.y end,
--									set = function(_,v)
--										style.SetCastbarIconPosition(units,unitdb.Castbar.Icon.position.point,unitdb.Castbar.Icon.position.x,v)
--									end,
--								},
--							},
--						},
--					},
--				},
--				Text = {
--					type = "group",
--					order = ns.order(),
--					name = L["Castbar Text"],
--					desc = L["Castbar Text"],
--					inline = true,
--					args = {
--						flag = {
--							type = "select",
--							name = L["Text Flag"],
--							desc = L["Text Flag"],
--							order = ns.order(),
--							values = style.FontFlagValue(),
--							get = function() return unitdb.Castbar.Text.flag end,
--							set = function(_,v)
--								style.SetCastbarText(units,unitdb.Castbar.Text.position.x,unitdb.Castbar.Text.position.y,v,unitdb.Castbar.Text.fontSize)
--							end,
--						},
--						fontSize = {
--							type = "range",
--							order = ns.order(),
--							name = L["Font size"],
--							desc = L["Font size"],
--							min = 1, max = 64,step = 1,
--							get = function() return unitdb.Castbar.Text.fontSize end,
--							set = function(_,v)
--								style.SetCastbarText(units,unitdb.Castbar.Text.position.x,unitdb.Castbar.Text.position.y,unitdb.Castbar.Text.flag,v)
--							end,
--						},
--						position = {
--							type = "group",
--							name = L["Posistion"],
--							desc = L["Posistion"],
--							order = ns.order(),
--							inline = true,
--							args = {
--								x = {
--									type = "range",
--									name = L["x"],
--									desc = L["x"],
--									order = ns.order(),
--									min = -800, max = 800,step = 1,
--									get = function() return unitdb.Castbar.Text.position.x end,
--									set = function(_,v)
--										style.SetCastbarText(units,v,unitdb.Castbar.Text.position.y,unitdb.Castbar.Text.flag,unitdb.Castbar.Text.fontSize)
--									end,
--								},
--								y = {
--									type = "range",
--									name = L["y"],
--									desc = L["y"],
--									order = ns.order(),
--									min = -800, max = 800,step = 1,
--									get = function() return unitdb.Castbar.Text.position.y end,
--									set = function(_,v)
--										style.SetCastbarText(units,unitdb.Castbar.Text.position.x,v,unitdb.Castbar.Text.flag,unitdb.Castbar.Text.fontSize)
--									end,
--								},
--							},
--						},
--					},
--				},
--			},
--		},
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
--	--	Indicators = {
--	--		type = "group",
--	--		order = ns.order(),
--	--		name = L["Indicators"],
--	--		desc = L["Indicators"],
--	--		args = style.IndicatorsConfig(units)
--	--	},
--		tags = {
--			type = "group",
--			order = ns.order(),
--			name = L["Tags"],
--			desc = L["Tags"],
--			args = style.TagsConfig(units),
--		},
--	})


