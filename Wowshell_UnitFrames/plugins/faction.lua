local parent, ns = ...
local oUF = ns.oUF

local function Update(self)
    local bar = self.Faction

    local name, reaction, min, max, value = GetWatchedFactionInfo()
    if(not name) then
        bar:SetMinMaxValues(0, 1)
        bar:SetValue(0)
        if(bar.Text) then
            bar.Text:SetText(0)
        end
    else
        bar:SetMinMaxValues(0, max-min)
        bar:SetValue(value - min)
        if(bar.Text) then
            local text = string.format('%s %d/%d', name, value-min, max-min)
            bar.Text:SetText(text)
        end
    end
end

local function Enable(self)
    if(self.Faction) then
        local bar = self.Faction

        self:RegisterEvent('UPDATE_FACTION', Update)

        return true
    end
end

local function Disable(self)
    if(self.Faction) then
        self:UnregisterEvent('UPDATE_FACTION', Update)

        self.Faction:Hide()
    end
end


oUF:AddElement('Faction', Update, Enable, Disable)

