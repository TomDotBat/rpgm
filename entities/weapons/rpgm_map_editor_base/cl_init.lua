
include("shared.lua")

function SWEP:Initialize()
end

function SWEP:IsShiftPressed()
    return input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if self:IsShiftPressed() then
        self:OnPrimaryShift(ply)
    else
        self:OnPrimary(ply)
    end
end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if self:IsShiftPressed() then
        self:OnSecondaryShift(ply)
    else
        self:OnSecondary(ply)
    end
end

function SWEP:Reload()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if self:IsShiftPressed() then
        self:OnReloadShift(ply)
    else
        self:OnReload(ply)
    end
end

function SWEP:DrawPoints(obj, color, obeyZ)
    for i, point in ipairs(obj) do
        local nextPoint = select(2, next(obj, i))
        if not nextPoint then nextPoint = obj[1] end

        render.DrawLine(point, nextPoint, color, obeyZ)
    end
end

function SWEP:DrawObjects(objs, color, obeyZ)
    for _, obj in ipairs(objs) do
        self:DrawPoints(obj, color, obeyZ)
    end
end

function SWEP:OnPrimary() end
function SWEP:OnPrimaryShift(ply)
    SWEP:OnPrimary(ply)
end

function SWEP:OnSecondary() end
function SWEP:OnSecondaryShift(ply)
    SWEP:OnSecondary(ply)
end

function SWEP:OnReload() end
function SWEP:OnReloadShift(ply)
    self:OnReload(ply)
end