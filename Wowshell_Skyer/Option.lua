local _order = 0
local order, getFunc, setFunc
local L = wsLocale:GetLocale("Skylark");

do
	function order()
		_order = _order + 1
		return _order
	end
	function getFunc(info)
		return (info.arg and Skylark.db.profile[info.arg] or Skylark.db.profile[info[#info]]);
	end
	function setFunc(info, value)
		local key = info.arg or info[#info]
		Skylark.db.profile[key] = value
	end
end

local function getOptions()
	if not Skylark.options then
		Skylark.options = {
			type = "group",
			name = L["额外动作条"],
			childGroups = "tree",
			plugins = {},
			args = {
				lock = {
					order = order(),
					type = "toggle",
					name = L["锁定"],
					desc = L["锁定所有动作条"],
					get = function() return Skylark.Locked end,
					set = function(info, val)
						Skylark[val and "Lock" or "Unlock"](Skylark);
					end,
					width = "half",
				},
				buttonlock = {
					order = order(),
					type = "toggle",
					name = L["按钮锁定"],
					desc = L["锁定按钮"],
					get = function() return Skylark.db.profile.buttonlock end,
					set = function(info, value)
						Skylark.db.profile.buttonlock = value
						Skylark.Bar:ForAll("ForAll", "SetAttribute", "buttonlock", value)
					end,
				},
				kb = {
					order = order(),
					type = "execute",
					name = L["按键绑定"],
					desc = L["设定按钮快捷键"],
					func = function()
						LibStub("LibKeyBound-1.0"):Toggle()
					end,
				},
				bars = {
					type = "group",
					order = order(),
					name = L["额外动作条"],
					args = {
						options = {
							type = "group",
							name = "",
							order = order(),
							guiInline = true,
							args = {
								selfcastmodifier = {
									type = "toggle",
									order = order(),
									name = L["自我施法"],
									desc = L["启用/关闭自我施法功能"],
									get = getFunc,
									set = function(info, value)
										Skylark.db.profile.selfcastmodifier = value
										Skylark.Bar:ForAll("UpdateSelfCast")
									end
								},
								setselfcastmod = {
									order = order(),
									type = "select",
									name = AUTO_SELF_CAST_KEY_TEXT,
									desc = L["设置自我施法"],
									values = {
										NONE = NONE,
										ALT = ALT_KEY,
										SHIFT = SHIFT_KEY,
										CTRL = CTRL_KEY
									},
									get = function(info) return GetModifiedClick("SELFCAST") end,
									set = function(info, value)
										SetModifiedClick("SELFCAST", value); 
										SaveBindings(GetCurrentBindingSet() or 1)
									end
								},
								selfcast_nl = {
									order = order(),
									type = "description",
									name = "",
								},
								focuscastmodifier = {
									order = order(),
									name = L["焦点施法"],
									desc = L["启用/关闭焦点施法"],
									type = "toggle",
									get = getFunc,
									set = function(info, value)
										Skylark.db.profile.focuscastmodifier = value
										Skylark.Bar:ForAll("UpdateSelfCast")
									end
								},
								focuscastmod = {
									order = order(),
									type = "select",
									name = FOCUS_CAST_KEY_TEXT,
									desc = L["设置焦点施法快捷键"],
									values = {
										NONE = NONE,
										ALT = ALT_KEY,
										SHIFT = SHIFT_KEY,
										CTRL = CTRL_KEY
									},
									get = function(info) return GetModifiedClick("FOCUSCAST") end,
									set = function(info, value)
										SetModifiedClick("FOCUSCAST", value); 
										SaveBindings(GetCurrentBindingSet() or 1)
									end
								},
								focuscast_nl = {
									order = order(),
									type = "description",
									name = "",
								},
								range = {
									order = order(),
									type = "select",
									name = L["射程指示"],
									desc = L["设置射程指示样式"],
									style = "dropdown",
									values = {
										none = L["不显示"],
										button = L["按钮模式"],
										hotkey = L["快捷键模式"],
									},
									get = function(info)
										return Skylark.db.profile.outofrange
									end,
									set = function(info, value)
										Skylark.db.profile.outofrange = value
										Skylark.Bar:ForAll("ApplyConfig");
									end,
								},
								colors = {
									order = order(),
									type = "group",
									guiInline = true,
									name = L["颜色设定"],
									get = function(info)
										local color = Skylark.db.profile.colors[info[#info]];
										return color.r, color.g, color.b
									end,
									set = function(info, r, g, b)
										local color = Skylark.db.profile.colors[info[#info]];
										color.r, color.g, color.b = r, g, b
										Skylark.Bar:ForAll("ApplyConfig");
									end,
									args = {
										range = {
											order = order(),
											type = "color",
											name = L["射程颜色"],
											desc = L["设定射程显示的颜色"],
										},
										mana = {
											order = order(),
											type = "color",
											name = L["法力不足颜色"],
											desc = L["设定法力不足时的颜色"],
										},
									},
								},
								tooltip = {
									type = "select",
									order = order(),
									name = L["鼠标提示"],
									desc = L["设定鼠标提示"],
									values = {
										["disabled"] = L["禁用"],
										["nocombat"] = L["战斗中禁用"],
										["enabled"] = L["启用"],
									},
									get = function() return Skylark.db.profile.tooltip end,
									set = function(_, val)
										Skylark.db.profile.tooltip = val
									end
								},
							},
						},
					},
				},
			},
		}
		Skylark.options.plugins.profiles = { profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(Skylark.db)};

		for k, v in Skylark:IterateModules() do
			if v.SetupOptions then
				v:SetupOptions();
			end
		end
	end
	return Skylark.options
end

function Skylark:RegisterBarOptions(id, tbl)
	self.options.args.bars.args[id] = tbl
end

function Skylark:SetupOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Skylark", getOptions)

	self:RegisterChatCommand("skylark", function() LibStub("AceConfigDialog-3.0"):Open("Skylark") end)
end
