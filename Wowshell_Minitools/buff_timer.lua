--[[
--          Author: yaroot at no fucking spam gmail dot com
--          Copyright owner: Wowshell, All Rights Reserved
--]]

local AceLocale = LibStub('AceLocale-3.0')
do
    local L = AceLocale:NewLocale('IceBuff', 'enUS', true)
    L['Buff timer'] = true
    L['Buff timer text'] = true
    L['Enable'] = true
end
do
    local L = AceLocale:NewLocale('IceBuff', 'zhCN')
    if(L) then
        L['Buff timer'] = 'Buff计时增强'
        L['Buff timer text'] = '增强Buff计时文字'
        L['Enable'] = '启用'
    end
end
do
    local L = AceLocale:NewLocale('IceBuff', 'zhTW')
    if(L) then
        L['Buff timer'] = 'Buff計時增強'
        L['Buff timer text'] = '增強Buff計時文字'
        L['Enable'] = '啟用'
    end
end

local icebuff = LibStub('AceAddon-3.0'):NewAddon('IceBuff', 'AceHook-3.0')
local L = AceLocale:GetLocale('IceBuff')

function icebuff:OnInitialize()
    local defaults = {
        char = {
            enabled = true,
        }
    }
    self.acedb = LibStub('AceDB-3.0'):New('WS_BUFF', defaults)
    self.db = self.acedb.char

    --self:SetupOptions()
    if(not self.db.enabled) then
        self:Disable()
    end
end

function icebuff:OnEnable()
--    hooksecurefunc('AuraButton_Update', function(...) icebuff:AuraButton_Update(...) end)
--    hooksecurefunc('AuraButton_UpdateDuration', function(...) icebuff:AuraButton_UpdateDuration(...) end)

    self:SecureHook('AuraButton_Update', 'AuraButton_Update')
    self:SecureHook('AuraButton_UpdateDuration', 'AuraButton_UpdateDuration')
end

function icebuff:OnDisable()
    self:UnhookAll()
end

--function onUpdate(self, elapsed)
--end

function icebuff:AuraButton_Update(buttonName, index, filter)
    local unit = PlayerFrame.unit
    local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura(unit, index, filter)
    if(not name) then return end

    local button = _G[buttonName .. index]
    if(not button) then return end

    if(duration > 0) and expirationTime then
        -- pass
    else
        if(SHOW_BUFF_DURATIONS == '1') then
            --button.duration:SetText('|cff00ff00N/A|r')
            button.duration:SetText('N/A')
            icebuff:SetColor(button.duration, GREEN_FONT_COLOR)
            button.duration:Show()
        end
    end
end

do
    local HOUR = 60*60
    local MINUTE = 60
    local SEC = 1
    local TEN_MIN = 10 * 60

    local F_HOUR = '%dh'
    local F_MINUTE = '%dm'
    local F_SEC = '%ds'
    local F_TEN_MIN = '%d:%02d'
    local F_HOUR = '%d:%02d:%02d'

    function icebuff:GetFormattedTime(t)
        --if(s >= HOUR) then
        --    return F_HOUR:format(s / HOUR), GREEN_FONT_COLOR
        --elseif(s >= TEN_MIN) then
        --    return F_MINUTE:format(s / MINUTE), GREEN_FONT_COLOR

        if(t >= HOUR) then
            local h, m, s
            h = floor(t / HOUR)
            m = floor( (t%HOUR) / MINUTE )
            s = floor(t % MINUTE)
            return F_HOUR:format(h, m, s), GREEN_FONT_COLOR
        elseif(t >= MINUTE) then
            return F_TEN_MIN:format(t / MINUTE, t % MINUTE), t>=TEN_MIN and GREEN_FONT_COLOR or NORMAL_FONT_COLOR
        else
            local remain = floor(t+1)
            if(remain >= 1) then
                return F_SEC:format(remain), RED_FONT_COLOR
            else
                return nil
            end
        end
    end
end

function icebuff:SetColor(t, c)
    if(c) then
        t:SetVertexColor(c.r, c.g, c.b)
    end
end

function icebuff:AuraButton_UpdateDuration(auraButton, timeLeft)
    local duration = auraButton.duration
    if(SHOW_BUFF_DURATIONS == '1' and timeLeft) then
        local t, c = icebuff:GetFormattedTime(timeLeft)
        duration:SetText(t)
        icebuff:SetColor(duration, c)
    end
end


--function icebuff:SetupOptions()
--    local __order = 0
--    local getOrder = function()
--        __order = __order + 1
--        return __order
--    end
--
--    wsRegisterOption(
--        'Interface',
--        'wsBuffTimer',
--        L['Buff timer'],
--        L['Buff timer text'],
--        [[Interface\icons\inv_jewelry_necklace_22]],
--        {
--            type = 'group',
--            args = {
--                enable = {
--                    type = 'toggle',
--                    order = getOrder(),
--                    name = L['Enable'],
--                    get = function() return self.db.enabled end,
--                    set = function(_,v)
--                        self.db.enabled = v
--                        if(v) then
--                            self:Enable()
--                        else
--                            self:Disable()
--                        end
--                    end
--                }
--            }
--        }
--    )
--end

