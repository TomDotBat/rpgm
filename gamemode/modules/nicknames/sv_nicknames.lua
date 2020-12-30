
local disallowedNames = {["tom.bat"] = true, ["tomdotbat"] = true, ["ooc"] = true, ["advert"] = true, ["shared"] = true, ["world"] = true, ["world prop"] = true}
hook.Add("RPGM.CanChangeNickname", "RPGM.NicknameRestrictions", function(ply, name)
    if disallowedNames[string.lower(name)] then return false, "is blacklisted" end
    if not string.match(name, "^[a-zA-ZЀ-џ0-9 ]+$") then return false, "contains illegal characters" end

    local len = string.len(name)
    if len > 30 then return false, "is too long" end
    if len < 3 then return false, "is too short" end
end)

function RPGM.ChangeNickname(ply, name, caller)
    if name == "" then RPGM.ResetNickname(caller, ply:Name()) end

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

function RPGM.ResetNickname(caller, name)
    RPGM.GetPlayerSteamIDFromDB(name, function(steamid)
        if not steamid then
            if IsValid(caller) then caller:rpNotify("Nickname Not Found", "The name you provided isn't in use.", NOTIFY_ERROR) end
            return
        end

        local ply = player.GetBySteamID64(steamid)
        RPGM.SetPlayerNameInDB(steamid, "", IsValid(ply) and ply:SteamName() or "", function()
            if IsValid(ply) then
                ply:setRPString("Nickname", "")
                ply:rpNotify("Nickname Reset", "Your nickname has been reset" .. (IsValid(caller) and " by an administrator." or "."), NOTIFY_ERROR)

                local filter = RecipientFilter()
                filter:AddAllPlayers()
                filter:RemovePlayer(ply)
                if IsValid(caller) then filter:RemovePlayer(caller) end

                RPGM.Notify(
                    filter, "Nickname Change",
                    name .. " changed their nickname to " .. ply:SteamName() .. ".",
                    NOTIFY_GENERIC
                )
            end

            if IsValid(caller) then caller:rpNotify("Nickname Removed", "The name \"" .. name .. "\" has been made available.", NOTIFY_ERROR) end
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

hook.Add("PlayerInitialSpawn", "RPGM.InitialisePlayerNickname", function(ply)
    local steamid = ply:SteamID64()

    RPGM.GetPlayerNameFromDB(steamid, function(name)
        if not IsValid(ply) then return end

        if not name then
            local steamName = ply:SteamName()
            RPGM.SetPlayerNameInDB(steamid, steamName, steamName)
            ply:setRPInt("Nickname", steamName)

            return
        end

        ply:setRPInt("Nickname", name)
        RPGM.SetPlayerNameInDB(steamid, name, ply:SteamName())
    end)
end)

hook.Remove("PlayerInitialSpawn", "RPGM.InitialisePlayerData") --Disable default player data storage behaviour to prevent nickname resets