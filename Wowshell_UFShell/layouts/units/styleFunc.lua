--susnow

local parent, ns = ...
local style = CreateFrame("Frame")
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local function GetObject(unit)
	local obj = self or ns.unitFrames[unit]
	if unit == "party" then
	--	for _, header in pairs(WSUF.Module.headerFrames) do
	--		header:SetAttribute("startingIndex", "-4")
	--		header.startingIndex = header:GetAttribute("startingIndex")
	--		for i =1, select("#",header:GetChildren()) do
	--		local frame = select(i,header:GetChildren())
	--			if frame == nil  then return end
	--			if frame.unitType and not frame.configUnitID then
	--				frame.configUnitID = header.groupID and (header.groupID*5) - 5 + i or i
	--				frame:SetAttribute("unit",ns[header.unitType.."Units"][frame.configUnitID])
	--			end
	--			obj = frame
	--		end
	--	end
	elseif unit == "partytarget" then
	
	elseif unit == "partypet" then

	elseif unit == "boss" then
		obj = ns.unitFrames.boss
		end
	return obj
end

local function GetDB(unit)
	local unitdb = ns:GetUnitDB(unit) 
	--if string.match(unit,"^party(%d)$") then
	--	unitdb = ns:GetUnitDB("party")
	--end
	return unitdb
end



--[functions for ACE3 GUI color control]
style.getColor = function(colors)
return colors[1],colors[2],colors[3],colors[4]
end
style.setColor = function(unit,element,key,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb[element][key].color[1] = r
	unitdb[element][key].color[2] = g
	unitdb[element][key].color[3] = b
	unitdb[element][key].color[4] = a
	local type = obj[element][key]:GetObjectType()
	local setTypeColor = {
		["Texture"] = function(e,v) e:SetVertexColor(unpack(v)) end,
		["Frame"] = function(e,v) 
			e:SetBackdropBorderColor(unpack(v)) 
			e:SetBackdropColor(unpack(v)) 
		end,
	}
	do
		setTypeColor[type](obj[element][key],unitdb[element][key].color)
	end
end

style.setHpColor = function(unit,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Health.colorH[1] = r
	unitdb.Health.colorH[2] = g
	unitdb.Health.colorH[3] = b
	unitdb.Health.colorH[4] = a
	obj.Health:SetStatusBarColor(unpack(unitdb.Health.colorH))
	--obj.Health:ForceUpdate()
end

style.setPpColor = function(unit,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Power.colorP[1] = r
	unitdb.Power.colorP[2] = g
	unitdb.Power.colorP[3] = b
	unitdb.Power.colorP[4] = a
	obj.Power:SetStatusBarColor(unpack(unitdb.Power.colorP))
end

style.setCbColor = function(unit,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Castbar.color[1] = r
	unitdb.Castbar.color[2] = g
	unitdb.Castbar.color[3] = b
	unitdb.Castbar.color[4] = a
	obj.Castbar:SetStatusBarColor(unpack(unitdb.Castbar.color))
end

--[end]


--设置元素的尺寸(初始加载和设置菜单中使用 1级键值方法)
--[int value] 宽度或者高度的值(可选), string key 宽度或者高度的键, string element 元素对象名, int scale 比例, [object obj] 单位(可选)
--可选参数代表如果不传参数或者用哑元即直接读取unitdb中对应的键值 一般在初始化时候可不传参 以下同
style.SetElementSize = function(unit,value,key,element,scale)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb[element][key] end
	unitdb[element][key] = value
	if element == "Parent" then obj[element] = obj end
	if not scale then scale = 1 end
	--if unit == "party" then print(obj) end
	local func = {
		["width"] = function(v,s,e)
			e:SetWidth(v*s) 
		end,
		["height"] = function(v,s,e) 
			e:SetHeight(v*s) 
		end,
	}
	do
		func[key](unitdb[element][key],scale,obj[element])
	end
end


--设置元素的颜色(初始加载和设置菜单中使用 1级键值方法)
--string element 元素对象名 [table color] 颜色表(可选),[object obj] 单位(可选)
style.SetElementColor = function(unit,element,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not color then color = unitdb[element].color end
	unitdb[element].color = color
	local objType = obj[element]:GetObjectType()
	local func  = {
		["PlayerModel"] = function(v,e,db) 
			end,
		["Button"] = function(v,e)

			end,
		["StatusBar"] = function(v,e,db)
				e:SetStatusBarColor(unpack(v))
				db = v
			end,
		["Frame"] = function(v,e,db) 
			end,
		["Texture"] = function(v,e,db)
				e:SetVertexColor(unpack(v))
				db = v
			end,
	}
	do
		func[objType](color,obj[element],unitdb[element].color)
	end
end

--设置元素的材质(初始化和设置菜单使用 1级键值方法)
--string element 元素的对象名 [string texture] 材质(可选) [object obj] 单位(可选)
style.SetElementTexture = function(unit,element,texture)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not texture then texture = unitdb.tex.barTex end
	local type = obj[element]:GetObjectType()
	local func = {
		["StatusBar"] = function(v,e,db)
			e:SetStatusBarTexture(v)
		end,
		["Frame"] = function(v,e,db)
			e:SetTexture(v)
		end,
		["Texture"] = function(v,e,db)
			e:SetTexture(v)
		end,
	}
	do
		func[type](texture,obj[element],unitdb.Health.tex)
	end
end

--设置对象的背景的材质和颜色(初始化和设置菜单中使用 1级键值方法)
--string element 元素对象名 [string texture] 材质(可选) [table color]背景色表(可选) [object obj] 单位(可选)
style.SetElementBackGroundTextrueAndColor = function(unit,element,texture,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	--if not texture then texture = unitdb[element].background.tex end
	if not texture then texture = unitdb.tex.barTex end
	if not color then color = unitdb[element].background.color or unitdb.colors.bgColor end
	--if not color then color = unitdb[element].background.color end 
	unitdb[element].background.tex = texture 
	unitdb[element].background.color = color 
	obj[element].background:SetAllPoints(obj[element])
	obj[element].background:SetTexture(unitdb.tex.barTex)
	obj[element].background:SetVertexColor(unpack(unitdb[element].background.color))
	obj[element].background:SetBlendMode("ALPHAKEY")
end

--设置元素边框粗细和材质和颜色(初始化和设置菜单中使用 1级键值方法)
--string element 元素对象名 [int value] 边框的粗细(可选) [string texture] 边框的材质(可选) [table color] 边框颜色表(可选) [object obj] 单位(可选)
style.SetElementBorderValueAndTextureAndColor = function(unit,element,value,texture,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb[element].border.value end
	if not texture then texture = unitdb.tex.borderTex end
	if not color then color = unitdb[element].border.color or unitdb.colors.brdColor end
--	if not texture then texture = unitdb[element].border.tex end
--	if not color then color = unitdb[element].border.color end
	unitdb[element].border.value = value
	unitdb[element].border.tex = texture
	unitdb[element].border.color = color
	obj[element].border:SetPoint("TOPLEFT",obj[element],"TOPLEFT",0-unitdb[element].border.value,unitdb[element].border.value)
	obj[element].border:SetPoint("BOTTOMRIGHT",obj[element],"BOTTOMRIGHT",unitdb[element].border.value,0-unitdb[element].border.value)
	obj[element].border:SetBackdrop(unitdb.tex.borderTex)
	--obj[element].border:SetBackdropColor(unitdb[element].border.color ~=nil and unpack(unitdb[element].border.color) or unpack(unitdb.colors.brdBgColor))
	obj[element].border:SetBackdropColor(unpack(unitdb[element].border.color))
	--obj[element].border:SetBackdropColor(0,0,0,0)
	obj[element].border:SetBackdropBorderColor(unpack(unitdb[element].border.color))
	obj[element].border:SetFrameLevel(0)
end

--设置元素的层级(初始化和设置菜单中使用 1级键值方法)
--string element 元素对象名 [int value] 元素的层级(可选) [object obj] 单位(可选)
style.SetElementFrameLevel = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb[element].frameLevel end
	unitdb[element].frameLevel = value
	obj[element]:SetFrameLevel(unitdb[element].frameLevel)
	--print(obj[element].border:GetFrameLevel(),obj[element]:GetFrameLevel())
	--print(obj[element]:GetFrameLevel())
end

--设置元素的透明度(初始化和设置菜单中使用 1级键值方法)
--string element 元素对象名 [int value] 元素的透明度 [object obj] 单位(可选)
style.SetElementAlpha = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb[element].alpha end
	unitdb[element].alpha = value
	obj[element]:SetAlpha(unitdb[element].alpha)
end

-------元素定位 分开写了..

--Health 定位(头像的位置 水平坐标 垂直坐标 单位)
style.SetHealthPosition = function(unit,point,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not point then point = unitdb.Portrait.position.point end
	if not x then x = unitdb.Health.position.x  end
	if not y then y = unitdb.Health.position.y  end
	unitdb.Health.position.x = x
	unitdb.Health.position.y = y
	obj.Health:SetPoint("TOPLEFT",obj.bg,"TOPLEFT",unitdb.Health.position.x,unitdb.Health.position.y)
	--local setPoint = {
	--	["LEFT"]  = function(hp,x,y) 
	--			hp:ClearAllPoints()
	--			hp:SetPoint("TOPLEFT",obj.bg,"TOPLEFT", x + unitdb.Portrait.width + 4 ,y) 
	--		end,
	--	["RIGHT"] = function(hp,x,y)
	--			hp:ClearAllPoints()
	--			hp:SetPoint("TOPRIGHT",obj.bg,"TOPRIGHT", x + unitdb.Portrait.width + 4,y) 
	--		end,
	--	["FULL"]  = function(hp,x,y)
	--			hp:ClearAllPoints()
	--			hp:SetPoint("TOPLEFT",obj.bg,"TOPLEFT", x, y) 
	--		end,
	--	["NONE"]  = function(hp,x,y)
	--		hp:ClearAllPoints()
	--		hp:SetPoint("TOPLEFT",obj.bg,"TOPLEFT", x, y) 
	--	end,
	--}
	--do 
	--	setPoint[point](obj.Health,unitdb.Health.position.x,unitdb.Health.position.y)
	--end
end

style.forceUpdateHP = function(unit,value,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Health.color = value
	obj.Health[unitdb.Health.color] = true
	if(unitdb.Health.color == "colorHealth") then 
	local r,g,b,a = unpack(color)	
		unitdb.Health.colorH[1] = r
		unitdb.Health.colorH[2] = g
		unitdb.Health.colorH[3] = b
		unitdb.Health.colorH[4] = a
		obj.Health.colorClass = nil
		obj.Health.colorSmooth = nil
		obj.Health.colorReaction = nil
		obj.Health.colorHealth = true
		obj.Health:SetStatusBarColor(unitdb.Health.colorH[1],unitdb.Health.colorH[2],unitdb.Health.colorH[3],unitdb.Health.colorH[4])
	end
	obj.Health:ForceUpdate()
end

style.forceUpdatePower = function(unit,value,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Power.color = value
	obj.Power[unitdb.Power.color] = true
	if(unitdb.Power.color == "colorCustom") then
		local r,g,b,a = unpack(color)
		unitdb.Power.colorP[1] = r
		unitdb.Power.colorP[2] = g
		unitdb.Power.colorP[3] = b
		unitdb.Power.colorP[4] = a
		obj.Power.colorClass = nil
		obj.Power.colorSmooth = nil
		obj.Power.colorPower = nil
		obj.Power.colorCustom = nil
		obj.Power:SetStatusBarColor(unpack(unitdb.Power.colorP))
	end
	obj.Power:ForceUpdate()
end


--Health 颜色(颜色表 单位)
style.SetHealthColor = function(unit,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.Health.colorClass = nil 
	obj.Health.colorSmooth = nil 
	obj.Health.colorHealth = nil 
	
	if not color then color = unitdb.Health.color end 
		unitdb.Health.color = color
		obj.Health[unitdb.Health.color] = true	
		if unitdb.Health.color == "colorHealth" then
			obj.Health:SetStatusBarColor(unpack(unitdb.Health.colorH))
		end

	--obj.Health.PostUpdate = style.SetHealthColor(unit,color)
end

--Power 定位(头像的位置 水平坐标 垂直坐标 单位)
style.SetPowerPosition = function(unit,point,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not point then point = unitdb.Portrait.position.point end
	if not x then x = unitdb.Power.position.x end
	if not y then y = unitdb.Power.position.y end
	unitdb.Power.position.x = x
	unitdb.Power.position.y = y
	obj.Power:SetPoint("TOPLEFT",obj.bg,"TOPLEFT",unitdb.Power.position.x,unitdb.Power.position.y)
--	local setPoint = {
--		["LEFT"] = function(mp,x,y) 
--				mp:ClearAllPoints()
--				mp:SetPoint("TOPLEFT",obj.Health,"BOTTOMLEFT", x, y - unitdb.Parent.spacing*2) 
--			end,
--		["RIGHT"] = function(mp,x,y) 
--				mp:ClearAllPoints()
--				mp:SetPoint("TOPRIGHT",obj.Health,"BOTTOMRIGHT", x, y - unitdb.Parent.spacing*2) 
--			end,		
--		["FULL"] = function(mp,x,y)
--				mp:ClearAllPoints()
--				mp:SetPoint("TOPLEFT",obj.Health,"BOTTOMLEFT", x, y - unitdb.Parent.spacing*2) 
--			end,
--		["NONE"] = function(mp,x,y) 
--				mp:ClearAllPoints()
--				mp:SetPoint("TOPLEFT",obj.Health,"BOTTOMLEFT", x, y - unitdb.Parent.spacing*2) 
--			end,
--	}
--	do
--		setPoint[point](obj.Power,unitdb.Power.position.x,unitdb.Power.position.y)
--	end
end

--Power 颜色(颜色表 单位)
style.SetPowerColor = function(unit,color)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not color then color = unitdb.Power.color end
	obj.Power.colorClass = nil 
	obj.Power.colorSmooth = nil 
	obj.Power.colorPower = nil 
	obj.Power.colorCustom = nil
	if unitdb.Power.color == "colorCustom" then
		obj.Power[unitdb.Power.color] = nil
		obj.Power:SetStatusBarColor(unpack(unitdb.Power.colorP))
	else
		obj.Power[unitdb.Power.color] = true
	end
end

--Portrait 定位(水平坐标 垂直坐标 位置 单位) --附赠开关特效 选择NONE即可..
style.SetPortraitPosition = function(unit,x,y,point)
	local obj = GetObject(unit)
	local unitdb = GetDB(unit)
	if not point then point = unitdb.Portrait.position.point end
	if not x then x = unitdb.Portrait.position.x end
	if not y then y = unitdb.Portrait.position.y end
	unitdb.Portrait.position.point = point 
	unitdb.Portrait.position.x = x
	unitdb.Portrait.position.y = y
	obj.Portrait:SetPoint("TOPLEFT",obj.bg,"TOPLEFT",unitdb.Portrait.position.x,unitdb.Portrait.position.y)
	--local setPoint = {
	--	["LEFT"] = function(p,x,y)
	--		p:ClearAllPoints()
	--		p:SetAlpha(1)
	--		p:SetPoint("TOPLEFT",obj.bg,"TOPLEFT",x,y)
	--	end,
	--	["RIGHT"] = function(p,x,y)
	--		p:ClearAllPoints()
	--		p:SetAlpha(1)
	--		p:SetPoint("TOPRIGHT",obj.bg,"TOPRIGHT",x,y)
	--	end,
	--	["FULL"] = function(p)
	--		p:ClearAllPoints()
	--		p:SetAlpha(.7)
	--		p:SetAllPoints(obj.bg)
	--	end,
	--	["NONE"] = function(p)
	--		p:ClearAllPoints()
	--		p:SetAlpha(0)
	--		p:SetAllPoints(obj.bg)
	--	end,
	--}
	--do
	--	setPoint[point](obj.Portrait,unitdb.Portrait.position.x,unitdb.Portrait.position.y)
	--end
end

--Castbar定位(水平坐标 垂直坐标 单位)
style.SetCastbarPosition = function(unit,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Castbar.position.x end
	if not y then y = unitdb.Castbar.position.y end
	unitdb.Castbar.position.x = x
	unitdb.Castbar.position.y = y
	obj.Castbar:SetPoint("TOPLEFT",obj,"BOTTOMLEFT",unitdb.Castbar.position.x,unitdb.Castbar.position.y - unitdb.Parent.spacing*2)
end


style.SetCastbarText = function(unit,x,y,flag,fontSize)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Castbar.Text.position.x end
	if not y then y = unitdb.Castbar.Text.position.y end
	if not flag then flag = unitdb.Castbar.Text.flag end
	if not fontSize then fontSize = unitdb.Castbar.Text.fontSize end
	unitdb.Castbar.Text.position.x = x
	unitdb.Castbar.Text.position.y = y
	unitdb.Castbar.Text.flag = flag 
	unitdb.Castbar.Text.fontSize = fontSize
	obj.Castbar.Text:SetFontObject(ChatFontNormal)
	do 
		local font,size,fl = obj.Castbar.Text:GetFont() 
		obj.Castbar.Text:SetFont(font,fontSize,flag)
	end
	obj.Castbar.Text:SetPoint("CENTER",obj.Castbar,"CENTER",unitdb.Castbar.Text.position.x,unitdb.Castbar.Text.position.y)
end


--设置施法条边框
style.SetCastbarBorder = function(unit,value,r,g,b,a) --赠送施法条背景...
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value  = unitdb.Castbar.background.value end 
	if not r then r = unitdb.Castbar.background.color[1] end
	if not g then g = unitdb.Castbar.background.color[2] end
	if not b then b = unitdb.Castbar.background.color[3] end
	if not a then a = unitdb.Castbar.background.color[4] end
	unitdb.Castbar.background.color[1] = r
	unitdb.Castbar.background.color[2] = g
	unitdb.Castbar.background.color[3] = b
	unitdb.Castbar.background.color[4] = a
	unitdb.Castbar.background.value = value 
	obj.Castbar.border:SetBackdrop(unitdb.tex.borderTex)
	obj.Castbar.border:SetPoint("TOPLEFT", obj.Castbar, "TOPLEFT", 0 - value, value)
	obj.Castbar.border:SetPoint("BOTTOMRIGHT",obj.Castbar,"BOTTOMRIGHT", value, 0 - value)
	obj.Castbar.border:SetBackdropColor(unpack(unitdb.Castbar.background.color))
	obj.Castbar.border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	obj.Castbar.border:SetFrameLevel(0)
end

--设置施法条图标尺寸
style.SetCastbarIconSize = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Castbar.Icon.size end
	unitdb.Castbar.Icon.size = value
	obj.Castbar.Icon:SetWidth(unitdb.Castbar.Icon.size)
	obj.Castbar.Icon:SetHeight(unitdb.Castbar.Icon.size)
	obj.Castbar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
end

style.SetCastbarIconPosition = function(unit,point,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Castbar.Icon.position.x end
	if not y then y = unitdb.Castbar.Icon.position.y end
	if not point then point = unitdb.Castbar.Icon.position.point end
	unitdb.Castbar.Icon.position.point = point
	unitdb.Castbar.Icon.position.x = x
	unitdb.Castbar.Icon.position.y = y


	local setPoint = {
		["LEFT"] = function(e,x,y) 
			e:ClearAllPoints()
			e:SetAlpha(1)
			e:SetPoint("BOTTOMRIGHT",obj.Castbar,"BOTTOMLEFT",x+unitdb.Parent.spacing*2,y)		
		end,
		["RIGHT"] = function(e,x,y)
			e:ClearAllPoints()
			e:SetAlpha(1)
			e:SetPoint("BOTTOMLEFT",obj.Castbar,"BOTTOMRIGHT",x+unitdb.Parent.spacing*2,y)
		end,
		["NONE"] = function(e,x,y)
			e:SetAlpha(0)
		end,
	}
	do 
		setPoint[point](obj.Castbar.Icon,unitdb.Castbar.Icon.position.x,unitdb.Castbar.Icon.position.y)
	end
end

style.SetCastbarIconBorder = function(unit,value,color)
		local obj,unitdb = GetObject(unit),GetDB(unit)
		if not value then value = unitdb.Castbar.Icon.border.value end
		if not color then color = unitdb.Castbar.Icon.border.color end
		obj.Castbar.Icon.border:SetPoint('TOPLEFT', obj.Castbar.Icon, 'TOPLEFT', 0-value , value)
		obj.Castbar.Icon.border:SetPoint('BOTTOMRIGHT', obj.Castbar.Icon, 'BOTTOMRIGHT', value, 0-value)
		obj.Castbar.Icon.border:SetBackdrop(unitdb.tex.borderTex)
		obj.Castbar.Icon.border:SetBackdropColor(unpack(unitdb.colors.brdBgColor))
		obj.Castbar.Icon.border:SetBackdropBorderColor(unpack(color))
		obj.Castbar.Icon.border:SetFrameLevel(1)
end

style.IndicatorsConfig = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	local indCfg = {}
	for key ,value in pairs(unitdb.Indicators) do
		indCfg[key] = {
			type = "group",
			order = ns.order(),
			inline = true,
			name = L[key],
			desc = L[key],
			args = {
			--	enable = {
			--		type = "toggle",
			--		order = ns.order(),
			--		name = L["Enable"],
			--		desc = L["Enable"],
			--		get = function() return unitdb.Indicators[key].enable end,
			--		set = function(_,v)
			--			style.ToggleIndicators(unit,key,v)
			--		end,
			--	},
				size = {
					type = "range",
					order = ns.order(),
					name = L["Size"],
					desc = L["Size"],
					min = 1, max = 400, step = 1,
					get = function() return unitdb.Indicators[key].size end,
					set = function(_,v)
						style.SetIndicatorsSize(unit,key,v,1)
					end,
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
							min = -400, max = 400, step = 1,
							get = function() return unitdb.Indicators[key].position.x end,
							set = function(_,v)
								style.SetIndicatorsPosition(unit,key,v,unitdb.Indicators[key].position.y)
							end,
						},
						y = {
							type = "range",
							order = ns.order(),
							name = L["y"],
							desc = L["y"],
							min = -400, max = 400, step = 1,
							get = function() return unitdb.Indicators[key].position.y end,
							set = function(_,v)
								style.SetIndicatorsPosition(unit,key,unitdb.Indicators[key].position.x,v)
							end,
						},
					},
				},
			},
		}
	end
	return indCfg
end


style.ToggleIndicators = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Indicators[element].enable end
	unitdb.Indicators[element].enable = value == true and true or false
	local alpha = unitdb.Indicators[element].enable == true and 1 or 0
	obj[element]:SetAlpha(alpha)	
	end

style.SetIndicatorsSize = function(unit,element,value,scale)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value =	unitdb.Indicators[element].size end
	if not scale then scale = 1 end
	obj[element]:SetWidth(value*scale)
	obj[element]:SetHeight(value*scale)
	unitdb.Indicators[element].size = value
end

style.SetIndicatorsPosition = function(unit,element,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Indicators[element].position.x end
	if not y then y = unitdb.Indicators[element].position.y end
	unitdb.Indicators[element].position.x = x
	unitdb.Indicators[element].position.y = y
	local point = unitdb.Indicators[element].position.point 
	local pos = unitdb.Indicators[element].position.relativePoint
	local anchorTo = unitdb.Indicators[element].position.anchorTo
	local setPoint = {
		["Health"] = function(e,p,a,x,y) 
			e:ClearAllPoints()
			e:SetPoint(p,obj.Health,a,x,y) 
		end,
		["Power"] = function(e,p,a,x,y)
			e:ClearAllPoints()
			e:SetPoint(p,obj.Power,a,x,y)
		end,
		["Portrait"] = function(e,p,a,x,y)
			e:ClearAllPoints()
			e:SetPoint(p,obj.Portrait,a,x,y)
		end,
		["FULL"] = function(e,p,a,x,y) 
			e:ClearAllPoints()
			e:SetPoint(p,obj,a,x,y) 
		end,
	}
	do 
		setPoint[pos](obj[element],point,anchorTo,x,y)
	end
end


style.TagsConfig = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	local tagCfg = {}
	for key,value in pairs(unitdb.tags) do
		tagCfg[key] = {
			type = "group",
			order = ns.order(),
			name = L[key],
			desc = L[key],
			inline = true,
			args = {
			--	enable = {
			--		type = "toggle",
			--		order = ns.order(),
			--		name = L["Enable"],
			--		desc = L["Enable"],
			--		get = function() return unitdb.tags[key].enable end,
			--		set = function(_,v)
			--			style.ToggleTags(unit,key,v)
			--		end,
			--	},
				fontSize = {
					type = "range",
					order = ns.order(),
					name = L["Font size"],
					desc = L["Font size"],
					min = 1, max = 64, step = 1,
					get = function() return unitdb.tags[key].fontSize end,
					set = function(_,v)
						style.SetTagsFontSize(unit,key,v)
					end,
				},
				flag = {
					type = "select",
					order = ns.order(),
					name = L["Font flag"],
					desc = L["Font flag"],
					values = style.FontFlagValue(),
					get = function() return unitdb.tags[key].flag end,
					set = function(_,v)
						style.SetTagsFontFlag(unit,key,v)
					end,
				},
				tag = {
					type = "group",
					order = ns.order(),
					inline = true,
					name = L["Tag"],
					desc = L["Tag"],
					args = {
						dropTag = {
							type = "select",
							order = ns.order(),
							name = L["Select tags"],
							desc = L["Select tags"],
							values = style.TagsValue(),
							get = function() return unitdb.tags[key].tag end,
							set = function(_,v)
									style.SetTags(unit,key,v)						
							end,
						},
						inputTag = {
							type = "input",
							order = ns.order(),
							name = L["Enter tags"],
							desc = L["Enter tags"],
							get = function() return unitdb.tags[key].tag end,
							set = function(_,v)
								style.SetTags(unit,key,v)	
							end,
						},
					},
				},
			},
		}
	end

	return tagCfg 
end



style.ToggleTags = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.tags[element].enable end
	unitdb.tags[element].enable = value
	if unitdb.tags[element].enable then
		obj.tags[element]:SetAlpha(1)
	else
		obj.tags[element]:SetAlpha(0)
	end
end

style.SetTagsFontSize = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.tags[element].fontSize end
	unitdb.tags[element].fontSize = value
	do
		local font,size,flag = obj.tags[element]:GetFont()
		obj.tags[element]:SetFont(font,unitdb.tags[element].fontSize,flag)
	end
end

style.SetTagsFontFlag = function(unit,element,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.tags[element].flag end
	unitdb.tags[element].flag = value
	local font,size,flag = obj.tags[element]:GetFont()
	local setFlag = {
		NORMAL = function(fs,f,s) fs:SetFont(f,s,"NORMAL") end,
		OUTLINE = function(fs,f,s) fs:SetFont(f,s,"OUTLINE")  end,
		THICKOUTLINE = function(fs,f,s) fs:SetFont(f,s,"THICKOUTLINE") end,
		MONOCHROME = function(fs,f,s) fs:SetFont(f,s,"MONOCHROME") end,
	}
	do
		setFlag[value](obj.tags[element],font,size)
	end
end


style.SetTagsPosition = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	
	local temp = {}
	for key,value in pairs(unitdb.tags) do
		for w in string.gmatch(key,"%u+%l+") do
			table.insert(temp,w)	
		end
	end

	local point = {}
	for i = 1,#temp do
		if i%2 == 1 then
			table.insert(point,{temp[i],temp[i+1]})
		end
	end
	local setParentPoint = {
		["Bottomleft"] = function(e,v) e:SetPoint("TOPLEFT",obj,v,0,0) end,
		["Bottom"] = function(e,v) e:SetPoint("TOP",obj,v,0,0) end,
		["Bottomright"] = function(e,v) e:SetPoint("TOPRIGHT", obj,v,0,0) end,
		["Topleft"] = function(e,v) e:SetPoint("BOTTOMLEFT",obj,v,0,0) end,
		["Top"] = function(e,v) e:SetPoint("BOTTOM",obj,v,0,0) end,
		["Topright"] = function(e,v) e:SetPoint("BOTTOMRIGHT",obj,v,0,0) end,
	}
	local setPoint = {
		["Parent"] = function(e,v) do setParentPoint[v](e,v) end end,
		["Health"] = function(e,v) e:SetPoint(v,obj.Health,v,0,0) end,
		["Portrait"] = function(e,v) e:SetPoint(v,obj.Portrait,v,0,0) end,
		["Power"] = function(e,v) e:SetPoint(v,obj.Power,v,0,0) end,
	}

	for i=1,#point do
		local pos = point[i][1]
		local tagk = point[i][1]..point[i][2]
		do
			setPoint[pos](obj.tags[tagk],point[i][2])
		end
	end
end

style.SetTags = function(unit,element,value)
	local unitdb = GetDB(unit)
	if not value then value  = unitdb.tags[element].tag end
	unitdb.tags[element].tag = value
	ns:Reload(unit)
end


style.PortraitPositionValue = function()
	local positions = {
		["NONE"] = L["NONE"],
		["LEFT"] = L["LEFT"],
		["RIGHT"] = L["RIGHT"],
		["FULL"] = L["FULL"],
	}
	return positions
end

style.FontFlagValue = function()
	local flag = {
		["OUTLINE"] = L["OUTLINE"], 
		["THICKOUTLINE"] = L["THICKOUTLINE"],
		["MONOCHROME"] = L["MONOCHROME"],
		["NORMAL"] = L["NORMAL"],
	}
	return flag
end

style.TagsValue = function()
	local tags = {
		[""] = L["NONE"],
		--name
		["[name]"] = L["name"],
		["[colorname]"] = L["colorname"],
		["[def:name]"] = L["defname"],
		--level
		["[level]"] = L["level"],
		["[levelcolor]"] = L["levelcolor"],
		["[smartlevel]"] = L["smartlevel"],
		--hp
		["[curhp]"] = L["curhp"],
		["[maxhp]"]=L["maxhp"],
		["[perhp]"]=L["perhp"],
		["[curmaxhp]"]=L["curmaxhp"],
		["[absolutehp]"] = L["absolutehp"], 
		["[abscurhp]"] = L["abscurhp"],
		["[absmaxhp]"] = L["absmaxhp"],
		["[missinghp]"] = L["missinghp"], 
		["[smart:curmaxhp]"] = L["smart:curmaxhp"],	
		--mp
		["[curpp]"] = L["curpp"],
		["[maxpp]"]=L["maxpp"],
		["[perpp]"] = L["perpp"],
		["[curmaxpp]"] = L["curmaxpp"],
		["[absolutepp]"] = L["absolutepp"],
		["[abscurpp]"] = L["abscurpp"],
		["[absmaxpp]"] = L["absmaxpp"],
		["[smart:curmaxpp]"]=L["smart:curmaxpp"],	
	} 
	return tags
end

style.GetTagValue = function(tbl,key)
	if not tbl then tbl = style.TagsValue end
	return tbl[key]
end

style.ToggleCombatFeedbackText = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.CombatFeedbackText.enable end
	unitdb.CombatFeedbackText.enable = value
	if unitdb.CombatFeedbackText.enable then
		obj.CombatFeedbackText:SetAlpha(.8)
	else
		obj.CombatFeedbackText:SetAlpha(0)
	end
end

style.SetCombatFeedbackText = function(unit,fontSize,flag)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not fontSize then fontSize = unitdb.CombatFeedbackText.fontSize end
	if not flag then flag = unitdb.CombatFeedbackText.flag end
	unitdb.CombatFeedbackText.fontSize = fontSize
	unitdb.CombatFeedbackText.flag = flag
	local f,s,fl = obj.CombatFeedbackText:GetFont()
	do 
		obj.CombatFeedbackText:SetFont(f,fontSize,flag)
	end
end

style.SetCombatFeedbackTextPosition = function(unit,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	local position = unitdb.CombatFeedbackText.position 
	if not x then x = position.x end
	if not y then y = position.y end
	unitdb.CombatFeedbackText.position.x = x
	unitdb.CombatFeedbackText.position.y = y
	do
		obj.CombatFeedbackText:SetPoint(position.point,obj[position.relativePoint],position.anchorTo,x,y)
	end
end

style.AddCombatIcon = function(unit)
	local obj = GetObject(unit)
	obj.Combat:SetTexture([[Interface\CharacterFrame\UI-StateIcon]])
	obj.Combat:SetBlendMode("ADD")
	obj.Combat:SetTexCoord(0.5,1,0.5,1)
	
end

style.SetCombatIconSize = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Combat.size end
	unitdb.Combat.size = value
	obj.Combat:SetWidth(unitdb.Combat.size)
	obj.Combat:SetHeight(unitdb.Combat.size)
end

style.SetCombatIconPosition = function(unit,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Combat.position.x end
	if not y then y = unitdb.Combat.position.y end
	unitdb.Combat.position.x = x
	unitdb.Combat.position.y = y
	obj.Combat:SetPoint(unitdb.Combat.position.point,obj.Health,unitdb.Combat.position.anchorTo,unitdb.Combat.position.x,unitdb.Combat.position.y)
end
	

style.AddSpecialElement2 = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	local class = select(2,UnitClass"player")
		local addSElement = {
		["DEATHKNIGHT"] = function()
				obj.Runes = CreateFrame("Frame",nil,obj)
				for i=1,6 do
					obj.Runes[i] = CreateFrame("StatusBar",obj:GetName().."_Shards"..i,obj)
					obj.Runes[i].Border = CreateFrame("Frame",nil,obj)
					obj.Runes[i]:SetStatusBarTexture(unitdb.tex.barTex)
					--obj.Runes[i]:SetStatusBarColor(.5,0,.56,1)
				--	obj.Runes[i]:SetStatusBarColor(1,0,0,1)
				end
		end,
		["SHAMAN"] = function()
				obj.Totems = CreateFrame("Frame",nil,obj.bg)
				for i = 1,4 do
					obj.Totems[i] = CreateFrame("StatusBar",obj:GetName().."_Shards"..i,obj)
					obj.Totems[i].Border = CreateFrame("Frame",nil,obj)
					obj.Totems[i]:SetStatusBarTexture(unitdb.tex.barTex)
					local setTotemsColor = {
						[1] = function(e) e:SetStatusBarColor(1,0,0,1) end,
						[2] = function(e) e:SetStatusBarColor(1,.6,0,1) end,
						[3] = function(e) e:SetStatusBarColor(.12,.6,1,1) end,
						[4] = function(e) e:SetStatusBarColor(.14,.55,.14,1) end,
					}
					do
						setTotemsColor[i](obj.Totems[i])
					end
				end
		end,
		["DRUID"] = function()
				obj.DruidMana = CreateFrame("StatusBar",nil,obj)
				obj.DruidMana.Border = CreateFrame("Frame",nil,obj)
				obj.EclipseBar = CreateFrame("Frame",nil,obj)
				obj.EclipseBar.Border = CreateFrame("Frame",nil,obj)
				local lunarBar = CreateFrame("StatusBar",nil,obj.EclipseBar)
				local solarBar = CreateFrame("StatusBar",nil,obj.EclipseBar)
				obj.EclipseBar.LunarBar = lunarBar
				obj.EclipseBar.SolarBar = solarBar
				obj.DruidMana:SetStatusBarTexture(unitdb.tex.barTex)
				obj.DruidMana:SetStatusBarColor(.3,.5,.85)
				obj.EclipseBar.LunarBar:SetStatusBarTexture(unitdb.tex.barTex)
				obj.EclipseBar.LunarBar:SetStatusBarColor(.34,.1,.86,1)
				obj.EclipseBar.SolarBar:SetStatusBarTexture(unitdb.tex.barTex)
				obj.EclipseBar.SolarBar:SetStatusBarColor(.95,.73,.15,1)
		end,
		["PALADIN"] = function()
				obj.HolyPower = CreateFrame("Frame",nil,obj)
				for i =1,3 do
					obj.HolyPower[i] = CreateFrame("StatusBar",obj:GetName().."_Shards"..i,obj)
					obj.HolyPower[i].Border = CreateFrame("Frame",nil,obj)
					obj.HolyPower[i]:SetStatusBarTexture(unitdb.tex.barTex)
					obj.HolyPower[i]:SetStatusBarColor(.96,.93,.15,1)
				end
		end,
		["WARLOCK"] = function()
				obj.SoulShards = CreateFrame("Frame",nil,obj)
				for i =1,3 do
					obj.SoulShards[i] = CreateFrame("StatusBar",obj:GetName().."_Shards"..i,obj)
					obj.SoulShards[i].Border = CreateFrame("Frame",nil,obj)
					obj.SoulShards[i]:SetStatusBarTexture(unitdb.tex.barTex)
					obj.SoulShards[i]:SetStatusBarColor(.58,.51,.79,1)
				end
		end,
		["MAGE"] = function() return end,
		["WARRIOR"] = function() return end,
		["PRIEST"] = function() return end,
		["ROGUE"] = function() return end,
		["HUNTER"] = function() return end,
	}
	do
		addSElement[class]()
	end
end

style.SetSpecialElementSize = function(unit,width,height,bv)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not width then width = unitdb.SpecialElement.width end
	if not height then height = unitdb.SpecialElement.height end
	if not bv then bv = unitdb.SpecialElement.border.value end
	unitdb.SpecialElement.width = width
	unitdb.SpecialElement.height = height

	local class = select(2,UnitClass"player")
	local setSElementSize = {
		["DEATHKNIGHT"] = function(w,h,v)
			for i = 1,6 do
				obj.Runes[i]:SetWidth(w/6-v*1.5)
				obj.Runes[i]:SetHeight(h)
			end
		end,
		["SHAMAN"] = function(w,h,v)
			for i = 1,4 do
				obj.Totems[i]:SetWidth(w/4-v*2)
				obj.Totems[i]:SetHeight(h)
			end
		end,
		["DRUID"] = function(w,h,v)
			obj.DruidMana:SetWidth(w-v*2.5)
			obj.DruidMana:SetHeight(h)
			obj.EclipseBar:SetWidth(w-v*2.5)
			obj.EclipseBar:SetHeight(h)
			obj.EclipseBar.LunarBar:SetWidth(w-v*2.5)
			obj.EclipseBar.LunarBar:SetHeight(h)
			obj.EclipseBar.SolarBar:SetWidth(w-v*2.5)
			obj.EclipseBar.SolarBar:SetHeight(h)
		end,
		["PALADIN"] = function(w,h,v) 
			for i=1,3 do
				obj.HolyPower[i]:SetWidth(w/3-v*2)
				obj.HolyPower[i]:SetHeight(h)
			end
		end,
		["WARLOCK"] = function(w,h,v)
			for i = 1,3 do
				obj.SoulShards[i]:SetWidth(w/3-v*2)
				obj.SoulShards[i]:SetHeight(h)
			end
		end,
		["MAGE"] = function(...) return end,
		["WARRIOR"] = function(...) return end,
		["PRIEST"] = function(...) return end,
		["HUNTER"] = function(...) return end,
		["ROGUE"] = function(...) return end,
	}
	do
		setSElementSize[class](unitdb.SpecialElement.width,unitdb.SpecialElement.height,unitdb.SpecialElement.border.value)
	end
end

style.SetSpecialElementBorder = function(unit,value)
local obj,unitdb = GetObject(unit),GetDB(unit)
if not value then value = unitdb.SpecialElement.border.value end
unitdb.SpecialElement.border.value = value
	local class = select(2,UnitClass"player")
	local function setBorder(e,v)
		e.Border:SetPoint("TOPLEFT",e,0-v,v)
		e.Border:SetPoint("BOTTOMRIGHT",e,v,0-v)
	end
	local setSElementBorder = {
		["DEATHKNIGHT"] = function(v)
			for i=1,6 do
				setBorder(obj.Runes[i],v)
			end
		end,
		["SHAMAN"] = function(v)
			for i =1,4 do
				setBorder(obj.Totems[i],v)
			end
		end,
		["DRUID"] = function(v)
			setBorder(obj.DruidMana,v)
			setBorder(obj.EclipseBar,v)
		end,
		["PALADIN"] = function(v)
			for i =1,3 do
				setBorder(obj.HolyPower[i],v)
			end
		end,
		["WARLOCK"] = function(v)
			for i=1,3 do
				setBorder(obj.SoulShards[i],v)
			end
		end,
		["MAGE"] = function(v) return end,
		["WARRIOR"] = function(v) return end,
		["PRIEST"] = function(v) return end,
		["HUNTER"] = function(v) return end,
		["ROGUE"] = function(v) return end,
	}
	do
		setSElementBorder[class](unitdb.SpecialElement.border.value)	
	end
end


style.SetSpecialElementBorderColor = function(unit,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not r then r = unitdb.SpecialElement.border.color[1] end
	if not g then g = unitdb.SpecialElement.border.color[2] end
	if not b then b = unitdb.SpecialElement.border.color[3] end
	if not a then a = unitdb.SpecialElement.border.color[4] end
	unitdb.SpecialElement.border.color[1] = r
	unitdb.SpecialElement.border.color[2] = g
	unitdb.SpecialElement.border.color[3] = b
	unitdb.SpecialElement.border.color[4] = a
	local class = select(2,UnitClass"player")
	local function setBorderColor(e,r,g,b,a)
		e.Border:SetBackdrop(unitdb.tex.borderTex)
		e.Border:SetBackdropColor(r,g,b,a)
		e.Border:SetBackdropBorderColor(r,g,b,a)
	end
local setSElementBorderColor = {
	["DEATHKNIGHT"] = function(r,g,b,a)
			for i=1,6 do
				setBorderColor(obj.Runes[i],r,g,b,a)
			end
		end,
		["SHAMAN"] = function(r,g,b,a)
			for i =1,4 do
				setBorderColor(obj.Totems[i],r,g,b,a)
			end
		end,
		["DRUID"] = function(r,g,b,a)
			setBorderColor(obj.DruidMana,r,g,b,a)
			setBorderColor(obj.EclipseBar,r,g,b,a)
		end,
		["PALADIN"] = function(r,g,b,a)
			for i =1,3 do
				setBorderColor(obj.HolyPower[i],r,g,b,a)
			end
		end,
		["WARLOCK"] = function(r,g,b,a)
			for i=1,3 do
				setBorderColor(obj.SoulShards[i],r,g,b,a)
			end
		end,
		["MAGE"] = function(...) return end,
		["WARRIOR"] = function(...) return end,
		["PRIEST"] = function(...) return end,
		["HUNTER"] = function(...) return end,
		["ROGUE"] = function(...) return end,
	}
	do
		setSElementBorderColor[class](unitdb.SpecialElement.border.color[1],unitdb.SpecialElement.border.color[2],unitdb.SpecialElement.border.color[3],unitdb.SpecialElement.border.color[4])
	end
end

style.SetSpecialElementPosition = function(unit,x,y,xOffset,yOffset)
local obj,unitdb = GetObject(unit),GetDB(unit)
if not x then x = unitdb.SpecialElement.position.x end
if not y then y = unitdb.SpecialElement.position.y end
if not xOffset then xOffset = unitdb.SpecialElement.position.xOffset end
if not yOffset then yOffset = unitdb.SpecialElement.position.yOffset end
unitdb.SpecialElement.position.x = x
unitdb.SpecialElement.position.y = y
unitdb.SpecialElement.position.xOffset = xOffset
unitdb.SpecialElement.position.yOffset = yOffset
local function setSElementPosition(e,x,y,xOffset,yOffset,a)
	if not a then a =1 end
	if a > 1 then
		for i=1,a do
			if i == 1 then
				e[i]:SetPoint("TOPLEFT",obj.bg,"TOPLEFT",x,y)
			else
				e[i]:SetPoint("TOPLEFT",e[i-1],"TOPRIGHT",xOffset,0)
			end
		end
	else
		e:SetPoint("TOPLEFT",obj.bg,x,y)
	end
end
	local class = select(2,UnitClass"player")
	local setSElementSize = {
		["DEATHKNIGHT"] = function(x,y,xOffset,yOffset)
			setSElementPosition(obj.Runes,x,y,xOffset,yOffset,6)			
		end,
		["SHAMAN"] = function(x,y,xOffset,yOffset)
			setSElementPosition(obj.Totems,x,y,xOffset,yOffset,4)
		end,
		["DRUID"] = function(x,y,xOffset,yOffset)
			setSElementPosition(obj.DruidMana,x,y,xOffset,yOffset,1)
			setSElementPosition(obj.EclipseBar,x,y,xOffset,yOffset,1)
			obj.EclipseBar.LunarBar:SetPoint("LEFT",obj.EclipseBar)
			obj.EclipseBar.SolarBar:SetPoint("LEFT",obj.EclipseBar.LunarBar:GetStatusBarTexture(),"RIGHT",0,0)
		end,
		["PALADIN"] = function(x,y,xOffset,yOffset)
			setSElementPosition(obj.HolyPower,x,y,xOffset,yOffset,3)
		end,
		["WARLOCK"] = function(x,y,xOffset,yOffset)
			setSElementPosition(obj.SoulShards,x,y,xOffset,yOffset,3)
		end,
		["MAGE"] = function(...) return end,
		["WARRIOR"] = function(...) return end,
		["PRIEST"] = function(...) return end,
		["HUNTER"] = function(...) return end,
		["ROGUE"] = function(...) return end,
	}
	do
		setSElementSize[class](unitdb.SpecialElement.position.x,unitdb.SpecialElement.position.y,unitdb.SpecialElement.position.xOffset,unitdb.SpecialElement.position.yOffset)
	end
end


style.AddComboPoints = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	local class = select(2,UnitClass"player")
	if class == "ROGUE" or class == "DRUID" then
		obj.CPoints:Show()
	else
		obj.CPoints:Hide()
	end
	for i=1,5 do
		obj.CPoints[i] = obj.CPoints:CreateTexture(nil,"OVERLAY")
		obj.CPoints[i].border = CreateFrame("Frame",nil,obj.CPoints)
		obj.CPoints[i].background = obj.CPoints:CreateTexture(nil,"ARTWORK")
		obj.CPoints[i].background:SetTexture(unitdb.tex.barTex)
		obj.CPoints[i]:SetTexture(unitdb.tex.barTex)
		obj.CPoints[i].background:SetVertexColor(0,0,0,1)
		obj.CPoints[i]:SetVertexColor(.93,.93,0,1)
		if i == 5 then
			obj.CPoints[i]:SetVertexColor(1,0,0,1)
		end
	end 	
end

style.SetComboPointsSize = function(unit,width,height)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not width then width = unitdb.CPoints.width end
	if not height then height = unitdb.CPoints.height end
	unitdb.CPoints.width = width
	unitdb.CPoints.height = height
	local bv = unitdb.CPoints.border.value 
	for i = 1,5 do
		obj.CPoints[i].background:SetWidth((unitdb.CPoints.width-unitdb.CPoints.border.value*1.5-unitdb.CPoints.position.xOffset)/5)
		obj.CPoints[i].background:SetHeight(unitdb.CPoints.height)
		obj.CPoints[i]:SetWidth((unitdb.CPoints.width-unitdb.CPoints.border.value*1.5-unitdb.CPoints.position.xOffset)/5)
		obj.CPoints[i]:SetHeight(unitdb.CPoints.height)
	end
end

style.SetComboPointsPosition = function(unit,x,y,xOffset,yOffset)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.CPoints.position.x end
	if not y then y = unitdb.CPoints.position.y end
	if not xOffset then xOffset = unitdb.CPoints.position.xOffset end
	if not yOffset then yOffset = unitdb.CPoints.position.yOffset end
	unitdb.CPoints.position.x = x
	unitdb.CPoints.position.y = y
	unitdb.CPoints.position.xOffset = xOffset
	unitdb.CPoints.position.yOffset = yOffset
	for i =1,5 do
		if i == 1 then
			obj.CPoints[i].background:SetPoint("TOPLEFT",obj,"TOPLEFT",unitdb.CPoints.position.x,unitdb.CPoints.position.y)
		else
			obj.CPoints[i].background:SetPoint("TOPLEFT",obj.CPoints[i-1],"TOPRIGHT",unitdb.CPoints.position.xOffset,unitdb.CPoints.position.yOffset)
		end
		--obj.CPoints[i]:SetPoint("CENTER",obj)
		obj.CPoints[i]:SetPoint("CENTER",obj.CPoints[i].background)
	end
end

style.SetComboPointsBorder = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value  = unitdb.CPoints.border.value end
	unitdb.CPoints.border.value = value
	for i =1, 5 do
		obj.CPoints[i].border:SetPoint("TOPLEFT",obj.CPoints[i],"TOPLEFT",0-unitdb.CPoints.border.value,unitdb.CPoints.border.value)
		obj.CPoints[i].border:SetPoint("BOTTOMRIGHT",obj.CPoints[i],"BOTTOMRIGHT",unitdb.CPoints.border.value,0-unitdb.CPoints.border.value)
	obj.CPoints[i].border:SetBackdrop(unitdb.tex.borderTex)
	obj.CPoints[i].border:SetFrameLevel(0)
	end
	
end

style.SetComboPointsBorderColor = function(unit,r,g,b,a)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not r then r = unitdb.CPoints.border.color[1] end
	if not g then g = unitdb.CPoints.border.color[2] end
	if not b then b = unitdb.CPoints.border.color[3] end
	if not a then a = unitdb.CPoints.border.color[4] end
	unitdb.CPoints.border.color[1] = r
	unitdb.CPoints.border.color[2] = g
	unitdb.CPoints.border.color[3] = b
	unitdb.CPoints.border.color[4] = a
	for i = 1,5 do
		obj.CPoints[i].border:SetBackdropColor(unpack(unitdb.CPoints.border.color))
		obj.CPoints[i].border:SetBackdropBorderColor(unpack(unitdb.CPoints.border.color))
	end
end


style.SetAurasSize = function(unit,width,height)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not width then width = unitdb.Auras.width end
	if not height then height  = unitdb.Auras.height end
	unitdb.Auras.width = width
	unitdb.Auras.height = height
	obj.Auras:SetWidth(unitdb.Auras.width)
	obj.Auras:SetHeight(unitdb.Auras.height)
	obj.Auras.size = unitdb.Auras.width/unitdb.Auras.count - unitdb.Auras.spacing
	obj.Auras.numBuffs = unitdb.Auras.numBuffs
	obj.Auras.numDebuffs = unitdb.Auras.numDebuffs
	obj.Auras.gap = true
	obj.Auras.showType = true
end
style.SetAurasNum = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value  = unitdb.Auras.num end
	unitdb.Auras.num = value
	obj.Auras.num = unitdb.Auras.num
end

style.SetAurasPosition = function(unit,x,y)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not x then x = unitdb.Auras.position.x end
	if not y then y = unitdb.Auras.position.y end
	unitdb.Auras.position.x = x
	unitdb.Auras.position.y = y
	obj.Auras:SetPoint("TOPLEFT",obj,"BOTTOMLEFT",x,y)
end



style.SetAurasSpacing = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Auras.spacing end
	unitdb.Auras.spacing = value 
	obj.Auras.spacing = unitdb.Auras.spacing
end

style.forceUpdateAurasDirection = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value  = unitdb.Auras.anchor end
	unitdb.Auras.anchor = value
	local setDirection = {
		["TOPLEFT"] = function(e,a,dbX,dbY)
			e.initialAnchor = a
			e['growth-x'] = "RIGHT" 
			e['growth-y'] = "DOWN"
			dbX = "RIGHT"
			dbY = "DOWN"
		end,
		["TOPRIGHT"] = function(e,a,dbX,dbY)
			e.initialAnchor = a
			e['growth-x'] = "LEFT" 
			e['growth-y'] = "DOWN"
			dbX = "LEFT"
			dbY = "DOWN"
		end,
		["BOTTOMRIGHT"] = function(e,a,dbX,dbY) 
			e.initialAnchor = a
			e['growth-x'] = "RIGHT" 
			e['growth-y'] = "UP"
			dbX = "RIGHT"
			dbY = "UP"
		end,
		["BOTTOMLEFT"] = function(e,a,dbX,dbY) 
			e.initialAnchor = a
			e['growth-x'] = "LEFT" 
			e['growth-y'] = "UP"
			dbX = "LEFT"
			dbY = "UP"
		end,
	}
	do
		setDirection[unitdb.Auras.anchor](obj.Auras,unitdb.Auras.anchor,unitdb.Auras.growthX,unitdb.Auras.growthY)
		obj.Auras:ForceUpdate()
	end
end


style.forceUpdateAurasWidth = function(unit,value)

end

style.forceUpdateAurasHeight = function(unit,value)

end

style.forceUpdateAurasSpacing = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Auras.spacing end
	unitdb.Auras.spacing = value 
	obj.Auras.spacing = unitdb.Auras.spacing
	obj.Auras:ForceUpdate()
end

style.SetAurasBuffsCount = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Auras.numBuffs end
	unitdb.Auras.numBuffs = value
	obj.Auras.numBuffs = unitdb.Auras.numBuffs
	obj.Auras:ForceUpdate(obj.Auras)
end

style.SetAurasDebuffsCount = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not value then value = unitdb.Auras.numDebuffs end
	unitdb.Auras.numDebuffs = value
	obj.Auras.numDebuffs = unitdb.Auras.numDebuffs
	obj.Auras:ForceUpdate()
end




--style.SetAurasCount = function(unit,value)
--	local obj,unitdb = GetObject(unit),GetDB(unit)
--	if not value then value = unitdb.Auras.count end
--	unitdb.Auras.count = value
--	--obj.Auras:SetWidth((unitdb.Auras.width-unitdb.Auras.count*unitdb.Auras.spacing)/unitdb.Auras.count-4)
--	obj.Auras.size = (unitdb.Auras.width-unitdb.Auras.count*unitdb.Auras.spacing)/unitdb.Auras.count-4
--	obj.Auras:ForceUpdate(obj.Auras)
--end

style.SetAurasGrowth = function(unit,anchor,growthX,growthY)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	if not anchor then anchor = unitdb.Auras.anchor end
	if not growthX then growthX = unitdb.Auras.growthX end
	if not growthY then growthY = unitdb.Auras.growthY end
	unitdb.Auras.anchor = anchor
	unitdb.Auras.growthX = growthX
	unitdb.Auras.growthY = growthY 
	obj.Auras.initialAnchor = unitdb.Auras.anchor
	obj.Auras['growth-x'] = unitdb.Auras.growthX
	obj.Auras['growth-y'] = unitdb.Auras.growthY
end
style.forceOnlyShowMyAuras = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Auras.onlyShowMyAuras = value 
	obj.Auras.onlyShowPlayer = unitdb.Auras.onlyShowMyAuras 
	obj.Auras:ForceUpdate()
end

style.forceHighLightMyAuras = function(unit,value)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	unitdb.Auras.highLightMyAuras = value 
	obj.Auras.postUpdateIcon = style.postUpdateIcon
	obj.Auras:ForceUpdate()
end


style.postUpdateIcon = function(icons,unit,icon,index,offset)
	local unitdb = GetDB(unit)
	local flag = unitdb and unitdb.Auras.highLightMyAuras or true 
	local _,_,_,_,_,_,_,caster = UnitAura(unit,index,icon.filter)
	if (caster ~= "player" and caster ~= "vehicle" ) then
		icon.icon:SetDesaturated(flag)
		icon.overlay:SetVertexColor(.25,.25,.25)
	else
		icon.icon:SetDesaturated(false)
	end
end

style.postCreateIcon = function(icons,button)
	--print(icons:GetParent():GetName())
	--local unit =string.lower(string.sub(icons:GetParent():GetName(),string.find(icons:GetParent():GetName(),"_")+1))
	--print(unit)
	--local unitdb = GetDB(unit)
	local tex = "Interface\\AddOns\\Wowshell_UFShell\\texture\\dBBorderK"
	button.count:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = button.count:GetFont()
		button.count:SetFont(font,size,flag)
	end
	button.oufaura = true
	button.cd:SetDrawEdge(false)
	button.cd:SetReverse(true)
	button.icon:SetTexCoord(.1,.9,.1,.9)
	button.overlay:SetTexture(tex)   --(unitdb.tex.auraTex)
	button.overlay:SetPoint("TOPLEFT",button.icon,-2,2)
	button.overlay:SetPoint("BOTTOMRIGHT",button.icon,2,-2)
	button.overlay:SetTexCoord(0,1,0,1)

end

style.showComboPointMenu = function()
	local class = select(2,UnitClass"player")
	if class == "ROGUE" or class == "DRUID" then 
		return false 
	else 
		return true 
	end
end

style.showSpecialElementMenu = function()
	local class = select(2,UnitClass"player")
	if class == "PALADIN" or class == "WARLOCK" or class == "SHAMAN" or class == "DRUID" or class == "DEATHKNIGHT" then 
		return false
	else 
		return true
	end
end	



















style.TestParent = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	--local f = CreateFrame("Frame")
	obj.testParent:SetFrameLevel(100)
	--local t = f:CreateTexture(nil,"OVERLAY")
	obj.testParent.t:SetAllPoints(obj)
	obj.testParent.t:SetTexture(unitdb.tex.barTex)
	obj.testParent.t:SetVertexColor(1,1,1,0.3)
	--local fs = f:CreateFontString(nil,"OVERLAY")
	obj.testParent.fs:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = obj.testParent.fs:GetFont()
		obj.testParent.fs:SetFont(font,size,"OUTLINE")
	end
	obj.testParent.fs:SetPoint("CENTER",obj,"CENTER",0,0)
	obj.testParent.fs:SetTextColor(1,0,0,1)

	obj.testParent.nextUpdate = 0
	local oldTime = GetTime()
	local duration = 4

	obj.testParent:SetScript("OnUpdate",function(self,elapsed)
		obj.testParent.nextUpdate = obj.testParent.nextUpdate + elapsed
		if obj.testParent.nextUpdate > 0.1 then
			local newTime = GetTime()
			if(newTime-oldTime) > duration then
				obj.testParent.t:SetVertexColor(1,1,1,0)
				obj.testParent:SetScript("OnUpdate",nil)
				obj.testParent.fs:SetText("")
			elseif (newTime - oldTime) > (duration-1) and (newTime - oldTime) <=duration then
				local tempNum = duration-tonumber(string.format("%6.1f",(newTime - oldTime)))
				obj.testParent.t:SetVertexColor(1,1,1,.3*tempNum)
				obj.testParent.fs:SetTextColor(1,0,0,.3*tempNum)			
			else
				obj.testParent.fs:SetText(string.format("%s%u%s","框架示例层将在",(duration-(newTime-oldTime)),"秒后消失"))
				obj.testParent.t:SetVertexColor(1,1,1,.3)
			end
			obj.testParent.nextUpdate = 0
		end
	end)
end



style.MoveAble = function(self,button,unit,position)
	local obj = GetObject(unit)
	ns.unitFrames[unit]:SetMovable(true)
		if UnitAffectingCombat(unit) then 
			print("|cffe1a500精灵头像|r:|cffff2020战斗中无法设置位置!|r")
		else
		if button == "RightButton" and obj.tempFlag%2 == 0 then
			ns.unitFrames[unit]:StartMoving()
			obj.tempFlag = obj.tempFlag +1 
			print("|cffe1a500精灵头像|r:|cff69ccf0解锁位置|r")
		elseif button == "RightButton" and obj.tempFlag%2 ~= 0 then
			ns.unitFrames[unit]:StopMovingOrSizing()
			local selfPoint,anchorTo,relativePoint,x,y = ns.unitFrames[unit]:GetPoint()

			position.selfPoint = selfPoint
			position.relativePoint = relativePoint
			position.anchorTo = "UIParent"
			position.x = x*UIParent:GetEffectiveScale()
			position.y = y*UIParent:GetEffectiveScale()
			obj.tempFlag= 0
			print("|cffe1a500精灵头像|r:|cff69ccf0锁定位置|r")
		end
	end
end


style.CopyName = function(unit)
	local obj = GetObject(unit)
	local copyName = function(str,arg1)
			ChatFrame1EditBox:Show()
			ChatFrame1EditBox:SetFocus()
			ChatFrame1EditBox:Insert(str)
			ChatFrame1EditBox:HighlightText(0,string.len(str))
			print(string.format("|cffe1a500获取 |cff69ccf0%s |cffe1a500的姓名成功|r",arg1))
	end
	
	obj:HookScript("OnMouseDown",function(self,button)
		local name,realm = UnitName(unit)
		if IsRightAltKeyDown() then
			copyName(name..(realm and realm or ""),name)
		end
	end)
end

style.CopyArmory = function(unit)
	local obj = GetObject(unit)
	local copyQueryString = function(str,arg1)
		ChatFrame1EditBox:Show()
		ChatFrame1EditBox:Insert(str)
		ChatFrame1EditBox:SetFocus()
		ChatFrame1EditBox:HighlightText(0,string.len(str))
		print(string.format("|cffe1a500去瞧瞧更多关于|cff69ccf0 %s  |cffe1a500的信息|r",arg1))
	end

	obj:HookScript("OnMouseDown",function(self,button)
		local name,realm = UnitName(unit)
		local client = GetLocale()
		local getArmory = {
			["zhCN"] = function(realm,name) return string.format("www.battlenet.com.cn/wow/zh/character/%s/%s/advanced",realm,name) end,
			["zhTW"] = function(realm,name) return string.format("tw.battle.net/wow/zh/character/%s/%s/advanced",realm,name) end,
			["enUS"] = function(realm,name) return string.format("us.battle.net/wow/en/character/%s/%s/advanced",realm,name) end,
		}
		local getDatabase = {
			["wowshell"] = function(id) return string.format("http://db.wowshell.com/npc=%s",id) end,
			["wowhead"] = function(id) return string.format("www.wowhead.com/npc=%s",id) end,
			["netease"] = function(id) return string.format("db.w.163.com/npc-%s.html",id) end,
			["sina"] = function(id) return string.format("wowdb.games.sina.com.cn/npc-%s.html",id) end,
			["178"] = function(id) return string.format("db.178.com/wow/cn/npc/%s.html",id) end,
			["duowan"] = function(id) return string.format("db.duowan.com/wow/npc-%s.html",id) end,
			["wowbox"] = function(id) return string.format("http://wowbox.meetgee.com/tw/npc-%s.html",id) end,
		}
		if IsRightControlKeyDown() then
			if UnitIsPlayer(unit) then	
				if not realm then realm = GetRealmName() end
				local armory = getArmory[client](realm,name)
				copyQueryString(armory,name)	
			else 
				local guid = UnitGUID(unit)
				local gid = string.sub(guid,7,10)
				local id = tonumber(gid,16)
				local dbUrl = getDatabase["wowshell"](id)
				copyQueryString(dbUrl,name)
			end
		end
	--	if ChatFrame1EditBox:IsShown() then
	--		local queryStr = ChatFrame1EditBox:GetText()
	--		if string.find(queryStr,"") then 

	--		end
	--	end
	end)
end



ns.style = style
