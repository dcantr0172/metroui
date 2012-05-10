-- LookingForLoot
-- Author: Rawlex
-- License: All Rights Reserved

local function ToString(v)
    if type(v) ~= "table" then
        return tostring(v)
    else
        local s = "{ "
        local sep = ""
        for key, value in pairs(v) do
            s = s .. sep .. "[" .. key .. "] = " .. ToString(value)
            sep = ", "
        end
        s = s .. " }"
        return s
    end
end

local optionsMapping = 
    {
        ["positioningMode"] = { {value = "stagger", text = "交错"}, {value = "grid", text = "交叉"} },
        ["careFactor"] = { {value = "all", text = "所有的ROLL点信息"}, {value = "greed", text = "我贪婪的物品"}, {value = "need", text = "我需求的物品"} }
    }

local function CreateDropDownMenu(parent, name, key, mapping, point, relativePoint, x, y, width, buttonWidth)
    local dropDownMenu = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate")
    parent[key] = dropDownMenu
    dropDownMenu:ClearAllPoints()
    dropDownMenu:SetPoint(point, parent, relativePoint, x, y)
    dropDownMenu:Show()
    dropDownMenu.mapping = mapping
    
    local function OnClick(self)
        UIDropDownMenu_SetSelectedValue(dropDownMenu, self.value)
    end
    
    local function initialize(self, level)
        local info = UIDropDownMenu_CreateInfo()
        for i, v in ipairs(self.mapping) do
            info = UIDropDownMenu_CreateInfo()
            info.text = v.text
            info.value = v.value
            info.func = OnClick
            UIDropDownMenu_AddButton(info, level)
        end
    end
    
    local function SetSelectedOption(self, value)
        UIDropDownMenu_SetSelectedValue(self, value)
        for i, v in ipairs(self.mapping) do
            if v.value == value then
                UIDropDownMenu_SetText(self, v.text)
            end
        end
    end
    
    local function GetSelectedOption(self)
        return UIDropDownMenu_GetSelectedValue(self)
    end
    
    dropDownMenu.SetSelectedOption = SetSelectedOption
    dropDownMenu.GetSelectedOption = GetSelectedOption
    
    UIDropDownMenu_Initialize(dropDownMenu, initialize)
    UIDropDownMenu_SetWidth(dropDownMenu, width);
    UIDropDownMenu_SetButtonWidth(dropDownMenu, buttonWidth)
    UIDropDownMenu_JustifyText(dropDownMenu, "LEFT")
end

function LookingForLootOptionsFrame_OnLoad(self)
    CreateDropDownMenu(self, self:GetName() .. "PositioningModeDropDownMenu", "positioningModeDropDownMenu", optionsMapping["positioningMode"], "TOPLEFT", "TOPLEFT", 0, -85, 100, 124)
    CreateDropDownMenu(self, self:GetName() .. "CareFactorDropDownMenu", "careFactorDropDownMenu", optionsMapping["careFactor"], "TOPLEFT", "TOPLEFT", 0, -155, 150, 174)
    self.enabledPartyCheckButton:SetText("asdasd")

    self.name = "LookingForLoot"
    self.okay = LookingForLootOptionsFrame_OnOkay
    self.cancel = LookingForLootOptionsFrame_OnCancel
    self.refresh = LookingForLootOptionsFrame_OnRefresh
    InterfaceOptions_AddCategory(self)
end

function LookingForLootOptionsFrame_OnOkay(self)
    self.db["enabled"]["party"] = self.enabledPartyCheckButton:GetChecked() == 1
    self.db["enabled"]["raid_10"] = self.enabledRaid10CheckButton:GetChecked() == 1
    self.db["enabled"]["raid_25"] = self.enabledRaid25CheckButton:GetChecked() == 1
    self.db["positioningMode"] = self.positioningModeDropDownMenu:GetSelectedOption()
    self.db["careFactor"] = self.careFactorDropDownMenu:GetSelectedOption()
    self.db["chatFilter"] = self.chatFilterCheckButton:GetChecked() == 1
end

function LookingForLootOptionsFrame_OnCancel(self)
end

function LookingForLootOptionsFrame_OnRefresh(self)
    self.enabledPartyCheckButton:SetChecked(self.db["enabled"]["party"] == true)
    self.enabledRaid10CheckButton:SetChecked(self.db["enabled"]["raid_10"] == true)
    self.enabledRaid25CheckButton:SetChecked(self.db["enabled"]["raid_25"] == true)
    self.positioningModeDropDownMenu:SetSelectedOption(self.db["positioningMode"])
    self.careFactorDropDownMenu:SetSelectedOption(self.db["careFactor"])
    self.chatFilterCheckButton:SetChecked(self.db["chatFilter"] == true)
end

function LookingForLootOptionsFrame_ResetButton_OnClick(self)
    self:GetParent().db["positions"] = {}
end

function LookingForLootOptionsFrame_TestButton_OnClick(self)
    self:GetParent().test()
end
