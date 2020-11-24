
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

RPGM.InitializeDB()

function GM:Initialize()
    self.Sandbox.Initialize(self)
end

function GM:InitPostEntity()
    self.InitPostEntityCalled = true

    local physData = physenv.GetPerformanceSettings()
    physData.MaxVelocity = 2000
    physData.MaxAngularVelocity = 3636
    physenv.SetPerformanceSettings(physData)

    game.ConsoleCommand("sv_allowcslua 0\n")
    game.ConsoleCommand("physgun_DampingFactor 0.9\n")
    game.ConsoleCommand("sv_sticktoground 0\n")
    game.ConsoleCommand("sv_airaccelerate 1000\n")
    game.ConsoleCommand("sv_alltalk 0\n")
end

timer.Simple(0.1, function()
    if not GAMEMODE.InitPostEntityCalled then
        GAMEMODE:InitPostEntity()
    end
end)

util.AddNetworkString("RPGM.ClientReady")

local readyPlys = {}
net.Receive("RPGM.ClientReady", function(len, ply)
    if readyPlys[ply] then return end
    readyPlys[ply] = true

    hook.Call("RPGM.ClientReady", nil, ply)
end)

hook.Add("PlayerDisconnected", "RPGM.ClientReadyCleanup", function(ply)
    readyPlys[ply] = nil
end)