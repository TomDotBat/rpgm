
RPGM.Classes.RegisterExtra("team", "salary", true)

local tostring = tostring
local find = string.find
local abs = math.abs

local config = RPGM.Config

local function addCurrency(str)
    return config.CurrencyLeft and config.CurrencySymbol .. str or str .. config.CurrencySymbol
end

function RPGM.formatMoney(n)
    if not n then return addCurrency("0") end

    if n >= 1e14 then return addCurrency(tostring(n)) end
    if n <= -1e14 then return "-" .. addCurrency(tostring(abs(n))) end

    local negative = n < 0

    n = tostring(abs(n))
    local dp = find(n, "%.") or #n + 1

    for i = dp - 4, 1, -3 do
        n = n:sub(1, i) .. "," .. n:sub(i + 1)
    end

    if n[#n - 1] == "." then
        n = n .. "0"
    end

    return (negative and "-" or "") .. addCurrency(n)
end