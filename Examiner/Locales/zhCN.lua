--by 月色狼影

if GetLocale() == "zhCN" then
--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

BINDING_HEADER_EXAMINER = "Examiner";
BINDING_NAME_EXAMINER_OPEN = "打开Examiner";
BINDING_NAME_EXAMINER_TARGET = "查看目标";
BINDING_NAME_EXAMINER_MOUSEOVER = "查看鼠标目标";

Examiner.StatEntryOrder = {
	--力量, 敏捷, 耐力, 智力, 精神, 护甲, 物理免伤
	{ name = PLAYERSTAT_BASE_STATS, stats = {"STR", "AGI", "STA", "INT", "SPI", "ARMOR"} },
	{ name = HEALTH.." & "..MANA, stats = {"HP", "MP", "HP5", "MP5"} },
	{ name = "基础等级", stats = {"CRIT", "HIT", "SPELLHIT", "HASTE"} },
	{ name = "法术", stats = {"HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT", "SPELLHIT", "SPELLHASTE", "SPELLPENETRATION"} },
	{ name = "近战 & 远程", stats = {"AP", "RAP", "APFERAL", "CRIT", "HIT", "HASTE", "WPNDMG", "RANGEDDMG", "ARMORPENETRATION", "ARMORPENETRATIONRATING", "EXPERTISE"} },
	{ name = PLAYERSTAT_DEFENSES, stats = {"DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "RESILIENCE"} },
};

ExScanner.SetBonusTokenActive = "^套装：";
ExScanner.ItemUseToken = "^使用：";

--------------------------------------------------------------------------------------------------------
--                                           Stat Patterns                                            --
--------------------------------------------------------------------------------------------------------

ExScanner.Patterns = {
	--  Base Stats  --
	{ p = "%+(%d+) 力量", s = "STR" },
	{ p = "%+(%d+) 敏捷", s = "AGI" },
	{ p = "%+(%d+) 耐力", s = "STA" },
	{ p = "耐力 %+(%d+)", s = "STA" }, -- WORKAROUND: Infused Amethyst (31116)
	{ p = "%+(%d+) 智力", s = "INT" },
	{ p = "%+(%d+) 精神", s = "SPI" },
	{ p = "(%d+) 护甲", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits
	{ p = "%+(%d+) 护甲", s = "ARMOR" }, -- Should catch all armor: Base armor, Armor enchants, Armor kits
	{ p = "(%d+)点护甲", s = "ARMOR" },
	{ p = "%+(%d+)所有属性", s = {"STR", "AGI", "STA", "INT", "SPI"}},

	--  Resistances (Exclude the Resist-"ance" then it picks up armor patches as well)  --
	{ p = "%+(%d+) 奥术抗性", s = "ARCANERESIST" },
	{ p = "%+(%d+) 火焰抗性", s = "FIRERESIST" },
	{ p = "%+(%d+) 自然抗性", s = "NATURERESIST" },
	{ p = "%+(%d+) 冰霜抗性", s = "FROSTRESIST" },
	{ p = "%+(%d+) 暗影抗性", s = "SHADOWRESIST" },
	{ p = "%+(%d+) 全部抗性", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },
	{ p = "%+(%d+) 抵抗全部", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } }, -- Void Sphere
	--{ p = "(%d+)点所有魔法抗性", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },

	--  Equip: Other  --
	{ p = "Improves your resilience rating by (%d+)%.", s = "RESILIENCE" },
	{ p = "韧性等级提高(%d+)。", s = "RESILIENCE" },

	{ p = "防御等级提高(%d+)。", s = "DEFENSE" },
	{ p = "Increases defense rating by (%d+)%.", s = "DEFENSE" },
	{ p = "Increases your dodge rating by (%d+)%.", s = "DODGE" },
	{ p = "使你的躲闪等级提高(%d+)。", s = "DODGE" },
	{ p = "使你的招架等级提高(%d+)。", s = "PARRY" },

	{ p = "Increases your s?h?i?e?l?d? ?block rating by (%d+)%.", s = "BLOCK" }, -- Should catch both new and old style
	{ p = "使你的盾牌格挡等级提高(%d+)点。", s = "BLOCK" }, -- Should catch both new and old style
	{ p = "使你的盾牌格挡等级提高(%d+)", s = "BLOCK" }, 
	{ p = "Increases the block value of your shield by (%d+)%.", s = "BLOCKVALUE" },
	{ p = "使你的盾牌格挡值提高(%d+)点。", s = "BLOCKVALUE" },
	{ p = "^(%d+) Block$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield

	--  Equip: Melee & Ranged  --
	{ p = "攻击强度提高(%d+)点。", s = "AP" },
	{ p = "Increases attack power by (%d+)%.", s = "AP" },

	{ p = "Increases ranged attack power by (%d+)%.", s = "RAP" },
	{ p = "远程攻击强度提高(%d+)点。", s = "RAP" },
	{ p = "Increases attack power by (%d+) in Cat, Bear, Dire Bear, and Moonkin forms only%.", s = "APFERAL" },

	{ p = "Increases your expertise rating by (%d+)%.", s = "EXPERTISE" }, -- New 2.3 Stat
	{ p = "使你的精准等级提高(%d+)。", s = "EXPERTISE" },
	{ p = "Your attacks ignore (%d+) of your opponent's armor%.", s = "ARMORPENETRATION" },
	{ p = "Increases your armor penetration rating by (%d+)%.", s = "ARMORPENETRATIONRATING" }, -- Armor Penetration in 3.0
	{ p = "护甲穿透等级提高(%d+)。", s = "ARMORPENETRATIONRATING" },

	--  Equip: Spell Power  --
	{ p = "Increases your spell penetration by (%d+)%.", s = "SPELLPENETRATION" },

	{ p = "Increases spell power by (%d+)%.", s = { "HEAL", "SPELLDMG" } },
	{ p = "法术强度提高(%d+)点。", s = { "HEAL", "SPELLDMG" } },
	{ p = "Increases spell power slightly%.", s = { "HEAL", "SPELLDMG" }, v = 6 }, -- Bronze Band of Force

	{ p = "Increases arcane spell power by (%d+)%.", s = "ARCANEDMG" },
	{ p = "Increases fire spell power by (%d+)%.", s = "FIREDMG" },
	{ p = "Increases nature spell power by (%d+)%.", s = "NATUREDMG" },
	{ p = "Increases frost spell power by (%d+)%.", s = "FROSTDMG" },
	{ p = "Increases shadow spell power by (%d+)%.", s = "SHADOWDMG" },
	{ p = "Increases holy spell power by (%d+)%.", s = "HOLYDMG" },

	--  Equip: Stats Which Improves Both Spells & Melee  --
	{ p = "Increases your critical strike rating by (%d+)%.", s = { "CRIT", "SPELLCRIT" } },
	{ p = "爆击等级提高(%d+)。", s = { "CRIT", "SPELLCRIT" } },
	{ p = "Increases your hit rating by (%d+)%.", s = { "HIT", "SPELLHIT" } },
	{ p = "命中等级提高(%d+)。", s = { "HIT", "SPELLHIT" } },

	{ p = "急速等级提高(%d+)", s = { "HASTE", "SPELLHASTE" } },

	--  Health & Mana Per 5 Sec  --
	{ p = "(%d+) health every 5 sec%.", s = "HP5" },
	{ p = "(%d+) [Hh]ealth per 5 sec%.", s = "HP5" },

	{ p = "%+(%d+) Mana Regen", s = "MP5" }, -- Scryer Shoulder Enchant, Priest ZG Enchant
	{ p = "%+(%d+) Mana restored per 5 seconds", s = "MP5" }, -- Magister's Armor Kit
	{ p = "每5秒法力回复%+(%d+)", s = "MP5" },

	{ p = "%+(%d+) Mana per 5 Seconds", s = "MP5" }, -- Gem: Royal Shadow Draenite
	{ p = "每5秒回复(%d+)点法力值", s = "MP5" },
	{ p = "每5秒恢复(%d+)点法力值。", s = "MP5" },
	
	{ p = "Mana Regen (%d+) per 5 sec%.", s = "MP5" }, -- Bracer Enchant
	{ p = "%+(%d+) Mana/5 seconds", s = "MP5" }, -- Some WotLK Shoulder Enchant, unsure which

	{ p = "(%d+) [Mm]ana [Pp]er 5 [Ss]ec%.|-r-$", s = "MP5" }, -- Combined Pattern: Covers [Equip Bonuses] [Socket Bonuses] --- Added "|-r-$" to avoid confusing on item 33502
	{ p = "%+(%d+) [Mm]ana every 5 [Ss]ec", s = "MP5" }, -- Combined Pattern: Covers [Chest Enchant] [Gem: Dazzling Deep Peridot] [Various Gems]

	--  Enchants / Gems / Socket Bonuses / Mixed / Misc  --
	{ p = "^%+(%d+) 生命值$", s = "HP" },
	{ p = "^%+(%d+) HP$", s = "HP" },
	{ p = "^%+(%d+) Health$", s = "HP" },
	{ p = "^%+(%d+) Mana$", s = "MP" },
	{ p = "^%+(%d+) 法力值$", s = "MP" },

	{ p = "^活力$", s = { "MP5", "HP5" }, v = 4 },
	{ p = "^Greater Vitality$", s = { "MP5", "HP5" }, v = 6 },
	{ p = "^野蛮$", s = "AP", v = 70 },
	{ p = "^魂霜$", s = { "FROSTDMG", "SHADOWDMG" }, v = 54 },
	{ p = "^阳炎$", s = { "ARCANEDMG", "FIREDMG" }, v = 50 },
	{ p = "^稳固$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 10 }, -- Boots
	{ p = "^履冰$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 12 }, -- Boots
	{ p = "^精确$", s = { "CRIT", "HIT", "SPELLCRIT", "SPELLHIT" }, v = 25 }, -- Weapon

--	{ p = "^Rune of the Stoneskin Gargoyle$", s = "DEFENSE", v = 25 }, -- Death Knight Enchant, also adds 2% stamina

	-- Az: these 3 was added 09.01.05 and has not been checked out in game yet, please confirm they are correct.
	{ p = "^Titanium Weapon Chain$", s = { "HIT", "SPELLHIT" }, v = 10 },
	{ p = "^Tuskar's Vitality$", s = "STA", v = 15 }, -- the enchant text of this is spelled wrong, missing one "r" in tuskarr
	{ p = "^Wisdom$", s = "SPI", v = 10 },
	
	{ p = "^泰坦神铁武器链$", s = { "HIT", "SPELLHIT" }, v = 10 },
	{ p = "^海象人的活力$", s = "STA", v = 15 }, -- the enchant text of this is spelled wrong, missing one "r" in tuskarr
	{ p = "^智慧$", s = "SPI", v = 10 },

	{ p = "%+(%d+) 所有属性", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

	{ p = "%+(%d+) Arcane S?p?e?l?l? ?Damage", s = "ARCANEDMG" },
	{ p = "%+(%d+) Fire S?p?e?l?l? ?Damage", s = "FIREDMG" },
	{ p = "%+(%d+) Nature S?p?e?l?l? ?Damage", s = "NATUREDMG" },
	{ p = "%+(%d+) Frost S?p?e?l?l? ?Damage", s = "FROSTDMG" },
	{ p = "%+(%d+) Shadow S?p?e?l?l? ?Damage", s = "SHADOWDMG" },
	{ p = "%+(%d+) Holy S?p?e?l?l? ?Damage", s = "HOLYDMG" },

	{ p = "%+(%d+) 奥术法术伤害", s = "ARCANEDMG" },
	{ p = "%+(%d+) 火焰法术伤害", s = "FIREDMG" },
	{ p = "%+(%d+) 自然法术伤害", s = "NATUREDMG" },
	{ p = "%+(%d+) 冰霜法术伤害", s = "FROSTDMG" },
	{ p = "%+(%d+) 暗影法术伤害", s = "SHADOWDMG" },
	{ p = "%+(%d+) 神圣法术伤害", s = "HOLYDMG" },


	{ p = "%+(%d+) 防御", s = "DEFENSE" }, -- Exclude "Rating" from this pattern due to Paladin ZG Enchant
	{ p = "%+(%d+) 躲闪等级", s = "DODGE" },
	{ p = "%+(%d+) 招架等级", s = "PARRY" },
	{ p = "%+(%d+) S?h?i?e?l?d? ?Block Rating", s = "BLOCK" }, -- Combined Pattern: Covers [Shield Enchant] [Socket Bonus]
	{ p = "%+(%d+) 盾?牌?格挡等级", s = "BLOCK" },

	{ p = "%+(%d+) Block Value", s = "BLOCKVALUE" },
	{ p = "%+(%d+) 格挡值", s = "BLOCKVALUE" },

	{ p = "%+(%d+) 攻击强度", s = "AP" },
	{ p = "%+(%d+) Attack Power", s = "AP" },
	{ p = "%+(%d+) 远程攻击强度", s = "RAP" },
	{ p = "%+(%d+) 命中等级", s = { "HIT", "SPELLHIT" } },
	{ p = "%+(%d+) Crit Rating", s = { "CRIT", "SPELLCRIT" } },
	{ p = "%+(%d+) 爆击等级", s = { "CRIT", "SPELLCRIT" } },
	{ p = "%+(%d+) Critical S?t?r?i?k?e? ?Rating", s = { "CRIT", "SPELLCRIT" } }, -- Matches two versions, with/without "Strike". No "Strike" on "Unstable Citrine".
	{ p = "(%d+) Critical strike rating%.", s = { "CRIT", "SPELLCRIT" } }, -- Kirin Tor head enchant, no "+" sign, lower case "s" and "r"
	{ p = "%+(%d+) Resilience", s = "RESILIENCE" },
	{ p = "%+(%d+) 韧性等级", s = "RESILIENCE" },
	{ p = "%+(%d+) 急速等级", s = "HASTE" },
	{ p = "%+(%d+) 精准等级", s = "EXPERTISE" },

	{ p = "%+(%d+) 法术能量", s = { "SPELLDMG", "HEAL" } }, -- Was used in a few items/gems before WotLK, but is now the permanent spell pattern
	{ p = "%+(%d+) 法术强度", s = { "SPELLDMG", "HEAL" } },
	{ p = "%+(%d+) 法术命中", s = "SPELLHIT" }, -- Exclude "Rating" from this pattern to catch Mage ZG Enchant
	{ p = "%+(%d+) 法术爆击等级", s = "SPELLCRIT" },
--	{ p = "%+(%d+) Spell Critical S?t?r?i?k?e? ?Rating", s = "SPELLCRIT" }, -- Matches two versions, with/without "Strike"
	{ p = "%+(%d+) 法术爆击", s = "SPELLCRIT" }, -- Matches three versions, with Strike + Rating, with Rating, and without any suffix at all
	{ p = "%+(%d+) 法术急速等级", s = "SPELLHASTE" }, -- Found on gems
	{ p = "%+(%d+) 法术穿透", s = "SPELLPENETRATION" },
	{ p = "%+(%d+) Spell Penetration", s = "SPELLPENETRATION" },

	-- Should no longer be relavent for WotLK, but keeping them in case something turns up on enchants I've yet to see
--	{ p = "%+(%d+) Healing", s = "HEAL" }, -- Has to appear before patterns with a SPELLDMG entry, due to the workaround
--	{ p = "%+(%d+) Healing and Spell Damage", s = "SPELLDMG" }, -- Warlock ZG Enchant (Healing will be caught by the pattern above)
--	{ p = "Spell Damage %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- WORKAROUND: Infused Amethyst (31116)
--	{ p = "%+(%d+) Spell Damage", s = { "SPELLDMG", "HEAL" } },
--	{ p = "%+(%d+) Damage and Healing Spells", s = { "SPELLDMG", "HEAL" } },
--	{ p = "%+(%d+) Damage Spells", s = "SPELLDMG" }, -- New 2.3: Damage part of the previously "+Healing" enchants

	{ p = "%+(%d+)  ?Weapon Damage", s = "WPNDMG" }, -- Added optional space as I found a "+1  Weapon Damage" enchant on someone
	{ p = "%+(%d+) 武器伤害", s = "WPNDMG" },
	{ p = "^Scope %(%+(%d+) Damage%)$", s = "RANGEDDMG" },
	{ p = "^瞄准镜（%+(%d+) 伤害）$", s = "RANGEDDMG" },
	{ p = "^瞄准镜（%+(%d+) 爆击等级）$", s = "CRIT" },


	--远程爆击等级 龙纹弩
	-- Demon's Blood
	{ p = "防御等级提高5，暗影抗性提高10点，生命值恢复速度提高3点。", s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 5, 10, 3 } },

	-- Void Star Talisman (Warlock T5 Class Trinket)
	{ p = "使你的宠物的抗性提高130点，你的法术伤害提高最多48点。", s = "SPELLDMG", v = 48 },

	-- Temp Enchants (Disabled as they are not part of "gear" stats)
	--{ p = "Minor Mana Oil", s = "MP5", v = 4 },
	--{ p = "Lesser Mana Oil", s = "MP5", v = 8 },
	--{ p = "Superior Mana Oil", s = "MP5", v = 14 },
	--{ p = "Brilliant Mana Oil", s = { "MP5", "HEAL" }, v = { 12, 25 } },

	--{ p = "Minor Wizard Oil", s = "SPELLDMG", v = 8 },
	--{ p = "Lesser Wizard Oil", s = "SPELLDMG", v = 16 },
	--{ p = "Wizard Oil", s = "SPELLDMG", v = 24 },
	--{ p = "Superior Wizard Oil", s = "SPELLDMG", v = 42 },
	--{ p = "Brilliant Wizard Oil", s = { "SPELLDMG", "SPELLCRIT" }, v = { 36, 14 } },

	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },
};

--------------------------------------------------------------------------------------------------------
--                                        Stat Order & Naming                                         --
--------------------------------------------------------------------------------------------------------



ExScanner.StatNames = {
	["STR"] = "力量",
	["AGI"] = "敏捷",
	["STA"] = "耐力",
	["INT"] = "智力",
	["SPI"] = "精神",

	["ARMOR"] = "护甲",

	["ARCANERESIST"] = "奥术抗性",
	["FIRERESIST"] = "火焰抗性",
	["NATURERESIST"] = "自然抗性",
	["FROSTRESIST"] = "冰霜抗性",
	["SHADOWRESIST"] = "暗影抗性",

	["DODGE"] = "躲闪等级",
	["PARRY"] = "招架等级",
	["DEFENSE"] = "防御等级",
	["BLOCK"] = "格挡等级",
	["BLOCKVALUE"] = "格挡值",
	["RESILIENCE"] = "韧性等级",

	["AP"] = "攻击强度",
	["RAP"] = "远程攻击强度",
	["APFERAL"] = "攻击强度 (野性)",
	["CRIT"] = "爆击等级",
	["HIT"] = "命中等级",
	["HASTE"] = "急速等级",
	["WPNDMG"] = "武器伤害",
	["RANGEDDMG"] = "远程伤害",
	["ARMORPENETRATION"] = "护甲穿透",
	["ARMORPENETRATIONRATING"] = "护甲穿透",
	["EXPERTISE"] = "精准等级",

	["SPELLCRIT"] = "法术爆击等级",
	["SPELLHIT"] = "法术命中等级",
	["SPELLHASTE"] = "法术急速等级",
	["SPELLPENETRATION"] = "法术穿透等级",

	["HEAL"] = "治疗量",
	["SPELLDMG"] = "法术伤害",
	["ARCANEDMG"] = "法术伤害 (奥术)",
	["FIREDMG"] = "法术伤害 (火焰)",
	["NATUREDMG"] = "法术伤害 (自然)",
	["FROSTDMG"] = "法术伤害 (冰霜)",
	["SHADOWDMG"] = "法术伤害 (暗影)",
	["HOLYDMG"] = "法术伤害 (神圣)",

	["HP"] = "生命值",
	["MP"] = "法力值",

	["HP5"] = "每5秒生命回复",
	["MP5"] = "每5秒法力回复",
};

end