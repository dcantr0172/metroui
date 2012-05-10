local _, ns = ...
local EasyAH = LibStub('AceAddon-3.0'):GetAddon('EasyAH')
local Savelist = EasyAH:NewModule('Savelist')
local L = ns.L

local info = {}
local EasyAH_SavelistDropdown = CreateFrame('Frame', 'EasyAH_SavelistDropdown')
EasyAH_SavelistDropdown.displayMode = 'MENU'

local menuOnClick = function(btn, item)
    Savelist:MenuOnClick(btn, item)
end

EasyAH_SavelistDropdown.initialize = function(self, level)
    wipe(info)
    info.notCheckable = 1

    info.text = L['|cffffd100Add|r'] .. ' ' .. (BrowseName:GetText() or '')
    info.func = function()
        Savelist:AddToMenu()
    end
    UIDropDownMenu_AddButton(info, level)

    wipe(info)
    info.text = '   '
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info, text)

    for _, v in next, EasyAH.db.char.ahList do
        info.func = menuOnClick
        info.text = v
        info.arg1 = v
        UIDropDownMenu_AddButton(info, level)
    end

    wipe(info)
    info.text = '   '
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info, text)


    info.text = L['|cffffd100Shift-click to remove']
    UIDropDownMenu_AddButton(info, level)
end

function Savelist:OnInitialize()
end
function Savelist:OnEnable()
end
function Savelist:OnDisable()
end

function Savelist:LoadAddon()
    self:CreateDropdownButton()
end

--- Creates a dropdown button for savelist
function Savelist:CreateDropdownButton()
    if(self.DropDownButton) then return end
    if(not BrowseName) then
        return geterrorhandler()('Cannot create dropdown button because of AuctionFrame not loaded')
    end
    self.DropDownButton = CreateFrame('Button', 'EasyAH_SavelistButton', BrowseName)
    local b = self.DropDownButton

    b:SetWidth(25); b:SetHeight(25)
    b:SetFrameStrata'HIGH'
    b:SetPoint('TOP', BrowseName, 'TOPRIGHT', -11, 5)
    b:SetNormalTexture[[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]]
    b:SetHighlightTexture[[Interface\Buttons\ButtonHilight-Round]]
    b:SetDisabledTexture[[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]]
    b:SetPushedTexture[[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]]

    b:SetScript('OnClick', function(self, btn)
        if(btn == 'LeftButton') then
            ToggleDropDownMenu(1, nil, EasyAH_SavelistDropdown, self:GetName(), 0, 0)
        end
    end)
    b:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        GameTooltip:ClearLines()
        GameTooltip:AddLine(L['Search list'])
        GameTooltip:Show()
    end)
    b:SetScript('OnLeave', function(self)
        GameTooltip:Hide()
    end)

    b:Show()
end

--- Add current AH panel search item to save list
-- No args needed, do nothing if the item already exist
function Savelist:AddToMenu()
    local item = strtrim(BrowseName:GetText())
    if(not item or item == '') then return end

    for k, v in next, EasyAH.db.char.ahList do
        if(v == item) then return end
    end

    tinsert(EasyAH.db.char.ahList, item)
end

--- Handle dropdown menu click
function Savelist:MenuOnClick(_, item)
    if(IsModifiedClick()) then
        for k, v in next, EasyAH.db.char.ahList do
            if(v == item) then
                tremove(EasyAH.db.char.ahList, k)
            end
        end
    else
        BrowseName:SetText(item)
    end
end

