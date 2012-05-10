local mod	= DBM:NewMod(333, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 7358 $"):sub(12, -3))
mod:SetCreatureID(56173)
mod:SetModelID(40087)
mod:SetZone()
mod:SetUsedIcons(8)

mod:RegisterCombat("yell", L.Pull)
mod:SetMinCombatTime(20)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_SUMMON",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED"
)

local warnMutated				= mod:NewSpellAnnounce("ej4112", 3, 467)
local warnImpale				= mod:NewTargetAnnounce(106400, 3, nil, mod:IsTank() or mod:IsHealer())
local warnElementiumBolt		= mod:NewSpellAnnounce(105651, 4)
local warnTentacle				= mod:NewSpellAnnounce(105551, 3)
local warnHemorrhage			= mod:NewSpellAnnounce(105863, 3)
local warnCataclysm				= mod:NewCastAnnounce(106523, 4)
local warnPhase2				= mod:NewPhaseAnnounce(2, 3)
local warnFragments				= mod:NewSpellAnnounce("ej4115", 4, 106708)
local warnTerror				= mod:NewSpellAnnounce("ej4117", 4, 106765)
local warnShrapnel				= mod:NewTargetAnnounce(109598, 3)
local warnParasite				= mod:NewTargetAnnounce(108649, 4)

local specWarnMutated			= mod:NewSpecialWarningSwitch("ej4112", true)
local specWarnImpale			= mod:NewSpecialWarningYou(106400)
local specWarnImpaleOther		= mod:NewSpecialWarningTarget(106400, mod:IsTank() or mod:IsHealer())
local specWarnElementiumBolt	= mod:NewSpecialWarningSpell(105651, nil, nil, nil, true)
local specWarnTentacle			= mod:NewSpecialWarningSwitch("ej4103", true)
local specWarnHemorrhage		= mod:NewSpecialWarningSpell(105863, mod:IsDps())
local specWarnFragments			= mod:NewSpecialWarningSpell("ej4115", true)
local specWarnTerror			= mod:NewSpecialWarningSpell("ej4117", true)
local specWarnShrapnel			= mod:NewSpecialWarningYou(109598)
local yellShrapnel				= mod:NewYell(109598)
local specWarnParasite			= mod:NewSpecialWarningYou(108649)
local specWarnUnstableCorruption			= mod:NewSpecialWarningSpell(108813)
local yellParasite				= mod:NewYell(108649)
local specWarnCongealingBlood	= mod:NewSpecialWarningSwitch("ej4350", true)

local timerImpale				= mod:NewTargetTimer(49.5, 106400, nil, false)
local timerImpaleCD				= mod:NewCDTimer(35, 109633, nil, mod:IsTank() or mod:IsHealer())
local timerElementiumCast		= mod:NewCastTimer(7.5, 105651)
local timerElementiumBlast		= mod:NewCastTimer(8, 109600)
local timerElementiumBoltCD		= mod:NewNextTimer(55.5, 105651)
local timerHemorrhageCD			= mod:NewCDTimer(100.5, 105863)
local timerCataclysm			= mod:NewCastTimer(60, 106523)
local timerCataclysmCD			= mod:NewCDTimer(130.5, 106523)
local timerFragmentsCD			= mod:NewNextTimer(90, "ej4115", nil, nil, nil, 106708)
local timerTerrorCD				= mod:NewNextTimer(90, "ej4117", nil, nil, nil, 106765)
local timerMutantCD		= mod:NewTimer(11, "TimerMutant", 109454)
local timerShrapnel				= mod:NewCastTimer(6, 109598)
local timerCrushCD	 = mod:NewNextTimer(7, 106382)
local timerParasite				= mod:NewTargetTimer(10, 108649)
local timerParasiteCD			= mod:NewCDTimer(60, 108649)
local timerUnstableCorruption	= mod:NewCastTimer(10, 108813)

local berserkTimer				= mod:NewBerserkTimer(900)

mod:AddBoolOption("RangeFrame", true)
mod:AddBoolOption("SetIconOnParasite", true)

local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

local firstAspect = true
local engageCount = 0
local phase2 = false
local playerGUID = 0
local shrapnelTargets = {}
local lastBlood = 0

local debuffFilter
do
	debuffFilter = function(uId)
		return UnitDebuff(uId, GetSpellInfo(108649))
	end
end

function mod:updateRangeFrame()
	if not self.Options.RangeFrame then return end
	if UnitDebuff("player", GetSpellInfo(108649)) then
		DBM.RangeCheck:Show(10, nil)
	else
		DBM.RangeCheck:Show(10, debuffFilter)
	end
end

local function warnShrapnelTargets()
	warnShrapnel:Show(table.concat(shrapnelTargets, "<, >"))
	table.wipe(shrapnelTargets)
end

function mod:OnCombatStart(delay)
	firstAspect = true
	engageCount = 0
	lastBlood = 0
	phase2 = false
	playerGUID = 0
	table.wipe(shrapnelTargets)
	berserkTimer:Start(-delay)
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(107018) then
		if firstAspect then
			firstAspect = false
			timerImpaleCD:Start(22)
			timerElementiumBoltCD:Start(40.5)
			if self:IsDifficulty("heroic10", "heroic25") then
				timerHemorrhageCD:Start(55.5)
				timerParasiteCD:Start(11)
			else
				timerHemorrhageCD:Start(85.5)
			end
			timerCataclysmCD:Start(115.5)
			warnMutated:Schedule(11)
			specWarnMutated:Schedule(11)
			timerMutantCD:Start(11)
			sndWOP:Schedule(11, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..GetLocale().."\\mutant.mp3")
		else
			timerImpaleCD:Start(27.5)
			timerElementiumBoltCD:Start()
			if self:IsDifficulty("heroic10", "heroic25") then
				timerHemorrhageCD:Start(70.5)
				timerParasiteCD:Start(22)
			else
				timerHemorrhageCD:Start()
			end
			timerCataclysmCD:Start()
			warnMutated:Schedule(17)
			specWarnMutated:Schedule(17)
			timerMutantCD:Start(17)
			sndWOP:Schedule(17, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..GetLocale().."\\mutant.mp3")
		end	
	elseif args:IsSpellID(106523, 110042, 110043, 110044) then
		warnCataclysm:Show()
		timerCataclysm:Start()
	elseif args:IsSpellID(108813) then
		if UnitDebuff(playerGUID, GetSpellInfo(108646)) then--Check if player that got the debuff is in nozdormu's bubble at time of cast.
			timerUnstableCorruption:Start(15)
			if UnitBuff("player", GetSpellInfo(109642)) and not UnitIsDeadOrGhost("player") then--Check for Ysera's Presence
				sndWOP:Schedule(12, "Interface\\AddOns\\DBM-Core\\extrasounds\\clickshield.mp3")
			end
			sndWOP:Schedule(13, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(14, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(15, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		else
			timerUnstableCorruption:Start()
			if UnitBuff("player", GetSpellInfo(109642)) and not UnitIsDeadOrGhost("player") and not self:IsTank() then--Check for Ysera's Presence
				sndWOP:Schedule(7, "Interface\\AddOns\\DBM-Core\\extrasounds\\clickshield.mp3")
			end
			sndWOP:Schedule(8, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(9, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(10, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(105651) then
		warnElementiumBolt:Show()
		if not UnitBuff("player", GetSpellInfo(109624)) and not UnitIsDeadOrGhost("player") then--Check for Nozdormu's Presence
			specWarnElementiumBolt:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\boltappear.mp3")
			timerElementiumBlast:Start()
			sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\boomrun.mp3")
			sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		else
			timerElementiumCast:Start()	
			timerElementiumBlast:Start(18)
			specWarnElementiumBolt:Schedule(5.5)
			sndWOP:Schedule(5.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\boltappear.mp3")
			sndWOP:Schedule(15.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(16.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(17.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
	elseif args:IsSpellID(110063) and phase2 and self:IsInCombat() then
		self:SendSync("MadnessDown")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(106400) then
		warnImpale:Show(args.destName)
		timerImpale:Start(args.destName)
		timerImpaleCD:Start()
--		sndWOP:Schedule(29, "Interface\\AddOns\\DBM-Core\\extrasounds\\awaymutant.mp3")
		if args:IsPlayer() then
			specWarnImpale:Show()
			if not UnitBuff("player", GetSpellInfo(109642)) and not UnitIsDeadOrGhost("player") then--Check for Ysera's Presence
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\watchimpale.mp3")
			else
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\clickshield.mp3")
			end
		else
			specWarnImpaleOther:Show(args.destName)
			if self:IsTank() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\changemt.mp3")				
			else
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\watchimpale.mp3")
			end
		end
	elseif args:IsSpellID(106794, 110139, 110140, 110141) then
		shrapnelTargets[#shrapnelTargets + 1] = args.destName
		self:Unschedule(warnShrapnelTargets)
		if args:IsPlayer() then
			specWarnShrapnel:Show()
			yellShrapnel:Yell()
			timerShrapnel:Start()
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\clickshield.mp3")
			sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
			sndWOP:Schedule(4, "Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
			sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
		end
		if (self:IsDifficulty("normal10", "heroic10") and #shrapnelTargets >= 3) or (self:IsDifficulty("normal25", "heroic25", "lfr25") and #shrapnelTargets >= 8) then
			warnShrapnelTargets()
		else
			self:Schedule(0.3, warnShrapnelTargets)
		end
	elseif args:IsSpellID(108649) then
		warnParasite:Show(args.destName)
		timerParasite:Start(args.destName)
		timerParasiteCD:Start()
		self:updateRangeFrame()
		if args:IsPlayer() then
			specWarnParasite:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
			yellParasite:Yell()
		elseif self:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\healparasite.mp3")
		end
		playerGUID = args.destGUID
		if self.Options.SetIconOnParasite then
			self:SetIcon(args.destName, 8)
		end
	end
end	

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(106444, 109631, 109632, 109633) then
		timerImpale:Cancel(args.destName)
	elseif args:IsSpellID(108649) then
		if self.Options.SetIconOnParasite then
			self:SetIcon(args.destName, 0)
		end
		specWarnUnstableCorruption:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\killparasite.mp3")
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(109091) and GetTime() - lastBlood > 10 then
		specWarnCongealingBlood:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aeblood.mp3")
		lastBlood = GetTime()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 56167 or cid == 56168 or cid == 56846 then
		timerElementiumBoltCD:Cancel()
		timerHemorrhageCD:Cancel()
		timerCataclysm:Cancel()
		timerCataclysmCD:Cancel()
	elseif cid == 56471 then
		timerImpaleCD:Cancel()
		timerParasiteCD:Cancel()
--		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\awaymutant.mp3")
		timerImpale:Cancel()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName, _, _, spellID)
	if uId == "boss1" or uId == "boss2" then
		if spellName == GetSpellInfo(105853) then
			warnHemorrhage:Show()
			specWarnHemorrhage:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\aeblood.mp3")
		elseif spellName == GetSpellInfo(105551) then
			if not UnitBuff("player", GetSpellInfo(109573)) and not UnitIsDeadOrGhost("player") then--Check for Alexstrasza's Presence
				warnTentacle:Show()
				specWarnTentacle:Show()
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\blisterling.mp3")
			end
		elseif spellName == GetSpellInfo(106708) and not phase2 then
			phase2 = true 
			warnPhase2:Show()
			timerFragmentsCD:Start(11)
			timerTerrorCD:Start(36)
		elseif spellName == GetSpellInfo(106775) then
			warnFragments:Show()
			specWarnFragments:Show()
			timerFragmentsCD:Start()
		elseif spellName == GetSpellInfo(106765) then
			warnTerror:Show()
			specWarnTerror:Show()
			timerTerrorCD:Start()
		elseif spellID == 106382 then
			timerCrushCD:Start()
		end
	elseif spellName == GetSpellInfo(110663) then
		self:SendSync("BoltDied")
	end
end

function mod:OnSync(msg)
	if msg == "BoltDied" then
		timerElementiumBlast:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\countone.mp3")
	elseif msg == "MadnessDown" then
		DBM:EndCombat(self)
	end
end
