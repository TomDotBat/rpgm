
local meta = FindMetaTable("Player")

meta.SteamName = meta.SteamName or meta.Name

function meta:Name()
    local nick = self:getRPString("Nickname", self:SteamName())
    return nick == "" and self:SteamName() or nick
end

meta.name = meta.Name
meta.GetName = meta.Name
meta.getName = meta.Name
meta.Nick = meta.Name
meta.nick = meta.Name

if CLIENT then return end

function meta:setName(name, caller)
    RPGM.ChangeNickname(self, name, caller)
end

function meta:resetName(caller)
    RPGM.ResetNickname(caller, self:Name())
end