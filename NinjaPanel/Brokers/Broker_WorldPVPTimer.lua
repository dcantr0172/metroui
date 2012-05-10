
local format = string.format
local floor = math.floor

local HOUR = 60*60
local MIN = 60

local max_areas = GetNumWorldPVPAreas()

local f, dataobj = CreateFrame'Frame', LibStub('LibDataBroker-1.1'):NewDataObject('Broker_WorldPVPTimer', {
    type = 'data source',
    icon = UnitFactionGroup'player' == 'Alliance' and [[Interface\PVPFrame\PVP-CURRENCY-ALLIANCE]] or [[Interface\PVPFrame\PVP-CURRENCY-HORDE]],
    text = '...',
})

local function formatTime(waitTime)
    if(type(waitTime) ~= 'number') or (waitTime<0) then return end

    local hour = floor(waitTime / HOUR)
    local minute = floor( (waitTime % HOUR) / MIN )
    local sec = floor( waitTime % MIN )

    if(hour > 0) then
        return ('%d:%02d:%02d'):format(hour, minute, sec)
    elseif(minute > 0) then
        return ('%d:%02d'):format(minute, sec)
    elseif(sec > 0) then
        return ('%ds'):format(sec)
    end
end

local function getPvpInfo(index)
    local pvpid, localizedName, isActive, canQueue, waitTime, canEnter = GetWorldPVPAreaInfo(index)

    return localizedName, formatTime(waitTime) or UNKNOWN
end

dataobj.OnTooltipShow = function(self)
    for i = max_areas, 1, -1 do
        self:AddDoubleLine(getPvpInfo(i))
    end
end

local total = 5
f:SetScript('OnUpdate', function(self, elapsed)
    total = total - elapsed
    if(total <= 0) then
        total = 1

        local name, formattedTime = getPvpInfo(max_areas)
        if(formattedTime) then
            dataobj.text = ('%s: %s'):format(name, formattedTime)
        else
            dataobj.text = ('%s'):format(name)
        end
    end
end)


