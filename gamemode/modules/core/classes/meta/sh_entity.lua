
local _R = debug.getregistry()

function RPGM.Classes.Entity(tbl, name, category, command, model, order, extra, functions, price, max, teamsAllowed, class, spawnFunction)
    tbl = RPGM.Classes.BuyableItemBase(
        tbl or setmetatable({}, _R["RPGMEntity"]),
        name, category, command, model, order, extra, functions, price, max, teamsAllowed
    )

    tbl.__type = "entity"

    tbl:setClass(class)
    tbl:setSpawnFunction(spawnFunction)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end

if _R["RPGMEntity"] then return end

local buyableItemBase = _R["RPGMBuyableItemBase"]

local entity = {}
_R["RPGMEntity"] = entity

entity.__index = entity
setmetatable(entity, {
    __index = buyableItemBase
})

function entity:getClass() return self._class end
function entity:getSpawnFunction() return self._functions["spawnFunction"] end

function entity:setClass(val)
    RPGM.Assert(isstring(val), "Entity class must be a entity class string.")

    if not scripted_ents.Get(val) then
        RPGM.LogWarning("The entity \"" .. val .. "\" doesn't exist for the buyable entity " .. name .. ", defaulting to \"prop_physics\".")
        self._class = "prop_physics"
        return
    end

    self._class = val
end

function entity:setSpawnFunction(val)
    RPGM.Assert(isfunction(val) or val == nil, "Entity spawn function must be a function taking a player, trace and entity table.")
    self._functions["spawnFunction"] = val
end

function entity:getNetworkableTable(useCache)
    if useCache and self._netTable then return self._netTable end

    buyableItemBase.getNetworkableTable(self, useCache)
    self._netTable["class"] = self._class

    return netTable
end
