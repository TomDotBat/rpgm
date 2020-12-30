
local commands = {}

function RPGM.GetCommands()
    return commands
end

function RPGM.GetCommandList()
    return table.GetKeys(commands)
end

function RPGM.GetCommand(name)
    return commands[name]
end

function RPGM.RegisterCommand(name, aliases, ...)
    local cmd = RPGM.Classes.Command(name, aliases, ...)

    for _, alias in ipairs(cmd:getNames()) do
        commands[alias] = cmd
    end

    return cmd
end

function RPGM.RemoveCommand(name)
    local cmd = commands[name]
    if not cmd then return end

    for _, alias in ipairs(cmd:getNames()) do
        commands[alias] = nil
    end
end

function RPGM.CommandCallback(ply, allowed, reason)
    if not IsValid(ply) then return end

    if not allowed then
        RPGM.MessagePlayer(ply, reason, RPGM.Config.CommandErrorCol)
        return
    end
end

function RPGM.HandleCommands(ply, str)
    local name = string.Split(str, " ")[1]
    if not name then return end
    name = string.lower(name)

    local cmd = RPGM.GetCommand(name)
    if not cmd then return end

    local length = #str
    local restLength = (#name + 1)
    cmd:execute(length <= restLength and "" or string.Right(str, length - restLength), ply, RPGM.CommandCallback)

    return true
end