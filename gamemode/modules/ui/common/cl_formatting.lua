
function RPGM.DateToString(date)
    if not date then return "now" end

    local dif = RPGM.GetServerTime() - date

    if dif < 60 then
        return "a moment ago"
    elseif dif < (60 * 60) then
        local mins = math.Round(dif / 60, 0)
        local str = mins .. " minute" .. (mins == 1 and "" or "s") .. " ago"

        return str
    elseif dif < (60 * 60) * 24 then
        return os.date("%H:%M", date)
    else
        return os.date("%d/%m/%Y", date)
    end

    return "?"
end