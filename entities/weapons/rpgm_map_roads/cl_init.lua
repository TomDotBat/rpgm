
include("shared.lua")

function SWEP:Initialize()
    self.Roads = {}
    self.RoadPoints = {}
end

function SWEP:PrimaryAttack()
   if not IsFirstTimePredicted() then return end
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    local tr = ply:GetEyeTraceNoCursor()
    if not tr.Hit then return end

    table.insert(self.RoadPoints, tr.HitPos)
end

function SWEP:SecondaryAttack()
    table.insert(self.Roads, self.RoadPoints)
    self.RoadPoints = {}
end

function SWEP:Reload()
    table.Empty(self.Roads)
    table.Empty(self.RoadPoints)
end

function SWEP:DrawRoad(road)
    if table.IsEmpty(road) then return end

    for i, point in ipairs(road) do
        local nextPoint = select(2, next(road, i))
        if not nextPoint then nextPoint = road[1] end

        render.DrawLine(point, nextPoint, self.LineColor)
    end
end

function SWEP:DrawHUD()
    self.LineColor = HSVToColor((CurTime() * 100) % 360, 1, 1)

    cam.Start3D()
        for _, road in ipairs(self.Roads) do
            self:DrawRoad(road)
        end

        self:DrawRoad(self.RoadPoints)
    cam.End3D()
end