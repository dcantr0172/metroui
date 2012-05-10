local ex = Examiner;
local gtt = GameTooltip;
local L = wsLocale:GetLocale("Examiner");

-- Module
local mod = ex:CreateModule("Stats");
mod:CreatePage(false);
mod:CreateButton(L["Stats"],L["Gear Statistics"],L["Right Click for extended menu"]);
mod.details = ex:CreateDetailObject();

-- Variables
local ITEM_HEIGHT = 12;
local cfg, cache;
local displayList = {};
local resists = {};
local entries = {};


-- Stat Entry Order
local StatEntryOrder = {
	{ [0] = PLAYERSTAT_BASE_STATS, "STR", "AGI", "STA", "INT", "SPI", "ARMOR" },
	{ [0] = HEALTH.." & "..MANA, "HP", "MP", "HP5", "MP5" },
	{ [0] = PLAYERSTAT_SPELL_COMBAT.." "..STATS_LABEL:gsub(":",""), "HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT", "SPELLHIT", "SPELLHASTE", "SPELLPENETRATION" },
	{ [0] = MELEE.." & "..RANGED, "AP", "RAP", "CRIT", "HIT", "HASTE", "ARMORPENETRATION", "EXPERTISE", "WPNDMG", "RANGEDDMG" },
	{ [0] = PLAYERSTAT_DEFENSES, "DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "RESILIENCE" },
};
-- Az: this is a temp slash command to add iLvlTotal value to old cached entries
ex.slashHelp[#ex.slashHelp + 1] = " |2fixcacheitemlevels|r = Temp slash cmd to give old cache entries an avg itemlevel";
ex.slashFuncs.fixcacheitemlevels = function(cmd)
	local numItems = (#ExScanner.Slots - 3); -- Ignore Tabard + Shirt + Ranged, hence minus 3
	for entryName, entry in next, cache do
		local iLvlTotal = 0;
		for slotName, link in next, entry.Items do
			if (slotName ~= "TabardSlot") and (slotName ~= "ShirtSlot") and (slotName ~= "RangedSlot") then
				local _, _, _, itemLevel = GetItemInfo(link);
				if (itemLevel) then
					if (slotName == "MainHandSlot") and (not entry.Items.SecondaryHandSlot) then
						itemLevel = (itemLevel * 2);
					end
					iLvlTotal = (iLvlTotal + itemLevel);
				end
			end
		end
		entry.iLvlAvg = nil
		entry.iLvlAverage = (iLvlTotal / numItems);
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
	-- Defaults
	cfg.statsViewType = (cfg.statsViewType or 1);
	-- Add cache sort method
	local cacheMod = ex:GetModuleFromToken("Cache");
	if (cacheMod) and (cacheMod.cacheSortMethods) then
		cacheMod.cacheSortMethods[#cacheMod.cacheSortMethods + 1] = "iLvlAverage";
	end
end

-- OnConfigChanged
function mod:OnConfigChanged(var,value)
	if (var == "combineAdditiveStats" or var == "percentRatings") then
		self:BuildShownList();
	end
end

-- OnButtonClick
function mod:OnButtonClick(button)
	-- left
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) and (ex.itemsLoaded) then
			ex:CacheStatsForCompare();
		elseif (IsControlKeyDown()) then
			cfg.statsViewType = (cfg.statsViewType == 1 and 2 or 1);
			self:BuildShownList();
		end
	-- right
	elseif (IsShiftKeyDown()) then
		ex:CacheStatsForCompare(1);
	end
end

-- OnInspect
function mod:OnInspect(unit)
	if (ex.itemsLoaded) then
		self.details:Clear();	-- Az: due to the gem workaround, clear details here
		self:InitDetails();
		self:BuildShownList();
		self.button:Enable();
	else
		self.page:Hide();
		self.button:Disable();
	end
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	self.details:Clear();	-- Az: due to the gem workaround, clear details here
	self:InitDetails();
	self:BuildShownList();
	self.button:Enable();
end

-- OnClearInspect
function mod:OnClearInspect()
	self.details:Clear();
end

-- OnCompare
function mod:OnCompare(isCompare,compareEntry)
	self:BuildShownList();
end

-- OnDetailsUpdate
function mod:OnDetailsUpdate()
	if (cfg.statsViewType == 2) then
		self:BuildShownList();
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Menu                                                --
--------------------------------------------------------------------------------------------------------

-- Menu Init Items
function mod.MenuInit(parent,list)
	--[[
	-- stats
	local tbl = list[#list + 1]; tbl.text = "Stats"; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Cache Player"; tbl.value = 1; tbl.checked = (cache[ex:GetEntryName()] ~= nil);
	-- view
	tbl = list[#list + 1]; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "View"; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Gear Stats"; tbl.value = 4; tbl.checked = (cfg.statsViewType == 1);
	tbl = list[#list + 1]; tbl.text = "Details"; tbl.value = 5; tbl.checked = (cfg.statsViewType == 2);
	-- compare
	tbl = list[#list + 1]; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Compare"; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Mark for Compare"; tbl.value = 2; tbl.checked = (ex.isComparing and ex.compareStats.entry == ex:GetEntryName());
	if (ex.isComparing) then
		tbl = list[#list + 1]; tbl.text = "Clear Compare"; tbl.value = 3;
	end
	]]
end

-- Menu Select Item
function mod.MenuSelect(parent,entry)
	-- Cache
	if (entry.value == 1) then
		ex:CachePlayer(1);
	-- Mark for Compare & Clear Compare
	elseif (entry.value == 2 or entry.value == 3) then
		ex:CacheStatsForCompare(entry.value == 3);
	-- View Type
	else
		cfg.statsViewType = (entry.value - 3);
		mod:BuildShownList();
	end
end

--------------------------------------------------------------------------------------------------------
--                                               Details                                              --
--------------------------------------------------------------------------------------------------------

-- Obtain Gem and Item Level Details
-- http://www.wowwiki.com/Item_level#Epic_Item_Level_Chart
-- http://elitistjerks.com/f15/t44718-item_level_mechanics/
local function GetGemAndItemInfo()
	local iLvlTotal, iSlotValues, iLvlMin, iLvlMax = 0, 0;
	local gemCount, gemRed, gemYellow, gemBlue = 0, 0, 0, 0;
	for slotName, link in next, ex.info.Items do
		-- Count Gem Colors
		for i = 1, 3 do
			local _, gemLink = GetItemGem(link,i);
			if (gemLink) then
				gemCount = (gemCount + 1);
				local _, _, _, _, _, _, itemSubType = GetItemInfo(gemLink);
				if (EMPTY_SOCKET_NO_COLOR:match(itemSubType)) then
					gemRed = (gemRed + 1);
					gemYellow = (gemYellow + 1);
					gemBlue = (gemBlue + 1);
				else
					ExScannerTip:ClearLines();
					ExScannerTip:SetHyperlink(gemLink);
					-- 09.08.09: This code now scans all lines, to fix the issue with patch 3.2 adding more lines to item tooltip.
					for n = 3, ExScannerTip:NumLines() do
						local line = _G["ExScannerTipTextLeft"..n]:GetText():lower();
						if (line:match("^\".+\"$")) then
							if (line:match(RED_GEM:lower())) then
								gemRed = (gemRed + 1);
							end
							if (line:match(YELLOW_GEM:lower())) then
								gemYellow = (gemYellow + 1);
							end
							if (line:match(BLUE_GEM:lower())) then
								gemBlue = (gemBlue + 1);
							end
						end
					end
				end
			end
		end
		-- Calculate Item Level Numbers
		if (slotName ~= "TabardSlot") and (slotName ~= "ShirtSlot") and (slotName ~= "RangedSlot") then
			local _, _, itemRarity, itemLevel = GetItemInfo(link);
			if (itemLevel) then
				iLvlMin = min(iLvlMin or itemLevel,itemLevel);
				iLvlMax = max(iLvlMax or itemLevel,itemLevel);
				local itemSlotValue = ExScanner:CalculateItemSlotValue(link);
				if (slotName == "MainHandSlot") and (not ex.info.Items.SecondaryHandSlot) then
					itemLevel = (itemLevel * 2);
					itemSlotValue = (itemSlotValue * 2);
				end
				iLvlTotal = (iLvlTotal + itemLevel);
				iSlotValues = (iSlotValues + itemSlotValue);
			end
		end
	end
	-- Return
	return iLvlTotal, iLvlMin, iLvlMax, iSlotValues, gemCount, gemRed, gemYellow, gemBlue;
end

-- Initialise Details
function mod:InitDetails()
	local details = self.details;
	-- Unit Details
	if (ex.unit) then
		details:Add("Unit");
		details:Add("Token",ex.unit);
		details:Add(HEALTH,UnitHealthMax(ex.unit));
		if (UnitPowerType(ex.unit) == 0) then
			details:Add(MANA,UnitPowerMax(ex.unit));
		end
	end
	-- Item Level
	local iLvlTotal, iLvlMin, iLvlMax, iSlotValues, gemCount, gemRed, gemYellow, gemBlue, test = GetGemAndItemInfo();
	local numItems = (#ExScanner.Slots - 3); -- Ignore Tabard + Shirt + Ranged, hence minus 3
	details:Add(L["Item Levels"]);
	details:Add(L["Combined Item Slot Values"],floor(iSlotValues));
	details:Add(L["Average Item Slot Value"],format("%.2f",iSlotValues / numItems));
	details:Add(L["Combined Item Levels"],iLvlTotal);
	details:Add(L["Average Item Level"],format("%.2f",iLvlTotal / numItems));
	if (iLvlMin and iLvlMax) then
	details:Add(L["Min / Max Item Levels"],iLvlMin.." / "..iLvlMax);
	end
	ex.info.iLvlAverage = (iLvlTotal / numItems);
	-- Gems
	details:Add(L["Gems"]);
	details:Add(L["Number of Gems"],gemCount);
	details:Add(L["Gem Color Matches"],format("|cffff6060%d|r/|cffffff00%d|r/|cff008ef8%d",gemRed,gemYellow,gemBlue));
	-- Cache
	-- remove cache
	--[[
	if (ex.isCacheEntry) then
		details:Add("Cached Entry");
		details:Add("Zone",ex.info.zone);
		details:Add("Date",date("%a, %b %d, %Y",ex.info.time));
		details:Add("Time",date("%H:%M:%S",ex.info.time));
		details:Add("Time Ago",ex:FormatTime(time() - ex.info.time));
	end
	]]
end

--------------------------------------------------------------------------------------------------------
--                                         Update Stat Lists                                          --
--------------------------------------------------------------------------------------------------------

-- Show Resistances
local function UpdateResistances()
	for i = 1, 5 do
		local statToken = (ExScanner.MagicSchools[i].."RESIST");
		if (ex.unitStats[statToken]) or (ex.isComparing and ex.compareStats[statToken]) then
			resists[i].value:SetText(ex:GetStatValue(statToken,ex.unitStats,ex.isComparing and ex.compareStats));
		else
			resists[i].value:SetText("");
		end
	end
end

-- ScrollBar: Update Stat List
local function UpdateShownItems()
	FauxScrollFrame_Update(ExaminerStatScroll,displayList.count,#entries,ITEM_HEIGHT);
	local index = ExaminerStatScroll.offset;
	for i = 1, #entries do
		index = (index + 1);
		local entry = entries[i];
		if (index <= displayList.count) then
			if (displayList[index].value) then
				entry.left:SetTextColor(1,1,1);
				entry.left:SetFormattedText("  %s",displayList[index].name);
				entry.right:SetText(displayList[index].value);
			elseif (displayList[index].name) then
				entry.left:SetTextColor(0.5,0.75,1.0);
				entry.left:SetFormattedText("%s:",displayList[index].name);
				entry.right:SetText("");
			else
				entry.left:SetText("");
				entry.right:SetText("");
			end

			if (displayList[index].tip) then
				entry.tip.tip = displayList[index].tip;
				entry.tip:SetWidth(max(entry.right:GetWidth(),20));
				entry.tip:Show();
			else
				entry.tip:Hide();
			end

			entry:Show();
		else
			entry:Hide();
		end
	end
	entries[1]:SetWidth(displayList.count > #entries and 200 or 216);
end

-- Adds a List Entry
local function AddListEntry(name,value,tip)
	displayList.count = (displayList.count + 1);
	local tbl = displayList[displayList.count] or {};
   	displayList[displayList.count] = tbl;
	tbl.name = name;
	tbl.value = value;
	tbl.tip = tip;
end

--对power bar进行着色
local function getPowerColor(unit)
	local unit = unit or uToken;
	local powerType = UnitPowerType(unit);

	if powerType == 0 then
		--mana
		return MANA, 48/255, 113/255, 191/255
	elseif powerType == 1 then
		--rage
		return RAGE, 226/255, 45/255, 75/255
	elseif powerType == 2 then
		--focus
		return FOCUS, 255/255, 210/255, 0
	elseif powerType == 3 then
		--energy
		return ENERGY, 1, 220/255, 25/255
	elseif powerType == 4 then
		--happniess HAPPINESS
		return HAPPINESS, 0, 1, 1
	elseif powerType == 6 then
		--runic power
		return RUNIC_POWER, 0, 0.82, 1
	end
end

-- Build Stat List
local function BuildStatList()
	displayList.count = 0;
	local needHeader;
	-- update base infobox
	local box = _G["Examiner_BaseInfoBox"];
	if (ex.unit) then
		box.hbtext:SetText(UnitHealthMax(ex.unit))
		box.pbtext:SetText(UnitPowerMax(ex.unit))
		local powerName, pr, pg, pb = getPowerColor(ex.unit)
		box.powertext:SetText(powerName..": ")
		box.powerbar:SetStatusBarColor(pr, pg, pb);
	end
	-- Build display table
	for _, statCat in ipairs(StatEntryOrder) do
		needHeader = 1;
		for _, statToken in ipairs(statCat) do
			if (ex.unitStats[statToken]) or (ex.isComparing and ex.compareStats[statToken]) then
				if (needHeader) then
					AddListEntry(statCat[0]);
					needHeader = nil;
				end
				local value, tip = ex:GetStatValue(statToken,ex.unitStats,ex.isComparing and ex.compareStats);
				AddListEntry(ExScanner.StatNames[statToken],value,tip);
			end
		end
	end
	-- Add Sets
	if (next(ex.info.Sets)) then
		AddListEntry();
		AddListEntry("Sets");
	end
	for setName, setEntry in next, ex.info.Sets do
		AddListEntry(setName,setEntry.count.."/"..setEntry.max);
	end
	-- Add Padding + Update Resistances + Shown Items
	AddListEntry();
	UpdateResistances();
	UpdateShownItems();
end

-- Build Detail List
local function BuildInfoList()
	displayList.count = 0;
	--- Show Details from Modules
	for index, mod in ipairs(ex.modules) do
		if (mod.details) and (#mod.details.entries > 0) then
			for index, entry in ipairs(mod.details.entries) do
				AddListEntry(entry.label,entry.value,entry.tip);
			end
		end
	end
	-- Add Padding + Update Resistances + Shown Items
	AddListEntry();
	UpdateResistances();
	UpdateShownItems();
end

-- Build the Shown List
function mod:BuildShownList()
	--if (cfg.statsViewType == 1) then
		BuildStatList();
	--else
	--	BuildInfoList();
	--end
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- Resistance Boxes
for i = 1, 5 do
	local t = CreateFrame("Frame",nil,mod.page);
	t:SetWidth(32);
	t:SetHeight(29);

	t.texture = t:CreateTexture(nil,"BACKGROUND");
	t.texture:SetTexture("Interface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons");
	t.texture:SetTexCoord(0,1,(i - 1) * 0.11328125,i * 0.11328125);
	t.texture:SetAllPoints();

	t.value = t:CreateFontString(nil,"ARTWORK","GameFontNormal");
	t.value:SetFont(GameFontNormal:GetFont(),12,"OUTLINE");
	t.value:SetPoint("BOTTOM",1,3);
	t.value:SetTextColor(1,1,0);

	if (i == 1) then
 		t:SetPoint("TOPLEFT",36,-9);
	else
 		t:SetPoint("LEFT",resists[i - 1],"RIGHT");
	end

	resists[i] = t;
end
--base info box
local infobox = CreateFrame("Frame", "Examiner_BaseInfoBox", mod.page);
infobox:SetBackdrop(ex.backdrop);
infobox:SetBackdropColor(37/255,77/255,110/255,1);
infobox:SetBackdropBorderColor(0.7,0.7,0.8,1);
infobox:SetWidth(220);
infobox:SetHeight(99);
infobox:SetPoint("TOP", 0,-40);

local tanicon = CreateFrame("Frame",nil, infobox);
tanicon:SetWidth(30);
tanicon:SetHeight(30);
tanicon:SetPoint("TOPLEFT", 10,-10)
tanicon.icon = tanicon:CreateTexture(nil,"BACKGROUND");
tanicon.icon:SetAllPoints();
tanicon.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
infobox.talenticon = tanicon.icon;
	--text
local talent_text = infobox:CreateFontString(nil,"ARTWORK","TextStatusBarText");
--talent_text:SetFont("Fonts\\FRIZQT__.TTF", 12);
talent_text:SetPoint("LEFT", tanicon, "RIGHT", 8, 4);
talent_text:SetTextColor(1,1,0);
talent_text:SetText(L["Load talent info..."])

infobox.talenttext = talent_text

--achievements
local achtext = infobox:CreateFontString(nil,"ARTWORK","TextStatusBarText");
achtext:SetPoint("TOP", tanicon, "BOTTOM", 2, -5);
achtext:SetTextColor(1,1,0);
achtext:SetText(ACHIEVEMENT_BUTTON..": ");
--UI-Achievement-TinyShield
local achIcon = CreateFrame("Frame",nil, infobox);
achIcon:SetWidth(24);
achIcon:SetHeight(24);
achIcon:SetPoint("LEFT", achtext, "RIGHT", 4, -4);
achIcon.icon = achIcon:CreateTexture(nil, "ARTWORK");
achIcon.icon:SetAllPoints();
achIcon.icon:SetTexture("Interface\\AchievementFrame\\UI-Achievement-TinyShield")
	--achlabel
local achlabel = infobox:CreateFontString(nil,"ARTWORK","TextStatusBarText");
achlabel:SetPoint("LEFT", achtext, "RIGHT", 24, 1);
achlabel:SetText(0)
infobox.achlabel = achlabel

--health & power
	---note 2580 UnitHealthMax UnitPowerMax
local healthtext = infobox:CreateFontString(nil,"ARTWORK","TextStatusBarText")
healthtext:SetPoint("TOP", achtext, "BOTTOM", 4, -5);
healthtext:SetText(HEALTH)

local healthbar = CreateFrame("StatusBar", nil, infobox);
healthbar:SetStatusBarTexture("Interface\\AddOns\\Wowshell_UnitFrame\\images\\smooth");
healthbar:SetMinMaxValues(0, 1);
healthbar:SetPoint("LEFT", healthtext, "RIGHT", 0, 0);
healthbar:SetHeight(12);
healthbar:SetWidth(155);
healthbar:SetStatusBarColor(0, 1, 0);
healthbar:SetOrientation("HORIZONTAL");
infobox.healthbar = healthbar--status bar
hbtext = healthbar:CreateFontString(nil, "ARTWORK");
hbtext:SetFont("Fonts\\FRIZQT__.TTF", 12, "Outline");
hbtext:SetJustifyH("CENTER");
hbtext:SetAllPoints(healthbar);
infobox.hbtext = hbtext

local powertext = infobox:CreateFontString(nil,"ARTWORK","TextStatusBarText")
powertext:SetPoint("TOP", healthtext, "BOTTOM", 0, -6);
powertext:SetText(MANA)
infobox.powertext = powertext
local powerbar = CreateFrame("StatusBar", nil, infobox);
powerbar:SetStatusBarTexture("Interface\\AddOns\\Wowshell_UnitFrame\\images\\smooth");
powerbar:SetMinMaxValues(0, 1);
powerbar:SetPoint("LEFT", powertext, "RIGHT", 0, 0);
powerbar:SetHeight(12);
powerbar:SetWidth(155);
powerbar:SetStatusBarColor(0, 1, 0);
powerbar:SetOrientation("HORIZONTAL");
infobox.powerbar = powerbar--status bar
pbtext = powerbar:CreateFontString(nil, "ARTWORK");
pbtext:SetFont("Fonts\\FRIZQT__.TTF", 12, "Outline");
pbtext:SetJustifyH("CENTER");
pbtext:SetAllPoints(powerbar);
infobox.pbtext = pbtext
---@ end

-- Stat Entries
--local statelist = CreateFrame("Frame", "Examiner_StateListBox", ex.frames[3]);
local statelist = CreateFrame("Frame", nil, mod.page)
statelist:SetBackdrop(ex.backdrop);
statelist:SetBackdropColor(37/255,77/255,110/255,1);
statelist:SetBackdropBorderColor(0.7,0.7,0.8,1);
statelist:SetWidth(220);
statelist:SetHeight(140);
statelist:SetPoint("TOP", infobox, "BOTTOM" , 0, -3);

local StatEntry_OnEnter = function(self,motion) gtt:SetOwner(self,"ANCHOR_RIGHT"); gtt:SetText(self.tip); end
for i = 1, 11 do
	local t = CreateFrame("Frame",nil, statelist);
	t:SetWidth(200);
	t:SetHeight(ITEM_HEIGHT);
	t.id = i;

	if (i == 1) then
		t:SetPoint("TOPLEFT", 4, -4);
	else
		t:SetPoint("TOPLEFT",entries[i - 1],"BOTTOMLEFT");
		t:SetPoint("TOPRIGHT",entries[i - 1],"BOTTOMRIGHT");
	end

	t.left = t:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	t.left:SetPoint("LEFT");

	t.right = t:CreateFontString(nil,"ARTWORK","GameFontHighlightSmall");
	t.right:SetPoint("RIGHT");
	t.right:SetTextColor(1,1,0);

	t.tip = CreateFrame("Frame",nil,t);
	t.tip:SetPoint("TOPRIGHT");
	t.tip:SetPoint("BOTTOMRIGHT");
	t.tip:SetScript("OnEnter",StatEntry_OnEnter);
	t.tip:SetScript("OnLeave",ex.HideGTT);
	t.tip:EnableMouse(1);

	entries[i] = t;
end

-- Scroll
local scroll = CreateFrame("ScrollFrame","ExaminerStatScroll",mod.page,"FauxScrollFrameTemplate");
scroll:SetPoint("TOPLEFT",entries[1]);
scroll:SetPoint("BOTTOMRIGHT",entries[#entries],-3,-1);
scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,ITEM_HEIGHT,UpdateShownItems) end);