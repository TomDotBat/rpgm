
RPGM.RegisterScaledConstant("HUD.Minimap.Size", 240)

local rotation = Angle(0, 0, 0)

local localPly
local lerpAngle = LerpAngle
local ft = FrameTime
local hasFocus = system.HasFocus
local function updateStats(ply)
    if not hasFocus() then return ply:EyeAngles() end

    local rot = ply:EyeAngles()
    if ply:InVehicle() then
        rot:Add(Angle(0, ply:GetVehicle():GetAngles().y, 0))
    end

    rotation = lerpAngle(ft() * 20, rotation, rot)
    rotation[1] = 0
    rotation[3] = 0

    return rot
end

local newMatrix = Matrix
local newVector = Vector
local setScissorRect = render.SetScissorRect
local pushModelMatrix, popModelMatrix = cam.PushModelMatrix, cam.PopModelMatrix
local disableClipping = DisableClipping
local backgroundCol = RPGM.Colors.Background
local getScaledConstant = RPGM.GetScaledConstant
hook.Add("RPGM.DrawHUD", "RPGM.DrawMinimap", function(scrW, scrH)
    localPly = RPGM.Util.GetLocalPlayer()
    if not localPly then return end
    local realRotation = updateStats(localPly)

    local padding = getScaledConstant("HUD.Padding")
    local mapSize = getScaledConstant("HUD.Minimap.Size")
    local halfMapSize = mapSize * .5

    local mapX, mapY = padding, padding
    local mapCenterX, mapCenterY = mapX + halfMapSize, mapY + halfMapSize

    surface.SetDrawColor(backgroundCol)
    surface.DrawRect(mapX, mapY, mapSize, mapSize)

    local layer = RPGM.MapData[1]
    local scale = .3
    local size = layer.size * scale
    local halfSize = size * .5

    local mapOffsetX, mapOffsetY
    do
        local pos = localPly:GetPos()
        mapOffsetX, mapOffsetY = layer:worldToMap(pos[1], pos[2])
        mapOffsetX, mapOffsetY = mapOffsetX * scale - size / 2, mapOffsetY * scale + size / 2

        local mat = newMatrix()
        mat:Translate(newVector(mapCenterX, mapCenterY))
        mat:Rotate(rotation)
        mat:Translate(newVector(-mapOffsetX, mapOffsetY))

        setScissorRect(mapX, mapY, mapX + mapSize, mapY + mapSize, true)
        pushModelMatrix(mat)
        disableClipping(true)

        local offset = -halfSize
        RPGM.DrawSubpixelClippedMaterial(RPGM.MapMaterial, offset, offset, size, size)

        disableClipping(false)
        popModelMatrix()
        setScissorRect(0, 0, 0, 0, false)
    end

    local plySize = RPGM.Scale(16)
    RPGM.DrawImgurRotated(mapCenterX, mapCenterY, plySize, plySize, (realRotation - rotation)[2], "h4qOjrP", Color(200, 200, 200))
end)