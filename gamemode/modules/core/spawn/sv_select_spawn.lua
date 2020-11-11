
local emptyCheckRadius = Vector(16, 16, 64)

function GM:PlayerSelectSpawn(ply)
    local spawn = self.Sandbox.PlayerSelectSpawn(self, ply)

    local spawnPos
    if IsValid(spawn) then
        spawnPos = spawn:GetPos()
    end

    if RPGM.Config.RespawnAtSuicide and ply.LastSuicidePos then
        return spawn, ply.LastSuicidePos
    end

    spawnPos = RPGM.Util.FindEmptyPos(spawnPos, {[ply] = true}, 600, 30, emptyCheckRadius)

    return spawn, spawnPos
end
