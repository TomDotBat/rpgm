
function GM:PlayerSpawn(ply)
    ply:CrosshairEnable()
    ply:UnSpectate()

    RPGM.SetBabyGod(ply, true)

    player_manager.SetPlayerClass(ply, "player_rpgm")

    --Apply team class vars here

    player_manager.RunClass(ply, "Spawn")

    hook.Call("PlayerLoadout", self, ply)
    hook.Call("PlayerSetModel", self, ply)

    local ent, pos = hook.Call("PlayerSelectSpawn", self, ply)
    ply:SetPos(pos or ent:GetPos())
end

function GM:PlayerInitialSpawn(ply)
    self.Sandbox.PlayerInitialSpawn(self, ply)

    RPGM.Log(ply:Nick() .. " (" .. ply:SteamID() .. ") has joined the game.")

    ply:SetTeam(RPGM.GetDefaultTeamID())
end