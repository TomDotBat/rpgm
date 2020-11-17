
local commands = {}

function RPGM.GetCommands()
    return commands
end

function RPGM.GetCommand(name)
    return commands[name]
end

function RPGM.RegisterCommand(...)
    table.insert(commands, RPGM.Classes.Command(...))
end

function RPGM.RemoveCommand(name)
    commands[name] = nil
end

function RPGM.HandleCommands(ply, str)
    local name = string.Split(str, " ")[1]
    if not name then return end
    name = string.lower(name)

    for _, cmd in ipairs(commands) do
        local aliases = cmd:getAliases()
        for _, alias in ipairs(aliases) do
            if name == alias then
                cmd:execute(string.Right(str, #str - (name + 1)), ply, function(allowed, reason)

                end)

                return true
            end
        end
    end

    return
end