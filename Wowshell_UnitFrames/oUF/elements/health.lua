local parent, ns = ...
local oUF = ns.oUF
local Health = {};
WSUF:RegisterModule(Health, "healthbar", "Health Bar");

oUF.colors.health = {49/255, 207/255, 37/255}

function Health:Update(frame, event, unit, powerType)
	if(frame.unit ~= unit) then return end
	local health = frame.Health

	if(health.PreUpdate) then health:PreUpdate(unit) end

	local min, max = UnitHealth(unit), UnitHealthMax(unit)
	local disconnected = not UnitIsConnected(unit)
	health:SetMinMaxValues(0, max)

	if(disconnected) then
		health:SetValue(max)
	else
		health:SetValue(min)
	end

	health.disconnected = disconnected

	local r, g, b, t
	if(health.colorTapping and UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
		t = frame.colors.tapped
	elseif(health.colorDisconnected and not UnitIsConnected(unit)) then
		t = frame.colors.disconnected
	elseif(health.colorClass and UnitIsPlayer(unit)) or
		(health.colorClassNPC and not UnitIsPlayer(unit)) or
		(health.colorClassPet and UnitPlayerControlled(unit) and not UnitIsPlayer(unit)) then
		local _, class = UnitClass(unit)
		t = frame.colors.class[class]
	elseif(health.colorReaction and UnitReaction(unit, 'player')) then
		t = frame.colors.reaction[UnitReaction(unit, "player")]
	elseif(health.colorSmooth) then
		r, g, b = frame.ColorGradient(min / max, unpack(health.smoothGradient or frame.colors.smooth))
	elseif(health.colorHealth) then
		t = frame.colors.health
	end

	if(t) then
		r, g, b = t[1], t[2], t[3]
	end

	if(b) then
		health:SetStatusBarColor(r, g, b)
		local bg = health.bg
		if(bg) then local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu)
		end
	end

	if(health.PostUpdate) then
		return health:PostUpdate(unit, min, max)
	end
end

local Update = function(frame, event, unit, powerType)
	Health:Update(frame, event, unit, powerType);
end

local Path = function(frame, ...)
	return (frame.Health.Override or Update) (frame, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local Enable = function(frame, unit)
	local health = frame.Health
	if(health) then
		health.__owner = frame
		health.ForceUpdate = ForceUpdate

		if(health.frequentUpdates) then
			frame:RegisterEvent('UNIT_HEALTH_FREQUENT', Path)
		else
			frame:RegisterEvent('UNIT_HEALTH', Path)
		end

		frame:RegisterEvent("UNIT_MAXHEALTH", Path)
		frame:RegisterEvent('UNIT_CONNECTION', Path)

		-- For tapping.
		frame:RegisterEvent('UNIT_FACTION', Path)

		if(not health:GetStatusBarTexture()) then
			health:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
		end

		return true
	end
end

local Disable = function(frame)
	local health = frame.Health
	if(health) then
		frame:UnregisterEvent('UNIT_HEALTH_FREQUENT', Path)
		frame:UnregisterEvent('UNIT_HEALTH', Path)
		frame:UnregisterEvent('UNIT_MAXHEALTH', Path)
		frame:UnregisterEvent('UNIT_CONNECTION', Path)
		frame:UnregisterEvent('UNIT_POWER', Path)

		frame:UnregisterEvent('UNIT_FACTION', Path)
	end
end

oUF:AddElement('Health', Path, Enable, Disable)
