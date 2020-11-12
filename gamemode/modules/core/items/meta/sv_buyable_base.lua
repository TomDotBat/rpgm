
function RPGM.Classes.BuyableItemBase(name, category, command, model, order, extra, functions, price, max)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order, extra, functions)

    function tbl:getPrice(ply) return (isfunction(price) and IsValid(ply)) and price(ply) or price end
    function tbl:getMax() return (isfunction(max) and IsValid(ply)) and max(ply) or max end
    function tbl:getJobsAllowed() return jobsAllowed end
    function tbl:isJobAllowed(jobName)
        if not jobsAllowed or table.Count(jobsAllowed) < 1 then return true end
        return jobsAllowed[jobName]
    end

    function tbl:setPrice(val)
        if isfunction(val) then price = val return end

        assert(isnumber(val), "Item price must be a number or function taking a player argument.")
        price = val
    end

    function tbl:setMax(val)
        if isfunction(val) then max = val return end

        assert(isnumber(val), "Item maximum must be a number or function taking a player argument.")
        max = val
    end

    function tbl:setJobsAllowed(val)
        assert(istable(val), "Entity allowed jobs must be a table of job name strings.")

        for k, v in pairs(val) do
            assert(isstring(v), "Entity allowed jobs must be a table of job name strings.")
        end

        jobsAllowed = val
    end

    tbl:setPrice(max)
    tbl:setMax(max)
    tbl:setJobsAllowed(jobsAllowed)

    return tbl
end