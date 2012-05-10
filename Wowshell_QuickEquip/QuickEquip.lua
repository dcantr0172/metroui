----------------------------------------
-- QuickEquip 一键换装3
-- $Revision: 2949 $
-- $Date: 2010-03-26 11:46:53 +0800 (Fri, 26 Mar 2010) $
-- Author: 月色狼影@cwdg
-- 针对WOW3.1的变更进行了较大的改动
----------------------------------------
QuickEquip = LibStub("AceAddon-3.0"):NewAddon("QuickEquip", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0")
local revision = tonumber(("$Revision: 2949 $"):match("%d+"));
QuickEquip.revision = revision
local L = wsLocale:GetLocale("QuickEquip")
local db;

--equipment API
local GetNumEquipmentSets = GetNumEquipmentSets--获取套装数量
local GetEquipmentSetInfo = GetEquipmentSetInfo--获取装备信息
local GameTooltip = GameTooltip
local equipSets = {};--cache system equipment info

local defaults = {
	profile = {
		enabled = true,
		showBar = true,
		enabledEE = false,--eventequip
		equipbar = {
			posX = 155, -- 120
			posY = 0,
			showNum = 4,
		},
	},
}

function QuickEquip:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("QuickEquipDB", defaults, "Default");
	db = self.db.profile

	self:SetEnabledState(db.enabled);
	--self:SetupOptions();
	--self:CreateStrip();

	--bindings
	BINDING_HEADER_WOWSHELL_QUICKEQUIP = L["一键换装"]
	--BINDING_NAME_WSQUICKEQUIP_QUICKSTRIP = "一键脱光"
	BINDING_NAME_WSQUICKEQUIP_EQUIP1 = L["套装"]..1
	BINDING_NAME_WSQUICKEQUIP_EQUIP2 = L["套装"]..2
	BINDING_NAME_WSQUICKEQUIP_EQUIP3 = L["套装"]..3
	BINDING_NAME_WSQUICKEQUIP_EQUIP4 = L["套装"]..4
	BINDING_NAME_WSQUICKEQUIP_EQUIP5 = L["套装"]..5
	BINDING_NAME_WSQUICKEQUIP_EQUIP6 = L["套装"]..6
	BINDING_NAME_WSQUICKEQUIP_EQUIP7 = L["套装"]..7
	BINDING_NAME_WSQUICKEQUIP_EQUIP8 = L["套装"]..8
end

function QuickEquip:OnEnable()
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateEquipSets");
	self:RegisterEvent("EQUIPMENT_SETS_CHANGED", "UpdateEquipSets");
	self:SecureHook("EquipmentManager_EquipSet", "Blz_EquipmentManager_EquipSet")
	self:RegisterEvent("CVAR_UPDATE");
	self:UpdateShow();
	--self:EnableEventEquip();

	--enable cvar
	--SetCVar("equipmentManager", 1);
end

function QuickEquip:OnDisable()
	self:UnregisterAllEvents();
	QuickEquip_Bar:Hide()
end

function QuickEquip:CreateStrip()
	for i=1, GetNumEquipmentSets() do
		local name, icon = GetEquipmentSetInfo(i);
		if name ~= "一键脱光" then
			if GetNumEquipmentSets() >= MAX_EQUIPMENT_SETS_PER_PLAYER then
				return
			end
			local icon, iconIndex = GetEquipmentSetIconInfo(836);
			
			--SaveEquipmentSet("一键脱光", iconIndex);
		end
		return;
	end
end

function QuickEquip:UpdateEquipSets(event)
	wipe(equipSets);
	for i=1, GetNumEquipmentSets() do
		local name, icon = GetEquipmentSetInfo(i);
		equipSets[i] = {["setname"]= name, ["icon"] = icon};
	end

	if db.currentset then
		self:SetButtonOnClick(db.currentset, true)
	end
	self:UpdateShow();
	QuickEquip.equipSets = equipSets
end

function QuickEquip:CVAR_UPDATE(event, name, value)
	if name == "USE_EQUIPMENT_MANAGER" then
		self:UpdateShow();
	end
end

function QuickEquip:GetSetID(setname)
	if not setname then return end
	for id, setinfo in pairs(equipSets) do
		for k, t in pairs(setinfo) do
			if k == "setname" then
				if t == setname then
					return id
				end
			end
		end
	end
	return false
end

function QuickEquip:GetSetNameByID(setindex)
	if not setindex then return end
	for id, setinfo in pairs(equipSets) do
		if id == setindex then
			return setinfo.setname
		end
	end
end

--监视
function QuickEquip:Blz_EquipmentManager_EquipSet(setname)
	local setid = self:GetSetID(setname)
	--save current set
	db.currentset = setid
	self:SetButtonOnClick(setid, true)
end

function QuickEquip:SwitchEquip(name)
	EquipmentManager_EquipSet(name)
end

function QuickEquip:ShowTooltip(self, id)
	if id > GetNumEquipmentSets() then return end

	--GameTooltip_SetDefaultAnchor(GameTooltip, self);
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	GameTooltip:AddLine(L["一键换装"]..": ");
	GameTooltip:AddLine(equipSets[id].setname);
	GameTooltip:AddTexture(equipSets[id].icon)
	GameTooltip:Show();
end

function QuickEquip:SetButtonOnClick(id, switchequip)
	if CursorHasItem() or UnitIsDeadOrGhost("player") then return end
	for i=1, 8 do
		getglobal("QuickEquip_BarSetButton"..i):SetChecked(nil);
	end
	
	if id > GetNumEquipmentSets() then return end
	local setname = equipSets[id].setname;

	if (id == 1) then
		QuickEquip_BarSetButton1:SetChecked(1)
	elseif (id == 2) then
		QuickEquip_BarSetButton2:SetChecked(1)
	elseif (id == 3) then
		QuickEquip_BarSetButton3:SetChecked(1)
	elseif (id == 4) then
		QuickEquip_BarSetButton4:SetChecked(1)
	elseif (id == 5) then
		QuickEquip_BarSetButton5:SetChecked(1)
	elseif (id == 6) then
		QuickEquip_BarSetButton6:SetChecked(1)
	elseif (id == 7) then
		QuickEquip_BarSetButton7:SetChecked(1)
	elseif (id == 8) then
		QuickEquip_BarSetButton8:SetChecked(1)
	end

	if not switchequip then
		self:SwitchEquip(setname)
	end
end

function QuickEquip:RegisterFrame(frame)
    self.wsuf_button = frame
    self:UpdateShow()
end

function QuickEquip:UpdateShow()--equip bar
	--local targetFrame = self.wsuf_button or PlayerFrame
	if(WSUF and wsUnitFrame_Player and (self.wsuf_button~=wsUnitFrame_Player)) then
		self.wsuf_button = wsUnitFrame_Player
	end

	if db.showBar then
		QuickEquip_Bar:Show()
	else
		QuickEquip_Bar:Hide()
		return
	end

	if(self.wsuf_button) then
		if IsAddOnLoaded("Wowshell_UFShell") then
			QuickEquip_Bar:ClearAllPoints()
			QuickEquip_Bar:SetParent(self.wsuf_button)
			QuickEquip_Bar:SetPoint('TOPLEFT',self.wsuf_button,'TOPLEFT',85,25)
		else
			QuickEquip_Bar:ClearAllPoints();
			QuickEquip_Bar:SetParent(self.wsuf_button)
			QuickEquip_Bar:SetPoint('TOPLEFT', self.wsuf_button, 'TOPLEFT', 155, 0)
		end
	else
		QuickEquip_Bar:ClearAllPoints()
		QuickEquip_Bar:SetParent('PlayerFrame')
		QuickEquip_Bar:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 155, 0)
	end

	--update show
	local showbutton
	local savedset = GetNumEquipmentSets()
	if savedset < self.db.profile.equipbar.showNum then
		showbutton = savedset
	else
		showbutton = self.db.profile.equipbar.showNum
	end

	for i = 1, self.db.profile.equipbar.showNum do
		getglobal("QuickEquip_BarSetButton"..i):Show();
	end

	for i = showbutton + 1, 8 do
		getglobal("QuickEquip_BarSetButton"..i):Hide();
	end
end

local _order = 0
function order()
	_order = _order + 1
	return _order
end
local options
function QuickEquip:CreateOptionPanel()
	if not options then
		options = {
			type = "group",
			name = L["一键换装设置面板"],
			args = {
				blah = {
					type = 'description',
					fontSize = 'medium',
					order = order()+99999,
					name = [[
					結合系統自帶的換裝功能做的增強一鍵換裝，設置方便，使用簡單。不解釋。
					]],
				},
				enabled = {
					type = "toggle",
					order = order(),
					name = L["启用"]..L["一键换装"],
					desc = L["启用/禁用一键换装插件"],
					get = function() return db.enabled end,
					set = function(_, v)
						db.enabled = v
						if v then
							QuickEquip:Enable()
						else
							QuickEquip:Disable()
						end
					end
				},
				--[[enabledee = {
					type = "toggle",
					order = order(),
					name = L["启用事件换装"],
					desc = L["启用/禁用事件换装"],
					disabled = function() return not db.enabled end,
					get = function() return db.enabledEE end,
					set = function(_, v)
						db.enabledEE = v
						local ee = self:GetModule("EventEquip");
						if v then
							ee:Enable()
						else
							ee:Disable()
						end
					end
				},]]
				equipBar = {
					type = "toggle",
					order = order(),
					name = L["启用快速换装条"],
					desc = L["在玩家头像上方显示快速换装条"],
					width = "full",
					disabled = function() return not db.enabled end,
					get = function() return db.showBar end,
					set = function(_, v)
						db.showBar = v
						self:UpdateShow()
					end,
				},
--				setPosX = {
--					type = "range",
--					order =order(),
--					disabled = function() return not db.enabled end,
--					name = L["设置换装条 X"],
--					desc = L["设置换装条X轴显示位置"],
--					min = 30,
--					max = 220,
--					step = 1,
--					get = function() return db.equipbar.posX end,
--					set = function(_, v)
--						db.equipbar.posX = v
--						self:UpdateShow()
--					end,
--				},
--				setPosY = {
--					type = "range",
--					order= order(),
--					disabled = function() return not db.enabled end,
--					name = L["设置换装条Y"],
--					desc = L["设置换装条Y轴显示位置"],
--					min = -100,
--					max = 5,
--					step = 1,
--					get = function() return db.equipbar.posY end,
--					set = function(_, v)
--						db.equipbar.posY = v
--						self:UpdateShow()
--					end,
--				},
				showNum = {
					type = "range",
					order= order(),
					disabled = function() return not db.enabled end,
					name = L["显示换装按钮"],
					desc = L["设置换装条显示按钮个数"],
					min = 1,
					max = 8,
					step = 1,
					get = function() return db.equipbar.showNum end,
					set = function(_, v)
						db.equipbar.showNum = v
						self:UpdateShow()
					end,
				},
			},
		}
	end
	return options
end

