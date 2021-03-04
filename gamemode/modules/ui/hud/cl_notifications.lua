
local notifs = {}

function RPGM.AddNotification(title, description, type, length)
    notification.AddLegacy(description, type, length, title)
end

local notificationTypes = RPGM.NotificationTypes
function notification.AddLegacy(text, type, length, title)
    RPGM.CheckType(text, "string")
    if not notificationTypes[type] then return end
    RPGM.CheckType(length, "number")
    if title and title ~= "" then RPGM.CheckType(title, "string")
    else title = notificationTypes[type][1] end

    table.insert(notifs, {text, notificationTypes[type][2], UnPredictedCurTime() + length, title or ""})
end

local function ignore() end
notification.AddProgress = ignore
notification.Kill = ignore

RPGM.RegisterFont("HUD.Notification.Title", "Open Sans SemiBold", 22, 500)
RPGM.RegisterFont("HUD.Notification.Body", "Open Sans", 19, 500)

RPGM.RegisterScaledConstant("HUD.Notifications.Width", 360)
RPGM.RegisterScaledConstant("HUD.Notifications.Spacing", 12)
RPGM.RegisterScaledConstant("HUD.Notifications.IconSize", 24)

local backgroundCol = RPGM.Colors.Background
local titleCol = RPGM.Colors.PrimaryText
local bodyCol = RPGM.Colors.SecondaryText

local fadeTime = .3
local getScaledConstant = RPGM.GetScaledConstant
local lerp = Lerp
local frameTime = FrameTime

local function cleanupDeadNotifs(deadNotifs)
    table.remove(notifs, deadNotifs[1])
    table.remove(deadNotifs, 1)

    for i, index in ipairs(deadNotifs) do
        deadNotifs[i] = index - 1
    end

    if table.IsEmpty(deadNotifs) then return end
    cleanupDeadNotifs(deadNotifs)
end

hook.Add("RPGM.DrawHUD", "RPGM.DrawNotifications", function(scrW, scrH)
    local padding = getScaledConstant("HUD.Padding")
    local contentPad = getScaledConstant("HUD.ContentPadding")
    local spacing = getScaledConstant("HUD.Notifications.Spacing")
    local notifW = getScaledConstant("HUD.Notifications.Width")
    local iconSize = getScaledConstant("HUD.Notifications.IconSize")

    local notifX = scrW - padding - notifW
    local contentX = notifX + contentPad

    local deadNotifs = {}

    local time = UnPredictedCurTime()
    local ft = frameTime() * 5
    local desiredY = padding

    for i = #notifs, 1, -1 do
        local notif = notifs[i]
        if not notif[5] then
            notif[5] = RPGM.WrapText(notif[1], notifW - contentPad * 2, "HUD.Notification.Body")
            notif[6] = select(2, RPGM.GetTextSize(notif[5])) + contentPad * 3 + iconSize
        end

        if time >= notif[3] then
            local alpha = 1 - (time - notif[3]) / fadeTime
            surface.SetAlphaMultiplier(alpha)
            if alpha <= 0 then
                table.insert(deadNotifs, i)
            end
        end

        local notifY = lerp(ft, notif[7] or -notif[6], desiredY)
        notif[7] = notifY

        surface.SetDrawColor(backgroundCol)
        surface.DrawRect(notifX, notifY, notifW, notif[6])

        local contentY = notifY + contentPad
        RPGM.DrawImgur(contentX, contentY, iconSize, iconSize, notif[2], titleCol)

        RPGM.DrawSimpleText(notif[4], "HUD.Notification.Title", contentX + iconSize + contentPad, contentY + iconSize * .5, titleCol, nil, TEXT_ALIGN_CENTER)
        RPGM.DrawText(notif[5], "HUD.Notification.Body", contentX, contentY + iconSize + contentPad, bodyCol)

        surface.SetAlphaMultiplier(1)
        desiredY = desiredY + notif[6] + spacing
    end

    if table.IsEmpty(deadNotifs) then return end
    cleanupDeadNotifs(deadNotifs)
end)