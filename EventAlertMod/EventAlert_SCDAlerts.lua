function EventAlert_SCD_Events_Frame_OnLoad()
	UIPanelWindows["EA_SCD_Events_Frame"] = {area = "center", pushable = 0};
end

function EventAlert_SCD_Events_Frame_Init()
	-- EA_SCD_Events_Frame_HelpText1:SetText(EX_XCLSALERT_HELP1);
	-- EA_SCD_Events_Frame_HelpText2:SetText(EX_XCLSALERT_HELP2);
	-- EA_SCD_Events_Frame_HelpText3:SetText(EX_XCLSALERT_HELP3);
	-- EA_SCD_Events_Frame_EditBox:SetFontObject(ChatFontNormal);
	-- EA_SCD_Events_Frame_EditBox:SetText(EX_XCLSALERT_SPELLURL);
	EA_SCD_Events_Frame_SpellText:SetText(EX_XCLSALERT_SPELL);
	EA_SCD_Events_Frame_SpellEditBox:SetFontObject(ChatFontNormal);
	EA_SCD_Events_Frame_SpellEditBox:SetText("");

	CreateFrames_EventsFrame_CreateScrollFrame(EA_SCD_Events_Frame, 375, 15, -55);
end

function EventAlert_SCD_Events_Frame_MouseDown(button)
	-- if button == "LeftButton" then
	--     SCD_Events_Frame:StartMoving();
	-- end
end

function EventAlert_SCD_Events_Frame_MouseUp(button)
	-- if button == "LeftButton" then
	--     SCD_Events_Frame:StopMovingOrSizing();
	-- end
end
