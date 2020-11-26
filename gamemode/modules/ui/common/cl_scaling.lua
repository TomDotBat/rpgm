
local scrh = ScrH
local max = math.max
function RPGM.Scale(value)
    return max(value * (scrh() / 1080), 1)
end

RPGM.HUDPadding = RPGM.Scale(30)

hook.Add("OnScreenSizeChanged", "RPGM.StoreScaledConstants", function()
    RPGM.HUDPadding = RPGM.Scale(30)
end)