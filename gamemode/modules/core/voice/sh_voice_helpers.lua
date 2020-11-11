
local traceLine = util.TraceLine
local traceData = {
    start = nil,
    endpos = nil,
    filter = nil
}

function RPGM.IsInRoom(listenerShootPos, talkerShootPos, talker)
    traceData.start = talkerShootPos
    traceData.endpos = listenerShootPos
    traceData.filter = talker

    return not traceLine(traceData).HitWorld
end