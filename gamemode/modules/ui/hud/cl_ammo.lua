
RPGM.RegisterFont("HUD.Ammo", "Open Sans SemiBold", 22, 500)

RPGM.RegisterScaledConstant("HUD.Ammo.IconSize", 24)

local localPly
local clip = 0
local reserve = 0

local isValid = IsValid
hook.Add("RPGM.ShouldDraw", "RPGM.DrawAmmo", function(elem)
    if elem ~= "Ammo" then return end
    local wep = localPly:GetActiveWeapon()
    if localPly:Health() < 1 or not isValid(wep) or wep:GetClass() == "weapon_physcannon" then return false end
end)

local animX = 0
local callHook = hook.Call
local getScaledConstant = RPGM.GetScaledConstant
local primaryCol = RPGM.Colors.PrimaryText
local lerp = Lerp
local ft = FrameTime
local max = math.max
hook.Add("RPGM.DrawHUD", "RPGM.DrawAmmo", function(scrW, scrH)
    localPly = RPGM.Util.GetLocalPlayer()
    if not localPly then return false end

    local padding = getScaledConstant("HUD.Padding")
    local iconSize = getScaledConstant("HUD.Ammo.IconSize")
    local contentPad = getScaledConstant("HUD.ContentPadding")

    local ammoText = clip .. "/" .. reserve
    local textW, textH = RPGM.GetTextSize(ammoText, "HUD.Ammo")

    local boxW, boxH = iconSize + textW + contentPad * 3, max(textH, iconSize) + contentPad * 2
    local boxX, boxY = scrW - padding - boxW, scrH - padding - boxH

    local wep = localPly:GetActiveWeapon()
    if isValid(wep) then
        clip = wep:Clip1()
        reserve = localPly:GetAmmoCount(wep:GetPrimaryAmmoType())
    end

    if clip < 0 or callHook("RPGM.ShouldDraw", nil, "Ammo") == false then
        animX = lerp(ft() * 8, animX, boxW + padding * 2)
    else
        animX = lerp(ft() * 8, animX, 0)
    end

    boxX = boxX + animX

    surface.SetDrawColor(RPGM.Colors.Background)
    surface.DrawRect(boxX, boxY, boxW, boxH)

    local iconX = boxX + contentPad
    RPGM.DrawImgur(iconX, boxY + boxH * .5 - iconSize * .5, iconSize, iconSize, "GRUdrxv", primaryCol)
    RPGM.DrawSimpleText(ammoText, "HUD.Ammo", iconX + contentPad + iconSize, boxY + boxH * .5, primaryCol, nil, TEXT_ALIGN_CENTER)
end)