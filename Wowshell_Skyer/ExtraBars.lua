--[[
 --新版的额外动作条为玩家提供了10条动作条
]]
local ExtraBars = Skylark:NewModule("ExtraBars", "AceEvent-3.0");
local ActionBar, ActionBar_MT
Skylark.MAX_NUM_EXTRABARS = 10
local L = wsLocale:GetLocale("Skylark");

local abdefaults = {
	['**'] = Skylark:Merge({
		enabled = false,
		buttons = 12,
		showgrid = true,
	}, Skylark.ActionBar.defaults),
}

local defaults = {
	profile = {
		extrabars = abdefaults,
	}
}

function ExtraBars:OnInitialize()
	self.db = Skylark.db:RegisterNamespace("ExtraBars", defaults);
	
	--[[if tonumber(Skylark.db.profile.version) == nil and self.db.profile.extrabars[1] ~= nil then
		if self.db.profile.extrabars[1].enabled then
			return
		end
		self.db.profile.extrabars[1].enabled = true
		Skylark.db.profile.version = 2
	end]]

	ActionBar = Skylark.ActionBar.prototype
	ActionBar_MT = {__index = ActionBar}
end

local first = true
function ExtraBars:OnEnable()
	if first then
		self.extrabars = {}
		for i=1, Skylark.MAX_NUM_EXTRABARS do
			local config = self.db.profile.extrabars[i]
			if config.enabled then
				self.extrabars[i] = self:Create(i, config)
			else
				self:CreateBarOption(i, self.disabledoptions)
			end
		end
		first = nil
	end
end

function ExtraBars:ApplyConfig()
	for i=1, Skylark.MAX_NUM_EXTRABARS do
		local config = self.db.profile.extrabars[i]
		if self.extrabars[i] then
			self.extrabars[i].cfg = config
		end
		if config.enabled then
			self:EnableBar(i)
		else
			self:DisableBar(i)
		end
	end
end

local function CreateIndicator(parent, id)
	local f = CreateFrame("Button", ("LarkBarIndicator%d"):format(id), parent);
	f:Hide();
	f.id = id;
	f:SetWidth(50);
	f:SetHeight(14);

	local left, mid, right, text
	left = f:CreateTexture(nil, "BACKGROUND");
	left:SetTexture([[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]);
	left:SetWidth(24);
	left:SetHeight(16);
	left:SetPoint("TOPLEFT", f, "TOPLEFT", 0, 0);
	left:SetTexCoord(0, 0.1875, 0, 1);

	right = f:CreateTexture(nil, "BACKGROUND");
	right:SetTexture([[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]);
	right:SetWidth(24);
	right:SetHeight(16);
	right:SetPoint("TOPRIGHT", f, "TOPRIGHT", 0, 0);
	right:SetTexCoord(0.53125, 0.71875, 0, 1);
	
	mid = f:CreateTexture(nil, "BACKGROUND");
	mid:SetTexture([[Interface\CharacterFrame\UI-CharacterFrame-GroupIndicator]]);
	mid:SetWidth(0)
	mid:SetHeight(16)
	mid:SetPoint("LEFT", left, "RIGHT", 0, 0);
	mid:SetPoint("RIGHT", right, "LEFT", 0, 0);
	mid:SetTexCoord(0.1875, 0.53125, 0 , 1);

	text = f:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall");
	text:SetPoint("LEFT", f, "LEFT", 20, -2);

	text:SetText(id)
	
	left:SetAlpha(0.3)
	right:SetAlpha(0.3)
	mid:SetAlpha(0.3)
	return f
end

function ExtraBars:Create(id, config)
	local id = tostring(id)
	local bar = setmetatable(Skylark.ActionBar:Create(id, config, (L["额外动作条"].."%s"):format(id)), ActionBar_MT);
	bar.module = self

	--set Indicator
	--local cator = CreateIndicator(bar, id);
	--cator:SetPoint("TOP", bar, "TOP", 21, 13);
	--cator:Show();

	self:CreateBarOption(id)

	bar:ApplyConfig();
	return bar
end

function ExtraBars:DisableBar(id)
	local id = tostring(id)
	local bar = self.extrabars[tonumber(id)]
	if not bar then return end
	bar.cfg.enabled = false;
	bar:Disable()
	self:CreateBarOption(id, self.disabledoptions)
end

function ExtraBars:EnableBar(id)
	id = tonumber(id)
	local bar = self.extrabars[id]
	local config = self.db.profile.extrabars[id]
	config.enabled = true
	if not bar then
		bar = self:Create(id, config)
		self.extrabars[id] = bar
	else
		bar.disabled = nil
		self:CreateBarOption(id);
		bar:ApplyConfig(config);

		bar:Show()
	end
	
	if not Skylark.Locked then
		bar:Unlock()
	end
end

function ExtraBars:GetAll()
	return pairs(self.extrabars)
end

function ExtraBars:ForAll(method, ...)
	for _, bar in self:GetAll() do
		local func = bar[method];
		if func then
			func(bar, ...)
		end
	end
end

function ExtraBars:ForAllButtons(...)
	self:ForAll("ForAll", ...)
end

---------------------
--for option
---------------------
function ExtraBars:SetupOptions()
	if not self.options then
		self.options = {}
	end

	self.disabledoptions = {
		genernal = {
			type = "group",
			name = L["综合设定"],
			cmdInline = true,
			order = 1,
			args = {
				enabled = {
					type = "toggle",
					name = L["启用"],
					desc = L["启用/禁用当前额外动作条"],
					get = function() return false end,
					set = function(info, value)
						if value then
							ExtraBars:EnableBar(info[2])
						end
					end
				}
			}
		}
	}

	for i = 1, 10 do
		local cfg = self.db.profile.extrabars[i];
		if cfg.enabled then
			self:CreateBarOption(i)
		else
			self:CreateBarOption(i, self.disabledoptions)
		end
	end
end

local _order = 0
local function order()
	_order = _order + 1
	return _order
end

local function getBar(id)
	local bar = ExtraBars.extrabars[tonumber(id)]
	return bar
end

local function getOpt(info, option, ...)
	local bar = getBar(info[2]);
	return bar[option](bar, ...)
end

local function setOpt(info, option, ...)
	local bar = getBar(info[2]);
	bar[option](bar, ...)
end

function ExtraBars:GetOptionsTable()
	--info: entery1 entery2, entery3 entery4
	local otbl = {
		genernal = {
			type = "group",
			cmdInline = true,
			name = L["综合设定"],
			order = order(),
			args = {
				enabled = {
					order = order(),
					type = "toggle",
					name = L["启用"],
					desc = L["启用/禁用当前额外动作条"],
					get = function(info, ...)
						return getOpt(info, "GetEnabled", ...)
					end,
					set = function(info, value)
						setOpt(info, "SetEnabled", value)
					end
				},
				hhhhhhhh = {
					order = order(),
					type = "header",
					name = L["额外动作条样式设定"],
				},
				alpha = {
					order = order(),
					name = L["透明度"],
					desc = L["设定动作条的透明度"],
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					get = function(info, ...)
						return getOpt(info, "GetConfigAlpha", ...)
					end,
					set = function(info, value)
						setOpt(info, "SetConfigAlpha", value)
					end
				},
				scale = {
					order = order(),
					name = L["缩放比例"],
					desc = L["调整动作条缩放比例"],
					type = "range",
					min = 0.1,
					max = 2,
					step = 0.05,
					get = function(info, ...)
						return getOpt(info, "GetConfigScale", ...)
					end,
					set = function(info, value)
						setOpt(info, "SetConfigScale", value)
					end,
				},
				padding = {
					order = order(),
					name = L["间距"],
					desc = L["调整动作条间距"],
					type = "range",
					min = -10,
					max = 20,
					step = 1,
					get = function(info, ...)
						return getOpt(info, "GetPadding", ...)
					end,
					set = function(info, value)
						setOpt(info, "SetPadding", value)
					end
				},
				rows = {
					order = order(),
					name = L["每行按钮数量"],
					desc = L["定义每行按钮的现实数量"],
					type = "range",
					min = 1,
					max = 12,
					step = 1,
					get = function(info, ...)
						return getOpt(info, "GetRows", ...)
					end,
					set = function(info, value)
						setOpt(info, "SetRows", value)
					end
				},
				numbuttons = {
					order = order(),
					name = L["按钮数量"],
					desc = L["设定按钮显示数量"],
					type = "range",
					min = 1,
					max = 12,
					step = 1,
					get = function(info, ...)
						return getOpt(info, "GetButtons", ...)
					end,
					set = function(info,value)
						setOpt(info, "SetButtons", value)
					end
				},
				grid = {
					order = order(),
					name = L["显示/隐藏空格"],
					desc = L["显示/隐藏按钮空格"],
					type = "toggle",
					get = function(info, ...)
						return getOpt(info, "GetGrid", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetGrid", ...)
					end
				},
				vgrowth = {
					order = order(),
					name = L["垂直增长"],
					desc = L["动作条垂直增长的方向"],
					type = "select",
					values = {
						UP = L["向上"],
						DOWN = L["向下"]
					},
					get = function(info, ...)
						return getOpt(info, "GetVGrowth", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetVGrowth", ...)
					end
				},
				hgrowth = {
					order = order(),
					name = L["水平增长"],
					desc = L["动作条水平增长的方向"],
					type = "select",
					values = {
						LEFT = L["向左"],
						RIGHT = L["向右"]
					},
					get = function(info, ...)
						return getOpt(info, "GetHGrowth", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetHGrowth", ...)
					end
				},

				--样式
				macrotext = {
					order = order(),
					name = L["隐藏/显示宏名称"],
					desc = L["隐藏/隐藏动作条按钮的宏名称"],
					type = "toggle",
					get = function(info, ...)
						return getOpt(info, "GetHideMacroText", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetHideMacroText", ...)
					end,
				},
				hotkey = {
					order = order(),
					name = L["隐藏/显示快键"],
					desc = L["隐藏/隐藏动作条按钮的快键文字"],
					type = "toggle",
					get = function(info, ...)
						return getOpt(info, "GetHideHotKey", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetHideHotKey", ...)
					end
				},
			},
		},
		advanced = {
			type = "group",
			cmdInline = true,
			name = L["高级设定"],
			order = order(),
			args = {
				fadeout = {
					order = order(),
					type = "toggle",
					name = L["启用渐隐"],
					desc = L["开启淡入淡出模式"],
					get = function(info, ...)
						return getOpt(info, "GetFadeOut", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetFadeOut", ...)
					end,
					width = "full",
				},
				fadeoutalpha = {
					order = order(),
					type = "range",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					name = L["淡出透明度"],
					desc = L["设定淡出透明度"],
					get = function(info, ...)
						return getOpt(info, "GetFadeOutAlpha", ...)
					end,
					set = function(info, ...)
						setOpt(info, "SetFadeOutAlpha", ...)
					end,
				},
				fadeoutdelay = {
					order = order(),
					type = "range",
					min = 0,
					max = 1,
					step = 0.01,
					name = L["淡出延迟"],
					desc = L["设定淡出延迟时间"],
					get = function(info, ...)
						return getOpt(info, "GetFadeOutDelay",...)
					end,
					set = function(info, ...)
						setOpt(info, "SetFadeOutDelay", ...)
					end
				},
				hidecondition = {
					order = order(),
					type = "group",
					name = L["设定隐藏条件"],
					guiInline = true,
					get = function(info, ...)
						local bar = getBar(info[2]);
						return bar["GetVisibilityOption"](bar, info[#info], ...)
					end,
					set = function(info, ...)
						local bar = getBar(info[2]);
						bar["SetVisibilityOption"](bar, info[#info], ...)
					end,
					args = {
						always = {
							type = "toggle",
							order = order(),
							name = L["总是隐藏"],
						},
						vehicle = {
							type = "toggle",
							order = order(),
							name = L["有载具时隐藏"],
						},
						pet = {
							type = "toggle",
							order = order(),
							name = L["有宠物时隐藏"],
						},
						nopet = {
							type = "toggle",
							order = order(),
							name = L["无宠物时隐藏"],
						},
						combat = {
							type = "toggle",
							order = order(),
							name = L["战斗时隐藏"],
						},
						nocombat = {
							type = "toggle",
							order = order(),
							name = L["非战斗时隐藏"],
						},
						mounted = {
							type = "toggle",
							order = order(),
							name = L["骑马时隐藏"],
						},
					},
				},
			},
		},
	}

	return otbl
end

function ExtraBars:CreateBarOption(id, options)
	if not self.options then return end	
	if not options then
		options = self:GetOptionsTable()
	end

	id = tostring(id)
	if not self.options[id] then
		self.options[id] = {
			order = 10 + tonumber(id),
			type = "group",
			name = (L["额外动作条"].."%s"):format(id),
			desc = (L["配置额外动作条%s"]):format(id),
			childGroups = "tab",
		}
	end
	self.options[id].args = options
	Skylark:RegisterBarOptions(id, self.options[id])
end