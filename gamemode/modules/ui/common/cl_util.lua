
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