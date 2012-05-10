-- Advanced Trade Skill Window v0.8.0
-- copyright 2006-2009 by Rene Schneider (Slarti on EU-Blackhand)

-- language file

-- German and English Language by myself
-- French Language by Nilyn (EU Dalaran Alliance Server)
-- Español por Jsr1976-Fili
-- zhCN and zhTW by Diablohu@è½»é£Žä¹‹è¯­ http://www.dreamgen.cn

ATSW_VERSION = "ATSW v0.8.0 - by Slarti on EU-Blackhand";

if(GetLocale()=="zhCN") then
    ATSW_VERSION = "商业技能助手 v0.8.0";

	ATSW_SORTBYHEADERS = "按分类排序";
	ATSW_SORTBYNAMES = "按名称排序";
	ATSW_SORTBYDIFFICULTY = "按制作难度排序";
	ATSW_CUSTOMSORTING = "按自定义分类";
	ATSW_QUEUE = "列队";
	ATSW_QUEUEALL = "列队所有";
	ATSW_DELETELETTER = "删";
	ATSW_STARTQUEUE = "开始制造";
	ATSW_STOPQUEUE = "停止制造";
	ATSW_DELETEQUEUE = "清空队列";
	ATSW_ITEMSMISSING1 = "制造";
	ATSW_ITEMSMISSING2 = "缺少的材料：";
	ATSW_FILTERLABEL = "搜索:";
	ATSW_REAGENTLIST1 = "制造";
	ATSW_REAGENTLIST2 = "所需材料：";
	ATSW_REAGENTFRAMETITLE = "制造队列中物品所需材料";
	ATSW_REAGENTBUTTON = "材料";
	ATSW_REAGENTFRAME_CH1 = "背包";
	ATSW_REAGENTFRAME_CH2 = "银行";
	ATSW_REAGENTFRAME_CH3 = "另角色";
	ATSW_REAGENTFRAME_CH4 = "可购买";
	ATSW_ALTLIST1 = "以下角色拥有'";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " (背包) ";
	ATSW_ALTLIST4 = " (银行) ";
	ATSW_OPTIONS_TITLE = "ATSW 设置";
	ATSWOFIB_TEXT = "考虑银行中的材料";
	ATSWOFIA_TEXT = "考虑其他角色上背包和银行中的材料";
	ATSWOFIM_TEXT = "考虑可购买的材料";
	ATSWOFUCB_TEXT = "显示采用以下设置的可制造数";
	ATSWOFSCB_TEXT = "显示由背包中的原料可制造数和采用以下设置\n的可制造数";
	ATSWOFTB_TEXT = "开启配方说明";
	ATSW_OPTIONSBUTTON = "设置";
	ATSW_BUYREAGENTBUTTON = "从当前商人处购买材料";
	ATSWOFAB_TEXT = "当与商人对话时自动购买所需材料";
	ATSW_AUTOBUYMESSAGE = "ATSW 已自动购买如下物品:";
	ATSW_TOOLTIP_PRODUCABLE = "个可由背包中的材料制造"
	ATSW_TOOLTIP_NECESSARY = "制作1件此物品所需材料:";
	ATSW_TOOLTIP_BUYABLE = " (可购买)";
	ATSW_TOOLTIP_LEGEND = "(背包中的数量 / 银行中的数量 / 其他角色上的数量)";
	ATSW_CONTINUEQUEUE = "继续制造";
	ATSW_ABORTQUEUE = "停止制造";
	ATSWCF_TITLE = "是否继续？";
	ATSWCF_TEXT = "1.10版本后，制作物品需要一次鼠标点击。单击“确定”以继续。";
	ATSWCF_TITLE2 = "队列中下一件物品为:";
	ATSW_CSBUTTON = "编辑分类";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "该商人出售你所需的材料！";
	ATSW_AUTOBUYBUTTON_TEXT = "购买材料";
	ATSW_SHOPPINGLISTFRAMETITLE = "购物清单 - 制作队列中物品所缺少的材料";
	ATSWOFSLB_TEXT = "在拍卖行中显示购物清单";
	ATSW_ENCHANT = "附魔";
	ATSW_ACTIVATIONMESSAGE = "ATSW 已";
	ATSW_ACTIVATED = "针对当前商业技能开启";
	ATSW_DEACTIVATED = "针对当前商业技能关闭";
	ATSW_SCAN_MINLEVEL = "^需要等级 (%d+)";
	ATSW_QUEUESDELETED = "已清空所有队列";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - 材料表";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "以下角色目前拥有需要的材料：";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "无队列";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "在 ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "在其他角色";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "可购买";
	ATSW_GETFROMBANK = "从银行中取出材料";
	ATSWOFRLB_TEXT = "如果任意角色的制造队列中存有队列，在访问银行时自动\n打开材料列表。";
	ATSWOFNRLB_TEXT = "使用整合型配方链接以替代多行链接。";

	atsw_blacklist = {
		[1] = "轻皮",
		[2] = "中皮",
		[3] = "重皮",
		[4] = "厚皮",
		[5] = "硬甲皮",
		[6] = "结缔皮",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - 自定义分类编辑器";
	ATSWCS_TRADESKILLISTTITLE = "未分类";
	ATSWCS_CATEGORYLISTTITLE = "已分类";
	ATSWCS_ADDCATEGORY = "新建分类";
	ATSWCS_NOTHINGINCATEGORY = "< 空 >";
	ATSWCS_UNCATEGORIZED = "未分类";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW 配方扫描";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW 正在扫描您的配方以将其从服务器保存入本地缓存中";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "初始化...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "跳过";
	ATSW_SCAN_DELAY_FRAME_ABORT = "停止";

	ATSW_ONLYCREATABLE = "只显示足够材料制造";
elseif (GetLocale()=="zhTW") then
    ATSW_VERSION = "商業技能助手 v0.8.0";

	ATSW_SORTBYHEADERS = "按照分類排序";
	ATSW_SORTBYNAMES = "按照名字排序";
	ATSW_SORTBYDIFFICULTY = "按照難度排序";
	ATSW_CUSTOMSORTING = "自訂排序";
	ATSW_QUEUE = "排程";
	ATSW_QUEUEALL = "全部排程";
	ATSW_DELETELETTER = "刪";
	ATSW_STARTQUEUE = "處理排程";
	ATSW_STOPQUEUE = "停止處理";
	ATSW_DELETEQUEUE = "清除排程";
	ATSW_ITEMSMISSING1 = "需要下列物品才能製作 ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "過濾:";
	ATSW_REAGENTLIST1 = "為了製作 1x ";
	ATSW_REAGENTLIST2 = " 需要下列材料:";
	ATSW_REAGENTFRAMETITLE = "需要下列材料才能處理排程:";
	ATSW_REAGENTBUTTON = "材料";
	ATSW_REAGENTFRAME_CH1 = "包包";
	ATSW_REAGENTFRAME_CH2 = "銀行";
	ATSW_REAGENTFRAME_CH3 = "其他角色";
	ATSW_REAGENTFRAME_CH4 = "商人";
	ATSW_ALTLIST1 = "以下角色擁有 '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " 此角色的包包 ";
	ATSW_ALTLIST4 = " 此角色的銀行 ";
	ATSW_OPTIONS_TITLE = "ATSW 選項";
	ATSWOFIB_TEXT = "計算可製作的物品數量時\n將你銀行裡的物品納入考慮";
	ATSWOFIA_TEXT = "計算可製作的物品數量時\n將你其他角色的銀行和包包裡的物品納入考慮";
	ATSWOFIM_TEXT = "計算可製作的物品數量時\n將可從商店購買的物品納入考慮";
	ATSWOFUCB_TEXT = "只顯示總共可製作的物品的數量,\n按照下列規則";
	ATSWOFSCB_TEXT = "顯示包包裡現有材料可製作的物品的數量,\n再按照下列規則顯示另一個數量";
	ATSWOFTB_TEXT = "開啟配方小提示";
	ATSW_OPTIONSBUTTON = "選項";
	ATSW_BUYREAGENTBUTTON = "向目前選中的商人購買材料";
	ATSWOFAB_TEXT = "對商人說話時,\n自動向商人購買可以買到的林料";
	ATSW_AUTOBUYMESSAGE = "ATSW 已經自動購買了下列物品:";
	ATSW_TOOLTIP_PRODUCABLE = "可利用包包裡現有的材料製作的數量: "
	ATSW_TOOLTIP_NECESSARY = "想製作的話, 需要以下材料:";
	ATSW_TOOLTIP_BUYABLE = " (可以用買的)";
	ATSW_TOOLTIP_LEGEND = "(包包裡有幾個 / 銀行裡有幾個 / 其他角色有幾個)";
	ATSW_CONTINUEQUEUE = "繼續排程";
	ATSW_ABORTQUEUE = "放棄";
	ATSWCF_TITLE = "要繼續排程嗎?";
	ATSWCF_TEXT = "從 patch 1.10 起, 要點一下按鈕才能製作物品. 按一下「繼續」就可以接著製作物品.";
	ATSWCF_TITLE2 = "排程裡下一個要製作的物品:";
	ATSW_CSBUTTON = "編輯";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "這位商人有你需要的材料";
	ATSW_AUTOBUYBUTTON_TEXT = "購買材料";
	ATSW_SHOPPINGLISTFRAMETITLE = "以下是製作 ATSW 排程裡所有的物品需要的材料的購物清單:";
	ATSWOFSLB_TEXT = "在拍賣場裡顯示購物清單";
	ATSW_ENCHANT = "附魔";
	ATSW_ACTIVATIONMESSAGE = "ATSW 已經";
	ATSW_ACTIVATED = "為目前的交易技能啟動";
	ATSW_DEACTIVATED = "為目前的交易技能取消";
	ATSW_SCAN_MINLEVEL = "^需要等級 (%d+)";
	ATSW_QUEUESDELETED = "所有儲存的排程已經刪除";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - 排程需要的材料";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "以下角色目前擁有排程的物品:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "沒有排程";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "在 ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "在其他角色";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "在商人";
	ATSW_GETFROMBANK = "從銀行取得材料";
	ATSWOFRLB_TEXT = "如果你任何一個角色有儲存排程,\n在銀行時自動開啟材料清單.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "輕皮",
		[2] = "中皮",
		[3] = "重皮",
		[4] = "厚皮",
		[5] = "硬甲皮",
		[6] = "境外皮革",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - 配方排列編輯器";
	ATSWCS_TRADESKILLISTTITLE = "未分類的配方";
	ATSWCS_CATEGORYLISTTITLE = "已分類的配方";
	ATSWCS_ADDCATEGORY = "新類別";
	ATSWCS_NOTHINGINCATEGORY = "< 空 >";
	ATSWCS_UNCATEGORIZED = "未分類";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW 配方掃描";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW 正在從伺服器取得您的配方並存入本機快取中";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "初始化...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "略過";
	ATSW_SCAN_DELAY_FRAME_ABORT = "放棄";

	ATSW_ONLYCREATABLE = "只顯示足夠材料製造";
else
	ATSW_SORTBYHEADERS = "Order by Categories";
	ATSW_SORTBYNAMES = "Order by Names";
	ATSW_SORTBYDIFFICULTY = "Order by Difficulty";
	ATSW_CUSTOMSORTING = "Custom Sorting";
	ATSW_QUEUE = "Queue";
	ATSW_QUEUEALL = "Queue all";
	ATSW_DELETELETTER = "D";
	ATSW_STARTQUEUE = "Process Queue";
	ATSW_STOPQUEUE = "Stop Processing";
	ATSW_DELETEQUEUE = "Empty Queue";
	ATSW_ITEMSMISSING1 = "You need the following items to produce ";
	ATSW_ITEMSMISSING2 = ":";
	ATSW_FILTERLABEL = "Filter:";
	ATSW_REAGENTLIST1 = "To produce 1x ";
	ATSW_REAGENTLIST2 = " the following reagents are needed:";
	ATSW_REAGENTFRAMETITLE = "The following reagents are needed to process the queue:";
	ATSW_REAGENTBUTTON = "Reagents";
	ATSW_REAGENTFRAME_CH1 = "Inv.";
	ATSW_REAGENTFRAME_CH2 = "Bank";
	ATSW_REAGENTFRAME_CH3 = "Alt";
	ATSW_REAGENTFRAME_CH4 = "Merchant";
	ATSW_ALTLIST1 = "The following alts own '";
	ATSW_ALTLIST2 = "':";
	ATSW_ALTLIST3 = " in the inventory of ";
	ATSW_ALTLIST4 = " in the bank of ";
	ATSW_OPTIONS_TITLE = "ATSW Options";
	ATSWOFIB_TEXT = "Consider items in your bank when calculating the number\nof producable items";
	ATSWOFIA_TEXT = "Consider items in the inventory and in the bank of your\nalternative characters when calculating the number\nof producable items";
	ATSWOFIM_TEXT = "Consider buyable items when calculating the number\nof producable items";
	ATSWOFUCB_TEXT = "Display only one total count of producable items considering\nthe following options";
	ATSWOFSCB_TEXT = "Display the number of items producable with inv. conntents\nand the number creatable considering the following options";
	ATSWOFTB_TEXT = "Enable recipe tooltips";
	ATSW_OPTIONSBUTTON = "Options";
	ATSW_BUYREAGENTBUTTON = "Buy reagents from the currently selected merchant";
	ATSWOFAB_TEXT = "Automatically buy anything possible and necessary\nfor the current queue when speaking to vendors";
	ATSW_AUTOBUYMESSAGE = "ATSW has automatically bought the following items:";
	ATSW_TOOLTIP_PRODUCABLE = " can be produced with the reagents in your inventory"
	ATSW_TOOLTIP_NECESSARY = "To produce one of these, the following reagents are needed:";
	ATSW_TOOLTIP_BUYABLE = " (buyable)";
	ATSW_TOOLTIP_LEGEND = "(items in inventory / items on bank / items on alts)";
	ATSW_CONTINUEQUEUE = "Continue queue";
	ATSW_ABORTQUEUE = "Abort";
	ATSWCF_TITLE = "Continue queue processing?";
	ATSWCF_TEXT = "Since patch 1.10, a click on a button is necessary to be able to produce items. By clicking on 'Continue', you supply this action and the queue processing can continue.";
	ATSWCF_TITLE2 = "The next item in the queue is:";
	ATSW_CSBUTTON = "Edit";
	ATSW_AUTOBUYBUTTON_TOPTEXT = "This merchant sells reagents you need!";
	ATSW_AUTOBUYBUTTON_TEXT = "Buy Reagents";
	ATSW_SHOPPINGLISTFRAMETITLE = "Shopping list of reagents you need to produce the items in all saved ATSW queues:";
	ATSWOFSLB_TEXT = "Display shopping list at the auction house";
	ATSW_ENCHANT = "Enchant";
	ATSW_ACTIVATIONMESSAGE = "ATSW has been";
	ATSW_ACTIVATED = "enabled for the current tradeskill";
	ATSW_DEACTIVATED = "disabled for the current tradeskill";
	ATSW_SCAN_MINLEVEL = "^Requires Level (%d+)";
	ATSW_QUEUESDELETED = "all saved queues have been deleted";
	ATSW_SHOPPINGLIST_HIDE_HELP = "Click this button to hide the shopping list. Click it with your shift key pressed to clear all ATSW queues on all characters.";

	ATSW_ALLREAGENTLISTFRAMETITLE = "ATSW - Reagents for queues";
	ATSW_ALLREAGENTLISTFRAMETITLE2 = "The following characters currently have queued items:";
	ATSW_ALLREAGENTLISTCHARDROPDOWNEMPTY = "no queues found";
	ATSW_ALLREAGENTLISTFRAME_CH1 = "on ";
	ATSW_ALLREAGENTLISTFRAME_CH3 = "on other alts";
	ATSW_ALLREAGENTLISTFRAME_CH4 = "at the merchant";
	ATSW_GETFROMBANK = "Get reagents from bank";
	ATSWOFRLB_TEXT = "Automatically open reagent list in bank if there are\nsaved queues on any of your characters.";
	ATSWOFNRLB_TEXT = "Use compact recipe links instead of multi-line links";

	atsw_blacklist = {
		[1] = "Light Leather",
		[2] = "Medium Leather",
		[3] = "Heavy Leather",
		[4] = "Thick Leather",
		[5] = "Rugged Leather",
		[6] = "Knothide Leather",
	};

	ATSWCS_TITLE = "Advanced Trade Skill Window - Recipe Sorting Editor";
	ATSWCS_TRADESKILLISTTITLE = "Uncategorized Recipes";
	ATSWCS_CATEGORYLISTTITLE = "Categorized Recipes";
	ATSWCS_ADDCATEGORY = "New Category";
	ATSWCS_NOTHINGINCATEGORY = "< empty >";
	ATSWCS_UNCATEGORIZED = "Uncategorized";

	ATSW_SCAN_DELAY_FRAME_TITLE = "ATSW recipe scan";
	ATSW_SCAN_DELAY_FRAME_SUBTITLE = "ATSW is now scanning your recipes to get them from the server into your local cache";
	ATSW_SCAN_DELAY_FRAME_INITIALIZING = "initializing...";
	ATSW_SCAN_DELAY_FRAME_SKIP = "Skip this";
	ATSW_SCAN_DELAY_FRAME_ABORT = "Abort";

	ATSW_ONLYCREATABLE = "materials available";
end
