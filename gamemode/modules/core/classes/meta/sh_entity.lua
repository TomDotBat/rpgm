
function RPGM.Classes.Entity(name, category, command, model, order, extra, functions, price, max, teamsAllowed, class, spawnFunction)
    local tbl = RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, teamsAllowed)
    tbl.__type = "entity"

    function tbl:getClass() return class end
    function tbl:getSpawnFunction() return spawnFunction end

    function tbl:setClass(val)
        RPGM.Assert(isstring(val), "Entity class must be a entity class string.")
        if not scripted_ents.Get(val) then
            RPGM.LogWarning("The entity \"" .. val .. "\" doesn't exist for the buyable entity " .. name .. ", defaulting to \"prop_physics\".")
            class = "prop_physics"
            return
        end
        class = val
    end

    function tbl:setSpawnFunction(val)
        RPGM.Assert(isfunction(val) or val == nil, "Entity spawn function must be a function taking a player, trace and entity table.")
        functions[spawnFunction] = val
    end

    tbl:setClass(class)
    tbl:setSpawnFunction(spawnFunction)

    local parentNetTableGetter = tbl.getNetworkableTable
    function tbl:getNetworkableTable(useCache)
        local netTable = parentNetTableGetter(self, useCache)

        netTable["class"] = class
        netTable["spawnFunction"] = spawnFunction

        return netTable
    end

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end