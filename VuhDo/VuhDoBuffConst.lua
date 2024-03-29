-- Definition of buff impact types
VUHDO_BUFF_TARGET_SELF = 1;
VUHDO_BUFF_TARGET_SINGLE = 2;
VUHDO_BUFF_TARGET_UNIQUE = 3;
VUHDO_BUFF_TARGET_OWN_GROUP = 4;
VUHDO_BUFF_TARGET_TOTEM = 7;
VUHDO_BUFF_TARGET_AURA = 8;
VUHDO_BUFF_TARGET_HOSTILE = 9;
VUHDO_BUFF_TARGET_RAID = 10;
VUHDO_BUFF_TARGET_ENCHANT = 11;


--
VUHDO_GROUPS_BUFFS = {
	[VUHDO_BUFF_TARGET_OWN_GROUP] = true,
	[VUHDO_BUFF_TARGET_TOTEM] = true,
	[VUHDO_BUFF_TARGET_AURA] = true,
	[VUHDO_BUFF_TARGET_RAID] = true,
};



--
VUHDO_MULTICAST_BUFFS = {
	[VUHDO_I18N_BUFFC_FIRE_TOTEM] = {
		["SLOT"] = 133,
		[VUHDO_SPELL_ID.BUFF_FLAMETONGUE_TOTEM] = 8227,
		[VUHDO_SPELL_ID.BUFF_SEARING_TOTEM] = 3599,
		[VUHDO_SPELL_ID.BUFF_FIRE_ELEMENTAL_TOTEM] = 2894,
		[VUHDO_SPELL_ID.BUFF_MAGMA_TOTEM] = 8190,
		[VUHDO_SPELL_ID.BUFF_TOTEM_OF_WRATH] = 57658,
	},
	[VUHDO_I18N_BUFFC_EARTH_TOTEM] = {
		["SLOT"] = 134,
		[VUHDO_SPELL_ID.BUFF_EARTHBIND_TOTEM] = 2484,
		[VUHDO_SPELL_ID.BUFF_STRENGTH_OF_EARTH_TOTEM] = 8075,
		[VUHDO_SPELL_ID.BUFF_STONESKIN_TOTEM] = 8071,
		[VUHDO_SPELL_ID.BUFF_STONECLAW_TOTEM] = 5730,
		[VUHDO_SPELL_ID.BUFF_EARTH_ELEMENTAL_TOTEM] = 2062,
		[VUHDO_SPELL_ID.BUFF_TREMOR_TOTEM] = 8143,
	},
	[VUHDO_I18N_BUFFC_WATER_TOTEM] = {
		["SLOT"] = 135,
		[VUHDO_SPELL_ID.BUFF_MANA_SPRING_TOTEM] = 5675,
		[VUHDO_SPELL_ID.BUFF_HEALING_STREAM_TOTEM] = 5394,
		[VUHDO_SPELL_ID.BUFF_TOTEM_OF_TRANQUIL_MIND] = 87718,
		[VUHDO_SPELL_ID.BUFF_ELEMENTAL_RESISTANCE_TOTEM] = 8184,
		[VUHDO_SPELL_ID.BUFF_MANA_TIDE_TOTEM] = 16190,
	},
	[VUHDO_I18N_BUFFC_AIR_TOTEM] = {
		["SLOT"] = 136,
		[VUHDO_SPELL_ID.BUFF_GROUNDING_TOTEM] = 8177,
		[VUHDO_SPELL_ID.BUFF_WINDFURY_TOTEM] = 8512,
		[VUHDO_SPELL_ID.BUFF_WRATH_OF_AIR_TOTEM] = 3738,
		[VUHDO_SPELL_ID.BUFF_SOUL_LINK_TOTEM] = 98008,
	}
}


--
-- Buffs per Class
-- Class => BUff-disjunctive-Group => Buff-Overwriting-Group => BuffName, Target type
--
VUHDO_CLASS_BUFFS = {
	-- Priest
	["PRIEST"] = {
		[VUHDO_SPELL_ID.BUFFC_FORTITUDE] = { -- 01
			{
				{ VUHDO_SPELL_ID.BUFF_POWER_WORD_FORTITUDE, VUHDO_BUFF_TARGET_RAID, VUHDO_SPELL_ID.BLOOD_PAKT, VUHDO_SPELL_ID.BUFF_COMMANDING_SHOUT },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_SHADOW_PROTECTION] = { -- 02
			{
				{ VUHDO_SPELL_ID.BUFF_SHADOW_PROTECTION, VUHDO_BUFF_TARGET_RAID },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_FEAR_WARD] = { -- 03
			{
				{ VUHDO_SPELL_ID.BUFF_FEAR_WARD, VUHDO_BUFF_TARGET_UNIQUE },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_INNER_FIRE] = { -- 04
			{
				{ VUHDO_SPELL_ID.BUFF_INNER_FIRE, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_INNER_WILL, VUHDO_BUFF_TARGET_SELF },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_SHADOW_FIEND] = { -- 05
			{
				{ VUHDO_SPELL_ID.BUFF_SHADOWFIEND, VUHDO_BUFF_TARGET_HOSTILE },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_POWER_INFUSION] = { -- 06
			{
				{ VUHDO_SPELL_ID.BUFF_POWER_INFUSION, VUHDO_BUFF_TARGET_UNIQUE },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_VAMPIRIC_EMBRACE] = { -- 07
			{
				{ VUHDO_SPELL_ID.BUFF_VAMPIRIC_EMBRACE, VUHDO_BUFF_TARGET_SELF },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_LEVITATE] = { -- 08
			{
				{ VUHDO_SPELL_ID.BUFF_LEVITATE, VUHDO_BUFF_TARGET_SINGLE },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_PAIN_SUPPRESSION] = { -- 09
			{
				{ VUHDO_SPELL_ID.PAIN_SUPPRESSION, VUHDO_BUFF_TARGET_UNIQUE },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_CHAKRA] = { -- 10
			{
				{ VUHDO_SPELL_ID.CHAKRA, VUHDO_BUFF_TARGET_SELF, VUHDO_SPELL_ID.CHAKRA_CHASITISE, VUHDO_SPELL_ID.CHAKRA_SANCTUARY, VUHDO_SPELL_ID.CHAKRA_SERENITY },
			}
		},
	},

	-- Shaman
	["SHAMAN"] = {
		[VUHDO_I18N_BUFFC_FIRE_TOTEM] = { -- 01
			{
				{ VUHDO_SPELL_ID.BUFF_FLAMETONGUE_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_SEARING_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_FIRE_ELEMENTAL_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_MAGMA_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_TOTEM_OF_WRATH, VUHDO_BUFF_TARGET_TOTEM },
			},
		},
		[VUHDO_I18N_BUFFC_AIR_TOTEM] = { -- 02
			{
				{ VUHDO_SPELL_ID.BUFF_GROUNDING_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_WINDFURY_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_WRATH_OF_AIR_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_SOUL_LINK_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
		},
		[VUHDO_I18N_BUFFC_EARTH_TOTEM] = { -- 03
			{
				{VUHDO_SPELL_ID.BUFF_EARTHBIND_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_STRENGTH_OF_EARTH_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_STONESKIN_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_STONECLAW_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_EARTH_ELEMENTAL_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_TREMOR_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
		},
		[VUHDO_I18N_BUFFC_WATER_TOTEM] = { -- 04
			{
				{ VUHDO_SPELL_ID.BUFF_MANA_SPRING_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_HEALING_STREAM_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_TOTEM_OF_TRANQUIL_MIND, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_ELEMENTAL_RESISTANCE_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_MANA_TIDE_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_MANA_TIDE_TOTEM] = { -- 05
			{
				{ VUHDO_SPELL_ID.BUFF_MANA_TIDE_TOTEM, VUHDO_BUFF_TARGET_TOTEM },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_HEROISM] = { -- 06
			{
				{ VUHDO_SPELL_ID.BUFF_HEROISM, VUHDO_BUFF_TARGET_OWN_GROUP },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_BLOODLUST] = { -- 07
			{
				{ VUHDO_SPELL_ID.BUFF_BLOODLUST, VUHDO_BUFF_TARGET_OWN_GROUP },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_EARTH_SHIELD] ={ -- 08
			{
				{ VUHDO_SPELL_ID.BUFF_EARTH_SHIELD, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
		[VUHDO_I18N_BUFFC_WEAPON_ENCHANT] = { -- 09
			{
				{ VUHDO_SPELL_ID.BUFF_ROCKBITER_WEAPON,  VUHDO_BUFF_TARGET_ENCHANT },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_FLAMETONGUE_WEAPON, VUHDO_BUFF_TARGET_ENCHANT },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_FROSTBRAND_WEAPON,  VUHDO_BUFF_TARGET_ENCHANT },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_WINDFURY_WEAPON,  VUHDO_BUFF_TARGET_ENCHANT },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_EARTHLIVING_WEAPON,  VUHDO_BUFF_TARGET_ENCHANT },
			},
		},
		[VUHDO_I18N_BUFFC_SHIELDS] = { -- 10
			{
				{ VUHDO_SPELL_ID.BUFF_LIGHTNING_SHIELD, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_WATER_SHIELD,  VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_NATURES_SWIFTNESS] = { -- 11
			{
				{ VUHDO_SPELL_ID.BUFF_NATURES_SWIFTNESS, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	["PALADIN"] = {
		[VUHDO_I18N_BUFFC_BLESSING] = {
			{
				{ VUHDO_SPELL_ID.BUFF_BLESSING_OF_MIGHT, VUHDO_BUFF_TARGET_RAID },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_BLESSING_OF_THE_KINGS, VUHDO_BUFF_TARGET_RAID, VUHDO_SPELL_ID.BUFF_MARK_OF_THE_WILD },
			},
		},
		[VUHDO_I18N_BUFFC_AURA] = {
			{
				{ VUHDO_SPELL_ID.BUFF_DEVOTION_AURA, VUHDO_BUFF_TARGET_AURA },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_RETRIBUTION_AURA, VUHDO_BUFF_TARGET_AURA },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_CONCENTRATION_AURA, VUHDO_BUFF_TARGET_AURA },
			},
			{
				{ VUHDO_SPELL_ID.RESISTANCE_AURA, VUHDO_BUFF_TARGET_AURA },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_CRUSADER_AURA, VUHDO_BUFF_TARGET_AURA },
			},
		},
		[VUHDO_I18N_BUFFC_SEAL] = {
			{
				{ VUHDO_SPELL_ID.BUFF_SEAL_OF_JUSTICE, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_SEAL_OF_INSIGHT, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_SEAL_OF_TRUTH, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_SEAL_OF_RIGHTEOUSNESS, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_BEACON_OF_LIGHT] = {
			{
				{ VUHDO_SPELL_ID.BUFF_BEACON_OF_LIGHT, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_RIGHTEOUS_FURY] = {
			{
				{ VUHDO_SPELL_ID.BUFF_RIGHTEOUS_FURY, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	["DRUID"] = {
		[VUHDO_SPELL_ID.BUFFC_MARK_OF_THE_WILD] = {
			{
				{ VUHDO_SPELL_ID.BUFF_MARK_OF_THE_WILD, VUHDO_BUFF_TARGET_RAID, VUHDO_SPELL_ID.BUFF_BLESSING_OF_THE_KINGS },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_THORNS] = {
			{
				{ VUHDO_SPELL_ID.BUFF_THORNS, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
	},

	["WARLOCK"] = {
		[VUHDO_I18N_BUFFC_SKIN] = {
			{
				{ VUHDO_SPELL_ID.BUFF_DEMON_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_FEL_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
		},
    [VUHDO_SPELL_ID.BUFFC_DARK_INTENT] = { -- 2
	    {
				{ VUHDO_SPELL_ID.BUFF_DARK_INTENT, VUHDO_BUFF_TARGET_UNIQUE },
  	  },
  	},
		[VUHDO_SPELL_ID.BUFFC_SOUL_LINK] = {
			{
				{ VUHDO_SPELL_ID.BUFF_SOUL_LINK, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	["MAGE"] = {
		[VUHDO_SPELL_ID.BUFFC_ARCANE_BRILLIANCE] = { -- 1
			{
				{ VUHDO_SPELL_ID.BUFF_ARCANE_BRILLIANCE, VUHDO_BUFF_TARGET_RAID, VUHDO_SPELL_ID.BUFF_DALARAN_BRILLIANCE },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_ICE_BLOCK] = { -- 2
			{
				{ VUHDO_SPELL_ID.BUFF_ICE_BLOCK, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_I18N_BUFFC_ARMOR_MAGE] = { -- 3
			{
				{ VUHDO_SPELL_ID.BUFF_FROST_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_MOLTEN_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_ICE_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_MAGE_ARMOR, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_FOCUS_MAGIC] = { -- 4
			{
				{ VUHDO_SPELL_ID.BUFF_FOCUS_MAGIC, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_COMBUSTION] = { -- 5
			{
				{ VUHDO_SPELL_ID.BUFF_COMBUSTION, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_SLOW_FALL] = { -- 6
			{
				{ VUHDO_SPELL_ID.BUFF_SLOW_FALL, VUHDO_BUFF_TARGET_SINGLE },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_INVISIBILITY] = { -- 7
			{
				{ VUHDO_SPELL_ID.BUFF_INVISIBILITY, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	-- Death Knight
	["DEATHKNIGHT"] = {
		[VUHDO_SPELL_ID.BUFFC_HORN_OF_WINTER] = {
			{
				{VUHDO_SPELL_ID.BUFF_HORN_OF_WINTER , VUHDO_BUFF_TARGET_SELF, VUHDO_SPELL_ID.BUFF_BATTLE_SHOUT },
			}
		},
		[VUHDO_SPELL_ID.BUFFC_BONE_SHIELD] = {
			{
				{ VUHDO_SPELL_ID.BUFF_BONE_SHIELD, VUHDO_BUFF_TARGET_SELF },
			}
		},
		[VUHDO_BUFFC_PRESENCE] = {
			{
				{ VUHDO_SPELL_ID.BUFF_BLOOD_PRESENCE, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_FROST_PRESENCE, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_UNHOLY_PRESENCE, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	-- Warrior
	["WARRIOR"] = {
		[VUHDO_I18N_BUFFC_SHOUT] = {
			{
				{ VUHDO_SPELL_ID.BUFF_BATTLE_SHOUT, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_COMMANDING_SHOUT, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_SPELL_ID.BUFFC_VIGILANCE] = {
			{
				{ VUHDO_SPELL_ID.BUFF_VIGILANCE, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
	},

	-- Hunter
	["HUNTER"] = {
		[VUHDO_SPELL_ID.BUFFC_TRUESHOT_AURA] = {
			{
				{ VUHDO_SPELL_ID.BUFF_TRUESHOT_AURA, VUHDO_BUFF_TARGET_SELF },
			},
		},
		[VUHDO_I18N_BUFFC_ASPECT] = {
			{
				{ VUHDO_SPELL_ID.BUFF_ASPECT_OF_THE_HAWK, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_ASPECT_OF_THE_PACK, VUHDO_BUFF_TARGET_SELF },
			},
			{
				{ VUHDO_SPELL_ID.BUFF_ASPECT_OF_THE_WILD, VUHDO_BUFF_TARGET_SELF },
			},
		},
	},

	-- Rogue
	["ROGUE"] = {
		[VUHDO_SPELL_ID.BUFFC_TRICKS_OF_THE_TRADE] = {
			{
				{ VUHDO_SPELL_ID.BUFF_TRICKS_OF_THE_TRADE, VUHDO_BUFF_TARGET_UNIQUE },
			},
		},
	},
};



VUHDO_CAST_ICON_DIFF = {
	[VUHDO_SPELL_ID.BUFF_EARTHLIVING_WEAPON] = "Interface\\Icons\\Spell_Shaman_GiftEarthmother",
	["OTHER"] = "Interface\\Icons\\achievement_bg_tophealer_soa",
};



VUHDO_BUFF_FILTER_COMBO_TABLE = {
	{ VUHDO_ID_ALL, VUHDO_I18N_BUFF_ALL },

	{ VUHDO_ID_MAINTANKS, VUHDO_HEADER_TEXTS[VUHDO_ID_MAINTANKS] },
	{ VUHDO_ID_MAIN_ASSISTS, VUHDO_HEADER_TEXTS[VUHDO_ID_MAIN_ASSISTS] },
	{ VUHDO_ID_PRIVATE_TANKS, VUHDO_HEADER_TEXTS[VUHDO_ID_PRIVATE_TANKS] },
	{ VUHDO_ID_SELF, VUHDO_HEADER_TEXTS[VUHDO_ID_SELF] },

	{ VUHDO_ID_GROUP_OWN, VUHDO_I18N_OWN_GROUP_LONG },

	{ VUHDO_ID_MELEE_TANK, VUHDO_HEADER_TEXTS[VUHDO_ID_MELEE_TANK] },
	{ VUHDO_ID_MELEE_DAMAGE, VUHDO_HEADER_TEXTS[VUHDO_ID_MELEE_DAMAGE] },
	{ VUHDO_ID_RANGED_DAMAGE, VUHDO_HEADER_TEXTS[VUHDO_ID_RANGED_DAMAGE] },
	{ VUHDO_ID_RANGED_HEAL, VUHDO_HEADER_TEXTS[VUHDO_ID_RANGED_HEAL] },
};
