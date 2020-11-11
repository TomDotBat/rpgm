
--[[
    TEAM_CITIZEN = DarkRP.createJob("Citizen", {
        color = Color(20, 150, 20, 255),
    model = {
        "models/cyanblue/darlingfranxx/zerotwo/zerotwo.mdl"
    },
    description = "citizen things",
    weapons = {},
    command = "citizen",
    max = 0,
    salary = 45,
    admin = 0,
    vote = false,
    hasLicense = false,
    candemote = false,
    category = "Citizens",
    sortOrder = 1,
    role = "Gold Donator",
    PlayerSpawn = function(ply) ply:SetBodygroup(1, 1) end,
    clearance = 1
    })
--]]

function RPGM.Classes.Team(name, category, command, model, order, description, weapons, limit, extra, hookOverrides)
    local tbl = RPGM.Classes.ItemBase(name, category, command, model, order)

    function tbl:getDescription() return description end
    function tbl:getWeapons() return weapons end
    function tbl:getLimit() return limit end
    function tbl:getExtra() return extra end
    function tbl:getHookOverrides() return hookOverrides end

    function tbl:doCustomCheck(ply)
        local check = hookOverrides["customCheck"]
        if not check then return true end

        return check(ply)
    end

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

    function tbl:setExtra(val)
        assert(istable(val) and not table.IsSequential(val), "Team extra data must be a key-value table.")
        extra = val
    end

    function tbl:setHookOverrides(val)
        assert(istable(val) and not table.IsSequential(val), "Team hook overrides must be a key-value table of hook identifiers and functions.")

        for k, v in pairs(val) do
            assert(isfunction(v), "Team hook overrides must be a key-value table of hook identifiers and functions.")
        end

        hookOverrides = val
    end

    tbl:setDescription(description)
    tbl:setLimit(limit)
    tbl:setExtra(extra)
    tbl:setHookOverrides(val)

    return tbl
end