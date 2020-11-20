
net.Receive("RPGM.TeamChanged", function()
    hook.Call("OnLocalTeamChanged", GAMEMODE, net.ReadUInt(10), net.ReadUInt(10))
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