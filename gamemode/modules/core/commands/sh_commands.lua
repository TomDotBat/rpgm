
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
end

function RPGM.RemoveCommand(name)
    local cmd = commands[name]
    if not cmd then return end

    for _, alias in ipairs(cmd:getNames()) do
        commands[alias] = nil
    end
end

function RPGM.HandleCommands(ply, str)
    local name = string.Split(str, " ")[1]
    if not name then return end
    name = string.lower(name)

    local cmd = RPGM.GetCommand(name)
    if not cmd then return end

    cmd:execute(string.Right(str, #str - (#name + 1)), ply, function(allowed, reason)
        print("cum")
    end)

    return true
end


RPGM.RegisterCommand("ooc", {"/"}, {
    RPGM.Classes.TextArgument("Message", false, nil, false, true)
}, function(data)
    PrintTable(data)
end)