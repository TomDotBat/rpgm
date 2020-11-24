
if not RPGM.GetDefaultTeam() then
    RPGM.AddTeam({
        name = "Citizen",
        category = "Citizens",
        command = "citizen",
        model = "models/player/gman_high.mdl",
        color = Color(255, 255, 255)
    })
end


RPGM.RegisterCommand("ooc", {"/"}, {
    RPGM.Classes.TextArgument("Message", false, nil, false, true)
}, function(ply, data)
    PrintTable(data)
end)