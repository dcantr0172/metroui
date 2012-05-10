local addonName, ns = ...
local L = ns.Locale or {}

ns.Locale = setmetatable(L, {__index = function(t, i) return i end})

