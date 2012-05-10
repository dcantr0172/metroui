
-------------------------------------------------------------------------------
--                            GearScoreLite                                  --
--                             Version 3x03                                   --
--								Mirrikat45                                   --
-------------------------------------------------------------------------------

------------------------------------------------------------------------------

local L = {};
L["GearScore"] = "GearScore";
L["GearScore: "] = "GearScore: ";
L["(iLevel: "] = "(iLevel: ";
L["YourScore: "] = "YourScore: ";
L["HunterScore: "] = "HunterScore: ";
L["Cache"] = "(Cache)";

if (GetLocale() == "zhCN") then
--	L["GearScore"] = "装备评分(GS)";
--	L["GearScore: "] = "◇装备评分(GS): ";
	L["(iLevel: "] = "(物品等级: ";
	L["YourScore: "] = "你的评分: ";
	L["HunterScore: "] = "猎人评分: ";
	L["Cache"] = "(缓存)";
elseif (GetLocale() == "zhTW") then
--	L["GearScore"] = "裝備評分(GS)";
--	L["GearScore: "] = "裝備評分(GS): ";
	L["(iLevel: "] = "(物品等級: ";
	L["YourScore: "] = "你的評分: ";
	L["HunterScore: "] = "獵人評分: ";
	L["Cache"] = "(緩存)";
end

local GS_Tooltip = CreateFrame("GameTooltip", "GearScore_Tooltip", UIParent, "GameTooltipTemplate");
GS_Tooltip:Hide();
------------------------------
-- 来自Warbaby RatingSummary
local InspectLess = LibStub("LibInspectLess-1.0")
local GearScore_Cache = {};
local tip = {}

function tip:InspectLess_InspectItemReady(event, unit, guid)
	self:SetGearScore(unit, guid);
end

function tip:InspectLess_Next(event, locked)
	local _, unit = GameTooltip:GetUnit()
	if unit and UnitGUID(unit)~=InspectLess:GetGUID() then
		if tip:ShouldGet(unit) and CanInspect(unit) and (not InspectFrame or not InspectFrame:IsShown()) and (not Examiner or not Examiner:IsShown()) then
			NotifyInspect(unit);
		end
	end
end

function GearScore_OnEvent(GS_Nil, GS_EventName, GS_Prefix, GS_AddonMessage, GS_Whisper, GS_Sender)
	if ( GS_EventName == "PLAYER_REGEN_ENABLED" ) then GS_PlayerIsInCombat = false; return; end
	if ( GS_EventName == "PLAYER_REGEN_DISABLED" ) then GS_PlayerIsInCombat = true; return; end
	if ( GS_EventName == "PLAYER_EQUIPMENT_CHANGED" ) then
		local MyGearScore = GearScore_GetScore(UnitName("player"), "player");
		local Red, Blue, Green = GearScore_GetQuality(MyGearScore)
    		PersonalGearScore:SetText(MyGearScore); 
		PersonalGearScore:SetTextColor(Red, Green, Blue, 1)
  	end
	if ( GS_EventName == "ADDON_LOADED" ) then
		if ( GS_Prefix == "GearScoreLite" ) then
      		if not ( GS_Settings ) then	
				GS_Settings = GS_DefaultSettings 
			end
			if not ( GS_Data ) then GS_Data = {}; end; 
			if not ( GS_Data[GetRealmName()] ) then
				GS_Data[GetRealmName()] = { ["Players"] = {} };
			end
  			for i, v in pairs(GS_DefaultSettings) do if not ( GS_Settings[i] ) then GS_Settings[i] = GS_DefaultSettings[i]; end; end
		end

		InspectLess.RegisterCallback(tip, "InspectLess_InspectItemReady")
		InspectLess.RegisterCallback(tip, "InspectLess_Next")
	end
end

function tip:ShouldGet(unit)
	return UnitLevel(unit)>=80
end

function tip:SetGearScore(unit, guid)
	local GearScore, AltScore = GearScore_GetScore(UnitName(unit), unit)
	local Red, Blue, Green = GearScore_GetQuality(GearScore)

	if GearScore then
		local _, unit = GameTooltip:GetUnit();
		if unit and UnitGUID(unit)==guid then
			local score;
			if (AltScore == 0) then
				score = GearScore;
			elseif (AltScore > 0) then
				score = GearScore.."(|cFF33FF00+"..AltScore.."|r)";
			else
				score = GearScore.."(|cFFFF1F00"..AltScore.."|r)";
			end
			self:SetTooltipText(score, Red, Blue, Green, nil);
		end
	end
end

function tip:SetTooltipText(score, r, g, b, isCache)
	local text = isCache and L["GearScore: "]..score..L["Cache"] or L["GearScore: "]..score;
	for i = 2, GameTooltip:NumLines() do		
		if (string.find(_G["GameTooltipTextLeft"..i]:GetText() or "","GearScore")) then			
		--if (string.find(_G["GameTooltipTextLeft"..i]:GetText() or "","(GS)")) then			
			_G["GameTooltipTextLeft"..i]:SetText(text, r, g, b);
			GameTooltip:Show();
			return;
		end
	end

	GameTooltip:AddLine(text, r, g, b);
	GameTooltip:Show()
end

-------------------------- 获取Miss的宝石格数 -----------------------------------
function GearScore_GetMissGemCount(itemLink)
	local MissingGemCount = 0;
	if (not itemLink or type(itemLink) ~= "string") then
		return 0;
	end
	
	local EmptyTextures = {
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta"] = "Meta",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Red"] = "Red",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow"] = "Yellow",
		["Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue"] = "Blue"
	};
	for i = 1, 4 do
		if ( _G["GearScore_TooltipTexture"..i] ) then
			_G["GearScore_TooltipTexture"..i]:SetTexture("");
	 	end
	end
	GearScore_Tooltip:SetOwner(UIParent,"ANCHOR_NONE");
 	GearScore_Tooltip:ClearLines();
 	GearScore_Tooltip:SetHyperlink(itemLink);
 	for i = 1,4 do
 		local texture = _G["GearScore_TooltipTexture"..i]:GetTexture();
 		if ( texture ) then
 			if ( EmptyTextures[texture] ) then	 			
	 			MissingGemCount = MissingGemCount + 1;
	 		end	 		
	 	end
 	end
	return MissingGemCount;
end
-------------------------- 判断装备是否附魔 -------------------------------------
function GearScore_IsItemEnchant(itemLink)
	if (not itemLink or type(itemLink) ~= "string") then
		return false;
	end
	
	local enchantID = itemLink:match("item:%d+:(%d+):");
	if (tonumber(enchantID) == 0) then
		return false;
	else
		return true;
	end
end
-------------------------- Get Mouseover Score -----------------------------------
function GearScore_GetScore(Name, Target)
	if ( UnitIsPlayer(Target) ) then
		local PlayerClass, PlayerEnglishClass = UnitClass(Target);
		local GearScore = 0;
		local PVPScore = 0;
		local ItemCount = 0;
		local AltScore = 0;
		local TitanGrip = 1; 
		local TempEquip = {}; 
		local TempPVPScore = 0
		local TempScore, TempAltItemScore, TempPVPScore = 0, 0, 0;

		if ( GetInventoryItemLink(Target, 16) ) and ( GetInventoryItemLink(Target, 17) ) then
      			local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(GetInventoryItemLink(Target, 16))
			if ( ItemEquipLoc == "INVTYPE_2HWEAPON" ) then TitanGrip = 0.5; end
		end

		if ( GetInventoryItemLink(Target, 17) ) then
			local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(GetInventoryItemLink(Target, 17))
			if ( ItemEquipLoc == "INVTYPE_2HWEAPON" ) then TitanGrip = 0.5; end
			TempScore, TempAltItemScore = GearScore_GetItemScore(GetInventoryItemLink(Target, 17));
			if ( PlayerEnglishClass == "HUNTER" ) then TempScore = TempScore * 0.3164; end
			GearScore = GearScore + TempScore * TitanGrip;
			ItemCount = ItemCount + 1;
			AltScore = AltScore + TempAltItemScore;
		end
		
		for i = 1, 18 do
			if ( i ~= 4 ) and ( i ~= 17 ) then
        			ItemLink = GetInventoryItemLink(Target, i)
        			GS_ItemLinkTable = {}
				if ( ItemLink ) then
        				local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(ItemLink)
        				if (ItemName and ItemLink) then					
						if ( GS_Settings["Detail"] == 1 ) then GS_ItemLinkTable[i] = ItemLink; end
						TempScore, TempAltItemScore = GearScore_GetItemScore(ItemLink);
						if ( i == 16 ) and ( PlayerEnglishClass == "HUNTER" ) then TempScore = TempScore * 0.3164; end
						if ( i == 18 ) and ( PlayerEnglishClass == "HUNTER" ) then TempScore = TempScore * 5.3224; end
						if ( i == 16 ) then TempScore = TempScore * TitanGrip; end
						GearScore = GearScore + TempScore;	
						ItemCount = ItemCount + 1; 
						AltScore = AltScore + (TempAltItemScore or 0);
					end
				end
			end;
		end
		if ( GearScore <= 0 ) and ( Name ~= UnitName("player") ) then
			GearScore = 0; return 0,0;
		elseif ( Name == UnitName("player") ) and ( GearScore <= 0 ) then
		    GearScore = 0; 
		end
		if ( ItemCount == 0 ) then LevelTotal = 0; end
		local score;
		if (AltScore == 0) then
			score = GearScore;
		elseif (AltScore > 0) then
			score = GearScore.."(|cFF33FF00+"..AltScore.."|r)";
		else
			score = GearScore.."(|cFFC41F3B"..AltScore.."|r)";
		end
		GearScore_Cache[UnitGUID(Target)] = score;
		return floor(GearScore), floor(AltScore)
	end
end

-------------------------------------------------------------------------------

------------------------------ Get Item Score ---------------------------------
function GearScore_GetItemScore(ItemLink)
	GearScore_ScoreBuff = GearScore_ScoreBuff or {}
	if GearScore_ScoreBuff[ItemLink] then return unpack(GearScore_ScoreBuff[ItemLink]) end
	local QualityScale = 1; local PVPScale = 1; local PVPScore = 0; local GearScore = 0
	if not ( ItemLink ) then
		return 0, 0; 
	end
	local AltItemScore = 0;
	local ItemName, link, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(ItemLink);
	local Table = {};
	--local Scale = 1.8618
	local Scale = 1.8291
 	if ( ItemRarity == 5 ) then 
		QualityScale = 1.3; 
		ItemRarity = 4;
	elseif ( ItemRarity == 1 ) then 
		QualityScale = 0.005; 
		ItemRarity = 2
	elseif ( ItemRarity == 0 ) then 
		QualityScale = 0.005; 
		ItemRarity = 2
	end

	if ( ItemRarity == 7 ) then 
		ItemRarity = 3; 
		ItemLevel = 187.05; 
	end

	if ( GS_ItemTypes[ItemEquipLoc] ) then
		if ( ItemLevel > 277 ) then
			Table = GS_Formula["C"]
		elseif ( ItemLevel > 120 ) then 
			Table = GS_Formula["B"]; 
		else 
			Table = GS_Formula["A"]; 
		end
		if ( ItemRarity >= 2 ) and ( ItemRarity <= 4 )then
			local Red, Green, Blue = GearScore_GetQuality((floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) * 1 * Scale)) * 11.25 )
			GearScore = floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) * GS_ItemTypes[ItemEquipLoc].SlotMOD * Scale * QualityScale)
			if ( ItemLevel == 187.05 ) then 
				ItemLevel = 0; 
			end
			if ( GearScore < 0 ) then 
				GearScore = 0;  
				Red, Green, Blue = GearScore_GetQuality(1); 
			end
			if ( PVPScale == 0.75 ) then 
				PVPScore = 1; 
				GearScore = GearScore * 1; 
			else
				PVPScore = GearScore * 0; 
			end
			GearScore = floor(GearScore);
			PVPScore = floor(PVPScore);			
			
			if (GearScore_IsItemEnchant(ItemLink)) then
				AltItemScore = GearScore * 0.03;
			end
			if (GearScore_GetMissGemCount(ItemLink) > 0) then
				AltItemScore = AltItemScore - GearScore * 0.02 * GearScore_GetMissGemCount(ItemLink);
			end
			
			AltItemScore = floor(AltItemScore);
			GearScore = GearScore + AltItemScore; -- 修正GS

			GearScore_ScoreBuff[ItemLink] = {GearScore, AltItemScore, GS_ItemTypes[ItemEquipLoc].ItemSlot, Red, Green, Blue, PVPScore, ItemEquipLoc}
			return GearScore, AltItemScore, GS_ItemTypes[ItemEquipLoc].ItemSlot, Red, Green, Blue, PVPScore, ItemEquipLoc;
		end
  	end
	GearScore_ScoreBuff[ItemLink] = {-1, AltItemScore, 50, 1, 1, 1, PVPScore, ItemEquipLoc}
	return -1, AltItemScore, 50, 1, 1, 1, PVPScore, ItemEquipLoc
end
-------------------------------------------------------------------------------

-------------------------------- Get Quality ----------------------------------

function GearScore_GetQuality(ItemScore)
	local Red = 0.1; local Blue = 0.1; local Green = 0.1; local GS_QualityDescription = "Legendary"
   	if not ( ItemScore ) then return 0, 0, 0, "Trash"; end
	for i = 0,6 do
		if ( ItemScore > i * 1000 ) and ( ItemScore <= ( ( i + 1 ) * 1000 ) ) then
		    local Red = GS_Quality[( i + 1 ) * 1000].Red["A"] + (((ItemScore - GS_Quality[( i + 1 ) * 1000].Red["B"])*GS_Quality[( i + 1 ) * 1000].Red["C"])*GS_Quality[( i + 1 ) * 1000].Red["D"])
            local Blue = GS_Quality[( i + 1 ) * 1000].Green["A"] + (((ItemScore - GS_Quality[( i + 1 ) * 1000].Green["B"])*GS_Quality[( i + 1 ) * 1000].Green["C"])*GS_Quality[( i + 1 ) * 1000].Green["D"])
            local Green = GS_Quality[( i + 1 ) * 1000].Blue["A"] + (((ItemScore - GS_Quality[( i + 1 ) * 1000].Blue["B"])*GS_Quality[( i + 1 ) * 1000].Blue["C"])*GS_Quality[( i + 1 ) * 1000].Blue["D"])
			--if not ( Red ) or not ( Blue ) or not ( Green ) then return 0.1, 0.1, 0.1, nil; end
			return Red, Green, Blue, GS_Quality[( i + 1 ) * 1000].Description
		end
	end
	if (ItemScore > 7000) then
		return 0.88, 0, 0.59
	end
	return 0.1, 0.1, 0.1
end
-------------------------------------------------------------------------------

----------------------------- Hook Set Unit -----------------------------------
function GearScore_HookSetUnit(self, ...)
	local _, unit = self:GetUnit();
	if not unit then return end
	
	local guid = UnitGUID(unit)
	if InspectLess:GetGUID() and InspectLess:GetGUID()==guid then
		if InspectLess:IsDone() then
			tip:SetGearScore(unit, guid)
			return
		end
	end

	if GearScore_Cache and GearScore_Cache[guid] then
		local cache = GearScore_Cache[guid]
		tip:SetTooltipText(cache, true)
	end

	if tip:ShouldGet(unit) and CanInspect(unit) and (not InspectFrame or not InspectFrame:IsShown()) and (not Examiner or not Examiner:IsShown()) then
		NotifyInspect(unit);
	end	
end

function GearScore_SetDetails(tooltip, Name)
    if not ( UnitName("mouseover") ) or ( UnitName("mouseover") ~= Name )then return; end
  	for i = 1,18 do
  	    if not ( i == 4 ) then
    		local ItemName, ItemLink, ItemRarity, ItemLevel, ItemMinLevel, ItemType, ItemSubType, ItemStackCount, ItemEquipLoc, ItemTexture = GetItemInfo(GS_ItemLinkTable[i])
			if ( ItemLink ) then
				local GearScore, AltItemScore, ItemType, Red, Green, Blue = GearScore_GetItemScore(ItemLink)
				--local Red, Green, Blue = GearScore_GetQuality((floor(((ItemLevel - Table[ItemRarity].A) / Table[ItemRarity].B) * 1 * 1.8618)) * 11.25 )
				if ( GearScore ) and ( i ~= 4 ) then
					local Add = ""
					if ( GS_Settings["Level"] == 1 ) then 
						Add = L["(iLevel: "]..tostring(ItemLevel)..")"; 
					end
					tooltip:AddDoubleLine("["..ItemName.."]", tostring(GearScore)..Add, GS_Rarity[ItemRarity].Red, GS_Rarity[ItemRarity].Green, GS_Rarity[ItemRarity].Blue, Red, Blue, Green)
				end
			end
		end
	end
end
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
function GearScore_HookSetItem()
	ItemName, ItemLink = GameTooltip:GetItem()
	GearScore_HookItem(ItemName, ItemLink, GameTooltip); 
end
function GearScore_HookRefItem() 
	ItemName, ItemLink = ItemRefTooltip:GetItem(); GearScore_HookItem(ItemName, ItemLink, ItemRefTooltip); 
end
function GearScore_HookCompareItem() 
	ItemName, ItemLink = ShoppingTooltip1:GetItem(); GearScore_HookItem(ItemName, ItemLink, ShoppingTooltip1); 
end
function GearScore_HookCompareItem2()  ItemName, ItemLink = ShoppingTooltip2:GetItem(); GearScore_HookItem(ItemName, ItemLink, ShoppingTooltip2); end
function GearScore_HookItem(ItemName, ItemLink, Tooltip)	
	if ( GS_PlayerIsInCombat ) then return; end


	local PlayerClass, PlayerEnglishClass = UnitClass("player");
	if not ( IsEquippableItem(ItemLink) ) then return; end
	local ItemScore, AltItemScore, EquipLoc, Red, Green, Blue, PVPScore, ItemEquipLoc = GearScore_GetItemScore(ItemLink);
 	if ( ItemScore >= 0 ) then
		if ( GS_Settings["Item"] == 1 ) then
  			if (AltItemScore == 0) then
				Tooltip:AddLine(L["GearScore: "]..ItemScore, Red, Blue, Green)
			elseif (AltItemScore > 0) then
				Tooltip:AddLine(L["GearScore: "]..ItemScore.."(|cFF33FF00+"..AltItemScore.."|r)", Red, Blue, Green)
			else
				Tooltip:AddLine(L["GearScore: "]..ItemScore.."(|cFFFF1F00"..AltItemScore.."|r)", Red, Blue, Green)
			end
			
			if ( PlayerEnglishClass == "HUNTER" ) then
				if ( ItemEquipLoc == "INVTYPE_RANGEDRIGHT" ) or ( ItemEquipLoc == "INVTYPE_RANGED" ) then
					Tooltip:AddLine(L["HunterScore: "]..floor(ItemScore * 5.3224), Red, Blue, Green)
				end
				if ( ItemEquipLoc == "INVTYPE_2HWEAPON" ) or ( ItemEquipLoc == "INVTYPE_WEAPONMAINHAND" ) or ( 	ItemEquipLoc == "INVTYPE_WEAPONOFFHAND" ) or ( ItemEquipLoc == "INVTYPE_WEAPON" ) or ( ItemEquipLoc == "INVTYPE_HOLDABLE" )  then
					Tooltip:AddLine(L["HunterScore: "]..floor(ItemScore * 0.3164), Red, Blue, Green)
				end
			end
  		end
	else
	    if ( GS_Settings["Level"] == 1 ) and ( ItemLevel ) then
	        Tooltip:AddLine(L["iLevel "]..ItemLevel)
		end
    end
end

function MyPaperDoll()
	if ( GS_PlayerIsInCombat ) then return; end
	local MyGearScore, MyAltScore = GearScore_GetScore(UnitName("player"), "player");
	local Red, Blue, Green = GearScore_GetQuality(MyGearScore)
	
	if (MyAltScore == 0) then
		PersonalGearScore:SetText(MyGearScore); 
	elseif (MyAltScore > 0) then
		PersonalGearScore:SetText(MyGearScore.."(|cFF33FF00+"..MyAltScore.."|r)"); 
	else
		PersonalGearScore:SetText(MyGearScore.."(|cFFFF1F00"..MyAltScore.."|r)"); 
	end
	PersonalGearScore:SetTextColor(Red, Green, Blue, 1)
end
-------------------------------------------------------------------------------

----------------------------- Reports -----------------------------------------

---------------GS-SPAM Slasch Command--------------------------------------
function GS_MANSET(Command)
	if ( strlower(Command) == "" ) or ( strlower(Command) == "options" ) or ( strlower(Command) == "option" ) or ( strlower(Command) == "help" ) then for i,v in ipairs(GS_CommandList) do print(v); end; return end
	if ( strlower(Command) == "show" ) then GS_Settings["Player"] = GS_ShowSwitch[GS_Settings["Player"]]; if ( GS_Settings["Player"] == 1 ) or ( GS_Settings["Player"] == 2 ) then print("Player Scores: On"); else print("Player Scores: Off"); end; return; end
	if ( strlower(Command) == "player" ) then GS_Settings["Player"] = GS_ShowSwitch[GS_Settings["Player"]]; if ( GS_Settings["Player"] == 1 ) or ( GS_Settings["Player"] == 2 ) then print("Player Scores: On"); else print("Player Scores: Off"); end; return; end
    if ( strlower(Command) == "item" ) then GS_Settings["Item"] = GS_ItemSwitch[GS_Settings["Item"]]; if ( GS_Settings["Item"] == 1 ) or ( GS_Settings["Item"] == 3 ) then print("Item Scores: On"); else print("Item Scores: Off"); end; return; end
	if ( strlower(Command) == "level" ) then GS_Settings["Level"] = GS_Settings["Level"] * -1; if ( GS_Settings["Level"] == 1 ) then print ("Item Levels: On"); else print ("Item Levels: Off"); end; return; end
	if ( strlower(Command) == "compare" ) then GS_Settings["Compare"] = GS_Settings["Compare"] * -1; if ( GS_Settings["Compare"] == 1 ) then print ("Comparisons: On"); else print ("Comparisons: Off"); end; return; end
	--print("GearScore: Unknown Command. Type '/gs' for a list of options")
end

function GS_Toggle(tog)
	if tog then
		GS_Settings["Player"] = 1
		GS_Settings["Item"] = 1
		PersonalGearScore:Show()
		GearScore2:Show()
	else
		GS_Settings["Player"] = 0
		GS_Settings["Item"] = 0
		PersonalGearScore:Hide()
		GearScore2:Hide()
	end
end

------------------------ GUI PROGRAMS -------------------------------------------------------

local f = CreateFrame("Frame", "GearScore", UIParent);
f:SetScript("OnEvent", GearScore_OnEvent);
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
GameTooltip:HookScript("OnTooltipSetUnit", GearScore_HookSetUnit)
GameTooltip:HookScript("OnTooltipSetItem", GearScore_HookSetItem)
ShoppingTooltip1:HookScript("OnTooltipSetItem", GearScore_HookCompareItem)
ShoppingTooltip2:HookScript("OnTooltipSetItem", GearScore_HookCompareItem2)
ItemRefTooltip:HookScript("OnTooltipSetItem", GearScore_HookRefItem)
PaperDollFrame:HookScript("OnShow", MyPaperDoll)
CharacterModelFrame:CreateFontString("PersonalGearScore", "ARTWORK")

do
    local __font = 'Fonts\\FRIZQT__.TTF'

    local function gsInitInspectFrame()
        local text1 = InspectModelFrame:CreateFontString("InspectGearScore");
        text1:SetFont(__font, 12);
        text1:SetText("GS: 0");
        text1:SetPoint("BOTTOMRIGHT",InspectPaperDollFrame,"TOPRIGHT",-65,-83);
        --text1:SetPoint("BOTTOMRIGHT",InspectPaperDollFrame,"TOPRIGHT",-65,-245);

        local text2 = InspectModelFrame:CreateFontString("InpsectGearScoreText");
        text2:SetFont(__font, 12);
        text2:SetText(L["GearScore"]);
        --text2:SetPoint("BOTTOMRIGHT",InspectPaperDollFrame,"TOPRIGHT",-65,-258);
        text2:SetPoint('TOPRIGHT', text1, 'BOTTOMRIGHT', 0, -5)

        InspectPaperDollFrame:HookScript("OnShow", function(self)
            if ( GS_PlayerIsInCombat ) then return; end
            local InspcetGearScore, InspectAltScore = GearScore_GetScore(UnitName(InspectFrame.unit), InspectFrame.unit);
            local Red, Blue, Green = GearScore_GetQuality(InspcetGearScore)
            if (InspectAltScore == 0) then
                InspectGearScore:SetText(InspcetGearScore);
            elseif (InspectAltScore > 0) then
                InspectGearScore:SetText(InspcetGearScore.."(|cFF33FF00+"..InspectAltScore.."|r)");
            else
                InspectGearScore:SetText(InspcetGearScore.."(|cFFFF1F00"..InspectAltScore.."|r)");
            end
            InspectGearScore:SetTextColor(Red, Green, Blue, 1)
        end);	
    end

    local _inspectui = 'Blizzard_InspectUI'
    if(IsAddOnLoaded(_inspectui)) then
        gsInitInspectFrame()
    else
        local f = CreateFrame'Frame'
        f:SetScript('OnEvent', function(self, event, addon)
            if(addon == _inspectui) then
                gsInitInspectFrame()
                self:UnregisterAllEvents()
                self:SetScript('OnEvent', nil)
                self:Hide()
            end
        end)
        f:RegisterEvent'ADDON_LOADED'
    end
end

local __font = 'Fonts\\FRIZQT__.TTF'
--PersonalGearScore:SetFont("Fonts\\FRIZQT__.TTF", 12)
PersonalGearScore:SetFont(__font, 20)
PersonalGearScore:SetText("GS: 0")
--PersonalGearScore:SetPoint("BOTTOMRIGHT",PaperDollFrame,"TOPLEFT", 270, -350)
PersonalGearScore:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 60, -28)
PersonalGearScore:Show()
CharacterModelFrame:CreateFontString("GearScore2")
GearScore2:SetFont(__font, 12)
GearScore2:SetText(L["GearScore"])
--GearScore2:SetPoint("BOTTOMRIGHT",PaperDollFrame,"TOPLEFT",270,-362)
GearScore2:SetPoint('TOPLEFT', PaperDollFrame, 'TOPLEFT', 60, -50)
GearScore2:Show()


local GS_LastNotified
function GearScore_OnEnter(Name, ItemSlot, Argument)	
	if  UnitName("target") and UnitName("target") ~= GS_LastNotified then
		NotifyInspect("target");
		GS_LastNotified = UnitName("target");
		GS_MouseOver = nil
	end
	local OriginalOnEnter = GearScore_Original_SetInventoryItem(Name, ItemSlot, Argument); return OriginalOnEnter
end

GearScore_Original_SetInventoryItem = GameTooltip.SetInventoryItem
GameTooltip.SetInventoryItem = GearScore_OnEnter

SlashCmdList["MY2SCRIPT"] = GS_MANSET
SLASH_MY2SCRIPT1 = "/gset"
SLASH_MY2SCRIPT2 = "/gs"
SLASH_MY2SCRIPT3 = "/gearscore"


