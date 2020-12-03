
local function buildTexture()
    local txt = file.Read("rpgm/map_dumps/map_complete.json")
    if not txt then return end

    local data = util.JSONToTable(txt)
    if not data then return end

    local min, max = math.min, math.max
    local round = math.Round
    local huge = math.huge
    local abs = math.abs

    local matSize = 512
    local scrH = ScrH()
    if scrH <= 512 then matSize = 512
    elseif scrH <= 1024 then matSize = 1024
    elseif scrH <= 2048 then matSize = 2048
    else matSize = 4096 end

    RPGM.MapData = {}

    for layerId, layer in ipairs(data) do
        local ly = {
            roads = {},
            size = matSize,
            minX = huge, minY = huge,
            maxX = -huge, maxY = -huge
        }
        RPGM.MapData[layerId] = ly

        for roadId, road in ipairs(layer.roads) do
            ly["roads"][roadId] = {}

            for pointId, point in ipairs(road) do
                local x, y = point[1], point[2]
                ly.minX = min(ly.minX, x)
                ly.minY = min(ly.minY, y)
                ly.maxX = max(ly.maxX, x)
                ly.maxY = max(ly.maxY, y)
            end
        end

        local offsetX, offsetY = round(abs(ly.minX)), round(abs(ly.minY))
        ly.offsetX = offsetX
        ly.offsetY = offsetY

        local scale = matSize / max(ly.maxX + offsetX, ly.maxY + offsetY)
        ly.scale = scale

        for roadId, road in ipairs(layer.roads) do
            for pointId, point in ipairs(road) do
                ly["roads"][roadId][pointId] = {x = (point[1] + offsetX) * scale, y = (point[2] + offsetY) * scale}
            end
        end

        function ly:worldToMap(x, y)
            return (-y + 7530) * scale, (x - 9120) * scale
            --return (-y + offsetX) * scale, (x - offsetY) * scale
        end
    end

    local layerNo = 1
    local renderTarget = GetRenderTarget("rpgm_minimap_" .. layerNo .. "_" .. tostring(matSize), matSize, matSize)

    RPGM.MapMaterial = CreateMaterial("rpgm_minimap_" .. layerNo,  "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1,
        ["$basetexturetransform"] = "center .5 .5 scale -1 1 rotate 90 translate 0 0"
    })

    render.PushRenderTarget(renderTarget)

    render.OverrideAlphaWriteEnable(true, true)
    render.Clear(0, 0, 0, 0)
    render.OverrideAlphaWriteEnable(false, false)

    cam.Start2D()
        draw.NoTexture()
        surface.SetDrawColor(255, 255, 255, 255)

        for _, road in ipairs(RPGM.MapData[layerNo].roads) do
            surface.DrawPoly(road)
        end
    cam.End2D()

    render.PopRenderTarget()

    RPGM.MapMaterial:SetTexture("$basetexture", renderTarget)
end

buildTexture()
hook.Add("OnScreenSizeChanged", "RPGM.RebuildMinimap", buildTexture)

hook.Add("HUDPaint", "mmtest", function()
    surface.SetDrawColor(0, 0, 0, 255)
    draw.NoTexture()
    --surface.DrawTexturedRectRotated(ScrH() * .5, ScrH() * .5, ScrH(), ScrH(), 90)
    local layer = RPGM.MapData[1]
    local size = layer.size -- * .5
    local posX, posY = layer:worldToMap(LocalPlayer():GetPos().x, LocalPlayer():GetPos().y)

    --posX, posY = posX * .5, posY * .5
    local x, y = ScrW() / 2 - size / 2, ScrH() / 2 - size / 2
    --surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(x, y, size, size)

    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(RPGM.MapMaterial)
    --surface.DrawTexturedRectRotated(ScrW() / 2, ScrH() / 2, size, size, 0)
    --surface.DrawTexturedRect(x, y, size, size)
    RPGM.DrawSubpixelClippedMaterial(RPGM.MapMaterial, x, y, size, size)

    surface.SetDrawColor(150, 150, 150, 255)
    draw.NoTexture()
    surface.DrawTexturedRectRotated(x + posX, y - posY, 8, 8, LocalPlayer():EyeAngles()[2])

    --surface.SetDrawColor(0, 0, 0, 255)
    --RPGM.DrawTexturedRectRotatedPoint(ScrW() * .5, ScrH() * .5, size, size, -LocalPlayer():EyeAngles()[2], posX, posY)
--
    --surface.SetDrawColor(255, 255, 255, 255)
    --surface.SetMaterial(RPGM.MapMaterial)
    --RPGM.DrawTexturedRectRotatedPoint(ScrW() * .5, ScrH() * .5, size, size, -LocalPlayer():EyeAngles()[2], posX, posY)
end)

--hook.Remove("HUDPaint", "mmtest")