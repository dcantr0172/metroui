-- LookingForLoot
-- Author: Rawlex
-- License: All Rights Reserved

local LookingForLoot = CreateFrame("Frame", "LookingForLoot")

local function ToString(v)
    if type(v) ~= "table" then
        return tostring(v)
    else
        local s = "{ "
        local sep = ""
        for key, value in pairs(v) do
            s = s .. sep .. "[" .. key .. "] = " .. ToString(value)
            sep = ", "
        end
        s = s .. " }"
        return s
    end
end

local CONFIG = "LookingForLootDb"
local VERSION = GetAddOnMetadata("LookingForLoot", "Version")
local PLAYER, REALM = UnitName("player")
local DEFAULTS =
    {
        -- key = { default function, validation function }
        ["version"] = { 
            function()
                return VERSION
            end, 
            function(value) 
                return type(value) == "string" and value == VERSION 
            end},
        ["enabled"] = {
            function()
                return { ["party"] = true, ["raid_10"] = true, ["raid_25"] = false }
            end,
            function(value)
                if type(value) ~= "table" then
                    return false
                end
                for key, value in pairs(value) do
                    if (key ~= "party" and key ~= "raid_10" and key ~= "raid_25") or type(value) ~= "boolean" then
                        return false
                    end
                end
                return true
            end},
        ["positions"] = { 
            function()
                return {}
            end, 
            function(value) 
                if type(value) ~= "table" then
                    return false
                end
                for idx, position in ipairs(value) do 
                    if type(position) ~= "table" or #position ~= 3 or type(position[1]) ~= "number" or type(position[2]) ~= "number" or type(position[3]) ~= "boolean" then
                        return false
                    end
                end
                return true  
            end},
        ["positioningMode"] = { 
            function()
                return "stagger"
            end, 
            function(value) 
                return type(value) == "string" and value == "stagger" or value == "grid" 
            end},
        ["careFactor"] = {
            function()
                return "all"
            end,
            function(value)
                return type(value) == "string" and value == "all" or value == "greed" or value == "need"
            end},
        ["chatFilter"] = {
            function()
                return false
            end, 
            function(value)
                return type(value) == "boolean" 
            end},
    }

local function CreatePattern(formatString)
    -- non-english clients use Blizzard's custom format option %<number>$<type>
    -- extract ordering of any custom format captures, replace with normal format->match substitution
    -- relies on assumption that custom format numbers are continuous starting from 1
    local returnValuePositions = {}
    local index = 1
    for n in string.gmatch(formatString, "%%(%d)%$[sd]") do
        returnValuePositions[tonumber(n)] = index
        index = index + 1
    end
    
    -- replace custom format options with normal looking format options
    local matchString = string.gsub(formatString, "%%%d%$([sd])", "%%%1")
    -- escape special characters
    matchString = string.gsub(matchString, "[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
    -- escape \000 charcter
    matchString = string.gsub(matchString, "%z", "%%z")
    -- replace normal format options with match patterns
    matchString = string.gsub(matchString, "(%%%%[sd])", { ["%%s"] = "(.+)", ["%%d"] = "(%d+)" })
    
    return { matchString, returnValuePositions }
end

local function ReorderCaptures(customOrder, nextIndex, ...)
    if nextIndex <= #customOrder then
        return select(customOrder[nextIndex], ...), ReorderCaptures(customOrder, nextIndex + 1, ...)
    end
end

local function MatchPattern(msg, pattern)
    local matchString = pattern[1]
    local returnValuePositions = pattern[2]
    
    if #returnValuePositions == 0 then
        return string.match(msg, matchString)
    else
        return ReorderCaptures(returnValuePositions, 1, string.match(msg, matchString))
    end
end

local PATTERNS = 
{
    ROLL_WON = CreatePattern(LOOT_ROLL_WON), 				                            -- %s won: %s 
    ROLL_YOU_WON = CreatePattern(LOOT_ROLL_YOU_WON),			                        -- You won: %s
    ROLLED_DE = CreatePattern(LOOT_ROLL_ROLLED_DE),	 	                                -- Disenchant Roll - %d for %s by %s
    ROLLED_GREED = CreatePattern(LOOT_ROLL_ROLLED_GREED),	                            -- Greed Roll - %d for %s by %s
    ROLLED_NEED = CreatePattern(LOOT_ROLL_ROLLED_NEED),                                 -- Need Roll - %d for %s by %s
    ROLLED_NEED_ROLE_BONUS = CreatePattern(LOOT_ROLL_ROLLED_NEED_ROLE_BONUS),           -- Need Roll - %d for %s by %s + Role Bonus
    SELECTED_PASS = CreatePattern(LOOT_ROLL_PASSED),                                    -- %s passed on: %s
    SELECTED_PASS_YOU = CreatePattern(LOOT_ROLL_PASSED_SELF),                           -- You passed on: %s
    SELECTED_PASS_YOU_AUTO = CreatePattern(LOOT_ROLL_PASSED_SELF_AUTO),                 -- You automatically passed on: %s because you cannot loot that item.
    SELECTED_PASS_AUTO = CreatePattern(LOOT_ROLL_PASSED_AUTO),                          -- %s automatically passed on: %s because he cannot loot that item.
    SELECTED_PASS_AUTO_FEMALE = CreatePattern(LOOT_ROLL_PASSED_AUTO_FEMALE),            -- %s automatically passed on: %s because she cannot loot that item.
    SELECTED_DISENCHANT = CreatePattern(LOOT_ROLL_DISENCHANT),                          -- %s has selected Disenchant for: %s
    SELECTED_DISENCHANT_YOU = CreatePattern(LOOT_ROLL_DISENCHANT_SELF),                 -- You have selected Disenchant for: %s
    SELECTED_GREED = CreatePattern(LOOT_ROLL_GREED),                                    -- %s has selected Greed for: %s
    SELECTED_GREED_YOU = CreatePattern(LOOT_ROLL_GREED_SELF),                           -- You have selected Greed for: %s
    SELECTED_NEED = CreatePattern(LOOT_ROLL_NEED),                                      -- %s has selected Need for: %s
    SELECTED_NEED_YOU = CreatePattern(LOOT_ROLL_NEED_SELF),                             -- You have selected Need for: %s
}

function LookingForLoot:MatchWinPattern(msg)
    local winner
    local item
    
    -- check you-won pattern first, since won pattern can match on the same thing
    item = MatchPattern(msg, PATTERNS.ROLL_YOU_WON)
    if item ~= nil then 
        return "You", item 
    end
    
    winner, item = MatchPattern(msg, PATTERNS.ROLL_WON)
    if item ~= nil then 
        return winner, item 
    end
end

function LookingForLoot:MatchRollPattern(msg)
    -- returns roll value, item text, roller name, role bonus, roll type
    local roll
    local item
    local name
    
    roll, item, name = MatchPattern(msg, PATTERNS.ROLLED_DE)
    if roll ~= nil then 
        return roll, item, name, false, "greed"
    end
    
    roll, item, name = MatchPattern(msg, PATTERNS.ROLLED_GREED)
    if roll ~= nil then 
        return roll, item, name, false, "greed"
    end
    
    -- check need-bonus pattern first, since need pattern can match on the same thing
    roll, item, name = MatchPattern(msg, PATTERNS.ROLLED_NEED_ROLE_BONUS)
    if roll ~= nil then 
        return roll, item, name, true, "need"
    end
    
    roll, item, name = MatchPattern(msg, PATTERNS.ROLLED_NEED)
    if roll ~= nil then 
        return roll, item, name, false, "need"
    end
end

function LookingForLoot:InitDb()
    self.db = _G[CONFIG]

    if self.db == nil then
        self.db = {}
    end
    
    self:ValidateDb()
    
    -- reset position flags
    for i, v in ipairs(self.db["positions"]) do
        v[3] = false
    end
end

function LookingForLoot:ValidateDb()
    for key, value in pairs(DEFAULTS) do
        local defaultFunction = value[1]
        local validationFunction = value[2]
        if self.db[key] == nil then
            -- add missing keys (use default value)
            self.db[key] = defaultFunction()
        else
            -- validate existing values
            if validationFunction(self.db[key]) ~= true then
                self.db[key] = defaultFunction()
            end
        end
    end
    
    for key, value in pairs(self.db) do
        if DEFAULTS[key] == nil then
            -- remove invalid keys
            self.db[key] = nil
        end
    end
end

function LookingForLoot:SaveDb()
    _G[CONFIG] = self.db
end

local function GetGroupType()
    local inInstance, instanceType = IsInInstance()

    if instanceType == "arena" then
        return "arena"
    end

    if instanceType == "pvp" then
        return "bg"
    end

    if GetNumRaidMembers() > 0 then
        if instanceType == "none" and GetZonePVPInfo() == "combat" then
            return "bg"
        end
        if instanceType == "raid" then
            local name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
            if maxPlayers > 10 then
                return "raid_25"
            else
                return "raid_10"
            end
        else
            local raidDifficulty = GetRaidDifficulty()
            if raidDifficulty == 2 or raidDifficulty == 4 then
                return "raid_25"
            else
                return "raid_10"
            end
        end
    end

    if GetNumPartyMembers() > 0 then
        return "party"
    end

    return "solo"
end

function LookingForLoot:GetCustomPosition()
    for i, v in ipairs(self.db["positions"]) do
        if v[3] == false then
            v[3] = true
            return v
        end
    end
    return nil
end

LookingForLoot.offsetNodes = { ["prev"] = nil, ["offset"] = -1, ["next"] = nil }

function LookingForLoot:GetOffsetNode() 
    local currentNode = self.offsetNodes
    local newNode = nil
    while(newNode == nil) do
        if currentNode.next == nil then
            -- add node to tail
            newNode = { ["prev"] = currentNode, ["offset"] = currentNode.offset + 1, ["next"] = nil }
            currentNode.next = newNode
        elseif currentNode.prev ~= nil and currentNode.offset ~= currentNode.prev.offset + 1 then
            -- insert node
            newNode = { ["prev"] = currentNode.prev, ["offset"] = currentNode.prev.offset + 1, ["next"] = currentNode }
            currentNode.prev.next = newNode
            currentNode.prev = newNode
        else
            currentNode = currentNode.next
        end
    end
    newNode.Release = 
        function(newNode)
            newNode.prev.next = newNode.next
            if newNode.next ~= nil then
                newNode.next.prev = newNode.prev
            end
        end
    return newNode
end

local function PositionByOffsetNode(frame, node, mode)
    local offsetX = 0
    local offsetY = 0
    local offsetPoint = "CENTER"
    local relativePoint = "CENTER"
    
    if mode == "stagger" then
        offsetX = node.offset * 40
        offsetY = -offsetX
        offsetPoint = "CENTER"
        relativePoint = "CENTER"
    elseif mode == "grid" then
        local effectiveScale = UIParent:GetEffectiveScale()
        local frameWidth = frame:GetWidth()
        local frameHeight = frame:GetHeight()
        local maxHorzFrames = math.floor((GetScreenWidth() / effectiveScale) / (frameWidth / effectiveScale))
        local maxVertFrames = math.floor((GetScreenHeight() / effectiveScale) / (frameHeight / effectiveScale))
        offsetY = -((node.offset % maxVertFrames) * frameHeight)
        offsetX = (math.floor(node.offset / maxVertFrames) % maxHorzFrames) * frameWidth
        offsetPoint = "TOPLEFT"
        relativePoint = "TOPLEFT"
    end
    
    frame:ClearAllPoints()
    frame:SetPoint(offsetPoint, "UIParent", relativePoint, offsetX, offsetY) 
    frame:SetFrameLevel(node.offset * 3)
end

local function PositionByCustomPosition(frame, position)
    frame:ClearAllPoints()
    frame:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", position[1], position[2]) 
end

LookingForLoot.activeRollFrames = { ["prev"] = nil, ["frame"] = nil, ["next"] = nil }

function LookingForLoot:CloseAllRollFrames()
    local current = self.activeRollFrames.next
    while current ~= nil do
        current.frame:Close(true)
        current = current.next
    end
end

LookingForLoot.rollFrameCache = {}
LookingForLoot.rollFrameCount = 0
LookingForLoot.rollFrameCustomPositionsInUse = {}

function LookingForLoot:GetRollFrame()
    local rollFrame = table.remove(self.rollFrameCache)
    if rollFrame ~= nil then
        rollFrame.messageFrame:Clear()
    else
        self.rollFrameCount = self.rollFrameCount + 1
        local name = "LookingForLootRollFrame" .. self.rollFrameCount
        rollFrame = CreateFrame("Button", name, UI_Parent, "LookingForLootRollFrameTemplate")
        rollFrame.messageFrame.editBox = DEFAULT_CHAT_FRAME.editBox

        rollFrame.Close = 
            function(rollFrame, closingAll)
                if closingAll ~= true and IsShiftKeyDown() == 1 then
                    -- start of 'close all' command
                    self:CloseAllRollFrames()
                else
                    rollFrame:Hide()
                    table.insert(self.rollFrameCache, rollFrame)   
                    rollFrame.activeNode.prev.next = rollFrame.activeNode.next
                    if rollFrame.activeNode.next ~= nil then
                        rollFrame.activeNode.next.prev = rollFrame.activeNode.prev
                    end
                    if rollFrame.customPosition == nil then
                        rollFrame.offsetNode:Release()
                    else
                        rollFrame.customPosition[3] = false
                    end       
                    rollFrame:ClearAllPoints()
                end
            end
            
        rollFrame.SaveCustomPosition = 
            function(rollFrame)
                if rollFrame.customPosition == nil then
                    rollFrame.offsetNode:Release()
                    rollFrame.customPosition = { rollFrame:GetLeft(), rollFrame:GetBottom(), true }
                    table.insert(self.db["positions"], rollFrame.customPosition)
                else
                    rollFrame.customPosition[1] = rollFrame:GetLeft()
                    rollFrame.customPosition[2] = rollFrame:GetBottom()
                end
            end
    end
        
    local customPosition = self:GetCustomPosition()
    if customPosition ~= nil then
        rollFrame.customPosition = customPosition
        PositionByCustomPosition(rollFrame, customPosition)
    else
        local offsetNode = self:GetOffsetNode()
        rollFrame.offsetNode = offsetNode
        PositionByOffsetNode(rollFrame, offsetNode, self.db["positioningMode"])
    end

    local newNode = { ["prev"] = self.activeRollFrames, ["frame"] = rollFrame, ["next"] = self.activeRollFrames.next }
    if self.activeRollFrames.next ~= nil then
        self.activeRollFrames.next.prev = newNode
    end
    self.activeRollFrames.next = newNode
    rollFrame.activeNode = newNode

    return rollFrame
end

LookingForLoot.currentRoll = nil
LookingForLoot.inRoll = false
LookingForLoot.playerInRoll = false
LookingForLoot.rollType = nil

function LookingForLoot:DisplayCurrentRoll()
    local rollFrame = self:GetRollFrame()
    
    local item = self.currentRoll["item"]
    local _, itemLink, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(item)
    SetItemButtonTexture(rollFrame.itemButton, itemTexture)
    rollFrame.itemButton.link = itemLink
    rollFrame.itemLabel:SetText("Item: " .. item)
    
    local winner = self.currentRoll["winner"]
    rollFrame.winnerLabel:SetText("Winner: " .. winner)
    
    local rolls = self.currentRoll["rolls"] 
    table.sort(rolls, 
        function(rollA, rollB)
            if rollA["value"] == rollB["value"] then
                return rollA["name"] < rollB["name"]
            else
                return rollA["value"] > rollB["value"]
            end
        end)
    
    for idx, roll in ipairs(rolls) do
        local value = roll["value"]
        local name = roll["name"]
        local bonus = roll["bonus"]
        
        local message = tostring(value) .. " - "
        
        local unitName = GetUnitName(name, true)
        local unitGuid
        local unitLink
        if unitName == nil then
            unitGuid = UnitGUID(name)
            unitLink = "|Hplayer:" .. name .. "|h[" .. name .. "]|h"
        else
            unitName = string.gsub(unitName, " ", "")
            unitGuid = UnitGUID(unitName)
            unitLink = "|Hplayer:" .. unitName .. "|h[" .. unitName .. "]|h"
        end
            
        if unitGuid ~= nil then 
            local _, unitClassFileName = GetPlayerInfoByGUID(unitGuid)
            local unitClassColour = RAID_CLASS_COLORS[unitClassFileName]
            message = message .. string.format("|cff%.2x%.2x%.2x%s|r", unitClassColour.r * 255, unitClassColour.g * 255, unitClassColour.b * 255, unitLink)  
        else
            message = message .. unitLink
        end
        
        if bonus == true then
            message = message .. " (+ Role Bonus)"
        end

        rollFrame.messageFrame:AddMessage(message)
    end

    -- make sure first roller is shown at top of messageFrame (requires frame to be visible) - currently bugged?
    rollFrame:Show()
    
    local total = rollFrame.messageFrame:GetNumMessages()
    local displayed = rollFrame.messageFrame:GetNumLinesDisplayed()
    local hidden = total - displayed
    --print("Hidden = " .. hidden .. ", Displayed = " .. displayed .. ", Total = " .. total)
    if hidden >= 0 then
        rollFrame.messageFrame:SetScrollOffset(hidden)
    end
    --print("scrollOffset = " .. rollFrame.messageFrame:GetCurrentScroll())
end

local function ChatFilter(chatFrame, event, msg, ...)
    if LookingForLoot.db["chatFilter"] == true and LookingForLoot.db["enabled"][GetGroupType()] == true then
        for key, value in pairs(PATTERNS) do
            if string.match(msg, value[1]) then
                return true
            end
        end
    end
end

local testing = false

function LookingForLoot:CanDisplayRoll()
    if testing == true then
        return true
    else
        local satisfiesEnabled = self.db["enabled"][GetGroupType()] == true
        local satisfiesCareFactor = self.db["careFactor"] == "all" or (self.db["careFactor"] == "greed" and self.playerInRoll == true) or (self.db["careFactor"] == "need" and self.playerInRoll and self.rollType == "need")
        return satisfiesEnabled and satisfiesCareFactor
    end
end

local function DispatchEvents(self, event, ...)
    local a = self[event]
    if a then
        a(self, event, ...)
    end
end

LookingForLoot:SetScript("OnEvent", DispatchEvents)
LookingForLoot:RegisterEvent("PLAYER_LOGIN")
LookingForLoot:RegisterEvent("PLAYER_LOGOUT")

function LookingForLoot:PLAYER_LOGIN()
    SLASH_LOOKINGFORLOOT1 = "/lfl"
    SlashCmdList["LOOKINGFORLOOT"] = 
        function(msg)
            self:ProcessSlashCmd(string.split(" ", msg))
        end

    self:InitDb()
    self:RegisterEvent("CHAT_MSG_LOOT")
    ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", ChatFilter)
    
    self.optionsFrame = CreateFrame("Frame", "LookingForLootOptionsFrame", UIParent, "LookingForLootOptionsFrameTemplate")
    self.optionsFrame.db = self.db
    self.optionsFrame.Test = 
        function() 
            self:Test() 
        end
        
    StaticPopupDialogs["LOOKINGFORLOOT_CHANGELOOTSPAMCVAR"] =
    {
        text = "LookingForLoot requires 'detailed loot information' to be enabled on your client. Would you like LookingForLoot to enable this now?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = 
            function()
                SetCVar("showLootSpam", 1)
            end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }

    if GetCVar("showLootSpam") == "0" and (self.db["enabled"]["party"] or self.db["enabled"]["raid_10"] or self.db["enabled"]["raid_25"]) then
        StaticPopup_Show("LOOKINGFORLOOT_CHANGELOOTSPAMCVAR")
    end
end

function LookingForLoot:PLAYER_LOGOUT()
    self:SaveDb()
end

function LookingForLoot:CHAT_MSG_LOOT(event, msg)
    local extracted = false
    
    if extracted == false then
        local roll
        local item
        local name
        local bonus
        local rolltype
        roll, item, name, bonus, rollType = self:MatchRollPattern(msg)
        if roll ~= nil then
            extracted = true
            if self.inRoll == false then
                self.inRoll = true
                self.playerInRoll = false
                self.rollType = rollType
                self.currentRoll = { ["item"] = item, ["rolls"] = {} }
            end   
            table.insert(self.currentRoll["rolls"], { ["name"] = name, ["value"] = tonumber(roll), ["bonus"] = bonus })
            self.playerInRoll = self.playerInRoll or name == PLAYER
        end
    end
    
    if extracted == false then
        local winner
        local item
        if self.inRoll == true then
            winner, item = self:MatchWinPattern(msg)
            if winner ~= nil then
                extracted = true
                self.currentRoll["winner"] = winner
                if self:CanDisplayRoll() == true then
                    self:DisplayCurrentRoll()
                end
                self.inRoll = false
            end
        end
    end
end

function LookingForLoot:ProcessSlashCmd(...)
    local valueColour = "22aaff"
    local descriptionColour = "ee8800"
    local addonColour = "00ff00"
    
    local addonPrefix = "|cff" .. addonColour .. "[LookingForLoot]|r "
    
    local parseChatFilterArg = 
        function(arg)
            if arg == "true" then
                return true
            elseif arg == "false" then
                return false
            else 
                return nil
            end
        end
     
    local parseEnabledArg =
        function(arg)
            local result = {}
            if arg ~= "" then
                local converted = { strsplit(" ", arg) }
                
                for idx, value in ipairs(converted) do
                    result[value] = true
                end
            end
            return result
        end 
    
    local changedDb = false
    local cmd, arg = ...
    if cmd == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    elseif cmd == "test" then
        self:Test()
    elseif cmd == "enabled" and DEFAULTS["enabled"][2](parseEnabledArg(arg)) then
        self.db["enabled"] = parseEnabledArg(arg)
        changedDb = true
    elseif cmd == "positioningMode" and DEFAULTS["positioningMode"][2](arg) then
        self.db["positioningMode"] = arg    
        changedDb = true
    elseif cmd == "careFactor" and DEFAULTS["careFactor"][2](arg) then
        self.db["careFactor"] = arg
        changedDb = true
    elseif cmd == "chatFilter" and DEFAULTS["enabled"][2](parseChatFilterArg(arg)) then
        self.db["chatFilter"] = parseChatFilterArg(arg)
        changedDb = true
    elseif cmd == "resetCustomPositions" then
        self.db["positions"] = {}
        changedDb = true
    elseif cmd == "_db" then
        print(ToString(self.db))
    elseif cmd == "_group" then
        print(GetGroupType())
    elseif cmd == "_candisplay" then
        print(tostring(self:CanDisplayRoll()))
    elseif cmd == "_match" then
        local rusFormatString = "Результат броска |3-1(%3$s) (\"Распылить\") за предмет %2$s: %1$d."
        local pattern = CreatePattern(rusFormatString)
        local matchString = pattern[1]
        local order = pattern[2]
        print("Match string: " .. matchString)
        print("Order: " .. ToString(order))
        local rusChatMsg = string.format(rusFormatString, 100, "[Item]", "Player")
        local roll, item, player = MatchPattern(rusChatMsg, pattern)
        print("Roll: " .. tostring(roll) .. ", Item: " .. tostring(item) .. ", Player: " .. tostring(player))
    else
        print(addonPrefix .. "Unrecognised command")
        print(addonPrefix .. "Usage:")
        print(addonPrefix .. "/lfl |cff" .. descriptionColour .. "open options frame|r")
        print(addonPrefix .. "/lfl test |cff" .. descriptionColour .. "run test roll|r")
        print(addonPrefix .. "/lfl enabled |cff" .. valueColour .. "party raid_10 raid_25 (any combination)|r |cff" .. descriptionColour .. "when addon is enabled|r")
        print(addonPrefix .. "/lfl positioningMode |cff" .. valueColour .. "stagger/grid|r |cff" .. descriptionColour .. "how new windows are positioned|r")
        print(addonPrefix .. "/lfl careFactor |cff" .. valueColour .. "all/greed/need|r |cff" .. descriptionColour .. "which rolls should be displayed|r")
        print(addonPrefix .. "/lfl chatFilter |cff" .. valueColour .. "true/false|r |cff" .. descriptionColour .. "whether loot chat is suppresed|r")
        print(addonPrefix .. "/lfl resetCustomPositions |cff" .. descriptionColour .. "clear custom window positions|r")
    end
    if(changedDb == true) then
        self:ChangedDb()
    end
    self.optionsFrame:refresh()
end

function LookingForLoot:Test()
    local item = "|cffffffff|Hitem:6948:0:0:0:0:0:0:0:0|h[Hearthstone]|h"
    local players = { "Cleaveland", "Sunderpants", "BubbleOSeven", "LayOnHooves", "ArrowDynamic", "Idtrapthat", "Bowme", "Dontlosmebro", "Backstabbath", "Hemotherapy", "Praystation", "Powerwordhug", "Vanhealin", "Crossblesser", "Lichslapped", "Shammurai", "Beeroism", "Shampayne", "Grimsheeper", "Mageulook", "Lockybalboa", "Fearoshima", "Dotctor", "Owlkapwn", "Clawandorder" }
    local rollType = math.random(1, 2)
    local maxRoll = 0
    local maxRoller = ""
    testing = true
    for i = 1, 25 do 
        local subRollType = math.random(1, 2)
        local roll
        if rollType == 1 and subRollType == 1 then 
            roll = math.random(1, 100)
            DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_ROLLED_DE, roll, item, players[i]))
        elseif rollType == 1 and subRollType == 2 then
            roll = math.random(1, 100)
            DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_ROLLED_GREED, roll, item, players[i]))
        elseif rollType == 2 and subRollType == 1 then
            roll = math.random(1, 100)
            DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_ROLLED_NEED, roll, item, players[i]))
        elseif rollType == 2 and subRollType == 2 then
            roll = math.random(100, 200)
            DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_ROLLED_NEED_ROLE_BONUS, roll, item, players[i]))
        end
        if roll > maxRoll then
            maxRoll = roll
            maxRoller = players[i]
        end
    end
    local winner = math.random(1, 2)
    if winner == 1 then
        DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_WON, maxRoller, item))
    else
        DispatchEvents(LookingForLoot, "CHAT_MSG_LOOT", string.format(LOOT_ROLL_YOU_WON, item))
    end
    testing = false
end
