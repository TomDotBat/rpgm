
local errorMessageCol = Color(217, 54, 46)

hook.Add("RPGM.RegisterCommands", "RPGM.TeamCommand", function()
    RPGM.RegisterCommand("team", {"become", "job"}, {
        RPGM.Classes.TextArgument("Team Name", false, nil, false, true)
    }, function(ply, data)
        local cmd = data[1]
        if not cmd then return end

        if ply:joinTeam(cmd) then
            RPGM.MessagePlayer(ply, "The team \"" .. cmd .. "\" couldn't be found.", errorMessageCol)
        end
    end)
end)