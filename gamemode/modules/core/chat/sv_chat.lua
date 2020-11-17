
function GM:PlayerSay(ply, text)
    --range checks here pls dad

    if string.StartWith(text, RPGM.Config.ChatCommandPrefix) and RPGM.HandleCommands(ply, string.Right(text, #text - 1)) then
        return ""
    end
end