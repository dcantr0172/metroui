local parent, ns = ...
local oUF = ns.oUF
local Tags = {afkStatus = {}, offlineStatus = {}, customEvents = {}};
local tagPool, functionPool, temp, regFontStrings, frequentUpdates, frequencyCache = {}, {}, {}, {}, {}, {};
local L = ns.L
ns.Tags = Tags;

--utils func
function ns:Hex(r, g, b)
	if (type(r) == "table") then
		if (r.r) then
			r,g,b = r.r, r.g, r.b
		else
			r, g, b = unpack(r);
		end
	end
	
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255);
end

function ns:FormatLargeNumber(number)
	if( number < 9999 ) then
		return number
	elseif( number < 999999 ) then
		return string.format("%.1fk", number / 1000)
	elseif( number < 99999999 ) then
		return string.format("%.2fm", number / 1000000)
	end
	
	return string.format("%dm", number / 1000000)
end

function ns:SmartFormatNumber(number)
	if( number < 999999 ) then
		return number
	elseif( number < 99999999 ) then
		return string.format("%.2fm", number / 1000000)
	end
	
	return string.format("%dm", number / 1000000)
end

function ns:GetClassColor(unit)
	if (not UnitIsPlayer(unit)) then
		return nil
	end

	local class = select(2, UnitClass(unit));

	return class and ns:Hex(ns.db.profile.classColors[class]);
end

function ns:FormatShortTime(seconds)
	if( seconds >= 3600 ) then
		return string.format("%dh", seconds / 3600)
	elseif( seconds >= 60 ) then
		return string.format("%dm", seconds / 60)
	end

	return string.format("%ds", seconds)
end

function ns:GetGradientColor(unit)
	local percent = UnitHealth(unit) / UnitHealthMax(unit)
	if( percent >= 1 ) then return self.db.profile.healthColors.green.r, self.db.profile.healthColors.green.g, self.db.profile.healthColors.green.b end
	if( percent == 0 ) then return self.db.profile.healthColors.red.r, self.db.profile.healthColors.red.g, self.db.profile.healthColors.red.b end
	
	local sR, sG, sB, eR, eG, eB = 0, 0, 0, 0, 0, 0
	local modifier, inverseModifier = percent * 2, 0
	if( percent > 0.50 ) then
		sR, sG, sB = self.db.profile.healthColors.green.r, self.db.profile.healthColors.green.g, self.db.profile.healthColors.green.b
		eR, eG, eB = self.db.profile.healthColors.yellow.r, self.db.profile.healthColors.yellow.g, self.db.profile.healthColors.yellow.b

		modifier = modifier - 1
	else
		sR, sG, sB = self.db.profile.healthColors.yellow.r, self.db.profile.healthColors.yellow.g, self.db.profile.healthColors.yellow.b
		eR, eG, eB = self.db.profile.healthColors.red.r, self.db.profile.healthColors.red.g, self.db.profile.healthColors.red.b
	end
	
	inverseModifier = 1 - modifier
	return eR * inverseModifier + sR * modifier, eG * inverseModifier + sG * modifier, eB * inverseModifier + sB * modifier
end

function Tags:RegisterEvents(parent, fontString, tags)
	for tag in string.gmatch(tags, "%[(.-)%]") do
		-- The reason the original %b() match won't work, with [( ()group())] (or any sort of tag with ( or )
		-- was breaking the logic and stripping the entire tag, this is a quick fix to stop that.
		local tagKey = select(2, string.match(tag, "(%b())([%w%p]+)(%b())"))
		if( not tagKey ) then tagKey = select(2, string.match(tag, "(%b())([%w%p]+)")) end
		if( not tagKey ) then tagKey = string.match(tag, "([%w%p]+)(%b())") end
		
		tag = tagKey or tag
		local currentStyle = ns.db.profile.currentMode;
		local currentStyleDB = ns:GetCurrentStyleDB(currentStyle);
		
		local tagEvents;
		--= Tags.defaultEvents[tag] or (currentStyleDB and currentStyleDB.tags[tag] and currentStyleDB.tags[tag].events) or (ns.db.profile.tags[tag] and ns.db.profile.tags[tag].events)
		if (Tags.defaultEvents[tag]) then
			tagEvents = Tags.defaultEvents[tag];
		elseif (currentStyleDB and currentStyleDB.tags[tag] and currentStyleDB.tags[tag].events) then
			tagEvents = currentStyleDB.tags[tag].events;
		elseif (ns.db.profile.tags[tag] and ns.db.profile.tags[tag].events) then
			tagEvents = ns.db.profile.tags[tag].events;
		end

		if( tagEvents ) then
			for event in string.gmatch(tagEvents, "%S+") do
				if( self.customEvents[event] ) then
					self.customEvents[event]:EnableTag(parent, fontString)
					fontString[event] = true
				elseif( Tags.eventType[event] ~= "unitless" or ns.Module.unitEvents[event] ) then
					parent:RegisterUnitEvent(event, fontString, "UpdateTags")
				else
					parent:RegisterNormalEvent(event, fontString, "UpdateTags")
				end
				
				-- The power and health bars will handle updating tags with this flag set
				fontString.fastPower = fontString.fastPower or Tags.eventType[event] == "power"
				fontString.fastHealth = fontString.fastHealth or Tags.eventType[event] == "health"
			end
		end
	end
end

function Tags:Reload()
	wipe(tagPool);
	wipe(functionPool);
	wipe(ns.tagFunc);

	for fontString, tags in pairs(regFontStrings) do
		self:Register(fontString.parent, fontString, tags)
		fontString.parent:RegisterUpdateFunc(fontString, "UpdateTags")
		fontString:UpdateTags()
	end
end

-- Frequent updates
local freqFrame = CreateFrame("Frame")
freqFrame:SetScript("OnUpdate", function(self, elapsed)
	for fontString, timeLeft in pairs(frequentUpdates) do
		if( fontString.parent:IsVisible() ) then
			frequentUpdates[fontString] = timeLeft - elapsed
			if( frequentUpdates[fontString] <= 0 ) then
				frequentUpdates[fontString] = fontString.frequentStart
				fontString:UpdateTags()
			end
		end
	end
end)
freqFrame:Hide();

function Tags:Register(parent, fontString, tags, resetCache)
	if( fontString.UpdateTags ) then
		self:Unregister(fontString)
	end

	---- current Style 
	local currentStyle = ns.db.profile.currentMode;
	local currentStyleDB = ns:GetCurrentStyleDB(currentStyle);

	fontString.parent = parent
	regFontStrings[fontString] = tags

	-- Use the cached polling time if we already saved it
	-- as we won't be rececking everything next call
	local pollTime = frequencyCache[tags]
	if( pollTime ) then
		frequentUpdates[fontString] = pollTime
		fontString.frequentStart = pollTime
		freqFrame:Show()
	end

	local updateFunc = not resetCache and tagPool[tags]
	if( not updateFunc ) then
		-- Using .- prevents supporting tags such as [foo ([)]. Supporting that and having a single pattern
		local formattedText = string.gsub(string.gsub(tags, "%%", "%%%%"), "[[].-[]]", "%%s")
		local args = {}

		for tag in string.gmatch(tags, "%[(.-)%]") do
			-- Tags that use pre or appends "foo(|)" etc need special matching, which is what this will handle
			local cachedFunc = not resetCache and functionPool[tag] or ns.tagFunc[tag]
			if( not cachedFunc ) then
				local hasPre, hasAp = true, true
				local tagKey = select(2, string.match(tag, "(%b())([%w%p]+)(%b())"))
				if( not tagKey ) then hasPre, hasAp = true, false tagKey = select(2, string.match(tag, "(%b())([%w%p]+)")) end
				if( not tagKey ) then hasPre, hasAp = false, true tagKey = string.match(tag, "([%w%p]+)(%b())") end

				if (tagKey) then
					if(self.defaultFrequents[tagKey]) then
						frequencyCache[tag] = self.defaultFrequents[tagKey];
					elseif (currentStyleDB and currentStyleDB.tags[tagKey] and currentStyleDB.tags[tagKey].frequency) then
						frequencyCache[tag] = currentStyleDB.tags[tagKey].frequency;
					elseif (ns.db.profile.tags[tagKey] and ns.db.profile.tags[tagKey].frequency) then
						frequencyCache[tag] = ns.db.profile.tags[tagKey].frequency;
					end

					--frequencyCache[tag] = tagKey and (self.defaultFrequents[tagKey] or WSUF.db.profile.tags[tagKey] and WSUF.db.profile.tags[tagKey].frequency)
					local tagFunc = tagKey and ns.tagFunc[tagKey]
					if( tagFunc ) then
						local startOff, endOff = string.find(tag, tagKey)
						local pre = hasPre and string.sub(tag, 2, startOff - 2)
						local ap = hasAp and string.sub(tag, endOff + 2, -2)

						if( pre and ap ) then
							cachedFunc = function(...)
								local str = tagFunc(...)
								if( str ) then return pre .. str .. ap end
							end
						elseif( pre ) then
							cachedFunc = function(...)
								local str = tagFunc(...)
								if( str ) then return pre .. str end
							end
						elseif( ap ) then
							cachedFunc = function(...)
								local str = tagFunc(...)
								if( str ) then return str .. ap end
							end
						end

						functionPool[tag] = cachedFunc
					end
				end
			end

			-- Figure out what the lowest update frequency for this font string and use it
			local pollTime = self.defaultFrequents[tag] or frequencyCache[tag]
			if( currentStyleDB and currentStyleDB.tags[tag] and currentStyleDB.tags[tag].frequency ) then
				pollTime = currentStyleDB.tags[tag].frequency
			elseif (ns.db.profile.tags[tag] and ns.db.profile.tags[tag].frequency) then
				pollTime = ns.db.profile.tags[tag].frequency
			end

			if( pollTime and ( not fontString.frequentStart or fontString.frequentStart > pollTime ) ) then
				frequencyCache[tags] = pollTime
				frequentUpdates[fontString] = pollTime
				fontString.frequentStart = pollTime
				freqFrame:Show()
			end

			-- It's an invalid tag, simply return the tag itself wrapped in brackets
			if( not cachedFunc ) then
				functionPool[tag] = functionPool[tag] or function() return string.format("[%s-error]", tag) end
				cachedFunc = functionPool[tag]
			end
			table.insert(args, cachedFunc)
		end

		-- Create our update function now
		updateFunc = function(fontString)
			for id, func in pairs(args) do
				temp[id] = func(fontString.parent.unit, fontString.parent.unitOwner, fontString) or ""
			end

			fontString:SetFormattedText(formattedText, unpack(temp))
		end

		tagPool[tags] = updateFunc
	end

	-- And give other frames an easy way to force an update
	fontString.UpdateTags = updateFunc

	-- Register any needed event
	self:RegisterEvents(parent, fontString, tags)
end

function Tags:Unregister(fontString)
	regFontStrings[fontString] = nil
	frequentUpdates[fontString] = nil
	
	-- Kill frequent updates if they aren't needed anymore
	local hasFrequent
	for k in pairs(frequentUpdates) do
		hasFrequent = true
		break
	end
	
	if( not hasFrequent ) then
		freqFrame:Hide()
	end
	
	-- Unregister it as using HC
	for key, module in pairs(self.customEvents) do
		if( fontString[key] ) then
			fontString[key] = nil
			module:DisableTag(fontString.parent, fontString)
		end
	end
		
	-- Kill any tag data
	fontString.parent:UnregisterAll(fontString)
	fontString.fastPower = nil
	fontString.fastHealth = nil
	fontString.frequentStart = nil
	fontString.UpdateTags = nil
	fontString:SetText("")
end

local function abbreviateName(text)
	return strsub(text, 1, 1) .. "."
end

Tags.abbrevCache = setmetatable({}, {
	__index = function()
		val = string.gsub(val, "([^%s]+) ", abbreviateName)
		rawset(tbl, val, val)
		return val
	end
})

local Druid = {}
Druid.CatForm, Druid.Shapeshift = GetSpellInfo(768)
Druid.MoonkinForm = GetSpellInfo(24858)
Druid.TravelForm = GetSpellInfo(783)
Druid.BearForm = GetSpellInfo(5487)
Druid.TreeForm = GetSpellInfo(33891)
Druid.AquaticForm = GetSpellInfo(1066)
Druid.SwiftFlightForm = GetSpellInfo(40120)
Druid.FlightForm = GetSpellInfo(33943)
ns.Druid = Druid

Tags.defaultTags = {
	["hp:color"] = [[function(unit, unitOwner)
		return WSUF:Hex(WSUF:GetGradientColor(unit))
	end]],
	["short:druidform"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		
		local Druid = WSUF.Druid
		if( UnitAura(unit, Druid.CatForm, Druid.Shapeshift) ) then
			return "C"
		elseif( UnitAura(unit, Druid.TreeForm, Druid.Shapeshift) ) then
			return "T"
		elseif( UnitAura(unit, Druid.MoonkinForm, Druid.Shapeshift) ) then
			return "M"
		elseif( UnitAura(unit, Druid.BearForm, Druid.Shapeshift) ) then
			return "B"
		elseif( UnitAura(unit, Druid.SwiftFlightForm, Druid.Shapeshift) or UnitAura(unit, Druid.FlightForm, Druid.Shapeshift) ) then
			return "F"
		elseif( UnitAura(unit, Druid.TravelForm, Druid.Shapeshift) ) then
			return "T"
		elseif( UnitAura(unit, Druid.AquaticForm, Druid.Shapeshift) ) then
			return "A"
		end
	end]],
	["druidform"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		
		local Druid = WSUF.Druid
		if( UnitAura(unit, Druid.CatForm, Druid.Shapeshift) ) then
			return WSUF.L["Cat"]
		elseif( UnitAura(unit, Druid.TreeForm, Druid.Shapeshift) ) then
			return WSUF.L["Tree"]
		elseif( UnitAura(unit, Druid.MoonkinForm, Druid.Shapeshift) ) then
			return WSUF.L["Moonkin"]
		elseif( UnitAura(unit, Druid.BearForm, Druid.Shapeshift) ) then
			return WSUF.L["Bear"]
		elseif( UnitAura(unit, Druid.SwiftFlightForm, Druid.Shapeshift) or UnitAura(unit, Druid.FlightForm, Druid.Shapeshift) ) then
			return WSUF.L["Flight"]
		elseif( UnitAura(unit, Druid.TravelForm, Druid.Shapeshift) ) then
			return WSUF.L["Travel"]
		elseif( UnitAura(unit, Druid.AquaticForm, Druid.Shapeshift) ) then
			return WSUF.L["Aquatic"]
		end
	end]],
	["guild"] = [[function(unit, unitOwner)
		return GetGuildInfo(unitOwner)
	end]],
	["abbrev:name"] = [[function(unit, unitOwner)
		local name = UnitName(unitOwner) or UNKNOWN
		return string.len(name) > 10 and WSUF.Tags.abbrevCache[name] or name
	end]],
	["unit:situation"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)
		if( state == 3 ) then
			return WSUF.L["Aggro"]
		elseif( state == 2 ) then
			return WSUF.L["High"]
		elseif( state == 1 ) then
			return WSUF.L["Medium"]
		end
	end]],
	["situation"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")
		if( state == 3 ) then
			return WSUF.L["Aggro"]
		elseif( state == 2 ) then
			return WSUF.L["High"]
		elseif( state == 1 ) then
			return WSUF.L["Medium"]
		end
	end]],
	["unit:color:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)
		
		return state and state > 0 and WSUF:Hex(GetThreatStatusColor(state))
	end]],
	["unit:color:aggro"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation(unit)
		
		return state and state >= 3 and WSUF:Hex(GetThreatStatusColor(state))
	end]],
	["color:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")
		
		return state and state > 0 and WSUF:Hex(GetThreatStatusColor(state))
	end]],
	["color:aggro"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player", "target")
		
		return state and state >= 3 and WSUF:Hex(GetThreatStatusColor(state))
	end]],
	--["unit:scaled:threat"] = [[function(unit, unitOwner, fontString)
	--	local scaled = select(3, UnitDetailedThreatSituation(unit))
	--	return scaled and string.format("%d%%", scaled)
	--end]],
	["scaled:threat"] = [[function(unit, unitOwner)
		local scaled = select(3, UnitDetailedThreatSituation("player", "target"))
		return scaled and string.format("%d%%", scaled)
	end]],
	["general:sit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player")
		if( state == 3 ) then
			return WSUF.L["Aggro"]
		elseif( state == 2 ) then
			return WSUF.L["High"]
		elseif( state == 1 ) then
			return WSUF.L["Medium"]
		end
	end]],
	["color:gensit"] = [[function(unit, unitOwner)
		local state = UnitThreatSituation("player")
		
		return state and state > 0 and WSUF:Hex(GetThreatStatusColor(state))
	end]],
	["status:time"] = [[function(unit, unitOwner)
		local offlineStatus = WSUF.Tags.offlineStatus
		if( not UnitIsConnected(unitOwner) ) then
			offlineStatus[unitOwner] = offlineStatus[unitOwner] or GetTime()
			return string.format(WSUF.L["Off:%s"], WSUF:FormatShortTime(GetTime() - offlineStatus[unitOwner]))
		end
		
		offlineStatus[unitOwner] = nil
	end]],
	["afk:time"] = [[function(unit, unitOwner)
		if( not UnitIsConnected(unitOwner) ) then return end
		
		local afkStatus = WSUF.Tags.afkStatus
		local status = UnitIsAFK(unitOwner) and WSUF.L["AFK:%s"] or UnitIsDND(unitOwner) and WSUF.L["DND:%s"]
		if( status ) then
			afkStatus[unitOwner] = afkStatus[unitOwner] or GetTime()
			return string.format(status, WSUF:FormatShortTime(GetTime() - afkStatus[unitOwner]))
		end
		
		afkStatus[unitOwner] = nil
	end]],
	["pvp:time"] = [[function(unit, unitOwner)
		if( GetPVPTimer() >= 300000 ) then
			return nil
		end
		
		return string.format(WSUF.L["PVP:%s"], WSUF:FormatShortTime(GetPVPTimer() / 1000))
	end]],
	["afk"] = [[function(unit, unitOwner, fontString)
		return UnitIsAFK(unitOwner) and WSUF.L["AFK"] or UnitIsDND(unitOwner) and WSUF.L["DND"]
	end]],
	["close"] = [[function(unit, unitOwner) return "|r" end]],
	["smartrace"] = [[function(unit, unitOwner)
		return UnitIsPlayer(unit) and WSUF.tagFunc.race(unit) or WSUF.tagFunc.creature(unit)
	end]],
	["reactcolor"] = [[function(unit, unitOwner)
		local color
		if( not UnitIsFriend(unit, "player") and UnitPlayerControlled(unit) ) then
			if( UnitCanAttack("player", unit) ) then
				color = WSUF.db.profile.healthColors.hostile
			else
				color = WSUF.db.profile.healthColors.enemyUnattack
			end
		elseif( UnitReaction(unit, "player") ) then
			local reaction = UnitReaction(unit, "player")
			if( reaction > 4 ) then
				color = WSUF.db.profile.healthColors.friendly
			elseif( reaction == 4 ) then
				color = WSUF.db.profile.healthColors.neutral
			elseif( reaction < 4 ) then
				color = WSUF.db.profile.healthColors.hostile
			end
		end
		
		return color and WSUF:Hex(color)
	end]],
	["class"] = [[function(unit, unitOwner)
		return UnitIsPlayer(unit) and UnitClass(unit)
	end]],
	["classcolor"] = [[function(unit, unitOwner) return WSUF:GetClassColor(unit) end]],
	["creature"] = [[function(unit, unitOwner) return UnitCreatureFamily(unit) or UnitCreatureType(unit) end]],
	["curhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end

		return WSUF:FormatLargeNumber(UnitHealth(unit))
	end]],
	["colorname"] = [[function(unit, unitOwner)
		local color = WSUF:GetClassColor(unitOwner)
		local name = UnitName(unitOwner) or UNKNOWN
		if( not color ) then
			return name
		end
		if string.find(unit,"party%d?target") then
			if string.len(name) >=8 then
				name = string.sub(name,1,8)
				name = name.."..."
			end
		end
		return string.format("%s%s|r", color, name)
	end]],
	["curpp"] = [[function(unit, unitOwner) 
		if( UnitPowerMax(unit) <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end
		
		return WSUF:FormatLargeNumber(UnitPower(unit))
	end]],
	["curmaxhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end
		
		return string.format("%s/%s", WSUF:FormatLargeNumber(UnitHealth(unit)), WSUF:FormatLargeNumber(UnitHealthMax(unit)))
	end]],
	["smart:curmaxhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end
		
		return string.format("%s/%s", WSUF:SmartFormatNumber(UnitHealth(unit)), WSUF:SmartFormatNumber(UnitHealthMax(unit)))
	end]],
	["absolutehp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end
		
		return string.format("%s/%s", UnitHealth(unit), UnitHealthMax(unit))
	end]],
	["abscurhp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end
		
		return UnitHealth(unit)
	end]],
	["absmaxhp"] = [[function(unit, unitOwner) return UnitHealthMax(unit) end]],
	["abscurpp"] = [[function(unit, unitOwner)
		if( UnitPowerMax(unit) <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end	
	
		return UnitPower(unit)
	end]],
	["absmaxpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		return power > 0 and power or nil
	end]],
	["absolutepp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", maxPower)
		elseif( maxPower <= 0 ) then
			return nil
		end
		
		return string.format("%s/%s", power, maxPower)
	end]],
	["curmaxpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", WSUF:FormatLargeNumber(maxPower))
		elseif( maxPower <= 0 ) then
			return nil
		end
		
		return string.format("%s/%s", WSUF:FormatLargeNumber(power), WSUF:FormatLargeNumber(maxPower))
	end]],
	["smart:curmaxpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		local power = UnitPower(unit)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", maxPower)
		elseif( maxPower <= 0 ) then
			return nil
		end
		
		return string.format("%s/%s", WSUF:SmartFormatNumber(power), WSUF:SmartFormatNumber(maxPower))
	end]],
	["levelcolor"] = [[function(unit, unitOwner)
		local level = UnitLevel(unit)
		if( level < 0 and UnitClassification(unit) == "worldboss" ) then
			return nil
		end
		
		if( UnitCanAttack("player", unit) ) then
			local color = WSUF:Hex(GetQuestDifficultyColor(level > 0 and level or 99))
			if( not color ) then
				return level > 0 and level or "??"
			end
			
			return color .. (level > 0 and level or "??") .. "|r"
		else
			return level > 0 and level or "??"
		end
	end]],
	["faction"] = [[function(unit, unitOwner) return UnitFactionGroup(unitOwner) end]],
	["level"] = [[function(unit, unitOwner)
		local level = UnitLevel(unit)
		return level > 0 and level or UnitClassification(unit) ~= "worldboss" and "??" or nil
	end]],
	["maxhp"] = [[function(unit, unitOwner) return WSUF:FormatLargeNumber(UnitHealthMax(unit)) end]],
	["maxpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		if( power <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) ) then
			return 0
		end
		
		return WSUF:FormatLargeNumber(power)
	end]],
	["missinghp"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end

		local missing = UnitHealthMax(unit) - UnitHealth(unit)
		if( missing <= 0 ) then return nil end
		return "-" .. WSUF:FormatLargeNumber(missing) 
	end]],
	["missingpp"] = [[function(unit, unitOwner)
		local power = UnitPowerMax(unit)
		if( power <= 0 ) then
			return nil
		end

		local missing = power - UnitPower(unit)
		if( missing <= 0 ) then return nil end
		return "-" .. WSUF:FormatLargeNumber(missing)
	end]],
	["def:name"] = [[function(unit, unitOwner)
		local deficit = WSUF.tagFunc.missinghp(unit, unitOwner)
		if( deficit ) then return deficit end
		
		return WSUF.tagFunc.name(unit, unitOwner)
	end]],
	["name"] = [[function(unit, unitOwner) return UnitName(unitOwner) or UNKNOWN end]],
	["server"] = [[function(unit, unitOwner)
		local server = select(2, UnitName(unitOwner))
		return server ~= "" and server or nil
	end]],
	["perhp"] = [[function(unit, unitOwner)
		local max = UnitHealthMax(unit)
		if( max <= 0 or UnitIsDead(unit) or UnitIsGhost(unit) or not UnitIsConnected(unit) ) then
			return "0%"
		end
		
		return math.floor(UnitHealth(unit) / max * 100 + 0.5) .. "%"
	end]],
	["perpp"] = [[function(unit, unitOwner)
		local maxPower = UnitPowerMax(unit)
		if( maxPower <= 0 ) then
			return nil
		elseif( UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) ) then
			return "0%"
		end
		
		return string.format("%d%%", math.floor(UnitPower(unit) / maxPower * 100 + 0.5))
	end]],
	["plus"] = [[function(unit, unitOwner) local classif = UnitClassification(unit) return (classif == "elite" or classif == "rareelite") and "+" end]],
	["race"] = [[function(unit, unitOwner) return UnitRace(unit) end]],
	["rare"] = [[function(unit, unitOwner) local classif = UnitClassification(unit) return (classif == "rare" or classif == "rareelite") and WSUF.L["Rare"] end]],
	["sex"] = [[function(unit, unitOwner) local sex = UnitSex(unit) return sex == 2 and WSUF.L["Male"] or sex == 3 and WSUF.L["Female"] end]],
	["smartclass"] = [[function(unit, unitOwner) return UnitIsPlayer(unit) and WSUF.tagFunc.class(unit) or WSUF.tagFunc.creature(unit) end]],
	["status"] = [[function(unit, unitOwner)
		if( UnitIsDead(unit) ) then
			return WSUF.L["Dead"]
		elseif( UnitIsGhost(unit) ) then
			return WSUF.L["Ghost"]
		elseif( not UnitIsConnected(unit) ) then
			return WSUF.L["Offline"]
		end
	end]],
	["cpoints"] = [[function(unit, unitOwner)
		local points = GetComboPoints(WSUF.playerUnit)
		if( points == 0 ) then
			points = GetComboPoints(WSUF.playerUnit, WSUF.playerUnit)
		end
		
		return points > 0 and points
	end]],
	["smartlevel"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		if( classif == "worldboss" ) then
			return WSUF.L["Boss"]
		else
			local plus = WSUF.tagFunc.plus(unit)
			local level = WSUF.tagFunc.level(unit)
			if( plus ) then
				return level .. plus
			else
				return level
			end
		end
	end]],
	["dechp"] = [[function(unit, unitOwner) return string.format("%.1f%%", (UnitHealth(unit) / UnitHealthMax(unit)) * 100) end]],
	["classification"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		if( classif == "rare" ) then
			return WSUF.L["Rare"]
		elseif( classif == "rareelite" ) then
			return WSUF.L["Rare Elite"]
		elseif( classif == "elite" ) then
			return WSUF.L["Elite"]
		elseif( classif == "worldboss" ) then
			return WSUF.L["Boss"]
		end
		
		return nil
	end]],
	["shortclassification"] = [[function(unit, unitOwner)
		local classif = UnitClassification(unit)
		return classif == "rare" and "R" or classif == "rareelite" and "R+" or classif == "elite" and "+" or classif == "worldboss" and "B"
	end]],
	["group"] = [[function(unit, unitOwner)
		if( GetNumRaidMembers() == 0 ) then return nil end
		local name, server = UnitName(unitOwner)
		if( server and server ~= "" ) then
			name = string.format("%s-%s", name, server)
		end
		
		for i=1, GetNumRaidMembers() do
			local raidName, _, group = GetRaidRosterInfo(i)
			if( raidName == name ) then
				return group
			end
		end
		
		return nil
	end]],
	["druid:curpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= 1 and powerType ~= 3 ) then return nil end
		return WSUF:FormatLargeNumber(UnitPower(unit, 0))
	end]],
	["druid:abscurpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= 1 and powerType ~= 3 ) then return nil end
		return UnitPower(unit, 0)
	end]],
	["druid:curmaxpp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= 1 and powerType ~= 3 ) then return nil end
		
		local maxPower = UnitPowerMax(unit, 0)
		local power = UnitPower(unit, 0)
		if( UnitIsDeadOrGhost(unit) ) then
			return string.format("0/%s", WSUF:FormatLargeNumber(maxPower))
		elseif( maxPower == 0 and power == 0 ) then
			return nil
		end
		
		return string.format("%s/%s", WSUF:FormatLargeNumber(power), WSUF:FormatLargeNumber(maxPower))
	end]],
	["druid:absolutepp"] = [[function(unit, unitOwner)
		if( select(2, UnitClass(unit)) ~= "DRUID" ) then return nil end
		local powerType = UnitPowerType(unit)
		if( powerType ~= 1 and powerType ~= 3 ) then return nil end
		return UnitPower(unit, 0)
	end]],
	["abs:incheal"] = [[function(unit, unitOwner, fontString)
		return fontString.incoming and string.format("%d", fontString.incoming)
	end]],
	["incheal"] = [[function(unit, unitOwner, fontString)
		return fontString.incoming and WSUF:FormatLargeNumber(fontString.incoming) or nil
	end]],
	["incheal:name"] = [[function(unit, unitOwner, fontString)
		return fontString.incoming and string.format("+%d", fontString.incoming) or WSUF.tagFunc.name(unit, unitOwner)
	end]],
	--[=[
	["unit:raid:targeting"] = [[function(unit, unitOwner, fontString)
		if( GetNumRaidMembers() == 0 ) then return nil end
		local guid = UnitGUID(unit)
		if( not guid ) then return "0" end
		
		local total = 0
		for i=1, GetNumRaidMembers() do
			local unit = WSUF.raidUnits[i]
			if( UnitGUID(WSUF.unitTarget[unit]) == guid ) then
				total = total + 1
			end
		end		
		return total
	end]],
	["unit:raid:assist"] = [[function(unit, unitOwner, fontString)
		if( GetNumRaidMembers() == 0 ) then return nil end
		local guid = UnitGUID(WSUF.unitTarget[unit])
		if( not guid ) then return "--" end
		
		local total = 0
		for i=1, GetNumRaidMembers() do
			local unit = WSUF.raidUnits[i]
			if( UnitGUID(WSUF.unitTarget[unit]) == guid ) then
				total = total + 1
			end
		end		
		return total
	end]],
	]=]
}

Tags.defaultEvents = {
	["hp:color"]			= "UNIT_HEALTH UNIT_MAXHEALTH",
	["short:druidform"]		= "UNIT_AURA",
	["druidform"]			= "UNIT_AURA",
	["guild"]				= "UNIT_NAME_UPDATE", -- Not sure when this data is available, guessing
	["abs:incheal"]			= "UNIT_HEAL_PREDICTION",
	["incheal:name"]		= "UNIT_HEAL_PREDICTION",
	["incheal"]				= "UNIT_HEAL_PREDICTION",
	["afk"]					= "PLAYER_FLAGS_CHANGED", -- Yes, I know it's called PLAYER_FLAGS_CHANGED, but arg1 is the unit including non-players.
	["afk:time"]			= "PLAYER_FLAGS_CHANGED UNIT_CONNECTION",
	["status:time"]			= "UNIT_POWER UNIT_CONNECTION",
	["pvp:time"]			= "PLAYER_FLAGS_CHANGED",
	["curhp"]               = "UNIT_HEALTH UNIT_CONNECTION",
	["abscurhp"]			= "UNIT_HEALTH UNIT_CONNECTION",
	["curmaxhp"]			= "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION",
	["absolutehp"]			= "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION",
	["smart:curmaxhp"]		= "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION",
	["curpp"]               = "UNIT_POWER UNIT_DISPLAYPOWER",
	["abscurpp"]            = "UNIT_POWER UNIT_DISPLAYPOWER UNIT_MAXPOWER",
	["curmaxpp"]			= "UNIT_POWER UNIT_DISPLAYPOWER UNIT_MAXPOWER",
	["absolutepp"]			= "UNIT_POWER UNIT_DISPLAYPOWER UNIT_MAXPOWER",
	["smart:curmaxpp"]		= "UNIT_POWER UNIT_DISPLAYPOWER UNIT_MAXPOWER",
	["druid:curpp"]  	    = "UNIT_POWER UNIT_DISPLAYPOWER",
	["druid:abscurpp"]      = "UNIT_POWER UNIT_DISPLAYPOWER",
	["druid:curmaxpp"]		= "UNIT_POWER UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["druid:absolutepp"]	= "UNIT_POWER UNIT_MAXPOWER UNIT_DISPLAYPOWER",
	["level"]               = "UNIT_LEVEL PLAYER_LEVEL_UP",
	["levelcolor"]			= "UNIT_LEVEL PLAYER_LEVEL_UP",
	["maxhp"]               = "UNIT_MAXHEALTH",
	["def:name"]			= "UNIT_NAME_UPDATE UNIT_MAXHEALTH UNIT_HEALTH",
	["absmaxhp"]			= "UNIT_MAXHEALTH",
	["maxpp"]               = "UNIT_MAXPOWER",
	["absmaxpp"]			= "UNIT_MAXPOWER",
	["missinghp"]           = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION",
	["missingpp"]           = "UNIT_POWER UNIT_MAXPOWER",
	["name"]                = "UNIT_NAME_UPDATE",
	["abbrev:name"]			= "UNIT_NAME_UPDATE",
	["server"]				= "UNIT_NAME_UPDATE",
	["colorname"]			= "UNIT_NAME_UPDATE",
	["perhp"]               = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION",
	["perpp"]               = "UNIT_POWER UNIT_MAXPOWER UNIT_CONNECTION",
	["status"]              = "UNIT_HEALTH PLAYER_UPDATE_RESTING UNIT_CONNECTION",
	["smartlevel"]          = "UNIT_LEVEL PLAYER_LEVEL_UP UNIT_CLASSIFICATION_CHANGED",
	["cpoints"]             = "UNIT_COMBO_POINTS PLAYER_TARGET_CHANGED",
	["rare"]                = "UNIT_CLASSIFICATION_CHANGED",
	["classification"]      = "UNIT_CLASSIFICATION_CHANGED",
	["shortclassification"] = "UNIT_CLASSIFICATION_CHANGED",
	["dechp"]				= "UNIT_HEALTH UNIT_MAXHEALTH",
	["group"]				= "RAID_ROSTER_UPDATE",
	["unit:color:aggro"]	= "UNIT_THREAT_SITUATION_UPDATE",
	["color:aggro"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["situation"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["color:sit"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["scaled:threat"]		= "UNIT_THREAT_SITUATION_UPDATE",
	["general:sit"]			= "UNIT_THREAT_SITUATION_UPDATE",
	["color:gensit"]		= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:scaled:threat"]	= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:color:sit"]		= "UNIT_THREAT_SITUATION_UPDATE",
	["unit:situation"]		= "UNIT_THREAT_SITUATION_UPDATE",
}

Tags.defaultFrequents = {
	["afk"] = 1,
	["afk:time"] = 1,
	["status:time"] = 1,
	["pvp:time"] = 1,
	["scaled:threat"] = 1,
	["unit:scaled:threat"] = 1,
	["curmaxpp"] = .1,
	--[[
	["unit:raid:targeting"] = 0.50,
	["unit:raid:assist"] = 0.50,
	]]
}

Tags.defaultCategories = {
	["hp:color"]			= "health",
	["abs:incheal"]			= "health",
	["incheal"]				= "health",
	["incheal:name"]		= "health",
	["smart:curmaxhp"]		= "health",
	["smart:curmaxpp"]		= "health",
	["afk"]					= "status",
	["afk:time"]			= "status",
	["status:time"]			= "status",
	["pvp:time"]			= "status",
	["cpoints"]				= "misc",
	["smartlevel"]			= "classification",
	["classification"]		= "classification",
	["shortclassification"]	= "classification",
	["rare"]				= "classification",
	["plus"]				= "classification",
	["sex"]					= "misc",
	["smartclass"]			= "classification",
	["smartrace"]			= "classification",
	["status"]				= "status",
	["race"]				= "classification",
	["level"]				= "classification",
	["maxhp"]				= "health",
	["maxpp"]				= "power",
	["missinghp"]			= "health",
	["missingpp"]			= "power",
	["name"]				= "misc",
	["abbrev:name"]			= "misc",
	["server"]				= "misc",
	["perhp"]				= "health",
	["perpp"]				= "power",
	["class"]				= "classification",
	["classcolor"]			= "classification",
	["creature"]			= "classification",
	["short:druidform"]		= "classification",
	["druidform"]			= "classification",
	["curhp"]				= "health",
	["curpp"]				= "power",
	["curmaxhp"]			= "health",
	["curmaxpp"]			= "power",
	["levelcolor"]			= "classification",
	["def:name"]			= "health",
	["faction"]				= "classification",
	["colorname"]			= "misc",
	["guild"]				= "misc",
	["absolutepp"]			= "power",
	["absolutehp"]			= "health",
	["absmaxhp"]			= "health",
	["abscurhp"]			= "health",
	["absmaxpp"]			= "power",
	["abscurpp"]			= "power",
	["reactcolor"]			= "classification",
	["dechp"]				= "health",
	["group"]				= "misc",
	["close"]				= "misc",
	["druid:curpp"]         = "power",
	["druid:abscurpp"]      = "power",
	["druid:curmaxpp"]		= "power",
	["druid:absolutepp"]	= "power",
	["situation"]			= "playerthreat",
	["color:sit"]			= "playerthreat",
	["scaled:threat"]		= "playerthreat",
	["general:sit"]			= "playerthreat",
	["color:gensit"]		= "playerthreat",
	["color:aggro"]			= "playerthreat",
	["unit:scaled:threat"]	= "threat",
	["unit:color:sit"]		= "threat",
	["unit:situation"]		= "threat",
	["unit:color:aggro"]	= "threat",
	--[[
	["unit:raid:assist"]	= "raid",
	["unit:raid:targeting"] = "raid",
	]]
}

Tags.defaultHelps = {
}

Tags.defaultNames = {
	["incheal:name"]		= L["Incoming heal/Name"],
	["unit:scaled:threat"]	= L["Unit scaled threat"],
	["unit:color:sit"]		= L["Unit colored situation"],
	["unit:situation"]		= L["Unit situation name"],
	["hp:color"]			= L["Health color"],
	["guild"]				= L["Guild name"],
	["druidform"]			= L["Druid form"],
	["short:druidform"]		= L["Druid form (Short)"],
	["abs:incheal"]			= L["Incoming heal (Absolute)"],
	["incheal"]				= L["Incoming heal (Short)"],
	["abbrev:name"]			= L["Name (Abbreviated)"],
	["smart:curmaxhp"]		= L["Cur/Max HP (Smart)"],
	["smart:curmaxpp"]		= L["Cur/Max PP (Smart)"],
	["pvp:time"]			= L["PVP timer"],
	["afk:time"]			= L["AFK timer"],
	["status:time"]			= L["Offline timer"],
	["afk"]					= L["AFK status"],
	["cpoints"]				= L["Combo points"],
	["smartlevel"]			= L["Smart level"],
	["classification"]		= L["Classificaiton"],
	["shortclassification"]	= L["Short classification"],
	["rare"]				= L["Rare indicator"],
	["plus"]				= L["Short elite indicator"],
	["sex"]					= L["Sex"],
	["smartclass"]			= L["Class (Smart)"],
	["smartrace"]			= L["Race (Smart)"],
	["status"]				= L["Status"],
	["race"]				= L["Race"],
	["level"]				= L["Level"],
	["maxhp"]				= L["Max HP (Short)"],
	["maxpp"]				= L["Max power (Short)"],
	["missinghp"]			= L["Missing HP (Short)"],
	["missingpp"]			= L["Missing power (Short)"],
	["name"]				= L["Unit name"],
	["server"]				= L["Unit server"],
	["perhp"]				= L["Percent HP"],
	["perpp"]				= L["Percent power"],
	["class"]				= L["Class"],
	["classcolor"]			= L["Class color tag"],
	["creature"]			= L["Creature type"],
	["curhp"]				= L["Current HP (Short)"],
	["curpp"]				= L["Current Power (Short)"],
	["curmaxhp"]			= L["Cur/Max HP (Short)"],
	["curmaxpp"]			= L["Cur/Max Power (Short)"],
	["levelcolor"]			= L["Level (Colored)"],
	["def:name"]			= L["Deficit/Unit Name"],
	["faction"]				= L["Unit faction"],
	["colorname"]			= L["Unit name (Class colored)"],
	["absolutepp"]			= L["Cur/Max power (Absolute)"],
	["absolutehp"]			= L["Cur/Max HP (Absolute)"],
	["absmaxhp"]			= L["Max HP (Absolute)"],
	["abscurhp"]			= L["Current HP (Absolute)"],
	["absmaxpp"]			= L["Max power (Absolute)"],
	["abscurpp"]			= L["Current power (Absolute)"],
	["reactcolor"]			= L["Reaction color tag"],
	["dechp"]				= L["Decimal percent HP"],
	["group"]				= L["Group number"],
	["close"]				= L["Close color"],
	["druid:curpp"]         = L["Current power (Druid)"],
	["druid:abscurpp"]      = L["Current power (Druid/Absolute)"],
	["druid:curmaxpp"]		= L["Cur/Max power (Druid)"],
	["druid:absolutepp"]	= L["Current health (Druid/Absolute)"],
	["situation"]			= L["Threat situation"],
	["color:sit"]			= L["Color code for situation"],
	["scaled:threat"]		= L["Scaled threat percent"],
	["general:sit"]			= L["General threat situation"],
	["color:gensit"]		= L["Color code for general situation"],
	["color:aggro"]			= L["Color code on aggro"],
	["unit:color:aggro"]	= L["Unit color code on aggro"],
	--[=[
	["unit:raid:targeting"]	= L["Raid targeting unit"],
	["unit:raid:assist"]	= L["Raid assisting unit"],
	]=]
}

Tags.eventType = {
	["UNIT_POWER"] = "power",
	["UNIT_MAXPOWER"] = "power",
	["UNIT_HEALTH"] = "health",
	["UNIT_MAXHEALTH"] = "health",
	["RAID_ROSTER_UPDATE"] = "unitless",
	["RAID_TARGET_UPDATE"] = "unitless",
	["PLAYER_TARGET_CHANGED"] = "unitless",
	["PARTY_MEMBERS_CHANGED"] = "unitless",
	["PARTY_LEADER_CHANGED"] = "unitless",
	["PLAYER_ENTERING_WORLD"] = "unitless",
	["PLAYER_XP_UPDATE"] = "unitless",
	["PLAYER_TOTEM_UPDATE"] = "unitless",
	["PLAYER_LEVEL_UP"] = "unitless",
	["UPDATE_EXHAUSTION"] = "unitless",
	["PLAYER_UPDATE_RESTING"] = "unitless",
	["UNIT_COMBO_POINTS"] = "unitless",
}

Tags.unitBlacklist = {
	["threat"]	= "%w+target",
}

Tags.unitRestrictions = {
	["pvp:time"] = "player",	
}

local function loadAPIEvents()
	if( Tags.APIEvents ) then return end
	Tags.APIEvents = {
		["InCombatLockdown"]		= "PLAYER_REGEN_ENABLED PLAYER_REGEN_DISABLED",
		["UnitLevel"]				= "UNIT_LEVEL",
		["UnitName"]				= "UNIT_NAME_UPDATE",
		["UnitClassification"]		= "UNIT_CLASSIFICATION_CHANGED",
		["UnitFactionGroup"]		= "UNIT_FACTION PLAYER_FLAGS_CHANGED",
		["UnitHealth%("]			= "UNIT_HEALTH",
		["UnitHealthMax"]			= "UNIT_MAXHEALTH",
		["UnitPower%("]				= "UNIT_POWER",
		["UnitPowerMax"]			= "UNIT_MAXPOWER",
		["UnitPowerType"]			= "UNIT_DISPLAYPOWER",
		["UnitIsDead"]				= "UNIT_HEALTH",
		["UnitIsGhost"]				= "UNIT_HEALTH",
		["UnitIsConnected"]			= "UNIT_HEALTH UNIT_CONNECTION",
		["UnitIsAFK"]				= "PLAYER_FLAGS_CHANGED",
		["UnitIsDND"]				= "PLAYER_FLAGS_CHANGED",
		["UnitIsPVP"]				= "PLAYER_FLAGS_CHANGED UNIT_FACTION",
		["UnitIsPartyLeader"]		= "PARTY_LEADER_CHANGED PARTY_MEMBERS_CHANGED",
		["UnitIsPVPFreeForAll"]		= "PLAYER_FLAGS_CHANGED UNIT_FACTION",
		["UnitCastingInfo"]			= "UNIT_SPELLCAST_START UNIT_SPELLCAST_STOP UNIT_SPELLCAST_FAILED UNIT_SPELLCAST_INTERRUPTED UNIT_SPELLCAST_DELAYED",
		["UnitChannelInfo"]			= "UNIT_SPELLCAST_CHANNEL_START UNIT_SPELLCAST_CHANNEL_STOP UNIT_SPELLCAST_CHANNEL_INTERRUPTED UNIT_SPELLCAST_CHANNEL_UPDATE",
		["UnitAura"]				= "UNIT_AURA",
		["UnitBuff"]				= "UNIT_AURA",
		["UnitDebuff"]				= "UNIT_AURA",
		["UnitXPMax"]				= "UNIT_PET_EXPERIENCE PLAYER_XP_UPDATE PLAYER_LEVEL_UP",
		["UnitXP%("]				= "UNIT_PET_EXPERIENCE PLAYER_XP_UPDATE PLAYER_LEVEL_UP",
		["GetTotemInfo"]			= "PLAYER_TOTEM_UPDATE",
		["GetXPExhaustion"]			= "UPDATE_EXHAUSTION",
		["GetWatchedFactionInfo"]	= "UPDATE_FACTION",
		["GetRuneCooldown"]			= "RUNE_POWER_UPDATE",
		["GetRuneType"]				= "RUNE_TYPE_UPDATE",
		["GetRaidTargetIndex"]		= "RAID_TARGET_UPDATE",
		["GetComboPoints"]			= "UNIT_COMBO_POINTS",
		["GetNumPartyMembers"]		= "PARTY_MEMBERS_CHANGED",
		["GetNumRaidMembers"]		= "RAID_ROSTER_UPDATE",
		["GetRaidRosterInfo"]		= "RAID_ROSTER_UPDATE",
		["GetReadyCheckStatus"]		= "READY_CHECK READY_CHECK_CONFIRM READY_CHECK_FINISHED",
		["GetLootMethod"]			= "PARTY_LOOT_METHOD_CHANGED",
		["GetThreatStatusColor"]	= "UNIT_THREAT_SITUATION_UPDATE",
		["UnitThreatSituation"]		= "UNIT_THREAT_SITUATION_UPDATE",
		["UnitDetailedThreatSituation"] = "UNIT_THREAT_SITUATION_UPDATE",
	}
end

-- Scan the actual tag code to find the events it uses
local alreadyScanned = {}
function Tags:IdentifyEvents(code, parentTag)
	-- Already scanned this tag, prevents infinite recursion
	if( parentTag and alreadyScanned[parentTag] ) then
		return ""
	-- Flagged that we already took care of this
	elseif( parentTag ) then
		alreadyScanned[parentTag] = true
	else
		for k in pairs(alreadyScanned) do alreadyScanned[k] = nil end
		loadAPIEvents()
	end
			
	-- Scan our function list to see what APIs are used
	local eventList = ""
	for func, events in pairs(self.APIEvents) do
		if( string.match(code, func) ) then
			eventList = eventList .. events .. " " 
		end
	end
	
	local currentStyle = WSUF.db.profile.currentStyle;
	local currentStyleDB = WSUF:GetCurrentStyleDB(currentStyle);

	-- Scan if they use any tags, if so we need to check them as well to see what content is used
	for tag in string.gmatch(code, "tagFunc\.(%w+)%(") do
		local code
		if (WSUF.Tags.defaultTags[tag]) then
			code =WSUF.Tags.defaultTags[tag]
		elseif (currentStyleDB and currentStyleDB.tags[tag] and currentStyleDB.tags[tag].func) then
			code = WSUF.Tags.defaultTags[tag];
		elseif (WSUF.db.profile.tags[tag] and WSUF.db.profile.tags[tag].func) then
			code = WSUF.db.profile.tags[tag].func
		end
		eventList = eventList .. " " .. self:IdentifyEvents(code, tag)
	end
	
	-- Remove any duplicate events
	if( not parentTag ) then
		local tagEvents = {}
		for event in string.gmatch(string.trim(eventList), "%S+") do
			tagEvents[event] = true
		end
		
		eventList = ""
		for event in pairs(tagEvents) do
			eventList = eventList .. event .. " "
		end
	end
		
	-- And give them our nicely outputted data
	return string.trim(eventList or "")
end
