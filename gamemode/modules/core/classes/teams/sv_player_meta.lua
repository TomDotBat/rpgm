
local meta = FindMetaTable("Player")

function meta:getTeamClass()
    return RPGM.TeamTableID[self:Team()]
end

function meta:applyTeamVars()
    local playerClass = baseclass.Get(player_manager.GetPlayerClass(self))

    self:SetWalkSpeed(playerClass.WalkSpeed >= 0 and playerClass.WalkSpeed or RPGM.Config.WalkSpeed)
    self:SetRunSpeed(playerClass.RunSpeed >= 0 and playerClass.RunSpeed or RPGM.Config.RunSpeed)

    self:SetCrouchedWalkSpeed(playerClass.CrouchedWalkSpeed)
    self:SetDuckSpeed(playerClass.DuckSpeed)
    self:SetUnDuckSpeed(playerClass.UnDuckSpeed)
    self:SetJumpPower(playerClass.JumpPower)
    self:AllowFlashlight(playerClass.CanUseFlashlight)

    self:SetMaxHealth(playerClass.MaxHealth >= 0 and playerClass.MaxHealth or (tonumber(RPGM.Config.StartingHealth) or 100))
    self:SetArmor(playerClass.StartArmor)

    self:SetNoCollideWithTeammates(playerClass.TeammateNoCollide)
    self:SetAvoidPlayers(playerClass.AvoidPlayers)
end