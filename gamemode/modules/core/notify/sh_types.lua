
RPGM.NotificationTypes = RPGM.NotificationTypes or {
    [NOTIFY_GENERIC] = {"Information", "rTZyn4X"},
    [NOTIFY_ERROR] = {"Error", "xbMow0M"},
    [NOTIFY_UNDO] = {"Undone", "Qgdrzj9"},
    [NOTIFY_HINT] = {"Hint", "Dc1ecKF"},
    [NOTIFY_CLEANUP] = {"Cleanup", "HidXQBw"}
}

function RPGM.RegisterNotificationType(typeName, niceName, imgurId)
    local nextId = table.Count(RPGM.NotificationTypes) - 1
    _G["NOTIFY_" .. string.upper(typeName)] = nextId
    RPGM.NotificationTypes[nextId] = {niceName, imgurId}
end