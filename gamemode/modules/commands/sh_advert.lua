

hook.Add("RPGM.RegisterCommands", "RPGM.AdvertCommand", function()
    local advertPrefix = RPGM.Config.PrefixStartChar .. lang:getString("advertPrefix") .. RPGM.Config.PrefixEndChar

    RPGM.RegisterCommand("advert", {"ad", "advertisement"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToAll(ply, data[1], nil, RPGM.Config.AdvertTagCol, advertPrefix)
    end)
end)