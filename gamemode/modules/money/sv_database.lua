
local tableName = RPGM.Config.Database.TablePrefix .. "money"

hook.Add("RPGM.DBBuilder", "RPGM.BuildMoneyTable", function()
    MySQLite.queueQuery([[CREATE TABLE "]] .. tableName .. [[" (
	"steamid"	TEXT NOT NULL,
	"money"	INTEGER NOT NULL,
	PRIMARY KEY("steamid")
);]])
end)

function RPGM.GetMoneyFromDB(steamid, callback)
    RPGM.CheckType(steamid, "string")

    MySQLite.query(
        [[SELECT "money" FROM `]] .. tableName .. [[` WHERE "steamid"=']] .. steamid .. [[';]],
        function(data)
            if data then
                local row = data[1]
                if row and row.money and row.money > 0 then
                    if callback then callback(row.money) end
                    return
                end
            end

            RPGM.SetMoneyInDB(steamid, RPGM.Config.StartingMoney)
            if callback then callback(RPGM.Config.StartingMoney) end
        end,
        function(err, sqlString)
            RPGM.LogError("Failed to get " .. steamid .. "'s' money from the DB with: " .. sqlString)
            RPGM.LogError(err)
        end
    )
end

function RPGM.SetMoneyInDB(steamid, amount, callback)
    RPGM.CheckType(steamid, "string")
    RPGM.CheckType(amount, "number")

    amount = tostring(amount)

    local query = [[INSERT INTO "]] .. tableName
        .. [[" ("steamid", "money") VALUES(]] .. steamid .. [[,]] .. amount .. [[)]]

    if MySQLite.isMySQL() then
        query = query
            .. [[ ON DUPLICATE KEY UPDATE money = ]] .. amount .. [[;]]
    else
        query = query
            .. [[ ON CONFLICT(steamid) DO UPDATE SET money = ]] .. amount .. [[;]]
    end

    MySQLite.query(
        query,
        function(data)
            if callback then callback(data) end
        end,
        function(err, sqlString)
            RPGM.LogError("Failed to set " .. steamid .. "'s' Money in the DB with: " .. sqlString)
            RPGM.LogError(err)
        end
    )
end