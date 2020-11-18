
function GM:OnPlayerChat() end

local function safeText(text)
    return string.match(text, "^#([a-zA-Z_]+)$") and text .. " " or text
end

local messageColor = RPGM.Config.ChatMessageColor
local deadMessageColor = RPGM.Config.ChatMessageDeadColor
local getTeamColor = team.GetColor

net.Receive("RPGM.Talk", function()
    local talker = net.ReadEntity()
    if not IsValid(talker) then return end

    local text = safeText(net.ReadString())
    local talkerDead = net.ReadBool()

    local talkerName
    if net.BytesLeft() == 0 then
        talkerName = talker:Nick()
    else
        local override = net.ReadString()
        if isstring(override) and override != "" then
            talkerName = override
        end
    end

    hook.Call("OnPlayerChat", GAMEMODE, talker, text, false, talkerDead)

    if net.BytesLeft() != 0 then
        chat.AddText(
            net.ReadColor(), net.ReadString() .. " ",
            talkerDead and deadMessageColor or getTeamColor(talker:Team()), talkerName,
            color_white, ": ",
            talkerDead and deadMessageColor or messageColor, text
        )

        return
    end

    chat.AddText(
        talkerDead and deadMessageColor or getTeamColor(talker:Team()), talkerName,
        color_white, ": ",
        talkerDead and deadMessageColor or messageColor, text
    )

    chat.PlaySound()
end)

local defaultPrefixCol = Color(52, 168, 235)

net.Receive("RPGM.Chat", function()
    local text = net.ReadString()

    local textColor = net.ReadColor()
    if not IsColor(textColor) then textColor = messageColor end

    if net.BytesLeft() != 0 then
        local prefixCol, prefix = net.ReadColor(), net.ReadString()

        chat.AddText(
            prefixCol, prefix .. " ",
            textColor, text
        )
        MsgC(prefixCol, prefix .. " ", textColor, text .. "\n")

        return
    end

    chat.AddText(textColor, text)
    MsgC(defaultPrefixCol, "[RPGM] ", textColor, text .. "\n")

    chat.PlaySound()
end)