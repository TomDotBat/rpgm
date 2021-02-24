
local defaultType = NOTIFY_GENERIC
local notificationSounds = RPGM.Config.NotificationSounds

function RPGM.Notify(title, description, type, len, disableSound)
    RPGM.AddNotification(title, description, type or defaultType, len or 5)
    if isstring(title) and title ~= "" then
        RPGM.Log(title .. " - " .. description)
    else
        RPGM.Log(description)
    end

    if disableSound then return end
    surface.PlaySound(notificationSounds[type] or notificationSounds[defaultType])
end

net.Receive("RPGM.Notify", function()
    RPGM.Notify(net.ReadString(), net.ReadString(), net.ReadUInt(3), net.ReadUInt(32))
end)
