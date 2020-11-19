
local meta = FindMetaTable("Player")

function meta:getTeamClass()
    return team.GetClass(self:Team())
end