
include("shared.lua")

function SWEP:Initialize()
    if not RPGM.RoadEditor then RPGM.RoadEditor = RPGM.Classes.RoadEditor() end
    self.Editor = RPGM.RoadEditor

    self.NewRoadPoints = {}
end

function SWEP:GetSelectedLayer()
    return self.Editor and self.Editor.selectedLayer or 0
end

function SWEP:HasSelectedLayer()
    return self:GetSelectedLayer() > 0
end

function SWEP:WarnUnselectedLayer()
    RPGM.AddNotification("You're a fucking retard", "Select a layer you absolute degenerate, what did you think was going to happen? Dumbass.", NOTIFY_ERROR, 20)
end

function SWEP:OnPrimary(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    local tr = ply:GetEyeTraceNoCursor()
    if not tr.Hit then return end

    table.insert(self.NewRoadPoints, tr.HitPos)
end

function SWEP:OnPrimaryShift(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    if table.IsEmpty(self.NewRoadPoints) then
        RPGM.AddNotification("No Previous Points", "Do you having fucking memory loss? There are no previous points you cretin.", NOTIFY_ERROR, 20)
        return
    end

    RPGM.AddNotification("Point Deleted", "Successfully deleted the last road point.", NOTIFY_GENERIC, 5)
    table.remove(self.NewRoadPoints)
end

function SWEP:OnSecondary(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    if table.IsEmpty(self.NewRoadPoints) then
        RPGM.AddNotification("Road Empty", "You can't add an empty road you absolute fucking wanker.", NOTIFY_ERROR, 20)
        return
    end

    RPGM.AddNotification("Road Added", "Successfully added the road to the layer.", NOTIFY_GENERIC, 5)
    table.insert(self.Editor.layers[self:GetSelectedLayer()].roads, self.NewRoadPoints)
    self.NewRoadPoints = {}
end

function SWEP:OnSecondaryShift(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    local roads = self.Editor.layers[self:GetSelectedLayer()].roads
    if table.IsEmpty(roads) then
        RPGM.AddNotification("No Previous Roads", "You clearly need to get your fucking memory checked retard.", NOTIFY_ERROR, 20)
        return
    end

    RPGM.AddNotification("Previous Road Selected", "The previous road has been selected and your current one was deleted.", NOTIFY_GENERIC, 5)

    self.NewRoadPoints = roads[#roads]
    table.remove(roads)
end

function SWEP:OnReload(ply)
    if self.NextReload and CurTime() < self.NextReload then return end
    self.NextReload = CurTime() + 1

    self.Editor:openMenu()
end

RPGM.RegisterFont("MapEditor.Title", "Open Sans Bold", 72, 500)
RPGM.RegisterFont("MapEditor.SubText", "Open Sans Bold", 30, 500)

RPGM.RegisterScaledConstant("MapEditor.TitleSpacing", 4)
RPGM.RegisterScaledConstant("MapEditor.TextSpacing", 2)

function SWEP:DrawTips()
    local shiftPressed = self:IsShiftPressed()

    local pad = RPGM.GetScaledConstant("HUD.Padding")
    local _, titleH = RPGM.DrawSimpleText("RPGM Road Editor", "RPGM.MapEditor.Title", pad, pad, RPGM.Colors.PrimaryText)

    local textSpacing = RPGM.GetScaledConstant("MapEditor.TextSpacing")

    local textY = pad + titleH + RPGM.GetScaledConstant("MapEditor.TitleSpacing")
    local _, textH = RPGM.DrawSimpleText("Left click: Place a road point", "RPGM.MapEditor.SubText", pad, textY, RPGM.Colors.SecondaryText)

    textY = textY + textH + textSpacing
    _, textH = RPGM.DrawSimpleText("Shift + Left click: Delete the last point", "RPGM.MapEditor.SubText", pad, textY, shiftPressed and RPGM.Colors.PrimaryText or RPGM.Colors.SecondaryText)

    textY = textY + textH + textSpacing
    _, textH = RPGM.DrawSimpleText("Right click: Start a new road", "RPGM.MapEditor.SubText", pad, textY, RPGM.Colors.SecondaryText)

    textY = textY + textH + textSpacing
    _, textH = RPGM.DrawSimpleText("Shift + Right click: Go back and delete the current road", "RPGM.MapEditor.SubText", pad, textY, shiftPressed and RPGM.Colors.PrimaryText or RPGM.Colors.SecondaryText)

    textY = textY + textH + textSpacing
    RPGM.DrawSimpleText("Reload: Open road editor menu", "RPGM.MapEditor.SubText", pad, textY, RPGM.Colors.SecondaryText)
end

function SWEP:DrawLayerInfo()
    local selectedLayer = self:GetSelectedLayer()
    local layer = self.Editor.layers[selectedLayer]

    local pad = RPGM.GetScaledConstant("HUD.Padding")
    local text = "Selected Layer: " .. (self.Editor.layers[selectedLayer].name or selectedLayer) .. "\nLayer Road Count: " .. #layer.roads

    surface.SetFont("RPGM.MapEditor.SubText")
    local _, textH = surface.GetTextSize(text)

    RPGM.DrawText(text, "RPGM.MapEditor.SubText", ScrW() * .5, ScrH() - pad - textH, RPGM.Colors.SecondaryText, TEXT_ALIGN_CENTER)
end

local red = Color(255, 0, 0)
function SWEP:DrawHUD()
    surface.SetAlphaMultiplier(.5)
    self:DrawTips()

    if not self:HasSelectedLayer() then surface.SetAlphaMultiplier(1) return end
    self:DrawLayerInfo()

    surface.SetAlphaMultiplier(1)

    local col = color_white
    cam.Start3D()
        self:DrawObjects(self.Editor.layers[self:GetSelectedLayer()].roads, col)
        self:DrawPoints(self.NewRoadPoints, red)
    cam.End3D()
end