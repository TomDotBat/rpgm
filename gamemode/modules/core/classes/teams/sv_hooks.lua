
util.AddNetworkString("RPGM.TeamChanged")

local function isValidTeamId(id)
    return id > 0 and id < 1000
end

function GM:PlayerChangedTeam(ply, oldTeamId, newTeamId)
    if not isValidTeamId(newTeamId) then return end

    if not RPGM.Config.KillOnTeamChange and ply:Alive() then
        ply:StripWeapons()
        ply:RemoveAllAmmo()

        player_manager.SetPlayerClass(ply, "player_rpgm")
        ply:applyTeamVars()

        gamemode.Call("PlayerSetModel", ply)
        gamemode.Call("PlayerLoadout", ply)
    else
        ply:KillSilent()
    end

    local newTeam = RPGM.TeamTableID[newTeamId]
    RPGM.CallClassFunction(newTeam, "onPlayerJoin", ply, oldTeamId)

    if not isValidTeamId(oldTeamId) then return end
    ply.lastTeam = oldTeamId
    RPGM.CallClassFunction(RPGM.TeamTableID[oldTeamId], "onPlayerLeave", ply, newTeamId)

    net.Start("RPGM.TeamChanged")
     net.WriteUInt(oldTeamId, 10)
     net.WriteUInt(newTeamId, 10)
    net.Send(ply)

    if not RPGM.Config.AnnounceTeamChange then return end
    RPGM.Notify(player.GetAll(), "Team Change", ply:Nick() .. " has became a " .. newTeam:getName() .. ".")
end