
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['Remove all notes'] = '移除全部任务点',
    ['Create waypoint'] = '创建箭头指向',
} or GetLocale() == 'zhTW' and {
    ['Remove all notes'] = '移除全部任務點',
    ['Create waypoint'] = '創建箭頭指向',
} or {}, {
    __index = function(t, i)
        t[i] = i
        return i
    end
})


local wsQuest = LibStub('AceAddon-3.0'):GetAddon'wsQuest'
local HandyNotes = HandyNotes
local MapHelper = wsQuest:GetModule'MapHelper'

local CQ = wsQuest:NewModule('CurrentQuest', 'AceEvent-3.0')
local CQ_Handler = {} -- handy notes handler
local CQ_HANDLER_NAME = 'WSCurrentQuest'

local Quixote = LibStub('LibQuixote-2.0')

function CQ:OnInitialize()
    --self:ClearCurrentQuest()

    Quixote.RegisterCallback(self, 'Quest_Complete', 'Quest_Complete')
end

function CQ:ClearCurrentQuest()
    self.current_db = nil
    self.current_uid = nil
    HandyNotes:SendMessage('HandyNotes_NotifyUpdate', CQ_HANDLER_NAME)
end

function CQ:AddPinsOnMap(db, uid)
    self.current_db = db
    self.current_uid = uid
    HandyNotes:SendMessage('HandyNotes_NotifyUpdate', CQ_HANDLER_NAME)
end

function CQ:Quest_Complete(name, title, uid)
    if(self.current_uid == uid) then
        self:ClearCurrentQuest()
    end
end

do
    local MARK_ICON = [[Interface\AddOns\Wowshell_Quest\Mark_Obj]]
    local scale, alpha = 1, 1
    local emptyTbl = {}

    local function iter(t, preState)
        if(not t)then return end
        local state = next(t, preState)

        --print(state, nil, MARK_ICON, scale, alpha)
        if(state) then
            return state, nil, MARK_ICON, scale, alpha, nil
        end
    end

    function CQ_Handler:GetNodes(mapFile, minimap, dungeonLevel)
        if(minimap) then
            return iter, emptyTbl, nil
        else
            --print(CQ.current_uid, CQ.current_db and CQ.current_db[mapFile], mapFile)
            return iter, CQ.current_db and CQ.current_db[mapFile] or emptyTbl, nil
        end
    end
end

function CQ_Handler:OnEnter(mapFile, coord)
    local data = CQ.current_db and CQ.current_db[mapFile]
    local c_d = data and data[coord]

    if(not c_d) then return end

    local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip

    if( self:GetCenter() > UIParent:GetCenter() ) then
        tooltip:SetOwner(self, 'ANCHOR_LEFT')
    else
        tooltip:SetOwner(self, 'ANCHOR_RIGHT')
    end

    tooltip:ClearLines()
    tooltip:AddLine(c_d.questTitle)
    tooltip:AddLine(c_d.npcName)

    tooltip:Show()
end

function CQ_Handler:OnLeave(mapFile, coord)
    if( self:GetParent() == WorldMapButton) then
        WorldMapTooltip:Hide()
    else
        GameTooltip:Hide()
    end
end

do
    local createWaypoint = function(btn, mapFile, coord)
        local c, z = HandyNotes:GetCZ(mapFile)
        local x, y = HandyNotes:getXY(coord)

        local d = CQ.current_db and CQ.current_db[mapFile] and CQ.current_db[mapFile][coord]

        TomTom:AddWaypoint(c, z, x*100, y*100, d.npcName)
    end

    local removeAllNotes = function()
        CQ:ClearCurrentQuest()
    end


    local clickedMapFile, clickedCoord
    local info = {}

    local initMenu = function(btn, lvl)
        if(not lvl) then return end
        wipe(info)

        if(lvl == 1) then
            info.text = L['Create waypoint']
            info.func = createWaypoint
            info.arg1 = clickedMapFile
            info.arg2 = clickedCoord
            info.disabled = nil
            info.icon = nil
            info.notCheckable = nil
            UIDropDownMenu_AddButton(info, lvl)

            info.text = L['Remove all notes']
            info.func = removeAllNotes
            info.arg1 = nil
            info.arg2 = nil
            UIDropDownMenu_AddButton(info, lvl)

            info.text = CLOSE
            info.icon = nil
            info.func = function() CloseDropDownMenus() end
            info.arg1 = nil
            info.notCheckable = 1
            UIDropDownMenu_AddButton(info, lvl)
        end
    end

    local Dropdown = CreateFrame('Frame', 'Wowshell_Quest_HNCQ_Dropdown')
    Dropdown.displayMode = 'MENU'
    Dropdown.initialize = initMenu

    function CQ_Handler:OnClick(button, down, mapFile, coord)
        if(button == 'RightButton' and down) then
            clickedCoord = coord
            clickedMapFile = mapFile
            ToggleDropDownMenu(1, nil, Dropdown, self, 0, 0)
        end
    end
end

HandyNotes:RegisterPluginDB('WSCurrentQuest', CQ_Handler)

