
local parent, ns = ...
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local db = WSUF.db.profile 

local position = ns:RegisterUnitPosition("arena",{
	selfPoint = "TOPRIGHT",
	anchorTo = "UIParent",
	relativePoint = "TOPRIGHT",
	x = "-30",
	y = "0",
})

local unitdb = ns:RegisterUnitDB("arena",{
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
		width = 120,
		height = 25,
		scale = 1,
		attribPoint = "TOP",
		attribAnchorPoint = "LEFT",
		unitsPerColumn = 5,
		columnSpacing = 30,
		offset = 20,
		spacing = 2,
	},
	portrait = {
		enable = false,
		width = 25,
		height = 25,
		position = "RIGHT",
	},
	healthBar = {
		width = 120,
		height = 18,
		color = "colorClass",
	},
	powerBar = {
		width = 120,
		height = 5,
	},
	indicators = {
		raidIcon = {
			enable = true,
			size = 12,
		},
	},
	castBar = {
		enable = true,
		width = 120,
		height = 4,
	},
	auras = {
		enable = true,
		numBuffs = 8,
		numDebuffs = 8,
		spacing = 2,
		count = 9,
	},
	tags = {
		name = {
			enable = true,
			tag = "[colorName]",
		},
		hp = {
			enable = true,
			tag = "[curhp]",
		},
		mp = {
			enable = true,
			tag = "[curpp]",
		},
	},
})


local units = "arena"

ns:setSize(units, unitdb.parent.width, unitdb.parent.height,unitdb.parent.scale)

ns:addLayoutElement(units, function(self, unit)
    local hp, mp
    hp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(hp, unitdb.healthBar.width, unitdb.healthBar.height)
		hp:SetPoint('TOPLEFT',self.bg, 0, 0)
    	
    mp = CreateFrame('StatusBar', nil, self.bg)
    utils.setSize(mp, unitdb.powerBar.width, unitdb.powerBar.height )
    mp:SetPoint("TOPLEFT",hp,"BOTTOMLEFT",0,0-self:GetHeight()*0.1)
		hp:SetStatusBarTexture(unitdb.tex.barTex)
		mp:SetStatusBarTexture(unitdb.tex.barTex)

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
	
		local mpbg = mp:CreateTexture(nil,'BACKGROUND')
			mpbg:SetAllPoints(mp)
			mpbg:SetTexture(unitdb.tex.barTex)
			mpbg:SetVertexColor(unpack(unitdb.colors.bgColor))
	
		local mpbrd = CreateFrame("Frame",nil,mp)	
			mpbrd:SetPoint('TOPLEFT',mp,'TOPLEFT',-2,2)
			mpbrd:SetPoint('BOTTOMRIGHT',mp,'BOTTOMRIGHT',2,-2)
			mpbrd:SetBackdrop(unitdb.tex.borderTex)
			mpbrd:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
			mpbrd:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
			mpbrd:SetFrameLevel(1)
	


		self.Health, self.Power = hp, mp

    hp[unitdb.healthBar.color] = true
    hp.frequentUpdates = true
    mp.colorPower = true
    mp.frequentUpdates = true

end)

ns:addLayoutElement(units, function(self, unit)
    local button = CreateFrame('Button', nil, self)

    local icon = button:CreateTexture(nil, 'BACKGROUND')
    icon.button = button
    self.ClassIcon = icon
    utils.setSize(icon, unitdb.portrait.width)
    icon:SetPoint('RIGHT', self, -6, 0)

		local bg = button:CreateTexture(nil,"BACKGROUND")
		bg:SetAllPoints(button)
		bg:SetTexture(unitdb.tex.barTex)
		bg:SetVertexColor(unpack(unitdb.colors.bgColor))

		local brd = CreateFrame("Frame", nil, p)
		brd:SetPoint('TOPLEFT', button, 'TOPLEFT', -1 , 1)
		brd:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', 1, -1)
		brd:SetBackdrop(unitdb.tex.borderTex)
		brd:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
		brd:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
		brd:SetFrameLevel(1)



   -- local border = button:CreateTexture(nil, 'BORDER')
   -- icon.border = border
   -- utils.setSize(border, 60)
   -- border:SetPoint('TOPLEFT', icon, 'TOPLEFT', -8, 6)
	--border:SetTexture([[Interface\ArenaEnemyFrame\UI-Arena-Border]])
  --  border:SetTexture([[Interface\Minimap\MiniMap-TrackingBorder]])  

end)

ns:addLayoutElement(units, function(self, unit)
    local t = self.tags

    local name = self:CreateFontString(nil, 'OVERLAY')
    t.name = name
		name :SetFontObject(ChatFontNormal)
		name :SetPoint("LEFT",-10,0)
--    name:SetFontObject(ChatFontNormal)
--    name:SetPoint('CENTER',self, -0, 22)
--    self:Tag(name, '[raidcolor][name]')
--
    local hp = self:CreateFontString(nil, 'OVERLAY')
    t.hp = hp
	hp:SetFontObject(ChatFontNormal)
    --hp:SetFontObject('TextStatusBarText')
    do
        local font, size, flag = hp:GetFont()
        hp:SetFont(font, size-3, flag)
    end
    hp:SetPoint('CENTER', self.Health, 0, 0)
    --utils.updateTag(self, hp, unitdb.tagonhealthbarright)
    --self:Tag(hp, '[colorhp][curhp]/[maxhp]')

    local mp = self:CreateFontString(nil, 'OVERLAY')
    t.mp = mp
	mp:SetFontObject(ChatFontNormal)
    do
        local font, size, flag = mp:GetFont()
        mp:SetFont(font, size-3, flag)
    end
    mp:SetPoint('CENTER',self.Power, 0, 0)
end)

--ns:addLayoutElement(units, function(self, unit)
--    local parent = self:GetParent()
--    parent.frames = parent.frames or {}
--    tinsert(parent.frames, self)
--end)

local function post(icons, button)
     local font, size, flag = button.count:GetFont()
    button.count:SetFont(STANDARD_TEXT_FONT, size, flag)
    button.oufaura = true
    button.cd:SetDrawEdge(false)
    button.cd:SetReverse(true)
		button.icon:SetTexCoord(0.1,0.9,0.1,0.9)
		button.overlay:SetTexture(unitdb.tex.auraTex)
    button.overlay:SetPoint("TOPLEFT", button.icon, "TOPLEFT", -1, 1)
    button.overlay:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 1, -1)		
		button.overlay:SetTexCoord(0, 1, 0, 1)
		button.overlay.Hide = function(self) self:SetVertexColor(unpack(unitdb.colors.brdColor)) end
end

local function postUpdateIcon(icons, unit, icon, index, offset)
    utils.postAuraUpdateCooldown(icons, unit, icon, index, offset)
end

ns:addLayoutElement(units, function(self, unit)
    local frame = CreateFrame('Frame', nil, self)
    self.Auras = frame
    frame.PostCreateIcon = post
    frame.showType = true

    frame.size = self:GetWidth()/unitdb.auras.count - unitdb.parent.spacing*2
    --frame.numBuffs = 8
    --frame.numDebuffs = 2
    frame.gap = true

    frame.spacing = unitdb.auras.spacing 
    frame.initialAnchor = 'TOPLEFT'
    frame['growth-x'] = 'LEFT'
    frame['growth-y'] = 'DOWN'

    frame:SetWidth(self:GetWidth())
    frame:SetHeight(frame.size*2)
    frame:SetPoint('TOPLEFT', self, 'BOTTOMLEFT', 0, -10)
    --frame.PostUpdateIcon = postUpdateIcon

end)

ns:addLayoutElement(units, function(self, unit)
	if not unitdb.indicators.raidIcon.enable then return end
    local ricon = self:CreateTexture(nil, 'OVERLAY')
    self.RaidIcon = ricon
    utils.setSize(ricon, unitdb.indicators.raidIcon.size)
    ricon:SetPoint('RIGHT', self,'LEFT', -5, 0)
end)

ns:addLayoutElement(units, function(self, unit)
if not unitdb.castBar.enable then return end
		local cb = CreateFrame('StatusBar', nil,self)
		self.Castbar = cb 
		cb:SetPoint('TOPLEFT',self,'BOTTOMLEFT',0,0-unitdb.parent.spacing*3)
		utils.setSize(cb,unitdb.castBar.width,unitdb.castBar.height)
		cb.__own = self
		cb:SetStatusBarTexture(unitdb.tex.barTex)
		cb:SetStatusBarColor(1,.7,0)
		
		local cbbrd = CreateFrame("Frame",nil,cb)
		cbbrd:SetPoint('TOPLEFT',cb,'TOPLEFT',-1,1)
		cbbrd:SetPoint('BOTTOMRIGHT',cb,'BOTTOMRIGHT',1,-1)
		cbbrd:SetBackdrop(unitdb.tex.borderTex)
		cbbrd:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
		cbbrd:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
		cbbrd:SetFrameLevel(1)


		cb.PostCastStart = postCastStart

		local icon = self.Castbar:CreateTexture(nil,'ARTWORK')
		self.Castbar.Icon = icon
		utils.setSize(icon, 12)
		icon:SetPoint('BOTTOMLEFT',cb,'BOTTOMRIGHT',unitdb.parent.spacing*3,0)
		icon:SetTexCoord(0.1,0.9,0.1,0.9)
		

		local iconbrd = CreateFrame("Frame", nil, self.Castbar)
		iconbrd:SetPoint('TOPLEFT', icon, 'TOPLEFT', -2 , 2)
		iconbrd:SetPoint('BOTTOMRIGHT', icon, 'BOTTOMRIGHT', 2, -2)
		iconbrd:SetBackdrop(unitdb.tex.borderTex)
		iconbrd:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
		iconbrd:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
		iconbrd:SetFrameLevel(1)
		
		local text = self.Castbar:CreateFontString(nil,'OVERLAY')
		self.Castbar.Text = text 
		text:SetFontObject(ChatFontNormal)
		do local font,size,flag = text:GetFont()
			text:SetFont(font,size-2,'OUTLINE')
		end
		text:SetPoint('CENTER',self.Castbar)
end)

ns:spawn(function()
	local header = ns:LoadZoneHeader("arena") 
end)

--[=[
ns:RegisterUnitOptions("arena",{
	type = "group",
	order = ns.order(),
	childGroups = "tab",
	name = L["Arena"],
	desc = L["Arena"],
	args = {
		--portrait = {
		--	type = "group",
		--	order = ns.order(),
		--	name = L["Portrait"],
		--	desc = L["Portrait"],
		--	args = {},
		--},
		healthBar = {
			type = "group",
			order = ns.order(),
			name = L["Healthbar"],
			desc = L["Healthbar"],
			args = {
				width = {
					type = "range",
					min = 50, max = 180, step = 1,
					order = ns.order(),
					name = L["Width"],
					desc = L["Healthbar's width"],
					get = function() return unitdb.healthBar.width end,
					set = function(_,v)
						unitdb.healthBar.width = v
						unitdb.parent.width = v
					end,
				},
				height = {
					type = "range",
					order = ns.order(),
					name = L["Height"],
					desc = L["Healthbar's height"],
					min = 10, max = 35, step = 1,
					get = function() return unitdb.healthBar.height end,
					set = function(_,v) 
						unitdb.healthBar.height = v
					end,
				},
			},
		},
		powerBar = {
			type = "group",
			order = ns.order(),
			name = L["Powerbar"],
			desc = L["Powerbar"],
			args = {
				width = {
					type = "range",
					min = 50, max = 180, step = 1,
					order = ns.order(),
					name = L["Width"],
					desc = L["Powerbar's width"],
					get = function() return unitdb.powerBar.width end,
					set = function(_,v)
						unitdb.powerBar.width = v
					end,
				},
				height = {
					type = "range",
					min = 2, max = 10, step = 1,
					order = ns.order(),
					name = L["Height"],
					desc = L["Powerbar's height"],
					get = function() return unitdb.powerBar.height end,
					set = function(_,v)
						unitdb.powerBar.height = v
					end,
				},
			},
		},
		castBar = {
			type = "group",
			order = ns.order(),
			name = L["Castbar"],
			desc = L["Castbar"],
			args = {
				enable = {
					type = "toggle",
					order = ns.order(),
					name = L["Enable"],
					desc = L["Enable castBar"],
					get = function() return unitdb.castBar.enable end,
					set = function(_,v)
						unitdb.castBar.enable = v 
					end,
				},
			},
		},
		auras = {
			type = "group",
			order = ns.order(),
			name = L["Auras"],
			desc = L["Auras"],
			args = {
				enable = {
					type = "toggle",
					order = ns.order(),
					name = L["Enable"],
					desc = L["Enable auras"],
					get = function() return unitdb.auras.enable end,
					set = function(_,v)
						unitdb.auras.enable = v
					end,
				},
			},
		},
		indicators = {
			type = "group",
			order = ns.order(),
			name = L["Indicators"],
			desc = L["Indicators"],
			args = {
				raidIcon = {
					enable = {
						type = "toggle",
						order = ns.order(),
						name = L["Enable"],
						desc = L["Enable raidIcon"],
						get = function() return unitdb.indicators.raidIcon.enable end,
						set = function(_,v)
							unitdb.indicators.raidIcon.enable = v
						end,
					},
				},
			},
		},
		tags = {
			type = "group",
			order = ns.order(),
			name = L["Tags"],
			desc = L["Tags"],
			args = {
					nameTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of name"],
						desc = L["Tags of name"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable tags of name"],
								get = function() return unitdb.tags.name.enable end,
								set = function(_,v)
									unitdb.tags.name.enable = v
									ns:Reload("arena")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance name tags"],
								desc = L["Set custom name tags"],
								values = { ["[name]"] = L["name"], ["[colorname]"] = L["colorname"],["[def:name]"] = L["defname"],},
								get = function() return unitdb.tags.name.tag end,
								set = function(_,v) 
									unitdb.tags.name.tag = v
									ns:Reload("arena")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance name tags"],
								desc = L["Set custom name tags"],
								get = function() return unitdb.tags.name.tag end,
								set = function(_,v)
									unitdb.tags.name.tag = v
									ns:Reload("arena")
								end,
							},
						},
					},
					hpTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of health"],
						desc = L["Tags of health"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable tags of hp"],
								get = function() return unitdb.tags.hp.enable end,
								set = function(_,v)
									unitdb.tags.hp.enable = v
									ns:Reload("arena")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance hp tags"],
								desc = L["Set custom hp tags"],
								values = {["[curhp]"] = L["curhp"],["[maxhp]"]=L["maxhp"],["[perhp]"]=L["perhp"],["[curmaxhp]"]=L["curmaxhp"],["[absolutehp]"] = L["absolutehp"], ["[abscurhp]"] = L["abscurhp"],["[absmaxhp]"] = L["absmaxhp"],["[missinghp]"] = L["missinghp"], ["[smart:curmaxhp]"] = L["smart:curmaxhp"],},
								get = function() return unitdb.tags.hp.tag end,
								set = function(_,v)
									unitdb.tags.hp.tag = v
									ns:Reload("arena")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance hp tags"],
								desc = L["Set custom hp tags"],
								get = function() return unitdb.tags.hp.tag end,
								set = function(_,v) 
									unitdb.tags.hp.tag = v
									ns:Reload("arena")
								end,
							},
						},
					},
					ppTag = {
						type = "group",
						order = ns.order(),
						name = L["Tags of power"],
						desc = L["Tags of power"],
						args = {
							enable = {
								type = "toggle",
								order = ns.order(),
								width = "full",
								name = L["Enable"],
								desc = L["Enable tags of mp"],
								get = function() return unitdb.tags.mp.enable end,
								set = function(_,v)
									unitdb.tags.mp.enable = v
									ns:Reload("arena")
								end,
							},
							dropTag = {
								type = "select",
								order = ns.order(),
								name = L["Advance mp tags"],
								desc = L["Set custom mp tags"],
								values = {["[curpp]"] = L["curpp"],["[maxpp]"]=L["maxpp"],["[perpp]"] = L["perpp"],["[curmaxpp]"] = L["curmaxpp"],["[absolutepp]"] = L["absolutepp"],["[abscurpp]"] = L["abscurpp"],["[absmaxpp]"] = L["absmaxpp"], ["[smart:curmaxpp]"]=L["smart:curmaxpp"]},
								get = function() return unitdb.tags.mp.tag end,
								set = function(_,v)
									unitdb.tags.mp.tag = v
									ns:Reload("arena")
								end,
							},
							advTag = {
								type = "input",
								order = ns.order(),
								name = L["Advance mp tags"],
								desc = L["Set custom mp tags"],
								get = function() return unitdb.tags.mp.tag end,
								set = function(_,v) 
									unitdb.tags.mp.tag = v
									ns:Reload("arena")
								end,
							},
						},
					},	
			},
		},
	},
})
--]=]


-- ns:RegisterModuleOptions('arena', {
    -- type = 'group',
    -- name = L['arena'],
    -- order = addon.order(),
    -- args = {
        -- enabled = {
            -- type = 'toggle',
            -- name = L['Enabled'],
            -- desc = L['Enable arena'],
            -- order = addon.order(),
            -- width = 'full',
            -- get = function() return unitdb.enabled end,
            -- set = function(_, v)
                -- unitdb.enabled = v
                -- if(v) then
                    -- frame:Enable()
                -- else
                    -- frame:Disable()
                -- end
            -- end,
        -- },
        -- taggroup = {
            -- type = 'group',
            -- name = L['Tag texts'],
            -- order = addon.order(),
            -- inline = true,
            -- args = {
                -- tagonhealthbar = {
                    -- type = 'select',
                    -- name = L['Text on health bar'],
                    -- desc = L['The text show on health bar'],
                    -- order = addon.order(),
                    -- values = utils.tag_select_values,
                    -- disabled = function() return not unitdb.enabled end,
                    -- get = function() return unitdb.tagonhealthbar or 'NONE' end,
                    -- set = function(_, v)
                        -- unitdb.tagonhealthbar = v
                        -- utils.updateTag(frame, 'hp', v)
                    -- end,
                -- },
                -- tagonpowerbar = {
                    -- type = 'select',
                    -- name = L['Text on power bar'],
                    -- desc = L['The text show on power bar'],
                    -- order = addon.order(),
                    -- values = utils.tag_select_values,
                    -- disabled = function() return not unitdb.enabled end,
                    -- get = function() return unitdb.tagonpowerbar or 'NONE' end,
                    -- set = function(_, v)
                        -- unitdb.tagonpowerbar = v
                        -- utils.updateTag(frame, 'mp', v, 1)
                    -- end,
                -- },
            -- },
        -- },
    -- },
-- })

--local option_args = {
--    enabled = {
--        type = 'toggle',
--        name = L['Enable'],
--        desc = L['Enable arena'] .. '\n' .. L['The settings will take effect after reload.'],
--        width = 'full',
--        order = addon.order(),
--        get = function() return unitdb.enabled end,
--        set = function(_, v)
--            unitdb.enabled = v
--            --StaticPopup_Show'WOWSHELL_UTIL_CONFIGCHANGED_RELOAD'
--        end,
--    },
--}
--
--ns:RegisterModuleOptions('arena', {
--    type = 'group',
--    name = L['arena'],
--    order = addon.order(),
--    args = option_args,
--})


