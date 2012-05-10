local _, ns = ...

ns.MODULES['ILEVEL'] = setmetatable({}, {
    __index = function(t, i)
        local name, link, quality, lvl = GetItemInfo(i)
        t[i] = lvl or false
        return lvl
    end
})

