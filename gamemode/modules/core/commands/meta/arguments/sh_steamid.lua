
local function getReturnArgs(tbl, str, text, id64)
    if not tbl:getReturnPlayer() then
        return true, tbl:removeLeftChars(str, #text + 1), text
    end

    local ply = player.GetBySteamID64(text)
    if not ply then
        return tbl:getOptional(), str, tbl:getDefault()
    end

    return true, tbl:removeLeftChars(str, #text + 1), ply
end

function RPGM.Classes.SteamIDArgument(name, optional, default, returnPlayer)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_steamid"
    tbl.DisplayType = "SteamID"

    function tbl:getReturnPlayer() return allowSteamId end

    function tbl:setReturnPlayer(val)
        RPGM.Assert(isbool(val), "SteamID argument return player state must be a boolean.")
        returnPlayer = val
    end

    function tbl:processString(str)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        local text = splitStr[1]

        if RPGM.Util.IsSteamID(text) then
            return getReturnArgs(tbl, str, util.SteamIDTo64(text))
        elseif RPGM.Util.IsSteamID64(text) then
            return getReturnArgs(tbl, str, text)
        end

        return self:getOptional(), str, self:getDefault()
    end

    tbl:setReturnPlayer(returnPlayer)

    return tbl
end

RPGM.Util.PlayerSteamIDArg = RPGM.Classes.SteamIDArgument("INTERNAL", false, nil, true)