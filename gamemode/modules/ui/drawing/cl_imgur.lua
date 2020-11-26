
local progressMat
RPGM.GetImgur("635PPvg", function(mat) progressMat = mat end)

function RPGM.DrawProgressWheel(x, y, w, h, col)
    local progSize = math.min(w, h)
    surface.SetMaterial(progressMat)
    surface.SetDrawColor(col.r, col.g, col.b, col.a)
    surface.DrawTexturedRectRotated(x + w / 2, y + h / 2, progSize, progSize, -CurTime() * 100)
end

local grabbingMaterials = {}
local materials = {}

function RPGM.DrawImgur(x, y, w, h, imgurId, col)
    if not materials[imgurId] then
        RPGM.DrawProgressWheel(x, y, w, h, col)

        if grabbingMaterials[imgurId] then return end
        grabbingMaterials[imgurId] = true

        RPGM.GetImgur(imgurId, function(mat)
            materials[imgurId] = mat
            grabbingMaterials[imgurId] = nil
        end)

        return
    end

    surface.SetMaterial(materials[imgurId])
    surface.SetDrawColor(col.r, col.g, col.b, col.a)
    surface.DrawTexturedRect(x, y, w, h)
end

function RPGM.DrawImgurRotated(x, y, w, h, rot, imgurId, col)
    if not materials[imgurId] then
        RPGM.DrawProgressWheel(x - w / 2, y - h / 2, w, h, col)

        if grabbingMaterials[imgurId] then return end
        grabbingMaterials[imgurId] = true

        RPGM.GetImgur(imgurId, function(mat)
            materials[imgurId] = mat
            grabbingMaterials[imgurId] = nil
        end)

        return
    end

    surface.SetMaterial(materials[imgurId])
    surface.SetDrawColor(col.r, col.g, col.b, col.a)
    surface.DrawTexturedRectRotated(x, y, w, h, rot)
end