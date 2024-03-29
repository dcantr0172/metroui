-- Recount Locale 
-- Please use the Localization App on WoWAce to Update this 
-- http://www.wowace.com/projects/recount/localization/
 
local debug = false 
--[===[@debug@ 
debug = true 
--@end-debug@]===] 
 
local L = LibStub("AceLocale-3.0"):NewLocale("Recount", "enUS", true, debug) 
 
L["Ability"] = true
L["Ability Name"] = true
L["Absorbed"] = true
L["Absorbs"] = true
L["Activity"] = true
L["Add to Current Graph (Alt Click)"] = true
L["Allows the data of a window to be reported"] = true
L["Appearance"] = true
L["Arcane"] = true
L["Arenas"] = true
L[" at "] = true
L["Attacked"] = true
L["Attacked by"] = true
L["Attacked/Healed"] = true
L["Attack Name"] = true
L["Attack Summary Incoming (Click for Outgoing)"] = true
L["Attack Summary Outgoing (Click for Incoming)"] = true
L["Autodelete Time Data"] = true
L["Autohide On Combat"] = true
L["Autoswitch Shown Fight"] = true
L["Available Bandwidth"] = true
L["Avg"] = true
L["Avg. DOTs Up"] = true
L["Avg. HOTs Up"] = true
L["Background"] = true
L["Bandwidth"] = true
L["Bar Color Selection"] = true
L["Bar Selection"] = true
L["Bar Text"] = true
L["Bar Text Options"] = true
L["Battlegrounds"] = true
L["Block"] = true
L["Blocked"] = true
L["Bosses"] = true
L["Bottom Color"] = true
L["Broke"] = true
L["Broke On"] = true
L[" by "] = true
L["Bytes"] = true
L["CC Breakers"] = true
L["CC Breaking"] = true
L["CC's Broken"] = true
L["|cff40ff40Enabled|r"] = true
L["|cffff4040Disabled|r"] = true
L["Check Versions"] = true
L["Clamp To Screen"] = true
L["Class Colors"] = true
L["Click for more Details"] = true
L["Click for next Pet"] = true
L["Click|r to toggle the Recount window"] = true
L["Close"] = true
L["Color"] = true
L["Combat Log Range"] = true
L["Combat Messages"] = true
L["Commas"] = true
L["Config"] = true
L["Config Access"] = true
L["Config Recount"] = true
L["Confirmation"] = true
L["Content-based Filters"] = true
L["Controls the frame strata of the Recount windows. Default: MEDIUM"] = true
L["Controls whether the Recount windows can be dragged offscreen"] = true
L["Count"] = true
L["Crit"] = true
L["Crushing"] = true
L["Current Fight"] = true
L["Damage"] = true
L["Damage Abilities"] = true
L["Damage Done"] = true
L["Damaged Who"] = true
L["Damage Focus"] = true
L["Damage Report for"] = true
L["Damage Taken"] = true
L["Data"] = true
L["Data collection turned off"] = true
L["Data collection turned on"] = true
L["Data Deletion"] = true
L["Data Name"] = true
L["Data Options"] = true
L["Death Details for"] = true
L["Death for "] = true
L["Death Graph"] = true
L["Deaths"] = true
L["Death Track"] = true
L["Delete Combatant (Ctrl-Alt Click)"] = true
L["Delete on Entry"] = true
L["Delete on New Group"] = true
L["Delete on New Raid"] = true
L["Detail"] = true
L["Detail Window"] = true
L[" dies."] = true
L["Dispelled"] = true
L["Dispelled By"] = true
L["Dispels"] = true
L["Display"] = true
L["Displaying Versions"] = true
L["Displays the versions of players in the raid"] = true
L["Distribution"] = true
L["Dodge"] = true
L["DoT"] = true
L["DOTs"] = true
L["DOT Time"] = true
L["DOT Uptime"] = true
L["Downstream Traffic"] = true
L["Down Traffic"] = true
L["Do you wish to reset the data?"] = true
L["DPS"] = true
L["DTPS"] = true
L["Duration"] = true
L["Enabled"] = true
L["End"] = true
L["Energy Abilities"] = true
L["Energy Gained"] = true
L["Energy Sources"] = true
L["Fight"] = true
L["Fight Segmentation"] = true
L["File"] = true
L["Filters"] = true
L["Fire"] = true
L["Fix Ambiguous Log Strings"] = true
L["Font Selection"] = true
L[" for "] = true
L["Fought"] = true
L["FPS"] = true
L["Frame Strata"] = true
L["Friendly Attacks"] = true
L["Friendly Fire"] = true
L["Friendly Fired On"] = true
L["From"] = true
L["Frost"] = true
L["Frostfire"] = true
L["Gained"] = true
L["General Window Options"] = true
L["Glancing"] = true
L["Global Data Collection"] = true
L["Global Realtime Windows"] = true
L["Graph Window"] = true
L["Group Based Deletion"] = true
L["Grouped"] = true
L["Guardian"] = true
L["gui"] = true
L["GUI"] = true
L["Guild"] = true
L["Heal"] = true
L["Healed"] = true
L["Healed By"] = true
L["Healed Who"] = true
L["Heal Focus"] = true
L["Healing"] = true
L["Healing Done"] = true
L["Healing Taken"] = true
L["Heal Name"] = true
L["Heals"] = true
L["Health"] = true
L["Hide"] = true
L["Hides the main window"] = true
L["Hide When Not Collecting"] = true
L["Hit"] = true
L["Holy"] = true
L["Hostile"] = true
L["HoT"] = true
L["HOTs"] = true
L["HOT Time"] = true
L["HOT Uptime"] = true
L["HPS"] = true
L["HTPS"] = true
L["Incoming"] = true
L["Instance Based Deletion"] = true
L["Integrate"] = true
L["Interrupted"] = true
L["Interrupted Who"] = true
L["Interrupts"] = true
L["Is this shown in the main window?"] = true
L["Keep Only Boss Segments"] = true
L["Killed By"] = true
L["Lag"] = true
L["Last Fight"] = true
L["Latency"] = true
L["Lines Reported"] = true
L["Lines reported set to: "] = true
L["Lock"] = true
L["Lock Windows"] = true
L["Main"] = true
L["Main Window"] = true
L["Main Window Options"] = true
L["Mana Abilities"] = true
L["Mana Gained"] = true
L["Mana Sources"] = true
L["Max"] = true
L["Melee"] = true
L["Merge Pets w/ Owners"] = true
L["Merge Aborbs w/ Heals"] = true
L["Messages"] = true
L["Min"] = true
L["Misc"] = true
L["Miss"] = true
L["Mob"] = true
L["Mobs"] = true
L["Name of Ability"] = true
L["Nature"] = true
L["Naturefire"] = true
L["Network"] = true
L["Network and FPS"] = true
L["Network Traffic"] = true
L["Network Traffic(by Player)"] = true
L["Network Traffic(by Prefix)"] = true
L["New"] = true
L["Next"] = true
L["No"] = true
L["No Absorb"] = true
L["No Block"] = true
L["Non-Trivial"] = true
L["No Pet"] = true
L["No Resist"] = true
L["Normalize"] = true
L["Number Format"] = true
L["Officer"] = true
L["Open Ace3 Config GUI"] = true
L["Other Windows"] = true
L["Outgoing"] = true
L["Outside Instances"] = true
L["Overall Data"] = true
L[" overheal"] = true
L["Overheal"] = true
L["Overhealing"] = true
L["Overhealing Done"] = true
L["Over Heals"] = true
L["Parry"] = true
L["Party"] = true
L["Party Instances"] = true
L["pause"] = true
L["Pause"] = true
L["Percent"] = true
L["Per Second"] = true
L["Pet"] = true
L["Pet Attacked"] = true
L["Pet Damage"] = true
L["Pet Damage Abilities"] = true
L["Pet Focus"] = true
L["Pet Healed"] = true
L["Pet Healing Abilities"] = true
L["Pets"] = true
L["Pet Time"] = true
L["Physical"] = true
L["Player/Mob Name"] = true
L["Players"] = true
L["Prefix"] = true
L["Previous"] = true
L["Profiles"] = true
L["Rage Abilities"] = true
L["Rage Gained"] = true
L["Rage Sources"] = true
L["Raid"] = true
L["Raid Instances"] = true
L["Rank Number"] = true
L["Realtime"] = true
L["Record Buffs/Debuffs"] = true
L["Record Data"] = true
L["Record Deaths"] = true
L["Recorded Fights"] = true
L["Records the times and applications of buff/debuffs on this type"] = true
L["Records when deaths occur and the past few actions involving this type"] = true
L["Record Time Data"] = true
L["Recount"] = true
L["Recount Version"] = true
L["Report"] = true
L["Report Data"] = true
L["Report for"] = true
L["Report the DeathTrack Window Data"] = true
L["Report the Detail Window Data"] = true
L["Report the Main Window Data"] = true
L["Report To"] = true
L["Report Top"] = true
L["reset"] = true
L["Reset"] = true
L["Reset Colors"] = true
L["ResetPos"] = true
L["Reset Positions"] = true
L["Reset Recount?"] = true
L["Resets the data"] = true
L["Resets the positions of the detail, graph, and main windows"] = true
L["Resist"] = true
L[" resisted"] = true
L["Resisted"] = true
L["Ressed"] = true
L["Ressed Who"] = true
L["Ressers"] = true
L["Right-click|r to open the options menu"] = true
L["Row Height"] = true
L["Row Spacing"] = true
L["RunicPower Abilities"] = true
L["Runic Power Gained"] = true
L["RunicPower Sources"] = true
L["'s Absorbs"] = true
L["Say"] = true
L["'s Dispels"] = true
L["'s DOT Uptime"] = true
L["'s DPS"] = true
L["'s DTPS"] = true
L["Seconds"] = true
L["'s Effective Healing"] = true
L["Self"] = true
L["'s Energy Gained"] = true
L["'s Energy Gained From"] = true
L["Set Combat Log Range"] = true
L["Set the maximum number of lines to report"] = true
L["Set the maximum number of recorded fight segments"] = true
L["'s Friendly Fire"] = true
L["Shadow"] = true
L["Shielded"] = true
L["Shielded Who"] = true
L["Short"] = true
L["'s Hostile Attacks"] = true
L["'s HOT Uptime"] = true
L["show"] = true
L["Show"] = true
L["Show Buttons"] = true
L["Show Death Track (Left Click)"] = true
L["Show Details (Left Click)"] = true
L["Show Graph"] = true
L["Show Graph (Shift Click)"] = true
L["Show next main page"] = true
L["Show previous main page"] = true
L["Show Realtime Graph (Ctrl Click)"] = true
L["Show Scrollbar"] = true
L["Shows found unknown spells in BabbleSpell"] = true
L["Shows the config window"] = true
L["Shows the main window"] = true
L["Show Total Bar"] = true
L["'s HPS"] = true
L["'s HTPS"] = true
L["'s Interrupts"] = true
L["'s Mana Gained"] = true
L["'s Mana Gained From"] = true
L["'s Network Traffic"] = true
L["Solo"] = true
L["'s Overhealing"] = true
L["'s Partial Resists"] = true
L["Specialized Realtime Graphs"] = true
L["Split"] = true
L["'s Rage Gained"] = true
L["'s Rage Gained From"] = true
L["'s Resses"] = true
L["'s RunicPower Gained"] = true
L["'s RunicPower Gained From"] = true
L["Stack"] = true
L["Standard"] = true
L["Start"] = true
L["Starts a realtime window tracking amount of available AceComm bandwidth left"] = true
L["Starts a realtime window tracking your downstream traffic"] = true
L["Starts a realtime window tracking your FPS"] = true
L["Starts a realtime window tracking your latency"] = true
L["Starts a realtime window tracking your upstream traffic"] = true
L["'s Time Spent"] = true
L["'s Time Spent Attacking"] = true
L["'s Time Spent Healing"] = true
L["'s TPS"] = true
L["Summary Report for"] = true
L["Swap Text and Bar Color"] = true
L["sync"] = true
L["Sync"] = true
L["Sync Data"] = true
L["Sync Options"] = true
L["Taken"] = true
L["Threat"] = true
L["Threat on"] = true
L["Tick"] = true
L["Ticked on"] = true
L["Time"] = true
L["Time Damaging"] = true
L["Time Healing"] = true
L["Times"] = true
L["Time (s)"] = true
L["Title"] = true
L["Title Text"] = true
L["Toggle"] = true
L["Toggle pause of global data collection"] = true
L["Toggles sending synchronization messages"] = true
L["Toggles the main window"] = true
L["Toggles windows being locked"] = true
L["Took Damage From"] = true
L["Top 3"] = true
L["Top Color"] = true
L["Total"] = true
L["Total Bar"] = true
L["Tracks Raid Damage Per Second"] = true
L["Tracks Raid Damage Taken Per Second"] = true
L["Tracks Raid Healing Per Second"] = true
L["Tracks Raid Healing Taken Per Second"] = true
L["Tracks your entire raid"] = true
L["Trivial"] = true
L["Type"] = true
L["Ungrouped"] = true
L["Unknown"] = true
L["Unknown Spells"] = true
L["Unknown Spells:"] = true
L["Upstream Traffic"] = true
L["Up Traffic"] = true
L["verChk"] = true
L["VerChk"] = "Version Check"
L["was Dispelled by"] = true
L["was Healed by"] = true
L["Whether data is recorded for this type"] = true
L["Whether time data is recorded for this type (used for graphs can be a |cffff2020memory hog|r if you are concerned about memory)"] = true
L["Whisper"] = true
L["Whisper Target"] = true
L["Who"] = true
L["Window"] = true
L["Window Color Selection"] = true
L["Window Options"] = true
L["Window Scaling"] = true
L["X Gridlines Represent"] = true
L["Yds"] = true
L["Yes"] = true
 
 
