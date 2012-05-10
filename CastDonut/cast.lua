-- The castbar code is an adapation of Haste's oUF CastBar element and used with permission

-- CONFIG

local RADIUS = 50
local THICKNESS = 5

local GCD_RADIUS = 40
local GCD_THICKNESS = 2

local ALPHA = 1
local GCD_ALPHA = 1

-- castbar color
local R, G, B = 1, .7, 0
local GCD_R, GCD_G, GCD_B = .7, 1, 0
-- timetext base color
local tR, tG, tB = 1, 1, 1

local SCALE = 1
local GCD_SCALE = 1

-- END CONFIG

local donut = LibStub("LibDonut-1.0")

local GetTime = GetTime
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo

local c = donut:New(RADIUS, (RADIUS-THICKNESS)/RADIUS, "Interface\\AddOns\\CastDonut\\media\\Ring4", "Interface\\AddOns\\CastDonut\\media\\Slice2")

local gcd = donut:New( GCD_RADIUS, (GCD_RADIUS-GCD_THICKNESS)/RADIUS, "Interface\\AddOns\\CastDonut\\media\\Ring4", "Interface\\AddOns\\CastDonut\\media\\Slice2" )
gcd.unit = "player"
gcd:SetFrameStrata("TOOLTIP")
gcd:SetAlpha(GCD_ALPHA)
gcd:SetScale(GCD_SCALE)
gcd:CallTextureMethod("SetVertexColor", GCD_R, GCD_G, GCD_B )


c.Time = c:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
c.Time:SetShadowColor(0,0,0)
c.Time:SetShadowOffset(0.8, -0.8)
c.Time:SetTextColor(tR,tG,tB)
c.Time:SetJustifyH("CENTER")
c.Time:SetPoint("BOTTOM", c, "TOP")

c.unit = "player"
c:SetFrameStrata("TOOLTIP")
c:SetAlpha(ALPHA)
c:SetScale(SCALE)
c:CallTextureMethod("SetVertexColor", R, G, B )

function c:SetTimeText( duration )
	local tformat = "%.1f"
	if self.delay ~= 0 then
		tformat = "%.1f|cffff0000-%.1f|r"
	end
	if self.casting then
		self.Time:SetFormattedText(tformat, self.max - duration, self.delay)
	elseif self.channeling then
		self.Time:SetFormattedText(tformat, duration, self.delay)
	end
end

function gcd:UNIT_SPELLCAST_START(event, unit, spell, spellrank)
	if self.unit ~= unit then return end
	local startTime, duration = GetSpellCooldown(spell)
	if duration and duration > 0 and duration <= 1.5 then
		self.max = duration
		self.duration = 0
		self:SetAngle(0)
		self:Show()
	end
end


gcd.UNIT_SPELLCAST_SUCCEEDED = gcd.UNIT_SPELLCAST_START

function c:UNIT_SPELLCAST_START(event, unit, spell, spellrank)
	if self.unit ~= unit then return end

	local name, rank, text, texture, startTime, endTime, _, castid = UnitCastingInfo(unit)
	if not name then
		c:Hide()
		return
	end
	if self.Time then self.Time:SetText() end

	endTime = endTime / 1e3
	startTime = startTime / 1e3
	local max = endTime - startTime

	self.castid = castid
	self.duration = GetTime() - startTime
	self.max = max
	self.delay = 0
	self.casting = true

	self:SetAngle(0)

	self:Show()
end

function c:UNIT_SPELLCAST_FAILED(event, unit, spellname, spellrank, castid)
	if(self.unit ~= unit) then return end

	if(self.castid ~= castid) then
		return
	end

	self.casting = nil
	self.channeling = nil
	self:SetAngle(0)
	self:Hide()
end
c.UNIT_SPELLCAST_INTERRUPTED = UNIT_SPELLCAST_FAILED
c.UNITSPELLCAST_CHANNEL_INTERRUPTED = UNIT_SPELLCAST_FAILED

function c:UNIT_SPELLCAST_DELAYED(event, unit, spellname, spellrank)
	if(self.unit ~= unit) then return end

	local name, rank, text, texture, startTime, endTime = UnitCastingInfo(unit)
	if(not startTime) then return end

	local duration = GetTime() - (startTime / 1000)
	if(duration < 0) then duration = 0 end

	self.delay = self.delay + self.duration - duration
	self.duration = duration

	self:SetAngle( 360 * duration/self.max )
end

function c:UNIT_SPELLCAST_STOP(event, unit, spellname, spellrank, castid)
	if(self.unit ~= unit) then return end

	if(self.castid ~= castid) then
		return
	end

	self.casting = nil
	self:SetAngle(0)
	
	self:Hide()
end

function c:UNIT_SPELLCAST_CHANNEL_START(event, unit, spellname, spellrank)
	if(self.unit ~= unit) then return end

	local name, rank, text, texture, startTime, endTime = UnitChannelInfo(unit)
	if(not name) then
		return
	end

	if self.Time then self.Time:SetText() end
	
	endTime = endTime / 1e3
	startTime = startTime / 1e3
	local max = (endTime - startTime)
	local duration = endTime - GetTime()

	self.duration = duration
	self.max = max
	self.delay = 0
	self.channeling = true

	self:SetAngle( 360 * duration/max )

	self:Show()
end

function c:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit, spellname, spellrank)
	if(self.unit ~= unit) then return end

	local name, rank, text, texture, startTime, endTime, oldStart = UnitChannelInfo(unit)
	if(not name) then
		return
	end

	local duration = (endTime / 1000) - GetTime()

	self.delay = self.delay + self.duration - duration
	self.duration = duration
	self.max = (endTime - startTime) / 1000

	self:SetAngle( 360 * duration/self.max)
end

function c:UNIT_SPELLCAST_CHANNEL_STOP(event, unit, spellname, spellrank)
	if(self.unit ~= unit) then return end

	if(self:IsShown()) then
		self.channeling = nil
		self:SetAngle( 0 )
		self:Hide()
	end
end

local onUpdate = function(self, elapsed)
	-- track the damn mouse
	local scale = UIParent:GetEffectiveScale()
	local framescale = self:GetScale()
	local x, y = GetCursorPosition()
	x = x / framescale / scale
	y = y / framescale / scale
	self:ClearAllPoints()
	self:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", x , y )
	
	if self.casting then
		local duration = self.duration + elapsed
		if (duration >= self.max) then
			self.casting = nil
			self:Hide()
			return
		end

		if self.Time then
			self:SetTimeText(duration)
		end

		self.duration = duration
		self:SetAngle( 360 * duration/ self.max)

	elseif self.channeling then
		local duration = self.duration - elapsed

		if(duration <= 0) then
		self.channeling = nil
			self:Hide()
			return
		end

		if self.Time then
			self:SetTimeText(duration)
		end
	
		self.duration = duration
		self:SetAngle( 360 * duration/self.max )
	else
		self.unitName = nil
		self.channeling = nil
		self:SetAngle(0)
		self:Hide()
	end
end

local function gcd_onUpdate( self, elapsed )
	-- track the damn mouse
	local scale = UIParent:GetEffectiveScale()
	local framescale = self:GetScale()
	local x, y = GetCursorPosition()
	x = x / framescale / scale
	y = y / framescale / scale
	self:ClearAllPoints()
	self:SetPoint( "CENTER", UIParent, "BOTTOMLEFT", x , y )
	
	local duration = self.duration + elapsed
	if (duration >= self.max) then
		self:Hide()
		return
	end

	self.duration = duration
	self:SetAngle( 360 * duration/ self.max)
end

c:SetScript("OnUpdate", onUpdate)
gcd:SetScript("OnUpdate", gcd_onUpdate)

c:SetScript("OnEvent", function( self, event, ... )
	self[event](self, event, ...)
end )

gcd:SetScript("OnEvent", function( self, event, ... )
	self[event](self, event, ...)
end )

gcd:RegisterEvent("UNIT_SPELLCAST_START")
gcd:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

c:RegisterEvent("UNIT_SPELLCAST_START")
c:RegisterEvent("UNIT_SPELLCAST_FAILED")
c:RegisterEvent("UNIT_SPELLCAST_DELAYED")
c:RegisterEvent("UNIT_SPELLCAST_STOP")
c:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
c:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
c:RegisterEvent("UNIT_SPELLCAST_CHANNEL_INTERRUPTED")
c:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")


