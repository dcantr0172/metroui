-- Locale是自动生成的, 请不要乱加字符. 否则会出现字符串不存在错误.
-- This is the base locale; values can be "true" so they default to their key, or any string to override that behaviour.
local L = wsLocale:NewLocale("AutoLFG", "zhCN", true)


L["AutoLFG"] =	"AutoLFG" 
L["Enable"] =	"启用" 
L["Enable AutoLFG"] = "随机本自动确认进组" 
L["Igonore old dungeon"] = "忽略不是新进度的随机本" 
L["Toggle if you won't enter the old dungeon when bosses remainder is not max"] = "如果排到的随机副本不是新进度 那么就自动离开队列" 
L["|cffffff00AutoLFG:Auto leave the queue(%s:%d/%d Bosses defeated)|r"] = "|cffffff00AutoLFG:自动离开队列(%s:已击杀%d/%d个首领)|r"
L["Countdown of ignore"] = "忽略倒计时"
L["Auto leave dungeon queue by seconds that you setted"] = "设置自动离开非新进度的随机本的倒计时时间"
