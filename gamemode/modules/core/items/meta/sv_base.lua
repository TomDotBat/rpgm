
function RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)
    local tbl = {}

    function tbl:getName() return name end
    function tbl:getCategory() return category end
    function tbl:getCommand() return command end
    function tbl:getModel()
        return istable(model) and table.Random(model) or model
    end
    function tbl:getOrder() return order end
    function tbl:getExtra() return extra end
    function tbl:getFunctions() return functions end
    function tbl:doCustomCheck(ply)
        local check = functions["customCheck"]
        if not check then return true end

        return check(ply)
    end

    function tbl:setName(val)
        assert(isstring(val), "Item name must be a string.")
        name = val
    end

    function tbl:setCategory(val)
        assert(isstring(val), "Item category must be a string.")
        category = val
    end

    function tbl:setCommand(val)
        assert(isstring(val), "Item command must be a string.")
        command = val
    end

    function tbl:setModel(val)
        if istable(val) then
            for k, v in pairs(val) do
                assert(isstring(v), "Item model must be a string or table of strings.")
            end
        end

        assert(isstring(val), "Item model must be a string or table of strings.")

        model = val
    end

    function tbl:setOrder(val)
        assert(isnumber(val), "Item order must be a number.")
        order = val
    end

    function tbl:setExtra(val)
        assert(istable(val) and not table.IsSequential(val), "Item extra data must be a key-value table.")
        extra = val
    end

    function tbl:setFunctions(val)
        assert(istable(val) and not table.IsSequential(val), "Item hook overrides must be a key-value table of hook identifiers and functions.")

        for k, v in pairs(val) do
            assert(isfunction(v), "Item hook overrides must be a key-value table of hook identifiers and functions.")
        end

        functions = val
    end

    tbl:setName(name)
    tbl:setCategory(category)
    tbl:setCommand(command)
    tbl:setModel(model)
    tbl:setOrder(order)
    tbl:setExtra(extra)
    tbl:setFunctions(val)

    return tbl
end