
hook.Remove("RPGM.DrawHUD", "RPGM.DrawMinimap")
if true then return end

RPGM.MapData = nil

if not RPGM.MapData then
    local txt = file.Read("rpgm/map_dumps/map_1606763011.json")
    if not txt then
        RPGM.AddNotification("Map Import Failed", "The specified file was empty.", NOTIFY_ERROR, 5)
        return
    end

    local data = util.JSONToTable(txt)
    if not data then
        RPGM.AddNotification("Map Import Failed", "The file contents couldn't be parsed.", NOTIFY_ERROR, 5)
        return
    end

    local centerPoint
    local function getIsLess(a, b)
        if a.x >= 0 and b.x < 0 then return true
        elseif a.x == 0 and b.x == 0 then return a.y > b.y
        end

        local det = (a.x - centerPoint.x) * (b.y - centerPoint.y) - (b.x - centerPoint.x) * (a.y - centerPoint.y)
        if det < 0 then return true
        elseif det > 0 then return false
        end

        local d1 = (a.x - centerPoint.x) * (a.x - centerPoint.x) + (a.y - centerPoint.y) * (a.y - centerPoint.y)
        local d2 = (b.x - centerPoint.x) * (b.x - centerPoint.x) + (b.y - centerPoint.y) * (b.y - centerPoint.y)
        return d1 > d2
    end

    local function getCenterPointOfPoints(points)
        local pointsSum = {x = 0, y = 0}
        for i = 1, #points do pointsSum.x = pointsSum.x + points[i].x; pointsSum.y = pointsSum.y + points[i].y end
        return {x = pointsSum.x / #points, y = pointsSum.y / #points}
    end

    local function sortPointsClockwise(points)
        centerPoint = getCenterPointOfPoints(points)
        table.sort(points, getIsLess)
        return points
    end

    local scale = .04
    local offset = 500

    RPGM.MapData = {}
    for roadId, road in ipairs(data[1].roads) do
        table.insert(RPGM.MapData, {})
        for _, point in ipairs(road) do
            table.insert(RPGM.MapData[roadId], {x = point[1] * scale + offset, y = point[2] * scale + offset}) -- {point[1], -point[2]}) --
        end
        --RPGM.MapData[roadId] = table.Reverse(RPGM.MapData[roadId])
        sortPointsClockwise(RPGM.MapData[roadId])
    end
end

RPGM.RegisterScaledConstant("Minimap.PlayerIcon", 24)

local localPly
local mapData = RPGM.MapData
local getScaledConstant = RPGM.GetScaledConstant
hook.Add("RPGM.DrawHUD", "RPGM.DrawMinimap", function(scrW, scrH)
    localPly = RPGM.Util.GetLocalPlayer()
    if not IsValid(localPly) then return end

    local scale = .04 --math.abs(math.sin(CurTime()) * .1)
    local offset = 500

    local rot = localPly:EyeAngles()

    --local centerX, centerY = scrW * .5, scrH * .5
    local iconSize = getScaledConstant("Minimap.PlayerIcon")

    surface.SetDrawColor(255, 255, 255, 255)
    draw.NoTexture()
    for _, road in ipairs(mapData) do
        --for i, point in ipairs(road) do
        --    local nextPoint = select(2, next(road, i))
        --    if not nextPoint then nextPoint = road[1] end
--
        --    surface.DrawLine(
        --        point[1] * scale + offset,
        --        point[2] * scale + offset,
        --        nextPoint[1] * scale + offset,
        --        nextPoint[2] * scale + offset
        --    )
        --end

        surface.DrawPoly(road)
    end

    local pos = localPly:GetPos()
    local plyX, plyY = pos[1], -pos[2]
    RPGM.DrawImgurRotated(plyX * scale + offset, plyY * scale + offset, iconSize, iconSize, rot[2], "8Mn7rdX", color_white)
end)