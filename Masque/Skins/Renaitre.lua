--[[ Renaitre skins for 4.2 ]]

local _, Core = ...

-- Renaitre: Beveled
Core:AddSkin("Renaitre: Beveled", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Backdrop]],
	},
	Icon = {
		Width = 30,
		Height = 30,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Overlay]],
	},
	Cooldown = {
		Width = 30,
		Height = 30,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -4,
		OffsetY = -4,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 3,
	},
})

-- Renaitre: Beveled Light
Core:AddSkin("Renaitre: Beveled Light", {
	Template = "Renaitre: Beveled",
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Beveled\Border]],
	},
})

-- Renaitre: Circle
Core:AddSkin("Renaitre: Circle", {
	Core_Version = 40000,
	Backdrop = {
		Width = 44,
		Height = 44,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Backdrop]],
	},
	Icon = {
		Width = 24,
		Height = 24,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Overlay]],
	},
	Cooldown = {
		Width = 24,
		Height = 24,
	},
	AutoCast = {
		Width = 24,
		Height = 24,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 44,
		Height = 44,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Normal]],
	},
	Pushed = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Highlight]],
	},
	Border = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
	Disabled = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
	Checked = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
	AutoCastable = {
		Width = 44,
		Height = 44,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Highlight]],
	},
	Gloss = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Gloss]],
	},
	HotKey = {
		Width = 44,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 44,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 3,
	},
	Name = {
		Width = 44,
		Height = 12,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 4,
	},
})

-- Renaitre: Circle Light
Core:AddSkin("Renaitre: Circle Light", {
	Template = "Renaitre: Circle",
	Normal = {
		Width = 44,
		Height = 44,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Normal]],
	},
	Border = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
	Disabled = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
	Checked = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Circle\Border]],
	},
})

-- Renaitre: Circle Pro
Core:AddSkin("Renaitre: Circle Pro", {
	Core_Version = 40000,
	Backdrop = {
		Width = 44,
		Height = 44,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Backdrop]],
	},
	Icon = {
		Width = 24,
		Height = 24,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Overlay]],
	},
	Cooldown = {
		Width = 24,
		Height = 24,
	},
	AutoCast = {
		Width = 24,
		Height = 24,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 44,
		Height = 44,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Normal]],
	},
	Pushed = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Highlight]],
	},
	Border = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
	Disabled = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
	Checked = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
	AutoCastable = {
		Width = 44,
		Height = 44,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Highlight]],
	},
	Gloss = {
		Width = 44,
		Height = 44,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Gloss]],
	},
	HotKey = {
		Width = 44,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 44,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 3,
	},
	Name = {
		Width = 44,
		Height = 12,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 4,
	},
})

-- Renaitre: Circle Pro Light
Core:AddSkin("Renaitre: Circle Pro Light", {
	Template = "Renaitre: Circle Pro",
	Normal = {
		Width = 44,
		Height = 44,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Normal]],
	},
	Border = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
	Disabled = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
	Checked = {
		Width = 44,
		Height = 44,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\CirclePro\Border]],
	},
})

-- Renaitre: Fade
Core:AddSkin("Renaitre: Fade", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Fade\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
})

-- Renaitre: Rounded
Core:AddSkin("Renaitre: Rounded", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Backdrop]],
	},
	Icon = {
		Width = 28,
		Height = 28,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Overlay]],
	},
	Cooldown = {
		Width = 28,
		Height = 28,
	},
	AutoCast = {
		Width = 28,
		Height = 28,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Normal]],
	},
	Pushed = {
		Width = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -4,
		OffsetY = -4,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 3,
	},
})

-- Renaitre: Rounded Light
Core:AddSkin("Renaitre: Rounded Light", {
	Template = "Renaitre: Rounded",
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Rounded\Border]],
	},
})

-- Renaitre: Square
Core:AddSkin("Renaitre: Square", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Backdrop]],
	},
	Icon = {
		Width = 34,
		Height = 34,
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -4,
		OffsetY = -4,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 3,
	},
})

-- Renaitre: Square Light
Core:AddSkin("Renaitre: Square Light", {
	Template = "Renaitre: Square",
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Square\Border]],
	},
})

-- Renaitre: Square Thin
Core:AddSkin("Renaitre: Square Thin", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Backdrop]],
	},
	Icon = {
		Width = 34,
		Height = 34,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -3,
		OffsetY = -3,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
})

-- Renaitre: Square Thin Light
Core:AddSkin("Renaitre: Square Thin Light", {
	Template = "Renaitre: Square Thin",
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\SquareThin\Border]],
	},
})

-- Renaitre: Thinnerest
Core:AddSkin("Renaitre: Thinnerest", {
	Core_Version = 40000,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.4, 0.4, 0.4, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Backdrop]],
	},
	Icon = {
		Width = 34,
		Height = 34,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
		AboveNormal = true,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
})

-- Renaitre: Thinnerest Light
Core:AddSkin("Renaitre: Thinnerest Light", {
	Template = "Renaitre: Thinnerest",
	Normal = {
		Width = 42,
		Height = 42,
		Static = true,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Normal]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\AddOns\Masque\Textures\Renaitre\Textures\Thinnerest\Border]],
	},
})
