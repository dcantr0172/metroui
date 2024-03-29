if( GetLocale() == "zhCN" ) then
	MBB_TOOLTIP1 = "左键点击展开全部按钮|nCtrl+右键释放一个按钮";
	MBB_OPTIONS_HEADER = "选项";
	MBB_OPTIONS_OKBUTTON = "确定";
	MBB_OPTIONS_CANCELBUTTON = "取消";
	MBB_OPTIONS_SLIDEROFF = "无";
	MBB_OPTIONS_SLIDERSEK = "秒";
	MBB_OPTIONS_SLIDERLABEL = "Collapse Timeout:";
	MBB_OPTIONS_EXPANSIONLABEL = "扩展方向:";
	MBB_OPTIONS_EXPANSIONLEFT = "左侧";
	MBB_OPTIONS_EXPANSIONTOP = "向上";
	MBB_OPTIONS_EXPANSIONRIGHT = "右侧";
	MBB_OPTIONS_EXPANSIONBOTTOM = "向下";
	MBB_OPTIONS_MAXBUTTONSLABEL = "最大按钮数/每行:";
	MBB_OPTIONS_MAXBUTTONSINFO = "(0=无穷多)";
	MBB_OPTIONS_ALTEXPANSIONLABEL = "内部按钮扩展方向:";
	MBB_HELP1 = "输入 \"/mbb <cmd>\" 以下 <cmd> 可以使用:";
	MBB_HELP2 = "  |c00ffffffbuttons|r: 在MBB条上显示所有按钮";
	MBB_HELP3 = "  |c00ffffffreset position|r: 重置 MBB 在迷你地图上的位置";
	MBB_HELP4 = "  |c00ffffffreset all|r: 重置所有设置";
	MBB_NOERRORS = "没有错误产生!";
elseif( GetLocale() == "zhTW" ) then
	MBB_TOOLTIP1 = "左鍵點擊展開全部按鈕|nCtrl+右鍵釋放一個按鈕";
	MBB_OPTIONS_HEADER = "選項";
	MBB_OPTIONS_OKBUTTON = "確定";
	MBB_OPTIONS_CANCELBUTTON = "取消";
	MBB_OPTIONS_SLIDEROFF = "無";
	MBB_OPTIONS_SLIDERSEK = "秒";
	MBB_OPTIONS_SLIDERLABEL = "Collapse Timeout:";
	MBB_OPTIONS_EXPANSIONLABEL = "擴展方向:";
	MBB_OPTIONS_EXPANSIONLEFT = "左側";
	MBB_OPTIONS_EXPANSIONTOP = "向上";
	MBB_OPTIONS_EXPANSIONRIGHT = "右側";
	MBB_OPTIONS_EXPANSIONBOTTOM = "向下";
	MBB_OPTIONS_MAXBUTTONSLABEL = "最大按鈕數/每行:";
	MBB_OPTIONS_MAXBUTTONSINFO = "(0=無窮多)";
	MBB_OPTIONS_ALTEXPANSIONLABEL = "內部按鈕擴展方向:";
	MBB_HELP1 = "輸入 \"/mbb <cmd>\" 以下 <cmd> 可以使用:";
	MBB_HELP2 = "  |c00ffffffbuttons|r: 在MBB條上顯示所有按鈕";
	MBB_HELP3 = "  |c00ffffffreset position|r: 重置 MBB 在迷你地圖上的位置";
	MBB_HELP4 = "  |c00ffffffreset all|r: 重置所有設置";
	MBB_NOERRORS = "沒有錯誤產生!";
else
	MBB_TOOLTIP1 = "Ctrl + Right click on a button to reattach it to the minimap.";
	MBB_OPTIONS_HEADER = "Options";
	MBB_OPTIONS_OKBUTTON = "Ok";
	MBB_OPTIONS_CANCELBUTTON = "Cancel";
	MBB_OPTIONS_SLIDEROFF = "Off";
	MBB_OPTIONS_SLIDERSEK = "sec";
	MBB_OPTIONS_SLIDERLABEL = "Collapse Timeout:";
	MBB_OPTIONS_EXPANSIONLABEL = "Expand to:";
	MBB_OPTIONS_EXPANSIONLEFT = "Left";
	MBB_OPTIONS_EXPANSIONTOP = "Top";
	MBB_OPTIONS_EXPANSIONRIGHT = "Right";
	MBB_OPTIONS_EXPANSIONBOTTOM = "Bottom";
	MBB_OPTIONS_MAXBUTTONSLABEL = "Max. Buttons/Line:";
	MBB_OPTIONS_MAXBUTTONSINFO = "(0=infinity)";
	MBB_OPTIONS_ALTEXPANSIONLABEL = "Alt. Expand to:";
	MBB_HELP1 = "Type \"/mbb <cmd>\" where <cmd> is one of the following:";
	MBB_HELP2 = "  |c00ffffffbuttons|r: Shows a list of all frames in the MBB bar";
	MBB_HELP3 = "  |c00ffffffreset position|r: resets the position of the MBB minimap button";
	MBB_HELP4 = "  |c00ffffffreset all|r: resets all options";
	MBB_NOERRORS = "No errors found!";
end