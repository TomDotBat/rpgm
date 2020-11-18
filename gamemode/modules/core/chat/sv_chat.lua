
function GM:PlayerSay(ply, text)
    if string.StartWith(text, RPGM.Config.ChatCommandPrefix) and RPGM.HandleCommands(ply, string.Right(text, #text - 1)) then
        return ""
    end

    --range checks here pls dad

    return text
end