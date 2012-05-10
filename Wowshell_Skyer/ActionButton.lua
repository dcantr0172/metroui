------------------------------------------------------------------
-- ActionButton
-- $Revision: 3135 $
-- $Date: 2010-05-14 13:39:40 +0800 (五, 2010-05-14) $
-- 作者: 月色狼影@cwdg
-- action button template
------------------------------------------------------------------
local Skylark = Skylark
local Button = CreateFrame("CheckButton");
local Button_MT = {__index = Button};
local LBF = LibStub("LibButtonFacade", true)
local Masque = LibStub("Masque", true);

local KeyBound = LibStub("LibKeyBound-1.0")
local L = wsLocale:GetLocale("Skylark");

Skylark.Button = {}
Skylark.Button.prototype = Button

local preClick, postClick, onReceiveDrag, onDragStart, onEnter, onLeave, onUpdate, onEventHandling

--param:
-- id 每个动作条中按钮的ID号
-- parent 动作按钮的父层
function Skylark.Button:Create(id, parent)
    local absid = (parent.id - 1) * 12 + id
    local name = ("LarkButton%d"):format(absid)
    local button = setmetatable(CreateFrame("CheckButton", name, parent, "SecureActionButtonTemplate, ActionButtonTemplate"), Button_MT);
    GetClickFrame(name)--类似于assert

    button.skylark = true

    button.rid = id
    button.id = absid
    button.parent = parent
    button.stateactions = {}

    button.icon = _G[("%sIcon"):format(name)];
    button.border = _G[("%sBorder"):format(name)];
    button.cooldown = _G[("%sCooldown"):format(name)];
    button.macroName = _G[("%sName"):format(name)];
    button.hotkey = _G[("%sHotKey"):format(name)];
    button.count = _G[("%sCount"):format(name)];
    button.flash = _G[("%sFlash"):format(name)];
    button.flash:Hide()

    button.FlyoutBorder = _G[name .. 'FlyoutBorder']
    button.FlyoutBorderShadow = _G[name .. 'FlyoutBorderShadow']
    button.FlyoutArrow = _G[name .. 'FlyoutArrow']

    if not Skylark.db.profile.buttons[name] then
            Skylark.db.profile.buttons[name] = {
                ["set1"] = {
                    type = "none",
                    actualtype = "",
                    value = "",
                    name = "",
                    id = "",
                },
                ["set2"] = {
                    type = "none",
                    actualtype = "",
                    value = "",
                    name = "",
                    id = "",
                }
            }
    end
    
    button.cfg = Skylark.db.profile.buttons[name]

    button:RegisterForDrag("LeftButton", "RightButton");
    button:RegisterForClicks("AnyUp")
    
    --register event
        --动作条基本事件的注册. 这些事件源于BLZ的ActionButton.lua模板
    button:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
    button:RegisterEvent("ACTIONBAR_UPDATE_STATE");
    button:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
    button:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
    button:RegisterEvent("ACTIONBAR_SHOWGRID");
    button:RegisterEvent("ACTIONBAR_HIDEGRID");
        --当鼠标上有一个技能或者一个物品的时候 此时应该触发UpdateGrid
    button:RegisterEvent("CURSOR_UPDATE");
        --更新技能等级
    button:RegisterEvent("LEARNED_SPELL_IN_TAB");
        --用于双天赋
    button:RegisterEvent("PLAYER_TALENT_UPDATE");
    button:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
        --宏的更新. 宏的处理变更是多样化. 假设玩家在更新宏 进行改名或者修改了宏的body之后 我们就得重新更新按钮信息才可以
    button:RegisterEvent("UPDATE_MACROS");
        --物品数量的更新
    button:RegisterEvent("UPDATE_INVENTORY_ALERTS");
    button:RegisterEvent("BAG_UPDATE");
        --目标变更
    button:RegisterEvent("PLAYER_TARGET_CHANGED");
        --交易技能
    button:RegisterEvent("TRADE_SKILL_SHOW");
    button:RegisterEvent("TRADE_SKILL_CLOSE");
        --enter/leave combat
    button:RegisterEvent("PLAYER_ENTER_COMBAT");
    button:RegisterEvent("PLAYER_LEAVE_COMBAT");
        --重复技能 比如自动射击
    button:RegisterEvent("START_AUTOREPEAT_SPELL")
    button:RegisterEvent("STOP_AUTOREPEAT_SPELL");
        --mount and critter
    button:RegisterEvent("COMPANION_UPDATE");
    button:RegisterEvent("COMPANION_LEARNED");
        --add 3.2
    button:RegisterEvent("UNIT_INVENTORY_CHANGED");
        --key binding
    button:RegisterEvent("UPDATE_BINDINGS");

    --set script
    button:SetScript("PreClick", preClick);
    button:SetScript("PostClick", postClick);
    button:SetScript("OnReceiveDrag", onReceiveDrag);
    button:SetScript("OnDragStart", onDragStart);
    button:SetScript("OnEnter", onEnter);
    button:SetScript("OnLeave", onLeave);
    button:SetScript("OnUpdate", onUpdate);
    button:SetScript("OnEvent", onEventHandling)
    button:HookScript('OnClick', button.UpdateFlyoutTexture)

    --set state
    button:SetAttribute("type", "none");
    button:SetAttribute("spell", "");
    button:SetAttribute("item", "");
    button:SetAttribute("macro", "");
    button:SetAttribute("flyout", "");
    button:SetAttribute("buttonlock", Skylark.db.profile.buttonlock);
    button:SetAttribute("useparent-unit", nil);
    button:SetAttribute("useparent-actionpage", nil);
    button:SetAttribute("showgrid", 0);

    button:UpdateSelfCast();

	if Masque and parent.MasqueGroup then
        local group = parent.MasqueGroup
        group:AddButton(button)
    elseif LBF and parent.LBFGroup then
        local group = parent.LBFGroup
        group:AddButton(button)
    end

    if parent.cfg.showgrid then
        button:ShowGrid()
    end

    --update
    button:UpdateGrid();
    button:UpdateMacro()
    button:UpdateCompanion();
    button:UpdateSpell();--button's spell
    button:UpdateFlyout();
    button:SetFromStoredCommand();--更新button按钮属性
    button:ToggleButtonElements();
    button:UpdateHotkeys();
--  button:UpdateAll();--update all func

    return button
end

--script method handling
function preClick(self)
    if (InCombatLockdown()) then
        return
    end

    self.cursorCommand, self.cursorData, self.cursorSubtype = GetCursorInfo();
    if (self.cursorCommand) then
        self:SetAttribute("type", "none")
    end
end

function postClick(self)
    if (InCombatLockdown()) then
        return
    end
    
    --如果玩家为双天赋 此时动作按钮的数据要跟着做变更. 以防某些技能无法使用
    if (self.cursorCommand) then
        local currentSet = GetActiveTalentGroup();--获取当前天赋
        self:SetAttribute("type", self.cfg["set"..currentSet]["type"])
        self:SetFromCursorInfo(self.cursorCommand, self.cursorData, self.cursorSubtype);
    end

    --update checked
    self:UpdateChecked()
end

function onReceiveDrag(self)
    local command, value, subtype = GetCursorInfo();
    self:SetFromCursorInfo(command, value, subtype);
    self:UpdateFlyoutTexture()
end

function onDragStart(self)
    if (InCombatLockdown() or Skylark.db.profile.buttonlock) then return end

    local command, value = self:GetCommand(true);
    self:UpdateCursor(command, value);
    self:SetCommand("none", "", "", "", "");

    self:UpdateFlyoutTexture()
end

function onEnter(self)
    if not (Skylark.db.profile.tooltip == "nocombat" and InCombatLockdown()) and Skylark.db.profile.tooltip ~= "disabled" then
        self:SetTooltip();
    end
    KeyBound:Set(self)
end

function onLeave(self)
    GameTooltip:Hide();
end

function onUpdate(self, elapsed)
    if self.flashing == 1 then
        self.flashtime = self.flashtime - elapsed

        if self.flashtime <= 0 then
            local overtime = -self.flashtime
            if overtime >= ATTACK_BUTTON_FLASH_TIME then
                overtime = 0
            end

            self.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

            local flashTexture = self.flash
            if flashTexture:IsShown() then
                flashTexture:Hide()
            else
                flashTexture:Show()
            end
        end
    end

    --form ActionButton.lua Handle range indicator
    if self.rangeTimer then
        self.rangeTimer = self.rangeTimer - elapsed
        if self.rangeTimer <= 0 then
            local hotkey = self.hotkey
            local command, value = self:GetCommand();
            local valid;
            local hkshown = hotkey:GetText() == RANGE_INDICATOR

            if command == "spell" then
                valid = IsSpellInRange(value)
            elseif command == "item" then
                valid = IsItemInRange(value)
            end

            if valid and hkshown then
                hotkey:Show()
            elseif hkshown then
                hotkey:Hide()
            end
            self.outOfRange = (valid == 0)
            self:UpdateUsable()
            self.rangeTimer = TOOLTIP_UPDATE_TIME
        end
    end
    
    --self:UpdateUsable()
end

function onEventHandling(self, event, ...)
    if event == "ACTIONBAR_SLOT_CHANGED" then
        self:UpdateAll();
    elseif event == "ACTIONBAR_UPDATE_STATE" or event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE" then
        self:UpdateChecked()
    elseif event == "COMPANION_UPDATE" then
        local type = ...
        if type == "mount" then
            self:UpdateChecked()
        end
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
        self:UpdateCooldown();
    elseif event == "ACTIONBAR_UPDATE_USABLE" then
        self:UpdateUsable()
    elseif event == "ACTIONBAR_SHOWGRID" then
        self:ShowGrid()
    elseif event == "ACTIONBAR_HIDEGRID" then
        if not self.parent.cfg.showgrid then
            self:HideGrid();
        end
    elseif event == "START_AUTOREPEAT_SPELL" then
        local command, value = self:GetCommand()
        if (command == "spell" and IsAutoRepeatSpell(value)) then
            self:StartFlash()
        end
    elseif event == "STOP_AUTOREPEAT_SPELL" then
        local command, value = self:GetCommand()
        if (self.flashing == 1 and not (command == "spell" and IsAttackSpell(value))) then
                self:StopFlash()
        end
    elseif event == "PLAYER_ENTER_COMBAT" then
        local command, value = self:GetCommand();
        if (command == "spell" and IsAttackSpell(value)) then
            self:StartFlash()
        end
    elseif event == "PLAYER_LEAVE_COMBAT" then
        local command, value = self:GetCommand()
        if (command == "spell" and IsAttackSpell(value)) then
            self:StopFlash()
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        self.rangeTimer = -1;
    elseif event == "CURSOR_UPDATE" then

    elseif event == "BAG_UPDATE" then
        self:UpdateEquipped();
        self:UpdateText();
    elseif event == "UPDATE_MACROS" then
        self:UpdateMacro();
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
        self:SetFromStoredCommand();--for dual spec
        --must update action button grid
        self:UpdateGrid()
    elseif event == "LEARNED_SPELL_IN_TAB" or event == "PLAYER_TALENT_UPDATE" then
        self:UpdateSpell()
    elseif event == "COMPANION_LEARNED" then
        self:UpdateCompanion();
    elseif event == "UPDATE_BINDINGS" then
        self:UpdateHotkeys()
    elseif event == "UNIT_INVENTORY_CHANGED" then
        local unit = ...
        if unit == "player" then
            if (GameTooltip:GetOwner() == self) then
            self:SetTooltip();
            end
        end
    end
end

 --prototype
function Button:UpdateSpell()
    if (InCombatLockdown()) then return end

    if (self.cfg["set1"]["actualtype"] == "spell") then
        local maxSpell = self:GetSpellNameFormSpellBook(self.cfg["set1"]["name"])
        if maxSpell and maxSpell ~= self.cfg["set1"]["value"] then
            self:SetCommand("spell", maxSpell, "spell", self.cfg["set1"]["name"], "", 1)
        end
    end

    if (self.cfg["set2"]["actualtype"] == "spell") then
        local maxSpell = self:GetSpellNameFormSpellBook(self.cfg["set2"]["name"])
        if maxSpell and maxSpell ~= self.cfg["set2"]["value"] then
            self:SetCommand("spell", maxSpell, "spell", self.cfg["set2"]["name"], "", 2)
        end
    end
end

function Button:UpdateFlyout()
    if (InCombatLockdown()) then return end
    if (self.cfg["set1"]["actualtype"] == "flyout") then
        local id = self.cfg["set1"]["value"];
        local tex = self.cfg['set1']['name']
        if id and tex then
            self:SetCommand("flyout", id, "flyout", tex, "", 1)
        end
    end

    if (self.cfg["set2"]["actualtype"] == "flyout") then
        local id = self.cfg["set2"]["value"];
        local tex = self.cfg['set2']['name']
        if id and tex then
            self:SetCommand("flyout", id, "flyout", tex, "", 2)
        end
    end
end

function Button:UpdateMacro()
    if (InCombatLockdown()) then return end
    if self.cfg["set1"]["actualtype"] == "macro" then
        local macroId = GetMacroIndexByName(self.cfg["set1"]["name"]);
        if (macroId == 0) then
            self:SetCommand("macro", "none", "", "", "", 1)
        elseif (macroId ~= self.cfg["set1"]["value"]) then
            self:SetCommand("macro", macroId, "macro", self.cfg["set1"]["name"], "", 1)
        end
    end

    if self.cfg["set2"]["actualtype"] == "macro" then
        local macroId = GetMacroIndexByName(self.cfg["set2"]["name"]);
        if (macroId == 0) then
            self:SetCommand("macro", "none", "", "", "", 2)
        elseif (macroId ~= self.cfg["set2"]["value"]) then
            self:SetCommand("macro", macroId, "macro", self.cfg["set1"]["name"], "", 2)
        end
    end
end

function Button:UpdateCompanion()
    if (InCombatLockdown()) then return end

    if self.cfg["set1"]["actualtype"] == "MOUNT" or self.cfg["set1"]["actualtype"] == "CRITTER" then
        local id = self:FindCompanionId(self.cfg["set1"]["actualtype"], self.cfg["set1"]["name"]);
        if (id ~= self.cfg["set1"]["id"]) then
            self:SetCommand("spell", self.cfg["set1"]["value"], self.cfg["set1"]["actualtype"], self.cfg["set1"]["name"], id, 1)
        end
    end

    if self.cfg["set2"]["actualtype"] == "MOUNT" or self.cfg["set2"]["actualtype"] == "CRITTER" then
        local id = self:FindCompanionId(self.cfg["set2"]["actualtype"], self.cfg["set2"]["name"]);
        if (id ~= self.cfg["set2"]["id"]) then
            self:SetCommand("spell", self.cfg["set2"]["value"], self.cfg["set2"]["actualtype"], self.cfg["set2"]["name"], id, 1)
        end
    end
end

--toggle spec
function Button:SetFromStoredCommand()
    local set = GetActiveTalentGroup();
    local cfg = self.cfg["set"..set]; 
    self:SetCommand(cfg["type"], cfg["value"], cfg["actualtype"], cfg["name"], cfg["id"])
end

--更新所有数据
function Button:UpdateAll()
    self:UpdateTexture();--update texture
    self:UpdateChecked();--update checked
    self:UpdateCooldown();--update cooldown
    self:UpdateUsable();
    self:UpdateEquipped();
    self:UpdateText();
end

function Button:UpdateTexture()
    local icon = self.icon
    local command, value = self:GetCommand();
    local relcommand, relvalue = self:GetCommand(true)
    local texture = nil
    
    if (command == "spell") then
        texture = GetSpellTexture(value)
    elseif (command == "item") then
        texture = GetItemIcon(value)
    elseif (command == "MOUNT" or command == "CRITTER") then
        texture = select(4, GetCompanionInfo(command, value))
    elseif (command == "flyout") then
        -- fetch the value
		local name, description, numSlots, isKnown = GetFlyoutInfo(value)
		local index = 1
		while true do
			local spellName = GetSpellBookItemName(index, "spell")
			if not spellName then
				break
			end
			if spellName == name then
				texture = GetSpellBookItemTexture(index, "spell")				
			end
			index = index + 1
		end
    end

    if relcommand == "macro" then
        local macroName, macroTexture = GetMacroInfo(relvalue);
        if (not texture or macroTexture ~= "Interface\\Icons\\INV_Misc_QuestionMark") then
            texture = macroTexture;
        end
    end

    if texture then
        icon:SetTexture(texture)
        icon:SetVertexColor(1, 1, 1, 1)
        icon:Show()
        self:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
    elseif (command == "spell") then
        icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
        icon:SetVertexColor(1, 1, 1,0.5)
        icon:Show()
        self:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
    else
        local cooldown = self.cooldown
        icon:Hide();
        cooldown:Hide()
        self:SetNormalTexture("Interface\\Buttons\\UI-Quickslot")
    end
end

function Button:UpdateChecked()
    local command, value = self:GetCommand();

    if (command == "spell" and (IsCurrentSpell(value) or IsAutoRepeatSpell(value))) then
        self:SetChecked(1)
    elseif (command == "item" and IsCurrentItem(value)) then
        self:SetChecked(1)
    elseif (command == "MOUNT" or command == "CRITTER") then
        local id, name, spellId, tex, isCurrent = GetCompanionInfo(command, value)
        self:SetChecked(isCurrent)
        local castName = UnitCastingInfo("player")
        if (castName == name) then
            self:SetChecked(1)
        end
    else
        self:SetChecked(0)
    end
end

function Button:UpdateCooldown()
    local cooldown = self.cooldown
    local start, duration, enable;
    local command, value = self:GetCommand();

    if (command == "spell" and self:FindSpellId(value)) then
        start, duration, enable = GetSpellCooldown(value)
    elseif (command == "item") then
        --start, duration, enable = GetItemCooldown(value)
    elseif (command == "MOUNT" and command=="CRITTER") then
        start, duration, enable = GetCompanionCooldown(command, value)
    end
    if (start == nil) then
        start, duration, enable = 0, 0, 0
    end
    CooldownFrame_SetTimer(cooldown, start, duration, enable);
end

function Button:UpdateUsable()
    local isUsable, notEnoughMana = true, false
    local command, value = self:GetCommand();
    local icon, hotkey = self.icon, self.hotkey
    local oor = Skylark.db.profile.outofrange
    local oorcolor, oomcolor = Skylark.db.profile.colors.range, Skylark.db.profile.colors.mana

    if (command == "spell") then
        isUsable, notEnoughMana = IsUsableSpell(value)
    elseif (command == "item") then
        isUsable, notEnoughMana = IsUsableItem(value)
    elseif (command == "MOUNT") then --针对坐骑部分进行判断是否在户外/户内/战斗/非战斗状态/游泳/非游泳/副本/战场
		local _, _, _, _, active, mountFlags = GetCompanionInfo("MOUNT", value)
		local isOutdoor, isInCombat = IsOutdoors(), InCombatLockdown()
		if isOutdoor and not isInCombat and not active then
			isUsable = true
		else
			isUsable = false
		end
    end

    if oor == "button" and self.outOfRange then
        icon:SetVertexColor(oorcolor.r, oorcolor.g, oorcolor.b)
        hotkey:SetVertexColor(1, 1, 1)
    else
        if oor == "hotkey" and self.outOfRange then
            hotkey:SetVertexColor(oorcolor.r, oorcolor.g, oorcolor.b)
        else
            hotkey:SetVertexColor(1, 1, 1)
        end

        if isUsable then
            icon:SetVertexColor(1, 1, 1)
        elseif notEnoughMana then
            icon:SetVertexColor(oomcolor.r, oomcolor.g, oomcolor.b)
        else
            icon:SetVertexColor(0.4, 0.4, 0.4)
        end
    end
end

function Button:UpdateText()
    local count = self.count
    local macroName = self.macroName
    local command, value = self:GetCommand()

    count:SetText("")
    macroName:SetText("")
    
    if (command == "spell" and IsConsumableSpell(value)) then
        count:SetText(GetSpellCount(value))
    elseif (command == "item" and IsConsumableItem(value)) then
        count:SetText(GetItemCount(value,nil,true))--get charges
    elseif (command == "item" and GetItemCount(value) > 1) then
        count:SetText(GetItemCount(value))
    elseif (self:GetAttribute("type") == "macro") then
        local set = GetActiveTalentGroup();
        macroName:SetText(self.cfg["set"..set]["name"])--not get macro name
    end
end

function Button:UpdateEquipped()
    local command, value = self:GetCommand();
    if (command == "item" and IsEquippedItem(value)) then
        self.border:SetVertexColor(0, 1, 0 , 0.35)
        self.border:Show();
    else
        self.border:Hide()
    end
end

function Button:GetCommand(real)
    local currentSet = GetActiveTalentGroup();
    local command = self.cfg["set"..currentSet]["actualtype"];--spell, item, macro
    local value = self:GetAttribute(command);
    if (command == "macro" and not real) then
        local spellName, spellRank = GetMacroSpell(value)--this value is macro id
        if (spellName) then
            command = "spell"
            value = spellName.."("..spellRank..")";
        else
            local itemName, itemLink = GetMacroItem(value)
            if (itemName) then
                command = "item"
                value = itemLink
            end
        end
    elseif (command == "MOUNT" or command == "CRITTER") then
        value = self.cfg["set"..currentSet]["id"]
    end
    
    return command, value
end

--typem fullValue, realType, value, id, isSave?, talentSet
function Button:SetCommand(command, data, actualType, name, id, set)
    if (InCombatLockdown()) then
        UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1.0, 0.1, 0.1, 1.0);
        return false
    end

    local currentSet = GetActiveTalentGroup();
    if not set then
        set = currentSet
    end

    if command == "item" then
        data = self:HotfixItemLink(data)
    end

    self.cfg["set"..set] = {
        type = command,
        value = data,
        actualtype = actualType,
        name = name, 
        id = id
    }

    if (set == currentSet) then
        local currentCommand = self:GetAttribute("type");
        --type: action, spell, item, macro, pet, actionbar, target, focus, assist, maintank/mainassist, stop, click, attribute

        self:SetAttribute(command, data);
        self:SetAttribute("type", command);
        if(command == 'flyout') then
            self:SetAttribute('spell', data)
            self.action = 999
        else
            self.action = nil
        end

        -- better not doing this
        --if command ~= currentCommand then
        --    self:SetAttribute(currentCommand, "");
        --end
        self:UpdateAll()
    end

    return true
end

function Button:HotfixItemLink(itemLink)
    --|cffffffff|Hitem:22018:0:0:0:0:0:0:399395648:70|h[魔法冰川水]|h|r
    if not itemLink or itemLink == "" then return end
    local _,_,uid, level = string.find(itemLink, "%:(%d+):(%d+)\124")
    if uid then
        --fix!
        return string.gsub(itemLink, "%:(%d+):(%d+)\124", "%:0:"..level.."\124")
    else
        return itemLink
    end
end

function Button:SetFromCursorInfo(command, value, subtype)
    local currentCommand, currentData = self:GetCommand(true);

    if (command == "spell") then
        local spellNameRank, spellName = self:GetSpellNameFormSpellBook(value, BOOKTYPE_SPELL);
        self:SetCommand(command, spellNameRank, "spell", spellName, "")
    elseif (command == "item") then
        self:SetCommand(command, subtype, "item", "", "");
    elseif (command == "macro") then
        local macroName = GetMacroInfo(value)
        self:SetCommand(command, value, "macro", macroName, "")
    elseif (command == "companion") then
        local id, name, spellId = GetCompanionInfo(subtype, value)
        local spellName = GetSpellInfo(spellId)--获取正确的法术名称
        self:SetCommand("spell", spellName, subtype, name, value)
    elseif (command == "equipmentset") then
    elseif (command == "bonusaction") then
    elseif (command == "flyout") then
        self:SetCommand(command, value, 'flyout', subtype)
    elseif (command == "customaction") then
    end

    self:UpdateCursor(currentCommand, currentData);
end

function Button:UpdateCursor(command, value)
    if (InCombatLockdown()) then
        return;
    end

	ClearCursor();
    if (command == "spell") then
        PickupSpell(value)
    elseif (command == "item") then
        PickupItem(value)
    elseif (command == "macro") then
        PickupMacro(value)
    elseif (command == "MOUNT" or command == "CRITTER") then
        PickupCompanion(command, value)
    end
end

function Button:GetSpellNameFormSpellBook(spell, ...)
    local spellName, spellRank = GetSpellBookItemName(spell, ...);
    if (spellName) then
        return spellName, spellName
    end
    return nil, nil
end

function Button:FindSpellId(spellName)
    local i = 1
    while true do
        local spell = self:GetSpellNameFormSpellBook(i, BOOKTYPE_SPELL)
        if (not spell) then
            break
        end
        if (spellName == spell) then
            return i
        end
        i = i + 1
    end
    return nil
end

function Button:FindCompanionId(compType, needFindCompName)
    for i=1, GetNumCompanions(compType) do
        local id, name = GetCompanionInfo(compType, i);
        if (name == needFindCompName) then
            return i;
        end
    end
    return nil;
end

function Button:SetTooltip()
    if (GetCVar("UberTooltips") == "1") then
        GameTooltip_SetDefaultAnchor(GameTooltip, self)
    else
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
    
    local command, value = self:GetCommand()
    if (command == "spell") then
        local spellId = self:FindSpellId(value)
        if (spellId and GameTooltip:SetSpellBookItem(spellId, BOOKTYPE_SPELL)) then
            self.UpdateTooltip = self.SetTooltip
        else
            self.UpdateTooltip = nil
        end
    elseif (command == "item") then
        if (GameTooltip:SetHyperlink(value)) then
            self.UpdateTooltip = self.SetTooltip
        else
            self.UpdateTooltip = nil
        end
    elseif (command == "MOUNT" or command == "CRITTER") then
        local id, name, spellId = GetCompanionInfo(command, value);
        if (GameTooltip:SetHyperlink("spell:"..spellId)) then
            self.UpdateTooltip = self.SetTooltip
        else
            self.UpdateTooltip = nil
        end
    end
end

function Button:UpdateSelfCast()
    self:SetAttribute("checkselfcast", Skylark.db.profile.selfcastmodifier and true or nil);
    self:SetAttribute("checkfocuscast", Skylark.db.profile.focuscastmodifier and true or nil);
    self:SetAttribute("unit2", Skylark.db.profile.selfcastrightclick and "player" or nil);
end

function Button:StartFlash()
    assert(self);--check it
    self.flashing = 1
    self.flashtime = 0
    self:UpdateChecked()
end

function Button:StopFlash()
    self.flashing = 0
    self.flash:Hide()
    self:UpdateChecked();
end

function Button:ToggleButtonElements()
    if self.parent.cfg.hidemacrotext then
        self.macroName:Hide()
    else
        self.macroName:Show()
    end
end

function Button:GetHotkey()
    local key = GetBindingKey('CLICK '..self:GetName()..":LeftButton");
    return key and KeyBound:ToShortKey(key)
end

function Button:UpdateHotkeys()
    local key = self:GetHotkey() or "";
    local hotkey = self.hotkey
    
    if key == "" or self.parent.cfg.hidehotkey then
        hotkey:SetText(RANGE_INDICATOR);
        hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -2);
        hotkey:Hide()
    else
        hotkey:SetText(key)
        hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, -2)
        hotkey:Show()
    end
end

function Button:GetBindings()
    local keys, binding = ""
    binding = 'CLICK '..self:GetName()..":LeftButton";
    for i = 1, select('#', GetBindingKey(binding)) do
        local hotKey = select(i, GetBindingKey(binding))
        if keys ~= "" then
            keys = keys..","
        end
        keys= keys..GetBindingText(hotKey,'KEY_')
    end
    return keys;
end

function Button:FreeKey(key)
    self:ClearBindings()
    return self:GetActionName()
end

function Button:SetKey(key)
    SetBindingClick(key, self:GetName(), "LeftButton")
end

function Button:ClearBindings()
    local binding = 'CLICK '..self:GetName()..":LeftButton";
    while GetBindingKey(binding) do
        SetBinding(GetBindingKey(binding), nil)
    end
end

function Button:GetActionName()
    return format(L["额外动作条%d 按钮%d"], self.parent.id, self.rid)
end

--InCombat CANT SETTING
function Button:UpdateGrid()
    if self:GetAttribute("showgrid") > 0 then
        ActionButton_ShowGrid(self)
    else
        assert(self);
        local showgrid = self:GetAttribute("showgrid");
        if ( issecure() ) then
            if ( showgrid > 0 ) then
                self:SetAttribute("showgrid", showgrid - 1);
            end
        end
        if self:GetAttribute("showgrid") == 0 then
            local currentSet = GetActiveTalentGroup();
            if (self.cfg["set"..currentSet]["type"] == "none") then
                self:Hide();
            else
                self:Show()
            end
        end
    end
end

function Button:ShowGrid()
    if InCombatLockdown() then return end;
    if not self.gridShown then
        self.gridShown = true
        self:SetAttribute("showgrid", self:GetAttribute("showgrid") + 1);
        self:UpdateGrid()
    end
end

function Button:HideGrid()
    if InCombatLockdown() then return end;
    if self.gridShown then
        self.gridShown = nil
        self:SetAttribute("showgrid", self:GetAttribute("showgrid") - 1);
        self:UpdateGrid()
    end
end

function Button:ClearSetPoint(...)
    self:ClearAllPoints()
    self:SetPoint(...)
end

-- update flyout texture
--hooksecurefunc(ActionButton_UpdateFlyout, function(self)
function Button:UpdateFlyoutTexture()
    if(not self.skylark) then return end
    if(self:GetAttribute'type' == 'flyout') then
        local arrowDistance
        if(SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) then
            self.FlyoutBorder:Show()
            self.FlyoutBorderShadow:Show()
            arrowDistance = 5
        else
            self.FlyoutBorder:Hide()
            self.FlyoutBorderShadow:Hide()
            arrowDistance = 2
        end

        self.FlyoutArrow:Show()
        self.FlyoutArrow:ClearAllPoints()

        local direction = self:GetAttribute('flyoutDirection')
        if(direction == 'LEFT') then
            self.FlyoutArrow:SetPoint('LEFT', self, 'LEFT', -arrowDistance, 0)
            SetClampedTextureRotation(self.FlyoutArrow, 270)
        elseif(direction == 'RIGHT') then
            self.FlyoutArrow:SetPoint('RIGHT', self, 'RIGHT', arrowDistance, 0)
            SetClampedTextureRotation(self.FlyoutArrow, 90)
        elseif(direction == 'DOWN') then
            self.FlyoutArrow:SetPoint('BOTTOM', self, 'BOTTOM', 9, -arrowDistance)
            SetClampedTextureRotation(self.FlyoutArrow, 180)
        else
            self.FlyoutArrow:SetPoint('TOP', self, 'TOP', 0, arrowDistance)
            SetClampedTextureRotation(self.FlyoutArrow, 0)
        end
    else
        self.FlyoutBorder:Hide()
        self.FlyoutBorderShadow:Hide()
        self.FlyoutArrow:Hide()
    end
end
