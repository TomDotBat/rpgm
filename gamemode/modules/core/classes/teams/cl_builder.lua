
RPGM.TeamTable = RPGM.TeamTable or {}
RPGM.TeamTableID = RPGM.TeamTableID or {}
RPGM.CategorisedTeamTable = RPGM.CategorisedTeamTable or {}

function RPGM.SetupTeams(teams)
    for _, team in ipairs(teams) do
        RPGM.SetupTeam(team)
    end

    RPGM.Log("Successfully registered " .. #teams .. " teams.")
end

function RPGM.SetupTeam(data)
    local id = data.id
    local name = data.name
    local category = data.category or "Other"
    local command = data.command
    local color = Color(data.color["r"], data.color["g"], data.color["b"], data.color["a"])

    local teamTbl = RPGM.Classes.Team(
        name,
        category,
        command,
        data.model,
        data.order or 0,
        data.extras or {},
        {},
        color,
        data.description or "",
        data.weapons or {},
        data.limit or 0
    )

    teamTbl.__id = id
    team.SetUp(id, name, color)

    if istable(data.model) then
        for k, v in pairs(data.model) do util.PrecacheModel(v) end
    else
        util.PrecacheModel(data.model)
    end

    RPGM.TeamTable[command] = teamTbl
    RPGM.TeamTableID[id] = teamTbl

    if not RPGM.CategorisedTeamTable[category] then
        RPGM.CategorisedTeamTable[category] = {}
    end

    RPGM.CategorisedTeamTable[category][command] = teamTbl

    return teamTbl, id
end

function RPGM.RemoveTeam(command)
    RPGM.Assert(command ~= RPGM.Config.DefaultTeam, "An attempt was made to delete the default team, action prevented.")

    local teamTbl = RPGM.TeamTable[command]
    if not teamTbl then return end

    takenNames[teamTbl:getName()] = nil

    local id = teamTbl.__id
    RPGM.TeamTable[command] = nil
    RPGM.CategorisedTeamTable[teamTbl:getCategory()][command] = nil

    if not id then return end
    RPGM.TeamTableID[id] = nil

    local teams = team.GetAllTeams()
    teams[id] = nil
end