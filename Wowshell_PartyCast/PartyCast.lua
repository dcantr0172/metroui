local MAX_PARTY_MEMBER = 4
local PartyCast = LibStub("AceAddon-3.0"):NewAddon("PartyCast", "AceEvent-3.0", "AceConsole-3.0", "AceHook-3.0");
_G.PartyCast = PartyCast
local revision = tonumber(("$Revision: 3008 $"):match("%d+"));
PartyCast.revision = revision;
local L = wsLocale:GetLocale("PartyCast");
local GetCursorInfo = GetCursorInfo
local default
local buttons = {}
local queque = {};
local tinsert = table.insert
local SPELL_TYPE = {
	["spell"] = L["法术"],
	["macro"] = L["宏"]
}
local getglobal = function(name)
    return name and _G[name]
end
--[[
spellList = {
	[1] = {
		name = 
		rank
		icon
		type = spell or macro
	}
}

]]

local default = {
	profile = {
		enable = false,
		locked = false,
		hideGrid = false,
		hideBuff = true,
		max_castSpell = 8,
		scale = 1.0,
	},
	char = {--save player spell
		spellList = {
			["*"] = {},
		},
	},
}

do
    local _, class = UnitClass"player"
    local classes = {
        SHAMAN = true,
        DRUID = true,
        PRIEST = true,
        PALADIN = true,
    }
    if(classes[class]) then
        default.profile.enable = true
    end
end

function PartyCast:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("PartyCastDB", default, "Default");
	self:CreateCastSpellFrame();
end

function PartyCast:OnEnable()
	--进入游戏后加载db
	self:ToggleShowCastFrame()
	self:ToggleButtonGrid()
	--options
	local options
	options = {
		type = "group",
		name = L["队伍施法"],
		args = {
			enable = {
				type = "toggle",
				name = L["启用"]..L["队伍施法"],
				desc = L["启用队伍施放"],
				order = 1,
				get = function() return self.db.profile.enable end,
				set = function(_, v)
					self.db.profile.enable = v
					self:ToggleShowCastFrame()
				end
			},
			locked = {
				type = "toggle",
				name = L["锁定"],
				desc = L["锁定队伍施放按钮,禁止拖动"],
				order = 2,
				get = function() return self.db.profile.locked end,
				set = function(_, v)
					self.db.profile.locked = v
					self:UpdatePartyCastButtonPro();
				end
			},
			hidebuff = {
				type = "toggle",
				name = L["渐隐按钮"],
				desc = L["但目标有这个buff时, 经渐隐相对应的法术按钮"],
				order = 3,
				get = function() return self.db.profile.hideBuff end,
				set = function(_, v)
					self.db.profile.hideBuff = v;
					self:UNIT_AURA();
				end,
			},
			hidegrid = {
				type = "toggle",
				name = L["隐藏空按钮"],
				desc = L["隐藏没有法术的按钮"],
				order = 4,
				get = function() return self.db.profile.hideGrid end,
				set = function(_, v)
					self.db.profile.hideGrid = v
					self:ToggleButtonGrid()
				end
			},
			numButton = {
				type = "range",
				name = L["设定法术格数"],
				desc = L["设定队伍施法法术按钮数量, 需要重新加载!"],
				min = 4,
				max = 30,
				step = 2,
				get = function() return self.db.profile.max_castSpell end,
				set = function(_, v)
					self.db.profile.max_castSpell = v
				end,
			},
			scale = {
				type = "range",
				name = L["设定按钮尺寸"],
				desc = L["设定队伍施法按钮的大小"],
				min = 0.6,
				max = 2,
				step = 0.1,
				get = function() return self.db.profile.scale end,
				set = function(_, v)
					self.db.profile.scale = v
					self:UpdateAllButton()
				end
			}
		},
	}
	
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("PartyCast", options)
	
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED");

		--spell macro
	if not next (self.db.char.spellList) then return end
	local db = self.db.char.spellList
	for i = 1, self.db.profile.max_castSpell do
		if (db[i] and db[i].type == "spell" and db[i].name and db[i].icon) then
			for frameId = 1, MAX_PARTY_MEMBER do
				local button = getglobal("PartyCastFrame"..frameId.."Button"..i);
                if(button) then
                    SetItemButtonTexture(button, db[i].icon)
                    local targetUnit = "party"..frameId

                    button:SetAttribute("type", "spell")
                    --判断有无等级
                    --if (db[i].rank and db[i].rank ~= "") then
                    --	button:SetAttribute("spell", db[i].name.."("..db[i].rank..")");
                    --else
                        button:SetAttribute("spell", db[i].name)
                    --end

                    button:SetAttribute("unit", targetUnit)
                end
			end
		end

		if (db[i] and db[i].type == "macro" and db[i].name and db[i].icon) then
			for frameId = 1, MAX_PARTY_MEMBER do
				local button = getglobal("PartyCastFrame"..frameId.."Button"..i);
				SetItemButtonTexture(button, db[i].icon)
				local targetUnit = "party"..frameId

				button:SetAttribute("type", "macro");
				button:SetAttribute("macrotext", "/target "..targetUnit.."\n"..db[i].body)
			end
		end
	end
end

--create
--PartyCastFrame1Button1
--frameid.. buttonid
local function CreatePartyCastSpellButton(frameId, parent, id)
	local buttonName = "PartyCastFrame"..frameId.."Button"..id
	local button = CreateFrame("Button", buttonName, getglobal(parent), "PartyCastActionButtonTemplate");
	button:SetID(id);
	button:EnableMouse(true);
	return button
end

function PartyCast:PARTY_MEMBERS_CHANGED()
	if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
		self:CreateCastSpellFrame();
	end
end

function PartyCast:PLAYER_REGEN_ENABLED()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:CreateCastSpellFrame();
end

--party
function PartyCast:CreateCastSpellFrame()
	--if(not self.db.profile.enable) then return end
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED");
		return
	end
	local numButtons = self.db.profile.max_castSpell
	for partyID = 1, MAX_PARTY_MEMBER do
		--create frame
		local parent;
		if (WSUF) then
			--parent = _G["Wowshell_UnitFrame_PartyFrameUnitButton"..partyID]
			parent = WSUF and WSUF.Module.units and WSUF.Module.units.partyframes and WSUF.Module.units.partyframes[partyID]
		else
			parent = _G["PartyMemberFrame"..partyID]
		end

		-- create party cast frame
		local PartyCastFrame = _G["PartyCastFrame" .. partyID]
		if (parent and (not PartyCastFrame))  then
			PartyCastFrame = CreateFrame("Frame", "PartyCastFrame"..partyID, parent)--frame
			PartyCastFrame:SetID(partyID);
			PartyCastFrame:SetWidth(115)
			PartyCastFrame:SetHeight(37);
			PartyCastFrame:SetPoint("LEFT", parent, "RIGHT", 70, 8)
			for buttonId = 1, numButtons do
				--party, parent
				local castSpellButton = CreatePartyCastSpellButton(partyID, "PartyCastFrame"..partyID, buttonId)--button
				castSpellButton:SetScale(self.db.profile.scale)
				tinsert(buttons, castSpellButton);
				--排列
				if buttonId == 1 then
					getglobal("PartyCastFrame"..partyID.."Button1"):SetPoint("LEFT", "PartyCastFrame"..partyID, "TOPLEFT", 1, 0);
				elseif buttonId > 1 and buttonId <= (numButtons/2) then
					getglobal("PartyCastFrame"..partyID.."Button"..buttonId):SetPoint("LEFT", getglobal("PartyCastFrame"..partyID.."Button"..(buttonId - 1)) ,"RIGHT", 6, 0)
				elseif buttonId == (numButtons/2 + 1) then
					getglobal("PartyCastFrame"..partyID.."Button"..buttonId):SetPoint("TOPLEFT", getglobal("PartyCastFrame"..partyID.."Button1") ,"BOTTOMLEFT", 0, -6)
				else
					getglobal("PartyCastFrame"..partyID.."Button"..buttonId):SetPoint("LEFT", getglobal("PartyCastFrame"..partyID.."Button"..(buttonId - 1)) ,"RIGHT", 6, 0)
				end
			end
		end

		-- make sure it"s attach to the right place
		if(PartyCastFrame and (PartyCastFrame:GetParent() ~= parent)) then
			PartyCastFrame:SetParent(parent)
			PartyCastFrame:SetPoint("LEFT", parent, "RIGHT", 70, 8)
		end

		if (PartyCastFrame) then
			if (self.db.profile.enable) then
				PartyCastFrame:Show()
			else
				PartyCastFrame:Hide()
			end
		end
	end

	self:UpdatePartyCastButtonPro()
end

function PartyCast:ToggleShowCastFrame()
	if self.db.profile.enable then
		for id =1, 4 do
			local frame = getglobal("PartyCastFrame"..id);
			if frame then
				frame:Show();
			end
		end
	else
		for id =1, 4 do
			local frame = getglobal("PartyCastFrame"..id);
			if frame then
				frame:Hide()
			end
		end
	end
end

function PartyCast:AdjustPartyCastFrame()
	for frameId=1, MAX_PARTY_MEMBER do
		getglobal("PartyCastFrame"..frameId):SetPoint("LEFT", "PartyMemberFrame"..frameId, "RIGHT", 64, 14)
	end
end

function PartyCast:UNIT_AURA(event, unit)
	if self.db.profile.hideBuff then
		for id = 1, MAX_PARTY_MEMBER do
			if (("party"..id) == unit) then
				self:UpdateCastButton(id)
			end
		end
	end
end

--PartyCastFrame1Button1
function PartyCast:UpdatePartyCastButtonPro()
	local OnEnter, OnLeave, OnReceiveDrag
	local function OnEnter(self)
		local id = self:GetID()
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		if PartyCast.db.char.spellList[id] ~= nil then
			GameTooltip:SetText(L["队伍快捷施法按钮"]..id)
			--GameTooltip:AddDoubleLine(PartyCast.db.char.spellList[id].name, PartyCast.db.char.spellList[id].rank, 1, 1, 1, 1, 1,1);
			GameTooltip:AddLine(PartyCast.db.char.spellList[id].name);
			GameTooltip:AddLine(SPELL_TYPE[PartyCast.db.char.spellList[id].type])
		else
			--不存在
			GameTooltip:SetText(L["队伍快捷施法按钮"]..id);
			GameTooltip:AddLine(L["没有选择对应法术, 宏"], 0.11, 0.82, 0.6);
		end
		GameTooltip:Show()
	end

	local function OnLeave()
		GameTooltip:Hide()
	end

	--保存 spell, macro
	local function OnReceiveDrag(self)
		local db = PartyCast.db.char.spellList
		local buttonId = self:GetID()
		if GetCursorInfo() then
			if InCombatLockdown == "1" then return end
		--判断 macro , spell
			if GetCursorInfo() == "spell" then
				local _, spellIndex = GetCursorInfo()
				local spellName, spellRank = GetSpellBookItemName(spellIndex, BOOKTYPE_SPELL);
				local spellIcon = GetSpellTexture(spellIndex, BOOKTYPE_SPELL)
				--save spell
				db[buttonId] = {}
				db[buttonId].type = "spell"
				db[buttonId].name = spellName
				db[buttonId].rank = spellRank
				db[buttonId].icon = spellIcon

				for i = 1, MAX_PARTY_MEMBER, 1 do
					local button =  getglobal("PartyCastFrame"..i.."Button"..buttonId);
					SetItemButtonTexture(button, db[buttonId].icon)
					local targetUnit = "party"..i
					
					button:SetAttribute("type", "spell");
					--现在设置法术总是最高等级
					--if (db[buttonId].rank and db[buttonId].rank ~= "") then
					--	button:SetAttribute("spell", db[buttonId].name.."("..db[buttonId].rank..")");
					--else
						button:SetAttribute("spell", db[buttonId].name)
					--end
					button:SetAttribute("unit", targetUnit)
				end
				ResetCursor();
                ClearCursor()
			elseif GetCursorInfo() == "macro" then
				db[buttonId].type = "macro"
				local _, macroIndex = GetCursorInfo()
				local macroName, macroIcon, macroBody = GetMacroInfo(macroIndex);
				--save macro
				db[buttonId] = {}
				db[buttonId].type = "macro"
				db[buttonId].name = macroName
				db[buttonId].icon = macroIcon
				db[buttonId].body = macroBody

				for i = 1, MAX_PARTY_MEMBER, 1 do
					local button =  getglobal("PartyCastFrame"..i.."Button"..buttonId);
					SetItemButtonTexture(button, db[buttonId].icon)
					local targetUnit = "party"..i
					button:SetAttribute("type", "macro");
					button:SetAttribute("macrotext", "/target "..targetUnit.."\n"..db[i].body)

				end
				ResetCursor();
                ClearCursor()
			end
		end
	end

	local function OnDragStart(self)
		if PartyCast.db.profile.locked then return end
		if InCombatLockdown == "1" then return end
		local id = self:GetID()
		PartyCast.db.char.spellList[id] = nil
		for i = 1, MAX_PARTY_MEMBER do
			local button = getglobal("PartyCastFrame"..i.."Button"..id);
			SetItemButtonTexture(button, nil)
			--needtext
			button:SetAttribute("type", "spell");
			button:SetAttribute("spell", nil);
		end
	end
	
	for partyId = 1, MAX_PARTY_MEMBER do
		for spellButtonId = 1, self.db.profile.max_castSpell do
			local castButton = getglobal("PartyCastFrame"..partyId.."Button"..spellButtonId);
			if castButton then
				castButton:RegisterForClicks("LeftButtonUp");
				castButton:RegisterForDrag("LeftButton");
				castButton:SetScript("OnEnter", OnEnter)
				castButton:SetScript("OnLeave", OnLeave);
				castButton:SetScript("PreClick", OnReceiveDrag)
				castButton:SetScript("OnReceiveDrag", OnReceiveDrag)
				castButton:SetScript("OnDragStart", OnDragStart)
			end
		end
	end
end

function PartyCast:UpdateAllButton()
	for index, button in ipairs(buttons) do
		button:SetScale(self.db.profile.scale)
	end
end

function PartyCast:UpdateCastButton(id)
	for spellId = 1, self.db.profile.max_castSpell, 1 do
		local button = getglobal("PartyCastFrame"..id.."Button"..spellId);
        if(button) then
            button:SetAlpha(1);
        end
	end

	for buffId =1, MAX_PARTY_TOOLTIP_BUFFS do
		if UnitBuff("party"..id, buffId) then
			local name, rank, icon, count, debuffType, duration, expirationTime, isMine, isStealable = UnitBuff("party"..id, buffId);
			if (duration) then
				for spellId = 1, self.db.profile.max_castSpell do
					if (self.db.char.spellList[spellId].name and self.db.char.spellList[spellId].name == name) then
						local button = getglobal("PartyCastFrame"..id.."Button"..spellId);
                        if(button) then
                            button:SetAlpha(0.2);
                        end
					end
				end
			end
		end
	end
end

function PartyCast:ToggleButtonGrid(db)
	if self.db.profile.hideGrid then
		for id = 1, self.db.profile.max_castSpell do
			if (not next(self.db.char.spellList) or not next (self.db.char.spellList[id])) then
				for frameId =1, MAX_PARTY_MEMBER do
					local button = getglobal("PartyCastFrame"..frameId.."Button"..id);
					if button then
						button:Hide()
					end
				end
			end
		end
	else
		for id = 1, self.db.profile.max_castSpell do
			for frameId =1, MAX_PARTY_MEMBER do
				local button = getglobal("PartyCastFrame"..frameId.."Button"..id);
				if button then
					button:Show()
				end
			end
		end
	end
end
