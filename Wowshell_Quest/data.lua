-- 提供任务数据API

-- locals
local wsData = LibStub('AceAddon-3.0'):GetAddon'wsQuest':NewModule('Data')
local LibGratuity = LibStub('LibGratuity-3.0')
local isAlliance = UnitFactionGroup'player' == 'Alliance'

-- fetch data
wsData.questData = QuestHelper_QuestData
wsData.npcData = QuestHelper_NPCData
wsData.zoneData = QuestHelper_ZoneData
wsData.nameData = QuestHelper_NameData
-- distroy global vars
_G.QuestHelper_QuestData = nil
_G.QuestHelper_NPCData = nil
_G.QuestHelper_ZoneData = nil
_G.QuestHelper_NameData = nil

-- fetch upvalue
local tinsert = table.insert
local format = string.format


 -- ace callbacks
function wsData:OnInitialize()
    -- pass
end

-- APIs

function wsData:GetQuestData(uid, ignoreObj)
    local data = self.questData[uid]
    if(not data) then return end

    local _,_,side, req_level, level, startNpc, endNpc, sharable, daily = data.i:find"^(.)`(%d+)`(%d+)`([^`]+)`([^`]+)`(%d+)`(%d+)$"

    local tmp = {}
    tmp.questId = uid
    tmp.side = side
    tmp.level = level
    tmp.req_level = req_level
    tmp.sharable = sharable
    tmp.startNpc = self:GetQuestNpc(startNpc)
    tmp.endNpc = self:GetQuestNpc(endNpc)

    local qlevelf, qtitle, qdesc, qobjs = self:GetQuestDataText(uid, level)

    tmp.title_full = '['..qlevelf..']'..qtitle
    tmp.title = qtitle
    tmp.desc = qdesc

    if(ignoreObj) then return tmp end

    if(data.o) then
        local npcdata = {}
        tmp.objs = {}

        for i, o in data.o:gmatch'(%d)=([^|]+)' do
            i = tonumber(i)
            local obj = {}
            obj.title = qobjs and qobjs[i] or '???'
            for npc_id, npc_zone, npc_x, npc_y in string.gmatch(o, '(%-?%d+)@?(%d*):?(%d*),?(%d*)') do
                npc_id = tonumber(npc_id)
                npc_zone = tonumber(npc_zone)

                local npc
                if(npc_id~=0) then
                    npcdata = self:GetNpc(npc_id, npc_zone)
                elseif npc_zone and self.zoneData[npc_zone] then
                    local zonename = self.zoneData[npc_zone]

                    npcdata.id = 0
                    npcdata.name = tmp.title
                    npcdata.classify = 0
                    npcdata.loc = {
                        [zonename] = {
                            {
                                ['x'] = (tonumber(npc_x) or 0)/10,
                                ['y'] = (tonumber(npc_y) or 0)/10,
                            }
                        }
                    }
                end
                if(npcdata) then
                    if(not obj.npcs) then
                        obj.npcs = {}
                    end
                    tinsert(obj.npcs, npcdata)
                end
            end
            tmp.objs[i] = obj
        end
    end

    if data.s then
        tmp.series = {}
        for qid in string.gmatch(data.s, '(%d+)') do
            tinsert(tmp.series, tonumber(qid))
        end
    end

    return tmp
end

function wsData:GetQuestDataText(uid, level)
    level = level or UnitLevel'player'

    local questLink = '|cff808080|Hquest:'..uid..':'..level..'|h[scanning]|h|r'
    LibGratuity:SetHyperlink(questLink)

    local num_lines = LibGratuity:NumLines()
    if(num_lines < 1) then return end
    local title, desc, objs = nil, nil, {}

    local desc_state = 0

    for i = 1, num_lines do
        local line_text = LibGratuity:GetLine(i)
        -- clean up
        line_text:gsub('|c%x%x%x%x%x%x%x%x', ''):gsub('|r', ''):gsub('[\n\t]', '')

        if(i == 1) then
            title = line_text
        elseif(line_text == ' ') then
            desc_state = 1
        elseif(desc_state == 1) then
            desc = line_text
            desc_state = 2
        elseif(desc_state == 2) then
            local _, _, o = line_text:find('^%s+%- (.-)%s?x?%s?%d*$')
            if(o) then
                table.insert(objs, o)
            end
        end
    end

    return level, title, desc ,objs
end

function wsData:GetQuestNpc(npc)
    local npcid = tonumber(npc)

    if(npcid) then return npcid end

    -- a => alliance
    -- h => horde
    local _, _, a, h = npc:find("A(%-?%d+);H(%-?%d+)")

    return isAlliance and a or h
end

function wsData:GetQuestID(link)
    return tonumber(link:match'|Hquest:(%d+)')
end

function wsData:GetNpc(npcid, zone_filter)
    local npcdata = self.npcData[npcid]
    if(not npcdata) then return end

    local _,_, side, level_min, level_max, classify, loc = npcdata:find'^(.)`(%d+)`(%d+)`(%d+)(|.*)$'
    local tmp = {}
    tmp.npcid = npcid
    tmp.side = side
    tmp.name = self.nameData[npcid] or '???'

    tmp.level_min = level_min ~= 0 and level_min
    tmp.level_max = level_max ~= 0 and level_max

    tmp.classify = classify

    for zone, pos in loc:gmatch'|(%d+):([^|]*)' do
        local zoneid = tonumber(zone)
        local zone_name = zoneid and self.zoneData[zoneid]
        if(zone_name and (not zone_filter or zone_filter == zoneid)) then
            tmp.loc = tmp.loc or {}

            tmp.loc[zone_name] = tmp.loc[zone_name] or {}

            for x, y in pos:gmatch('(%d+),(%d+)') do
                tinsert(tmp.loc[zone_name], {
                    ['x'] = tonumber(x)/10,
                    ['y'] = tonumber(y)/10,
                })
            end
        end
    end

    return tmp
end

