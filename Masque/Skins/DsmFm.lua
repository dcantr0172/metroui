--[[ DsmFade ]]

	-- Skin data start.
-- DsmFade
local _, Core = ...

Core:AddSkin("DsmFade", {
	--Author = "darkloki",
	--Version = "1.0b",
	--Shape = "Square",
	--Masque_Version = 40300,
	Backdrop = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 0.75},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Backdrop]],
	},
	Icon = {
		Width = 26,
		Height = 26,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Overlay]],
	},
	Cooldown = {
		Width = 26,
		Height = 26,
	},
	AutoCast = {
		Width = 24,
		Height = 24,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Color = {0.25, 0.25, 0.25, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Normal]],
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Overlay]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Border]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {0, 0.75, 1, 0.5},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Border]],
	},
	AutoCastable = {
		Width = 64,
		Height = 64,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Highlight]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textrues\Masque_DsmFade\Textures\Gloss]],
	},
	HotKey = {
		Width = 40,
		Height = 10,
	--	Font = [[Interface\AddOns\YourFonts\Your Font Name Goes Here]],
		FontSize = 10,
	--	JustifyH = "CENTER",	--Available values are LEFT, CENTER, RIGHT
	--	JustifyV = "TOP",	--Available values are BOTTOM, MIDDLE, TOP
		OffsetX = -6,
		OffsetY = -1,
	},
	Count = {
		Width = 40,
		Height = 10,
	--	Color = {0, 0, 0, 0},
	--	Font = [[Interface\AddOns\YourFonts\Your Font Name Goes Here]],
	FontSize = 12,
	--	JustifyH = "RIGHT",	--Available values are LEFT, CENTER, RIGHT
	--	JustifyV = "BOTTOM",	--Available values are BOTTOM, MIDDLE, TOP
		OffsetX = -6,
		OffsetY = 4,
	},
	Name = {		--Macro text on the action button
		Width = 40,
		Height = 10,
	--	Color = {0, 0, 0, 0},
	--	Font = [[Interface\AddOns\YourFonts\Your Font Name Goes Here]],
	FontSize = 10,
	--	JustifyH = "CENTER",	--Available values are LEFT, CENTER, RIGHT
	--	JustifyV = "BOTTOM",	--Available values are BOTTOM, MIDDLE, Top
		OffsetX = 0,
		OffsetY = 4,
	},
	Duration = {
		Width = 40,
		Height = 10,
	--	Color = {0, 0, 0, 0},
	--	Font = [[Interface\AddOns\YourFonts\Your Font Name Goes Here]],
	FontSize = 12,
	--	JustifyH = "CENTER",	--Available values are LEFT, CENTER, RIGHT
	--	JustifyV = "MIDDLE",	--Available values are BOTTOM, MIDDLE, TOP
	--	OffsetX = 0,
		OffsetY = -10,
	},

	-- Skin data end.

})
