
SWEP.PrintName = "Hands"
SWEP.Author = "Tom.bat"
SWEP.Instructions = ""
SWEP.Category = "RPGM - Core"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize = .3
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = false

SWEP.Secondary.ClipSize = .3
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.UseHands = true

SWEP.GrabDistance = 80
SWEP.HoldDistance = 50
SWEP.MaxDistanceApart = 50 ^ 2

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:Holster()
    return true
end

function SWEP:PreDrawViewModel()
    return true
end

function SWEP:SetupDataTables()
    self:NetworkVar("Entity", 0, "GrabbedEntity")
    self:NetworkVar("Vector", 0, "GrabbedPoint")
end

local traceData = {}
function SWEP:GetHoldPoint()
    local owner = self:GetOwner()
    traceData["filter"] = owner
    traceData["start"] = owner:EyePos()
    traceData["endpos"] = traceData["start"] + owner:EyeAngles():Forward() * self.HoldDistance

    return util.TraceLine(traceData).HitPos
end

function SWEP:GetGrabPoint()
    local grabbedPoint = self:GetGrabbedPoint()
    if grabbedPoint then return grabbedPoint, self:GetGrabbedEntity() end

    local owner = self:GetOwner()
    traceData["filter"] = owner
    traceData["start"] = owner:EyePos()
    traceData["endpos"] = traceData["start"] + owner:EyeAngles():Forward() * self.GrabDistance

    local traceResult = util.TraceLine(traceData)
    if traceResult.HitWorld then return end

    local ent = traceResult.Entity
    if not IsValid(ent) then return end

    return ent:WorldToLocal(traceResult.HitPos), ent
end

function SWEP:GetWorldGrabPoint()
    local grabbedPoint = self:GetGrabbedPoint()
    if not grabbedPoint then return end

    local grabbedEntity = self:GetGrabbedEntity()
    if not IsValid(grabbedEntity) then return end

    return grabbedEntity:LocalToWorld(grabbedPoint)
end

function SWEP:PrimaryAttack()
    if CLIENT or not IsFirstTimePredicted() then return end
    self:GrabEntity()
end

function SWEP:SecondaryAttack()
    if CLIENT or not IsFirstTimePredicted() then return end
    self:DropEntity()
end

function SWEP:Reload()
    if not IsFirstTimePredicted() then return end
end