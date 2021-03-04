
local ceil = math.ceil
local getTextSize = RPGM.GetTextSize
local setTextPos = surface.SetTextPos
local setTextColor = surface.SetTextColor
local drawText = surface.DrawText
function RPGM.DrawSimpleText(text, font, x, y, col, xAlign, yAlign)
    local w, h = getTextSize(text, font)

    if xAlign == 1 then
        x = x - w / 2
    elseif xAlign == 2 then
        x = x - w
    end

    if yAlign == 1 then
        y = y - h / 2
    elseif yAlign == 4 then
        y = y - h
    end

    setTextPos(ceil(x), ceil(y))
    setTextColor(col.r, col.g, col.b, col.a)
    drawText(text)

    return w, h
end

local drawSimpleText = RPGM.DrawSimpleText
local gmatch = string.gmatch
local find = string.find
local max = math.max
local select = select
function RPGM.DrawText(text, font, x, y, col, xAlign, yAlign)
    local curX = x
    local curY = y

    local lineHeight = select(2, getTextSize("\n", font))
    local tabWidth = 50

    for str in gmatch(text, "[^\n]*") do
        if #str > 0 then
            if find(str, "\t") then
                for tabs, str2 in gmatch(str, "(\t*)([^\t]*)") do
                    curX = ceil((curX + tabWidth * max(#tabs - 1, 0 )) / tabWidth) * tabWidth

                    if #str2 > 0 then
                        drawSimpleText(str2, font, curX, curY, col, xAlign)
                        curX = curX + getTextSize(str2)
                    end
                end
            else
                drawSimpleText(str, font, curX, curY, col, xAlign)
            end
        else
            curX = x
            curY = curY + lineHeight / 2
        end
    end
end

function RPGM.DrawShadowText(text, font, x, y, col, xAlign, yAlign, depth, shadow)
    shadow = shadow or 50

    for i = 1, depth do
        drawSimpleText(text, font, x + i, y + i, Color(0, 0, 0, i * shadow), xAlign, yAlign)
    end

    drawSimpleText(text, font, x, y, col, xAlign, yAlign)
end

local drawShadowText = RPGM.DrawShadowText
function RPGM.DrawDualText(title, subtitle, x, y, h)
    x = x or 0
    y = y or 0

    local tH = select(2, getTextSize(title[1], title[2]))
    local sH = select(2, getTextSize(subtitle[1], subtitle[2]))

    drawShadowText(title[1], title[2], x, y - sH / 2, title[3], title[4], 1, title[5], title[6])
    drawShadowText(subtitle[1], subtitle[2], x, y + tH / 2, subtitle[3], subtitle[4], 1, subtitle[5], subtitle[6])
end

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

local subString = string.sub
function RPGM.WrapText(text, width, font)
    local textWidth = getTextSize(text, font)

    if textWidth <= width then
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

    return text
end

local left = string.Left
function RPGM.EllipsesText(text, width, font)
    local textWidth = getTextSize(text, font)

    if textWidth <= width then
        return text
    end

    local infiniteLoopPrevention = 0 --Just in case we really fuck up

    repeat
        text = left(text, #text - 1)
        textWidth = getTextSize(text .. "...")

        infiniteLoopPrevention = infiniteLoopPrevention + 1
    until textWidth <= width or infiniteLoopPrevention > 10000

    text = text .. "..."

    return text
end
