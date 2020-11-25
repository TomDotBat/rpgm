
local errorMessageCol = Color(217, 54, 46)

hook.Add("RPGM.RegisterCommands", "RPGM.TeamCommand", function()
    RPGM.RegisterCommand("team", {"become", "job", "join"}, {
        RPGM.Classes.TextArgument("Team Name", false, nil, false, true)
    }, function(ply, data)
        local cmd = data[1]
        if not cmd then return end

        cmd = string.lower(cmd)

        local teamTbl = ply:getTeamClass()
        if teamTbl and cmd == teamTbl:getCommand() then
            RPGM.MessagePlayer(ply, "You are already a \"" .. cmd .. "\".", errorMessageCol)
            return
        end

        if ply:joinTeam(cmd) then
            RPGM.MessagePlayer(ply, "The team \"" .. cmd .. "\" couldn't be found.", errorMessageCol)
        end
    end)
end)