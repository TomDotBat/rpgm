
function RPGM.Classes.NumberArgument(name, optional, default, decimal, rangeMin, rangeMax)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_number"
    tbl.DisplayType = "Number"

    function tbl:getDecimal() return decimal end
    function tbl:getRange() return rangeMin, rangeMax end
    function tbl:isInRange(num)
        if rangeMin and num < rangeMin then return false end
        if rangeMax and num > rangeMax then return false end
        return true
    end

    function tbl:setDecimal(val)
        RPGM.Assert(isbool(val), "Number argument decimal state must be a boolean.")
        decimal = val
    end

    function tbl:setRange(min, max)
        RPGM.Assert(min == nil or isnumber(min), "Number argument range must be one or two numbers/nil values.")
        RPGM.Assert(max == nil or isnumber(max), "Number argument range must be one or two numbers/nil values.")

        rangeMin, rangeMax = min, max
    end

    function tbl:processString(str)
        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        local text = splitStr[1]
        local number = tonumber(text)
        if not tbl:isInRange(number) then return self:getOptional(), str, self:getDefault() end

        return true, self:removeLeftChars(str, #text + 1), decimal and math.Round(number) or number
    end

    tbl:setDecimal(decimal or false)
    tbl:setRange(rangeMin, rangeMax)

    return tbl
end