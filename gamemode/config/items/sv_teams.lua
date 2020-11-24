
if not RPGM.GetDefaultTeam() then
    RPGM.AddTeam({
        name = "Citizen",
        category = "Citizens",
        command = "citizen",
        model = "models/player/gman_high.mdl",
        color = Color(255, 255, 255)
    })
end
