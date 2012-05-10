-- ButtonFacade_DaedUI, used in DaedhirUI
-- http://daedhirui.blogspot.com

local _, Core = ...

Core:AddSkin("DaedUI", {
	Author = "",
	Version = "",
	Shape = "Square",
	Masque_Version = 40300,
	       Backdrop = {
		  Width = 42,
		  Height = 42,
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Backdrop]],
	       },
	       Icon = {
		  Width = 36,
		  Height = 36,
	       },
	       Flash = {
		  Width = 42,
		  Height = 42,
		  Color = {1, 0, 0, 0.3},
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Overlay]],
	       },
	       Cooldown = {
		  Width = 36,
		  Height = 36,
	       },
	       Pushed = {
		  Width = 42,
		  Height = 42,
		  Color = {0, 0, 0, 0.5},
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Overlay]],
	       },
	       Normal = {
		  Width = 42,
		  Height = 42,
		  Static = true,
		  Color = {1, 1, 1, 1},
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\DaedUI\Textures\Normal]],
	       },
	       Disabled = {
		  Hide = true,
	       },
	       Checked = {
		  Width = 42,
		  Height = 42,
		  BlendMode = "ADD",
		  Color = {0, 0.8, 1, 0.5},
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Border]],
	       },
	       Border = {
		  Width = 42,
		  Height = 42,
		  BlendMode = "ADD",
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Border]],
	       },
	       Gloss = {
		  Width = 42,
		  Height = 42,
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\DaedUI\Textures\Gloss]],
	       },
	       AutoCastable = {
		  Width = 64,
		  Height = 64,
		  OffsetX = 0.5,
		  OffsetY = -0.5,
		  Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	       },
	       Highlight = {
		  Width = 42,
		  Height = 42,
		  BlendMode = "ADD",
		  Color = {1, 1, 1, 0.3},
		  Texture = [[Interface\AddOns\Masque\Textures\DaedUI\Textures\Highlight]],
	       },
	       Name = {
		  Width = 42,
		  Height = 10,
		  OffsetY = -10,
	       },
	       Count = {
		  Width = 42,
		  Height = 10,
		  OffsetX = -3,
		  OffsetY = -10,
	       },
	       HotKey = {
		  Width = 42,
		  Height = 10,
		  OffsetX = -3,
		  OffsetY = 10,
	       },
	       AutoCast = {
		  Width = 32,
		  Height = 32,
		  OffsetX = 1,
		  OffsetY = -1,
	       },
	    })
