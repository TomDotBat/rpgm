
RPGM.StartTime = os.clock()

include("shared.lua")

function GM:InitPostEntity()
    net.Start("RPGM.ClientReady")
    net.SendToServer()
end