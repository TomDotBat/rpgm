
if not RPGM.Config.FirstPersonDeathView then return end

local view = {
    origin = Vector(0, 0, 0),
    angles = Angle(0, 0, 0),
    fov = 90,
    znear = 1
}

hook.Add("CalcView", "RPGM.FirstPersonDeathView", function(ply, origin, angles, fov)
    if ply:Health() > 0 then return end

    local ragdoll = ply:GetRagdollEntity()
    if not IsValid(ragdoll) then return end

    local head = ragdoll:LookupAttachment("eyes")
    head = ragdoll:GetAttachment(head)
    if not head or not head.Pos then return end

    if not ragdoll.BonesRattled then
        ragdoll.BonesRattled = true

        ragdoll:InvalidateBoneCache()
        ragdoll:SetupBones()

        local matrix

        for bone = 0, (ragdoll:GetBoneCount() or 1) do
            if ragdoll:GetBoneName(bone):lower():find("head") then
                matrix = ragdoll:GetBoneMatrix(bone)
                break
            end
        end

        if IsValid(matrix) then matrix:SetScale(vector_origin) end
    end

    view.origin = head.Pos + head.Ang:Up() * 8
    view.angles = head.Ang

    return view
end)