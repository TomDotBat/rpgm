
function RPGM.GetPlayerMoney(ply, callback)
	RPGM.CheckType(ply, "Player")

	local amount = tonumber(ply:getRPInt("Money", -1))

	if amount < 0 then
		RPGM.GetMoneyFromDB(ply:SteamID64(), function(pnts)
			ply:setRPInt("Money", pnts)

			if callback then callback(pnts) end
		end)
	else
		if callback then callback(amount) end
	end
end

function RPGM.SetPlayerMoney(ply, amount, callback)
	RPGM.CheckType(ply, "Player")
	RPGM.CheckType(amount, "number")

	ply:setRPInt("Money", amount)
	RPGM.SetMoneyInDB(ply:SteamID64(), amount, ply:Name(), callback)
end

function RPGM.GivePlayerMoney(ply, amount, callback)
	RPGM.CheckType(ply, "Player")
	RPGM.CheckType(amount, "number")

	RPGM.GetPlayerMoney(ply, function(curAmount)
		 RPGM.SetPlayerMoney(ply, curAmount + amount, callback)
	end)
end

function RPGM.CanPlayerAffordMoney(ply, amount, callback)
	RPGM.CheckType(ply, "Player")
	RPGM.CheckType(amount, "number")

	RPGM.GetPlayerMoney(ply, function(curAmount)
		callback(curAmount >= amount)
	end)
end

function RPGM.RemovePlayerMoney(ply, amount, callback)
	RPGM.CheckType(ply, "Player")
	RPGM.CheckType(amount, "number")

	RPGM.CanPlayerAffordMoney(ply, amount, function(canAfford)
		if canAfford then
			RPGM.GivePlayerMoney(ply, -amount, callback)
		else
			callback(false)
		end
	end)
end

function RPGM.ResetPlayerMoney(ply, callback)
	RPGM.CheckType(ply, "Player")

	RPGM.SetPlayerMoney(ply, 0, function()
		RPGM.LogWarning("Player " .. ply:Name() .. " just had their money reset.")
		debug.Trace()

		callback()
	end)
end

hook.Add("PlayerInitialSpawn", "RPGM.InitialisePlayerMoney", function(ply)
	RPGM.GetPlayerMoney(ply, function(amount)
		ply:setRPInt("Money", amount)
	end)
end)