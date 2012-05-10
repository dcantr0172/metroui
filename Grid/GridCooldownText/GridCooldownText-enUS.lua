---------------------------------------
-- Localization for GridCooldownText --
---------------------------------------
GridCooldownTextLocale = {}
function GridCooldownTextLocale:NewLocale(locale, t)
  if locale == true or GetLocale() == locale then
    for k, v in pairs(t) do
      self[k] = (v == true and k) or v
    end
  end
end

GridCooldownTextLocale:NewLocale(true, {
	["Cooldown Text"] = true,
	["Cooldown Text options."] = true,
	["Cooldown Text Font Size"] = true, 
	["Adjust the font size for Cooldown Text."] = true,
	["Cooldown Text Font"] = true,
	["Adjust the font setting for Cooldown Text."] = true,
	["Cooldown Alpha"] = true,
	["Adjust the opacity of the Cooldown."] = true,
})