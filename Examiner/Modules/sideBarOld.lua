--side frame
--$Rev: 3284 $
EXSideFrame = {}
local sideFrame;
EXSideFrame.unit = "player";
EXSideFrame.player = {}
local EXFont = ChatFontNormal:GetFont()
local L = wsLocale:GetLocale("Examiner");
-----------------------------------------------------------
-----  Side Frame
-----------------------------------------------------------
do
	sideFrame = CreateFrame("Frame", "ExaminerSideFrame", PaperDollFrame);
    PaperDollFrame:HookScript('OnShow', function() sideFrame:Show() end);
	sideFrame:SetWidth(215);
	sideFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 }})
	sideFrame:SetBackdropColor(0.1, 0.22, 0.35)
	sideFrame:SetBackdropBorderColor(0.7, 0.7, 0.8, 1)
	sideFrame:ClearAllPoints()
	sideFrame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -30, -12);
	sideFrame:EnableMouse(true)
	sideFrame:SetMovable(true)
	sideFrame:SetToplevel(true)

	--base info
	sideFrame.title = sideFrame:CreateFontString(nil,"ARTWORK");
	sideFrame.title:SetFont(EXFont, 14);
	sideFrame.title:SetTextColor(1, 0.82, 0)
	sideFrame.title:SetPoint("TOPLEFT", 5, -5)

	local t;
	EXSideFrame.entries = {}
	for i = 1, 60 do
		local t = CreateFrame("Frame", nil, sideFrame);
		t:SetWidth(202);
		t:SetHeight(12);
		t.id = i

		--point
		if i == 1 then
			t:SetPoint("TOPLEFT", 5, -25)
		else
			t:SetPoint("TOP", EXSideFrame.entries[i-1], "BOTTOM", 0, -2)
		end

		t.left = t:CreateFontString(nil, "ARTWORK");
		t.left:SetFont(EXFont, 12);
		t.left:SetPoint("LEFT");

		t.right = t:CreateFontString(nil, "ARTWORK");
		t.right:SetFont(EXFont, 12);
		t.right:SetPoint("RIGHT");
		t.right:SetTextColor(1, 1, 0);

		tinsert(EXSideFrame.entries, t)
	end
	local closeButton = CreateFrame("Button", nil, sideFrame, "UIPanelCloseButton"):SetPoint("TOPRIGHT", 0, 0);
    
	--script
	sideFrame:SetScript("OnMouseDown", function(self, button) self:StartMoving(); end);
	sideFrame:SetScript("OnMouseUp", function(self, button) self:StopMovingOrSizing(); end);
	sideFrame:SetScript("OnShow", function(self) ExSideFrame_OnShow(self) end)
	sideFrame:SetScript("OnHide", function(self) ExSideFrame_OnHide(self) end)
end


function ExSideFrame_OnShow(self)
	if Examiner:IsShown() then
		sideFrame:SetPoint("LEFT", Examiner, "RIGHT", -30, 10);
	else
		sideFrame:SetPoint("TOPLEFT", PaperDollFrame, "TOPRIGHT", -30, -12);
	end
	--update base info
	EXSideFrame:UpdateBaseInfo()
	EXSideFrame:UpdateResistances()
	EXSideFrame:UpdatePatterns()

	for i = 1, #EXSideFrame.player do
		entry = EXSideFrame.entries[i]
		if EXSideFrame.player[i] then
			local data = EXSideFrame.player[i]
			if data.value then
				local value
				entry.left:SetTextColor(1, 1, 1)
				if data.tip then
					value = "|cff20ff20"..data.value.."|r("..data.tip..")";
				else
					value = "|cff20ff20"..data.value.."|r";
				end
				if data.name then
					entry.left:SetText("  "..data.name);
					entry.right:SetText(value)
					sideFrame:SetHeight(sideFrame:GetHeight() + entry.left:GetHeight()+2)
				end
			elseif data.name then
				entry.left:SetTextColor(0.5,0.75,1.0);
				entry.left:SetText(data.name..":");
				entry.right:SetText("");
				sideFrame:SetHeight(sideFrame:GetHeight() + entry.left:GetHeight()+2)
			end
		end
	end
end

function ExSideFrame_OnHide(self)
	sideFrame:ClearAllPoints();
	for index, data in pairs(EXSideFrame.player) do
		EXSideFrame.player[index] = nil
	end
	--clear frame text
	for i = 1, 60 do
		local entry = EXSideFrame.entries[i]
		entry.left:SetText("");
		entry.right:SetText("")
	end
end

function EXSideFrame:UpdateBaseInfo()
	local playerName = UnitName(self.unit);
	local guildName, guildRank = GetGuildInfo(self.unit)
	local maxHealth = UnitHealthMax(self.unit)
	local maxPower = UnitPowerMax(self.unit)
	local _, powerType = UnitPowerType(self.unit)

	sideFrame.title:SetText(playerName);
	sideFrame:SetHeight(sideFrame.title:GetHeight()+30)

	tinsert(self.player, {name = GENERAL});
	tinsert(self.player, {name = HEALTH, value = maxHealth});
	tinsert(self.player, {name = _G[powerType], value = maxPower});
	--GetTotalAchievementPoints
	tinsert(self.player, {name = ACHIEVEMENT_BUTTON, value = GetTotalAchievementPoints()});
end

--base, resistance, positive, negative = UnitResistance("unit", resistanceIndex)
	--[[
	    * 0 - (Physical) - Armor rating
        * 1 - (Holy)
        * 2 - (Fire)
        * 3 - (Nature)
        * 4 - (Frost)
        * 5 - (Shadow)
        * 6 - (Arcane)

DAMAGE_SCHOOL3 = "火焰";
DAMAGE_SCHOOL4 = "自然";
DAMAGE_SCHOOL5 = "冰霜";
DAMAGE_SCHOOL6 = "暗影";
DAMAGE_SCHOOL7 = "奥术";
]]
local resistanceColor = {
	[2] = '|CFFFF60FF',		-- arcane
	[3] = '|CFFFF3600',		-- fire
	[4] = '|CFF00C0FF',		-- frost
	[5] = '|CFFFFA400',		-- holy
	[6] = '|CFF00FF60',	-- nature
	[7] = '|CFFAA12AC',	-- shadow
}


function EXSideFrame:UpdateResistances()
	local resistanceTbl = {}
	local base, total;
	for i=2, 6 do
		local base, total = UnitResistance(self.unit, i)
		--if total >= 0 then
			tinsert(resistanceTbl, {name = resistanceColor[i].._G["DAMAGE_SCHOOL"..(i+1)].."|r", value = tonumber(total-base), tip = total})
		--end
	end
	if (#resistanceTbl > 0 ) then
		tinsert(self.player, {name = RESISTANCE_LABEL});
		for i=1, #resistanceTbl do
			--if resistanceTbl[i].value > 0 then
				tinsert(self.player, {name = resistanceTbl[i].name, value = resistanceTbl[i].value, tip = resistanceTbl[i].tip})
			--end
		end
	end
end

function EXSideFrame:UpdatePatterns()
	--STR, AGI, STA, INT, SPI (力量, 敏捷, 耐力, 智力, 精神)
	--UnitStat

	local class = select(2, UnitClass(self.unit))
	local level = UnitLevel(self.unit)
	local ExPlayerStat, ExPlayerSet = {}, {}
	ExScanner:ScanUnitItems("player", ExPlayerStat, ExPlayerSet);

	if ExPlayerStat["STR"] or ExPlayerStat["AGI"] or ExPlayerStat["STA"] or ExPlayerStat["INT"] or ExPlayerStat["SPI"] or ExPlayerStat["ARMOR"] then
		tinsert(self.player, {name = PLAYERSTAT_BASE_STATS});
		for token, appvalue in pairs(ExPlayerStat) do
			if token == "STR" then
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "AGI" then
				local valuePct = tonumber(format("%.2f",ExBaseData:GetCritFromAgi(appvalue, class, level))).."%";
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			elseif token == "STA" then
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "INT" then
				local valuePct = tonumber(format("%.2f",ExBaseData:GetSpellCritPerInt(appvalue, class, level))).."%";
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			elseif token == "SPI" then
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "ARMOR" then
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue});
			end
		end
	end

	if ExPlayerStat["HP"] or ExPlayerStat["MP"] or ExPlayerStat["HP5"] or ExPlayerStat["MP5"] then
		tinsert(self.player, {name = HEALTH.." & "..MANA});
		for token, appvalue in pairs(ExPlayerStat) do
			if token == "HP" or token == "MP" or token == "HP5" or token == "MP5" then
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue});
			end
		end
	end

	if ExPlayerStat["AP"] or ExPlayerStat["RAP"] or ExPlayerStat["APFERAL"] or ExPlayerStat["CRIT"] or ExPlayerStat["HIT"] or ExPlayerStat["HASTE"] or ExPlayerStat["WPNDMG"] or ExPlayerStat["RANGEDDMG"] or ExPlayerStat["ARMORPENETRATION"] or ExPlayerStat["ARMORPENETRATIONRATING"] or ExPlayerStat["EXPERTISE"] then
		tinsert(self.player, {name = PLAYERSTAT_MELEE_COMBAT.." & "..PLAYERSTAT_RANGED_COMBAT});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "AP" or token == "RAP" or token == "APFERAL" or token == "CRIT" or token == "HIT" or token == "HASTE" or token == "WPNDMG" or token == "RANGEDDMG" or token == "ARMORPENETRATION" or token == "ARMORPENETRATIONRATING" or token == "EXPERTISE" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if ExPlayerStat["HEAL"] or ExPlayerStat["SPELLDMG"]or ExPlayerStat["ARCANEDMG"] or ExPlayerStat["FIREDMG"] or ExPlayerStat["NATUREDMG"] or ExPlayerStat["FROSTDMG"] or ExPlayerStat["SHADOWDMG"] or ExPlayerStat["HOLYDMG"] or ExPlayerStat["SPELLCRIT"] or ExPlayerStat["SPELLHIT"] or ExPlayerStat["SPELLHASTE"] or ExPlayerStat["SPELLPENETRATION"] then
		tinsert(self.player, {name = PLAYERSTAT_SPELL_COMBAT});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "HEAL" or token == "SPELLDMG"or token =="ARCANEDMG" or token == "FIREDMG" or token == "NATUREDMG" or token == "FROSTDMG" or token == "SHADOWDMG" or token == "HOLYDMG" or token =="SPELLCRIT" or token == "SPELLHIT" or token == "SPELLHASTE" or token == "SPELLPENETRATION" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if ExPlayerStat["DEFENSE"] or ExPlayerStat["DODGE"] or ExPlayerStat["PARRY"] or ExPlayerStat["BLOCK"] or ExPlayerStat["BLOCKVALUE"] or ExPlayerStat["RESILIENCE"] then
		tinsert(self.player, {name = PLAYERSTAT_DEFENSES});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "DEFENSE" or token == "DODGE" or token ==  "PARRY" or token == "BLOCK" or token == "BLOCKVALUE" or token == "RESILIENCE" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(self.player, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if type(ExPlayerSet) == "table" and next(ExPlayerSet) then
		tinsert(self.player, {name = L["Sets: "]});
		for setName, setData in pairs(ExPlayerSet) do
			tinsert(self.player, {name = setName, value = setData.count.."/"..setData.max});
		end
	end
end

