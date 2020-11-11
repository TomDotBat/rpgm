
local fallDamageConvar
function GM:GetFallDamage(ply, fallSpeed)
    if not fallDamageConvar then fallDamageConvar = GetConVar("mp_falldamage") end

    if fallDamageConvar:GetBool() or RPGM.Config.RealisticFallDamage then
        return fallSpeed / RPGM.Config.FallDamageDamper
    else
        return RPGM.Config.FallDamageAmount
    end
end