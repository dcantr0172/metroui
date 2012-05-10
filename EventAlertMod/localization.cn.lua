if GetLocale() ~= "zhCN" then return end

EA_TTIP_DOALERTSOUND = "事件发生时是否播放音效.";
EA_TTIP_ALERTSOUNDSELECT = "选择事件发生时所播放的音效.";
EA_TTIP_LOCKFRAME = "锁定提示框架，避免被滑鼠拖拉移动.";
EA_TTIP_SHOWFRAME = "显示/关闭 事件发生时的提示框架.";
EA_TTIP_SHOWNAME = "显示/关闭 事件发生时的法术名称.";
EA_TTIP_SHOWFLASH = "显示/关闭 事件发生时的全荧幕闪烁.";
EA_TTIP_SHOWTIMER = "显示/关闭 事件发生时的法术剩余时间.";
EA_TTIP_CHANGETIMER = "变更法术剩余时间的字体大小、位置.";
EA_TTIP_ICONSIZE = "变更提示的图示大小.";
EA_TTIP_ALLOWESC = "变更是否可用ESC键关闭提示框架. (附注: 需重新载入UI)";
EA_TTIP_ALTALERTS = "允许/关闭 EventAlertMod 提示额外类型的法术事件.";

EA_TTIP_ICONXOFFSET = "调整提示框架的水平间距.";
EA_TTIP_ICONYOFFSET = "调整提示框架的垂直间距.";
EA_TTIP_ICONREDDEBUFF = "调整本身 Debuff 图示的红色深度.";
EA_TTIP_ICONGREENDEBUFF = "调整目标 Debuff 图示的绿色深度.";
EA_TTIP_ICONEXECUTION = "调整首领血量百分比的斩杀期(0%代表关闭斩杀提示)";
EA_TTIP_PLAYERLV2BOSS = "比玩家等级高2级者(如5人副本首领)也套用首领级斩杀提示";
EA_TTIP_TAR_NEWLINE = "调整目标Debuff，是否另以单独一行显示";
EA_TTIP_TAR_ICONXOFFSET = "调整目标Debuff行与提醒框架水平间距";
EA_TTIP_TAR_ICONYOFFSET = "调整目标Debuff行与提醒框架垂直间距";
EA_TTIP_TARGET_MYDEBUFF = "调整目标Debuff行，是否仅显示玩家所施放之Debuff";
EA_TTIP_SPELLCOND_STACK = "开启/关闭, 当法术堆叠大于等于几层时才显示框架\n(可以输入的最小值由2开始)";
EA_TTIP_SPELLCOND_SELF = "开启/关闭, 只限制为玩家施放的法术, 避免监控到他人施放的相同法术";
EA_TTIP_SPELLCOND_OVERGROW = "开启/关闭, 当法术堆叠大于等于几层时以高亮显示\n(可以输入的最小值由1开始)";
EA_TTIP_SPELLCOND_REDSECTEXT = "开启/关闭, 当倒数秒数小于等于几秒时，以加大红色字体显示\n(可以输入的最小值由1开始)";
EA_TTIP_SPECFLAG_HOLYPOWER = "开启/关闭, 于本身BUFF框架左侧第一格显示圣能堆叠数";
EA_TTIP_SPECFLAG_RUNICPOWER = "开启/关闭, 于本身BUFF框架左侧第一格显示符文能量";
EA_TTIP_SPECFLAG_SOULSHARDS = "开启/关闭, 于本身BUFF框架左侧第一格显示灵魂能量";
EA_TTIP_SPECFLAG_ECLIPSE = "开启/关闭, 于本身BUFF框架左侧第一格显示日月能量";
EA_TTIP_SPECFLAG_COMBOPOINT = "开启/关闭, 于目标DEBUFF框架左侧第一格显示集星连击数";
EA_TTIP_SPECFLAG_LIFEBLOOM = "开启/关闭, 于本身BUFF框架左侧第一格显示生命之花堆叠与时间";


EA_CLASS_DK = "DEATHKNIGHT";
EA_CLASS_DRUID = "DRUID";
EA_CLASS_HUNTER = "HUNTER";
EA_CLASS_MAGE = "MAGE";
EA_CLASS_PALADIN = "PALADIN";
EA_CLASS_PRIEST = "PRIEST";
EA_CLASS_ROGUE = "ROGUE";
EA_CLASS_SHAMAN = "SHAMAN";
EA_CLASS_WARLOCK = "WARLOCK";
EA_CLASS_WARRIOR = "WARRIOR";
EA_CLASS_FUNKY = "FUNKY";
EA_CLASS_OTHER = "OTHER";

EA_XOPT_ICONPOSOPT = "图示位置选项";
EA_XOPT_SHOW_ALTFRAME = "显示主提示框架";
EA_XOPT_SHOW_BUFFNAME = "显示法术名称";
EA_XOPT_SHOW_TIMER = "显示倒数秒数";
EA_XOPT_SHOW_OMNICC = "秒数显示于框架内";
EA_XOPT_SHOW_FULLFLASH = "显示全荧幕闪烁提示";
EA_XOPT_PLAY_SOUNDALERT = "播放声音提示";
EA_XOPT_ESC_CLOSEALERT = "ESC 关闭提示";
EA_XOPT_SHOW_ALTERALERT = "显示额外提示";
EA_XOPT_SHOW_CHECKLISTALERT = "启用";
EA_XOPT_SHOW_CLASSALERT = "本职业-增减益提示";
EA_XOPT_SHOW_OTHERALERT = "跨职业-增减益提示";
EA_XOPT_SHOW_TARGETALERT = "目标的-增减益提示";
EA_XOPT_SHOW_SCDALERT = "本职业-技能CD提示";
EA_XOPT_OKAY = "关闭";
EA_XOPT_SAVE = "储存";
EA_XOPT_VERURLTEXT = "插件发布网址：";
EA_XOPT_VERBTN1 = "巴哈";
EA_XOPT_VERBTN2 = "藏宝箱";
EA_XOPT_VERURL1 = "http://forum.gamer.com.tw/C.php?bsn=05219&snA=464455&tnum=44&subbsn=26";
EA_XOPT_VERURL2 = "http://wowbox.yatta.com.tw/bbs/viewtopic.php?f=84&t=21778";
EA_XOPT_SPELLCOND_STACK = "法术堆叠>=几层时显示框架:";
EA_XOPT_SPELLCOND_SELF = "只限制为玩家施放的法术";
EA_XOPT_SPELLCOND_OVERGROW = "法术堆叠>=几层时显示高亮:"
EA_XOPT_SPELLCOND_REDSECTEXT = "倒数秒数<=几秒时显示红字:"
EA_XOPT_SPECFLAG_HOLYPOWER = "圣能";
EA_XOPT_SPECFLAG_RUNICPOWER = "符文能量";
EA_XOPT_SPECFLAG_SOULSHARDS = "灵魂能量";
EA_XOPT_SPECFLAG_ECLIPSE = "日月能量";
EA_XOPT_SPECFLAG_COMBOPOINT = "贼/猫德连击数";
EA_XOPT_SPECFLAG_LIFEBLOOM = "生命之花";

EA_XICON_LOCKFRAME = "锁定提示框架";
EA_XICON_LOCKFRAMETIP = "若要移动‘提示框架’或‘重设框架位置’时，请将‘锁定提示框架’的打勾取消";
EA_XICON_ICONSIZE = "图示大小";
EA_XICON_LARGE = "大";
EA_XICON_SMALL = "小";
EA_XICON_HORSPACE = "水平间距";
EA_XICON_VERSPACE = "垂直间距";
EA_XICON_MORE = "多";
EA_XICON_LESS = "少";
EA_XICON_REDDEBUFF = "本身Debuff图示红色深度";
EA_XICON_GREENDEBUFF = "目标Debuff图示绿色深度";
EA_XICON_DEEP = "深";
EA_XICON_LIGHT = "淡";
EA_XICON_TAR_NEWLINE = "目标Debuff以另一行显示";
EA_XICON_TAR_HORSPACE = "与提醒框架水平间距";
EA_XICON_TAR_VERSPACE = "与提醒框架垂直间距";
EA_XICON_TOGGLE_ALERTFRAME = "显示/隐藏 提示框架";
EA_XICON_RESET_FRAMEPOS = "重设框架位置";
EA_XICON_SELF_BUFF = "本身Buff";
EA_XICON_SELF_DEBUFF = "本身Debuff";
EA_XICON_TARGET_DEBUFF = "目标Debuff";
EA_XICON_SCD = "技能CD";
EA_XICON_EXECUTION = "提示首领级目标血量斩杀期";
EA_XICON_EXEFULL = "50%";
EA_XICON_EXECLOSE = "关闭";

EX_XCLSALERT_SELALL = "全选";
EX_XCLSALERT_CLRALL = "全不选";
EX_XCLSALERT_LOADDEFAULT = "载入预设";
EX_XCLSALERT_SPELL = "法术ID:";
EX_XCLSALERT_ADDSPELL = "新增";
EX_XCLSALERT_DELSPELL = "删除";
EX_XCLSALERT_HELP1 = "上面列表以[法术ID]作为排列顺序";
EX_XCLSALERT_HELP2 = "若想查询法术ID，建议输入 /eam help 指令";
EX_XCLSALERT_HELP3 = "了解在游戏中[查询法术]的各种指令。";
EX_XCLSALERT_HELP4 = "额外提醒区为非Buff类型之条件式技能";
EX_XCLSALERT_HELP5 = "例如:敌人血量进入斩杀期,或招架后使用";
EX_XCLSALERT_HELP6 = ",不会额外显示Buff,却能使用的技能。";
EX_XCLSALERT_SPELLURL = "http://www.wowbox.tw/spell.php?sname=";
EA_XTARALERT_TARGET_MYDEBUFF = "仅限玩家施放减益";

EA_XSPECINFO_COMBOPOINT = "连击数";
EA_XSPECINFO_RUNICPOWER	= "符能";
EA_XSPECINFO_SOULSHARDS	= "灵魂能量";
EA_XSPECINFO_ECLIPSE	= "月能";
EA_XSPECINFO_ECLIPSEORG	= "日能";
EA_XSPECINFO_HOLYPOWER	= "圣能";

EA_XLOOKUP_START1 = "查询法术名称";
EA_XLOOKUP_START2 = "完整符合";
EA_XLOOKUP_RESULT1 = "查询法术结果";
EA_XLOOKUP_RESULT2 = "项符合";

EA_XLOAD_FIRST_LOAD = "\124cffFF0000首次载入 EventAlertMod 特效触发提示UI，载入预设参数\124r。\n\n"..
"请使用 \124cffFFFF00/eam opt\124r 来进行参数设定、监控法术设定。\n\n";

EA_XLOAD_NEWVERSION_LOAD = "请使用 \124cffFFFF00/eam help\124r 查阅详细指令说明。\n\n\n"..
"\124cff00FFFF- 主要更新项目 -\124r\n\n"..
"1.LUA修正：WOW 4.2 改版，修正COMBAT_LOG_EVENT_UNFILTERED参数顺序。\n\n"..
"2.LUA修正：修正跨伺服随机时，生命之花堆叠侦测，无法显示问题。\n\n"..
"3.LUA修正：法术ID可输入6位数。\n\n"..
"4.功能新增：法术条件项目新增，当倒数秒数低于n时，可将秒数字体以加大红字显示。\n\n"..
"5.内建清单新增：补德-共生-100977, 萨满-雷霆风暴-100955\n\n"..
""; -- END OF NEWVERSION

EA_XCMD_VER = " \124cff00FFFFBy 永恒满月@冰风岗哨\124r 版本: ";
EA_XCMD_DEBUG = " 模式: ";
EA_XCMD_SELFLIST = " 显示自身Buff/Debuff: ";
EA_XCMD_TARGETLIST = " 显示目标Debuff: ";
EA_XCMD_CASTSPELL = " 显示施放法术ID: ";
EA_XCMD_AUTOADD_SELFLIST = " 自动新增本身全增减益: ";
EA_XCMD_ENVADD_SELFLIST = " 自动新增本身环境增减益: ";
EA_XCMD_DEBUG_P0 = "触发法术清单";
EA_XCMD_DEBUG_P1 = "法术";
EA_XCMD_DEBUG_P2 = "法术ID";
EA_XCMD_DEBUG_P3 = "堆叠";
EA_XCMD_DEBUG_P4 = "持续秒数";

EA_XCMD_CMDHELP = {
	["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00指令\124r说明(/eventalertmod or /eam):",
	["OPT"] = "\124cff00FF00/eam options(或opt)\124r - 显示/关闭 主设定视窗.",
	["HELP"] = "\124cff00FF00/eam help\124r - 显示进一步指令说明.",
	["SHOW"] = {
		"\124cff00FF00/eam show [sec]\124r -",
		"开始/停止, 持续列出 >玩家< 身上所有 Buff/Debuff 的法术ID. 并且持续时间为 sec 秒之内的法术",
	},
	["SHOWT"] = {
		"\124cff00FF00/eam showtarget(或showt) [sec]\124r -",
		"开始/停止, 持续列出 >目标< 身上所有 Debuff 的法术ID. 并且持续时间为 sec 秒之内的法术",
	},
	["SHOWC"] = {
		"\124cff00FF00/eam showcast(或showc)\124r -",
		"开始/停止, 成功施放法术之后, 列出所施放的法术ID",
	},
	["SHOWA"] = {
		"\124cff00FF00/eam showautoadd(或showa) [sec]\124r -",
		"开始/停止, 自动将 >玩家< 身上所有 Buff/Debuff 的法术加入监测清单. 并且持续时间为 sec 秒(预设为60秒)之内的法术",
	},
	["SHOWE"] = {
		"\124cff00FF00/eam showenvadd(或showe) [sec]\124r -",
		"开始/停止, 自动将 >玩家< 身上 Buff/Debuff 的法术(但排除来自团队与队伍的)加入监测清单. 并且持续时间为 sec 秒(预设为60秒)之内的法术",
	},
	["LIST"] = {
		"\124cff00FF00/eam list\124r - 显示触发法术清单",
		"显示/隐藏 show, showc, showt, lookup, lookupfull 指令的输出结果",
	},
	["LOOKUP"] = {
		"\124cff00FF00/eam lookup(或l) 查询名称\124r - 部份名称查询法术ID",
		"查询游戏中所有法术，并列出所有[部份符合]查询名称的法术ID",
	},
	["LOOKUPFULL"] = {
		"\124cff00FF00/eam lookupfull(或lf) 查询名称\124r - 完整名称查询法术ID",
		"查询游戏中所有法术，并列出所有[完整符合]查询名称的法术ID",
	},
}
