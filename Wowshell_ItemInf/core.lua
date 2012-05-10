
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['Item info'] = '物品信息增强',
    ['Compare gears, item info, etc..'] = '装备对比, 物品提示增强...',
    ['Hover link'] = '链接悬浮',
    ['Show tooltips for links in chat when hovering over them'] = '鼠标悬浮在聊天栏链接上时显示链接',
} or GetLocale() == 'zhTW' and {
    ['Item info'] = '物品信息增強',
    ['Compare gears, item info, etc..'] = '裝備對比, 物品提示增強...',
    ['Hover link'] = '鏈接懸浮',
    ['Show tooltips for links in chat when hovering over them'] = '鼠標懸浮在聊天欄鏈接上時顯示鏈接',
} or {}, { __index = function(t, i)
    t[i] = i
    return i
end})


local _, ns = ...
local ItemInf = LibStub('AceAddon-3.0'):NewAddon('wsItemInf')

local defaults = {
    profile = {
        item_details = {},
        hover_compare = false,
    }
}


function ItemInf:OnInitialize()
    self.acedb = LibStub('AceDB-3.0'):New('ItemInfDB', defaults)
    self.db = self.acedb.profile
    ns.db = self.db

    self:SetupOption()
end

ns.presetup = {}
local options
function ItemInf:SetupOption()
    for k, v in next, ns.presetup do
        v()
    end

		self.options = options;
end

local _i = 0
ns.getOrder = function()
    _i = _i + 1
    return _i
end

options = {
    hover_compare = {
        order = ns.getOrder(),
        type = 'toggle',
        name = L['Hover link'],
        desc = L['Show tooltips for links in chat when hovering over them'],
        get = function()
            return ns.db.hover_compare
        end,
        set = function(_,v)
            ns.db.hover_compare = v
        end,
    },
}
ns.options = options

