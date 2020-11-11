
function RPGM.Util.AccessorFunc(tbl, varName, functionName, forceType)
    tbl["get" .. functionName] = function(self) return self[varName] end

    if forceType == FORCE_STRING then
        tbl["set" .. name] = function(self, val) self[varName] = tostring(val) end
        return
    end

    if forceType == FORCE_NUMBER then
        tbl["set" .. functionName] = function(self, val) self[varName] = tonumber(val) end
        return
    end

    if forceType == FORCE_BOOL then
        tbl["set" .. functionName] = function(self, val) self[varName] = tobool(val) end
        return
    end

    tbl["set" .. functionName] = function(self, val) self[varName] = val end
end