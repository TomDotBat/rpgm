
function RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)
    tbl.__type = "base_buyable"

    function tbl:getPrice(ply) return (isfunction(price) and IsValid(ply)) and price(ply) or price end
    function tbl:getMax(ply) return (isfunction(max) and IsValid(ply)) and max(ply) or max end
    function tbl:getJobsAllowed() return jobsAllowed end

    function tbl:isJobAllowed(jobName)
        if not jobsAllowed or table.Count(jobsAllowed) < 1 then return true end
        return jobsAllowed[jobName]
    end

    function tbl:canBuy(ply)
        local teamName = ply:teamName()
        if not self:isJobAllowed(teamName) then return false, "You can't buy this item as a " .. teamName .. "." end
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

    function tbl:setJobsAllowed(val)
        RPGM.Assert(istable(val), "Entity allowed jobs must be a table of job name strings.")

        for k, v in pairs(val) do
            RPGM.Assert(isstring(v), "Entity allowed jobs must be a table of job name strings.")
        end

        jobsAllowed = val
    end

    tbl:setPrice(price)
    tbl:setMax(max)
    tbl:setJobsAllowed(jobsAllowed)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end