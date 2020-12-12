
local meta = FindMetaTable("Player")

meta.SteamName = meta.SteamName or meta.Name

function meta:Name()
    return self:getRPString("Nickname", self:SteamName())
end

meta.GetName = meta.Name
meta.getName = meta.Name
meta.Nick = meta.Name

if CLIENT then return end

function meta:setName(name, caller)
    RPGM.ChangeNickname(self, name, caller)
end

function meta:resetName(caller)
    RPGM.ResetNickname(caller, self:Name())
end