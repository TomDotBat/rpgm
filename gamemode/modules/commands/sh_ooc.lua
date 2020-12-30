
hook.Add("RPGM.RegisterCommands", "RPGM.OOCCommands", function()
    local oocCommand = RPGM.RegisterCommand("ooc", {"/", "oc"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToAll(ply, data[1], nil, RPGM.Config.OOCTagCol, "[OOC]")
    end)

    hook.Add("RPGM.PreCommandCheck", "RPGM.OOCShortcuts", function(ply, text)
        if not string.StartWith(text, "//") then return end

        local length = #text
        oocCommand:execute(length <= 2 and "" or string.Right(text, length - 2), ply, RPGM.CommandCallback)

        return ""
    end)

    RPGM.RegisterCommand("looc", {"/l", "loc"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToRange(ply, data[1], RPGM.Config.LOOCRange, nil, RPGM.Config.LOOCTagCol, "[LOOC]")
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.LOOCTagCol, "[LOOC]")
    end)
end)