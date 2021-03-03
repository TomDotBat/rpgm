
local lang = gmodI18n.getAddon("rpgm")

function RPGM.PayPlayerSalary(ply)
    local team = ply:getTeamClass()

    local salary = team:getSalary()
    if isfunction(salary) then salary = salary(ply) end

    local newSalary = hook.Run("RPGM.OverridePlayerSalary", ply, salary or 0)
    salary = newSalary or salary

    if not salary or salary < 1 then return end

    local canReceive, reason = hook.Run("RPGM.CanPlayerReceiveSalary", ply, salary)
    if canReceive == false then
        ply:rpNotify(reason, NOTIFY_ERROR)
        return
    end

    ply:addMoney(salary)
    ply:rpNotify(lang:getString("salaryPayment"), lang:getString("salaryOfAmountPaid", {salaryAmount = RPGM.FormatMoney(salary)}), NOTIFY_MONEY)
end

local getAllPlayers = player.GetAll
timer.Create("RPGM.SalaryTimer", RPGM.Config.SalaryTimer, 0, function()
    for _, ply in ipairs(getAllPlayers()) do
        RPGM.PayPlayerSalary(ply)
    end
end)