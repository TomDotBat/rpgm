
local lang = gmodI18n.getAddon("rpgm")

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
            RPGM.MessagePlayer(ply, lang:getString("alreadyATeam", {teamName = teamName}), errorMessageCol)
            return
        end

        if ply:joinTeam(cmd) then
            RPGM.MessagePlayer(ply, lang:getString("teamNotFound", {teamName = teamName}), errorMessageCol)
        end
    end)
end)