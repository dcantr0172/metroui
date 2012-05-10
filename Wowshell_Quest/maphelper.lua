local wsQuest = LibStub('AceAddon-3.0'):GetAddon'wsQuest'
local MH = wsQuest:NewModule'MapHelper'

local HandyNotes = HandyNotes

local continents
local zone2map, map2zone = {}, {}
local id2map, map2id = {}, {}

continents = { GetMapContinents() }
for c in next, continents do
    local zones = { GetMapZones(c) }
    continents[c] = zones

    for z, lname in next, zones do
        SetMapZoom(c, z)
        local mapFile = GetMapInfo()

        zone2map[lname] = mapFile
        map2zone[mapFile] = lname

        local id = GetCurrentMapAreaID()
        map2id[mapFile] = id
        id2map[id] = mapFile
    end
end

function MH:MapFileToZone(mapFile)
    return map2zone[mapFile]
end

function MH:ZoneToMapFile(zone)
    return zone2map[zone]
end

function MH:AddWaypointToTomtom(c, z, x, y, title)
    if(TomTom) then
        return TomTom:AddZWaypoint(c,z,x,y,title)
    end
end


D1 = id2map
D2 = map2id
