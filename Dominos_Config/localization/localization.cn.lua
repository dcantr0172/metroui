﻿--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com

	Simple Chinese : 简体中文
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'zhCN')
if not L then return end

L.Scale = '缩放'
L.Opacity = '透明度'
L.FadedOpacity = '半隐藏状态透明度'
L.Visibility = '可见度'
L.Spacing = '间隔'
L.Padding = '填充'
L.Layout = '布局'
L.Columns = '列'
L.Size = '大小'
L.Modifiers = '修饰键'
L.QuickPaging = '快速翻页'
L.Targeting = '选择目标时'
L.ShowStates = '显示状态'
L.Set = '设置'
L.Save = '保存'
L.Copy = '复制'
L.Delete = '删除'
L.Bar = '动作条 %d'
L.RightClickUnit = '右键点击'
L.RCUPlayer = '自己'
L.RCUFocus = '焦点'
L.RCUToT = '目标的目标'
L.EnterName = '输入名称'
L.PossessBar = '载具/心灵控制动作条'
L.Profiles = '配置管理'
L.ProfilesPanelDesc = '允许你管理Dominos插件的配置'
L.SelfcastKey = '自我施法按键'
L.QuickMoveKey = '快速移动按键'
L.ShowMacroText = '显示宏名称'
L.ShowBindingText = '显示按键绑定文字'
L.ShowEmptyButtons = '显示空按钮'
L.LockActionButtons = '锁定动作条位置'
L.EnterBindingMode = '绑定按键...'
L.EnterConfigMode = '进入设置模式'
L.ActionBarSettings = '动作条 %d 设置'
L.BarSettings = '%s 动作条设置'
L.ShowTooltips = '显示鼠标提示'
L.ShowTooltipsCombat = '战斗中显示鼠标提示'
L.OneBag = '只现实一个背包图标'
L.ShowKeyring = '显示钥匙链'
L.StickyBars = '粘附动作条'
L.ShowMinimapButton = '显示小地图按钮'
L.Advanced = '高级'
L.LeftToRight = '按钮从左至右排列'
L.TopToBottom = '按钮从上至下排列'
L.LinkedOpacity = '粘附动作条继承透明度'
L.ClickThrough = '允许穿透点击'

L.ALT_KEY_TEXT = 'ALT'

L.State_HELP = '帮助'
L.State_HARM = '损害'
L.State_NOTARGET = '无目标'
L.State_ALTSHIFT = 'ALT-' .. SHIFT_KEY_TEXT
L.State_CTRLSHIFT = CTRL_KEY_TEXT .. '-' .. SHIFT_KEY_TEXT
L.State_CTRLALT = CTRL_KEY_TEXT .. '-ALT'
L.State_CTRLALTSHIFT = CTRL_KEY_TEXT .. '-ALT-' .. SHIFT_KEY_TEXT

--totems
L.ShowTotems = '显示图腾'
L.ShowTotemRecall = '显示回收'
