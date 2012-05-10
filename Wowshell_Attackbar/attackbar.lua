-----------------------------------------------------
--攻击记时条
--作者: 月色狼影
--$Rev: 2004 $
--$Date: 2009-04-20 10:03:24 +0800 (一, 2009-04-20) $
------------------------------------------------------
local attackBar = LibStub("AceAddon-3.0"):NewAddon("WSAttackbar", "AceEvent-3.0", "AceConsole-3.0");
WSAttackbar = attackBar;
local SM = LibStub("LibSharedMedia-3.0");
local L = wsLocale:GetLocale("Attackbar")
local GetTime = GetTime
local UnitGUID = UnitGUID
local mainHand, offHand, minDam, maxDam, minOffDam, maxOffDam, mainHandTime, offHandTime, perMainHandTime, perOffHandTime = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
local mainHandTimes, offHandTimes = 0, 0
local mainHandHandler, offHandHandler = 0, 0
local abs = math.abs

local backdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	tile = true,
	tileSize = 16,
	insets = {left = 5, right = 5, top = 5, bottom = 5},
}

local defaults = {
	profile = {
		texture = "BantoBar",
		playerbar = {
			enable = true,
			locked = false,
			--fix button
			showoffhand = true,--if u have off hand weapon 
			range = true, -- hunter
			timeSize = 12,
			spellSize = 12,
			delaySize = 14,
			width = 180,
			height = 8,
		},
		--[[enemybar = {
			enbale = true,
			locked = false,
			--fix 
			pvpShow = true, --show player
			showMob = true,--mob
		},]]
	},
}

local _order = 0
local function order()
	_order = _order + 1
	return _order
end

function attackBar:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("AttackbarDB", defaults, UnitName("player").." - "..GetRealmName())
	db = self.db.profile
	self:CreatePlayerAttackBar()

	self.options = {
		type = "group",
		name = L["攻击记时条"],
		desc = L["近战远程攻击记时条."],
		order = 5,
		args = {
			enable = {
				type = "toggle",
				name = L["启用近战/远程记时条"],
				desc = L["显示你武器攻击记时条"],
				order = order(),
				width = "full",
				get = function() return self.db.profile.playerbar.enable end,
				set = function(_, v)
					self.db.profile.playerbar.enable = v;
					if v then
						self:CreatePlayerAttackBar()
						--show anchor
						self.PlayerFrame:Show()
						self.db.profile.playerbar.locked = false
						self:UpdatePlayerMainHandBar()
						self:UpdatePlayerOffHandBar()
					else
						self.PlayerFrame:Hide()
						self:UpdatePlayerMainHandBar()
						self:UpdatePlayerOffHandBar()
					end
				end
			},
			locked = {
				type = "toggle",
				name = L["锁定"],
				desc = L["锁定记时条位置"],
				order = order(),
				get = function() return self.db.profile.playerbar.locked end,
				set = function(_, v)
					self.db.profile.playerbar.locked = v
					if v then
						self.PlayerFrame:Hide()
					else
						self.PlayerFrame:Show()
					end
				end
			},
			texture = {
				type = "select",
				name = L["材质"],
				desc = L["设置显示的材质"],
				order = order(),
				dialogControl = "LSM30_Statusbar",
				values = AceGUIWidgetLSMlists.statusbar,
				get = function() return self.db.profile.texture end,
				set = function(_, v)
					self.db.profile.texture = v
					self:UpdateMainBarLayout()
				end
			},
			width = {
				type = "range",
				name = L["长度"],
				desc = L["设定攻击记时条的长度"],
				order = order(),
				min = 20,
				max = 500,
				step = 2,
				get = function() return self.db.profile.playerbar.width end,
				set = function(_, v)
					self.db.profile.playerbar.width = v
					self:UpdateMainBarLayout()
				end
			},
			height = {
				type = "range",
				name = L["高度"],
				desc = L["设定攻击记时条的高度"],
				order = order(),
				min = 2,
				max = 20,
				step = 0.1,
				get = function() return self.db.profile.playerbar.height end,
				set = function(_, v)
					self.db.profile.playerbar.height = v
					self:UpdateMainBarLayout()
				end
			},
			fix = {
				type = "execute",
				name = L["修正计时时间"],
				desc = L["点击修正当前武器攻击时间"],
				order = order(),
				func = self:ResetAll(),
				width = "full",
			},
		}
	}
end

function attackBar:OnEnable()
	self:RegisterEvent("UNIT_ATTACK_SPEED");
	self:RegisterEvent("PLAYER_LEAVE_COMBAT");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function attackBar:OnDisable()
	self:UnregisterAllEvents();
	if self.PlayerFrame then
		self.PlayerFrame:Hide();
	end
end

function attackBar:UNIT_ATTACK_SPEED(event)
	self:ResetAll()
end

function attackBar:PLAYER_LEAVE_COMBAT(event)
	self:ResetAll()
end

function attackBar:COMBAT_LOG_EVENT_UNFILTERED(event, stm, cevent, hideCaster, sguid, sname, sflag, sourceRaidFlag, dguid, dname, dflag, destRaidFlags, ...)
	if sguid and dguid then
		if sguid == UnitGUID("player") and dguid == UnitGUID("playertarget") then
			if cevent == "SWING_DAMAGE" or cevent == "SWING_MISSED" then
				self:SwingHit()
				return
			elseif cevent == "RANGE_DAMAGE" or cevent == "RANGE_MISSED" then
				spellId, spellName = select(1, ...)
				--print(spellName);
				self:RangeUpdate(spellName)
				return
			end
		end
	end
end

function attackBar:ResetAll()
	mainHandTime, offHandTime, perMainHandTime, perOffHandTime = 0, 0 , 0, 0
	mainHandTimes, offHandTimes = 0, 0
	mainHandHandler, offHandHandler = 0, 0
end

--arg:
-- name: bar name
-- parentFrame: string
local function makeAttackBar(name, parentFrame)
	local bar = CreateFrame("StatusBar", "ws"..name.."Bar", UIParent);
	bar.Spark = bar:CreateTexture(nil, "OVERLAY")
	bar.Timer = bar:CreateFontString(nil, "OVERLAY");
	bar.Spell = bar:CreateFontString(nil, "OVERLAY");
	bar.Delay = bar:CreateFontString(nil, "OVERLAY");

	return bar
end

--name: (string) frame name
--frame.table 
local function makeBarFrame(name)
	local frame = CreateFrame("Frame", "ws"..name.."Frame", UIParent);
	frame:SetToplevel(true);
	frame:EnableMouse(true);
	frame:SetMovable(true);
	frame:SetWidth(206)
	frame:SetHeight(72);
	frame:SetBackdrop(backdrop);
	frame:SetBackdropColor(0.3, 0.3, 0.3, 1);
	frame:RegisterForDrag("LeftButton")
	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	text:SetPoint("TOP", 0, -5);
	frame.Title = text --show title

	frame:Show()
	return frame
end

function SavePosition(frame)
	local point, _, rpoint, x, y = frame:GetPoint()
	return point, rpoint, x, y
end

--adjux player
--update layou
function attackBar:CreatePlayerAttackBar()
	local gameFont = GameFontHighlightSmall:GetFont()
	local db = self.db.profile.playerbar
	if not self.PlayerFrame then
		self.PlayerFrame = makeBarFrame("Player")
	end
	self.PlayerFrame:SetScript("OnDragStart", function(self) 
		self:StartMoving();
	end)
	self.PlayerFrame:SetScript("OnDragStop", function(self) 
		self:StopMovingOrSizing() 
		local point, rpoint, x, y = SavePosition(self)
		local db = attackBar.db.profile.playerbar
		db.point, db.rpoint, db.x, db.y = point, rpoint, x, y
	end);
	self.PlayerFrame.Title:SetText(L["玩家武器记时条锚点"])

	if not db.x then
		db.x = 0
		db.y = 52
		db.rpoint = "CENTER"
		db.point = "CENTER"
	end

	self.PlayerFrame:SetPoint(db.point, UIParent, db.rpoint, db.x, db.y);

	if not self.PlayerFrame.MainBar then
		self.PlayerFrame.MainBar = makeAttackBar("MainBar", self.PlayerFrame);
	end

	self.PlayerFrame.MainBar:ClearAllPoints();
	self.PlayerFrame.MainBar:SetPoint("TOP", self.PlayerFrame, "TOP", 0, -20);
	if not db.width then
		db.width = 180
		db.height = 8
	end
	self.PlayerFrame.MainBar:SetWidth(db.width)
	self.PlayerFrame.MainBar:SetHeight(db.height)
	self.PlayerFrame.MainBar:SetStatusBarTexture(SM:Fetch("statusbar", self.db.profile.texture));

	self.PlayerFrame.MainBar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
	self.PlayerFrame.MainBar.Spark:SetWidth(16)
	self.PlayerFrame.MainBar.Spark:SetHeight(db.height * 2.44)
	self.PlayerFrame.MainBar.Spark:SetBlendMode("ADD");

	self.PlayerFrame.MainBar.Timer:SetJustifyH("RIGHT");
	self.PlayerFrame.MainBar.Timer:SetFont(gameFont, db.timeSize)
	self.PlayerFrame.MainBar.Timer:SetText("0.1");
	self.PlayerFrame.MainBar.Timer:ClearAllPoints()
	self.PlayerFrame.MainBar.Timer:SetPoint("RIGHT", self.PlayerFrame.MainBar, "RIGHT", -10, 0);
	self.PlayerFrame.MainBar.Timer:SetShadowColor(0, 0, 0, 1)
	self.PlayerFrame.MainBar.Timer:SetShadowOffset(0.8, -0.8);

	self.PlayerFrame.MainBar.Spell:SetJustifyH("CENTER");
	self.PlayerFrame.MainBar.Spell:SetWidth(db.width - self.PlayerFrame.MainBar.Timer:GetWidth())
	self.PlayerFrame.MainBar.Spell:SetFont(gameFont, db.spellSize);
	self.PlayerFrame.MainBar.Spell:SetText("Main Hand");
	self.PlayerFrame.MainBar.Spell:ClearAllPoints()
	self.PlayerFrame.MainBar.Spell:SetPoint("LEFT", self.PlayerFrame.MainBar, "LEFT", 10, 0)
	self.PlayerFrame.MainBar.Spell:SetShadowColor(0, 0, 0 ,1)
	self.PlayerFrame.MainBar.Spell:SetShadowOffset(0.8, -0.8);

	--[[self.PlayerFrame.MainBar.Delay:SetJustifyH("RIGHT");
	self.PlayerFrame.MainBar.Delay:SetFont(gameFont, db.delaySize)
	self.PlayerFrame.MainBar.Delay:SetTextColor(1, 0, 0, 1);
	self.PlayerFrame.MainBar.Delay:SetText("0.2");
	self.PlayerFrame.MainBar.Delay:ClearAllPoints();
	self.PlayerFrame.MainBar.Delay:SetPoint("TOPRIGHT", self.PlayerFrame.MainBar, "TOPRIGHT", -5, 10)
	self.PlayerFrame.MainBar.Delay:SetShadowColor(0, 0, 0, 1)
	self.PlayerFrame.MainBar.Delay:SetShadowOffset(0.8, -0.8)
	self.PlayerFrame.MainBar.Delay:Hide();]]

	-- off bar
	if not self.PlayerFrame.OffBar then
		self.PlayerFrame.OffBar = makeAttackBar("MainBar", self.PlayerFrame);
	end

	self.PlayerFrame.OffBar:ClearAllPoints();
	self.PlayerFrame.OffBar:SetPoint("TOP", self.PlayerFrame.MainBar, "BOTTOM", 0, -10);
	if not db.width then
		db.width = 180
		db.height = 15
	end
	self.PlayerFrame.OffBar:SetWidth(db.width)
	self.PlayerFrame.OffBar:SetHeight(db.height)
	self.PlayerFrame.OffBar:SetStatusBarTexture(SM:Fetch("statusbar", self.db.profile.texture));

	self.PlayerFrame.OffBar.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
	self.PlayerFrame.OffBar.Spark:SetWidth(16)
	self.PlayerFrame.OffBar.Spark:SetHeight(db.height * 1.86)
	self.PlayerFrame.OffBar.Spark:SetBlendMode("ADD");

	self.PlayerFrame.OffBar.Timer:SetJustifyH("RIGHT");
	self.PlayerFrame.OffBar.Timer:SetFont(gameFont, db.timeSize)
	self.PlayerFrame.OffBar.Timer:SetText("0.1");
	self.PlayerFrame.OffBar.Timer:ClearAllPoints()
	self.PlayerFrame.OffBar.Timer:SetPoint("RIGHT", self.PlayerFrame.OffBar, "RIGHT", -10, 0);
	self.PlayerFrame.OffBar.Timer:SetShadowColor(0, 0, 0, 1)
	self.PlayerFrame.OffBar.Timer:SetShadowOffset(0.8, -0.8);

	self.PlayerFrame.OffBar.Spell:SetJustifyH("CENTER");
	self.PlayerFrame.OffBar.Spell:SetWidth(db.width - self.PlayerFrame.OffBar.Timer:GetWidth())
	self.PlayerFrame.OffBar.Spell:SetFont(gameFont, db.spellSize);
	self.PlayerFrame.OffBar.Spell:SetText("Off Hand");
	self.PlayerFrame.OffBar.Spell:ClearAllPoints()
	self.PlayerFrame.OffBar.Spell:SetPoint("LEFT", self.PlayerFrame.OffBar, "LEFT", 10, 0)
	self.PlayerFrame.OffBar.Spell:SetShadowColor(0, 0, 0 ,1)
	self.PlayerFrame.OffBar.Spell:SetShadowOffset(0.8, -0.8);

	--out
	if not self.db.profile.playerbar.enable then
		self.PlayerFrame:Hide()
	end
	if self.db.profile.playerbar.locked then
		self.PlayerFrame:Hide()
	end
	self.PlayerFrame.MainBar:Hide()
	self.PlayerFrame.MainBar.Spark:Hide()
	self.PlayerFrame.MainBar.Timer:Hide()
	self.PlayerFrame.MainBar.Spell:Hide()
	self.PlayerFrame.OffBar:Hide()
	self.PlayerFrame.OffBar.Spark:Hide()
	self.PlayerFrame.OffBar.Timer:Hide()
	self.PlayerFrame.OffBar.Spell:Hide()

	self:UpdateMainBarLayout()
end

--[[
global arg:
mainHand
offHand
minDam
maxDam
minOffDam
maxOffDam
mainHandTime
offHandTime
perMainHandTime --last main hand
perOffHandTime --last offhand
mainHandTimes --
offHandTimes
]]

function attackBar:UpdateMainBarLayout()
	if not self.PlayerFrame.MainBar then return end
	local db = self.db.profile.playerbar
	self.PlayerFrame.MainBar:SetWidth(db.width)
	self.PlayerFrame.MainBar:SetHeight(db.height)
	self.PlayerFrame.MainBar:SetStatusBarTexture(SM:Fetch("statusbar", self.db.profile.texture));
	self.PlayerFrame.OffBar:SetWidth(db.width)
	self.PlayerFrame.OffBar:SetHeight(db.height)
	self.PlayerFrame.OffBar:SetStatusBarTexture(SM:Fetch("statusbar", self.db.profile.texture));
	self.PlayerFrame.MainBar.Spark:SetHeight(db.height * 2.44)
	self.PlayerFrame.OffBar.Spark:SetHeight(db.height * 1.86)
end

function attackBar:SwingHit()
	mainHand, offHand = UnitAttackSpeed("player");
	minDam, maxDam, minOffDam, maxOffDam, phyPos, phyNeg, percent = UnitDamage("player");
	minDam, maxDam = minDam - mod(minDam, 1), maxDam - mod(maxDam, 1);

	if maxOffDam then
		maxOffDam, minOffDam = maxOffDam - mod(maxOffDam, 1), minOffDam - mod(minOffDam, 1);
	end

	if offHand then
		mainHandTime, offHandTime = GetTime(), GetTime();
		if ((abs((mainHandTime - perMainHandTime) - mainHand) <= abs((offHandTime - perOffHandTime) - offHand)) and not (mainHandHandler <= offHand/mainHand)) or offHandHandler >= mainHand/offHand then
			if perOffHandTime == 0 then perOffHandTime = offHandTime end
			perMainHandTime = mainHandHandler
			currentMainHand = mainHand
			offHandHandler = 0
			mainHandHandler = mainHandHandler + 1
			mainHand = mainHand - mod(mainHand, 0.1);
			self:UpdatePlayerMainHandBar(currentMainHand, L["主手攻击"], 0, 0.2, 0.92)
			--print(currentMainHand)
			--print("main")
		else
			perOffHandTime = offHandTime
			offHandHandler = offHandHandler + 1
			mainHandHandler = 0
			minOffDam, maxOffDam = minOffDam - mod(minOffDam, 1), maxOffDam - mod(maxOffDam, 1);
			offHand = offHand - mod(offHand, 0.1);
			self:UpdatePlayerOffHandBar(offHand, L["副手攻击"], 0, 0.2, 0.92)
		end
	else
		mainHandTime = GetTime()
		currentMainHand = mainHand
		mainHand = mainHand - mod(mainHand, 0.1);
		self:UpdatePlayerMainHandBar(mainHand, L["自动攻击"], 0, 0.2, 0.92)
	end
end

function attackBar:UpdatePlayerMainHandBar(barTime, text, r, g, b)
	if not self.db.profile.playerbar.enable then return end
	if not barTime then return end
	self.PlayerFrame.MainBar:Hide()
	if text then
		self.PlayerFrame.MainBar.Spell:SetText(text);
		self.PlayerFrame.MainBar.Spell:Show()
	end
	local startTime = GetTime()
	local endTime = GetTime() + barTime
	self.PlayerFrame.MainBar:SetStatusBarColor(r, g, b);
	self.PlayerFrame.MainBar:SetMinMaxValues(startTime, endTime);
	self.PlayerFrame.MainBar:SetValue(startTime);
	
	self.PlayerFrame.MainBar:SetScript("OnUpdate", function(self) 
		local currentTimer = GetTime()
		local left = (endTime - currentTimer) - mod((endTime - currentTimer), 0.1);
		self.Timer:SetText(left);
		self.Timer:Show();
		self:SetValue(currentTimer);
		self.Spark:SetPoint("CENTER", self, "LEFT", (currentTimer - startTime)/(endTime - startTime)*(attackBar.db.profile.playerbar.width), 2);
		if currentTimer >= endTime then
			self:Hide()
			self.Spark:SetPoint("CENTER", self, "LEFT", attackBar.db.profile.playerbar.width, 2)
		end
	end)
	self.PlayerFrame.MainBar:Show()
end

function attackBar:UpdatePlayerOffHandBar(barTime, text, r, g, b)
	if not self.db.profile.playerbar.enable then return end
	if not barTime then return end
	self.PlayerFrame.OffBar:Hide()
	if text then
		self.PlayerFrame.OffBar.Spell:SetText(text)
		self.PlayerFrame.OffBar.Spell:Show()
	end

	local startTime = GetTime()
	local endTime = GetTime() + barTime
	self.PlayerFrame.OffBar:SetStatusBarColor(r, g, b);
	self.PlayerFrame.OffBar:SetMinMaxValues(startTime, endTime);
	self.PlayerFrame.OffBar:SetValue(startTime);

	self.PlayerFrame.OffBar:SetScript("OnUpdate", function(self)
		local current = GetTime();
		local left = (endTime - current) - mod((endTime - current), 0.1);
		self.Timer:SetText(left);
		self.Timer:Show();
		self:SetValue(current);
		self.Spark:SetPoint("CENTER", self, "LEFT", (current - startTime)/(endTime - startTime)*(attackBar.db.profile.playerbar.width), 2);
		if current >= endTime then
			self:Hide()
			self.Spark:SetPoint("CENTER", self, "LEFT", attackBar.db.profile.playerbar.width, 2)
		end
	end);

	self.PlayerFrame.OffBar:Show()
end

function attackBar:RangeUpdate(spellName)
	if not self.db.profile.playerbar.range then return end
	local rspeed, rminDam, rmaxDam = UnitRangedDamage("player");
	rminDam, rmaxDam = rminDam - mod(rminDam, 1), rmaxDam - mod(rmaxDam, 1)

	lastrspeed = rspeed
	rspeed = rspeed - mod(rspeed, 0.1);
	self:UpdatePlayerMainHandBar(rspeed, spellName, 1, 0.5, 0)
end
