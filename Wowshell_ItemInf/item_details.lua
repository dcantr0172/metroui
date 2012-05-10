
local _, ns = ...

ns.MODULES = {}
local orig = {}
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['ILEVEL'] = '物品等级',
    ['INBAG'] = '背包',
    ['INBANK'] = '银行',
    ['ITEMID'] = '物品ID',
    ['ITEMTYPE'] = '物品分类',
    ['STACKSIZE'] = '物品堆叠',
    ['WEIGHTEDILEVEL'] = '平均物品等级',

    ['Tooltip enhance'] = '鼠标提示',
} or GetLocale() == 'zhTW' and {
    ['ILEVEL'] = '物品等級',
    ['INBAG'] = '背包',
    ['INBANK'] = '銀行',
    ['ITEMID'] = '物品ID',
    ['ITEMTYPE'] = '物品分類',
    ['STACKSIZE'] = '物品堆疊',
    ['WEIGHTEDILEVEL'] = '平均物品等級',

    ['Tooltip enhance'] = '鼠標提示',
} or {
    ['ILEVEL'] = 'iLevel',
    ['INBAG'] = 'Bag',
    ['INBANK'] = 'Bank',
    ['ITEMID'] = 'ItemID',
    ['ITEMTYPE'] = 'ItemType',
    ['STACKSIZE'] = 'Stacksize',
    ['WEIGHTEDILEVEL'] = 'WeightediLvl',
}, { __index = function(t, i) t[i] = i return i end })

local R, G, B = 1, .82, 0

local function OnTooltipSetItem(frame, ...)
    local name, link = frame:GetItem()
    local id = link and tonumber(link:match'item:(%d+):')
    if(link) then
        for k, v in next, ns.MODULES do
            if ns.db.item_details[k] and v[id] then
                frame:AddDoubleLine(L[k], v[id], R,G,B, R,G,B)
            end
        end
    end
    local f = orig[frame]
    return f and f(frame, ...)
end

for _,frame in pairs{GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2} do
    orig[frame] = frame:GetScript'OnTooltipSetItem'
    frame:SetScript('OnTooltipSetItem', OnTooltipSetItem)
end

tinsert(ns.presetup, function()
    ns.options['TOOLTIP'] = {
        type = 'group',
        inline = true,
        order = ns.getOrder(),
        name = L['Tooltip enhance'],
        args = {},
    }

    local args = ns.options.TOOLTIP.args
    for i in next, ns.MODULES do
        args[i] = {
            name = L[i],
            type = 'toggle',
            order = ns.getOrder(),
            get = function() return ns.db.item_details[i] end,
            set = function(_, v)
                ns.db.item_details[i] = v
            end
        }
    end
end)

