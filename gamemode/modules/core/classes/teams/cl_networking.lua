
net.Receive("RPGM.TeamChanged", function()
    local oldTeam, newTeam = net.ReadUInt(10), net.ReadUInt(10)
    hook.Call("OnLocalTeamChanged", GAMEMODE, oldTeam, newTeam)
end)

net.Receive("RPGM.DownloadTeams", function()
    local len = net.ReadUInt(32)
    local teamData = net.ReadData(len)

    teamData = util.Decompress(teamData)
    teamData = RPGM.MessagePack.Unpack(teamData)

    RPGM.SetupTeams(teamData)
end)

net.Receive("RPGM.DownloadTeam", function()
    local len = net.ReadUInt(32)
    local teamData = net.ReadData(len)

    teamData = util.Decompress(teamData)
    teamData = RPGM.MessagePack.Unpack(teamData)

    RPGM.SetupTeam(teamData)
end)

net.Receive("RPGM.DeleteTeam", function()
    RPGM.RemoveTeam(net.ReadString())
end)