
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Money"
ENT.Category = "RPGM"
ENT.Author = "Tom.bat"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.IsRPGMMoney = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Amount")
end