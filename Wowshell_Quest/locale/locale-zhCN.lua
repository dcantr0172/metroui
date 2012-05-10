if ( GetLocale() ~= 'zhCN' ) then return end
local L = {
    ['Wowshell Quest: %s: %d/%d'] = '魔兽精灵任务助手: %s: %d/%d',
    ['Wowshell Quest: %s complete'] = '魔兽精灵任务助手: %s 完成',
    ["Wowshell Quest"] = '任务助手',
    ["Wowshell quest helper"] = '魔兽精灵任务助手',
    ['Announce progress'] = '通报进度',
    ['Announce quest progress to group'] = '通报任务进度到小队',
    ['Auto complete quest'] = '自动完成任务',
    ['Complete quest automatically'] = '自动完成任务',

    ['Enable automatic quest objective waypoints'] = '启用任务向导箭头',
    ['Enables the automatic setting of quest objective waypoints based on which objective is closest to your current location.  This setting WILL override the setting of manual waypoints.'] = '自动任务向导会显示一个指向最近任务点的箭头. 如果启用这项设置, 将会覆盖你手动设置的路径指向',
    ['Enable TomTom'] = '启用箭头支持插件',
    ['Last option needs TomTom support, needs reload'] = '启用任务向导功能需要的其他支持插件, 需要重载',
    ['Fix TomTom support'] = '修复自动任务向导设置',
    ['If auto quest waypoints doesn\'t work, you might mess up TomTom, click here to reset TomTom'] = '如果自动任务向导没有正常工作, 可能是因为你破坏了其设置, 点击修复.',
    ['Reset arrow position'] = '重设箭头位置',
    ['Resets the position of the waypoint arrow if its been dragged off screen'] = '如果找不到箭头, 可以重设箭头的位置',
    ['Auto unwatch complete quest'] = '自动移除完成任务',
    ['Automatically remove quest from watch list when it\'s complete'] = '自动将完成的任务从追踪列表中移除',
    ['Movable quest tracker'] = '可移动追踪列表',
    ['Let you move quest tracker'] = '让追踪列表可以拖动',
    ['Watch frame scale'] = '追踪列表缩放',
}

local addonName, ns = ...
ns.Locale = L

