
local disallowedNames = {["tom.bat"] = true, ["tomdotbat"] = true, ["ooc"] = true, ["advert"] = true, ["shared"] = true, ["world"] = true, ["world prop"] = true}
hook.Add("RPGM.CanChangeNickname", "RPGM.NicknameRestrictions", function(ply, name)
    if disallowedNames[string.lower(name)] then return false, "is blacklisted" end
    if not string.match(name, "^[a-zA-ZЀ-џ0-9 ]+$") then return false, "contains illegal characters" end

    local len = string.len(name)
    if len > 30 then return false, "is too long" end
    if len < 3 then return false, "is too short" end
end)

function RPGM.ChangeNickname(ply, name, caller)
    caller = caller or ply

    local success, reason = hook.Call("RPGM.CanChangeNickname", nil, ply, name)
    if success == false then
        caller:rpNotify("Invalid Nickname", "The name you provided " .. reason .. ".", NOTIFY_ERROR)
        return
    end

    RPGM.GetPlayerNameExists(name, function(exists)
        if not (IsValid(ply) and IsValid(caller)) then return end
        if exists then
            caller:rpNotify("Nickname In Use", "The name you provided is already in use.", NOTIFY_ERROR)
            return
        end

        local oldName = ply:Name()
        RPGM.SetPlayerNameInDB(ply:SteamID64(), name, ply:SteamName(), function()
            if not IsValid(ply) then return end
            ply:setRPString("Nickname", name)
            hook.Call("RPGM.NicknameChanged", nil, ply, oldName, name, ply:SteamName())
        end)
    end)
end

hook.Add("RPGM.NicknameChanged", "RPGM.AlertNicknameChanges", function(ply, oldName, newName, steamName)
    RPGM.Notify(
        player.GetAll(), "Nickname Change",
        oldName .. " changed their nickname to " .. newName .. ".",
        NOTIFY_GENERIC
    )
end)