
local PANEL = {}

AccessorFunc(PANEL, "nProgress", "Progress", FORCE_NUMBER)
AccessorFunc(PANEL, "bRightToLeft", "RightToLeft", FORCE_BOOL)
AccessorFunc(PANEL, "cBackgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "cForegroundColor", "ForegroundColor")

function PANEL:Init()
    self.nProgress = 0
    self.cBackgroundColor = color_black
    self.cForegroundColor = color_white
end

local lerp = Lerp
function PANEL:Think()
    self.SmoothProg = lerp(FrameTime() * 5, self.SmoothProg, self.nProgress)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self.cBackgroundColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(self.cForegroundColor)

    local width = w * self.SmoothProg
    if self.RightToLeft then
        surface.DrawRect(0, w - width, width, h)
    else
        surface.DrawRect(0, 0, width, h)
    end
end

vgui.Register("RPGM.ProgressBar", PANEL, "Panel")