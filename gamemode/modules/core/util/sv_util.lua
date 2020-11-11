
local ipairs = ipairs
local pointContents = util.PointContents
local findInSphere = ents.FindInSphere

function RPGM.Util.IsEmpty(pos, ignore)
    ignore = ignore or {}

    local point = pointContents(pos)
    local a = point ~= CONTENTS_SOLID
        and point ~= CONTENTS_MOVEABLE
        and point ~= CONTENTS_LADDER
        and point ~= CONTENTS_PLAYERCLIP
        and point ~= CONTENTS_MONSTERCLIP
    if not a then return false end

    local b = true

    for _, v in ipairs(findInSphere(pos, 35)) do
        if (v:IsNPC() or v:IsPlayer() or v:GetClass() == "prop_physics" or v.NotEmptyPos) and not ignore[v] then
            b = false
            break
        end
    end

    return a and b
end

local isEmpty = RPGM.Util.IsEmpty

function RPGM.Util.FindEmptyPos(pos, ignore, distance, step, area)
    if isEmpty(pos, ignore) and isEmpty(pos + area, ignore) then
        return pos
    end

    for j = step, distance, step do
        for i = -1, 1, 2 do
            local k = j * i

            -- Look North/South
            if isEmpty(pos + Vector(k, 0, 0), ignore) and RPGM.Util.IsEmpty(pos + Vector(k, 0, 0) + area, ignore) then
                return pos + Vector(k, 0, 0)
            end

            -- Look East/West
            if isEmpty(pos + Vector(0, k, 0), ignore) and isEmpty(pos + Vector(0, k, 0) + area, ignore) then
                return pos + Vector(0, k, 0)
            end

            -- Look Up/Down
            if isEmpty(pos + Vector(0, 0, k), ignore) and isEmpty(pos + Vector(0, 0, k) + area, ignore) then
                return pos + Vector(0, 0, k)
            end
        end
    end

    return pos
end