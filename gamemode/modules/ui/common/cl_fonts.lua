
RPGM.RegisteredFonts = RPGM.RegisteredFonts or {}
local registeredFonts = RPGM.RegisteredFonts

do
    RPGM.SharedFonts = RPGM.SharedFonts or {}
    local sharedFonts = RPGM.SharedFonts

    function RPGM.RegisterFontUnscaled(name, font, size, weight)
        weight = weight or 500

        local identifier = font .. size .. ":" .. weight

        local fontName = "RPGM:" .. identifier
        registeredFonts[name] = fontName

        if sharedFonts[identifier] then return end
        sharedFonts[identifier] = true

        surface.CreateFont(fontName, {
            font = font,
            size = size,
            weight = weight,
            antialias = true
        })
    end
end

do
    RPGM.ScaledFonts = RPGM.ScaledFonts or {}
    local scaledFonts = RPGM.ScaledFonts

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
end

do
    local setFont = surface.SetFont
    local function setRPGMFont(font)
        local RPGMFont = registeredFonts[font]
        if RPGMFont then
            setFont(RPGMFont)
            return
        end

        setFont(font)
    end

    RPGM.SetFont = setRPGMFont

    local getTextSize = surface.GetTextSize
    function RPGM.GetTextSize(text, font)
        if font then setRPGMFont(font) end
        return getTextSize(text)
    end

    function RPGM.GetRealFont(font)
        return registeredFonts[font]
    end
end