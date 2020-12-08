
if not RPGM.GetDefaultTeam() then
    RPGM.AddTeam({
        name = "Citizen",
        category = "Citizens",
        command = "citizen",
        model = "models/player/gman_high.mdl",
        color = Color(255, 255, 255),
        extras = {
            salary = 40
        }
    })
end

RPGM.AddTeam({
    name = "Policeman",
    category = "Police",
    command = "policeman",
    model = "models/player/alyx.mdl",
    color = Color(0, 0, 0),
    extras = {
        salary = 80
    }
})