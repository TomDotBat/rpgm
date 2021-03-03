
util.AddNetworkString("RPGM.Talk")
util.AddNetworkString("RPGM.Chat")

function GM:PlayerSay(ply, text, teamOnly)
    if text == "" then return "" end

    local returnOverride = hook.Call("RPGM.PreCommandCheck", nil, ply, text, teamOnly)
    if returnOverride ~= nil then return returnOverride end

    if string.StartWith(text, RPGM.Config.ChatCommandPrefix) and RPGM.HandleCommands(ply, string.Right(text, #text - 1)) then
        return ""
    end

    if game.IsDedicated() then
        RPGM.Log(ply:Nick() .. " (" .. ply:SteamID() .. "): " .. text)
    end

    local isDead = not ply:Alive()
    if not RPGM.Config.ChatWhenDead and isDead then return "" end

    if teamOnly then
        local result = hook.Call("RPGM.PlayerTeamSay", nil, ply, text, isDead)
        if result ~= false and isstring(result) then
            return result
        end
    end

    if RPGM.Config.ChatUseRadius then
        RPGM.TalkToRange(ply, text)
        RPGM.TalkToPlayer(ply, ply, text)
    else
        RPGM.TalkToAll(ply, text)
    end

    hook.Call("RPGM.PostPlayerSay", nil, ply, text, teamOnly, isDead)
    return ""
end

function RPGM.TalkToAll(talker, text, nameOverride, prefixCol, prefix, disableColon)
    net.Start("RPGM.Talk")
        net.WriteEntity(talker)
        net.WriteString(text)
        net.WriteBool(not talker:Alive())
        net.WriteString(nameOverride or "")
        net.WriteBool(disableColon or false)
        if prefix then
            net.WriteColor(prefixCol or color_white)
            net.WriteString(prefix)
        end
    net.Broadcast()
end

function RPGM.TalkToRange(talker, text, range, nameOverride, prefixCol, prefix, disableColon)
    range = range or RPGM.Config.ChatRange

    local filter = {}
    for _, target in ipairs(RPGM.Util.FindPlayersInSphere(talker:EyePos(), range)) do
        if target == talker then continue end
        if not target:IsPlayer() or target:IsBot() then continue end

        local name = nameOverride or talker:name()
        if hook.Run("PlayerCanSeePlayersChat", (prefix and (prefix .. " ") or "") .. name .. ": " .. text, false, target, talker) ~= false then
            table.insert(filter, target)
        end
    end

    net.Start("RPGM.Talk")
        net.WriteEntity(talker)
        net.WriteString(text)
        net.WriteBool(not talker:Alive())
        net.WriteString(nameOverride or "")
        net.WriteBool(disableColon or false)
        if prefix then
            net.WriteColor(prefixCol or color_white)
            net.WriteString(prefix)
        end
    net.Send(filter)
end

function RPGM.TalkToPlayer(talker, receiver, text, prefixCol, prefix, talkerNameOverride, disableColon)
    net.Start("RPGM.Talk")
        net.WriteEntity(talker)
        net.WriteString(text)
        net.WriteBool(not talker:Alive())
        net.WriteString(talkerNameOverride or "")
        net.WriteBool(disableColon or false)
        if prefix then
            net.WriteColor(prefixCol or color_white)
            net.WriteString(prefix)
        end
    net.Send(receiver)
end

function RPGM.MessagePlayer(receiver, text, textCol, prefixCol, prefix)
    net.Start("RPGM.Chat")
        net.WriteString(text)
        if prefix then
            net.WriteColor(textCol or color_white)
            net.WriteString(prefix)
            net.WriteColor(prefixCol or color_white)
        else
            if textCol then
                net.WriteColor(textCol or color_white)
            end
        end
    net.Send(receiver)
end