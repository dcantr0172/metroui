
local is40100 = select(4,GetBuildInfo()) == 40100

EA_Config = { DoAlertSound, AlertSound, AlertSoundValue, LockFrame, ShowFrame, ShowName, ShowFlash, ShowTimer, TimerFontSize, StackFontSize, SNameFontSize, ChangeTimer, Version, AllowESC, AllowAltAlerts, Target_MyDebuff };
EA_Position = { Anchor, relativePoint, xLoc, yLoc, xOffset, yOffset, RedDebuff, GreenDebuff, Tar_NewLine, TarAnchor, TarrelativePoint, Tar_xOffset, Tar_yOffset, ScdAnchor, Scd_xOffset, Scd_yOffset, Execution, PlayerLv2BOSS };
EA_SpecFlag = { HolyPower, RunicPower, SoulShards, Eclipse, ComboPoint, Lifebloom };

EA_Pos = { };

EA_SPELLINFO_SELF = { };
EA_SPELLINFO_TARGET = { };
EA_SPELLINFO_SCD = { };
EA_ClassAltSpellName = { };

local EA_DEBUGFLAG1 = false;
local EA_DEBUGFLAG2 = false;
local EA_DEBUGFLAG3 = false;
local EA_DEBUGFLAG11 = false;
local EA_DEBUGFLAG21 = false;
local EA_LISTSEC_SELF = 0;
local EA_LISTSEC_TARGET = 0;
local EA_SPEC_expirationTime1 = 0;
local EA_SPEC_expirationTime2 = 0;

local EA_CurrentBuffs = { };
local EA_TarCurrentBuffs = { };
local EA_ScdCurrentBuffs = { };
local EA_ShowScrollSpells = { };
local EA_ShowScrollSpell_YPos = 25;

local EA_SpecFrame_Self = false;
local EA_SpecFrame_Target = false;
local EA_SpecFrame_Lifebloom = { UnitID = "", UnitName = "", ExpireTime = 0, Stack = 0 };


-- local EA_SpecFlag_ComboPoint = true; -- Rogue / Druid(Cat)
-- local EA_SpecFlag_RunicPower = true; -- Death Knight
-- local EA_SpecFlag_SoulShards = true; -- Warlock
-- local EA_SpecFlag_Eclipse = true;        -- Druid(Mookin)
-- local EA_SpecFlag_HolyPower = true;      -- Paladin

-- The first event of this UI
function EventAlert_OnLoad(self)
	self:RegisterEvent("COMBAT_TEXT_UPDATE");
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	-- self:RegisterEvent("SPELL_UPDATE_COOLDOWN");

	-- self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	-- self:RegisterEvent("UNIT_SPELLCAST_CAST");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

	self:RegisterEvent("UNIT_COMBO_POINTS");
	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("UNIT_POWER");

	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_DEAD");
	self:RegisterEvent("ADDON_LOADED");

	SlashCmdList["EVENTALERTMOD"] = EventAlert_SlashHandler;
	SLASH_EVENTALERTMOD1 = "/eventalertmod";
	SLASH_EVENTALERTMOD2 = "/eam";

	EA_SPELLINFO_SELF = { };
	EA_SPELLINFO_TARGET = { };

	EA_CurrentBuffs = { };
	EA_TarCurrentBuffs = { };
end

local iEAEXF_AlreadyAlert = false;
local iEAEXF_FrameCount = 0;
local iEAEXF_Prefraction = 0;
local function EAEXF_AnimAlpha(self, fraction)
	if iEAEXF_Prefraction == 0 then iEAEXF_Prefraction = fraction end;
	local iAlpha = self:GetAlpha();
	if iEAEXF_Prefraction >= fraction + 0.05 then
		iEAEXF_FrameCount = iEAEXF_FrameCount + 1;
		if iEAEXF_FrameCount >= 19 then iEAEXF_FrameCount = 19 end;
		self:SetBackdrop({bgFile = "Interface\\AddOns\\EventAlertMod\\Images\\Seed"..iEAEXF_FrameCount});
		iAlpha = iAlpha - 0.02;
		iEAEXF_Prefraction = fraction;
	end
	return iAlpha;
end
local EAEXFrameAnimTable = {
	totalTime = 1,
	updateFunc = "SetAlpha",
	getPosFunc = EAEXF_AnimAlpha,
}
function EAEXF_AnimateOut(self)
	SetUpAnimation(self, EAEXFrameAnimTable, EAEXF_AnimFinished, true);
end
function EAEXF_AnimFinished(self)
	self:Hide();
end


-- The procedures of events
function EventAlert_OnEvent(self, event, ...)
	if (event == "ADDON_LOADED") then
		local arg1, arg2 = ...;
		if (arg1 == "EventAlertMod") then
			EventAlert_LoadSpellArray();
			_, EA_playerClass = UnitClass("player");
			-- EA_playerClass = EA_CLASS_DK;
			-- EA_playerClass = EA_CLASS_DRUID;
			-- EA_playerClass = EA_CLASS_HUNTER;
			-- EA_playerClass = EA_CLASS_MAGE;
			-- EA_playerClass = EA_CLASS_PALADIN;
			-- EA_playerClass = EA_CLASS_PRIEST;
			-- EA_playerClass = EA_CLASS_ROGUE;
			-- EA_playerClass = EA_CLASS_SHAMAN;
			-- EA_playerClass = EA_CLASS_WARLOCK;
			-- EA_playerClass = EA_CLASS_WARRIOR;
			EventAlert_VersionCheck();

			if EA_Config.AlertSound == nil then EA_Config.AlertSound = "Sound\\Spells\\ShaysBell.wav" end;
			if EA_Config.AlertSoundValue == nil then EA_Config.AlertSoundValue = 1 end;
			if EA_Config.DoAlertSound == nil then EA_Config.DoAlertSound = true end;
			if EA_Config.LockFrame == nil then EA_Config.LockFrame = true end;
			if EA_Config.ShowFrame == nil then EA_Config.ShowFrame = true end;
			if EA_Config.ShowName == nil then EA_Config.ShowName = true end;
			if EA_Config.ShowFlash == nil then EA_Config.ShowFlash = false end;
			if EA_Config.ShowTimer == nil then EA_Config.ShowTimer = true end;
			if EA_Config.IconSize == nil then EA_Config.IconSize = 60 end;
			if EA_Config.TimerFontSize == nil then EA_Config.TimerFontSize = 28 end;
			if EA_Config.StackFontSize == nil then EA_Config.StackFontSize = 18 end;
			if EA_Config.SNameFontSize == nil then EA_Config.SNameFontSize = 14 end;
			if EA_Config.ChangeTimer == nil then EA_Config.ChangeTimer = false end;
			if EA_Config.AllowESC == nil then EA_Config.AllowESC = false end;
			if EA_Config.AllowAltAlerts == nil then EA_Config.AllowAltAlerts = false end;
			if EA_Config.Target_MyDebuff == nil then EA_Config.Target_MyDebuff = true end;

			if EA_Position.Anchor == nil then EA_Position.Anchor = "CENTER" end;
			if EA_Position.relativePoint == nil then EA_Position.relativePoint = "CENTER" end;
			if EA_Position.xLoc == nil then EA_Position.xLoc = 0 end;
			if EA_Position.yLoc == nil then EA_Position.yLoc = -140 end;
			if EA_Position.xOffset == nil then EA_Position.xOffset = 0 end;
			if EA_Position.yOffset == nil then EA_Position.yOffset = 0 end;
			if EA_Position.RedDebuff == nil then EA_Position.RedDebuff = 0.5 end;
			if EA_Position.GreenDebuff == nil then EA_Position.GreenDebuff = 0.5 end;
			if EA_Position.Tar_NewLine == nil then EA_Position.Tar_NewLine = true end;
			if EA_Position.TarAnchor == nil then EA_Position.TarAnchor = "CENTER" end;
			if EA_Position.TarrelativePoint == nil then EA_Position.TarrelativePoint = "CENTER" end;
			if EA_Position.Tar_xOffset == nil then EA_Position.Tar_xOffset = 0 end;
			if EA_Position.Tar_yOffset == nil then EA_Position.Tar_yOffset = -220 end;
			if EA_Position.ScdAnchor == nil then EA_Position.ScdAnchor = "CENTER" end;
			if EA_Position.Scd_xOffset == nil then EA_Position.Scd_xOffset = 0 end;
			if EA_Position.Scd_yOffset == nil then EA_Position.Scd_yOffset = 80 end;
			if EA_Position.Execution == nil then EA_Position.Execution = 0 end;

			if EA_Pos == nil then EA_Pos = { } end;
			if EA_Pos[EA_CLASS_DK] == nil then EA_Pos[EA_CLASS_DK] = EA_Position end;
			if EA_Pos[EA_CLASS_DRUID] == nil then EA_Pos[EA_CLASS_DRUID] = EA_Position end;
			if EA_Pos[EA_CLASS_HUNTER] == nil then EA_Pos[EA_CLASS_HUNTER] = EA_Position end;
			if EA_Pos[EA_CLASS_MAGE] == nil then EA_Pos[EA_CLASS_MAGE] = EA_Position end;
			if EA_Pos[EA_CLASS_PALADIN] == nil then EA_Pos[EA_CLASS_PALADIN] = EA_Position end;
			if EA_Pos[EA_CLASS_PRIEST] == nil then EA_Pos[EA_CLASS_PRIEST] = EA_Position end;
			if EA_Pos[EA_CLASS_ROGUE] == nil then EA_Pos[EA_CLASS_ROGUE] = EA_Position end;
			if EA_Pos[EA_CLASS_SHAMAN] == nil then EA_Pos[EA_CLASS_SHAMAN] = EA_Position end;
			if EA_Pos[EA_CLASS_WARLOCK] == nil then EA_Pos[EA_CLASS_WARLOCK] = EA_Position end;
			if EA_Pos[EA_CLASS_WARRIOR] == nil then EA_Pos[EA_CLASS_WARRIOR] = EA_Position end;

			EA_Position = EA_Pos[EA_playerClass];
			EA_Position.Tar_NewLine = true;
			if EA_Position.Execution == nil then EA_Position.Execution = 25 end;
			if EA_Position.PlayerLv2BOSS == nil then EA_Position.PlayerLv2BOSS = true end;
			-- EA_Icon_Options_Frame_Tar_NewLine:SetChecked(EA_Position.Tar_NewLine);

			if EA_SpecFlag.HolyPower == nil then EA_SpecFlag.HolyPower = true end;
			if EA_SpecFlag.RunicPower == nil then EA_SpecFlag.RunicPower = true end;
			if EA_SpecFlag.SoulShards == nil then EA_SpecFlag.SoulShards = true end;
			if EA_SpecFlag.Eclipse == nil then EA_SpecFlag.Eclipse = true end;
			if EA_SpecFlag.ComboPoint == nil then EA_SpecFlag.ComboPoint = true end;
			if EA_SpecFlag.Lifebloom == nil then EA_SpecFlag.Lifebloom = true end;

			EventAlert_Options_Init();
			EventAlert_Class_Events_Frame_Init();
			EventAlert_Icon_Options_Frame_Init();
			EventAlert_Other_Events_Frame_Init();
			EventAlert_Target_Events_Frame_Init();
			EventAlert_SCD_Events_Frame_Init();
			EventAlert_CreateFrames();

			if (EA_playerClass == EA_CLASS_PALADIN) then
				if (EA_SpecFlag.HolyPower) then
					CreateFrames_CreateSpecialFrame(10090, 1);  -- Paladin Holy Power
				end
			elseif (EA_playerClass == EA_CLASS_DK) then
				if (EA_SpecFlag.RunicPower) then
					CreateFrames_CreateSpecialFrame(10060, 1);  -- Death Knight Runic
				end
			elseif (EA_playerClass == EA_CLASS_DRUID) then
				if (EA_SpecFlag.ComboPoint) then
					CreateFrames_CreateSpecialFrame(10000, 1);  -- Druid/Rogue Combo Point
				end
				if (EA_SpecFlag.Eclipse) then
					CreateFrames_CreateSpecialFrame(10081, 1);  -- Durid Eclipse
					CreateFrames_CreateSpecialFrame(10082, 1);  -- Durid Eclipse Orange
				end
				if (EA_SpecFlag.Lifebloom) then
					CreateFrames_CreateSpecialFrame(33763, 1);  -- Durid Lifebloom
				end
			elseif (EA_playerClass == EA_CLASS_ROGUE) then
				if (EA_SpecFlag.ComboPoint) then
					CreateFrames_CreateSpecialFrame(10000, 1);  -- Druid/Rogue Combo Point
				end
			elseif (EA_playerClass == EA_CLASS_WARLOCK) then
				if (EA_SpecFlag.SoulShards) then
					CreateFrames_CreateSpecialFrame(10070, 1);  -- Warlock Soul Shards
				end
			end
			EAFun_HookTooltips();
		end
	end

	if (event == "PLAYER_TARGET_CHANGED") then
		EventAlert_TarChange_ClearFrame();
		if UnitName("player") ~= UnitName("target") then
			EventAlert_TarBuffs_Update();
			if EA_SpecFlag.ComboPoint then EventAlert_UpdateComboPoint() end;
			EventAlert_CheckExecution();
		end;
	end

	-- if (event == "UNIT_SPELLCAST_SUCCEEDED" or event == "UNIT_SPELLCAST_START")  then
	--  local arg1, arg2, arg3, arg4, arg5 = ...;
	--  -- /ea showc will also display in this function
	--  -- EventAlert_ScdBuffs_Update(arg1, arg2, arg5);
	-- end

	if (event == "COMBAT_LOG_EVENT_UNFILTERED")  then
		-- local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
		--local timestp, event, hideCaster, surGUID, surName, surFlags, surRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellID, spellName = ...;
		local timestp, event, hideCaster, surGUID, surName, surFlags, surRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellID, spellName
        if(is40100) then
            timestp, event, hideCaster, surGUID, surName, surFlags, dstGUID, dstName, dstFlags, spellID, spellName = ...;
        else
            timestp, event, hideCaster, surGUID, surName, surFlags, surRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellID, spellName = ...;
        end
		-- /ea showc will also display in this function
		-- EventAlert_ScdBuffs_Update(arg4, arg10, arg9);   -- UnitName, spellName, spellID
		spellID = tonumber(spellID);
		if (dstName ~= nil) then dstName = strsplit("-", dstName, 2) end;
		if ((spellID ~= nil) and (spellID > 0 and spellID < 1000000)) then
			EventAlert_ScdBuffs_Update(surName, spellName, spellID); -- WOW 4.1 Change
			local iUnitPower = UnitPower("player", 8);
			if (EA_playerClass == EA_CLASS_DRUID and EA_SpecFlag.Lifebloom and iUnitPower == 0) then
				local EA_PlayerName = UnitName("player");
				if (surName == EA_PlayerName and spellID == 33763 and dstName ~= nil) then
					-- print ("tar="..arg8.." /spid="..arg10);
					local EA_UnitID = "";
					if (dstName == EA_PlayerName) then
						EA_UnitID = "player";
					elseif dstName == EA_SpecFrame_Lifebloom.UnitName then
						EA_UnitID = EA_SpecFrame_Lifebloom.UnitID;
					else
						EA_UnitID = EAFun_GetUnitIDByName(dstName);
					end
					EventAlert_UpdateLifebloom(EA_UnitID);
				end
			end
		end
	end

	if (event == "UNIT_AURA") then
		local arg1 = ...;
		EventAlert_Unit_Aura(arg1);
	end

	if (event == "COMBAT_TEXT_UPDATE") then
		local arg1, arg2 = ...;
		if (arg1 == "SPELL_ACTIVE") then
			EventAlert_COMBAT_TEXT_SPELL_ACTIVE(arg2);
		end
	end

	if (event == "UNIT_COMBO_POINTS") then
		if EA_SpecFlag.ComboPoint then EventAlert_UpdateComboPoint() end;
	end

	if (event == "UNIT_HEALTH") then
		local arg1 = ...;
		if arg1 == "target" then
			EventAlert_CheckExecution();
		end
	end

	if (event == "UNIT_POWER") then
		local arg1, arg2 = ...;
		if arg1 == "player" then
			if ((arg2 == "RUNIC_POWER") and (EA_playerClass == EA_CLASS_DK) and EA_SpecFlag.RunicPower) then
				EventAlert_UpdateSinglePower(6);
			end
			if ((arg2 == "SOUL_SHARDS") and (EA_playerClass == EA_CLASS_WARLOCK) and EA_SpecFlag.SoulShards) then
				EventAlert_UpdateSinglePower(7);
			end
			if ((arg2 == "HOLY_POWER") and (EA_playerClass == EA_CLASS_PALADIN) and EA_SpecFlag.HolyPower) then
				EventAlert_UpdateSinglePower(9);
			end
			if ((arg2 == "ECLIPSE") and (EA_playerClass == EA_CLASS_DRUID) and EA_SpecFlag.Eclipse) then
				EventAlert_UpdateEclipse();
			end
		end
	end

	if (event == "PLAYER_DEAD" or event == "PLAYER_ENTERING_WORLD") then
		if (EA_playerClass == EA_CLASS_DK and EA_SpecFlag.RunicPower) then
			EventAlert_UpdateSinglePower(6);
		end
		if (EA_playerClass == EA_CLASS_WARLOCK and EA_SpecFlag.SoulShards) then
			EventAlert_UpdateSinglePower(7);
		end
		if (EA_playerClass == EA_CLASS_PALADIN and EA_SpecFlag.HolyPower) then
			EventAlert_UpdateSinglePower(9);
		end
		if (EA_playerClass == EA_CLASS_DRUID and EA_SpecFlag.Eclipse) then
			EventAlert_UpdateEclipse();
		end
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9 = ...;
		local v = table.foreach(EA_CurrentBuffs, function(i, v) if v==arg9 then return v end end)
		if v then
			local f = _G["EAFrame_"..v];
			f:Hide();
			EA_CurrentBuffs = table.wipe(EA_CurrentBuffs);
		end

		EA_ClassAltSpellName = { };
		for i,v in pairs(EA_AltItems[EA_playerClass]) do
			local name, rank = GetSpellInfo(i);
			EA_ClassAltSpellName[name] = tonumber(i);
		end
	end
end


function EventAlert_Unit_Aura(unit)
	if unit == "player" then
		EventAlert_Buffs_Update();
	elseif unit == "target" then
		EventAlert_TarBuffs_Update();
	end
end

local function EAFun_CheckSpellConditionMatch(EA_count, EA_unitCaster, EAItems)
	local ifAdd_buffCur = true;
	local SC_Stack, SC_Self = 1, false;
	if (EAItems ~= nil) then
		if (EAItems.stack ~= nil) then SC_Stack = EAItems.stack end;
		if (EAItems.self ~= nil) then SC_Self = EAItems.self end;
	end
	if (SC_Stack ~= nil and SC_Stack > 1) then
		if (EA_count < SC_Stack) then ifAdd_buffCur = false end;
	end
	if (SC_Self ~= nil and SC_Self) then
		if (EA_unitCaster ~= "player") then ifAdd_buffCur = false end;
	end
	return ifAdd_buffCur;
end

local function EAFun_GetSpellItemEnable(EAItems)
	local SpellEnable = false;
	if (EAItems ~= nil) then
		if (EAItems.enable) then SpellEnable = true end;
	end
	return SpellEnable;
end

local function EAFun_CheckSpellConditionOverGrow(EA_count, EAItems)
	local isOverGrow = false;
	local SC_OverGrow = 0;
	if (EAItems ~= nil) then
		if (EAItems.overgrow ~= nil) then SC_OverGrow = EAItems.overgrow end;
	end
	if (EA_count <= 0) then EA_count = 1 end;
	if (SC_OverGrow ~= nil and SC_OverGrow > 0) then
		if (SC_OverGrow <= EA_count) then isOverGrow = true end;
	end
	return isOverGrow;
end

local function EAFun_GetSpellConditionRedSecText(EAItems)
	local SC_RedSecText = -1;
	if (EAItems ~= nil) then
		if (EAItems.redsectext ~= nil) then SC_RedSecText = EAItems.redsectext end;
		if (SC_RedSecText < 1) then SC_RedSecText = -1 end;
	end
	return SC_RedSecText;
end

function EventAlert_Buffs_Update()
	local buffsCurrent = {};
	local buffsToDelete = {};
	local SpellEnable, OtherEnable = false, false;
	local ifAdd_buffCur = false;
	-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert_Buffs_Update");
	-- if (EA_DEBUGFLAG1) then
	--  DEFAULT_CHAT_FRAME:AddMessage("----"..EA_XCMD_SELFLIST.."----");
	-- end

	if (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
		CreateFrames_EventsFrame_ClearSpellList(3);
	end

	for i=1,40 do
		local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("player", i)
		if (not spellId) then
			break;
		end

		if (spellId == 71601) then EA_SPEC_expirationTime1 = expirationTime end;
		if (spellId == 71644) then EA_SPEC_expirationTime2 = expirationTime end;

		if (EA_DEBUGFLAG1) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				EAFun_AddSpellToScrollFrame(spellId, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellId..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
			end
		end

		ifAdd_buffCur = false;
		SpellEnable = EAFun_GetSpellItemEnable(EA_Items[EA_playerClass][spellId]);
		OtherEnable = EAFun_GetSpellItemEnable(EA_Items[EA_CLASS_OTHER][spellId]);
		if (SpellEnable) then
			-- ifAdd_buffCur = true;
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_Items[EA_playerClass][spellId]);
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true;
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_Items[EA_CLASS_OTHER][spellId]);
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			-- ifAdd_buffCur = true;
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellId="..spellId.." /unitCaster="..unitCaster);
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if EA_Items[EA_CLASS_OTHER][spellId] == nil then EA_Items[EA_CLASS_OTHER][spellId] = {enable=true,} end;
					CreateFrames_CreateSpellFrame(spellId, 1);
					ifAdd_buffCur = true;
				end
			end
		end

		if (ifAdd_buffCur) then
			-- if EA_SPELLINFO_SELF[spellId] == nil then EA_SPELLINFO_SELF[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
			-- EA_SPELLINFO_SELF[spellId].name = name;
			-- EA_SPELLINFO_SELF[spellId].rank = rank;
			-- EA_SPELLINFO_SELF[spellId].icon = icon;
			EA_SPELLINFO_SELF[spellId].count = count;
			EA_SPELLINFO_SELF[spellId].duration = duration;
			EA_SPELLINFO_SELF[spellId].expirationTime = expirationTime;
			EA_SPELLINFO_SELF[spellId].unitCaster = unitCaster;
			EA_SPELLINFO_SELF[spellId].isDebuff = false;
			table.insert(buffsCurrent, spellId);
		end
	end

	for i=41,80 do
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("player", i-40)
		if (not spellId) then
			break;
		end

		if (EA_DEBUGFLAG1) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				EAFun_AddSpellToScrollFrame(spellId, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellId..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
			end
		end

		ifAdd_buffCur = false;
		SpellEnable = EAFun_GetSpellItemEnable(EA_Items[EA_playerClass][spellId]);
		OtherEnable = EAFun_GetSpellItemEnable(EA_Items[EA_CLASS_OTHER][spellId]);
		if (SpellEnable) then
			-- ifAdd_buffCur = true;
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_Items[EA_playerClass][spellId]);
		elseif (OtherEnable) then
			-- ifAdd_buffCur = true;
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_Items[EA_CLASS_OTHER][spellId]);
		elseif (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
			if (EA_LISTSEC_SELF == 0 or (0 < duration and duration <= EA_LISTSEC_SELF)) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellId="..spellId.." /unitCaster="..unitCaster);
				if EA_DEBUGFLAG11 or (EA_DEBUGFLAG21 and (not (UnitInRaid(unitCaster) or UnitInParty(unitCaster)))) then
					if EA_Items[EA_CLASS_OTHER][spellId] == nil then EA_Items[EA_CLASS_OTHER][spellId] = {enable=true,} end;
					CreateFrames_CreateSpellFrame(spellId, 1);
					ifAdd_buffCur = true;
				end
			end
		end

		if (ifAdd_buffCur) then
			-- if EA_SPELLINFO_SELF[spellId] == nil then EA_SPELLINFO_SELF[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
			-- EA_SPELLINFO_SELF[spellId].name = name;
			-- EA_SPELLINFO_SELF[spellId].rank = rank;
			-- EA_SPELLINFO_SELF[spellId].icon = icon;
			EA_SPELLINFO_SELF[spellId].count = count;
			EA_SPELLINFO_SELF[spellId].duration = duration;
			EA_SPELLINFO_SELF[spellId].expirationTime = expirationTime;
			EA_SPELLINFO_SELF[spellId].unitCaster = unitCaster;
			EA_SPELLINFO_SELF[spellId].isDebuff = true;
			table.insert(buffsCurrent, spellId);
		end
	end

	-- Check: Buff dropped
	local v1 = table.foreach(EA_CurrentBuffs,
		function(i, v1)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-check: "..i.." id: "..v1);
			SpellEnable = false;
			SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][v1]);
			if (not SpellEnable) then
				local v2 = table.foreach(buffsCurrent,
					function(k, v2)
						if (v1==v2) then
							return v2;
						end
					end
				)
				if(not v2) then
					-- Buff dropped
					table.insert(buffsToDelete, v1);
				end
			end
		end
	)

	-- Drop Buffs
	table.foreach(buffsToDelete,
		function(i, v)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropped: id: "..v);
			EventAlert_Buff_Dropped(v);
		end
	)

	-- Check: Buff applied
	local v1 = table.foreach(buffsCurrent,
		function(i, v1)
			local v2 = table.foreach(EA_CurrentBuffs,
				function(k, v2)
					if (v1==v2) then
					return v2;
					end
				end
			)
			if(not v2) then
				-- Buff applied
				EventAlert_Buff_Applied(v1);
			end
		end
	)
	EventAlert_PositionFrames();

	if (EA_DEBUGFLAG11 or EA_DEBUGFLAG21) then
		CreateFrames_EventsFrame_RefreshSpellList(3);
	end
end


function EventAlert_TarBuffs_Update()
	local buffsCurrent = {};
	local buffsToDelete = {};
	local SpellEnable = false;
	local ifAdd_buffCur = false;
	-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert_Buffs_Update");
	-- if (EA_DEBUGFLAG2) then
	--  DEFAULT_CHAT_FRAME:AddMessage("--------"..EA_XCMD_TARGETLIST.."--------");
	-- end

	for i=1,40 do
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff("target", i)
		if (not spellId) then
			break;
		end

		if (EA_DEBUGFLAG2) then
			if (EA_LISTSEC_TARGET == 0 or (0 < duration and duration <= EA_LISTSEC_TARGET)) then
				EAFun_AddSpellToScrollFrame(spellId, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellId..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
			end
		end

		ifAdd_buffCur = false;
		SpellEnable = EAFun_GetSpellItemEnable(EA_TarItems[EA_playerClass][spellId]);
		if (SpellEnable) then
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_TarItems[EA_playerClass][spellId]);
			if (ifAdd_buffCur) then
				-- if EA_SPELLINFO_TARGET[spellId] == nil then EA_SPELLINFO_TARGET[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
				-- EA_SPELLINFO_TARGET[spellId].name = name;
				-- EA_SPELLINFO_TARGET[spellId].rank = rank;
				-- EA_SPELLINFO_TARGET[spellId].icon = icon;
				EA_SPELLINFO_TARGET[spellId].count = count;
				EA_SPELLINFO_TARGET[spellId].duration = duration;
				EA_SPELLINFO_TARGET[spellId].expirationTime = expirationTime;
				EA_SPELLINFO_TARGET[spellId].unitCaster = unitCaster;
				EA_SPELLINFO_TARGET[spellId].isDebuff = true;
				table.insert(buffsCurrent, spellId);
			end
		end
	end

	for i=41,80 do
		name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("target", i-40)
		if (not spellId) then
			break;
		end

		if (EA_DEBUGFLAG2) then
			if (EA_LISTSEC_TARGET == 0 or (0 < duration and duration <= EA_LISTSEC_TARGET)) then
				EAFun_AddSpellToScrollFrame(spellId, " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
					" /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
				-- DEFAULT_CHAT_FRAME:AddMessage("["..i.."]\124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r:"..name..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r:"..spellId..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P3.."\124r:"..count..
				--  " /\124cffFFFF00"..EA_XCMD_DEBUG_P4.."\124r:"..duration);
			end
		end

		ifAdd_buffCur = false;
		SpellEnable = EAFun_GetSpellItemEnable(EA_TarItems[EA_playerClass][spellId]);
		if (SpellEnable) then
			ifAdd_buffCur = EAFun_CheckSpellConditionMatch(count, unitCaster, EA_TarItems[EA_playerClass][spellId]);
			if (ifAdd_buffCur) then
				-- if EA_SPELLINFO_TARGET[spellId] == nil then EA_SPELLINFO_TARGET[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
				-- EA_SPELLINFO_TARGET[spellId].name = name;
				-- EA_SPELLINFO_TARGET[spellId].rank = rank;
				-- EA_SPELLINFO_TARGET[spellId].icon = icon;
				EA_SPELLINFO_TARGET[spellId].count = count;
				EA_SPELLINFO_TARGET[spellId].duration = duration;
				EA_SPELLINFO_TARGET[spellId].expirationTime = expirationTime;
				EA_SPELLINFO_TARGET[spellId].unitCaster = unitCaster;
				EA_SPELLINFO_TARGET[spellId].isDebuff = false;
				table.insert(buffsCurrent, spellId);
			end
		end
	end

	-- Check: Buff dropped
	local v1 = table.foreach(EA_TarCurrentBuffs,
		function(i, v1)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-check: "..i.." id: "..v1);
			local v2 = table.foreach(buffsCurrent,
				function(k, v2)
					-- DEFAULT_CHAT_FRAME:AddMessage("=== buff-check: "..i.." /v2 id: "..v1);
					if (v1==v2) then
						return v2;
					end
				end
			)
			if(not v2) then
				-- Buff dropped
				-- DEFAULT_CHAT_FRAME:AddMessage("=== add to Delete /v1 id: "..v1);
				table.insert(buffsToDelete, v1);
			end
		end
	)

	-- Drop Buffs
	table.foreach(buffsToDelete,
		function(i, v)
			-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropped: id: "..v);
			EventAlert_TarBuff_Dropped(v);
		end
	)

	-- Check: Buff applied
	local v1 = table.foreach(buffsCurrent,
		function(i, v1)
			local v2 = table.foreach(EA_TarCurrentBuffs,
				function(k, v2)
					if (v1==v2) then
					return v2;
					end
				end
			)
			if(not v2) then
				-- Buff applied
				-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert_Buff_Applied("..v1..")");
				EventAlert_TarBuff_Applied(v1);
			end
		end
	)
	EventAlert_TarPositionFrames();
end


function EventAlert_TarChange_ClearFrame()
	local ibuff = #EA_TarCurrentBuffs;
	for i=1,ibuff do
		EventAlert_TarBuff_Dropped(EA_TarCurrentBuffs[1]);
	end
end


function EventAlert_ScdBuffs_Update(EA_Unit, EA_SpellName, EA_SpellID)
		local spellId = tonumber(EA_SpellID);
		local sSpellLink = "";
		local SpellEnable = false;
		-- DEFAULT_CHAT_FRAME:AddMessage("spellId="..spellId.." / EA_SpellName="..EA_SpellName);
		-- DEFAULT_CHAT_FRAME:AddMessage("EA_Unit="..EA_Unit);
		if ((EA_Unit == UnitName("player")) and (spellId ~= 0)) then
			-- print (EA_SpellID.." /"..EA_SpellName.." /"..EA_Unit);
		-- if ((EA_Unit == "player") and (spellId ~= 0)) then
			if (EA_DEBUGFLAG3) then
				sSpellLink = GetSpellLink(EA_SpellID);
				if (sSpellLink ~= nil) then
					-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..EA_SpellID.." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink);
					EAFun_AddSpellToScrollFrame(EA_SpellID, "");
				end
			end

			if (spellId==47666 or spellId==47750) then spellId=47540 end;   -- Priest Penance
			if (spellId==73921 or spellId==98887) then spellId=73920 end;   -- Shaman Healing Rain
			if (spellId==61391) then spellId=50516 end;   			-- Druid Typhoon
			SpellEnable = EAFun_GetSpellItemEnable(EA_ScdItems[EA_playerClass][spellId]);
			if (SpellEnable) then
				-- DEFAULT_CHAT_FRAME:AddMessage("spellId="..spellId.." / EA_ScdItems[EA_playerClass][spellId]=true");
				local strSpellId = tostring(spellId);
				local eaf = _G["EAScdFrame_"..strSpellId];
				insertBuffValue(EA_ScdCurrentBuffs, spellId);
				if eaf ~= nil then
					eaf:Hide();
					if not eaf:IsVisible() then
						local gsiIcon = EA_SPELLINFO_SCD[spellId].icon;
						eaf:SetBackdrop({bgFile = gsiIcon});
						eaf:SetWidth(EA_Config.IconSize);
						eaf:SetHeight(EA_Config.IconSize);
						eaf:SetAlpha(1);
						eaf:SetScript("OnUpdate", function()
							EventAlert_OnSCDUpdate(spellId);
						end);
					end
					EventAlert_ScdPositionFrames();
				end
			end
		end
end



function EventAlert_Buff_Dropped(spellId)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropping: id: "..spellId);
	local f = _G["EAFrame_"..spellId];
	ActionButton_HideOverlayGlow(f);
	f.overgrow = false;
	f:Hide();
	f:SetScript("OnUpdate", nil);
	removeBuffValue(EA_CurrentBuffs, spellId);
	-- EventAlert_PositionFrames();
end
function EventAlert_Buff_Applied(spellId)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-applying: id: "..spellId);
	table.insert(EA_CurrentBuffs, spellId);
	-- EventAlert_PositionFrames();
	EventAlert_DoAlert();
end
function EventAlert_TarBuff_Dropped(spellId)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-dropping: id: "..spellId);
	local f = _G["EATarFrame_"..spellId];
	ActionButton_HideOverlayGlow(f);
	f.overgrow = false;
	f:Hide();
	f:SetScript("OnUpdate", nil);
	removeBuffValue(EA_TarCurrentBuffs, spellId);
	EventAlert_TarPositionFrames();
end
function EventAlert_TarBuff_Applied(spellId)
	-- DEFAULT_CHAT_FRAME:AddMessage("buff-applying: id: "..spellId);
	table.insert(EA_TarCurrentBuffs, spellId);
	EventAlert_TarPositionFrames();
end


function EventAlert_COMBAT_TEXT_SPELL_ACTIVE(spellName)
	local SpellEnable = false;
	if (EA_Config.AllowAltAlerts==true) then
		-- DEFAULT_CHAT_FRAME:AddMessage("spell-active: "..spellName);
		-- searching for the spell-id, because we only get the name of the spell
		local spellId = table.foreach(EA_ClassAltSpellName,
		function(i, spellId)
			-- DEFAULT_CHAT_FRAME:AddMessage("EA_ClassAltSpellName("..spellId..")");
			if i==spellName then
				return spellId
			end
		end)

		if spellId then
			spellId = tonumber(spellId);
			SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][spellId]);
			if (SpellEnable) then
				local v2 = table.foreach(EA_CurrentBuffs,
				function(i2, v2)
					if v2==spellId then
						return v2
					end
				end)

				if (not v2) then
					-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert_Buff_Applied("..spellId..")");
					EventAlert_Buff_Applied(spellId);
					EventAlert_PositionFrames();
				end
			end
		end
	end
end


-- function EventAlert_OnUpdate()
function EventAlert_OnUpdate(spellId)
	if #EA_CurrentBuffs ~= 0 then
		local timerFontSize = 0;
		local SC_RedSecText, isOverGrow = -1, false;

		-- for i,v in ipairs (EA_CurrentBuffs) do
			local v = tostring(spellId);
			local eaf = _G["EAFrame_"..v];
			-- local name, rank = GetSpellInfo(v);
			spellId = tonumber(v);
			local name = EA_SPELLINFO_SELF[spellId].name;
			local rank = EA_SPELLINFO_SELF[spellId].rank;

			if (EA_Config.AllowAltAlerts == true) then
				local SpellEnable = EAFun_GetSpellItemEnable(EA_AltItems[EA_playerClass][spellId]);
				if (SpellEnable) then
					local EA_usable, EA_nomana = IsUsableSpell(name);
					if (EA_usable ~= 1) then
						EventAlert_Buff_Dropped(spellId);
						EventAlert_PositionFrames();
						return;
					 else
						-- local _,_,_,EAA_count,_,_,EAA_expirationTime,_,_ = UnitAura("player", name, rank);
						EA_SPELLINFO_SELF[spellId].count = 0;
						EA_SPELLINFO_SELF[spellId].expirationTime = 0;
						EA_SPELLINFO_SELF[spellId].isDebuff = false;
					end
				end
			end

			if eaf ~= nil then
				eaf:SetCooldown(1, 0);
				if (EA_Config.ShowTimer) then
					-- local _,_,_,_,_,_,EA_expirationTime,_,_ = UnitAura("player", name, rank);
					-- local EA_Name,_,_,EA_count,_,_,EA_expirationTime,_,_ = UnitAura("player", name, rank);
					local EA_Name = EA_SPELLINFO_SELF[spellId].name;
					local EA_count = EA_SPELLINFO_SELF[spellId].count;
					local EA_expirationTime = EA_SPELLINFO_SELF[spellId].expirationTime;
					local IfIsDebuff = EA_SPELLINFO_SELF[spellId].isDebuff;
					local EA_currentTime = 0;
					local EA_timeLeft = 0;

					-- eaf:SetCooldown(EA_start, EA_duration);
					if (EA_expirationTime ~= nil) then
						EA_currentTime = GetTime();
						EA_timeLeft = 0 + EA_expirationTime - EA_currentTime;
					end

					SC_RedSecText = EAFun_GetSpellConditionRedSecText(EA_Items[EA_playerClass][spellId]);
					if (SC_RedSecText <= -1) then
						SC_RedSecText = EAFun_GetSpellConditionRedSecText(EA_Items[EA_CLASS_OTHER][spellId]);
					end
					EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText);

					isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, EA_Items[EA_playerClass][spellId]);
					if (not isOverGrow) then
						isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, EA_Items[EA_CLASS_OTHER][spellId]);
					end
					if (isOverGrow) then
						if (not eaf.overgrow) then
							ActionButton_ShowOverlayGlow(eaf);
							eaf.overgrow = true;
						end
					else
						if (eaf.overgrow) then
							ActionButton_HideOverlayGlow(eaf);
							eaf.overgrow = false;
						end
					end
				else
					eaf.spellTimer:SetText("");
					eaf.spellStack:SetText("");
				end
			end
		-- end
	end
end


-- function EventAlert_OnTarUpdate()
function EventAlert_OnTarUpdate(spellId)
	if #EA_TarCurrentBuffs ~= 0 then
		local SC_RedSecText, isOverGrow = -1, false;

		-- for i,v in ipairs (EA_TarCurrentBuffs) do
			local v = tostring(spellId);
			local eaf = _G["EATarFrame_"..v];
			-- local name, rank = GetSpellInfo(v);
			spellId = tonumber(v);

			if eaf ~= nil then
				eaf:SetCooldown(1, 0);
				if (EA_Config.ShowTimer) then
					-- local EA_Name,_,_,EA_count,_,_,EA_expirationTime,_,_ = UnitDebuff("target", name, rank);
					local EA_Name = EA_SPELLINFO_TARGET[spellId].name;
					local EA_count = EA_SPELLINFO_TARGET[spellId].count;
					local EA_expirationTime = EA_SPELLINFO_TARGET[spellId].expirationTime;
					local IfIsDebuff = EA_SPELLINFO_TARGET[spellId].isDebuff;
					local EA_currentTime = 0;
					local EA_timeLeft = 0;

					if (EA_expirationTime ~= nil) then
						EA_currentTime = GetTime();
						EA_timeLeft = 0 + EA_expirationTime - EA_currentTime;
					end

					SC_RedSecText = EAFun_GetSpellConditionRedSecText(EA_Items[EA_playerClass][spellId]);

					EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText);

					isOverGrow = EAFun_CheckSpellConditionOverGrow(EA_count, EA_TarItems[EA_playerClass][spellId]);
					if (isOverGrow) then
						if (not eaf.overgrow) then
							ActionButton_ShowOverlayGlow(eaf);
							eaf.overgrow = true;
						end
					else
						if (eaf.overgrow) then
							ActionButton_HideOverlayGlow(eaf);
							eaf.overgrow = false;
						end
					end
				else
					eaf.spellTimer:SetText("");
					eaf.spellStack:SetText("");
				end
			end
		-- end
	end
end


local function EASCDFrame_AnimSize(self, fraction)
	local iAlpha = self:GetAlpha();
	local iSize = self:GetWidth();
	self:SetSize(iSize+1, iSize+1);
	return iAlpha-0.02;
end
local EASCDFrameAnimTable = {
	totalTime = 0.5,
	updateFunc = "SetAlpha",
	getPosFunc = EASCDFrame_AnimSize,
}
function EASCDFrame_AnimateOut(self)
	SetUpAnimation(self, EASCDFrameAnimTable, EASCDFrame_AnimFinished, true)
end
function EASCDFrame_AnimFinished(self)
end
function EventAlert_OnSCDUpdate(spellId)
	local iShift = 0;
	local eaf = _G["EAScdFrame_"..spellId];

	local EA_start, EA_duration, EA_Enable = GetSpellCooldown(spellId);
	if (eaf ~= nil) then
		if (EA_Enable ~= 0) then
			if (EA_start > 0) and (EA_duration > 0) then
				local EA_timeLeft = EA_start + EA_duration - GetTime();
				-- DEFAULT_CHAT_FRAME:AddMessage("[spellId="..spellId.." / EA_timeLeft="..EA_timeLeft.."]");
				if 1.5 <= EA_timeLeft then
					local gsiIcon = EA_SPELLINFO_SCD[spellId].icon;
					eaf:SetBackdrop({bgFile = gsiIcon});
					eaf:SetWidth(EA_Config.IconSize);
					eaf:SetHeight(EA_Config.IconSize);
					eaf:SetAlpha(1);
					eaf:SetCooldown(EA_start, EA_duration);
					if (EA_Config.ShowTimer) then
						EAFun_SetCountdownStackText(eaf, EA_timeLeft+0.5, 0, -1);
					end
					eaf:Show();
				elseif 0 <= EA_timeLeft and EA_timeLeft < 1.5 then
					if (EA_timeLeft < 0.5) then
						EASCDFrame_AnimateOut(eaf);
					end
					if (EA_Config.ShowTimer) then
						EAFun_SetCountdownStackText(eaf, EA_timeLeft+0.5, 0, -1);
					end
				else
					-- eaf:SetCooldown(1, 0);
					-- eaf:SetAlpha(0);
					eaf:Hide();
					eaf:SetCooldown(1, 0);
					eaf:SetAlpha(0);
					eaf:SetScript("OnUpdate", nil);
					removeBuffValue(EA_ScdCurrentBuffs, spellId);
					EventAlert_ScdPositionFrames();
				end
			else
				eaf:Hide();
				eaf:SetCooldown(1, 0);
				eaf:SetAlpha(0);
				eaf:SetScript("OnUpdate", nil);
				removeBuffValue(EA_ScdCurrentBuffs, spellId);
				EventAlert_ScdPositionFrames();
			end
		end
	end
end


function EventAlert_DoAlert()
	if (EA_Config.ShowFlash == true) then
		UIFrameFadeIn(LowHealthFrame, 1, 0, 1);
		UIFrameFadeOut(LowHealthFrame, 2, 1, 0);
	end
	if (EA_Config.DoAlertSound == true) then
		PlaySoundFile(EA_Config.AlertSound);
	end
end


function EventAlert_PositionFrames(event)
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local prevFrame2 = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;

		for k,v in ipairs(EA_CurrentBuffs) do
			local eaf = _G["EAFrame_"..v];
			local spellId = tonumber(v);
			local gsiName = EA_SPELLINFO_SELF[spellId].name;
			local gsiIcon = EA_SPELLINFO_SELF[spellId].icon;
			local gsiIsDebuff = EA_SPELLINFO_SELF[spellId].isDebuff;

			if eaf ~= nil then
				eaf:ClearAllPoints();
				if EA_Position.Tar_NewLine then
					if gsiIsDebuff then
						if (prevFrame2 == "EA_Main_Frame" or prevFrame2 == eaf) then
							prevFrame2 = "EA_Main_Frame";
							if EA_SpecFrame_Self then
								eaf:SetPoint(EA_Position.Anchor, prevFrame2, EA_Position.Anchor, -2 * xOffset, -2 * yOffset);
							else
								eaf:SetPoint(EA_Position.Anchor, prevFrame2, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);
							end
						else
							eaf:SetPoint("CENTER", prevFrame2, "CENTER", -1 * xOffset, -1 * yOffset);
						end
						prevFrame2 = eaf;
					else
						if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
							prevFrame = "EA_Main_Frame";
							eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, 0, 0);
						else
							eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset);
						end
						prevFrame = eaf;
					end
				else
					if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
						prevFrame = "EA_Main_Frame";
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, 0, 0);
					else
						eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset);
					end
					prevFrame = eaf;
				end;

				eaf:SetWidth(EA_Config.IconSize);
				eaf:SetHeight(EA_Config.IconSize);
				eaf:SetBackdrop({bgFile = gsiIcon});
				if gsiIsDebuff then eaf:SetBackdropColor(1.0, EA_Position.RedDebuff, EA_Position.RedDebuff) end;
				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(gsiName);
					local SfontName, SfontSize = eaf.spellName:GetFont();
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf.spellName:SetText("");
				end
				eaf:SetScript("OnUpdate", function()
					EventAlert_OnUpdate(spellId)
				end);
				eaf:Show();
			end
		end
	end
end


function EventAlert_TarPositionFrames(event)
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local prevFrame2 = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;

		for k,v in ipairs(EA_TarCurrentBuffs) do
			local eaf = _G["EATarFrame_"..v];
			local spellId = tonumber(v);
			local gsiName = EA_SPELLINFO_TARGET[spellId].name;
			local gsiIcon = EA_SPELLINFO_TARGET[spellId].icon;
			local gsiIsDebuff = EA_SPELLINFO_TARGET[spellId].isDebuff;

			if eaf ~= nil then
				eaf:ClearAllPoints();
				if EA_Position.Tar_NewLine then
					if gsiIsDebuff then
						if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
							prevFrame = "EA_Main_Frame";
							eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset, EA_Position.Tar_yOffset);
						else
							eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset);
						end
						prevFrame = eaf;
					else
						if (prevFrame2 == "EA_Main_Frame" or prevFrame2 == eaf) then
							prevFrame2 = "EA_Main_Frame";
							if EA_SpecFrame_Target then
								eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - 2 * xOffset, EA_Position.Tar_yOffset - 2 * yOffset);
								-- eaf:SetPoint(EA_Position.TarAnchor, prevFrame2, EA_Position.TarAnchor, -2 * xOffset, -2 * yOffset);
							else
								eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - xOffset, EA_Position.Tar_yOffset - yOffset);
								-- eaf:SetPoint(EA_Position.TarAnchor, prevFrame2, EA_Position.TarAnchor, -1 * xOffset, -1 * yOffset);
							end
						else
							eaf:SetPoint("CENTER", prevFrame2, "CENTER", -1 * xOffset, -1 * yOffset);
						end
						prevFrame2 = eaf;
					end
				else
					if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
						prevFrame = "EA_Main_Frame";
						eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);
					else
						eaf:SetPoint("CENTER", prevFrame, "CENTER", -1 * xOffset, -1 * yOffset);
					end
				end

				eaf:SetWidth(EA_Config.IconSize);
				eaf:SetHeight(EA_Config.IconSize);
				eaf:SetBackdrop({bgFile = gsiIcon});
				if gsiIsDebuff then eaf:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff) end;
				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(gsiName);
					local SfontName, SfontSize = eaf.spellName:GetFont();
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf.spellName:SetText("");
				end
				eaf:SetScript("OnUpdate", function()
					EventAlert_OnTarUpdate(spellId)
				end);
				eaf:Show();
			end
		end
	end
end

function EventAlert_ScdPositionFrames(event)
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;

		for k,v in ipairs(EA_ScdCurrentBuffs) do
			local eaf = _G["EAScdFrame_"..v];
			local spellId = tonumber(v);
			local gsiName = EA_SPELLINFO_SCD[spellId].name;

			if eaf ~= nil then
				eaf:ClearAllPoints();
				if (prevFrame == "EA_Main_Frame" or prevFrame == eaf) then
					prevFrame = "EA_Main_Frame";
					eaf:SetPoint("CENTER", UIParent, EA_Position.ScdAnchor, EA_Position.Scd_xOffset, EA_Position.Scd_yOffset);
				else
					eaf:SetPoint("CENTER", prevFrame, "CENTER", xOffset, yOffset);
				end

				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(gsiName);
					local SfontName, SfontSize = eaf.spellName:GetFont();
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf.spellName:SetText("");
				end
				prevFrame = eaf;
				eaf:Show();
			end
		end
	end
end


-- The command parser
function EventAlert_SlashHandler(msg)
	local F_EA = "\124cffFFFF00EventAlertMod\124r";
	local F_ON = "\124cffFF0000".."[ON]".."\124r";
	local F_OFF = "\124cff00FFFF".."[OFF]".."\124r";
	local RtnMsg = "";
	local MoreHelp = false;

	msg = string.lower(msg);
	local cmdtype, para1 = strsplit(" ", msg)
	local listSec = 0;
	if para1 ~= nil then
		listSec = tonumber(para1);
	end

	if (cmdtype == "options" or cmdtype == "opt") then
		if not EA_Options_Frame:IsVisible() then
			ShowUIPanel(EA_Options_Frame);
		else
			HideUIPanel(EA_Options_Frame);
		end

	-- elseif (cmdtype == "version" or cmdtype == "ver") then
	--  DEFAULT_CHAT_FRAME:AddMessage(F_EA..EA_XCMD_VER..EA_Config.Version);

	elseif (cmdtype == "show") then
		EA_DEBUGFLAG11 = false;
		EA_DEBUGFLAG21 = false;
		EA_LISTSEC_SELF = 0;
		if (EA_DEBUGFLAG1) then
			EA_DEBUGFLAG1 = false;
			RtnMsg = F_EA..EA_XCMD_SELFLIST..F_OFF;
		else
			EA_DEBUGFLAG1 = true;
			EA_LISTSEC_SELF = listSec;
			RtnMsg = F_EA..EA_XCMD_SELFLIST..F_ON;
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end;
			EAFun_ClearSpellScrollFrame();
			EA_Version_Frame:Show();
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg);

	elseif (cmdtype == "showtarget" or cmdtype == "showt") then
		EA_DEBUGFLAG11 = false;
		EA_DEBUGFLAG21 = false;
		EA_LISTSEC_TARGET = 0;
		if (EA_DEBUGFLAG2) then
			EA_DEBUGFLAG2 = false;
			RtnMsg = F_EA..EA_XCMD_TARGETLIST..F_OFF;
		else
			EA_DEBUGFLAG2 = true;
			EA_LISTSEC_TARGET = listSec;
			RtnMsg = F_EA..EA_XCMD_TARGETLIST..F_ON;
			if EA_LISTSEC_TARGET > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_TARGET.." secs)" end;
			EAFun_ClearSpellScrollFrame();
			EA_Version_Frame:Show();
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg);

	elseif (cmdtype == "showcast" or cmdtype == "showc") then
		EA_DEBUGFLAG11 = false;
		EA_DEBUGFLAG21 = false;
		if (EA_DEBUGFLAG3) then
			EA_DEBUGFLAG3 = false;
			RtnMsg = F_EA..EA_XCMD_CASTSPELL..F_OFF;
		else
			EA_DEBUGFLAG3 = true;
			RtnMsg = F_EA..EA_XCMD_CASTSPELL..F_ON;
			EAFun_ClearSpellScrollFrame();
			EA_Version_Frame:Show();
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg);

	elseif (cmdtype == "showautoadd" or cmdtype == "showa") then
		EA_DEBUGFLAG1 = false;
		EA_DEBUGFLAG2 = false;
		EA_DEBUGFLAG3 = false;
		EA_DEBUGFLAG21 = false;
		EA_LISTSEC_SELF = 60;
		if (EA_DEBUGFLAG11) then
			EA_DEBUGFLAG11 = false;
			RtnMsg = F_EA..EA_XCMD_AUTOADD_SELFLIST..F_OFF;
		else
			EA_DEBUGFLAG11 = true;
			RtnMsg = F_EA..EA_XCMD_AUTOADD_SELFLIST..F_ON;
			if listSec > 0 then EA_LISTSEC_SELF = listSec end;
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end;
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg);

	elseif (cmdtype == "showenvadd" or cmdtype == "showe") then
		EA_DEBUGFLAG1 = false;
		EA_DEBUGFLAG2 = false;
		EA_DEBUGFLAG3 = false;
		EA_DEBUGFLAG11 = false;
		EA_LISTSEC_SELF = 60;
		if (EA_DEBUGFLAG21) then
			EA_DEBUGFLAG21 = false;
			RtnMsg = F_EA..EA_XCMD_ENVADD_SELFLIST..F_OFF;
		else
			EA_DEBUGFLAG21 = true;
			RtnMsg = F_EA..EA_XCMD_ENVADD_SELFLIST..F_ON;
			if listSec > 0 then EA_LISTSEC_SELF = listSec end;
			if EA_LISTSEC_SELF > 0 then RtnMsg = RtnMsg.." ("..EA_LISTSEC_SELF.." secs)" end;
		end
		DEFAULT_CHAT_FRAME:AddMessage(RtnMsg);

	elseif (cmdtype == "lookup") or (cmdtype == "l")then
		EventAlert_Lookup(para1, false);

	elseif (cmdtype == "lookupfull") or (cmdtype == "lf") then
		EventAlert_Lookup(para1, true);

	elseif (cmdtype == "list") then
		EA_Version_Frame_HeaderText:SetText(EA_XCMD_DEBUG_P0);
		EA_Version_ScrollFrame_EditBox:Hide();
		EA_Version_Frame:Show();

	elseif (cmdtype == "print") then
		-- table.foreach(EA_ClassAltSpellName,
		-- function(i, v)
		--  if v == nil then v = "nil" end;
		--  DEFAULT_CHAT_FRAME:AddMessage("["..i.."]EA_ClassAltSpellName["..i.."]="..EA_ClassAltSpellName[i].." v="..v);
		-- end
		-- )
		-- EAFun_CreateVersionFrame_ScrollEditBox();
		-- EA_Version_Frame_HeaderText:SetText("Test");
		-- EA_Version_Frame:Show();
		-- print ("go print");
		-- for  i, v in pairsByKeys(EA_Items) do
		--  print (i);
		--  --if v.enable then
		--  --  print ("enable T");
		--  --else
		--  --  print ("enable F");
		--  --end
		-- end

	-- elseif (cmdtype == "play") then
	--  EventAlert_ExecutionFrame:SetAlpha(1);
	--  EventAlert_ExecutionFrame:Show();
	--  iEAEXF_FrameCount = 0;
	--  iEAEXF_Prefraction = 0;
	--  EAEXF_AnimateOut(EventAlert_ExecutionFrame);

	else
		if cmdtype == "help" then MoreHelp = true end;
		DEFAULT_CHAT_FRAME:AddMessage(F_EA..EA_XCMD_VER..EA_Config.Version);
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.TITLE);
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.OPT);
		DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_CMDHELP.HELP);

		for i, v in ipairs(EA_XCMD_CMDHELP["SHOW"]) do
			if i == 1 then
				if EA_DEBUGFLAG1 then v = v..EA_XCMD_SELFLIST..F_ON else v = v..EA_XCMD_SELFLIST..F_OFF end;
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWT"]) do
			if i == 1 then
				if EA_DEBUGFLAG2 then v = v..EA_XCMD_TARGETLIST..F_ON else v = v..EA_XCMD_TARGETLIST..F_OFF end;
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWC"]) do
			if i == 1 then
				if EA_DEBUGFLAG3 then v = v..EA_XCMD_CASTSPELL..F_ON else v = v..EA_XCMD_CASTSPELL..F_OFF end;
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWA"]) do
			if i == 1 then
				if EA_DEBUGFLAG11 then v = v..EA_XCMD_AUTOADD_SELFLIST..F_ON else v = v..EA_XCMD_AUTOADD_SELFLIST..F_OFF end;
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["SHOWE"]) do
			if i == 1 then
				if EA_DEBUGFLAG21 then v = v..EA_XCMD_ENVADD_SELFLIST..F_ON else v = v..EA_XCMD_ENVADD_SELFLIST..F_OFF end;
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LIST"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUP"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
		for i, v in ipairs(EA_XCMD_CMDHELP["LOOKUPFULL"]) do
			if i == 1 then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			elseif MoreHelp then
				DEFAULT_CHAT_FRAME:AddMessage(v);
			end
		end
	end
end


-- The URLs of update
function EventAlert_ShowVerURL(SiteIndex)
	local VerUrl = "";
	VerUrl = EA_XOPT_VERURL1;
	if SiteIndex ~= 1 then VerUrl = EA_XOPT_VERURL2 end;

	ChatFrame1EditBox:SetText(VerUrl)
	if not ChatFrame1EditBox:IsShown() then ChatFrame1EditBox:Show() end;
	ChatFrame1EditBox:HighlightText()
end


function EAFun_CreateVersionFrame_ScrollEditBox()
	local framewidth = EA_Version_Frame:GetWidth()-45;
	local frameheight = EA_Version_Frame:GetHeight()-70;
	local panel3 = _G["EA_Version_ScrollFrame"];
	if panel3 == nil then
		panel3 = CreateFrame("ScrollFrame", "EA_Version_ScrollFrame", EA_Version_Frame, "UIPanelScrollFrameTemplate");
	end
	local scc = _G["EA_Version_ScrollFrame_List"];
	if scc == nil then
		scc = CreateFrame("Frame", "EA_Version_ScrollFrame_List", panel3);
		panel3:SetScrollChild(scc);
		panel3:SetPoint("TOPLEFT", EA_Version_Frame, "TOPLEFT", 15, -30);
		scc:SetPoint("TOPLEFT", panel3, "TOPLEFT", 0, 0);
		panel3:SetWidth(framewidth);
		panel3:SetHeight(frameheight);
		scc:SetWidth(framewidth);
		scc:SetHeight(frameheight);
		panel3:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		panel3:SetScript("OnVerticalScroll", function()  end);
		panel3:EnableMouse(true);
		panel3:SetVerticalScroll(0);
		panel3:SetHorizontalScroll(0);
	end
	local etb1 = _G["EA_Version_ScrollFrame_EditBox"];
	if etb1 == nil then
		etb1 = CreateFrame("EditBox", "EA_Version_ScrollFrame_EditBox", scc);
		etb1:SetPoint("TOPLEFT",0,0);
		etb1:SetFontObject(ChatFontNormal);
		etb1:SetWidth(framewidth);
		etb1:SetHeight(frameheight);
		etb1:SetMultiLine();
		etb1:SetMaxLetters(0);
		etb1:SetAutoFocus(false);
	end
end

local function EAFun_ExtendExecution_4505(EAItems)
	for index1, value1 in pairsByKeys(EAItems) do
		if EAItems[index1] ~= nil then EAItems[index1].Execution = 0 end;
	end
	return EAItems;
end
local function EAFun_ChangeSavedVariblesFormat_4505(EAItems, EASelf)
	if EAItems == nil then EAItems = { } end;
	for index1, value1 in pairsByKeys(EAItems) do
		for index2, value2 in pairsByKeys(EAItems[index1]) do
			if (EASelf) then
				EAItems[index1][index2] = {enable=value2, self=true,};
			else
				EAItems[index1][index2] = {enable=value2,};
			end
		end
	end
	return EAItems;
end

function EventAlert_VersionCheck()
	local EA_TocVersion = GetAddOnMetadata("EventAlertMod", "Version");
	local F_EA = "\124cffFFFF00EventAlertMod\124r";

	EAFun_CreateVersionFrame_ScrollEditBox();
	EA_Version_Frame_Okay:SetText(EA_XOPT_OKAY);
	if (EA_Config.Version ~= EA_TocVersion and EA_Config.Version ~= nil) then
		if (EA_Config.Version < "4.5.01" and EA_TocVersion < "4.5.04") then
			-- Ver 4.5.01 is For WOW 4.0.1+
			-- Many WOW 3.x spells are canceled or integrated,
			-- so the saved-spells should be clear, and to load the new spells.
			EA_Items = { };
			EA_AltItems = { };
			EA_TarItems = { };
			EA_ScdItems = { };
		end
		if (EA_Config.Version < "4.5.05" and EA_TocVersion <= "4.6.01a") then
			-- EventAlert SpellArray Format Change
			-- from true/false to attribute values
			-- so, it should formate old parameters to new
			EA_Pos = EAFun_ExtendExecution_4505(EA_Pos);
			EA_Items = EAFun_ChangeSavedVariblesFormat_4505(EA_Items, false);
			EA_AltItems = EAFun_ChangeSavedVariblesFormat_4505(EA_AltItems, false);
			EA_TarItems = EAFun_ChangeSavedVariblesFormat_4505(EA_TarItems, true);
			EA_ScdItems = EAFun_ChangeSavedVariblesFormat_4505(EA_ScdItems, false);
		end
		EA_Config.Version = EA_TocVersion;
		--if (EA_XLOAD_NEWVERSION_LOAD ~= "") then
		--	EA_Version_ScrollFrame_EditBox:SetText(F_EA..EA_XCMD_VER..EA_Config.Version.."\n\n\n"..EA_XLOAD_NEWVERSION_LOAD);
		--	EA_Version_Frame:Show();
		--end
		EventAlert_LoadClassSpellArray(9);
	elseif (EA_Config.Version == nil) then
		EA_Items = { };
		EA_AltItems = { };
		EA_TarItems = { };
		EA_ScdItems = { };
		EA_Config.Version = EA_TocVersion;
		--if (EA_XLOAD_FIRST_LOAD ~= "") then
		--	EA_Version_ScrollFrame_EditBox:SetText(F_EA..EA_XCMD_VER..EA_Config.Version.."\n\n\n"..EA_XLOAD_FIRST_LOAD..EA_XLOAD_NEWVERSION_LOAD)
		--	EA_Version_Frame:Show();
		--end
		EventAlert_LoadClassSpellArray(9);
	elseif (EAFun_GetCountOfTable(EA_Items[EA_playerClass]) <= 0) then
		EventAlert_LoadClassSpellArray(9);
	end

	-- After confirm the version, set the VersionText in the EA_Options_Frame.
	EA_Options_Frame_VersionText:SetText("Ver:\124cffFFFFFF"..EA_Config.Version.."\124r");
end


function insertBuffValue(tab, value)
	local isExist = false;
	for pos, name in ipairs(tab) do
		if (name == value) then
			isExist = true;
		end
	end
	if not isExist then table.insert(tab, value) end;
end

function removeBuffValue(tab, value)
	for pos, name in ipairs(tab) do
		if (name == value) then
			table.remove(tab, pos)
		end
	end
end

function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0 -- iterator variable
		local iter = function () -- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end

function EAFun_GetFormattedTime(timeLeft)
	local formattedTime = "";
	if timeLeft <= 60 then
		formattedTime = tostring(floor(timeLeft));
	else
		formattedTime = format("%d:%02d", floor(timeLeft/60), timeLeft % 60);
	end
	return formattedTime;
end

function MyPrint(info)
	DEFAULT_CHAT_FRAME:AddMessage(info);
end

function EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_count, SC_RedSecText)
	eaf.spellTimer:ClearAllPoints();
	if ((SC_RedSecText == nil) or (SC_RedSecText <= 0)) then SC_RedSecText = -1 end;
	if (EA_timeLeft > 0) then
		if (EA_Config.ChangeTimer == true) then
			eaf.spellTimer:SetPoint("CENTER", 0, 0);
		else
			eaf.spellTimer:SetPoint("TOP", 0, 20);
		end
		-- eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
		-- eaf.spellTimer:SetText(EAFun_GetFormattedTime(EA_timeLeft));
		if (EA_timeLeft < SC_RedSecText + 1) then
			if (not eaf.redsectext) then
				eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize+5, "OUTLINE");
				eaf.spellTimer:SetTextColor(1, 0, 0);
				eaf.redsectext = true;
				eaf.whitesectext = false;
			end
		else
			if (not eaf.whitesectext) then
				eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				eaf.spellTimer:SetTextColor(1, 1, 1);
				eaf.redsectext = false;
				eaf.whitesectext = true;
			end
		end
		eaf.spellTimer:SetText(EAFun_GetFormattedTime(EA_timeLeft));
	end

	eaf.spellStack:ClearAllPoints();
	if (EA_count > 1) then
		eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 0);
		eaf.spellStack:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.StackFontSize, "OUTLINE");
		eaf.spellStack:SetFormattedText("%d", EA_count);
	else
		eaf.spellStack:SetFormattedText("");
	end
end

function EventAlert_UpdateComboPoint()
	local iComboPoint = GetComboPoints("player", "target");
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;
		local eaf = _G["EAFrameSpec_10000"];
		if eaf ~= nil then
			if iComboPoint > 0 then
				EA_SpecFrame_Target = true;
				eaf:ClearAllPoints();
				eaf:SetPoint(EA_Position.TarAnchor, UIParent, EA_Position.TarAnchor, EA_Position.Tar_xOffset - xOffset, EA_Position.Tar_yOffset - yOffset);

				if (EA_Config.ShowName) then
					eaf.spellName:SetText(EA_XSPECINFO_COMBOPOINT);
					local SfontName, SfontSize = eaf.spellName:GetFont();
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf.spellName:SetText("");
				end

				EAFun_SetCountdownStackText(eaf, iComboPoint, 0, -1);
				eaf:Show();
				if (iComboPoint >= 5) then ActionButton_ShowOverlayGlow(eaf) end;
			else
				ActionButton_HideOverlayGlow(eaf);
				EA_SpecFrame_Target = false;
				eaf:Hide();
			end
			EventAlert_TarPositionFrames();
		end
	end
end


function EventAlert_UpdateEclipse()
	local iUnitPower = UnitPower("player", 8);
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;
		local eaf1 = _G["EAFrameSpec_10081"];
		local eaf2 = _G["EAFrameSpec_10082"];
		if eaf1 ~= nil and eaf2 ~= nil then
			if iUnitPower > 0 then
				ActionButton_HideOverlayGlow(eaf1);
				EA_SpecFrame_Self = true;
				eaf1:ClearAllPoints();
				eaf2:ClearAllPoints();
				eaf1:Hide();
				eaf2:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);

				if (EA_Config.ShowName == true) then
					eaf2.spellName:SetText(EA_XSPECINFO_ECLIPSEORG);
					local SfontName, SfontSize = eaf2.spellName:GetFont();
					eaf2.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf2.spellName:SetText("");
				end

				eaf2.spellTimer:ClearAllPoints();
				if (EA_Config.ChangeTimer == true) then
					eaf2.spellTimer:SetPoint("CENTER", 0, 0);
				else
					eaf2.spellTimer:SetPoint("TOP", 0, 20);
				end
				eaf2.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				eaf2.spellTimer:SetText(iUnitPower);
				eaf2:Show();
				if (iUnitPower >= 100) then ActionButton_ShowOverlayGlow(eaf2) end;
			elseif iUnitPower < 0 then
				ActionButton_HideOverlayGlow(eaf2);
				EA_SpecFrame_Self = true;
				eaf1:ClearAllPoints();
				eaf2:ClearAllPoints();
				eaf1:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);
				eaf2:Hide();

				if (EA_Config.ShowName == true) then
					eaf1.spellName:SetText(EA_XSPECINFO_ECLIPSE);
					local SfontName, SfontSize = eaf1.spellName:GetFont();
					eaf1.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf1.spellName:SetText("");
				end

				eaf1.spellTimer:ClearAllPoints();
				if (EA_Config.ChangeTimer == true) then
					eaf1.spellTimer:SetPoint("CENTER", 0, 0);
				else
					eaf1.spellTimer:SetPoint("TOP", 0, 20);
				end
				eaf1.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				eaf1.spellTimer:SetText(-1 * iUnitPower);
				eaf1:Show();
				if (iUnitPower <= -100) then ActionButton_ShowOverlayGlow(eaf1) end;
			else
				ActionButton_HideOverlayGlow(eaf1);
				ActionButton_HideOverlayGlow(eaf2);
				EA_SpecFrame_Self = false;
				eaf1:Hide();
				eaf2:Hide();
			end
			EventAlert_PositionFrames();
		end
	end
end


function EventAlert_UpdateSinglePower(iPowerType)
	local iUnitPower = UnitPower("player", iPowerType);
	local iPowerName = "";
	local iFrameIndex = 10000 + iPowerType * 10;
	local iGrowPower = 3;
	if iPowerType == 6 then iPowerName = EA_XSPECINFO_RUNICPOWER end;
	if iPowerType == 7 then iPowerName = EA_XSPECINFO_SOULSHARDS end;
	if iPowerType == 9 then iPowerName = EA_XSPECINFO_HOLYPOWER end;
	if (EA_Config.ShowFrame == true) then
		EA_Main_Frame:ClearAllPoints();
		EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
		local prevFrame = "EA_Main_Frame";
		local xOffset = 100 + EA_Position.xOffset;
		local yOffset = 0 + EA_Position.yOffset;
		local eaf = _G["EAFrameSpec_"..iFrameIndex];
		if eaf ~= nil then
			if iUnitPower > 0 then
				EA_SpecFrame_Self = true;
				eaf:ClearAllPoints();
				eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);

				if (EA_Config.ShowName == true) then
					eaf.spellName:SetText(iPowerName);
					local SfontName, SfontSize = eaf.spellName:GetFont();
					eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
				else
					eaf.spellName:SetText("");
				end

				eaf.spellTimer:ClearAllPoints();
				if (EA_Config.ChangeTimer == true) then
					eaf.spellTimer:SetPoint("CENTER", 0, 0);
				else
					eaf.spellTimer:SetPoint("TOP", 0, 20);
				end
				eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				eaf.spellTimer:SetText(iUnitPower);
				eaf:Show();
				if (iPowerType == 9 and iUnitPower >=3) then ActionButton_ShowOverlayGlow(eaf) end;
			else
				ActionButton_HideOverlayGlow(eaf);
				EA_SpecFrame_Self = false;
				eaf:Hide();
			end
			EventAlert_PositionFrames();
		end
	end
end


function EventAlert_UpdateLifebloom(EA_Unit)
	local iFrameIndex = 33763;
	local fNewToShow = false;
	local eaf = nil;
	if (EA_Unit ~= "") then
		if (EA_Config.ShowFrame == true) then
			EA_Main_Frame:ClearAllPoints();
			EA_Main_Frame:SetPoint(EA_Position.Anchor, UIParent, EA_Position.relativePoint, EA_Position.xLoc, EA_Position.yLoc);
			local prevFrame = "EA_Main_Frame";
			local xOffset = 100 + EA_Position.xOffset;
			local yOffset = 0 + EA_Position.yOffset;
			eaf = _G["EAFrameSpec_"..iFrameIndex];
			if eaf ~= nil then
				for i=1,40 do
					local _, _, _, count, _, _, expirationTime, _, _, _, spellId = UnitBuff(EA_Unit, i)
					if (not spellId) then
						break;
					end
					if (spellId == 33763) then
						local iShiftFormID = GetShapeshiftFormID();
						fNewToShow = false;
						if (iShiftFormID == nil) then
							fNewToShow = true;
						elseif (iShiftFormID == 2) then -- Life of tree form, multi lifebloom
							if (count > EA_SpecFrame_Lifebloom.Stack) then
								fNewToShow = true;
							elseif (count == EA_SpecFrame_Lifebloom.Stack and expirationTime >= EA_SpecFrame_Lifebloom.ExpireTime) then
								fNewToShow = true;
							end
						end

						if (fNewToShow) then
							EA_SpecFrame_Lifebloom.UnitID = EA_Unit;
							EA_SpecFrame_Lifebloom.UnitName = UnitName(EA_Unit);
							EA_SpecFrame_Lifebloom.ExpireTime = expirationTime;
							EA_SpecFrame_Lifebloom.Stack = count;
						end
						break;
					end
				end

				if (fNewToShow) then
					-- print ("fNewToShow = true");
					EA_SpecFrame_Self = true;
					eaf:ClearAllPoints();
					eaf:SetPoint(EA_Position.Anchor, prevFrame, EA_Position.Anchor, -1 * xOffset, -1 * yOffset);
					eaf:SetWidth(EA_Config.IconSize);
					eaf:SetHeight(EA_Config.IconSize);

					if (EA_Config.ShowName == true) then
						eaf.spellName:SetText(EA_SpecFrame_Lifebloom.UnitName);
						local SfontName, SfontSize = eaf.spellName:GetFont();
						eaf.spellName:SetFont(SfontName, EA_Config.SNameFontSize);
					else
						eaf.spellName:SetText("");
					end
					eaf:SetScript("OnUpdate", EventAlert_OnLifebloomUpdate);
					eaf:Show();
				end
				EventAlert_PositionFrames();
			end
		end
	else
		-- print ("fNewToShow = false 1");
		EA_SpecFrame_Lifebloom.UnitID = "";
		EA_SpecFrame_Lifebloom.UnitName = "";
		EA_SpecFrame_Lifebloom.ExpireTime = 0;
		EA_SpecFrame_Lifebloom.Stack = 0;
		EA_SpecFrame_Self = false;
		eaf = _G["EAFrameSpec_"..iFrameIndex];
		if eaf ~= nil then
			if eaf:IsVisible() then
				eaf:SetScript("OnUpdate", nil);
				eaf:Hide();
			end
		end
		EventAlert_PositionFrames();
	end
end


function EventAlert_OnLifebloomUpdate()
	local iFrameIndex = 33763;
	local eaf = _G["EAFrameSpec_"..iFrameIndex];
	if eaf ~= nil then
		local EA_timeLeft = 0;
		if (EA_SpecFrame_Lifebloom.ExpireTime ~= nil) then
			EA_timeLeft = EA_SpecFrame_Lifebloom.ExpireTime - GetTime();
		end

		if EA_timeLeft > 0 then
			if (EA_Config.ShowTimer) then
				EAFun_SetCountdownStackText(eaf, EA_timeLeft, EA_SpecFrame_Lifebloom.Stack, -1);
				if EA_timeLeft < 4 then 
				 	eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize+5, "OUTLINE");
					eaf.spellTimer:SetTextColor(1, 0, 0);
				else
				 	eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
					eaf.spellTimer:SetTextColor(1, 1, 1);
				end
			end
		else
			-- print ("fNewToShow = false 2");
			EA_SpecFrame_Self = false;
			eaf:SetScript("OnUpdate", nil);
			eaf:Hide();
		end
	end
end

function EventAlert_CheckExecution()
	if (EA_Position.Execution > 0) then
		local iDead = UnitIsDeadOrGhost("target");
		local iEnemy = UnitIsEnemy("player", "target");
		local iLevel = 3;
		if EA_Position.PlayerLv2BOSS then iLevel = 2 end;
		if ((iDead ~= 1) and (iEnemy == 1)) then
			local iLvPlayer, iLvTarget = UnitLevel("player"), UnitLevel("target");
			if ((iLvTarget == -1) or (iLvTarget - iLvPlayer >= iLevel)) then
				local iHppTarget = (UnitHealth("target") * 100) / UnitHealthMax("target");
				if (iHppTarget <= EA_Position.Execution) then
					if (not iEAEXF_AlreadyAlert) then
						EventAlert_ExecutionFrame:SetAlpha(1);
						EventAlert_ExecutionFrame:Show();
						iEAEXF_FrameCount = 0;
						iEAEXF_Prefraction = 0;
						EAEXF_AnimateOut(EventAlert_ExecutionFrame);
						iEAEXF_AlreadyAlert = true;
					end
				else
					iEAEXF_AlreadyAlert = false;
				end
			end
		else
			iEAEXF_AlreadyAlert = false;
		end
	end
end


function EventAlert_Lookup(para1, fullmatch)
	local sFMatch = "";
	local sName = "";
	local iCount = 0;
	local sSpellLink = "";
	local fGoPrint = false;
	if fullmatch then sFMatch = " / "..EA_XLOOKUP_START2 end;
	DEFAULT_CHAT_FRAME:AddMessage(EA_XLOOKUP_START1..": [\124cffFFFF00"..para1.."\124r]"..sFMatch);
	EAFun_ClearSpellScrollFrame();
	for i=1,99999 do
		sName = GetSpellInfo(i);
		fGoPrint = false;
		if (sName ~= nil) then
			if (fullmatch) then
				if (sName == para1) then fGoPrint = true end;
			else
				if (strfind(sName, para1)) then fGoPrint = true end;
			end
			if (fGoPrint) then
				sSpellLink = GetSpellLink(i);
				if (sSpellLink ~= nil) then
					iCount = iCount + 1;
					-- DEFAULT_CHAT_FRAME:AddMessage("["..tostring(iCount).."]\124cffFFFF00"..EA_XCMD_DEBUG_P2.."\124r="..tostring(i).." / \124cffFFFF00"..EA_XCMD_DEBUG_P1.."\124r="..sSpellLink);
					EAFun_AddSpellToScrollFrame(i, "");
				end
			end
		end
	end
	EA_Version_Frame:Show();
	DEFAULT_CHAT_FRAME:AddMessage(EA_XLOOKUP_RESULT1..": \124cffFFFF00"..tostring(iCount).."\124r"..EA_XLOOKUP_RESULT2);
end


function EAFun_AddSpellToScrollFrame(SpellID, OtherMessage)
	SpellID = tonumber(SpellID);
	if OtherMessage == nil then OtherMessage = "" end;
	if EA_ShowScrollSpells[SpellID] == nil then
		EA_ShowScrollSpells[SpellID] = true;
		local EA_name, EA_rank, EA_icon = GetSpellInfo(SpellID);
		if EA_name == nil then EA_name = "" end;
		if EA_rank == nil then EA_rank = "" end;

		local f1 = _G["EA_Version_ScrollFrame_Icon_"..SpellID];
		if f1 == nil then
			EA_ShowScrollSpell_YPos = EA_ShowScrollSpell_YPos - 25;
			local ShowScrollIcon = CreateFrame("Frame", "EA_Version_ScrollFrame_Icon_"..SpellID, EA_Version_ScrollFrame_List);
			ShowScrollIcon:SetWidth(25);
			ShowScrollIcon:SetHeight(25);
			ShowScrollIcon:SetPoint("TOPLEFT", 0, EA_ShowScrollSpell_YPos);
			ShowScrollIcon:SetBackdrop({bgFile = EA_icon});
		else
			if (not f1:IsShown()) then
				EA_ShowScrollSpell_YPos = EA_ShowScrollSpell_YPos - 25;
				f1:SetPoint("TOPLEFT", 0, EA_ShowScrollSpell_YPos);
				f1:Show();
			end
		end

		local framewidth = EA_Version_Frame:GetWidth()+50;
		local f2 = _G["EA_Version_ScrollFrame_EditBox_"..SpellID];
		if f2 == nil then
			local ShowScrollEditBox = CreateFrame("EditBox", "EA_Version_ScrollFrame_EditBox_"..SpellID, EA_Version_ScrollFrame_List);
			ShowScrollEditBox:SetPoint("TOPLEFT", 30, EA_ShowScrollSpell_YPos);
			ShowScrollEditBox:SetFontObject(ChatFontNormal);
			ShowScrollEditBox:SetWidth(framewidth);
			ShowScrollEditBox:SetHeight(25);
			ShowScrollEditBox:SetMaxLetters(0);
			ShowScrollEditBox:SetAutoFocus(false);
			if (EA_rank == "") then
				-- ShowScrollEditBox:SetText(EA_name.." ["..SpellID.."]1".." ["..SpellID.."]2".." ["..SpellID.."]3".." ["..SpellID.."]4".." ["..SpellID.."]5".." ["..SpellID.."]6".." ["..SpellID.."]7".." ["..SpellID.."]8".." ["..SpellID.."]9"..OtherMessage);
				ShowScrollEditBox:SetText(EA_name.." ["..SpellID.."]"..OtherMessage);
			else
				ShowScrollEditBox:SetText(EA_name.."("..EA_rank..") ["..SpellID.."]"..OtherMessage);
			end
			local function ShowScrollEditBoxGameToolTip()
				ShowScrollEditBox:SetTextColor(0, 1, 1);
				GameTooltip:SetOwner(ShowScrollEditBox, "ANCHOR_TOPLEFT");
				GameTooltip:SetSpellByID(SpellID);
			end
			local function HideScrollEditBoxGameToolTip()
				ShowScrollEditBox:SetTextColor(1, 1, 1);
				ShowScrollEditBox:HighlightText(0,0);
				ShowScrollEditBox:ClearFocus();
				GameTooltip:Hide();
			end
			ShowScrollEditBox:SetScript("OnEnter", ShowScrollEditBoxGameToolTip);
			ShowScrollEditBox:SetScript("OnLeave", HideScrollEditBoxGameToolTip);
		else
			if (not f2:IsShown()) then
				f2:SetPoint("TOPLEFT", 30, EA_ShowScrollSpell_YPos);
				f2:Show();
			end
		end
	end
end


function EAFun_ClearSpellScrollFrame()
	EA_Version_Frame_HeaderText:SetText(EA_XCMD_DEBUG_P0);
	-- EA_Version_ScrollFrame_EditBox:SetText("");
	EA_Version_ScrollFrame_EditBox:Hide();
	table.foreach(EA_ShowScrollSpells,
	function(i, v)
		-- MyPrint ("Clear:["..i.."]");
		local f1 = _G["EA_Version_ScrollFrame_Icon_"..i];
		if f1 ~= nil then
			f1:Hide();
			f1 = nil;
		end
		local f2 = _G["EA_Version_ScrollFrame_EditBox_"..i];
		if f2 ~= nil then
			f2:Hide();
			f2 = nil;
		end
	end)
	EA_ShowScrollSpells = { };
	EA_ShowScrollSpell_YPos = 25;
end


function EAFun_GetCountOfTable(EAItems)
	local iCount = 0;
	if (EAItems ~= nil) then
		for i, v in pairsByKeys(EAItems) do
			iCount = iCount + 1;
		end
	end
	return iCount;
end

function EAFun_GetUnitIDByName(EA_UnitName)
	local fNotFound, iIndex = true, 1;
	local sUnitID, sUnitName = "", "";

	if UnitInRaid("player") then
		iIndex = 1;
		while (fNotFound and iIndex <= 40) do
			sUnitID = "raid"..iIndex;
			sUnitName = UnitName(sUnitID);
			if EA_UnitName == sUnitName then fNotFound = false end;
			iIndex = iIndex + 1;
		end
	elseif GetNumPartyMembers() > 0 then
		iIndex = 1;
		while (fNotFound and iIndex <= 4) do
			sUnitID = "party"..iIndex;
			sUnitName = UnitName(sUnitID);
			if EA_UnitName == sUnitName then fNotFound = false end;
			iIndex = iIndex + 1;
		end
	end

	if (fNotFound) then
		return "";
	else
		return sUnitID;
	end
end

function EAFun_HookTooltips()
	hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...)
		local id = select(11,UnitBuff(...))
		if id then
			self:AddDoubleLine(EX_XCLSALERT_SPELL,id)
			self:Show()
		end
	end)

	hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...)
		local id = select(11,UnitDebuff(...))
		if id then
			self:AddDoubleLine(EX_XCLSALERT_SPELL,id)
			self:Show()
		end
	end)

	hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...)
		local id = select(11,UnitAura(...))
		if id then
			self:AddDoubleLine(EX_XCLSALERT_SPELL,id)
			self:Show()
		end
	end)

	hooksecurefunc("SetItemRef", function(link, text, button, chatFrame)
		if string.find(link,"^spell:") then
			local id = string.sub(link,7)
			ItemRefTooltip:AddDoubleLine(EX_XCLSALERT_SPELL,id)
			ItemRefTooltip:Show()
		end
	end)

	GameTooltip:HookScript("OnTooltipSetSpell", function(self)
		local id = select(3,self:GetSpell())
		if id then
			self:AddDoubleLine(EX_XCLSALERT_SPELL,id)
			self:Show()
		end
	end)
end
