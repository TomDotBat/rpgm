
include("shared.lua")

function SWEP:Deploy()
    return true
end

local grabbedCol = Color(42, 135, 212)
local ungrabbedCol = Color(212, 53, 42)
local connectionCol = Color(255, 255, 255)
function SWEP:DrawHUD()
    local holdPoint = self:GetHoldPoint()
    local grabPoint = self:GetWorldGrabPoint()

    cam.Start3D()
     if holdPoint and grabPoint then
        render.DrawLine(holdPoint, grabPoint, connectionCol, true)
     end

     self:DrawPoint(holdPoint, ungrabbedCol)
     self:DrawPoint(grabPoint, grabbedCol)
    cam.End3D()
end

function SWEP:DrawPoint(point, col)
    if not point then return end

    render.SetColorMaterial()
    render.DrawWireframeSphere(point, 1, 8, 8, col, true)
end