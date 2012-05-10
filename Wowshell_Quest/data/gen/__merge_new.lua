

require'__value_dump'

dofile'QuestData.lua'
dofile'ctm_new.lua'


for k, v in next, new_data do
    if(not QuestHelper_QuestData[k]) then
        QuestHelper_QuestData[k] = v
    end
end

print(dump_value(QuestHelper_QuestData))



