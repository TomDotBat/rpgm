
function RPGM.CallClassFunction(class, functionName, ...)
    if not class then return end

    local functions = class:getFunctions()
    if not (istable(functions) and functions[functionName]) then return end

    return functions[functionName](...)
end