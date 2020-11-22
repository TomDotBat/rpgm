
hook.Add("RPGM.RegisterCommands", "RPGM.TeamCommand", function()
    RPGM.RegisterCommand("team", {"become", "job"}, {
        RPGM.Classes.TextArgument("Team Name", false, nil, false, true)
    }, function(ply, data)
        local cmd = data[1]
        if not cmd then return end

        ply:joinTeam(cmd)
    end)
end)