
local meta = FindMetaTable("Player")

function meta:rpNotify(text, type, len)
    RPGM.Notify(self, text, type, len)
end