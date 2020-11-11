
function GM:PlayerLoadout(ply)
    self.Sandbox.PlayerLoadout(self, ply)

    for k, v in pairs(RPGM.Config.BaseLoadout) do
        ply:Give(v)
    end
end