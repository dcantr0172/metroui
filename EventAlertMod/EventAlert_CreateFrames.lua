--------------------------------------------------------------------------------
-- Create Basic Spell Frames, Anchor Frames, Speciall Frames
--------------------------------------------------------------------------------
function EventAlert_CreateFrames()
	-- Create anchor frames used for mod customization.
		if (EA_Config.AllowESC == true) then
			tinsert(UISpecialFrames,"EA_Anchor_Frame1");
		end

		local iLocOffset_X = 100 + EA_Position.xOffset;
		local iLocOffset_Y = 0 + EA_Position.yOffset
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame1", 1);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame2", 1);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame3", 1);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame4", 2);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame5", 2);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame6", 3);
		CreateFrames_CreateAnchorFrame("EA_Anchor_Frame7", 3);
	-- Self Buff/Debuff
		EA_Anchor_Frame1:SetPoint(EA_Position.Anchor, UIParent, EA_Position.xLoc, EA_Position.yLoc);
		EA_Anchor_Frame2:SetPoint("CENTER", EA_Anchor_Frame1, iLocOffset_X, iLocOffset_Y);
		EA_Anchor_Frame3:SetPoint("CENTER", EA_Anchor_Frame2, iLocOffset_X, iLocOffset_Y);
	-- Target Buff/Debuff
		EA_Anchor_Frame4:SetPoint("CENTER", EA_Anchor_Frame1, -1 * iLocOffset_X, -1 * iLocOffset_Y);
		EA_Anchor_Frame5:SetPoint("CENTER", EA_Anchor_Frame4, -1 * iLocOffset_X, -1 * iLocOffset_Y);
	-- Spell Cooldowns
		EA_Anchor_Frame6:SetPoint("CENTER", EA_Anchor_Frame1, 0, 80 + iLocOffset_Y);
		EA_Anchor_Frame7:SetPoint("CENTER", EA_Anchor_Frame6, iLocOffset_X, iLocOffset_Y);

		local EA_OptHeight = EA_Options_Frame:GetHeight();
	-- Create primary alert frames
		CreateFrames_EventsFrame_CreateSpellList(1);
		CreateFrames_EventsFrame_RefreshSpellList(1);
		EA_Class_Events_Frame:SetHeight(EA_OptHeight);

	-- Create alternate alert frames
		CreateFrames_EventsFrame_CreateSpellList(2);
		CreateFrames_EventsFrame_RefreshSpellList(2);
		EA_ClassAlt_Events_Frame:SetHeight(EA_OptHeight);

	-- Create other alert frames. (Mostly trinket procs)
		CreateFrames_EventsFrame_CreateSpellList(3);
		CreateFrames_EventsFrame_RefreshSpellList(3);
		EA_Other_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Target's Debuffs alert frames. (Target's Debuffs only now)
		CreateFrames_EventsFrame_CreateSpellList(4);
		CreateFrames_EventsFrame_RefreshSpellList(4);
		EA_Target_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Spells' Cooldown alert frames.
		CreateFrames_EventsFrame_CreateSpellList(5);
		CreateFrames_EventsFrame_RefreshSpellList(5);
		EA_SCD_Events_Frame:SetHeight(EA_OptHeight);

	-- Create Execution alert frames.
		local eaexf = CreateFrame("FRAME", "EventAlert_ExecutionFrame", UIParent);
		eaexf:ClearAllPoints();
		eaexf:SetFrameStrata("BACKGROUND");
		eaexf:SetPoint("TOP", UIParent, "TOP", 0, -50);
		eaexf:SetHeight(256);
		eaexf:SetWidth(256);
		eaexf:Hide();

end


function CreateFrames_CreateAnchorFrame(AnchorFrameName, typeIndex)
		local eaaf = CreateFrame("FRAME", AnchorFrameName, UIParent);
		eaaf:SetFrameStrata("DIALOG");
		eaaf:ClearAllPoints();
		eaaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Nature_Polymorph_Cow"});

		eaaf.spellName = eaaf:CreateFontString(AnchorFrameName.."_Name","OVERLAY");
		eaaf.spellName:SetFontObject(ChatFontNormal);
		eaaf.spellName:SetPoint("BOTTOM", 0, -15);

		eaaf.spellTimer = eaaf:CreateFontString(AnchorFrameName.."_Timer","OVERLAY");
		eaaf.spellTimer:SetFontObject(ChatFontNormal);
		eaaf.spellTimer:SetPoint("TOP", 0, 15);

		eaaf:SetMovable(true);
		eaaf:EnableMouse(true);
		if (typeIndex == 1) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp);
		elseif (typeIndex == 2) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown2);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp2);
		elseif (typeIndex == 3) then
			eaaf:SetScript("OnMouseDown",   EventAlert_Icon_Options_Frame_Anchor_OnMouseDown3);
			eaaf:SetScript("OnMouseUp",     EventAlert_Icon_Options_Frame_Anchor_OnMouseUp3);
		end
		eaaf:Hide();
end

function CreateFrames_CreateSpellFrame(index, typeIndex)
	-- local eaf = CreateFrame("FRAME", "EAFrame_"..index, EA_Main_Frame);
	local sFramePrefix = "EAFrame_";
	if typeIndex == 2 then sFramePrefix = "EATarFrame_" end;
	if typeIndex == 3 then sFramePrefix = "EAScdFrame_" end;

	local eaf = CreateFrame("Cooldown", sFramePrefix..index, EA_Main_Frame, "CooldownFrameTemplate");
	eaf.noCooldownCount = true;

	if (EA_Config.AllowESC == true) then
		tinsert(UISpecialFrames,sFramePrefix..index);
	end

	eaf:SetFrameStrata("DIALOG");
	-- eaf:SetFrameStrata("LOW");
	eaf.redsectext = false;
	eaf.whitesectext = false;
	eaf.overgrow = false;

	eaf.spellName = eaf:CreateFontString(sFramePrefix..index.."_Name","OVERLAY");
	eaf.spellName:SetFontObject(ChatFontNormal);
	eaf.spellName:SetPoint("BOTTOM", 0, -15);

	eaf.spellTimer = eaf:CreateFontString(sFramePrefix..index.."_Timer","OVERLAY");
	eaf.spellTimer:SetFontObject(ChatFontNormal);
	eaf.spellTimer:SetPoint("TOP", 0, 15);

	eaf.spellStack = eaf:CreateFontString(sFramePrefix..index.."_Stack","OVERLAY");
	eaf.spellStack:SetFontObject(ChatFontNormal);
	eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 15);

	local spellId = tonumber(index);
	local name, rank, icon = GetSpellInfo(spellId);
	if rank == nil then rank = "nil" end;
	if typeIndex == 1 then
		if EA_SPELLINFO_SELF[spellId] == nil then EA_SPELLINFO_SELF[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
		EA_SPELLINFO_SELF[spellId].name = name;
		EA_SPELLINFO_SELF[spellId].rank = rank;
		if (spellId == 48517) then          -- Druid / Eclipse (Solar): replace the Icon as Wrath (Rank 1)
			_, _, icon, _, _, _, _, _, _ = GetSpellInfo(5176);
		elseif (spellId == 48518) then      -- Druid / Eclipse (Lunar): replace the Icon as Starfire (Rank 1)
			_, _, icon, _, _, _, _, _, _ = GetSpellInfo(2912);
		elseif (spellId == 8921) then       -- Druid / Moonfire: always use the starfall picture
			icon = "Interface/Icons/Spell_Nature_Starfall";
		end
		EA_SPELLINFO_SELF[spellId].icon = icon;
	elseif typeIndex == 2 then
		if EA_SPELLINFO_TARGET[spellId] == nil then EA_SPELLINFO_TARGET[spellId] = {name, rank, icon, count, duration, expirationTime, unitCaster, isDebuff} end;
		EA_SPELLINFO_TARGET[spellId].name = name;
		EA_SPELLINFO_TARGET[spellId].rank = rank;
		EA_SPELLINFO_TARGET[spellId].icon = icon;
	elseif typeIndex == 3 then
		if EA_SPELLINFO_SCD[spellId] == nil then EA_SPELLINFO_SCD[spellId] = {name, rank, icon} end;
		EA_SPELLINFO_SCD[spellId].name = name;
		EA_SPELLINFO_SCD[spellId].rank = rank;
		EA_SPELLINFO_SCD[spellId].icon = icon;
	end
end

function CreateFrames_CreateSpecialFrame(index, typeIndex)
	-- local eaf = CreateFrame("FRAME", "EAFrame_"..index, EA_Main_Frame);
	local sFramePrefix = "EAFrameSpec_";

	local eaf = CreateFrame("FRAME", sFramePrefix..index, EA_Main_Frame, "CooldownFrameTemplate");
	-- eaf.noCooldownCount = true;

	if (EA_Config.AllowESC == true) then
		tinsert(UISpecialFrames,sFramePrefix..index);
	end

	eaf:SetFrameStrata("DIALOG");
	-- eaf:SetFrameStrata("LOW");
	eaf.spellName = eaf:CreateFontString(sFramePrefix..index.."_Name","OVERLAY");
	eaf.spellName:SetFontObject(ChatFontNormal);
	eaf.spellName:SetPoint("BOTTOM", 0, -15);

	eaf.spellTimer = eaf:CreateFontString(sFramePrefix..index.."_Timer","OVERLAY");
	eaf.spellTimer:SetFontObject(ChatFontNormal);
	eaf.spellTimer:SetPoint("TOP", 0, 15);

	eaf.spellStack = eaf:CreateFontString(sFramePrefix..index.."_Stack","OVERLAY");
	eaf.spellStack:SetFontObject(ChatFontNormal);
	eaf.spellStack:SetPoint("BOTTOMRIGHT", 0, 15);

	-- if typeIndex == 1 then
		eaf:SetWidth(EA_Config.IconSize);
		eaf:SetHeight(EA_Config.IconSize);

		if index == 10000 then
			-- Druid/Rogue Combo Point
			eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Whirlwind"});
		elseif index == 10060 then
			-- Death Knight Runic
			eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Arcane_Rune"});
		elseif index == 10070 then
			-- Warlock Soul Shards
			eaf:SetBackdrop({bgFile = "Interface/Icons/Inv_Misc_Gem_Amethyst_02"});
		elseif index == 10081 then
			-- Durid Eclipse
			eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Druid_Eclipse"});
		elseif index == 10082 then
			-- Durid Eclipse Orange
			eaf:SetBackdrop({bgFile = "Interface/Icons/Ability_Druid_Eclipseorange"});
		elseif index == 10090 then
			-- Paladin Holy Power
			eaf:SetBackdrop({bgFile = "Interface/Icons/Spell_Holy_Powerwordbarrier"});
		elseif index == 33763 then
			-- Druid Lifebloom
			eaf:SetBackdrop({bgFile = "Interface/Icons/INV_Misc_Herb_Felblossom"});
		end
	-- end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Create ScrollListFrame And Items(Icon, CheckButton, EditBox, ConfigButton, FontString)
--------------------------------------------------------------------------------
function CreateFrames_EventsFrame_CreateScrollFrame(ParentFrameObj, ScrollFrameHeight, xOffset, yOffset)
	local framewidht = ParentFrameObj:GetWidth();
	local framename = ParentFrameObj:GetName();
	local panel3 = CreateFrame("ScrollFrame", framename.."_SpellListFrameScroll", ParentFrameObj, "UIPanelScrollFrameTemplate");
	local scc = CreateFrame("Frame", framename.."_SpellListFrame", panel3);
		panel3:SetScrollChild(scc);
		panel3:SetPoint("TOPLEFT", ParentFrameObj, "TOPLEFT", xOffset, yOffset);
		scc:SetPoint("TOPLEFT", panel3, "TOPLEFT", 0, 0);
		panel3:SetWidth(framewidht-45);
		panel3:SetHeight(ScrollFrameHeight);
		scc:SetWidth(framewidht-45);
		scc:SetHeight(ScrollFrameHeight);
		-- panel3:SetHorizontalScroll(-50);
		-- panel3:SetVerticalScroll(50);
		panel3:SetBackdrop({bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", edgeFile="", tile = false, tileSize = 0, edgeSize = 0, insets = { left = 0, right = 0, top = 0, bottom = 0 }});
		panel3:SetScript("OnVerticalScroll", function()  end);
		panel3:EnableMouse(true);
		panel3:SetVerticalScroll(0);
		panel3:SetHorizontalScroll(0);
end

function CreateFrames_CreateSpellListIcon(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, IconPath)
	SpellID = tonumber(SpellID);
	local SpellIcon = _G[FrameNamePrefix..SpellID];
	if (SpellIcon == nil) then
		SpellIcon = CreateFrame("Frame", FrameNamePrefix..SpellID, ParentFrameObj);
		SpellIcon:SetWidth(25);
		SpellIcon:SetHeight(25);
		SpellIcon:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
		SpellIcon:SetBackdrop({bgFile = IconPath});
	else
		SpellIcon:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
		SpellIcon:SetBackdrop({bgFile = IconPath});
		SpellIcon:Show();
	end
end

function CreateFrames_CreateSpellListChkbox(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, SpellName, SpellRank, FrameIndex, EditboxObj)
	SpellID = tonumber(SpellID);

	local fValue = true;
	if FrameIndex == 1 then
		fValue = EA_Items[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 2 then
		fValue = EA_AltItems[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 3 then
		fValue = EA_Items[EA_CLASS_OTHER][SpellID].enable;
	elseif FrameIndex == 4 then
		fValue = EA_TarItems[EA_playerClass][SpellID].enable;
	elseif FrameIndex == 5 then
		fValue = EA_ScdItems[EA_playerClass][SpellID].enable;
	end

	local SpellChkbox = _G[FrameNamePrefix..SpellID];
	if (SpellChkbox == nil) then
		SpellChkbox = CreateFrame("CheckButton", FrameNamePrefix..SpellID, ParentFrameObj, "OptionsCheckButtonTemplate");
		SpellChkbox:SetPoint("TOPLEFT", LocOffsetX + 25, LocOffsetY);
		SpellChkbox:SetChecked(fValue);

		if (SpellRank == "") then
			_G[SpellChkbox:GetName().."Text"]:SetText(SpellName.." ["..SpellID.."]");
		else
			_G[SpellChkbox:GetName().."Text"]:SetText(SpellName.."("..SpellRank..") ["..SpellID.."]");
		end
		-- if (SpellRank == "") then
		--     _G[SpellChkbox:GetName().."Text"]:SetText(SpellName);
		-- else
		--     _G[SpellChkbox:GetName().."Text"]:SetText(SpellName.."("..SpellRank..")");
		-- end

		local function ChkboxGetChecked()
			if (IsShiftKeyDown()) then
				DEFAULT_CHAT_FRAME:AddMessage(EA_XCMD_DEBUG_P2.."="..tostring(SpellID).." / "..GetSpellLink(SpellID));
			end
			EditboxObj:SetText(tostring(SpellID));
			if (SpellChkbox:GetChecked()) then
				fValue = true;
			else
				fValue = false;
			end
			if (FrameIndex == 1) then
				EA_Items[EA_playerClass][SpellID].enable = fValue;
			elseif (FrameIndex == 2) then
				EA_AltItems[EA_playerClass][SpellID].enable = fValue;
			elseif (FrameIndex == 3) then
				EA_Items[EA_CLASS_OTHER][SpellID].enable = fValue;
			elseif (FrameIndex == 4) then
				EA_TarItems[EA_playerClass][SpellID].enable = fValue;
			elseif (FrameIndex == 5) then
				EA_ScdItems[EA_playerClass][SpellID].enable = fValue;
			end
		end
		local function ChkboxGameToolTip()
			GameTooltip:SetOwner(SpellChkbox, "ANCHOR_RIGHT");
			GameTooltip:SetSpellByID(SpellID);
		end
		SpellChkbox:RegisterForClicks("AnyUp");
		SpellChkbox:SetScript("OnClick", ChkboxGetChecked);
		SpellChkbox:SetScript("OnEnter", ChkboxGameToolTip);
	else
		SpellChkbox:SetPoint("TOPLEFT", LocOffsetX + 25, LocOffsetY);
		SpellChkbox:SetChecked(fValue);
		SpellChkbox:Show();
	end
end

-- function CreateFrames_CreateSpellListEditbox(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, EditWidth, SpellText)
--  SpellID = tonumber(SpellID);
--
--  local SpellEditBox = _G[FrameNamePrefix..SpellID];
--  if (SpellEditBox == nil) then
--      SpellEditBox = CreateFrame("EditBox", FrameNamePrefix..SpellID, ParentFrameObj);
--      SpellEditBox:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
--      SpellEditBox:SetFontObject(ChatFontNormal);
--      SpellEditBox:SetWidth(EditWidth);
--      SpellEditBox:SetHeight(25);
--      SpellEditBox:SetMaxLetters(0);
--      SpellEditBox:SetAutoFocus(false);
--      SpellEditBox:SetText(SpellText);
--
--         local function ShowEditBoxGameToolTip()
--          SpellEditBox:SetTextColor(0, 1, 1);
--          GameTooltip:SetOwner(SpellEditBox, "ANCHOR_RIGHT");
--          GameTooltip:SetSpellByID(SpellID);
--         end
--         local function HideEditBoxGameToolTip()
--          SpellEditBox:SetTextColor(1, 1, 1);
--          SpellEditBox:HighlightText(0,0);
--          SpellEditBox:ClearFocus();
--          GameTooltip:Hide();
--         end
--      SpellEditBox:SetScript("OnEnter", ShowEditBoxGameToolTip);
--      SpellEditBox:SetScript("OnLeave", HideEditBoxGameToolTip);
--  else
--      if (not SpellEditBox:IsShown()) then
--          SpellEditBox:SetPoint("TOPLEFT", LocOffsetX, LocOffsetY);
--          SpellEditBox:Show();
--      end
--  end
-- end


function CreateFrames_CfgBtn_SaveSpellCondition(FrameIndex, SpellID)
	-- Get saved condition of spell
	local SC_Stack, SC_Self, SC_OverGrow, SC_RedSecText = nil, nil, nil, nil;
	local Chk_Stack, Chk_OverGrow, Chk_RedSecText = false, false, false;

	Chk_Stack = EA_SpellCondition_Frame_Stack:GetChecked();
	SC_Stack = EA_SpellCondition_Frame_StackEditBox:GetText();
	SC_Stack = tonumber(SC_Stack);
	if ((not Chk_Stack) or (SC_Stack == nil) or (SC_Stack <= 1)) then
		Chk_Stack = false;
		SC_Stack = nil;
	end

	SC_Self = EA_SpellCondition_Frame_Self:GetChecked();
	if (SC_Self == 1) then
		SC_Self = true;
	else
		SC_Self = false;
	end

	Chk_OverGrow = EA_SpellCondition_Frame_OverGrow:GetChecked();
	SC_OverGrow = EA_SpellCondition_Frame_OverGrowEditBox:GetText();
	SC_OverGrow = tonumber(SC_OverGrow);
	if ((not Chk_OverGrow) or (SC_OverGrow == nil) or (SC_OverGrow <= 0) or (SC_OverGrow >= 100)) then
		Chk_OverGrow = false;
		SC_OverGrow = nil;
	end

	Chk_RedSecText = EA_SpellCondition_Frame_RedSecText:GetChecked();
	SC_RedSecText = EA_SpellCondition_Frame_RedSecTextEditBox:GetText();
	SC_RedSecText = tonumber(SC_RedSecText);
	if ((not Chk_RedSecText) or (SC_RedSecText == nil) or (SC_RedSecText <= 0) or (SC_RedSecText >= 100)) then
		Chk_RedSecText = false;
		SC_RedSecText = nil;
	end

	if (FrameIndex == 1) then
		EA_Items[EA_playerClass][SpellID].stack = SC_Stack;
		EA_Items[EA_playerClass][SpellID].self = SC_Self;
		EA_Items[EA_playerClass][SpellID].overgrow = SC_OverGrow;
		EA_Items[EA_playerClass][SpellID].redsectext = SC_RedSecText;
	elseif (FrameIndex == 2) then
		EA_AltItems[EA_playerClass][SpellID].stack = SC_Stack;
		EA_AltItems[EA_playerClass][SpellID].self = SC_Self;
		EA_AltItems[EA_playerClass][SpellID].overgrow = SC_OverGrow;
		EA_AltItems[EA_playerClass][SpellID].redsectext = SC_RedSecText;
	elseif (FrameIndex == 3) then
		EA_Items[EA_CLASS_OTHER][SpellID].stack = SC_Stack;
		EA_Items[EA_CLASS_OTHER][SpellID].self = SC_Self;
		EA_Items[EA_CLASS_OTHER][SpellID].overgrow = SC_OverGrow;
		EA_Items[EA_CLASS_OTHER][SpellID].redsectext = SC_RedSecText;
	elseif (FrameIndex == 4) then
		EA_TarItems[EA_playerClass][SpellID].stack = SC_Stack;
		EA_TarItems[EA_playerClass][SpellID].self = SC_Self;
		EA_TarItems[EA_playerClass][SpellID].overgrow = SC_OverGrow;
		EA_TarItems[EA_playerClass][SpellID].redsectext = SC_RedSecText;
	elseif (FrameIndex == 5) then
		EA_ScdItems[EA_playerClass][SpellID].stack = SC_Stack;
		EA_ScdItems[EA_playerClass][SpellID].self = SC_Self;
		EA_ScdItems[EA_playerClass][SpellID].overgrow = SC_OverGrow;
		EA_ScdItems[EA_playerClass][SpellID].redsectext = SC_RedSecText;
	end

	EA_SpellCondition_Frame:Hide();
end

local function EACFFun_EventsFrame_CheckSpellID(spellID, ReCheckSpell)
	local EA_name, EA_rank, EA_icon = GetSpellInfo(spellID);
	if EA_name == nil then EA_name = "" end;
	if EA_rank == nil then EA_rank = "" end;

	if (ReCheckSpell) then
		if (spellID == 33151) then
			EA_rank = "";
		elseif (spellID == 48517) then      -- Druid / Eclipse (Solar): replace the Icon as Wrath (Rank 1)
			_, _, EA_icon = GetSpellInfo(5176);
		elseif (spellID == 48518) then      -- Druid / Eclipse (Lunar): replace the Icon as Starfire (Rank 1)
			_, _, EA_icon = GetSpellInfo(2912);
		elseif (spellID == 8921) then       -- Druid / Moonfire: always use the starfall picture
			EA_icon = "Interface/Icons/Spell_Nature_Starfall";
		end
	end
	return EA_name, EA_rank, EA_icon;
end

function CreateFrames_CfgBtn_LoadSpellCondition(FrameIndex, SpellID)
	-- Get saved condition of spell
	local ReCheckSpell = false;
	if (FrameIndex == 1) then ReCheckSpell = true end;
	local SpellName, SpellRank, SpellIconPath = EACFFun_EventsFrame_CheckSpellID(SpellID, ReCheckSpell);
	if (SpellRank ~= nil and SpellRank ~= "") then SpellName = SpellName.."("..SpellRank..")" end;

	local SC_Stack, SC_Self, SC_OverGrow, SC_RedSecText = nil, nil, nil, nil;
	local Chk_Stack, Chk_OverGrow, Chk_RedSecText = false, false, false;
	if (FrameIndex == 1) then
		SC_Stack = EA_Items[EA_playerClass][SpellID].stack;
		SC_Self = EA_Items[EA_playerClass][SpellID].self;
		SC_OverGrow = EA_Items[EA_playerClass][SpellID].overgrow;
		SC_RedSecText = EA_Items[EA_playerClass][SpellID].redsectext;
	elseif (FrameIndex == 2) then
		SC_Stack = EA_AltItems[EA_playerClass][SpellID].stack;
		SC_Self = EA_AltItems[EA_playerClass][SpellID].self;
		SC_OverGrow = EA_AltItems[EA_playerClass][SpellID].overgrow;
		SC_RedSecText = EA_AltItems[EA_playerClass][SpellID].redsectext;
	elseif (FrameIndex == 3) then
		SC_Stack = EA_Items[EA_CLASS_OTHER][SpellID].stack;
		SC_Self = EA_Items[EA_CLASS_OTHER][SpellID].self;
		SC_OverGrow = EA_Items[EA_CLASS_OTHER][SpellID].overgrow;
		SC_RedSecText = EA_Items[EA_CLASS_OTHER][SpellID].redsectext;
	elseif (FrameIndex == 4) then
		SC_Stack = EA_TarItems[EA_playerClass][SpellID].stack;
		SC_Self = EA_TarItems[EA_playerClass][SpellID].self;
		SC_OverGrow = EA_TarItems[EA_playerClass][SpellID].overgrow;
		SC_RedSecText = EA_TarItems[EA_playerClass][SpellID].redsectext;
	elseif (FrameIndex == 5) then
		SC_Stack = EA_ScdItems[EA_playerClass][SpellID].stack;
		SC_Self = EA_ScdItems[EA_playerClass][SpellID].self;
		SC_OverGrow = EA_ScdItems[EA_playerClass][SpellID].overgrow;
		SC_RedSecText = EA_ScdItems[EA_playerClass][SpellID].redsectext;
	end

	if (SC_Stack == nil or SC_Stack <=1) then
		Chk_Stack = false;
		SC_Stack = 1;
	else
		Chk_Stack = true;
	end
	if (SC_Self == nil) then
		SC_Self = false;
	end
	if (SC_OverGrow == nil or SC_OverGrow <=0) then
		Chk_OverGrow = false;
		SC_OverGrow = 100;
	else
		Chk_OverGrow = true;
	end
	if (SC_RedSecText == nil or SC_RedSecText <=0) then
		Chk_RedSecText = false;
		SC_RedSecText = -1;
	else
		Chk_RedSecText = true;
	end

	EA_SpellCondition_Frame_SpellIcon:SetBackdrop({bgFile = SpellIconPath});
	EA_SpellCondition_Frame_SpellNameText:SetText(SpellName);
	local iTextWidth = EA_SpellCondition_Frame_SpellNameText:GetTextWidth();
	EA_SpellCondition_Frame_SpellNameText:SetWidth(iTextWidth);
	local function SNTGameToolTip()
		GameTooltip:SetOwner(EA_SpellCondition_Frame_SpellNameText, "ANCHOR_RIGHT");
		GameTooltip:SetSpellByID(SpellID);
	end
	EA_SpellCondition_Frame_SpellNameText:SetScript("OnEnter", SNTGameToolTip);

	-- Set SpellCondition Stack Checkbox & Editbox
	EA_SpellCondition_Frame_Stack:SetChecked(Chk_Stack);
	if (Chk_Stack) then
		EA_SpellCondition_Frame_StackEditBox:SetText(SC_Stack);
	else
		EA_SpellCondition_Frame_StackEditBox:SetText("");
	end

	-- Set SpellCondition Self Checkbox
	EA_SpellCondition_Frame_Self:SetChecked(SC_Self);

	-- Set SpellCondition OverGrow Checkbox & Editbox
	EA_SpellCondition_Frame_OverGrow:SetChecked(Chk_OverGrow);
	if (Chk_OverGrow) then
		EA_SpellCondition_Frame_OverGrowEditBox:SetText(SC_OverGrow);
	else
		EA_SpellCondition_Frame_OverGrowEditBox:SetText("");
	end

	-- Set SpellCondition RedSecText Checkbox & Editbox
	EA_SpellCondition_Frame_RedSecText:SetChecked(Chk_RedSecText);
	if (Chk_RedSecText) then
		EA_SpellCondition_Frame_RedSecTextEditBox:SetText(SC_RedSecText);
	else
		EA_SpellCondition_Frame_RedSecTextEditBox:SetText("");
	end

	EA_SpellCondition_Frame:ClearAllPoints();
	EA_SpellCondition_Frame:SetPoint("LEFT", EA_Options_Frame, "RIGHT", 50);
	EA_SpellCondition_Frame:Show();

	EA_SpellCondition_Frame_Save:SetScript("OnClick", function()
		CreateFrames_CfgBtn_SaveSpellCondition(FrameIndex, SpellID);
	end);
end

function CreateFrames_CreateSpellListCfgBtn(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, FrameIndex)
	SpellID = tonumber(SpellID);

	local SpellCfgBtn = _G[FrameNamePrefix..SpellID];
	if (SpellCfgBtn == nil) then
		SpellCfgBtn = CreateFrame("Button", FrameNamePrefix..SpellID, ParentFrameObj);
		SpellCfgBtn:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
		SpellCfgBtn:SetWidth(25);
		SpellCfgBtn:SetHeight(25);
		SpellCfgBtn:SetNormalTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton-Down");
		SpellCfgBtn:SetHighlightTexture("Interface\\AddOns\\EventAlertMod\\Images\\UI-Panel-CfgButton-Highlight", "BLEND");
		SpellCfgBtn:SetScript("OnClick", function()
			CreateFrames_CfgBtn_LoadSpellCondition(FrameIndex, SpellID);
		end);
		-- SpellCfgBtn:SetScript("OnEnter", ShowEditBoxGameToolTip);
		-- SpellCfgBtn:SetScript("OnLeave", HideEditBoxGameToolTip);
	else
		if (not SpellCfgBtn:IsShown()) then
			SpellCfgBtn:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
			SpellCfgBtn:Show();
		end
	end
end

-- function CreateFrames_CreateSpellListFontStr(SpellID, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY)
--  SpellID = tonumber(SpellID);
--
--  local SpellFontStr = _G[FrameNamePrefix..SpellID];
--  if (SpellFontStr == nil) then
--      SpellFontStr = ParentFrameObj:CreateFontString(FrameNamePrefix..SpellID, "ARTWORK", "GameFontNormal");
--      SpellFontStr:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
--      SpellFontStr:SetWidth(60);
--      SpellFontStr:SetHeight(25);
--      SpellFontStr:SetText("["..tostring(SpellID).."]");
--  else
--      if (not SpellFontStr:IsShown()) then
--          SpellFontStr:SetPoint("TOPRIGHT", LocOffsetX, LocOffsetY);
--          SpellFontStr:Show();
--      end
--  end
-- end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- CreateSpellList, ClearSpellList, RefreshSpellList
--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_CreateSpellList(EAItems, typeIndex)
	for index,value in pairsByKeys(EAItems) do
		CreateFrames_CreateSpellFrame(index, typeIndex);
	end
end
function CreateFrames_EventsFrame_CreateSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_CreateSpellList(EA_Items[EA_playerClass], 1);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_CreateSpellList(EA_AltItems[EA_playerClass], 1);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_CreateSpellList(EA_Items[EA_CLASS_OTHER], 1);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_CreateSpellList(EA_TarItems[EA_playerClass], 2);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_CreateSpellList(EA_ScdItems[EA_playerClass], 3);
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_ClearSpellList(EAItems, FrameNamePrefix)
	local f1, f2, f3;
	for index,value in pairsByKeys(EAItems) do
		f1 = _G[FrameNamePrefix.."_Icon_"..index];
		f2 = _G[FrameNamePrefix.."_Chkbtn_"..index];
		f3 = _G[FrameNamePrefix.."_CfgBtn_"..index];
		if f1 ~= nil then f1:Hide() end;
		if f2 ~= nil then f2:Hide() end;
		if f3 ~= nil then f3:Hide() end;
	end
end
function CreateFrames_EventsFrame_ClearSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_ClearSpellList(EA_Items[EA_playerClass], "EA_ClassFrame");
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_ClearSpellList(EA_AltItems[EA_playerClass], "EA_ClassAltFrame");
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_ClearSpellList(EA_Items[EA_CLASS_OTHER], "EA_OtherFrame");
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_ClearSpellList(EA_TarItems[EA_playerClass], "EA_TargetFrame");
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_ClearSpellList(EA_ScdItems[EA_playerClass], "EA_SCDFrame");
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EAItems, FrameNamePrefix, ParentFrameObj, LocOffsetX, LocOffsetY, EditboxObj)
	local CanCfg, ReCheckSpell = false, false;
	if FrameIndex == 1 then
		CanCfg = true;
		ReCheckSpell = true;
	elseif FrameIndex == 3 then
		CanCfg = true;
	elseif FrameIndex == 4 then
		CanCfg = true;
	end
	for index, value in pairsByKeys(EAItems) do
		-- local EA_name, EA_rank, EA_icon = GetSpellInfo(index);
		local EA_name, EA_rank, EA_icon = EACFFun_EventsFrame_CheckSpellID(index, ReCheckSpell);
		CreateFrames_CreateSpellListIcon(index, FrameNamePrefix.."_Icon_", ParentFrameObj, LocOffsetX, LocOffsetY, EA_icon);
		CreateFrames_CreateSpellListChkbox(index, FrameNamePrefix.."_Chkbtn_", ParentFrameObj, LocOffsetX, LocOffsetY, EA_name, EA_rank, FrameIndex, EditboxObj);
		if (CanCfg) then CreateFrames_CreateSpellListCfgBtn(index, FrameNamePrefix.."_CfgBtn_", ParentFrameObj, LocOffsetX, LocOffsetY, FrameIndex) end;
		LocOffsetY = LocOffsetY - 25;
	end
end
function CreateFrames_EventsFrame_RefreshSpellList(FrameIndex)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_Items[EA_playerClass], "EA_ClassFrame", EA_Class_Events_Frame_SpellListFrame, 0, 0, EA_Class_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_AltItems[EA_playerClass], "EA_ClassAltFrame", EA_ClassAlt_Events_Frame, 15, -55, EA_ClassAlt_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_Items[EA_CLASS_OTHER], "EA_OtherFrame", EA_Other_Events_Frame_SpellListFrame, 0, 0, EA_Other_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_TarItems[EA_playerClass], "EA_TargetFrame", EA_Target_Events_Frame_SpellListFrame, 0, 0, EA_Target_Events_Frame_SpellEditBox);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_RefreshSpellList(FrameIndex, EA_ScdItems[EA_playerClass], "EA_SCDFrame", EA_SCD_Events_Frame_SpellListFrame, 0, 0, EA_SCD_Events_Frame_SpellEditBox);
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Select All, LoadDefault, Add Spell, Del Spell
--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_SelAll(EAItems, FrameName, Status)
	for index, value in pairsByKeys(EAItems) do
		index = tonumber(index);
		EAItems[index].enable = Status;
		local f2 = _G[FrameName..index];
		if (f2 ~= nil) then f2:SetChecked(Status) end;
	end
end
function CreateFrames_EventsFrame_SelAll(FrameIndex, Status)
	if (FrameIndex == 1) then
		EACFFun_EventsFrame_SelAll(EA_Items[EA_playerClass], "EA_ClassFrame_Chkbtn_", Status);
	elseif (FrameIndex == 2) then
		EACFFun_EventsFrame_SelAll(EA_AltItems[EA_playerClass], "EA_ClassAltFrame_Chkbtn_", Status);
	elseif (FrameIndex == 3) then
		EACFFun_EventsFrame_SelAll(EA_Items[EA_CLASS_OTHER], "EA_OtherFrame_Chkbtn_", Status);
	elseif (FrameIndex == 4) then
		EACFFun_EventsFrame_SelAll(EA_TarItems[EA_playerClass], "EA_TargetFrame_Chkbtn_", Status);
	elseif (FrameIndex == 5) then
		EACFFun_EventsFrame_SelAll(EA_ScdItems[EA_playerClass], "EA_SCDFrame_Chkbtn_", Status);
	end
end

--------------------------------------------------------------------------------
function CreateFrames_EventsFrame_LoadDefault(FrameIndex)
	EventAlert_LoadClassSpellArray(FrameIndex);
	CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
	CreateFrames_EventsFrame_CreateSpellList(FrameIndex);
	CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
end

--------------------------------------------------------------------------------
local function EACFFun_GetSpellButton_ByFrame(FrameIndex)
	if (FrameIndex == 1) then
		return EA_Class_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 2) then
		return EA_ClassAlt_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 3) then
		return EA_Other_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 4) then
		return EA_Target_Events_Frame_SpellEditBox;
	elseif (FrameIndex == 5) then
		return EA_SCD_Events_Frame_SpellEditBox;
	end
end
function CreateFrames_EventsFrame_AddSpell(FrameIndex)
	local typeIndex = 1;
	if (FrameIndex == 4) then typeIndex = 2 end;
	if (FrameIndex == 5) then typeIndex = 3 end;

	local SpellButton = EACFFun_GetSpellButton_ByFrame(FrameIndex);
	SpellButton:ClearFocus();
	local spellID = SpellButton:GetText();
	-- DEFAULT_CHAT_FRAME:AddMessage("Add spellID = "..spellID);
	if spellID ~= nil and spellID ~= "" then
		spellID = tonumber(spellID);
		-- Check if is a valid spellID
		local sname = GetSpellInfo(spellID);
		if (sname ~= nil) then
			CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
			if (FrameIndex==1 and EA_Items[EA_playerClass][spellID] == nil) then EA_Items[EA_playerClass][spellID] = {enable=true,} end;
			if (FrameIndex==2 and EA_AltItems[EA_playerClass][spellID] == nil) then EA_AltItems[EA_playerClass][spellID] = {enable=true,} end;
			if (FrameIndex==3 and EA_Items[EA_CLASS_OTHER][spellID] == nil) then EA_Items[EA_CLASS_OTHER][spellID] = {enable=true,} end;
			if (FrameIndex==4 and EA_TarItems[EA_playerClass][spellID] == nil) then EA_TarItems[EA_playerClass][spellID] = {enable=true,} end;
			if (FrameIndex==5 and EA_ScdItems[EA_playerClass][spellID] == nil) then EA_ScdItems[EA_playerClass][spellID] = {enable=true,} end;
			CreateFrames_CreateSpellFrame(spellID, typeIndex);
			CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
		end
	end
end

--------------------------------------------------------------------------------
local function EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EAItems, FrameName)
	spellID = tonumber(spellID);
	local TempPlayerClass = {};
	local IsCurrSpell = false;
	for index,value in pairsByKeys(EAItems) do
		if (index ~= spellID) then
			TempPlayerClass[index] = value; -- Store the existed spells
		else
			IsCurrSpell = true;             -- Find the spell match to delete
		end;
	end
	-- Check if is a spell in current list
	if (IsCurrSpell) then
		CreateFrames_EventsFrame_ClearSpellList(FrameIndex);
		if (FrameIndex == 1) then
			EA_Items[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 2) then
			EA_AltItems[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 3) then
			EA_Items[EA_CLASS_OTHER] = TempPlayerClass;
		elseif (FrameIndex == 4) then
			EA_TarItems[EA_playerClass] = TempPlayerClass;
		elseif (FrameIndex == 5) then
			EA_ScdItems[EA_playerClass] = TempPlayerClass;
		end
		local eaf = _G[FrameName..spellID];
		eaf:SetScript("OnUpdate", nil);
		eaf:Hide();
		eaf = nil;
		CreateFrames_EventsFrame_RefreshSpellList(FrameIndex);
	end
end
function CreateFrames_EventsFrame_DelSpell(FrameIndex)
	local SpellButton = EACFFun_GetSpellButton_ByFrame(FrameIndex);
	SpellButton:ClearFocus();
	local spellID = SpellButton:GetText();
	-- DEFAULT_CHAT_FRAME:AddMessage("Del spellID = "..spellID);
	if spellID ~= nil and spellID ~= "" then
		if (FrameIndex == 1) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_Items[EA_playerClass], "EAFrame_");
		elseif (FrameIndex == 2) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_AltItems[EA_playerClass], "EAFrame_");
		elseif (FrameIndex == 3) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_Items[EA_CLASS_OTHER], "EAFrame_");
		elseif (FrameIndex == 4) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_TarItems[EA_playerClass], "EATarFrame_");
		elseif (FrameIndex == 5) then
			EACFFun_EventsFrame_DelSpell(FrameIndex, spellID, EA_ScdItems[EA_playerClass], "EAScdFrame_");
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
