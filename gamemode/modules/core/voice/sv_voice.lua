

local voiceDistance = RPGM.Config.VoiceRange ^ 2
local voice3d = RPGM.Config.Voice3D
local useRadius = RPGM.Config.VoiceUseRadius
local roomOnly = RPGM.Config.VoiceRoomOnly
local whenDead = RPGM.Config.VoiceWhenDead

local isInRoom = RPGM.IsInRoom
local getHumans = player.GetHumans
local ipairs = ipairs

local canHearWho = {}

for k, ply in pairs(getHumans()) do
    canHearWho[ply] = {}
end

local function findNearbySpeakers(listener)
    if not IsValid(listener) then return end
    if listener:IsBot() then return end

    canHearWho[listener] = canHearWho[listener] or {}

    local listenerShootPos = listener:GetShootPos()

    for _, talker in ipairs(getHumans()) do
        local talkerShootPos = talker:GetShootPos()

        canHearWho[listener][talker] = not useRadius or -- Voiceradius is off, everyone can hear everyone
            (listenerShootPos:DistToSqr(talkerShootPos) < voiceDistance and -- voiceradius is on and the two are within hearing distance
            (not roomOnly or isInRoom(listenerShootPos, talkerShootPos, talker))) -- Dynamic voice is on and players are in the same room
    end
end

hook.Add("PlayerInitialSpawn", "RPGM.CanHearVoice", function(ply)
    if ply:IsBot() then return end

    findNearbySpeakers(ply)

    timer.Create("RPGM.CanHearVoice:" .. ply:UserID(), 0.5, 0, function()
        findNearbySpeakers(ply)
    end)
end)

hook.Add("PlayerDisconnected", "RPGM.CanHearVoice", function(ply)
    if ply:IsBot() then return end

    canHearWho[ply] = nil

    for _, v in ipairs(getHumans()) do
        if not canHearWho[v] then continue end
        canHearWho[v][ply] = nil
    end

    timer.Remove("RPGM.CanHearVoice:" .. ply:UserID())
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if not whenDead and not talker:Alive() then return false end

    return canHearWho[listener][talker], voice3d
end
