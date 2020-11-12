
if not RPGM.Config.EnableDecalCleaner then return end

local function clearDecals()
    RunConsoleCommand("r_cleardecals")
end

timer.Create("RPGM.DecalCleaner", 120, 0, clearDecals)