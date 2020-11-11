
function RPGM.Classes.BuyableItemBase(name, category, command, model, order, price, max)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order)

    function tbl:getPrice() return price end
    function tbl:getMax() return max end

    function tbl:setPrice(val)
        assert(isnumber(val), "Item price must be a number.")
        price = val
    end

    function tbl:setMax(val)
        assert(isnumber(val), "Item maximum must be a number.")
        max = val
    end

    tbl:setPrice(max)
    tbl:setMax(max)

    return tbl
end