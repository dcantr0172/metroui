local enableClicks = true       -- True if waypoint-clicking is enabled to set points
local enableClosest = true      -- True if 'Automatic' quest waypoints are enabled
local modifier                  -- A string representing click-modifiers "CAS", etc.

local modTbl = {
    C = IsControlKeyDown,
    A = IsAltKeyDown,
    S = IsShiftKeyDown,
}

local L = TomTomLocals
local astrolabe = DongleStub("TTAstrolabe-1.0")

-- This function and the related events/hooks are used to automatically
-- update the crazy arrow to the closest quest waypoint.
local lastWaypoint
local scanning          -- This function is not re-entrant, stop that

local function ObjectivesChanged()
    -- This function should only run if enableClosest is set
    if not enableClosest then
        return
    end

    -- This function may be called while we are processing this function
    -- so stop that from happening.
    if scanning then
        return
    else
        scanning = true
    end

    local map, floor = GetCurrentMapAreaID()
    local floors = astrolabe:GetNumFloors(map)
    floor = floors == 0 and 0 or 1

    local px, py = GetPlayerMapPosition("player")

    -- Bail out if we can't get the player's position
    if not px or not py or px <= 0 or py <= 0 then
        scanning = false
        return
    end

    -- THIS CVAR MUST BE CHANGED BACK!
    local cvar = GetCVarBool("questPOI")
    SetCVar("questPOI", 1)

    local closest
    local closestdist = math.huge

    -- This function relies on the above CVar being set, and updates the icon
    -- position information so it can be queries via the API
    QuestPOIUpdateIcons()

    -- Scan through every quest that is tracked, and find the closest one
    local watchIndex = 1
    while true do
        local questIndex = GetQuestIndexForWatch(watchIndex)

        if not questIndex then
            break
        end

        local qid = select(9, GetQuestLogTitle(questIndex))
        local completed, x, y, objective = QuestPOIGetIconInfo(qid)

        if x and y then
            local dist, xd, yd = astrolabe:ComputeDistance(map, floor, px, py, map, floor, x, y)
            if dist < closestdist then
                closest = watchIndex
                closestdist = dist
            end
        end
        watchIndex = watchIndex + 1
    end

    if closest then
        local questIndex = GetQuestIndexForWatch(closest)
        local title = GetQuestLogTitle(questIndex)
        local qid = select(9, GetQuestLogTitle(questIndex))
        local completed, x, y, objective = QuestPOIGetIconInfo(qid)

        if completed then
            title = "Turn in: " .. title
        end

        local setWaypoint = true
        if lastWaypoint then
            -- This is a hack that relies on the UID format, do not use this
            -- in your addons, please.
            local pm, pf, px, py = unpack(lastWaypoint)
            if map == pm and floor == pf and x == px and y == py and lastWaypoint.title == title then
                -- This is the same waypoint, do nothing
                setWaypoint = false
            else
                -- This is a new waypoint, clear the previous one
                TomTom:RemoveWaypoint(lastWaypoint)
            end
        end

        if setWaypoint then
            -- Set the new waypoint
            lastWaypoint = TomTom:AddMFWaypoint(map, floor, x, y, {
                title = title,
                persistent = false,
                arrivaldistance = TomTom.profile.poi.arrival,
            })

            -- Check and see if the Crazy arrow is empty, and use it if so
            if TomTom:IsCrazyArrowEmpty() then
                TomTom:SetCrazyArrow(lastWaypoint, TomTom.profile.poi.arrival, title)
            end
        end
    else
        -- No closest waypoint was found, so remove one if its already set
        if lastWaypoint then
            TomTom:RemoveWaypoint(lastWaypoint)
            lastWaypoint = nil
        end
    end

    SetCVar("questPOI", cvar and 1 or 0)
    scanning = false
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("QUEST_POI_UPDATE")
eventFrame:RegisterEvent("QUEST_LOG_UPDATE")
hooksecurefunc("WatchFrame_Update", function(self)
    ObjectivesChanged()
end)

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "QUEST_POI_UPDATE" then
        ObjectivesChanged()
    elseif event == "QUEST_LOG_UPDATE" then
        ObjectivesChanged()
    end
end)

local poiclickwaypoints = {}
local function poi_OnClick(self, button)
    if not enableClicks then
        return
    end

    if button == "RightButton" then
        --for i = 1, #modifier do
        --    local mod = modifier:sub(i, i)
        --    local func = modTbl[mod]
        --    if not func() then
        --        return
        --    end
        --end
    else
        return
    end

    -- Run our logic, and set a waypoint for this button
    local m, f = GetCurrentMapAreaID()

    local questIndex = self.quest and self.quest.questLogIndex
    if not questIndex and self.questId then
        -- Lookup the questIndex for the given questId
        for idx = 1, GetNumQuestLogEntries(), 1 do
            local qid = select(9, GetQuestLogTitle(idx))
            if qid == self.questId then
                questIndex = idx
            end
        end
    end

    if not questIndex and self.index then
        questIndex = GetQuestIndexForWatch(self.index)
    end

    local title = GetQuestLogTitle(questIndex)
    local qid = select(9, GetQuestLogTitle(questIndex))
    local completed, x, y, objective = QuestPOIGetIconInfo(qid)
    if completed then
        title = "Turn in: " .. title
    end

    if not x or not y then
        -- No coordinate information for this quest/objective
        local header = "|cFF33FF99TomTom|r"
        print(L["%s: No coordinate information found for '%s' at this map level"]:format(header, title))
        return
    end

    local key = TomTom:GetKeyArgs(m, f, x, y, title)

    local alreadySet = false
    if poiclickwaypoints[key] then
        local uid = poiclickwaypoints[key]
        -- Check to see if it has been removed by the user
        if TomTom:IsValidWaypoint(uid) then
            alreadySet = true
        end
    end

    if not alreadySet then
        local uid = TomTom:AddMFWaypoint(m, f, x, y, {
            title = title,
            arrivaldistance = TomTom.profile.poi.arrival,
        })
        poiclickwaypoints[key] = uid
    end
end

local hooked = {}
hooksecurefunc("QuestPOI_DisplayButton", function(parentName, buttonType, buttonIndex, questId)
    local buttonName = "poi"..tostring(parentName)..tostring(buttonType).."_"..tostring(buttonIndex);
    local poiButton = _G[buttonName];

    if not hooked[buttonName] then
        poiButton:HookScript("OnClick", poi_OnClick)
        poiButton:RegisterForClicks("AnyUp")
        hooked[buttonName] = true
    end

    -- Check to see if there is a swap button
    local swapName = "poi" .. parentName .. "_Swap"
    local swapButton = _G[swapName]

    if not hooked[swapName] and swapButton then
        swapButton:HookScript("OnClick", poi_OnClick)
        swapButton:RegisterForClicks("AnyUp")
        hooked[swapName] = true
    end
end)

function TomTom:EnableDisablePOIIntegration()
    enableClicks= TomTom.profile.poi.enable
    modifier = TomTom.profile.poi.modifier
    enableClosest = TomTom.profile.poi.setClosest

    if not enableClosest and lastWaypoint then
        TomTom:RemoveWaypoint(lastWaypoint)
        lastWaypoint = nil
    elseif enableClosest then
        ObjectivesChanged()
    end
end
