--susnow

local parent, ns = ...
local preview = CreateFrame("Frame")
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.tags
local db = WSUF.db.profile

local barTex = "Interface\\AddOns\\Wowshell_UFShell\\texture\\statusbarTexture" 
local borderTex =  {
				bgFile = "Interface\\Buttons\\WHITE8x8", 
				edgeFile = "Interface\\Buttons\\WHITE8x8", 
				edgeSize = 1, 
				insert = {
					left= -1, 
					right = -1, 
					top = -1, 
					bottom = -1
				}, 
			}
local auraTex = "Interface\\AddOns\\Wowshell_UFShell\\texture\\dBBorderK"
local buffTex = "Interface\\ICONS\\Spell_ChargePositive"
local debuffTex = "Interface\\ICONS\\Spell_ChargeNegative"
local spellTex = "Interface\\ICONS\\Spell_Fire_SunKey"

local function GetObject(unit)
	local obj = self or ns.unitFrames[unit]
	return obj
end

local function GetDB(unit)
	local unitdb = ns:GetUnitDB(unit)
	return unitdb
end

local function GetGlobalScale() 
	return UIParent:GetEffectiveScale()
end

preview.toggleTestObj = function(unit,value)
	local obj = GetObject(unit)
	for k,v in next,obj.TestList do
		if value then 
			obj[v]:Show()
		else
			obj[v]:Hide()
		end
	end
end

preview.testFrame = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testFrame:SetFrameLevel(150)
	obj.testFrame.bg:SetFrameLevel(obj.testFrame:GetFrameLevel()-10)
	obj.testFrame:SetWidth(unitdb.Parent.width*GetGlobalScale())
	obj.testFrame:SetHeight(unitdb.Parent.height*GetGlobalScale())
	
	obj.testFrame:SetPoint("CENTER",obj)
	obj.testFrame.tex:SetAllPoints(obj.testFrame)
	obj.testFrame.tex:SetStatusBarTexture(barTex)
	obj.testFrame.tex:SetStatusBarColor(0,0,0,0)
	end


--preview.testParent = function(unit)
--	local obj,unitdb = GetObject(unit),GetDB(unit)
--	obj.testParent:SetFrameLevel(300)
--	--obj.testParent.t:SetAllPoints(obj)
--	obj.testParent:SetPoint("TOPLEFT",obj)
--	obj.testParent.t:SetAllPoints(obj.testParent)
--	obj.testParent.t:SetTexture(barTex)
--	obj.testParent.t:SetVertexColor(1,1,1,.3)
--	obj.testParent.fs:SetFontObject(ChatFontNormal)
--	do 
--		local font,size,flag = obj.testParent.fs:GetFont()
--		obj.testParent.fs:SetFont(font,size,"OUTLINE")
--	end
--	obj.testParent.fs:SetPoint("CENTER",obj)
--	obj.testParent.fs:SetTextColor(1,0,0,1)
--
--	obj.testParent.nextUpdate = 0
--	local oldTime = GetTime()
--	local duration = 4
--	local interval = 0.1
--
--	obj.testParent:SetScript("OnUpdate",function(self,elapsed)
--		obj.testParent.nextUpdate = obj.testParent.nextUpdate + elapsed
--		if obj.testParent.nextUpdate > interval then
--			local newTime = GetTime()
--			if(newTime-oldTime) > duration then
--				obj.testParent.t:SetVertexColor(1,1,1,0)
--				obj.testParent:SetScript("OnUpdate",nil)
--				obj.testParent.fs:SetText("")
--			elseif(newTime - oldTime) > (duration -1) and (newTime - oldTime) <= duration then
--				local tempNum = duration-tonumber(string.format("%6.1f",(newTime - oldTime)))
--				obj.testParent.t:SetVertexColor(1,1,1,.3*tempNum)
--				obj.testParent.fs:SetTextColor(1,0,0,.3*tempNum)		
--			else
--				obj.testParent.fs:SetText(string.format("%s%u%s","框架示例层将在",(duration-(newTime-oldTime)),"秒后消失"))
--				obj.testParent.t:SetVertexColor(1,1,1,.3)
--			end
--			obj.testParent.nextUpdate = 0
--		end
--	end)	
--end



preview.testPortrait = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	--local randomFlag = math.random(0,1)
	--if randomFlag == 1 then
		obj.testPortrait:SetUnit("player")
		obj.testPortrait:SetCamera(0)
		--obj.testPortrait:SetModelScale(4.25)
	--else
		--obj.testPortrait:SetModelScale(4.25)
		--obj.testPortrait:SetPosition(0,0,-1.5)
		--obj.testPortrait:SetModel"Interface\\Buttons\\talktomequestionmark.mdx"
	--end
	obj.testPortrait:SetWidth(unitdb.Portrait.width*GetGlobalScale())
	obj.testPortrait:SetHeight(unitdb.Portrait.height*GetGlobalScale())
	obj.testPortrait:SetPoint("TOPLEFT",obj.testFrame,"TOPLEFT",unitdb.Portrait.position.x*GetGlobalScale(),unitdb.Portrait.position.y*GetGlobalScale())
	obj.testPortrait.border:SetPoint("TOPLEFT",obj.testPortrait,"TOPLEFT", 0 - unitdb.Portrait.border.value,unitdb.Portrait.border.value)
	obj.testPortrait.border:SetPoint("BOTTOMRIGHT",obj.testPortrait,"BOTTOMRIGHT", unitdb.Portrait.border.value,0-unitdb.Portrait.border.value)
	obj.testPortrait.border:SetBackdropColor(unpack(unitdb.Portrait.border.color))
	obj.testPortrait.border:SetBackdropBorderColor(unpack(unitdb.Portrait.border.color))
	obj.testPortrait.background:SetAllPoints(obj.testPortrait)
	obj.testPortrait.background:SetTexture(barTex)
	obj.testPortrait.background:SetVertexColor(unpack(unitdb.Portrait.background.color))
	obj.testPortrait.background:SetBlendMode("ALPHAKEY")
end


preview.testHealth = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testHealth:SetWidth(unitdb.Health.width*GetGlobalScale())
	obj.testHealth:SetHeight(unitdb.Health.height*GetGlobalScale())
	obj.testHealth:SetFrameLevel(100)
	obj.testHealth:SetPoint("TOPLEFT",obj.testFrame,"TOPLEFT",unitdb.Health.position.x*GetGlobalScale(),unitdb.Health.position.y*GetGlobalScale())
	obj.testHealth.background:SetAllPoints(obj.testHealth)
	obj.testHealth.background:SetTexture(barTex)
	obj.testHealth.background:SetVertexColor(unpack(unitdb.Health.background.color))
	obj.testHealth.tex:SetStatusBarTexture(barTex)
	obj.testHealth.tex:SetPoint("TOPLEFT",obj.testHealth,"TOPLEFT",0,0)	
	obj.testHealth.tex:SetPoint("BOTTOMRIGHT",obj.testHealth,"BOTTOMRIGHT",0,0)
	obj.testHealth.border:SetPoint("TOPLEFT",obj.testHealth,"TOPLEFT",0-unitdb.Health.border.value,unitdb.Health.border.value-.5)
	obj.testHealth.border:SetPoint("BOTTOMRIGHT",obj.testHealth,"BOTTOMRIGHT",unitdb.Health.border.value-.5,0-unitdb.Health.border.value)
	obj.testHealth.border:SetBackdrop(borderTex)
	obj.testHealth.border:SetBackdropColor(unpack(unitdb.Health.border.color))
	obj.testHealth.border:SetBackdropBorderColor(unpack(unitdb.Health.border.color))
	obj.testHealth.border:SetFrameLevel(obj.testHealth:GetFrameLevel()-1)
	
	local setStatusBarColor = {
		["colorClass"] = function() 
			local class = select(2,UnitClass"player")
			local color = RAID_CLASS_COLORS[class]
			obj.testHealth.tex:SetStatusBarColor(color.r,color.g,color.b)
		end,
		["colorSmooth"] = function()
			local color = oUF.colors.smooth 
			local maxWidth = obj.testHealth:GetWidth()
			local curWidth = obj.testHealth.tex:GetWidth()
			local percent = curWidth/maxWidth
			local r,g,b = oUF.ColorGradient(percent,unpack(color))
			obj.testHealth.tex:SetStatusBarColor(r,g,b)
			
			--obj.testHealth.tex:SetStatusBarColor(color.r * percent, color.g * percent, color.b * percent)
		end,
		["colorHealth"] = function()
			obj.testHealth.tex:SetStatusBarColor(unpack(unitdb.Health.colorH))
		end,
	}



	obj.testHealth.nextUpdate = 0
	
	local oldTime = GetTime()
	local duration = 60
	local interval = 0.1
	obj.testHealth:SetScript("OnHide",function(self,...)
		oldTime = GetTime()
	end)
	obj.testHealth:SetScript("OnUpdate",function(self,elapsed)
		obj.testHealth.nextUpdate = obj.testHealth.nextUpdate + elapsed
		if obj.testHealth.nextUpdate > interval then
			local newTime = GetTime()
			if(newTime - oldTime) < duration  then
					local tempNum = duration - tonumber(string.format("%6.1f",(newTime - oldTime)))
					local tempWidth = obj.testHealth:GetWidth() - (tempNum*obj.testHealth:GetWidth())/duration
					obj.testHealth.tex:SetPoint("BOTTOMRIGHT",obj.testHealth,"BOTTOMRIGHT",0-tempWidth,0)
					setStatusBarColor[unitdb.Health.color]()
			else
				obj.testHealth:SetScript("OnUpdate",nil)
			end

			obj.testHealth.nextUpdate = 0
		end
	end)

end

preview.testPower = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testPower:SetWidth(unitdb.Power.width*GetGlobalScale())
	obj.testPower:SetHeight(unitdb.Power.height*GetGlobalScale())
	obj.testPower:SetFrameLevel(100)
	obj.testPower:SetPoint("TOPLEFT",obj.testFrame,"TOPLEFT",unitdb.Power.position.x*GetGlobalScale(),unitdb.Power.position.y*GetGlobalScale())
	obj.testPower.background:SetAllPoints(obj.testPower)
	obj.testPower.background:SetTexture(barTex)
	obj.testPower.background:SetVertexColor(unpack(unitdb.Power.background.color))
	obj.testPower.tex:SetStatusBarTexture(barTex)
	obj.testPower.tex:SetPoint("TOPLEFT",obj.testPower,"TOPLEFT",0,0)	
	obj.testPower.tex:SetPoint("BOTTOMRIGHT",obj.testPower,"BOTTOMRIGHT",0,0)
	obj.testPower.border:SetPoint("TOPLEFT",obj.testPower,"TOPLEFT",0-unitdb.Power.border.value,unitdb.Power.border.value+.5)
	obj.testPower.border:SetPoint("BOTTOMRIGHT",obj.testPower,"BOTTOMRIGHT",unitdb.Power.border.value,0-unitdb.Power.border.value+.5)
	obj.testPower.border:SetBackdrop(borderTex)
	obj.testPower.border:SetBackdropColor(unpack(unitdb.Power.border.color))
	obj.testPower.border:SetBackdropBorderColor(unpack(unitdb.Power.border.color))
	obj.testPower.border:SetFrameLevel(obj.testPower:GetFrameLevel()-1)

	obj.testPower.nextUpdate = 0
	local oldTime = GetTime()
	local duration = 60
	local interval = 0.1
	obj.testPower:SetScript("OnHide",function(self,...)
		oldTime = GetTime()
	end)
	obj.testPower:SetScript("OnUpdate",function(self,elapsed)
		obj.testPower.nextUpdate = obj.testPower.nextUpdate + elapsed
		if obj.testPower.nextUpdate > interval then
			local newTime = GetTime()
			if(newTime - oldTime) < duration then
					local tempNum = duration - tonumber(string.format("%6.1f",(newTime - oldTime)))
					local tempWidth = obj.testPower:GetWidth() - (tempNum*obj.testPower:GetWidth())/duration
					obj.testPower.tex:SetPoint("BOTTOMRIGHT",obj.testPower,"BOTTOMRIGHT",0-tempWidth,0)
			else
				obj.testPower:SetScript("OnUpdate",nil)
			end

			obj.testPower.nextUpdate = 0
		end
	end)

	local setStatusBarColor = {
		["colorClass"] = function() 
			local class = select(2,UnitClass"player")
			local color = RAID_CLASS_COLORS[class]
			obj.testPower.tex:SetStatusBarColor(color.r,color.g,color.b)
		end,
		["colorPower"] = function()
			local ptype,ptoken,altR,altG,altB = UnitPowerType("player")
			local color = {
				MANA = {r = 0, g = 0, b = 1}, 
				RAGE = {r = 1, g = 0, b = 0},
				FOCUS = {r = 1, g = .5, b = .25},
				ENERGY = {r = 1, g = 1, b = 0}, 
				RUNIC_POWER = {b = 0, g = .82, r = 1},
			}
			obj.testPower.tex:SetStatusBarColor(color[ptoken].r,color[ptoken].g,color[ptoken].b)
		end,
		["colorCustom"] = function()
			obj.testPower.tex:SetStatusBarColor(unpack(unitdb.Power.colorP))
		end,
	}
	do
		setStatusBarColor[unitdb.Power.color]()
	end
end

preview.testAuras = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testAuras:SetFrameLevel(100)
	obj.testAuras:SetWidth(unitdb.Auras.width*GetGlobalScale())
	obj.testAuras:SetHeight(unitdb.Auras.height*GetGlobalScale())
	obj.testAuras:SetPoint("TOPLEFT",obj.testFrame,"BOTTOMLEFT",unitdb.Auras.position.x*GetGlobalScale(),unitdb.Auras.position.y*GetGlobalScale())
	obj.testAuras.background:SetTexture(barTex)
	obj.testAuras.background:SetVertexColor(1,1,1,0)
	obj.testAuras.background:SetAllPoints(obj.testAuras)

	local numBuffs = unitdb.Auras.numBuffs
	local numDebuffs = unitdb.Auras.numDebuffs
	local size = unitdb.Auras.width*GetGlobalScale()/unitdb.Auras.count - unitdb.Auras.spacing
	local spacing = unitdb.Auras.spacing
	local count = unitdb.Auras.count
	local icon = {}
	for i = 1, numBuffs+numDebuffs+1 do
		icon[i] = obj.testAuras:CreateTexture(nil,"ARTWORK")
		icon[i].border = obj.testAuras:CreateTexture(nil,"OVERLAY")
		icon[i].duration = obj.testAuras:CreateFontString(nil,"OVERLAY")
		icon[i].count = obj.testAuras:CreateFontString(nil,"ARTWORK")

		icon[i].duration:SetFontObject(ChatFontNormal)
		icon[i].count:SetFontObject(ChatFontNormal)
		
		do local font,size,flag = icon[i].duration:GetFont()
			icon[i].duration:SetFont(font,size-4,"OUTLINE")
			icon[i].count:SetFont(font,size-4,flag)
		end

		icon[i].duration:SetPoint("CENTER",icon[i],"TOPRIGHT")
		icon[i].count:SetPoint("CENTER",icon[i],"BOTTOM")

		--local randomDur = math.random(1,60)		
		--local randomCou = math.random(1,5)
		--icon[i].duration:SetText(randomDur)
		--icon[i].count:SetText(randomCou)

		icon[i].border:SetTexture(auraTex)
		icon[i].border:SetPoint("TOPLEFT",icon[i],-2,2)
		icon[i].border:SetPoint("BOTTOMRIGHT",icon[i],2,-2)		
		
		icon[i]:SetWidth(size)
		icon[i]:SetHeight(size)
		icon[i]:SetTexCoord(0.1,0.9,0.1,0.9)
		if i <= numBuffs then
			icon[i]:SetTexture(buffTex)
			icon[i].border:SetVertexColor(0.36, 0.45, 0.88,.7)
		elseif i == numBuffs+1 then
			icon[i].border:SetVertexColor(0,0,0,0)
		else
			icon[i]:SetTexture(debuffTex)
			icon[i].border:SetVertexColor(1,0,0,.7)
		end
		
		if i == 1 then
			icon[i]:SetPoint("TOPLEFT",obj.testAuras)
		elseif i%count ==1 then
				icon[i]:SetPoint("TOPLEFT",icon[i-count],"BOTTOMLEFT",0,0-spacing)
		else
			icon[i]:SetPoint("TOPLEFT",icon[i-1],"TOPRIGHT",spacing,0)
		end
	end
		obj.testAuras.nextUpdate = 0
		local oldTime = GetTime()
		local duration = 60
		local interval = 1
		local randomNums = {}
		obj.testAuras:SetScript("OnHide",function(self,...)
			oldTime = GetTime()
		end)
		obj.testAuras:SetScript("OnUpdate",function(self,elapsed)
			obj.testAuras.nextUpdate = obj.testAuras.nextUpdate + elapsed
			if obj.testAuras.nextUpdate > interval then
			local newTime = GetTime()
			if(newTime - oldTime) < duration then	
					
		for i = 1, #icon do
			local randomDur = math.random(1,60)		
			local randomCou = math.random(1,5)
			local randomMin = math.random(0,1)
			if i ~= numBuffs +1 then
				icon[i].duration:SetText(string.format("%s%s",randomDur,randomMin==1 and "m" or ""))
				icon[i].count:SetText(randomCou)
			else
				icon[i].duration:SetText("")
				icon[i].count:SetText("")
			end
		end
		local randomBuff = math.random(1,numBuffs)
				local randomDebuff = math.random(numBuffs+2,#icon)
				for i = 1, #icon do
					if i > randomBuff and i <= numBuffs then
						icon[i]:SetDesaturated(true)
						icon[i].border:SetVertexColor(.25,.25,.25)
					elseif i < randomBuff then 
						icon[i]:SetDesaturated(false)
						icon[i].border:SetVertexColor(.36,.45,.88,.7)
					elseif i > randomDebuff and i <=#icon then
						icon[i]:SetDesaturated(true)
						icon[i].border:SetVertexColor(.25,.25,.25)
					elseif i > numBuffs+2 and i < randomDebuff then
						icon[i]:SetDesaturated(false)
						icon[i].border:SetVertexColor(1,0,0,.7)
					end
				end
			else 
				obj.testAuras:SetScript("OnUpdate",nil)
			end
			obj.testAuras.nextUpdate = 0
		end
		end)
end

preview.testCastbar = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testCastbar:SetFrameLevel(100)
	obj.testCastbar:SetWidth(unitdb.Castbar.width*GetGlobalScale())
	obj.testCastbar:SetHeight(unitdb.Castbar.height*GetGlobalScale())
	obj.testCastbar:SetPoint("TOPLEFT",obj.testFrame,"BOTTOMLEFT",unitdb.Castbar.position.x*GetGlobalScale(),unitdb.Castbar.position.y*GetGlobalScale() - unitdb.Parent.spacing*2)
	obj.testCastbar.border:SetBackdrop(unitdb.tex.borderTex)
	obj.testCastbar.border:SetPoint("TOPLEFT",obj.testCastbar,"TOPLEFT", 0- unitdb.Castbar.background.value ,unitdb.Castbar.background.value)
	obj.testCastbar.border:SetPoint("BOTTOMRIGHT",obj.testCastbar,"BOTTOMRIGHT", unitdb.Castbar.background.value,0-unitdb.Castbar.background.value)
	obj.testCastbar.border:SetBackdropColor(unpack(unitdb.Castbar.background.color))
	obj.testCastbar.border:SetBackdropBorderColor(unpack(unitdb.colors.brdColor))
	obj.testCastbar.tex:SetStatusBarTexture(barTex)
	obj.testCastbar.tex:SetStatusBarColor(unpack(unitdb.Castbar.color))
	obj.testCastbar.tex:SetPoint("TOPLEFT",obj.testCastbar,"TOPLEFT",0,0)
	obj.testCastbar.tex:SetPoint("BOTTOMRIGHT",obj.testCastbar,"BOTTOMLEFT",0,0)
	obj.testCastbar.tex:SetFrameLevel(obj.testCastbar:GetFrameLevel()+1)
	obj.testCastbar.Icon:SetWidth(unitdb.Castbar.Icon.size*GetGlobalScale())
	obj.testCastbar.Icon:SetHeight(unitdb.Castbar.Icon.size*GetGlobalScale())
	local setCastBarIconPoint = {
		["LEFT"] = function(e,x,y) 
			e:ClearAllPoints()
			e:SetAlpha(1)
			e:SetPoint("BOTTOMRIGHT",obj.testCastbar,"BOTTOMLEFT",x+unitdb.Parent.spacing*2,y)		
		end,
		["RIGHT"] = function(e,x,y)
			e:ClearAllPoints()
			e:SetAlpha(1)
			e:SetPoint("BOTTOMLEFT",obj.testCastbar,"BOTTOMRIGHT",x+unitdb.Parent.spacing*2,y)
		end,
		["NONE"] = function(e,x,y)
			e:SetAlpha(0)
		end,
	}
	do
		setCastBarIconPoint[unitdb.Castbar.Icon.position.point](obj.testCastbar.Icon,unitdb.Castbar.Icon.position.x*GetGlobalScale(),unitdb.Castbar.Icon.position.y*GetGlobalScale())
	end
	obj.testCastbar.Icon:SetTexture(spellTex)
	obj.testCastbar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
	
	obj.testCastbar.Icon.border:SetPoint("TOPLEFT",obj.testCastbar.Icon,"TOPLEFT",0-unitdb.Castbar.Icon.border.value,unitdb.Castbar.Icon.border.value)
	obj.testCastbar.Icon.border:SetPoint("BOTTOMRIGHT",obj.testCastbar.Icon,"BOTTOMRIGHT",unitdb.Castbar.Icon.border.value,0-unitdb.Castbar.Icon.border.value)
	obj.testCastbar.Icon.border:SetTexture(auraTex)
	obj.testCastbar.Icon.border:SetVertexColor(unpack(unitdb.Castbar.Icon.border.color))
	obj.testCastbar.Text:SetPoint("CENTER",obj.testCastbar,"CENTER",unitdb.Castbar.Text.position.x*GetGlobalScale(),unitdb.Castbar.Text.position.y*GetGlobalScale())
	obj.testCastbar.Text:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = obj.testCastbar.Text:GetFont()
		obj.testCastbar.Text:SetFont(font,unitdb.Castbar.Text.fontSize,unitdb.Castbar.Text.flag)
	end
	obj.testCastbar.Text:SetText("Excalibur")
	
	obj.testCastbar.nextUpdate = 0
	local oldTime = GetTime()
	local duration = 60
	local interval = 0.001
	obj.testCastbar:SetScript("OnShow",function(self,...)
		oldTime = GetTime()
	end)
	obj.testCastbar:SetScript("OnHide",function(self,...)
		oldTime = GetTime()
	end)
	obj.testCastbar:SetScript("OnUpdate",function(self,elapsed)
		obj.testCastbar.nextUpdate = obj.testCastbar.nextUpdate + elapsed
		if obj.testCastbar.nextUpdate > interval then
			local newTime = GetTime()
			if(newTime - oldTime) < duration then
				local tempNum = duration - tonumber(string.format("%6.4f",(newTime - oldTime)))
				local tempWidth = obj.testCastbar:GetWidth() - (tempNum*obj.testCastbar:GetWidth())/duration
				obj.testCastbar.tex:SetPoint("BOTTOMRIGHT",obj.testCastbar,"BOTTOMLEFT",tempWidth,0)
			else
				obj.testCastbar:Hide()
				obj.testCastbar:SetScript("OnUpdate",nil)
			end
			obj.testCastbar.nextUpdate = 0
		end
	end)
end

preview.testIndicators = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)	
	local setTex = {
		["PvP"] = function(e) 
			e:SetTexture("Interface\\TargetingFrame\\UI-PVP".."-"..UnitFactionGroup("player")) 
		end,
		["Combat"] = function(e) 
			e:SetTexture("Interface\\CharacterFrame\\UI-StateIcon") 
			e:SetTexCoord(.5, 1, 0, .49)
		end,	
		["Leader"] = function(e) 
			e:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon") 
		end,
		["MasterLooter"] = function(e) 
			e:SetTexture("Interface\\GroupFrame\\UI-Group-MasterLooter") 
		end,
		["RaidIcon"] = function(e)
			local rIconIndex = math.random(1,8)
			e:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon".."_"..rIconIndex)
		end,
		["Resting"] = function(e)
			e:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
			e:SetTexCoord(0, .5, 0, .421875)
		end,
		["QuestIcon"] = function(e)
			e:SetTexture("Interface\\TargetingFrame\\PortraitQuestBadge")	
		end,
		["LFDRole"] = function(e) 
			local roleIndex = math.random(1,3)
			local role = {"TANK","HEALER","DAMAGER"}
			e:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES") 
			e:SetTexCoord(GetTexCoordsForRoleSmallCircle(role[roleIndex]))
		end
		--["ReadyCheck"] = function(e)
		--end
	}
	obj.testIndicators:SetFrameLevel(200)
	for key,value in pairs(unitdb.Indicators) do
		obj.testIndicators[key]:SetWidth(unitdb.Indicators[key].size*GetGlobalScale())
		obj.testIndicators[key]:SetHeight(unitdb.Indicators[key].size*GetGlobalScale())
		local rel = unitdb.Indicators[key].position.relativePoint
		local testObj = "test"..rel 
		obj.testIndicators[key]:SetPoint(unitdb.Indicators[key].position.point,obj[testObj],unitdb.Indicators[key].position.anchorTo,unitdb.Indicators[key].position.x*GetGlobalScale(),unitdb.Indicators[key].position.y*GetGlobalScale())
		setTex[key](obj.testIndicators[key])	
	end

end

preview.testTags = function(unit)
	local obj,unitdb = GetObject(unit),GetDB(unit)
	obj.testTags:SetFrameLevel(200)
	local setParentPoint = {
		["Bottomleft"] = function(e,v) e:SetPoint("TOPLEFT",obj.testFrame,v,0,0) end,
		["Bottom"] = function(e,v) e:SetPoint("TOP",obj.testFrame,v,0,0) end,
		["Bottomright"] = function(e,v) e:SetPoint("TOPRIGHT", obj.testFrame,v,0,0) end,
		["Topleft"] = function(e,v) e:SetPoint("BOTTOMLEFT",obj.testFrame,v,0,0) end,
		["Top"] = function(e,v) e:SetPoint("BOTTOM",obj.testFrame,v,0,0) end,
		["Topright"] = function(e,v) e:SetPoint("BOTTOMRIGHT",obj.testFrame,v,0,0) end,
	}
	for key,value in next, unitdb.tags do
		obj.testTags[key]:SetFontObject(ChatFontNormal)
		do local font,size,fl = obj.testTags[key]:GetFont()
			obj.testTags[key]:SetFont(font,unitdb.tags[key].fontSize,unitdb.tags[key].flag)
		end
		obj.testTags[key]:SetText(unitdb.tags[key].tag)
		local rel,point = key:match"^(.+)(%u%l+)$"
		local testObj = "test"..rel	
		if rel == "Parent" then
			setParentPoint[point](obj.testTags[key],point)	
		else
			obj.testTags[key]:SetPoint(point,obj[testObj])
		end
	end
end

preview.testUnit = {
	["player"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
		preview.testCastbar(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["target"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
		preview.testCastbar(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["targettarget"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["targettargettarget"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["focus"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
		preview.testCastbar(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["focustarget"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["focustargettarget"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testTags(unit)
		preview.testIndicators(unit)
	end,
	["pet"] = function(unit)
		preview.testFrame(unit)
		preview.testPortrait(unit)
		preview.testHealth(unit)
		preview.testPower(unit)
		preview.testAuras(unit)
	end,
	["boss"] = function(unit)

	end,
	["bosstarget"] = function(unit)

	end,
	["party"] = function(unit)

	end,
}


ns.preview = preview

