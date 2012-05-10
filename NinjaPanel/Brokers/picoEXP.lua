if UnitLevel'player' == MAX_PLAYER_LEVEL then return end


local L = setmetatable( GetLocale() == 'zhCN' and {
    ["EXP:"] = '经验:',
    ["Rest:"] = '休息:',
    ["TNL:"] = '剩余经验:',
    ["%.2f hours played this session"] = '本次连接已进行 %.2f 个小时',
    [" EXP gained this session"] = ' 经验在本次连接中获得',
    ["%.2f levels gained this session"] = '本次连接获得 %.2f 等级',
} or GetLocale() == 'zhTW' and {
    ["EXP:"] = '經驗:',
    ["Rest:"] = '休息:',
    ["TNL:"] = '剩餘經驗:',
    ["%.2f hours played this session"] = '本次連接已進行 %.2f 個小時',
    [" EXP gained this session"] = ' 經驗在本次連接中獲得',
    ["%.2f levels gained this session"] = '本次連接獲得 %.2f 等級',
} or {}, { __index = function(t, i)
    t[i] = i
    return i
end})

------------------------------
--      Are you local?      --
------------------------------

local start, cur, max, starttime, startlevel


-------------------------------------------
--      Namespace and all that shit      --
-------------------------------------------

local f = CreateFrame("frame")
f:SetScript("OnEvent", function(self, event, ...) if self[event] then return self[event](self, event, ...) end end)
local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("picoEXP", {type = "data source", text = "99%", icon = "Interface\\AddOns\\NinjaPanel\\Brokers\\picoEXP"})


----------------------
--      Enable      --
----------------------


function f:PLAYER_LOGIN()
	start, max, starttime = UnitXP("player"), UnitXPMax("player"), GetTime()
	cur = start
	startlevel = UnitLevel("player") + start/max

	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("PLAYER_LEVEL_UP")

	self:PLAYER_XP_UPDATE()

	self:UnregisterEvent("PLAYER_LOGIN")
	self.PLAYER_LOGIN = nil
end


------------------------------
--      Event Handlers      --
------------------------------

function f:PLAYER_XP_UPDATE()
	cur = UnitXP("player")
	max = UnitXPMax("player")
	dataobj.text = string.format("%d%%", cur/max*100)
end


function f:PLAYER_LEVEL_UP()
	start = start - max
end


------------------------
--      Tooltip!      --
------------------------

local function GetTipAnchor(frame)
	local x,y = frame:GetCenter()
	if not x or not y then return "TOPLEFT", "BOTTOMLEFT" end
	local hhalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
	local vhalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
	return vhalf..hhalf, frame, (vhalf == "TOP" and "BOTTOM" or "TOP")..hhalf
end


function dataobj.OnLeave() GameTooltip:Hide() end
function dataobj.OnEnter(self)
 	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint(GetTipAnchor(self))
	GameTooltip:ClearLines()

	GameTooltip:AddLine("picoEXP")

	GameTooltip:AddDoubleLine(L["EXP:"], cur.."/"..max, nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["Rest:"], string.format("%d%%", (GetXPExhaustion() or 0)/max*100), nil,nil,nil, 1,1,1)
	GameTooltip:AddDoubleLine(L["TNL:"], max-cur, nil,nil,nil, 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f hours played this session"], (GetTime()-starttime)/3600), 1,1,1)
	GameTooltip:AddLine((cur - start)..L[" EXP gained this session"], 1,1,1)
	GameTooltip:AddLine(string.format(L["%.2f levels gained this session"], UnitLevel("player") + cur/max - startlevel), 1,1,1)

	GameTooltip:Show()
end

if IsLoggedIn() then f:PLAYER_LOGIN() else f:RegisterEvent("PLAYER_LOGIN") end
