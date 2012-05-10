
dofile 'Quest.lua'

local quest_data = {}


local pp = function(i, d)
    if(i and d) then
        print('        '..i..' = "'..d..'",')
    end
end

for id, questi in next, QuestInfo_Quest do
    print(  '    ['..id..'] = {')
    for k, v in next, questi do
        pp(k, v)
    end
    print(  '    },')
end


