
local commandPrefix = RPGM.Config.ConsoleCommand

concommand.Add(commandPrefix, function(ply, cmd, args, argStr)
    if CLIENT then return end
    RPGM.HandleCommands(ply, argStr, function(msg)
        print(msg)
    end)
end,
function(_, args)
    args = string.Split(string.Trim(args), " ")

    local cmd = RPGM.GetCommands()[args[1]]
    if not cmd then
        local tbl = RPGM.GetCommandList()

        for k, v in ipairs(tbl) do
            tbl[k] = commandPrefix .. " " .. v
        end

        return tbl
    end

    return {commandPrefix .. " " .. args[1] .. " " .. cmd:getSyntax()}
end)