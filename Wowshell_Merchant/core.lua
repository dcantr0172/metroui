
local Merchant = LibStub('AceAddon-3.0'):NewAddon('wsMerchant', 'AceEvent-3.0')
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['Wowshell Merchant: '] = '精灵商人助手',
    ['Sell %s x %d for %s'] = '卖出 %s x %d  (%s)',
    ['Sell %s for %s'] = '卖出 %s  (%s)',
    ['Audo sell junk'] = '自动出售垃圾',
    ['Auto sell grey items when talking to a merchant'] = '和商人对话时自动出售灰色物品',
    ['Chat feedback'] = '聊天反馈',
    ['Give chat feedback when selling and repairing'] = '出售和修理时在聊天窗口提示',
    ['Auto restocking config'] = '自动补购设置',
    ['Auto restocking settings'] = '设置自动补购物品',
    ['Auto repair'] = '自动修理',
    ['Repair all items when meeting a merchant'] = '在和商人对话时自动修理装备和背包内物品',
    ['Use guildbank'] = '使用公会银行修理',
    ['use guildbank to repair your equipments'] = '用公会银行的金币修理装备',
    ['G'] = '金',
    ['S'] = '银',
    ['C'] = '铜',
    ['Repairing costs %s |cff00ff00(use guild bank)|r'] = '修理花费 %s |cffff0000(使用公会银行)|r',
    ['Repairing costs %s |cffff0000(cannot use guild bank)|r'] = '修理花费 %s |cffff0000(无法使用公会银行)|r',
    ['Repairing costs %s'] = '修理花费 %s',
    ['Not enough, needs %s'] = '需要修理费: %s',
    ["Wowshell Merchant"] = '贩卖修理助手',
    ["Auto repair, auto junk seller, ..."] = '自动贩卖, 修理',
    ['Selling list'] = '贩卖列表',
    ['Adding %s to selling list'] = '%s 已被加入自动贩卖列表',
    ['Removing %s from selling list'] = '%s 已被从自动贩卖列表中移除',
    ['Dragging items onto this button will add/remove this item to/from selling list'] = '将物品拖到这个按钮上会将其加入/移除贩卖列表',
} or GetLocale() == 'zhTW' and {
    ['Wowshell Merchant: '] = '精靈商人助手',
    ['Sell %s x %d for %s'] = '售出 %s x %d (%s)',
    ['Sell %s for %s'] = '售出 %s (%s)',
    ['Audo sell junk'] = '自動出售垃圾',
    ['Auto sell grey items when talking to a merchant'] = '和商人對話時自動出售灰色物品',
    ['Chat feedback'] = '聊天反饋',
    ['Give chat feedback when selling and repairing'] = '出售和修理時在聊天窗口提示',
    ['Auto restocking config'] = '自動補購設置',
    ['Auto restocking settings'] = '設置自動補購物品',
    ['Auto repair'] = '自動修理',
    ['Repair all items when meeting a merchant'] = '在和商人對話時自動修理裝備和背包內物品',
    ['Use guildbank'] = '使用公會銀行修理',
    ['use guildbank to repair your equipments'] = '用公會銀行的金幣修理裝備',
    ['G'] = '金',
    ['S'] = '銀',
    ['C'] = '銅',
    ['Repairing costs %s |cff00ff00(use guild bank)|r'] = '修理花費%s |cffff0000(使用公會銀行)|r',
    ['Repairing costs %s |cffff0000(cannot use guild bank)|r'] = '修理花費%s |cffff0000(無法使用公會銀行)|r',
    ['Repairing costs %s'] = '修理花費 %s',
    ['Not enough, needs %s'] = '需要修理費: %s',
    ["Wowshell Merchant"] = '販賣修理助手',
    ["Auto repair, auto junk seller, ..."] = '自動販賣, 修理', 
    ['Selling list'] = '販賣列表',
    ['Adding %s to selling list'] = '%s 已被加入自動販賣列表',
    ['Removing %s from selling list'] = '%s 已被從自動販賣列表中移除',
    ['Dragging items onto this button will add/remove this item to/from selling list'] = '將物品拖到這個按鈕上會將其加入/移除自動販賣列表',
} or {}, {__index = function(t, i) return i end})

Merchant.L = L

local db
local defaults = {
    profile = {
        chatpromt = true,
        selljunk = true,
        autorepair = true,
        useguildbank = true,
        sellinglist = {},
    },
}

function Merchant:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New('WSMERCHANTDB', defaults, UnitName'player' .. '-' ..GetRealmName())
    db = self.db.profile

    self:RegisterEvent('MERCHANT_SHOW')

    self:SetupOption()
end

function Merchant:MERCHANT_SHOW()
    if(db.selljunk) then
        self:SellJunk()
    end
    if(db.autorepair and CanMerchantRepair()) then
        self:Repair()
    end
    self:SellJunksOnList()
end

function Merchant:Repair()
    local cost, can = GetRepairAllCost()
    if(cost and cost>0 and can) then
        can = true
    else
        can = false
    end
    if(not can) then return end

    if(db.useguildbank) then
        local costLeft = cost
        if(IsInGuild() and CanGuildBankRepair()) then
            local costLimit = GetGuildBankWithdrawMoney()
            local gbRepairMoney
            if(costLimit == -1) then
                gbRepairMoney = math.min(GetGuildBankMoney(), cost)
            else
                gbRepairMoney = math.min(costLimit, cost)
            end

            self:PromptRepair(L['Repairing costs %s |cff00ff00(use guild bank)|r'], gbRepairMoney)

            costLeft = cost - gbRepairMoney
            RepairAllItems(1)
        end

        if(costLeft > 0) then
            local hasMoney = GetMoney()
            self:PromptRepair(L['Repairing costs %s |cffff0000(cannot use guild bank)|r'], math.min(costLeft, hasMoney))
            if(hasMoney < costLeft) then
                self:PromptRepair(L['Not enough, needs %s'], costLeft - hasMoney)
            end
            RepairAllItems()
        end
    else
        RepairAllItems()
        local hasMoney = GetMoney()
        if(hasMoney > 0) then
            self:PromptRepair(L['Repairing costs %s'], math.min(hasMoney, cost))
        end
        if(cost > hasMoney) then
            self:PromptRepair(L['Not enough, needs %s'], cost - hasMoney)
        end
    end

--    if(cost and cost>0 and can) then
--        if(db.useguildbank) then
--            local gbm = GetGuildBankWithdrawMoney()
--            if(IsInGuild() and CanGuildBankRepair() and (gbm >= cost or gbm==-1)) then
--                RepairAllItems(1)
--                self:PromptRepair(L['Repairing costs %s |cff00ff00(use guild bank)|r'], cost)
--            else
--                RepairAllItems()
--                self:PromptRepair(L['Repairing costs %s |cffff0000(cannot use guild bank)|r'], cost)
--            end
--        else
--            RepairAllItems()
--            self:PromptRepair(L['Repairing costs %s'], cost)
--        end
--    end
end

function Merchant:PromptRepair(text, money)
    if(db.chatpromt) then
        self:PrintF(text, self:FormatMoney(money))
    end
end

function Merchant:SellJunk()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemLink = GetContainerItemLink(bag, slot)
            if(itemLink) then
                local tex, count, locked, quality, readable = GetContainerItemInfo(bag, slot)
                local name, link, quality = GetItemInfo(itemLink)

                if(quality == 0) then
                    self:Sell(bag, slot, count, link)
                    --print(bag, slot, quility, quality == 0 )
                end
            end
        end
    end
end

function Merchant:SellJunksOnList()
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local itemlink = GetContainerItemLink(bag, slot)
            local itemid = itemlink and tonumber(itemlink:match'item:(%d+):')
            if(itemid and db.sellinglist[itemid]) then
                local tex, count, locked, quality, readable = GetContainerItemInfo(bag, slot)
                self:Sell(bag, slot, count, itemlink)
            end
        end
    end
end

function Merchant:Sell(bag, slot, count, link)
    ShowMerchantSellCursor(1)
    UseContainerItem(bag, slot)
    if(db.chatpromt) then
        self:PromptJunkSell(bag, slot, count, link)
    end
end

function Merchant:Print(...)
    print('|cff33ff99' .. L['Wowshell Merchant: '] .. '|r', ...)
end

function Merchant:PrintF(s, a, ...)
    if(s and a) then
        Merchant:Print(string.format(s, a, ...))
    end
end

function Merchant:PromptJunkSell(bag, slot, count, link)
    local name, ilink, rarity, ilvl, minLvl, iType, subType, stackCount, location, texture, price = GetItemInfo(link)

    if(count and count > 1) then
        self:PrintF(L['Sell %s x %d for %s'], link, count, self:FormatMoney(price*count))
    else
        self:PrintF(L['Sell %s for %s'], link, self:FormatMoney(price))
    end
end

local function truncate(d)
    return string.format('%d', d)
end

function Merchant:FormatMoney(value)
--    local g = math.floor(money/10000)
--    local s = math.floor((money/100) % 100)
--    local b = math.floor(money%100)
--
--    local text = '|cffeda55f' .. truncate(b) .. L['B'] .. '|r'
--    if(s>0) or (s==0 and g>0) then
--        text = '|cffc7c7cf' .. truncate(s) .. L['S'] .. text
--    end
--
--    if(g>0) then
--        text = '|cffffd700' .. truncate(g) .. L['G'] .. text
--    end
    local str = ''
    if(value >= 10000) then
        str = str .. format('|c00ffd700%d%s|r', floor(value/10000), L.G)
    end
    if(value >= 100) then
        str = str .. format('|c00c7c7cf%d%s|r', floor(value/100) % 100, L.S)
    end
    str = str .. format('|c00eda55f%d%s|r', ceil(value%100), L.C)

    return str
end

function Merchant:SetupOption()
    local order
    do
        local a = 0
        function order()
            a = a + 1
            return a
        end
    end

    if(not self.option) then
        self.option = {
            blah = {
                order=  order()+99999,
                type = 'description',
                fontSize = 'medium',
                name = GetLocale() == 'zhTW' and [[在原來自動修理和售賣的功能上做了改進，還增加了自動補購的功能，可以點擊自行設置要補購的物品。]] or [[在原来自动修理和售卖的功能上做了改进，还增加了自动补购的功能，可以点击自行设置要补购的物品。]] ,
            },
            selljunk = {
                type = 'toggle',
                order = order(),
                name = L['Audo sell junk'],
                desc = L['Auto sell grey items when talking to a merchant'],
                get = function() return db.selljunk end,
                set = function(_,v) db.selljunk = v end,
            },
            repair = {
                type = 'toggle',
                order = order(),
                name = L['Auto repair'],
                desc = L['Repair all items when meeting a merchant'],
                get = function() return db.autorepair end,
                set = function(_,v)
                    db.autorepair = v
                end
            },
            usegb = {
                type = 'toggle',
                order = order(),
                name = L['Use guildbank'],
                desc = L['use guildbank to repair your equipments'],
                get = function() return db.useguildbank end,
                set = function(_,v)
                    db.useguildbank = v
                end
            },
            chatpromt = {
                type = 'toggle',
                order = order(),
                name = L['Chat feedback'],
                desc = L['Give chat feedback when selling and repairing'],
                get = function() return db.chatpromt end,
                set = function(_,v) db.chatpromt = v end,
            },
            openSYC = {
                type = 'execute',
                order = order(),
                name = L['Auto restocking config'],
                desc = L['Auto restocking settings'],
                func = function()
                    if(StealYourCarbon) then
                        InterfaceOptionsFrame_OpenToCategory(StealYourCarbon.configframe)
                    else
                        --TODO
                    end
                end,
            },
        }

--        self.option.profile = LibStub('AceDBOptions-3.0'):GetOptionsTable(self.db)
--        self.option.profile.order = order()
    end

end


