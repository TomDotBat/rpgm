
local PANEL = {}

local localPly
function PANEL:Init()
    localPly = RPGM.Util.GetLocalPlayer()
    if not IsValid(localPly) then return end

    self:UpdatePlayerVars(localPly)

    self.SmoothHealth = 0
    self.SmoothArmor = 0
    self.SmoothMoney = 0

    self:SetSize(RPGM.Scale(220), RPGM.Scale(120))
    self:AutoPosition()

    gameevent.Listen("player_spawn")
    hook.Add("player_spawn", self, self.ResetMaxes)
end

function PANEL:UpdatePlayerVars(ply)
    self.Name = ply:Nick()
    self.Job = ply:getTeamName()
    self.Money = ply:getMoney()
    self.Health = math.max(ply:Health(), 0)

    local armor = ply:Armor()
    self.ShouldShowArmor = armor > 0
    self.Armor = armor
end

function PANEL:ResetMaxes(data)
    if data.userid ~= localPly:UserID() then return end
    self.MaxHealth = 100
    self.MaxArmor = 100
end

function PANEL:AutoPosition()
    local pad = RPGM.GetScaledConstant("HUD.Padding")
    self:SetPos(pad, ScrH() - pad - self:GetTall())
end

function PANEL:PerformLayout(w, h)

end

function PANEL:Paint(w, h)
    surface.SetDrawColor(RPGM.Colors.Background)
    surface.DrawRect(0, 0, w, h)
end

vgui.Register("RPGM.HUD.PlayerInfo", PANEL, "Panel")

if not IsValid(LocalPlayer()) then return end

if IsValid(testframe) then testframe:Remove() end
testframe = vgui.Create("RPGM.HUD.PlayerInfo")