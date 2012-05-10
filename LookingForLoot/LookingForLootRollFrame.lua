-- LookingForLoot
-- Author: Rawlex
-- License: All Rights Reserved

local LFL_SCROLL_DELAY = 0.05

function LookingForLootRollFrame_OnDragStart(self)
    self:StartMoving()
end

function LookingForLootRollFrame_OnDragEnd(self)
    self:StopMovingOrSizing()
    self:SaveCustomPosition()
end

function LookingForLootRollFrame_UpDownButton_OnUpdate(self, elapsed)
    if (self:GetButtonState() == "PUSHED") then
        if self.clickDelay == nil then 
            self.clickDelay = LFL_SCROLL_DELAY 
        end
        
        self.clickDelay = self.clickDelay - elapsed
        if self.clickDelay < 0 then
            local name = self:GetName()
            if name == self:GetParent():GetName().."DownButton" then
                self:GetParent():ScrollDown()
            elseif name == self:GetParent():GetName().."UpButton" then
                self:GetParent():ScrollUp()
            end
            self.clickDelay = LFL_SCROLL_DELAY
        end
    end
end

function LookingForLootRollFrame_ItemButton_OnEnter(self, motion)
    if self.link ~= nil then
        GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
        GameTooltip:SetHyperlink(self.link)
        GameTooltip:Show()
    end
end

function LookingForLootRollFrame_ItemButton_OnLeave(self, motion)
    GameTooltip:Hide()
end
