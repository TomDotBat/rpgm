
--https://github.com/FPtje/DarkRP/blob/211395e81fe6024335f04cba6e647e9a1e6849aa/gamemode/modules/base/sv_gamemode_functions.lua#L305

local voiceDistance = RPGM.Config.VoiceRange ^ 2
local voice3d = RPGM.Config.Voice3D
local useRadius = RPGM.Config.VoiceUseRadius
local roomOnly = RPGM.Config.VoiceRoomOnly
local whenDead = RPGM.Config.VoiceWhenDead
local gridSize = voiceDistance * 2 --Grid cell size is equal to the size of the diamater of player talking

local isInRoom = RPGM.IsInRoom
local getHumans = player.GetHumans
local ipairs = ipairs
local pairs = pairs
local insert = table.insert
local floor = math.floor --Caching floor as we will need to use it a lot

if not useRadius then --Voice radius check is off, don't run checks
    function GM:PlayerCanHearPlayersVoice(listener, talker)
        if not whenDead and not talker:Alive() then return false end
        return true, voice3d
    end

    return
end

local canHearWho = {}

for k, ply in pairs(getHumans()) do
    canHearWho[ply] = {}
end

hook.Add("PlayerDisconnect", "RPGM.CanHearPlayersVoice", function(ply)
    canHearWho[ply] = nil
end)

function GM:PlayerCanHearPlayersVoice(listener, talker)
    if not whenDead and not talker:Alive() then return false end
    return canHearWho[listener][talker] == true, voice3d
end

--Grid based position check
local grid

--Translate player to grid coordinates. The first table maps players to x
--coordinates, the second table maps players to y coordinates.
local plyToGrid = {
    {},
    {}
}

timer.Create("RPGM.CanHearPlayersVoice", RPGM.Config.VoiceCanHearCheckRate, 0, function()
    local players = getHumans()

    --Clear old values
    plyToGrid[1] = {}
    plyToGrid[2] = {}
    grid = {}

    local plyPos = {}
    local eyePos = {}

    --Get the grid position of every player O(N)
    for _, ply in ipairs(players) do
        eyePos[ply] = ply:EyePos()

        local pos = ply:GetPos()
        plyPos[ply] = pos

        local x = floor(pos.x / gridSize)
        local y = floor(pos.y / gridSize)

        local row = grid[x] or {}
        local cell = row[y] or {}

        insert(cell, ply)
        row[y] = cell
        grid[x] = row

        plyToGrid[1][ply] = x
        plyToGrid[2][ply] = y

        canHearWho[ply] = {}
    end

    --Check all neighbouring cells for every player.
    --We are only checking in 1 direction to avoid duplicate check of cells
    for _, ply1 in ipairs(players) do
        local gridX = plyToGrid[1][ply1]
        local gridY = plyToGrid[2][ply1]
        local ply1Pos = plyPos[ply1]
        local ply1EyePos = eyePos[ply1]

        for i = 0, 3 do
            local vOffset = 1 - ((i >= 3) and 1 or 0)
            local hOffset = -(i % 3-1)
            local x = gridX + hOffset
            local y = gridY + vOffset

            local row = grid[x]
            if not row then continue end

            local cell = row[y]
            if not cell then continue end

            for _, ply2 in ipairs(cell) do
                local canTalk = ply1Pos:DistToSqr(plyPos[ply2]) < voiceDistance and --Voice radius is on and the two are within hearing distance
                    (not roomOnly or isInRoom(ply1EyePos, eyePos[ply2], ply2)) --Dynamic voice is on and players are in the same room

                canHearWho[ply1][ply2] = canTalk and (whenDead or ply2:Alive())
                canHearWho[ply2][ply1] = canTalk and (whenDead or ply1:Alive()) --Take advantage of the symmetry
            end
        end
    end

    --Doing a pass-through inside every cell to compute the interactions inside of the cells.
    --Each grid check is O(N(N+1)/2) where N is the number of players inside the cell.
    for _, row in pairs(grid) do
        for _, cell in pairs(row) do
            local count = #cell

            for i = 1, count do
                local ply1 = cell[i]
                for j = i + 1, count do
                    local ply2 = cell[j]
                    local canTalk =
                        plyPos[ply1]:DistToSqr(plyPos[ply2]) < voiceDistance and --Voice radius is on and the two are within hearing distance
                            (not roomOnly or isInRoom(eyePos[ply1], eyePos[ply2], ply2)) --Dynamic voice is on and players are in the same room

                    canHearWho[ply1][ply2] = canTalk and (whenDead or ply2:Alive())
                    canHearWho[ply2][ply1] = canTalk and (whenDead or ply1:Alive()) --Take advantage of the symmetry
                end
            end
        end
    end
end)
