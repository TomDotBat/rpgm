
local takenNames, takenCmds = {}, {}

RPGM.TeamTable = RPGM.TeamTable or {}
RPGM.CategorisedTeamTable = RPGM.CategorisedTeamTable or {}
RPGM.TeamCounter = 0

function RPGM.AddTeam(data)
    if takenCmds[data.command] then
        return RPGM.LogError("Command already taken for team \"" .. (data.name or "Unknown") .. "\".")
    elseif takenNames[data.name] then
        return RPGM.LogError("Name already taken for team \"" .. (data.name or "Unknown") .. "\".")
    end

    takenCmds[data.command] = true
    takenCmds[data.name] = true

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
        data.extra or {},
        data.functions or {},
        color,
        data.description or "",
        data.weapons or {},
        data.limit or 0
    )

    RPGM.TeamTable[command] = teamTbl

    if not RPGM.CategorisedTeamTable[category] then
        RPGM.CategorisedTeamTable[category] = {}
    end

    RPGM.CategorisedTeamTable[category][command] = teamTbl

    RPGM.TeamCounter = RPGM.TeamCounter + 1
    team.SetUp(RPGM.TeamCounter, name, color)

    if istable(data.model) then
        for k, v in pairs(data.model) do util.PrecacheModel(v) end
    else
        util.PrecacheModel(data.model)
    end

    return teamTbl
end