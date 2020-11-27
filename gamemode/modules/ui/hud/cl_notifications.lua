
NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4
NOTIFY_MONEY = 5

local imgurIds = {
    [NOTIFY_GENERIC] = "rTZyn4X",
    [NOTIFY_ERROR] = "xbMow0M",
    [NOTIFY_UNDO] = "Qgdrzj9",
    [NOTIFY_HINT] = "Dc1ecKF",
    [NOTIFY_CLEANUP] = "HidXQBw",
    [NOTIFY_MONEY] = "5Y76zSd"
}

local typeNames = {
    [NOTIFY_GENERIC] = "Information",
    [NOTIFY_ERROR] = "Error",
    [NOTIFY_UNDO] = "Undone",
    [NOTIFY_HINT] = "Hint",
    [NOTIFY_CLEANUP] = "Cleanup",
    [NOTIFY_MONEY] = "Transaction"
}

local notifs = {}

function RPGM.AddNotification(title, description, type, length)
    notification.AddLegacy(description, type, length, title)
end

function notification.AddLegacy(text, type, length, title)
    RPGM.CheckType(text, "string")
    if not imgurIds[type] then return end
    RPGM.CheckType(length, "number")
    if title and title ~= "" then RPGM.CheckType(title, "string")
    else title = typeNames[type] end

    table.insert(notifs, {text, type, UnPredictedCurTime() + length, title or ""})
end

local function ignore() end
notification.AddProgress = ignore
notification.Kill = ignore

RPGM.RegisterFont("HUD.Notification.Title", "Open Sans SemiBold", 22, 500)
RPGM.RegisterFont("HUD.Notification.Body", "Open Sans", 19, 500)

RPGM.RegisterScaledConstant("HUD.Notifications.Width", 360)
RPGM.RegisterScaledConstant("HUD.Notifications.Spacing", 12)
RPGM.RegisterScaledConstant("HUD.Notifications.ContentSpacing", 12)
RPGM.RegisterScaledConstant("HUD.Notifications.IconSize", 24)

local fadeTime = .3
local getScaledConstant = RPGM.GetScaledConstant
local lerp = Lerp
local frameTime = FrameTime

hook.Add("RPGM.DrawHUD", "RPGM.DrawNotifications", function(scrW, scrH)
    local padding = getScaledConstant("HUD.Padding")
    local spacing = getScaledConstant("HUD.Notifications.Spacing")
    local notifW = getScaledConstant("HUD.Notifications.Width")
    local contentSpacing = getScaledConstant("HUD.Notifications.ContentSpacing")
    local iconSize = getScaledConstant("HUD.Notifications.IconSize")

    local notifX = scrW - padding - notifW
    local contentX = notifX + contentSpacing

    local titleCol = RPGM.Colors.PrimaryText
    local bodyCol = RPGM.Colors.SecondaryText

    local time = UnPredictedCurTime()
    local ft = frameTime() * 5
    local desiredY = padding

    for i = #notifs, 1, -1 do
        local notif = notifs[i]
        if not notif[5] then
            notif[5] = RPGM.WrapText(notif[1], notifW - contentSpacing * 2, "RPGM.HUD.Notification.Body")
            notif[6] = select(2, surface.GetTextSize(notif[5])) + contentSpacing * 3 + iconSize
        end

        if time >= notif[3] then
            surface.SetAlphaMultiplier(1 - (time - notif[3]) / fadeTime)
        end

        local notifY = lerp(ft, notif[7] or -notif[6], desiredY)
        notif[7] = notifY

        surface.SetDrawColor(RPGM.Colors.Background)
        surface.DrawRect(notifX, notifY, notifW, notif[6])

        local contentY = notifY + contentSpacing
        RPGM.DrawImgur(contentX, contentY, iconSize, iconSize, imgurIds[notif[2]], titleCol)

        RPGM.DrawSimpleText(notif[4], "RPGM.HUD.Notification.Title", contentX + iconSize + contentSpacing, contentY + iconSize * .5, titleCol, nil, TEXT_ALIGN_CENTER)
        RPGM.DrawText(notif[5], "RPGM.HUD.Notification.Body", contentX, contentY + iconSize + contentSpacing, bodyCol)

        surface.SetAlphaMultiplier(1)
        desiredY = desiredY + notif[6] + spacing
    end
end)

timer.Create("RPGM.CleanupNotifications", 3, 0, function()
    local time = UnPredictedCurTime()
    for i, notif in ipairs(notifs) do
        if time > (notif[3] + fadeTime) then
            table.remove(notifs, i)
            return
        end
    end
end)