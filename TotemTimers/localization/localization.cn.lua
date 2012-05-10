if ( GetLocale() == "zhCN" ) then
_G["BINDING_HEADER_TOTEMTIMERSHEADER"] = "TotemTimers"
_G["BINDING_NAME_TOTEMTIMERSAIR"] = "Cast active air totem"
_G["BINDING_NAME_TOTEMTIMERSAIRMENU"] = "Open air totem menu"
_G["BINDING_NAME_TOTEMTIMERSEARTH"] = "Cast active earth totem"
_G["BINDING_NAME_TOTEMTIMERSEARTHMENU"] = "Open earth totem menu"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDLEFT"] = "Earth Shield Leftclick"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDMIDDLE"] = "Earth Shield Middleclick"
_G["BINDING_NAME_TOTEMTIMERSEARTHSHIELDRIGHT"] = "Earth Shield Rightclick"
_G["BINDING_NAME_TOTEMTIMERSFIRE"] = "Cast active fire totem"
_G["BINDING_NAME_TOTEMTIMERSFIREMENU"] = "Open fire totem menu"
_G["BINDING_NAME_TOTEMTIMERSWATER"] = "Cast active water totem"
_G["BINDING_NAME_TOTEMTIMERSWATERMENU"] = "Open water totem menu"
_G["BINDING_NAME_TOTEMTIMERSWEAPONBUFF1"] = "Weapon Buff 1"
_G["BINDING_NAME_TOTEMTIMERSWEAPONBUFF2"] = "Weapon Buff 2"

end


local L = LibStub("AceLocale-3.0"):NewLocale("TotemTimers", "zhCN")
if not L then return end

L["Air Button"] = "空气图腾按钮" -- Requires localization
L["Ctrl-Leftclick to remove weapon buffs"] = "Ctrl-左键点击 移除武器Buff"
L["Delete Set"] = "删除图腾设置 %u?" -- Requires localization
L["Earth Button"] = "大地图腾按钮" -- Requires localization
L["Fire Button"] = "火焰图腾按钮" -- Requires localization
L["Leftclick to cast %s"] = "左键点击施放 %s"
L["Leftclick to cast spell"] = "左键点击施放法术"
L["Leftclick to load totem set to %s"] = "点击左键读取 %s 的配置" -- Requires localization
L["Leftclick to open totem set menu"] = "点击左键打开图腾设置表菜单" -- Requires localization
L["Maelstrom Notifier"] = "漩涡武器就绪！"
L["Middleclick to cast %s"] = "中键点击施放 %s"
L["Next leftclick casts %s"] = "下一个左键点击施放 %s"
L["Reset"] = "重置图腾计时器！"
L["Rightclick to assign both %s and %s to leftclick"] = "右键点击指定 %s 和 %s 都到左键点击"
L["Rightclick to assign spell to leftclick"] = "右键点击指定法术到左键点击"
L["Rightclick to cast %s"] = "右键点击施放 %s"
L["Rightclick to delete totem set"] = "点击右键删除图腾配置" -- Requires localization
L["Rightclick to save active totem configuration as set"] = "点击右键将当前活动的设置保存到配置中" -- Requires localization
L["Rightclick to set %s as active multicast spell"] = "点击右键将 %s 设置为当前活动的快速施法" -- Requires localization
L["Shield removed"] = "%s效果消失。"
L["Shift-Rightclick to assign spell to middleclick"] = "Shift-右键点击 指定法术到鼠标中键点击"
L["Shift-Rightclick to assign spell to rightclick"] = "Shift-右键点击 指定法术到右键点击"
L["Totem Destroyed"] = "%s被摧毁了。"
L["Totem Expired"] = "s到期了。"
L["Totem Expiring"] = "s即将到期。"
L["Water Button"] = "水图腾按钮" -- Requires localization
