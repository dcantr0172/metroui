if ( GetLocale() ~= 'zhTW' ) then return end
local L = {
    ['Wowshell Quest: %s: %d/%d'] = '魔獸精靈 任務助手: %s: %d/%d',
    ['Wowshell Quest: %s complete'] = '魔獸精靈 任務助手: %s 完成',
    ["Wowshell Quest"] = '任務助手',
    ["Wowshell quest helper"] = '魔獸精靈任務助手',
    ['Announce progress'] = '通報進度',
    ['Announce quest progress to group'] = '通報任務進度到小隊',
    ['Auto complete quest'] = '自動完成任務',
    ['Complete quest automatically'] = '自動完成任務',

    ['Enable automatic quest objective waypoints'] = '啟用任務嚮導箭頭',
    ['Enables the automatic setting of quest objective waypoints based on which objective is closest to your current location. This setting WILL override the setting of manual waypoints.'] = '自動任務嚮導會顯示一個指向最近任務點的箭頭. 如果啟用這項設置, 將會覆蓋你手動設置的路徑指向',
    ['Enable TomTom'] = '啟用箭頭支持插件',
    ['Last option needs TomTom support, needs reload'] = '啟用任務嚮導功能需要的其他支持插件, 需要重載',
    ['Fix TomTom support'] = '修復任務嚮導設置',
    ['If auto quest waypoints doesn\'t work, you might mess up TomTom, click here to reset TomTom'] = '如果自動任務嚮導沒有正常工作, 可能是因為你破壞了其設置, 點擊修復.',
    ['Reset arrow position'] = '重設箭頭位置',
    ['Resets the position of the waypoint arrow if its been dragged off screen'] = '如果找不到箭頭, 可以重設箭頭的位置',
['Auto unwatch complete quest'] = '自動移除完成任務',
    ['Automatically remove quest from watch list when it\'s complete'] = '自動將完成的任務從追踪列表中移除',
    ['Movable quest tracker'] = '可移動追踪列表',
    ['Let you move quest tracker'] = '讓追踪列表可以拖動',
    ['Watch frame scale'] = '追踪列表縮放',
}

local addonName, ns = ...
ns.Locale = L

