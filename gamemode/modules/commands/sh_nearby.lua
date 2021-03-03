
hook.Add("RPGM.RegisterCommands", "RPGM.NearbyCommands", function()
    local lang = gmodI18n.getAddon("rpgm")

    local yellPrefix = RPGM.Config.PrefixStartChar .. lang:getString("yellPrefix") .. RPGM.Config.PrefixEndChar
    local whisperPrefix = RPGM.Config.PrefixStartChar .. lang:getString("whisperPrefix") .. RPGM.Config.PrefixEndChar

    lang = nil

    RPGM.RegisterCommand("yell", {"y", "shout"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.YellRange, nil, RPGM.Config.YellTagCol, yellPrefix)
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.YellTagCol, yellPrefix)
    end)

    RPGM.RegisterCommand("whisper", {"w"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.WhisperRange, nil, RPGM.Config.WhisperTagCol, whisperPrefix)
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.WhisperTagCol, whisperPrefix)
    end)
end)
