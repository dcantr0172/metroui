-- susnow

local parent, ns = ...
local style = CreateFrame("Frame")
local oUF = WSUF.oUF
local utils = ns.utils
local L = WSUF.L
local Tags = WSUF.Tags
local db = WSUF.db.profile

local function GetObject(unit)
	local obj = self or ns.unitFrames[unit]
	if unit == "party" then
		obj = ns.unitFrames.party:GetChildren()
	elseif unit == "partytarget" then

	elseif unit == "partypet" then

	elseif unit == "boss" then
	
	end
	return obj
end

local function GetDB(unit)
	local unitdb = ns:GetUnitDB(unit)
	return unitdb
end

style.MoveAble = function(self,button,unit,position)
	local obj = GetObject(unit)
	obj:SetMovable(true)
	if UnitAffectingCombat(unit) then 
					print("|cffe1a500精灵头像|r:|cffff2020战斗中无法设置位置!|r")
		else
		if button == "RightButton" and obj.tempFlag%2 == 0 then
			obj:StartMoving()
			obj.tempFlag = obj.tempFlag +1 
			print("|cffe1a500精灵头像|r:|cff69ccf0解锁位置|r")
		elseif button == "RightButton" and obj.tempFlag%2 ~= 0 then
			obj:StopMovingOrSizing()
			local selfPoint,anchorTo,relativePoint,x,y = obj:GetPoint()

			position.selfPoint = selfPoint
			position.relativePoint = relativePoint
			position.anchorTo = "UIParent"
			position.x = x*UIParent:GetEffectiveScale()
			position.y = y*UIParent:GetEffectiveScale()
			obj.tempFlag= 0
			print("|cffe1a500精灵头像|r:|cff69ccf0锁定位置|r")
		end
	end
end

style.CopyName = function(unit)
	local obj = GetObject(unit)
	local copyName = function(str,arg1)
			ChatFrame1EditBox:Show()
			ChatFrame1EditBox:SetFocus()
			ChatFrame1EditBox:Insert(str)
			ChatFrame1EditBox:HighlightText(0,string.len(str))
			print(string.format("|cffe1a500获取 |cff69ccf0%s |cffe1a500的姓名成功|r",arg1))
	end
	
	obj:HookScript("OnMouseDown",function(self,button)
		local name,realm = UnitName(unit)
		if IsRightAltKeyDown() then
			copyName(name..(realm and realm or ""),name)
		end
	end)
end

style.CopyArmory = function(unit)
	local obj = GetObject(unit)
	local copyQueryString = function(str,arg1)
		ChatFrame1EditBox:Show()
		ChatFrame1EditBox:Insert(str)
		ChatFrame1EditBox:SetFocus()
		ChatFrame1EditBox:HighlightText(0,string.len(str))
		print(string.format("|cffe1a500去瞧瞧更多关于|cff69ccf0 %s  |cffe1a500的信息|r",arg1))
	end

	obj:HookScript("OnMouseDown",function(self,button)
		local name,realm = UnitName(unit)
		local client = GetLocale()
		local getArmory = {
			["zhCN"] = function(realm,name) return string.format("www.battlenet.com.cn/wow/zh/character/%s/%s/advanced",realm,name) end,
			["zhTW"] = function(realm,name) return string.format("tw.battle.net/wow/zh/character/%s/%s/advanced",realm,name) end,
			["enUS"] = function(realm,name) return string.format("us.battle.net/wow/en/character/%s/%s/advanced",realm,name) end,
		}
		local getDatabase = {
			["wowshell"] = function(id) return string.format("http://db.wowshell.com/npc=%s",id) end,
			["wowhead"] = function(id) return string.format("www.wowhead.com/npc=%s",id) end,
			["netease"] = function(id) return string.format("db.w.163.com/npc-%s.html",id) end,
			["sina"] = function(id) return string.format("wowdb.games.sina.com.cn/npc-%s.html",id) end,
			["178"] = function(id) return string.format("db.178.com/wow/cn/npc/%s.html",id) end,
			["duowan"] = function(id) return string.format("db.duowan.com/wow/npc-%s.html",id) end,
			["wowbox"] = function(id) return string.format("http://wowbox.meetgee.com/tw/npc-%s.html",id) end,
		}
		if IsRightControlKeyDown() then
			if UnitIsPlayer(unit) then	
				if not realm then realm = GetRealmName() end
				local armory = getArmory[client](realm,name)
				copyQueryString(armory,name)	
			else 
				local guid = UnitGUID(unit)
				local gid = string.sub(guid,7,10)
				local id = tonumber(gid,16)
				local dbUrl = getDatabase["wowshell"](id)
				copyQueryString(dbUrl,name)
			end
		end
	end)
end


ns.style = style
		
