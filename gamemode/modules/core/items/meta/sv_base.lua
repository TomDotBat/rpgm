
function RPGM.Classes.ItemBase(name, category, command, model, order)
    local tbl = {}

    function tbl:getName() return name end
    function tbl:getCategory() return category end
    function tbl:getCommand() return command end
    function tbl:getModel() 
        return istable(model) and table.Random(model) or model
    end
    function tbl:getOrder() return order end

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

    tbl:setName(name)
    tbl:setCategory(category)
    tbl:setCommand(command)
    tbl:setModel(model)
    tbl:setOrder(order)

    return tbl
end