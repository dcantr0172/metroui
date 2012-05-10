

local coords_format = ' (%.1f, %.1f)'
local f = CreateFrame'Frame'

local text_zone = ''

local dataobj = LibStub("LibDataBroker-1.1"):NewDataObject("Broker_Location", {
	type	= "data source",
	icon	= "Interface\\Icons\\INV_Misc_Map07.png",
	--label	= "Broker_Location",
	text	= text_zone,
})

local zone_types = {
    sanctuary = {0.41, 0.8, 0.94},
    arena = {1.0, 0.1, 0.1},
    friendly = {0.1, 1.0, 0.1},
    hostile = {1.0, 0.1, 0.1},
    contested = {1.0, 0.7, 0},
    combat = {1.0, 0.1, 0.1},
    default = {1.0, 0.9294, 0.7607},
}

local updateCoords = function()
    local x, y = GetPlayerMapPosition'player'

    dataobj.text = text_zone .. string.format(coords_format, x*100, y*100)
end

local updateZone = function()
    local pvpType = GetZonePVPInfo()
    local pvp_color = pvpType and zone_types[pvpType] or zone_types.default

    local color = string.format('|cff%02x%02x%02x', 255*pvp_color[1], 255*pvp_color[2], 255*pvp_color[3])

    local realZone = GetRealZoneText()
    local subZone = GetSubZoneText()

    if(realZone and subZone and subZone~='' and realZone~=subZone) then
        realZone = realZone .. ': ' .. subZone
    end

    if(realZone) then
        text_zone = color .. realZone .. '|r'
        updateCoords()
    else
        text_zone = ''
    end
end

local frames_to_update = 20
local count = 50

local onUpdate = function()
    count = count - 1
    if(count > 0) then return end
    count = frames_to_update

    updateCoords()
end

f:SetScript('OnEvent', function(self)
    self:RegisterEvent'PLAYER_ENTERING_WORLD'
    self:RegisterEvent'ZONE_CHANGED_NEW_AREA'
    self:RegisterEvent'ZONE_CHANGED_INDOORS'
    self:RegisterEvent'ZONE_CHANGED'
    self:RegisterEvent'WORLD_MAP_UPDATE'

    updateZone()
    self:SetScript('OnUpdate', onUpdate)
end)
f:RegisterEvent'PLAYER_LOGIN'

