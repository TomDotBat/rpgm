
function RPGM.JoinTeam(ply, cmd, force)
    local teamTbl = RPGM.TeamTable[cmd]
    if not teamTbl then return end

    if not force then
        local limit = teamTbl:getLimit(ply)
        if limit > 0 and team.NumPlayers(teamTbl.__id) >= limit then

            return
        end

        if not teamTbl:doCustomCheck(ply) then
            return
        end
    end

    ply:SetTeam(teamTbl.__id)
end