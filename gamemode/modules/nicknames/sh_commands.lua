
hook.Add("RPGM.RegisterCommands", "RPGM.NicknameCommands", function()
    RPGM.RegisterCommand("nick", {"rpname", "name", "nickname"}, {
        RPGM.Classes.TextArgument("Name", false, nil, false, true)
    }, function(ply, data)
        RPGM.ChangeNickname(ply, data[1], ply)
    end)
end)