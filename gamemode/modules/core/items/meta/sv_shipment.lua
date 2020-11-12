
function RPGM.Classes.Shipment(name, category, command, model, order, extra, functions, price, max, jobsAllowed, class)
    local tbl = RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max, jobsAllowed)

    function tbl:getClass() return class end

    function tbl:setClass(val)
        assert(isstring(val), "Shipment class must be a weapon class string.")
        if not weapons.Get(val) then
            print("Warning! The weapon \"" .. val .. "\" doesn't exist for the shipment " .. name .. ", defaulting to \"weapon_physcannon\".")
            class = "weapon_physcannon"
            return
        end

        class = val
    end

    tbl:setClass(class)

    return tbl
end