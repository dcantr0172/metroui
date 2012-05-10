
local parent, ns = ...
local Data = ns.MapPlusNodeData

local DB_NAME = 'WOWSHELL_HANDYNOTES_DB'

local SCALE, ALPHA = 1, 1

local LibBZ = LibStub('LibBabble-Zone-3.0')
local RBZ = LibBZ:GetReverseLookupTable()

Wowshell_HandyNotes = LibStub("AceAddon-3.0"):NewAddon('Wowshell_HandyNotes', 'AceEvent-3.0')

local wsHN = Wowshell_HandyNotes
local HandyNotes = HandyNotes
local prototype_handler = {}
local Icons, List
local Cache = {
--  ['map'] = {
--      ['type'] = {
--          [_coord_] = name,
--      },
--  },
}
local IconCache = {--[[  simple text => icon  ]]}

local iconpath = "Interface\\AddOns\\"..parent.."\\imgs\\"
if(GetLocale() == 'zhCN') then
    Icons = {
        -- Classes
        ["DRUID"]   = {text = "德鲁伊训练师", icon = iconpath .. "Druid"},
        ["HUNTER"]  = {text = "猎人训练师", icon = iconpath .. "Hunter"},
        ["MAGE"]    = {text = "法师训练师", icon = iconpath .. "Mage"},
        ["PALADIN"] = {text = "圣骑士训练师", icon = iconpath .. "Paladin"},
        ["PRIEST"]  = {text = "牧师训练师", icon = iconpath .. "Priest"},
        ["ROGUE"]   = {text = "潜行者训练师", icon = iconpath .. "Rogue"},
        ["SHAMAN"]  = {text = "萨满训练师", icon = iconpath .. "Shaman"},
        ["WARLOCK"] = {text = "术士训练师", icon = iconpath .. "Warlock"},
        ["WARRIOR"] = {text = "战士训练师", icon = iconpath .. "Warrior"},
        ["DEATHKNIGHT"]  = {text = "死亡骑士训练师", icon = iconpath .. "Deathknight"},

        -- Primary
        ["Alchemy"]        = {text = "炼金训练师", icon=iconpath .. "Alchemy"},
        ["Blacksmithing"]  = {text = "锻造训练师", icon=iconpath .. "Blacksmithing"},
        ["Enchanting"]     = {text = "附魔训练师", icon=iconpath .. "Enchanting"},
        ["Engineering"]    = {text = "工程训练师", icon=iconpath .. "Engineering"},
        ["Inscription"]    = {text = "铭文训练师", icon=iconpath .. "Inscription"},
        ["Jewelcrafting"]  = {text = "珠宝训练师", icon=iconpath .. "Jewelcrafting"},
        ["Leatherworking"] = {text = "制皮训练师", icon=iconpath .. "Leatherworking"},
        ["Tailoring"]      = {text = "裁缝训练师", icon=iconpath .. "Tailoring"},

        ["Herbalism"]      = {text = "草药训练师", icon=iconpath .. "Herbalism"},
        ["Mining"]         = {text = "采矿训练师", icon=iconpath .. "Mining"},
        ["Skinning"]       = {text = "剥皮训练师", icon=iconpath .. "Skinning"},

        -- Secondary
        ["Cooking"]        = {text = "烹饪训练师", icon=iconpath .. "Cooking"},
        ["First Aid"]      = {text = "急救训练师", icon=iconpath .. "Firstaid"},
        ["Fishing"]        = {text = "钓鱼训练师", icon=iconpath .. "Fishing"},

        -- Special
        ["WeaponMaster"]  = {text = "武器大师", icon=iconpath .. "Weaponmaster"},
        ["Riding"]        = {text = "骑术训练师", icon=iconpath .. "Riding"},
        ["ColdFlying"]    = {text = "寒冷飞行训练师", icon=iconpath .. "Riding"},

        ["Portal"]  = {text = "传送门训练师", icon=iconpath .. "Portal"},

        ["Pet"]     = {text = "宠物训练师", icon=iconpath .. "Pet"},

        --特殊商人
        ["ArenaTrader"] = {text = "竞技场商人", icon = "Interface\\PVPFrame\\PVP-ArenaPoints-Icon"},
        ["Barber"] = {text = "理发店", icon = iconpath.."haircut"},

        --城市npc坐标点
        ["Auctioneer"] = {text = MINIMAP_TRACKING_AUCTIONEER, icon = "Interface\\Minimap\\Tracking\\Auctioneer"},
        ["Banker"] = {text = MINIMAP_TRACKING_BANKER, icon = "Interface\\Minimap\\Tracking\\Banker"},
        ["BattleMaster"] = {text = MINIMAP_TRACKING_BATTLEMASTER, icon = "Interface\\Minimap\\Tracking\\BattleMaster"},
        --["FlightMaster"] = {text = MINIMAP_TRACKING_FLIGHTMASTER, icon = "Interface\\Minimap\\Tracking\\FlightMaster"},
        ["Innkeeper"] = {text = MINIMAP_TRACKING_INNKEEPER, icon = "Interface\\Minimap\\Tracking\\Innkeeper"},
        ["Mailbox"] = {text = MINIMAP_TRACKING_MAILBOX, icon = "Interface\\Minimap\\Tracking\\Mailbox"},
        ["Repair"] = {text = MINIMAP_TRACKING_REPAIR, icon = "Interface\\Minimap\\Tracking\\Repair"},
        ["StableMaster"] = {text = MINIMAP_TRACKING_STABLEMASTER, icon = "Interface\\Minimap\\Tracking\\StableMaster"},
        ["Profession"] = {text = MINIMAP_TRACKING_TRAINER_PROFESSION, icon = "Interface\\Minimap\\Tracking\\Profession"},
        ["Food"] = {text = MINIMAP_TRACKING_VENDOR_FOOD, icon = "Interface\\Minimap\\Tracking\\Food"},
        ["Poisons"] = {text = MINIMAP_TRACKING_VENDOR_POISON, icon = "Interface\\Minimap\\Tracking\\Poisons"},
        ["Reagents"] = {text = MINIMAP_TRACKING_VENDOR_REAGENT, icon = "Interface\\Minimap\\Tracking\\Reagents"},
    }

    List = {
        ["CLASSES"] = {
            ["DRUID"]   = {text = "德鲁伊训练师" },
            ["HUNTER"]  = {text = "猎人训练师"},
            ["MAGE"]    = {text = "法师训练师"},
            ["PALADIN"] = {text = "圣骑士训练师"},
            ["PRIEST"]  = {text = "牧师训练师"},
            ["ROGUE"]   = {text = "潜行者训练师"},
            ["SHAMAN"]  = {text = "萨满训练师"},
            ["WARLOCK"] = {text = "术士训练师"},
            ["WARRIOR"] = {text = "战士训练师"},
            ["DEATHKNIGHT"]  = {text = "死亡骑士训练师"}, 
        },
        ["PROFESSIONS"] = {
            ["Alchemy"]        = {text = "炼金训练师"},
            ["Blacksmithing"]  = {text = "锻造训练师"},
            ["Enchanting"]     = {text = "附魔训练师"},
            ["Engineering"]    = {text = "工程训练师"},
            ["Inscription"]    = {text = "铭文训练师"},
            ["Jewelcrafting"]  = {text = "珠宝训练师"},
            ["Leatherworking"] = {text = "制皮训练师"},
            ["Tailoring"]      = {text = "裁缝训练师"},

            ["Herbalism"]      = {text = "草药训练师"},
            ["Mining"]         = {text = "采矿训练师"},
            ["Skinning"]       = {text = "剥皮训练师"},
            -- Secondary
            ["Cooking"]        = {text = "烹饪训练师"},
            ["First Aid"]      = {text = "急救训练师"},
            ["Fishing"]        = {text = "钓鱼训练师"},
        },
        ["OTHERS"] = {
            ["WeaponMaster"]  = {text = "武器大师"},
            ["Riding"]        = {text = "骑术训练师"},
            ["ColdFlying"]    = {text = "寒冷飞行训练师"},

            ["Portal"]  = {text = "传送门训练师"},

            ["Pet"]     = {text = "宠物训练师"},
            ["ArenaTrader"] = {text = "竞技场商人"},
            ["Barber"] = {text = "理发店"},
            ["Auctioneer"] = {text = MINIMAP_TRACKING_AUCTIONEER,},
            ["Banker"] = {text = MINIMAP_TRACKING_BANKER,},
            ["BattleMaster"] = {text = MINIMAP_TRACKING_BATTLEMASTER, },
            --["FlightMaster"] = {text = MINIMAP_TRACKING_FLIGHTMASTER, },
            ["Innkeeper"] = {text = MINIMAP_TRACKING_INNKEEPER, },
            ["Mailbox"] = {text = MINIMAP_TRACKING_MAILBOX, },
            ["Repair"] = {text = MINIMAP_TRACKING_REPAIR, },
            ["StableMaster"] = {text = MINIMAP_TRACKING_STABLEMASTER, },
            ["Profession"] = {text = MINIMAP_TRACKING_TRAINER_PROFESSION },
            ["Food"] = {text = MINIMAP_TRACKING_VENDOR_FOOD, },
            ["Poisons"] = {text = MINIMAP_TRACKING_VENDOR_POISON, },
            ["Reagents"] = {text = MINIMAP_TRACKING_VENDOR_REAGENT, }
        },
    }

else

    Icons = {
        -- Classes
        ["DRUID"] = {text = "德魯伊訓練師", icon = iconpath .. "Druid"},
        ["HUNTER"] = {text = "獵人訓練師", icon = iconpath .. "Hunter"},
        ["MAGE"] = {text = "法師訓練師", icon = iconpath .. "Mage"},
        ["PALADIN"] = {text = "聖騎士訓練師", icon = iconpath .. "Paladin"},
        ["PRIEST"] = {text = "牧師訓練師", icon = iconpath .. "Priest"},
        ["ROGUE"] = {text = "潛行者訓練師", icon = iconpath .. "Rogue"},
        ["SHAMAN"] = {text = "薩滿訓練師", icon = iconpath .. "Shaman"},
        ["WARLOCK"] = {text = "術士訓練師", icon = iconpath .. "Warlock"},
        ["WARRIOR"] = {text = "戰士訓練師", icon = iconpath .. "Warrior"},
        ["DEATHKNIGHT"] = {text = "死亡騎士訓練師", icon = iconpath .. "Deathknight"},

        -- Primary
        ["Alchemy"] = {text = "煉金訓練師", icon=iconpath .. "Alchemy"},
        ["Blacksmithing"] = {text = "鍛造訓練師", icon=iconpath .. "Blacksmithing"},
        ["Enchanting"] = {text = "附魔訓練師", icon=iconpath .. "Enchanting"},
        ["Engineering"] = {text = "工程訓練師", icon=iconpath .. "Engineering"},
        ["Inscription"] = {text = "銘文訓練師", icon=iconpath .. "Inscription"},
        ["Jewelcrafting"] = {text = "珠寶訓練師", icon=iconpath .. "Jewelcrafting"},
        ["Leatherworking"] = {text = "制皮訓練師", icon=iconpath .. "Leatherworking"},
        ["Tailoring"] = {text = "裁縫訓練師", icon=iconpath .. "Tailoring"},

        ["Herbalism"] = {text = "草藥訓練師", icon=iconpath .. "Herbalism"},
        ["Mining"] = {text = "採礦訓練師", icon=iconpath .. "Mining"},
        ["Skinning"] = {text = "剝皮訓練師", icon=iconpath .. "Skinning"},

        -- Secondary
        ["Cooking"] = {text = "烹飪訓練師", icon=iconpath .. "Cooking"},
        ["First Aid"] = {text = "急救訓練師", icon=iconpath .. "Firstaid"},
        ["Fishing"] = {text = "釣魚訓練師", icon=iconpath .. "Fishing"},

        -- Special
        ["WeaponMaster"] = {text = "武器大師", icon=iconpath .. "Weaponmaster"},
        ["Riding"] = {text = "騎術訓練師", icon=iconpath .. "Riding"},
        ["ColdFlying"] = {text = "寒冷飛行訓練師", icon=iconpath .. "Riding"},

        ["Portal"] = {text = "傳送門訓練師", icon=iconpath .. "Portal"},

        ["Pet"] = {text = "寵物訓練師", icon=iconpath .. "Pet"},

        --特殊商人
        ["ArenaTrader"] = {text = "競技場商人", icon = "Interface\\PVPFrame\\PVP-ArenaPoints-Icon"},
        ["Barber"] = {text = "理髮店", icon = iconpath.."haircut"},

        --城市npc坐標點
        ["Auctioneer"] = {text = MINIMAP_TRACKING_AUCTIONEER, icon = "Interface\\Minimap\\Tracking\\Auctioneer"},
        ["Banker"] = {text = MINIMAP_TRACKING_BANKER, icon = "Interface\\Minimap\\Tracking\\Banker"},
        ["BattleMaster"] = {text = MINIMAP_TRACKING_BATTLEMASTER, icon = "Interface\\Minimap\\Tracking\\BattleMaster"},
        --["FlightMaster"] = {text = MINIMAP_TRACKING_FLIGHTMASTER, icon = "Interface\\Minimap\\Tracking\\FlightMaster"},
        ["Innkeeper"] = {text = MINIMAP_TRACKING_INNKEEPER, icon = "Interface\\Minimap\\Tracking\\Innkeeper"},
        ["Mailbox"] = {text = MINIMAP_TRACKING_MAILBOX, icon = "Interface\\Minimap\\Tracking\\Mailbox"},
        ["Repair"] = {text = MINIMAP_TRACKING_REPAIR, icon = "Interface\\Minimap\\Tracking\\Repair"},
        ["StableMaster"] = {text = MINIMAP_TRACKING_STABLEMASTER, icon = "Interface\\Minimap\\Tracking\\StableMaster"},
        ["Profession"] = {text = MINIMAP_TRACKING_TRAINER_PROFESSION, icon = "Interface\\Minimap\\Tracking\\Profession"},
        ["Food"] = {text = MINIMAP_TRACKING_VENDOR_FOOD, icon = "Interface\\Minimap\\Tracking\\Food"},
        ["Poisons"] = {text = MINIMAP_TRACKING_VENDOR_POISON, icon = "Interface\\Minimap\\Tracking\\Poisons"},
        ["Reagents"] = {text = MINIMAP_TRACKING_VENDOR_REAGENT, icon = "Interface\\Minimap\\Tracking\\Reagents"},
    }

    List = {
        ["CLASSES"] = {
            ["DRUID"] = {text = "德魯伊訓練師" },
            ["HUNTER"] = {text = "獵人訓練師"},
            ["MAGE"] = {text = "法師訓練師"},
            ["PALADIN"] = {text = "聖騎士訓練師"},
            ["PRIEST"] = {text = "牧師訓練師"},
            ["ROGUE"] = {text = "潛行者訓練師"},
            ["SHAMAN"] = {text = "薩滿訓練師"},
            ["WARLOCK"] = {text = "術士訓練師"},
            ["WARRIOR"] = {text = "戰士訓練師"},
            ["DEATHKNIGHT"] = {text = "死亡騎士訓練師"},
        },
        ["PROFESSIONS"] = {
            ["Alchemy"] = {text = "煉金訓練師"},
            ["Blacksmithing"] = {text = "鍛造訓練師"},
            ["Enchanting"] = {text = "附魔訓練師"},
            ["Engineering"] = {text = "工程訓練師"},
            ["Inscription"] = {text = "銘文訓練師"},
            ["Jewelcrafting"] = {text = "珠寶訓練師"},
            ["Leatherworking"] = {text = "制皮訓練師"},
            ["Tailoring"] = {text = "裁縫訓練師"},

            ["Herbalism"] = {text = "草藥訓練師"},
            ["Mining"] = {text = "採礦訓練師"},
            ["Skinning"] = {text = "剝皮訓練師"},
            -- Secondary
            ["Cooking"] = {text = "烹飪訓練師"},
            ["First Aid"] = {text = "急救訓練師"},
            ["Fishing"] = {text = "釣魚訓練師"},
        },
        ["OTHERS"] = {
            ["WeaponMaster"] = {text = "武器大師"},
            ["Riding"] = {text = "騎術訓練師"},
            ["ColdFlying"] = {text = "寒冷飛行訓練師"},

            ["Portal"] = {text = "傳送門訓練師"},

            ["Pet"] = {text = "寵物訓練師"},
            ["ArenaTrader"] = {text = "競技場商人"},
            ["Barber"] = {text = "理髮店"},
            ["Auctioneer"] = {text = MINIMAP_TRACKING_AUCTIONEER,},
            ["Banker"] = {text = MINIMAP_TRACKING_BANKER,},
            ["BattleMaster"] = {text = MINIMAP_TRACKING_BATTLEMASTER, },
            --["FlightMaster"] = {text = MINIMAP_TRACKING_FLIGHTMASTER, },
            ["Innkeeper"] = {text = MINIMAP_TRACKING_INNKEEPER, },
            ["Mailbox"] = {text = MINIMAP_TRACKING_MAILBOX, },
            ["Repair"] = {text = MINIMAP_TRACKING_REPAIR, },
            ["StableMaster"] = {text = MINIMAP_TRACKING_STABLEMASTER, },
            ["Profession"] = {text = MINIMAP_TRACKING_TRAINER_PROFESSION },
            ["Food"] = {text = MINIMAP_TRACKING_VENDOR_FOOD, },
            ["Poisons"] = {text = MINIMAP_TRACKING_VENDOR_POISON, },
            ["Reagents"] = {text = MINIMAP_TRACKING_VENDOR_REAGENT, }
        },
    }
end
wsHN.Icons = Icons
wsHN.List = List
local Z2M, M2Z = {}, {}

local continents = { GetMapContinents() }
for c in next, continents do
    local zones = { GetMapZones(c) }
    continents[c] = zones
    for z, lname in next, zones do
        SetMapZoom(c, z)
        local mapFile = GetMapInfo()

        Z2M[lname] = mapFile
        M2Z[mapFile] = lname
    end
end


function wsHN:OnInitialize()


    self:RegisterHNPlugins()
end


do
    local new_plugin = function(__type)
        local new = setmetatable({}, {__index = prototype_handler})
        new.__type = __type

        return new
    end

    function wsHN:RegisterHNPlugins()
        for _, lists in next, List do
            for _, d in next, lists do
                if(d.text) then
                    local plugin = new_plugin(d.text)
                    HandyNotes:RegisterPluginDB(d.text, plugin)
                end
            end
        end
    end
end

local function getIcon(typ)
    for k, v in next, wsHN.Icons do
        if(v.text == typ) then
            return v.icon
        end
    end
end

local emptyTbl = {}
local iter = function(t, prestate)
    if(not t) then return end
    local state, val = next(t, prestate)

    if(state) then
        --print('itering', state, val.icon)
        return state, nil, val.icon, SCALE, ALPHA, nil
    end
end

function prototype_handler:GetNodes(mapFile, minimap, dungeonLevel)
    if(minimap) then
        return iter, emptyTbl, nil
    else
        local typ = self.__type
        local zone
        do
            local localized_zone_name = M2Z[mapFile]
            zone = localized_zone_name and RBZ[localized_zone_name]

            if(not zone) or (not MapPlusNodeData[zone]) then
                return iter, emptyTbl, nil
            end
        end

        if(not zone) then
            return iter, emptyTbl, nil
        end
        if(Cache[zone]) then
            local c = Cache[zone][typ]
            if(c or c == false) then
                return iter, c or emptyTbl, nil
            end
            -- no cache, pass through
        end

        local zone_data = MapPlusNodeData[zone]
        if(zone_data) then
            local new_tbl = {}
            local icon = getIcon(typ)

            for _, node in next, zone_data do
                local num_arg = #node
                if(num_arg >= 3) then
                    --print('each node', num_arg, node, print(node[1]), string.find(node[1], typ))
                    if(string.find(node[1], typ)) then
                        local npc_name = node[2]

                        local detail = {
                            ['text'] = npc_name,
                            ['icon'] = icon,
                            ['type'] = typ,
                        }

                        for i = 3, num_arg do
                            local x, y = unpack(node[i])
                            local coord = HandyNotes:getCoord(x/100, y/100)
                            if(coord) then
                                new_tbl[coord] = detail
                            end
                        end
                    end
                end
            end
            Cache[zone] = Cache[zone] or {}
            Cache[zone][typ] = (next(new_tbl)) and new_tbl or false

            return iter, new_tbl, nil
        end
    end
    return iter, emptyTbl, nil
end

function prototype_handler:OnEnter(mapFile, coord)

end

function prototype_handler:OnLeave(mapFile, coord)

end











