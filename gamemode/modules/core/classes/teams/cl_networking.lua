
net.Receive("RPGM.TeamChanged", function()
    local oldTeam, newTeam = net.ReadUInt(10), net.ReadUInt(10)
    hook.Call("OnLocalTeamChanged", GAMEMODE, oldTeam, newTeam)
end)