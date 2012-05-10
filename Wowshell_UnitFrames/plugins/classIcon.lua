-- by yaroot <yaroot AT gmail.com>

local parent, ns = ...
local oUF = ns.oUF

local function Update(self, event)
    if(not self.ClassIcon.nohook) then
        local _, class = UnitClass(self.unit)
        local coords = class and CLASS_ICON_TCOORDS[class]
        if(coords) then
            self.ClassIcon:SetTexCoord(unpack(coords))
        end
        --print(self.unit, class)
    end
end

local function Enable(self)
    local icon = self.ClassIcon
    if(icon) then
        if(not icon:GetTexture()) then
            icon:SetTexture([[Interface\Glues\CharacterCreate\UI-CharacterCreate-Classes]]);
        end
        --self:RegisterEvent('PLAYER_TARGET_CHANGED', Update)
        --self:RegisterEvent('PARTY_MEMBERS_CHANGED', Update)
        --self:RegisterEvent('PARTY_MEMBER_ENABLE', Update)
        --self:RegisterEvent('PARTY_LEADER_CHANGED', Update)
        --self:HookScript('OnShow', Update)

        return true
    end
end

local function Disable(self)
    local icon = self.ClassIcon
    if(icon) then
        --self:UnregisterEvent('PLAYER_TARGET_CHANGED', Update)
        --self:UnregisterEvent('PARTY_MEMBERS_CHANGED', Update)
        --self:UnregisterEvent('PARTY_MEMBER_ENABLE', Update)
        --self:UnregisterEvent('PARTY_LEADER_CHANGED', Update)
        icon.nohook = true
    end
end

oUF:AddElement('ClassIcon', Update, Enable, Disable)
