
NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4

local icons = RPGM.Config.NotificationIcons

RPGM.NotificationTypes = RPGM.NotificationTypes or {
    [NOTIFY_GENERIC] = {"Information", icons[NOTIFY_GENERIC]},
    [NOTIFY_ERROR] = {"Error", icons[NOTIFY_ERROR]},
    [NOTIFY_UNDO] = {"Undone", icons[NOTIFY_UNDO]},
    [NOTIFY_HINT] = {"Hint", icons[NOTIFY_HINT]},
    [NOTIFY_CLEANUP] = {"Cleanup", icons[NOTIFY_CLEANUP]}
}

function RPGM.RegisterNotificationType(typeName, niceName, imgurId)
    local nextId = table.Count(RPGM.NotificationTypes) - 1
    _G["NOTIFY_" .. string.upper(typeName)] = nextId
    RPGM.NotificationTypes[nextId] = {niceName, imgurId}
end

icons = nil