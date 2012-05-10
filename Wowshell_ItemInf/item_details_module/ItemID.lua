local _, ns = ...
ns.MODULES['ITEMID'] = setmetatable({}, {
    __index = function(t, i)
        t[i] = i
        return i
    end
})
