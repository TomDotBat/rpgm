
function RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)
    local tbl = {}
    tbl.__type = "base"

    function tbl:getName() return name end
    function tbl:getCategory() return category end
    function tbl:getCommand() return command end
    function tbl:getModel()
        return istable(model) and table.Random(model) or model
    end
    function tbl:getOrder() return order end
    function tbl:getExtras() return extra end
    function tbl:getFunctions() return functions end
    function tbl:doCustomCheck(ply)
        local check = functions["customCheck"]
        if not check then return true end

        return check(ply)
    end

    function tbl:setName(val)
        RPGM.Assert(isstring(val), "Item name must be a string.")
        name = val
    end

    function tbl:setCategory(val)
        RPGM.Assert(isstring(val), "Item category must be a string.")
        category = val
        RPGM.AddCategory(self.__type, val)
    end

    function tbl:setCommand(val)
        RPGM.Assert(isstring(val), "Item command must be a string.")
        command = val
    end

    function tbl:setModel(val)
        if istable(val) then
            for k, v in pairs(val) do
                RPGM.Assert(isstring(v), "Item model must be a string or table of strings.")
            end
        else
            RPGM.Assert(isstring(val), "Item model must be a string or table of strings.")
        end

        model = val
    end

    function tbl:setOrder(val)
        RPGM.Assert(isnumber(val), "Item order must be a number.")
        order = val
    end

    function tbl:setExtras(val)
        if table.IsEmpty(val) then return end
        RPGM.Assert(istable(val) and not table.IsSequential(val), "Item extra data must be a key-value table.")
        extra = val
    end

    function tbl:setExtra(key, val)
        RPGM.Assert(isstring(key), "Item extra name must be a string.")

        if not istable(extra) then extra = {} end
        extra[key] = val
    end

    function tbl:setFunctions(val)
        if table.IsEmpty(val) then return end
        RPGM.Assert(istable(val) and table.IsSequential(val), "Item functions must be a key-value table of functions and names.")

        for k, v in pairs(val) do
            RPGM.Assert(isfunction(v), "Item functions must be a key-value table of functions and names.")
        end

        functions = val
    end

    function tbl:setFunction(key, val)
        RPGM.Assert(isstring(key), "Item function name must be a string.")
        RPGM.Assert(isfunction(val), "Item function must be a function.")

        if not istable(functions) then functions = {} end
        functions[key] = val
    end

    tbl:setName(name)
    tbl:setCategory(category)
    tbl:setCommand(command)
    tbl:setModel(model)
    tbl:setOrder(order)
    tbl:setExtras(extra)
    tbl:setFunctions(functions)

    local netTable
    function tbl:getNetworkableTable(useCache)
        if useCache and netTable then return netTable end

        netTable = {
            ["name"] = name,
            ["category"] = category,
            ["command"] = command,
            ["model"] = model,
            ["order"] = order,
            ["extra"] = extra
        }

        return netTable
    end

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end