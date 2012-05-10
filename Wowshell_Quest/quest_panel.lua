-- 任务面板增强
-- 增加系列提示, 接任务NPC等
local wsQuest = LibStub('AceAddon-3.0'):GetAddon'wsQuest'
local HandyNotes = HandyNotes

local wsPanel = wsQuest:NewModule('Panel', 'AceEvent-3.0')

local wsData = wsQuest:GetModule'Data'
local MapHelper = wsQuest:GetModule'MapHelper'
local CQ = wsQuest:GetModule'CurrentQuest'

-- local helper
wsPanel.callbacks = {}
wsPanel.widget_helpers = {}
local callbacks = wsPanel.callbacks

local L = setmetatable(GetLocale() == 'zhTW' and {
    ['Start Npc'] = '任務開始',
    ['End Npc'] = '任務結束',
    ['not found'] = '未找到',
    ['No quest data'] = '暫無資料',
    ['Req lvl:'] = '需要等級',
    ['Quest sharable'] = '可共享',
} or GetLocale() == 'zhCN' and {
    ['Start Npc'] = '任务开始',
    ['End Npc'] = '任务结束',
    ['not found'] = '未找到',
    ['No quest data'] = '暂无数据',
    ['Req lvl:'] = '需要等级',
    ['Quest sharable'] = '可共享',
} or {}, { __index = function(t, i) return i end})



------------------------------
--      madness
------------------------------

function wsPanel:OnEnable()
    -- pass
end

function wsPanel:OnInitialize()
    self.marks = {}

    self:CreateQuestMarks()
    self:CreateQuestObjectsMarks()

    hooksecurefunc('QuestLog_UpdateQuestDetails', function(...)
        self:QuestLog_UpdateQuestDetails(...)
    end)
end

function wsPanel:QuestLog_UpdateQuestDetails()
    local currentQuestLink = GetQuestLink(GetQuestLogSelection())
    local uid = currentQuestLink and wsData:GetQuestID(currentQuestLink)
    local data = wsData:GetQuestData(uid)

    self.CurrentQuestUID = uid
    self.CurrentQuestData = data

    if(data and data.objs) then
        --self.marks.info:Show()
        --self.marks.complete:Show()
        --self.marks.start:Show()
        self:UpdateQuestObjectButton(data)
    else
        -- hide quest object marks only
        for _, k in ipairs(self.marks) do
            k:Hide()
        end
    end
end

function wsPanel:UpdateQuestObjectButton(qdata)
    for i = 1, 9 do
        local qobj = _G['QuestInfoObjective'..i]
        local infobtn = self.marks[i]
        if(qobj:IsShown() and qdata.objs[i] and qdata.objs[i].npcs) then
            infobtn.data = {
                quest = qdata.title_full,
                obj = qdata.objs[i],
            }
            infobtn:ClearAllPoints()
            infobtn:SetPoint('TOPLEFT', qobj, 'TOPLEFT', 0, 0)
            infobtn:SetPoint('BOTTOMRIGHT', qobj, 'BOTTOMRIGHT', 0, 0)

            infobtn:Show()
        else
            infobtn:Hide()
        end
    end
end

--[[
--      These marks will appear at the top right of the
--      quest detail panel.
--]]
function wsPanel:CreateQuestMarks()
    local start = self:NewMarkButton('WSQuestStartButton', 'start')
    self.marks.start = start
    start.icon:SetTexture[[Interface\GossipFrame\AvailableQuestIcon]]
    start:SetPoint('TOPRIGHT', 'QuestLogDetailScrollChildFrame', 'TOPRIGHT', -35, -5)

    local complete = self:NewMarkButton('WSQuestCompleteButton', 'complete')
    self.marks.complete = complete
    complete.icon:SetTexture[[Interface\GossipFrame\ActiveQuestIcon]]
    complete:SetPoint('TOPRIGHT', 'QuestLogDetailScrollChildFrame', 'TOPRIGHT', -19, -5)

    local info = self:NewMarkButton('WSQuestInfoButton', 'info')
    self.marks.info = info
    info.icon:SetTexture[[Interface\GossipFrame\BinderGossipIcon]]
    info:SetPoint('TOPRIGHT', 'QuestLogDetailScrollChildFrame', 'TOPRIGHT', -3, -5)
end

--[[
--      Buttons for quest objects
--]]
function wsPanel:CreateQuestObjectsMarks()
    local numObjs = 9

    for i = 1, numObjs do
        local btn = self:NewMarkButton('IceQuestHelper_ObjButton'..i, 'obj')
        btn:SetID(i)
        btn.icon:SetTexture[[Interface\GossipFrame\PetitionGossipIcon]]

        btn.icon:ClearAllPoints()
        btn.icon:SetHeight(16)
        btn.icon:SetWidth(16)
        btn.icon:SetPoint('TOPRIGHT', btn, 'TOPRIGHT', -1, 0)

        tinsert(self.marks, btn)
        btn:Hide()
    end

end

function wsPanel:NewMarkButton(name, typ)
    local btn = CreateFrame('Button', name, QuestLogDetailScrollChildFrame)
    btn.name = typ
    btn:SetWidth(16)
    btn:SetHeight(16)
    --btn:SetPoint('TOPRIGHT', 'QuestLogDetailScrollChildFrame', 'TOPRIGHT', -35, -5)
    btn.icon = btn:CreateTexture(nil, 'BACKGROUND')
    btn.icon:SetAllPoints(btn)
    --btn.icon:SetTexture[[Interface\GossipFrame\AvailableQuestIcon]]
    btn:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], 'ADD')

    btn:Show()

    for _, s in next, {'OnClick', 'OnEnter', 'OnLeave'} do
        btn:SetScript(s, self:GetBindFunc(btn, s))
    end

    return btn
end

function wsPanel:GetBindFunc(btn, scriptType)
    local scripts = callbacks[btn.name]
    local func = scripts and scripts[scriptType]
    return func
end

callbacks.hidetip = function(self)
    if(GameTooltip:GetOwner() == self) then
        GameTooltip:Hide()
    end
end

callbacks.add_npc_waypoint = function(npcdata)
    local c, z, x, y
    local zonename

    local loc = npcdata.loc
    for zone_name, zone_data in pairs(loc) do
        for _,coords in ipairs(zone_data) do
            x = coords.x
            y = coords.y
            zonename = zone_name
            break
        end
        if(x and y and x~=0 and y~=0) then
            break
        end
    end

    if(x==0 and y==0) then return end
    if(not zonename) then return end

    c, z = HandyNotes:GetZoneToCZ(zonename)
    if not (c and z) then return end

    MapHelper:AddWaypointToTomtom(c, z, x, y, npcdata.name)
end

callbacks.start = {
    OnClick = function(self)
        if(self.waypoint_data) then
            callbacks.add_npc_waypoint(self.waypoint_data)
        end
    end,

    OnEnter = function(self)
        local data = wsData:GetQuestData(wsPanel.CurrentQuestUID, 1)

        local startNpc = data and data.startNpc and wsData:GetNpc(data.startNpc)
        self.waypoint_data = startNpc

        GameTooltip:SetOwner(self, 'ANCHOR_NONE')
        GameTooltip:SetPoint('BOTTOMRIGHT', self, 'TOPLEFT', 5, -10)

        GameTooltip:AddLine(L['Start Npc'], 1, .5, 0)
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(startNpc and startNpc.name or L['not found'], 1,1,1)

        GameTooltip:Show()
    end,

    OnLeave = function(self)
        callbacks.hidetip(self)
        self.waypoint_data = nil
    end,
}

callbacks.complete = {
    OnClick = function(self)
        if(self.waypoint_data) then
            callbacks.add_npc_waypoint(self.waypoint_data)
        end
    end,

    OnEnter = function(self)
        local data = wsData:GetQuestData(wsPanel.CurrentQuestUID, 1)

        local endNpc = data and data.endNpc and wsData:GetNpc(data.endNpc)
        self.waypoint_data = endNpc

        GameTooltip:SetOwner(self, 'ANCHOR_NONE')
        GameTooltip:SetPoint('BOTTOMRIGHT', self, 'TOPLEFT', 5, -10)

        GameTooltip:AddLine(L['End Npc'], 1, .5, 0)
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(endNpc and endNpc.name or L['not found'], 1,1,1)

        GameTooltip:Show()
    end,

    OnLeave = function(self)
        callbacks.hidetip(self)
        self.waypoint_data = nil
    end,
}

callbacks.info = {
    OnClick = function(self)
    end,

    OnEnter = function(self)
        GameTooltip:SetOwner(self, 'ANCHOR_NONE')
        GameTooltip:SetPoint('BOTTOMRIGHT', self, 'TOPLEFT', 5, -10)

        local questData = wsData:GetQuestData(wsPanel.CurrentQuestUID)

        if(not questData) then
            GameTooltip:AddLine(L['No quest data'], 1, .2, 0)
            GameTooltip:Show()
            return
        end

        GameTooltip:AddLine(questData.title_full, 1, .5, 0)

        if(questData.req_level) then
            GameTooltip:AddDoubleLine(L['Req lvl:'], questData.req_level, .8, 1, 0, 1,1,1)
        end

        if(questData.sharable) then
            GameTooltip:AddDoubleLine(' ', L['Quest sharable'], 1,1,1, 1,1,1)
        end

        if(questData.series) then
            GameTooltip:AddLine(' ')
            for _, s_qid in next, questData.series do
                local s_data = wsData:GetQuestData(s_qid, 1)
                local c = GetQuestDifficultyColor(s_data.level)
                GameTooltip:AddLine(s_data.title_full, c.r, c.g, c.b)
            end
        end

        GameTooltip:Show()
    end,

    OnLeave = function(self)
        callbacks.hidetip(self)
    end,
}

local function sendToTomtom(self)
    local locdata
    if(self.data and self.data.obj and self.data.obj.npcs) then
        for k, v in next, self.data.obj.npcs do
            locdata = v
            break -- found the answer, break the loop
        end
    else
        return
    end
    if not (locdata and locdata.loc) then return end

    local mapname, x, y
    do
        local zone, coords_data = next(locdata.loc)
        local _, coords = next(coords_data)
        mapname = zone
        x, y = coords.x, coords.y
    end

    --        for k, v in next, locdata.loc do
    --            --for p, q in next, v do
    --            --    if(q and q.x and q.y) then
    --            --        mapname, x, y = k, q.x, q.y
    --            --    end
    --            --end
    --        end

    local c, z
    if(x and y and mapname) then
        c, z = HandyNotes:GetZoneToCZ(mapname)
    end
    if not (c and z) then return end

    MapHelper:AddWaypointToTomtom(c, z, x, y, self.data.quest)
end

local function sendToHandyNotes(self)
    if(self.data and self.data.obj and self.data.obj.npcs) then

        -- create db that will pass to HandyNotes to get the coords
        local db = {}

        for _, npc_tbl in next, self.data.obj.npcs do
            --print(_, npc_tbl)
            for zone, coords_tbl in next, npc_tbl.loc do
                local mf = MapHelper:ZoneToMapFile(zone)
                --print(mf, zone)
                db[mf] = db[mf] or {}
                for _, crd in next, coords_tbl do
                    local crd_int = HandyNotes:getCoord(crd.x/100, crd.y/100)
                    --print(crd_int)
                    db[mf][crd_int] = {
                        ['questTitle'] = self.data.quest,
                        ['questName'] = self.data.obj.title,
                        ['npcName'] = npc_tbl.name,
                    }
                end
            end
        end

        CQ:AddPinsOnMap(db, wsPanel.CurrentQuestData.questId)
    end
end

callbacks.obj = {
    OnClick = function(self)
        --[[
            self.data = {
                obj = {
                    title = "quest name (without level)",
                    npcs = {
                        {
                            id = 0,
                            loc = {
                                ['localized_mapName'] = {
                                    {
                                        x = 32.45,
                                        y = 12.34,
                                    },
                                }
                            },
                            name = "name",
                            classify = 0,
                        },
                    },
                },
                quest = "quest name (w/ level)",
            }
        --]]

        sendToHandyNotes(self)
        sendToTomtom(self)
    end,

    OnEnter = function()
    end,

    OnLeave = function()
    end,
}



