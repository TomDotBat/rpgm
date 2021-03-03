
local lang = gmodI18n.getAddon("rpgm")

local disallowedNames = RPGM.Config.DisallowedNicknames
hook.Add("RPGM.CanChangeNickname", "RPGM.NicknameRestrictions", function(ply, name)
    if disallowedNames[string.lower(name)] then return false, lang:getString("isBlacklisted") end
    if not string.match(name, "^[a-zA-ZЀ-џ0-9 ]+$") then return false, lang:getString("containsIllegalChars") end

    local len = string.len(name)
    if len > 30 then return false, lang:getString("isToLong") end
    if len < 3 then return false, lang:getString("isToShort") end
end)

function RPGM.ChangeNickname(ply, name, caller)
    if name == "" then RPGM.ResetNickname(caller, ply:name()) end

    caller = caller or ply

    local success, reason = hook.Call("RPGM.CanChangeNickname", nil, ply, name)
    if success == false then
        caller:rpNotify(lang:getString("invalidNickname"), lang:getString("nameProvidedInvalid", {reason = reason}), NOTIFY_ERROR)
        return
    end

    RPGM.GetPlayerNameExists(name, function(exists)
        if not (IsValid(ply) and IsValid(caller)) then return end
        if exists then
            caller:rpNotify(lang:getString("nicknameInUse"), lang:getString("nameProvidedInUse"), NOTIFY_ERROR)
            return
        end

        local oldName = ply:name()
        RPGM.SetPlayerNameInDB(ply:SteamID64(), name, ply:steamName(), function()
            if not IsValid(ply) then return end
            ply:setRPString("Nickname", name)
            hook.Call("RPGM.NicknameChanged", nil, ply, oldName, name, ply:steamName())
        end)
    end)
end

function RPGM.ResetNickname(caller, name)
    RPGM.GetPlayerSteamIDFromDB(name, function(steamid)
        if not steamid then
            if IsValid(caller) then caller:rpNotify(lang:getString("nicknameNotFound"), lang:getString("nameProvidedNotInUse"), NOTIFY_ERROR) end
            return
        end

        local ply = player.GetBySteamID64(steamid)
        RPGM.SetPlayerNameInDB(steamid, "", IsValid(ply) and ply:steamName() or "", function()
            if IsValid(ply) then
                ply:setRPString("Nickname", "")
                ply:rpNotify(
                    lang:getString("nicknameReset"),
                    lang:getString("nicknameResetBy", {
                        by = IsValid(caller) and (" " .. lang:getString("byAnAdmin")) or ""
                    }),
                    NOTIFY_ERROR
                )

                local filter = RecipientFilter()
                filter:AddAllPlayers()
                filter:RemovePlayer(ply)
                if IsValid(caller) then filter:RemovePlayer(caller) end

                RPGM.Notify(
                    filter, lang:getString("nicknameChange"),
                    lang:getString("changedOldNameTo", {oldName = name, newName = ply:steamName()}),
                    NOTIFY_GENERIC
                )
            end

            if IsValid(caller) then caller:rpNotify(lang:getString("nicknameRemoved"), lang:getString("nicknameMadeAvailable", {name = name}), NOTIFY_ERROR) end
        end)
    end)
end

hook.Add("RPGM.NicknameChanged", "RPGM.AlertNicknameChanges", function(ply, oldName, newName, steamName)
    RPGM.Notify(
        player.GetAll(), lang:getString("nicknameChange"),
        lang:getString("changedOldNameTo", {oldName = oldName, newName = newName}),
        NOTIFY_GENERIC
    )
end)

hook.Add("PlayerInitialSpawn", "RPGM.InitialisePlayerNickname", function(ply)
    local steamid = ply:SteamID64()

    RPGM.GetPlayerNameFromDB(steamid, function(name)
        if not IsValid(ply) then return end

        if not name then
            local steamName = ply:steamName()
            RPGM.SetPlayerNameInDB(steamid, steamName, steamName)
            ply:setRPInt("Nickname", steamName)

            return
        end

        ply:setRPInt("Nickname", name)
        RPGM.SetPlayerNameInDB(steamid, name, ply:steamName())
    end)
end)

hook.Remove("PlayerInitialSpawn", "RPGM.InitialisePlayerData") --Disable default player data storage behaviour to prevent nickname resets