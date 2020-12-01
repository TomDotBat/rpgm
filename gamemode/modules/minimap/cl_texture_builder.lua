
local function buildTexture()
    local txt = file.Read("rpgm/map_dumps/map_complete.json")
    if not txt then return end

    local data = util.JSONToTable(txt)
    if not data then return end

    local min, max = math.min, math.max
    local huge = math.huge
    local abs = math.abs

    RPGM.MapData = {}

    for layerId, layer in ipairs(data) do
        RPGM.MapData[layerId] = {
            roads = {},
            minX = 0, minY = 0,
            maxX = huge, maxY = huge
        }

        for roadId, road in ipairs(layer.roads) do
            RPGM.MapData[layerId]["roads"][roadId] = {}

            for pointId, point in ipairs(road) do
                local x, y = point[1], point[2]

                RPGM.MapData[layerId].minX = min(RPGM.MapData[layerId].minX, x)
                RPGM.MapData[layerId].minY = min(RPGM.MapData[layerId].minY, y)
                RPGM.MapData[layerId].maxX = max(RPGM.MapData[layerId].maxX, x)
                RPGM.MapData[layerId].maxY = max(RPGM.MapData[layerId].maxY, y)
            end
        end

        local offsetX, offsetY = abs(RPGM.MapData[layerId].minX), abs(RPGM.MapData[layerId].minY)

        RPGM.MapData[layerId].minX = 0
        RPGM.MapData[layerId].minY = 0
        RPGM.MapData[layerId].maxX = RPGM.MapData[layerId].maxX + offsetX
        RPGM.MapData[layerId].maxY = RPGM.MapData[layerId].maxY + offsetY

        local scale = .1
        for roadId, road in ipairs(layer.roads) do
            for pointId, point in ipairs(road) do
                RPGM.MapData[layerId]["roads"][roadId][pointId] = {x = (point[1] + offsetX) * scale, y = (point[2] + offsetY) * scale}
            end
        end
    end

    local matSize = ScrH()
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