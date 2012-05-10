#!/usr/bin/env lua

--require 'lib/dump_value'
--local floor = math.floor


function __FILE__() return debug.getinfo(2,'S').source end
function __LINE__() return debug.getinfo(2, 'l').currentline end

require '__LibBabble-Zone'
require '__value_dump'

dofile'data.lua'

--print(MapPlusNodeData, __FILE__(), __LINE__())

local BZL = BZ
local BZ = {}
for k, v in next, BZL do
    BZ[v] = k
end

local untranslated = {}
local new_data = {}

for zone, zone_data in next, MapPlusNodeData do
    local en_zone = BZ[zone]
    if(en_zone) then
        new_data[en_zone] = zone_data
    else
        untranslated[zone] = zone_data
    end
end

print(dump_value(new_data, 'MapPlusNodeData'))
print('\n\n\n\n')
print(dump_value(untranslated, 'untranslated'))


--=======================================
--      data format
--=======================================
--  datadb = {
--      ['map_name(locale)'] = {
--          ['type_id'] = {
--              [coords] = name,
--          },
--      },
--  }



--=======================================
--      rip them off
--=======================================
--local _DATA = {}
--local function GenerateFromFile(filename, locale)
--    _G.GetLocale = function() return locale end
--    dofile(filename)
--    local orig = MapPlusNodeData
--    if(not orig) then
--        error(string.format("File [%s] doesn't exists, please double check and retry", filename))
--    end
--
--    dofile('LibBabble-Zone-3.0.lua')
--
--    local BZ = LibBabbleZone
--    local L = {}
--    for k, v in next, BZ[locale] do
--        L[v] = k
--    end
--
--    for zone, zinfo in next, orig do
--        zone = L[zone] -- delocalize
--        if(not zone) then
--            print(string.format("Zone [%s] can't be delocalized", zone))
--        end
--
--        -- create the data zone
--        if(not _DATA[zone]) then
--            _DATA[zone] = {}
--        end
--        local zdata = _DATA[zone]
--
--        for i, zpack in next, zinfo do
--            local typ, name, coord = unpack(zpack)
--
--            local hn_coord = HandyNotes:getCoord(unpack(coord))
--            zdata[i] = zdata[i] or {}
--
--            zdata[i]['name.'..locale] = name
--            zdata[i]['typ.'..locale] = typ
--            zdata[i]['coord.'..locale] = hn_coord
--        end
--    end
--end

--    local _DATA2 = {}
--    local t2id = {}
--    local id2t = {}
--
--    for zone, z_data in next, _DATA do
--        for coords, c_data in next, z_data do
--            local typ = c_data.typ
--            local name = c_data.name
--
--            local typ_id = t2id[typ]
--
--            if(not typ_id) then
--                table.insert(id2t, typ)
--                typ_id = #id2t
--                t2id[typ] = typ_id
--            end
--
--            print(typ_id, typ)
--        end
--    end
--
--
--    print('WSHN_DATA = {')
--
--    for zone, z_data in next, _DATA do
--        print(ind(1)..'['..zone..'] = {')
--        for coord, c_data in next, z_data do
--            print(coord, c_data.name, c_data.typ)
--        end
--        print(ind(1)..'},'
--    end
--
--    print('}')
--    print''
--    print''
--    print''
--    print''

--GenerateFromFile('BFMData.cn.lua', 'zhCN')
--GenerateFromFile('BFMData.tw.lua', 'zhTW')

--for zone, zone_info in next, _DATA do
--    for p, p_data in next, zone_info do
--        print(p)
--        for k, v in next, p_data do
--            print(k, v)
--        end
--    end
--end


