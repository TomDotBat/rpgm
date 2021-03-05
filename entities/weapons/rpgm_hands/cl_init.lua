
include("shared.lua")

function SWEP:Initialize()
end

function SWEP:IsShiftPressed()
    return input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_RSHIFT)
end

function SWEP:IsControlPressed()
    return input.IsKeyDown(KEY_LCONTROL) or input.IsKeyDown(KEY_RCONTROL)
end

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

end

function SWEP:Reload()
    if not IsFirstTimePredicted() then return end

    local ply = self:GetOwner()
    if not IsValid(ply) then return end

end