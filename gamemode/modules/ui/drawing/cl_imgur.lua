
local progressMat
RPGM.GetImgur("hX9kSve", function(mat) progressMat = mat end)

local getImgur = RPGM.GetImgur

local setMaterial = surface.SetMaterial
local setDrawColor = surface.SetDrawColor
local drawTexturedRectRotated = surface.DrawTexturedRectRotated
local drawTexturedRect = surface.DrawTexturedRect

local min = math.min
local function drawProgressWheel(x, y, w, h, col)
    local progSize = min(w, h)
    setMaterial(progressMat)
    setDrawColor(col.r, col.g, col.b, col.a)
    drawTexturedRectRotated(x + w / 2, y + h / 2, progSize, progSize, -CurTime() * 100)
end
RPGM.DrawProgressWheel = drawProgressWheel

do
    local materials = {}
    local grabbingMaterials = {}

    function RPGM.DrawImgur(x, y, w, h, imgurId, col)
        if not materials[imgurId] then
            drawProgressWheel(x, y, w, h, col)

            if grabbingMaterials[imgurId] then return end
            grabbingMaterials[imgurId] = true

            getImgur(imgurId, function(mat)
                materials[imgurId] = mat
                grabbingMaterials[imgurId] = nil
            end)

            return
        end

        setMaterial(materials[imgurId])
        setDrawColor(col.r, col.g, col.b, col.a)
        drawTexturedRect(x, y, w, h)
    end

    function RPGM.DrawImgurRotated(x, y, w, h, rot, imgurId, col)
        if not materials[imgurId] then
            drawProgressWheel(x - w / 2, y - h / 2, w, h, col)

            if grabbingMaterials[imgurId] then return end
            grabbingMaterials[imgurId] = true

            getImgur(imgurId, function(mat)
                materials[imgurId] = mat
                grabbingMaterials[imgurId] = nil
            end)

            return
        end

        setMaterial(materials[imgurId])
        setDrawColor(col.r, col.g, col.b, col.a)
        drawTexturedRectRotated(x, y, w, h, rot)
    end
end