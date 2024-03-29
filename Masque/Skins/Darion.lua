--[[ Darion skin for Masque ]]

local _, Core = ...
-- Darion
Core:AddSkin("Darion",{

	-- Skin data start.
	Backdrop = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Backdrop]],
	},
	Icon = {
		Width = 34,
		Height = 34,
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Overlay]],
	},
	Cooldown = {
		Width = 30,
		Height = 30,
	},
	AutoCast = {
		Width = 16,
		Height = 16,
		AboveNormal = true;
	},
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Normal]],
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Overlay]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {0, 1, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Border]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Highlight]],
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
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Highlight]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textures\Darion\Textures\Gloss]],
	},
	HotKey = {
		Width = 40,
		Height = 10,
		OffsetX = -2,
		OffsetY = 8,
	},
	Count = {
		Width = 40,
		Height = 10,
		OffsetX = -2,
		OffsetY = -8,
	},
	Name = {
		Width = 40,
		Height = 10,
		OffsetY = -8,
	},
	-- Skin data end.

})

-- Darion Blue
Core:AddSkin("Darion Blue", {

	-- Skin data start.
	Template = "Darion",
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Normal_blue]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_blue]],
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_blue]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Gloss_blue]],
	},
	-- Skin data end.

})

-- Darion Gold
Core:AddSkin("Darion Gold", {

	-- Skin data start.
	Template = "Darion",
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Normal_gold]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_gold]],
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_gold]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Gloss_gold]],
	},
	-- Skin data end.

})

-- Darion Red
Core:AddSkin("Darion Red", {

	-- Skin data start.
	Template = "Darion",
	Normal = {
		Width = 40,
		Height = 40,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Normal_red]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_red]],
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Highlight_red]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque\Textrues\Darion\Textures\Gloss_red]],
	},
	-- Skin data end.

})
