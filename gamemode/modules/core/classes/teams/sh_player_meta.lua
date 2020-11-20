
local meta = FindMetaTable("Player")

function meta:getTeamClass()
    return RPGM.TeamTableID[self:Team()]
end