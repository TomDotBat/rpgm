
hook.Add("RPGM.RegisterCommands", "RPGM.PMCommands", function()
    local lang = gmodI18n.getAddon("rpgm")

    local pmPrefix = RPGM.Config.PrefixStartChar .. lang:getString("pmPrefix") .. RPGM.Config.PrefixEndChar

    lang = nil

    local lastConversations = setmetatable({}, {
        __mode = 'k'
    })

    local function setLatestConversation(sender, recipient)
        lastConversations[sender] = recipient
        lastConversations[recipient] = sender

        timer.Create("RPGM.PMTimeout:" .. sender:SteamID64(), 120, 1, function()
            lastConversations[sender] = nil
        end)

        timer.Create("RPGM.PMTimeout:" .. recipient:SteamID64(), 120, 1, function()
            lastConversations[recipient] = nil
        end)
    end

    RPGM.RegisterCommand("pm", {"dm"}, {
        RPGM.Classes.PlayerArgument("Recipient", false, nil, true),
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        RPGM.TalkToPlayer(ply, data[1], data[2], RPGM.Config.PMTagCol, pmPrefix)

        if ply == data[1] then return end
        setLatestConversation(ply, data[1])
        RPGM.TalkToPlayer(ply, ply, data[2], RPGM.Config.PMTagCol, pmPrefix)
    end)

    RPGM.RegisterCommand("reply", {"r"}, {
        RPGM.Classes.TextArgument("Message", false, nil, false, true)
    }, function(ply, data)
        local recipient = lastConversations[ply]
        if not IsValid(recipient) then
            RPGM.Notify(ply, lang:getString("noRecentConversation"), lang:getString("haventRecentlySpoken"), NOTIFY_ERROR)
            return
        end

        setLatestConversation(ply, recipient)

        RPGM.TalkToPlayer(ply, recipient, data[1], RPGM.Config.PMTagCol, pmPrefix)
        RPGM.TalkToPlayer(ply, ply, data[1], RPGM.Config.PMTagCol, pmPrefix)
    end)
end)