--[[
	Dominos.lua
		Driver for Dominos Frames
--]]

Dominos = LibStub('AceAddon-3.0'):NewAddon('Dominos', 'AceEvent-3.0', 'AceConsole-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('Dominos')
local CURRENT_VERSION = GetAddOnMetadata('Dominos', 'Version')


--[[ Startup ]]--

function Dominos:OnInitialize()
	--register database events
	self.db = LibStub('AceDB-3.0'):New('DominosDB', self:GetDefaults(), UnitClass('player'))
	self.db.RegisterCallback(self, 'OnNewProfile')
	self.db.RegisterCallback(self, 'OnProfileChanged')
	self.db.RegisterCallback(self, 'OnProfileCopied')
	self.db.RegisterCallback(self, 'OnProfileReset')
	self.db.RegisterCallback(self, 'OnProfileDeleted')

	--version update
	if DominosVersion then
		if DominosVersion ~= CURRENT_VERSION then
			self:UpdateSettings(DominosVersion:match('(%w+)%.(%w+)%.(%w+)'))
			self:UpdateVersion()
		end
	--new user
	else
		DominosVersion = CURRENT_VERSION
	end

	--slash command support
	self:RegisterSlashCommands()

	--create a loader for the options menu
	local f = CreateFrame('Frame', nil, InterfaceOptionsFrame)
	f:SetScript('OnShow', function(self)
		self:SetScript('OnShow', nil)
		LoadAddOn('Dominos_Config')
	end)

	--keybound support
	local kb = LibStub('LibKeyBound-1.0')
	kb.RegisterCallback(self, 'LIBKEYBOUND_ENABLED')
	kb.RegisterCallback(self, 'LIBKEYBOUND_DISABLED')

	--button facade support
	local LBF = LibStub('LibButtonFacade', true)
	if LBF then
		LBF:RegisterSkinCallback('Dominos', self.OnSkin, self)
	end
end

function Dominos:OnEnable()
	self:HideBlizzard()
	self:Load()

	if LibStub:GetLibrary('LibDataBroker-1.1', true) then
		self:LoadDataBrokerPlugin()
	end
end

function Dominos:LoadDataBrokerPlugin()
	LibStub:GetLibrary('LibDataBroker-1.1'):NewDataObject('Dominos', {
		type = 'launcher',

		icon = 'Interface\\Addons\\Dominos\\Dominos',

		OnClick = function(_, button)
			if button == 'LeftButton' then
				if IsShiftKeyDown() then
					Dominos:ToggleBindingMode()
				else
					Dominos:ToggleLockedFrames()
				end
			elseif button == 'RightButton' then
				Dominos:ShowOptions()
			end
		end,

		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine('Dominos')

			if Dominos:Locked() then
				tooltip:AddLine(L.ConfigEnterTip)
			else
				tooltip:AddLine(L.ConfigExitTip)
			end

			local KB = LibStub('LibKeyBound-1.0', true)
			if KB then
				if KB:IsShown() then
					tooltip:AddLine(L.BindingExitTip)
				else
					tooltip:AddLine(L.BindingEnterTip)
				end
			end

			local enabled = select(4, GetAddOnInfo('Dominos_Config'))
			if enabled then
				tooltip:AddLine(L.ShowOptionsTip)
			end
		end,
	})
end

--[[ Version Updating ]]--

function Dominos:GetDefaults()
	return {
		profile = {
			possessBar = 1,

			sticky = true,
			linkedOpacity = false,
			showMacroText = true,
			showBindingText = true,
			showTooltips = true,
			showTooltipsCombat = true,
			showMinimap = true,

			ab = {
				count = 10,
				showgrid = true,
				style = {'Entropy: Copper', 0.5, true},
			},

			petStyle  = {'Entropy: Silver', 0.5, nil},

			classStyle = {'Entropy: Silver', 0.5, nil},

			bagStyle = {'Entropy: Bronze', 0.5, nil},

			frames = {}
		}
	}
end

function Dominos:UpdateSettings(major, minor, bugfix)
	if major == '1' and minor < '23' then
		for profile,sets in pairs(self.db.sv.profiles) do
			local frames = sets.frames
			if frames then
				local frameSets = frames[1]
				if frameSets then
					local rogueStates = frameSets.pages and frameSets.pages['ROGUE']
					if rogueStates then
						local shadowDance = rogueStates['[bonusbar:2]']
						if not shadowDance then
							rogueStates['[bonusbar:2]'] = 6
						end
					end
				end
			end
		end
	end

	--perform state translation to handle updates from older versions
	if major < '4' then
		for profile,sets in pairs(self.db.sv.profiles) do
			if sets.frames then
				for frameId, frameSets in pairs(sets.frames) do
					if frameSets.pages then
						for class, oldStates in pairs(frameSets.pages) do
							local newStates = {}
							
							--convert class states
							if class == 'WARRIOR' then
								newStates['battle'] = oldStates['[bonusbar:1]']
								newStates['defensive'] = oldStates['[bonusbar:2]']
								newStates['berserker'] = oldStates['[bonusbar:3]']
							elseif class == 'DRUID' then
								newStates['moonkin'] = oldStates['[bonusbar:4]']
								newStates['bear'] = oldStates['[bonusbar:3]']
								newStates['tree'] = oldStates['[form:5]']
								newStates['prowl'] = oldStates['[bonusbar:1,stealth]']
								newStates['cat'] = oldStates['[bonusbar:1]']
							elseif class == 'PRIEST' then
								newStates['shadow'] = oldStates['[bonusbar:1]']
							elseif class == 'ROGUE' then
								newStates['vanish'] = oldStates['[bonusbar:1,form:3]']
								newStates['shadowdance'] = oldStates['[bonusbar:2]']
								newStates['stealth'] = oldStates['[bonusbar:1]']
							elseif class == 'WARLOCK' then
								newStates['meta'] = oldStates['[form:2]']
							end
						
							--modifier states
							for i, state in Dominos.BarStates:getAll('modifier') do
								newStates[state.id] = oldStates[state.value]
							end
							
							--possess states
							for i, state in Dominos.BarStates:getAll('possess') do
								newStates[state.id] = oldStates[state.value]
							end
							
							--page states
							for i, state in Dominos.BarStates:getAll('page') do
								newStates[state.id] = oldStates[state.value]
							end
							
							--targeting states
							for i, state in Dominos.BarStates:getAll('target') do
								newStates[state.id] = oldStates[state.value]
							end
							
							frameSets.pages[class] = newStates
						end
					end
				end
			end
		end
	end
end

function Dominos:UpdateVersion()
	DominosVersion = CURRENT_VERSION
	self:Print(format(L.Updated, DominosVersion))
end


--Load is called  when the addon is first enabled, and also whenever a profile is loaded
local function HasClassBar()
	local _,class = UnitClass('player')
	return not(class == 'MAGE' or class == 'SHAMAN')
end

function Dominos:Load()
	for i = 1, self:NumBars() do
		self.ActionBar:New(i)
	end
	if HasClassBar() then
		self.ClassBar:New()
	end
	self.PetBar:New()
	self.BagBar:New()
	self.MenuBar:New()
	self.VehicleBar:New()

	if self.ExtraBar then
		self.ExtraBar:New()
	end

	--button facade support
	local bf = LibStub('LibButtonFacade', true)
	if bf then
		bf:Group('Dominos', 'Action Bar'):Skin(unpack(self.db.profile.ab.style))
		bf:Group('Dominos', 'Pet Bar'):Skin(unpack(self.db.profile.petStyle))
		bf:Group('Dominos', 'Class Bar'):Skin(unpack(self.db.profile.classStyle))
		bf:Group('Dominos', 'Bag Bar'):Skin(unpack(self.db.profile.bagStyle))
	end

	--load in extra functionality
	for _,module in self:IterateModules() do
		module:Load()
	end

	--anchor everything
	self.Frame:ForAll('Reanchor')
--	self.Frame:ForAll('UpdateAlpha')
--	self.Frame:ForAll('UpdateWatched')

	--minimap button
	self:UpdateMinimapButton()
end

--unload is called when we're switching profiles
function Dominos:Unload()
	self.ActionBar:ForAll('Free')
	self.Frame:ForFrame('pet', 'Free')
	self.Frame:ForFrame('class', 'Free')
	self.Frame:ForFrame('menu', 'Free')
	self.Frame:ForFrame('bags', 'Free')
	self.Frame:ForFrame('vehicle', 'Free')
	self.Frame:ForFrame('extra', 'Free')

	--unload any module stuff
	for _,module in self:IterateModules() do
		module:Unload()
	end
end


--[[ Blizzard Stuff Hiding ]]--

function Dominos:HideBlizzard()
	local uiHider = CreateFrame("Frame"); uiHider:Hide()
	self.uiHider = uiHider

	local newForAll = function(f)
		return function(...)
			for i = 1, select('#', ...) do
				f(select(i, ...))
			end
		end
	end

	local disableFrames = newForAll(function(name)
		local f = _G[name]
		f:UnregisterAllEvents()
		f:SetParent(uiHider)
		f:Hide()
	end)

	local nilFramePositions = newForAll(function(name)
		local f = _G[name]--UIPARENT_MANAGED_FRAME_POSITIONS[i] = nil
		if f then
			f.ignoreFramePositionManager = true
		end
	end)

	disableFrames(
		'MainMenuBar',
		'MultiBarBottomLeft',
		'MultiBarBottomRight',
		'MultiBarLeft',
		'MultiBarRight',
--		'PetActionBarFrame', --we don't actually want to disable this, since I reuse the buttons
		'ShapeshiftBarFrame',
		'BonusActionBarFrame',
		'PossessBarFrame',
		'MainMenuExpBar',
		'MainMenuBarArtFrame'
	)

	nilFramePositions(
		'MultiBarRight',
		'MultiBarLeft',
		'MultiBarBottomLeft',
		'MultiBarBottomRight',
		'MainMenuBar',
		'ShapeshiftBarFrame',
		'PossessBarFrame',
		'MultiCastActionBarFrame',
		'ExtraActionBarFrame'
		--'PETACTIONBAR_YPOS',
		--'MULTICASTACTIONBAR_YPOS'
	)

	--register necessary main menu events
	MainMenuBarArtFrame:RegisterEvent('BAG_UPDATE')  --needed to display the keyring
	MainMenuBarArtFrame:RegisterEvent('CURRENCY_DISPLAY_UPDATE') --needed to display stuff on the backpack button

	--hide some weird effects of loading the talent frame
	local talentFrame = _G['PlayerTalentFrame']
	if talentFrame then
		talentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	else
		hooksecurefunc('TalentFrame_LoadUI', function()
			_G['PlayerTalentFrame']:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		end)
	end

	--hack, to make sure the seat indicator is placed in the right spot
	if not _G['VehicleSeatIndicator']:IsUserPlaced() then
		_G['VehicleSeatIndicator']:SetPoint("TOPRIGHT", MinimapCluster, "BOTTOMRIGHT", 0, -13)
	end

	--unregister evil binding events
	for i = 1, 6 do
		_G['VehicleMenuBarActionButton' .. i]:UnregisterAllEvents()
	end

	for i = 1, 12 do
		_G['BonusActionButton' .. i]:UnregisterAllEvents()
		_G['MultiCastActionButton' .. i]:UnregisterEvent('UPDATE_BINDINGS')
	end

	--prevent multi actionbar grids from randomly showing
	MultiActionBar_UpdateGrid = Multibar_EmptyFunc
end

--[[ Button Facade Events ]]--

function Dominos:OnSkin(skin, glossAlpha, gloss, group, _, colors)
	local styleDB
	if group == 'Action Bar' then
		styleDB = self.db.profile.ab.style
	elseif group == 'Pet Bar' then
		styleDB = self.db.profile.petStyle
	elseif group == 'Class Bar' then
		styleDB = self.db.profile.classStyle
	elseif group == 'Bag Bar' then
		styleDB = self.db.profile.bagStyle
	end

	if styleDB then
		styleDB[1] = skin
		styleDB[2] = glossAlpha
		styleDB[3] = gloss
		styleDB[4] = colors
	end
end


--[[ Keybound Events ]]--

function Dominos:LIBKEYBOUND_ENABLED()
	for _,frame in self.Frame:GetAll() do
		if frame.KEYBOUND_ENABLED then
			frame:KEYBOUND_ENABLED()
		end
	end
end

function Dominos:LIBKEYBOUND_DISABLED()
	for _,frame in self.Frame:GetAll() do
		if frame.KEYBOUND_DISABLED then
			frame:KEYBOUND_DISABLED()
		end
	end
end


--[[ Profile Functions ]]--

function Dominos:SaveProfile(name)
	local toCopy = self.db:GetCurrentProfile()
	if name and name ~= toCopy then
		self:Unload()
		self.db:SetProfile(name)
		self.db:CopyProfile(toCopy)
		self.isNewProfile = nil
		self:Load()
	end
end

function Dominos:SetProfile(name)
	local profile = self:MatchProfile(name)
	if profile and profile ~= self.db:GetCurrentProfile() then
		self:Unload()
		self.db:SetProfile(profile)
		self.isNewProfile = nil
		self:Load()
	else
		self:Print(format(L.InvalidProfile, name or 'null'))
	end
end

function Dominos:DeleteProfile(name)
	local profile = self:MatchProfile(name)
	if profile and profile ~= self.db:GetCurrentProfile() then
		self.db:DeleteProfile(profile)
	else
		self:Print(L.CantDeleteCurrentProfile)
	end
end

function Dominos:CopyProfile(name)
	if name and name ~= self.db:GetCurrentProfile() then
		self:Unload()
		self.db:CopyProfile(name)
		self.isNewProfile = nil
		self:Load()
	end
end

function Dominos:ResetProfile()
	self:Unload()
	self.db:ResetProfile()
	self.isNewProfile = true
	self:Load()
end

function Dominos:ListProfiles()
	self:Print(L.AvailableProfiles)

	local current = self.db:GetCurrentProfile()
	for _,k in ipairs(self.db:GetProfiles()) do
		if k == current then
			DEFAULT_CHAT_FRAME:AddMessage(' - ' .. k, 1, 1, 0)
		else
			DEFAULT_CHAT_FRAME:AddMessage(' - ' .. k)
		end
	end
end

function Dominos:MatchProfile(name)
	local name = name:lower()
	local nameRealm = name .. ' - ' .. GetRealmName():lower()
	local match

	for i, k in ipairs(self.db:GetProfiles()) do
		local key = k:lower()
		if key == name then
			return k
		elseif key == nameRealm then
			match = k
		end
	end
	return match
end


--[[ Profile Events ]]--

function Dominos:OnNewProfile(msg, db, name)
	self.isNewProfile = true
	self:Print(format(L.ProfileCreated, name))
end

function Dominos:OnProfileDeleted(msg, db, name)
	self:Print(format(L.ProfileDeleted, name))
end

function Dominos:OnProfileChanged(msg, db, name)
	self:Print(format(L.ProfileLoaded, name))
end

function Dominos:OnProfileCopied(msg, db, name)
	self:Print(format(L.ProfileCopied, name))
end

function Dominos:OnProfileReset(msg, db)
	self:Print(format(L.ProfileReset, db:GetCurrentProfile()))
end


--[[ Settings...Setting ]]--

function Dominos:SetFrameSets(id, sets)
	local id = tonumber(id) or id
	self.db.profile.frames[id] = sets

	return self.db.profile.frames[id]
end

function Dominos:GetFrameSets(id)
	return self.db.profile.frames[tonumber(id) or id]
end


--[[ Options Menu Display ]]--

function Dominos:ShowOptions()
	if LoadAddOn('Dominos_Config') then
		InterfaceOptionsFrame_OpenToCategory(self.Options)
		return true
	end
	return false
end

function Dominos:NewMenu(id)
	if not self.Menu then
		LoadAddOn('Dominos_Config')
	end
	return self.Menu and self.Menu:New(id)
end


--[[ Slash Commands ]]--

function Dominos:RegisterSlashCommands()
	self:RegisterChatCommand('dominos', 'OnCmd')
	self:RegisterChatCommand('dom', 'OnCmd')
end

function Dominos:OnCmd(args)
	local cmd = string.split(' ', args):lower() or args:lower()

	--frame functions
	if cmd == 'config' or cmd == 'lock' then
		self:ToggleLockedFrames()
	elseif cmd == 'scale' then
		self:ScaleFrames(select(2, string.split(' ', args)))
	elseif cmd == 'setalpha' then
		self:SetOpacityForFrames(select(2, string.split(' ', args)))
	elseif cmd == 'fade' then
		self:SetFadeForFrames(select(2, string.split(' ', args)))
	elseif cmd == 'setcols' then
		self:SetColumnsForFrames(select(2, string.split(' ', args)))
	elseif cmd == 'pad' then
		self:SetPaddingForFrames(select(2, string.split(' ', args)))
	elseif cmd == 'space' then
		self:SetSpacingForFrame(select(2, string.split(' ', args)))
	elseif cmd == 'show' then
		self:ShowFrames(select(2, string.split(' ', args)))
	elseif cmd == 'hide' then
		self:HideFrames(select(2, string.split(' ', args)))
	elseif cmd == 'toggle' then
		self:ToggleFrames(select(2, string.split(' ', args)))
	--actionbar functions
	elseif cmd == 'numbars' then
		self:SetNumBars(tonumber(select(2, string.split(' ', args))))
	elseif cmd == 'numbuttons' then
		self:SetNumButtons(tonumber(select(2, string.split(' ', args))))
	--profile functions
	elseif cmd == 'save' then
		local profileName = string.join(' ', select(2, string.split(' ', args)))
		self:SaveProfile(profileName)
	elseif cmd == 'set' then
		local profileName = string.join(' ', select(2, string.split(' ', args)))
		self:SetProfile(profileName)
	elseif cmd == 'copy' then
		local profileName = string.join(' ', select(2, string.split(' ', args)))
		self:CopyProfile(profileName)
	elseif cmd == 'delete' then
		local profileName = string.join(' ', select(2, string.split(' ', args)))
		self:DeleteProfile(profileName)
	elseif cmd == 'reset' then
		self:ResetProfile()
	elseif cmd == 'list' then
		self:ListProfiles()
	elseif cmd == 'version' then
		self:PrintVersion()
	elseif cmd == 'help' or cmd == '?' then
		self:PrintHelp()
	--options stuff
	else
		if not self:ShowOptions() then
			self:PrintHelp()
		end
	end
end

function Dominos:PrintHelp(cmd)
	local function PrintCmd(cmd, desc)
		print(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end

	self:Print('Commands (/dom, /dominos)')
	PrintCmd('config', L.ConfigDesc)
	PrintCmd('scale <frameList> <scale>', L.SetScaleDesc)
	PrintCmd('setalpha <frameList> <opacity>', L.SetAlphaDesc)
	PrintCmd('fade <frameList> <opacity>', L.SetFadeDesc)
	PrintCmd('setcols <frameList> <columns>', L.SetColsDesc)
	PrintCmd('pad <frameList> <padding>', L.SetPadDesc)
	PrintCmd('space <frameList> <spacing>', L.SetSpacingDesc)
	PrintCmd('show <frameList>', L.ShowFramesDesc)
	PrintCmd('hide <frameList>', L.HideFramesDesc)
	PrintCmd('toggle <frameList>', L.ToggleFramesDesc)
	PrintCmd('save <profile>', L.SaveDesc)
	PrintCmd('set <profile>', L.SetDesc)
	PrintCmd('copy <profile>', L.CopyDesc)
	PrintCmd('delete <profile>', L.DeleteDesc)
	PrintCmd('reset', L.ResetDesc)
	PrintCmd('list', L.ListDesc)
	PrintCmd('version', L.PrintVersionDesc)
end

--version info
function Dominos:PrintVersion()
	self:Print(DominosVersion)
end


--[[ Configuration Functions ]]--

--moving
Dominos.locked = true

local function CreateConfigHelperDialog()
	local f = CreateFrame('Frame', 'DominosConfigHelperDialog', UIParent)
	f:SetFrameStrata('DIALOG')
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetWidth(360)
	f:SetHeight(120)
	f:SetBackdrop{
		bgFile='Interface\\DialogFrame\\UI-DialogBox-Background' ,
		edgeFile='Interface\\DialogFrame\\UI-DialogBox-Border',
		tile = true,
		insets = {left = 11, right = 12, top = 12, bottom = 11},
		tileSize = 32,
		edgeSize = 32,
	}
	f:SetPoint('TOP', 0, -24)
	f:Hide()
	f:SetScript('OnShow', function() PlaySound('igMainMenuOption') end)
	f:SetScript('OnHide', function() PlaySound('gsTitleOptionExit') end)

	local tr = f:CreateTitleRegion()
	tr:SetAllPoints(f)

	local header = f:CreateTexture(nil, 'ARTWORK')
	header:SetTexture('Interface\\DialogFrame\\UI-DialogBox-Header')
	header:SetWidth(326); header:SetHeight(64)
	header:SetPoint('TOP', 0, 12)

	local title = f:CreateFontString('ARTWORK')
	title:SetFontObject('GameFontNormal')
	title:SetPoint('TOP', header, 'TOP', 0, -14)
	title:SetText(L.ConfigMode)

	local desc = f:CreateFontString('ARTWORK')
	desc:SetFontObject('GameFontHighlight')
	desc:SetJustifyV('TOP')
	desc:SetJustifyH('LEFT')
	desc:SetPoint('TOPLEFT', 18, -32)
	desc:SetPoint('BOTTOMRIGHT', -18, 48)
	desc:SetText(L.ConfigModeHelp)

	local exitConfig = CreateFrame('CheckButton', f:GetName() .. 'ExitConfig', f, 'OptionsButtonTemplate')
	_G[exitConfig:GetName() .. 'Text']:SetText(EXIT)
	exitConfig:SetScript('OnClick', function() Dominos:SetLock(true) end)
	exitConfig:SetPoint('BOTTOMRIGHT', -14, 14)

	return f
end

function Dominos:ShowConfigHelper()
	if not self.configHelper then
		self.configHelper = CreateConfigHelperDialog()
	end
	self.configHelper:Show()
end

function Dominos:HideConfigHelper()
	if self.configHelper then
		self.configHelper:Hide()
	end
end

function Dominos:SetLock(enable)
	self.locked = enable or false
	if self:Locked() then
		self.Frame:ForAll('Lock')
		self:HideConfigHelper()
	else
		self.Frame:ForAll('Unlock')
		LibStub('LibKeyBound-1.0'):Deactivate()
		self:ShowConfigHelper()
	end
end

function Dominos:Locked()
	return self.locked
end

function Dominos:ToggleLockedFrames()
	self:SetLock(not self:Locked())
end

function Dominos:ToggleBindingMode()
	self:SetLock(true)
	LibStub('LibKeyBound-1.0'):Toggle()
end

--scale
function Dominos:ScaleFrames(...)
	local numArgs = select('#', ...)
	local scale = tonumber(select(numArgs, ...))

	if scale and scale > 0 and scale <= 10 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameScale', scale)
		end
	end
end

--opacity
function Dominos:SetOpacityForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFrameAlpha', alpha)
		end
	end
end

--faded opacity
function Dominos:SetFadeForFrames(...)
	local numArgs = select('#', ...)
	local alpha = tonumber(select(numArgs, ...))

	if alpha and alpha >= 0 and alpha <= 1 then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetFadeMultiplier', alpha)
		end
	end
end

--columns
function Dominos:SetColumnsForFrames(...)
	local numArgs = select('#', ...)
	local cols = tonumber(select(numArgs, ...))

	if cols then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetColumns', cols)
		end
	end
end

--spacing
function Dominos:SetSpacingForFrame(...)
	local numArgs = select('#', ...)
	local spacing = tonumber(select(numArgs, ...))

	if spacing then
		for i = 1, numArgs - 1 do
			self.Frame:ForFrame(select(i, ...), 'SetSpacing', spacing)
		end
	end
end

--padding
function Dominos:SetPaddingForFrames(...)
	local numArgs = select('#', ...)
	local pW, pH = select(numArgs - 1, ...)

	if tonumber(pW) and tonumber(pH) then
		for i = 1, numArgs - 2 do
			self.Frame:ForFrame(select(i, ...), 'SetPadding', tonumber(pW), tonumber(pH))
		end
	end
end

--visibility
function Dominos:ShowFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'ShowFrame')
	end
end

function Dominos:HideFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'HideFrame')
	end
end

function Dominos:ToggleFrames(...)
	for i = 1, select('#', ...) do
		self.Frame:ForFrame(select(i, ...), 'ToggleFrame')
	end
end

--clickthrough
function Dominos:SetClickThroughForFrames(...)
	local numArgs = select('#', ...)
	local enable = select(numArgs - 1, ...)

	for i = 1, numArgs - 2 do
		self.Frame:ForFrame(select(i, ...), 'SetClickThrough', tonumber(enable) == 1)
	end
end

--empty button display
function Dominos:ToggleGrid()
	self:SetShowGrid(not self:ShowGrid())
end

function Dominos:SetShowGrid(enable)
	self.db.profile.showgrid = enable or false
	self.ActionBar:ForAll('UpdateGrid')
end

function Dominos:ShowGrid()
	return self.db.profile.showgrid
end

--right click selfcast
function Dominos:SetRightClickUnit(unit)
	self.db.profile.ab.rightClickUnit = unit
	self.ActionBar:ForAll('UpdateRightClickUnit')
end

function Dominos:GetRightClickUnit()
	return self.db.profile.ab.rightClickUnit
end

--binding text
function Dominos:SetShowBindingText(enable)
	self.db.profile.showBindingText = enable or false

	for _,f in self.Frame:GetAll() do
		if f.buttons then
			for _,b in pairs(f.buttons) do
				if b.UpdateHotkey then
					b:UpdateHotkey()
				end
			end
		end
	end
end

function Dominos:ShowBindingText()
	return self.db.profile.showBindingText
end

--macro text
function Dominos:SetShowMacroText(enable)
	self.db.profile.showMacroText = enable or false

	for _,f in self.Frame:GetAll() do
		if f.buttons then
			for _,b in pairs(f.buttons) do
				if b.UpdateMacro then
					b:UpdateMacro()
				end
			end
		end
	end
end

function Dominos:ShowMacroText()
	return self.db.profile.showMacroText
end

--possess bar settings
function Dominos:SetPossessBar(id)
	local prevBar = self:GetPossessBar()
	self.db.profile.possessBar = id
	local newBar = self:GetPossessBar()

	prevBar:UpdateStateDriver()
	newBar:UpdateStateDriver()
end

function Dominos:GetPossessBar()
	return self.Frame:Get(self.db.profile.possessBar)
end

--vehicle bar settings
function Dominos:GetVehicleBar()
	return self:GetPossessBar()
end

--action bar numbers
function Dominos:SetNumBars(count)
	count = max(min(count, 120), 1) --sometimes, I do entertaininig things

	if count ~= self:NumBars() then
		self.ActionBar:ForAll('Delete')
		self.db.profile.ab.count = count

		for i = 1, self:NumBars() do
			self.ActionBar:New(i)
		end
	end
end

function Dominos:SetNumButtons(count)
	self:SetNumBars(120 / count)
end

function Dominos:NumBars()
	return self.db.profile.ab.count
end

--tooltips
function Dominos:ShouldShowTooltips()
	if self:ShowTooltips() then
		return (not InCombatLockdown()) or self:ShowCombatTooltips()
	end
	return false;	
end

function Dominos:ShowTooltips()
	return self.db.profile.showTooltips
end

function Dominos:SetShowTooltips(enable)
	self.db.profile.showTooltips = enable or false
end

function Dominos:SetShowCombatTooltips(enable)
	self.db.profile.showTooltipsCombat = enable or false
end

function Dominos:ShowCombatTooltips()
	return self.db.profile.showTooltipsCombat
end


--minimap button
function Dominos:SetShowMinimap(enable)
	self.db.profile.showMinimap = enable or false
	self:UpdateMinimapButton()
end

function Dominos:ShowingMinimap()
	return self.db.profile.showMinimap
end

function Dominos:UpdateMinimapButton()
	if self:ShowingMinimap() then
		self.Minimap:UpdatePosition()
		self.Minimap:Show()
	else
		self.Minimap:Hide()
	end
end

function Dominos:SetMinimapButtonPosition(angle)
	self.db.profile.minimapPos = angle
end

function Dominos:GetMinimapButtonPosition(angle)
	return self.db.profile.minimapPos
end

--sticky bars
function Dominos:SetSticky(enable)
	self.db.profile.sticky = enable or false
	if not enable then
		self.Frame:ForAll('Stick')
		self.Frame:ForAll('Reposition')
	end
end

function Dominos:Sticky()
	return self.db.profile.sticky
end

--linked opacity
function Dominos:SetLinkedOpacity(enable)
	self.db.profile.linkedOpacity = enable or false
	self.Frame:ForAll('UpdateWatched')
	self.Frame:ForAll('UpdateAlpha')
end

function Dominos:IsLinkedOpacityEnabled()
	return self.db.profile.linkedOpacity
end
function Dominos:Masque(group, button, buttonData)
	local Masque = LibStub('Masque',true)
	if Masque then
		Masque:Group('Dominos',group):AddButton(button,buttonData)
		return true
	end
end


--[[ Utility Functions ]]--

--utility function: create a widget class
function Dominos:CreateClass(type, parentClass)
	local class = CreateFrame(type)
	class.mt = {__index = class}

	if parentClass then
		class = setmetatable(class, {__index = parentClass})
		class.super = parentClass
	end

	function class:Bind(o)
		return setmetatable(o, self.mt)
	end

	return class
end
