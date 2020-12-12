
function GM:PlayerLoadout(ply)
    self.Sandbox.PlayerLoadout(self, ply)

    for k, v in pairs(RPGM.Config.BaseLoadout) do
        ply:Give(v)
    end

    local teamTbl = ply:getTeamClass()
    if not teamTbl then return end

    RPGM.CallClassFunction(teamTbl, "onPlayerLoadout", ply)
    for k,v in ipairs(teamTbl:getWeapons()) do
        ply:Give(v)
    end
end