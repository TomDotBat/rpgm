
function RPGM.InitializeDB()
    MySQLite.initialize({
        EnableMySQL = RPGM.Config.Database.EnableMySQL,
        Host        = RPGM.Config.Database.Host,
        Username    = RPGM.Config.Database.Username,
        Password    = RPGM.Config.Database.Password,
        Database_name = RPGM.Config.Database.Database,
        Preferred_module = "mysqloo",
        MultiStatements = false
    })

    local isMySQL = MySQLite.isMySQL()
    local autoIncrement = isMySQL and "AUTO_INCREMENT" or "AUTOINCREMENT"
    local tablePrefix = RPGM.Config.Database.TablePrefix

    MySQLite.begin()

    MySQLite.queueQuery("CREATE TABLE IF NOT EXISTS `" .. tablePrefix .. "version` (version INTEGER NOT NULL PRIMARY KEY);")

    MySQLite.queueQuery("SELECT MAX(version) AS version FROM `" .. tablePrefix .. "version`;", function(data)
        RPGM.DBVersion = data and data[1] and tonumber(data[1].version) or 1
    end)

    MySQLite.queueQuery("REPLACE INTO `" .. tablePrefix .. "version` VALUES(1);")

    hook.Call("RPGM.DBBuilder", GM or GAMEMODE, autoIncrement)

    MySQLite.commit(function()
        hook.Call("RPGM.DBInitialized", GM or GAMEMODE, RPGM.DBVersion, isMySQL, tablePrefix)
    end)
end