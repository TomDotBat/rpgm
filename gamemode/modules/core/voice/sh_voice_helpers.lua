
local traceLine = util.TraceLine
local collisionGroupWorld = COLLISION_GROUP_WORLD
local maskSolidBrushOnly = MASK_SOLID_BRUSHONLY

local trResult = {}
local traceData = {
    output = trResult,
    collisiongroup = COLLISION_GROUP_WORLD,
    mask = MASK_SOLID_BRUSHONLY
}

function RPGM.IsInRoom(listenerPos, talkerPos, talker)
    traceData["start"] = talkerPos
    traceData["endpos"] = listenerPos
    traceData["filter"] = talker
    traceLine(traceData)

    return not trResult["HitWorld"]
end
