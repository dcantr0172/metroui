-- HelloKitty

local _, Core = ...

Core:AddSkin("HelloKitty", {

	-- Skin data start.
	Backdrop = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyBase]],
	},
	Icon = {
		Width = 25,
		Height = 24,
	},
	Flash = {
		Width = 30,
		Height = 30,
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\overlayred]],
	},
	Cooldown = {
		Width = 20,
		Height = 20,
	},
	AutoCast = {
		Width = 30,
		Height = 30,
		AboveNormal = true,
	},
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyBase]],
	},
	Pushed = {
		Width = 38,
		Height = 37,
		BlendMode = "ADD",
		Texture = [[Interface\Minimap\UI-Minimap-ZoomButton-Highlight]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyBase]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyActive]],
	},
	AutoCastable = {
		Width = 57,
		Height = 62,
		OffsetX = 0.5,
		OffsetY = -0.5,
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyHighlight]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
	},
	HotKey = {
		Width = 40,
		Height = 10,
		OffsetX = -2,
		OffsetY = 11,
	},
	Count = {
		Width = 40,
		Height = 8,
		OffsetX = 4,
		OffsetY = -8,
	},
	Name = {
		Width = 40,
		Height = 10,
		OffsetY = -8,
	},
	-- Skin data end.

})

Core:AddSkin("HelloKitty Christmas", {

	-- Skin data start.
	Template = "HelloKitty",
	Normal = {
		Width = 40,
		Height = 36,
		OffsetY = 5,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyBase_Xmas]],
	},
	Border = {
		Width = 40,
		Height = 36,
		OffsetY = 5,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyBase_Xmas]],
	},
	Checked = {
		Width = 40,
		Height = 36,
		OffsetY = 5,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\HelloKitty\Textures\HKittyActive_Xmas]],
	},
	-- Skin data end.

})
