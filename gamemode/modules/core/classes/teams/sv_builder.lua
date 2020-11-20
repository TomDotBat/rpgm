
local takenNames = {}

RPGM.TeamTable = RPGM.TeamTable or {}
RPGM.TeamTableID = RPGM.TeamTableID or {}
RPGM.CategorisedTeamTable = RPGM.CategorisedTeamTable or {}
RPGM.TeamCounter = 0

function RPGM.AddTeam(data)
    if RPGM.TeamTable[data.command] then
        return RPGM.LogError("Command already taken for team \"" .. (data.name or "Unknown") .. "\".")
    elseif takenNames[data.name] then
        return RPGM.LogError("Name already taken for team \"" .. (data.name or "Unknown") .. "\".")
    end

    local name = data.name
    local category = data.category or "Other"
    local command = data.command
    local color = data.color

    local teamTbl = RPGM.Classes.Team(
        name,
        category,
        command,
        data.model,
        data.order or 0,
        data.extras or {},
        data.functions or {},
        color,
        data.description or "",
        data.weapons or {},
        data.limit or 0
    )

    RPGM.TeamCounter = RPGM.TeamCounter + 1
    teamTbl.__id = RPGM.TeamCounter

    team.SetUp(RPGM.TeamCounter, name, color)

    if istable(data.model) then
        for k, v in pairs(data.model) do util.PrecacheModel(v) end
    else
        util.PrecacheModel(data.model)
    end

    takenNames[data.name] = true

    RPGM.TeamTable[command] = teamTbl
    RPGM.TeamTableID[RPGM.TeamCounter] = teamTbl

    if not RPGM.CategorisedTeamTable[category] then
        RPGM.CategorisedTeamTable[category] = {}
    end

    RPGM.CategorisedTeamTable[category][command] = teamTbl

    return teamTbl, RPGM.TeamCounter
end

function RPGM.RemoveTeam(command)
    RPGM.Assert(command ~= RPGM.Config.DefaultTeam, "An attempt was made to delete the default team, action prevented.")

    local teamTbl = RPGM.TeamTable[command]
    if not teamTbl then return end

    RPGM.SendTeamDelete(command, player.GetAll())

    takenNames[teamTbl:getName()] = nil

    local id = teamTbl.__id
    RPGM.TeamTable[command] = nil
    RPGM.CategorisedTeamTable[teamTbl:getCategory()][command] = nil

    if not id then return end
    RPGM.TeamTableID[id] = nil

    local defaultId = RPGM.GetDefaultTeamID()
    for _, ply in ipairs(team.GetPlayers(id)) do
        ply:SetTeam(defaultId)
    end

    local teams = team.GetAllTeams()
    teams[id] = nil
end

function RPGM.GetDefaultTeam()
    return RPGM.TeamTable[RPGM.Config.DefaultTeam]
end

function RPGM.GetDefaultTeamID()
    return RPGM.GetDefaultTeam().__id
end