--susnow
local addon,ns = ...

local L = ns.locales[GetLocale()]
local GUI = ns.GUI
local AL = ns.AL --AddOnList
local CFG = ns.CFG
local UL = ns.updateLog[GetLocale()] -- updateLog
local SPEC = ns.spec

local categorys ={ "UnitFrame","ActionBar","Map","Chat","CastSpell","Item","Quest","Archievement","Raid","PVP","Database","Business","Class"}

local buttons = {}
local results = {}

-- create widget objects
GUI:MainFrame()
GUI:BetaLogo()
GUI:HelpDocs()
local mf = _G["Wowshell_MainFrame"]
local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
sf:SetHorizontalScroll(700)
local scf = _G["Wowshell_MainFrame_ScrollFrame"]
mf:RegisterEvent("ADDON_LOADED")
mf:RegisterEvent("PLAYER_LOGIN")
local f = _G["Wowshell_MainFrame_ScrollFrame"]
for i =1, #categorys do
	GUI:CategoryButton(mf.scf,categorys[i],i,function() end)
	GUI:CategoryChildFrame(categorys[i])
	GUI:CategoryButtonSetPoint(categorys,i)
	for j=1, #AL[categorys[i]] do
		if j == 0 then break end
		GUI:CategoryChildFrameSetSize(categorys[i],j)
		GUI:CategoryChildFrameButtons(categorys[i],j)
		GUI:CategoryChildFrameButtonsSetPoint(categorys[i],j)
		local button = _G["Wowshell_Category"..categorys[i].."_ChildFrame_Button"..j]
		local addonName = AL[categorys[i]][j]
		button.text:SetText(CFG[addonName][GetLocale()])
		button.bg:SetTexture(CFG[addonName].icon)
		button.name = AL[categorys[i]][j]
		button.category = L[categorys[i]]
		button.clickCount = 1
		mf:HookScript("OnEvent",function(self,event,...)
			if event == "PLAYER_LOGIN" then
				collectgarbage'collect'
				if IsAddOnLoaded(addonName) then
					button.bg:SetDesaturated(false)	
					button.text:SetTextColor(1,1,1)
					button.isLoad = false
				else
					button.isLoad = true
					button.bg:SetDesaturated(true)	
					button.bg:SetVertexColor(.8,.7,.6,.5)
					button.text:SetTextColor(.8,.7,.6,.5)
				end
			end
		end)
		buttons[addonName] = button:GetName()
	end
end

GUI:TipFrame()
GUI:MouseOverTipFrame()
GUI:SearchBox()
GUI:StatsBar()
GUI:UpdateLog()

local function TipFunc(button,addonName)
	local tipFrame = _G["Wowshell_TipFrame"]
	local mouseTip = _G["Wowshell_GameTooltip"]
		button:SetScript("OnEnter",function(self)
			mouseTip:Show()
			local sug = GetAddOnMetadata(addonName,"X-TipSuggest") or ""
			local mem = GetAddOnMetadata(addonName,"X-TipMemory") and string.upper(GetAddOnMetadata(addonName,"X-TipMemory")) or ""

			GUI:MouseOverTipFrameSetPoint(self)
			if self.text:GetText() ~= nil then
				mouseTip.addonName:SetText(format("%s[%s]",self.text:GetText(),addonName))
				mouseTip.category:SetText(self.category)
				mouseTip.suggest:SetText(sug)
				mouseTip.memory:SetText(L[mem])
			else
				mouseTip:Hide()
			end
		end)
		button:SetScript("OnLeave",function(self)
			mouseTip:Hide()
		end)
	button:SetScript("OnClick",function(self,key)
		if key == "LeftButton" then
			self.clickCount = self.clickCount + 1
			if IsAddOnLoaded(addonName) then
				if self.clickCount % 2 == 0 then
					if SPEC[addonName] then
						SPEC[addonName](self.clickCount)
					elseif not SPEC[addonName] then
						DisableAddOn(addonName)
					end
					self.text:SetTextColor(.8,.7,.6,.5)
					tipFrame:Show()	
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipAddOnsLoad"],self.text:GetText(),addonName))
					GUI:TipFrameOnHide(GetTime()+2)
				elseif self.clickCount % 2 ~= 0 then
					if SPEC[addonName] then
						SPEC[addonName](self.clickCount)
					elseif not SPEC[addonName] then
						EnableAddOn(addonName)
					end
					self.text:SetTextColor(1,1,1,1)
					tipFrame:Show()
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipAddOnsCancel"],self.text:GetText(),addonName))
					GUI:TipFrameOnHide(GetTime()+2)
				end
			else
				if self.clickCount % 2 == 0 then
					if SPEC[addonName] then
						SPEC[addonName](self.clickCount)
					elseif not SPEC[addonName] then
						EnableAddOn(addonName)
					end
					self.text:SetTextColor(1,1,1,1)
					tipFrame:Show()
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipAddOnsLoad"],self.text:GetText(),addonName))
					GUI:TipFrameOnHide(GetTime()+2)
				elseif self.clickCount % 2 ~= 0 then
					if SPEC[addonName] then
						SPEC[addonName](self.clickCount)
					elseif not SPEC[addonName] then
						DisableAddOn(addonName)
					end
					self.text:SetTextColor(.8,.7,.6,.5)
					tipFrame:Show()
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipAddOnsCancel"],self.text:GetText(),addonName))
					GUI:TipFrameOnHide(GetTime()+2)
				end
			end
		elseif key == "RightButton" then
			if IsAddOnLoaded(addonName) then
				CFG[addonName].handler()	
			else
				--	
			end	
		end
	end)
end

for addonName,button in pairs(buttons) do
	TipFunc(_G[button],addonName)
end

GUI:ResultFrame()
GUI:SearchResultButtons()
GUI:MainFrameButton(mf,"reload",{"TOPRIGHT",-50,-10},function() ReloadUI() end)

GUI:MainFrameButton(mf,"collect",{"TOPRIGHT",-90,-10},function()
	local tipFrame = _G["Wowshell_TipFrame"]
	local oldMem = collectgarbage'count'
	collectgarbage'collect'
	local newMem = collectgarbage'count'
	if (oldMem - newMem) >= 0 then
		local colMem = format("%6.1f",(oldMem - newMem))
		tipFrame:Show()
		GUI:TipFrameOnShow(GetTime()+2)
		tipFrame.text:SetText(format(L["TipCollectMemory"],colMem))
		GUI:TipFrameOnHide(GetTime()+2)
	end
end)
local updateDate = GetAddOnMetadata("Wowshell","X-UpdateDate")
local version = GetAddOnMetadata("Wowshell","X-Version")

_G["Wowshell_UpdateLog_Button"].text:SetText(format(L["UpdateLog"],updateDate))

_G["Wowshell_SearchBox"]:SetScript("OnTextChanged",function(self)
	local tipFrame = _G["Wowshell_TipFrame"]
	local mouseTip = _G["Wowshell_GameTooltip"]
	local index = 0
	local str = self:GetText()
	if string.len(str) <=0 then
		local curVScr = sf:GetHorizontalScroll() 
		if curVScr < 600 then
			GUI:SetHScroll("LEFT",GetTime(),0,function() sf:SetHorizontalScroll(700) end)
		elseif curVScr > 1000 then
			GUI:SetHScroll("RIGHT",GetTime(),1450,function() sf:SetHorizontalScroll(700) end)
		else

		end
		for x = 1, 25 do
			local button = _G["Wowshell_SearchResult_Button"..x]	
			button:SetBackdropColor(0,0,0,0)
			button:SetBackdropBorderColor(0,0,0,0)
			button.text:SetText("")
			button.bg:SetTexture(nil)
			button:SetScript("OnEnter",nil)
			button:SetScript("OnLeave",nil)
		end
	end
	if string.find(str,"%d+") and string.len(str) == 4 then --updateLog
		local curHScr = sf:GetVerticalScroll()
		local curAddOnVersion = GetAddOnMetadata("Wowshell","X-Version")
		curAddOnVersion = tonumber(string.sub(curAddOnVersion,-4,-1))
		scf.title:SetPoint("TOPLEFT",scf,100,curHScr>0 and 0-(curHScr + 20) or -20)
		GUI:SetHScroll("RIGHT",GetTime(),700,function() 
			sf:SetHorizontalScroll(0) 
			if tonumber(str) - curAddOnVersion > 0 then
				scf.content:SetText(format(L["TipSearchLogNew"],str))
			elseif tonumber(str)  < 2750 then
				scf.content:SetText(format(L["TipSearchLogOld"],str))
			else
				if UL[str] then
					scf.content:SetText(UL[str])
				else
					scf.content:SetText(format(L["TipSearchLogNotFound"],str))
				end
			end
		end)	
	end
	if string.find(str,"%a+") and string.len(str) > 2 then --addonName
		local curHScr = sf:GetHorizontalScroll()
		if curHScr > 1000 then
		elseif curHScr > 600 then
			GUI:SetHScroll("LEFT",GetTime(),750,function() sf:SetHorizontalScroll(1450) end)
		end
		local curVScr = sf:GetVerticalScroll()
		scf.searchTitle:SetPoint("TOPLEFT",scf,1500,curVScr>0 and 0-(curVScr + 20) or -20)
		for x = 1, 25 do
			local button = _G["Wowshell_SearchResult_Button"..x]	
			button.clickCount = 1
			button:SetBackdropColor(0,0,0,0)
			button:SetBackdropBorderColor(0,0,0,0)
			button.text:SetText("")
			button.bg:SetTexture(nil)
		end
		for i = 1, #categorys do
			for j = 1, #AL[categorys[i]] do
				local addonName = AL[categorys[i]][j]
				local addonNameCN = GetAddOnMetadata(addonName,"X-PY")
				if string.find(string.lower(addonName),string.lower(str)) then 
					index = index + 1
					local button = _G["Wowshell_SearchResult_Button"..index]	
					button:SetBackdropColor(.3,.3,.3,.2)
					button:SetBackdropBorderColor(0,0,0,1)
					button.text:SetText(CFG[addonName][GetLocale()])
					button.bg:SetTexture(CFG[addonName].icon)
					if IsAddOnLoaded(addonName) then
						button.bg:SetDesaturated(false)	
						button.text:SetTextColor(1,1,1)
					else
						button.bg:SetDesaturated(true)	
						button.bg:SetVertexColor(.8,.7,.6,.5)
						button.text:SetTextColor(.8,.7,.6,.5)
					end
					TipFunc(button,addonName)	
					tipFrame:Show()
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipSearchResultAddOns"],index))
					GUI:TipFrameOnHide(GetTime()+2)
				elseif string.find(string.lower(addonNameCN),string.lower(str)) then
					index = index + 1
					local button = _G["Wowshell_SearchResult_Button"..index]	
					button:SetBackdropColor(.3,.3,.3,.2)
					button:SetBackdropBorderColor(0,0,0,1)
					button.text:SetText(CFG[addonName][GetLocale()])
					button.bg:SetTexture(CFG[addonName].icon)
					if IsAddOnLoaded(addonName) then
						button.bg:SetDesaturated(false)	
						button.text:SetTextColor(1,1,1)
					else
						button.bg:SetDesaturated(true)	
						button.bg:SetVertexColor(.8,.7,.6,.5)
						button.text:SetTextColor(.8,.7,.6,.5)
					end
					TipFunc(button,addonName)	
					tipFrame:Show()
					GUI:TipFrameOnShow(GetTime()+2)
					tipFrame.text:SetText(format(L["TipSearchResultAddOns"],index))
					GUI:TipFrameOnHide(GetTime()+2)
				else
					--
				end
			end
		end
	end
end)

_G["Wowshell_SearchBox"]:SetScript("OnEscapePressed",function(self)
	self:ClearFocus()
	local curVScr = sf:GetHorizontalScroll() 
	if curVScr < 600 then
		GUI:SetHScroll("LEFT",GetTime(),0,function() sf:SetHorizontalScroll(700) end)
	elseif curVScr > 1000 then
		GUI:SetHScroll("RIGHT",GetTime(),1450,function() sf:SetHorizontalScroll(700) end)
	else

	end
end)

GUI:MiniMapButton()
mf:Hide()
mf:SetAlpha(0)


local function MiniMapButtonClick(button)
	button:SetScript("OnMouseDown",function(self,key)
		if key == "LeftButton" then
			if not mf:IsShown() then
				mf:Show()
			end

			local oldTime = GetTime()
			self:SetScript("OnUpdate",function(self,elapsed)
				self.nextUpdate = self.nextUpdate + elapsed
				if self.nextUpdate > 0.0001 then
					local newTime = GetTime()
					if newTime - oldTime < 0.2 then 
						local tempScale = (1- (1/0.2)*(tonumber(string.format("%6.2f",(newTime - oldTime))))) +1		
						local tempAlpha = (1/0.2) * tonumber(string.format("%6.2f",(newTime - oldTime)))
						mf:SetScale(tempScale)
						mf:SetAlpha(tempAlpha)
					else
						mf:SetScale(1)
						mf:SetAlpha(1)
						self:SetScript("OnUpdate",nil)
						self:SetScript("OnClick",nil)
					end
					self.nextUpdate = 0
				end
			end)
		elseif key == "RightButton" then
			UIParent:Hide()
			_G["SlideLock"]:ToggleSlideLock("SHOW")
		end
	end)
end
if mf:IsShown() then
	_G["Wowshell_Minimap_Button"]:SetScript("OnClick",nil)
elseif not mf:IsShown() then
	MiniMapButtonClick(_G["Wowshell_Minimap_Button"])
end


GUI:MainFrameButton(mf,"close",{"TOPRIGHT",-10,-10},function() end)
GUI:MainFrameButton(mf,"help",{"TOPRIGHT",-210,-10},function() end)
GUI:MainFrameButton(mf,"info",{"TOPRIGHT",-130,-10},function() end)
GUI:MainFrameButton(mf,"setting",{"TOPRIGHT",-170,-10},function() end)


_G["Wowshell_MainFrame_CloseButton"].nextUpdate = 0
_G["Wowshell_MainFrame_HelpButton"].nextUpdate = 0

_G["Wowshell_MainFrame_HelpButton"]:SetScript("OnClick",function(self)
	if mf.helpDoc:IsShown() then
		sf:SetVerticalScroll(0)
		mf.helpDoc:Hide()
	else
		sf:SetHorizontalScroll(700)
		sf:SetVerticalScroll(6000)
		mf.helpDoc:Show()
	end
end)

_G["Wowshell_MainFrame_InfoButton"]:SetScript("OnClick",function(self)
	if mf.cpu:IsShown() then
		sf:SetVerticalScroll(0)
		mf.cpu:Hide()
	else
		sf:SetHorizontalScroll(700)
		sf:SetVerticalScroll(5000)
		mf.cpu:Show()
	end
end)

_G["Wowshell_MainFrame_SettingButton"]:SetScript("OnClick",function(self)
	if mf.setting:IsShown() then
		sf:SetVerticalScroll(0)
		mf.setting:Hide()
	else
		sf:SetHorizontalScroll(700)
		sf:SetVerticalScroll(7000)
		mf.setting:Show()
	end
end)

GUI:Setting()
GUI:GraphicWarning()

local settingAnimate = function(time,obj,label1,label2)
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]	
	local oldTime = time or GetTime()
	label2:Show()	
	label2:SetAlpha(0)
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.001 then
			
			local newTime = GetTime()	
			if newTime - oldTime < 0.2 then
				local tempOffset = 786 + (750/0.2) * (tonumber(string.format("%6.2f",(newTime - oldTime)))) 	
				local tempAlpha = (1/0.2) * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				label1:SetPoint("TOPLEFT",tempOffset,-7050)
				label2:SetAlpha(tempAlpha)
			else
				label2:SetAlpha(1)
				label1:SetPoint("TOPLEFT",scf,786,-7050)
				label1:Hide()
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end
--
--
_G["Wowshell_Sound"]:SetScript("OnClick",function(self)
	local audio = _G["Wowshell_SoundMenu"] 
	local video = _G["Wowshell_VideoMenu"]
	settingAnimate(GetTime(),self,video,audio)
	if audio:IsShown() then
		self.text:SetTextColor(1,.5,.25)
		_G["Wowshell_Video"].text:SetTextColor(1,1,1)
	else
		self.text:SetTextColor(1,1,1)
		_G["Wowshell_Video"].text:SetTextColor(1,.5,.25)
	end
end)
--
_G["Wowshell_Video"]:SetScript("OnClick",function(self)
	local audio = _G["Wowshell_SoundMenu"] 
	local video = _G["Wowshell_VideoMenu"]
	settingAnimate(GetTime(),self,audio,video)
	if audio:IsShown() then
		self.text:SetTextColor(1,.5,.25)
		_G["Wowshell_Sound"].text:SetTextColor(1,1,1)
	else
		self.text:SetTextColor(1,1,1)
		_G["Wowshell_Sound"].text:SetTextColor(1,.5,.25)
	end
end)



local cpuAnimate = function(time,widthArg,cpuArg,name,kb,obj)
	local oldTime = time or GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.001 then
			local newTime = GetTime()
			if newTime - oldTime < 0.5 then
				local tempColor = (widthArg/0.5)/500 * (tonumber(string.format("%6.2f",(newTime - oldTime))))
				local tempWidth = (widthArg/0.5) * (tonumber(string.format("%6.2f",(newTime - oldTime)))) 	
				local tempCpu = (cpuArg/0.5) * (tonumber(string.format("%6.2f",(newTime-oldTime))))
				self.bg:SetSize(tempWidth,14)
				self.bg:SetVertexColor(GUI:ColorGradient(tempColor,0,1,0, 1,1,0, 1,0,0))
				self.text:SetText(format("%s : %s",name,tempCpu<=2048 and math.ceil(tempCpu).."kb" or L["Bigthan2M"]))
			else
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end

local cpus = {}
local function sortMemName(a,b)
	return a.mem > b.mem
end
GUI:MemoryUseage()
mf.cpu:SetScript("OnShow",function()
	mf.memoryUseage:Show()
	mf.memoryTip:Show()
	for k, v in pairs(AL) do
		for i = 1, #v do
			if IsAddOnLoaded(v[i]) then
				local mem = GetAddOnMemoryUsage(v[i])
				table.insert(cpus,{name = v[i],mem = math.ceil(mem)})
			end
		end
	end
	table.sort(cpus,sortMemName)
	for k,v in pairs(cpus) do
		local width = 1 
		if v.mem < 2048 then
			width = v.mem/2048
		else
			width = 1
		end
		if k <= 20 then
			mf.addonmems[k]:Show()
			mf.addonmems[k].index:SetText(k)
			cpuAnimate(GetTime(),600*width,v.mem,CFG[v.name][GetLocale()],v.mem,mf.addonmems[k])
		else
			return
		end
	end
end)

mf.cpu:SetScript("OnHide",function()
	table.wipe(cpus)
	mf.memoryUseage:Hide()
	for i = 1, #mf.addonmems do
		local button = mf.addonmems[i]
		button:Hide()
		button.bg:SetSize(0,16)
		button.text:SetText("")
		button.index:SetText("")
	end
end)
	

local hideAnimate = function(self)
	local oldTime = GetTime()
	_G["Wowshell_MainFrame_CloseButton"]:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.0001 then
			local newTime = GetTime()
			if newTime - oldTime < 0.2 then
				local tempScale = (1/0.2) * (tonumber(string.format("%6.2f",(newTime - oldTime)))) + 1
				local tempAlpha = 1 - (1/0.2) * tonumber(string.format("%6.2f",(newTime - oldTime)))
				mf:SetScale(tempScale)
				mf:SetAlpha(tempAlpha)
			else
				mf:SetScale(2)
				mf:SetAlpha(0)
				mf:Hide()
				self:SetScript("OnUpdate",nil)
				MiniMapButtonClick(_G["Wowshell_Minimap_Button"])
			end
			self.nextUpdate = 0
		end
	end)
end

_G["Wowshell_MainFrame_CloseButton"]:SetScript("OnClick",function(self)
	hideAnimate(self);
end)

mf:SetScript("OnKeyDown",function(self,key)
	if key == "ESCAPE" then
		hideAnimate(self)
	elseif key == "ENTER" then
		ChatFrame1EditBox:Show()
		ChatFrame1EditBox:SetFocus()
	elseif key == "PRINTSCREEN" then
		Screenshot()
	end
end)
