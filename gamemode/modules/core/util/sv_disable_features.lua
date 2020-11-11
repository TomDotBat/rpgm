
function GM:PlayerSpray()
    return not RPGM.Config.EnableSprays
end

function GM:PlayerShouldTaunt(ply, actId)
    return false
end