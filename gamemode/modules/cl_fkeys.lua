
local keyBinds = {
    ["gm_showhelp"] = "ShowHelp",
    ["gm_showteam"] = "ShowTeam",
    ["gm_showspare1"] = "ShowSpare1",
    ["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
    self.Sandbox.PlayerBindPress(self, ply, bind, pressed)
    bind = string.lower(bind)

    local bnd = string.match(bind, "gm_[a-z]+[12]?")
    if bnd and keyBinds[bnd] then
        hook.Call(keyBinds[bnd], GM or GAMEMODE)
    end

    if not RPGM.Config.VoiceWhenDead and not ply:Alive() and string.find(bind, "voicerecord") then return true end
end

local function handleFKeyPress(ply, keyNo)
    if ply ~= nil and ply ~= RPGM.Util.GetLocalPlayer() then return end
    if keyNo < 0 or keyNo > 4 then return end

    hook.Call("RPGM.FKeyPressed",  GM or GAMEMODE, keyNo)
end

function GM:ShowHelp(ply)
    handleFKeyPress(ply, 1)
end

function GM:ShowTeam(ply)
    handleFKeyPress(ply, 2)
end

function GM:ShowSpare1(ply)
    handleFKeyPress(ply, 3)
end

function GM:ShowSpare2(ply)
    handleFKeyPress(ply, 4)
end

local mouseX, mouseY
local cursorUnlocked = false

hook.Add("RPGM.FKeyPressed", "RPGM.UnlockCursorBind", function(keyNo)
    if keyNo ~= 3 then return end

    cursorUnlocked = not cursorUnlocked

    if cursorUnlocked then
        if not (mouseX and mouseY) then
            gui.SetMousePos(ScrW() * .5, ScrH() * .5)
        else
            gui.SetMousePos(mouseX, mouseY)
        end
    else
        mouseX, mouseY = gui.MousePos()
    end

    gui.EnableScreenClicker(cursorUnlocked)
end)