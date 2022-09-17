if not s0lame then return end

local PANEL = {}

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")

	self:SetAutoSize(false)
	
	self:SetSize(150, 150)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

return s0lame.RegisterElement("sList", PANEL, "sButton")