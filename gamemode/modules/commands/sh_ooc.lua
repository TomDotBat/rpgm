
hook.Add("RPGM.RegisterCommands", "RPGM.OOCCommands", function()
    RPGM.RegisterCommand("ooc", {"/", "oc"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToAll(ply, data[1])
    end)

    RPGM.RegisterCommand("looc", {"loc"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.LOOCRange)
    end)
end)