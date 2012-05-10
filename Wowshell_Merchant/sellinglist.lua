local Merchant = LibStub('AceAddon-3.0'):GetAddon'wsMerchant'
local L = Merchant.L

local SellingList = Merchant:NewModule('SellingList', 'AceEvent-3.0')

local _ICON = [[Interface\Icons\inv_misc_bag_10_black]]

function SellingList:OnInitialize()
    self:CreateButton()
    self:RegisterEvent('MERCHANT_SHOW', 'UpdateMerchantFrame')
    hooksecurefunc('MerchantFrame_Update', function() self:UpdateMerchantFrame() end)

    self.sellinglist = Merchant.db.profile.sellinglist
end

function SellingList:CreateButton()
    if(self.SellingButton) then return end
    local b = CreateFrame('Button', nil, MerchantFrame)
    self.SellingButton = b

    local _size = 37
    b:SetHeight(_size)
    b:SetHeight(_size)

    b.icon = b:CreateTexture(nil, 'BORDER')
    b.icon:SetAllPoints(b)
    b.icon:SetTexture(_ICON)

    b:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]], 'ADD')
    b:SetPushedTexture[[Interface\Buttons\UI-Quickslot-Depress]]

    b:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        GameTooltip:ClearLines()

        GameTooltip:AddLine(L['Wowshell Merchant: '])
        GameTooltip:AddLine(L['Dragging items onto this button will add/remove this item to/from selling list'])
        GameTooltip:Show()
    end)

    b:SetScript('OnLeave', function(self)
        GameTooltip:Hide()
    end)

    b:SetScript('OnReceiveDrag', function(self)
        local typ, itemid, itemlink = GetCursorInfo()
        ClearCursor()
        GameTooltip:Hide()

        if(typ ~= 'item' or type(itemid) ~= 'number') then return end

        if(SellingList.sellinglist[itemid]) then
            SellingList.sellinglist[itemid] = nil
            Merchant:PrintF(L['Removing %s from selling list'], itemlink)
        else
            SellingList.sellinglist[itemid] = true
            Merchant:PrintF(L['Adding %s to selling list'], itemlink)
        end
    end)
end

function SellingList:UpdateMerchantFrame()
    if(MerchantFrame.selectedTab == 1) then
        self.SellingButton:ClearAllPoints()

        local _size
        if(CanMerchantRepair()) then
            local _offsetx
            if(CanGuildBankRepair()) then
                _size = 32
                _offsetx = -2
            else
                _size = 36
                _offsetx = -4
            end

            self.SellingButton:SetPoint('BOTTOMRIGHT', MerchantRepairItemButton, 'BOTTOMLEFT', _offsetx, -1)

            -- clear merchant frame
            if(MerchantRepairText) then
                MerchantRepairText:SetText""
                MerchantRepairText:Hide()
            end
        else
            _size = 36
            self.SellingButton:SetPoint('BOTTOMRIGHT', MerchantFrame, 'BOTTOMLEFT', 172, 89) -- 172, 91
        end

        if(_size) then
            self.SellingButton:SetHeight(_size)
            self.SellingButton:SetWidth(_size)
        end

        self.SellingButton:Show()
    else
        self.SellingButton:Hide()
    end
end

--[[    module for combuctor set    ]]

local CombuctorSet = Combuctor and Combuctor:GetModule('Sets', true);
if(not CombuctorSet) then return end

CombuctorSet:Register(L['Selling list'], _ICON, function(player, bagType, name, link, quality, level, ilvl, type, subType, stackCount, equipLoc)
    local itemid = link and tonumber(link:match'item:(%d+):')
    if(itemid) then
        return SellingList.sellinglist[itemid]
    end
end)



