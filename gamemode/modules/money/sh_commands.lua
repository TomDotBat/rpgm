
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
            RPGM.Notify(ply, "Can't Give Money", "You're not looking at someone who's close enough to receive money.", NOTIFY_ERROR)
            return
        end

        local amount = data[1]
        ply:giveMoney(amount, receiver, function(success, reason)
            if success then
                RPGM.Notify(receiver, "Received Money", ply:Name() .. " has gave you " .. RPGM.FormatMoney(amount) .. ".")
                RPGM.Notify(ply, "Gave Money", "You have given " .. RPGM.FormatMoney(amount) .. " to " .. receiver:Name() .. ".")
            else
                RPGM.Notify(ply, "Can't Give Money", reason, NOTIFY_ERROR)
            end
        end)
    end)
end)