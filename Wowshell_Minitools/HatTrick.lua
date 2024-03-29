
local GameTooltip = GameTooltip

local L = {
--	helmtip = "Toggles helmet model.",
--	cloaktip = "Toggles cloak model.",
    helmtip = SHOW_HELM,
    cloaktip = SHOW_CLOAK,
}


local hcheck = CreateFrame("CheckButton", "HelmCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
hcheck:ClearAllPoints()
hcheck:SetWidth(22)
hcheck:SetHeight(22)
hcheck:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 5, 5)
hcheck:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
hcheck:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L.helmtip)
end)
hcheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
hcheck:SetScript("OnEvent", function() hcheck:SetChecked(ShowingHelm()) end)
hcheck:RegisterEvent("UNIT_MODEL_CHANGED")
hcheck:SetToplevel(true)


local ccheck = CreateFrame("CheckButton", "CloakCheckBox", PaperDollFrame, "OptionsCheckButtonTemplate")
ccheck:ClearAllPoints()
ccheck:SetWidth(22)
ccheck:SetHeight(22)
--ccheck:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 5)
ccheck:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 5, 30)
ccheck:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
ccheck:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText(L.cloaktip)
end)
ccheck:SetScript("OnLeave", function() GameTooltip:Hide() end)
ccheck:SetScript("OnEvent", function() ccheck:SetChecked(ShowingCloak()) end)
ccheck:RegisterEvent("UNIT_MODEL_CHANGED")
ccheck:SetToplevel(true)


hcheck:SetChecked(ShowingHelm())
ccheck:SetChecked(ShowingCloak())
