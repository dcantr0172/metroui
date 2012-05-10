--[[ Gears 4.0.54-Beta ]]

-- Gears
local _, Core = ...
Core:AddSkin("Gears", {
	Core_Version = 40000,
	Backdrop = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Backdrop]],
	},
	Icon = {
		Width = 24,
		Height = 24,
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 0.8},
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Overlay]],
	},
	Cooldown = {
		Width = 24,
		Height = 24,
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 0.8},
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Overlay]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {0, 0.8, 1, 0.5},
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Border]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.8},
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Highlight]],
	},
	Name = {
		Width = 40,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = 40,
		Height = 10,
		OffsetY = 4,
		FontSize = 13,
	},
	HotKey = {
		Width = 40,
		Height = 10,
		JustifyH = "CENTER",
	},
	AutoCast = {
		Width = 16,
		Height = 16,
	},
})

-- Gears: Black
Core:AddSkin("Gears: Black", {
	Template = "Gears",
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Black]],
	},
})

-- Gears: Spark
Core:AddSkin("Gears: Spark", {
	Template = "Gears",
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\Gears\Textures\Spark]],
	},
})
