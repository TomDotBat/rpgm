
function GM:PlayerSetModel(ply)
    ply:SetModel("models/player/charple.mdl")
    self.Sandbox.PlayerSetModel(self, ply)
    ply:SetupHands()
end