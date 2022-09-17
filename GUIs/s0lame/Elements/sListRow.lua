if not s0lame then return end

local PANEL = {}

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetText("")
	self:SetTextAlignment(TEXT_ALIGN_LEFT)

	self:SetAutoSize(false)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawLine(x, y + h, x + w, y + h)
end

function PANEL:OnLeftClick()

end

function PANEL:OnParentChanged(_, NewParent)
	self:SetSize(NewParent:GetWidth(), 15)
end

return s0lame.RegisterElement("sListRow", PANEL, "sButton")