HEALBOT_VERSION = "4.3.0.1";

-------------
-- ENGLISH --
-------------

-------------------
-- Compatibility --
-------------------

-- Class
HEALBOT_DRUID                           = "Druid";
HEALBOT_HUNTER                          = "Hunter";
HEALBOT_MAGE                            = "Mage";
HEALBOT_PALADIN                         = "Paladin";
HEALBOT_PRIEST                          = "Priest";
HEALBOT_ROGUE                           = "Rogue";
HEALBOT_SHAMAN                          = "Shaman";
HEALBOT_WARLOCK                         = "Warlock";
HEALBOT_WARRIOR                         = "Warrior";
HEALBOT_DEATHKNIGHT                     = "Death Knight";

-- Bandages and pots
HEALBOT_SILK_BANDAGE                    = GetItemInfo(6450) or "Silk Bandage";
HEALBOT_HEAVY_SILK_BANDAGE              = GetItemInfo(6451) or "Heavy Silk Bandage";
HEALBOT_MAGEWEAVE_BANDAGE               = GetItemInfo(8544) or "Mageweave Bandage";
HEALBOT_HEAVY_MAGEWEAVE_BANDAGE         = GetItemInfo(8545) or "Heavy Mageweave Bandage";
HEALBOT_RUNECLOTH_BANDAGE               = GetItemInfo(14529) or "Runecloth Bandage";
HEALBOT_HEAVY_RUNECLOTH_BANDAGE         = GetItemInfo(14530) or "Heavy Runecloth Bandage";
HEALBOT_NETHERWEAVE_BANDAGE             = GetItemInfo(21990) or "Netherweave Bandage";
HEALBOT_HEAVY_NETHERWEAVE_BANDAGE       = GetItemInfo(21991) or "Heavy Netherweave Bandage";
HEALBOT_FROSTWEAVE_BANDAGE              = GetItemInfo(34721) or "Frostweave Bandage";
HEALBOT_HEAVY_FROSTWEAVE_BANDAGE        = GetItemInfo(34722) or "Heavy Frostweave Bandage";
HEALBOT_EMBERSILK_BANDAGE               = GetItemInfo(53049) or "Embersilk Bandage";
HEALBOT_DENSE_EMBERSILK_BANDAGE         = GetItemInfo(53051) or "Dense Embersilk Bandage";
HEALBOT_MAJOR_HEALING_POTION            = GetItemInfo(13446) or "Major Healing Potion";
HEALBOT_SUPER_HEALING_POTION            = GetItemInfo(22829) or "Super Healing Potion";
HEALBOT_MAJOR_COMBAT_HEALING_POTION     = GetItemInfo(31838) or "Major Combat Healing Potion";
HEALBOT_RUNIC_HEALING_POTION            = GetItemInfo(33447) or "Runic Healing Potion";
HEALBOT_ENDLESS_HEALING_POTION          = GetItemInfo(43569) or "Endless Healing Potion";   
HEALBOT_MAJOR_MANA_POTION               = GetItemInfo(13444) or "Major Mana Potion";
HEALBOT_SUPER_MANA_POTION               = GetItemInfo(22832) or "Super Mana Potion";
HEALBOT_MAJOR_COMBAT_MANA_POTION        = GetItemInfo(31840) or "Major Combat Mana Potion";
HEALBOT_RUNIC_MANA_POTION               = GetItemInfo(33448) or "Runic Mana Potion";
HEALBOT_ENDLESS_MANA_POTION             = GetItemInfo(43570) or "Endless Mana Potion";
HEALBOT_PURIFICATION_POTION             = GetItemInfo(13462) or "Purification Potion";
HEALBOT_ANTI_VENOM                      = GetItemInfo(6452) or "Anti-Venom";
HEALBOT_POWERFUL_ANTI_VENOM             = GetItemInfo(19440) or "Powerful Anti-Venom";
HEALBOT_ELIXIR_OF_POISON_RES            = GetItemInfo(3386) or "Potion of Curing";

-- Racial abilities and item procs
HEALBOT_STONEFORM                       = GetSpellInfo(20594) or "Stoneform";
HEALBOT_GIFT_OF_THE_NAARU               = GetSpellInfo(59547) or "Gift of the Naaru";
HEALBOT_PROTANCIENTKINGS                = GetSpellInfo(64413) or "Protection of Ancient Kings";

-- Healing spells by class
HEALBOT_REJUVENATION                    = GetSpellInfo(774) or "Rejuvenation";
HEALBOT_LIFEBLOOM                       = GetSpellInfo(33763) or "Lifebloom";
HEALBOT_WILD_GROWTH                     = GetSpellInfo(48438) or "Wild Growth";
HEALBOT_TRANQUILITY                     = GetSpellInfo(740) or "Tranquility";
HEALBOT_SWIFTMEND                       = GetSpellInfo(18562) or "Swiftmend";
HEALBOT_LIVING_SEED                     = GetSpellInfo(48496) or "Living Seed";
HEALBOT_REGROWTH                        = GetSpellInfo(8936) or "Regrowth";
HEALBOT_HEALING_TOUCH                   = GetSpellInfo(5185) or "Healing Touch";
HEALBOT_NOURISH                         = GetSpellInfo(50464) or "Nourish";

HEALBOT_FLASH_OF_LIGHT                  = GetSpellInfo(19750) or "Flash of Light";
HEALBOT_WORD_OF_GLORY                   = GetSpellInfo(85673) or "Word of Glory";
HEALBOT_LIGHT_OF_DAWN                   = GetSpellInfo(85222) or "Light of Dawn";
HEALBOT_HOLY_LIGHT                      = GetSpellInfo(635) or "Holy Light";
HEALBOT_DIVINE_LIGHT                    = GetSpellInfo(82326) or "Divine Light";
HEALBOT_HOLY_RADIANCE                   = GetSpellInfo(82327) or "Holy Radiance";

HEALBOT_GREATER_HEAL                    = GetSpellInfo(2060) or "Greater Heal";
HEALBOT_BINDING_HEAL                    = GetSpellInfo(32546) or "Binding Heal"
HEALBOT_PENANCE                         = GetSpellInfo(47540) or "Penance"
HEALBOT_PRAYER_OF_MENDING               = GetSpellInfo(33076) or "Prayer of Mending";
HEALBOT_FLASH_HEAL                      = GetSpellInfo(2061) or "Flash Heal";
HEALBOT_HEAL                            = GetSpellInfo(2050) or "Heal";
HEALBOT_HOLY_NOVA                       = GetSpellInfo(15237) or "Holy Nova";
HEALBOT_DIVINE_HYMN                     = GetSpellInfo(64843) or "Divine Hymn";
HEALBOT_RENEW                           = GetSpellInfo(139) or "Renew";
HEALBOT_DESPERATE_PRAYER                = GetSpellInfo(19236) or "Desperate Prayer";
HEALBOT_PRAYER_OF_HEALING               = GetSpellInfo(596) or "Prayer of Healing";
HEALBOT_GLYPH_PRAYER_OF_HEALING         = GetSpellInfo(55680) or "Glyph of Prayer of Healing"
HEALBOT_CIRCLE_OF_HEALING               = GetSpellInfo(34861) or "Circle of Healing";
HEALBOT_HOLY_WORD_CHASTISE              = GetSpellInfo(88625) or "Holy Word: Chastise";
HEALBOT_HOLY_WORD_SERENITY              = GetSpellInfo(88684) or "Holy Word: Serenity"; -- Heal
-- HEALBOT_HOLY_WORD_ASPIRE                = GetSpellInfo(88682) or "Holy Word: Aspire"; -- Renew - 88682
HEALBOT_HOLY_WORD_SANCTUARY             = GetSpellInfo(88685) or "Holy Word: Sanctuary"; -- PoH 

HEALBOT_HEALING_WAVE                    = GetSpellInfo(331) or "Healing Wave";
HEALBOT_HEALING_SURGE                   = GetSpellInfo(8004) or "Healing Surge";
HEALBOT_RIPTIDE                         = GetSpellInfo(61295) or "Riptide";
HEALBOT_HEALING_WAY                     = GetSpellInfo(29206) or "Healing Way";
HEALBOT_GREATER_HEALING_WAVE            = GetSpellInfo(77472) or "Greater Healing Wave";
HEALBOT_HEALING_RAIN                    = GetSpellInfo(73920) or "Healing Rain";
HEALBOT_CHAIN_HEAL                      = GetSpellInfo(1064) or "Chain Heal";

HEALBOT_HEALTH_FUNNEL                   = GetSpellInfo(755) or "Health Funnel";

-- Buffs, Talents and Other spells by class
HEALBOT_ICEBOUND_FORTITUDE              = GetSpellInfo(48792) or "Icebound Fortitude";
HEALBOT_ANTIMAGIC_SHELL                 = GetSpellInfo(48707) or "Antimagic Shell";
HEALBOT_ARMY_OF_THE_DEAD                = GetSpellInfo(42650) or "Army of the Dead";
HEALBOT_LICHBORNE                       = GetSpellInfo(49039) or "Lichborne";
HEALBOT_ANTIMAGIC_ZONE                  = GetSpellInfo(51052) or "Antimagic Zone";
HEALBOT_VAMPIRIC_BLOOD                  = GetSpellInfo(55233) or "Vampiric Blood";
HEALBOT_BONE_SHIELD                     = GetSpellInfo(49222) or "Bone Shield";
HEALBOT_HORN_OF_WINTER                  = GetSpellInfo(57330) or "Horn of Winter";

HEALBOT_MARK_OF_THE_WILD                = GetSpellInfo(1126) or "Mark of the Wild";
HEALBOT_THORNS                          = GetSpellInfo(467) or "Thorns";
HEALBOT_NATURES_GRASP                   = GetSpellInfo(16689) or "Nature's Grasp";
HEALBOT_OMEN_OF_CLARITY                 = GetSpellInfo(16864) or "Omen of Clarity";
HEALBOT_BARKSKIN                        = GetSpellInfo(22812) or "Barkskin";
HEALBOT_SURVIVAL_INSTINCTS              = GetSpellInfo(61336) or "Survival Instincts";
HEALBOT_FRENZIED_REGEN                  = GetSpellInfo(22842) or "Frenzied Regeneration";
HEALBOT_INNERVATE                       = GetSpellInfo(29166) or "Innervate";
HEALBOT_DRUID_CLEARCASTING              = GetSpellInfo(16870) or "Clearcasting";
HEALBOT_TREE_OF_LIFE                    = GetSpellInfo(33891) or "Tree of Life";
HEALBOT_EFFLORESCENCE                   = GetSpellInfo(81275) or "Efflorescence";
HEALBOT_HARMONY                         = GetSpellInfo(77495) or "Efflorescence";

HEALBOT_A_FOX                           = GetSpellInfo(82661) or "Aspect of the Fox"
HEALBOT_A_HAWK                          = GetSpellInfo(13165) or "Aspect of the Hawk"
HEALBOT_A_CHEETAH                       = GetSpellInfo(5118) or "Aspect of the Cheetah"
HEALBOT_A_PACK                          = GetSpellInfo(13159) or "Aspect of the Pack"
HEALBOT_A_WILD                          = GetSpellInfo(20043) or "Aspect of the Wild"
HEALBOT_MENDPET                         = GetSpellInfo(136) or "Mend Pet"

HEALBOT_ARCANE_BRILLIANCE               = GetSpellInfo(1459) or "Arcane Brilliance";
HEALBOT_DALARAN_BRILLIANCE              = GetSpellInfo(61316) or "Dalaran Brilliance";
HEALBOT_MAGE_WARD                       = GetSpellInfo(543) or "Mage Ward";
HEALBOT_MAGE_ARMOR                      = GetSpellInfo(6117) or "Mage Armor";
HEALBOT_MOLTEN_ARMOR                    = GetSpellInfo(30482) or "Molten Armor";
HEALBOT_FOCUS_MAGIC                     = GetSpellInfo(54646) or "Focus Magic";
HEALBOT_FROST_ARMOR                     = GetSpellInfo(168) or "Frost Armor";

HEALBOT_HANDOFPROTECTION                = GetSpellInfo(1022) or "Hand of Protection";
HEALBOT_BEACON_OF_LIGHT                 = GetSpellInfo(53563) or "Beacon of Light";
HEALBOT_LIGHT_BEACON                    = GetSpellInfo(53651) or "Light's Beacon";
HEALBOT_CONVICTION                      = GetSpellInfo(20049) or "Conviction";
HEALBOT_SACRED_SHIELD                   = GetSpellInfo(53601) or "Sacred Shield";
HEALBOT_LAY_ON_HANDS                    = GetSpellInfo(633) or "Lay on Hands";
HEALBOT_INFUSION_OF_LIGHT               = GetSpellInfo(53569) or "Infusion of Light";
HEALBOT_SPEED_OF_LIGHT                  = GetSpellInfo(85495) or "Speed of Light";
HEALBOT_DAY_BREAK                       = GetSpellInfo(88820) or "Daybreak";
HEALBOT_DENOUNCE                        = GetSpellInfo(31825) or "Denounce";
HEALBOT_CLARITY_OF_PURPOSE              = GetSpellInfo(85462) or "Clarity of Purpose";
HEALBOT_HOLY_SHOCK                      = GetSpellInfo(20473) or "Holy Shock";
HEALBOT_DIVINE_FAVOR                    = GetSpellInfo(31842) or "Divine Favor";
HEALBOT_DIVINE_PLEA                     = GetSpellInfo(54428) or "Divine Plea"
HEALBOT_DIVINE_SHIELD                   = GetSpellInfo(642) or "Divine Shield";
HEALBOT_RIGHTEOUS_DEFENSE               = GetSpellInfo(31789) or "Righteous Defense";
HEALBOT_BLESSING_OF_MIGHT               = GetSpellInfo(19740) or "Blessing of Might";
HEALBOT_BLESSING_OF_KINGS               = GetSpellInfo(20217) or "Blessing of Kings";
HEALBOT_SEAL_OF_RIGHTEOUSNESS           = GetSpellInfo(20154) or "Seal of Righteousness";
HEALBOT_SEAL_OF_JUSTICE                 = GetSpellInfo(20164) or "Seal of Justice";
HEALBOT_SEAL_OF_INSIGHT                 = GetSpellInfo(20165) or "Seal of Insight";
HEALBOT_SEAL_OF_TRUTH                   = GetSpellInfo(31801) or "Seal of Truth";
HEALBOT_HAND_OF_FREEDOM                 = GetSpellInfo(1044) or "Hand of Freedom";
HEALBOT_HAND_OF_PROTECTION              = GetSpellInfo(1022) or "Hand of Protection";
HEALBOT_HAND_OF_SACRIFICE               = GetSpellInfo(6940) or "Hand of Sacrifice";
HEALBOT_HAND_OF_SALVATION               = GetSpellInfo(1038) or "Hand of Salvation";
HEALBOT_RIGHTEOUS_FURY                  = GetSpellInfo(25780) or "Righteous Fury";
HEALBOT_AURA_MASTERY                    = GetSpellInfo(31821) or "Aura Mastery";
HEALBOT_DEVOTION_AURA                   = GetSpellInfo(465) or "Devotion Aura";
HEALBOT_RETRIBUTION_AURA                = GetSpellInfo(7294) or "Retribution Aura";
HEALBOT_RESISTANCE_AURA                 = GetSpellInfo(19891) or "Resistance Aura";
HEALBOT_CONCENTRATION_AURA              = GetSpellInfo(19746) or "Concentration Aura";
HEALBOT_CRUSADER_AURA                   = GetSpellInfo(32223) or "Crusader Aura";
HEALBOT_DIVINE_PROTECTION               = GetSpellInfo(498) or "Divine Protection";
HEALBOT_ILLUMINATED_HEALING             = GetSpellInfo(76669) or "Illuminated Healing";
HEALBOT_ARDENT_DEFENDER                 = GetSpellInfo(31850) or "Ardent Defender";
HEALBOT_HOLY_SHIELD                     = GetSpellInfo(20925) or "Holy Shield"
HEALBOT_GUARDED_BY_THE_LIGHT            = GetSpellInfo(85646) or "Guarded by the Light";
HEALBOT_GUARDIAN_ANCIENT_KINGS          = GetSpellInfo(86150) or "Guardian of Ancient Kings";

HEALBOT_POWER_WORD_SHIELD               = GetSpellInfo(17) or "Power Word: Shield";
HEALBOT_POWER_WORD_BARRIER              = GetSpellInfo(62618) or "Power Word: Barrier";
HEALBOT_ECHO_OF_LIGHT                   = GetSpellInfo(77485) or "Echo of Light";
HEALBOT_GUARDIAN_SPIRIT                 = GetSpellInfo(47788) or "Guardian Spirit";
HEALBOT_LEVITATE                        = GetSpellInfo(1706) or "Levitate";
HEALBOT_DIVINE_AEGIS                    = GetSpellInfo(47509) or "Divine Aegis";
HEALBOT_SURGE_OF_LIGHT                  = GetSpellInfo(33154) or "Surge of Light";
HEALBOT_BLESSED_HEALING                 = GetSpellInfo(70772) or "Blessed Healing";
HEALBOT_BLESSED_RESILIENCE              = GetSpellInfo(33142) or "Blessed Resilience";
HEALBOT_PAIN_SUPPRESSION                = GetSpellInfo(33206) or "Pain Suppression";
HEALBOT_POWER_INFUSION                  = GetSpellInfo(10060) or "Power Infusion";
HEALBOT_POWER_WORD_FORTITUDE            = GetSpellInfo(21562) or "Power Word: Fortitude";
HEALBOT_SHADOW_PROTECTION               = GetSpellInfo(27683) or "Shadow Protection";
HEALBOT_INNER_FIRE                      = GetSpellInfo(588) or "Inner Fire";
HEALBOT_INNER_WILL                      = GetSpellInfo(73413) or "Inner Will";
HEALBOT_SHADOWFORM                      = GetSpellInfo(15473) or "Shadowform"
HEALBOT_INNER_FOCUS                     = GetSpellInfo(89485) or "Inner Focus";
HEALBOT_CHAKRA                          = GetSpellInfo(14751) or "Chakra";
HEALBOT_CHAKRA_POH                      = GetSpellInfo(81206) or "Chakra: Prayer of Healing";
-- HEALBOT_CHAKRA_RENEW                    = GetSpellInfo(81207) or "Chakra: Renew";
HEALBOT_CHAKRA_HEAL                     = GetSpellInfo(81208) or "Chakra: Heal";
HEALBOT_CHAKRA_SMITE                    = GetSpellInfo(81209) or "Chakra: Smite";
HEALBOT_REVELATIONS                     = GetSpellInfo(88627) or "Revelations";
HEALBOT_FEAR_WARD                       = GetSpellInfo(6346) or "Fear Ward";
HEALBOT_SERENDIPITY                     = GetSpellInfo(63730) or "Serendipity";
HEALBOT_VAMPIRIC_EMBRACE                = GetSpellInfo(15286) or "Vampiric Embrace";
HEALBOT_INSPIRATION                     = GetSpellInfo(14892) or "Inspiration";
HEALBOT_LIGHTWELL_RENEW                 = GetSpellInfo(7001) or "Lightwell Renew";
HEALBOT_GRACE                           = GetSpellInfo(47516) or "Grace";
HEALBOT_LEAP_OF_FAITH                   = GetSpellInfo(73325) or "Leap of Faith";
HEALBOT_EVANGELISM                      = GetSpellInfo(81661) or "Evangelism";
HEALBOT_ARCHANGEL                       = GetSpellInfo(87151) or "Archangel";

HEALBOT_CHAINHEALHOT                    = GetSpellInfo(70809) or "Chain Heal";
HEALBOT_TIDAL_WAVES                     = GetSpellInfo(51562) or "Tidal Waves";
HEALBOT_TIDAL_FORCE                     = GetSpellInfo(55198) or "Tidal Force";
HEALBOT_NATURE_SWIFTNESS                = GetSpellInfo(17116) or "Nature's Swiftness";
HEALBOT_LIGHTNING_SHIELD                = GetSpellInfo(324) or "Lightning Shield";
HEALBOT_ROCKBITER_WEAPON                = GetSpellInfo(8017) or "Rockbiter Weapon";
HEALBOT_FLAMETONGUE_WEAPON              = GetSpellInfo(8024) or "Flametongue Weapon";
HEALBOT_EARTHLIVING_WEAPON              = GetSpellInfo(51730) or "Earthliving Weapon";
HEALBOT_WINDFURY_WEAPON                 = GetSpellInfo(8232) or "Windfury Weapon";
HEALBOT_FROSTBRAND_WEAPON               = GetSpellInfo(8033) or "Frostbrand Weapon";
HEALBOT_EARTH_SHIELD                    = GetSpellInfo(974) or "Earth Shield";
HEALBOT_WATER_SHIELD                    = GetSpellInfo(52127) or "Water Shield";
HEALBOT_WATER_BREATHING                 = GetSpellInfo(131) or "Water Breathing";
HEALBOT_WATER_WALKING                   = GetSpellInfo(546) or "Water Walking";
HEALBOT_ANCESTRAL_FORTITUDE             = GetSpellInfo(16236) or "Ancestral Fortitude";
HEALBOT_EARTHLIVING                     = GetSpellInfo(51945) or "Earthliving";
HEALBOT_UNLEASH_ELEMENTS                = GetSpellInfo(73680) or "Unleash Elements";
HEALBOT_STONEKIN_TOTEM                  = GetSpellInfo(8071) or "Stonekin Totem";

HEALBOT_DEMON_ARMOR                     = GetSpellInfo(687) or "Demon Armor";
HEALBOT_FEL_ARMOR                       = GetSpellInfo(28176) or "Fel Armor";
HEALBOT_SOUL_LINK                       = GetSpellInfo(19028) or "Soul Link";
HEALBOT_UNENDING_BREATH                 = GetSpellInfo(5697) or "Unending Breath"
HEALBOT_LIFE_TAP                        = GetSpellInfo(1454) or "Life Tap";
HEALBOT_BLOOD_PACT                      = GetSpellInfo(6307) or "Blood Pact";
HEALBOT_DARK_INTENT                     = GetSpellInfo(80398) or "Dark Intent";

HEALBOT_BATTLE_SHOUT                    = GetSpellInfo(6673) or "Battle Shout";
HEALBOT_COMMANDING_SHOUT                = GetSpellInfo(469) or "Commanding Shout";
HEALBOT_INTERVENE                       = GetSpellInfo(3411) or "Intervene";
HEALBOT_VIGILANCE                       = GetSpellInfo(50720) or "Vigilance";
HEALBOT_LAST_STAND                      = GetSpellInfo(12975) or "Last Stand";
HEALBOT_SHIELD_WALL                     = GetSpellInfo(871) or "Shield Wall";
HEALBOT_SHIELD_BLOCK                    = GetSpellInfo(2565) or "Shield Block";
HEALBOT_ENRAGED_REGEN                   = GetSpellInfo(55694) or "Enraged Regeneration";

-- Res Spells
HEALBOT_RESURRECTION                    = GetSpellInfo(2006) or "Resurrection";
HEALBOT_MASS_RESURRECTION               = GetSpellInfo(83968) or "Mass Resurrection";
HEALBOT_REDEMPTION                      = GetSpellInfo(7328) or "Redemption";
HEALBOT_REBIRTH                         = GetSpellInfo(20484) or "Rebirth";
HEALBOT_REVIVE                          = GetSpellInfo(50769) or "Revive";
HEALBOT_ANCESTRALSPIRIT                 = GetSpellInfo(2008) or "Ancestral Spirit";

-- Cure Spells
HEALBOT_CLEANSE                         = GetSpellInfo(4987) or "Cleanse";
HEALBOT_REMOVE_CURSE                    = GetSpellInfo(475) or "Remove Curse";
HEALBOT_REMOVE_CORRUPTION               = GetSpellInfo(2782) or "Remove Corruption";
HEALBOT_NATURES_CURE                    = GetSpellInfo(88423) or "Nature's Cure";
HEALBOT_CURE_DISEASE                    = GetSpellInfo(528) or "Cure Disease";
HEALBOT_DISPEL_MAGIC                    = GetSpellInfo(527) or "Dispel Magic";
HEALBOT_CLEANSE_SPIRIT                  = GetSpellInfo(51886) or "Cleanse Spirit";
HEALBOT_IMPROVED_CLEANSE_SPIRIT         = GetSpellInfo(77130) or "Improved Cleanse Spirit";
HEALBOT_SACRED_CLEANSING                = GetSpellInfo(53551) or "Sacred Cleansing";
HEALBOT_BODY_AND_SOUL                   = GetSpellInfo(64127) or "Body and Soul";
HEALBOT_DISEASE                         = "Disease";
HEALBOT_MAGIC                           = "Magic";
HEALBOT_CURSE                           = "Curse";
HEALBOT_POISON                          = "Poison";
HEALBOT_DISEASE_en                      = "Disease";  -- Do NOT localize this value.
HEALBOT_MAGIC_en                        = "Magic";  -- Do NOT localize this value.
HEALBOT_CURSE_en                        = "Curse";  -- Do NOT localize this value.
HEALBOT_POISON_en                       = "Poison";  -- Do NOT localize this value.
HEALBOT_CUSTOM_en                       = "Custom";  -- Do NOT localize this value. 

-- Common Buffs
HEALBOT_ZAMAELS_PRAYER                  = GetSpellInfo(88663) or "Zamael's Prayer";

-- Debuffs
HEALBOT_DEBUFF_ANCIENT_HYSTERIA         = "Ancient Hysteria";
HEALBOT_DEBUFF_IGNITE_MANA              = "Ignite Mana";
HEALBOT_DEBUFF_TAINTED_MIND             = "Tainted Mind";
HEALBOT_DEBUFF_VIPER_STING              = "Viper Sting";
HEALBOT_DEBUFF_SILENCE                  = "Silence";
HEALBOT_DEBUFF_MAGMA_SHACKLES           = "Magma Shackles";
HEALBOT_DEBUFF_FROSTBOLT                = "Frostbolt";
HEALBOT_DEBUFF_HUNTERS_MARK             = "Hunter's Mark";
HEALBOT_DEBUFF_SLOW                     = "Slow";
HEALBOT_DEBUFF_ARCANE_BLAST             = "Arcane Blast";
HEALBOT_DEBUFF_IMPOTENCE                = "Curse of Impotence";
HEALBOT_DEBUFF_DECAYED_STR              = "Decayed Strength";
HEALBOT_DEBUFF_DECAYED_INT              = "Decayed Intellect";
HEALBOT_DEBUFF_CRIPPLE                  = "Cripple";
HEALBOT_DEBUFF_CHILLED                  = "Chilled";
HEALBOT_DEBUFF_CONEOFCOLD               = "Cone of Cold";
HEALBOT_DEBUFF_CONCUSSIVESHOT           = "Concussive Shot";
HEALBOT_DEBUFF_THUNDERCLAP              = "Thunderclap";
HEALBOT_DEBUFF_HOWLINGSCREECH           = "Howling Screech";
HEALBOT_DEBUFF_DAZED                    = "Dazed";
HEALBOT_DEBUFF_UNSTABLE_AFFL            = "Unstable Affliction";
HEALBOT_DEBUFF_DREAMLESS_SLEEP          = "Dreamless Sleep";
HEALBOT_DEBUFF_GREATER_DREAMLESS        = "Greater Dreamless Sleep";
HEALBOT_DEBUFF_MAJOR_DREAMLESS          = "Major Dreamless Sleep";
HEALBOT_DEBUFF_FROST_SHOCK              = "Frost Shock"
HEALBOT_DEBUFF_WEAKENED_SOUL            = GetSpellInfo(6788) or "Weakened Soul";

HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(29670) or "Ice Tomb";
HEALBOT_DEBUFF_SACRIFICE                = GetSpellInfo(30115) or "Sacrifice";
HEALBOT_DEBUFF_ICEBOLT                  = GetSpellInfo(31249) or "Icebolt";
HEALBOT_DEBUFF_DOOMFIRE                 = GetSpellInfo(31944) or "Doomfire";
HEALBOT_DEBUFF_IMPALING_SPINE           = GetSpellInfo(39837) or "Impaling Spine";
HEALBOT_DEBUFF_FEL_RAGE                 = GetSpellInfo(40604) or "Fel Rage";
HEALBOT_DEBUFF_FEL_RAGE2                = GetSpellInfo(40616) or "Fel Rage 2";
HEALBOT_DEBUFF_FATAL_ATTRACTION         = GetSpellInfo(41001) or "Fatal Attraction";
HEALBOT_DEBUFF_AGONIZING_FLAMES         = GetSpellInfo(40932) or "Agonizing Flames";
HEALBOT_DEBUFF_DARK_BARRAGE             = GetSpellInfo(40585) or "Dark Barrage";
HEALBOT_DEBUFF_PARASITIC_SHADOWFIEND    = GetSpellInfo(41917) or "Parasitic Shadowfiend";
HEALBOT_DEBUFF_GRIEVOUS_THROW           = GetSpellInfo(43093) or "Grievous Throw";
HEALBOT_DEBUFF_BURN                     = GetSpellInfo(46394) or "Burn";
HEALBOT_DEBUFF_ENCAPSULATE              = GetSpellInfo(45662) or "Encapsulate";
HEALBOT_DEBUFF_CONFLAGRATION            = GetSpellInfo(45342) or "Conflagration";
HEALBOT_DEBUFF_FLAME_SEAR               = GetSpellInfo(46771) or "Flame Sear";
HEALBOT_DEBUFF_FIRE_BLOOM               = GetSpellInfo(45641) or "Fire Bloom";
HEALBOT_DEBUFF_GRIEVOUS_BITE            = GetSpellInfo(48920) or "Grievous Bite";
HEALBOT_DEBUFF_FROST_TOMB               = GetSpellInfo(25168) or "Frost Tomb";
HEALBOT_DEBUFF_IMPALE                   = GetSpellInfo(67478) or "Impale";
HEALBOT_DEBUFF_WEB_WRAP                 = GetSpellInfo(28622) or "Web Wrap";
HEALBOT_DEBUFF_JAGGED_KNIFE             = GetSpellInfo(55550) or "Jagged Knife";
HEALBOT_DEBUFF_FROST_BLAST              = GetSpellInfo(27808) or "Frost Blast";
HEALBOT_DEBUFF_SLAG_PIT                 = GetSpellInfo(63477) or "Slag Pit";
HEALBOT_DEBUFF_GRAVITY_BOMB             = GetSpellInfo(64234) or "Gravity Bomb";
HEALBOT_DEBUFF_LIGHT_BOMB               = GetSpellInfo(63018) or "Light Bomb";
HEALBOT_DEBUFF_STONE_GRIP               = GetSpellInfo(64292) or "Stone Grip";
HEALBOT_DEBUFF_FERAL_POUNCE             = GetSpellInfo(64669) or "Feral Pounce";
HEALBOT_DEBUFF_NAPALM_SHELL             = GetSpellInfo(63666) or "Napalm Shell";
HEALBOT_DEBUFF_IRON_ROOTS               = GetSpellInfo(62283) or "Iron Roots";
HEALBOT_DEBUFF_SARA_BLESSING            = GetSpellInfo(63134) or "Sara's Blessing";
HEALBOT_DEBUFF_SNOBOLLED                = GetSpellInfo(66406) or "Snobolled!";
HEALBOT_DEBUFF_FIRE_BOMB                = GetSpellInfo(67475) or "Fire Bomb";
HEALBOT_DEBUFF_BURNING_BILE             = GetSpellInfo(66869) or "Burning Bile";
HEALBOT_DEBUFF_PARALYTIC_TOXIN          = GetSpellInfo(67618) or "Paralytic Toxin";
HEALBOT_DEBUFF_INCINERATE_FLESH         = GetSpellInfo(67049) or "Incinerate Flesh";
HEALBOT_DEBUFF_LEGION_FLAME             = GetSpellInfo(68123) or "Legion Flame";
HEALBOT_DEBUFF_MISTRESS_KISS            = GetSpellInfo(67078) or "Mistress' Kiss";
HEALBOT_DEBUFF_SPINNING_PAIN_SPIKE      = GetSpellInfo(66283) or "Spinning Pain Spike";
HEALBOT_DEBUFF_TOUCH_OF_LIGHT           = GetSpellInfo(67297) or "Touch of Light";
HEALBOT_DEBUFF_TOUCH_OF_DARKNESS        = GetSpellInfo(66001) or "Touch of Darkness";
HEALBOT_DEBUFF_PENETRATING_COLD         = GetSpellInfo(66013) or "Penetrating Cold";
HEALBOT_DEBUFF_ACID_DRENCHED_MANDIBLES  = GetSpellInfo(67861) or "Acid-Drenched Mandibles";
HEALBOT_DEBUFF_EXPOSE_WEAKNESS          = GetSpellInfo(67847) or "Expose Weakness";
HEALBOT_DEBUFF_IMPALED                  = GetSpellInfo(69065) or "Impaled";
HEALBOT_DEBUFF_NECROTIC_STRIKE          = GetSpellInfo(70659) or "Necrotic Strike";
HEALBOT_DEBUFF_FALLEN_CHAMPION          = GetSpellInfo(72293) or "Mark of the Fallen Champion";
HEALBOT_DEBUFF_BOILING_BLOOD            = GetSpellInfo(72385) or "Boiling Blood";
HEALBOT_DEBUFF_RUNE_OF_BLOOD            = GetSpellInfo(72409) or "Rune of Blood";
HEALBOT_DEBUFF_VILE_GAS                 = GetSpellInfo(72273) or "Vile Gas";
HEALBOT_DEBUFF_GASTRIC_BLOAT            = GetSpellInfo(72219) or "Gastric Bloat";
HEALBOT_DEBUFF_GAS_SPORE                = GetSpellInfo(69278) or "Gas Spore";
HEALBOT_DEBUFF_INOCULATED               = GetSpellInfo(72103) or "Inoculated";
HEALBOT_DEBUFF_MUTATED_INFECTION        = GetSpellInfo(71224) or "Mutated Infection";
HEALBOT_DEBUFF_GASEOUS_BLOAT            = GetSpellInfo(72455) or "Gaseous Bloat";
HEALBOT_DEBUFF_VOLATILE_OOZE            = GetSpellInfo(70447) or "Volatile Ooze Adhesive";
HEALBOT_DEBUFF_MUTATED_PLAGUE           = GetSpellInfo(72745) or "Mutated Plague";
HEALBOT_DEBUFF_GLITTERING_SPARKS        = GetSpellInfo(72796) or "Glittering Sparks";
HEALBOT_DEBUFF_SHADOW_PRISON            = GetSpellInfo(72999) or "Shadow Prison";
HEALBOT_DEBUFF_SWARMING_SHADOWS         = GetSpellInfo(72638) or "Swarming Shadows";
HEALBOT_DEBUFF_PACT_DARKFALLEN          = GetSpellInfo(71340) or "Pact of the Darkfallen";
HEALBOT_DEBUFF_ESSENCE_BLOOD_QUEEN      = GetSpellInfo(70867) or "Essence of the Blood Queen";
HEALBOT_DEBUFF_DELIRIOUS_SLASH          = GetSpellInfo(71624) or "Delirious Slash";
HEALBOT_DEBUFF_CORROSION                = GetSpellInfo(70751) or "Corrosion";
HEALBOT_DEBUFF_GUT_SPRAY                = GetSpellInfo(70633) or "Gut Spray";
HEALBOT_DEBUFF_ICE_TOMB                 = GetSpellInfo(70157) or "Ice Tomb";
HEALBOT_DEBUFF_FROST_BEACON             = GetSpellInfo(70126) or "Frost Beacon";
HEALBOT_DEBUFF_CHILLED_BONE             = GetSpellInfo(70106) or "Chilled to the Bone";
HEALBOT_DEBUFF_INSTABILITY              = GetSpellInfo(69766) or "Instabilty";
HEALBOT_DEBUFF_MYSTIC_BUFFET            = GetSpellInfo(70127) or "Mystic Buffet";
HEALBOT_DEBUFF_FROST_BREATH             = GetSpellInfo(69649) or "Frost Breath";
HEALBOT_DEBUFF_INFEST                   = GetSpellInfo(70541) or "Infest";
HEALBOT_DEBUFF_NECROTIC_PLAGUE          = GetSpellInfo(70338) or "Necrotic Plague";
HEALBOT_DEBUFF_DEFILE                   = GetSpellInfo(72754) or "Defile";
HEALBOT_DEBUFF_HARVEST_SOUL             = GetSpellInfo(68980) or "Harvest Soul";
HEALBOT_DEBUFF_FIERY_COMBUSTION         = GetSpellInfo(74562) or "Fiery Combustion";
HEALBOT_DEBUFF_COMBUSTION               = GetSpellInfo(75882) or "Combustion";
HEALBOT_DEBUFF_SOUL_CONSUMPTION         = GetSpellInfo(74792) or "Soul Consumption";
HEALBOT_DEBUFF_CONSUMPTION              = GetSpellInfo(75875) or "Consumption";
HEALBOT_DEBUFF_TOXIC_SPORES             = GetSpellInfo(86281) or "Toxic Spores";
HEALBOT_DEBUFF_LIGHTING_ROD             = GetSpellInfo(93294) or "Lightning Rod";
HEALBOT_DEBUFF_PARASITIC_INFECT         = GetSpellInfo(91913) or "Parasitic Infection"
HEALBOT_DEBUFF_CONSUMING_FLAMES         = GetSpellInfo(92973) or "Consuming Flames"
HEALBOT_DEBUFF_FLASH_FREEZE             = GetSpellInfo(92978) or "Flash Freeze"
HEALBOT_DEBUFF_EXPLOSIVE_CINDERS        = GetSpellInfo(79339) or "Explosive Cinders"
HEALBOT_DEBUFF_ENGULFING_MAGIC          = GetSpellInfo(95641) or "Engulfing Magic"
HEALBOT_DEBUFF_WATERLOGGED              = GetSpellInfo(82762) or "Waterlogged"
HEALBOT_DEBUFF_GRAVITY_CORE             = GetSpellInfo(92075) or "Gravity Core"
HEALBOT_DEBUFF_GRAVITY_CRUSH            = GetSpellInfo(92488) or "Gravity Crush"

HB_TOOLTIP_MANA                         = "^(%d+) Mana$";
HB_TOOLTIP_INSTANT_CAST                 = "Instant cast";
HB_TOOLTIP_CAST_TIME                    = "(%d+.?%d*) sec cast";
HB_TOOLTIP_CHANNELED                    = "Channeled";
HB_TOOLTIP_OFFLINE                      = "Offline";
HB_OFFLINE                              = "offline"; -- has gone offline msg
HB_ONLINE                               = "online"; -- has come online msg

-----------------
-- Translation --
-----------------

HEALBOT_ADDON                           = "HealBot " .. HEALBOT_VERSION;
HEALBOT_LOADED                          = " loaded.";

HEALBOT_ACTION_OPTIONS                  = "Options";

HEALBOT_OPTIONS_TITLE                   = HEALBOT_ADDON;
HEALBOT_OPTIONS_DEFAULTS                = "Defaults";
HEALBOT_OPTIONS_CLOSE                   = "Close";
HEALBOT_OPTIONS_HARDRESET               = "ReloadUI"
HEALBOT_OPTIONS_SOFTRESET               = "ResetHB"
HEALBOT_OPTIONS_INFO                    = "Info"
HEALBOT_OPTIONS_TAB_GENERAL             = "General";
HEALBOT_OPTIONS_TAB_SPELLS              = "Spells";
HEALBOT_OPTIONS_TAB_HEALING             = "Healing";
HEALBOT_OPTIONS_TAB_CDC                 = "Cure";
HEALBOT_OPTIONS_TAB_SKIN                = "Skins";
HEALBOT_OPTIONS_TAB_TIPS                = "Tips";
HEALBOT_OPTIONS_TAB_BUFFS               = "Buffs"

HEALBOT_OPTIONS_BARALPHA                = "Enabled opacity";
HEALBOT_OPTIONS_BARALPHAINHEAL          = "Incoming heals opacity";
HEALBOT_OPTIONS_BARALPHAEOR             = "Out of range opacity";
HEALBOT_OPTIONS_ACTIONLOCKED            = "Lock position";
HEALBOT_OPTIONS_AUTOSHOW                = "Close automatically";
HEALBOT_OPTIONS_PANELSOUNDS             = "Play sound on open";
HEALBOT_OPTIONS_HIDEOPTIONS             = "Hide options button";
HEALBOT_OPTIONS_PROTECTPVP              = "Avoid PvP";
HEALBOT_OPTIONS_HEAL_CHATOPT            = "Chat Options";

HEALBOT_OPTIONS_FRAMESCALE              = "Frame Scale"
HEALBOT_OPTIONS_SKINTEXT                = "Use skin"
HEALBOT_SKINS_STD                       = "Standard"
HEALBOT_OPTIONS_SKINTEXTURE             = "Texture"
HEALBOT_OPTIONS_SKINHEIGHT              = "Height"
HEALBOT_OPTIONS_SKINWIDTH               = "Width"
HEALBOT_OPTIONS_SKINNUMCOLS             = "No. columns"
HEALBOT_OPTIONS_SKINNUMHCOLS            = "No. groups per column"
HEALBOT_OPTIONS_SKINBRSPACE             = "Row spacer"
HEALBOT_OPTIONS_SKINBCSPACE             = "Col spacer"
HEALBOT_OPTIONS_EXTRASORT               = "Sort raid bars by"
HEALBOT_SORTBY_NAME                     = "Name"
HEALBOT_SORTBY_CLASS                    = "Class"
HEALBOT_SORTBY_GROUP                    = "Group"
HEALBOT_SORTBY_MAXHEALTH                = "Max health"
HEALBOT_OPTIONS_NEWDEBUFFTEXT           = "New debuff"
HEALBOT_OPTIONS_DELSKIN                 = "Delete"
HEALBOT_OPTIONS_NEWSKINTEXT             = "New skin"
HEALBOT_OPTIONS_SAVESKIN                = "Save"
HEALBOT_OPTIONS_SKINBARS                = "Bar options"
HEALBOT_SKIN_ENTEXT                     = "Enabled"
HEALBOT_SKIN_DISTEXT                    = "Disabled"
HEALBOT_SKIN_DISABLED                   = HEALBOT_SKIN_DISTEXT
HEALBOT_SKIN_DEBTEXT                    = "Debuff"
HEALBOT_SKIN_BACKTEXT                   = "Background"
HEALBOT_SKIN_BORDERTEXT                 = "Border"
HEALBOT_OPTIONS_SKINFONT                = "Font"
HEALBOT_OPTIONS_SKINFHEIGHT             = "Font Size"
HEALBOT_OPTIONS_SKINFOUTLINE            = "Font Outline"
HEALBOT_OPTIONS_BARALPHADIS             = "Disabled opacity"
HEALBOT_OPTIONS_SHOWHEADERS             = "Show headers"

HEALBOT_OPTIONS_ITEMS                   = "Items";

HEALBOT_OPTIONS_COMBOCLASS              = "Key combos for";
HEALBOT_OPTIONS_CLICK                   = "Click";
HEALBOT_OPTIONS_SHIFT                   = "Shift";
HEALBOT_OPTIONS_CTRL                    = "Ctrl";
HEALBOT_OPTIONS_ENABLEHEALTHY           = "Always use enabled";

HEALBOT_OPTIONS_CASTNOTIFY1             = "No messages";
HEALBOT_OPTIONS_CASTNOTIFY2             = "Notify self";
HEALBOT_OPTIONS_CASTNOTIFY3             = "Notify target";
HEALBOT_OPTIONS_CASTNOTIFY4             = "Notify party";
HEALBOT_OPTIONS_CASTNOTIFY5             = "Notify raid";
HEALBOT_OPTIONS_CASTNOTIFY6             = "Notify chan";
HEALBOT_OPTIONS_CASTNOTIFYRESONLY       = "Notify for resurrection only";

HEALBOT_OPTIONS_CDCBARS                 = "Bar colours";
HEALBOT_OPTIONS_CDCSHOWHBARS            = "Change health bar colour";
HEALBOT_OPTIONS_CDCSHOWABARS            = "Change aggro bar colour";
HEALBOT_OPTIONS_CDCWARNINGS             = "Debuff warnings";
HEALBOT_OPTIONS_SHOWDEBUFFICON          = "Show debuff";
HEALBOT_OPTIONS_SHOWDEBUFFWARNING       = "Display warning on debuff";
HEALBOT_OPTIONS_SOUNDDEBUFFWARNING      = "Play sound on debuff";
HEALBOT_OPTIONS_SOUND                   = "Sound"

HEALBOT_OPTIONS_HEAL_BUTTONS            = "Healing bars";
HEALBOT_OPTIONS_SELFHEALS               = "Self"
HEALBOT_OPTIONS_PETHEALS                = "Pets"
HEALBOT_OPTIONS_GROUPHEALS              = "Group";
HEALBOT_OPTIONS_TANKHEALS               = "Main tanks";
HEALBOT_OPTIONS_MAINASSIST              = "Main assist";
HEALBOT_OPTIONS_PRIVATETANKS            = "Private main tanks";
HEALBOT_OPTIONS_TARGETHEALS             = "Targets";
HEALBOT_OPTIONS_EMERGENCYHEALS          = "Raid";
HEALBOT_OPTIONS_ALERTLEVEL              = "Alert Level";
HEALBOT_OPTIONS_EMERGFILTER             = "Show raid bars for";
HEALBOT_OPTIONS_EMERGFCLASS             = "Configure classes for";
HEALBOT_OPTIONS_COMBOBUTTON             = "Button";
HEALBOT_OPTIONS_BUTTONLEFT              = "Left";
HEALBOT_OPTIONS_BUTTONMIDDLE            = "Middle";
HEALBOT_OPTIONS_BUTTONRIGHT             = "Right";
HEALBOT_OPTIONS_BUTTON4                 = "Button4";
HEALBOT_OPTIONS_BUTTON5                 = "Button5";
HEALBOT_OPTIONS_BUTTON6                 = "Button6";
HEALBOT_OPTIONS_BUTTON7                 = "Button7";
HEALBOT_OPTIONS_BUTTON8                 = "Button8";
HEALBOT_OPTIONS_BUTTON9                 = "Button9";
HEALBOT_OPTIONS_BUTTON10                = "Button10";
HEALBOT_OPTIONS_BUTTON11                = "Button11";
HEALBOT_OPTIONS_BUTTON12                = "Button12";
HEALBOT_OPTIONS_BUTTON13                = "Button13";
HEALBOT_OPTIONS_BUTTON14                = "Button14";
HEALBOT_OPTIONS_BUTTON15                = "Button15";


HEALBOT_CLASSES_ALL                     = "All classes";
HEALBOT_CLASSES_MELEE                   = "Melee";
HEALBOT_CLASSES_RANGES                  = "Ranged";
HEALBOT_CLASSES_HEALERS                 = "Healers";
HEALBOT_CLASSES_CUSTOM                  = "Custom";

HEALBOT_OPTIONS_SHOWTOOLTIP             = "Show tooltips";
HEALBOT_OPTIONS_SHOWDETTOOLTIP          = "Show detailed spell information";
HEALBOT_OPTIONS_SHOWCDTOOLTIP           = "Show spell cooldown";
HEALBOT_OPTIONS_SHOWUNITTOOLTIP         = "Show target information";
HEALBOT_OPTIONS_SHOWRECTOOLTIP          = "Show heal over time recommendation";
HEALBOT_TOOLTIP_POSDEFAULT              = "Default location";
HEALBOT_TOOLTIP_POSLEFT                 = "Left of Healbot";
HEALBOT_TOOLTIP_POSRIGHT                = "Right of Healbot";
HEALBOT_TOOLTIP_POSABOVE                = "Above Healbot";
HEALBOT_TOOLTIP_POSBELOW                = "Below Healbot";
HEALBOT_TOOLTIP_POSCURSOR               = "Next to Cursor";
HEALBOT_TOOLTIP_RECOMMENDTEXT           = "Heal over time Recommendation";
HEALBOT_TOOLTIP_NONE                    = "none available";
HEALBOT_TOOLTIP_CORPSE                  = "Corpse of ";
HEALBOT_TOOLTIP_CD                      = " (CD ";
HEALBOT_TOOLTIP_SECS                    = "s)";
HEALBOT_WORDS_SEC                       = "sec";
HEALBOT_WORDS_CAST                      = "Cast";
HEALBOT_WORDS_UNKNOWN                   = "Unknown";
HEALBOT_WORDS_YES                       = "Yes";
HEALBOT_WORDS_NO                        = "No";
HEALBOT_WORDS_THIN                      = "Thin";
HEALBOT_WORDS_THICK                     = "Thick";

HEALBOT_WORDS_NONE                      = "None";
HEALBOT_OPTIONS_ALT                     = "Alt";
HEALBOT_DISABLED_TARGET                 = "Target";
HEALBOT_OPTIONS_SHOWCLASSONBAR          = "Show class on bar";
HEALBOT_OPTIONS_SHOWHEALTHONBAR         = "Show health on bar";
HEALBOT_OPTIONS_BARHEALTHINCHEALS       = "Include incoming heals";
HEALBOT_OPTIONS_BARHEALTHSEPHEALS       = "Separate incoming heals";
HEALBOT_OPTIONS_BARHEALTH1              = "as delta";
HEALBOT_OPTIONS_BARHEALTH2              = "as percentage";
HEALBOT_OPTIONS_TIPTEXT                 = "Tooltip information";
HEALBOT_OPTIONS_POSTOOLTIP              = "Position tooltip";
HEALBOT_OPTIONS_SHOWNAMEONBAR           = "Show name on bar";
HEALBOT_OPTIONS_BARTEXTCLASSCOLOUR1     = "Colour text by class";
HEALBOT_OPTIONS_EMERGFILTERGROUPS       = "Include raid groups";

HEALBOT_ONE                             = "1";
HEALBOT_TWO                             = "2";
HEALBOT_THREE                           = "3";
HEALBOT_FOUR                            = "4";
HEALBOT_FIVE                            = "5";
HEALBOT_SIX                             = "6";
HEALBOT_SEVEN                           = "7";
HEALBOT_EIGHT                           = "8";

HEALBOT_OPTIONS_SETDEFAULTS             = "Set defaults";
HEALBOT_OPTIONS_SETDEFAULTSMSG          = "Reset all options to default values";
HEALBOT_OPTIONS_RIGHTBOPTIONS           = "Right click opens options";

HEALBOT_OPTIONS_HEADEROPTTEXT           = "Header options";
HEALBOT_OPTIONS_ICONOPTTEXT             = "Icon options";
HEALBOT_SKIN_HEADERBARCOL               = "Bar colour";
HEALBOT_SKIN_HEADERTEXTCOL              = "Text colour";
HEALBOT_OPTIONS_BUFFSTEXT1              = "Spell to buff";
HEALBOT_OPTIONS_BUFFSTEXT2              = "check members";
HEALBOT_OPTIONS_BUFFSTEXT3              = "bar colours";
HEALBOT_OPTIONS_BUFF                    = "Buff ";
HEALBOT_OPTIONS_BUFFSELF                = "on self";
HEALBOT_OPTIONS_BUFFPARTY               = "on party";
HEALBOT_OPTIONS_BUFFRAID                = "on raid";
HEALBOT_OPTIONS_MONITORBUFFS            = "Monitor for missing buffs";
HEALBOT_OPTIONS_MONITORBUFFSC           = "also in combat";
HEALBOT_OPTIONS_ENABLESMARTCAST         = "SmartCast out of combat";
HEALBOT_OPTIONS_SMARTCASTSPELLS         = "Include spells";
HEALBOT_OPTIONS_SMARTCASTDISPELL        = "Remove debuffs";
HEALBOT_OPTIONS_SMARTCASTBUFF           = "Add buffs";
HEALBOT_OPTIONS_SMARTCASTHEAL           = "Healing spells";
HEALBOT_OPTIONS_BAR2SIZE                = "Power bar size";
HEALBOT_OPTIONS_SETSPELLS               = "Set spells for";
HEALBOT_OPTIONS_ENABLEDBARS             = "Enabled bars at all times";
HEALBOT_OPTIONS_DISABLEDBARS            = "Disabled bars when out of combat";
HEALBOT_OPTIONS_MONITORDEBUFFS          = "Monitor to remove debuffs";
HEALBOT_OPTIONS_DEBUFFTEXT1             = "Spell to remove debuffs";

HEALBOT_OPTIONS_IGNOREDEBUFF            = "Ignore debuffs:";
HEALBOT_OPTIONS_IGNOREDEBUFFCLASS       = "By class";
HEALBOT_OPTIONS_IGNOREDEBUFFMOVEMENT    = "Slow movement";
HEALBOT_OPTIONS_IGNOREDEBUFFDURATION    = "Short duration";
HEALBOT_OPTIONS_IGNOREDEBUFFNOHARM      = "Non harmful";

HEALBOT_OPTIONS_RANGECHECKFREQ          = "Range, Aura and Aggro check frequency";

HEALBOT_OPTIONS_HIDEPARTYFRAMES         = "Hide party frames";
HEALBOT_OPTIONS_HIDEPLAYERTARGET        = "Include player and target";
HEALBOT_OPTIONS_DISABLEHEALBOT          = "Disable HealBot";

HEALBOT_OPTIONS_CHECKEDTARGET           = "Checked";

HEALBOT_ASSIST                          = "Assist";
HEALBOT_FOCUS                           = "Focus";
HEALBOT_MENU                            = "Menu";
HEALBOT_MAINTANK                        = "MainTank";
HEALBOT_MAINASSIST                      = "MainAssist";
HEALBOT_STOP                            = "Stop";
HEALBOT_TELL                            = "Tell";

HEALBOT_TITAN_SMARTCAST                 = "SmartCast";
HEALBOT_TITAN_MONITORBUFFS              = "Monitor buffs";
HEALBOT_TITAN_MONITORDEBUFFS            = "Monitor debuffs"
HEALBOT_TITAN_SHOWBARS                  = "Show bars for";
HEALBOT_TITAN_EXTRABARS                 = "Extra bars";
HEALBOT_BUTTON_TOOLTIP                  = "Left click to toggle HealBot options panel\nRight click (hold) to move this icon";
HEALBOT_TITAN_TOOLTIP                   = "Left click to toggle HealBot options panel";
HEALBOT_OPTIONS_SHOWMINIMAPBUTTON       = "Show minimap button";
HEALBOT_OPTIONS_BARBUTTONSHOWHOT        = "Show HoT";
HEALBOT_OPTIONS_BARBUTTONSHOWRAIDICON   = "Show Raid Target";
HEALBOT_OPTIONS_HOTONBAR                = "On bar";
HEALBOT_OPTIONS_HOTOFFBAR               = "Off bar";
HEALBOT_OPTIONS_HOTBARRIGHT             = "Right side";
HEALBOT_OPTIONS_HOTBARLEFT              = "Left side";

HEALBOT_ZONE_AB                         = "Arathi Basin";
HEALBOT_ZONE_AV                         = "Alterac Valley";
HEALBOT_ZONE_ES                         = "Eye of the Storm";
HEALBOT_ZONE_IC                         = "Isle of Conquest";
HEALBOT_ZONE_SA                         = "Strand of the Ancients";
HEALBOT_ZONE_WG                         = "Warsong Gulch";

HEALBOT_OPTION_AGGROTRACK               = "Monitor Aggro"
HEALBOT_OPTION_AGGROBAR                 = "Bar"
HEALBOT_OPTION_AGGROTXT                 = ">> Text <<"
HEALBOT_OPTION_AGGROIND                 = "Indicator"
HEALBOT_OPTION_BARUPDFREQ               = "Refresh Multiplier"
HEALBOT_OPTION_USEFLUIDBARS             = "Use fluid bars"
HEALBOT_OPTION_CPUPROFILE               = "Use CPU profiler (Addons CPU usage Info)"
HEALBOT_OPTIONS_RELOADUIMSG             = "This option requires a UI Reload, Reload now?"

HEALBOT_BUFF_PVP                        = "PvP"
HEALBOT_BUFF_PVE						= "PvE"
HEALBOT_OPTIONS_ANCHOR                  = "Frame anchor"
HEALBOT_OPTIONS_BARSANCHOR              = "Bars anchor"
HEALBOT_OPTIONS_TOPLEFT                 = "Top Left"
HEALBOT_OPTIONS_BOTTOMLEFT              = "Bottom Left"
HEALBOT_OPTIONS_TOPRIGHT                = "Top Right"
HEALBOT_OPTIONS_BOTTOMRIGHT             = "Bottom Right"
HEALBOT_OPTIONS_TOP                     = "Top"
HEALBOT_OPTIONS_BOTTOM                  = "Bottom"

HEALBOT_PANEL_BLACKLIST                 = "BlackList"

HEALBOT_WORDS_REMOVEFROM                = "Remove from";
HEALBOT_WORDS_ADDTO                     = "Add to";
HEALBOT_WORDS_INCLUDE                   = "Include";

HEALBOT_OPTIONS_TTALPHA                 = "Opacity"
HEALBOT_TOOLTIP_TARGETBAR               = "Target Bar"
HEALBOT_OPTIONS_MYTARGET                = "My Targets"

HEALBOT_DISCONNECTED_TEXT               = "<DC>"
HEALBOT_OPTIONS_SHOWUNITBUFFTIME        = "Show my buffs";
HEALBOT_OPTIONS_TOOLTIPUPDATE           = "Constantly update";
HEALBOT_OPTIONS_BUFFSTEXTTIMER          = "Show buff before it expires";
HEALBOT_OPTIONS_SHORTBUFFTIMER          = "Short buffs"
HEALBOT_OPTIONS_LONGBUFFTIMER           = "Long buffs"

HEALBOT_BALANCE                         = "Balance"
HEALBOT_FERAL                           = "Feral"
HEALBOT_RESTORATION                     = "Restoration"
HEALBOT_SHAMAN_RESTORATION              = "Restoration"
HEALBOT_ARCANE                          = "Arcane"
HEALBOT_FIRE                            = "Fire"
HEALBOT_FROST                           = "Frost"
HEALBOT_DISCIPLINE                      = "Discipline"
HEALBOT_HOLY                            = "Holy"
HEALBOT_SHADOW                          = "Shadow"
HEALBOT_ASSASSINATION                   = "Assassination"
HEALBOT_COMBAT                          = "Combat"
HEALBOT_SUBTLETY                        = "Subtlety"
HEALBOT_ARMS                            = "Arms"
HEALBOT_FURY                            = "Fury"
HEALBOT_PROTECTION                      = "Protection"
HEALBOT_BEASTMASTERY                    = "Beast Mastery"
HEALBOT_MARKSMANSHIP                    = "Marksmanship"
HEALBOT_SURVIVAL                        = "Survival"
HEALBOT_RETRIBUTION                     = "Retribution"
HEALBOT_ELEMENTAL                       = "Elemental"
HEALBOT_ENHANCEMENT                     = "Enhancement"
HEALBOT_AFFLICTION                      = "Affliction"
HEALBOT_DEMONOLOGY                      = "Demonology"
HEALBOT_DESTRUCTION                     = "Destruction"
HEALBOT_BLOOD                           = "Blood"
HEALBOT_UNHOLY                          = "Unholy"

HEALBOT_OPTIONS_NOTIFY_HEAL_MSG         = "Heal Message"
HEALBOT_OPTIONS_NOTIFY_MSG              = "Message"
HEALBOT_WORDS_YOU                       = "you";
HEALBOT_NOTIFYOTHERMSG                  = "Casting #s on #n";

HEALBOT_OPTIONS_HOTPOSITION             = "Icon position"
HEALBOT_OPTIONS_HOTSHOWTEXT             = "Show icon text"
HEALBOT_OPTIONS_HOTTEXTCOUNT            = "Count"
HEALBOT_OPTIONS_HOTTEXTDURATION         = "Duration"
HEALBOT_OPTIONS_ICONSCALE               = "Icon Scale"
HEALBOT_OPTIONS_ICONTEXTSCALE           = "Icon Text Scale"

HEALBOT_SKIN_FLUID                      = "Fluid"
HEALBOT_SKIN_VIVID                      = "Vivid"
HEALBOT_SKIN_LIGHT                      = "Light"
HEALBOT_SKIN_SQUARE                     = "Square"
HEALBOT_OPTIONS_AGGROBARSIZE            = "Aggro bar size"
HEALBOT_OPTIONS_DOUBLETEXTLINES         = "Double text lines"
HEALBOT_OPTIONS_TEXTALIGNMENT           = "Text Alignment"
HEALBOT_VEHICLE                         = "Vehicle"
HEALBOT_OPTIONS_UNIQUESPEC              = "Save unique spells for each spec"
HEALBOT_WORDS_ERROR                     = "Error"
HEALBOT_SPELL_NOT_FOUND	                = "Spell Not Found"
HEALBOT_OPTIONS_DISABLETOOLTIPINCOMBAT  = "Hide Tooltip in Combat"
HEALBOT_OPTIONS_ENABLELIBQH             = "Enable HealBot fastHealth"

HEALBOT_OPTIONS_BUFFNAMED               = "Enter the player names to watch for\n\n"
HEALBOT_WORD_ALWAYS                     = "Always";
HEALBOT_WORD_SOLO                       = "Solo";
HEALBOT_WORD_NEVER                      = "Never";
HEALBOT_SHOW_CLASS_AS_ICON              = "as icon";
HEALBOT_SHOW_CLASS_AS_TEXT              = "as text";

HEALBOT_SHOW_INCHEALS                   = "Show incoming heals";
HEALBOT_D_DURATION                      = "Direct duration";
HEALBOT_H_DURATION                      = "HoT Duration";
HEALBOT_C_DURATION                      = "Channelled Duration";

HEALBOT_HELP={ [1] = "[HealBot] /hb h -- Display help",
               [2] = "[HealBot] /hb o -- Toggles options",
               [3] = "[HealBot] /hb ri -- Reset HealBot",
               [4] = "[HealBot] /hb t -- Toggle Healbot between disabled and enabled",
               [5] = "[HealBot] /hb bt -- Toggle Buff Monitor between disabled and enabled",
               [6] = "[HealBot] /hb dt -- Toggle Debuff Monitor between disabled and enabled",
               [7] = "[HealBot] /hb skin <skinName> -- Switch Skins",
               [8] = "[HealBot] /hb ui -- Reload UI",
               [9] = "[HealBot] /hb hs -- Display additional slash commands",
              }

HEALBOT_HELP2={ [1] = "[HealBot] /hb d -- Reset options to default",
                [2] = "[HealBot] /hb aggro 2 <n> -- Set aggro level 2 on threat percentage <n>",
                [3] = "[HealBot] /hb aggro 3 <n> -- Set aggro level 3 on threat percentage <n>",
                [4] = "[HealBot] /hb tr <Role> -- Set highest role priority for SubSort by Role. Valid Roles are 'TANK', 'HEALER' or 'DPS'",
                [5] = "[HealBot] /hb use10 -- Automatically use Engineering slot 10",
                [6] = "[HealBot] /hb pcs <n> -- Adjust the size of the Holy power charge indicator by <n>, Default value is 7 ",
                [7] = "[HealBot] /hb info -- Show the info window",
                [8] = "[HealBot] /hb spt -- Self Pet toggle",
                [9] = "[HealBot] /hb ws -- Toggle Hide/Show the Weaken Soul icon instead of the PW:S with a -",
               [10] = "[HealBot] /hb rld <n> -- In seconds, how long the players name stays green after a res",
               [11] = "[HealBot] /hb flb -- Toggle frame lock bypass (frame always moves with Ctrl+Alt+Left click)",
               [12] = "[HealBot] /hb rtb -- Toggle restrict target bar to Left=SmartCast and Right=add/remove to/from My Targets",
              }
              
HEALBOT_OPTION_HIGHLIGHTACTIVEBAR       = "Highlight mouseover"
HEALBOT_OPTION_HIGHLIGHTTARGETBAR       = "Highlight target"
HEALBOT_OPTIONS_TESTBARS                = "Test Bars"
HEALBOT_OPTION_NUMBARS                  = "Number of Bars"
HEALBOT_OPTION_NUMTANKS                 = "Number of Tanks"
HEALBOT_OPTION_NUMMYTARGETS             = "Number of MyTargets"
HEALBOT_OPTION_NUMPETS                  = "Number of Pets"
HEALBOT_WORD_TEST                       = "Test";
HEALBOT_WORD_OFF                        = "Off";
HEALBOT_WORD_ON                         = "On";

HEALBOT_OPTIONS_TAB_PROTECTION          = "Protection"
HEALBOT_OPTIONS_TAB_CHAT                = "Chat"
HEALBOT_OPTIONS_TAB_HEADERS             = "Headers"
HEALBOT_OPTIONS_TAB_BARS                = "Bars"
HEALBOT_OPTIONS_TAB_ICONS               = "Icons"
HEALBOT_OPTIONS_TAB_WARNING             = "Warning"
HEALBOT_OPTIONS_SKINDEFAULTFOR          = "Skin default for"
HEALBOT_OPTIONS_INCHEAL                 = "Incoming heals"
HEALBOT_WORD_ARENA                      = "Arena"
HEALBOT_WORD_BATTLEGROUND               = "Battle Ground"
HEALBOT_OPTIONS_TEXTOPTIONS             = "Text Options"
HEALBOT_WORD_PARTY                      = "Party"
HEALBOT_OPTIONS_COMBOAUTOTARGET         = "Auto Target"
HEALBOT_OPTIONS_COMBOAUTOTRINKET        = "Auto Trinket"
HEALBOT_OPTIONS_GROUPSPERCOLUMN         = "Use Groups per Column"

HEALBOT_OPTIONS_MAINSORT                = "Main sort"
HEALBOT_OPTIONS_SUBSORT                 = "Sub sort"
HEALBOT_OPTIONS_SUBSORTINC              = "Also sub sort:"

HEALBOT_OPTIONS_BUTTONCASTMETHOD        = "cast when"
HEALBOT_OPTIONS_BUTTONCASTPRESSED       = "Pressed"
HEALBOT_OPTIONS_BUTTONCASTRELEASED      = "Released"

HEALBOT_INFO_INCHEALINFO                = "== Healbot Version Information =="
HEALBOT_INFO_ADDONCPUUSAGE              = "== Addon CPU Usage in Seconds =="
HEALBOT_INFO_ADDONCOMMUSAGE             = "== Addon Comms Usage =="
HEALBOT_WORD_HEALER                     = "Healer"
HEALBOT_WORD_VERSION                    = "Version"
HEALBOT_WORD_CLIENT                     = "Client"
HEALBOT_WORD_ADDON                      = "Addon"
HEALBOT_INFO_CPUSECS                    = "CPU Secs"
HEALBOT_INFO_MEMORYKB                   = "Memory KB"
HEALBOT_INFO_COMMS                      = "Comms KB"

HEALBOT_WORD_STAR                       = "Star"
HEALBOT_WORD_CIRCLE                     = "Circle"
HEALBOT_WORD_DIAMOND                    = "Diamond"
HEALBOT_WORD_TRIANGLE                   = "Triangle"
HEALBOT_WORD_MOON                       = "Moon"
HEALBOT_WORD_SQUARE                     = "Square"
HEALBOT_WORD_CROSS                      = "Cross"
HEALBOT_WORD_SKULL                      = "Skull"

HEALBOT_OPTIONS_ACCEPTSKINMSG           = "Accept [HealBot] Skin: "
HEALBOT_OPTIONS_ACCEPTSKINMSGFROM       = " from "
HEALBOT_OPTIONS_BUTTONSHARESKIN         = "Share with"

HEALBOT_CHAT_ADDONID                    = "[HealBot]  "
HEALBOT_CHAT_NEWVERSION1                = "A newer version is available"
HEALBOT_CHAT_NEWVERSION2                = "at http://www.healbot.info"
HEALBOT_CHAT_SHARESKINERR1              = " Skin not found for Sharing"
HEALBOT_CHAT_SHARESKINERR3              = " not found for Skin Sharing"
HEALBOT_CHAT_SHARESKINACPT              = "Share Skin accepted from "
HEALBOT_CHAT_CONFIRMSKINDEFAULTS        = "Skins set to Defaults"
HEALBOT_CHAT_CONFIRMCUSTOMDEFAULTS      = "Custom Debuffs reset"
HEALBOT_CHAT_CHANGESKINERR1             = "Unknown skin: /hb skin "
HEALBOT_CHAT_CHANGESKINERR2             = "Valid skins:  "
HEALBOT_CHAT_CONFIRMSPELLCOPY           = "Current spells copied for all specs"
HEALBOT_CHAT_UNKNOWNCMD                 = "Unknown slash command: /hb "
HEALBOT_CHAT_ENABLED                    = "Entering enabled state"
HEALBOT_CHAT_DISABLED                   = "Entering disabled state"
HEALBOT_CHAT_SOFTRELOAD                 = "Reload healbot requested"
HEALBOT_CHAT_HARDRELOAD                 = "Reload UI requested"
HEALBOT_CHAT_CONFIRMSPELLRESET          = "Spells have been reset"
HEALBOT_CHAT_CONFIRMCURESRESET          = "Cures have been reset"
HEALBOT_CHAT_CONFIRMBUFFSRESET          = "Buffs have been reset"
HEALBOT_CHAT_POSSIBLEMISSINGMEDIA       = "Unable to receive all Skin settings - Possibly missing SharedMedia, see HealBot/Docs/readme.html for links"
HEALBOT_CHAT_MACROSOUNDON               = "Sound not suppressed when using auto trinkets"
HEALBOT_CHAT_MACROSOUNDOFF              = "Sound suppressed when using auto trinkets"
HEALBOT_CHAT_MACROERRORON               = "Errors not suppressed when using auto trinkets"
HEALBOT_CHAT_MACROERROROFF              = "Errors suppressed when using auto trinkets"
HEALBOT_CHAT_ACCEPTSKINON               = "Share Skin - Show accept skin popup when someone shares a skin with you"
HEALBOT_CHAT_ACCEPTSKINOFF              = "Share Skin - Always ignore share skins from everyone"
HEALBOT_CHAT_USE10ON                    = "Auto Trinket - Use10 is on - You must enable an existing auto trinket for use10 to work"
HEALBOT_CHAT_USE10OFF                   = "Auto Trinket - Use10 is off"
HEALBOT_CHAT_SKINREC                    = " skin received from " 

HEALBOT_OPTIONS_SELFCASTS               = "Self casts only"
HEALBOT_OPTIONS_HOTSHOWICON             = "Show icon"
HEALBOT_OPTIONS_ALLSPELLS               = "All spells"
HEALBOT_OPTIONS_DOUBLEROW               = "Double row"
HEALBOT_OPTIONS_HOTBELOWBAR             = "Below bar"
HEALBOT_OPTIONS_OTHERSPELLS             = "Other spells"
HEALBOT_WORD_MACROS                     = "Macros"
HEALBOT_WORD_SELECT                     = "Select"
HEALBOT_OPTIONS_QUESTION                = "?"
HEALBOT_WORD_CANCEL                     = "Cancel"
HEALBOT_WORD_COMMANDS                   = "Commands"
HEALBOT_OPTIONS_BARHEALTH3              = "as health";
HEALBOT_SORTBY_ROLE                     = "Role"
HEALBOT_WORD_DPS                        = "DPS"
HEALBOT_CHAT_TOPROLEERR                 = " role not valid in this context - use 'TANK', 'DPS' or 'HEALER'"
HEALBOT_CHAT_NEWTOPROLE                 = "Highest top role is now "
HEALBOT_CHAT_SUBSORTPLAYER1             = "Player will be set to first in SubSort"
HEALBOT_CHAT_SUBSORTPLAYER2             = "Player will be sorted normally in SubSort"
HEALBOT_OPTIONS_SHOWREADYCHECK          = "Show Ready Check";
HEALBOT_OPTIONS_SUBSORTSELFFIRST        = "Self First"
HEALBOT_WORD_FILTER                     = "Filter"
HEALBOT_OPTION_AGGROPCTBAR              = "Move bar"
HEALBOT_OPTION_AGGROPCTTXT              = "Show text"
HEALBOT_OPTION_AGGROPCTTRACK            = "Track percentage" 
HEALBOT_OPTIONS_ALERTAGGROLEVEL1        = "1 - Low threat"
HEALBOT_OPTIONS_ALERTAGGROLEVEL2        = "2 - High threat"
HEALBOT_OPTIONS_ALERTAGGROLEVEL3        = "3 - Tanking"
HEALBOT_OPTIONS_AGGROALERT              = "Bar alert level"
HEALBOT_OPTIONS_AGGROINDALERT           = "Indicator alert level"
HEALBOT_OPTIONS_TOOLTIPSHOWHOT          = "Show active monitored HoT details"
HEALBOT_WORDS_MIN                       = "min"
HEALBOT_WORDS_MAX                       = "max"
HEALBOT_WORDS_R                         = "R"
HEALBOT_WORDS_G                         = "G"
HEALBOT_WORDS_B                         = "B"
HEALBOT_CHAT_SELFPETSON                 = "Self Pet switched on"
HEALBOT_CHAT_SELFPETSOFF                = "Self Pet switched off"
HEALBOT_WORD_PRIORITY                   = "Priority"
HEALBOT_VISIBLE_RANGE                   = "Within 100 yards"
HEALBOT_SPELL_RANGE                     = "Within spell range"
HEALBOT_CUSTOM_CATEGORY                 = "Category"
HEALBOT_CUSTOM_CAT_CUSTOM               = "Custom"
HEALBOT_CUSTOM_CAT_CLASSIC              = "Classic"
HEALBOT_CUSTOM_CAT_TBC_OTHER            = "TBC - Other"
HEALBOT_CUSTOM_CAT_TBC_BT               = "TBC - Black Temple"
HEALBOT_CUSTOM_CAT_TBC_SUNWELL          = "TBC - Sunwell"
HEALBOT_CUSTOM_CAT_LK_OTHER             = "WotLK - Other"
HEALBOT_CUSTOM_CAT_LK_ULDUAR            = "WotLK - Ulduar"
HEALBOT_CUSTOM_CAT_LK_TOC               = "WotLK - Trial of the Crusader"
HEALBOT_CUSTOM_CAT_LK_ICC_LOWER         = "WotLK - ICC Lower Spire"
HEALBOT_CUSTOM_CAT_LK_ICC_PLAGUEWORKS   = "WotLK - ICC The Plagueworks"
HEALBOT_CUSTOM_CAT_LK_ICC_CRIMSON       = "WotLK - ICC The Crimson Hall"
HEALBOT_CUSTOM_CAT_LK_ICC_FROSTWING     = "WotLK - ICC Frostwing Halls"
HEALBOT_CUSTOM_CAT_LK_ICC_THRONE        = "WotLK - ICC The Frozen Throne"
HEALBOT_CUSTOM_CAT_LK_RS_THRONE         = "WotLK - Ruby Sanctum"
HEALBOT_CUSTOM_CAT_CATA_OTHER           = "Cata - Other"
HEALBOT_CUSTOM_CAT_CATA_PARTY           = "Cata - Party"
HEALBOT_CUSTOM_CAT_CATA_RAID            = "Cata - Raid"
HEALBOT_WORD_RESET                      = "Reset"
HEALBOT_HBMENU                          = "HBmenu"
HEALBOT_ACTION_HBFOCUS                  = "Left click to set\nfocus on target"
HEALBOT_WORD_CLEAR                      = "Clear"
HEALBOT_WORD_SET                        = "Set"
HEALBOT_WORD_HBFOCUS                    = "HealBot Focus"
HEALBOT_WORD_OUTSIDE                    = "Outside"
HEALBOT_WORD_ALLZONE                    = "All zones"
HEALBOT_WORD_OTHER                      = "Other"
HEALBOT_OPTIONS_TAB_ALERT               = "Alert"
HEALBOT_OPTIONS_TAB_SORT                = "Sort"
HEALBOT_OPTIONS_TAB_HIDE                = "Hide"
HEALBOT_OPTIONS_TAB_AGGRO               = "Aggro"
HEALBOT_OPTIONS_TAB_ICONTEXT            = "Icon text"
HEALBOT_OPTIONS_TAB_TEXT                = "Bar text"
HEALBOT_OPTIONS_AGGRO3COL               = "Aggro bar\ncolour"
HEALBOT_OPTIONS_AGGROFLASHFREQ          = "Flash frequency"
HEALBOT_OPTIONS_AGGROFLASHALPHA         = "Flash opacity"
HEALBOT_OPTIONS_SHOWDURATIONFROM        = "Show duration from"
HEALBOT_OPTIONS_SHOWDURATIONWARN        = "Duration warning from"
HEALBOT_CMD_RESETCUSTOMDEBUFFS          = "Reset custom debuffs"
HEALBOT_CMD_RESETSKINS                  = "Reset skins"
HEALBOT_CMD_CLEARBLACKLIST              = "Clear BlackList"
HEALBOT_CMD_TOGGLEACCEPTSKINS           = "Toggle accept Skins from others"
HEALBOT_CMD_COPYSPELLS                  = "Copy current spells to all specs"
HEALBOT_CMD_RESETSPELLS                 = "Reset spells"
HEALBOT_CMD_RESETCURES                  = "Reset cures"
HEALBOT_CMD_RESETBUFFS                  = "Reset buffs"
HEALBOT_CMD_RESETBARS                   = "Reset bar position"
HEALBOT_CMD_SUPPRESSSOUND               = "Toggle suppress sound when using auto trinkets"
HEALBOT_CMD_SUPPRESSERRORS              = "Toggle suppress errors when using auto trinkets"
HEALBOT_OPTIONS_COMMANDS                = "HealBot Commands"
HEALBOT_WORD_RUN                        = "Run"
HEALBOT_OPTIONS_MOUSEWHEEL              = "Use mouse wheel"
HEALBOT_OPTIONS_MOUSEUP                 = "Wheel up"
HEALBOT_OPTIONS_MOUSEDOWN               = "Wheel down"
HEALBOT_CMD_DELCUSTOMDEBUFF10           = "Delete custom debuffs on priority 10"
HEALBOT_ACCEPTSKINS                     = "Accept Skins from others"
HEALBOT_SUPPRESSSOUND                   = "Auto Trinket: Suppress sound"
HEALBOT_SUPPRESSERROR                   = "Auto Trinket: Suppress errors"
HEALBOT_OPTIONS_CRASHPROT               = "Crash Protection"
HEALBOT_CP_MACRO_LEN                    = "Macro name must be between 1 and 14 characters"
HEALBOT_CP_MACRO_BASE                   = "Base macro name"
HEALBOT_CP_MACRO_SAVE                   = "Last saved at: "
HEALBOT_CP_STARTTIME                    = "Protect duration on logon"
HEALBOT_WORD_RESERVED                   = "Reserved"
HEALBOT_OPTIONS_COMBATPROT              = "Combat Protection"
HEALBOT_COMBATPROT_PARTYNO              = "bars Reserved for Party"
HEALBOT_COMBATPROT_RAIDNO               = "bars Reserved for Raid"

HEALBOT_WORD_HEALTH                     = "Health"
HEALBOT_OPTIONS_DONT_SHOW               = "Don't show"
HEALBOT_OPTIONS_SAME_AS_HLTH_CURRENT    = "Same as health (current health)"
HEALBOT_OPTIONS_SAME_AS_HLTH_FUTURE     = "Same as health (future health)"
HEALBOT_OPTIONS_FUTURE_HLTH             = "Future health"
HEALBOT_SKIN_HEALTHBARCOL_TEXT          = "Health bar colour";
HEALBOT_SKIN_INCHEALBARCOL_TEXT         = "Incoming heals colour";
HEALBOT_OPTIONS_ALWAYS_SHOW_TARGET      = "Target: Always show"
HEALBOT_OPTIONS_ALWAYS_SHOW_FOCUS       = "Focus: Always show"
HEALBOT_OPTIONS_GROUP_PETS_BY_FIVE      = "Pets: Groups of five"
HEALBOT_OPTIONS_USEGAMETOOLTIP          = "Use Game Tooltip"
HEALBOT_OPTIONS_SHOWPOWERCOUNTER        = "Show power counter"
HEALBOT_OPTIONS_SHOWPOWERCOUNTER_PALA   = "Show holy power"
HEALBOT_OPTIONS_CUSTOMDEBUFF_REVDUR     = "Reverse Duration"
HEALBOT_OPTIONS_DISABLEHEALBOTSOLO      = "only when solo"

HEALBOT_BLIZZARD_MENU                   = "Blizzard menu"
HEALBOT_HB_MENU                         = "Healbot menu"
HEALBOT_FOLLOW                          = "Follow"
HEALBOT_TRADE                           = "Trade"
HEALBOT_PROMOTE_RA                      = "Promote raid assistant"
HEALBOT_DEMOTE_RA                       = "Demote raid assistant"
HEALBOT_TOGGLE_ENABLED                  = "Toggle enabled"
HEALBOT_TOGGLE_MYTARGETS                = "Toggle My Targets"
HEALBOT_TOGGLE_PRIVATETANKS             = "Toggle private tanks"
HEALBOT_RESET_BAR                       = "Reset bar"
HEALBOT_HIDE_BARS                       = "Hide bars over 100 yards"
HEALBOT_RANDOMMOUNT                     = "Random Mount"
HEALBOT_RANDOMGOUNDMOUNT                = "Random Ground Mount"
HEALBOT_RANDOMPET                       = "Random Pet"
HEALBOT_ZONE_AQ40                       = "Ahn'Qiraj"
HEALBOT_ZONE_THEOCULUS                  = "The Oculus"
HEALBOT_ZONE_VASHJIR1                   = "Kelp'thar Forest"
HEALBOT_ZONE_VASHJIR2                   = "Shimmering Expanse"
HEALBOT_ZONE_VASHJIR3                   = "Abyssal Depths"
HEALBOT_ZONE_VASHJIR                    = "Vashj'ir"
HEALBOT_RESLAG_INDICATOR                = "Keep name green after res set to" 
HEALBOT_RESLAG_INDICATOR_ERROR          = "Keep name green after res must be between 1 and 30" 
HEALBOT_FRAMELOCK_BYPASS_OFF            = "Frame lock bypass turned Off"
HEALBOT_FRAMELOCK_BYPASS_ON             = "Frame lock bypass (Ctl+Alt+Left) turned On"
HEALBOT_RESTRICTTARGETBAR_ON            = "Restrict Target bar turned On"
HEALBOT_RESTRICTTARGETBAR_OFF           = "Restrict Target bar turned Off"
HEALBOT_PRELOADOPTIONS_ON               = "PreLoad Options turned On"
HEALBOT_PRELOADOPTIONS_OFF              = "PreLoad Options turned Off"
HEALBOT_AGGRO2_ERROR_MSG                = "To set aggro level 2, threat percentage must be between 25 and 95"
HEALBOT_AGGRO3_ERROR_MSG                = "To set aggro level 3, threat percentage must be between 75 and 100"
HEALBOT_AGGRO2_SET_MSG                  = "Aggro level 2 set at threat percentage "
HEALBOT_AGGRO3_SET_MSG                  = "Aggro level 3 set at threat percentage "
HEALBOT_WORD_THREAT                     = "Threat"
HEALBOT_AGGRO_ERROR_MSG                 = "Invalid aggro level - use 2 or 3"

HEALBOT_OPTIONS_QUERYTALENTS            = "Query talent data"       
HEALBOT_OPTIONS_LOWMANAINDICATOR        = "Low Mana indicator"
HEALBOT_OPTIONS_LOWMANAINDICATOR1       = "Don't show"
HEALBOT_OPTIONS_LOWMANAINDICATOR2       = "*10% / **20% / ***30%"
HEALBOT_OPTIONS_LOWMANAINDICATOR3       = "*15% / **30% / ***45%"
HEALBOT_OPTIONS_LOWMANAINDICATOR4       = "*20% / **40% / ***60%"
HEALBOT_OPTIONS_LOWMANAINDICATOR5       = "*25% / **50% / ***75%"
HEALBOT_OPTIONS_LOWMANAINDICATOR6       = "*30% / **60% / ***90%"

HEALBOT_OPTION_IGNORE_AURA_RESTED       = "Ignore aura events when resting"

HEALBOT_WORD_ENABLE                     = "Enable"
HEALBOT_WORD_DISABLE                    = "Disable"