
local defaultPrefixCol = Color(52, 168, 235)

function RPGM.Notify(ply, text, type, len, disableSound)
    notification.AddLegacy(text, type or NOTIFY_GENERIC, len or 5)
    MsgC(defaultPrefixCol, "[RPGM] ", color_white, text .. "\n")

    if disableSound then return end
    surface.PlaySound("buttons/lightswitch2.wav")
end

net.Receive("RPGM.Notify", function()
    RPGM.Notify(nil, net.ReadString(), net.ReadUInt(3), net.ReadUInt(32))
end)