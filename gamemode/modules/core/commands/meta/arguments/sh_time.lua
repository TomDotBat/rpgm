
function RPGM.Classes.TimeArgument(name, optional, default)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_time"
    tbl.DisplayType = "Time"

    function tbl:processString(str)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        local lastParseNo = false
        for k, v in ipairs(splitStr) do
            local text = table.concat(splitStr, " ", 1, k)

            if RPGM.Util.ParseTime(text) then
                lastParseNo = k
            end
        end

        if not lastParseNo then
            return self:getOptional(), str, self:getDefault()
        end

        local text = table.concat(splitStr, " ", 1, lastParseNo)
        return true, self:removeLeftChars(str, #text + 1), RPGM.Util.ParseTime(text)
    end

    return tbl
end