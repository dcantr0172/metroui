-----------------------------------------------------
--施放条增强
--作者: 月色狼影
------------------------------------------------------

local addon = LibStub("AceAddon-3.0"):NewAddon("CastBar", "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0");
WSCastingBar = addon
local L = wsLocale:GetLocale("WSCastbar")
local SM = LibStub("LibSharedMedia-3.0")
local castingInfo = {}
local CastingBarTimer_DisplayString = " (%0.1f)";
local channelDelay = "|cffff2020%-.2f|r"
local castDelay = "|cffff2020%.2f|r"

local db, sendTime, timeDiff;
local GetTime = GetTime;
local defaults = {
	profile = {
		showTime = true,
		delayTime = true,
		showTargetCastBar = true,
		castTime = true,
		texture = "Blizzard",
		width = 195,
		height = 13,
		showIcon = false,
		iconPoisition = "left",
		hideBlzBorder = false,
		Showinfo = {
			fontsize = 23,
			fonttype = "Friz Quadrata TT",
			fontstyle = "OUTLINE",
			framefade = 0.5,
		},
	}
}

local optGetter, optSetter
do
	function optGetter(info)
		local key = info[#info]
		return db[key]
	end

	function optSetter(info, v)
		local key = info[#info]
		db[key] = v;
		addon:UpdateBlzCastingFrame();
	end
end

local __order = 0;
local function order()
	__order = __order + 1;
	return __order
end

local options
local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["施法条增强"],
			desc = L["显示施法时间,改变施法材质"],
			args = {
				movable = {
					type = "toggle",
					name = L["移动施法条"],
					order = order(),
					get = function()
						return addon.moveable;
					end,
					set = function()
						addon:UpdateCastingPosition();
					end
				},
				showTime = {
					name = L["施法时间"],
					type = "toggle",
					desc = L["增强wow自带施法条,增加施法时间"],
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				delayTime = {
					name = L["延迟"],
					type = "toggle",
					desc = L["在施法条上显示施法延迟时间"],
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				showTargetCastBar = {
					name = L["开启目标施法条"],
					type = "toggle",
					desc = L["开启wow系统自身目标施法条"],
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				castTime = {
					name = L["切换正反计时"],
					type = "toggle",
					desc = L["此功能只对施法类法术有效, 计时模式有两种,正计时从0开始递增, 反计时则从法术时间往0进行递减.默认是递增"],
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				hideBlzBorder = {
					name = L["隐藏暴雪样式边框"],
					type = "toggle",
					desc = L["隐藏暴雪样式边框材质."],
					order = order(),
					get = optGetter,
					set = optSetter
				},
				showIcon = {
					name = L["显示技能图标"],
					type = "toggle",
					desc = L["显示当前正在施法技能的图标"],
					order = order(),
					get = optGetter,
					set = optSetter
				},
				iconPoisition = {
					name = L["图标位置"],
					order = order(),
					type = "select",
					values = {left = L["左边"], right = L["右边"]},
					get = optGetter,
					set = optSetter
				},
				width = {
					name = L["宽度"],
					type = "range",
					min = 50, max = 500, step = 1,
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				height = {
					name = L["高度"],
					type = "range",
					min = 10, max = 30, step = 1,
					order = order(),
					get = optGetter,
					set = optSetter,
				},
				texture = {
					type = "select",
					order = order(),
					name = L["材质"],
					desc = L["设定施法条材质"],
					dialogControl = "LSM30_Statusbar",
					values = AceGUIWidgetLSMlists.statusbar,
					get = optGetter,
					set = optSetter,
				},
			},
		}
	end
	return options
end


function addon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("CastbarDB", defaults, UnitName("player").." - "..GetRealmName())
	db = self.db.profile

	self:UpdateBlzCastingFrame();
	
	self.options = getOptions();
	self.playerName = UnitName("player");
end

function addon:OnEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SENT");
	self:RegisterEvent("UNIT_SPELLCAST_START");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
	self:RegisterEvent("UNIT_SPELLCAST_FAILED");
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	self:RegisterEvent("UNIT_SPELLCAST_STOP", "SpellOther");
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", "SpellOther");
	--self:RegisterEvent('UNIT_SPELLCAST_SUCCEEDED');
	
	self:UpdateCastingPosition();
	self.moveable = true;
	self:UpdateCastingPosition();
	
	self:SecureHook("CastingBarFrame_OnUpdate");

	delayTimeText = CastingBarFrame:CreateFontString(nil, "ARTWORK");
	delayTimeText:SetPoint("TOPRIGHT", CastingBarFrame, "TOPRIGHT", 0, 20);
	delayTimeText:SetFont(SM:Fetch("font", addon.db.profile.Showinfo.fonttype), 12, addon.db.profile.Showinfo.fontstyle);

	--创建一个延迟条
	if not self.delayBar then
		self.delayBar = CastingBarFrame:CreateTexture("StatusBar", "BACKGROUND");
		self.delayBar:SetHeight(CastingBarFrame:GetHeight());
		self.delayBar:SetTexture(SM:Fetch("statusbar", db.texture))
		self.delayBar:SetVertexColor(0.8, 0, 0, 0.8)
		self.delayBar:Hide()
	end

	if (db.showTargetCastBar) then
		if (GetCVar("ShowTargetCastbar") ~= 1) then
			SetCVar("ShowTargetCastbar", 1)
		end
	else
		SetCVar("ShowTargetCastbar", 0)
	end
	self:UpdateBlzCastingFrame();
end

function addon:CreateCustomParent()
	self.parent = CreateFrame("Frame", nil, UIParent);
	self.parent:SetPoint(CastingBarFrame:GetPoint());
	self.parent:SetWidth(CastingBarFrame:GetWidth());
	self.parent:SetHeight(CastingBarFrame:GetHeight());
	self.parent:SetMovable(true)
	self.parent:EnableMouse(true);
	self.parent:EnableKeyboard(true);
	CastingBarFrame:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 8,
		insets = {
			bottom = 5,
			left = 5,
			right = 5,
			top = 5
		},
		tileSize = 8
	})
	CastingBarFrame:SetBackdropColor(0, 0, 0, 0);
	CastingBarFrame:SetBackdropBorderColor(0, 0, 0);

	local mover = CreateFrame("Button", nil, UIParent);
	mover:EnableMouse(true);
	mover:SetMovable(true);
	mover:SetWidth(self.parent:GetWidth())
	mover:SetHeight(self.parent:GetHeight() + 10);
	mover:SetClampedToScreen(true);
	mover:RegisterForDrag("LeftButton")
	mover:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 16,
		insets = {
			bottom = 5,
			left = 5,
			right = 5,
			top = 5
		},
		tileSize = 8
	});
	mover:SetBackdropBorderColor(0, 0, 0, 0);
	mover:SetBackdropColor(0, 1, 0.2, 0.7);
	mover.parent = self.parent;
	self.parent.mover = mover;

	local txt = mover:CreateFontString(nil, "OVERLAY");
	txt:SetPoint("CENTER", mover, "CENTER", 0, 0);
	txt:SetFontObject(ChatFontNormal);
	txt:SetText(L["点击拖动, 双击锁定"])
	mover.txt = txt;
	mover:Hide();
	txt:Hide();
end

function addon:UpdateBlzCastingFrame()
	if not self.parent then
		self:CreateCustomParent();
	end

	self.parent:SetWidth(db.width);
	self.parent:SetHeight(db.height);
	self.parent.mover:SetWidth(db.width);
	self.parent.mover:SetHeight(db.height);

	local bg,spell,border,icon,spark,flash = CastingBarFrame:GetRegions()
	local castBar = CastingBarFrame;
	
	CastingBarFrame:SetWidth(db.width);
	CastingBarFrame:SetHeight(db.height);
	if self.delayBar then
		self.delayBar:SetHeight(db.height);
	end

	CastingBarFrame.border:SetWidth(db.width*1.33)
	CastingBarFrame.border:SetHeight(db.height*6)
	CastingBarFrameFlash:SetWidth(db.width*1.33);
	CastingBarFrameFlash:SetHeight(db.height * 6)

	CastingBarFrame.text:ClearAllPoints();
	CastingBarFrame.text:SetPoint("CENTER",CastingBarFrame)
	CastingBarFrame.border:SetPoint("TOP",CastingBarFrame, 0, CastingBarFrame:GetHeight()*2.5)
	CastingBarFrameFlash:SetPoint("TOP",CastingBarFrame, 0, CastingBarFrame:GetHeight()*2.5)

	if db.position then
		UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil;
		local position = db.position
		local rel = UIParent;
		local p = db.position["p"]
		local relp = db.position["relp"]
		local x = db.position["x"]
		local y = db.position["y"]
		self.parent:SetPoint( p, rel, relp, x , y);
	end

	CastingBarFrame:HookScript("OnShow", function()
		local _redix = db.hideBlzBorder and 5 or 0;

		if db.iconPoisition == "left" then
			castBar.icon:SetPoint("RIGHT", CastingBarFrame, "LEFT", (-5 + _redix) , 0);
		elseif db.iconPoisition == "right" then
			castBar.icon:SetPoint("RIGHT", CastingBarFrame, "RIGHT", (db.height - _redix), 0);
		end

		if db.showIcon then
			castBar.icon:Show();
			castBar.icon:SetSize(db.height, db.height);
			castBar.icon:SetTexCoord(.08, .92, .08, .92);
		else
			castBar.icon:Hide();
		end

		CastingBarFrame:ClearAllPoints();
		CastingBarFrame:SetParent(self.parent);
		CastingBarFrame:SetPoint(self.parent:GetPoint())

		if (db.hideBlzBorder) then
			castBar.border:Hide();
			CastingBarFrameFlash:Hide();
		else
			castBar.border:Show();
			CastingBarFrameFlash:Show();
		end
	end);
	
	CastingBarFrame:HookScript("OnEvent", function(f, event, ...)
		if (db.hideBlzBorder) then
			castBar.border:Hide();
			CastingBarFrameFlash:Hide();
		else
			castBar.border:Show();
			CastingBarFrameFlash:Show();
		end
	end)

	CastingBarFrame:SetStatusBarTexture(SM:Fetch("statusbar", db.texture))
end

function addon:UpdateCastingPosition()
	local parent = self.parent;
	local mover = parent.mover;

	mover:SetScript("OnEnter", function(self)
		self:SetBackdropBorderColor(0.8, 0.35, 0.5, 1)
	end)
	mover:SetScript("OnLeave", function(self)
		self:SetBackdropBorderColor(0, 0, 0, 0)
	end)
	mover:SetScript("OnDoubleClick", function(self)
		addon:UpdateCastingPosition()
	end)
	mover:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end);

	mover:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		parent:SetPoint(self:GetPoint());
		if not db.position then
			db.position = {}
		end
		wipe(db.position);--clean
		local p, rel,relp,x,y= mover:GetPoint()
		db.position = {
			p = p,
			relp = relp,
			x = x,
			y = y
		}
	end)

	--锁定
	if self.moveable then
		mover:Hide();
		mover.txt:Hide();
		parent:Show();
		parent:ClearAllPoints();
		local p, rel,relp,x,y= mover:GetPoint()
		parent:SetPoint(p, rel,relp,x,y);
		--保存移动位置
		if not db.position then
			db.position = {}
		end
		wipe(db.position);--clean
		db.position = {
			p = p,
			relp = relp,
			x = x,
			y = y
		}
	else--移动
		mover:SetFrameStrata("TOOLTIP");
		mover:ClearAllPoints();
		mover:SetPoint(parent:GetPoint());
		mover:Show()
		mover.txt:Show();
		parent:Hide();
	end
	
	self:UpdateBlzCastingFrame();
	self.moveable = not self.moveable;
end

--[[        EVENTS     ]]

function addon:UNIT_SPELLCAST_SENT(event, unit, spell, rank, target)
	if unit ~= 'player' then
		return
	end
	--if self.casting then return end
	if target then
		self.targetName = target;
	else
		self.targetName = self.playerName;
	end
	if self.casting == nil then
		self.sendTime = GetTime()
	else
		self.sendTime = self.endTime
	end
end

function addon:UNIT_SPELLCAST_START(event, unit,...)
	if unit ~= 'player' then
		return
	end
	local _, _, text,_,startTime, endTime = UnitCastingInfo(unit)
	self.startTime = startTime / 1000;
	self.endTime = endTime/1000;
	self.delay = 0
	self.casting = true
	self.channeling = nil
	self.fadeOut = nil

	castingInfo[unit] = text..CastingBarTimer_DisplayString;

	if not self.sendTime then return end
	self.timeDiff = GetTime() - self.sendTime;
	local castlength = endTime - startTime
	self.timeDiff = self.timeDiff > castlength and castlength or self.timeDiff
end

function addon:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	if unit ~="player" or not self.sendTime then return end
	local _, _, text,_,startTime,endTime = UnitChannelInfo(unit)
	
	startTime = startTime / 1000
	endTime = endTime / 1000

	self.startTime = startTime;
	self.endTime = endTime;
	self.delay = 0

	self.casting = nil
	self.channeling = true
	self.fadeOut = nil

	castingInfo[unit] = text..CastingBarTimer_DisplayString;

	self.timeDiff = GetTime() - self.sendTime;
	local castlength = endTime - startTime
	self.timeDiff = self.timeDiff > castlength and castlength or self.timeDiff
end

function addon:PLAYER_TARGET_CHANGED()
	if unit ~= 'player' then
		return
	end
	local _, _, text = UnitCastingInfo("target");
	if not (text) then
		_, _, text = UnitChannelInfo("target");
	end
	if (text) then
		castingInfo["target"] = text..CastingBarTimer_DisplayString;
	else
		castingInfo["target"] = nil;
	end
end

function addon:UNIT_SPELLCAST_DELAYED(event, unit)
	if unit ~= "player" then return end
	local oldStart = self.startTime
	local _,_,text,_,startTime,endTime = UnitCastingInfo(unit)
	if not startTime then self.delay = 0 return end
	
	startTime = startTime/1000
	endTime = endTime/1000
	self.startTime = startTime
	self.endTime = endTime
	self.delay = (self.delay or 0) + (startTime - (oldStart or startTime))
end

function addon:UNIT_SPELLCAST_CHANNEL_UPDATE(event, unit)
	if unit ~= "player" then return end

	local oldStart = self.startTime;
	local _, _, text, _, startTime, endTime = UnitChannelInfo(unit);

	if (not startTime) then self.delay = 0 return end
	startTime = startTime/1000
	endTime = endTime/1000
	self.startTime = startTime
	self.endTime = endTime

	self.delay = (self.delay or 0) + ((oldStart or startTime) - startTime);
end

function addon:SpellOther(event, unit)
	if unit ~="player" then return end
	castingInfo[unit] = nil
	if event == "UNIT_SPELLCAST_STOP" then
		if self.casting then
			self.targetName = nil
			self.casting = nil
			self.fadeOut = true
			self.stopTime = GetTime()
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		if self.channeling then
			self.channeling = nil
			self.fadeOut = true
			self.stopTime = GetTime()
		end
	end
end

function addon:UNIT_SPELLCAST_FAILED(event, unit)
	if unit ~= "player" or self.channeling or self.casting then return end
	self.targetName = nil
	self.casting = nil
	self.channeling = nil
	self.fadeOut = true
	if not self.stopTime then
		self.stopTime = GetTime()
	end
end

function addon:UNIT_SPELLCAST_INTERRUPTED(event, unit)
	if unit ~= "player" then return end
	self.targetName = nil
	self.casting = nil
	self.channeling = nil
	self.fadeOut = true
	if not self.stopTime then
		self.stopTime = GetTime()
	end
end


----- END  ----

function addon:CastingBarFrame_OnUpdate(frame, elapsed, ...)
	if frame.unit ~= "player" then return end

	local currentTime = GetTime();
	local startTime = self.startTime;
	local endTime = self.endTime
	local delay = self.delay
	local timeLeft;
	
	if (self.casting) then
		if currentTime > endTime then
			self.casting = nil
			self.fadeOut = true
			self.stopTime = currentTime
			return
		end
		--显示实际施法时间.
		local showTime = math.min(currentTime, endTime)
		if (db.castTime) then
			timeLeft = max((showTime - startTime), 0);
		else
			timeLeft = (endTime - showTime);
		end
	elseif(self.channeling) then
		if currentTime > endTime then
			self.channeling = nil
			self.fadeOut = true
			self.stopTime = currentTime
			return
		end
		timeLeft = max((endTime - currentTime), 0);
	end
	
	if (timeLeft) then
		local textDisplay = getglobal(frame:GetName().."Text");
		timeleft = (timeLeft < 0.1) and 0.01 or timeLeft;
		local displayName = castingInfo[frame.unit];

		if not (displayName) then
			local _, text;
			if ( self.casting ) then
				_, _, text = UnitCastingInfo(frame.unit);
			elseif ( self.channeling ) then
				_, _, text = UnitChannelInfo(frame.unit);
			end
			if (text) then
				displayName = text..CastingBarTimer_DisplayString
				castingInfo[CastingBarFrame.unit] = displayName;
			else
				displayName = (textDisplay:GetText() or "")..CastingBarTimer_DisplayString
			end
		end
		
		if (db.showTime) then
			if (self.casting) then
				textDisplay:SetText(format(displayName, timeLeft))
			elseif (self.channeling) then
				textDisplay:SetText(format(displayName, timeLeft))
			end
		end
	end

	if (self.timeDiff and db.delayTime) then
		if (self.casting) then
			local modulus = math.abs(self.timeDiff)/frame.maxValue
			if modulus > 1 then
				modulus = 1
			elseif modulus < 0 then
				modulus = 0
			end
			self.delayBar:SetPoint("RIGHT", frame, "RIGHT",  0, 0)
			self.delayBar:SetWidth(frame:GetWidth() * modulus);
			self.delayBar:Show();
			delayTimeText:SetText(L["延迟 "].."|cffff2020+|r".. format(castDelay,math.abs(self.timeDiff)));
		elseif (self.channeling) then
			self.delayBar:Hide()
			delayTimeText:SetText(L["延迟 "].."|cffff2020-|r"..format(channelDelay, self.timeDiff));
		end
	end
end
