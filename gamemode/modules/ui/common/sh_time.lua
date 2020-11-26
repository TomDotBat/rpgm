
if SERVER then
	util.AddNetworkString("RPGM.OSTime")

	hook.Add("PlayerInitialSpawn", "RPGM.OSTime", function(ply)
		net.Start("RPGM.OSTime")
			net.WriteFloat(os.time())
			net.WriteFloat(CurTime())
		net.Send(ply)
	end)
else
	RPGM._SVRDiff = RPGM._SVRDiff or 0

	net.Receive("RPGM.OSTime", function()
		local osTime = net.ReadFloat()
		local curTime = net.ReadFloat()

		RPGM._SVRDiff = os.time() - osTime + curTime - CurTime()
	end)

	function RPGM.GetServerTime()
		return os.time() - RPGM._SVRDiff
	end
end
