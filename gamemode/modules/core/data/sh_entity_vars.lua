
function RPGM.GetNWAngle(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Angle(key, fallback) or ent:GetNWAngle(key, fallback)
end

function RPGM.GetNWBool(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Bool(key, fallback) or ent:GetNWBool(key, fallback)
end

function RPGM.GetNWEntity(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Entity(key, fallback) or ent:GetNWEntity(key, fallback)
end

function RPGM.GetNWFloat(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Float(key, fallback) or ent:GetNWFloat(key, fallback)
end

function RPGM.GetNWInt(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Int(key, fallback) or ent:GetNWInt(key, fallback)
end

function RPGM.GetNWString(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2String(key, fallback) or ent:GetNWString(key, fallback)
end

function RPGM.GetNWVector(ent, key, fallback, pvsOnly)
    return pvsOnly and ent:GetNW2Vector(key, fallback) or ent:GetNWVector(key, fallback)
end

-----------------

function RPGM.SetNWAngle(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Angle(key, val) or ent:SetNWAngle(key, val)
end

function RPGM.SetNWBool(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Bool(key, val) or ent:SetNWBool(key, val)
end

function RPGM.SetNWEntity(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Entity(key, val) or ent:SetNWEntity(key, val)
end

function RPGM.SetNWFloat(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Float(key, val) or ent:SetNWFloat(key, val)
end

function RPGM.SetNWInt(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Int(key, val) or ent:SetNWInt(key, val)
end

function RPGM.SetNWString(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2String(key, val) or ent:SetNWString(key, val)
end

function RPGM.SetNWVector(ent, key, val, pvsOnly)
    return pvsOnly and ent:SetNW2Vector(key, val) or ent:SetNWVector(key, val)
end