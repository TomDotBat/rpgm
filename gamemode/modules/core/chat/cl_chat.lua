
function GM:OnPlayerChat() end

local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

local messageColor = RPGM.Config.ChatMessageColor
local deadMessageColor = RPGM.Config.ChatMessageDeadColor
local getTeamColor = team.GetColor

net.Receive("RPGM.Talk", function()
    local talker = net.ReadEntity()
    talker = IsValid(talker) and talker or LocalPlayer()

    local text = safeText(net.ReadString())
    local talkerDead = net.ReadBool()

    local talkerName
    local nameOverride = net.ReadString()
    if isstring(nameOverride) and nameOverride ~= "" then
        talkerName = nameOverride
    else
        talkerName = talker:Nick()
    end

    local prefixCol, prefix
    if net.BytesLeft() ~= 0 then
        prefixCol, prefix = net.ReadColor(), net.ReadString()
    end

    if text and text ~= "" and IsValid(talker) then
        if hook.Call("OnPlayerChat", GAMEMODE, talker, text, false, talkerDead) == true then return end
    else
        if hook.Call("ChatText", GAMEMODE, 0, prefix, prefix, "rpgm") == true then return end
    end

    if prefix then
        chat.AddText(
            prefixCol, prefix .. " ",
            talkerDead and deadMessageColor or getTeamColor(talker:Team()), talkerName,
            color_white, ": ",
            talkerDead and deadMessageColor or messageColor, text
        )

        chat.PlaySound()
        return
    end

    chat.AddText(
        talkerDead and deadMessageColor or getTeamColor(talker:Team()), talkerName,
        color_white, ": ",
        talkerDead and deadMessageColor or messageColor, text
    )

    chat.PlaySound()
end)

net.Receive("RPGM.Chat", function()
    local text = net.ReadString()

    local textColor = net.ReadColor()
    if not IsColor(textColor) then textColor = messageColor end

    if net.BytesLeft() ~= 0 then
        local prefixCol, prefix = net.ReadColor(), net.ReadString()

        chat.AddText(
            prefixCol, prefix .. " ",
            textColor, text
        )
        RPGM.Log(text, prefixCol)

        return
    end

    chat.AddText(textColor, text)
    RPGM.Log(text)

    chat.PlaySound()
end)