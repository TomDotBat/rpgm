
local meta = FindMetaTable("Player")

function meta:rpNotify(title, description, type, len, disableSound)
    if SERVER then
        RPGM.Notify(self, title, description, type, len)
        return
    end

    RPGM.Notify(title, description, type, len, disableSound)
end