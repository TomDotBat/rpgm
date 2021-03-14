
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy()
    local owner = self:GetOwner()
    if not IsValid(owner) then return true end

    owner:DrawWorldModel(false)
    return true
end

function SWEP:GrabEntity()
    local grabbedPoint, grabbedEntity = self:GetGrabPoint()
    if not IsValid(grabbedEntity) then return end

    local physObj = grabbedEntity.GetPhysicsObject and grabbedEntity:GetPhysicsObject()
    if not IsValid(physObj) then return end

    self:SetGrabbedPoint(grabbedPoint)
    self:SetGrabbedEntity(grabbedEntity)

    self.GrabbedEntityInitialLinearDamping, self.GrabbedEntityInitialAngularDamping = physObj:GetDamping()

    --if physObj:GetMass() < 30 then
    --    physObj:SetDamping(10, 80)
    --else
    --    physObj:SetDamping(5, 200)
    --end
end

function SWEP:DropEntity()
    local grabbedEntity = self:GetGrabbedEntity()
    if IsValid(grabbedEntity) then
        local physObj = grabbedEntity:GetPhysicsObject()
        physObj:SetDamping(self.GrabbedEntityInitialLinearDamping or 0, self.GrabbedEntityInitialAngularDamping or 0)
    end

    self:SetGrabbedEntity(NULL)
end

function SWEP:Think()
    local grabbedEntity = self:GetGrabbedEntity()
    if not IsValid(grabbedEntity) then
        self:DropEntity()
        return
    end

    local holdPoint = self:GetHoldPoint()
    local grabPoint = self:GetWorldGrabPoint()
    if holdPoint:DistToSqr(grabPoint) > self.MaxDistanceApart then
        self:DropEntity()
        return
    end

    grabbedEntity:GetPhysicsObject():ApplyForceOffset((holdPoint - grabPoint) * 15, grabPoint)
end