
local extras = {}

function RPGM.Classes.GetExtras(classType)
    return extras[classType]
end

function RPGM.Classes.RegisterExtra(classType, varName, useAccessors, getter, setter)
    if not extras[classType] then extras[classType] = {} end

    if not useAccessors then
        extras[classType][varName] = true
        return
    end

    extras[classType][varName] = {getter, setter}
end

function RPGM.Classes.SetupExtras(class)
    local classType = class.__type
    local classExtras = extras[classType]
    if not classExtras then return end

    local extraTable = class:getExtras()

    for k, v in pairs(classExtras) do
        local accessorData = extras[classType]
        if isbool(accessorData) then continue end

        local accessorName = k:gsub("^%l", string.upper)

        if accessorData[1] then
            class["get" .. accessorName] = accessorData[1]
        else
            class["get" .. accessorName] = function(self) return extraTable[k] end
        end

        if accessorData[2] then
            class["set" .. accessorName] = accessorData[2]
        else
            class["set" .. accessorName] = function(self, val) extraTable[k] = val end
        end
    end
end