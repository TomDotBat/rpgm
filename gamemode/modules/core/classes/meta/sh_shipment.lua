
local _R = debug.getregistry()

function RPGM.Classes.Shipment(tbl, name, category, command, model, order, extra, functions, price, max, teamsAllowed, class, size, sellIndividual, individualPrice)
    tbl = RPGM.Classes.BuyableItemBase(
        tbl or setmetatable({}, _R["RPGMShipment"]),
        name, category, command, model, order, extra, functions, price, max, teamsAllowed
    )

    tbl.__type = "shipment"

    tbl:setClass(class)
    tbl:setSize(size)
    tbl:setSellIndividual(sellIndividual)
    tbl:setIndividualPrice(individualPrice)

    RPGM.Classes.SetupExtras(tbl)

    return tbl
end

if _R["RPGMShipment"] then return end

local buyableItemBase = _R["RPGMBuyableItemBase"]

local shipment = {}
_R["RPGMShipment"] = shipment

shipment.__index = shipment
setmetatable(shipment, {
    __index = buyableItemBase
})

function shipment:getClass() return self._class end
function shipment:getSize(ply) return (isfunction(self._size) and IsValid(ply)) and self._size(ply) or self._size end
function shipment:getSellIndividual() return self._sellIndividual end
function shipment:getIndividualPrice(ply) return (isfunction(self._individualPrice) and IsValid(ply)) and self._individualPrice(ply) or self._individualPrice end

function shipment:setClass(val)
    RPGM.Assert(isstring(val), "Shipment class must be a weapon class string.")

    if not weapons.Get(val) then
        RPGM.LogWarning("The weapon \"" .. val .. "\" doesn't exist for the shipment " .. name .. ", defaulting to \"weapon_physcannon\".")
        self._class = "weapon_physcannon"
        return
    end

    self._class = val
end

function shipment:setSize(val)
    if isfunction(val) then self._size = val return end
    RPGM.Assert(isnumber(val), "Shipment size must be a number or function taking a player argument.")
    self._size = val
end

function shipment:setSellIndividual(val)
    RPGM.Assert(isbool(val), "Shipment individual sell state must be a boolean.")
    self._sellIndividual = val
end

function shipment:setIndividualPrice(val)
    if isfunction(val) then self._individualPrice = val return end
    RPGM.Assert(isnumber(val), "Individual shipment price must be a number or function taking a player argument.")
    self._individualPrice = val
end

function shipment:getNetworkableTable(useCache)
    if useCache and self._netTable then return self._netTable end

    buyableItemBase.getNetworkableTable(self, useCache)
    self._netTable["class"] = self._class
    self._netTable["size"] = self._size
    self._netTable["individualPrice"] = self._individualPrice
    self._netTable["sellIndividual"] = self._sellIndividual

    return netTable
end
