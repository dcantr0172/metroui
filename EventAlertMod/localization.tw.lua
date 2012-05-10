if GetLocale() ~= "zhTW" then return end

EA_TTIP_DOALERTSOUND = "事件發生時是否播放音效.";
EA_TTIP_ALERTSOUNDSELECT = "選擇事件發生時所播放的音效.";
EA_TTIP_LOCKFRAME = "鎖定提示框架，避免被滑鼠拖拉移動.";
EA_TTIP_SHOWFRAME = "顯示/關閉 事件發生時的提示框架.";
EA_TTIP_SHOWNAME = "顯示/關閉 事件發生時的法術名稱.";
EA_TTIP_SHOWFLASH = "顯示/關閉 事件發生時的全螢幕閃爍.";
EA_TTIP_SHOWTIMER = "顯示/關閉 事件發生時的法術剩餘時間.";
EA_TTIP_CHANGETIMER = "變更法術剩餘時間的字體大小、位置.";
EA_TTIP_ICONSIZE = "變更提示的圖示大小.";
EA_TTIP_ALLOWESC = "變更是否可用ESC鍵關閉提示框架. (附註: 需重新載入UI)";
EA_TTIP_ALTALERTS = "允許/關閉 EventAlertMod 提示額外類型的法術事件.";

EA_TTIP_ICONXOFFSET = "調整提示框架的水平間距.";
EA_TTIP_ICONYOFFSET = "調整提示框架的垂直間距.";
EA_TTIP_ICONREDDEBUFF = "調整本身 Debuff 圖示的紅色深度.";
EA_TTIP_ICONGREENDEBUFF = "調整目標 Debuff 圖示的綠色深度.";
EA_TTIP_ICONEXECUTION = "調整首領血量百分比的斬殺期(0%代表關閉斬殺提示)";
EA_TTIP_PLAYERLV2BOSS = "比玩家等級高2級者(如5人副本首領)也套用首領級斬殺提示";
EA_TTIP_TAR_NEWLINE = "調整目標Debuff，是否另以單獨一行顯示";
EA_TTIP_TAR_ICONXOFFSET = "調整目標Debuff行與提醒框架水平間距";
EA_TTIP_TAR_ICONYOFFSET = "調整目標Debuff行與提醒框架垂直間距";
EA_TTIP_TARGET_MYDEBUFF = "調整目標Debuff行，是否僅顯示玩家所施放之Debuff";
EA_TTIP_SPELLCOND_STACK = "開啟/關閉, 當法術堆疊大於等於幾層時才顯示框架\n(可以輸入的最小值由2開始)";
EA_TTIP_SPELLCOND_SELF = "開啟/關閉, 只限制為玩家施放的法術, 避免監控到他人施放的相同法術";
EA_TTIP_SPELLCOND_OVERGROW = "開啟/關閉, 當法術堆疊大於等於幾層時以高亮顯示\n(可以輸入的最小值由1開始)";
EA_TTIP_SPELLCOND_REDSECTEXT = "開啟/關閉, 當倒數秒數小於等於幾秒時，以加大紅色字體顯示\n(可以輸入的最小值由1開始)";
EA_TTIP_SPECFLAG_HOLYPOWER = "開啟/關閉, 於本身BUFF框架左側第一格顯示聖能堆疊數";
EA_TTIP_SPECFLAG_RUNICPOWER = "開啟/關閉, 於本身BUFF框架左側第一格顯示符文能量";
EA_TTIP_SPECFLAG_SOULSHARDS = "開啟/關閉, 於本身BUFF框架左側第一格顯示靈魂能量";
EA_TTIP_SPECFLAG_ECLIPSE = "開啟/關閉, 於本身BUFF框架左側第一格顯示日月能量";
EA_TTIP_SPECFLAG_COMBOPOINT = "開啟/關閉, 於目標DEBUFF框架左側第一格顯示集星連擊數";
EA_TTIP_SPECFLAG_LIFEBLOOM = "開啟/關閉, 於本身BUFF框架左側第一格顯示生命之花堆疊與時間";


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

EA_XOPT_ICONPOSOPT = "圖示位置選項";
EA_XOPT_SHOW_ALTFRAME = "顯示主提示框架";
EA_XOPT_SHOW_BUFFNAME = "顯示法術名稱";
EA_XOPT_SHOW_TIMER = "顯示倒數秒數";
EA_XOPT_SHOW_OMNICC = "秒數顯示於框架內";
EA_XOPT_SHOW_FULLFLASH = "顯示全螢幕閃爍提示";
EA_XOPT_PLAY_SOUNDALERT = "播放聲音提示";
EA_XOPT_ESC_CLOSEALERT = "ESC 關閉提示";
EA_XOPT_SHOW_ALTERALERT = "顯示額外提示";
EA_XOPT_SHOW_CHECKLISTALERT = "啟用";
EA_XOPT_SHOW_CLASSALERT = "本職業-增減益提示";
EA_XOPT_SHOW_OTHERALERT = "跨職業-增減益提示";
EA_XOPT_SHOW_TARGETALERT = "目標的-增減益提示";
EA_XOPT_SHOW_SCDALERT = "本職業-技能CD提示";
EA_XOPT_OKAY = "關閉";
EA_XOPT_SAVE = "儲存";
EA_XOPT_VERURLTEXT = "插件發布網址：";
EA_XOPT_VERBTN1 = "巴哈";
EA_XOPT_VERBTN2 = "藏寶箱";
EA_XOPT_VERURL1 = "http://forum.gamer.com.tw/C.php?bsn=05219&snA=464455&tnum=44&subbsn=26";
EA_XOPT_VERURL2 = "http://wowbox.yatta.com.tw/bbs/viewtopic.php?f=84&t=21778";
EA_XOPT_SPELLCOND_STACK = "法術堆疊>=幾層時顯示框架:";
EA_XOPT_SPELLCOND_SELF = "只限制為玩家施放的法術";
EA_XOPT_SPELLCOND_OVERGROW = "法術堆疊>=幾層時顯示高亮:"
EA_XOPT_SPELLCOND_REDSECTEXT = "倒數秒數<=幾秒時顯示紅字:"
EA_XOPT_SPECFLAG_HOLYPOWER = "聖能";
EA_XOPT_SPECFLAG_RUNICPOWER = "符文能量";
EA_XOPT_SPECFLAG_SOULSHARDS = "靈魂能量";
EA_XOPT_SPECFLAG_ECLIPSE = "日月能量";
EA_XOPT_SPECFLAG_COMBOPOINT = "賊/貓德連擊數";
EA_XOPT_SPECFLAG_LIFEBLOOM = "生命之花";

EA_XICON_LOCKFRAME = "鎖定提示框架";
EA_XICON_LOCKFRAMETIP = "若要移動『提示框架』或『重設框架位置』時，請將『鎖定提示框架』的打勾取消";
EA_XICON_ICONSIZE = "圖示大小";
EA_XICON_LARGE = "大";
EA_XICON_SMALL = "小";
EA_XICON_HORSPACE = "水平間距";
EA_XICON_VERSPACE = "垂直間距";
EA_XICON_MORE = "多";
EA_XICON_LESS = "少";
EA_XICON_REDDEBUFF = "本身Debuff圖示紅色深度";
EA_XICON_GREENDEBUFF = "目標Debuff圖示綠色深度";
EA_XICON_DEEP = "深";
EA_XICON_LIGHT = "淡";
EA_XICON_TAR_NEWLINE = "目標Debuff以另一行顯示";
EA_XICON_TAR_HORSPACE = "與提醒框架水平間距";
EA_XICON_TAR_VERSPACE = "與提醒框架垂直間距";
EA_XICON_TOGGLE_ALERTFRAME = "顯示/隱藏 提示框架";
EA_XICON_RESET_FRAMEPOS = "重設框架位置";
EA_XICON_SELF_BUFF = "本身Buff";
EA_XICON_SELF_DEBUFF = "本身Debuff";
EA_XICON_TARGET_DEBUFF = "目標Debuff";
EA_XICON_SCD = "技能CD";
EA_XICON_EXECUTION = "提示首領級目標血量斬殺期";
EA_XICON_EXEFULL = "50%";
EA_XICON_EXECLOSE = "關閉";

EX_XCLSALERT_SELALL = "全選";
EX_XCLSALERT_CLRALL = "全不選";
EX_XCLSALERT_LOADDEFAULT = "載入預設";
EX_XCLSALERT_SPELL = "法術ID:";
EX_XCLSALERT_ADDSPELL = "新增";
EX_XCLSALERT_DELSPELL = "刪除";
EX_XCLSALERT_HELP1 = "上面列表以[法術ID]作為排列順序";
EX_XCLSALERT_HELP2 = "若想查詢法術ID，建議輸入 /eam help 指令";
EX_XCLSALERT_HELP3 = "瞭解在遊戲中[查詢法術]的各種指令。";
EX_XCLSALERT_HELP4 = "額外提醒區為非Buff類型之條件式技能";
EX_XCLSALERT_HELP5 = "例如:敵人血量進入斬殺期,或招架後使用";
EX_XCLSALERT_HELP6 = ",不會額外顯示Buff,卻能使用的技能。";
EX_XCLSALERT_SPELLURL = "http://www.wowbox.tw/spell.php?sname=";
EA_XTARALERT_TARGET_MYDEBUFF = "僅限玩家施放減益";

EA_XSPECINFO_COMBOPOINT = "連擊數";
EA_XSPECINFO_RUNICPOWER	= "符能";
EA_XSPECINFO_SOULSHARDS	= "靈魂能量";
EA_XSPECINFO_ECLIPSE	= "月能";
EA_XSPECINFO_ECLIPSEORG	= "日能";
EA_XSPECINFO_HOLYPOWER	= "聖能";

EA_XLOOKUP_START1 = "查詢法術名稱";
EA_XLOOKUP_START2 = "完整符合";
EA_XLOOKUP_RESULT1 = "查詢法術結果";
EA_XLOOKUP_RESULT2 = "項符合";

EA_XLOAD_FIRST_LOAD = "\124cffFF0000首次載入 EventAlertMod 特效觸發提示UI，載入預設參數\124r。\n\n"..
"請使用 \124cffFFFF00/eam opt\124r 來進行參數設定、監控法術設定。\n\n";

EA_XLOAD_NEWVERSION_LOAD = "請使用 \124cffFFFF00/eam help\124r 查閱詳細指令說明。\n\n\n"..
"\124cff00FFFF- 主要更新項目 -\124r\n\n"..
"1.LUA修正：WOW 4.2 改版，修正COMBAT_LOG_EVENT_UNFILTERED參數順序。\n\n"..
"2.LUA修正：修正跨伺服隨機時，生命之花堆疊偵測，無法顯示問題。\n\n"..
"3.LUA修正：法術ID可輸入6位數。\n\n"..
"4.功能新增：法術條件項目新增，當倒數秒數低於n時，可將秒數字體以加大紅字顯示。\n\n"..
"5.內建清單新增：補德-共生-100977, 薩滿-雷霆風暴-100955\n\n"..
""; -- END OF NEWVERSION

EA_XCMD_VER = " \124cff00FFFFBy 永恆滿月@冰風崗哨\124r 版本: ";
EA_XCMD_DEBUG = " 模式: ";
EA_XCMD_SELFLIST = " 顯示自身Buff/Debuff: ";
EA_XCMD_TARGETLIST = " 顯示目標Debuff: ";
EA_XCMD_CASTSPELL = " 顯示施放法術ID: ";
EA_XCMD_AUTOADD_SELFLIST = " 自動新增本身全增減益: ";
EA_XCMD_ENVADD_SELFLIST = " 自動新增本身環境增減益: ";
EA_XCMD_DEBUG_P0 = "觸發法術清單";
EA_XCMD_DEBUG_P1 = "法術";
EA_XCMD_DEBUG_P2 = "法術ID";
EA_XCMD_DEBUG_P3 = "堆疊";
EA_XCMD_DEBUG_P4 = "持續秒數";

EA_XCMD_CMDHELP = {
	["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00指令\124r說明(/eventalertmod or /eam):",
	["OPT"] = "\124cff00FF00/eam options(或opt)\124r - 顯示/關閉 主設定視窗.",
	["HELP"] = "\124cff00FF00/eam help\124r - 顯示進一步指令說明.",
	["SHOW"] = {
		"\124cff00FF00/eam show [sec]\124r -",
		"開始/停止, 持續列出 >玩家< 身上所有 Buff/Debuff 的法術ID. 並且持續時間為 sec 秒之內的法術",
	},
	["SHOWT"] = {
		"\124cff00FF00/eam showtarget(或showt) [sec]\124r -",
		"開始/停止, 持續列出 >目標< 身上所有 Debuff 的法術ID. 並且持續時間為 sec 秒之內的法術",
	},
	["SHOWC"] = {
		"\124cff00FF00/eam showcast(或showc)\124r -",
		"開始/停止, 成功施放法術之後, 列出所施放的法術ID",
	},
	["SHOWA"] = {
		"\124cff00FF00/eam showautoadd(或showa) [sec]\124r -",
		"開始/停止, 自動將 >玩家< 身上所有 Buff/Debuff 的法術加入監測清單. 並且持續時間為 sec 秒(預設為60秒)之內的法術",
	},
	["SHOWE"] = {
		"\124cff00FF00/eam showenvadd(或showe) [sec]\124r -",
		"開始/停止, 自動將 >玩家< 身上 Buff/Debuff 的法術(但排除來自團隊與隊伍的)加入監測清單. 並且持續時間為 sec 秒(預設為60秒)之內的法術",
	},
	["LIST"] = {
		"\124cff00FF00/eam list\124r - 顯示觸發法術清單",
		"顯示/隱藏 show, showc, showt, lookup, lookupfull 指令的輸出結果",
	},
	["LOOKUP"] = {
		"\124cff00FF00/eam lookup(或l) 查詢名稱\124r - 部份名稱查詢法術ID",
		"查詢遊戲中所有法術，並列出所有[部份符合]查詢名稱的法術ID",
	},
	["LOOKUPFULL"] = {
		"\124cff00FF00/eam lookupfull(或lf) 查詢名稱\124r - 完整名稱查詢法術ID",
		"查詢遊戲中所有法術，並列出所有[完整符合]查詢名稱的法術ID",
	},
}