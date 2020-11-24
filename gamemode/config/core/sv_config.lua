
--Movement Settings
RPGM.Config.WalkSpeed = 160
RPGM.Config.RunSpeed = 240

--Vitals Settings
RPGM.Config.StartingHealth = 100

--Spawning Settings
RPGM.Config.BabyGodEnabled = true
RPGM.Config.BabyGodTime = 5
RPGM.Config.RespawnAtSuicide = false

--Loadout Settings
RPGM.Config.BaseLoadout = {
    "keys",
    "weapon_physcannon",
    "gmod_camera",
    "gmod_tool",
    "weapon_physgun"
}

--Damage Settings
RPGM.Config.RealisticFallDamage = true
RPGM.Config.FallDamageDamper = 15
RPGM.Config.FallDamageAmount = 10
RPGM.Config.DisableSuicide = false

--Chat Settings
RPGM.Config.ChatRange = 250
RPGM.Config.ChatUseRadius = true

--Voice Settings
RPGM.Config.VoiceRange = 550
RPGM.Config.Voice3D = true
RPGM.Config.VoiceUseRadius = true
RPGM.Config.VoiceRoomOnly = true

--Q Menu Spawning Settings
--[[
    Permission Level Nos:
     < 0 Anyone
     1   Admin
     2   SuperAdmin
     > 2 No one
]]
RPGM.Config.PropSpawnLevel = 0
RPGM.Config.EffectSpawnLevel = 2
RPGM.Config.RagdollSpawnLevel = 2
RPGM.Config.WeaponSpawnLevel = 2
RPGM.Config.EntitySpawnLevel = 2
RPGM.Config.NPCSpawnLevel = 3
RPGM.Config.VehicleSpawnLevel = 2

--Prop Settings
RPGM.Config.AllowedProperties = {
    ["remover"] = true,
    ["ignite"] = false,
    ["extinguish"] = true,
    ["keepupright"] = true,
    ["gravity"] = true,
    ["collision"] = true,
    ["skin"] = true,
    ["bodygroups"] = true
}

--Misc Settings
RPGM.Config.EnableSprays = true
RPGM.Config.DisableCSSAlert = false
RPGM.Config.ForcePlayerModel = true
RPGM.Config.AnnounceTeamChange = true