local _, ns = ...
local floor = math.floor

ns.MODULES['WEIGHTEDILEVEL'] = setmetatable({}, {
    __index = function(t, i)
        local _, _, quality, ilvl = GetItemInfo(i)
        local wilvl = false
        if(quality == 3) then
            wilvl = floor((ilvl - .75) / .9 + 8)
        elseif(quality == 4) then
            wilvl = floor((ilvl - 26) / .6 + 8)
        end

        t[i] = wilvl
        return wilvl
    end
})
