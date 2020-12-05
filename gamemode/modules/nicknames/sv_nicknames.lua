
local disallowedNames = {["tom.bat"] = true, ["tomdotbat"] = true, ["ooc"] = true, ["shared"] = true, ["world"] = true, ["world prop"] = true}
hook.Add("RPGM.CanChangeNickname", "RPGM.NicknameRestrictions", function(ply, name)
    if disallowedNames[string.lower(name)] then return false, "is blacklisted" end
    if not string.match(name, "^[a-zA-ZЀ-џ0-9 ]+$") then return false, "contains illegal characters" end

    local len = string.len(name)
    if len > 30 then return false, "is too long" end
    if len < 3 then return false, "is too short" end
end)

function RPGM.ChangeNickname(ply, name)
    local success, reason = hook.Call("RPGM.CanChangeNickname", nil, ply, name)
    if success == false then
        ply:rpNotify("Invalid Nickname", "The name you provided " .. reason .. ".", NOTIFY_ERROR)
        return
    end

end