local addon,ns = ...
local statsFunc = CreateFrame("Frame")

statsFunc.PrimaryTalentTree = GetPrimaryTalentTree()

--PVE
--职业
statsFunc.GetClass = function(v)
	local class,CLASS = UnitClass("player")
	if v then
		return CLASS 
	else
		return class 
	end
end

--天赋
statsFunc.GetTalent = function()
	local talent = ""
	local points = "" 
	local mainPoints = 0
	for i = 1, 3 do
		local _,name ,_,_,point = GetTalentTabInfo(i)
		points = points .. point .. "/"
		if point >= mainPoints then
			mainPoints = point 
			talent = name	
		end
	end
	points = "("..points..")"
	return "天赋:"..talent..points
end

--物品等级
statsFunc.GetItemLevel = function()
	return math.ceil(GetAverageItemLevel())
end

----------基础属性
--力量
statsFunc.GetStrength = function() 
	return UnitStat("player",1)
end
--敏捷
statsFunc.GetAgility = function()
	return UnitStat("player",2)
end
--耐力
statsFunc.GetStamina = function()
	return UnitStat("player",3)
end
--智力
statsFunc.GetIntellect = function()
	return UnitStat("player",4)
end
--精神
statsFunc.GetSpirit = function()
	return UnitStat("player",5)
end
--精通
statsFunc.GetMasterys = function()
	return string.format("%6.2f",GetMastery())
end

-----------近战
--攻击强度
statsFunc.GetMeleeAttackPower = function()
	local base, posBuff, negBuff = UnitAttackPower("player")
	return floor(base + posBuff + negBuff)
end
--命中
statsFunc.GetMeleeHit = function()
	return GetCombatRating(CR_HIT_MELEE)
end
--暴击
statsFunc.GetMeleeCrit = function()
	return string.format("%6.2f%%",GetCritChance())
end
--精准
statsFunc.GetMeleeExpertise = function()
	return GetExpertise()
end
--急速
statsFunc.GetMeleeHastes = function()
	return string.format("%6.2f%%",GetMeleeHaste())
end

------------远程
--强度
statsFunc.GetRangeAttackPower = function()
	local base, posBuff, negBuff = UnitRangedAttackPower("player")
	return floor(base + posBuff + negBuff)
end
--命中
statsFunc.GetRangeHit = function()
	return GetCombatRating(CR_HIT_RANGED)
end
--暴击
statsFunc.GetRangeCrit = function()
	return string.format("%6.2f%%", GetRangedCritChance())
end
--急速
statsFunc.GetRangeHastes = function()
	return string.format("%6.2f%%", GetRangedHaste())
end

-----------法术
--法伤
statsFunc.GetSpellPower = function()
	local sp = GetSpellBonusDamage(2);
	for i=3, 7 do
		sp = max(sp, GetSpellBonusDamage(i));
	end
	return floor(sp);
end
--命中
statsFunc.GetSpellHit = function()
	return GetCombatRating(CR_HIT_SPELL)
end
--暴击
statsFunc.GetSpellCrit = function()
	local scrit = GetSpellCritChance(2);
	for i=3, 7 do
		scrit = max(scrit, GetSpellCritChance(i));
	end
	return string.format("%6.2f%%",scrit);
end
--急速
statsFunc.GetSpellHastes = function()
	return string.format("%6.2f%%",UnitSpellHaste"player")
end

-----------防御
--护甲
statsFunc.GetArmor = function()
	return select(3,UnitArmor"player")
end
--躲闪
statsFunc.GetDodge = function()
	return string.format("%6.2f%%",GetDodgeChance())
end
--招架
statsFunc.GetParry = function()
	return string.format("%6.2f%%",GetParryChance())
end
--格挡
statsFunc.GetBlock = function()
	return string.format("%6.2f%%",GetBlockChance())
end

--近战属性
statsFunc.GetMeleeInfo = function()
	local MeleeInfo = "攻强:"..statsFunc.GetMeleeAttackPower()..",".."命中:"..statsFunc.GetMeleeHit()..",".."暴击:"..statsFunc.GetMeleeCrit()..",".."精准:"..statsFunc.GetMeleeExpertise()..",".."急速"..statsFunc.GetMeleeHastes()
	return MeleeInfo
end
--远程属性
statsFunc.GetRangeInfo = function()
	local RangeInfo = "攻强:"..statsFunc.GetRangeAttackPower()..",".."命中:"..statsFunc.GetRangeHit()..",".."暴击:"..statsFunc.GetRangeCrit()..",".."急速"..statsFunc.GetRangeHastes()
	return RangeInfo
end

--法术属性
statsFunc.GetSpellsInfo = function()
	local SpellsInfo = "法强:"..statsFunc.GetSpellPower()..",".."命中:"..statsFunc.GetSpellHit()..",".."暴击:"..statsFunc.GetSpellCrit()..",".."急速"..statsFunc.GetSpellHastes()
	return SpellsInfo
end

--防御属性
statsFunc.GetTankInfo = function()
	local TankInfo = {
		PALADIN = function() return "护甲:"..statsFunc.GetArmor()..",".."躲闪:"..statsFunc.GetDodge()..",".."招架:"..statsFunc.GetParry()..",".."格挡"..statsFunc.GetBlock() end,
		WARRIOR = function() return "护甲:"..statsFunc.GetArmor()..",".."躲闪:"..statsFunc.GetDodge()..",".."招架:"..statsFunc.GetParry()..",".."格挡"..statsFunc.GetBlock() end,
		DRUID = function() return "护甲:"..statsFunc.GetArmor()..",".."躲闪:"..statsFunc.GetDodge() end,
		DEATHKNIGHT = function() return "护甲:"..statsFunc.GetArmor()..",".."躲闪:"..statsFunc.GetDodge()..",".."招架:"..statsFunc.GetParry() end, 
		MAGE = function() return "" end,
		HUNTER = function() return "" end,
		SHAMAN = function() return "" end,
		ROGUE = function() return "" end,
		PRIEST = function() return "" end,
		WARLOCK = function() return "" end,
	}
	return TankInfo[statsFunc.GetClass(true)]()  	
end

--职业&天赋
statsFunc.ClassInfo = {
	MAGE = { 
		"s","s","s" 
	},
	PRIEST = { 
		"s","s","s" 
	},
	WARLOCK = { 
		"s","s","s" 
	},
	SHAMAN = {
		 "s","m","s"
	},
	HUNTER = {
		"r","r","r" 
	},
	ROGUE = {
		 "m","m","m"
	},
	PALADIN ={
		"s","t","m"
	},
	DRUID = {
		 "s","tm","s"
	},
	WARRIOR = {
		"m","m","t"
	},
	DEATHKNIGHT ={
		"t","m","m"
	},
}

statsFunc.GetDetailsByClass = function()
		local details = "" 
		local class = statsFunc.GetClass(true)
		local talent = GetPrimaryTalentTree() 
		local ct = statsFunc.ClassInfo[class][talent]
		if ct == "s" then
			details = statsFunc.GetSpellsInfo()
		elseif ct == "m" then
			details = statsFunc.GetMeleeInfo()
		elseif ct == "t" then
			details = statsFunc.GetTankInfo()
		elseif ct == "r" then
			details = statsFunc.GetRangeInfo()
		elseif ct == "tm" then
			details = string.format("%s%s",statsFunc.GetTankInfo(),statsFunc.GetMeleeInfo())
		end
		return details
end

statsFunc.GetPvEInfo = function()
	local PvEInfo = ""
	 PvEInfo = string.format("职业:%s,装等:%s,天赋:%s,精通:%s,%s,via 魔兽精灵PvE属性通报",statsFunc.GetClass(),statsFunc.GetItemLevel(),statsFunc.GetTalent(),statsFunc.GetMasterys(),statsFunc.GetDetailsByClass())	
	return PvEInfo
end

--pvp

statsFunc.GetCritDeffence = function()
	return GetCombatRating(15)
end

statsFunc.InventorySlots = {
	["1"] = {},
	["3"] = {},
	["5"] = {},
	["7"] = {},
	["10"] = {},	
}
statsFunc.GetPvPItemsInfo = function()
	local PvPItemInfo = ""
	local flag = 0
	local itemLv = {}
	for slot,item in pairs(statsFunc.InventorySlots) do
		local id = GetInventoryItemID("player",tonumber(slot))
		if id then
			local name,link,_,level = GetItemInfo(id)
			for k,v in pairs(GetItemStats(link)) do
				if _G[k] == "韧性等级" then
					local shortName = string.sub(name,1,6).."角斗士"
					itemLv[shortName.."("..level] = itemLv[shortName.."("..level] == nil and 1 or itemLv[shortName.."("..level] + 1
				end
			end
			item.id = id
			item.name = name
			item.level = level
		end
	end
	for k,v in pairs(itemLv) do
		PvPItemInfo = PvPItemInfo ..string.format("%s%s%s%s",k,"*",v,") ")	
	end
	return PvPItemInfo
end

statsFunc.GetPvPInfo = function()
	local PvPInfo = ""
	PvPInfo = "职业:"..statsFunc.GetClass()..","..statsFunc.GetTalent()..",".."韧性:"..statsFunc.GetCritDeffence()..","..statsFunc.GetPvPItemsInfo()..",".."via 魔兽精灵PvP属性通报"
	return PvPInfo
end

statsFunc.InsertPlayerStats = function(v)
	if UnitLevel"player" <10 then 
		print("|cffe1a500属性通报功能不对10级以下角色开放|r")
	else
		local eb = (SELECTED_DOCK_FRAME or DEFAULT_CHAT_FRAME).editBox
		if v == "LeftButton" then
			eb:Insert(statsFunc.GetPvEInfo())
			eb:Show()
			eb:SetFocus()
		elseif v == "RightButton" then
			eb:Insert(statsFunc.GetPvPInfo())
			eb:Show()
			eb:SetFocus()
		end
	end
end

ns.statsFunc = statsFunc 
