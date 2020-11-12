
function RPGM.Classes.Team(name, category, command, model, order, extra, functions, description, weapons, limit)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)

    function tbl:getDescription() return description end
    function tbl:getWeapons() return weapons end
    function tbl:getLimit() return limit end

    function tbl:setDescription(val)
        assert(isstring(val), "Team description must be a string.")
        description = val
    end

    function tbl:setWeapons(val)
        assert(istable(val), "Team weapons must be a table of weapon class strings.")

        local actualWeapons = {}
        for k, v in pairs(val) do
            assert(isstring(v), "Team weapons must be a table of weapon class strings.")

            if not weapons.Get(v) then
                print("Warning! The weapon \"" .. v .. "\" doesn't exist, removing from the loadout for " .. name ".")
                continue
            end
            table.insert(actualWeapons, v)
        end

        weapons = actualWeapons
    end

    function tbl:setLimit(val)
        assert(isnumber(val), "Team maximum must be a number.")
        limit = val
    end

    tbl:setDescription(description)
    tbl:setLimit(limit)

    return tbl
end