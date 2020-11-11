
local localPly = LocalPlayer()
function RPGM.Util.GetLocalPlayer()
    if localPly == NULL then localPly = LocalPlayer() end
    return localPly
end