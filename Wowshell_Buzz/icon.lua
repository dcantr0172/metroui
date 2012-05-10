
local Buzz = Buzz
local L = wsLocale:GetLocale('Buzz')
local ICON_PATH = [[Interface\AddOns\Wowshell_Buzz\icons_face\]]
local icons = {
    [L.Angel] = "angel",
    [L.Angry] = "angry",
    [L.Biglaugh] = "biglaugh",
    [L.Clap] = "clap",
    [L.Cool] = "cool",
    [L.Cry] = "cry",
    [L.Cute] = "cutie",
    [L.Despise] = "despise",
    [L.Dreamsmile] = "dreamsmile",
    [L.Embarras] = "embarrass",
    [L.Evil] = "evil",
    [L.Excited] = "excited",
    [L.Faint] = "faint",
    [L.Fight] = "fight",
    [L.Flu] = "flu",
    [L.Freeze] = "freeze",
    [L.Frown] = "frown",
    [L.Greet] = "greet",
    [L.Grimace] = "grimace",
    [L.Growl] = "growl",
    [L.Happy] = "happy",
    [L.Heart] = "heart",
    [L.Horror] = "horror",
    [L.Ill] = "ill",
    [L.Innocent] = "innocent",
    [L.Kongfu] = "kongfu",
    [L.Love] = "love",
    [L.Mail] = "mail",
    [L.Makeup] = "makeup",
    [L.Mario] = "mario",
    [L.Meditate] = "meditate",
    [L.Miserable] = "miserable",
    [L.Okay] = "okay",
    [L.Pretty] = "pretty",
    [L.Puke] = "puke",
    [L.Shake] = "shake",
    [L.Shout] = "shout",
    [L.Silent] = "shuuuu",
    [L.Shy] = "shy",
    [L.Sleep] = "sleep",
    [L.Smile] = "smile",
    [L.Suprise] = "suprise",
    [L.Surrender] = "surrender",
    [L.Sweat] = "sweat",
    [L.Tear] = "tear",
    [L.Tears] = "tears",
    [L.Think] = "think",
    [L.Titter] = "titter",
    [L.Ugly] = "ugly",
    [L.Victory] = "victory",
    [L.Volunteer] = "volunteer",
    [L.Wronged] = "wronged",
}

local raid_icons, RAID_ICON_PATH = {
    ICON_TAG_RAID_TARGET_STAR1, -- rt1
    ICON_TAG_RAID_TARGET_CIRCLE1, -- rt2
    ICON_TAG_RAID_TARGET_DIAMOND1, -- rt3
    ICON_TAG_RAID_TARGET_TRIANGLE1, -- rt4
    ICON_TAG_RAID_TARGET_MOON1, -- rt5
    ICON_TAG_RAID_TARGET_SQUARE1, -- rt6
    ICON_TAG_RAID_TARGET_CROSS1, -- rt7
    ICON_TAG_RAID_TARGET_SKULL1, -- rt8
}, [[Interface\TargetingFrame\UI-RaidTargetingIcon_]]

local toggleButton, iconFrame, createIconContainor
local buttons = {}
do
    local ICONS_PER_ROW = 10
    local ICON_SIZE = 25
    local GAP_SIZE = 3

    local function onClick(self)
        iconFrame:Hide()
        local text = self.name and ('{' .. self.name .. '}')
        if(text) then
            local eb = ACTIVE_CHAT_EDIT_BOX
                       or LAST_ACTIVE_CHAT_EDIT_BOX
                       or ChatFrame1EditBox
                       or ChatFrameEditBox
            if(eb and eb.Insert) then
                eb:Insert(text)
                eb:Show()
                eb:SetFocus()
            end
        end
    end

    local function onUpdate(self, elapsed)
        self.total = (self.total or 1) - elapsed
        if(self.total < 0) then
            self:Hide()
        end
    end

    local function icon_onEnter(self)
        iconFrame:SetScript('OnUpdate', nil)
    end

    local function createIcon(name, raidicon)
        local button = CreateFrame('Button', nil, iconFrame)
        table.insert(buttons, button)
        button.id = #buttons
        button.name = name
        button:SetScript('OnClick', onClick)
        button:SetWidth(ICON_SIZE)
        button:SetHeight(ICON_SIZE)
        button:SetScript('OnEnter', icon_onEnter)

        local icon = button:CreateTexture(nil, 'ARTWORK')
        button.icon = icon
        icon:SetAllPoints(button)
        if(raidicon) then
            icon:SetTexture(RAID_ICON_PATH .. raidicon)
        else
            icon:SetTexture(ICON_PATH .. icons[name])
        end
    end

    function createIconContainor()
        if(not toggleButton) then
            toggleButton = CreateFrame('Button', nil, UIParent)
            iconFrame = CreateFrame('Button', nil, UIParent)
            iconFrame:SetFrameStrata'TOOLTIP'

            for i = 1, #raid_icons do
                createIcon(raid_icons[i], i)
            end
            for k in pairs(icons) do
                createIcon(k)
            end

            local num_buttons = #buttons
            local rows = math.ceil(num_buttons / ICONS_PER_ROW)

            iconFrame:SetHeight(rows * ICON_SIZE + GAP_SIZE * (rows + 1))
            iconFrame:SetWidth(ICONS_PER_ROW * ICON_SIZE + GAP_SIZE * (ICONS_PER_ROW +1))
            iconFrame:SetBackdrop({
                bgFile = [=[Interface\ChatFrame\ChatFrameBackground]=],
                insets = {top = -1, left = -1, bottom = -1, right = -1},
            })
            iconFrame:SetBackdropColor(0,0,0,.8)
            iconFrame:SetScript('OnEnter', function(self)
                self:SetScript('OnUpdate', nil)
            end)
            iconFrame:SetScript('OnLeave', function(self)
                self.total = 1
                self:SetScript('OnUpdate', onUpdate)
            end)
            iconFrame:SetScript('OnShow', function(self)
                self.total = 3
                self:SetScript('OnUpdate', onUpdate)
            end)

            toggleButton:SetHeight(25)
            toggleButton:SetWidth(25)
            toggleButton:SetPoint('TOP', ChatFrameMenuButton, 'BOTTOM', 0, -95)
            toggleButton:SetNormalTexture(ICON_PATH .. 'text_nor_icon')
            toggleButton:SetPushedTexture(ICON_PATH .. 'text_push_icon')
			toggleButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
            toggleButton:SetScript('OnMouseUp', function(self)
                if(iconFrame:IsShown()) then
                    iconFrame:Hide()
                else
                    iconFrame:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT', 5, 0)
                    iconFrame:Show()
                end
            end)
			--toggleButton:SetScript('OnEnter', toggleButton:GetScript'OnMouseUp')


            for i = 1, num_buttons do
                local button = buttons[i]
                local last, inRow
                do
                    inRow = i % ICONS_PER_ROW ~= 1
                    if(inRow) then
                        last = buttons[i - 1]
                    else
                        last = buttons[i - ICONS_PER_ROW]
                    end
                end

                if(last) then -- i~=1
                    if(inRow) then
                        button:SetPoint('TOPLEFT', last, 'TOPRIGHT', GAP_SIZE, 0)
                    else
                        button:SetPoint('TOPLEFT', last, 'BOTTOMLEFT', 0, -GAP_SIZE)
                    end
                else
                    button:SetPoint('TOPLEFT', iconFrame, GAP_SIZE, -GAP_SIZE)
                end
            end
        end
    end

end


local function Enable()
    for k, v in pairs(icons) do
        local icon_path = string.format('|T%s%s:28.', ICON_PATH, v)

        -- 插入ICON_TAG_LIST表
        ICON_TAG_LIST[k] = v

        -- 插入ICON_LIST表
        ICON_LIST[v] = icon_path
    end
    if(not toggleButton) then
        createIconContainor()
    end
    if(toggleButton) then
        toggleButton:Show()
    end
end

local function Disable()
    for k, v in pairs(icons) do
        -- ICON_TAG_LIST
        ICON_TAG_LIST[k] = nil

        -- ICON_LIST
        ICON_LIST[v] = nil
    end
    if(toggleButton) then
        toggleButton:Hide()
        iconFrame:Hide()
    end
end


function Buzz:ToggleBuzzIcon()
    if(self.db.profile.buzzicon) then
        Enable()
    else
        Disable()
    end
end



