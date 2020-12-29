
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local clamp = math.Clamp
function ENT:Initialize()
    self:SetModel(RPGM.Config.MoneyModel)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local oldSetAmount = self.SetAmount
    function self:SetAmount(amount)
        oldSetAmount(self, clamp(amount, 1, 2147483647))
    end

    local physObj = self:GetPhysicsObject()
    if not physObj:IsValid() then return end
    physObj:Wake()
end

function ENT:Use(ply)
    if self.RPGMMoneyUsed then return end

    local canUse, reason = hook.Call("RPGM.CanPickupMoney", nil, ply, self)
    if canUse == false then
        if reason then RPGM.Notify(ply, "Pick-Up Prevented", reason, NOTIFY_ERROR) end
        return
    end

    self.RPGMMoneyUsed = true
    local value = self:GetAmount()
    if not value then return end

    hook.Call("RPGM.PlayerPickedUpMoney", nil, ply, self, value)

    ply:addMoney(value)
    RPGM.Notify(ply, "Picked-Up Money", "You picked up " .. RPGM.FormatMoney(value) .. " from the floor.")
    self:Remove()
end

function ENT:StartTouch(ent)
    if ent:GetClass() ~= "rpgm_money" or self.RPGMMoneyUsed then return end

    ent.RPGMMoneyUsed = true
    timer.Remove("RPGM.RemoveMoney:" .. ent:EntIndex())
    ent:Remove()

    self:SetAmount(self:GetAmount() + ent:GetAmount())

    timer.Adjust("RPGM.RemoveMoney:" .. self:EntIndex(), RPGM.Config.MoneyAutoRemoveTime, 1, function()
        SafeRemoveEntity(self)
    end)
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)

    local dmgType = dmg:GetDamageType()
    if bit.band(dmgType, bit.bor(DMG_FALL, DMG_VEHICLE, DMG_DROWN, DMG_RADIATION, DMG_PHYSGUN)) > 0 then return end

    self.RPGMMoneyUsed = true
    self:Remove()
end