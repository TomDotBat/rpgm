
hook.Add("RPGM.RegisterCommands", "RPGM.ActionCommands", function()
    RPGM.RegisterCommand("me", {"action", "act"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.ActionRange, nil, nil, "**", true)
        RPGM.TalkToPlayer(ply, ply, data[1], nil, "**", nil, true)
    end)
end)