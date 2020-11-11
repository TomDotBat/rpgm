
local getTextSize = surface.GetTextSize
local function charWrap(text, remainingWidth, maxWidth)
    local totalWidth = 0

    text = text:gsub(".", function(char)
        totalWidth = totalWidth + getTextSize(char)

        if totalWidth >= remainingWidth then
            totalWidth = getTextSize(char)
            remainingWidth = maxWidth
            return "\n" .. char
        end

        return char
    end)

    return text, totalWidth
end

local setFont = surface.SetFont
local subString = string.sub
local textWrapCache = {}
function RPGM.Util.WrapText(text, width, font)
    local chachedName = text .. width .. font
    if textWrapCache[chachedName] then return textWrapCache[chachedName] end

    setFont(font)
    local textWidth = getTextSize(text)

    if textWidth <= width then
        textWrapCache[chachedName] = text
        return text
    end

    local totalWidth = 0
    local spaceWidth = getTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
        local char = subString(word, 1, 1)
        if char == "\n" or char == "\t" then
            totalWidth = 0
        end

        local wordlen = getTextSize(word)
        totalWidth = totalWidth + wordlen

        if wordlen >= width then
            local splitWord, splitPoint = charWrap(word, width - (totalWidth - wordlen), width)
            totalWidth = splitPoint
            return splitWord
        elseif totalWidth < width then
            return word
        end

        if char == ' ' then
            totalWidth = wordlen - spaceWidth
            return '\n' .. subString(word, 2)
        end

        totalWidth = wordlen
        return '\n' .. word
    end)

    textWrapCache[chachedName] = text
    return text
end

local left = string.Left
local ellipsesTextCache = {}
function RPGM.Util.EllipsesText(text, width, font)
    local chachedName = text .. width .. font
    if ellipsesTextCache[chachedName] then return ellipsesTextCache[chachedName] end

    setFont(font)
    local textWidth = getTextSize(text)

    if textWidth <= width then
        ellipsesTextCache[chachedName] = text
        return text
    end

    local infiniteLoopPrevention = 0 --Just in case we really fuck up

    repeat
        text = left(text, #text - 1)
        textWidth = getTextSize(text .. "...")

        infiniteLoopPrevention = infiniteLoopPrevention + 1
    until textWidth <= width or infiniteLoopPrevention > 10000

    text = text .. "..."

    ellipsesTextCache[chachedName] = text
    return text
end