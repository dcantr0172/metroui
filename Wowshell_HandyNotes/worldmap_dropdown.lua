
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['Map Points'] = '地图坐标点',
    ['Missing quests'] = '未接任务',
    ['OTHERS'] = '其他',
    ['PROFESSIONS'] = '专业训练师',
    ['CLASSES'] = '职业训练师',
    ['FlightMasters'] = '飞行点',
} or GetLocale() == 'zhTW' and {
    ['Map Points'] = '地圖坐標點',
    ['Missing quests'] = '未接任務',
    ['OTHERS'] = '其他',
    ['PROFESSIONS'] = '專業訓練師',
    ['CLASSES'] = '職業訓練師',
    ['FlightMasters'] = '飛行點',
} or {}, { __index = function(t, i) t[i] = i; return i end })

local WSHN = Wowshell_HandyNotes
local HandyNotes = HandyNotes

local btn = CreateFrame('Button', 'WSHN_WorldMapButton', WorldMapFrame, 'UIPanelButtonTemplate2')

btn:SetPoint('TOPRIGHT', WorldMapDetailFrame, 'TOPRIGHT', -30, 68)
btn:SetWidth(100)
btn:SetText(L['Map Points'])

local dropDown = CreateFrame('Frame', 'WSHN_DropDown')

dropDown.displayMode = 'MENU'


local function toggleDisplay(_, pluginName)
    local ep = HandyNotes.db.profile.enabledPlugins
    ep[pluginName] = not ep[pluginName]

    HandyNotes:UpdatePluginMap(nil, pluginName)
end

local cats_enabled = {}
local function toggleCat(_, cat)
    local ep = HandyNotes.db.profile.enabledPlugins
    cats_enabled[cat] = not cats_enabled[cat]
    local enabled = cats_enabled[cat]

    local nodes = WSHN.List[cat]
    for _, node in next, nodes do
        ep[node.text] = enabled
        HandyNotes:UpdatePluginMap(nil, node.text)
    end
end

local function getEnabled(pName)
    return HandyNotes.db.profile.enabledPlugins[pName]
end

local info = {}
dropDown.initialize = function(self, level)
    wipe(info)

    info.isNotRadio = true
    info.keepShownOnClick = true
    info.isTitle = nil
    info.disabled = nil

    if(level==1) then
        info.notCheckable = true

        for mtitle, mv in next, WSHN.List do
            info.text = L[mtitle]
            info.value = mtitle
            info.func = toggleCat
            info.arg1 = mtitle
            info.hasArrow = true
            UIDropDownMenu_AddButton(info, level)
        end

        --info.text = 'test'
        --info.value = 'sub1'
        --info.func = toggleDisplay
        --UIDropDownMenu_AddButton(info, level)

        info.value = nil
        info.hasArrow = false

        if(HandyNotes.plugins['wsMissingQuest']) then
            info.text = L['Missing quests']
            info.arg1 = 'wsMissingQuest'
            info.func = toggleDisplay
            info.notCheckable = false
            info.checked = getEnabled'wsMissingQuest'
            UIDropDownMenu_AddButton(info, level)
        end

        if(HandyNotes.plugins['FlightMasters']) then
            info.text = L['FlightMasters']
            info.arg1 = 'FlightMasters'
            info.func = toggleDisplay
            info.notCheckable = false
            info.checked = getEnabled'FlightMasters'
            UIDropDownMenu_AddButton(info, level)
        end

        info.text = CLOSE
        info.func = nil
        info.notCheckable = true
        info.checked = false
        UIDropDownMenu_AddButton(info, level)

    elseif(level == 2) then
        local subtd = UIDROPDOWNMENU_MENU_VALUE and WSHN.List[UIDROPDOWNMENU_MENU_VALUE]
        if(not subtd) then return end

        for _, td in next, subtd do
            info.text = td.text
            info.arg1 = td.text
            info.func = toggleDisplay
            info.notCheckable = false
            info.checked = getEnabled(td.text)
            UIDropDownMenu_AddButton(info, level)
        end

        --info.text = 'test'
        --UIDropDownMenu_AddButton(info, level)

    end
end

btn:SetScript('OnClick', function(self)
    ToggleDropDownMenu(1, nil, dropDown, self:GetName(), 0, 0)
end)



