
local _R = debug.getregistry()

function RPGM.Classes.BuyableItemBase(tbl, name, category, command, model, order, extra, functions, price, max, teamsAllowed)
    tbl = RPGM.Classes.ItemBase(
        tbl or setmetatable({}, _R["RPGMBuyableItemBase"]),
        name, category, command, model, order, extra, functions
    )

    tbl.__type = "base_buyable"

    tbl:setPrice(price)
    tbl:setMax(max)
    tbl:setTeamsAllowed(teamsAllowed)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end

if _R["RPGMBuyableItemBase"] then return end

local itemBase = _R["RPGMItemBase"]

local buyableItemBase = {}
_R["RPGMBuyableItemBase"] = buyableItemBase

buyableItemBase.__index = buyableItemBase
buyableItemBase.__type = "base"

setmetatable(buyableItemBase, {
    __index = itemBase
})

function buyableItemBase:getPrice(ply) return (isfunction(self._price) and IsValid(ply)) and self._price(ply) or self._price end
function buyableItemBase:getMax(ply) return (isfunction(self._max) and IsValid(ply)) and self._max(ply) or self._max end
function buyableItemBase:getTeamsAllowed() return self._teamsAllowed end

function buyableItemBase:setPrice(val)
    if isfunction(val) then self._price = val return end

    RPGM.Assert(isnumber(val), "Item price must be a number or function taking a player argument.")
    self._price = val
end

function buyableItemBase:setMax(val)
    if isfunction(val) then self._max = val return end

    RPGM.Assert(isnumber(val), "Item maximum must be a number or function taking a player argument.")
    self._max = val
end

function buyableItemBase:setTeamsAllowed(val)
    RPGM.Assert(istable(val), "Entity allowed teams must be a table of team command strings.")

    for k, v in pairs(val) do
        RPGM.Assert(isstring(v), "Entity allowed teams must be a table of team command strings.")
    end

    self._teamsAllowed = val
end

function buyableItemBase:isTeamAllowed(teamName)
    if not self._teamsAllowed or table.Count(self._teamsAllowed) < 1 then return true end
    return self._teamsAllowed[teamName]
end

local lang = gmodI18n.getAddon("rpgm")
function buyableItemBase:canBuy(ply)
    local teamName = ply:teamName()
    if not self:isTeamAllowed(teamName) then return false, lang:getString("cantBuyItemAs", {teamName = teamName}) end
    return self:doCustomCheck(ply)
end

function buyableItemBase:getNetworkableTable(useCache)
    if useCache and self._netTable then return self._netTable end

    itemBase.getNetworkableTable(self, useCache)

    self._netTable["price"] = price
    self._netTable["max"] = max
    self._netTable["teamsAllowed"] = teamsAllowed

    return self._netTable
end
