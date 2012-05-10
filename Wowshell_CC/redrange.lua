
local _, ns = ...
local RedRange = ns.CC:NewModule('RedRange', 'AceEvent-3.0', 'AceHook-3.0')
_G.RedRange = RedRange

local UPDATE_DELAY = 0.4
local COLORS = {
    normal = { 1, 1, 1 },
    oom = { .25, .25, .5 }, -- this one is from blizzard
    --oom = { .1, .3, .1 },
    oor = { .8, .1, .1 },
}

function RedRange:OnInitialize()
    self.db = ns.CC.db
    self.pool = {}
end

function RedRange:OnEnable()
    self:RegisterEvent('PLAYER_TARGET_CHANGED', 'UpdateAllButtons')
    self:SecureHook('ActionButton_OnUpdate', 'EnableButton')
    self:SecureHook('ActionButton_UpdateUsable', 'EnableButton')
    self:SecureHook('ActionButton_Update', 'EnableButton')
    self:EnableUpdate()

    self:UpdateAllButtons()
end

function RedRange:OnDisable()
    self:UnregisterEvent('PLAYER_TARGET_CHANGED', 'UpdateAllButtons')
    self:DisableUpdate()
end

function RedRange:UpdateButton(btn, state)
--    if(btn.__wsrr_state ~= state) then
        btn.__wsrr_state = state
        local c = COLORS[state]
        if(c) then
					if btn.__wsrr_icon then
            btn.__wsrr_icon:SetVertexColor(unpack(c))
					end
					if btn.__wsrr_normal then
            btn.__wsrr_normal:SetVertexColor(unpack(c))
					end
        end
    --end
end

function RedRange:CheckState(btn)
    local action = ActionButton_GetPagedID(btn)
    local isUsable, notEnoughMana = IsUsableAction(action)

    if(isUsable) then
        if(IsActionInRange(action) == 0) then
            self:UpdateButton(btn, 'oor')
        else
            self:UpdateButton(btn, 'normal')
        end
    elseif(notEnoughMana) then
        self:UpdateButton(btn, 'oom')
    else
        -- unusable
    end
end

function RedRange:UpdateAllButtons()
    for btn in next, self.pool do
        self:CheckState(btn)
    end
end


local function onUpdate(self, elapsed)
    self.nextUpdate = self.nextUpdate - elapsed
    if(self.nextUpdate > 0) then return end
    self.nextUpdate = UPDATE_DELAY

    RedRange:UpdateAllButtons()
end

function RedRange:EnableUpdate()
    self.updateFrame = self.updateFrame or CreateFrame'Frame'
    self.updateFrame.nextUpdate = 1
    self.updateFrame:SetScript('OnUpdate', onUpdate)
end

function RedRange:DisableUpdate()
    if(self.updateFrame) then
        self.updateFrame:Hide()
        self.updateFrame:SetScript('OnUpdate', nil)
    end
end

local function onShow(btn)
    RedRange.pool[btn] = true
    RedRange:CheckState(btn)
end
local function onHide(btn)
    RedRange.pool[btn] = nil
end

function RedRange:CheckUsage(btn)
    if(btn:IsShown()) then
        onShow(btn)
    else
        onHide(btn)
    end
end

function RedRange:EnableButton(btn)
    if(btn.__wsrr_hooked) then
        self:CheckUsage(btn)
    else
        btn.__wsrr_icon = _G[btn:GetName() .. 'Icon']
        btn.__wsrr_normal = btn:GetNormalTexture()

        btn:SetScript('OnUpdate', nil)
        btn:HookScript('OnShow', onShow)
        btn:HookScript('OnHide', onHide)

        btn.__wsrr_hooked = true
    end
end

