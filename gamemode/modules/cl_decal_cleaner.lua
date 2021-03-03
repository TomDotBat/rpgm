
if not RPGM.Config.EnableDecalCleaner then return end

timer.Create("RPGM.DecalCleaner", 120, 0, function()
    RunConsoleCommand("r_cleardecals")
end)