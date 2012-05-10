local _, ns = ...

local MAX_STACK = 2147483647

ns.MODULES['STACKSIZE'] = setmetatable({}, {
    __index = function(t, i)
        local name, link, quality, iLvl, iMinLvl, itemType, itemSubtype, stack = GetItemInfo(i)
        stack = stack or 0
        stack = stack > 1 and stack < MAX_STACK and stack or false
        t[i] = stack
        return stack
    end
})


