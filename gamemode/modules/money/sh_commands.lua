
hook.Add("RPGM.RegisterCommands", "RPGM.MoneyCommands", function()
    RPGM.RegisterCommand("dropmoney", {"moneydrop", "dropcash", "cashdrop"}, {
        RPGM.Classes.NumberArgument("Amount", false, nil, false, 1, 2147483647)
    }, function(ply, data)
        ply:dropMoney(data[1])
    end)
end)