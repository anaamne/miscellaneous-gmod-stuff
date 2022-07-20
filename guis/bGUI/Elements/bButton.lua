local PANEL = {}

function PANEL:Init()
	self:SetSize(75, 20)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetLabelColor())

	local label = self:GetLabel()
	local tw, th = surface.GetTextSize(label)

	surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + ((h / 2) - (th / 2)))
	surface.DrawText(label)
end

bGUI.RegisterElement("bButton", PANEL, "bLabel")