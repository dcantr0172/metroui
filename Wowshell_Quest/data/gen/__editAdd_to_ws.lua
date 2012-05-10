QuestInfo_Quest = {}

local tn = 'QuestHelper_QuestData'

local pp = function(i,d)
    if(i and d) then
        print('    '..i..' = "' .. d ..'",')
    end
end

for id, qdata in next, QuestInfo_Quest do
    print(tn..'['..id..'] = {')
    for k, v in next, qdata do
        pp(k, v)
    end
    print('}')
end


