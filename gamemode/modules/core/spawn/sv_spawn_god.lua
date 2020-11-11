
function RPGM.SetBabyGod(ply, enabled)
    if not RPGM.Config.BabyGodEnabled then return end
    if not IsValid(ply) then return end

    if enabled then
        timer.Remove("RPGM.BabyGod:" .. ply:UserID())

        ply:GodEnable()
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
        ply:SetColor(Color(255, 255, 255, 100))

        timer.Create("RPGM.BabyGod:" .. ply:UserID(), RPGM.Config.BabyGodTime, 1, function()
            RPGM.SetBabyGod(ply, false)
        end)
    else
        ply:GodDisable()
        ply:SetRenderMode(RENDERMODE_NORMAL)
        ply:SetColor(Color(255, 255, 255, 255))
    end
end