
function GM:PlayerStartVoice(ply)
    if ply == RPGM.Util.GetLocalPlayer() then
        ply.RPGMIsTalking = true
        return
    end

    self.Sandbox.PlayerStartVoice(self, ply)
end

function GM:PlayerEndVoice(ply)
    if ply == RPGM.Util.GetLocalPlayer() then
        ply.RPGMIsTalking = false
        return
    end

    self.Sandbox.PlayerEndVoice(self, ply)
end