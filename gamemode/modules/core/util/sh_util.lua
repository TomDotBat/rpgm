
function RPGM.Util.AccessorFunc(tbl, varName, functionName, forceType)
    tbl["get" .. functionName] = function(self) return self[varName] end

    if forceType == FORCE_STRING then
        tbl["set" .. functionName] = function(self, val) self[varName] = tostring(val) end
        return
    end

    if forceType == FORCE_NUMBER then
        tbl["set" .. functionName] = function(self, val) self[varName] = tonumber(val) end
        return
    end

    if forceType == FORCE_BOOL then
        tbl["set" .. functionName] = function(self, val) self[varName] = tobool(val) end
        return
    end

    tbl["set" .. functionName] = function(self, val) self[varName] = val end
end

function RPGM.Util.IsSteamID(str)
    return isstring(str) and str:match("^STEAM_[0-5]:[0-1]:[0-9]+$") ~= nil
end

function RPGM.Util.IsSteamID64(str)
    local len = #str
    return isstring(str) and str:sub(1, 7) == "7656119" and (len == 17 or len == 18)
end

do
    local times = {
        m = 1,
        h = 60,
        d = 1440,
        w = 10080,
        mo = 43800,
        y = 525600
    }

    function RPGM.Util.ParseTime(length)
        local time, found = tonumber(length), false
        if isnumber(length) then
            time, found = length, true
        elseif time then
            found = true
        else
            time = 0
            for t, u in length:gmatch("(%d+)(%a+)") do
                u = times[u]
                if u then
                    time = time + (u * t)
                    found = true
                end
            end
        end
        if not found then return false end
        return math.Clamp(time, 0, 31536000)
    end

    local times2 = {}
    for k, v in SortedPairsByValue(times, true) do
        table.insert(times2, k)
        table.insert(times2, v)
    end

    local floor = math.floor
    function RPGM.Util.ReverseParseTime(mins)
        if mins <= 0 then
            return "0"
        elseif mins <= 1 then
            return "1m"
        end

        local str = ""
        for i = 1, #times2, 2 do
            local n1, n2 = times2[i + 1]
            n2, mins = floor(mins / n1), mins % n1

            if n2 > 0 then
                if str ~= "" then
                    str = str .. " "
                end
                str = str .. n2 .. times2[i]
            end

            if mins == 0 then
                break
            end
        end
        return str
    end
end

do
    local times = {
        "year"; 525600,
        "month"; 43800,
        "week"; 10080,
        "day"; 1440,
        "hour"; 60,
        "minute"; 1
    }

    for i = 1, #times, 2 do
        times[i] = " " .. times[i]
    end

    local floor = math.floor
    function RPGM.Util.FormatTime(mins) -- Thanks to this guide https://stackoverflow.com/a/21323783
        if mins <= 0 then
            return "Indefinitely"
        elseif mins <= 1 then
            return "1 minute"
        end

        local str = ""
        for i = 1, #times, 2 do
            local n1, n2 = times[i + 1]
            n2, mins = floor(mins / n1), mins % n1

            if n2 > 0 then
                if str ~= "" then
                    if mins == 0 then
                        str = str .. " and "
                    else
                        str = str .. ", "
                    end
                end
                str = str .. n2 .. times[i]
                if n2 > 1 then
                    str = str .. "s"
                end
            end

            if mins == 0 then
                break
            end
        end
        return str
    end
end

local maps = {}
local ipairs = ipairs
function RPGM.Util.IsMap(name)
    if table.IsEmpty(maps) then
        for k, v in ipairs(file.Find("maps/*.bsp", "GAME")) do
            maps[k] = v:sub(1, -5):lower()
        end
    end

    name = name:lower()

    if name:sub(-4) == ".bsp" then
        name = name:sub(1, -5)
    end

    for i = 1, #maps do
        if maps[i] == name then
            return name
        end
    end

    return false
end

local insert = table.insert
local getAllPlayers = player.GetAll
function RPGM.Util.FindPlayersInSphere(pos, radius, plyList)
    radius = radius ^ 2

    local results = {}
    for _, ply in ipairs(plyList or getAllPlayers()) do
        if ply:GetPos():DistToSqr(pos) > radius then continue end
        insert(results, ply)
    end

    return results
end