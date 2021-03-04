
local lang = gmodI18n.getAddon("rpgm")

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4

local icons = RPGM.Config.NotificationIcons or {}

RPGM.NotificationTypes = RPGM.NotificationTypes or {
    [NOTIFY_GENERIC] = {lang:getString("notifyTypeInformation"), icons[NOTIFY_GENERIC]},
    [NOTIFY_ERROR] = {lang:getString("notifyTypeError"), icons[NOTIFY_ERROR]},
    [NOTIFY_UNDO] = {lang:getString("notifyTypeUndone"), icons[NOTIFY_UNDO]},
    [NOTIFY_HINT] = {lang:getString("notifyTypeHint"), icons[NOTIFY_HINT]},
    [NOTIFY_CLEANUP] = {lang:getString("notifyTypeCleanup"), icons[NOTIFY_CLEANUP]}
}

function RPGM.RegisterNotificationType(typeName, niceName, imgurId)
    local nextId = table.Count(RPGM.NotificationTypes) - 1
    _G["NOTIFY_" .. string.upper(typeName)] = nextId
    RPGM.NotificationTypes[nextId] = {niceName, imgurId}
end

icons = nil