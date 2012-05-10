function EventAlert_Options_OnLoad()
	UIPanelWindows["EA_Options_Frame"] = {area = "center", pushable = 0};
end

function EAFun_SetButtonState(button, state)
	if state == 1 then
		button:SetButtonState("PUSHED", true);
	else
		button:SetButtonState("NORMAL", false);
	end
end

function EventAlert_Options_Init()
	EA_Options_Frame_Header_Text:SetFontObject(GameFontNormal);
	EA_Options_Frame_Header_Text:SetText("EventAlertMod Options");
	EA_Options_Frame_VerUrlText:SetText(EA_XOPT_VERURLTEXT);

	EA_Options_Frame_DoAlertSound:SetChecked(EA_Config.DoAlertSound);
	EA_Options_Frame_ShowFrame:SetChecked(EA_Config.ShowFrame);
	EA_Options_Frame_ShowName:SetChecked(EA_Config.ShowName);
	EA_Options_Frame_ShowFlash:SetChecked(EA_Config.ShowFlash);
	EA_Options_Frame_ShowTimer:SetChecked(EA_Config.ShowTimer);
	EA_Options_Frame_ChangeTimer:SetChecked(EA_Config.ChangeTimer);
	EA_Options_Frame_AllowESC:SetChecked(EA_Config.AllowESC);
	EA_Options_Frame_AltAlerts:SetChecked(EA_Config.AllowAltAlerts);

	-- EA_Options_Frame_ToggleClassEvents:Disable();
	local sTexturePath = "Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-BlueButton-Down";
	EA_Options_Frame_ToggleIconOptions:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleClassEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleOtherEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleTargetEvents:SetPushedTexture(sTexturePath);
	EA_Options_Frame_ToggleSCDEvents:SetPushedTexture(sTexturePath);

	-- EA_SpellCondition_Frame_StackText:SetText(EA_XOPT_SPELLCOND_STACK);
	-- EA_SpellCondition_Frame_SelfText:SetText(EA_XOPT_SPELLCOND_SELF);
	-- EA_SpellCondition_Frame_OverGrowText:SetText(EA_XOPT_SPELLCOND_OVERGROW);
end

function EventAlert_Options_ToggleIconOptionsFrame()
	EA_SpellCondition_Frame:Hide();
	if EA_Icon_Options_Frame:IsVisible() then
		EA_Icon_Options_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
	else
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end

		EA_Icon_Options_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	end
end

function EventAlert_Options_ToggleClassEventsFrame()
	EA_SpellCondition_Frame:Hide();
	if EA_Class_Events_Frame:IsVisible() then
		EA_Class_Events_Frame:Hide();
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end

		EA_Class_Events_Frame:Show();
		if (EA_Config.AllowAltAlerts == true) then
			EA_ClassAlt_Events_Frame:Show();
		else
			EA_ClassAlt_Events_Frame:Hide();
		end
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	end
end

function EventAlert_Options_ToggleOtherEventsFrame()
	EA_SpellCondition_Frame:Hide();
	if EA_Other_Events_Frame:IsVisible() then
		EA_Other_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end

		EA_Other_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	end
end

function EventAlert_Options_ToggleTargetEventsFrame()
	EA_SpellCondition_Frame:Hide();
	if EA_Target_Events_Frame:IsVisible() then
		EA_Target_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_SCD_Events_Frame:IsVisible() then EA_SCD_Events_Frame:Hide(); end

		EA_Target_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 1);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	end
end

function EventAlert_Options_ToggleSCDEventsFrame()
	EA_SpellCondition_Frame:Hide();
	if EA_SCD_Events_Frame:IsVisible() then
		EA_SCD_Events_Frame:Hide();
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 0);
	else
		if EA_Icon_Options_Frame:IsVisible() then EA_Icon_Options_Frame:Hide(); end
		if EA_Class_Events_Frame:IsVisible() then EA_Class_Events_Frame:Hide(); end
		if EA_ClassAlt_Events_Frame:IsVisible() then EA_ClassAlt_Events_Frame:Hide(); end
		if EA_Other_Events_Frame:IsVisible() then EA_Other_Events_Frame:Hide(); end
		if EA_Target_Events_Frame:IsVisible() then EA_Target_Events_Frame:Hide(); end

		EA_SCD_Events_Frame:Show();
		EAFun_SetButtonState(EA_Options_Frame_ToggleIconOptions, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleClassEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleOtherEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleTargetEvents, 0);
		EAFun_SetButtonState(EA_Options_Frame_ToggleSCDEvents, 1);
	end
end

function EventAlert_Options_CloseAnchorFrames()
	EA_SpellCondition_Frame:Hide();
	if EA_Anchor_Frame1 ~= nil then
		EA_Anchor_Frame1:Hide();
		EA_Anchor_Frame2:Hide();
		EA_Anchor_Frame3:Hide();
		EA_Anchor_Frame4:Hide();
		EA_Anchor_Frame5:Hide();
		EA_Anchor_Frame6:Hide();
		EA_Anchor_Frame7:Hide();
		EA_Options_Frame_ToggleIconOptions:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleClassEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleOtherEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleTargetEvents:SetButtonState("NORMAL", false);
		EA_Options_Frame_ToggleSCDEvents:SetButtonState("NORMAL", false);
	end
end



function EventAlert_Options_AlertSoundSelect_OnLoad()
	UIDropDownMenu_Initialize(EA_Options_Frame_AlertSoundSelect, EventAlert_Options_AlertSoundSelect_Initialize);
	UIDropDownMenu_SetSelectedID(EA_Options_Frame_AlertSoundSelect, EA_Config.AlertSoundValue);
	UIDropDownMenu_SetWidth(EA_Options_Frame_AlertSoundSelect, 130);
end


function EventAlert_Options_AlertSoundSelect_Initialize()
	local selectedValue = UIDropDownMenu_GetSelectedValue(EA_Options_Frame_AlertSoundSelect);
	if selectedValue == nil then selectedValue = 0 end;

	local info = {};
	local function AddItem(text, value)
		info.text = text;
		info.func = EventAlert_Options_AlertSoundSelect_OnClick;
		info.value = value;
		if (info.value == selectedValue) then
			info.checked = 1;
		end
		info.checked = checked
		UIDropDownMenu_AddButton(info)
	end

	AddItem("ShaysBell", 1);
	AddItem("Flute", 2);
	AddItem("Netherwind", 3);
	AddItem("PolyCow", 4);
	AddItem("Rockbiter", 5);
	AddItem("Yarrrr!", 6);
	AddItem("Broken Heart", 7);
	AddItem("Millhouse 1!", 8);
	AddItem("Millhouse 2!", 9);
	AddItem("Pissed Satyr", 10);
	AddItem("Pissed Dwarf", 11);
end


function EventAlert_Options_AlertSoundSelect_OnClick(self)
	local SelValue = self.value;
	if SelValue == nil then SelValue = 0 end;
	UIDropDownMenu_SetSelectedValue(EA_Options_Frame_AlertSoundSelect, SelValue);

	if (SelValue == 1) then
		EA_Config.AlertSound = "Sound\\Spells\\ShaysBell.wav";
	elseif (SelValue == 2) then
		EA_Config.AlertSound = "Sound\\Spells\\FluteRun.wav";
	elseif (SelValue == 3) then
		EA_Config.AlertSound = "Sound\\Spells\\NetherwindFocusImpact.wav";
	elseif (SelValue == 4) then
		EA_Config.AlertSound = "Sound\\Spells\\PolyMorphCow.wav";
	elseif (SelValue == 5) then
		EA_Config.AlertSound = "Sound\\Spells\\RockBiterImpact.wav";
	elseif (SelValue == 6) then
		EA_Config.AlertSound = "Sound\\Spells\\YarrrrImpact.wav";
	elseif (SelValue == 7) then
		EA_Config.AlertSound = "Sound\\Spells\\valentines_brokenheart.wav";
	elseif (SelValue == 8) then
		EA_Config.AlertSound = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Ready01.wav";
	elseif (SelValue == 9) then
		EA_Config.AlertSound = "Sound\\Creature\\MillhouseManastorm\\TEMPEST_Millhouse_Pyro01.wav";
	elseif (SelValue == 10) then
		EA_Config.AlertSound = "Sound\\Creature\\Satyre\\SatyrePissed4.wav";
	elseif (SelValue == 11) then
		EA_Config.AlertSound = "Sound\\Creature\\Mortar Team\\MortarTeamPissed9.wav";
	end
	EA_Config.AlertSoundValue = SelValue;
	PlaySoundFile(EA_Config.AlertSound);
end

function EventAlert_Options_MouseDown(button)
	if button == "LeftButton" then
		EA_Options_Frame:StartMoving();
	end
end

function EventAlert_Options_MouseUp(button)
	if button == "LeftButton" then
		EA_Options_Frame:StopMovingOrSizing();
	end
end