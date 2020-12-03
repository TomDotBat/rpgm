
local rad = math.rad
local sin, cos = math.sin, math.cos
function RPGM.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
    local ang = rad(rot)
    local sinAng, cosAng = sin(ang), cos(ang)

    surface.DrawTexturedRectRotated(
        x + y0 * sinAng - x0 * cosAng,
        y + y0 * cosAng + x0 * sinAng,
        w, h, rot
    )
end

local du = 0.5 / 32
local dv = 0.5 / 32
local u0, v0 = (0 - du) / (1 - 2 * du), (0 - dv) / (1 - 2 * dv)
local u1, v1 = (1 - du) / (1 - 2 * du), (1 - dv) / (1 - 2 * dv)
function RPGM.DrawSubpixelClippedMaterial(mat, x, y, w, h)
    surface.SetMaterial(mat)
    surface.DrawTexturedRectUV(x, y, w, h, u0, v0, u1, v1)
end