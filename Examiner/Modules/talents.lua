local ex = Examiner;
local L = wsLocale:GetLocale("Examiner")
-- Module
local mod = ex:CreateModule("Talents");
mod.page = CreateFrame("Frame",nil,ex);
mod.page:SetScript("OnEvent",ex.Standard_OnEvent);
mod:CreateButton(L["Talent"],L["Talents"],L["The Inspected Player's Talent Specialization"]);
mod.canCache = true;
mod.details = ex:CreateDetailObject();

-- Variables
local BRANCH_ARRAY = {};
local cfg, cache;
local activeTab = 1;
local activeSpec;
local arrowIndex, branchIndex;
local points = {};

-- Init Talent Branches
for i = 1, MAX_NUM_TALENT_TIERS do
	BRANCH_ARRAY[i] = {};
	for j = 1, NUM_TALENT_COLUMNS do
		BRANCH_ARRAY[i][j] = {};
	end
end

--------------------------------------------------------------------------------------------------------
--                                           Module Scripts                                           --
--------------------------------------------------------------------------------------------------------

-- OnInspect
function mod:OnInitialize()
	cfg = Examiner_Config;
	cache = Examiner_Cache;
end

--IcetipDB
--IcetipDB["mousetarget"].showTalent
-- OnInspect
function mod:OnInspect(unit)
	if (ex.canInspect) then
		self.page:RegisterEvent("INSPECT_TALENT_READY");
		if (cfg.activePage == self.index) then
			mod:UpdateTalents();
		end
		self.button:Enable();
	else
		self.page:Hide();
		self.button:Disable();
	end
end

-- OnCacheLoaded
function mod:OnCacheLoaded(entry,unit)
	if (entry.talentPoints and entry.talentSpec) then
		mod.details:Add(L["Talents"]);
		mod.details:Add(L["Specialization"],entry.talentSpec or UNKNOWN);
		mod.details:Add(L["Points"],entry.talentPoints or entry.talents); -- Az: backward compatibility
		mod.details:Update();
	end
	self.button:Disable();
end

-- OnClearInspect
function mod:OnClearInspect()
	self.details:Clear();
end

--------------------------------------------------------------------------------------------------------
--                                               Events                                               --
--------------------------------------------------------------------------------------------------------
local MAX_TALENT_POINT = 71
local function ColorTalent(point)
	local r, g, b
	local minpoint, maxpoint = 0, MAX_TALENT_POINT
	point = max(0, min(point, MAX_TALENT_POINT));
	if (maxpoint - minpoint) > 0 then
		percent = (point - minpoint)/(maxpoint- minpoint)
	else
		percent = 0
	end
	
	if percent > 0.5 then
		r = 0.1 + (((1-percent)*2) * (1-0.1))
		g = 0.9
	else
		r = 1.0
		g = (0.9) - (0.5-percent)* 2 * (0.9)
	end
	local hexColor = format("|cff%2x%2x18", r*255, g*255);
	return hexColor.."%s|r";
end

local function TalentSpecName(names, nums, colors, icons)
	if type(names) ~= "table" then return end
	if type(nums) ~= "table" then return end
	if type(colors) ~= "table" then return end

	if nums[1] == 0 and nums[2] == 0 and nums[3] == 0 then
		--return _G.NONE, _G.NONE, nil--name, text, icon
		return _G.NONE, nil
	else
		local first, second, third, name, text, point, icon
		if (nums[1] >= nums[2]) then
			if nums[1] >= nums[3] then
				first = 1
				if nums[2] >= nums[3] then 
					second = 2; third=3;	
				else
					second = 3; third = 2; 
				end
			else
				first = 3; second = 1; third = 2
			end
		else
			if nums[2] >= nums[3] then
				first = 2;
				if nums[1] >= nums[3] then
					second = 1; third = 3;
				else
					second = 3; third = 1;
				end
			else
				first = 3; second = 2; third = 1
			end
		end
		local first_num = nums[first]
		local second_num = nums[second]

		if (first_num * 3/4) <= second_num then
			if (first_num * 3/4) < nums[third] then
				name = colors[first]:format(names[first]).."/"..colors[second]:format(names[second]).."/"..colors[third]:format(names[third])
				text = names[first].."/"..names[second].."/"..names[third]
				icon = icons[first]
			else
				name = colors[first]:format(names[first]).."/"..colors[second]:format(names[second])
				text = names[first].."/"..names[second]
				icon = icons[first]
			end
		else
			name = colors[first]:format(names[first])
			text = names[first]
			icon = icons[first]
		end

		point = (" %s/%s/%s"):format(colors[1]:format(nums[1]), colors[2]:format(nums[2]), colors[3]:format(nums[3]))
		return name.."\n"..point, icon
	end
end


-- Talent Update
function mod.page:INSPECT_TALENT_READY(event)
	self:UnregisterEvent(event);
	if (cfg.activePage == mod.index) then
		mod:UpdateTalents();
	end
	-- Gather Talent Info
	local group = GetActiveTalentGroup(true);
	local maxTree = 1;
	local combined = 0;
	for i = 1, MAX_TALENT_TABS do
		points[i] = select(3,GetTalentTabInfo(i,true,nil,group))
		combined = (combined + points[i]);
		if (points[i] > points[maxTree]) then
			maxTree = i;
		end
	end
	local talentPoints = points[1].."/"..points[2].."/"..points[3];
	-- Fancy level estimate since we can determine it from talents
	if (ex.info.level == -1) and (combined > 0) then
		ex.info.level = (combined + 9);
		ex.details:SetText(ex:UnitDetailString());
	end
	-- Details
	local talentSpec = GetTalentTabInfo(maxTree,true,nil,group);
	mod.details:Add(L["Talents"]);
	mod.details:Add(L["Specialization"],combined > 0 and talentSpec or "No Talents");
	mod.details:Add(L["Points"],talentPoints);
	mod.details:Update();

	--update for info box
	local a, aicon, apoint = GetTalentTabInfo(1,true)
	local b, bicon, bpoint = GetTalentTabInfo(2,true)
	local c, cicon, cpoint = GetTalentTabInfo(3,true)
	local pcolor1, pcolor2, pcolor3 = ColorTalent(apoint), ColorTalent(bpoint),ColorTalent(cpoint)
	local talent_name, talent_icon = TalentSpecName({a,b,c}, {apoint,bpoint,cpoint},{pcolor1, pcolor2, pcolor3}, {aicon, bicon, cicon})
	if (getglobal("Examiner_BaseInfoBox")) then
		local box = _G["Examiner_BaseInfoBox"];
		box.talenticon:SetTexture(talent_icon);
		box.talenttext:SetText("|cff80ff80"..L["Current Activate"].."|r: "..talent_name);
	end

	for i = 1, 2 do
		local btn = getglobal("Examiner_SpecTab"..i)
	end

	--remove
	-- Az: this needs a change, we no longer use this type of cache
	if (mod:CanCache()) then
		local cacheEntry = cache[ex:GetEntryName()];
		if (cacheEntry) and (time() - cacheEntry.time <= 8) then
			cacheEntry.talentSpec = talentSpec;
			cacheEntry.talentPoints = talentPoints;
			cacheEntry.level = ex.info.level;
		end
	end
end

--------------------------------------------------------------------------------------------------------
--                                                Menu                                                --
--------------------------------------------------------------------------------------------------------

-- Menu Init Items
function mod.MenuInit(parent,list)
	local group = GetActiveTalentGroup(true);
	local _, _, p1 = GetTalentTabInfo(1,true,nil,2);
	local _, _, p2 = GetTalentTabInfo(2,true,nil,2);
	local _, _, p3 = GetTalentTabInfo(3,true,nil,2);
	local noSecondary = (p1 + p2 + p3 == 0);
	list[1].text = L["Shown Spec"]; list[1].header = 1;
	list[2].text = L["Active"]; list[2].value = nil; list[2].checked = (cfg.shownSpec == nil);
	list[3].text = (group == 1 and "|cff80ff80" or "")..L["Primary"]; list[3].value = 1; list[3].checked = (cfg.shownSpec == 1);
	list[4].text = (group == 2 and "|cff80ff80" or noSecondary and "|cffff8080" or "")..L["Secondary"]; list[4].value = 2; list[4].checked = (cfg.shownSpec == 2);
end

-- Menu Select Item
function mod.MenuSelect(parent,entry)
	cfg.shownSpec = entry.value;
	if (cfg.activePage == mod.index) then
		mod:UpdateTalents();
	end
end

--------------------------------------------------------------------------------------------------------
--                                       Talent Button Functions                                      --
--------------------------------------------------------------------------------------------------------

-- Select Tab
local function TalentsTab_OnClick(self,button)
	activeTab = self.id;
	PanelTemplates_SetTab(ex,activeTab);
	mod:UpdateTalents();
end

-- Talent OnClick
local function TalentButton_OnClick(self,button)
	if (IsModifiedClick("CHATLINK")) and (ChatFrameEditBox:IsVisible()) then
		ChatFrameEditBox:Insert(GetTalentLink(activeTab,self.id,true,nil,activeSpec));
	end
end

-- Talent OnEnter
local function TalentButton_OnEnter(self,motion)
	GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
	GameTooltip:SetTalent(activeTab,self.id,true,nil,activeSpec);
end

-- Create Talent Button
local function CreateTalentButton(parent,index)
	local btn = CreateFrame("Button",nil,parent);
	btn:SetWidth(37);
	btn:SetHeight(37);
	btn:SetScript("OnClick",TalentButton_OnClick);
	btn:SetScript("OnEnter",TalentButton_OnEnter);
	btn:SetScript("OnLeave",ex.HideGTT);
	btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square");
	btn.id = index;

	btn.icon = btn:CreateTexture(nil,"BORDER");
	btn.icon:SetPoint("TOPLEFT",1,-1);
	btn.icon:SetPoint("BOTTOMRIGHT",-1,1);

	btn.slot = btn:CreateTexture(nil,"BACKGROUND");
	btn.slot:SetTexture("Interface\\Buttons\\UI-EmptySlot-White");
	btn.slot:SetWidth(64);
	btn.slot:SetHeight(64);
	btn.slot:SetPoint("CENTER");

	btn.rankBorder = btn:CreateTexture(nil,"OVERLAY");
	btn.rankBorder:SetTexture("Interface\\TalentFrame\\TalentFrame-RankBorder");
	btn.rankBorder:SetWidth(32);
	btn.rankBorder:SetHeight(32);
	btn.rankBorder:SetPoint("CENTER",btn,"BOTTOMRIGHT");

	btn.rank = btn:CreateFontString(nil,"OVERLAY","GameFontNormalSmall");
	btn.rank:SetPoint("CENTER",btn.rankBorder,0,1);

	return btn;
end

--------------------------------------------------------------------------------------------------------
--                                           Widget Creation                                          --
--------------------------------------------------------------------------------------------------------

-- OnShow
local function OnShow(self)
	mod:UpdateTalents();
	ex.model:Hide();
	ex.details:Hide();
	ex.guild:Hide();
	ex:ShowBackground(true);
	ExaminerSideBar:Hide();
end

-- OnHide
local function OnHide(self)
	ex.model:Show();
	ex.details:Show();
	ex.guild:Show();
	ex:ShowBackground();
	ex:SetBackgroundTexture();
	ExaminerSideBar:Show()
end

-- Talent Page
mod.page:SetWidth(320);
mod.page:SetHeight(354);
mod.page:SetPoint("BOTTOM",-11,10);
mod.page:Hide();
mod.page:SetScript("OnShow",OnShow);
mod.page:SetScript("OnHide",OnHide);

-- Scroll
local sc = CreateFrame("ScrollFrame","ExaminerTalentsScrollChild",mod.page,"UIPanelScrollFrameTemplate");
sc:SetPoint("TOPLEFT",ex.model,0,-2);
sc:SetPoint("BOTTOMRIGHT",ex.model,-25,25);

-- Scroll Child Frame
local scf = CreateFrame("Frame","ExaminerScrollChildFrame");
scf:SetWidth(320);
scf:SetHeight(1);
sc:SetScrollChild(scf);

--toggle primary/secondary talent button
--UpdateTalents
--初始化总是在1
---create spec tab
local specTabs = {}
for i=1, 2 do
	local btn = CreateFrame("CheckButton", "Examiner_SpecTab"..i, mod.page);
	btn:SetID(i)
	btn:SetWidth(32)
	btn:SetHeight(32)
	local bg = btn:CreateTexture(btn:GetName().."Background", "BACKGROUND")
	bg:SetTexture("Interface\\SpellBook\\SpellBook-SkillLineTab");
	bg:SetWidth(64);
	bg:SetHeight(64);
	bg:SetPoint("TOPLEFT", -3, 11);
	specTabs[i] = btn
	
	local overlayicon = btn:CreateTexture(btn:GetName().."OverlayIcon", "ARTWORK");
	overlayicon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");--默认修改为问号
	overlayicon:SetWidth(32)
	overlayicon:SetHeight(32)
	overlayicon:SetPoint("CENTER", 0, 0)
	btn.overlayicon = overlayicon

	if i == 1 then
		btn:SetPoint("TOPLEFT", mod.page, "TOPRIGHT", 7, -10);
	else
		btn:SetPoint("TOPLEFT", "Examiner_SpecTab"..(i-1), "BOTTOMLEFT", 0, -22)
	end

	btn:SetScript("OnClick", function(self)
		local id = self:GetID();
		cfg.shownSpec = id;
		mod:UpdateTalents();
		for _, frame in next, specTabs do
			frame:SetChecked(nil);
		end
		self:SetChecked(1);
		self:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight");
	end)
	
	btn:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		local id = self:GetID();
		GameTooltip:AddLine(L["Toggle Talent "]..id);
		GameTooltip:Show()
	end)

	btn:SetScript("OnLeave", ex.HideGTT)
end

-- Talent Tabs
for i = 1, MAX_TALENT_TABS do
	local tab = CreateFrame("Button","ExaminerTab"..i,mod.page,"TabButtonTemplate");
	tab.id = i;
	tab:SetScript("OnClick",TalentsTab_OnClick);
	if (i == 1) then
		tab:SetPoint("TOPLEFT",45,36);
	else
		tab:SetPoint("LEFT","ExaminerTab"..(i - 1),"RIGHT");
	end
end
ex.selectedTab = 1;
PanelTemplates_SetNumTabs(ex,3);
PanelTemplates_UpdateTabs(ex);

-- Talent Buttons -- Az: workaround, if I create these dynamically with a metatable (see commented out line below), the framelevel/strata of the arrowframe screws up, seems like a blizzard ui bug
local talentBtns = {};
for i = 1, 40 do
	talentBtns[i] = CreateTalentButton(scf,i);
end

-- ArrowFrame -- To make them appear above talent buttons
local af = CreateFrame("Frame",nil,scf);
af:SetAllPoints();

-- Talent Buttons + Arrows + Branches
--local talentBtns = setmetatable({},{ __index = function(t,k) t[k] = CreateTalentButton(scf,k); return t[k]; end });
local branches = setmetatable({},{ __index = function(t,k) t[k] = scf:CreateTexture(nil,"BACKGROUND","TalentBranchTemplate"); return t[k]; end });
local arrows = setmetatable({},{ __index = function(t,k) t[k] = af:CreateTexture(nil,"OVERLAY","TalentArrowTemplate"); return t[k]; end });

--------------------------------------------------------------------------------------------------------
--                                              Functions                                             --
--------------------------------------------------------------------------------------------------------

-- Branch
local function SetBranchTexture(coords,x,y)
	local branch = branches[branchIndex];
	branch:SetTexCoord(unpack(coords));
	branch:SetPoint("TOPLEFT",x,y);
	branch:Show();
	branchIndex = (branchIndex + 1);
end

-- Arrows
local function SetArrowTexture(coords,x,y)
	local arrow = arrows[arrowIndex];
	arrow:SetTexCoord(unpack(coords));
	arrow:SetPoint("TOPLEFT",x,y);
	arrow:Show();
	arrowIndex = (arrowIndex + 1);
end

-- CalculateBranchLines
local function CalculateBranchLines(tier,column,rank,...)
	local type = (rank > 0 and 1 or -1);
	for i = 1, select("#",...), 4 do
		local preTier, preColumn = select(i,...);
		local left = min(preColumn,column);
		local right = max(preColumn,column);
		-- Same Column
		if (preColumn == column) then
			for i = preTier, tier - 1 do
				BRANCH_ARRAY[i][column].down = type;
				if (i + 1 <= tier - 1) then
					BRANCH_ARRAY[i + 1][column].up = type;
				end
			end
			BRANCH_ARRAY[tier][column].topArrow = type;
		-- Same Tier
		elseif (preTier == tier) then
			for i = left, right - 1 do
				BRANCH_ARRAY[tier][i].right = type;
				BRANCH_ARRAY[tier][i + 1].left = type;
			end
			BRANCH_ARRAY[tier][column][preColumn < column and "leftArrow" or "rightArrow"] = type
		-- Diagonal
		else
			local blocked;
			for i = preTier, tier - 1 do
				if (BRANCH_ARRAY[i][column].id) then
					blocked = true;
-- Az: debug, going to keep this in, one day talent trees might change so this is needed, this way people can see Examiner is the cause
AzMsg("|2Examiner Talent Module:|r blocked path |1"..tier.." x "..i.."|r    left = |1"..left.."|r, right = |1"..right);
					break;
				end
			end
			-- Top Connection -- Az: Currently, as of patch 3.1, no classes actually has a blocking talent above, so I haven't been able to test it, and it will most likely not be correct
			if (blocked) then
				for i = preTier, tier - 1 do
					BRANCH_ARRAY[i][column].up = type;
					BRANCH_ARRAY[i + 1][column].down = type;
				end
				BRANCH_ARRAY[tier][column][preColumn < column and "leftArrow" or "rightArrow"] = type
			-- Left/Right Connection
			else
				for i = preTier, tier - 1 do
					BRANCH_ARRAY[i][column].down = type;
					BRANCH_ARRAY[i + 1][column].up = type;
				end
				for i = left, right - 1 do
					BRANCH_ARRAY[preTier][i].right = type;
					BRANCH_ARRAY[preTier][i + 1].left = type;
				end
				BRANCH_ARRAY[tier][column].topArrow = type;
			end
		end
	end
end

-- Update Talents
function mod:UpdateTalents()
	activeSpec = cfg.shownSpec or GetActiveTalentGroup(true);
	local name, icon, pointsSpent, background, previewPointsSpent = GetTalentTabInfo(activeTab,true,nil,activeSpec);

	if (not name) then
		return;
	end

	local specTab = _G["Examiner_SpecTab"..activeSpec];
	if specTab then
		specTab:SetChecked(1);
		specTab:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight");
	end
	ex:SetBackgroundTexture("Interface\\TalentFrame\\"..background.."-");
	
	
	--update tabs icon
	local a, aicon, apoint = GetTalentTabInfo(1,true, nil, activeSpec)
	local b, bicon, bpoint = GetTalentTabInfo(2,true, nil, activeSpec)
	local c, cicon, cpoint = GetTalentTabInfo(3,true, nil, activeSpec)
	local pcolor1, pcolor2, pcolor3 = ColorTalent(apoint), ColorTalent(bpoint),ColorTalent(cpoint)
	local talent_name, talent_icon = TalentSpecName({a,b,c}, {apoint,bpoint,cpoint},{pcolor1, pcolor2, pcolor3}, {aicon, bicon, cicon})
	if talent_icon then
		specTabs[activeSpec].overlayicon:SetTexture(talent_icon)
	else
		specTabs[activeSpec].overlayicon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
	end

	-- Update Tabs
	for i = 1, MAX_TALENT_TABS do
		local tab = _G["ExaminerTab"..i];
		local tabName, icon, pointsSpent = GetTalentTabInfo(i,true,nil, activeSpec);
		tab:SetFormattedText("%s |cff00ff00%d",tabName,pointsSpent);
		PanelTemplates_TabResize(tab,-18);
	end
	-- Reset Prereq
	arrowIndex = 1;
	branchIndex = 1;
	for i = 1, MAX_NUM_TALENT_TIERS do
		for j = 1, NUM_TALENT_COLUMNS do
			wipe(BRANCH_ARRAY[i][j])
		end
	end
	-- Talents
	local numTalents = GetNumTalents(activeTab,true,nil);
	for i = 1, numTalents do
		local name, iconTexture, tier, column, rank, maxRank, isExceptional, meetsPrereq, previewRank, meetsPreviewPrereq = GetTalentInfo(activeTab,i,true,nil,activeSpec);
		local btn = talentBtns[i];
		BRANCH_ARRAY[tier][column].id = i;
		CalculateBranchLines(tier,column,rank,GetTalentPrereqs(activeTab,i,true,nil,activeSpec));

		btn:Show();
		btn:ClearAllPoints();
		btn:SetPoint("TOPLEFT",(column - 1) * 63 + 35,(tier - 1) * -63 - 20);
		btn.icon:SetTexture(iconTexture);
		btn.icon:SetTexCoord(0.07,0.93,0.07,0.93);

		if (rank == 0) then
			btn.icon:SetDesaturated(true);
			btn.rankBorder:Hide();
			btn.rank:Hide();
			btn.slot:SetVertexColor(0.5, 0.5, 0.5);
		else
			btn.icon:SetDesaturated(false);
			btn.rankBorder:Show();
			btn.rank:Show();
			btn.rank:SetText(rank);
			if (rank < maxRank) then
				btn.slot:SetVertexColor(0.1,1,0.1);
				btn.rank:SetTextColor(0,1,0);
			else
				btn.slot:SetVertexColor(1,0.82,0);
				btn.rank:SetTextColor(1,0.82,0);
			end
		end
	end
	-- Draw Branches + Arrows
	local ignoreUp;
	for i = 1, MAX_NUM_TALENT_TIERS do
		for j = 1, NUM_TALENT_COLUMNS do
			local node = BRANCH_ARRAY[i][j];
			local x = ((j - 1) * 63) + INITIAL_TALENT_OFFSET_X + 2;
			local y = -((i - 1) * 63) - INITIAL_TALENT_OFFSET_Y - 2;
			-- Node
			if (node.id) then
				-- branches
				if (node.up) then
					if (ignoreUp) then
						ignoreUp = nil;
					else
						SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.up[node.up],x,y + TALENT_BUTTON_SIZE);
					end
				end
				if (node.down) then
					SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.down[node.down],x,y - TALENT_BUTTON_SIZE + 1);
				end
				if (node.left) then
					SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.left[node.left],x - TALENT_BUTTON_SIZE,y);
				end
				if (node.right) then
					SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.right[node.right],x + TALENT_BUTTON_SIZE,y);
				end
				-- arrows
				if (node.rightArrow) then
					SetArrowTexture(TALENT_ARROW_TEXTURECOORDS.right[node.rightArrow],x + 5 + TALENT_BUTTON_SIZE / 2,y);
				end
				if (node.leftArrow) then
					SetArrowTexture(TALENT_ARROW_TEXTURECOORDS.left[node.leftArrow],x - 5 - TALENT_BUTTON_SIZE / 2,y);
				end
				if (node.topArrow) then
					SetArrowTexture(TALENT_ARROW_TEXTURECOORDS.top[node.topArrow],x,y + 5 + TALENT_BUTTON_SIZE / 2);
				end
			-- No Node
			elseif (node.up and node.left and node.right) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.tup[node.up],x,y);
			elseif (node.down and node.left and node.right) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.tdown[node.down],x,y);
			elseif (node.left and node.down) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.topright[node.left],x,y);
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.down[node.down],x,y - 32);
			elseif (node.left and node.up) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.bottomright[node.left],x,y);
			elseif (node.left and node.right) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.right[node.right],x + TALENT_BUTTON_SIZE,y);
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.left[node.left],x + 1,y);
			elseif (node.right and node.down) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.topleft[node.right],x,y);
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.down[node.down],x,y - 32);
			elseif (node.right and node.up) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.bottomleft[node.right],x,y);
			elseif (node.up and node.down) then
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.up[node.up],x,y);
				SetBranchTexture(TALENT_BRANCH_TEXTURECOORDS.down[node.down],x,y - 32);
				ignoreUp = 1;
			end
		end
	end
	-- Hide Remaining Objects
	for i = numTalents + 1, #talentBtns do
		talentBtns[i]:Hide();
	end
	for i = branchIndex, #branches do
		branches[i]:Hide();
	end
	for i = arrowIndex, #arrows do
		arrows[i]:Hide();
	end
end