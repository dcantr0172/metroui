--susnow
local addon,ns = ...
local sound = "Interface\\AddOns\\AutoLFG\\sounds\\"
local bgSound = sound.."bg2.ogg"
local countSound = sound.."count.ogg"
local enterySound = sound.."enter.ogg"
local leaveSound = sound.."leave.ogg"
local bar = "Interface\\AddOns\\AutoLFG\\textures\\bar.tga"
local bd = "Interface\\Buttons\\WHITE8x8"
local backdrop = {edgeFile = bd,bgFile = bd, edgeSize = 1}

local AutoLFG = LibStub("AceAddon-3.0"):NewAddon("AutoLFG","AceEvent-3.0","AceConsole-3.0")
ALFG = AutoLFG
local L = wsLocale:GetLocale("AutoLFG")
local defaults = {
	profile = {
		enable = true,
		igonoreOld = false,
		igonoreCountDown = 5,
	},
}

function ALFG:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("AutoLFG", defaults, UnitName("player").." - "..GetRealmName())
	db = self.db.profile
	self.options = {
		type = "group",
		name = L["AutoLFG"],
		desc = L["AutoLFG"],
		args = {
		--	enable = {
		--		type = "toggle",
		--		name = L["Enable"],
		--		desc = L["Enable AutoLFG"],
		--		order = 1,
		--		width = "full",
		--		get = function() return self.db.profile.enable end,
		--		set = function(_,v)
		--			self.db.profile.enable = v
		--			if v then
		--				self:OnEnable()
		--			else
		--				self:OnDisable()
		--			end
		--		end,
		--	},
			igonoreOld = {
				type = "toggle",
				name = L["Igonore old dungeon"],
				desc = L["Toggle if you won't enter the old dungeon when bosses remainder is not max"],
				order = 2,
				width = "full",
				get = function() return self.db.profile.igonoreOld end,
				set = function(_,v)
					self.db.profile.igonoreOld = v
				end,
			},
		--	ignoreCountDown = {
		--		type = "range",
		--		name = L["Countdown of ignore"],
		--		desc = L["Auto leave dungeon queue by seconds that you setted"],
		--		min = 5, max = 30,
		--		get = function() return self.db.profile.igonoreCountDown end,
		--		set = function(_,v)
		--			self.db.profile.igonoreCountDown = v
		--		end
		--	},
		},
	}
end

ALFG.enter = CreateFrame("Frame")
ALFG.leave = CreateFrame("Frame")
ALFG.enter.nextUpdate = 0
ALFG.leave.nextUpdate = 0
LFGDungeonReadyDialog.nextUpdate = 0
ALFG.durationBG = CreateFrame("Frame",nil,LFGDungeonReadyDialog)
ALFG.durationBar = CreateFrame("StatusBar",nil,ALFG.durationBG)
ALFG.durationBar.Border = CreateFrame("Frame",nil,ALFG.durationBar)
ALFG.durationTime	= ALFG.durationBar:CreateFontString(nil,"OVERLAY")

local PostUpdate = function(obj,duration,func)
	local oldTime = GetTime()
	local interval = 1
	obj:SetScript("OnUpdate",function(self,elapsed)
		obj.nextUpdate = obj.nextUpdate + elapsed
		if obj.nextUpdate > interval then
			local newTime = GetTime()
			PlayMusic(bgSound)
			if (newTime - oldTime) < duration then
				PlaySoundFile(countSound,"Master")
			else
				do func() end
				StopMusic()
			end
			obj.nextUpdate = 0 
		end
	end)
end

local leaveLFG = function(duration,name,curKilled,maxKilled)
	--local leaveFunc = function()
		LFGDungeonReadyDialogLeaveQueueButton:Click()
		print(string.format(L["|cffffff00AutoLFG:Auto leave the queue(%s:%d/%d Bosses defeated)|r"],name,curKilled,maxKilled))
		--PlaySoundFile(leaveSound,"Master")
	--end
	--PostUpdate(ALFG.leave,duration,leaveFunc())
end


local enterLFG = function(duration)
	local enterFunc = function()	
		LFGDungeonReadyDialogEnterDungeonButton:Click() -- 无法执行
		PlaySoundFile(enterySound,"Master")
	end
	PostUpdate(ALFG.enter,duration,enterFunc())
end

local barWidget = function()
	ALFG.durationBG:SetSize(LFGDungeonReadyDialog:GetWidth()*0.75,4)
	ALFG.durationBG:SetPoint("BOTTOM",LFGDungeonReadyDialog,0,16)
	ALFG.durationBar:SetStatusBarTexture(bar)
	ALFG.durationBar:SetPoint("TOPLEFT",ALFG.durationBG)
	ALFG.durationBar:SetPoint("BOTTOMRIGHT",ALFG.durationBG)
	ALFG.durationBar:SetFrameLevel(LFGDungeonReadyDialog:GetFrameLevel()+1)
	ALFG.durationBar:SetStatusBarColor(1,.7,0,1)
	ALFG.durationBar.Border:SetBackdrop(backdrop)
	ALFG.durationBar.Border:SetBackdropColor(0,0,0,0)
	ALFG.durationBar.Border:SetBackdropBorderColor(0,0,0,1)
	ALFG.durationBar.Border:SetPoint("TOPLEFT",ALFG.durationBG,-1,1)
	ALFG.durationBar.Border:SetPoint("BOTTOMRIGHT",ALFG.durationBG,1,-1)
	ALFG.durationTime:SetFontObject(GameFontNormalLarge)
	do local f,s,g =  ALFG.durationTime:GetFont()
		ALFG.durationTime:SetFont(f,12,g)
		ALFG.durationTime:SetText("")
		ALFG.durationTime:SetPoint("RIGHT",LFGDungeonReadyDialogLeaveQueueButton,-8,0)
	end
end

local PostUpdateDurationBar = function()
	local obj =	LFGDungeonReadyDialog	
	local oldTime = GetTime()
	local flag = 0
	local duration = 40 
	local interval = 0.1 
	obj:SetScript("OnUpdate",function(self,elapsed)
		obj.nextUpdate = obj.nextUpdate + elapsed
		if obj.nextUpdate > interval then
			local newTime = GetTime()
			if (newTime - oldTime) < duration then
				local width = ALFG.durationBG:GetWidth() * (newTime - oldTime)/duration
				ALFG.durationBar:SetPoint("BOTTOMRIGHT",ALFG.durationBG,0-width,0)
				ALFG.durationTime:SetText(string.format("%d",(duration - (newTime - oldTime))))		
				flag = flag + 1
				if flag == 10 then
					PlaySoundFile(countSound,"Master")
					flag = 0
				end
			else
				obj:SetScript("OnUpdate",nil)
			end
			obj.nextUpdate = 0
		end
	end)
end

function ALFG:OnEnable()
	self:RegisterEvent("LFG_PROPOSAL_SHOW")
	--self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	barWidget()	
	end

function ALFG:OnDisable()
	self:UnregisterAllEvents()
end

function ALFG:LFG_PROPOSAL_SHOW(event)
	if LFGDungeonReadyDialog:IsShown() then
		PostUpdateDurationBar()
		local killedInfo = LFGDungeonReadyDialogInstanceInfoFrame.statusText:GetText()
		local nameInfo = LFGDungeonReadyDialogInstanceInfoFrame.name:GetText()	
		local curKilled = 0
		local maxKilled = 0
		if killedInfo then 
			local i,j = string.find(killedInfo,"%/")
			curKilled = string.sub(killedInfo,i-1,j-1)
			maxKilled = string.sub(killedInfo,i+1,i+1)
			if tonumber(curKilled) > 0 and self.db.profile.igonoreOld then
				leaveLFG(self.db.profile.igonoreCountDown,nameInfo,curKilled,maxKilled)
			else
				--enterLFG()
			end
		else
			--enterLFG()
		end
	end
end





