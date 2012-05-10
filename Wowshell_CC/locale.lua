local _, ns = ...

ns.L = setmetatable(GetLocale()=='zhCN' and {
    ['Font'] = '字体',
    ['Normal font size'] = '正常字体尺寸',
    ['Small font size'] = '小字体尺寸',
    ['Min scale'] = '最小缩放',
    ['The minimum size of the font, anything bellow this percentage would be count as small font'] = '任何在这个百分比之下的字体都会被当作小字体',
    ['Cooldown text'] = '冷却计时',
    ['Show options for cooldown text'] = '设置冷却计时',
    ['Small text on right top'] = '小字体置于右上角',
    ['Put small cooldown text on right top of the button'] = '将小字体置于冷却按钮的右上角',
} or GetLocale() == 'zhTW' and {
    ['Font'] = '字體',
    ['Normal font size'] = '正常字體尺寸',
    ['Small font size'] = '小字體尺寸',
    ['Min scale'] = '最小縮放',
    ['The minimum size of the font, anything bellow this percentage would be count as small font'] = '任何在這個百分比之下的字體都會被當作小字體',
    ['Cooldown text'] = '冷卻計時',
    ['Show options for cooldown text'] = '設置冷卻計時',
    ['Small text on right top'] = '小字體置於右上角',
    ['Put small cooldown text on right top of the button'] = '將小字體置於冷卻按鈕的右上角',
} or {}, {
    __index = function(t,i) t[i] = i; return i end
})


