local ex = Examiner;
local L = wsLocale:GetLocale("Examiner")

-- Module
local mod = ex:CreateModule("Cache");
mod:CreatePage(false,"");
mod:CreateButton(L["Cache"],L["Cached Players"],L["Right Click for extended menu"]);

-- Variables
local cacheSortMethods = { "none", "name", "realm", "level", "guild", "race", "class", "time" };
local BUTTON_HEIGHT = 24;
local cfg, cache;
local ExCacheList = {};
local buttons = {};
mod.cacheSortMethods = cacheSortMethods;

-- Filtering
local levelPattern = "%s(%d*)(%-)(%d*)%s";
local numberPattern = "%s%d+%s";
local listPattern = "([^%s]+):([^%s]+)";
local filterList = {};

-- Custom Colors
local CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS;

-- RaceCoords. For females, add 0.5 to "top" and "bottom".
-- Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races
local EX_RaceCoord = {
	Human		= { left = 0/8, right = 1/8, top = 0/4, bottom = 1/4 },
	Dwarf		= { left = 1/8, right = 2/8, top = 0/4, bottom = 1/4 },
	Gnome		= { left = 2/8, right = 3/8, top = 0/4, bottom = 1/4 },
	NightElf	= { left = 3/8, right = 4/8, top = 0/4, bottom = 1/4 },
	Draenei		= { left = 4/8, right = 5/8, top = 0/4, bottom = 1/4 },
	Tauren		= { left = 0/8, right = 1/8, top = 1/4, bottom = 2/4 },
	Scourge		= { left = 1/8, right = 2/8, top = 1/4, bottom = 2/4 },
	Troll		= { left = 2/8, right = 3/8, top = 1/4, bottom = 2/4 },
	Orc			= { left = 3/8, right = 4/8, top = 1/4, bottom = 2/4 },
	BloodElf	= { left = 4/8, right = 5/8, top = 1/4, bottom = 2/4 },
};

-- Dialog Func
local CacheFilterOkayFunc = function(text) cfg.cacheFilter = text; mod:BuildCacheList(); end

-- Page: OnShow
mod.page:SetScript("OnShow",function(self) if (#ExCacheList == 0) then mod:BuildCacheList(); end end);

-- HOOK: Slash Command "clearcache"
local oldClearCacheFunc = ex.slashFuncs.clearcache;
ex.slashFuncs.clearcache = function(cmd) oldClearCacheFunc(cmd); mod:BuildCacheList(); end
--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInitialize
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
	-- Defaults
	cfg.cacheSort = cfg.cacheSort or "class";
	cfg.cacheFilter = cfg.cacheFilter or "";
end

-- OnButtonClick
function mod:OnButtonClick(button)
	-- left
	if (button == "LeftButton") then
		if (IsShiftKeyDown()) then
			AzDialog:Show("Enter new cache filter...",cfg.cacheFilter,CacheFilterOkayFunc);
		end
	-- right
	elseif (IsShiftKeyDown()) then
		cfg.cacheFilter = "";
		self:BuildCacheList();
	end
end

-- OnCache -- Clear the cache list if this page isn't shown, to invalidate it
function mod:OnCache(entry)
	if (self.index == cfg.activePage) then
		self:BuildCacheList();
	else
		wipe(ExCacheList);
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Delete Cache Functions                                       --
--------------------------------------------------------------------------------------------------------

-- Counts number of entries in a hash table
local function GetTableEntries(t)
	local count = 0;
	for _ in next, t do
		count = (count + 1);
	end
	return count;
end

-- Is the given value in the table?
local function IndexOf(t,value)
	for index, v in ipairs(t) do
		if (v == value) then
			return index;
		end
	end
end

-- Deletes all entries
local function DeleteAllCache()
	wipe(cache);
	mod:BuildCacheList();
end

-- Deletes all the shown entries
local function DeleteShownCache()
	for index, entryName in ipairs(ExCacheList) do
		cache[entryName] = nil;
	end
	mod:BuildCacheList();
end

-- Deletes all the hidden entries
local function DeleteHiddenCache()
	for entryName in next, cache do
		if (not IndexOf(ExCacheList,entryName)) then
			cache[entryName] = nil;
		end
	end
	mod:BuildCacheList();
end

--------------------------------------------------------------------------------------------------------
--                                                Menu                                                --
--------------------------------------------------------------------------------------------------------

-- Menu Init Items
function mod.MenuInit(parent,list)
	if (mod.index ~= cfg.activePage) then
		mod:BuildCacheList();
	end
	-- filter
	local tbl = list[#list + 1]; tbl.text = "Filter"; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Set Filter..."; tbl.value = 1;
	-- sort
	tbl = list[#list + 1]; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Sort Method"; tbl.header = 1;
	for index, method in ipairs(cacheSortMethods) do
		local tbl = list[#list + 1];
		tbl.text = method; tbl.value = method; tbl.checked = (cfg.cacheSort == method);
	end
	-- cache
	tbl = list[#list + 1]; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Cache"; tbl.header = 1;
	tbl = list[#list + 1]; tbl.text = "Delete All Entries"; tbl.value = 2;
	if (#ExCacheList ~= GetTableEntries(cache)) then
		tbl = list[#list + 1]; tbl.text = "Delete Shown Entries"; tbl.value = 3;
		tbl = list[#list + 1]; tbl.text = "Delete Hidden Entries"; tbl.value = 4;
	end
end

-- Menu Select Item
function mod.MenuSelect(parent,entry)
	-- Sort
	if (type(entry.value) == "string") then
		cfg.cacheSort = entry.value;
	-- Cache Filter
	elseif (entry.value == 1) then
		AzDialog:Show("Enter new cache filter...",cfg.cacheFilter,CacheFilterOkayFunc);
	-- Delete Cache
	elseif (entry.value == 2) then
		AzDialog:Show("Are you sure you want to delete |cffffff80"..GetTableEntries(cache).."|r cached entries?",nil,DeleteAllCache);
	elseif (entry.value == 3) then
		AzDialog:Show("Sure you want to delete the |cffffff80"..#ExCacheList.."|r shown cache entries?",nil,DeleteShownCache);
	elseif (entry.value == 4) then
		AzDialog:Show("Sure you want to delete the |cffffff80"..(GetTableEntries(cache) - #ExCacheList).."|r hidden cache entries?",nil,DeleteHiddenCache);
	end
	-- Rebuild Cache List
	if (entry.value ~= 1) then
		mod:BuildCacheList();
	end
end

--------------------------------------------------------------------------------------------------------
--                                            Cache Stuff                                             --
--------------------------------------------------------------------------------------------------------

-- CacheEntry: OnClick
local function CacheEntry_OnClick(self,button)
	if (button == "LeftButton") then
		if (IsModifiedClick("CHATLINK")) and (ChatFrameEditBox:IsVisible()) then
			local entry = cache[self.entryName];
			ChatFrameEditBox:Insert(format("%s, %d %s%s",self.entryName,entry.level,entry.class,(entry.guild and " of <"..entry.guild..">" or "")));
		else
			PlaySound("igMainMenuOptionCheckBoxOn");
			ex:ClearInspect();
			ex:LoadPlayerFromCache(self.entryName);
			-- Show Stats page if that module exists
			if (not IsShiftKeyDown()) then
				local mod = ex:GetModuleFromToken("Stats");
				if (mod) then
					ex:ShowModulePage(mod.index);
				end
			end
		end
	elseif (button == "RightButton") and (IsShiftKeyDown()) then
		cache[self.entryName] = nil;
		mod:BuildCacheList();
	end
end

-- CacheEntry: OnEnter
local function CacheEntry_OnEnter(self,motion)
	local entry = cache[self.entryName];
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	-- Init Text & Colors
	local color = CLASS_COLORS[entry.classFixed];
	local classText = ("|cff%.2x%.2x%.2x%s|r"):format(color.r*255,color.g*255,color.b*255,entry.class);
	color = GetQuestDifficultyColor(entry.level ~= -1 and entry.level or 500);
	local level = ("|cff%.2x%.2x%.2x%s|r"):format(color.r*255,color.g*255,color.b*255,entry.level ~= -1 and entry.level or "??");
	-- Add Lines & Show
	GameTooltip:AddLine(entry.pvpName..(entry.realm and " - "..entry.realm or ""),0.5,0.75,1.0);
	if (entry.guild) then
		GameTooltip:AddLine("<"..entry.guild..">",0.0,0.5,0.8);
	end
	GameTooltip:AddLine(level.." "..entry.race.." "..classText,1,1,1);
	GameTooltip:AddLine(entry.zone,1,1,1);
	GameTooltip:AddLine(ex:FormatTime(time() - entry.time));
	GameTooltip:AddLine(date("%a, %b %d, %Y - %H:%M:%S",entry.time));
	GameTooltip:AddLine("<Shift + Right-Click to Delete>",0.7,0.7,0.7);
	GameTooltip:Show();
end

-- Cache List Sorting
local function CacheListSortFunc(a,b)
	local aValue = cache[a][cfg.cacheSort];
	local bValue = cache[b][cfg.cacheSort];
	if (aValue == bValue) then
		return cache[a].name < cache[b].name;
	elseif (not aValue or not bValue) then
		return aValue and true;
	elseif (type(aValue) == "number") then
		return aValue > bValue;
	else
		return aValue < bValue;
	end
end

-- ScrollBar: Cache list update
local function UpdateShownItems()
	buttons[1]:SetWidth(#ExCacheList > #buttons and 200 or 216);
	FauxScrollFrame_Update(ExaminerCacheScroll,#ExCacheList,#buttons,BUTTON_HEIGHT);
	local gttOwner = GameTooltip:GetOwner();
	local index = ExaminerCacheScroll.offset;
	for i = 1, #buttons do
		index = (index + 1);
		local button = buttons[i];
		if (ExCacheList[index]) then
			local entryName = ExCacheList[index];
			local entry = cache[entryName];
			local color = CLASS_COLORS[entry.classFixed];

			button.entryName = entryName;
			button.name:SetFormattedText("|cffffffff%s|r %s",(entry.level ~= -1 and entry.level or "??"),entry.name);
			button.name:SetTextColor(color.r,color.g,color.b);

			button.value:SetText(cfg.cacheSort ~= "name" and entry[cfg.cacheSort]);

			local coords = EX_RaceCoord[entry.raceFixed];
			local iconOffset = (entry.sex == 3 and 0.5 or 0);
			button.race:SetTexCoord(coords.left,coords.right,coords.top + iconOffset,coords.bottom + iconOffset);

			-- Update Tooltip
			if (button == gttOwner) then
				CacheEntry_OnEnter(button);
			end

			button:Show();
		else
			button:Hide();
		end
	end
end

-- Include Filtered Entry
local function IncludeFilteredEntry(entry,filter,lvlMin,lvlHyphen,lvlMax)
	local include = true;
	-- List Pattern
	for type, string in next, filterList do
		include = (include) and (entry[type]) and (tostring(entry[type]):lower():gsub(" ",""):match(string));
	end
	-- Level Match
	if (lvlMin and lvlMax) then
		include = (include) and (entry.level >= lvlMin and entry.level <= lvlMax);
	elseif (lvlHyphen == "-") then
		include = (include) and (lvlMin and entry.level >= lvlMin or lvlMax and entry.level <= lvlMax);
	elseif (lvlMin) then
		include = (include) and (entry.level == lvlMin);
	end
	-- Name Match & Return
	return (include) and (entry.name:lower():find(filter));
end

-- Build the table used to display the cache (display table)
function mod:BuildCacheList()
	-- We're padding the filter with spaces to fix some pattern matching
	local filter = (" "..cfg.cacheFilter.." ");
	-- Filter List
	for type, string in filter:gmatch(listPattern) do
		filterList[type] = string:lower();
	end
	-- Filter Level
	local lvlMin, lvlHyphen, lvlMax = filter:match(levelPattern);
	if (not lvlMin) then
		lvlMin = filter:match(numberPattern);
	end
	lvlMin, lvlMax = tonumber(lvlMin), tonumber(lvlMax);
	-- Filter Fin
	filter = filter:gsub(levelPattern,""):gsub(numberPattern,""):gsub(listPattern,""):trim():lower();
	local notFiltered = (filter == "" and not lvlMin and not lvlMax and not next(filterList));
	-- Create Display Table
	wipe(ExCacheList);
	for entryName, entry in next, cache do
		if (notFiltered) or (IncludeFilteredEntry(entry,filter,lvlMin,lvlHyphen,lvlMax)) then
			ExCacheList[#ExCacheList + 1] = entryName;
		end
	end
	-- Sort
	if (cfg.cacheSort ~= "none") then
		sort(ExCacheList,CacheListSortFunc);
	end
	-- Update
	self.page.header:SetFormattedText("Cached Players (%d)%s",#ExCacheList,(notFiltered and "" or " |cffffff00*"));
	UpdateShownItems();
	wipe(filterList);
end

--------------------------------------------------------------------------------------------------------
--                                        Cache Frame Creation                                        --
--------------------------------------------------------------------------------------------------------

-- Cache Entries
for i = 1, 10 do
	local btn = CreateFrame("Button",nil,mod.page);
	btn:SetWidth(200);
	btn:SetHeight(BUTTON_HEIGHT);
	btn:RegisterForClicks("LeftButtonDown","RightButtonDown");
	btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	btn.id = i;

	if (i == 1) then
		btn:SetPoint("TOPLEFT",8,-40);
	else
		btn:SetPoint("TOPLEFT",buttons[i - 1],"BOTTOMLEFT");
		btn:SetPoint("TOPRIGHT",buttons[i - 1],"BOTTOMRIGHT");
	end

	btn:SetScript("OnClick",CacheEntry_OnClick);
	btn:SetScript("OnEnter",CacheEntry_OnEnter);
	btn:SetScript("OnLeave",ex.HideGTT);

	btn.race = btn:CreateTexture(nil,"ARTWORK");
	btn.race:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races");
	btn.race:SetPoint("LEFT",3,0);
	btn.race:SetWidth(BUTTON_HEIGHT - 2);
	btn.race:SetHeight(BUTTON_HEIGHT - 2);

	btn.name = btn:CreateFontString(nil,"ARTWORK","GameFontHighlight");
	btn.name:SetPoint("LEFT",btn.race,"RIGHT",3,0);
	btn.name:SetJustifyH("LEFT");

	btn.value = btn:CreateFontString(nil,"ARTWORK","GameFontHighlightExtraSmall");
	btn.value:SetPoint("LEFT",btn.name,"RIGHT",2,0);
	btn.value:SetPoint("RIGHT",-2);
	btn.value:SetJustifyH("RIGHT");

	buttons[i] = btn;
end

-- Cache Scroll
local scroll = CreateFrame("ScrollFrame","ExaminerCacheScroll",mod.page,"FauxScrollFrameTemplate");
scroll:SetPoint("TOPLEFT",buttons[1]);
scroll:SetPoint("BOTTOMRIGHT",buttons[#buttons],-3,-1);
scroll:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self,offset,BUTTON_HEIGHT,UpdateShownItems) end);