
util.AddNetworkString("RPGM.DownloadTeams")
util.AddNetworkString("RPGM.DownloadTeam")
util.AddNetworkString("RPGM.DeleteTeam")

function RPGM.SendAllTeams(recipient)
    local data = {}

    for _, team in pairs(RPGM.TeamTable) do
        table.insert(data, team:getNetworkableTable(true))
    end

    data = RPGM.MessagePack.Pack(data)
    data = util.Compress(data)

    local len = string.len(data)
    net.Start("RPGM.DownloadTeams")
     net.WriteUInt(len, 32)
     net.WriteData(data, len)
    net.Send(recipient)
end

hook.Add("RPGM.ClientReady", "RPGM.SendTeamsOnStart", RPGM.SendAllTeams)


function RPGM.SendTeam(team, recipient)
    local data = team:getNetworkableTable()
    data = RPGM.MessagePack.Pack(data)
    data = util.Compress(data)

    local len = string.len(data)
    net.Start("RPGM.DownloadTeam")
     net.WriteUInt(len, 32)
     net.WriteData(data, len)
    net.Send(recipient)
end

function RPGM.SendTeamDelete(command, recipient)
    net.Start("RPGM.DeleteTeam")
     net.WriteString(command)
    net.Send(recipient)
end