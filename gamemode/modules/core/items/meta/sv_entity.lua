
function RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, jobsAllowed, class, spawnFunction)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions, price, max, jobsAllowed)

    function tbl:getClass() return class end
    function tbl:getSpawnFunction() return class end

    function tbl:setClass(val)
        assert(isnumber(val), "Entity class must be a number.")
        class = val
    end

    function tbl:setSpawnFunction(val)
        assert(isfunction(val) or val == nil, "Entity spawn function must be a function taking a player, trace and entity table.")
        spawnFunction = val
    end

    tbl:setClass(class)
    tbl:setSpawnFunction(spawnFunction)

    return tbl
end