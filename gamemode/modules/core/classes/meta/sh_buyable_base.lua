
local lang = gmodI18n.getAddon("rpgm")

function RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, teamsAllowed)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)
    tbl.__type = "base_buyable"

    function tbl:getPrice(ply) return (isfunction(price) and IsValid(ply)) and price(ply) or price end
    function tbl:getMax(ply) return (isfunction(max) and IsValid(ply)) and max(ply) or max end
    function tbl:getTeamsAllowed() return teamsAllowed end

    function tbl:isTeamAllowed(teamName)
        if not teamsAllowed or table.Count(teamsAllowed) < 1 then return true end
        return teamsAllowed[teamName]
    end

    function tbl:canBuy(ply)
        local teamName = ply:teamName()
        if not self:isTeamAllowed(teamName) then return false, lang:getString("cantBuyItemAs", {teamName = teamName}) end
        return self:doCustomCheck(ply)
    end

    function tbl:setPrice(val)
        if isfunction(val) then price = val return end

        RPGM.Assert(isnumber(val), "Item price must be a number or function taking a player argument.")
        price = val
    end

    function tbl:setMax(val)
        if isfunction(val) then max = val return end

        RPGM.Assert(isnumber(val), "Item maximum must be a number or function taking a player argument.")
        max = val
    end

    function tbl:setTeamsAllowed(val)
        RPGM.Assert(istable(val), "Entity allowed teams must be a table of team command strings.")

        for k, v in pairs(val) do
            RPGM.Assert(isstring(v), "Entity allowed teams must be a table of team command strings.")
        end

        teamsAllowed = val
    end

    tbl:setPrice(price)
    tbl:setMax(max)
    tbl:setTeamsAllowed(teamsAllowed)

    local parentNetTableGetter = tbl.getNetworkableTable
    function tbl:getNetworkableTable(useCache)
        local netTable = parentNetTableGetter(self, useCache)

        netTable["price"] = price
        netTable["max"] = max
        netTable["teamsAllowed"] = teamsAllowed

        return netTable
    end

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end