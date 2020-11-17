
function RPGM.Classes.PlayerArgument(name, optional, default, allowSteamId)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_number"
    tbl.DisplayType = "Player"

    function tbl:getAllowSteamId() return allowSteamId end

    function tbl:setAllowSteamId(val)
        RPGM.Assert(isbool(val), "Player argument allow SteamID state must be a boolean.")
        allowSteamId = val
    end

    function tbl:processString(str, caller)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        if allowSteamId then
            local success, nextStr, val = RPGM.Util.PlayerSteamIDArg:processString(str)
            if success then return success, nextStr, val end
        end

        local text = splitStr[1]
        if text == "^" then
            return true, self:removeLeftChars(str, 2), caller
        elseif text == "@" then
            local target = caller:GetEyeTrace().Entity
            if target and IsPlayer(target) and target != caller then
                return true, self:removeLeftChars(str, 2), target
            end
            return self:getOptional(), str, self:getDefault()
        end

        local playerList = player.GetAll()
        for k, v in ipairs(splitStr) do
            text = table.concat(splitStr, " ", 1, k)

            for _, target in ipairs(playerList) do
                if not IsValid(target) then continue end

                if string.find(string.lower(v:Nick()), text) then
                    return true, self:removeLeftChars(str, #text + 1), target
                end
            end
        end

        return self:getOptional(), str, self:getDefault()
    end

    tbl:setAllowSteamId(allowSteamId)

    return tbl
end