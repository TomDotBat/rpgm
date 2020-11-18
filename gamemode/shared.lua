
GM.Name = "RPGM: An RP Gamemode Base"
GM.Author = "Tom.bat"
GM.Email = "tom@tomdotbat.dev"
GM.Website = "https://tomdotbat.dev"

DeriveGamemode("sandbox")
DEFINE_BASECLASS("gamemode_sandbox")

GM.Sandbox = BaseClass

RPGM = RPGM or {
    Config = {},
    Items = {},
    Classes = {},
    Util = {}
}

function RPGM.Util.LoadDirectory(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

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

    for k, v in pairs(folders) do
        RPGM.Util.LoadDirectory(dir .. "/" .. v)
    end
end

local rootDir = GM.FolderName .. "/gamemode/"
RPGM.Util.LoadDirectory(rootDir .. "config")
RPGM.Util.LoadDirectory(rootDir .. "libraries")
RPGM.Util.LoadDirectory(rootDir .. "modules")

collectgarbage()