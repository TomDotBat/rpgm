
function RPGM.Classes.PlayerArgument(name, optional, default, decimal, rangeMin, rangeMax)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_number"
    tbl.DisplayType = "Player"

    function tbl:processString(str)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

    end

    return tbl
end