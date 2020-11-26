
function RPGM.Notify(title, description, type, len, disableSound)
    RPGM.AddNotification(title, description, type or NOTIFY_GENERIC, len or 5)
    if isstring(title) and title ~= "" then
        RPGM.Log(title .. " - " .. description)
    else
        RPGM.Log(description)
    end

    if disableSound then return end
    surface.PlaySound("buttons/lightswitch2.wav")
end

net.Receive("RPGM.Notify", function()
    RPGM.Notify(net.ReadString(), net.ReadString(), net.ReadUInt(3), net.ReadUInt(32))
end)