--[[ LiteStep 4.0.55-Beta ]]

-- LiteStep
local _, Core = ...
Core:AddSkin("LiteStep", {
	Core_Version = 40000,
	Backdrop = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 36,
		Height = 36,
		Color = {1, 0, 0, 0.3},
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	Pushed = {
		Width = 36,
		Height = 36,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Overlay]],
	},
	Normal = {
		Width = 36,
		Height = 36,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 36,
		Height = 36,
		BlendMode = "ADD",
		Color = {0, 0.8, 1, 0.8},
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Border]],
	},
	Border = {
		Width = 36,
		Height = 36,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Border]],
	},
	Gloss = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Gloss]],
	},
	AutoCastable = {
		Width = 64,
		Height = 64,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 36,
		Height = 36,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Border]],
	},
	Name = {
		Width = 36,
		Height = 10,
		OffsetY = 3,
	},
	Count = {
		Width = 36,
		Height = 10,
		OffsetX = -1,
		OffsetY = 3,
		FontSize = 13,
	},
	HotKey = {
		Width = 36,
		Height = 10,
		OffsetX = -1,
		OffsetY = -5,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
	},
})

-- LiteStep XLT
Core:AddSkin("LiteStep XLT", {
	Template = "LiteStep",
	Normal = {
		Width = 36,
		Height = 36,
		Static = true,
		Texture = [[Interface\AddOns\Masque\Textures\LiteStep\Textures\Lite]],
	},
})
