
local function hasSymbolPair(str, symbol)
    if not string.StartWith(symbol, str) then return false end
    return string.find(str, symbol, 2)
end

function RPGM.Classes.TextArgument(name, optional, default, singleWord, wholeString)
    local tbl = RPGM.Classes.Argument(name, optional, default)
    tbl.__type = "argument_text"
    tbl.DisplayType = "Text"

    function tbl:getSingleWord() return singleWord end
    function tbl:getWholeString() return wholeString end

    function tbl:setSingleWord(val)
        RPGM.Assert(isbool(val), "Text argument single word state must be a boolean.")
        singleWord = val
    end

    function tbl:setWholeString(val)
        RPGM.Assert(isbool(val), "Text argument whole string state must be a boolean.")
        wholeString = val
    end

    function tbl:processString(str)
        if wholeString then
            if #str < 1 then return self:getOptional(), str, self:getDefault() end
            return true, "", str
        end

        local splitStr = string.Split(str, " ")
        if #splitStr < 1 then return self:getOptional(), str, self:getDefault() end

        if singleWord then
            local word = splitStr[1]
            return true, self:removeLeftChars(str, #word + 1), word
        end

        local endPoint = hasSymbolPair(str, "\"") or hasSymbolPair(str, "'")
        if endPoint then
            local text = string.sub(str, 2, endPoint - 1)
            return true, self:removeLeftChars(str, #text + 1), text
        end

        local word = splitStr[1]
        return true, self:removeLeftChars(str, #word + 1), word
    end

    tbl:setSingleWord(singleWord or false)
    tbl:setWholeString(wholeString or false)

    return tbl
end