--------------------------------------------------
--  背包状态及一键打开设置界面
--  $Revision: 2930 $
--  $Date: 2010-03-24 15:53:11 +0800 (三, 2010-03-24) $
--  作者: 月色狼影@cwdg
--------------------------------------------------

--[=[
local BagStatus = LibStub("AceAddon-3.0"):GetAddon("BagStatus");
local revision = tonumber(("$Revision: 2930 $"):match("%d+"));
if BagStatus.revision < revision then
	BagStatus.revision = revision
end

local L = wsLocale:GetLocale("BagStatus")

local options
local _order = 0

local function order()
	_order = _order + 1
	return _order
end

local function getOptions()
	local db = BagStatus.db.profile
	local self = BagStatus
	if not options then
		options = {
			type = "group",
			name = L["背包状态管理"],
			args = {
				bagStausBar = {
					type = "toggle",
					name = L["显示背包状态"],
					desc = L["在每个背包上显示该背包的使用率"],
					order = order(),
					get = function() return db.showBagStatus end,
					set = function(_, v) 
						db.showBagStatus = v
						self:OnProfileChanged()
					end
				},
				setalpha = {
					type = "range",
					name = L["设置背包状态透明度"],
					desc = L["设置每个背包状态条的透明度"],
					order = order(),
					min = 0,
					max = 100,
					step = 1,
					width = "full",
					get = function() return db.BagStatusAlpha*100 end,
					set = function(_, v)
						db.BagStatusAlpha = v/100,
						self:OnProfileChanged()
					end
				},
				bettercount = {
					type = "toggle",
					name = L["计数修正"],
					desc = L["大于999用#.#K显示"],
					order = order(),
					width = "full",
					get = function() return db.CountAbb end,
					set = function(_, v)
						db.CountAbb = v
						self:OnProfileChanged()
					end
				},
			},
		}
	end
	return options
end
]=]
function BagStatus:SetupOptions()
	--LibStub("AceConfig-3.0"):RegisterOptionsTable("BagStatusOptions", getOptions)
end
