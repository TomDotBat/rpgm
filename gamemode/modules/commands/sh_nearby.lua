
hook.Add("RPGM.RegisterCommands", "RPGM.NearbyCommands", function()
    RPGM.RegisterCommand("yell", {"y", "shout"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.YellRange, nil, RPGM.Config.YellTagCol, "[Yell]")
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.YellTagCol, "[Yell]")
    end)

    RPGM.RegisterCommand("whisper", {"w"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.WhisperRange, nil, RPGM.Config.WhisperTagCol, "[Whisper]")
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.WhisperTagCol, "[Whisper]")
    end)
end)
