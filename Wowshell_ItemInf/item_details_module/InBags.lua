local _, ns = ...

local lasti, lastc
ns.MODULES['INBAG'] = setmetatable({}, {
    __index = function(t, i)
        if i ~= lasti then
            local num = GetItemCount(i)
            lastc = num > 0 and num
            lasti = i
        end
        return lastc
    end
})

local lasti , lastc
ns.MODULES['INBANK'] = setmetatable({}, {
    __index = function(t, i)
        if i ~= lasti then
            local num = GetItemCount(i, true) - GetItemCount(i)
            lastc = num > 0 and num
            lasti = i
        end
        return lastc
    end
})


