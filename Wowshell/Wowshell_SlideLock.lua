﻿--susnow(消逝的流星@NGA)

local addon,ns = ...
local L = ns.locales[GetLocale()]
local texFile = "Interface\\Buttons\\WHITE8X8"
local bgTex = {bgFile = texFile,edgeFile = texFile, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}}
local tex = "Interface\\AddOns\\Wowshell\\media\\"
local barTex = "Interface\\AddOns\\Wowshell\\media\\bar2"
local buttonTex = "Interface\\AddOns\\Wowshell\\media\\button2"


local function CreateFontObject(fontObject,parent,layer,color)
	parent[fontObject] = parent.SlideBar:CreateFontString(layer,nil,"ChatFontNormal")
	local fs = parent[fontObject]
	do 
		local font,size,flag = fs:GetFont()
		fs:SetFont(font,14,"OUTLINE")
	end
	fs:SetText(L["Slide Button To Unlock"].."      ")
	fs:SetPoint("RIGHT",parent.SlideBar,-10,0)
	if color == "Gray" then
		fs:SetTextColor(.3,.3,.3,1)
	elseif color == "White" then
		fs:SetTextColor(1,1,1,1)
	end
end

local month = {"January","February","March","April","May","June","July","Auguest","September","October","November","December"}
local week = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}


local SL = CreateFrame("Frame","SlideLock",WorldFrame)
SL:SetAllPoints(UIParent)
SL.nextUpdate = 0
SL.gradient = 0 
SL:EnableMouse(true)
SL:EnableKeyboard(true)
SL:EnableMouseWheel(true)


--SL:SetBackdrop(bgTex)
--SL:SetBackdropColor(.3,.3,.3,.8)
--SL:SetBackdropBorderColor(0,0,0,0)

SL.SlideBar = CreateFrame("Frame","SlideBar",SL)-- :CreateTexture(nil,"ARTWORK")
SL.SlideBar.nextUpdate = 0
SL.SlideBar:SetSize(256,32)
SL.SlideBar:SetPoint("BOTTOM",SL,0,20)
SL.SlideBar.tex = SL.SlideBar:CreateTexture(nil,"ARTWORK") 
SL.SlideBar.tex:SetTexture(barTex)
SL.SlideBar.tex:SetAllPoints(SL.SlideBar)
SL.CameraButton = CreateFrame("Button",nil,SL)
SL.CameraButton:SetSize(32,32)
SL.CameraButton:SetPoint("LEFT",SL.SlideBar,"RIGHT",-16,1)
SL.CameraButton.tex = SL.CameraButton:CreateTexture(nil,"OVERLAY")
SL.CameraButton.tex:SetTexture(tex.."Camera3")
SL.CameraButton.tex:SetPoint("CENTER",SL.CameraButton)
SL.CameraButton:SetScale(0.94)
SL.SlideButton = CreateFrame("Button",nil,SL)
SL.SlideButton:SetScale(0.94)
SL.SlideButton:SetFrameLevel(SL.SlideBar:GetFrameLevel()+10)
SL.SlideButton.nextUpdate = 0
SL.SlideButton:SetSize(64,32)
SL.SlideButton:SetPoint("LEFT",SL.SlideBar,14,-0.3)
SL.SlideButton.tex = SL.SlideButton:CreateTexture(nil,"OVERLAY")
SL.SlideButton.tex:SetTexture(buttonTex)
SL.SlideButton.tex:SetPoint("CENTER",SL.SlideButton)
SL.SlideButton:EnableKeyboard(true)
SL.control = CreateFrame("Frame")
SL.control.nextUpdate = 0

do 
	CreateFontObject("TextBG",SL,"ARTWORK","Gray")
	CreateFontObject("TextStuff",SL,"OVERLAY","White")
	CreateFontObject("TextCover",SL,"OVERLAY","Gray")
end

SL.Logo = SL:CreateTexture(nil,"OVERLAY")
SL.Logo:SetTexture(tex.."wsLogo2")
SL.Logo:SetPoint("TOP",SL,100,-10)
SL.Logo:SetSize(64,64)
SL.LogoText = SL:CreateFontString(nil,"OVERLAY")
SL.LogoUrl = SL:CreateFontString(nil,"OVERLAY")
SL.LogoText:SetFont(tex.."core_font.ttf",16,"OUTLINE")
SL.LogoUrl:SetFont(tex.."core_font.ttf",16,"OUTLINE")
SL.LogoText:SetPoint("LEFT",SL.Logo,"RIGHT",0,0)
SL.LogoText:SetText(L["Wowshell"])
SL.LogoUrl:SetPoint("TOPLEFT",SL.LogoText,"BOTTOMLEFT")
SL.LogoUrl:SetText("www.wowshell.com")


local BP1 = CreateFrame("Frame",nil,WorldFrame)
BP1:SetBackdrop(bgTex)
BP1:SetBackdropColor(0,0,0,1)
BP1:SetBackdropBorderColor(0,0,0,0)
BP1:SetSize(UIParent:GetWidth(),36)
BP1:SetPoint("BOTTOM",UIParent)

local BP2 =CreateFrame("Frame",nil,WorldFrame)
BP2:SetBackdrop(bgTex)
BP2:SetBackdropColor(.3,.3,.3,1)
BP2:SetBackdropBorderColor(0,0,0,1)
BP2:SetSize(UIParent:GetWidth(),36)
BP2:SetPoint("BOTTOM",BP1,"TOP")

local TP = CreateFrame("Frame",nil,WorldFrame)
TP:SetBackdrop(bgTex)
TP:SetBackdropColor(0,0,0,.5)
TP:SetBackdropBorderColor(0,0,0,0)
TP:SetSize(UIParent:GetWidth(),100)
TP:SetPoint("TOP",UIParent)
TP.time = TP:CreateFontString(nil,"OVERLAY","ChatFontNormal")
TP.time:SetPoint("CENTER",TP)
do 
	local font,size,flag = TP.time:GetFont()
	TP.time:SetFont(font,48,"OUTLINE")
end
TP.time:SetText(format("%s:%s:%s",date("%H"),date("%M"),date("%S")))
TP.YMDW = TP:CreateFontString(nil,"OVERLAY","ChatFontNormal")
do 
	local font,size,flag = TP.YMDW:GetFont()
	TP.YMDW:SetFont(font,10,"NORMAL")
end
TP.YMDW:SetPoint("TOP",TP.time,"BOTTOM",0,-10)
TP:RegisterEvent("PLAYER_LOGIN")
TP:SetScript("OnEvent",function(self)
	local w,m,d,y = CalendarGetDate()
	TP.YMDW:SetText(format("%s, %s%s",L[week[w]],L[month[m]],d..L["DD"]))
end)


SL:SetScript("OnUpdate",function(self,elapsed)
	self.nextUpdate = self.nextUpdate + elapsed
	if self.nextUpdate > 0.05 then
		local maxLength = string.len(self.TextStuff:GetText()) - 6
		self.gradient = self.gradient + 1 
		if self.gradient > maxLength then
			self.gradient = 0 
		end
		local width = 6
		if self.gradient >= (maxLength - 6) then
			width = maxLength - self.gradient
		end
		self.TextStuff:SetAlphaGradient(self.gradient+4, 6)
		self.TextCover:SetAlphaGradient(self.gradient, width+1)
		TP.time:SetText(format("%s:%s:%s",date("%H"),date("%M"),date("%S")))
		self.nextUpdate = 0
	end
end)

SL.SlideButton:SetScript("OnMouseDown",function()
	SL.TextBG:SetAlpha(0)
	SL.TextStuff:SetAlpha(0)
	SL.TextCover:SetAlpha(0)
	local mdmX = GetCursorPosition()  -- mouse's x positon when MouseDown action,every mousedown just get once
	local mdsX = select(4,SL.SlideButton:GetPoint()) -- slider's x positon when MouseDown action, every mousedown just get once
	SL.control:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01  then
			local tempX  = GetCursorPosition()  -- tempX will always update 	
			if IsMouseButtonDown(1) then
				if tempX > mdmX then
					local cusX = select(4,SL.SlideButton:GetPoint())
					if cusX >= 192 then
						SL.SlideButton:Disable()
					else	
						SL.SlideButton:SetPoint("LEFT",SL.SlideBar,(mdsX+ tempX - mdmX),-0.3)
					end
				elseif tempX < mdmX then

				end
			elseif not IsMouseButtonDown(1) then
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end)

SL.SlideButton:SetScript("OnMouseUp",function(self)
	SL.TextBG:SetAlpha(1)
	SL.TextStuff:SetAlpha(1)
	SL.TextCover:SetAlpha(1)
	SL.control:SetScript("OnUpdate",nil)
	local musX = select(4,SL.SlideButton:GetPoint())
	if musX >= 55 then
		local oldTime = GetTime()
		self:SetScript("OnUpdate",function(self,elapsed)
			self.nextUpdate = self.nextUpdate + elapsed
			if self.nextUpdate > 0.01 then
				local newTime = GetTime()
				if newTime - oldTime < 0.3 then
					local tempX = ((194-musX)/0.3)*(newTime - oldTime)+musX	
					self:SetPoint("LEFT",SL.SlideBar,tempX,-0.3)
				else
					self:SetScript("OnUpdate",nil)
					PlaySoundFile(tex.."Unlock2.ogg","Master")
					self:SetPoint("LEFT",SL.SlideBar,194,-0.3)
					UIParent:Show()
					SL:ToggleSlideLock("HIDE")
				end
			self.nextUpdate = 0
			end
		end)
	elseif musX < 55 then
		local oldTime = GetTime()
		self:SetScript("OnUpdate",function(self,elapsed)
			self.nextUpdate = self.nextUpdate + elapsed
			if self.nextUpdate > 0.01 then
				local newTime = GetTime()
				if newTime - oldTime < 0.1 then
					local tempX = musX - ((musX - 13.5)/0.1) * (newTime - oldTime) 
					self:SetPoint("LEFT",SL.SlideBar,tempX,-0.3)
				else
					self:SetScript("OnUpdate",nil)
					self:SetPoint("LEFT",SL.SlideBar,13.5, -0.3)
				end
			self.nextUpdate = 0
			end
		end)
	end
end)

SL.CameraButton:RegisterEvent("SCREENSHOT_SUCCEEDED")
SL.CameraButton:SetScript("OnClick",function(self)
	Screenshot()
	self:SetScript("OnEvent",function()
		PlaySoundFile(tex.."Camera.ogg","Master")
	end)
end)

-- don't Unregister these two handlers , because I need to intercept all keyboard and mouse action
SL:SetScript("OnKeyDown",function(self,key)
	--
end)
SL:SetScript("OnMouseWheel",function()

end)

function SL:ToggleSlideLock(flag)
	if flag == "HIDE" then
		SL:Hide()
		BP1:Hide()
		BP2:Hide()
		TP:Hide()
		SetUIVisibility(true)
		MoveViewRightStop()
	elseif flag == "SHOW" then
		SL:Show()
		SL.SlideButton:SetPoint("LEFT",SL.SlideBar,13.5, -0.3)
		BP1:Show()
		BP2:Show()
		TP:Show()
		PlaySoundFile(tex.."lock2.ogg","Master")
		MoveViewRightStart(0.01)
	end
end

--UIParent:HookScript("OnHide",function()
--	ToggleSlideLock("SHOW")
--end)
--
--UIParent:HookScript("OnShow",function()
--	ToggleSlideLock("HIDE")
--end)

SL:ToggleSlideLock("HIDE")




