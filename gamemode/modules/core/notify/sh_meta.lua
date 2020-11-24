
local meta = FindMetaTable("Player")

function meta:rpNotify(text, type, len, disableSound)
    if SERVER then
        RPGM.Notify(self, text, type, len)
    end

    RPGM.Notify(text, type, len, disableSound)
end