
function RPGM.Classes.Shipment(name, category, command, model, order, extra, functions, price, max, teamsAllowed, class, size, sellIndividual, individualPrice)
    local tbl = RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, teamsAllowed)
    tbl.__type = "shipment"

    function tbl:getClass() return class end
    function tbl:getSize(ply) return (isfunction(size) and IsValid(ply)) and size(ply) or size end
    function tbl:getSellIndividual() return sellIndividual end
    function tbl:getIndividualPrice(ply) return (isfunction(individualPrice) and IsValid(ply)) and individualPrice(ply) or individualPrice end

    function tbl:setClass(val)
        RPGM.Assert(isstring(val), "Shipment class must be a weapon class string.")
        if not weapons.Get(val) then
            RPGM.LogWarning("The weapon \"" .. val .. "\" doesn't exist for the shipment " .. name .. ", defaulting to \"weapon_physcannon\".")
            class = "weapon_physcannon"
            return
        end

        class = val
    end

    function tbl:setSize(val)
        if isfunction(val) then size = val return end

        RPGM.Assert(isnumber(val), "Shipment size must be a number or function taking a player argument.")
        size = val
    end

    function tbl:setSellIndividual(val)
        RPGM.Assert(isbool(val), "Shipment individual sell state must be a boolean.")
        sellIndividual = val
    end

    function tbl:setIndividualPrice(val)
        if isfunction(val) then individualPrice = val return end

        RPGM.Assert(isnumber(val), "Individual shipment price must be a number or function taking a player argument.")
        individualPrice = val
    end

    tbl:setClass(class)
    tbl:setSize(size)
    tbl:setIndividualPrice(individualPrice)
    tbl:setSellIndividual(sellIndividual)

    local parentNetTableGetter = tbl.getNetworkableTable
    function tbl:getNetworkableTable(useCache)
        local netTable = parentNetTableGetter(self, useCache)

        netTable["class"] = class
        netTable["size"] = size
        netTable["individualPrice"] = individualPrice
        netTable["sellIndividual"] = sellIndividual

        return netTable
    end

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end