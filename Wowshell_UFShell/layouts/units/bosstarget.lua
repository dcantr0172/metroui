local parent, ns = ...
local oUF = ns.oUF
local utils = ns.utils
local L = WSUF.L
local db = WSUF.db.profile;
local style = ns.style

local position = ns:RegisterUnitPosition("bosstarget", {
	selfPoint = "BOTTOMLEFT",
	anchorTo = "$parent",
	relativePoint = "BOTTOMRIGHT",
	x = 5,
	y = 0
})

local unitdb = ns:RegisterUnitDB("bosstarget", {
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
	Parent = {
		width = 50,
		height = 20,
		scale = 1,
		spacing = 2,
		background = {
			tex = "",
			color = {0,0,0,.8},
		},
	},
	Health = {
		width = 50,
		height = 20,
		position = {
			x = 0,
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


local units = "bosstarget";
ns:setSize(units, unitdb.Parent.width, unitdb.Parent.height,unitdb.Parent.Scale)

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
	for key,value in pairs(unitdb.tags) do
		self.tags[key] = self:CreateFontString(nil,"OVERLAY")
		self.tags[key]:SetFontObject(ChatFontNormal)
		style.SetTagsFontSize(units,key)
		style.SetTagsFontFlag(units,key)
	end
	style.SetTagsPosition(units)
end)


--ns:spawn(function()
	--local header = ns:LoadZoneHeader("bosstarget")
--end)


--ns:RegisterUnitOptions('bosstarget',{
--	type = 'group',
--	childGroups = 'tab',
--	order = ns.order(),
--	name = L["bosstarget"],
--	desc = L["bosstarget"],
--	args = {
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
--		tags = {
--			type = "group",
--			order = ns.order(),
--			name = L["Tags"],
--			desc = L["Tags"],
--			args = style.TagsConfig(units),
--		},
--	},
--})




--ns:RegisterUnitOptions('bosstarget',{
--	type = "group",
--	name = L["bosstarget"],
--	desc = L["bosstarget"],
--	order = ns.order(),
--	childGroups = 'tab',
--	args = {
--		healthBar = {
--			type = "group",
--			name = L["HealthBar"],
--			desc = L["HealthBar"],
--			order = ns.order(),
--			args = {
--				width = {
--					type = "range",
--					order = ns.order(),
--					name = L["Width"],
--					desc = L["HealthBar' width"],
--					min = 30, max = 80,step = 1,
--					get = function() return unitdb.healthBar.width end,
--					set = function(_,v)
--						setGlobalWidth(v)	
--					end,
--				},
--				height = {
--					type = "range",
--					order = ns.order(),
--					name = L["Height"],
--					desc = L["HealthBar's height"],
--					get = function() return unitdb.healthBar.height end,
--					set = function(_,v)
--						setGlobalHeight(v,"healthBar","Health")
--					end,
--				},
--			},
--		},
--		tags = {
--			type = "group",
--			order = ns.order(),
--			name = L["Tags"],
--			desc = L["Tags"],
--			args = {
--					nameTag = {
--						type = "group",
--						order = ns.order(),
--						name = L["Tags of name"],
--						desc = L["Tags of name"],
--						args = {
--							enable = {
--								type = "toggle",
--								order = ns.order(),
--								width = "full",
--								name = L["Enable"],
--								desc = L["Enable tags of name"],
--								get = function() return unitdb.tags.name.enable end,
--								set = function(_,v)
--									toggleTags(v,"name")
--									ns:Reload("bosstarget")
--								end,
--							},
--							dropTag = {
--								type = "select",
--								order = ns.order(),
--								name = L["Advance name tags"],
--								desc = L["Set custom name tags"],
--								values = { ["[name]"] = L["name"], ["[colorname]"] = L["colorname"],["[def:name]"] = L["defname"],},
--								get = function() return unitdb.tags.name.tag end,
--								set = function(_,v) 
--									unitdb.tags.name.tag = v
--									ns:Reload("bosstarget")
--								end,
--							},
--							advTag = {
--								type = "input",
--								order = ns.order(),
--								name = L["Advance name tags"],
--								desc = L["Set custom name tags"],
--								get = function() return unitdb.tags.name.tag end,
--								set = function(_,v)
--									unitdb.tags.name.tag = v
--									ns:Reload("bosstarget")
--								end,
--							},
--						},
--					},			
--			},
--		},
--	},
--})








--ns:spawn(function()
--	local header = ns:LoadZoneHeader("bosstarget")
--end)


--[==[
local bosses = {}

for bossId = 1, MAX_BOSS_FRAMES do
	local units = "boss"..bossId.."target"


	addon:addLayoutElement(units, function(self, unit)
		local Tags = self.tags

		local name = self:CreateFontString(nil, "OVERLAY")
		name:SetFontObject(GameFontNormalSmall)
		name:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
		self:Tag(name, "[name]")
		Tags.name = name

	end)

	addon:spawn(function()
		local temp = oUF:Spawn(units, "wsUnitFrame_BossFrame"..bossId.."target")
		temp:SetPoint("CENTER", addon.units["boss"..bossId], "CENTER", 10, -25)
		addon.units["boss"..bossId.."target"] = temp
	end)
end

addon:RegisterInitCallback(function()
    db = addon.db.profile
    unitdb = addon.db:RegisterNamespace("bosstarget", { profile = {
            castbar = true,
            auracooldown = true,
            castbyme = true,
            highlightmydebuff = false,
            taghp = "SMAR",
            tagmp = "SMAR",
            perhp = "PERC",
            perpp = "PERC",
        }
    }).profile
end)
--]==]
