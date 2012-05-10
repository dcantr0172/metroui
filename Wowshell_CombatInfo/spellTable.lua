local CI = LibStub("AceAddon-3.0"):GetAddon("CombatInfo");
local spellTable = CI:NewModule("spellTable");
local L = wsLocale:GetLocale("CombatInfo")

local db;
local options

function spellTable:OnInitialize()
	db = CI.db.profile
	self:SetupOpt();
end

local _order = 0
local function order()
	_order = _order + 1;
	return _order
end

local function replaceSpellName(spellId)
	local spellId = tonumber(spellId)
	local spellName = GetSpellInfo(spellId)
	if spellName then
		return ("|cff71d5ff|Hspell:%d|h%s|h|r"):format(spellId, spellName)
	end
end

local _combatlist = 0;
local function CreateSpellOpt(class, text)
    _combatlist = _combatlist + 1;
    local _cc = "classspell_".._combatlist
    _cc = {
        type = "group",
        name = text,
        order = order(),
        args = {
        }
    }

    local _slist = 0;
    if(db.spelllist[class]) then
        for spellId in pairs(db.spelllist[class]) do
            local _sopt = "spell_".._slist
            local spellData = replaceSpellName(spellId);
            if spellData then
                _cc.args[_sopt] = {}
                _cc.args[_sopt].name = spellData
                _cc.args[_sopt].order = order()
                _cc.args[_sopt].type = "toggle"
                _cc.args[_sopt].descStyle = "inline"
                _cc.args[_sopt].desc = function() GameTooltip:SetHyperlink(spellData); GameTooltip:Show(); end
                _cc.args[_sopt].get = function() return db.spelllist[class][spellId] end
                _cc.args[_sopt].set = function(_, vv) db.spelllist[class][spellId] = vv end
                _slist = _slist + 1;
            end
        end
    end
    return _cc
end

local _buffo = 0;
local function CreateBuffOpt(text)
	_buffo = _buffo + 1;
	local _cc = "classspell_".._buffo
	_cc = {
		type = "group",
		name = text,
		order = order(),
		args = {
		}
	}
	
	local _slist = 0;
	for spellId in pairs(db.bufflist) do
		local _sopt = "spell_".._slist
		local spellData = replaceSpellName(spellId);
		if spellData then
			_cc.args[_sopt] = {}
			_cc.args[_sopt].name = spellData
			_cc.args[_sopt].order = order()
			_cc.args[_sopt].type = "toggle"
			_cc.args[_sopt].descStyle = "inline"
			_cc.args[_sopt].desc = function() GameTooltip:SetHyperlink(spellData); GameTooltip:Show(); end
			_cc.args[_sopt].get = function() return db.bufflist[spellId] end
			_cc.args[_sopt].set = function(_, vv) db.bufflist[spellId] = vv end
			_slist = _slist + 1;
		end
	end
	return _cc
end

function spellTable:SetupOpt()
	options = {
		name = L["法术预警技能列表"],
		type = "group",
		desc = L["自定义法术报警列表"],
		order = 3,
		childGroups = "tab",
		disabled = function() return not CI.db.profile.enabled end,
		args = {
			spellGroup = {
				type = "group",
				name = L["法术列表"],
				desc = L["自定义法术报警列表"],
				order = 101,
				childGroups = "tab",
				args = {
					spellExtra = {
						type = "group",
						name = L["自定义"],
						order = 208,
						args = {
							spellAdd = {
								order = 1,
								type = "input",
								name = L["自定义需要的法术"],
								usage = L["<法术名称>"],
								get = function() return "" end,
								set = function(_, v)
									db.spellCustom[v] = true
									db.spellCustomcache[v] = v
								end,
							},
							spellRemove = {
								order = 2,
								type = 'multiselect',
								name = L["移除自定义法术"],
								get = function() return false end,
								set = function(_, key) 
									db.spellCustom[key] = nil
									db.spellCustomcache[key] = nil
								end,
								values = db.spellCustomcache,
							},
						},
					},
				},
			},
			buffGroup = {
				type = "group",
				name = L["增益列表"],
				desc = L["自定义Buff报警列表"],
				order = 102,
				childGroups = "tab",
				args = {
					buffExtra = {
						type = "group",
						name = L["自定义"],
						order = 208,
						args = {
							spellAdd = {
								order = 1,
								type = "input",
								name = L["自定义需要的增益"],
								usage = L["<法术名称>"],
								get = function() return "" end,
								set = function(_, v)
									db.buffCustom[v] = true
									db.buffCustomcache[v] = v
								end,
							},
							spellRemove = {
								order = 2,
								type = 'multiselect',
								name = L["移除自定义法术"],
								get = function() return false end,
								set = function(_, key) 
									db.buffCustom[key] = nil
									db.buffCustomcache[key] = nil
								end,
								values = db.buffCustomcache,
							},
						},
					},
				},
			},
		},
	}

    local locale_classes = {}
    FillLocalizedClassList(locale_classes)
    local CLASS_SORT_ORDER = CLASS_SORT_ORDER

    for _, c in next, CLASS_SORT_ORDER do
        local enc = strlower(c)
        local lc  = locale_classes[c]
        options.args.spellGroup.args[enc] = CreateSpellOpt(enc, lc)
    end

	--options.args.spellGroup.args["priest"] = CreateSpellOpt("priest", "牧师");
	--options.args.spellGroup.args["druid"] = CreateSpellOpt("druid", "德鲁伊");
	--options.args.spellGroup.args["hunter"] = CreateSpellOpt("hunter", "猎人");
	--options.args.spellGroup.args["mage"] = CreateSpellOpt("mage", "法师");
	--options.args.spellGroup.args["shaman"] = CreateSpellOpt("shaman", "萨满祭司");
	--options.args.spellGroup.args["warlock"] = CreateSpellOpt("warlock", "术士");
	--options.args.spellGroup.args["paladin"] = CreateSpellOpt("paladin", "圣骑士");
	--options.args.spellGroup.args["deathknight"] = CreateSpellOpt("deathknight", "死亡骑士");
	--options.args.spellGroup.args["warrior"] = CreateSpellOpt("warrior", "战士");	
	options.args.buffGroup.args.bufflist = CreateBuffOpt("增益列表");
	CI:RegisterModuleOptions("spellTable", options, L["法术列表"])
end
