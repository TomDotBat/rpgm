
local scrh = ScrH
local max = math.max
function RPGM.Scale(value)
    return max(value * (scrh() / 1080), 1)
end

local constants = {}
local scaledConstants = {}
function RPGM.RegisterScaledConstant(varName, size)
    constants[varName] = size
    scaledConstants[varName] = RPGM.Scale(size)
end

function RPGM.GetScaledConstant(varName)
    return scaledConstants[varName]
end

hook.Add("OnScreenSizeChanged", "RPGM.StoreScaledConstants", function()
    for varName, size in pairs(constants) do
        scaledConstants[varName] = RPGM.Scale(size)
    end
end)