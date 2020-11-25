
util.AddNetworkString("RPGM.Notify")

function RPGM.Notify(ply, text, type, len)
    net.Start("RPGM.Notify")
     net.WriteString(text)
     net.WriteUInt(type or NOTIFY_GENERIC, 3)
     net.WriteUInt(len or 5, 32)
    net.Send(ply)
end

NOTIFY_GENERIC = 0
NOTIFY_ERROR = 1
NOTIFY_UNDO = 2
NOTIFY_HINT = 3
NOTIFY_CLEANUP = 4