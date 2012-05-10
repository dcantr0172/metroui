
local L = setmetatable(GetLocale() == 'zhCN' and {
    ['New Mail!'] = '有新邮件',
    ['No Mail'] = '无邮件',
} or GetLocale() == 'zhTW' and {
    ['New Mail!'] = '有新郵件',
    ['No Mail'] = '無郵件',
} or {}, {__index = function(t, i)
    t[i] = i
    return i
end})

local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('Broker_Mail', {
    type = 'data source',
    text = '...',
    icon = 'Interface\\Minimap\\Tracking\\mailbox',
})


local f = CreateFrame'Frame'

local updateMail = function()
    dataobj.text = HasNewMail() and L['New Mail!'] or L['No Mail']
end

dataobj.OnClick = function()
    updateMail()
end

f:SetScript('OnEvent', updateMail)
f:RegisterEvent'PLAYER_ENTERING_WORLD'
f:RegisterEvent'UPDATE_PENDING_MAIL'
f:RegisterEvent'MAIL_CLOSED'

