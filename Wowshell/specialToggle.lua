--susnow
local addon,ns = ...

local spec = {}

spec.Wowshell_UFBlizzard = function(click)
	if IsAddOnLoaded("Wowshell_UFBlizzard") then
		if click %2 == 0 then
			_G["WSUF"].db.profile.currentStyle = "Shell"
			DisableAddOn("Wowshell_UFBlizzard")
			EnableAddOn("Wowshell_UFShell")
		elseif click %2 ~= 0 then
			_G["WSUF"].db.profile.currentStyle = "Blizzard"
			DisableAddOn("Wowshell_UFShell")
			EnableAddOn("Wowshell_UFBlizzard") 
		--else
		--	DisableAddOn("Wowshell_UFBlizzard")
		end
	else
		if click %2 == 0 then
			_G["WSUF"].db.profile.currentStyle = "Blizzard"
			EnableAddOn("Wowshell_UFBlizzard")
			DisableAddOn("Wowshell_UFShell")
		elseif click %2 ~= 0 then
			_G["WSUF"].db.profile.currentStyle = "Shell"
			DisableAddOn("Wowshell_UFBlizzard")
			EnableAddOn("Wowshell_UFShell")
		--else
		--	EnableAddOn("Wowshell_UFBlizzard")
		end
	end
end
spec.Wowshell_UFShell = function(click)
	if IsAddOnLoaded("Wowshell_UFShell") then
		if click %2 == 0 then
			_G["WSUF"].db.profile.currentStyle = "Blizzard"
			DisableAddOn("Wowshell_UFShell")
			EnableAddOn("Wowshell_UFBlizzard")
		elseif click %2 ~= 0 then
			_G["WSUF"].db.profile.currentStyle = "Shell"
			DisableAddOn("Wowshell_UFBlizzard")
			EnableAddOn("Wowshell_UFShell") 
		--else
		--	DisableAddOn("Wowshell_UFShell")
		end
	else
		if click %2 == 0 then
			_G["WSUF"].db.profile.currentStyle = "Shell"
			EnableAddOn("Wowshell_UFShell")
			DisableAddOn("Wowshell_UFBlizzard")
		elseif click %2 ~= 0 then
			_G["WSUF"].db.profile.currentStyle = "Blizzard"
			DisableAddOn("Wowshell_UFShell")
			EnableAddOn("Wowshell_UFBlizzard")
	--	else
	--		EnableAddOn("Wowshell_UFShell")
		end
	end

end
spec.Dominos = function(click)
	if IsAddOnLoaded("Dominos") then
		if click%2 == 0 then
			DisableAddOn("Dominos")
			DisableAddOn("Dominos_Config")
			DisableAddOn("Dominos_Roll")
			DisableAddOn("Dominos_Totems")
			DisableAddOn("Dominos_XP")
		elseif click%2 ~= 0 then
			EnableAddOn("Dominos")
			EnableAddOn("Dominos_Config")
			EnableAddOn("Dominos_Roll")
			EnableAddOn("Dominos_Totems")
			EnableAddOn("Dominos_XP")
		else
			DisableAddOn("Dominos")
			DisableAddOn("Dominos_Config")
			DisableAddOn("Dominos_Roll")
			DisableAddOn("Dominos_Totems")
			DisableAddOn("Dominos_XP")
		end
	else
		if click %2 == 0 then
			EnableAddOn("Dominos")
			EnableAddOn("Dominos_Config")
			EnableAddOn("Dominos_Roll")
			EnableAddOn("Dominos_Totems")
			EnableAddOn("Dominos_XP")
		elseif click %2 ~= 0 then
			DisableAddOn("Dominos")
			DisableAddOn("Dominos_Config")
			DisableAddOn("Dominos_Roll")
			DisableAddOn("Dominos_Totems")
			DisableAddOn("Dominos_XP")
		else
			EnableAddOn("Dominos")
			EnableAddOn("Dominos_Config")
			EnableAddOn("Dominos_Roll")
			EnableAddOn("Dominos_Totems")
			EnableAddOn("Dominos_XP")
		end
	end
end


ns.spec = spec
