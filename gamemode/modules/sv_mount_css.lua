
if RPGM.Config.DisableCSSAlert then return end
if IsMounted("cstrike") and util.IsValidModel("models/props/cs_assault/money.mdl") then return end

timer.Create("RPGM.MountCSSAlert", 10, 0, function()
    for k, ply in ipairs(player.GetAll()) do
        ply:PrintMessage(HUD_PRINTTALK, "WARNING! CSS could not be found on the server.")
    end
end)