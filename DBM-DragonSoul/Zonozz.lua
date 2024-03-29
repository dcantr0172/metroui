local mod	= DBM:NewMod(324, "DBM-DragonSoul", nil, 187)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 7231 $"):sub(12, -3))
mod:SetCreatureID(55308)
mod:SetModelID(39138)
mod:SetZone()
mod:SetUsedIcons(6, 7, 8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_SPELLCAST_SUCCEEDED",
	"CHAT_MSG_MONSTER_YELL"
)

local warnVoidofUnmaking		= mod:NewSpellAnnounce(103571, 4, 103527)
local warnVoidDiffusion			= mod:NewStackAnnounce(106836, 2)
local warnFocusedAnger			= mod:NewStackAnnounce(104543, 3, nil, false)
local warnPsychicDrain			= mod:NewSpellAnnounce(104322, 4)
local warnShadows				= mod:NewSpellAnnounce(103434, 3)

local specWarnVoidofUnmaking	= mod:NewSpecialWarningSpell(103571, nil, nil, nil, true)
local specWarnBlackBlood		= mod:NewSpecialWarningSpell(104378, nil, nil, nil, true)
local specWarnPsychicDrain		= mod:NewSpecialWarningSpell(104322, false)
local specWarnShadows			= mod:NewSpecialWarningYou(103434)

local timerVoidofUnmakingCD		= mod:NewNextTimer(90, 103571, nil, nil, nil, 103527)
local timerPsychicDrainCD		= mod:NewCDTimer(20, 104322)
local timerShadowsCD			= mod:NewCDTimer(25, 103434)
local timerBlackBlood			= mod:NewBuffActiveTimer(30, 104378)
local timerphasetwobegin		= mod:NewTimer(71, "timerPhaseTwo", "Interface\\Icons\\Spell_Nature_WispSplode")

local berserkTimer				= mod:NewBerserkTimer(360)

local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:AddBoolOption("DisruptingShadowsIcons", true)
mod:AddDropdownOption("CustomRangeFrame", {"Never", "Normal", "DynamicPhase2", "DynamicAlways"}, "Dynamic3Always", "misc")

local shadowsTargets	= {}
local shadowIcon = 8
local firstPsychicDrain = true
local lastvoid = 0

local function warnShadowsTargets()
	warnShadows:Show(table.concat(shadowsTargets, "<, >"))
	timerShadowsCD:Start()
	if mod:IsHealer() then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\dispelnow.mp3")
	end
	table.wipe(shadowsTargets)
	shadowIcon = 8
end

local shadowsDebuffFilter
do
	shadowsDebuffFilter = function(uId)
		return UnitDebuff(uId, (GetSpellInfo(103434)))
	end
end

function mod:updateRangeFrame()
	if self:IsDifficulty("normal10", "normal25", "lfr25") or self.Options.CustomRangeFrame == "Never" then return end
	if self.Options.CustomRangeFrame == "Normal" or UnitDebuff("player", GetSpellInfo(103434)) or self.Options.CustomRangeFrame == "DynamicPhase2" and not phase2started then
		DBM.RangeCheck:Show(10, nil)
	else
		DBM.RangeCheck:Show(10, shadowsDebuffFilter)
	end
end

local function blackBloodEnds()
	timerShadowsCD:Start(6)
	if mod:IsDifficulty("lfr25") then
		timerphasetwobegin:Start()
	end
	if GetTime() - lastvoid > 90 then
		timerVoidofUnmakingCD:Start(6)
	end
end

function mod:OnCombatStart(delay)
	shadowIcon = 8
	firstPsychicDrain = true
	lastvoid = 0
	table.wipe(shadowsTargets)
	timerVoidofUnmakingCD:Start(6-delay)
	timerPsychicDrainCD:Start(16-delay)
	timerShadowsCD:Start(-delay)
	self:updateRangeFrame()
	if not self:IsDifficulty("lfr25") then
		berserkTimer:Start(-delay)
	else
		timerphasetwobegin:Start()
	end
end

function mod:OnCombatEnd()
	if self.Options.CustomRangeFrame ~= "Never" then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(104322, 104606, 104607, 104608) then
		warnPsychicDrain:Show()
		specWarnPsychicDrain:Show()
		timerPsychicDrainCD:Start()
	end
end	

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(104543, 109409, 109410, 109411) then
		warnFocusedAnger:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(106836) then
		warnVoidDiffusion:Show(args.destName, args.amount or 1)
	elseif args:IsSpellID(103434, 104599, 104600, 104601) then
		shadowsTargets[#shadowsTargets + 1] = args.destName
		if self.Options.DisruptingShadowsIcons then
			self:SetIcon(args.destName, shadowIcon)
			shadowIcon = shadowIcon - 1
		end
		if args:IsPlayer() and self:IsDifficulty("heroic10", "heroic25") then
			specWarnShadows:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\runout.mp3")
			self:updateRangeFrame()
		end
		self:Unschedule(warnShadowsTargets)
		if (self:IsDifficulty("normal10", "heroic10") and #shadowsTargets >= 3) then
			warnShadowsTargets()
		else
			self:Schedule(0.3, warnShadowsTargets)
		end
	end
end		
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(103434, 104599, 104600, 104601) then
		if self.Options.DisruptingShadowsIcons then
			self:SetIcon(args.destName, 0)
		end
		self:updateRangeFrame()
	end
end	

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, spellName, _, _, spellID)
	if uId ~= "boss1" then return end
	if spellID == 103571 and not self:IsDifficulty("lfr25") then
		warnVoidofUnmaking:Show()
		specWarnVoidofUnmaking:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..GetLocale().."\\ballappear.mp3")
		timerVoidofUnmakingCD:Start()
		if not firstPsychicDrain then
			timerPsychicDrainCD:Start(8)
		end
		firstPsychicDrain = false
		lastvoid = GetTime()
	elseif spellID == 109413 then
		timerPsychicDrainCD:Cancel()
		timerShadowsCD:Cancel()
		if self:IsDifficulty("lfr25") then
			timerphasetwobegin:Cancel()
		end
		specWarnBlackBlood:Show()
		if self:IsDifficulty("heroic10", "heroic25") then
			timerBlackBlood:Start(41)
			self:Schedule(41, blackBloodEnds)
		else
			timerBlackBlood:Start(31)
			self:Schedule(31, blackBloodEnds)
		end		
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.voidYell or msg:find(L.voidYell)) and self:IsDifficulty("lfr25") then
		warnVoidofUnmaking:Show()
		specWarnVoidofUnmaking:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..GetLocale().."\\ballappear.mp3")
		timerVoidofUnmakingCD:Start()
		if not firstPsychicDrain then
			timerPsychicDrainCD:Start(8)
		end
		firstPsychicDrain = false
		lastvoid = GetTime()
	end
end
