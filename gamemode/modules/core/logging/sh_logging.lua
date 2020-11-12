
function RPGM.Log(msg)
    Msg("RPGM: " .. msg .. "\n")
end

function RPGM.LogWarning(warningMsg)
    Msg("[WARNING] RPGM: " .. warningMsg .. "\n")
end

function RPGM.LogError(errorMsg)
    Msg("[ERROR] RPGM: " .. errorMsg .. "\n")
    debug.Trace()
end

function RPGM.Assert(expression, errorMsg)
    assert(expression, "RPGM: " .. errorMsg)
end

function RPGM.CheckType(var, expectedType)
    RPGM.Assert(type(var) == expectedType, "RPGM: Expected type \"" .. expectedType .. "\" from var.")
end