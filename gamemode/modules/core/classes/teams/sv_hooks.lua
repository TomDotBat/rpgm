
local getTeamClass = team.GetClass

function GM:PlayerChangedTeam(ply, oldTeamId, newTeamId)
    ply.lastTeam = oldTeamId

    RPGM.CallClassFunction(getTeamClass(oldTeamId), "onPlayerLeave", ply, newTeamId)
    RPGM.CallClassFunction(getTeamClass(newTeamId), "onPlayerJoin", ply, oldTeamId)

    net.Start("RPGM.TeamChanged")
     net.WriteUInt(oldTeamId, 10)
     net.WriteUInt(newTeamId, 10)
    net.Send(ply)
end

util.AddNetworkString("RPGM.TeamChanged")