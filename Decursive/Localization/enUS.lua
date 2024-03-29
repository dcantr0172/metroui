--[[
    This file is part of Decursive.
    
    Decursive (v 2.7.0.5) add-on for World of Warcraft UI
    Copyright (C) 2006-2007-2008-2009-2010-2011 John Wellesz (archarodim AT
    teaser.fr) ( http://www.2072productions.com/to/decursive.php )

    Starting from 2009-10-31 and until said otherwise by its author, Decursive
    is no longer free software, all rights are reserved to its author (John
    Wellesz).

    The only official and allowed distribution means are
    www.2072productions.com, www.wowace.com and curse.com.
    To distribute Decursive through other means a special authorization is
    required.
    

    Decursive is inspired from the original "Decursive v1.9.4" by Quu.
    The original "Decursive 1.9.4" is in public domain ( www.quutar.com )

    Decursive is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY.

    This file was last updated on 2011-11-06T13:34:55Z
--]]
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- English default localization
-------------------------------------------------------------------------------

--[=[
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating Decursive.
--    Do not edit those files. Use the localization interface available at the following address:
--
--      ################################################################
--      #  http://wow.curseforge.com/projects/decursive/localization/  #
--      ################################################################
--
--    Your translations made using this interface will be automatically included in the next release.
--
--]=]


local addonName, T = ...;
-- big ugly scary fatal error message display function {{{
if not T._FatalError then
-- the beautiful error popup : {{{ -
StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] = {
    text = "|cFFFF0000Decursive Error:|r\n%s",
    button1 = "OK",
    OnAccept = function()
        return false;
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    showAlert = 1,
    }; -- }}}
T._FatalError = function (TheError) StaticPopup_Show ("DECURSIVE_ERROR_FRAME", TheError); end
end
-- }}}
if not T._LoadedFiles or not T._LoadedFiles["Dcr_DIAG.xml"] or not T._LoadedFiles["Dcr_DIAG.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (Dcr_DIAG.lua or Dcr_DIAG.xml not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end


local L = LibStub("AceLocale-3.0"):NewLocale("Decursive", "enUS", true, false);

if not L then return end;

L["ABOLISH_CHECK"] = "Check for \"Abolish\" before curing"
L["ABOUT_AUTHOREMAIL"] = "AUTHOR E-MAIL"
L["ABOUT_CREDITS"] = "CREDITS"
L["ABOUT_LICENSE"] = "LICENSE"
L["ABOUT_NOTES"] = "Afflictions display and cleaning for solo, group and raid with advanced filtering and priority system."
L["ABOUT_OFFICIALWEBSITE"] = "OFFICIAL WEBSITE"
L["ABOUT_SHAREDLIBS"] = "SHARED LIBRARIES"
L["ABSENT"] = "Missing (%s)"
L["AFFLICTEDBY"] = "%s Afflicted"
L["ALT"] = "Alt"
L["AMOUNT_AFFLIC"] = "The amount of afflicted to show : "
L["ANCHOR"] = "Decursive Text Anchor"
L["BINDING_NAME_DCRMUFSHOWHIDE"] = "Show or hide the micro-unit frames"
L["BINDING_NAME_DCRPRADD"] = "Add target to priority list"
L["BINDING_NAME_DCRPRCLEAR"] = "Clear the priority list"
L["BINDING_NAME_DCRPRLIST"] = "Print the priority list"
L["BINDING_NAME_DCRPRSHOW"] = "Show or hide the priority list"
L["BINDING_NAME_DCRSHOW"] = [=[Show or hide Decursive Main Bar
(live-list anchor)]=]
L["BINDING_NAME_DCRSHOWOPTION"] = "Display the option static panel"
L["BINDING_NAME_DCRSKADD"] = "Add target to skip list"
L["BINDING_NAME_DCRSKCLEAR"] = "Clear the skip list"
L["BINDING_NAME_DCRSKLIST"] = "Print the skip list"
L["BINDING_NAME_DCRSKSHOW"] = "Show or hide the skip list"
L["BLACK_LENGTH"] = "Seconds on the blacklist : "
L["BLACKLISTED"] = "Black-listed"
L["CHARM"] = "Charm"
L["CLASS_HUNTER"] = "Hunter"
L["CLEAR_PRIO"] = "C"
L["CLEAR_SKIP"] = "C"
L["COLORALERT"] = "Set the color alert when a '%s' is required."
L["COLORCHRONOS"] = "Chronometers"
L["COLORCHRONOS_DESC"] = "Set the chronometers' color"
L["COLORSTATUS"] = "Set the color for the '%s' MUF status."
L["CTRL"] = "Ctrl"
L["CURE_PETS"] = "Scan and cure pets"
L["CURSE"] = "Curse"
L["DEBUG_REPORT_HEADER"] = [=[|cFF11FF33Please report the content of this window to Archarodim+DcrReport@teaser.fr|r
|cFF009999(Use CTRL+A to select all and then CTRL+C to put the text in your clip-board)|r
Also tell in your report if you noticed any strange behavior of Decursive.
]=]
L["DECURSIVE_DEBUG_REPORT"] = "**** |cFFFF0000Decursive Debug Report|r ****"
L["DECURSIVE_DEBUG_REPORT_NOTIFY"] = [=[A debug report is available!
Type |cFFFF0000/DCRREPORT|r to see it.]=]
L["DECURSIVE_DEBUG_REPORT_SHOW"] = "Debug report available!"
L["DECURSIVE_DEBUG_REPORT_SHOW_DESC"] = "Show a debug report the author needs to see..."
L["DEFAULT_MACROKEY"] = "`"
L["DEV_VERSION_ALERT"] = [=[You are using a development version of Decursive.

If you do not want to participate in testing new features/fixes, receive in-game debug reports, send issues to the author then DO NOT USE THIS VERSION and download the latest STABLE version on curse.com or wowace.com.

This message will be displayed only once per version]=]
L["DEV_VERSION_EXPIRED"] = [=[This development version of Decursive has expired.
You should, download the latest development version or go back to the current stable release available on CURSE.COM or WOWACE.COM.
This warning will be displayed every two days.]=]
L["DEWDROPISGONE"] = "There is no DewDrop equivalent for Ace3. Alt-Right-Click to open the option panel."
L["DISABLEWARNING"] = [=[Decursive has been disabled!

To enable it again, type |cFFFFAA44/DCR ENABLE|r]=]
L["DISEASE"] = "Disease"
L["DONOT_BL_PRIO"] = "Don't blacklist priority list names"
L["DONT_SHOOT_THE_MESSENGER"] = "Decursive is merely reporting the issue. So, don't shoot the messenger and address the actual problem."
L["FAILEDCAST"] = [=[|cFF22FFFF%s %s|r |cFFAA0000failed on|r %s
|cFF00AAAA%s|r]=]
L["FOCUSUNIT"] = "Focus Unit"
L["FUBARMENU"] = "FuBar Menu"
L["FUBARMENU_DESC"] = "Set options relative to FuBar icon"
L["GLOR1"] = "In memory of Glorfindal"
L["GLOR2"] = [=[Decursive is dedicated to the memory of Bertrand who left way too soon.
He will always be remembered.]=]
L["GLOR3"] = [=[In remembrance of Bertrand Sense
1969 - 2007]=]
L["GLOR4"] = [=[Friendship and affection can take their roots anywhere, those who met Glorfindal in World of Warcraft knew a man of great commitment and a charismatic leader.

He was in life as he was in game, selfless, generous, dedicated to his friends and most of all, a passionate man.

He left us at the age of 38 leaving behind him not just anonymous players in a virtual world but, a group of true friends who will miss him forever.]=]
L["GLOR5"] = "He will always be remembered..."
L["HANDLEHELP"] = "Drag all the Micro-UnitFrames (MUFs)"
L["HIDE_LIVELIST"] = "Hide the live-list"
L["HIDE_MAIN"] = "Hide Decursive Window"
L["HIDESHOW_BUTTONS"] = "Hide/Show buttons"
L["HLP_LEFTCLICK"] = "Left-Click"
L["HLP_LL_ONCLICK_TEXT"] = [=[The Live-List is not meant to be clicked. Please, read the documentation to learn how to use this add-on. Just search for 'Decursive' on WoWAce.com
(To move this list move the Decursive bar, /dcrshow and left-alt-click to move)]=]
L["HLP_MIDDLECLICK"] = "Middle-Click"
L["HLP_NOTHINGTOCURE"] = "There is nothing to cure!"
L["HLP_RIGHTCLICK"] = "Right-Click"
L["HLP_USEXBUTTONTOCURE"] = "Use \"%s\" to cure this affliction!"
L["HLP_WRONGMBUTTON"] = "Wrong mouse button!"
L["IGNORE_STEALTH"] = "Ignore cloaked Units"
L["IS_HERE_MSG"] = "Decursive is now initialized, remember to check the options"
L["LIST_ENTRY_ACTIONS"] = [=[|cFF33AA33[CTRL]|r-Click: Remove this player
|cFF33AA33LEFT|r-Click: Rise this player
|cFF33AA33RIGHT|r-Click: Come down this player
|cFF33AA33[SHIFT] LEFT|r-Click: Put this player at the top
|cFF33AA33[SHIFT] RIGHT|r-Click: Put this player at the bottom]=]
L["MACROKEYALREADYMAPPED"] = [=[WARNING: The key mapped to Decursive macro [%s] was mapped to action '%s'.
Decursive will restore the previous mapping if you set another key for its macro.]=]
L["MACROKEYMAPPINGFAILED"] = "The key [%s] could not be mapped to Decursive macro!"
L["MACROKEYMAPPINGSUCCESS"] = "The key [%s] has been successfully mapped to Decursive macro."
L["MACROKEYNOTMAPPED"] = "Decursive mouse-over macro is not mapped to a key, take a look at the 'Macro' options!"
L["MAGIC"] = "Magic"
L["MAGICCHARMED"] = "Magic Charm"
L["MISSINGUNIT"] = "Missing unit"
L["NEW_VERSION_ALERT"] = [=[A new version of Decursive has been detected: |cFFEE7722%q|r released on |cFFEE7722%s|r!


Go to |cFFFF0000WoWAce.com|r to get it!
--------]=]
L["NORMAL"] = "Normal"
L["NOSPELL"] = "No spell available"
L["OPT_ABOLISHCHECK_DESC"] = "select whether units with an active 'Abolish' spell are shown and cured"
L["OPT_ABOUT"] = "About"
L["OPT_ADD_A_CUSTOM_SPELL"] = "Add a custom spell"
L["OPT_ADD_A_CUSTOM_SPELL_DESC"] = "Click here and shift-click on a spell from your spell book. You can also directly write its name or its numeric ID."
L["OPT_ADDDEBUFF"] = "Add a custom affliction"
L["OPT_ADDDEBUFF_DESC"] = "Adds a new affliction to this list"
L["OPT_ADDDEBUFFFHIST"] = "Add a recent affliction"
L["OPT_ADDDEBUFFFHIST_DESC"] = "Add an affliction using the history"
L["OPT_ADDDEBUFF_USAGE"] = "<Affliction name>"
L["OPT_ADVDISP"] = "Advance display Options"
L["OPT_ADVDISP_DESC"] = "Allow to set Transparency of the border and center separately, to set the space between each MUF"
L["OPT_AFFLICTEDBYSKIPPED"] = "%s afflicted by %s will be skipped"
L["OPT_ALLOWMACROEDIT"] = "Allow macro edition"
L["OPT_ALLOWMACROEDIT_DESC"] = "Enable this to prevent Decursive from updating its macro, letting you edit it as you want."
L["OPT_ALWAYSIGNORE"] = "Also ignore when not in combat"
L["OPT_ALWAYSIGNORE_DESC"] = "If checked, this affliction will also be ignored when you are not in combat"
L["OPT_AMOUNT_AFFLIC_DESC"] = "Defines the max number of cursed to display in the live-list"
L["OPT_ANCHOR_DESC"] = "Shows the anchor of the custom message frame"
L["OPT_AUTOHIDEMFS"] = "Hide MUFs when:"
L["OPT_AUTOHIDEMFS_DESC"] = "Choose when to automatically hide the MUFs' window."
L["OPT_BLACKLENTGH_DESC"] = "Defines how long someone stays on the blacklist"
L["OPT_BORDERTRANSP"] = "Border transparency"
L["OPT_BORDERTRANSP_DESC"] = "Set the transparency of the border"
L["OPT_CENTERTRANSP"] = "Center transparency"
L["OPT_CENTERTRANSP_DESC"] = "Set the transparency of the center"
L["OPT_CHARMEDCHECK_DESC"] = "If checked you'll be able to see and deal with charmed units"
L["OPT_CHATFRAME_DESC"] = "Decursive's messages will be printed to the default chat frame"
L["OPT_CHECKOTHERPLAYERS"] = "Check other players"
L["OPT_CHECKOTHERPLAYERS_DESC"] = "Displays Decursive version among the players in your current group or guild (cannot display versions prior to Decursive 2.4.6)."
L["OPT_CMD_DISBLED"] = "Disabled"
L["OPT_CMD_ENABLED"] = "Enabled"
L["OPT_CREATE_VIRTUAL_DEBUFF"] = "Create a virtual test affliction"
L["OPT_CREATE_VIRTUAL_DEBUFF_DESC"] = "Lets you see how Decursive looks when an affliction is found."
L["OPT_CUREPETS_DESC"] = "Pets will be managed and cured"
L["OPT_CURE_PRIORITY_NUM"] = "Priority #%d"
L["OPT_CURINGOPTIONS"] = "Curing Options"
L["OPT_CURINGOPTIONS_DESC"] = "Curing options including options to change priority for each affliction type"
L["OPT_CURINGOPTIONS_EXPLANATION"] = [=[Select the types of affliction you want to cure, unchecked types will be completely ignored by Decursive.

The green numbers represent the priority associated to each affliction type. This priority determines the following options:

- Which affliction type Decursive shows you first if a player has several afflictions types.

- The color and binding associated with each affliction type.

(To change the priorities, uncheck all the check boxes and then check them in order of the priority you want.)]=]
L["OPT_CURINGORDEROPTIONS"] = "Affliction types and priorities"
L["OPT_CURSECHECK_DESC"] = "If checked you'll be able to see and cure cursed units"
L["OPT_CUSTOM_SPELL_ALLOW_EDITING"] = "Allow macro editing (for advanced users only)"
L["OPT_CUSTOM_SPELL_ALLOW_EDITING_DESC"] = [=[Check this if you want to edit the internal macro Decursive will use for your custom spell.

Note: Checking this allows you to modify spells managed by Decursive.
(---For advanced users only---)]=]
L["OPT_CUSTOM_SPELL_CURE_TYPES"] = "Affliction types"
L["OPT_CUSTOM_SPELL_IS_DEFAULT"] = "This spell is part of Decursive's automatic configuration. If this spell is no longer working correctly, you can remove or disable it to regain default Decursive behaviour."
L["OPT_CUSTOM_SPELL_MACRO_MISSING_NOMINAL_SPELL"] = "Warning: The spell %q is not present in your macro, range and cooldown information will not match..."
L["OPT_CUSTOM_SPELL_MACRO_MISSING_UNITID_KEYWORD"] = "The UNITID keyword is missing."
L["OPT_CUSTOM_SPELL_MACRO_TEXT"] = "Macro text:"
L["OPT_CUSTOM_SPELL_MACRO_TEXT_DESC"] = [=[Edit the default macro text.
|cFFFF0000Only 2 restrictions:|r

- You must specify the target using the UNITID keyword which will be automatically replaced by the unit ID of each MUF.

- Whatever is the spell used in the macro, Decursive will keep using the original name displayed on the left for range and cooldown display/tracking.
(keep that in mind if you plan on using different spells with conditionals)]=]
L["OPT_CUSTOM_SPELL_MACRO_TOO_LONG"] = "Your macro is too long, you need to remove %d characters."
L["OPT_CUSTOM_SPELL_PRIORITY"] = "Spell priority"
L["OPT_CUSTOM_SPELL_PRIORITY_DESC"] = "When several spells can cure the same affliction types, those with a higher priority will be preferred."
L["OPT_CUSTOMSPELLS"] = "Custom spells"
L["OPT_CUSTOMSPELLS_DESC"] = [=[Here you can add spells to extend Decursive's automatic configuration.
Your custom spells always have a higher priority and will override and replace the default spells (if and only if your character can use those spells).
]=]
L["OPT_CUSTOMSPELLS_EFFECTIVE_ASSIGNMENTS"] = "Effective spells assignments:"
L["OPT_CUSTOM_SPELL_STOPCASTING"] = "/StopCasting"
L["OPT_CUSTOM_SPELL_STOPCASTING_DESC"] = "Using this spell will interrupt other spells in progress (uncheck that if the spell comes from a pet)"
L["OPT_CUSTOM_SPELL_UNAVAILABLE"] = "unavailable"
L["OPT_DEBCHECKEDBYDEF"] = [=[

Checked by default]=]
L["OPT_DEBUFFENTRY_DESC"] = "Select what class should be ignored in combat when afflicted by this affliction"
L["OPT_DEBUFFFILTER"] = "Affliction filtering"
L["OPT_DEBUFFFILTER_DESC"] = "Select afflictions to filter out by name and class while you are in combat"
L["OPT_DELETE_A_CUSTOM_SPELL"] = "Remove"
L["OPT_DISABLEABOLISH"] = "Do not use 'Abolish' spells"
L["OPT_DISABLEABOLISH_DESC"] = "If enabled, Decursive will prefer 'Cure Disease' and 'Cure Poison' over their 'Abolish' equivalent."
L["OPT_DISABLEMACROCREATION"] = "Disable macro creation"
L["OPT_DISABLEMACROCREATION_DESC"] = "Decursive macro will no longer be created or maintained"
L["OPT_DISEASECHECK_DESC"] = "If checked you'll be able to see and cure diseased units"
L["OPT_DISPLAYOPTIONS"] = "Display options"
L["OPT_DONOTBLPRIO_DESC"] = "Prioritized units won't be blacklisted"
L["OPT_ENABLE_A_CUSTOM_SPELL"] = "Enable"
L["OPT_ENABLEDEBUG"] = "Enable Debugging"
L["OPT_ENABLEDEBUG_DESC"] = "Enable Debugging output"
L["OPT_ENABLEDECURSIVE"] = "Enable Decursive"
L["OPT_FILTEROUTCLASSES_FOR_X"] = "%q will be ignored on the specified classes while you are in combat."
L["OPT_GENERAL"] = "General options"
L["OPT_GROWDIRECTION"] = "Reverse MUFs Display"
L["OPT_GROWDIRECTION_DESC"] = "The MUFs will be displayed from bottom to top"
L["OPT_HIDELIVELIST_DESC"] = "If not hidden, displays an informative list of cursed people"
L["OPT_HIDEMFS_GROUP"] = "in solo or in party"
L["OPT_HIDEMFS_GROUP_DESC"] = "Hide the MUF's window when you are not in a raid."
L["OPT_HIDEMFS_NEVER"] = "Never auto-hide"
L["OPT_HIDEMFS_NEVER_DESC"] = "Never auto-hide the MUFs' window."
L["OPT_HIDEMFS_SOLO"] = "in solo"
L["OPT_HIDEMFS_SOLO_DESC"] = "Hide the MUFs' window when you are not part of any kind of group."
L["OPT_HIDEMUFSHANDLE"] = "Hide the MUFs handle"
L["OPT_HIDEMUFSHANDLE_DESC"] = [=[Hides the Micro-Unit Frames handle and disables the possibility to move them.
Use the same command to get it back.]=]
L["OPT_IGNORESTEALTHED_DESC"] = "Cloaked units will be ignored"
L["OPT_INPUT_SPELL_BAD_INPUT_ALREADY_HERE"] = "Spell already listed!"
L["OPT_INPUT_SPELL_BAD_INPUT_DEFAULT_SPELL"] = "Decursive already manage this spell. Shift-click the spell or type its ID to add a special rank."
L["OPT_INPUT_SPELL_BAD_INPUT_ID"] = "Invalid spell ID!"
L["OPT_INPUT_SPELL_BAD_INPUT_NOT_SPELL"] = "Spell not found in your spell book!"
L["OPTION_MENU"] = "Decursive Options Menu"
L["OPT_LIVELIST"] = "Live list"
L["OPT_LIVELIST_DESC"] = "Options for the live list"
L["OPT_LLALPHA"] = "Live-list transparency"
L["OPT_LLALPHA_DESC"] = "Changes Decursive main bar and live-list transparency (Main bar must be displayed)"
L["OPT_LLSCALE"] = "Scale of the Live-list"
L["OPT_LLSCALE_DESC"] = "Set the size of the Decursive main bar and of the Live-list (Main bar must be displayed)"
L["OPT_LVONLYINRANGE"] = "Units in range only"
L["OPT_LVONLYINRANGE_DESC"] = "Only units in dispel range will be shown in the live-list"
L["OPT_MACROBIND"] = "Set the macro binding key"
L["OPT_MACROBIND_DESC"] = [=[Defines the key on which the 'Decursive' macro will be called.

Press the key and hit your 'Enter' keyboard key to save the new assignment (with your mouse cursor over the edit field)]=]
L["OPT_MACROOPTIONS"] = "Macro options"
L["OPT_MACROOPTIONS_DESC"] = "Set the behaviour of the macro created by Decursive"
L["OPT_MAGICCHARMEDCHECK_DESC"] = "If checked you'll be able to see and cure magic-charmed units"
L["OPT_MAGICCHECK_DESC"] = "If checked you'll be able to see and cure magic afflicted units"
L["OPT_MAXMFS"] = "Max units shown"
L["OPT_MAXMFS_DESC"] = "Defines the max number of micro unit frame to display"
L["OPT_MESSAGES"] = "Messages"
L["OPT_MESSAGES_DESC"] = "Options about messages display"
L["OPT_MFALPHA"] = "Transparency"
L["OPT_MFALPHA_DESC"] = "Defines the transparency of the MUFs when units are not afflicted"
L["OPT_MFPERFOPT"] = "Performance options"
L["OPT_MFREFRESHRATE"] = "Refresh rate"
L["OPT_MFREFRESHRATE_DESC"] = "Time between each refresh call (1 or several micro-unit-frames can be refreshed at once)"
L["OPT_MFREFRESHSPEED"] = "Refresh speed"
L["OPT_MFREFRESHSPEED_DESC"] = "Number of micro-unit-frames to refresh on a single pass"
L["OPT_MFSCALE"] = "Scale of the micro-unit-frames"
L["OPT_MFSCALE_DESC"] = "Set the size of the micro-unit-frames"
L["OPT_MFSETTINGS"] = "Micro Unit Frame Options"
L["OPT_MFSETTINGS_DESC"] = "Set various MUF and afflictions' type priority related display options"
L["OPT_MUFFOCUSBUTTON"] = "Focusing button:"
L["OPT_MUFHANDLE_HINT"] = "To move the micro-unit-frames: ALT-click the invisible handle located above the first micro-unit-frame."
L["OPT_MUFMOUSEBUTTONS"] = "Mouse bindings"
L["OPT_MUFMOUSEBUTTONS_DESC"] = [=[Change the bindings used to cure, target or focus group members via the MUFs.

Each priority number represents a different affliction type as specified in the '|cFFFF5533Curing Options|r' panel.

The spell used for each affliction type is set by default but can be changed in the '|cFF00DDDDCustom Spells|r' panel.]=]
L["OPT_MUFSCOLORS"] = "Colors"
L["OPT_MUFSCOLORS_DESC"] = [=[Options to change the color for each affliction type's priority and various MUF statuses.

Each priority represents a different affliction type as specified in the '|cFFFF5533Curing Options|r' panel.]=]
L["OPT_MUFSVERTICALDISPLAY"] = "Vertical display"
L["OPT_MUFSVERTICALDISPLAY_DESC"] = "MUFs' window will grow vertically"
L["OPT_MUFTARGETBUTTON"] = "Targeting button:"
L["OPT_NEWVERSIONBUGMENOT"] = "New version alerts"
L["OPT_NEWVERSIONBUGMENOT_DESC"] = "If a newer version of Decursive is detected, a pop-up alert will be displayed once every seven days."
L["OPT_NOKEYWARN"] = "Warn if no key"
L["OPT_NOKEYWARN_DESC"] = "Display a warning if no key is mapped."
L["OPT_NOSTARTMESSAGES"] = "Disable welcome messages"
L["OPT_NOSTARTMESSAGES_DESC"] = "Remove the three messages Decursive prints to the chat frame at every login."
L["OPT_OPTIONS_DISABLED_WHILE_IN_COMBAT"] = "These options are disabled while you are in combat."
L["OPT_PERFOPTIONWARNING"] = "WARNING: Do not change those values unless you know exactly what you are doing. These settings can have a great impact on the game performances. Most users should use the default values of 0.1 and 10."
L["OPT_PLAYSOUND_DESC"] = "Play a sound if someone get cursed"
L["OPT_POISONCHECK_DESC"] = "If checked you'll be able to see and cure poisoned units"
L["OPT_PRINT_CUSTOM_DESC"] = "Decursive's messages will be printed in a custom chat frame"
L["OPT_PRINT_ERRORS_DESC"] = "Errors will be displayed"
L["OPT_PROFILERESET"] = "Profile reset..."
L["OPT_RANDOMORDER_DESC"] = "Units will be displayed and cured randomly (not recommended)"
L["OPT_READDDEFAULTSD"] = "Re-add default afflictions"
L["OPT_READDDEFAULTSD_DESC1"] = [=[Add missing Decursive's default afflictions to this list
Your settings won't be changed]=]
L["OPT_READDDEFAULTSD_DESC2"] = "All Decursive's default afflictions are in this list"
L["OPT_REMOVESKDEBCONF"] = [=[Are you sure you want to remove
 '%s' 
from Decursive's affliction skip list?]=]
L["OPT_REMOVETHISDEBUFF"] = "Remove this affliction"
L["OPT_REMOVETHISDEBUFF_DESC"] = "Removes '%s' from the skip list"
L["OPT_RESETDEBUFF"] = "Reset this affliction"
L["OPT_RESETDTDCRDEFAULT"] = "Resets '%s' to Decursive default"
L["OPT_RESETMUFMOUSEBUTTONS"] = "Reset"
L["OPT_RESETMUFMOUSEBUTTONS_DESC"] = "Reset mouse button assignments to defaults."
L["OPT_RESETOPTIONS"] = "Reset options to defaults"
L["OPT_RESETOPTIONS_DESC"] = "Reset the current profile to the default values"
L["OPT_RESTPROFILECONF"] = [=[Are you sure you want to reset the profile
 '(%s) %s'
 to default options?]=]
L["OPT_REVERSE_LIVELIST_DESC"] = "The live-list fills itself from bottom to top"
L["OPT_SCANLENGTH_DESC"] = "Defines the time between each scan"
L["OPT_SHOWBORDER"] = "Show the class-colored borders"
L["OPT_SHOWBORDER_DESC"] = "A colored border will be displayed around the MUFs representing the unit's class"
L["OPT_SHOWCHRONO"] = "Show chronometers"
L["OPT_SHOWCHRONO_DESC"] = "The number of seconds elapsed since a unit has been afflicted is displayed"
L["OPT_SHOWCHRONOTIMElEFT"] = "Time left"
L["OPT_SHOWCHRONOTIMElEFT_DESC"] = "Display time left instead of time elapsed."
L["OPT_SHOWHELP"] = "Show help"
L["OPT_SHOWHELP_DESC"] = "Shows an detailed tooltip when you mouse-over a micro-unit-frame"
L["OPT_SHOWMFS"] = "Show the Micro Units Frame"
L["OPT_SHOWMFS_DESC"] = "This must be enabled if you want to cure by clicking"
L["OPT_SHOWMINIMAPICON"] = "Minimap Icon"
L["OPT_SHOWMINIMAPICON_DESC"] = "Toggle the minimap icon."
L["OPT_SHOW_STEALTH_STATUS"] = "Show stealth status"
L["OPT_SHOW_STEALTH_STATUS_DESC"] = "When a player is stealthed, his MUF will take a special color"
L["OPT_SHOWTOOLTIP_DESC"] = "Shows a detailed tooltips about curses in the live-list and on the MUFs"
L["OPT_STICKTORIGHT"] = "Align MUF window to the right"
L["OPT_STICKTORIGHT_DESC"] = "The MUF window will grow from right to left, the handle will be moved as necessary."
L["OPT_TESTLAYOUT"] = "Test Layout"
L["OPT_TESTLAYOUT_DESC"] = [=[Create fake units so you can test the display layout.
(Wait a few seconds after clicking)]=]
L["OPT_TESTLAYOUTUNUM"] = "Unit number"
L["OPT_TESTLAYOUTUNUM_DESC"] = "Set the number of fake units to create."
L["OPT_TIECENTERANDBORDER"] = "Tie center and border transparency"
L["OPT_TIECENTERANDBORDER_OPT"] = "The transparency of the border is half the center transparency when checked"
L["OPT_TIE_LIVELIST_DESC"] = "The live-list display is tied to \"Decursive\" bar display"
L["OPT_TIEXYSPACING"] = "Tie horizontal and vertical spacing"
L["OPT_TIEXYSPACING_DESC"] = "The horizontal and vertical space between MUFs are the same"
L["OPT_UNITPERLINES"] = "Number of units per row"
L["OPT_UNITPERLINES_DESC"] = "Defines the max number of micro-unit-frames to display per row"
L["OPT_USERDEBUFF"] = "This affliction is not part of Decursive's default afflictions"
L["OPT_XSPACING"] = "Horizontal spacing"
L["OPT_XSPACING_DESC"] = "Set the Horizontal space between MUFs"
L["OPT_YSPACING"] = "Vertical spacing"
L["OPT_YSPACING_DESC"] = "Set the Vertical space between MUFs"
L["PLAY_SOUND"] = "Play a sound when there is someone to cure"
L["POISON"] = "Poison"
L["POPULATE"] = "p"
L["POPULATE_LIST"] = "Quickly populate the Decursive list"
L["PRINT_CHATFRAME"] = "Print messages in default chat"
L["PRINT_CUSTOM"] = "Print messages in the window"
L["PRINT_ERRORS"] = "Print error messages"
L["PRIORITY_LIST"] = "Decursive Priority List"
L["PRIORITY_SHOW"] = "P"
L["RANDOM_ORDER"] = "Cure in a random order"
L["REVERSE_LIVELIST"] = "Reverse live-list display"
L["SCAN_LENGTH"] = "Seconds between live scans : "
L["SHIFT"] = "Shift"
L["SHOW_MSG"] = "To show Decursive's frame, type /dcrshow"
L["SHOW_TOOLTIP"] = "Show Tooltips on afflicted units"
L["SKIP_LIST_STR"] = "Decursive Skip List"
L["SKIP_SHOW"] = "S"
L["SPELL_FOUND"] = "%s spell found!"
L["STEALTHED"] = "cloaked"
L["STR_CLOSE"] = "Close"
L["STR_DCR_PRIO"] = "Decursive Priority"
L["STR_DCR_SKIP"] = "Decursive Skip"
L["STR_GROUP"] = "Group "
L["STR_OPTIONS"] = "Decursive's Options"
L["STR_OTHER"] = "Other"
L["STR_POP"] = "Populate List"
L["STR_QUICK_POP"] = "Quickly Populate"
L["SUCCESSCAST"] = "|cFF22FFFF%s %s|r |cFF00AA00succeeded on|r %s"
L["TARGETUNIT"] = "Target Unit"
L["TIE_LIVELIST"] = "Tie live-list visibility to DCR window"
L["TOOFAR"] = "Too far"
L["TOO_MANY_ERRORS_ALERT"] = [=[There are too many Lua errors in your User Interface (%d). Your game experience is currently degraded. Disable or update the failing add-ons to turn off this message and regain a proper frame rate.
You may want to turn on Lua error reporting ('Help' section of World of Warcraft's interface options) to identify the problematic add-ons.]=]
L["UNITSTATUS"] = "Unit Status: "
L["UNSTABLERELEASE"] = "Unstable release"





T._LoadedFiles["enUS.lua"] = "2.7.0.5";
