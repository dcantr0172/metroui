local frame = CreateFrame("Frame", nil)

function FixTrinketMiniButton()
	if (TrinketMenu and TrinketMenu.MoveMinimapButton) then
		TrinketMenu.MoveMinimapButton = function ()
    		TrinketMenu_IconFrame:ClearAllPoints()
        	TrinketMenu_IconFrame:SetPoint("LEFT","TrinketMenu_MainFrame","RIGHT",-1, -2)
        	if TrinketMenuOptions.ShowIcon=="ON" then
        		TrinketMenu_IconFrame:Show()
        	else
        		TrinketMenu_IconFrame:Hide()
        	end
        end
    end
	if (TrinketMenu) then
		local button = CreateFrame("Button", "TrinketMenu_Reset", TrinketMenu_OptFrame, "UIPanelButtonTemplate")
		button:SetPoint("TOPLEFT", TrinketMenu_OptFrame, "TOPLEFT", 6, -4)
		button:SetWidth(80)
		button:SetHeight(20);
		button:SetText(RESET)
		button:SetScript("OnClick", function(self, button) 
			TrinketMenu.ResetSettings()
		end)
	end
end

--register for wowshell
--local WL = wsLocale:GetLocale("WoWShell");
--wsRegisterOption(
--	"UserIn",
--	"TrinketMenu",
--	WL["饰品管理器"],
--	WL["点击打开饰品管理器设置界面"],
--	"Interface\\Icons\\Inv_Trinket_Naxxramas02",
--	{
--		type = "group",
--		args = {
--			enable = {
--				type = "toggle",
--				name = WL["启用"]..WL["饰品管理器"],
--				get = function()
--					if TrinketMenuPerOptions.Visible == "OFF" then
--						return false;
--					else
--						return true;
--					end
--				end,
--				set = function(_, v)
--					if v then
--						TrinketMenuPerOptions.Visible = "ON"
--						TrinketMenu_MainFrame:Show()
--					else
--						TrinketMenuPerOptions.Visible = "OFF"
--						TrinketMenu_MainFrame:Hide()
--					end
--				end
--			},
--			advance = {
--				type = "execute",
--				name = WL["高级设定"],
--				func = function()
--					TrinketMenu.ToggleFrame(TrinketMenu_OptFrame)
--					WS_GUI:ToggleFrame(false)
--				end
--			}
--		}
--	},
--	15
--);

frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, addon) 
	if event == "ADDON_LOADED" then
		if addon == "TrinketMenu" then
			FixTrinketMiniButton()
		end
	end
end)
