
function RPGM.Classes.MapArgument(name, optional, default)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_map"
    tbl.DisplayType = "Map"

    function tbl:processString(str)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        local text = splitStr[1]
        if RPGM.Util.IsMap(text) then
            return true, self:removeLeftChars(str, #text + 1), text
        end

        return self:getOptional(), str, self:getDefault()
    end

    return tbl
end