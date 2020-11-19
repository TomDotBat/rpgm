
function GM:PlayerSetModel(ply)
    local teamTbl = ply:getTeamClass()
    if not teamTbl then return self.Sandbox.PlayerSetModel(self, ply) end

    local model = RPGM.CallClassFunction(teamTbl, "setModel", ply)
    if model then
        ply:SetModel(model)
        return
    end

    if RPGM.Config.ForcePlayerModel then
        model = teamTbl:getModel()
    else
        model = player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel"))
    end

    ply:SetModel(model)
    self.Sandbox.PlayerSetModel(self, ply)
    ply:SetupHands()
end