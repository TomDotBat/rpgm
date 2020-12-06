
local roofCache = {
    ["models/tdmcars/bus.mdl"] = Vector(),
    ["models/sligwolf/bus/bus.mdl"] = Vector(),
}

local function getRoof(car)
    local parent = car:GetParent()
    car = (parent:IsValid() and parent:IsVehicle()) and parent or car

    local mdl = car:GetModel()
    if not roofCache[mdl] then
        roofCache[mdl] = car:WorldToLocal(
            util.TraceLine({
                start = car:LocalToWorld(Vector(0, 0, car:OBBMaxs().z)),
                endpos = car:LocalToWorld(Vector(0, 0, car:OBBMins().z)),
                filter = function(ent) return ent == car end
            }).HitPos
        )
    end

    return car:LocalToWorld(roofCache[mdl]).z
end

local localPly
local isValid = IsValid
hook.Add("RPGM.ShouldDraw", "RPGM.DrawOverheads", function(elem)
    if elem ~= "Overheads" then return end
    local wep = localPly:GetActiveWeapon()
    if isValid(wep) and wep:GetClass() == "gmod_camera" then return false end
end)

local max = math.max
local getAllPlayers = player.GetAll
local callHook = hook.Call
hook.Add("PostDrawTranslucentRenderables", "RPGM.DrawOverheads", function(depth, skybox)
    if depth or skybox then return end

    localPly = RPGM.Util.GetLocalPlayer()
    if not localPly then return end

    if callHook("RPGM.ShouldDraw", nil, "Overheads") == false then return end

    for _, ply in ipairs(getAllPlayers()) do
        if ply == localPly then continue end
        if ply:Health() < 1 then continue end

        local eye
        local boneId = ply:LookupBone("ValveBiped.Bip01_Head1")
        if boneId then eye = ply:GetBonePosition(boneId)
        else eye = ply:GetPos() end

        if ply:InVehicle() then
            eye.z = max(eye.z + 9, getRoof(ply:GetVehicle()) + 5)
        else
            eye.z = eye.z + 9
        end
    end
end)