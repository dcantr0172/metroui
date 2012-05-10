-----------------------------------------------------
--战斗信息
--敌对施放提示以及施放时间
--作者: 月色狼影
--$LastChangedBy: 月色狼影 $
--$Rev: 2637 $
--$Date: 2009-12-16 14:56:26 +0800 (三, 2009-12-16) $
------------------------------------------------------

local CI = LibStub("AceAddon-3.0"):NewAddon("CombatInfo", "AceEvent-3.0", "AceConsole-3.0");
_G.CombatInfo = CI
local L = wsLocale:GetLocale("CombatInfo")
local SM = LibStub("LibSharedMedia-3.0");
local fonts = SM:List("font");
CombatInfo.revision = tonumber(("$Rev: 2637 $"):match("%d+"));

local SPELLCASTOTHERSTART = L["%s开始施放%s。"];
local AURAADDEDOTHERHELPFUL = L["%s获得了%s的效果。"];

local ws_PartyMember = {}
local ws_RaidMember = {}
local spellFrame, buffFrame
local spellId, spellName
local strsub = strsub
local bit_bor = bit.bor;
local bit_band = bit.band
local uInCombat = false;--check u

--npc
local WS_enemy_mob = bit_bor(
	COMBATLOG_OBJECT_REACTION_HOSTILE,
	COMBATLOG_OBJECT_TYPE_NPC
)

--player
local WS_enemy_player = bit_bor(
	COMBATLOG_OBJECT_REACTION_HOSTILE,
	COMBATLOG_OBJECT_TYPE_PLAYER
)

local db;
local defaults = {
	profile = {
		enabled = true,
		showCombat = true,
		showMob = true,
		showPlayer = true,
		showMobbuff = true,
		showPlayerbuff = true,
		otherInfo = true,
		Showinfo = {
			fontsize = 23,
			fonttype = "Friz Quadrata TT",
			fontstyle = "OUTLINE",
			framefade = 0.5,
		},
		zoneAler = true,
		inCombat = true,
		spelllist = {
			["priest"] = {
				["605"] = true,--精神控制
				["8103"] = true,--心灵震爆
				["8129"] = true,--法力燃烧
				["585"] = true,--惩击
				["15263"] = true,--神圣之火
				["34916"] = true,--吸血鬼之触
				["592"] = true,--真言术：盾
				["15407"] = true,--精神鞭笞
				["2060"] = true,--强效治疗术
				["10915"] = true,--快速治疗
				["34861"] = true,--治疗之环
				["10960"] = true,--治疗祷言
				["32546"] = true,--联结治疗
				["15286"] = true, --吸血鬼的拥抱
			},
			["druid"] = {
				["26989"] = true,--纠缠根须
				["26985"] = true,--愤怒
				["26986"] = true,--星火术
				["26979"] = true,--治疗之触
				["26980"] = true,--愈合术
				["26981"] = true,--回春术
			},
			["hunter"] = {
				["27065"] = true,--致命一击
			},
			["mage"] = {
				["12825"] = true,--变羊
				["28272"] = true,--变猪
				["28271"] = true,--变乌龟
				["38697"] = true,--寒冰箭
				["38692"] = true,--火球术
				["30451"] = true,--奥冲
				["33938"] = true,--炎爆术
				["2121"] = true,--烈焰
				["12472"] = true,--冰箱
				["10205"] = true, --灼烧
			},
			["shaman"] = {
				["25449"] = true,--闪电箭
				["25442"] = true,--闪电链
				["25423"] = true,--治疗链
				["25396"] = true,--治疗波
				["25420"] = true,--次级治疗波
			},
			["warlock"] = {
				["6215"] = true,--恐惧
				["17928"] = true,--恐惧嚎叫
				["6358"] = true,--诱惑
				["27209"] = true,--暗影箭
				["27243"] = true,--腐蚀之种
				["30545"] = true,--灵魂之火
				["30405"] = true,--痛苦无常
				["32231"] = true,--烧尽
				["30414"] = true,--暗影之怒
			},
			["paladin"] = {
				["27137"] = true,--圣闪
				["27136"] = true,--圣光
			},
			["deathknight"] = {},
			["warrior"] = {},
            ['rogue'] = {},
		},
		bufflist = {
			["2825"] = true,--嗜血
			["13750"] = true,--冲动
			["31884"] = true,--复仇之怒
			["1044"] = true,--自由祝福
			["10278"] = true,--保护祝福
			["12292"] = true,--死亡之愿
			["19263"] = true,--威慑
			["642"] = true,--圣盾术
			["498"] = true,--无敌
			["26669"] = true,--闪避
			["32182"] = true,--英勇
			["33206"] = true,--痛苦压制
			["20600"] = true,--感知
			["1719"] = true,--鲁莽
			["23920"] = true,--法术反射
			["20594"] = true,--石像形态
			["34692"] = true,--野兽之心
		},
		spellCustom = {},
		buffCustom = {},
		spellCustomcache = {},
		buffCustomcache = {},
	}
}

function CI:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CombatInfoDB", defaults, UnitName("player").." - "..GetRealmName())
	db = self.db.profile

	self:CreateSpellAndBuffFrame();

	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	self:SetupOptions()
	self:SetEnabledState(db.enabled)
end

function CI:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
end

function CI:OnDisable()
	self:UnregisterAllEvents();
	if spellFrame then
		spellFrame:Hide()
	end
	if buffFrame then
		buffFrame:Hide()
	end

end

function CI:OnProfileChanged(type)
	self:CreateSpellAndBuffFrame()
end

function CI:CreateMessageFrame(name)
	local frame = CreateFrame("MessageFrame", name, UIParent)
	frame:SetPoint("LEFT", UIParent)
	frame:SetPoint("RIGHT", UIParent)
	frame:SetHeight(25)
	frame:SetInsertMode("TOP")
	frame:SetFrameStrata("HIGH")
	frame:SetTimeVisible(1)

	return frame
end

function CI:CreateSpellAndBuffFrame()
	spellFrame = self:CreateMessageFrame("SpellAlertFrame");
	spellFrame:SetPoint("TOP", 0, -180);
	spellFrame:SetFadeDuration(db.Showinfo.framefade)
	spellFrame:SetFont(SM:Fetch("font", db.Showinfo.fonttype), db.Showinfo.fontsize, db.Showinfo.fontstyle)
	spellFrame:Hide();
	buffFrame = self:CreateMessageFrame("BuffAlertFrame");
	buffFrame:SetPoint("BOTTOM", spellFrame, "TOP", 0, 2);
	buffFrame:SetFadeDuration(db.Showinfo.framefade)
	buffFrame:SetFont(SM:Fetch("font", db.Showinfo.fonttype), db.Showinfo.fontsize, db.Showinfo.fontstyle)
	buffFrame:Hide();
end

function CI:PLAYER_REGEN_DISABLED()
	local frame = spellFrame
	if (db.showCombat) then
		frame:AddMessage("*** |cFFFF2B2B"..(L["进入战斗"]).."|r ***", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		uInCombat = true
		frame:Show()
	end
end

function CI:PLAYER_REGEN_ENABLED()
	local frame = spellFrame
	if (db.showCombat) then
		frame:AddMessage("*** |cFFFF2B2B"..(L["离开战斗"]).."|r ***", 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
		uInCombat = false
		frame:Show()
	end
end

function CI:CHAT_MSG_MONSTER_EMOTE(event, msg, name)
	if ((msg == L["%s似乎已经做好被捕捉的准备了。"]) and db.otherInfo) then
		spellFrame:AddMessage(format(msg, "|cFFFFB400"..name.."|r"),1.0, 1.0, 1.0, 1.0)
		spellFrame:Show()
	end
end

local function hasFlag(flags, flag)
	return bit_band(flags, flag) == flag
end

--[[ function ]]
local function spellAlert(spellIcon, srcName, spellName)
	--print(srcName,spellName)
	spellFrame:AddMessage(spellIcon..format(SPELLCASTOTHERSTART , "|cFFFFB400"..srcName.."|r" , "|cFFFF2B2B"..spellName.."|r"), 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	spellFrame:Show()
end
local function buffAlert(spellIcon, dstName, spellName)
	buffFrame:AddMessage(spellIcon..format(AURAADDEDOTHERHELPFUL , "|cFFFFB400"..dstName.."|r" , "|cFFFF2B2B"..spellName.."|r"), 1.0, 1.0, 1.0, 1.0, UIERRORS_HOLD_TIME);
	buffFrame:Show()
end
--[[ END ]]

--检测是否在此数组中
--并且返回它在表中的值
local function in_array(need, hacky)
	for fkey in pairs(hacky) do
		if (type(hacky[fkey]) == "table") then
			return in_array(need, hacky[fkey]);
		elseif (type(hacky[fkey]) ~= "table") then
			if (fkey == need) then
				return true, hacky[fkey]
			end
		end
	end
	return false
end


local __QUESTION_MARK = "interface\\icons\\INV_Misc_QuestionMark"
function CI:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, sourceRaidFlags, dstGUID, dstName, dstFlags, destRaidFlags = select(1, ...);
	local prefix = strsub(eventtype, 1, 5);
	local pvpzone = select(1, GetZonePVPInfo());
	if (prefix == "SPELL") then
	local spellId, spellName = select(12, ...);
	local _,_,spellIcon = GetSpellInfo(spellId);

    spellIcon = "|T"..(spellIcon or __QUESTION_MARK)..":0|t";

		local suffix = strsub(eventtype, strlen(prefix)+2, -1);
		
		--cast spell alert

		if (suffix == "CAST_START" or suffix == "SUMMON" or suffix=="DISPEL") then
			--mob
			if (db.showMob and hasFlag(srcFlags ,WS_enemy_mob)) then
				if (db.zoneAler) then
					if (pvpzone=="friend" or pvpzone == "sanctuary") then return
					else
						if (db.inCombat) then
							if (uInCombat) then
								spellAlert(spellIcon, srcName, spellName) 
							end
						else
							spellAlert(spellIcon, srcName, spellName)
						end
					end
				else
					if (db.inCombat) then
						if (uInCombat) then
							spellAlert(spellIcon, srcName, spellName) 
						end
					else
						spellAlert(spellIcon, srcName, spellName)
					end
				end
				--CombatInfo.modules.spellTable.db.profile.isSpellTable[spellName]
			elseif (db.showPlayer and hasFlag(srcFlags, WS_enemy_player)) then
				local has, sval = in_array(spellName, db.spelllist)
				local cshas, csval = in_array(spellName, db.spellCustom)
				if ((has and sval) or (cshas and csval)) then
					if (db.zoneAler) then
						if (pvpzone=="friend" or pvpzone == "sanctuary") then return
						else
							if (db.inCombat) then
								if (uInCombat) then
									spellAlert(spellIcon, srcName, spellName) 
								end
							else
								spellAlert(spellIcon, srcName, spellName)
							end
						end
					else
						if (db.inCombat) then
							if (uInCombat) then
								spellAlert(spellIcon, srcName, spellName) 
							end
						else
							spellAlert(spellIcon, srcName, spellName)
						end
					end
				end
			end
		elseif (suffix == "AURA_APPLIED") then
			local buffType = select(12, ...)
			if (db.showMobbuff and hasFlag(dstFlags, WS_enemy_mob) and buffType == "BUFF") then
				if (db.zoneAler) then
					if (pvpzone=="friend" or pvpzone == "sanctuary") then return
					else
						if (db.inCombat) then
							if (uInCombat) then
								buffAlert(spellIcon, dstName, spellName)
							end
						else
							buffAlert(spellIcon, dstName, spellName)
						end
					end
				else
					if (db.inCombat) then
						if (uInCombat) then
							buffAlert(spellIcon, dstName, spellName)
						end
					else
						buffAlert(spellIcon, dstName, spellName)
					end
				end
				--and CombatInfo.modules.spellTable.db.profile.isBuffTable[spellName] 
			elseif (db.showPlayerbuff and hasFlag(dstFlags, WS_enemy_player)) then
				local has, sval = in_array(spellName, db.bufflist)
				local cshas, csval = in_array(spellName, db.buffCustom)
				if ((has and sval) or (cshas and csval)) then
					if (db.zoneAler) then
						if (pvpzone=="friend" or pvpzone == "sanctuary") then return
						else
							if (db.inCombat) then
								if (uInCombat) then
									buffAlert(spellIcon, dstName, spellName)
								end
							else
								buffAlert(spellIcon, dstName, spellName)
							end
						end
					else
						if (db.inCombat) then
							if (uInCombat) then
								buffAlert(spellIcon, dstName, spellName)
							end
						else
							buffAlert(spellIcon, dstName, spellName)
						end
					end
				end
			end
		end
	end
end

--for setting
function CI:ShowSpellAlertFrame()
	spellFrame:AddMessage(L["|Tinterface\\icons\\INV_Misc_QuestionMark:0|t 法术预警测试框|r"], 1.0, 1.0, 1.0, 1.0);
	spellFrame:Show();
	buffFrame:AddMessage(L["|Tinterface\\icons\\INV_Misc_QuestionMark:0|t Buff预警测试框|r"], 1.0, 1.0, 1.0, 1.0);
	buffFrame:Show()
end
