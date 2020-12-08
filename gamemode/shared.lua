
GM.Name = "RPGM: An RP Gamemode Base"
GM.Author = "Tom.bat"
GM.Email = "tom@tomdotbat.dev"
GM.Website = "https://tomdotbat.dev"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

local isRefresh
if istable(RPGM) then
    isRefresh = true
    if RPGM.LogWarning then
        RPGM.LogWarning("Lua refresh detected, the gamemode will now attempt to load changes without disruption.")
    end
end

RPGM = RPGM or {
    Config = {},
    Items = {},
    Classes = {},
    Util = {}
}

function RPGM.Util.LoadDirectory(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

    for k, v in pairs(folders) do
        RPGM.Util.LoadDirectory(dir .. "/" .. v)
    end

    for k, v in pairs(files) do
        local dirPath = dir .. "/" .. v

        if v:StartWith("cl_") then
            if SERVER then AddCSLuaFile(dirPath)
            else include(dirPath) end
        elseif v:StartWith("sh_") then
            if SERVER then AddCSLuaFile(dirPath) end
            include(dirPath)
        else
            if CLIENT then continue end
            include(dirPath)
        end
    end
end

local rootDir = GM.FolderName .. "/gamemode/"
RPGM.Util.LoadDirectory(rootDir .. "config/core")
RPGM.Util.LoadDirectory(rootDir .. "config/modules")
RPGM.Util.LoadDirectory(rootDir .. "libraries")
RPGM.Util.LoadDirectory(rootDir .. "modules")
RPGM.Util.LoadDirectory(rootDir .. "config/items")

hook.Run("RPGM.RegisterCommands")

RPGM.RegisterCommand("ooc", {"/"}, {
    RPGM.Classes.TextArgument("Message", false, nil, false, true)
}, function(data)
    PrintTable(data)
end)

RPGM.Log(
    "The gamemode successfully "
    .. (isRefresh and "auto-refreshed in " or "finished loading in ")
    .. (math.Round(os.clock() - RPGM.StartTime, 2)) .. " seconds."
)

RPGM.BootComplete = true

collectgarbage()