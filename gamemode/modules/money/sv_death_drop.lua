
hook.Add("PlayerDeath", "RPGM.DropMoneyOnDeath", function(ply, _, killer)
    local dropAmount = RPGM.Config.MoneyDroppedOnDeath
    if dropAmount < 1 then return end
    if ply == killer and not RPGM.Config.MoneyDroppedOnSuicide then return end

    ply:dropMoney(dropAmount)
end)