
local _R = debug.getregistry()

function RPGM.Classes.Team(tbl, name, category, command, model, order, extra, functions, color, description, weps, limit)
    tbl = RPGM.Classes.ItemBase(
        tbl or setmetatable({}, _R["RPGMTeam"]),
        name, category, command, model, order, extra, functions
    )

    tbl.__type = "team"

    tbl:setColor(color)
    tbl:setDescription(description)
    tbl:setWeapons(weps)
    tbl:setLimit(limit)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end

if _R["RPGMTeam"] then return end

local itemBase = _R["RPGMItemBase"]

local team = {}
_R["RPGMTeam"] = team

team.__index = team
team.__type = "base"

setmetatable(team, {
    __index = itemBase
})

function team:getColor() return self._color end
function team:getDescription() return self._description end
function team:getWeapons() return self._weps end
function team:getLimit(ply) return (isfunction(self._limit) and IsValid(ply)) and self._limit(ply) or self._limit end

function team:setColor(val)
    RPGM.Assert(IsColor(val), "Team color must be a color.")
    self._color = val
end

function team:setDescription(val)
    RPGM.Assert(isstring(val), "Team description must be a string.")
    self._description = val
end

function team:setWeapons(val)
    RPGM.Assert(istable(val), "Team weapons must be a table of weapon class strings.")

    local actualWeapons = {}
    for k, v in pairs(val) do
        RPGM.Assert(isstring(v), "Team weapons must be a table of weapon class strings.")

        if not weapons.Get(v) then
            RPGM.LogWarning("The weapon \"" .. v .. "\" doesn't exist, removing from the loadout for " .. self._name .. ".")
            continue
        end
        table.insert(actualWeapons, v)
    end

    self._weps = actualWeapons
end

function team:setLimit(val)
    if isfunction(val) then self._limit = val return end

    RPGM.Assert(isnumber(val), "Team slot limit must be a number or function taking a player argument.")
    self._limit = val
end

function team:getNetworkableTable(useCache)
    if useCache and self._netTable then return self._netTable end

    itemBase.getNetworkableTable(self, useCache)

    self._netTable["id"] = self.__id
    self._netTable["color"] = self._color
    self._netTable["description"] = self._description
    self._netTable["weapons"] = self._weps
    self._netTable["limit"] = self._limit

    return self._netTable
end
