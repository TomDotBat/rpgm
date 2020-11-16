
function RPGM.Classes.Argument(name, optional, default)
    local tbl = {}
    tbl.__type = "base_argument"
    tbl.DisplayType = "BASE"

    function tbl:getName() return name end
    function tbl:getOptional() return optional end
    function tbl:getDefault() return optional and default or nil end

    function tbl:setName(val)
        RPGM.Assert(isstring(val), "Argument name must be a string.")
        name = val
    end

    function tbl:setOptional(val)
        RPGM.Assert(isbool(val), "Argument optional state must be a boolean.")
        optional = val
    end

    function tbl:setDefault(val)
        default = val
    end

    function tbl:removeLeftChars(str, amount)
        return string.Right(str, #str - amount)
    end

    function tbl:processString(str)
        return false //Bool: Success, String: Rest of string, Any: Processed Value
    end

    tbl:setName(name)
    tbl:setOptional(optional)
    tbl:setDefault(default)

    return tbl
end