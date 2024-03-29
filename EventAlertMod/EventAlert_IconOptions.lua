function EventAlert_Icon_Options_Frame_OnLoad()
	UIPanelWindows["EA_Icon_Options_Frame"] = {area = "center", pushable = 0};
end

function EventAlert_Icon_Options_Frame_Init()
	EA_Icon_Options_Frame_LockFrame:SetChecked(EA_Config.LockFrame);
	EA_Icon_Options_Frame_IconSize:SetValue(EA_Config.IconSize);
	EA_Icon_Options_Frame_IconXOffset:SetValue(EA_Position.xOffset);
	EA_Icon_Options_Frame_IconYOffset:SetValue(EA_Position.yOffset);
	EA_Icon_Options_Frame_IconRedDebuff:SetValue((EA_Position.RedDebuff * 100) - 50);
	EA_Icon_Options_Frame_IconGreenDebuff:SetValue((EA_Position.GreenDebuff * 100) - 50);
	EA_Icon_Options_Frame_IconExecution:SetValue(EA_Position.Execution);
	EA_Icon_Options_Frame_PlayerLv2BOSS:SetChecked(EA_Position.PlayerLv2BOSS);
	-- EA_Icon_Options_Frame_Tar_IconXOffset:SetValue(EA_Position.Tar_xOffset);
	-- EA_Icon_Options_Frame_Tar_IconYOffset:SetValue(EA_Position.Tar_yOffset);
	-- EA_Icon_Options_Frame_Tar_NewLine:SetChecked(EA_Position.Tar_NewLine);
	EA_Icon_Options_Frame_SpecFlag_HolyPower:SetChecked(EA_SpecFlag.HolyPower);
	EA_Icon_Options_Frame_SpecFlag_RunicPower:SetChecked(EA_SpecFlag.RunicPower);
	EA_Icon_Options_Frame_SpecFlag_SoulShards:SetChecked(EA_SpecFlag.SoulShards);
	EA_Icon_Options_Frame_SpecFlag_Eclipse:SetChecked(EA_SpecFlag.Eclipse);
	EA_Icon_Options_Frame_SpecFlag_ComboPoint:SetChecked(EA_SpecFlag.ComboPoint);
	EA_Icon_Options_Frame_SpecFlag_Lifebloom:SetChecked(EA_SpecFlag.Lifebloom);
end

function EventAlert_Icon_Options_Frame_ToggleAlertFrame()
	if EA_Anchor_Frame1:IsVisible() then
		EA_Anchor_Frame1:Hide();
		EA_Anchor_Frame2:Hide();
		EA_Anchor_Frame3:Hide();
		EA_Anchor_Frame4:Hide();
		EA_Anchor_Frame5:Hide();
		EA_Anchor_Frame6:Hide();
		EA_Anchor_Frame7:Hide();
	else
		if (EA_Config.ShowFrame == true) then
			EA_Anchor_Frame1:Show();
			EventAlert_Icon_Options_Frame_PaintAlertFrame();
		end

		if (EA_Config.ShowFlash == true) then
			UIFrameFadeIn(LowHealthFrame, 1, 0, 1);
			UIFrameFadeOut(LowHealthFrame, 2, 1, 0);
		end

		EventAlert_Icon_Options_Frame_ToggleNewLineAnchor();
		if (EA_Config.DoAlertSound == true) then
			PlaySoundFile(EA_Config.AlertSound);
		end
	end
end


function EventAlert_Icon_Options_Frame_SetAlertFrameText(eaf, spellName, toSetTextAndShow)
	if (eaf ~= nil) then
		if (toSetTextAndShow) then
			if (EA_Config.ShowName == true) then
				eaf.spellName:SetText(spellName);
			else
				eaf.spellName:SetText("");
			end
		end

		eaf.spellTimer:ClearAllPoints();
		if (EA_Config.ShowTimer == true) then
			if (EA_Config.ChangeTimer == true) then
				eaf.spellTimer:SetPoint("CENTER", 0, 0);
				eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				if (toSetTextAndShow) then eaf.spellTimer:SetText("TIME\nLEFT") end;
			else
				eaf.spellTimer:SetPoint("TOP", 0, 20);
				eaf.spellTimer:SetFont("Fonts\\FRIZQT__.TTF", EA_Config.TimerFontSize, "OUTLINE");
				if (toSetTextAndShow) then eaf.spellTimer:SetText("TIME LEFT") end;
			end
		else
			if (toSetTextAndShow) then eaf.spellTimer:SetText("") end;
		end

		eaf:SetWidth(EA_Config.IconSize);
		eaf:SetHeight(EA_Config.IconSize);
		if (toSetTextAndShow) then eaf:Show() end;
	end
end

function EventAlert_Icon_Options_Frame_PaintAlertFrame()
	if EA_Anchor_Frame1 ~= nil then
		if EA_Anchor_Frame1:IsVisible() then
			local xOffset = 100 + EA_Position.xOffset;
			local yOffset = 0 + EA_Position.yOffset;

			EA_Anchor_Frame1:ClearAllPoints();
			EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, EA_Position.xLoc, EA_Position.yLoc);
			EA_Anchor_Frame2:ClearAllPoints();
			EA_Anchor_Frame2:SetPoint("CENTER", EA_Anchor_Frame1, xOffset, yOffset);

			EA_Anchor_Frame3:ClearAllPoints();
			EA_Anchor_Frame3:SetPoint("CENTER", EA_Anchor_Frame2, xOffset, yOffset);
			EA_Anchor_Frame3:SetBackdropColor(1.0, EA_Position.RedDebuff, EA_Position.RedDebuff);

			if EA_Position.Tar_NewLine then
				-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_Position.Tar_NewLine = True");
				EA_Anchor_Frame4:ClearAllPoints();
				EA_Anchor_Frame4:SetPoint(EA_Position.TarAnchor, EA_Position.Tar_xOffset, EA_Position.Tar_yOffset);
				EA_Anchor_Frame4:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff);
				EA_Anchor_Frame5:ClearAllPoints();
				EA_Anchor_Frame5:SetPoint("CENTER", EA_Anchor_Frame4, xOffset, yOffset);
				EA_Anchor_Frame5:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff);
			else
				-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_Position.Tar_NewLine = False");
				EA_Anchor_Frame4:ClearAllPoints();
				EA_Anchor_Frame4:SetPoint("CENTER", EA_Anchor_Frame1, -1 * xOffset, -1 * yOffset);
				EA_Anchor_Frame4:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff);
				EA_Anchor_Frame5:ClearAllPoints();
				EA_Anchor_Frame5:SetPoint("CENTER", EA_Anchor_Frame4, -1 * xOffset, -1 * yOffset);
				EA_Anchor_Frame5:SetBackdropColor(EA_Position.GreenDebuff, 1.0, EA_Position.GreenDebuff);
			end

			EA_Anchor_Frame6:ClearAllPoints();
			EA_Anchor_Frame6:SetPoint("CENTER", UIParent, EA_Position.ScdAnchor, EA_Position.Scd_xOffset, EA_Position.Scd_yOffset);
			EA_Anchor_Frame7:ClearAllPoints();
			EA_Anchor_Frame7:SetPoint("CENTER", EA_Anchor_Frame6, xOffset, yOffset);

			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame1, EA_XICON_SELF_BUFF.."(1)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame2, EA_XICON_SELF_BUFF.."(2)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame3, EA_XICON_SELF_DEBUFF.."(3)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame4, EA_XICON_TARGET_DEBUFF.."(1)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame5, EA_XICON_TARGET_DEBUFF.."(2)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame6, EA_XICON_SCD.."(1)", true);
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EA_Anchor_Frame7, EA_XICON_SCD.."(2)", true);
		end
	end

	if (EA_playerClass == EA_CLASS_PALADIN) then
		if (EA_SpecFlag.HolyPower) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10090, "", false);  -- Paladin Holy Power
		end
	elseif (EA_playerClass == EA_CLASS_DK) then
		if (EA_SpecFlag.RunicPower) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10060, "", false);  -- Death Knight Runic
		end
	elseif (EA_playerClass == EA_CLASS_DRUID) then
		if (EA_SpecFlag.ComboPoint) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10000, "", false);  -- Druid/Rogue Combo Point
		end
		if (EA_SpecFlag.Eclipse) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10081, "", false);  -- Durid Eclipse
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10082, "", false);  -- Durid Eclipse Orange
		end
		if (EA_SpecFlag.Lifebloom) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_33763, "", false);  -- Druid Lifebloom
		end
	elseif (EA_playerClass == EA_CLASS_ROGUE) then
		if (EA_SpecFlag.ComboPoint) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10000, "", false);  -- Druid/Rogue Combo Point
		end
	elseif (EA_playerClass == EA_CLASS_WARLOCK) then
		if (EA_SpecFlag.SoulShards) then
			EventAlert_Icon_Options_Frame_SetAlertFrameText(EAFrameSpec_10070, "", false);  -- Warlock Soul Shards
		end
	end
end

function EventAlert_Icon_Options_Frame_AdjustTimerFontSize()
	if (EA_Config.ChangeTimer == true) then
		EA_Config.TimerFontSize = 28;
		EA_Config.StackFontSize = 18;
		if EA_Config.IconSize < 60 then
			EA_Config.TimerFontSize = 28 + (EA_Config.IconSize - 60) * 0.3;
			EA_Config.StackFontSize = 18 + (EA_Config.IconSize - 60) * 0.3;
		end
	else
		EA_Config.TimerFontSize = 18;
		EA_Config.StackFontSize = 18;
		if EA_Config.IconSize > 60 then
			EA_Config.TimerFontSize = 22;
		end;
		if EA_Config.IconSize < 60 then
			EA_Config.StackFontSize = 18 + (EA_Config.IconSize - 60) * 0.3;
		end
	end
	EA_Config.SNameFontSize = EA_Config.IconSize / 4;
	if EA_Config.SNameFontSize < 10 then EA_Config.SNameFontSize = 10 end;
end

function EventAlert_Icon_Options_Frame_ResetFrame()
	if (EA_Config.LockFrame == true) then
		-- DEFAULT_CHAT_FRAME:AddMessage("EventAlert: You must unlock the alert frame in order to move it or reset it's position.")
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r: "..EA_XICON_LOCKFRAMETIP);
	else
		EA_Position.Anchor = "CENTER";
		EA_Position.relativePoint = "CENTER";
		EA_Position.xLoc = 0;
		EA_Position.yLoc = -140;
		EA_Position.xOffset = 0;
		EA_Position.yOffset = 0;
		EA_Position.RedDebuff = 0.5;
		EA_Position.GreenDebuff = 0.5;

		EA_Position.Tar_NewLine = true;
		EA_Position.TarAnchor = "CENTER";
		EA_Position.TarrelativePoint = "CENTER";
		EA_Position.Tar_xOffset = 0;
		EA_Position.Tar_yOffset = -220;
		-- EA_Icon_Options_Frame_Tar_NewLine:SetChecked(EA_Position.Tar_NewLine);

		EA_Position.ScdAnchor = "CENTER";
		EA_Position.Scd_xOffset = 0;
		EA_Position.Scd_yOffset = 80;

		EA_Anchor_Frame1:ClearAllPoints();
		EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, EA_Position.xLoc, EA_Position.yLoc);
		EA_Anchor_Frame1:Hide();

		EA_Icon_Options_Frame_IconXOffset:SetValue(EA_Position.xOffset);
		EA_Icon_Options_Frame_IconYOffset:SetValue(EA_Position.yOffset);
		EA_Icon_Options_Frame_IconRedDebuff:SetValue((EA_Position.RedDebuff * 100) - 50);
		EA_Icon_Options_Frame_IconGreenDebuff:SetValue((EA_Position.GreenDebuff * 100) - 50);
		EventAlert_Icon_Options_Frame_ToggleNewLineAnchor();
		EventAlert_Icon_Options_Frame_ToggleAlertFrame();
		-- EventAlert_Icon_Options_Frame_ToggleAlertFrame();
	end
end


function EventAlert_Icon_Options_Frame_MouseDown(button)
	if button == "LeftButton" then
		-- EA_Icon_Options_Frame:StartMoving();
	end
end

function EventAlert_Icon_Options_Frame_MouseUp(button)
	if button == "LeftButton" then
		-- EA_Icon_Options_Frame:StopMovingOrSizing();
	end
end

function EventAlert_Icon_Options_Frame_ToggleNewLineAnchor()
	if (EA_Position.Tar_NewLine) then
		EA_Anchor_Frame4:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2);
		EA_Anchor_Frame4:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2);
		EA_Anchor_Frame5:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2);
		EA_Anchor_Frame5:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2);
	else
		EA_Anchor_Frame4:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown);
		EA_Anchor_Frame4:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp);
		EA_Anchor_Frame5:SetScript("OnMouseDown", EventAlert_Icon_Options_Frame_Anchor_OnMouseDown);
		EA_Anchor_Frame5:SetScript("OnMouseUp", EventAlert_Icon_Options_Frame_Anchor_OnMouseUp);
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r: "..EA_XICON_LOCKFRAMETIP);
	else
		EA_Anchor_Frame1:StartMoving();
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp()
	EA_Anchor_Frame1:StopMovingOrSizing();
	local EA_point, _, EA_relativePoint, EA_xOfs, EA_yOfs = EA_Anchor_Frame1:GetPoint();
	EA_Position.Anchor = EA_point;
	EA_Position.relativePoint = EA_relativePoint;
	EA_Position.xLoc = EA_xOfs;
	EA_Position.yLoc = EA_yOfs;
	-- DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r EA_yOfs: "..EA_yOfs);
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r: "..EA_XICON_LOCKFRAMETIP);
	else
		EA_Anchor_Frame4:StartMoving();
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2()
	EA_Anchor_Frame4:StopMovingOrSizing();
	local EA_point, UIParent, EA_relativePoint, EA_x4Ofs, EA_y4Ofs = EA_Anchor_Frame4:GetPoint();
	EA_Position.TarAnchor = EA_point;
	EA_Position.TarrelativePoint = EA_relativePoint;
	EA_Position.Tar_xOffset = EA_x4Ofs;
	EA_Position.Tar_yOffset = EA_y4Ofs;
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseDown3()
	if (EA_Config.LockFrame == true) then
		DEFAULT_CHAT_FRAME:AddMessage("\124cffFFFF00EventAlert2\124r: "..EA_XICON_LOCKFRAMETIP);
	else
		EA_Anchor_Frame6:StartMoving();
	end
end

function EventAlert_Icon_Options_Frame_Anchor_OnMouseUp3()
	local halfIconSize = EA_Config.IconSize / 2;
	EA_Anchor_Frame6:StopMovingOrSizing();
	local EA_point, UIParent, EA_relativePoint, EA_x6Ofs, EA_y6Ofs = EA_Anchor_Frame6:GetPoint();
	-- DEFAULT_CHAT_FRAME:AddMessage("EA_point="..EA_point.." EA_relativePoint="..EA_relativePoint.." EA_x6Ofs="..EA_x6Ofs.." EA_y6Ofs="..EA_y6Ofs);
	if EA_point == "TOP" then EA_y6Ofs = EA_y6Ofs - halfIconSize end;
	if EA_point == "BOTTOM" then EA_y6Ofs = EA_y6Ofs + halfIconSize end;
	if EA_point == "LEFT" then EA_x6Ofs = EA_x6Ofs + halfIconSize end;
	if EA_point == "RIGHT" then EA_x6Ofs = EA_x6Ofs - halfIconSize end;
	if EA_point == "TOPLEFT" then
		EA_x6Ofs = EA_x6Ofs + halfIconSize;
		EA_y6Ofs = EA_y6Ofs - halfIconSize;
	end
	if EA_point == "TOPRIGHT" then
		EA_x6Ofs = EA_x6Ofs - halfIconSize;
		EA_y6Ofs = EA_y6Ofs - halfIconSize;
	end
	if EA_point == "BOTTOMLEFT" then
		EA_x6Ofs = EA_x6Ofs + halfIconSize;
		EA_y6Ofs = EA_y6Ofs + halfIconSize;
	end
	if EA_point == "BOTTOMRIGHT" then
		EA_x6Ofs = EA_x6Ofs - halfIconSize;
		EA_y6Ofs = EA_y6Ofs + halfIconSize;
	end
	EA_Position.ScdAnchor = EA_relativePoint;
	EA_Position.Scd_xOffset = EA_x6Ofs;
	EA_Position.Scd_yOffset = EA_y6Ofs;
end