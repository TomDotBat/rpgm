
util.AddNetworkString("RPGM.TeamChanged")

function GM:PlayerChangedTeam(ply, oldTeamId, newTeamId)
    if oldTeamId then
        ply.lastTeam = oldTeamId
        RPGM.CallClassFunction(RPGM.TeamTableID[oldTeamId], "onPlayerLeave", ply, newTeamId)
    end

    RPGM.CallClassFunction(RPGM.TeamTableID[newTeamId], "onPlayerJoin", ply, oldTeamId)

    net.Start("RPGM.TeamChanged")
     net.WriteUInt(oldTeamId, 10)
     net.WriteUInt(newTeamId, 10)
    net.Send(ply)
end