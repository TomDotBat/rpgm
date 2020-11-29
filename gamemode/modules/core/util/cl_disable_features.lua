
local disabledElements = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudSuitPower"] = true,
    ["CHUDQuickInfo"] = true,
    ["CHudDamageIndictator"] = true,
    ["CHudZoom"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["CHudDeathNotice"] = true
}

function GM:HUDShouldDraw(name)
    if disabledElements[name] then return false
    else return self.Sandbox.HUDShouldDraw(self, name) end
end

function GM:HUDDrawTargetID()
    return false
end

function GM:DrawDeathNotice(x, y)
    if not RPGM.Config.ShowKillFeed then return end
    self.Sandbox.DrawDeathNotice(self, x, y)
end

function GM:HUDPaint()
    self.Sandbox.HUDPaint(self)
end