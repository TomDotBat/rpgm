
local localPly = LocalPlayer()
function RPGM.Util.GetLocalPlayer()
    if localPly == NULL then localPly = LocalPlayer() end
    return localPly
end

local scrW, scrH = ScrW(), ScrH()
hook.Add("OnScreenSizeChanged", "RPGM.StoreResolution", function()
    scrW, scrH = ScrW(), ScrH()
end)

local callHook = hook.Call
function GM:HUDPaint()
    callHook("RPGM.DrawHUD", nil, scrW, scrH, localPly)
end