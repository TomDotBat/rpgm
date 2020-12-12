
hook.Add("RPGM.RegisterCommands", "RPGM.NicknameCommands", function()
    RPGM.RegisterCommand("nick", {"rpname", "name", "nickname"}, {
        RPGM.Classes.TextArgument("Name", false, nil, false, true)
    }, function(ply, data)
        RPGM.ChangeNickname(ply, data[1], ply)
    end)

    RPGM.RegisterCommand("resetnick", {
        "resetrpname", "resetname", "resetnickname",
        "removenick", "removerpname", "removename", "removenickname",
        "deletenick", "deleterpname", "deletename", "deletenickname",
        "clearnick", "clearrpname", "clearname", "clearnickname",
        "freenick", "freerpname", "freename", "freenickname"
    }, {
        RPGM.Classes.TextArgument("Name", false, nil, false, true)
    }, function(ply, data)
        RPGM.ResetNickname(ply, data[1])
    end, "Nickname.Reset", "admin")
end)