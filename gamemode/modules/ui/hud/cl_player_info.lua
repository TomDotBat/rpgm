
local localPly
local name, job = "Tom.bat", "Citizen"
local health, armor, money = 0, 0, 0

local formattedMoney = ""

RPGM.RegisterFont("HUD.PlayerInfo", "Open Sans SemiBold", 22, 500)

RPGM.RegisterScaledConstant("HUD.PlayerInfo.MinWidth", 270)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.RowHeight", 24)

local getScaledConstant = RPGM.GetScaledConstant
local primaryCol
local contentPad

local rows = {}

rows[1] = function(x, y, w, h, centerY)
    RPGM.DrawImgur(x, y, h, h, "imgurId", primaryCol)
    RPGM.DrawSimpleText(name, "RPGM.HUD.PlayerInfo", x + h + contentPad, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)
    --surface.SetDrawColor(color_white)
    --surface.DrawRect(x, y, w, h)
end

rows[2] = function(x, y, w, h, centerY)
    RPGM.DrawImgur(x, y, h, h, "imgurId", primaryCol)
    local jobX = x + h + contentPad
    local jobW = RPGM.DrawSimpleText(job, "RPGM.HUD.PlayerInfo", jobX, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)

    local moneyX = jobX + jobW + contentPad
    RPGM.DrawImgur(moneyX, y, h, h, "imgurId", primaryCol)
    RPGM.DrawSimpleText(RPGM.FormatMoney(money), "RPGM.HUD.PlayerInfo", moneyX + h + contentPad, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)
    --surface.SetDrawColor(Color(255, 0, 0))
    --surface.DrawRect(x, y, w, h)
end

rows[3] = function(x, y, w, h, centerY)
end

rows[4] = function(x, y, w, h, centerY)
end

hook.Add("RPGM.DrawHUD", "RPGM.DrawPlayerInfo", function(scrW, scrH)
    local rowCount = #rows
    local padding = getScaledConstant("HUD.Padding")
    contentPad = getScaledConstant("HUD.ContentPadding")
    local rowHeight = getScaledConstant("HUD.PlayerInfo.RowHeight")
    local halfRowHeight = rowHeight * .5
    local height = (contentPad + rowHeight) * rowCount + contentPad

    local rowX, rowY = padding + contentPad, scrH - padding - height
    local rowWidth = getScaledConstant("HUD.PlayerInfo.MinWidth") - contentPad * 2

    primaryCol = RPGM.Colors.PrimaryText

    surface.SetDrawColor(RPGM.Colors.Background)
    surface.DrawRect(padding, rowY, getScaledConstant("HUD.PlayerInfo.MinWidth"), height)

    rowY = rowY + contentPad

    for i = 1, rowCount do
        rows[i](rowX, rowY, rowWidth, rowHeight, rowY + halfRowHeight)

        rowY = rowY + rowHeight + contentPad
    end
end)