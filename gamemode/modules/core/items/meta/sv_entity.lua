
function RPGM.Classes.Entity(name, category, command, model, order, extra, functions, price, max, jobsAllowed, class, spawnFunction)
    local tbl = RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, jobsAllowed)

    function tbl:getClass() return class end
    function tbl:getSpawnFunction() return spawnFunction end

    function tbl:setClass(val)
        assert(isstring(val), "Entity class must be a entity class string.")
        if not scripted_ents.Get(val) then
            print("Warning! The entity \"" .. val .. "\" doesn't exist for the buyable entity " .. name .. ", defaulting to \"prop_physics\".")
            class = "prop_physics"
            return
        end
        class = val
    end

    function tbl:setSpawnFunction(val)
        assert(isfunction(val) or val == nil, "Entity spawn function must be a function taking a player, trace and entity table.")
        functions[spawnFunction] = val
    end

    tbl:setClass(class)
    tbl:setSpawnFunction(spawnFunction)

    return tbl
end