
function GM:PlayerLoadout(ply)
    self.Sandbox.PlayerLoadout(self, ply)

    local teamTbl = ply:getTeamClass()
    RPGM.CallClassFunction(teamTbl, "onPlayerLoadout", ply)

    for k, v in pairs(RPGM.Config.BaseLoadout) do
        ply:Give(v)
    end

    for k,v in ipairs(teamTbl:getWeapons()) do
        ply:Give(v)
    end
end