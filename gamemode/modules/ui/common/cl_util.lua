
local rad = math.rad
local sin, cos = math.sin, math.cos
function RPGM.DrawTexturedRectRotatedPoint(x, y, w, h, rot, x0, y0)
    local ang = rad(rot)
    local sinAng = sin(ang)

    surface.DrawTexturedRectRotated(
        x + y0 * sinAng - x0 * cos,
        y + y0 * cos(ang) + x0 * sinAng,
        w, h, rot
    )
end