
local getTeamClass = team.GetClass

function GM:PlayerLoadout(ply)
    self.Sandbox.PlayerLoadout(self, ply)
    RPGM.CallClassFunction(getTeamClass(ply:Team()), "onPlayerLoadout", ply)

    for k, v in pairs(RPGM.Config.BaseLoadout) do
        ply:Give(v)
    end
end