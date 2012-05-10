local __disabled_list = {
    Archy = true,
    YssBossLoot = true,
    ['NinjaPanel-Launcher'] = true,
    LFGForwarder = true,
    TradeSkillInfo = true,
    Grid = true,
    Icetip = true,
    StealYourCarbon = true,
    GatherMate2 = true,
    Decursive = true,
    Accountant_Classic = true,
    Dominos = true,
    VuhDo = true,
    Masque = true,
}


NinjaPanel = {panels = {}, plugins = {}, pluginNames = {}}

-- Import Data Broker and bail if we can't find it for some reason
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local jostle = LibStub:GetLibrary("LibJostle-3.0", true)
local db

local debugf = tekDebug and tekDebug:GetFrame("NinjaPanel")
local function Debug(...) if debugf then debugf:AddMessage(string.join(", ", tostringall(...))) end end

local eventFrame = CreateFrame("Frame", "NinjaPanelEventFrame", UIParent)
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
	if arg1 == "NinjaPanel" and event == "ADDON_LOADED" then
		-- Update addon options once they've been loaded
		if not NinjaPanelDB then
			NinjaPanelDB = {}
		end
		db = NinjaPanelDB
		db.panels = db.panels or {}
		db.plugins = db.plugins or {}

		-- Clean up old SV issues
		for k,v in pairs(db.plugins) do if type(v.panel) ~= "string" then v.panel = nil end end

		self:UnregisterEvent("ADDON_LOADED")
        
        -- In order to set the bar on the bottom instead of the top
        -- comment out the first line, and uncomment the second
        
		--NinjaPanel:SpawnPanel("NinjaPanelTop", "TOP")
        --NinjaPanel:SpawnPanel("NinjaPanelBottom", "BOTTOM")
 
        -- XXX hack by wowshell
        NinjaPanel:SpawnPanel("NinjaPanelTop", db.BOTTOM and "BOTTOM" or 'TOP')

		if db.DEVELOPMENT then
			-- Spawn all four bars so we can test
			NinjaPanel:SpawnPanel("NinjaPanelBottom", "BOTTOM")
			NinjaPanel:SpawnPanel("NinjaPanelRight", "RIGHT")
			NinjaPanel:SpawnPanel("NinjaPanelLeft", "LEFT")

			-- Create two plugins for each bar in order to test drag/drop
			ldb:NewDataObject("TopOne", { type = "data source", text = "Top One" })
			ldb:NewDataObject("TopTwo", { type = "data source", text = "Top Two" })
			ldb:NewDataObject("BottomOne", { type = "data source", text = "Bottom One"})
			ldb:NewDataObject("BottomTwo", { type = "data source", text = "Bottom Two"})
			ldb:NewDataObject("LeftOne", { type = "launcher", icon = "Interface\\Icons\\Spell_Nature_StormReach"})
			ldb:NewDataObject("LeftTwo", { type = "launcher", icon = "Interface\\Icons\\Spell_Nature_StormReach"})
			ldb:NewDataObject("RightOne", { type = "launcher", icon = "Interface\\Icons\\Spell_Nature_StormReach"})
			ldb:NewDataObject("RightTwo", { type = "launcher", icon = "Interface\\Icons\\Spell_Nature_StormReach"})
		end

		NinjaPanel:ScanForPlugins()

		if db.DEVELOPMENT then
			db.plugins["TopOne"].panel = "NinjaPanelTop"
			db.plugins["TopTwo"].panel = "NinjaPanelTop"
			db.plugins["BottomOne"].panel = "NinjaPanelBottom"
			db.plugins["BottomTwo"].panel = "NinjaPanelBottom"
			NinjaPanel:UpdatePanels()
		end

		ldb.RegisterCallback(NinjaPanel, "LibDataBroker_DataObjectCreated", "ScanForPlugins")
	end
end)

-- Local functions that are defined below
local SortWeightName
local Button_OnEnter, Button_OnLeave
local Button_OnMouseDown
local Button_OnDragStart, Button_OnDragStop, Button_OnUpdateDragging
local Button_Tooltip_OnEnter, Button_Tooltip_OnLeave
local Panel_UpdateLayout

function NinjaPanel:SpawnPanel(name, position)
	local panel = CreateFrame("Frame", name, eventFrame)
	panel.bg = panel:CreateTexture(name .. "BG", "BACKGROUND")
	panel.border = panel:CreateTexture(name .. "Border", "BACKGROUND")
	panel.name = name
	panel.position = position

	panel:ClearAllPoints()
	if position == "TOP" then
		panel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
		panel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
		panel:SetHeight(16)
		panel.bg:SetTexture(1, 1, 1, 0.8)
		panel.bg:SetGradient("VERTICAL", 0.2, 0.2, 0.2, 0, 0, 0)
		panel.bg:SetPoint("TOPLEFT")
		panel.bg:SetPoint("TOPRIGHT")
		panel.bg:SetHeight(15)
		panel.border:SetTexture(1, 1, 1, 0.8)
		panel.border:SetGradient("HORIZONTAL", 203 / 255, 161 / 255, 53 / 255, 0, 0, 0)
		panel.border:SetPoint("TOPLEFT", panel.bg, "BOTTOMLEFT", 0, 0)
		panel.border:SetPoint("TOPRIGHT", panel.bg, "BOTTOMRIGHT", 0, 0)
		panel.border:SetHeight(1)

		if jostle then
			jostle:RegisterTop(panel)
		end
	elseif position == "BOTTOM" then
		panel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
		panel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
		panel:SetHeight(16)
		panel.bg:SetTexture(1, 1, 1, 0.8)
		panel.bg:SetGradient("VERTICAL", 0.2, 0.2, 0.2, 0, 0, 0)
		panel.bg:SetPoint("BOTTOMLEFT")
		panel.bg:SetPoint("BOTTOMRIGHT")
		panel.bg:SetHeight(15)
		panel.border:SetTexture(1, 1, 1, 0.8)
		panel.border:SetGradient("HORIZONTAL", 203 / 255, 161 / 255, 53 / 255, 0, 0, 0)
		panel.border:SetPoint("BOTTOMLEFT", panel.bg, "TOPLEFT", 0, 0)
		panel.border:SetPoint("BOTTOMRIGHT", panel.bg, "TOPRIGHT", 0, 0)
		panel.border:SetHeight(1)

		if jostle then
			jostle:RegisterBottom(panel)
		end
	elseif position == "RIGHT" then
		-- TODO: Fix the colors and gradients here
		panel:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
		panel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
		panel:SetWidth(16)
		panel.bg:SetTexture(1, 1, 1, 0.8)
		panel.bg:SetGradient("VERTICAL", 0.2, 0.2, 0.2, 0, 0, 0)
		panel.bg:SetPoint("TOPRIGHT")
		panel.bg:SetPoint("BOTTOMRIGHT")
		panel.bg:SetWidth(15)
		panel.border:SetTexture(1, 1, 1, 0.8)
		panel.border:SetGradient("VERTICAL", 203 / 255, 161 / 255, 53 / 255, 0, 0, 0)
		panel.border:SetPoint("TOPRIGHT", panel.bg, "TOPLEFT", 0, 0)
		panel.border:SetPoint("BOTTOMRIGHT", panel.bg, "BOTTOMLEFT", 0, 0)
		panel.border:SetWidth(1)
	elseif position == "LEFT" then
		-- TODO: Fix the colors and gradients here
		panel:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
		panel:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
		panel:SetWidth(16)
		panel.bg:SetTexture(1, 1, 1, 0.8)
		panel.bg:SetGradient("HORIZONTAL", 0, 0, 0, 0.2, 0.2, 0.2)
		panel.bg:SetPoint("TOPLEFT")
		panel.bg:SetPoint("BOTTOMLEFT")
		panel.bg:SetWidth(15)
		panel.border:SetTexture(1, 1, 1, 0.8)
		panel.border:SetGradient("VERTICAL", 203 / 255, 161 / 255, 53 / 255, 0, 0, 0)
		panel.border:SetPoint("TOPLEFT", panel.bg, "TOPRIGHT", 0, 0)
		panel.border:SetPoint("BOTTOMLEFT", panel.bg, "BOTTOMRIGHT", 0, 0)
		panel.border:SetWidth(1)
	end


	-- TODO: Add the panel methods here
	panel.plugins = {}
	table.insert(self.panels, panel)
	self.panels[panel.name] = panel

	return panel
end

function NinjaPanel:HasPlugin(name)
	return self.plugins[name] and true
end

function NinjaPanel:SpawnPlugin(name, object, type)
	db.plugins[name] = db.plugins[name] or {}
	local opts = setmetatable(db.plugins[name], {
		__index = {
			weight = 0,
			alignRight = false,
		}
	})

	local entry = {}
	self.plugins[name] = entry

	entry.type = type
	entry.object = object
	entry.name = name
	entry.weight = opts.weight

	-- Push all of the launchers to the right-hand side
	if object.type == "launcher" and rawget(opts, "alignRight") == nil then
		entry.alignRight = true
	else
		entry.alignRight = opts.alignRight
	end

	local button = CreateFrame("Button", "NinjaPanelButton_" .. name, eventFrame)
	button.icon = button:CreateTexture(nil, "BACKGROUND")
	button.text = button:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
    do
        local font, size, flag = GameFontHighlightSmall:GetFont()
        button.text:SetFont(font, size-2, flag)
    end

	button.entry = entry
	button.object = object
    button.last_width = 0 -- XXX hack by wowshell
	button:RegisterForClicks("AnyUp")
	button:SetMovable(true)

	entry.button = button

	ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_" .. name, "UpdatePlugin")
end

function NinjaPanel:PluginIsDisabled(name)
	if db.plugins[name] then
		return db.plugins[name].disabled
	else
		return false
	end
end

function NinjaPanel:StoreName(name)
	if not self.pluginNames[name] then
		self.pluginNames[name] = true
		table.insert(self.pluginNames, name)
	end
end

function NinjaPanel:ScanForPlugins()
	self.warned = self.warned or {}

	for name,dataobj in ldb:DataObjectIterator() do
        -- disable some broker plugin, so it won't show
        if(not __disabled_list[name]) then
            -- Create any plugins that aren't disabled
            if not self:HasPlugin(name) and not self:PluginIsDisabled(name) then 
                if dataobj.type == "data source" or dataobj.text then
                    self:StoreName(name)
                    self:SpawnPlugin(name, dataobj, "data source")
                elseif dataobj.type == "launcher" or (dataobj.icon and dataobj.OnClick) then
                    self:StoreName(name)
                    self:SpawnPlugin(name, dataobj, "launcher")
                elseif not self.warned[name] then
                    --print("Skipping unknown broker object for " .. name .. "(" .. tostring(dataobj.type) .. ")")
                    self.warned[name] = true
                end
            else
                self:StoreName(name)
            end
        end
    end

    self:UpdatePanels()
end

function NinjaPanel:UpdateButtonWidth(button)
	local iconWidth = button.icon:IsShown() and button.icon:GetWidth() or 0
	local textWidth = button.text:IsShown() and button.text:GetWidth() or 0

	--button:SetWidth(textWidth + iconWidth + ((textWidth > 0) and 9 or 3))
    -- XXX hack by wowshell

    local width = textWidth + iconWidth + ((textWidth>0) and 9 or 5)

    local diff = button.last_width - width
    if(diff > 0) and (diff < 10) then
        width = button.last_width
    end

    button.last_width = width
    button:SetWidth(width)
end

function NinjaPanel:UpdatePlugin(event, name, key, value, dataobj)
	-- name:	The name of the plugin being updated
	-- key:		The key that was updated in the plugin
	-- value:	The new value of the given key
	-- dataobj: The actual data object 

	-- Bail out early if necessary
	if not self:HasPlugin(name) then 
		return
	end

	local entry = self.plugins[name]
	local button = entry.button

    if key == "type" then
        self:UpdatePanels()
    elseif key == "text" then
		button.text:SetFormattedText("%s", value or "")
		self:UpdateButtonWidth(button)
	elseif key == "icon" then
		button.icon:SetTexture(value)
        if value == nil then
            button.icon:Hide()
        else
            button.icon:Show()
        end
	elseif key == "tooltip" or key == "OnTooltipShow" or key == "OnEnter" or key == "OnLeave" then
		-- Update the tooltip handers on the frame
		self:UpdateTooltipHandlers(button, dataobj)
	elseif key == "OnClick" then
		button:SetScript("OnClick", value)
	end

	-- Update the icon coordinates if either the icon or the icon coords were 
	if key == "icon" or key == "iconCoords" then
		-- Since the icon has changed, update texcoord and color
		if entry.object.iconCoords then
			button.icon:SetTexCoord(unpack(dataobj.iconCoords))
		else
			button.icon:SetTexCoord(0, 1, 0, 1)
		end
	end

	-- Update the icon color if either the icon or the color attributes are changed
	if key == "icon" or key == "iconR" or key == "iconG" or key == "iconB" then
		if entry.object.iconR then
			local r = dataobj.iconR or 1
			local g = dataobj.iconG or 1
			local b = dataobj.iconB or 1
			button.icon:SetVertexColor(r, g, b)
		else
			button.icon:SetVertexColor(1, 1, 1)
		end
	end
end

function NinjaPanel:UpdateTooltipHandlers(button, dataobj)
	-- It’s possible that a source addon may provide more that one tooltip method.
	-- The display addon should only use one of these (even if it support all
	-- three in the spec). The generally preferred order is: tooltip >
	-- OnEnter/OnLeave > OnTooltipShow.

	-- Generally speaking, tooltip is not likely to be implemented along with
	-- another render method. OnEnter may also provide (and use) OnTooltipShow, in
	-- this case it’s usually preferred that the display simply set the OnEnter
	-- handler directly to the frame, thus bypassing the display’s tooltip
	-- handling code and never calling OnTooltipShow from the display.
	
	if dataobj.tooltip then
		button:SetScript("OnEnter", Button_Tooltip_OnEnter)
		button:SetScript("OnLeave", Button_Tooltip_OnLeave)
	elseif dataobj.OnEnter and dataobj.OnLeave then
		button:SetScript("OnEnter", dataobj.OnEnter)
		button:SetScript("OnLeave", dataobj.OnLeave)
	elseif dataobj.OnTooltipShow then
		button:SetScript("OnEnter", Button_OnEnter)
		button:SetScript("OnLeave", Button_OnLeave)
    else
        -- Fallback and proide our own tooltip handler
        button:SetScript("OnEnter", Button_Tooltip_OnEnter)
        button:SetScript("OnLeave", Button_Tooltip_OnLeave)
    end
end

function NinjaPanel:UpdatePanels()
	-- Ensure the options table exists
	db.panels = db.panels or {}

	-- Iterate over the plugins that have been registered, and claim children
	local head = self.panels[1]
	for name,entry in pairs(self.plugins) do
		local opt = db.plugins[name]
        -- If the plugin hasn't been claimed
        if not entry.panel then
            if opt.panel and not self.panels[opt.panel] then
                -- The assigned panel does not exist
                -- do nothing, skip
            else
                opt.panel = opt.panel and self.panels[opt.panel].name or head.name
            end
		end
		self:AttachPlugin(entry, opt.panel)
	end

	-- Loop through each of the panels, updating the visual display
	for idx,panel in ipairs(self.panels) do
		local name = panel.name
		db.panels[name] = db.panels[name] or {}
		local opt = db.panels[name]
		setmetatable(opt, {
			__index = {
				height = 15,
				border_height = 1,
				gradient = {0.2, 0.2, 0.2, 1.0, 0, 0, 0, 1.0},
				gradient_dir = "VERTICAL",
				border_gradient = {203 / 255, 161 / 255, 53 / 255, 1.0, 0, 0, 0, 1.0},
				border_gradient_dir = "HORIZONTAL",
			}
		})
		
		-- DEFAULT OPTIONS HERE
		local height = opt.height
		local border_height = opt.border_height
		local gradient = opt.gradient
		local gradient_dir = opt.gradient_dir
		local border_gradient = opt.border_gradient
		local border_gradient_dir = opt.border_gradient_dir
		
		panel:SetHeight(height + border_height)
		panel.bg:SetHeight(height)
		panel.border:SetHeight(border_height)
		panel.bg:SetGradientAlpha(gradient_dir, unpack(gradient))
		panel.border:SetGradientAlpha(border_gradient_dir, unpack(border_gradient))
	end

	-- Update the plugins on each panel
	for idx,panel in ipairs(self.panels) do
		Panel_UpdateLayout(panel)
	end
end

function NinjaPanel:AttachPlugin(plugin, panelName)
	local panel = self.panels[panelName] or self.panels[1]
	panel.plugins[plugin.name] = plugin
	plugin.panel = panel.self
	plugin.button:SetParent(panel)
end

function NinjaPanel:DetachPlugin(plugin)
	plugin.panel = nil
	plugin.button:ClearAllPoints()
	plugin.button:Hide()
end

function NinjaPanel:HardAnchorPlugins()
	for idx,panel in ipairs(self.panels) do
		local opt = db.panels[panel.name]
		local yoffset = opt.border_height

		for name,entry in pairs(panel.plugins) do
			local button = entry.button
			local left = button:GetLeft()
			button:ClearAllPoints()
			button:SetPoint("LEFT", panel, "LEFT", left, 0)
		end
	end
end

function Panel_UpdateLayout(self)
	local left, right = {}, {}

	-- Loop through all of the plugins in the given panel
	for name,entry in pairs(self.plugins) do
		local panel_opts = db.panels[self.name]

		table.insert(entry.alignRight and right or left, entry)

		local button = entry.button
		local height = panel_opts.height - (panel_opts.border_height * 2)
		button:SetHeight(height)
		button:Show()

		if entry.object.icon then
			-- Actually update the layout of the button
			button.icon:SetHeight(height)
			button.icon:SetWidth(height)
			button.icon:SetTexture(entry.object.icon)
			button.icon:ClearAllPoints()
			button.icon:SetPoint("LEFT", button, "LEFT", 3, panel_opts.border_height)
			button.icon:Show()

			-- Run a SetTexCoord on the icon if .iconCoords is set 
			if entry.object.iconCoords then
				button.icon:SetTexCoord(unpack(entry.object.iconCoords))
			else
				button.icon:SetTexCoord(0, 1, 0, 1)
			end

			if entry.object.iconR or entry.object.iconG or entry.object.iconB then
				local r = entry.object.iconR or 1.0
				local g = entry.object.iconG or 1.0
				local b = entry.object.iconB or 1.0
				button.icon:SetVertexColor(r, g, b)
			end
		else
			button.icon:Hide()
		end

		NinjaPanel:UpdateTooltipHandlers(button, entry.object)

		button:SetScript("OnClick", entry.object.OnClick)
        button:SetScript("OnMouseDown", Button_OnMouseDown)
		button:SetScript("OnDragStart", Button_OnDragStart)
		button:SetScript("OnDragStop", Button_OnDragStop)
		button:RegisterForDrag("LeftButton")

		button.text:SetText(entry.object.text or "Waiting...")
		button.text:SetHeight(height)
		button.text:ClearAllPoints()

		if button.icon:IsShown() then
			button.text:SetPoint("LEFT", button.icon, "RIGHT", 5, 0)
		else
			button.text:SetPoint("LEFT", button, "LEFT", 3, panel_opts.border_height)
		end 

		if entry.object.type == "launcher" then
			-- Hide the text
			button.text:Hide()
		else
			button.text:Show()
		end
		NinjaPanel:UpdateButtonWidth(button)
	end

	-- Sort the list of plugins into left/right
	table.sort(left, SortWeightName)
	table.sort(right, SortWeightName)

	-- Anchor everything that is left-aligned
	for idx,entry in ipairs(left) do
		local button = entry.button
		button:ClearAllPoints()
		if idx == 1 then
			button:SetPoint("LEFT", self, "LEFT", 3, 0)
		else
			button:SetPoint("LEFT", left[idx-1].button, "RIGHT", 3, 0)
		end
	end

	-- Anchor everything that is right-aligned
	for idx,entry in ipairs(right) do
		local button = entry.button
		button:ClearAllPoints()
		if idx == 1 then
			button:SetPoint("RIGHT", self, "RIGHT", -3, 0)
		else
			button:SetPoint("RIGHT", right[idx-1].button, "LEFT", -3, 0)
		end
	end
end

--[[-----------------------------------------------------------------------
--  Locally defined functions
-----------------------------------------------------------------------]]--

function SortWeightName(a,b)
	if a.weight and b.weight then
		return a.weight < b.weight
	else
		return a.name < b.name
	end
end

function Button_OnMouseDown(self, ...)
    if self.tooltip_shown then
        GameTooltip:Hide()
        self.tooltip_shown = false;
    end
end

function Button_OnEnter(self, ...)
	GameTooltip:SetOwner(self, "ANCHOR_NONE")
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
	GameTooltip:ClearLines()
	if self.object.OnTooltipShow then
		self.object.OnTooltipShow(GameTooltip)
	else
		GameTooltip:SetText(self.entry.name)
	end
	GameTooltip:Show()
    self.tooltip_shown = true
end

function Button_OnLeave(self, ...)
	GameTooltip:Hide()
end

function Button_OnUpdateDragging(self, elapsed)
	self:ClearAllPoints()
	local left, right = GetCursorPosition()
	left = left / self:GetEffectiveScale()
	self:SetPoint("LEFT", self:GetParent(), "LEFT", left, 0)
end

function Button_OnDragStart(self, button, ...)
	NinjaPanel:HardAnchorPlugins()
	self:SetToplevel(true)
	self:SetScript("OnUpdate", Button_OnUpdateDragging)
	self.origLeft = self:GetLeft()
end

function Button_OnDragStop(self, button, ...)
	self:SetScript("OnUpdate", nil)
	self:StopMovingOrSizing()
	local p = self:GetParent()

	local left, right = {}, {}
	for name,entry in pairs(p.plugins) do
		if entry.button ~= self then
			table.insert(entry.alignRight and right or left, entry)
		end
	end

	table.sort(left, SortWeightName)
	table.sort(right, SortWeightName)

	local newLeft, newRight = self:GetLeft(), self:GetRight()
	local alignRight = false
	local leftPos, rightPos = {}, {}

	-- Store the positions for the right-most plugins first
	for idx,entry in ipairs(right) do
		rightPos[entry] = entry.button:GetLeft()
	end

	-- Store the positions for the left-most plugins
	for idx,entry in ipairs(left) do
		leftPos[entry] = entry.button:GetRight()
	end

	-- If we are moving to the right
	if self.origLeft <= newLeft then
		-- Check to see if we're on the right-hand side of the panel
		for idx, entry in ipairs(right) do
			if newRight > rightPos[entry] then
				rightPos[self.entry] = rightPos[entry] + 1
				alignRight = true
				break
			end
		end

		if not alignRight then
			for idx=#left, 1, -1 do
				local entry = left[idx]
				if newRight > entry.button:GetLeft() and newRight <= entry.button:GetRight() then
					leftPos[self.entry] = leftPos[entry] + 1
					alignRight = false
					break
				end
			end
		end
	else
		-- We are moving to the left
		-- Check to see if we're on the right-hand side of the panel
		if right[1] and newLeft > right[#right].button:GetLeft() then
			for idx=#right, 1, -1 do
				local entry = right[idx]
				if newLeft < entry.button:GetRight() then
					rightPos[self.entry] = rightPos[entry] - 1
					alignRight = true
					break
				end
			end
		end

		if not alignRight then
			for idx,entry in ipairs(left) do
				if newLeft < leftPos[entry] then
					leftPos[self.entry] = leftPos[entry] - 1
					alignRight = false
					break
				end
			end
		end
	end

	-- If we didn't get a position above
	if not leftPos[self.entry] and not rightPos[self.entry] then
		-- Handle the case where we're the first plugin to go to the right
		local panelRight = p:GetRight()
		if newRight >= panelRight - 100 then
			rightPos[self.entry] = panelRight
			alignRight = true
		end

		-- Handle the case where we're the first plugin to go to the left
		if not alignRight then
			if newLeft <= 100 then
				leftPos[self.entry] = 0
				alignRight = false
			else
				-- Otherwise, just tag it onto the right of the left
				leftPos[self.entry] = panelRight
				alignRight = false
			end
		end
	end

	table.insert(alignRight and right or left, self.entry)
	self.entry.alignRight = alignRight

	table.sort(left, function(a,b) return leftPos[a] < leftPos[b] end)
	table.sort(right, function(a,b) return rightPos[a] > rightPos[b] end) 

	for idx,entry in ipairs(left) do
		entry.weight = idx
	end
	for idx,entry in ipairs(right) do
		entry.weight = idx
	end

	-- Save the new weight information out to the database
	if not NinjaPanelDB.plugins then NinjaPanelDB.plugins = {} end
	local opts = NinjaPanelDB.plugins

	for name,entry in pairs(p.plugins) do
		opts[name].weight = entry.weight
		opts[name].enabled = entry.enabled
		opts[name].alignRight = entry.alignRight
	end

	Panel_UpdateLayout(p)
end

function Button_Tooltip_OnEnter(button)
	local tooltip = button.object.tooltip
    if tooltip then
        tooltip:ClearAllPoints()
        tooltip:SetPoint("TOPLEFT", button, "BOTTOMLEFT", 0, 0)
        tooltip:Show()
    else
        --GameTooltip:SetOwner(button, "ANCHOR_BOTTOMLEFT")
		--GameTooltip:AddLine(button.entry.name, nil, nil, nil, true)
		--GameTooltip:AddDoubleLine("LDB Type", button.entry.type, nil, nil, nil, 1, 1, 1, true)
		--GameTooltip:Show()
    end
end

function Button_Tooltip_OnLeave(button)
	local tooltip = button.object.tooltip or GameTooltip
	tooltip:Hide()
end

--[[-------------------------------------------------------------------------
-- Interface Options using tekConfig with Ampere's code example
-------------------------------------------------------------------------]]--

--local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
--frame.name = "NinjaPanel"
--frame:Hide()
--frame:SetScript("OnShow", function(frame)
--	local function MakeButton(parent)
--		local button = CreateFrame("Button", nil, parent or frame)
--		button:SetWidth(80)
--		button:SetHeight(22)
--
--		button:SetHighlightFontObject(GameFontHighlightSmall)
--		button:SetNormalFontObject(GameFontNormalSmall)
--
--		button:SetNormalTexture("Interface\\Buttons\\UI-Panel-Button-Up")
--		button:SetPushedTexture("Interface\\Buttons\\UI-Panel-Button-Down")
--		button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
--		button:SetDisabledTexture("Interface\\Buttons\\UI-Panel-Button-Disabled")
--		button:GetNormalTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--		button:GetPushedTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--		button:GetHighlightTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--		button:GetDisabledTexture():SetTexCoord(0, 0.625, 0, 0.6875)
--		button:GetHighlightTexture():SetBlendMode("ADD")
--
--		return button
--	end
--
--	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
--	title:SetPoint("TOPLEFT", 16, -16)
--	title:SetText("NinjaPanel Configuration")
--
--	local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--	--~ 	subtitle:SetHeight(32)
--	subtitle:SetHeight(35)
--	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
--	subtitle:SetPoint("RIGHT", frame, -32, 0)
--	subtitle:SetNonSpaceWrap(true)
--	subtitle:SetJustifyH("LEFT")
--	subtitle:SetJustifyV("TOP")
--	--~ 	subtitle:SetMaxLines(3)
--	subtitle:SetText("This panel can be used to configure the NinjaPanel LDB display.")
--
--	local rows, anchor = {}
--	local EDGEGAP, ROWHEIGHT, ROWGAP, GAP = 16, 20, 2, 4
--
--	local function OnEnter(self)
--		local type = (NinjaPanel.plugins[self.name] and NinjaPanel.plugins[self.name].object.type) or "Unknown"
--		GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
--		GameTooltip:AddLine(self.name, nil, nil, nil, true)
--		GameTooltip:AddLine(type, 1, 1, 1, true)
--		GameTooltip:Show()
--	end
--	local function OnLeave() GameTooltip:Hide() end
--	local function OnClick(self)
--		local opts = NinjaPanelDB.plugins[self.name]
--		local plugin = NinjaPanel.plugins[self.name]
--		if opts.disabled then
--			opts.disabled = nil
--		else
--			opts.disabled = true
--			NinjaPanel:DetachPlugin(plugin)
--		end
--		PlaySound(enabled and "igMainMenuOptionCheckBoxOff" or "igMainMenuOptionCheckBoxOn")
--		NinjaPanel:ScanForPlugins()
--		Refresh()
--	end
--
--	-- Create rows for each option
--	for i=1,math.floor((305-22)/(ROWHEIGHT + ROWGAP)) do
--		local row = CreateFrame("Button", nil, frame)
--		if not anchor then row:SetPoint("TOP", subtitle, "BOTTOM", 0, -16)
--		else row:SetPoint("TOP", anchor, "BOTTOM", 0, -ROWGAP) end
--		row:SetPoint("LEFT", EDGEGAP, 0)
--		row:SetPoint("RIGHT", -EDGEGAP*2-8, 0)
--		row:SetHeight(ROWHEIGHT)
--		anchor = row
--		rows[i] = row
--
--		local check = CreateFrame("CheckButton", nil, row)
--		check:SetWidth(ROWHEIGHT+4)
--		check:SetHeight(ROWHEIGHT+4)
--		check:SetPoint("LEFT")
--		check:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
--		check:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
--		check:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
--		check:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
--		check:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
--		check:SetScript("OnClick", OnClick)
--		row.check = check
--
--		local title = row:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
--		title:SetPoint("LEFT", check, "RIGHT", 4, 0)
--		row.title = title
--
--		local status = row:CreateFontString(nil, "BACKGROUND", "GameFontHighlightSmall")
--		status:SetPoint("RIGHT", row, "RIGHT", -4, 0)
--		status:SetPoint("LEFT", title, "RIGHT")
--		status:SetJustifyH("RIGHT")
--		row.status = status
--
--		row:SetScript("OnEnter", OnEnter)
--		row:SetScript("OnLeave", OnLeave)
--	end
--
--	local statusColors = {
--		[true] = {0.1, 1.0, 0.1},
--		[false] = {1.0, 0.1, 0.1},
--	}
--
--	local offset = 0
--	Refresh = function()
--		if not frame:IsVisible() then return end
--
--		table.sort(NinjaPanel.pluginNames)
--
--		for i,row in ipairs(rows) do
--			if (i + offset) <= #NinjaPanel.pluginNames then
--				local name = NinjaPanel.pluginNames[i + offset]
--				local entry = NinjaPanel.plugins[name]
--				local opts = NinjaPanelDB.plugins[name]
--				local enabled = not opts.disabled
--				local color = statusColors[enabled or false]
--                local dataObj = ldb:GetDataObjectByName(name)
--                local type = dataObj.type == "launcher" and " |cffffffff(launcher)|r" or ""
--
--				row.check:SetChecked(enabled)
--				row.title:SetText(name .. type)
--				row.status:SetText(enabled and "Enabled" or "Disabled")
--				row.status:SetTextColor(unpack(color))
--				row.name = name
--				row.check.name = name
--				row:Show()
--			else
--				row:Hide()
--			end
--		end
--	end
--	frame:SetScript("OnEvent", Refresh)
--	frame:RegisterEvent("ADDON_LOADED")
--	frame:SetScript("OnShow", Refresh)
--	Refresh()
--
--	local scrollbar = LibStub("tekKonfig-Scroll").new(frame, nil, #rows/2)
--	scrollbar:ClearAllPoints()
--	scrollbar:SetPoint("TOP", rows[1], 0, -16)
--	scrollbar:SetPoint("BOTTOM", rows[#rows], 0, 16)
--	scrollbar:SetPoint("RIGHT", -16, 0)
--	scrollbar:SetMinMaxValues(0, math.max(0, #NinjaPanel.pluginNames - #rows))
--	scrollbar:SetValue(0)
--
--	local f = scrollbar:GetScript("OnValueChanged")
--	scrollbar:SetScript("OnValueChanged", function(self, value, ...)
--		offset = math.floor(value)
--		Refresh()
--		return f(self, value, ...)
--	end)
--
--	frame:EnableMouseWheel()
--	frame:SetScript("OnMouseWheel", function(self, val) scrollbar:SetValue(scrollbar:GetValue() - val*#rows/2) end)
--
--	local enableall = MakeButton()
--	enableall:SetPoint("BOTTOMLEFT", 16, 16)
--	enableall:SetText("Enable All")
--	enableall:SetScript("OnClick", function(button)
--		for idx,name in ipairs(NinjaPanel.pluginNames) do
--			NinjaPanelDB.plugins[name].disabled = nil
--		end
--		Refresh()
--	end)
--
--	local disableall = MakeButton()
--	disableall:SetPoint("LEFT", enableall, "RIGHT", 4, 0)
--	disableall:SetText("Disable All")
--	disableall:SetScript("OnClick", function(button)
--		for idx,name in ipairs(NinjaPanel.pluginNames) do
--			NinjaPanelDB.plugins[name].disabled = true
--		end
--		Refresh()
--	end)
--
--	local reload = MakeButton()
--	reload:SetPoint("BOTTOMRIGHT", -16, 16)
--	reload:SetText("Refresh")
--	reload:SetScript("OnClick", ReloadUI)
--end)
--
--InterfaceOptions_AddCategory(frame)
--LibStub("tekKonfig-AboutPanel").new("NinjaPanel", "NinjaPanel")

----------------------------------------
--      Quicklaunch registration      --
----------------------------------------

-- Icon provided by NinjaKiller (http://ninjakiller.deviantart.com/art/Ninja-Icon-Package-01-56129382)
--local dataobj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("NinjaPanel-Launcher", {
--	type = "launcher",
--	icon = "Interface\\AddOns\\NinjaPanel\\NinjaLogo",
--	OnClick = function() InterfaceOptionsFrame_OpenToCategory(frame) end,
--})
