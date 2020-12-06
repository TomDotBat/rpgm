
local meta = FindMetaTable("Player")

meta.SteamName = meta.SteamName or meta.Name

function meta:Name()
    return self:getRPString("Nickname", nil) or self:SteamName()
end

meta.GetName = meta.Name
meta.Nick = meta.Name