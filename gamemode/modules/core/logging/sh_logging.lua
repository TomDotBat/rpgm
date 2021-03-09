
local prefixCol = RPGM.Config.LogPrefixCol
local messageCol = RPGM.Config.LogMessageCol
local warningCol = RPGM.Config.LogWarningCol
local errorCol = RPGM.Config.LogErrorCol

function RPGM.Log(msg, prefixColOverride)
    MsgC(prefixColOverride or prefixCol, "[RPGM]: ", messageCol, msg .. "\n")
end

function RPGM.LogWarning(warningMsg)
    MsgC(prefixCol, "[RPGM - WARNING]: ", warningCol, warningMsg .. "\n")
end

function RPGM.LogError(errorMsg)
    MsgC(prefixCol, "[RPGM - ERROR]: ", errorCol, errorMsg .. "\n")
    debug.Trace()
end

function RPGM.Assert(expression, errorMsg)
    if not expression then RPGM.LogError(errorMsg) end
end

local type = type
function RPGM.CheckType(var, expectedType)
    RPGM.Assert(type(var) == expectedType, "Expected type \"" .. expectedType .. "\" from var.")
end