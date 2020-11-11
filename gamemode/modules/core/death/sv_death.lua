
function GM:DoPlayerDeath(ply, attacker, dmgInfo, ...)
    self.Sandbox.DoPlayerDeath(self, ply, attacker, dmgInfo, ...)
end

function GM:PlayerDeath(ply, weapon, killer)
    if weapon:IsVehicle() and weapon:GetDriver():IsPlayer() then killer = weapon:GetDriver() end

    if RPGM.Config.ShowKillFeed then
        self.Sandbox.PlayerDeath(self, ply, weapon, killer)
    end

    ply:Extinguish()
    ply:ExitVehicle()

    if ply == killer then ply.LastSuicidePos = ply:GetPos()
    else ply.LastSuicidePos = nil end
end