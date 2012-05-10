local _, ns = ...
local EasyAH = LibStub('AceAddon-3.0'):NewAddon('EasyAH', 'AceEvent-3.0')
_G.EasyAH = EasyAH
--local L = LibStub('AceLocale-3.0'):GetLocale'EasyAH'
local L = setmetatable(GetLocale() == 'zhTW' and {
    ['|cffffd100Add|r'] = '|cffffd100添加|r',
    ['|cffffd100Shift-click to remove'] = '|cffffd100Shift點擊刪除物品',
    ['Search list'] = '搜索列表',
} or GetLocale() == 'zhCN' and {
    ['|cffffd100Add|r'] = '|cffffd100添加|r',
    ['|cffffd100Shift-click to remove'] = '|cffffd100Shift点击删除物品',
    ['Search list'] = '搜索列表',
} or {}, {__index = function(t, i) return i end})
ns.L = L

local defaults = {
    profile = {

    },
    char = {
        ahList = {},
    },
}

local BLIZ_UI = 'Blizzard_AuctionUI'

function EasyAH:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('EasyAHDB', defaults, true)

    if(IsAddOnLoaded(BLIZ_UI)) then
        self:AddonLoaded(nil, BLIZ_UI, true)
    else
        self:RegisterEvent('ADDON_LOADED', 'AddonLoaded')
    end
end

function EasyAH:OnEnable()
end

function EasyAH:OnDisable()
end

function EasyAH:LoadAddon()
    for name, module in self:IterateModules() do
        if(module.LoadAddon) then
            module:LoadAddon()
        end
    end
end

function EasyAH:AddonLoaded(event, addonName)
    if(addonName == BLIZ_UI) then
        self:LoadAddon()
        if(event) then
            self:UnregisterEvent('ADDON_LOADED', 'AddonLoaded')
        end
    end
end


