
if RPGM.Config.DisableCSSAlert then return end
if IsMounted("cstrike") and util.IsValidModel("models/props/cs_assault/money.mdl") then return end

local lang = gmodI18n.getAddon("rpgm")
timer.Create("RPGM.MountCSSAlert", 10, 0, function()
    for k, ply in ipairs(player.GetAll()) do
        ply:PrintMessage(HUD_PRINTTALK, lang:getString("cssMountAlert"))
    end
end)