--[[
--       glyphs
--]]

local gather = CreateFrame'Frame'
_G.WSGather = gather
gather:SetScript('OnEvent', function(self, event, ...)
    self[event](self, event, ...)
end)

gather:RegisterEvent'PLAYER_LOGIN'
function gather:PLAYER_LOGIN()
    WSGatherDB = WSGatherDB or {}
    self.identifier = UnitName'player'..'-'..GetRealmName()

    WSGatherDB = WSGatherDB or {}
    WSGatherDB[self.identifier] = WSGatherDB[self.identifier] or {}

    self.db = WSGatherDB[self.identifier]
    self.alldb = WSGatherDB

    self:RegisterEvent'PLAYER_LOGOUT'
    self:RegisterEvent'PLAYER_ENTERING_WORLD'

    -- mounts, quests
    self:COMPANION_UPDATE()
    self:RegisterEvent'COMPANION_UPDATE'

    -- titles
    self:KNOWN_TITLES_UPDATE()
    self:RegisterEvent'KNOWN_TITLES_UPDATE'

    -- quests
    QueryQuestsCompleted()
    self:RegisterEvent'QUEST_QUERY_COMPLETE'

    -- achievements
    self:ACHIEVEMENT_EARNED()
    self:RegisterEvent'ACHIEVEMENT_EARNED'

    -- factions
--  self:UPDATE_FACTION()
--  self:RegisterEvent'UPDATE_FACTION'

    -- guild
    self:GUILD_PERK_UPDATE()
    self:RegisterEvent'GUILD_XP_UPDATE'
    self:RegisterEvent'PLAYER_GUILD_UPDATE'
    self:RegisterEvent'GUILD_PERK_UPDATE'
    self:RegisterEvent'UPDATE_FACTION'

    -- profession
    --self:ScanProfession()
    self:RegisterEvent'TRADE_SKILL_SHOW'
end

function gather:PLAYER_LOGOUT()
    self:COMPANION_UPDATE()
    self:KNOWN_TITLES_UPDATE()
    self:QUEST_QUERY_COMPLETE()
    self:ACHIEVEMENT_EARNED()
    self:PLAYER_GUILD_UPDATE()
    --self:ScanProfession()
--  self:UPDATE_FACTION()
end

function gather:PLAYER_ENTERING_WORLD()
    QueryQuestsCompleted()
end

function gather:COMPANION_UPDATE()
    self.db.mounts = self.db.mounts or {}
    self.db.critters = self.db.critters or {}

    wipe(self.db.mounts)
    wipe(self.db.critters)

    local num_mounts = GetNumCompanions'MOUNT'
    local num_critters = GetNumCompanions'CRITTER'

    if(num_mounts>0) then
        for i = 1, num_mounts do
            local _,_, spellid = GetCompanionInfo('MOUNT', i)
            table.insert(self.db.mounts, spellid)
        end
    end
    if(num_critters>0) then
        for i = 1, num_critters do
            local _, _, spellid = GetCompanionInfo('CRITTER', i)
            table.insert(self.db.critters, spellid)
        end
    end
end

function gather:KNOWN_TITLES_UPDATE()
    self.db.titles = self.db.titles or {}
    wipe(self.db.titles)
    for i = 1, GetNumTitles() do
        -- GetTitleName
        if(IsTitleKnown(i) == 1) then
            table.insert(self.db.titles, i)
        end
    end
end

function gather:QUEST_QUERY_COMPLETE()
    self.db.quests = self.db.quests or {}
    wipe(self.db.quests)

    local complete_list = GetQuestsCompleted()
    for id in next, complete_list do
        table.insert(self.db.quests, id)
    end
end

function gather:ACHIEVEMENT_EARNED()
    self.db.achievements = self.db.achievements or {}
    wipe(self.db.achievements)

    local categoryList = GetCategoryList()
    for _, cateID in ipairs(categoryList) do
        local num_achi = GetCategoryNumAchievements(cateID)
        if(num_achi and num_achi>0) then
            for offset = 1, num_achi do
                local achi_id, name, points, completed, month, day, year, desc, flags, image, rewardText = GetAchievementInfo(cateID, offset)
                if(completed) then
                    table.insert(self.db.achievements, achi_id)
                end
            end
        end
    end
end

--function gather:UPDATE_FACTION()
--    self.db.factions = self.db.factions or {}
--    wipe(self.db.factions)
--
--    for i = 1, GetNumFactions() do
--        local name, desc, standingID, bottomValue, topValue, earnedValue = GetFactionInfo()
--        self.db.factions[name] = earnedValue
--    end
--end

function gather:PLAYER_GUILD_UPDATE()
    self.db.guild = self.db.guild or {}
    if(not IsInGuild()) then
        wipe(self.db.guild)
    end

    local num_perks = GetNumGuildPerks()
    local guild_level = GetGuildLevel()

    self.db.guild.level = guild_level
    self.db.guild.perks = self.db.guild.perks or {}
    wipe(self.db.guild.perks)

    for i = 1, num_perks do
        local name, spellid, icon, level = GetGuildPerkInfo(i)
        if(guild_level >= level) then
            table.insert(self.db.guild.perks, spellid)
        end
    end

    local currentXP, nextLevelXP, dailyXP, maxDailyXP = UnitGetGuildXP'player'
    self.db.guild.currentxp = currentXP

    local name, desc, standingID, barMin, barMax, barValue = GetGuildFactionInfo()
    self.db.guild.faction_standingid = standingID
    self.db.guild.faction_currentvalue = barValue
    self.db.guild.faction_currentmax = barMax
    self.db.guild.faction_currentmin = barMin
end

gather.GUILD_XP_UPDATE = gather.PLAYER_GUILD_UPDATE
gather.GUILD_PERK_UPDATE = gather.GUILD_XP_UPDATE
gather.UPDATE_FACTION = gather.GUILD_XP_UPDATE

do
    local profession_spells = {
        2259,  -- Alchemy
        2018,  -- Blacksmith
        7411,  -- Enchanting
        4036,  -- Engineering
        45357, -- Inscription
        25229, -- Jewelcrafting
        2108,  -- Leatherworking
        2656,  -- Smelting (Mining)
        3908,  -- Tailoring
        2550,  -- Cooking
        3273   -- First Aid
    }
    local smelt = GetSpellInfo(2575)

    local function scanProfession(spellName, profid)
        gather.db.professions = gather.db.professions or {}
        local skillLineName = GetTradeSkillLine()

        if(skillLineName == 'UNKNOWN') then
            return
        end

        if(spellName) then
            if(skillLineName ~= spellName) then
                if(gather.db.professions[profid]) then
                    gather.db.professions[profid] = nil
                end
                return
            end
        else
            if(skillLineName == smelt) then
                profid = 2565
            else
                for _, id in ipairs(profession_spells) do
                    local sn = GetSpellInfo(id)
                    if(sn and sn == skillLineName) then
                        profid = id
                    end
                end
            end
            if(not profid) then
                return
            end
        end

        TradeSkillFrame:UnregisterEvent'TRADE_SKILL_UPDATE'

        gather.db.professions[profid] = gather.db.professions[profid] or {}
        local prof = gather.db.professions[profid]
        wipe(prof)

        -- clear filters
        TradeSkillOnlyShowSkillUps(false)
        TradeSkillOnlyShowMakeable(false)

        SetTradeSkillSubClassFilter(0, 1, 1)
        SetTradeSkillInvSlotFilter(0, 1, 1)

        local unexpanded = {}

        local i = 1
        while(i<=GetNumTradeSkills()) do
            local name, cate, _, isExpanded = GetTradeSkillInfo(i)
            if(name) then
                if(cate == 'header') then
                    if(not isExpanded) then
                        ExpandTradeSkillSubClass(i)
                        unexpanded[name] = true
                    end
                else
                    local spellid = string.match(GetTradeSkillRecipeLink(i), '|Henchant:(%d+)|h')
                    if(spellid) then
                        local succ, spellid = pcall(tonumber, spellid)
                        if(succ) then
                            table.insert(prof, spellid)
                        end
                    end
                end
            end
            i = i + 1
        end

        i = 1
        while(i<=GetNumTradeSkills()) do
            local name, cate, _, isExpanded = GetTradeSkillInfo(i)
            if(name and cate == 'header' and unexpanded[name]) then
                CollapseTradeSkillSubClass(i)
            end
            i = i + 1
        end

        TradeSkillOnlyShowMakeable(TradeSkillFrame.filterTbl.hasMaterials)
        TradeSkillOnlyShowSkillUps(TradeSkillFrame.filterTbl.hasSkillUp)

        TradeSkillFrame:RegisterEvent'TRADE_SKILL_UPDATE'

    end

    function gather:ScanProfession()
        if(not IsAddOnLoaded'Blizzard_TradeSkillUI') then
            LoadAddOn'Blizzard_TradeSkillUI'
        end
        self:UnregisterEvent'TRADE_SKILL_SHOW'

        local sound = GetCVar'Sound_EnableSFX'
        SetCVar('Sound_EnableSFX', 0)
        TradeSkillFrame:UnregisterEvent'TRADE_SKILL_SHOW'
        TradeSkillFrame:UnregisterEvent'TRADE_SKILL_CLOSE'

        for _, id in ipairs(profession_spells) do
            local spellName = GetSpellInfo(id)
            if(IsUsableSpell(spellName)) then
                CastSpellByName(spellName)
                scanProfession(spellName, id)
            end
        end

        TradeSkillFrame:RegisterEvent'TRADE_SKILL_SHOW'
        TradeSkillFrame:RegisterEvent'TRADE_SKILL_CLOSE'
        SetCVar('Sound_EnableSFX', sound)

        self:RegisterEvent'TRADE_SKILL_SHOW'
    end

    function gather:TRADE_SKILL_SHOW()
        scanProfession()
    end
end


