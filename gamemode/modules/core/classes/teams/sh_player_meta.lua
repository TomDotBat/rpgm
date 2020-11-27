
local meta = FindMetaTable("Player")

function meta:getTeamClass()
    return RPGM.TeamTableID[self:Team()]
end

function meta:getTeamName()
    return team.GetName(self:Team())
end