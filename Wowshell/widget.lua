--susnow
local addon,ns = ...
local L = ns.locales[GetLocale()]

--texture
local bgTex = "Interface\\Buttons\\WHITE8x8"
local tex = "Interface\\AddOns\\Wowshell\\media\\"
local logoTex = tex.."wsLogo2"
local backTex = tex.."back"
local forwardTex = tex.."forward"
local beta = tex.."beta.ttf"
local cf = tex.."core_font.ttf"

local GUI = CreateFrame("Frame")

local categorys = { "UnitFrame","ActionBar","Map","Chat","CastSpell","Bag","Quest","Archievement","Raid","PVP","Database","Business"}

function GUI:MainFrame() 
	local mf = CreateFrame("ScrollFrame","Wowshell_MainFrame",UIParent)
	mf.nextUpdate = 0
	mf:SetSize(800,600)
	mf:SetPoint("CENTER")
	mf:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	mf:SetBackdropColor(.1,.1,.1,.5)
	mf:SetBackdropBorderColor(0,0,0,1)
	mf.logo = CreateFrame("Button","Wowshell_Logo",mf)
	mf.logo:SetSize(64,64)
	mf.logo:SetPoint("TOPLEFT",10,-10)
	mf.logo.bg = mf.logo:CreateTexture(nil,"OVERLAY")
	mf.logo.bg:SetPoint("TOP",mf.logo,6,-6)
	mf.logo.bg:SetTexture(logoTex)
	mf.logo.title = mf.logo:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	mf.logo.title:SetPoint("BOTTOMLEFT",mf.logo,"BOTTOMRIGHT",10,0)
	do 
		local font,size,flag = mf.logo.title:GetFont()
		mf.logo.title:SetFont(cf,38,"OUTLINE")
	end
	mf.logo.title:SetText(L["Wowshell"])	

	mf.opLine = mf:CreateTexture(nil,"OVERLAY")
	mf.opLine:SetSize(mf:GetWidth()-100,1)
	mf.opLine:SetPoint("TOPLEFT",mf.logo,"BOTTOMLEFT",50,-10)
	mf.opLine:SetTexture(bgTex)
	mf.opLine:SetVertexColor(1,1,1,.2)
	mf:EnableMouse(true)
	mf:EnableMouseWheel(true)
	mf:RegisterForDrag("LeftButton")

	local f = CreateFrame("ScrollFrame","Wowshell_MainFrame_ScrollFrame_Parent",mf)
	f:SetSize(mf:GetWidth()-100,mf:GetHeight()-120)--2500)--520)
	f:SetPoint("TOPLEFT",mf,0,-100)
	f.nextUpdate = 0	

	local scf = CreateFrame("Frame","Wowshell_MainFrame_ScrollFrame",f)	
	scf.nextUpdate = 0
	scf:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	scf:SetBackdropBorderColor(1,1,1,0)
	scf:SetBackdropColor(0,0,0,0)
	scf:SetSize(f:GetWidth()-10,f:GetHeight()-10)
	scf:SetPoint("TOPLEFT",f,50,-50)
	scf.nextUpdate = 0
	f:SetScrollChild(scf)
	
	mf:SetScript("OnMouseWheel",function(self,delay)
		if scf.updateLog:IsShown() then 
			self:SetScript("OnMouseWheel",nil) 
			return 
		end
		local curScr = f:GetVerticalScroll()
		if delay == 1 then
			f:SetVerticalScroll((curScr - 30))	
			if curScr < -60 then
				f:SetVerticalScroll(0)
			end
		elseif delay == -1 then
			f:SetVerticalScroll((curScr + 30))	
		end
	end)

	mf:SetScript("OnDragStart",function(self,button)
		if scf.updateLog:IsShown() then 
			self:SetScript("OnMouseWheel",nil) 
			return 
		end
		local curX, curY = GetCursorPosition()
		local curScr = f:GetVerticalScroll()
		self:SetScript("OnUpdate",function(self,elapsed)
			self.nextUpdate = self.nextUpdate + elapsed
			if self.nextUpdate > 0.1 then
				local tmpX, tmpY = GetCursorPosition()
				if tmpY > curY then -- up
					f:SetVerticalScroll((curScr + (tmpY-curY)))	
				elseif tmpY < curY then --bottom
					local tmpScr = f:GetVerticalScroll()
					f:SetVerticalScroll((curScr - (curY-tmpY)))	
					if tmpScr < -60 then
						self:SetScript("OnUpdate",nil)
						f:SetVerticalScroll(0)
					end
				else
					
				end
				self.nextUpdate = 0
			end
		end)
	end)
	
	mf:SetScript("OnDragStop",function(self,button)
		self:SetScript("OnUpdate",nil)
	end)

	mf:SetScript("OnMouseDown",function(self,button)
		if IsLeftControlKeyDown() and button == "LeftButton" then
			self:SetMovable(true)
			self:StartMoving()
		end
	end)
	mf:SetScript("OnMouseUp",function(self,button)
		self:StopMovingOrSizing()
	end)

	mf.scf = scf
end

function GUI:BetaLogo()
	local mf = _G["Wowshell_MainFrame"]
	mf.betaLogo = mf:CreateFontString(nil,"OVERLAY")
	mf.betaLogo:SetFont(beta,12,"OUTLINE")
	mf.betaLogo:SetPoint("BOTTOMRIGHT",mf.logo.title,"TOPRIGHT")
	mf.betaLogo:SetText("beta")
	mf.curBuild = mf:CreateFontString(nil,"OVERLAY")
	mf.curBuild:SetFont(beta,12,"OUTLINE")
	mf.curBuild:SetPoint("BOTTOMLEFT",mf.logo,"TOPLEFT",0,2)
	mf.curBuild:SetText("Cataclysm")
end

function GUI:MainFrameButton(parent,name,point,handler)
	local button = CreateFrame("Button","Wowshell_MainFrame_"..name:gsub("^%l",string.upper).."Button",parent)
	button.tip = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	button:SetSize(32,32)
	button:SetPoint(unpack(point))
	button.bg = button:CreateTexture(nil,"OVERLAY")
	button.bg:SetAllPoints(button)
	button.bg:SetTexture(tex..name)
	button.bg:SetVertexColor(1,1,1)
	if name == "help" then
		button.bg:SetVertexColor(1,.5,.25)
	end
	button:SetScript("OnEnter",function(self)
		self.bg:SetVertexColor(1,.5,.25)	
		self.tip:Show()
		if name == "help" then
			button.bg:SetVertexColor(1,1,1)
		end
	end)
	button:SetScript("OnLeave",function(self)
		self.bg:SetVertexColor(1,1,1)	
		if name == "help" then
			button.bg:SetVertexColor(1,.5,.25)
		end
		self.tip:Hide()
	end)
	button:SetScript("OnClick",function()
		handler()
	end)
	button.tip:SetPoint("TOP",button,"BOTTOM",0,-10)
	do 
		local font,size,flag = button.tip:GetFont()
		button.tip:SetFont(cf,size,"THICK")
	end
	button.tip:SetText(L[name])
	button.tip:Hide()
end

function GUI:SearchBox()
	local mf = _G["Wowshell_MainFrame"]
	local editbox = CreateFrame("EditBox","Wowshell_SearchBox",mf)	
	editbox:SetSize(250,25)
	editbox:SetPoint("BOTTOMLEFT",mf.logo.title,"BOTTOMRIGHT",10,0)
	editbox:SetAutoFocus(false)
	editbox:EnableMouse(true)
	editbox:SetFontObject(ChatFontNormal)
	do local f,s,flag = editbox:GetFont()
		editbox:SetFont(cf,s,flag)
	end
	editbox:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	editbox:SetBackdropColor(.2,.2,.2,.5)
	editbox:SetBackdropBorderColor(.1,.1,.1,1)
	editbox:SetTextInsets(5,0,0,0)
	editbox:SetText(L["SearchBoxText"])
	editbox:SetTextColor(.7,.7,.7)
	editbox.tip = editbox:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local f,s,flag = editbox.tip:GetFont()
		editbox.tip:SetFont(cf,s,flag)
	end
	editbox.tip:SetPoint("BOTTOMLEFT",editbox,"TOPLEFT",0,5)
	editbox.tip:SetText(L["SearchTip"])
	editbox.tip:Hide()
	editbox.input = editbox:CreateTexture(nil,"OVERLAY")
	editbox.input:SetTexture(tex.."input")
	editbox.input:SetSize(26,26)
	editbox.input:SetPoint("RIGHT",editbox,-5,0)
	editbox.input:SetVertexColor(1,.5,.25)
	editbox.input:Hide()
	editbox:HookScript("OnEditFocusGained",function(self) 
		self:SetFocus()
		self:SetSize(250,25)
		self:SetText("")
		self:SetTextColor(1,1,1,1)
		self:SetBackdropBorderColor(1,.5,.25,1)
		self.input:Show()
	end)
	editbox:HookScript("OnEditFocusLost",function(self)
		self:ClearFocus()
		self:SetSize(250,25)
		self:SetTextColor(.7,.7,.7,1)
		self:SetBackdropBorderColor(.1,.1,.1,1)
		self:SetText(L["SearchBoxText"])
		self.input:Hide()
	end)
	editbox:SetScript("OnEnter",function(self)
		self.tip:Show()
	end)
	editbox:SetScript("OnLeave",function(self)
		self.tip:Hide()
	end)
	editbox:SetScript("OnEnterPressed",function(self)
		self:ClearFocus()
	end)
end

function GUI:HelpDocs()
	local mf = _G["Wowshell_MainFrame"]
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	mf.helpDoc = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = mf.helpDoc:GetFont()
		mf.helpDoc:SetFont(cf,26,"OUTLINE")
	end
	mf.helpDoc:SetSize(500,500)
	mf.helpDoc:SetWordWrap(true)
	mf.helpDoc:SetJustifyH("LEFT")
	--mf.helpDoc:SetJustifyV("TOP")
	mf.helpDoc:SetSpacing(20)
	mf.helpDoc:SetPoint("TOPLEFT",scf,750,-6000)
	mf.helpDoc:SetText(L["helpDoc"])
	mf.helpDoc:Hide()
end

function GUI:CategoryButton(parent,name,index,hander)
	local button = CreateFrame("Button","Wowshell_Category_"..name:gsub("^%l",string.upper).."Button",parent)
	button:SetSize(parent:GetWidth() - 100,20)
	button.bg = button:CreateTexture(nil,"OVERLAY")
	button.bg:SetTexture(bgTex)
	button.bg:SetAllPoints(button)
	button.bg:SetVertexColor(.3,.3,.3,0) --.2
	button.fw = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	button.fw:SetPoint("LEFT",button)
	do 
		local font,size,flag = button.fw:GetFont()
		button.fw:SetFont(cf,24,"OUTLINE")
	end
	button.sw = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	button.sw:SetPoint("BOTTOMLEFT",button.fw,"BOTTOMRIGHT")
	do 
		local font,size,flag = button.sw:GetFont()
		button.sw:SetFont(cf,12,"OUTLINE")
	end
	local fw,sw = string.sub(L[name],1,3),string.sub(L[name],4)
	button.fw:SetText(fw)
	button.sw:SetText(sw)
end

function GUI:CategoryButtonSetPoint(categorys,index)
	local button = _G["Wowshell_Category_"..categorys[index]:gsub("^%l",string.upper).."Button"]
	if index == 1 then 
		button:SetPoint("TOPLEFT",_G["Wowshell_MainFrame_ScrollFrame"],750,-20)	
	elseif index >1 then 
		button:SetPoint("TOPLEFT",_G["Wowshell_Category"..categorys[index-1].."_ChildFrame"],"BOTTOMLEFT",0,-30)
	end
end

function GUI:CategoryChildFrame(parent)
	local f = CreateFrame("Frame","Wowshell_Category"..parent.."_ChildFrame",_G["Wowshell_Category_"..parent.."Button"])
	f:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	f:SetBackdropColor(1,1,1,0) -- .2
	f:SetBackdropBorderColor(0,0,0,0) -- 1
	f:SetPoint("TOPLEFT",_G["Wowshell_Category_"..parent.."Button"],"BOTTOMLEFT")
end

function GUI:CategoryChildFrameSetSize(parent,index)
	local f = _G["Wowshell_Category"..parent.."_ChildFrame"]
	local num = math.ceil(index/5)
	for i = 1, num do
		f:SetSize(_G["Wowshell_Category_"..parent.."Button"]:GetWidth(),100*i)
	end
end

function GUI:CategoryChildFrameButtons(parent,index)
	local button = CreateFrame("Button","Wowshell_Category"..parent.."_ChildFrame_Button"..index,_G["Wowshell_Category"..parent.."_ChildFrame"])
	button:SetSize(50,50)
	button:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 2, bottom = -2,left = 2,right = 2}})
	button:SetBackdropColor(.3,.3,.3,.2)
	button:SetBackdropBorderColor(0,0,0,1)
	button.bg = button:CreateTexture(nil,"OVERLAY")
	button.bg:SetPoint("TOPLEFT",1,-1)
	button.bg:SetPoint("BOTTOMRIGHT",-1,1)
	--button.bg:SetTexture([[Interface/ICONS/Ability_Hunter_MarkedForDeath]])
	button.bg:SetTexCoord(.1,.9,.1,.9)
	button.text = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local f,s,flag = button.text:GetFont()
		button.text:SetFont(cf,s,flag)
	end
	button.text:SetSize(button:GetWidth()+24,30)
	button.text:SetPoint("TOP",button,"BOTTOM",0,-10)
	button.text:SetWordWrap(true)
	button:RegisterForClicks("AnyUp")
end

function GUI:CategoryChildFrameButtonsSetPoint(parent,index)
	local button = _G["Wowshell_Category"..parent.."_ChildFrame_Button"..index]
	local modNum = 5
	if index % modNum - 1 ~= 0 and index > modNum then 
		button:SetPoint("TOPLEFT",_G["Wowshell_Category"..parent.."_ChildFrame_Button"..(index-1)],"TOPRIGHT",90,0)
	elseif index % modNum - 1 == 0 and index > modNum then
		button:SetPoint("TOPLEFT",_G["Wowshell_Category"..parent.."_ChildFrame_Button"..(index-modNum)],"BOTTOMLEFT",0,-40)
	elseif index % modNum - 1 ~= 0 and index <= modNum then
		button:SetPoint("TOPLEFT",_G["Wowshell_Category"..parent.."_ChildFrame_Button"..(index-1)],"TOPRIGHT",90,0)
	elseif index == 1 then
		button:SetPoint("TOPLEFT",_G["Wowshell_Category"..parent.."_ChildFrame"],30,-20)	
	end
end

function GUI:TipFrame()
	local mf = _G["Wowshell_MainFrame"]
	local f = CreateFrame("Frame","Wowshell_TipFrame",mf)
	f:SetSize(600,70)
	f:SetPoint("CENTER",mf)
	f:SetFrameLevel(mf:GetFrameLevel() + 10)
	--f:SetPoint("TOPLEFT",mf,"BOTTOMLEFT",0,-20)
	f:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	f:SetBackdropColor(.1,.1,.1,.5)
	f:SetBackdropBorderColor(0,0,0,1)
	f.text = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local font,size,flag = f.text:GetFont()
		f.text:SetFont(cf,size,flag)
	end
	f.text:SetSize(f:GetWidth()-20,f:GetHeight()-10)
	f.text:SetPoint("TOPLEFT",f,10,-5)
	f.text:SetText("")
	f.text:SetJustifyV("LEFT")
	f.text:SetJustifyH("TOP")
	f.nextUpdate = 0
	f:Hide()
	
end

function GUI:TipFrameOnShow(time)
	local f = _G["Wowshell_TipFrame"]
	local oldTime = time or GetTime() 
	f:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()
			if newTime - oldTime < 1 then
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

function GUI:TipFrameOnHide(time)
	local f = _G["Wowshell_TipFrame"]
	local oldTime = time or GetTime() 
	f:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()
			if newTime - oldTime < 1 then
				local tempAlpha = 1 - tonumber(string.format("%6.2f",(newTime - oldTime)))
				self:SetAlpha(tempAlpha)
			else
				self:SetAlpha(0)
				self:SetScript("OnUpdate",nil)
				self:Hide()
			end
			self.nextUpdate = 0
		end
	end)

end

function GUI:StatsBar()
	local mf = _G["Wowshell_MainFrame"]
	local bar = CreateFrame("Frame","Wowshell_StatesBar",mf)
	bar:SetSize(mf:GetWidth(),30)
	bar:SetPoint("TOPLEFT",mf,"BOTTOMLEFT")
	bar.uLog = CreateFrame("Button","Wowshell_UpdateLog_Button",bar)
	bar.uLog:SetSize(150,bar:GetHeight())
	bar.uLog:SetPoint("BOTTOMRIGHT",bar)
	bar.uLog.text = bar.uLog:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = bar.uLog.text:GetFont()
		bar.uLog.text:SetFont(cf,size,"OUTLINE")
	end
	bar.uLog.text:SetPoint("RIGHT",bar.uLog)
end

function GUI:UpdateLog()
	local mf = _G["Wowshell_MainFrame"]
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	local f = CreateFrame("Frame","Wowshell_UpdateLog_Frame",sf)
	scf.title = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = scf.title:GetFont()
		scf.title:SetFont(cf,24,"OUTLINE")
	end
	scf.title:SetText(L["Log"])
	scf.title:SetPoint("TOPLEFT",scf,100,-20)
	scf.content = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local fs,sz,fl = scf.content:GetFont()
		scf.content:SetFont(cf,sz,fl)
	end
	scf.content:SetSize(700,500)
	scf.content:SetPoint("TOPLEFT",scf.title,"BOTTOMLEFT",10,-20)
	--scf.content:SetText("1. xxxxxxxxxxxxx \n2. xxxxxxxxxxxxx \n3. xxxxxxxxxxxxx")
	scf.content:SetJustifyV("TOP")
	scf.content:SetJustifyH("LEFT")
	scf.content:SetWordWrap(true)
	scf.content:SetSpacing(10)
	scf.updateLog = f
	f:Hide()
end

function GUI:ResultFrame()
	local mf = _G["Wowshell_MainFrame"]
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	local f = CreateFrame("Frame","Wowshell_SearchResult_Frame",sf)
	scf.searchTitle = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
  scf.searchTitle:SetPoint("TOPLEFT",scf,1500,0)
  do 
		local font,size,flag = scf.searchTitle:GetFont()
		scf.searchTitle:SetFont(cf,24,"OUTLINE")
	end
	scf.searchTitle:SetText(L["SearchTitle"])
  scf.searchResult = f
end

function GUI:SearchResultButtons()
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	for i = 1, 25 do
		local button = CreateFrame("Button","Wowshell_SearchResult_Button"..i,scf)
		button:SetSize(50,50)
		button:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 2, bottom = -2,left = 2,right = 2}})
		button:SetBackdropColor(.3,.3,.3,.2)
		button:SetBackdropBorderColor(0,0,0,1)
		button.bg = button:CreateTexture(nil,"OVERLAY")
		button.bg:SetPoint("TOPLEFT",1,-1)
		button.bg:SetPoint("BOTTOMRIGHT",-1,1)
		--button.bg:SetTexture([[Interface/ICONS/Ability_Hunter_MarkedForDeath]])
		button.bg:SetTexCoord(.1,.9,.1,.9)
		button.text = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
		do local fs,sz,fl = button.text:GetFont()
			button.text:SetFont(cf,sz,fl)
		end
		button.text:SetSize(button:GetWidth()+24,30)
		button.text:SetPoint("TOP",button,"BOTTOM",0,-10)
		button.text:SetWordWrap(true)
		button.text:SetText("")
		button:RegisterForClicks("AnyUp")
		local modNum = 5
		if i % modNum - 1 ~= 0 and i > modNum then 
			button:SetPoint("TOPLEFT",_G["Wowshell_SearchResult_Button"..(i-1)],"TOPRIGHT",90,0)
		elseif i % modNum - 1 == 0 and i > modNum then
			button:SetPoint("TOPLEFT",_G["Wowshell_SearchResult_Button"..(i-modNum)],"BOTTOMLEFT",0,-40)
		elseif i % modNum - 1 ~= 0 and i <= modNum then
			button:SetPoint("TOPLEFT",_G["Wowshell_SearchResult_Button"..(i-1)],"TOPRIGHT",90,0)
		elseif i == 1 then
			button:SetPoint("TOPLEFT",scf.searchTitle,30,-50)	
		end

	end
end

function GUI:MiniMapButton()
	local button = CreateFrame("Button","Wowshell_Minimap_Button",UIParent)
	button.nextUpdate = 0 
	button:SetSize(40,40)

	button:SetPoint("CENTER",Minimap,"LEFT",-10,-10)
	button.bd = button:CreateTexture(nil,"OVERLAY")
	button.icon = button:CreateTexture(nil,"ARTWORK")
	button.icon:SetSize(32,32)

	button.icon:SetTexture(tex.."minimapButton")
	button.icon:SetPoint("TOPLEFT",button,8,-8)

	button.tip = button:CreateFontString(nil,"OVERLAY","GameFontNormal")
	do local fs,sz,fl = button.tip:GetFont()
		button.tip:SetFont(cf,sz,fl)
	end
	button.tip:SetSize(95,80)
	button.tip:SetWordWrap(true)
	button.tip:SetText(L["MinimapTip"])
	button.tip:SetPoint("RIGHT",button,"BOTTOMLEFT",3,0)
	button.tip:Hide()
	button:SetScript("OnEnter",function(self)
		self.tip:Show()
	end)
	button:SetScript("OnLeave",function(self)
		self.tip:Hide()
	end)
end


function GUI:SetHScroll(flag,time,offset,handler)
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local mf = _G["Wowshell_MainFrame"]
	local oldTime = time or GetTime() 
	sf:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()
			if newTime - oldTime < 0.3 then
				local tempOffset =  (700/0.3)*(tonumber(string.format("%6.2f",(newTime - oldTime))))	
				--print(tempOffset)
				if flag == "LEFT" then
					tempOffset = 0 + tempOffset + offset
				elseif flag == "RIGHT" then
					tempOffset = 0 - tempOffset + offset
				end
				sf:SetHorizontalScroll(tempOffset)
			else
				self:SetScript("OnUpdate",nil)
				handler()
			end
			self.nextUpdate = 0
		end
	end)


end


function GUI:MouseOverTipFrame()
	local mf = _G["Wowshell_MainFrame"] 
	local f = CreateFrame("Frame","Wowshell_GameTooltip",mf)
	f.nextUpdate = 0 
	f.nextFlag = 1
	f:SetFrameLevel(mf:GetFrameLevel()+8)
	f:SetSize(400,150)
	f:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	f:SetBackdropColor(.1,.1,.1,.8)
	f:SetBackdropBorderColor(0,0,0,1)
	f.addonName = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	f.category = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	f.suggest = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local fs,sz,fl = f.addonName:GetFont()
		f.addonName:SetFont(cf,sz,fl)
		f.category:SetFont(cf,sz,fl)
		f.suggest:SetFont(cf,sz,fl)
	end
	f.suggest:SetSize(f:GetWidth()-20,30)
	f.suggest:SetJustifyH("LEFT")
	f.suggest:SetJustifyV("TOP")
	f.suggest:SetWordWrap(true)
	f.memory = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do local fs,sz,fl = f.memory:GetFont()
		f.memory:SetFont(cf,sz,fl)
	end
	f.addonName:SetPoint("TOPLEFT",f,10,-10)
	f.category:SetPoint("TOPLEFT",f.addonName,"BOTTOMLEFT",0,-10)
	f.memory:SetPoint("TOPLEFT",f.category,"BOTTOMLEFT",0,-10)
	f.suggest:SetPoint("TOPLEFT",f.memory,"BOTTOMLEFT",0,-10)
	f:Hide()
	f.left = f:CreateTexture(nil,"ARTWORK")
	f.right = f:CreateTexture(nil,"ARTWORK")
	f.left:SetSize(34,30)
	f.left:SetTexture(tex.."mouse")
	f.left:SetPoint("BOTTOMLEFT",f,5,5)
	f.right:SetSize(34,30)
	f.right:SetTexture(tex.."mouse")
	f.right:SetPoint("BOTTOMLEFT",f.left,"BOTTOMRIGHT",140,0)
	f.leftClick = f:CreateTexture(nil,"OVERLAY")
	f.leftClick:SetSize(12,12)
	f.leftClick:SetPoint("TOPLEFT",f.left,5,0)
	f.leftClick:SetTexture(tex.."o2")
	f.leftClick:SetVertexColor(1,0,0,1)
	f.leftText = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	f.leftText:SetPoint("BOTTOMLEFT",f.leftClick,"BOTTOMRIGHT",25,-10)
	f.leftText:SetText(L["LeftClick"])
	f.rightClick = f:CreateTexture(nil,"OVERLAY")
	f.rightClick:SetSize(12,12)
	f.rightClick:SetPoint("TOPRIGHT",f.right,-5,0)
	f.rightClick:SetTexture(tex.."o2")
	f.rightClick:SetVertexColor(1,0,0,1)
	f.rightText = f:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	f.rightText:SetPoint("BOTTOMLEFT",f.rightClick,"BOTTOMRIGHT",5,-10)
	f.rightText:SetText(L["RightClick"])
	do local fs,sz,fl = f.leftText:GetFont()
		f.leftText:SetFont(cf,sz,fl)
		f.rightText:SetFont(cf,sz,fl)
	end
	f:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.5 then
			self.nextFlag = self.nextFlag + 1	
			if self.nextFlag % 2 == 0 then
				self.leftClick:Hide()
				self.rightClick:Hide()
			else
				self.leftClick:Show()
				self.rightClick:Show()
			end
			self.nextUpdate = 0
		end
	end)
end

function GUI:MouseOverTipFrameSetPoint(parent)
	local f = _G["Wowshell_GameTooltip"]
	f:SetPoint("TOPLEFT",parent,"BOTTOMRIGHT")
end

function GUI:MemoryUseage()
	local mf = _G["Wowshell_MainFrame"]
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	mf.cpu = CreateFrame("Frame",nil,scf)
	mf.cpu:Hide()
	mf.memoryUseage = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = mf.memoryUseage:GetFont()
		mf.memoryUseage:SetFont(cf,26,"OUTLINE")
	end
	mf.memoryUseage:SetPoint("TOPLEFT",scf,750,-5000)
	mf.memoryUseage:SetText(L["MemoryUseage"])
	mf.memoryUseage:Hide()
	mf.memoryTip = CreateFrame("Button",nil,scf)
	mf.memoryTip:SetSize(250,2)
	mf.memoryTip:SetPoint("TOPLEFT",scf,1150,-5475)
	mf.memoryTip.t1 = scf:CreateFontString(nil,"OVERLAY")
	mf.memoryTip.t2 = scf:CreateFontString(nil,"OVERLAY")
	mf.memoryTip.t3 = scf:CreateFontString(nil,"OVERLAY")
	mf.memoryTip.t1:SetPoint("BOTTOMLEFT",mf.memoryTip,"TOPLEFT")
	mf.memoryTip.t2:SetPoint("BOTTOM",mf.memoryTip,"TOP")
	mf.memoryTip.t3:SetPoint("BOTTOMRIGHT",mf.memoryTip,"TOPRIGHT")
	mf.memoryTip.t1:SetFont(beta,8,"OUTLINE")
	mf.memoryTip.t2:SetFont(beta,8,"OUTLINE")
	mf.memoryTip.t3:SetFont(beta,8,"OUTLINE")
	mf.memoryTip.t1:SetText("Low")
	mf.memoryTip.t2:SetText("Medium")
	mf.memoryTip.t3:SetText("High")
	mf.memoryTip:Hide()
	--mf.memoryTip.t1:Hide()
	--mf.memoryTip.t2:Hide()
	--mf.memoryTip.t3:Hide()
	for i = 1, 250 do
		local bg = mf.memoryTip:CreateTexture(nil,"OVERLAY")
		bg:SetSize(1,2)
		bg:SetTexture(bgTex)
		bg:SetVertexColor(GUI:ColorGradient(i*0.004,0,1,0, 1,1,0, 1,0,0))
		bg:SetPoint("TOPLEFT",mf.memoryTip,(i-1)*1,0)	
	end
	mf.addonmems = {}
	for i = 1, 20 do
		local button = CreateFrame("Button",nil,scf)
		button.nextUpdate = 0
		button:SetSize(500,14)
		button.bg = button:CreateTexture(nil,"OVERLAY")
		button.bg:SetTexture(bgTex)
		button.bg:SetSize(button:GetWidth(),button:GetHeight())
		button.bg:SetPoint("TOPLEFT",button)
		button.bg:SetVertexColor(.1,.1,.1)
		button.text = button:CreateFontString(nil,"OVERLAY")
		button.text:SetFont(cf,12,"OUTLINE")
		button.text:SetPoint("LEFT",button.bg,"RIGHT",5,0)
		button.text:SetText("")
		button.index = button:CreateFontString(nil,"OVERLAY")
		button.index:SetSize(button:GetHeight()*1.5,button:GetHeight())
		button.index:SetFont(cf,12,"OUTLINE")
		button.index:SetPoint("TOPRIGHT",button,"TOPLEFT",-5,0)
		button.index:SetText("")
		button.bottomBD = button:CreateTexture(nil,"OVERLAY")
		button.rightBD = button:CreateTexture(nil,"OVERLAY")
		button.bottomBD:SetTexture(bgTex)
		button.rightBD:SetTexture(bgTex)
		button.bottomBD:SetHeight(2)
		button.bottomBD:SetVertexColor(0,0,0,1)
		button.bottomBD:SetPoint("TOPLEFT",button.bg,"BOTTOMLEFT",1,0)
		button.bottomBD:SetPoint("TOPRIGHT",button.bg,"BOTTOMRIGHT",1,0)
		button.rightBD:SetVertexColor(0,0,0,1)
		button.rightBD:SetWidth(2)
		button.rightBD:SetPoint("TOPLEFT",button.bg,"TOPRIGHT",0,-1)
		button.rightBD:SetPoint("BOTTOMLEFT",button.bg,"BOTTOMRIGHT",0,-1)
		if i == 1 then
			button:SetPoint("TOPLEFT",mf.memoryUseage,0,-40)
		elseif i > 1 then
			button:SetPoint("TOPLEFT",mf.addonmems[i-1],"BOTTOMLEFT",0,-8)
		end
		mf.addonmems[i] = button
		button:Hide()
	end
end

function GUI:Setting()
	local mf = _G["Wowshell_MainFrame"]
	local sf = _G["Wowshell_MainFrame_ScrollFrame_Parent"]
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	mf.setting = scf:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = mf.setting:GetFont()
		mf.setting:SetFont(cf,26,"OUTLINE")
	end
	mf.setting:Hide()
	mf.setting:SetPoint("TOPLEFT",scf,750,-7000)
	mf.setting:SetText(L["settingTitle"])
	local soundSetting = CreateFrame("Button","Wowshell_Sound",scf)
	local videoSetting = CreateFrame("Button","Wowshell_Video",scf)
	soundSetting:SetSize(24,24)
	soundSetting:SetPoint("TOPLEFT",scf,760,-7050)
	soundSetting.text = soundSetting:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = soundSetting.text:GetFont()
		soundSetting.text:SetFont(cf,18,flag)
	end
	soundSetting.text:SetPoint("LEFT",soundSetting)
	soundSetting.text:SetText(L["AUDIO"])
	videoSetting:SetSize(24,24)
	videoSetting:SetPoint("TOPLEFT",scf,760,-7100)
	videoSetting.text = videoSetting:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = videoSetting.text:GetFont()
		videoSetting.text:SetFont(cf,18,flag)
	end
	videoSetting.text:SetPoint("LEFT",videoSetting)
	videoSetting.text:SetText(L["VIDEO"])

	soundSetting.flag = false
	videoSetting.flag = false
	soundSetting.nextUpdate = 0
	videoSetting.nextUpdate = 0

	local soundMenu = CreateFrame("Frame","Wowshell_SoundMenu",scf) 
	local videoMenu = CreateFrame("Frame","Wowshell_VideoMenu",scf)

	soundMenu:SetSize(550,500)
	soundMenu:SetPoint("TOPLEFT",scf,786,-7050)--soundSetting,"TOPRIGHT",20,0)
	soundMenu.bg = soundMenu:CreateTexture(nil,"OVERLAY")
	soundMenu.bg:SetTexture(bgTex)
	soundMenu.bg:SetAllPoints(soundMenu)
	soundMenu.bg:SetVertexColor(0,0,0,0)

	videoMenu:SetSize(550,500)
	videoMenu:SetPoint("TOPLEFT",scf,786,-7050)--soundSetting,"TOPRIGHT",20,0)
	videoMenu.bg = videoMenu:CreateTexture(nil,"OVERLAY")
	videoMenu.bg:SetTexture(bgTex)
	videoMenu.bg:SetAllPoints(videoMenu)
	videoMenu.bg:SetVertexColor(0,0,0,0)

	GUI:CheckBox("Sound_EnableAllSound",{"TOPLEFT",soundMenu,20,-20},soundMenu)	
	GUI:CheckBox("Sound_EnableErrorSpeech",{"TOPLEFT",soundMenu,20,-40},soundMenu)
	GUI:CheckBox("Sound_EnableEmoteSounds",{"TOPLEFT",soundMenu,20,-60},soundMenu)
	GUI:CheckBox("Sound_EnablePetSounds",{"TOPLEFT",soundMenu,20,-80},soundMenu)
	GUI:CheckBox("Sound_EnableAmbience",{"TOPLEFT",soundMenu,20,-100},soundMenu)
	GUI:CheckBox("Sound_EnableSoundWhenGameIsInBG",{"TOPLEFT",soundMenu,20,-120},soundMenu)
	GUI:CheckBox("Sound_EnableReverb",{"TOPLEFT",soundMenu,20,-140},soundMenu)
	GUI:CheckBox("Sound_EnableSoftwareHRTF",{"TOPLEFT",soundMenu,20,-160},soundMenu)
	GUI:CheckBox("Sound_EnableHardware",{"TOPLEFT",soundMenu,20,-180},soundMenu)
	GUI:CheckBox("Sound_EnableMusic",{"TOPLEFT",soundMenu,20,-200},soundMenu)
	GUI:CheckBox("Sound_ZoneMusicNoDelay",{"TOPLEFT",soundMenu,20,-220},soundMenu)
	GUI:SlideBar("Sound_MasterVolume",{"TOPLEFT",soundMenu,300,-20},soundMenu)
	GUI:SlideBar("Sound_MusicVolume",{"TOPLEFT",soundMenu,300,-60},soundMenu)
	GUI:SlideBar("Sound_SFXVolume",{"TOPLEFT",soundMenu,300,-100},soundMenu)
	GUI:SlideBar("Sound_AmbienceVolume",{"TOPLEFT",soundMenu,300,-140},soundMenu)
	GUI:RadioButton("Sound_OutputQuality",{"LOW","MEDIUM","HIGH"},{"TOPLEFT",soundMenu,300,-180},soundMenu)

	GUI:RadioButton("Texture_Quality",{"LOW","NORMAL","EXCELLENT","HIGH"},{"TOPLEFT",videoMenu,20,-20},videoMenu)
	GUI:RadioButton("textureFilteringMode",{"filter_2L","filter_3L","filter_2X","filter_4X","filter_8X","filter_16X"},{"TOPLEFT",videoMenu,20,-80},videoMenu)
	GUI:RadioButton("Shadow_Quality",{"LOW","NORMAL","EXCELLENT","HIGH","GREAT"},{"TOPLEFT",videoMenu,20,-140},videoMenu)
	GUI:RadioButton("waterDetail",{"LOW","NORMAL","EXCELLENT","GREAT"},{"TOPLEFT",videoMenu,20,-200},videoMenu)
	GUI:RadioButton("SunShafts",{"OFF","LOW","HIGH"},{"TOPLEFT",videoMenu,20,-260},videoMenu)
	GUI:RadioButton("particleDensity",{"LOW","NORMAL","EXCELLENT","HIGH","GREAT"},{"TOPLEFT",videoMenu,20,-320},videoMenu)
	GUI:RadioButton("farClip",{"LOW","NORMAL","EXCELLENT","HIGH","GREAT"},{"TOPLEFT",videoMenu,320,-20},videoMenu)
	GUI:RadioButton("environmentDetail",{"LOW","NORMAL","EXCELLENT","HIGH","GREAT"},{"TOPLEFT",videoMenu,320,-80},videoMenu)
	GUI:RadioButton("groundEffectDist",{"LOW","NORMAL","EXCELLENT","HIGH","GREAT"},{"TOPLEFT",videoMenu,320,-140},videoMenu)
	GUI:RadioButton("projectedTextures",{"OFF","ON"},{"TOPLEFT",videoMenu,320,-200},videoMenu)
	--GUI:RadioButton("gxVSync",{"OFF","ON"},{"TOPLEFT",videoMenu,320,-260},videoMenu)
	
	--soundMenu:Hide()
	videoMenu:Hide()
	soundSetting.text:SetTextColor(1,.5,.25)
	soundSetting:SetScript("OnEnter",function(self)
		self.text:SetTextColor(1,.5,.25)
	end)
	soundSetting:SetScript("OnLeave",function(self)
		if soundMenu:IsShown() then
			self.text:SetTextColor(1,.5,.25)
		else
			self.text:SetTextColor(1,1,1)
		end
	end)
	videoSetting:SetScript("OnEnter",function(self)
		self.text:SetTextColor(1,.5,.25)
	end)
	videoSetting:SetScript("OnLeave",function(self)
		if videoMenu:IsShown() then
			self.text:SetTextColor(1,.5,.25)
		else
			self.text:SetTextColor(1,1,1)
		end
	end)

end

function GUI:CheckBox(name,point,parent) --,getter,setter)
	local button = CreateFrame("Button",name,parent)
	button:SetSize(16,16)
	button:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = -1, bottom = 1,left = 1,right = -1}})
	button:SetBackdropColor(.1,.1,.1,.5)
	button:SetBackdropBorderColor(1,1,1,1)
	button:SetPoint(unpack(point))
	button.check = button:CreateTexture(nil,"OVERLAY")
	button.check:SetTexture(bgTex)
	button.check:SetPoint("TOPLEFT",button,2,-2)
	button.check:SetPoint("BOTTOMRIGHT",button,-2,2)
	button.check:SetVertexColor(1,1,1)
	button.check:Hide()
	button.msg = button:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do
		local font,size,flag = button.msg:GetFont()
		button.msg:SetFont(cf,14,"NORMAL")
	end
	button.msg:SetPoint("LEFT",button,"RIGHT",4,0)
	button.msg:SetText(L[name])
	button:SetScript("OnEnter",function(self)
		self:SetBackdropBorderColor(1,.5,.25)
		self.check:SetVertexColor(1,.5,.25)
	end)
	button:SetScript("OnLeave",function(self)
		self:SetBackdropBorderColor(1,1,1,1)
		self.check:SetVertexColor(1,1,1,1)
	end)
	button:SetScript("OnClick",function(self)
		
	end)
	button:RegisterEvent("PLAYER_LOGIN")
	button:SetScript("OnEvent",function(self,event)
		if event == "PLAYER_LOGIN" then
			if GetCVar(name) == "1" then
				self.check:Show()
			elseif GetCVar(name) == "0" then
				self.check:Hide()
			end
		end
	end)
	button:SetScript("OnClick",function(self)
		if GetCVar(name) == "1" then
			SetCVar(name,"0")
			self.check:Hide()
		elseif GetCVar(name) == "0" then
			SetCVar(name,"1")
			self.check:Show()
		end
	end)
end

function GUI:SlideBar(name,point,parent)
	local btnp = CreateFrame("Frame",name,parent)
	local button = CreateFrame("Button",name.."_Button",btnp)
	btnp:SetSize(200,2)
	btnp:SetPoint(unpack(point))
	btnp.bg = btnp:CreateTexture(nil,"OVERLAY")
	btnp.bg:SetTexture(bgTex)
	btnp.bg:SetAllPoints(btnp)
	btnp.bg:SetVertexColor(.1,.1,.1,1)
	btnp.title = btnp:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do
		local font,size,flag = btnp.title:GetFont()
		btnp.title:SetFont(cf,14,flag)
	end
	btnp.title:SetPoint("BOTTOM",btnp,"TOP",0,8)
	btnp.title:SetText(L[name])

	button:SetSize(14,10)
	button:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1,insets={top = 0, bottom = 0,left = 0,right = 0}})
	button:SetBackdropColor(1,1,1,1)
	button:SetBackdropBorderColor(0,0,0,1)
	button:SetPoint("CENTER",btnp)
	button.overlay = button:CreateTexture(nil,"OVERLAY")
	button.overlay:SetHeight(2)
	button.overlay:SetPoint("LEFT",btnp)
	button.overlay:SetPoint("RIGHT",button,"LEFT")
	button.overlay:SetTexture(bgTex)
	button.overlay:SetVertexColor(1,1,1,1)
	button.nextUpdate = 0
	button:RegisterEvent("PLAYER_LOGIN")
	button:SetScript("OnEvent",function(self,event)
		if event == "PLAYER_LOGIN" then
			local value = GetCVar(name)
			value = btnp:GetWidth() * value
			if value > 186 then
				button:SetPoint("LEFT",btnp,186,0)
			else
				button:SetPoint("LEFT",btnp,value,0)
			end
		end
	end)
	button:SetScript("OnMouseDown",function(self)
		local mdmX = GetCursorPosition()
		local mdsX = select(4,self:GetPoint())
		self:SetScript("OnUpdate",function(self,elapsed)
			self.nextUpdate = self.nextUpdate + elapsed
			if self.nextUpdate > 0.01 then
				local tempX = GetCursorPosition()
				if IsMouseButtonDown(1) then
					if tempX > mdmX then
						local cusX = select(4,self:GetPoint())
						if cusX > 186 then	
							self:SetScript("OnUpdate",nil)
							--self:Disable()	
							SetCVar(name,1)
						else
							local cvar = cusX/btnp:GetWidth()
							SetCVar(name,cvar)
							self:SetPoint("LEFT",btnp,(mdsX + tempX - mdmX),0)
						end
					elseif tempX < mdmX then
						local cusX = select(4,self:GetPoint())
						if cusX < 0 then
							SetCVar(name,0)
							self:SetScript("OnUpdate",nil)
							--self:Disable()
						else
							local cvar = cusX/btnp:GetWidth()
							SetCVar(name,cvar)
							self:SetPoint("LEFT",btnp,(mdsX - (mdmX-tempX)),0)
						end
					end
				elseif not IsMouseButtonDown(1) then
					self:SetScript("OnUpdate",nil)
				end
				self.nextUpdate = 0
			end
		end)
	end)
	button:SetScript("OnMouseUp",function(self)
		self:SetScript("OnUpdate",nil)
	end)
	button:SetScript("OnEnter",function(self)
		self:SetBackdropColor(1,.5,.25)
	end)
	button:SetScript("OnLeave",function(self)
		self:SetBackdropColor(1,1,1,1)
	end)
end

function GUI:RadioButton(name,buttons,point,parent)
	for i = 1, #buttons do
		local v = buttons[i]	
		
		buttons[i] = CreateFrame("Button",name..buttons[i],parent)
		buttons[i]:SetSize(20,10)
		if i == 1 then
			buttons[i]:SetPoint(unpack(point))
			buttons[i].title = buttons[i]:CreateFontString(nil,"OVERLAY","ChatFontNormal")
			do
				local font,size,flag = buttons[i].title:GetFont()
				buttons[i].title:SetFont(cf,14,flag)
			end
			buttons[i].title:SetPoint("BOTTOMLEFT",buttons[i],"TOPLEFT",0,5)
			buttons[i].title:SetText(L[name])
		elseif i > 1 then
			buttons[i]:SetPoint("LEFT",buttons[i-1],"RIGHT",20,0)
		end

		buttons[i]:SetBackdrop({bgFile = bgTex,edgeFile = bgTex, edgeSize = 1.05,insets={top = -1, bottom = 1,left = 1,right = -1}})
		buttons[i]:SetBackdropColor(.1,.1,.1,.5)
		buttons[i]:SetBackdropBorderColor(1,1,1,1)
		
		buttons[i].check = buttons[i]:CreateTexture(nil,"OVERLAY")
		buttons[i].check:SetTexture(bgTex)
		buttons[i].check:SetPoint("TOPLEFT",buttons[i],2,-2)
		buttons[i].check:SetPoint("BOTTOMRIGHT",buttons[i],-2,2)
		buttons[i].check:SetVertexColor(1,1,1,1)
		buttons[i].check:Hide()	
		buttons[i].value = buttons[i]:CreateFontString(nil,"OVERLAY","ChatFontNormal")
		do 
			local font,size,flag = buttons[i].value:GetFont()
			buttons[i].value:SetFont(cf,14,flag)
		end
		buttons[i].value:SetText(L[v])
		buttons[i].value:SetPoint("TOP",buttons[i],"BOTTOM",0,-6)
		buttons[i]:RegisterEvent("PLAYER_LOGIN")
		buttons[i]:SetScript("OnEvent",function(self,event)
			if name == "Texture_Quality" then
				if GetCVar("baseMip") == "1" then
					buttons[1].check:Show()	
				elseif GetCVar("baseMip") == "0" then
					buttons[1].check:Hide()
					if GetCVar("terrainMipLevel") == "1" then
						buttons[2].check:Show()
					elseif GetCVar("terrainMipLevel") == "0" then
						buttons[2].check:Hide()
						if GetCVar("componentTextureLevel") == "8" then
							buttons[3].check:Show()
						elseif GetCVar("componentTextureLevel") == "9" then
							buttons[3].check:Hide()
							buttons[4].check:Show()
						end
					end
				end
			elseif name == "Shadow_Quality" then
				if GetCVar("shadowMode") == "0" then
					buttons[1].check:Show()
				elseif GetCVar("shadowMode") == "1" then
					if GetCVar("shadowTextureSize") == "1024" then
						buttons[2].check:Show()
						buttons[3].check:Hide()
					elseif GetCVar("shadowTextureSize") == "2048" then
						buttons[2].check:Hide()
						buttons[3].check:Show()
					end
				elseif GetCVar("shadowMode") == "2" then
					buttons[4].check:Show()
				elseif GetCVar("shadowMode") == "3" then
					buttons[5].check:Show()	
				end
			elseif name == "particleDensity" then 
				if GetCVar("particleDensity") == "10" then
					buttons[1].check:Show()
				elseif GetCVar("particleDensity") == "40" then
					buttons[2].check:Show()
				elseif GetCVar("particleDensity") == "60" then
					buttons[3].check:Show()
				elseif GetCVar("particleDensity") == "80" then
					buttons[4].check:Show()
				elseif GetCVar("particleDensity") == "100" then
					buttons[5].check:Show()
				end
			elseif name == "farClip" then
				if GetCVar("farClip") == "185" then
					buttons[1].check:Show()
				elseif GetCVar("farClip") == "507" then
					buttons[2].check:Show()
				elseif GetCVar("farClip") == "727" then
					buttons[3].check:Show()
				elseif GetCVar("farClip") == "1057" then
					buttons[4].check:Show()
				elseif GetCVar("farClip") == "1250" then
					buttons[5].check:Show()
				end
			elseif name == "environmentDetail" then
				if GetCVar("environmentDetail") == "50" then
					buttons[1].check:Show()
				elseif GetCVar("environmentDetail") == "75" then
					buttons[2].check:Show()
				elseif GetCVar("environmentDetail") == "100" then
					buttons[3].check:Show()
				elseif GetCVar("environmentDetail") == "125" then
					buttons[4].check:Show()
				elseif GetCVar("environmentDetail") == "150" then
					buttons[5].check:Show()
				end
			elseif name == "groundEffectDist" then
				if GetCVar("groundEffectDist") == "70" then
					buttons[1].check:Show()
				elseif GetCVar("groundEffectDist") == "110" then
					buttons[2].check:Show()
				elseif GetCVar("groundEffectDist") == "160" then
					buttons[3].check:Show()
				elseif GetCVar("groundEffectDist") == "200" then
					buttons[4].check:Show()
				elseif GetCVar("groundEffectDist") == "260" then
					buttons[5].check:Show()
				end
			else
				if GetCVar(name) == tostring(i-1) then
					buttons[i].check:Show()
				else
					buttons[i].check:Hide()
				end
			end
		end)
		buttons[i]:SetScript("OnClick",function(self)
			self.check:Show()
			if name == "Texture_Quality" then
				if i == 1 then
					SetCVar("baseMip",1)
					SetCVar("terrainMipLevel",1)
					SetCVar("componentTextureLevel",8)
				elseif i == 2 then
					SetCVar("baseMip",0)
					SetCVar("terrainMipLevel",1)
					SetCVar("componentTextureLevel",8)
				elseif i == 3 then
					SetCVar("baseMip",0)
					SetCVar("terrainMipLevel",0)
					SetCVar("componentTextureLevel",8)
				elseif i == 4 then
					SetCVar("baseMip",0)
					SetCVar("terrainMipLevel",0)
					SetCVar("componentTextureLevel",9)
				end
			elseif name == "Shadow_Quality" then
				if i == 1 then
					SetCVar("shadowMode",0)
					SetCVar("shadowTextureSize",1024)
				elseif i == 2 then
					SetCVar("shadowMode",1)
					SetCVar("shadowTextureSize",1024)
				elseif i == 3 then
					SetCVar("shadowMode",1)
					SetCVar("shadowTextureSize",2048)
				elseif i == 4 then
					SetCVar("shadowMode",2)
					SetCVar("shadowTextureSize",2048)
				elseif i == 5 then
					SetCVar("shadowMode",3)
					SetCVar("shadowTextureSize",2048)
				end
			elseif name == "waterDetail" then
				if i == 1 then
					SetCVar("waterDetail",0)
					SetCVar("rippleDetail",1)
				elseif i == 2 then 
					SetCVar("waterDetail",1)
					SetCVar("rippleDetail",1)
				elseif i == 3 then
					SetCVar("waterDetail",2)
					SetCVar("rippleDetail",1)
				elseif i == 4 then
					SetCVar("waterDetail",3)
					SetCVar("rippleDetail",2)
				end
			elseif name == "particleDensity" then
				if i == 1 then 
					SetCVar("particleDensity",10)
				elseif i == 2 then
					SetCVar("particleDensity",40)
				elseif i == 3 then
					SetCVar("particleDensity",60)
				elseif i == 4 then
					SetCVar("particleDensity",80)
				elseif i == 5 then
					SetCVar("particleDensity",100)
				end
			elseif name == "farClip" then
				if i == 1 then
					SetCVar("farClip",185)
				elseif i == 2 then
					SetCVar("farClip",507)
				elseif i == 3 then
					SetCVar("farClip",727)
				elseif i == 4 then
					SetCVar("farClip",1057)
				elseif i == 5 then
					SetCVar("farClip",1250)
				end
			elseif name == "environmentDetail" then
				if i == 1 then
					SetCVar("environmentDetail",50)
				elseif i == 2 then
					SetCVar("environmentDetail",75)
				elseif i == 2 then
					SetCVar("environmentDetail",100)
				elseif i == 2 then
					SetCVar("environmentDetail",125)
				elseif i == 2 then
					SetCVar("environmentDetail",150)
				end
			elseif name == "groundEffectDist" then
				if i == 1 then 
					SetCVar("groundEffectDist",70)
					SetCVar("groundEffectDensity",16)
				elseif i == 2 then
					SetCVar("groundEffectDist",110)
					SetCVar("groundEffectDensity",40)
				elseif i == 3 then
					SetCVar("groundEffectDist",160)
					SetCVar("groundEffectDensity",64)
				elseif i == 4 then
					SetCVar("groundEffectDist",200)
					SetCVar("groundEffectDensity",96)
				elseif i == 5 then
					SetCVar("groundEffectDist",260)
					SetCVar("groundEffectDensity",128)
				end

			else
				SetCVar(name,tostring(i-1))
			end
			for j =1, #buttons do
				if j ~= i then
					buttons[j].check:Hide()
				end
			end
		end)
		buttons[i]:SetScript("OnEnter",function(self)
			self:SetBackdropBorderColor(1,.5,.25)
			self.check:SetVertexColor(1,.5,.25)
		end)
		buttons[i]:SetScript("OnLeave",function(self)
			self:SetBackdropBorderColor(1,1,1,1)
			self.check:SetVertexColor(1,1,1,1)
		end)
	end
end

function GUI:GraphicWarning()
	local scf = _G["Wowshell_MainFrame_ScrollFrame"]
	local warning = CreateFrame("Frame","GraphicWarning",scf)
	warning:SetSize(300,50)
	warning:SetPoint("TOPLEFT",scf,800,-7420)
	warning.icon = warning:CreateTexture(nil,"OVERLAY")
	warning.icon:SetSize(64,64)
	warning.icon:SetTexture(tex.."warning.tga")
	warning.icon:SetPoint("LEFT",warning,10,0)
	warning.icon:SetVertexColor(1,0,.25)
	warning.text = warning:CreateFontString(nil,"OVERLAY","ChatFontNormal")
	do 
		local font,size,flag = warning.text:GetFont()
		warning.text:SetFont(cf,16,flag)
	end
	warning.text:SetPoint("LEFT",warning.icon,"RIGHT",10,0)
	warning.text:SetShadowOffset(1,-1)
	warning.text:SetShadowColor(0,0,0)
	warning.text:SetText(L["WARNING"])
	warning.text:SetTextColor(1,0,.25)
end


function GUI:ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select('#', ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select('#', ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end



ns.GUI = GUI
