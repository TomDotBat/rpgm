
local prefixCol = Color(52, 168, 235)
local messageCol = Color(255, 255, 255)
function RPGM.Log(msg, prefixColOverride)
    MsgC(prefixColOverride or prefixCol, "[RPGM]: ", messageCol, msg .. "\n")
end

local warningCol = Color(230, 131, 60)
function RPGM.LogWarning(warningMsg)
    MsgC(prefixCol, "[RPGM - WARNING]: ", warningCol, warningMsg .. "\n")
end

local errorCol = Color(230, 60, 60)
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