function EventAlert_Class_Events_Frame_OnLoad()
	UIPanelWindows["EA_Class_Events_Frame"] = {area = "center", pushable = 0};
end

function EventAlert_Class_Events_Frame_Init()
	EA_Class_Events_Frame_HelpText1:SetText(EX_XCLSALERT_HELP1);
	EA_Class_Events_Frame_HelpText2:SetText(EX_XCLSALERT_HELP2);
	EA_Class_Events_Frame_HelpText3:SetText(EX_XCLSALERT_HELP3);
	EA_Class_Events_Frame_EditBox:SetFontObject(ChatFontNormal);
	EA_Class_Events_Frame_EditBox:SetText(EX_XCLSALERT_SPELLURL);
	EA_Class_Events_Frame_SpellText:SetText(EX_XCLSALERT_SPELL);
	EA_Class_Events_Frame_SpellEditBox:SetFontObject(ChatFontNormal);
	EA_Class_Events_Frame_SpellEditBox:SetText("");

	EA_ClassAlt_Events_Frame_HelpText1:SetText(EX_XCLSALERT_HELP4);
	EA_ClassAlt_Events_Frame_HelpText2:SetText(EX_XCLSALERT_HELP5);
	EA_ClassAlt_Events_Frame_HelpText3:SetText(EX_XCLSALERT_HELP6);
	EA_ClassAlt_Events_Frame_SpellText:SetText(EX_XCLSALERT_SPELL);
	EA_ClassAlt_Events_Frame_SpellEditBox:SetFontObject(ChatFontNormal);
	EA_ClassAlt_Events_Frame_SpellEditBox:SetText("");

	CreateFrames_EventsFrame_CreateScrollFrame(EA_Class_Events_Frame, 300, 15, -55);
end

function EventAlert_Class_Events_Frame_MouseDown(button)
	-- if button == "LeftButton" then
	--     EA_Class_Events_Frame:StartMoving();
	-- end
end

function EventAlert_Class_Events_Frame_MouseUp(button)
	-- if button == "LeftButton" then
	--     EA_Class_Events_Frame:StopMovingOrSizing();
	-- end
end
