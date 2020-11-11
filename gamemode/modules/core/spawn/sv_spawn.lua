
function GM:PlayerSpawn(ply)
    ply:CrosshairEnable()
    ply:UnSpectate()

    RPGM.SetBabyGod(ply, true)

    hook.Call("PlayerLoadout", self, ply)
    hook.Call("PlayerSetModel", self, ply)

    local ent, pos = hook.Call("PlayerSelectSpawn", self, ply)
    ply:SetPos(pos or ent:GetPos())
end