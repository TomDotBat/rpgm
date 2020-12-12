
function RPGM.Classes.Command(name, aliases, args, func, permission, minAccess)
    local tbl = {}
    tbl.__type = "command"

    local names = {}

    local function cleanName(nm)
        return string.lower(string.Trim(nm))
    end

    local function updateNames()
        names = table.Copy(aliases)
        table.insert(names, 1, cleanName(name))
    end

    function tbl:getName() return name end
    function tbl:getNames() return names end
    function tbl:getAliases() return aliases end
    function tbl:getArguments() return args end
    function tbl:getFunction() return func end
    function tbl:getPermission() return permission end
    function tbl:getSyntax()
        local syntax = ""

        for k, v in ipairs(args) do
            syntax = syntax .. "<" .. v.DisplayType .. ": " .. v:getName() .. "> "
        end

        return string.Left(syntax, #syntax - 1)
    end
    function tbl:hasPermission(ply, callback, targetPly)
        if not permission then
            callback(true, "The \"" .. name .. "\" command is not permission restricted.")
            return true, "The \"" .. name .. "\" command is not permission restricted."
        end

        return CAMI.PlayerHasAccess(ply, "RPGM." .. permission, callback, targetPly)
    end

    function tbl:setName(val)
        RPGM.Assert(isstring(val), "Command name must be a string.")
        name = val
        updateNames()
    end

    function tbl:setAliases(val)
        RPGM.Assert(istable(val), "Command aliases must be a sequential table of strings.")
        RPGM.Assert(table.IsSequential(val), "Command aliases must be a sequential table of strings.")

        for k, v in ipairs(val) do
            RPGM.Assert(isstring(v), "Command aliases must be a sequential table of strings.")
            v = cleanName(v)
        end

        aliases = val
        updateNames()
    end

    function tbl:setFunction(val)
        RPGM.Assert(isfunction(val), "Command function must be a function.")
        func = val
    end

    function tbl:setArguments(val)
        RPGM.Assert(istable(val), "Command arguments must be a sequential table of arugment classes.")
        RPGM.Assert(table.IsSequential(val), "Command arguments must be a sequential table of arugment classes.")

        for k, v in ipairs(val) do
            RPGM.Assert(string.StartWith(v.__type, "argument_"), "Command arguments must be a sequential table of arugment classes.")
        end

        args = val
    end

    function tbl:setPermission(val, access)
        RPGM.Assert(isstring(val), "Command permission must be a string.")
        RPGM.Assert(isstring(access), "Command minimum access level must be a usergroup name string.")

        CAMI.UnregisterPrivilege("RPGM." .. permission)

        permission = val

        CAMI.RegisterPrivilege({
            Name = "RPGM." .. val,
            MinAccess = access
        })
    end

    function tbl:execute(str, caller, callback)
        local data = {}
        local targetPly

        for k, arg in ipairs(args) do
            local success, str, result = arg:processString(str, caller)
            if not success then
                callback(false, "Correct syntax: " .. name .. " " .. self:getSyntax())
                return false
            end

            if arg.__type == "argument_player" then
                targetPly = result
            end

            data[k] = result
        end

        return self:hasPermission(caller, function(allowed, reason)
            callback(allowed, reason)
            if not allowed then return end

            func(caller, data)
        end, targetPly)
    end

    tbl:setName(name)
    tbl:setAliases(aliases or {})

    if not istable(args) then args = nil
    else tbl:setArguments(args) end

    if not isstring(permission) then permission = nil
    else tbl:setPermission(permission, minAccess) end

    return tbl
end