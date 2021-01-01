
include("shared.lua")

RPGM.RegisterFontUnscaled("Money.Value", "Open Sans Bold", 50)

local eyeAngles = EyeAngles
local centerAlign = TEXT_ALIGN_CENTER
local disableClipping = DisableClipping
local start3D2D, end3D2D = cam.Start3D2D, cam.End3D2D

local col = RPGM.OffsetColor(RPGM.Colors.Positive, 20)
local offset = Vector(0, 0, 4)
local angle = Angle(0, 0, 90)
function ENT:Draw()
    self:DrawModel()

    local text = self.FormattedAmount
    if not text then
        text = RPGM.FormatMoney(self:GetAmount())
        self.FormattedAmount = text
    end

    local oldClipping = disableClipping(true)

    angle[2] = eyeAngles()[2] - 90

    start3D2D(self:GetPos() + offset, angle, .1)
        RPGM.DrawSimpleText(text, "RPGM.Money.Value", 0, 0, col, centerAlign, centerAlign)
    end3D2D()

    disableClipping(oldClipping)
end