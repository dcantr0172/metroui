------------------------------------------------
--- Feed Pet -----------------------------------
------------------------------------------------
if(not IceHunex) then return end

local feedme = IceHunex:NewModule("FeedMe", "AceEvent-3.0");
local db;
local L = wsLocale:GetLocale("IceHunex")

local defaults = {
	profile = {
		enable = true,
		locked = true,
		alphaShow = true,
	},
	char = {
		petFeedList = {},
	},
}

local options = nil
local function getoptions()
	if not options then
		options = {
			type = "group",
			name = L["一键喂食"],
			guiInline = true,
			order = 1,
			args = {
				enabled = {
					type = "toggle",
					name = L["启用"],
					desc = L["启用一键喂食"],
					get = function() return db.enable end,
					set = function(_, v)
						db.enable = v
						if v then
							feedme:Enable()
						else
							feedme:Disable()
						end
					end
				}
			},
		}
	end
	return options
end

function feedme:OnInitialize()
	self.db = IceHunex.db:RegisterNamespace("feedme", defaults);
	db = self.db.profile

	self:CreatePetFeedButton();
	self:SetEnabledState(db.enable)
	IceHunex:RegisterModuleOptions("feedme", getoptions())
end

function feedme:OnEnable()
	self:RegisterEvent("BAG_UPDATE");
	self:RegisterEvent("UNIT_HAPPINESS");
	--update
	self:UpdatePetFeedButton()
	RegisterStateDriver(self.PetFeedButton, 'visibility', '[target=vehicle, noexists]show;hide')
	if db.enable then
		self.PetFeedButton:Show()
	end
end

function feedme:OnDisable()
	if self.PetFeedButton then self.PetFeedButton:Hide() end
	self:UnregisterAllEvents();
	UnregisterStateDriver(self.PetFeedButton, 'visibility')
end

function feedme:CreatePetFeedButton()
	--onevent, onenter onleave preclcick OnReceiveDrag
	local function OnReceiveDrag(self)
		if InCombatLockdown() == "1" then return end--ps: in combat cannt set pet feed
		if (GetCursorInfo() and GetCursorInfo() == "item") then
			local _, itemId = GetCursorInfo();
			local name, link,_,_,_, Itemtype, subType, maxStack,_, icon = GetItemInfo(itemId);
			if not feedme.db.char.petFeedList then feedme.db.char.petFeedList = {} end
			feedme.db.char.petFeedList.Link = link;
			feedme.db.char.petFeedList.name = name
			if icon then
				feedme.db.char.petFeedList.icon = icon
				SetItemButtonTexture(self, icon)
			end
			GameTooltip:Hide()
			feedme:UNIT_HAPPINESS(nil, "pet")
			ClearCursor();
			feedme:UpdateItemCount(self)
			feedme:UpdatePetFeedButton()
		end
	end

	local function PreClick(self)
		if not feedme.db.char.petFeedList.Link then return end
		if InCombatLockdown() then return end
		GameTooltip:Hide()
		feedme:UpdateItemCount(self)
	end

	local function OnEnter(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		if not feedme.db.char.petFeedList.Link then
			GameTooltip:SetText(L["快速宠物喂食"]);
			GameTooltip:AddLine(L["没有选定宠物食物"]);
		else
			GameTooltip:ClearLines()
			GameTooltip:SetText(L["快速宠物喂食"]);
			GameTooltip:SetHyperlink(feedme.db.char.petFeedList.Link)
			--GameTooltip:AddDoubleLine("食物: ", feedme.db.char.petFeedList.Link, 1,1,1,1,1,1)
			--GameTooltip:AddDoubleLine("数量: ", feedme.db.char.petFeedList.count, 1, 1, 1, 1, 1, 1)
		end

		GameTooltip:Show()
	end

	local function OnLeave(self)
		GameTooltip:Hide()
	end

	local function OnDragStart(self)
		--dont work in combat
		if InCombatLockdown() == "1" then return end
		if db.locked then return end
		feedme.db.char.petFeedList = nil
		feedme.db.char.petFeedList = {}

		SetItemButtonCount(self, 0);
		SetItemButtonTexture(self, nil);
		feedme:UNIT_HAPPINESS(nil, "pet")
		GameTooltip:Hide()
	end

	if not self.PetFeedButton then
		local button = CreateFrame("Button", "wsQuickFeedButton", UIParent, "ItemButtonTemplate, SecureActionButtonTemplate");

		button:SetMovable(true)
        local _size = 36
		button:SetWidth(36)
		button:SetHeight(36);
		button:SetNormalTexture([[Interface\Buttons\UI-Quickslot2]]);
		button:RegisterForDrag("LeftButton")
		self.PetFeedButton = button
		self:UpdateButtonAnchor()
	end

	self.PetFeedButton:SetScript("OnEnter", OnEnter);
	self.PetFeedButton:SetScript("OnReceiveDrag", OnReceiveDrag);
	self.PetFeedButton:SetScript("PreClick", PreClick);
	self.PetFeedButton:SetScript("OnLeave", OnLeave);
	self.PetFeedButton:SetScript("OnDragStart", OnDragStart);
	self.PetFeedButton:Hide();
end

function feedme:UpdateButtonAnchor()
    --	if IsAddOnLoaded("Wowshell_UnitFrame") then
    --		--local wsuf = LibStub("AceAddon-3.0"):GetAddon("wsUnitFrame")
    --		--if IceUF.modules.Pet.db.profile.enabled then
    --		--	self.PetFeedButton:SetPoint("LEFT", PetFrame, "RIGHT", 106, -5)
    --		--else
    --		--	self.PetFeedButton:SetPoint("LEFT", PetFrame, "RIGHT", 22, -5)
    --		--end
    --        if(wsUnitFrame and wsUnitFrame.db.profile.enabled) then
    --        else
    --            self.PetFeedButton:SetPoint('LEFT', PetFrame, 'RIGHT', 22, -5)
    --        end
    --	else
    --    local petFrame = wsUnitFrame and wsUnitFrame.units and wsUnitFrame.units.pet
    --    if(petFrame) then
    --        self.PetFeedButton:ClearAllPoints()
    --        self.PetFeedButton:SetParent(petFrame)
    --        self.PetFeedButton:SetPoint('LEFT', petFrame, 'RIGHT', 30, 0)
    --    else
    --        petFrame = PetFrame
    self.PetFeedButton:SetParent(PetFrame)
    self.PetFeedButton:ClearAllPoints()
    self.PetFeedButton:SetPoint("LEFT", PetFrame, "RIGHT", 86, 0)
    --    end
    --  end
end

function feedme:BAG_UPDATE()
	if InCombatLockdown() then return end
	self:UpdateItemCount(self.PetFeedButton);
	self:UpdatePetFeedButton();
end

function feedme:UpdateItemCount(button)
	if (self.db.char.petFeedList.Link) then
		local currentCount = findItemInBagByLink(self.db.char.petFeedList.Link);
		self.db.char.petFeedList.count = currentCount
		SetItemButtonCount(button, self.db.char.petFeedList.count);
		if (self.db.char.petFeedList.count and self.db.char.petFeedList.count == 0) then
			getglobal(button:GetName().."IconTexture"):SetVertexColor(1, 0.1, 0.1);
		else
			getglobal(button:GetName().."IconTexture"):SetVertexColor(1, 1, 1);
		end
	end
end

local function link2id(link)
    if(link) then
        local id = link:match'item:(%d+)'
        if(id) then
            return tonumber(id)
        end
    end
end

local function findItemInBagByLink(link)
    local want = link2id(link)

    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if(link and link2id(link)==want) then
                return bag, slot
            end
        end
    end

    return false, false
end

--update button attribute
function feedme:UpdatePetFeedButton()
	if not self.PetFeedButton then return end
	--防止战斗中重新载入
	if InCombatLockdown() then return end

	local button = self.PetFeedButton
	button:SetAttribute("unit", "pet");
	button:SetAttribute("type", "target");

	local bag, slot = findItemInBagByLink(self.db.char.petFeedList.Link);
	--6991 喂养宠物
	local spellName = GetSpellInfo(6991)
	--PickupContainerItem
	if (bag and slot) then
		--self:Print(bag,slot)
		button:SetAttribute("type1", "spell");
		button:SetAttribute("spell1", spellName);
		button:SetAttribute("target-bag", bag)
		button:SetAttribute("target-slot", slot)
	else
		button:SetAttribute("type", ATTRIBUTE_NOOP)
		button:SetAttribute("spell", ATTRIBUTE_NOOP)
		button:SetAttribute("type1", ATTRIBUTE_NOOP)
		button:SetAttribute("spell1", ATTRIBUTE_NOOP)
		button:SetAttribute("target-bag", nil)
		button:SetAttribute("target-slot", nil)
	end

	if self.db.char.petFeedList.Link then
		SetItemButtonTexture(button, self.db.char.petFeedList.icon)
	end

	self:UpdateItemCount(button)
end

function feedme:UNIT_HAPPINESS(event, unit)
	if unit ~= "pet" then return end
	if not db.alphaShow then return end

	local happiness = GetPetHappiness()
	if (happiness and happiness < 3) then
		self.PetFeedButton:SetAlpha(1)
	else
		if (self.db.char.petFeedList.Link) then
			self.PetFeedButton:SetAlpha(0.2)
		else
			self.PetFeedButton:SetAlpha(1)
		end
	end
end
