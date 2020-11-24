
local meta = FindMetaTable("Player")

function meta:getMoney(callback)
    if CLIENT then
        if callback then callback(self:getRPInt("Money", -1)) end
    else
        if callback then RPGM.GetPlayerMoney(self, callback) end
    end

    return self:getRPInt("Money", -1)
end

function meta:canAfford(amount, callback)
    if CLIENT then
        if callback then callback(amount <= self:getRPInt("Money", -1)) end
    else
        if callback then RPGM.CanPlayerAffordMoney(self, amount, callback) end
    end

    return amount <= self:getRPInt("Money", -1)
end

if CLIENT then return end

function meta:setMoney(amount, callback)
    RPGM.SetPlayerMoney(self, amount, callback)
end

function meta:addMoney(amount, callback)
    RPGM.GivePlayerMoney(self, amount, callback)
end

function meta:removeMoney(amount, callback)
    RPGM.RemovePlayerMoney(self, amount, callback)
end