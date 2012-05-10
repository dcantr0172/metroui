local VUHDO_SHIELDS = {
	[VUHDO_SPELL_ID.POWERWORD_SHIELD] = 15,
	[VUHDO_SPELL_ID.DIVINE_AEGIS] = 15,
	[VUHDO_SPELL_ID.ILLUMINATED_HEALING] = 5,
	[VUHDO_SPELL_ID.ICE_BARRIER] = 60, -- Ice Barrier
	[VUHDO_SPELL_ID.MANA_SHIELD] = 60, -- Mana Shield
	[VUHDO_SPELL_ID.SACRIFICE] = 30, -- Sacrifice
	[VUHDO_SPELL_ID.SACRED_SHIELD] = 15, -- Sacred Shield
	[VUHDO_SPELL_ID.SAVAGE_DEFENSE] = 10 -- Savage Defense
};

local sMissedEvents = {
	["SWING_MISSED"] = true,
	["RANGE_MISSED"] = true,
	["SPELL_MISSED"] = true,
	["SPELL_PERIODIC_MISSED"] = true,
	["ENVIRONMENTAL_MISSED"] = true
};

local VUHDO_SHIELD_LEFT = { };
local VUHDO_SHIELD_SIZE = { };
local VUHDO_SHIELD_EXPIRY = { };
local sEmpty = { };


--
local pairs = pairs;
local ceil = ceil;
local GetTime = GetTime;
local select = select;
local UnitAura = UnitAura;



--
local VUHDO_PLAYER_GUID = -1;
local sIsPumpAegis = false;
function VUHDO_shieldAbsorbInitBurst()
	VUHDO_PLAYER_GUID = UnitGUID("player");
	sIsPumpAegis = VUHDO_PANEL_SETUP["BAR_COLORS"]["HOTS"]["isPumpDivineAegis"];
end


--
local function VUHDO_initShieldValue(aUnit, aShieldName, anAmount, aDuration)
	if ((anAmount or 0) == 0) then
		--VUHDO_xMsg("ERROR: Failed to init shield " .. aShieldName .. " on " .. aUnit, anAmount);
		return;
	end

	if (VUHDO_SHIELD_LEFT[aUnit] == nil) then
		VUHDO_SHIELD_LEFT[aUnit], VUHDO_SHIELD_SIZE[aUnit], VUHDO_SHIELD_EXPIRY[aUnit] = {}, {}, {};
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;

	if (sIsPumpAegis and VUHDO_SPELL_ID.DIVINE_AEGIS == aShieldName) then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = VUHDO_RAID["player"]["healthmax"] * 0.4;
	else
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end
	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
	--VUHDO_xMsg("Init shield " .. aShieldName .. " on " .. aUnit .. " for " .. anAmount);
end



--
local function VUHDO_updateShieldValue(aUnit, aShieldName, anAmount, aDuration)
	if ((VUHDO_SHIELD_SIZE[aUnit] or sEmpty)[aShieldName] == nil) then
		return;
	end

	if (VUHDO_SHIELD_LEFT[aUnit][aShieldName] <= anAmount) then
		VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = GetTime() + aDuration;
		--VUHDO_Msg("Shield overwritten");
	end

	if (VUHDO_SHIELD_SIZE[aUnit][aShieldName] < anAmount) then
		VUHDO_SHIELD_SIZE[aUnit][aShieldName] = anAmount;
	end

	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = anAmount;
	--VUHDO_Msg("Updated shield " .. aShieldName .. " on " .. aUnit .. " to " .. anAmount);
end



--
local function VUHDO_removeShield(aUnit, aShieldName)
	if ((VUHDO_SHIELD_SIZE[aUnit] or sEmpty)[aShieldName] == nil) then
		return;
	end

	VUHDO_SHIELD_SIZE[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_LEFT[aUnit][aShieldName] = nil;
	VUHDO_SHIELD_EXPIRY[aUnit][aShieldName] = nil;
	--VUHDO_Msg("Removed shield " .. aShieldName .. " from " .. aUnit);
end



--
local tNow;
local tUnit, tAllShields;
local tShieldName, tExpiry;
function VUHDO_removeObsoleteShields()
	tNow = GetTime();
	for tUnit, tAllShields in pairs(VUHDO_SHIELD_EXPIRY) do
		for tShieldName, tExpiry in pairs(tAllShields) do
			if (tExpiry < tNow) then
				VUHDO_removeShield(tUnit, tShieldName);
			end
		end
	end
end



--
local tInit, tValue;
function VUHDO_getShieldLeftCount(aUnit, aShield)
	tInit = (VUHDO_SHIELD_SIZE[aUnit] or sEmpty)[aShield] or 0;

	if (tInit > 0) then
		tValue = ceil(4 * ((VUHDO_SHIELD_LEFT[aUnit] or sEmpty)[aShield] or 0) / tInit);
		return tValue > 4 and 4 or tValue;
	else
		return 0;
	end
end



--
local tRemain;
local tShieldName;
local function VUHDO_updateShields(aUnit)
	for tShieldName, _ in pairs(VUHDO_SHIELD_SIZE[aUnit] or sEmpty) do
		tRemain = select(14, UnitAura(aUnit, tShieldName));

		if (tRemain ~= nil) then
			if (tRemain > 0) then
				VUHDO_updateShieldValue(aUnit, tShieldName, tRemain, VUHDO_SHIELDS[tShieldName]);
			else
				VUHDO_removeShield(aUnit, tShieldName);
			end
		end
	end
end



--
local tUnit;
function VUHDO_parseCombatLogShieldAbsorb(aMessage, aSrcGuid, aDstGuid, aShieldName, anAmount)
	tUnit = VUHDO_RAID_GUIDS[aDstGuid];
	if (tUnit == nil) then
		return;
	end

	if (sMissedEvents[aMessage]) then
		VUHDO_updateShields(tUnit);
		return;
	end

	if (VUHDO_PLAYER_GUID ~= aSrcGuid or VUHDO_SHIELDS[aShieldName] == nil) then
		return;
	end

	if ("SPELL_AURA_REFRESH" == aMessage) then
		VUHDO_updateShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aShieldName]);
	elseif ("SPELL_AURA_APPLIED" == aMessage) then
		VUHDO_initShieldValue(tUnit, aShieldName, anAmount, VUHDO_SHIELDS[aShieldName]);
	elseif ("SPELL_AURA_REMOVED" == aMessage
		or "SPELL_AURA_BROKEN" == aMessage
		or "SPELL_AURA_BROKEN_SPELL" == aMessage) then
		VUHDO_removeShield(tUnit, aShieldName);
	end
end
