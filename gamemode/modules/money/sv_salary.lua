
RPGM.Classes.RegisterExtra("Team", "salary", true)

function RPGM.PayPlayerSalary(ply)
    local team = ply:getTeamClass()

    local salary = team:getSalary()
    if isfunction(salary) then salary = salary(ply) end

    local newSalary = hook.Run("RPGM.OverridePlayerSalary", ply, salary or 0)
    salary = newSalary or salary

    if not salary or salary < 1 then return end

    local cantRecieve, reason = hook.Run("RPGM.CanPlayerRecieveSalary", ply, salary)
    if cantRecieve then
        ply:rpNotify(reason, NOTIFY_ERROR)
        return
    end

    ply:addMoney(salary)
    ply:rpNotify("You have been paid your salary of " .. RPGM.formatMoney(salary) .. ".")
end

local getAllPlayers = player.GetAll
timer.Create("RPGM.SalaryTimer", RPGM.Config.SalaryTimer, 0, function()
    for _, ply in ipairs(getAllPlayers()) do
        RPGM.PayPlayerSalary(ply)
    end
end)