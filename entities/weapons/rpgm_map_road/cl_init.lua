
include("shared.lua")

function SWEP:Initialize()
    if not RPGM.RoadEditor then RPGM.RoadEditor = RPGM.Classes.RoadEditor() end
    self.Editor = RPGM.RoadEditor

    self.PreviewData = {}
    self.NewRoadPoints = {}
    self:SetupRender()

    hook.Add("RPGM.Minimap.EditorUpdate", self, self.FormatMapData)
end

function SWEP:Deploy()
    self:SetupRender()
end

function SWEP:SetupRender()
    local class = self.ClassName
    hook.Add("PostDrawTranslucentRenderables", self, function()
        local localPly = RPGM.Util.GetLocalPlayer()
        if not IsValid(localPly) then return end
        local wep = localPly:GetActiveWeapon()
        if wep:GetClass() ~= class then hook.Remove("PostDrawTranslucentRenderables", "RPGM.MapEditor.Overlay") return end
        wep:DrawEditor()
    end)
end

function SWEP:FormatMapData()
    local scale = self.Editor.previewScale
    local offsetX, offsetY = self.Editor.previewOffsetX, self.Editor.previewOffsetY

    local layer = self.Editor.layers[self:GetSelectedLayer()]
    if not layer then return end

    self.PreviewData = {}
    for roadId, road in ipairs(layer.roads) do
        table.insert(self.PreviewData, {})
        for _, point in ipairs(road) do
            table.insert(self.PreviewData[roadId], {x = point[1] * scale + offsetX, y = point[2] * scale + offsetY})
        end
    end
end

function SWEP:GetSelectedLayer()
    return self.Editor and self.Editor.selectedLayer or 0
end

function SWEP:HasSelectedLayer()
    return self:GetSelectedLayer() > 0
end

function SWEP:GetCursorPos()
    local realPos = self:GetOwner():GetEyeTraceNoCursor().HitPos

    local snap = self.Editor.cursorSnap
    if not snap or snap < 1 then return realPos end

    local lastPos = self.NewRoadPoints[#self.NewRoadPoints]
    if not lastPos then return realPos end

    local relativePos = realPos - lastPos
    local angleDiff = relativePos:Angle()
    angleDiff:SnapTo("y", snap)

    local mathsThing = math.sqrt(relativePos[1] ^ 2 + relativePos[2] ^ 2)
    local newPos = Vector(realPos[1] + math.sin(angleDiff[2]) * mathsThing, realPos[2] + math.cos(angleDiff[2]) * mathsThing, realPos[3])

    return newPos
end

function SWEP:WarnUnselectedLayer()
    RPGM.AddNotification("You're a fucking retard", "Select a layer you absolute degenerate, what did you think was going to happen? Dumbass.", NOTIFY_ERROR, 20)
end

function SWEP:OnPrimary(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end
    table.insert(self.NewRoadPoints, self:GetCursorPos())
    self:FormatMapData()
end

function SWEP:OnPrimaryShift(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    if table.IsEmpty(self.NewRoadPoints) then
        RPGM.AddNotification("No Previous Points", "Do you having fucking memory loss? There are no previous points you cretin.", NOTIFY_ERROR, 20)
        return
    end

    RPGM.AddNotification("Point Deleted", "Successfully deleted the last road point.", NOTIFY_GENERIC, 5)
    table.remove(self.NewRoadPoints)
    self:FormatMapData()
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
    self:FormatMapData()
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
    self:FormatMapData()
end

function SWEP:OnSecondaryControl(ply)
    if not self:HasSelectedLayer() then self:WarnUnselectedLayer() return end

    local nearRoad = self.NearestObject
    if not nearRoad then
        RPGM.AddNotification("No Nearby Roads", "Can you see any fucking yellow? No. So why are you trying dumbass.", NOTIFY_ERROR, 20)
        return
    end

    self.NewRoadPoints = self.NearestObject
    table.remove(self.Editor.layers[self:GetSelectedLayer()].roads, self.NearestObjectId)
    self:FormatMapData()
end

function SWEP:OnReload(ply)
    if self.NextReload and CurTime() < self.NextReload then return end
    self.NextReload = CurTime() + 1

    self.Editor:openMenu()
    self:FormatMapData()
end

RPGM.RegisterFont("MapEditor.Title", "Open Sans Bold", 72, 500)
RPGM.RegisterFont("MapEditor.SubText", "Open Sans Bold", 30, 500)

RPGM.RegisterScaledConstant("MapEditor.TitleSpacing", 4)
RPGM.RegisterScaledConstant("MapEditor.TextSpacing", 2)

function SWEP:DrawTips()
    local shiftPressed = self:IsShiftPressed()
    local controlPressed = self:IsControlPressed()

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
    _, textH = RPGM.DrawSimpleText("Ctrl + Right click: Edit the currently hovered road", "RPGM.MapEditor.SubText", pad, textY, controlPressed and RPGM.Colors.PrimaryText or RPGM.Colors.SecondaryText)

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
local blue = Color(0, 0, 255)
local yellow = Color(255, 255, 0)
function SWEP:DrawHUD()
    surface.SetAlphaMultiplier(.5)
    self:DrawTips()

    if not self:HasSelectedLayer() then surface.SetAlphaMultiplier(1) return end
    self:DrawLayerInfo()

    surface.SetAlphaMultiplier(1)

    draw.NoTexture()
    local localPly = RPGM.Util.GetLocalPlayer()
    if not IsValid(localPly) then return end

    for _, road in ipairs(self.PreviewData) do
        if _ == self.NearestObjectId then surface.SetDrawColor(yellow) else surface.SetDrawColor(color_white) end
        surface.DrawPoly(road)
    end

    local scale = self.Editor.previewScale
    local offsetX, offsetY = self.Editor.previewOffsetX, self.Editor.previewOffsetY

    local newRoadPoints
    if self.Editor.connectToCursor then
        newRoadPoints = table.Copy(self.NewRoadPoints)
        table.insert(newRoadPoints, self:GetCursorPos())
    else
        newRoadPoints = self.NewRoadPoints
    end

    if #newRoadPoints > 2 then
        surface.SetDrawColor(red)
        local drawData = {}
        for _, point in ipairs(newRoadPoints) do
            table.insert(drawData, {x = point[1] * scale + offsetX, y = point[2] * scale + offsetY})
        end
        surface.DrawPoly(drawData)
    end

    local pos = localPly:GetPos()
    local plyX, plyY = pos[1], pos[2]
    RPGM.DrawCircle(plyX * scale + offsetX - 4, plyY * scale + offsetY - 4, 8, 8, HSVToColor((CurTime() * 100) % 360, 1, 1))
end

function SWEP:DrawEditor()
    if not self:HasSelectedLayer() then return end

    local cursorPos
    if self.Editor.showCursor or self.Editor.connectToCursor then
        cursorPos = self:GetCursorPos()
    end

    local col = color_white
    cam.Start3D()
        local obj, id = self:DrawObjects(self.Editor.layers[self:GetSelectedLayer()].roads, col, true, self:GetOwner():GetPos())
        if obj then
            self.NearestObject = obj
            self.NearestObjectId = id
            self:DrawPoints(obj, yellow)
        end

        local roadPoints
        if self.Editor.connectToCursor then
            roadPoints = table.Copy(self.NewRoadPoints)
            table.insert(roadPoints, cursorPos)
        else
            roadPoints = self.NewRoadPoints
        end

        self:DrawPoints(roadPoints, red)

        if self.Editor.showCursor then
            render.SetColorMaterial()
            render.DrawWireframeSphere(cursorPos, 4, 8, 8, blue, true)
        end
    cam.End3D()
end