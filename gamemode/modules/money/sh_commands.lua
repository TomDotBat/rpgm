
hook.Add("RPGM.RegisterCommands", "RPGM.MoneyCommands", function()
    RPGM.RegisterCommand("dropmoney", {"moneydrop", "dropcash", "cashdrop"}, {
        RPGM.Classes.NumberArgument("Amount", false, nil, false, 1, 2147483647)
    }, function(ply, data)
        ply:dropMoney(data[1])
    end)

    RPGM.RegisterCommand("givemoney", {"givemoeny", "give"}, {
        RPGM.Classes.NumberArgument("Amount", false, nil, false, 1, 2147483647)
    }, function(ply, data)
        local receiver = ply:GetEyeTrace().Entity
        if not IsValid(receiver) or receiver:GetPos():DistToSqr(ply:GetPos()) >= 22500 then
            RPGM.Notify(ply, lang:getString("cantGiveMoney"), lang:getString("notLookingAtMoneyReceiver"), NOTIFY_ERROR)
            return
        end

        local amount = data[1]
        ply:giveMoney(amount, receiver, function(success, reason)
            if success then
                local formattedMoney = RPGM.FormatMoney(amount)
                RPGM.Notify(receiver, lang:getString("receivedMoney"), lang:getString("playerGaveAmount", {giverName = ply:name(), givenAmount = formattedMoney}), NOTIFY_MONEY)
                RPGM.Notify(ply, lang:getString("gaveMoney"), lang:getString("gaveAmountTo", {giverName = receiver:name(), givenAmount = formattedMoney}))
            else
                RPGM.Notify(ply, lang:getString("cantGiveMoney"), reason, NOTIFY_ERROR)
            end
        end)
    end)
end)