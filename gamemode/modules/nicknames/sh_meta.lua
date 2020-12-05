
local meta = FindMetaTable("Player")

meta.SteamName = meta.SteamName or meta.Name

function meta:Name()
    return self:getNickname() or self:SteamName()
end

meta.GetName = meta.Name
meta.Nick = meta.Name