
RPGM.Colors = {}

RPGM.Colors.Background = Color(33, 33, 33, 253)
RPGM.Colors.Header = Color(82, 87, 93, 90)

RPGM.Colors.PrimaryText = Color(255, 255, 255, 255)
RPGM.Colors.SecondaryText = Color(189, 189, 189, 255)

RPGM.Colors.Primary = Color(25, 118, 210)
RPGM.Colors.Negative = Color(183, 28, 28)

local clamp = math.Clamp
function RPGM.OffsetColor(col, amount)
    return Color(
        clamp(col.r + amount, 0, 255),
        clamp(col.g + amount, 0, 255),
        clamp(col.b + amount, 0, 255)
    )
end

local lerp = Lerp
local Color = Color
function RPGM.LerpColor(t, from, to)
    local newCol = Color(0, 0, 0)

    newCol.r = lerp(t, from.r, to.r)
    newCol.g = lerp(t, from.g, to.g)
    newCol.b = lerp(t, from.b, to.b)
    newCol.a = lerp(t, from.a, to.a)

    return newCol
end

function RPGM.CopyColor(col)
    return Color(col.r, col.g, col.b, col.a)
end

function RPGM.Hue2RGB(p, q, t)
    if t < 0 then t = t + 1 end
    if t > 1 then t = t - 1 end
    if t < 1 / 6 then return p + (q - p) * 6 * t end
    if t < 1 / 2 then return q end
    if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
    return p
end

local pi = math.pi
function RPGM.HSLToColor(h, s, l, a)
    local r, g, b
    local t = h / (2 * pi)

    if s == 0 then
        r, g, b = l, l, l
    else
        local q
        if l < 0.5 then
        q = l * (1 + s)
        else
        q = l + s - l * s
        end
        local p = 2 * l - q

        r = RPGM.Hue2RGB(p, q, t + 1 / 3)
        g = RPGM.Hue2RGB(p, q, t)
        b = RPGM.Hue2RGB(p, q, t - 1 / 3)
    end

    return Color(r * 255, g * 255, b * 255, (a or 1) * 255)
end

local getMin, getMax = math.min, math.max
function RPGM.ColorToHSL(col)
    local r = col.r / 255
    local g = col.g / 255
    local b = col.b / 255
    local max, min = getMax(r, g, b), getMin(r, g, b)
    b = max + min
    local h = b / 2
    if max == min then return 0, 0, h end
    local s, l = h, h
    local d = max - min
    s = l > .5 and d / (2 - b) or d / b
    if max == r then h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    return h * .16667, s, l
end

local format = string.format
function RPGM.DecToHex(d, zeros)
    return format("%0" .. (zeros or 2) .. "x", d)
end

function RPGM.RGBToHex(color)
    return "#" ..
        EliteUI.DecToHEX(getMax(getMin(color.r, 255), 0)) ..
        EliteUI.DecToHEX(getMax(getMin(color.g, 255), 0)) ..
        EliteUI.DecToHEX(getMax(getMin(color.b, 255), 0))
end

local tonumber = tonumber
function RPGM.HexToRGB(hex)
    hex = hex:gsub("#", "")

    if (#hex == 3) then
        local r = hex:sub(1, 1)
        local g = hex:sub(2, 2)
        local b = hex:sub(3, 3)

        return Color(
            tonumber("0x" .. r .. r),
            tonumber("0x" .. g .. g),
            tonumber("0x" .. b .. b)
        )
    end

    return Color(
        tonumber("0x" .. hex:sub(1, 2)),
        tonumber("0x" .. hex:sub(3, 4)),
        tonumber("0x" .. hex:sub(5, 6))
    )
end