
if system.IsWindows() then
    local osDate = os.date
    local replace = function(txt)
        if txt == "%%" then return txt end
        return ""
    end

    function os.date(format, time, ...)
        if (isstring(format) or isnumber(format)) then
            format = string.gsub(format, "%%[^aAbBcdHIjmMpSUwWxXyYz]", replace)
        elseif (format ~= nil) then
            argError(Val, 1, "string")
        end

        if (not (time == nil or isnumber(time)) and (not isstring(time) or tonumber(time) == nil)) then
            argError(Val, 2, "number")
        end

        return osDate(format, time, ...)
    end
end

if game.SinglePlayer() or GetConVar("sv_lan"):GetBool() then
    local plyMeta = FindMetaTable("Player")

    if SERVER then
        local sid64 = plyMeta.SteamID64

        function plyMeta:SteamID64(...)
            return sid64(self, ...) or "0"
        end
    end

    local aid = plyMeta.AccountID

    function plyMeta:AccountID(...)
        return aid(self, ...) or 0
    end
end

hook.Remove("PlayerSay", "ULXMeCheck")

concommand.Remove("gm_save")

if game.GetMap() == "rp_downtown_v4c_v2" then
    for k, v in pairs(ents.FindByClass("info_player_terrorist")) do
        v:Remove()
    end
end

hook.Add("PropBreak", "RPGM.AntiConstraintCrash", function(attacker, ent)
    if IsValid(ent) and ent:GetPhysicsObject():IsValid() then
        constraint.RemoveAll(ent)
    end
end)