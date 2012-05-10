local parent, ns = ...
local oUF = ns.oUF

local function Update(self, event, unit)
    if(unit and unit~=self.unit) then
        return
    end

    local bar = self.Exp
    if(bar.PreUpdate) then
        bar:PreUpdate(event, unit)
    end

    local cur = UnitXP(self.unit)
    local max = UnitXPMax(self.unit)
    local rest = GetXPExhaustion(self.unit) or 0
    rest = rest and rest/2

    bar:SetMinMaxValues(0, max)
    bar:SetValue(cur)
    if(bar.bg) then
        local displayRest = math.min((cur+rest)/max, 1)
        bar.bg:SetWidth(displayRest == 0 and bar:GetWidth() or displayRest * bar:GetWidth())
    end

    if(bar.Text) then
        local text
        if(rest) then
            text = format('%d / %d (%d)', cur, max, rest)
        else
            text = format('%d /%d', cur, max)
        end

        bar.Text:SetText(text)
    end

    if(bar.PostUpdate) then
        bar:PostUpdate(event, unit, cur, max, rest)
    end
end

-- for ouf 1.5
--local function proxy(self, event, unit)
--    if(self.Exp.Update) then
--    end
--end

local events = {
    'PLAYER_XP_UPDATE',
    'UPDATE_EXHAUSTION',
    'PLAYER_LEVEL_UP',
    'UNIT_LEVEL',
}

local function Enable(self)
    if(self.Exp) then
        for _, e in ipairs(events) do
            self:RegisterEvent(e, Update)
        end

        if(self.Exp.bg) then
            local bar = self.Exp
            bar.bg:ClearAllPoints()
            bar.bg:SetPoint('TOPLEFT', bar)
            bar.bg:SetPoint('BOTTOMLEFT', bar)
        end

        self.Exp.__own = self

        if(not self.Exp:GetStatusBarTexture()) then
			self.Exp:SetStatusBarTexture[[Interface\TargetingFrame\UI-StatusBar]]
        end

        return true
    end
end

local function Disable(self)
    if(self.Exp) then
        for _, e in ipairs(events) do
            self:UnregisterEvent(e, Update)
        end
        self.Exp:Hide()
    end
end


oUF:AddElement('Exp', Update, Enable, Disable)
