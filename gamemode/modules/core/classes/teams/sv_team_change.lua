
local lang = gmodI18n.getAddon("rpgm")

function RPGM.JoinTeam(ply, cmd, force)
    local teamTbl = RPGM.TeamTable[cmd]
    if not teamTbl then return true end

    if not force then
        local limit = teamTbl:getLimit(ply)
        if limit > 0 and team.NumPlayers(teamTbl.__id) >= limit then
            ply:rpNotify(lang:getString("noSlotsAvailable", {teamName = teamTbl:getName()}), NOTIFY_ERROR)
            return
        end

        local allowed, reason = teamTbl:doCustomCheck(ply)
        if not allowed then
            if reason then
                ply:rpNotify(reason, NOTIFY_ERROR)
                return
            end

            ply:rpNotify(lang:getString("teamRequirementsNotMet", {teamName = teamTbl:getName()}), NOTIFY_ERROR)
            return
        end
    end

    ply:SetTeam(teamTbl.__id)
end