
local meta = FindMetaTable("Player")

function meta:getTeamClass()
    return RPGM.TeamTableID[self:Team()]
end

local getTeamName = team.GetName
function meta:getTeamName()
    return getTeamName(self:Team())
end