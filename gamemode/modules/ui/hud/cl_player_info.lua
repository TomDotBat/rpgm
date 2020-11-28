
local localPly
local name, team = "", ""
local health, armor, money = 0, 0, 0
local maxHealth, maxArmor = 100, 100
local hideArmor

local max = math.max
local lerp = Lerp
local ft = FrameTime
local function updateStats(ply)
    name = ply:Name()
    team = ply:getTeamName()

    local animSpeed = ft() * 2
    health = max(lerp(animSpeed, health, ply:Health()), 0)
    armor = lerp(animSpeed, armor, ply:Armor())
    money = lerp(animSpeed, money, ply:getMoney())

    if armor < 1 then hideArmor = true
    else hideArmor = false end
end

RPGM.RegisterFont("HUD.PlayerInfo", "Open Sans SemiBold", 22, 500)

RPGM.RegisterScaledConstant("HUD.PlayerInfo.MinWidth", 270)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.RowHeight", 24)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.BarHeight", 10)

local getScaledConstant = RPGM.GetScaledConstant
local primaryCol = RPGM.Colors.PrimaryText
local healthCol = RPGM.Colors.Negative
local armorCol = RPGM.Colors.Primary
local healthBgCol = RPGM.OffsetColor(healthCol, -45)
local armorBgCol = RPGM.OffsetColor(armorCol, -45)
local contentOverflow = 0
local contentPad
local barHeight

local rows = {}

rows[1] = function(x, y, w, h, centerY, baseW)
    RPGM.DrawImgur(x, y, h, h, "9dOCGhN", primaryCol)

    local nameOffset = h + contentPad
    local nameW = RPGM.DrawSimpleText(name, "RPGM.HUD.PlayerInfo", x + nameOffset, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)

    contentOverflow = (nameOffset + nameW) - baseW
end

local round = math.Round
rows[2] = function(x, y, w, h, centerY, baseW)
    RPGM.DrawImgur(x, y, h, h, "wcd8zwk", primaryCol)
    local teamX = x + h + contentPad
    local teamW = RPGM.DrawSimpleText(team, "RPGM.HUD.PlayerInfo", teamX, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)

    local moneyX = teamX + teamW + contentPad
    RPGM.DrawImgur(moneyX, y, h, h, "1PGuA4X", primaryCol)

    moneyX = moneyX + h + contentPad
    local moneyW = RPGM.DrawSimpleText(RPGM.FormatMoney(round(money)), "RPGM.HUD.PlayerInfo", moneyX, centerY, primaryCol, nil, TEXT_ALIGN_CENTER)

    contentOverflow = max((moneyX + moneyW - x) - baseW, contentOverflow)
end

local function drawProgress(x, y, w, h, prog, bgCol, fgCol)
    y = y + (h - barHeight) * .5

    surface.SetDrawColor(bgCol)
    surface.DrawRect(x, y, w, barHeight)
    surface.SetDrawColor(fgCol)
    surface.DrawRect(x, y, w * prog, barHeight)
end

rows[3] = function(x, y, w, h, centerY, baseW)
    RPGM.DrawImgur(x, y, h, h, "HUc3yHx", primaryCol)

    local barOffset = h + contentPad
    drawProgress(x + barOffset, y, w - barOffset, h, health / maxHealth, healthBgCol, healthCol)
end

rows[4] = function(x, y, w, h, centerY, baseW)
    RPGM.DrawImgur(x, y, h, h, "GwgAhqq", primaryCol)

    local barOffset = h + contentPad
    drawProgress(x + barOffset, y, w - barOffset, h, armor / maxArmor, armorBgCol, armorCol)
end

hook.Add("RPGM.DrawHUD", "RPGM.DrawPlayerInfo", function(scrW, scrH)
    localPly = RPGM.Util.GetLocalPlayer()
    if not localPly then return end
    updateStats(localPly)

    local rowCount = hideArmor and (#rows - 1) or #rows
    local padding = getScaledConstant("HUD.Padding")
    contentPad = getScaledConstant("HUD.ContentPadding")
    barHeight = getScaledConstant("HUD.PlayerInfo.BarHeight")
    local rowHeight = getScaledConstant("HUD.PlayerInfo.RowHeight")
    local halfRowHeight = rowHeight * .5
    local width = getScaledConstant("HUD.PlayerInfo.MinWidth")
    local height = (contentPad + rowHeight) * rowCount + contentPad

    contentOverflow = max(contentOverflow, 0)

    local rowX, rowY = padding + contentPad, scrH - padding - height
    local baseRowWidth = width - contentPad * 2
    local rowWidth = baseRowWidth + contentOverflow

    surface.SetDrawColor(RPGM.Colors.Background)
    surface.DrawRect(padding, rowY, width + contentOverflow, height)

    rowY = rowY + contentPad

    for i = 1, rowCount do
        rows[i](rowX, rowY, rowWidth, rowHeight, rowY + halfRowHeight, baseRowWidth)
        rowY = rowY + rowHeight + contentPad
    end
end)