﻿if GetLocale() ~= "zhTW" then return end

local L

----------------
--  Argaloth  --
----------------
--L= DBM:GetModLocalization(139)
L = DBM:GetModLocalization("Argaloth")

L:SetGeneralLocalization({
	name = "深淵領主阿加羅斯"
})

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetMiscLocalization({
})

L:SetOptionLocalization({
	SetIconOnConsuming		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(88954)
})

-----------------
--  Occu'thar  --
-----------------
L= DBM:GetModLocalization(140)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
})

L:SetMiscLocalization({
})

L:SetOptionLocalization({
})

----------------------------------
--  Alizabal, Mistress of Hate  --
----------------------------------
L= DBM:GetModLocalization(339)

L:SetWarningLocalization({
})

L:SetTimerLocalization({
	TimerFirstSpecial		= "第一次特別技能"
})

L:SetOptionLocalization({
	TimerFirstSpecial		= "$spell:105738施放後為第一次特別技能顯示計時器"
})

L:SetMiscLocalization({
})
