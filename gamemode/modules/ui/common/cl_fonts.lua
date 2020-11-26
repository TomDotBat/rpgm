
function RPGM.RegisterFontUnscaled(name, font, size, weight)
    surface.CreateFont("RPGM." .. name, {
        font = font,
        size = size,
        weight = weight or 500,
        antialias = true
    })
end

local scaledFonts = {}

function RPGM.RegisterFont(name, font, size, weight)
    scaledFonts[name] = {
        font = font,
        size = size,
        weight = weight
    }

    RPGM.RegisterFontUnscaled(name, font, RPGM.Scale(size), weight)
end

hook.Add("OnScreenSizeChanged", "RPGM.ReRegisterFonts", function()
    for k,v in pairs(scaledFonts) do
        RPGM.RegisterFont(k, v.font, v.size, v.weight)
    end
end)