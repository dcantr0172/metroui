-- Locale是自动生成的, 请不要乱加字符. 否则会出现字符串不存在错误.
-- Please make sure to save the file as UTF-8, BUT WITHOUT THE UTF-8 BOM HEADER; ¶
local L = wsLocale:NewLocale("TrinketMenu", "zhTW")
if not L then return end

L["At Mouse"] = "跟隨滑鼠"
L["Bottom Trinket Auto Queue"] = "下麵飾品欄自動排隊"
L["Check this to dismiss this window when you load a profile."] = "當你載入一個配置時關閉這個視窗"
L["Check this to enable auto queue for this trinket slot.  You can also Alt+Click the trinket slot to toggle Auto Queue."] = "選中這個選項會讓飾品自動排隊替換到上面的飾品欄.  你也可以Alt+點擊飾品來開關自動排隊."
L["Check this to prevent the menu appearing unless Shift is held."] = "Shift顯示清單","只有按下Shift才會顯示飾品選擇清單."
L["Check this to prevent the menu from appearing until either worn trinket is right-clicked.\n\nNOTE: This setting CANNOT be changed while in combat."] = "防止功能表出現除非一個警告飾品被右擊.\n\n提示: 戰鬥中不能改變這個選項."
L["Check this to red out worn trinkets that are out of range to a valid target.  ie, Gnomish Death Ray and Gnomish Net-O-Matic."] = "當有效目標在飾品的射程外時飾品變紅警告.  例如, 侏儒死亡射線和侏儒捕網器."
L["Check this to suspend the auto queue while this trinket is equipped. ie, for Carrot on a Stick if you have a mod to auto-equip it to a slot with Auto Queue active."] = "選中這個選項,當這個飾品被裝備時會暫停自動排隊替換. 比如, 你有一個自動換裝的插件在你騎馬時把棍子上的胡蘿蔔裝備上了."
L["Close On Profile Load"] = "當配置載入時關閉"
L["Cooldown Numbers"] = "冷卻計時"
L["Define how many trinkets before the menu will wrap to the next row.\n\nUncheck to let TrinketMenu choose how to wrap the menu."] = "設置飾品選擇列表的列數.\n\n不選擇此項 TrinketMenu 會自動排列."
L["Delete"] = "刪除"
L["Disable Toggle"] = "禁用切換"
L["Disables the minimap button's ability to toggle the trinket frame."] = "禁止使用點擊小地圖按鈕來控制清單的顯示/隱藏"
L["Display all tooltips near the mouse."] = "提示資訊跟隨滑鼠"
L["Display the cooldown time in a larger font."] = "用更大的字體顯示冷卻時間."
L["Display the key bindings over the equipped trinkets."] = "在飾品上顯示綁定的快速鍵."
L["Display time remaining on cooldowns ontop of the button."] = "在按鈕上顯示剩餘冷卻時間."
L["Enter a name to call the profile.  When saved, you can load this profile to either trinket slot."] = "為這個配置輸入一個名字.  保存後, 你可以載入給任一飾品槽."
L["Here you can load or save auto queue profiles."] = "這裡你可以載入或保存自動排列配置"
L["High Priority"] = "高優先權"
L["Keep Menu Docked"] = "保持列表粘附"
L["Keep Menu Open"] = "保持列表開啟"
L["Keep menu docked at all times."] = "保持飾物列表粘附在當前裝備列表."
L["Keep menu open at all times."] = "保持飾物列表始終開啟."
L["Large Numbers"] = "大字體"
L["Load Profile"] = "載入配置"
L["Load a queue order for the selected trinket slot.  You can double-click a profile to load it also."] = "為選中飾品槽載入一個佇列.  你也可以按兩下一個配置來載入它."
L["Lock Windows"] = "鎖定窗口"
L["Main Scale: %.2f"] = "主列表縮放比: %.2f"
L["Menu On Right-Click"] = "右擊菜單"
L["Menu On Shift"] = "Shift顯示清單"
L["Menu Scale: %.2f"] = "選擇列表縮放比: %.2f"
L["Minimap Button"] = "迷你地圖按鈕"
L["Move minimap button as if around a square minimap."] = "如果迷你地圖是方形移動迷你地圖按鈕."
L["Notify At 30 sec"] = "三十秒提示"
L["Notify Chat Also"] = "在聊天窗口提示"
L["Notify When Ready"] = "可使用提示"
L["Pause Queue"] = "暫停自動排隊"
L["Prevents the windows from being moved, resized or rotated."] = "不能移動,縮放,轉動飾品列表."
L["Profile Name"] = "配置名"
L["Profiles"] = "設定檔"
L["Red Out of Range"] = "射程警告"
L["Remove this profile."] = "移除配置"
L["Remove this trinket from the list.  Trinkets further down the list don't affect performance at all.  This option is merely to keep the list managable. Note: Trinkets in your bags will return to end of the list."] = "從列表中刪這個飾品.  更下面的飾品完全不會影響.  這個選項僅僅用來保持清單的可控性. 提示: 你包包裡的飾品將回到列表的最下麵."
L["Save Profile"] = "保存配置"
L["Save the queue order from the selected trinket slot.  Either trinket slot can use saved profiles."] = "保存選中飾品槽的佇列.  任一飾品槽都可以使用它."
L["Sends an overhead notification when a trinket has 30 seconds left on cooldown."] = "在飾品冷卻前三十秒時提示玩家."
L["Sends an overhead notification when a trinket's cooldown is complete."] = "飾物冷卻後提示玩家"
L["Sends notifications through chat also."] = "在飾物冷卻結束後在聊天視窗也發出提示資訊."
L["Show Key Bindings"] = "顯示快速鍵"
L["Show Tooltips"] = "顯示滑鼠提示"
L["Show or hide minimap button."] = "顯示或隱藏小地圖按鈕"
L["Shows tooltips."] = "顯示滑鼠提示"
L["Shrink trinket tooltips to only their name, charges and cooldown."] = "簡化飾品的提示資訊變為只有名字, 用途, 冷卻."
L["Square Minimap"] = "方形迷你地圖"
L["Stop Queue On Swap"] = "被動飾品停止排隊"
L["Swap Delay"] = "延遲替換"
L["Swapping a passive trinket stops an auto queue.  Check this to also stop the auto queue when a clickable trinket is manually swapped in via TrinketMenu.  This will have the most use to those with frequent trinkets marked Priority."] = "當換上一個被動飾品時停止自動排隊.  選中這個選項時, 當一個可點擊飾品通過 TrinketMenu 被手動換上時同樣會停止自動排隊. 當頻繁標記飾品為優先時這個選項尤其有用"
L["This is the time (in seconds) before a trinket will be swapped out.  ie, for Earthstrike you want 20 seconds to get the full 20 second effect of the buff."] = "設置一個飾品被替換的時間 (秒).  比如, 你需要20秒得到大地之擊的20秒BUFF."
L["Tiny Tooltips"] = "迷你提示"
L["Top Trinket Auto Queue"] = "上面飾品欄自動排隊"
L["When checked, this trinket will be swapped in as soon as possible, whether the equipped trinket is on cooldown or not.\n\nWhen unchecked, this trinket will not equip over one already worn that's not on cooldown."] = "當選中這個選項時, 這個飾品會被第一時間裝備上, 而不管裝備著的飾品是否在冷卻中.\n\n當沒選中時, 這個飾品不會替換掉沒有在冷卻中的已裝備飾品."
L["Wrap at: "] = "設置列表列數"

L["Bag"] = "背包"
L["Engineering Bag"] = "工程學材料袋"
L["Trade Goods"] = "商品"
L["Devices"] = "裝置"
L["Requires Engineering"] = "需要工程學"
L["Use Top Trinket"] = "使用上飾品"
L["Use Bottom Trinket"] = "使用下飾品"
L["-- stop queue here --"] = "-- 停止排隊線 --"
L["Stop Queue Here"] = "停止排隊線"
L["Move this to mark the lowest trinket to auto queue.  Sometimes you may want a passive trinket with a click effect to be the end (Burst of Knowledge, Second Wind, etc)."] = "移動此標記到最低飾品自動排隊. 有時候你點擊效果將結束時將需要一個被動的飾品(比如 博學墜飾, 復蘇之風)"
L["First parameter must be 0 for top trinket or 1 for bottom."] = "第一個參數必須為0頂端飾物或1的底部。"
L["Second parameter is either ON, OFF, PAUSE, RESUME or the beginning of a list of trinkets in a sort order."] = "第二參數可以是 ON, OFF, PAUSE, RESUME或者視頻開始替換清單"
L[" Expected ON, OFF, PAUSE, RESUME or SORT+list"] = " 預期ON, OFF, PAUSE, RESUME或者SORT+列表"
L["|cFFBBBBBBTrinketMenu.GetQueue:|cFFFFFFFF Parameter must be 0 for top trinket or 1 for bottom."] = "|cFFBBBBBBTrinketMenu.GetQueue:|cFFFFFFFF 參數必須為0頂端飾物或1的底部。"
L["Click: toggle options\nDrag: move icon"]= "點擊: 開關選項視窗\n拖動: 移動設置按鈕"
L["Left click: toggle trinkets\nRight click: toggle options\nDrag: move icon"] = "左鍵點擊: 開關飾物視窗\n右鍵點擊: 開關選項視窗\n拖動: 移動設置按鈕"
L["Options"] = "設置"
L[" trinkets"] = "飾品"
L["Are you sure you want to reset TrinketMenu to default state and reload the UI?"] = "確定是否需要重置TrinketMenu配置? 點擊確定重載UI"
