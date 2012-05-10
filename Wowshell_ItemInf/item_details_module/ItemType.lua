local _, ns = ...

ns.MODULES['ITEMTYPE'] = setmetatable({}, {
    __index = function(t, i)
        local name, link, quality, ilvl, iMinLvl, itemType, itemSubType = GetItemInfo(i)
        local str = false
        if(itemType) then
            if(itemSubType) then
                str = itemType .. '-' .. itemSubType
            else
                str = itemType
            end
        end

        t[i] = str
        return str
    end
})
