
local PANEL = {}

AccessorFunc(PANEL, "nProgress", "Progress", FORCE_NUMBER)
AccessorFunc(PANEL, "bRightToLeft", "RightToLeft", FORCE_BOOL)
AccessorFunc(PANEL, "cBackgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "cForegroundColor", "ForegroundColor")

function PANEL:Init()
    self.Progress = 0
    self.BackgroundColor = color_black
    self.ForegroundColor = color_white
end

local lerp = Lerp
function PANEL:Think()
    self.SmoothProg = lerp(FrameTime() * 5, self.SmoothProg, self.Progress)
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self.BackgroundColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(self.ForegroundColor)

    local width = w * self.SmoothProg
    if self.RightToLeft then
        surface.DrawRect(0, w - width, width, h)
    else
        surface.DrawRect(0, 0, width, h)
    end
end

vgui.Register("RPGM.ProgressBar", PANEL, "Panel")