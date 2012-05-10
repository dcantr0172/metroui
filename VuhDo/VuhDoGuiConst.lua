
-- Group Model Header Texts
VUHDO_HEADER_TEXTS = {
	[VUHDO_ID_UNDEFINED] = "",

	[VUHDO_ID_GROUP_1] = VUHDO_I18N_GROUP .. " 1",
	[VUHDO_ID_GROUP_2] = VUHDO_I18N_GROUP .. " 2",
	[VUHDO_ID_GROUP_3] = VUHDO_I18N_GROUP .. " 3",
	[VUHDO_ID_GROUP_4] = VUHDO_I18N_GROUP .. " 4",
	[VUHDO_ID_GROUP_5] = VUHDO_I18N_GROUP .. " 5",
	[VUHDO_ID_GROUP_6] = VUHDO_I18N_GROUP .. " 6",
	[VUHDO_ID_GROUP_7] = VUHDO_I18N_GROUP .. " 7",
	[VUHDO_ID_GROUP_8] = VUHDO_I18N_GROUP .. " 8",
	[VUHDO_ID_GROUP_OWN] = VUHDO_I18N_OWN_GROUP,

	[VUHDO_ID_WARRIORS] = VUHDO_I18N_WARRIORS,
	[VUHDO_ID_ROGUES] = VUHDO_I18N_ROGUES,
	[VUHDO_ID_HUNTERS] = VUHDO_I18N_HUNTERS,
	[VUHDO_ID_PALADINS] = VUHDO_I18N_PALADINS,
	[VUHDO_ID_MAGES] = VUHDO_I18N_MAGES,
	[VUHDO_ID_WARLOCKS] = VUHDO_I18N_WARLOCKS,
	[VUHDO_ID_SHAMANS] = VUHDO_I18N_SHAMANS,
	[VUHDO_ID_DRUIDS] = VUHDO_I18N_DRUIDS,
	[VUHDO_ID_PRIESTS] = VUHDO_I18N_PRIESTS,
	[VUHDO_ID_DEATH_KNIGHT] = VUHDO_I18N_DEATH_KNIGHT,

	[VUHDO_ID_PETS] = VUHDO_I18N_PETS,
	[VUHDO_ID_MAINTANKS] = VUHDO_I18N_MAINTANKS,
	[VUHDO_ID_MAIN_ASSISTS] = VUHDO_I18N_MAIN_ASSISTS,
	[VUHDO_ID_PRIVATE_TANKS] = VUHDO_I18N_PRIVATE_TANKS,

	[VUHDO_ID_MELEE] = VUHDO_I18N_MELEES,
	[VUHDO_ID_RANGED] = VUHDO_I18N_RANGED,

	[VUHDO_ID_MELEE_TANK] = VUHDO_I18N_MELEE_TANK,
	[VUHDO_ID_MELEE_DAMAGE] = VUHDO_I18N_MELEE_DPS,
	[VUHDO_ID_RANGED_DAMAGE] = VUHDO_I18N_RANGED_DPS,
	[VUHDO_ID_RANGED_HEAL] = VUHDO_I18N_RANGED_HEALERS,

	[VUHDO_ID_VEHICLES] = VUHDO_I18N_VEHICLES,
	[VUHDO_ID_SELF] = VUHDO_I18N_SELF,
	[VUHDO_ID_SELF_PET] = VUHDO_I18N_OWN_PET,
};



-- For initializing the minimap
VUHDO_MM_LAYOUT = {
	icon = "interface\\characterframe\\temporaryportrait-female-draenei",
	drag = "CIRCLE",
	left = nil,
	right = nil,
	tooltip = VUHDO_I18N_MM_TOOLTIP,
	enabled = true
};



--
VUHDO_CUSTOM_ICONS = {
	{ VUHDO_I18N_CUSTOM_ICON_NONE, nil }, -- 1
	{ VUHDO_I18N_CUSTOM_ICON_GLOSSY, "Interface\\AddOns\\VuhDo\\Images\\icon_white_square" }, --2
	{ VUHDO_I18N_CUSTOM_ICON_MOSAIC, "Interface\\AddOns\\VuhDo\\Images\\cluster" }, -- 3
	{ VUHDO_I18N_CUSTOM_ICON_CLUSTER, "Interface\\AddOns\\VuhDo\\Images\\cluster2" }, -- 4
	{ VUHDO_I18N_CUSTOM_ICON_FLAT, "Interface\\AddOns\\VuhDo\\Images\\white_square_16_16" }, -- 5
	{ VUHDO_I18N_CUSTOM_ICON_SPOT, "Interface\\AddOns\\VuhDo\\Images\\icon_white" }, -- 6
	{ VUHDO_I18N_CUSTOM_ICON_CIRCLE, "Interface\\AddOns\\VuhDo\\Images\\shield_stacks4" }, -- 7
	{ VUHDO_I18N_CUSTOM_ICON_SKETCHED, "Interface\\AddOns\\VuhDo\\Images\\hot_flat_16_16" }, -- 8
	{ VUHDO_I18N_CUSTOM_ICON_RHOMB, "Interface\\AddOns\\VuhDo\\Images\\rhomb" }, -- 9
	{ VUHDO_I18N_CUSTOM_ICON_ONE_THIRD, "Interface\\AddOns\\VuhDo\\Images\\third_one" }, -- 10
	{ VUHDO_I18N_CUSTOM_ICON_TWO_THIRDS, "Interface\\AddOns\\VuhDo\\Images\\third_two" }, -- 11
	{ VUHDO_I18N_CUSTOM_ICON_THREE_THIRDS, "Interface\\AddOns\\VuhDo\\Images\\third_three" }, -- 12
};
