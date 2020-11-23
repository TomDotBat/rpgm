
local meta = FindMetaTable("Entity")

function meta:getRPAngle(key, fallback, pvsOnly)
    return RPGM.GetNWAngle(self, key, fallback, pvsOnly)
end

function meta:getRPBool(key, fallback, pvsOnly)
    return RPGM.GetNWBool(self, key, fallback, pvsOnly)
end

function meta:getRPEntity(key, fallback, pvsOnly)
    return RPGM.GetNWEntity(self, key, fallback, pvsOnly)
end

function meta:getRPFloat(key, fallback, pvsOnly)
    return RPGM.GetNWFloat(self, key, fallback, pvsOnly)
end

function meta:getRPInt(key, fallback, pvsOnly)
    return RPGM.GetNWInt(self, key, fallback, pvsOnly)
end

function meta:getRPString(key, fallback, pvsOnly)
    return RPGM.GetNWString(self, key, fallback, pvsOnly)
end

function meta:getRPVector(key, fallback, pvsOnly)
    return RPGM.GetNWVector(self, key, fallback, pvsOnly)
end

-----------------

function meta:setRPAngle(key, val, pvsOnly)
    RPGM.SetNWAngle(self, key, val, pvsOnly)
end

function meta:setRPBool(key, val, pvsOnly)
    RPGM.SetNWBool(self, key, val, pvsOnly)
end

function meta:setRPEntity(key, val, pvsOnly)
    RPGM.SetNWEntity(self, key, val, pvsOnly)
end

function meta:setRPFloat(key, val, pvsOnly)
    RPGM.SetNWFloat(self, key, val, pvsOnly)
end

function meta:setRPInt(key, val, pvsOnly)
    RPGM.SetNWInt(self, key, val, pvsOnly)
end

function meta:setRPString(key, val, pvsOnly)
    RPGM.SetNWString(self, key, val, pvsOnly)
end

function meta:setRPVector(key, val, pvsOnly)
    RPGM.SetNWVector(self, key, val, pvsOnly)
end