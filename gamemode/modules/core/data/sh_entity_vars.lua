
local varPrefix = "RPGM."

function RPGM.GetNWAngle(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Angle(varPrefix .. key, fallback)
     or ent:GetNWAngle(varPrefix .. key, fallback)
end

function RPGM.GetNWBool(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Bool(varPrefix .. key, fallback)
     or ent:GetNWBool(varPrefix .. key, fallback)
end

function RPGM.GetNWEntity(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Entity(varPrefix .. key, fallback)
     or ent:GetNWEntity(varPrefix .. key, fallback)
end

function RPGM.GetNWFloat(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Float(varPrefix .. key, fallback)
     or ent:GetNWFloat(varPrefix .. key, fallback)
end

function RPGM.GetNWInt(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Int(varPrefix .. key, fallback)
     or ent:GetNWInt(varPrefix .. key, fallback)
end

function RPGM.GetNWString(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2String(varPrefix .. key, fallback)
     or ent:GetNWString(varPrefix .. key, fallback)
end

function RPGM.GetNWVector(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Vector(varPrefix .. key, fallback)
     or ent:GetNWVector(varPrefix .. key, fallback)
end

-----------------

function RPGM.SetNWAngle(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Angle(varPrefix .. key, val)
     or ent:SetNWAngle(varPrefix .. key, val)
end

function RPGM.SetNWBool(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Bool(varPrefix .. key, val)
     or ent:SetNWBool(varPrefix .. key, val)
end

function RPGM.SetNWEntity(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Entity(varPrefix .. key, val)
     or ent:SetNWEntity(varPrefix .. key, val)
end

function RPGM.SetNWFloat(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Float(varPrefix .. key, val)
     or ent:SetNWFloat(varPrefix .. key, val)
end

function RPGM.SetNWInt(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Int(varPrefix .. key, val)
     or ent:SetNWInt(varPrefix .. key, val)
end

function RPGM.SetNWString(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2String(varPrefix .. key, val)
     or ent:SetNWString(varPrefix .. key, val)
end

function RPGM.SetNWVector(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Vector(varPrefix .. key, val)
     or ent:SetNWVector(varPrefix .. key, val)
end