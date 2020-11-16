
local commands = {}

function RPGM.GetCommands()
    return commands
end

function RPGM.GetCommand(name)
    return commands[name]
end

function RPGM.RemoveCommand(name)
    commands[name] = nil
end