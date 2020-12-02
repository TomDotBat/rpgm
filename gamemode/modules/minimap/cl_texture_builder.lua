
local function buildTexture()
    local txt = file.Read("rpgm/map_dumps/map_complete.json")
    if not txt then return end

    local data = util.JSONToTable(txt)
    if not data then return end

    local min, max = math.min, math.max
    local huge = math.huge
    local abs = math.abs

    local matSize = ScrH() * 2

    RPGM.MapData = {}

    for layerId, layer in ipairs(data) do
        local ly = {
            roads = {},
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

        local offsetX, offsetY = abs(ly.minX), abs(ly.minY)

        local scale = matSize / max(ly.maxX + offsetX, ly.maxY + offsetY)
        RPGM.MapData[layerId].scale = scale

        for roadId, road in ipairs(layer.roads) do
            for pointId, point in ipairs(road) do
                ly["roads"][roadId][pointId] = {x = (point[1] + offsetX) * scale, y = (point[2] + offsetY) * scale}
            end
        end
    end

    local layerNo = 1
    local renderTarget = GetRenderTarget("rpgm_minimap_" .. layerNo .. "_" .. tostring(matSize), matSize, matSize)

    RPGM.MapMaterial = CreateMaterial("rpgm_minimap_" .. layerNo,  "UnlitGeneric", {
        ["$translucent"] = 1,
        ["$vertexalpha"] = 1,
        ["$alpha"] = 1
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
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(RPGM.MapMaterial)
    surface.DrawTexturedRectRotated(ScrH() * .5, ScrH() * .5, ScrH(), ScrH(), CurTime() * 10)
end)