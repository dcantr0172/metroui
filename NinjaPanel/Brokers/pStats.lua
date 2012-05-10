local addon = CreateFrame'Frame'
local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('pStats', {text = '...', icon = [=[Interface\AddOns\NinjaPanel\Brokers\pStats]=]})

local function formats(value)
    if(value > 999) then
        return format('%.1f|rMiB', value / 1024)
    else
        return format('%.1f|rKiB', value)
    end
end

local Hex = function(r, g, b)
    if type(r) == "table" then
        if r.r then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
    end
    return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local percent_color = {}

local inf = math.huge
local ColorGradient = function(perc, ...)
    -- Translate divison by zeros into 0, so we don't blow select.
    -- We check perc against itself because we rely on the fact that NaN can't equal NaN.
    if(perc ~= perc or perc == inf) then perc = 0 end

    if perc >= 1 then
        local r, g, b = select(select('#', ...) - 2, ...)
        return r, g, b
    elseif perc <= 0 then
        local r, g, b = ...
        return r, g, b
    end

    local num = select('#', ...) / 3
    local segment, relperc = math.modf(perc*(num-1))
    local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

    return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

local smooth = {
    1, 0, 0,
    1, 1, 0,
    0, 1, 0
}

for i = 0, 100 do
    percent_color[i] = {ColorGradient(i/100, unpack(smooth))}
end

local get_color_by_perc = function(perc)
    perc = floor(perc)
    if(perc<0) then
        perc=0
    elseif (perc>100) then
        perc=100
    end

    return Hex(percent_color[perc])
    --print(c .. perc)
    --return c
end


local addons = {}
local tbls = setmetatable({}, {__mode='v'})
--local tbls = {}
local new_tbl = function()
    if(next(tbls)) then
        return wipe(table.remove(tbls, 1))
    end
    return {}
end
local del_tbl = function(tbl)
    table.insert(tbls, tbl)
end

function dataobj.OnLeave()
	--GameTooltip:SetClampedToScreen(true)
	GameTooltip:Hide()
end

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end

local function UpdateAddOnTotalMemory()
	UpdateAddOnMemoryUsage()
	local mem = 0;
	for i = 1, GetNumAddOns() do
        if(IsAddOnLoaded(i)) then
			local _mem = GetAddOnMemoryUsage(i)
			mem = mem + _mem;
        end
    end
	return mem;
end

function dataobj.OnEnter(self)
    wipe(addons)
    UpdateAddOnMemoryUsage()

    for i = 1, GetNumAddOns() do
        if(IsAddOnLoaded(i)) then
            local _, name = GetAddOnInfo(i)
            local mem = GetAddOnMemoryUsage(i)
            local t = new_tbl()
            t.name = name
            t.mem = mem

            table.insert(addons, t)
        end
    end
    table.sort(addons, (function(a,b) return a.mem > b.mem end))

    GameTooltip:SetOwner(self, 'ANCHOR_NONE')
    GameTooltip:SetPoint(GetTipAnchor(self))
    GameTooltip:ClearLines()
    GameTooltip:AddLine'   '

    local c = 0
    for i, ad in ipairs(addons) do
        GameTooltip:AddDoubleLine(ad.name, get_color_by_perc(100 - ad.mem/(3*1024)*100) ..formats(ad.mem), 1,1,1,1,1,1)
        c = c + 1
        if(c >= 25) then
            break
        end
    end

    GameTooltip:Show()
    for k,v in next, addons do
        del_tbl(v)
    end
    wipe(addons)

--	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMLEFT', 0, self:GetHeight())
--	GameTooltip:ClearLines()
--	GameTooltip:AddDoubleLine(fps, net, r, g, b, r, g, b)
--	GameTooltip:AddLine('\n')
--
--	local addons, entry, total = {}, {}, 0
--	UpdateAddOnMemoryUsage()
--
--	for i = 1, GetNumAddOns() do
--		if(IsAddOnLoaded(i)) then
--			entry = {GetAddOnInfo(i), GetAddOnMemoryUsage(i)}
--			table.insert(addons, entry)
--			total = total + GetAddOnMemoryUsage(i)
--		end
--	end
--
--    table.sort(addons, (function(a, b) return a[2] > b[2] end))
--
--	for i,entry in pairs(addons) do
--		--GameTooltip:AddDoubleLine(entry[1], formats(entry[2]), 1, 1, 1)
--	end

--	GameTooltip:Show()
end

function dataobj.OnClick(self, button)
    local collected = collectgarbage'count'
    collectgarbage'collect'
    dataobj.OnEnter(self)
--    GameTooltip:AddLine('\n')
--    GameTooltip:AddDoubleLine('Garbage Collected:', formats(collected - collectgarbage('count')))
--    GameTooltip:Show()
end


local update_dataobj = function()
    local mem = UpdateAddOnTotalMemory();
    local fps = GetFramerate()
    local _, _, lagHome, lagWorld = GetNetStats()

    --print('mem', mem)
    mem = get_color_by_perc(mem/1024) .. formats(mem)   -- mem / 102400 * 100
    --print('fps', fps)
    fps = get_color_by_perc((fps-10)/40 * 100) .. floor(fps)         -- 10 < fps < 50
    --print('lag', lagHome, lagWorld)
    lagHome = get_color_by_perc(100 - lagHome/3) .. lagHome       -- 0 < lag < 300
    lagWorld = get_color_by_perc(100 - lagWorld/3) .. lagWorld

    dataobj.text = format('%s|r %s|rfps %s|r/%s|rms', mem, fps, lagHome, lagWorld)
end

local count, max_frames = 0, 40
local function onUpdate(self)
    count = count - 1
    if(count < 0) then
        count = max_frames
        update_dataobj()
    end
end

addon:RegisterEvent('PLAYER_LOGIN')

addon:SetScript('OnEvent', function(self, event, addon)
    count = max_frames
    self:SetScript('OnUpdate', onUpdate)
end)
