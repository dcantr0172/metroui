-- Locale是自动生成的, 请不要乱加字符. 否则会出现字符串不存在错误.
-- Please make sure to save the file as UTF-8, BUT WITHOUT THE UTF-8 BOM HEADER; ¶
local L = wsLocale:NewLocale("AutoLFG", "zhTW")
if not L then return end

L["AutoLFG"] =	"AutoLFG" 
L["Enable"] =	"啟用" 
L["Enable AutoLFG"] = "隨機本自動確認進組" 
L["Igonore old dungeon"] = "忽略不是新進度的隨機副本" 
L["Toggle if you won't enter the old dungeon when bosses remainder is not max"] = "如果排到的隨機副本不是新進度 那麼就自動離開隊列" 
L["|cffffff00AutoLFG:Auto leave the queue(%s:%d/%d Bosses defeated)|r"] = "自動離開隊列(%s:已擊殺%d/%d個首領)"
L["Countdown of ignore"] = "忽略倒計時"
L["Auto leave dungeon queue by seconds that you setted"] = "設置自動離開非新進度的隨機副本的倒計時時間"
