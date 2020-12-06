
local tableName = RPGM.Config.Database.TablePrefix .. "players"

hook.Add("RPGM.DBBuilder", "RPGM.BuildPlayerTable", function()
    MySQLite.queueQuery([[CREATE TABLE IF NOT EXISTS "]] .. tableName .. [[" (
	steamid	    TEXT NOT NULL,
	name	    TEXT NOT NULL,
    steam_name	TEXT NOT NULL,
	PRIMARY KEY("steamid")
);]])
end)

function RPGM.SetPlayerNameInDB(steamid, name, steamName, callback)
    RPGM.CheckType(steamid, "string")
    RPGM.CheckType(name, "string")
    RPGM.CheckType(steamName, "string")

    name = MySQLite.SQLStr(name)
    steamName = MySQLite.SQLStr(steamName)

    local query = [[INSERT INTO `]] .. tableName
        .. [[` (steamid, name, steam_name) VALUES("]] .. steamid .. [[", "]] .. name .. [[", "]] .. steamName .. [[")]]

    if MySQLite.isMySQL() then
        query = query
            .. [[ ON DUPLICATE KEY UPDATE name = "]] .. name .. [[", steam_name = "]] .. steamName .. [[";]]
    else
        query = query
            .. [[ ON CONFLICT(steamid) DO UPDATE SET name = "]] .. name .. [[", steam_name = "]] .. steamName .. [[";]]
    end

    MySQLite.query(
        query,
        callback,
        function(err, sqlString)
            RPGM.LogError("Failed to set " .. name .. "'s' name in the DB with: " .. sqlString)
            RPGM.LogError(err)
        end
    )
end

hook.Add("PlayerInitialSpawn", "RPGM.InitialisePlayerData", function(ply)
    RPGM.SetPlayerNameInDB(ply:SteamID64(), ply:Nick(), ply.SteamName and ply:SteamName() or ply:Name())
end)