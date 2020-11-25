
function RPGM.Notify(text, type, len, disableSound)
    notification.AddLegacy(text, type or NOTIFY_GENERIC, len or 5)
    RPGM.Log(text)

    if disableSound then return end
    surface.PlaySound("buttons/lightswitch2.wav")
end

net.Receive("RPGM.Notify", function()
    RPGM.Notify(net.ReadString(), net.ReadUInt(3), net.ReadUInt(32))
end)