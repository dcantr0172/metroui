--susnow
local addon,ns = ...
local texture = "Interface\\Buttons\\WHITE8x8"

local tex1 = "Interface\\AddOns\\Wowshell\\media\\wsLogo"
local tex2 = "Interface\\AddOns\\Wowshell\\media\\wsLogo2"
local tex3 = "Interface\\AddOns\\Wowshell\\media\\o"
local tex4 = "Interface\\AddOns\\Wowshell\\media\\o2"
local cf = "Interface\\AddOns\\Wowshell\\media\\core_font"
local L = ns.locales[GetLocale()]

local f = CreateFrame("Frame",nil,UIParent)
f.nextUpdate = 0
f:SetSize(418,72)
f:SetPoint("TOP",UIParent,0,-230)
f.icon = CreateFrame("BUTTON",nil,f)
f.icon:SetSize(50,50)
f.icon:SetPoint("CENTER",f,0,18)
f.icon.tex = f.icon:CreateTexture(nil,"OVERLAY")
f.icon.tex:SetTexture(tex2)
f.icon.tex:SetAllPoints(f.icon)
f.icon.tex:SetVertexColor(1,1,1,1)
f.text = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
do 
	local font,size,flag = f.text:GetFont()
	f.text:SetFont(cf,18,"OUTLINE")
end

f.text:SetPoint("BOTTOM",0,10)
f.text:SetText(L["Welcome"])

f.bg = f:CreateTexture(nil,"OVERLAY")
f.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
f.bg:SetSize(326,103)
f.bg:SetPoint("BOTTOM")
f.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
f.bg:SetVertexColor(1,1,1,.6)

f.bl = f:CreateTexture(nil,"OVERLAY")
f.bl:SetTexture([[Interface\LevelUp\LevelUpTex]])
f.bl:SetPoint("BOTTOM")
f.bl:SetSize(418,7)
f.bl:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)
f:SetAlpha(0)
f:Hide()

local b = CreateFrame("Frame",nil,_G["Wowshell_Minimap_Button"])
b.icon = b:CreateTexture(nil,"OVERLAY")
b.icon:SetPoint("TOPLEFT",_G["Wowshell_Minimap_Button"],0,2)
b.icon:SetPoint("BOTTOMRIGHT",_G["Wowshell_Minimap_Button"],1,0)
b.icon:SetTexture(tex3)
b.icon:SetVertexColor(1,0.75,0,.8)
b.nextUpdate = 0
b:SetAlpha(0)
b:Hide()

local m = CreateFrame("Frame",nil,_G["Wowshell_Minimap_Button"])
m.icon = m:CreateTexture(nil,"OVERLAY")
m.icon:SetPoint("TOPLEFT",_G["Wowshell_Minimap_Button"],2,-2)
m.icon:SetPoint("BOTTOMRIGHT",_G["Wowshell_Minimap_Button"] ,5,-6)
m.icon:SetTexture("Interface\\UnitPowerBarAlt\\Atramedes_Circular_Flash")
m.icon:SetVertexColor(1, 1, 0.3, .8)
m.icon:SetBlendMode("ADD")
m.nextUpdate = 0
m:SetAlpha(0)
m:Hide()


function ns:StartShow(obj,time)
	obj:Show()
	local oldTime = time or GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()
			if (newTime - oldTime) < 1 then
				local tempAlpha = tonumber(string.format("%6.2f",(newTime - oldTime)))
				self:SetAlpha(tempAlpha)
			else
				self:SetAlpha(1)
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end

function ns:StartHide(obj,time)
	local oldTime = time or GetTime() 
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()
			if (newTime - oldTime) < 1 then
				local tempOffsetY = tonumber(string.format("%6.2f",(newTime - oldTime)))
				local tempAlpha = tonumber(string.format("%6.2f",(newTime - oldTime))) 	
				self:SetAlpha(1-tempAlpha)
			else
				self:SetAlpha(0)
				self:SetScript("OnUpdate",nil)
				self:Hide()
			end
			self.nextUpdate = 0
		end
	end)
end

local FPS = CreateFrame("Frame")
FPS.nextUpdate = 0

function ns:CheckFPS(obj)
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed 
		if self.nextUpdate > 30 then
			local fps = GetFramerate()
			fps = floor(fps+0.5)
			if fps < 5 then
				UIErrorsFrame:AddMessage(L["LowFPS"],1,1,0,1)
			end
			self.nextUpdate = 0
		end
	end)
end

ns:CheckFPS(FPS)

f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_CAMPING")
f:RegisterAllEvents()
f:SetScript("OnEvent",function(self,e)
	if e == "PLAYER_LOGIN" then 
		ns:StartShow(f,GetTime()+8)
		ns:StartShow(m,GetTime()+8)
		ns:StartHide(f,GetTime()+10)
		ns:StartHide(m,GetTime()+10)
	elseif e == "PLAYER_CAMPING" then
		f.text:SetText(L["Thanks"])
		ns:StartShow(f,GetTime()+8)
		ns:StartShow(m,GetTime()+8)
		ns:StartHide(f,GetTime()+10)
		ns:StartHide(m,GetTime()+10)
	end
end)

f.icon:SetScript("OnClick",function()
	--TODO
end)

