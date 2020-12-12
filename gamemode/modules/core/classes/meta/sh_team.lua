
function RPGM.Classes.Team(name, category, command, model, order, extra, functions, color, description, weps, limit)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)
    tbl.__type = "team"

    function tbl:getColor() return color end
    function tbl:getDescription() return description end
    function tbl:getWeapons() return weps end
    function tbl:getLimit(ply) return (isfunction(limit) and IsValid(ply)) and limit(ply) or limit end

    function tbl:setColor(val)
        RPGM.Assert(IsColor(val), "Team color must be a color.")
        color = val
    end

    function tbl:setDescription(val)
        RPGM.Assert(isstring(val), "Team description must be a string.")
        description = val
    end

    function tbl:setWeapons(val)
        RPGM.Assert(istable(val), "Team weapons must be a table of weapon class strings.")

        local actualWeapons = {}
        for k, v in pairs(val) do
            RPGM.Assert(isstring(v), "Team weapons must be a table of weapon class strings.")

            if not weapons.Get(v) then
                RPGM.LogWarning("The weapon \"" .. v .. "\" doesn't exist, removing from the loadout for " .. name ".")
                continue
            end
            table.insert(actualWeapons, v)
        end

        weps = actualWeapons
    end

    function tbl:setLimit(val)
        if isfunction(val) then limit = val return end

        RPGM.Assert(isnumber(val), "Team slot limit must be a number or function taking a player argument.")
        limit = val
    end

    tbl:setColor(color)
    tbl:setDescription(description)
    tbl:setWeapons(weps)
    tbl:setLimit(limit)

    local parentNetTableGetter = tbl.getNetworkableTable
    function tbl:getNetworkableTable(useCache)
        local netTable = parentNetTableGetter(self, useCache)

        netTable["id"] = self.__id
        netTable["color"] = color
        netTable["description"] = description
        netTable["weapons"] = weps
        netTable["limit"] = limit

        return netTable
    end

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end