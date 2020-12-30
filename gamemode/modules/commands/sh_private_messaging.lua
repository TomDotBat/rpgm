
hook.Add("RPGM.RegisterCommands", "RPGM.PMCommands", function()
    RPGM.RegisterCommand("pm", {"dm"}, {
        RPGM.Classes.PlayerArgument("Recipient", false, nil, true),
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToPlayer(ply, data[1], data[2], RPGM.Config.PMTagCol, "[PM]")
    end)
end)