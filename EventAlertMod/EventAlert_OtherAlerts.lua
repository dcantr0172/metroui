function EventAlert_Other_Events_Frame_OnLoad()
	UIPanelWindows["EA_Other_Events_Frame"] = {area = "center", pushable = 0};
end

function EventAlert_Other_Events_Frame_Init()
	-- EA_Other_Events_Frame_HelpText1:SetText(EX_XCLSALERT_HELP1);
	-- EA_Other_Events_Frame_HelpText2:SetText(EX_XCLSALERT_HELP2);
	-- EA_Other_Events_Frame_HelpText3:SetText(EX_XCLSALERT_HELP3);
	-- EA_Other_Events_Frame_EditBox:SetFontObject(ChatFontNormal);
	-- EA_Other_Events_Frame_EditBox:SetText(EX_XCLSALERT_SPELLURL);
	EA_Other_Events_Frame_SpellText:SetText(EX_XCLSALERT_SPELL);
	EA_Other_Events_Frame_SpellEditBox:SetFontObject(ChatFontNormal);
	EA_Other_Events_Frame_SpellEditBox:SetText("");

	CreateFrames_EventsFrame_CreateScrollFrame(EA_Other_Events_Frame, 375, 15, -55);
end

function EventAlert_Other_Events_Frame_MouseDown(button)
	-- if button == "LeftButton" then
	--     Other_Events_Frame:StartMoving();
	-- end
end

function EventAlert_Other_Events_Frame_MouseUp(button)
	-- if button == "LeftButton" then
	--     Other_Events_Frame:StopMovingOrSizing();
	-- end
end
