
util.AddNetworkString("RPGM.TeamChanged")

function GM:PlayerChangedTeam(ply, oldTeamId, newTeamId)
    local newTeam = RPGM.TeamTableID[newTeamId]
    RPGM.CallClassFunction(newTeam, "onPlayerJoin", ply, oldTeamId)

    if not oldTeamId then return end
    ply.lastTeam = oldTeamId
    RPGM.CallClassFunction(RPGM.TeamTableID[oldTeamId], "onPlayerLeave", ply, newTeamId)

    net.Start("RPGM.TeamChanged")
     net.WriteUInt(oldTeamId, 10)
     net.WriteUInt(newTeamId, 10)
    net.Send(ply)

    if not RPGM.Config.AnnounceTeamChange then return end
    RPGM.Notify(player.GetAll(), ply:Nick() .. " has become a " .. newTeam:getName(), NOTIFY_HINT)
end