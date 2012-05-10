local wsquest = LibStub('AceAddon-3.0'):NewAddon('wsQuest', 'AceEvent-3.0')
local Quixote = LibStub('LibQuixote-2.0')
local L = select(2, ...).Locale

local db
local defaults = {
    profile = {
        announceToGroup = true,
        autoCompleteQuest = false,
        customWatcherPosition = true,
        watcherPosition = {},
        unwatchComplete = true,
        watchFrameScale = 1,
    },
}

function wsquest:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New('WSQuestDB', defaults, UnitName'player' .. '-' ..GetRealmName())
    db = self.db.profile

    -- register events and callbacks
    self:RegisterEvent('QUEST_PROGRESS', 'CompleteQuest')
    self:RegisterEvent('QUEST_COMPLETE', 'CompleteQuest')

    Quixote.RegisterCallback(self, 'Objective_Update', 'AnnounceQuest')
    Quixote.RegisterCallback(self, 'Quest_Complete', 'QuestComplete_Unwatch')

    self:SetupOption()
    self:InitWatcherMover()
    self:UpdateWatchFrameScale()
end

function wsquest:QuestComplete_Unwatch(name, qtitle, uid)
    if(db.unwatchComplete) then
        local _, questIndex = Quixote:GetQuestByUid(uid)
        RemoveQuestWatch(questIndex)
        WatchFrame_Update()
    end
end

function wsquest:UpdateWatchFrameScale()
    local scale = db.watchFrameScale
    WatchFrame:SetScale(scale)
end

function wsquest:AnnounceQuest(event, title, uid, objective, had, got, need, typ)
    if(db.announceToGroup and GetNumPartyMembers()>0) then
        if(typ =='item' or typ == 'monster' or typ == 'reputation') then
            --print(objective, got, need)
            local text = string.format(L['Wowshell Quest: %s: %d/%d'], objective, got, need)
            --print(text)
            SendChatMessage(text, 'PARTY')
        end

        local _, _, _, _, _, _, qstatus = Quixote:GetQuestByUid(uid)
        if(got == need and qstatus==1) then
            SendChatMessage(string.format(L['Wowshell Quest: %s complete'], title), 'PARTY')
        end
    end
end

function wsquest:CompleteQuest(event)
    if(not db.autoCompleteQuest) then return end
    if(event=='QUEST_PROGRESS') then
        CompleteQuest()
    else
        if( GetNumQuestChoices() == 0 ) then
            GetQuestReward(QuestFrameRewardPanel.itemChoice)
        end
    end
end

function wsquest:InitWatcherMover()
    if(not db.customWatcherPosition) then return end
    if(self.hooked_watcher) then return end
    self.hooked_watcher = true

    WatchFrame:SetMovable(true)
    WatchFrameHeader:RegisterForDrag('LeftButton')
    WatchFrameHeader:SetScript('OnDragStart', function(self)
        WatchFrame:StartMoving()
    end)
    WatchFrameHeader:SetScript('OnDragStop', function(self)
        WatchFrame:StopMovingOrSizing()
        db.watcherPosition.x, db.watcherPosition.y = WatchFrame:GetCenter()
    end)

    local x, y = db.watcherPosition.x, db.watcherPosition.y
    if not (x and y) then
        x, y = nil
    end
    if( x and y) then
        WatchFrame:ClearAllPoints()
        WatchFrame:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', x, y)
    end

    WatchFrame.ClearAllPoints = function() end
    WatchFrame.SetPoint = function() end
    WatchFrame:SetHeight(500)
end

function wsquest:SetupOption()
    if(not self.option) then
        local aaa = 0
        local function o()
            aaa=aaa+1
            return aaa
        end

        self.option = {
            autoCompleteQuest = {
                type = 'toggle',
                name = L['Auto complete quest'],
                desc = L['Complete quest automatically'],
                order = o(),
                get = function() return db.autoCompleteQuest end,
                set = function(_, v)
                    db.autoCompleteQuest = v
                end,
            },
            unwatchComplete = {
                type = 'toggle',
                name = L['Auto unwatch complete quest'],
                desc = L['Automatically remove quest from watch list when it\'s complete'],
                order = o(),
                get = function() return db.unwatchComplete end,
                set = function(_, v)
                    db.unwatchComplete = v
                end
            },
            movable_tracker = {
                type = 'toggle',
                name = L['Movable quest tracker'],
                desc = L['Let you move quest tracker'],
                order = o(),
                get = function() return db.customWatcherPosition end,
                set = function(_,v)
                    db.customWatcherPosition = v
                    if(v) then
                        wsquest:InitWatcherMover()
                    else
                        wipe(db.watcherPosition)
                    end
                end
            },
            announceToGroup = {
                type = 'toggle',
                get = function() return db.announceToGroup end,
                set = function(_,v)
                    db.announceToGroup = v
                end,
                order = o(),
                name = L['Announce progress'],
                desc = L['Announce quest progress to group'],
            },
            watchFrameWidth = {
                type = 'toggle',
                name = WATCH_FRAME_WIDTH_TEXT, -- 更寬的任務追踪面板
                order = o(),
                --get = function() return db.wilderWatchFrame end,
                get = function() return GetCVar'watchFrameWidth' == '1' end,
                set = function(_,v)
                    --db.wilderWatchFrame = v
                    local setting = v and '1' or '0'
                    SetCVar('watchFrameWidth', setting)
                    --wsquest:UpdateWatchFrameWidth()
                    WatchFrame_SetWidth(GetCVar'watchFrameWidth')
                end
            },
            watchFrameScale = {
                name = L['Watch frame scale'],
                type = 'range',
                min = 0.5, max = 1.5,
                step = 0.1,
                get = function() return db.watchFrameScale end,
                set = function(_, v)
                    db.watchFrameScale = v
                    wsquest:UpdateWatchFrameScale()
                end
            },
            auto_tomtom = {
                type = 'toggle',
                name = L['Enable automatic quest objective waypoints'],
                desc = L['Enables the automatic setting of quest objective waypoints based on which objective is closest to your current location.  This setting WILL override the setting of manual waypoints.'],
                order = o(),
                disabled = function() return not TomTom end,
                get = function() return TomTom and TomTom.db.profile.poi.setClosest end,
                set = function(_, v)
                    if(TomTom) then
                        TomTom.db.profile.poi.setClosest = v
                        TomTom:EnableDisablePOIIntegration()
                    end
                end,
            },
            enable_tomtom = {
                type = 'execute',
                name = L['Enable TomTom'],
                desc = L['Last option needs TomTom support, needs reload'],
                hidden = function() return (not not TomTom) end,
                order = o(),
                confirm = true,
                func = function()
                    EnableAddOn('TomTom')
                    ReloadUI()
                end
            },
            fix_tomtom_poi = {
                type = 'execute',
                name = L['Fix TomTom support'],
                desc = L['If auto quest waypoints doesn\'t work, you might mess up TomTom, click here to reset TomTom'],
                disabled = function() return not TomTom end,
                order = o(),
                confirm = true,
                func = function()
                    TomTom.db.profile.poi.setClosest = false
                    TomTom.db.profile.poi.enable = true
                    TomTom.db.profile.poi.modifier = 'C'
                    TomTom:EnableDisablePOIIntegration()
                end,
            },
            reset_crazyarrow_position = {
                type = 'execute',
                name = L['Reset arrow position'],
                desc = L['Resets the position of the waypoint arrow if its been dragged off screen'],
                order = o(),
                func = function()
                    TomTomCrazyArrow:ClearAllPoints()
                    TomTomCrazyArrow:SetPoint('CENTER', UIParent, 'CENTER', 0, 0)
                end,
            },
            disc = {
                type = 'description',
                order = o(),
                name = GetLocale() == 'zhTW' and [[自動任務嚮導可以自動為你選取最近的任務並指向任務地點, 如果關閉此選項, 你還可以按住ctrl右鍵點擊任務點數字按鈕來使用箭頭指示.]] or [[自动任务向导可以自动为你选取最近的任务并指向任务地点, 如果关闭此选项, 你还可以按住ctrl右键点击任务点数字按钮来使用箭头指示.]],
            },
        }
    end

end
