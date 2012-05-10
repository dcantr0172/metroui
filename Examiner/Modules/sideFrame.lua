--side frame
--$Rev: 3317 $

local ex = Examiner;
local L = wsLocale:GetLocale("Examiner");
local cfg = Examiner_Config;
local PaperDollFrame = PaperDollFrame;
local ExScanner = ExScanner;
local handler = CreateFrame('Frame', 'ExaminerSideBar', UIParent, 'WS_InsetFrameTemplate');
local toggleButton = CreateFrame('Button', nil, UIParent)

local CATEGORY_GAP = 5
handler.stats = {}

local resistanceColor = {
	[2] = '|CFFFF60FF',		-- arcane
	[3] = '|CFFFF3600',		-- fire
	[4] = '|CFF00C0FF',		-- frost
	[5] = '|CFFFFA400',		-- holy
	[6] = '|CFF00FF60',	-- nature
	[7] = '|CFFAA12AC',	-- shadow
}

local scanner = {}
function scanner:GetBaseInfo(unit)
    local info = {}
    info.name = GENERAL --PLAYERSTAT_BASE_STATS
	--local playerName = UnitName(unit);
	--local guildName, guildRank = GetGuildInfo(unit)
	local maxHealth = UnitHealthMax(unit)
	local maxPower = UnitPowerMax(unit)
	local _, powerType = UnitPowerType(unit)

	tinsert(info, {name = GENERAL});
	tinsert(info, {name = HEALTH, value = maxHealth});
	tinsert(info, {name = _G[powerType], value = maxPower});
	--GetTotalAchievementPoints
	tinsert(info, {name = ACHIEVEMENT_BUTTON, value = GetTotalAchievementPoints()})

    -- resistance
    for i=2,6 do
        local base, total = UnitResistance(unit, i)
        tinsert(info, {
            name = resistanceColor[i] .. _G['DAMAGE_SCHOOL' .. (i+1)] .. '|r',
            value = total-base,
            tip = total,
        })
    end
    
    return info
end

--function scanner:GetResistanceInfo()
--    local info = {}
--
--    return info
--end

function scanner:GetOtherPatterns(unit)
    local infos = {}


	local class = select(2, UnitClass(unit))
	local level = UnitLevel(unit)
	local ExPlayerStat, ExPlayerSet = {}, {}
	ExScanner:ScanUnitItems("player", ExPlayerStat, ExPlayerSet);

	if ExPlayerStat["STR"] or ExPlayerStat["AGI"] or ExPlayerStat["STA"] or ExPlayerStat["INT"] or ExPlayerStat["SPI"] or ExPlayerStat["ARMOR"] then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = PLAYERSTAT_BASE_STATS});
		for token, appvalue in pairs(ExPlayerStat) do
			if token == "STR" then
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "AGI" then
				local valuePct = tonumber(format("%.2f",ExBaseData:GetCritFromAgi(appvalue, class, level))).."%";
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			elseif token == "STA" then
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "INT" then
				local valuePct = tonumber(format("%.2f",ExBaseData:GetSpellCritPerInt(appvalue, class, level))).."%";
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			elseif token == "SPI" then
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue});
			elseif token == "ARMOR" then
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue});
			end
		end
	end

	if ExPlayerStat["HP"] or ExPlayerStat["MP"] or ExPlayerStat["HP5"] or ExPlayerStat["MP5"] then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = HEALTH.." & "..MANA});
		for token, appvalue in pairs(ExPlayerStat) do
			if token == "HP" or token == "MP" or token == "HP5" or token == "MP5" then
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue});
			end
		end
	end

	if ExPlayerStat["AP"] or ExPlayerStat["RAP"] or ExPlayerStat["APFERAL"] or ExPlayerStat["CRIT"] or ExPlayerStat["HIT"] or ExPlayerStat["HASTE"] or ExPlayerStat["WPNDMG"] or ExPlayerStat["RANGEDDMG"] or ExPlayerStat["ARMORPENETRATION"] or ExPlayerStat["ARMORPENETRATIONRATING"] or ExPlayerStat["EXPERTISE"] then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = PLAYERSTAT_MELEE_COMBAT.." & "..PLAYERSTAT_RANGED_COMBAT});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "AP" or token == "RAP" or token == "APFERAL" or token == "CRIT" or token == "HIT" or token == "HASTE" or token == "WPNDMG" or token == "RANGEDDMG" or token == "ARMORPENETRATION" or token == "ARMORPENETRATIONRATING" or token == "EXPERTISE" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if ExPlayerStat["HEAL"] or ExPlayerStat["SPELLDMG"]or ExPlayerStat["ARCANEDMG"] or ExPlayerStat["FIREDMG"] or ExPlayerStat["NATUREDMG"] or ExPlayerStat["FROSTDMG"] or ExPlayerStat["SHADOWDMG"] or ExPlayerStat["HOLYDMG"] or ExPlayerStat["SPELLCRIT"] or ExPlayerStat["SPELLHIT"] or ExPlayerStat["SPELLHASTE"] or ExPlayerStat["SPELLPENETRATION"] then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = PLAYERSTAT_SPELL_COMBAT});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "HEAL" or token == "SPELLDMG"or token =="ARCANEDMG" or token == "FIREDMG" or token == "NATUREDMG" or token == "FROSTDMG" or token == "SHADOWDMG" or token == "HOLYDMG" or token =="SPELLCRIT" or token == "SPELLHIT" or token == "SPELLHASTE" or token == "SPELLPENETRATION" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if ExPlayerStat["DEFENSE"] or ExPlayerStat["DODGE"] or ExPlayerStat["PARRY"] or ExPlayerStat["BLOCK"] or ExPlayerStat["BLOCKVALUE"] or ExPlayerStat["RESILIENCE"] then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = PLAYERSTAT_DEFENSES});
		for token, appvalue in pairs(ExPlayerStat) do
			local valuePct
			if token == "DEFENSE" or token == "DODGE" or token ==  "PARRY" or token == "BLOCK" or token == "BLOCKVALUE" or token == "RESILIENCE" then
				if (ExScanner:GetRatingInPercent(token,appvalue,level)) then
					valuePct = tonumber(format("%.2f",ExScanner:GetRatingInPercent(token,appvalue,level))).."%";
				end
				tinsert(info, {name = ExScanner.StatNames[token], value = appvalue, tip = valuePct});
			end
		end
	end

	if type(ExPlayerSet) == "table" and next(ExPlayerSet) then
        local info = {}
        tinsert(infos, info)
		tinsert(info, {name = L["Sets: "]});
		for setName, setData in pairs(ExPlayerSet) do
			tinsert(info, {name = setName, value = setData.count.."/"..setData.max});
		end
	end
    return infos
end

function handler:RescanPlayer()
    wipe(self.stats)

    tinsert(self.stats, scanner:GetBaseInfo('player'))
    --tinsert(self.stats, scanner:GetResistanceInfo('player'))

    local infos = scanner:GetOtherPatterns('player')
    for i = 1, #infos do
        local info = infos[i]
        tinsert(self.stats, info)
    end
end

function handler:PLAYER_LOGIN(event)
    self:InitiateSideFrame()
    self:InitiateExpandButton();
    self:InitAllCategoryFrame()

    self:UnregisterEvent(event)
    self:RegisterEvent('UNIT_INVENTORY_CHANGED')
end

function handler:UNIT_INVENTORY_CHANGED(event)
    if(handler:IsVisible()) then
        handler:OnShow()
    end
end

handler:RegisterEvent("PLAYER_LOGIN")
handler:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

function handler:InitiateSideFrame()
    self:SetParent(PaperDollFrame)
    self:SetHeight(PaperDollFrame:GetHeight() - 90)
    self:SetWidth(210)
    self:SetPoint('TOPLEFT', PaperDollFrame, 'TOPRIGHT', -35, -14)
    self:Show()
    self:SetScript('OnShow', self.OnShow)
    self:InitiateStatPanel();  
end

function handler:OnShow()
    self:RescanPlayer()
    self:UpdateAllCategoryFrame()
end


function handler:UpdateHeight()
    local height_sum = 0
    for i, panel in ipairs(self.StatsPanel.panels) do
        if(panel:IsShown()) then
            height_sum = height_sum + panel:GetHeight() + CATEGORY_GAP
        end
    end

    self.StatsPanel.ChildPanel:SetHeight(height_sum)
end

function handler:InitiateExpandButton()
    toggleButton:SetParent(PaperDollFrame)
    toggleButton:SetWidth(32);
    toggleButton:SetHeight(32);
    toggleButton:SetPoint("BOTTOMRIGHT", PaperDollFrame, "BOTTOMRIGHT", -40, 80);

    self:HookScript('OnShow', toggleButton.UpdateTexture)
    self:HookScript('OnHide', toggleButton.UpdateTexture)

    self.expandButton = toggleButton
end

function toggleButton:SetLocation()
    self:SetPoint('BOTTOMRIGHT', PaperDollFrame, 15, 30)
end

function toggleButton:UpdateTexture()
    if(handler:IsShown()) then
        toggleButton:SetNormalTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]]
        toggleButton:SetPushedTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]]
        toggleButton:SetDisabledTexture[[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]]
    else
        toggleButton:SetNormalTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]]
        toggleButton:SetPushedTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]]
        toggleButton:SetDisabledTexture[[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]]
    end
end

function toggleButton:ToggleSideFrame()
    if(handler:IsShown()) then
        handler:Hide()
    else
        handler:Show()
    end
    
    self:UpdateTexture()
end
toggleButton:SetScript('OnMouseUp', toggleButton.ToggleSideFrame)

function handler:InitiateStatPanel()
    local WIDTH = self:GetWidth() - 20
    local statsPanel = CreateFrame('ScrollFrame', 'ExaminerSideBarStatsPanel', handler, 'UIPanelScrollFrameTemplate')
    local childPanel = CreateFrame('Frame', 'ExaminerSideBarStatsPanelScrollChind', statsPanel);
    self.StatsPanel =statsPanel
    self.StatsPanel.ChildPanel = childPanel
    
    statsPanel:SetScrollChild(childPanel)
    statsPanel:SetPoint('TOPLEFT', handler, "TOPLEFT", 4, -4)
    statsPanel:SetPoint('BOTTOMRIGHT', handler, "BOTTOMRIGHT", -27, 2)
    local scrollBar = _G[statsPanel:GetName().."ScrollBar"];
    scrollBar.scrollStep = 50
    statsPanel.ScrollBar = scrollBar
    childPanel:SetPoint('TOPLEFT')
    childPanel:SetWidth(WIDTH)

    ScrollFrame_OnLoad(statsPanel)
    ScrollFrame_OnScrollRangeChanged(statsPanel)

    local panels = {}
    statsPanel.panels = panels
    for i = 1, 7 do
        local panel = CreateFrame('Frame', 'ExaminerSideBarStatsFrameCategory' .. i, childPanel, 'wsStatGroupTemplate')
        tinsert(panels, panel)

        panel:SetWidth(WIDTH)
        panel:SetID(i)
        panel.statsFrames = {}

        local prev = panels[i-1]
        if(prev) then
            panel:SetPoint('TOPLEFT', prev, 'BOTTOMLEFT', 0, -CATEGORY_GAP)
        else
            panel:SetPoint('TOPLEFT', childPanel, "TOPLEFT", 8, 0)
        end
    end
end

local function createStatsFrame(parent)
    local i = #parent.statsFrames + 1
    local frame = CreateFrame('Frame', parent:GetName() .. 'Stat' .. i, parent, 'wsStatFrameTemplate')
    frame:SetWidth(140)
    frame.Label:SetWidth(100)
    frame.Label:SetJustifyH('LEFT')
    frame.Label:SetNonSpaceWrap(false)
    frame.Label:SetHeight(frame:GetHeight())
    frame.Value:SetWidth(100)
    
    tinsert(parent.statsFrames, frame)

    return frame
end

function handler:InitAllCategoryFrame()
    for i, panel in ipairs(self.StatsPanel.panels) do
        self:UpdateTextureExpanded(panel)
    end
end

function handler:UpdateAllCategoryFrame()
    for i, panel in ipairs(self.StatsPanel.panels) do
        self:UpdateCategoryStats(panel)
    end

    local num_panel_needed = #self.stats
    if(num_panel_needed < #self.StatsPanel.panels) then
        for i = num_panel_needed+1, #self.StatsPanel.panels do
            self.StatsPanel.panels[i]:Hide()
        end
    end
    
    self:UpdateHeight()
end

function handler:UpdateCategoryStats(frame)
    --frame:SetHeight(200) -- TEST
    local info = self.stats[frame:GetID()]
    if(frame.collapsed or (not info)) then
        return
    end

    --print('UpdateCategoryStats', frame, frame:GetID(), info)
    local sumHeight, lastIndex = 0
    for i, stat in ipairs(info) do
        local statsFrame = frame.statsFrames[i] or createStatsFrame(frame)
        statsFrame.Label:SetText(stat.name)
        
        if(i~=1) then
            statsFrame.Label:SetTextColor(1,1,1)
        end
        statsFrame.Value:SetText(stat.value)
        statsFrame:Show()

        statsFrame.Tip = stat.tip

        local prev = frame.statsFrames[i-1]
        if(prev) then
            statsFrame:SetPoint('TOPLEFT', prev, 'BOTTOMLEFT', 0, -1)
        else
            statsFrame:SetPoint('TOPLEFT', frame, 'TOPLEFT', 15, -2)
        end

        lastIndex = i
        sumHeight = sumHeight + statsFrame:GetHeight() + 2
    end

    if(lastIndex > #frame.statsFrames) then
        for i = lastIndex, #frame.statsFrames do
            frame.statsFrames[i]:Hide()
        end
    end

    --print(sumHeight)
    local MINIMAL_HEIGHT = 40
    frame:SetHeight(sumHeight < MINIMAL_HEIGHT and MINIMAL_HEIGHT or sumHeight)
    frame:Show()
end

function handler:CollapseCategoryFrame(frame)
    for i = 2, #frame.statsFrames do
        frame.statsFrames[i]:Hide()
    end
    frame:SetHeight(frame.statsFrames[1]:GetHeight() + 2)
end

function handler:UpdateTextureCollapsed(frame)
    frame.collapsed = true
    frame.CollapsedIcon:Show()
    frame.ExpandedIcon:Hide()
    frame.BgMinimized:Show()
    frame.BgTop:Hide()
    frame.BgMiddle:Hide()
    frame.BgBottom:Hide()
end

function handler:UpdateTextureExpanded(frame)
    frame.collapsed = false
    frame.CollapsedIcon:Hide()
    frame.ExpandedIcon:Show()
    frame.BgMinimized:Hide()
    frame.BgTop:Show()
    frame.BgMiddle:Show()
    frame.BgBottom:Show()
end

function handler:CategoryFrameOnLick(frame)
    --print(cateFrame:GetName())

    if(frame.collapsed) then
        self:UpdateTextureExpanded(frame)
        self:UpdateCategoryStats(frame)
    else
        self:UpdateTextureCollapsed(frame)
        self:CollapseCategoryFrame(frame)
    end

    self:UpdateHeight()
end

function handler:ShowCategoryFrameTooltip(frame)
    GameTooltip:ClearLines()
    GameTooltip:SetOwner(frame, 'ANCHOR_BOTTOMRIGHT')
    --GameTooltip:SetPoint('TOPLEFT', frame, 'TOPRIGHT', 3, 0)
    local textLeft = frame.Label:GetText()
    local textRight
    if(frame.Tip) then
      textRight = string.format('%s (%s)', frame.Value:GetText(), frame.Tip)
    end
    --GameTooltip:SetText(" ")
    GameTooltip:AddDoubleLine(textLeft, textRight or frame.Value:GetText())
    --print(frame.name)
    GameTooltip:Show()
end
