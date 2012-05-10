local CI = LibStub("AceAddon-3.0"):GetAddon("CombatInfo")
local L = wsLocale:GetLocale("CombatInfo")
local SM = LibStub("LibSharedMedia-3.0");
local fonts = SM:List("font");

local outlines = {[""] = L["普通"], ["OUTLINE"] = L["粗体"], ["THICKOUTLINE"] = L["超粗体"]}


local options, moduleOptions = nil, {}

local function getConfig(info)
	return CombatInfo.db.profile[info[#info]]
end

local function setConfig(info, v)
	CombatInfo.db.profile[info[#info]] = v
	CombatInfo:OnProfileChanged()
end

local function getOptions()
	local db = CombatInfo.db
	if not options then
		options = {
			type = "group",
			name = L["战斗信息"],
			desc = L["施法条增强, 显示敌对施法信息."],
			args = {
				enabled = {
					type = "toggle",
					order = 0,
					name = L["启用"],
					desc = L["启用/禁用此插件"],
					get = getConfig,
					set = function(_, v)
						db.profile.enabled = v
						if v then
							CombatInfo:Enable()
						else
							CombatInfo:Disable()
						end
					end
				},
				spellinfo = {
					type = "group",
					name = L["法术信息"],
					desc = L["设置敌对玩家以及怪物法术预警"],
					order = 1,
					disabled = function() return not db.profile.enabled end,
					args = {
						showCombat = {
							name = L["战斗提示信息"],
							desc = L["当你进入或者离开战斗,提示信息警报"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 1,
						},
						iheader = {
							type = "header",
							name = L["法术预警设置"],
							order = 2,
						},
						showPlayer = {
							name = L["敌对玩家施法"],
							desc = L["显示敌对玩家施法警报"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 3,
						},
						showMob = {
							name = L["怪物施法"],
							desc = L["显示怪物施法警报"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 4,
						},
						showMobbuff = {
							name = L["怪物增益"],
							desc = L["当Npc受到增益发出警报"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 5,
						},
						showPlayerbuff = {
							name = L["敌对玩家增益"],
							desc = L["当敌对玩家受到增益发出警报"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 6,
						},
						otherInfo = {
							name = L["其他信息"],
							desc = L["针对一些特殊事件提醒, 比如抓捕以太鳐等"],
							type = "toggle",
							get = getConfig,
							set = setConfig,
							order = 7,
						},
						iheader2 = {
							name = L["详细设置"],
							type = "header",
							order = 8,
						},
						zoneAler = {
							name = L["在友善或安全区禁用"],
							desc = L["设置法术预警是否在友善或者安全区使用"],
							type = "toggle",
							order = 9,
							get = getConfig,
							set = setConfig,
						},
						inCombat = {
							name = L["在非战斗时禁用"],
							desc = L["设置法术预警是否在非战斗时也显示"],
							type = "toggle",
							order = 10,
							get = getConfig,
							set = setConfig,
						},
					},
				},
				ShowInfo = {
					type = "group",
					name = L["显示设置"],
					desc = L["设置提示信息样式, 显示位置"],
					order = 2,
					disabled = function() return not db.profile.enabled end,
					args = {
						fontsize = {
							type = "range",
							name = L["字体大小"],
							desc = L["设置字体尺寸"],
							order = 1,
							step = 1,
							bigStep = 1,
							min = 16,
							max = 25,
							get = function(info) return db.profile.Showinfo.fontsize end,
							set = function(info, v) db.profile.Showinfo.fontsize = v 
								CombatInfo:OnProfileChanged("test")
							end,
						},
						framefade = {
							type = "range",
							name = L["消失时间"],
							desc = L["设置消失时间的长短"],
							step = 0.1,
							bigStep = 0.1,
							min = 0.2,
							max = 1.5,
							get = function(info) return db.profile.Showinfo.framefade end,
							set = function(info, v) db.profile.Showinfo.framefade = v
								CombatInfo:OnProfileChanged("test")
							end,
							order = 2,
						},
						fontstyle = {
							type = "select",
							name = L["字体样式"],
							desc = L["设置字体样式"],
							values = outlines,
							get = function(info) return db.profile.Showinfo.fontstyle end,
							set = function(info, v) db.profile.Showinfo.fontstyle = v
								CombatInfo:OnProfileChanged("test")
							end,
							order = 3,
						},
						fonttype = {
							type = "select",
							name = L["字体"],
							desc = L["设置字体"],
							dialogControl = "LSM30_Font",
							values = AceGUIWidgetLSMlists.font,
							get = function(info) return db.profile.Showinfo.fonttype end,
							set = function(info, v) 
								db.profile.Showinfo.fonttype = v
								CombatInfo:OnProfileChanged("test")
							end,
							order = 4,
						},
						testFrame = {
							type = "execute",
							name = L["测试预览"],
							desc = L["点击测试预览效果"],
							func = function() CombatInfo.ShowSpellAlertFrame() end,
						},
					},
				},
			},
		}
		--[[for k,v in pairs(moduleOptions) do
			options.args[k] = (type(v) == "function") and v() or v
		end]]
	end
	
	return options;
end

function CI:SetupOptions()
    local opts = getOptions()

	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("CombatInfo", opts)
	self:RegisterModuleOptions("Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db), "Profiles")

end

function CI:RegisterModuleOptions(name, optTbl, displayName)
    if(options) then
        options.args[name] = (type(optTbl) == 'function') and optTbl() or optTbl
    else
        moduleOptions[name] = optTbl;
    end
end
