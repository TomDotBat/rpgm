
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

    local animSpeed = ft() * 3
    health = max(lerp(animSpeed, health, ply:Health()), 0)
    armor = lerp(animSpeed, armor, ply:Armor())
    money = lerp(animSpeed, money, ply:getMoney())

    maxHealth = max(maxHealth, health)
    maxArmor = max(maxArmor, armor)

    if armor < 1 then hideArmor = true
    else hideArmor = false end
end

gameevent.Listen("player_spawn")
hook.Add("player_spawn", "RPGM.ResetPlayerInfoStats", function(data)
    if data.userid ~= localPly:UserID() then return end
    maxHealth = 100
    maxArmor = 100
end)

RPGM.RegisterFont("HUD.PlayerInfo", "Open Sans SemiBold", 22, 500)
RPGM.RegisterFont("HUD.Wanted", "Open Sans Bold", 24, 500)

RPGM.RegisterScaledConstant("HUD.PlayerInfo.MinWidth", 270)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.RowHeight", 24)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.BarHeight", 10)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.WantedSpacing", 6)
RPGM.RegisterScaledConstant("HUD.PlayerInfo.SirenSize", 24)

local getScaledConstant = RPGM.GetScaledConstant
local backgroundCol = RPGM.Colors.Background
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

local animX = 0
local sin = math.sin
local curTime = UnPredictedCurTime
local callHook = hook.Call
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

    local boxY = scrH - padding - height
    local rowX = padding + contentPad - animX
    local baseRowWidth = width - contentPad * 2
    local rowWidth = baseRowWidth + contentOverflow

    if callHook("RPGM.ShouldDraw", nil, "PlayerInfo") == false then
        animX = lerp(ft() * 5, animX, padding * 2 + width + contentOverflow)
    else
        animX = lerp(ft() * 5, animX, 0)
    end

    surface.SetDrawColor(backgroundCol)
    surface.DrawRect(padding - animX, boxY, width + contentOverflow, height)

    local rowY = boxY + contentPad

    for i = 1, rowCount do
        rows[i](rowX, rowY, rowWidth, rowHeight, rowY + halfRowHeight, baseRowWidth)
        rowY = rowY + rowHeight + contentPad
    end

    if not wanted then return end

    local centerX = padding + width * .5 - animX
    local wantedY = boxY - getScaledConstant("HUD.PlayerInfo.WantedSpacing")
    local wantedW, wantedH = RPGM.DrawSimpleText("WANTED", "RPGM.HUD.Wanted", centerX, wantedY, primaryCol, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)

    local sirenSize = getScaledConstant("HUD.PlayerInfo.SirenSize")
    local sirenOffset = wantedW * .5 + sirenSize + contentPad
    wantedY = wantedY - wantedH * .5 - sirenSize * .5

    local time = curTime() * 5
    local sinTime = (sin(time) + 1) * .5
    for i = -1, 1, 2 do
        RPGM.DrawImgur(centerX + sirenOffset * i, wantedY, sirenSize, sirenSize, "dIjQAWu", RPGM.LerpColor(sinTime, healthCol, armorCol))
        sinTime = (sin(-time) + 1) * .5
        sirenOffset = sirenOffset - sirenSize
    end
end)