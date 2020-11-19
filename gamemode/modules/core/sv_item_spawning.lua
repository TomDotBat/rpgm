
--[[
    < 1 Anyone
    1   Admin
    2   SuperAdmin
    > 2 No One
]]

local function canPlayerSpawn(ply, permissionLevel)
    if permissionLevel < 1 then return true end
    if permissionLevel > 2 then return false end

    if permissionLevel == 1 then
        return ply:IsAdmin()
    elseif permissionLevel == 2 then
        return ply:IsSuperAdmin()
    end
end

function GM:PlayerSpawnProp(ply, model)
    if not canPlayerSpawn(ply, RPGM.Config.PropSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnProp(self, ply, model)
end

function GM:PlayerSpawnEffect(ply, model)
    if not canPlayerSpawn(ply, RPGM.Config.EffectSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnEffect(self, ply, model)
end

function GM:PlayerSpawnRagdoll(ply, model)
    if not canPlayerSpawn(ply, RPGM.Config.RagdollSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnRagdoll(self, ply, model)
end

function GM:PlayerSpawnSWEP(ply, class, wep)
    if not canPlayerSpawn(ply, RPGM.Config.WeaponSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnSWEP(self, ply, class, wep)
end

function GM:PlayerSpawnSENT(ply, class)
    if not canPlayerSpawn(ply, RPGM.Config.EntitySpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnSENT(self, ply, class)
end

function GM:PlayerSpawnNPC(ply, type, wep)
    if not canPlayerSpawn(ply, RPGM.Config.NPCSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnNPC(self, ply, type, wep)
end

function GM:PlayerSpawnVehicle(ply, model, name, tbl)
    if not canPlayerSpawn(ply, RPGM.Config.VehicleSpawnLevel) then return false end
    return self.Sandbox.PlayerSpawnVehicle(self, model, name, tbl)
end


function GM:PlayerSpawnedProp(ply, model, ent)
    self.Sandbox.PlayerSpawnedProp(self, ply, model, ent)
    if IsValid(ent) and ent.CPPISetOwner then ent:CPPISetOwner(ply) end
end

function GM:EntityRemoved(ent)
    self.Sandbox.EntityRemoved(self, ent)
end

function GM:CanProperty(ply, property, ent)
    if ent.CPPICanTool then
        return RPGM.Config.AllowedProperties[property] and ent:CPPICanTool(ply, "remover")
    end

    return RPGM.Config.AllowedProperties[property]
end