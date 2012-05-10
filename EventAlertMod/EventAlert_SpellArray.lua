function EventAlert_LoadClassSpellArray(ItemType)
	if EA_Items[EA_playerClass] == nil then EA_Items[EA_playerClass] = {} end;
	if EA_AltItems[EA_playerClass] == nil then EA_AltItems[EA_playerClass] = {} end;
	if EA_Items[EA_CLASS_OTHER] == nil then EA_Items[EA_CLASS_OTHER] = {} end;
	if EA_TarItems[EA_playerClass] == nil then EA_TarItems[EA_playerClass] = {} end;
	if EA_ScdItems[EA_playerClass] == nil then EA_ScdItems[EA_playerClass] = {} end;

	if (ItemType == 1 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["ITEMS"]) do
			i = tonumber(i);
			if EA_Items[EA_playerClass][i] == nil then EA_Items[EA_playerClass][i] = v end;
		end
	end
	if (ItemType == 2 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["ALTITEMS"])    do
			i = tonumber(i);
			if EA_AltItems[EA_playerClass][i] == nil then EA_AltItems[EA_playerClass][i] = v end;
		end
	end
	if (ItemType == 3 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_CLASS_OTHER])    do
			i = tonumber(i);
			if EA_Items[EA_CLASS_OTHER][i] == nil then EA_Items[EA_CLASS_OTHER][i] = v  end;
		end
	end
	if (ItemType == 4 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["TARITEMS"])    do
			i = tonumber(i);
			if EA_TarItems[EA_playerClass][i] == nil then EA_TarItems[EA_playerClass][i] = v end;
		end
	end
	if (ItemType == 5 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["SCDITEMS"])    do
			i = tonumber(i);
			if EA_ScdItems[EA_playerClass][i] == nil then EA_ScdItems[EA_playerClass][i] = v end;
		end
	end
end


function EventAlert_LoadSpellArray()

	EADef_Items = {};

--------------------------------------------------------------------------------
-- Death Knight / 死亡騎士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_DK] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[48707] = {enable=true,},   -- 反魔法護罩
			[48792] = {enable=true,},   -- 冰錮堅韌
			[49039] = {enable=true,},   -- 巫妖之軀
			[49222] = {enable=true,},   -- 骸骨之盾
			[51124] = {enable=true,},   -- Killing  Machine / 殺戮酷刑
			[52424] = {enable=true,},   -- 反擊風暴
			[53386] = {enable=true,},   -- Cinderglacier (Runeforge) /  冰燼
			[57330] = {enable=true,},   -- 凜冬號角
			[59052] = {enable=true,},   -- Rime (Freezing Fog) / 冰封之霧
			[81141] = {enable=true,},   -- 赤血災禍
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[56815] = {enable=true,},   -- Rune Strike / 符文打擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[55095] = {enable=true, self=true,},    -- 冰霜熱疫
			[55078] = {enable=true, self=true,},    -- 血魄瘟疫
			[81130] = {enable=true, self=true,},    -- 血色熱疫
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[43265] = {enable=true,},   -- 死亡凋零
			[45524] = {enable=true,},   -- 冰鍊術
			[47476] = {enable=true,},   -- 絞殺
			[47528] = {enable=true,},   -- 心智冰封
			[48707] = {enable=true,},   -- 反魔法護罩
			[48721] = {enable=true,},   -- 沸血術
			[48792] = {enable=true,},   -- 冰錮堅韌
			[49020] = {enable=true,},   -- 滅寂
			[49576] = {enable=true,},   -- 死亡之握
			[49998] = {enable=true,},   -- 死亡打擊
			[77575] = {enable=true,},   -- 疫病爆發
			[85948] = {enable=true,},   -- 膿瘡潰擊
		},
	}


--------------------------------------------------------------------------------
-- Druid / 德魯依
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_DRUID] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[16870] = {enable=true,},   -- Omen of Clarity / 清晰預兆
			[16886] = {enable=true,},   -- Nature's Grace / 自然之賜
			[48517] = {enable=true,},   -- Eclipse / 日蝕
			[48518] = {enable=true,},   -- Eclipse / 月蝕
			[50334] = {enable=true,},   -- Berserk / 狂暴
			[52610] = {enable=true,},   -- Savage Roar / 兇蠻咆嘯
			[80951] = {enable=true,},   -- 粉碎
			[81192] = {enable=true,},   -- 月沐
			[93400] = {enable=true,},   -- 射星術
			[93622] = {enable=true,},   -- 狂暴(免費割碎)
			[100977] = {enable=true,},  -- 共生
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			--[770] = {enable=true, self=true,},    -- Faerie Fire / 精靈之火
			--[16857] = {enable=true, self=true,},  -- Faerie Fire (Feral) / 精靈之火(野性)
			--[48564] = {enable=true, self=true,},  -- Mangle(Bear) / 割碎(熊形態)
			[99] = {enable=true, self=true,},       -- 挫志咆哮
			[774] = {enable=true, self=true,},      -- 回春術
			[1079] = {enable=true, self=true,},     -- Rip / 撕扯
			[1822] = {enable=true, self=true,},     -- Rake / 掃擊
			[5570] = {enable=true, self=true,},     -- Insect Swarm / 蟲群
			[8921] = {enable=true, self=true,},     -- Moonfire / 月火術
			[33745] = {enable=true, self=true,},    -- Lacerate / 割裂
			[33763] = {enable=true, self=true,},    -- 生命之花
			[33876] = {enable=true, self=true,},    -- Mangle(Cat) / 割碎(獵豹形態)
			[52610] = {enable=true, self=true,},    -- 兇蠻咆哮
			[93402] = {enable=true, self=true,},    -- Moonfire / 日炎術
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[17116] = {enable=true,},   -- 自然迅捷
			[18562] = {enable=true,},   -- 迅癒
			[29166] = {enable=true,},   -- 啟動
			[48438] = {enable=true,},   -- 野性痊癒
			[78674] = {enable=true,},   -- 星湧術
		},
	}


--------------------------------------------------------------------------------
-- Hunter / 獵人
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_HUNTER] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[3045] = {enable=true,},    -- 急速射擊
			[34471] = {enable=true,},   -- 獸心
			[34477] = {enable=true,},   -- 誤導
			[35079] = {enable=true,},   -- 誤導
			[53220] = {enable=true,},   -- Improved Stead Shot / 強化穩固射擊
			[53257] = {enable=true,},   -- 眼鏡蛇之擊
			[53434] = {enable=true,},   -- 狂野呼喚
			[56453] = {enable=true,},   -- Lock and Load / 蓄勢待發
			[70728] = {enable=true,},   -- 攻擊弱點
			[82925] = {enable=true,},   -- 準備、就緒、瞄準…
			[82926] = {enable=true,},   -- 射擊!
			[89388] = {enable=true,},   -- 攻擊敵人
			[94007] = {enable=true,},   -- 連殺
			[95712] = {enable=true,},   -- X光瞄準器
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[53351] = {enable=true,},   -- Kill Shot / 擊殺射擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[1978] = {enable=true, self=true,},     -- 毒蛇釘刺
			[1130] = {enable=true, self=true,},     -- 獵人印記
			[19503] = {enable=true, self=true,},    -- 驅散射擊
			[63468] = {enable=true, self=true,},    -- 穿透射擊
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[781] = {enable=true,},     -- 逃脫
		},
	}


--------------------------------------------------------------------------------
-- Mage / 法師
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_MAGE] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[12042] = {enable=true,},   -- 秘法強化
			[12051] = {enable=true,},   -- 喚醒
			[36032] = {enable=true,},   -- Arcane Blast / 奧衝堆疊
			[44544] = {enable=true,},   -- Fingers of Frost / 冰霜之指
			[48108] = {enable=true,},   -- Hot Streak / 焦炎之痕
			[57761] = {enable=true,},   -- Brain Freeze / 腦部凍結
			[64343] = {enable=true,},   -- 衝擊
			[79683] = {enable=true,},   -- Missile Barrage! / 秘法飛彈!
			[87023] = {enable=true,},   -- 燒灼
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[12654] = {enable=true, self=true,},    -- 點燃
			[22959] = {enable=true, self=true,},    -- 火焰重擊
			[31589] = {enable=true, self=true,},    -- Slow / 減速術
			[44457] = {enable=true, self=true,},    -- Living Bomb / 活體爆彈
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[122] = {enable=true,},     -- 冰霜新星
			[1953] = {enable=true,},    -- 閃現
			[12042] = {enable=true,},   -- 秘法強化
			[12043] = {enable=true,},   -- 氣定神閒
			[12051] = {enable=true,},   -- 喚醒
			[44572] = {enable=true,},   -- 極度冰凍
			[45438] = {enable=true,},   -- 寒冰屏障
		},
	}


--------------------------------------------------------------------------------
-- Paladin / 聖騎士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_PALADIN] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[498] = {enable=true,},     -- 聖佑術
			[642] = {enable=true,},     -- 聖盾術
			[31842] = {enable=true,},   -- 神恩術
			[31884] = {enable=true,},   -- 復仇之怒
			[53657] = {enable=true,},   -- 純潔審判
			[54149] = {enable=true,},   -- 聖光灌注
			[54428] = {enable=true,},   -- 神性祈求
			[59578] = {enable=true,},   -- Art of War / 戰爭藝術
			[84963] = {enable=true,},   -- 異端審問
			[85222] = {enable=true,},   -- 黎明曙光
			[85696] = {enable=true,},   -- 狂熱精神
			[88819] = {enable=true,},   -- 破曉之光
			[90174] = {enable=true,},   -- 聖光之手
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[24275] = {enable=true,},   -- Hammer of Wrath / 憤怒之錘
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[853] = {enable=true, self=true,},      -- 制裁之錘
			[2812] = {enable=true, self=true,},     -- 神聖憤怒
			[10326] = {enable=true, self=true,},    -- 退邪術
			[20066] = {enable=true, self=true,},    -- 懺悔
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[498] = {enable=true,},     -- 聖佑術
			[853] = {enable=true,},     -- 制裁之鎚
			[2812] = {enable=true,},    -- 神聖憤怒
			[20271] = {enable=true,},   -- 審判
			[20473] = {enable=true,},   -- 神聖震擊
			[26573] = {enable=true,},   -- 奉獻
			[28730] = {enable=true,},   -- 奧流之術
			[35395] = {enable=true,},   -- 十字軍聖擊
			[54428] = {enable=true,},   -- 神性祈求
		},
	}


--------------------------------------------------------------------------------
-- Priest / 牧師
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_PRIEST] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[17] = {enable=true,},      -- 真言術:盾
			[6788] = {enable=true,},    -- 虛弱靈魂
			[47585] = {enable=true,},   -- 影散
			[59887] = {enable=true,},   -- Borrowed Time / 預支時間
			[59888] = {enable=true,},   -- Borrowed Time / 預支時間
			[63735] = {enable=true,},   -- 機緣回復
			[77487] = {enable=true,},   -- 暗影寶珠
			[81206] = {enable=true,},   -- 脈輪運轉:庇護
			[81208] = {enable=true,},   -- 脈輪運轉:平靜
			[81209] = {enable=true,},   -- 脈輪運轉:譴責
			[81782] = {enable=true,},   -- 真言術:壁
			[87118] = {enable=true,},   -- 黑暗佈道
			[87153] = {enable=true,},   -- 黑天使
			[87160] = {enable=true,},   -- 心靈熔蝕
			[88688] = {enable=true,},   -- 光之澎派
			[95799] = {enable=true,},   -- 強化暗影
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[589] = {enable=true, self=true,},      -- Shadow Word: Pain / 暗言術:痛
			[2944] = {enable=true, self=true,},     -- Devouring Plague / 噬靈瘟疫
			[6788] = {enable=true, self=true,},     -- Weakened Soul / 虛弱靈魂
			[34914] = {enable=true, self=true,},    -- Vampiric Touch / 吸血之觸
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[10060] = {enable=true,},   -- 注入能量
			[14751] = {enable=true,},   -- 脈輪運轉
			[28730] = {enable=true,},   -- 奧流之術
			[32379] = {enable=true,},   -- 暗言術:死
			[33206] = {enable=true,},   -- 痛苦鎮壓
			[34433] = {enable=true,},   -- 暗影惡魔
			[47540] = {enable=true,},   -- 懺悟
			[47585] = {enable=true,},   -- 影散
			[87151] = {enable=true,},   -- 大天使
			[88684] = {enable=true,},   -- 聖言術:寧
			[89485] = {enable=true,},   -- 心靈專注
		},
	}


--------------------------------------------------------------------------------
-- Rogue / 盜賊
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_ROGUE] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[5171] = {enable=true,},    -- 切割
			[1966] = {enable=true,},    -- 佯攻
			[57934] = {enable=true,},   -- 偷天換日
			[59628] = {enable=true,},   -- 偷天換日
			[58427] = {enable=true,},   -- 極限殺戮
			[84590] = {enable=true,},   -- 致命殺陣
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[14251] = {enable=true,},   -- Riposte / 還擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[1943] = {enable=true, self=true,},     -- 割裂
			[84617] = {enable=true, self=true,},    -- 揭底之擊
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[65961] = {enable=true,},   -- 暗影披風
			[79140] = {enable=true,},   -- 宿怨
		},
	}


--------------------------------------------------------------------------------
-- Shaman / 薩滿
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_SHAMAN] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[324] = {enable=true,},     -- 閃電之盾
			[53817] = {enable=true, stack=5,},  -- 氣漩武器
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[8050] = {enable=true, self=true,},     -- 烈焰震擊
			[100955] = {enable=true, self=true,},   -- 雷霆風暴
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[16190] = {enable=true,},   -- 法力之潮圖騰
			[51505] = {enable=true,},   -- 熔岩爆發
			[61295] = {enable=true,},   -- 激流
			[73680] = {enable=true,},   -- 釋放元素能量
			[73920] = {enable=true,},   -- 治癒大雨
		},
	}


--------------------------------------------------------------------------------
-- Warlock / 術士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_WARLOCK] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[687] = {enable=true,},     -- 惡魔護甲
			[18095] = {enable=true,},   -- 夜暮
			[19028] = {enable=true,},   -- 靈魂鏈結
			[28176] = {enable=true,},   -- 魔化護甲
			[34939] = {enable=true,},   -- 反衝
			[47283] = {enable=true,},   -- Empowered Imp / 強力小鬼
			[63158] = {enable=true,},   -- 屠虐
			[63167] = {enable=true,},   -- 屠虐
			[71165] = {enable=true,},   -- 熔火之心
			[85383] = {enable=true,},   -- 強化靈魂之火
			[89937] = {enable=true,},   -- 魔化火光
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[172] = {enable=true, self=true,},      -- Corruption / 腐蝕術
			[348] = {enable=true, self=true,},      -- Immolate / 獻祭
			[686] = {enable=true, self=true,},      -- 末日災厄
			[603] = {enable=true, self=true,},      -- 暗影箭
			[980] = {enable=true, self=true,},      -- 痛苦災厄
			[1490] = {enable=true, self=true,},     -- Curse of the Elements / 元素詛咒
			[29722] = {enable=true, self=true,},    -- 燒盡
			[30108] = {enable=true, self=true,},    -- 痛苦動盪
			[48181] = {enable=true, self=true,},    -- 蝕魂術
			[50796] = {enable=true, self=true,},    -- 混沌箭
			[80240] = {enable=true, self=true,},    -- 浩劫災厄
			[86000] = {enable=true, self=true,},    -- 古爾丹詛咒
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[17962] = {enable=true,},   -- 焚燒
			[59672] = {enable=true,},   -- 惡魔化身
			[71165] = {enable=true,},   -- 熔火之心
		},
	}


--------------------------------------------------------------------------------
-- Warrior / 戰士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_WARRIOR] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[871] = {enable=true,},     -- 盾牆(防禦姿態)
			[1134] = {enable=true,},    -- 心靈之怒
			[2565] = {enable=true,},    -- 盾牌格檔(防禦姿態)
			[12328] = {enable=true,},   -- 橫掃攻擊(戰鬥，狂暴姿態)
			[12964] = {enable=true,},   -- 戰鬥沈思
			[12975] = {enable=true,},   -- 破斧沈舟
			[14202] = {enable=true,},   -- 狂怒(等級 3)
			[16491] = {enable=true,},   -- 血之狂熱
			[20230] = {enable=true,},   -- 反擊風暴(戰鬥姿態)
			[23885] = {enable=true,},   -- 嗜血
			[23920] = {enable=true,},   -- 法術反射(戰鬥，防禦姿態)
			[29841] = {enable=true,},   -- 復甦之風(等級1)
			[32216] = {enable=true,},   -- 勝利
			[46916] = {enable=true,},   -- Bloodsurge (Slam) / 熱血沸騰
			[50227] = {enable=true,},   -- 劍盾合壁
			[52437] = {enable=true,},   -- 驟亡
			[55694] = {enable=true,},   -- 狂怒恢復
			[57516] = {enable=true,},   -- 狂怒(等級 2)
			[57519] = {enable=true,},   -- 狂怒(等級 2)
			[60503] = {enable=true,},   -- 血腥體驗
			[65156] = {enable=true,},   -- 勢不可當
			[82368] = {enable=true,},   -- 勝利
			[84586] = {enable=true,},   -- 屠宰(等級 3)
			[84620] = {enable=true,},   -- 堅守陣線
			[85730] = {enable=true,},   -- 沉著殺機
			[86627] = {enable=true,},   -- 激動
			[87096] = {enable=true,},   -- 雷擊
			[90806] = {enable=true,},   -- 處決者
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[94009] = {enable=true, self=true,},    -- 撕裂
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
		},
	}


--------------------------------------------------------------------------------
-- Other / 跨職業共通區
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_OTHER] = {
		[17] = {enable=true,},      -- Priest / 牧師 - 真言術:盾
		[7001] = {enable=true,},    -- Priest / 牧師 - 光束泉恢復
		[10060] = {enable=true,},   -- Priest - Power Infusion / 牧師 - 注入能量
		[33206] = {enable=true,},   -- Priest - Pain Suppression / 牧師 - 痛苦鎮壓
		[81782] = {enable=true,},   -- Priest - 牧師 - 真言術:壁

		[29166] = {enable=true,},   -- Druid-Innervate / 德魯依-啟動

		[2825] = {enable=true,},    -- Shaman / 薩滿 - 嗜血術
		[80353] = {enable=true,},   -- Mage / 法師 - 時間扭曲
		[90355] = {enable=true,},   -- Hunter / 獵人 - 上古狂亂

		[89091] = {enable=true,},   -- 飾品-火山毀滅
		[91007] = {enable=true,},   -- 飾品-災厄魔力
		[91308] = {enable=true,},   -- 飾品-蛋之殼
		[91816] = {enable=true,},   -- 飾品-狂怒之心
		[91828] = {enable=true,},   -- 飾品-年少急躁
		[91832] = {enable=true,},   -- 飾品-安格弗之怒-累積層數
		[91836] = {enable=true,},   -- 飾品-安格弗之怒-持續時間
		[92222] = {enable=true,},   -- 飾品-破碎影像之鏡
		[96228] = {enable=true,},   -- 工程-神經突觸彈簧-敏捷
		[96229] = {enable=true,},   -- 工程-神經突觸彈簧-力量
		[96230] = {enable=true,},   -- 工程-神經突觸彈簧-智力

		[82705] = {enable=true,},   -- 黑翼-奇馬龍-芬克的混合物

		[86622] = {enable=true,},   -- 暮光-雙龍-侵噬魔法
		[88518] = {enable=true,},   -- 暮光-雙龍-暮光隕星
		[83099] = {enable=true,},   -- 暮光-議會-聚雷針
	}


end