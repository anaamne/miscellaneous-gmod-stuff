local PANEL = {
	_bChecked = false
}

function PANEL:GetValue()
	return self._bChecked
end

function PANEL:SetValue(newValue)
	bGUI.CheckValueType(1, newValue, "boolean")

	local shouldChange = self:PreValueChange(newValue)
	if not shouldChange then return end

	self._bChecked = newValue

	self:OnValueChange(self._bChecked)
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, h, h)

	if self:GetValue() then
		surface.SetDrawColor(bGUI.Colors.White)
		surface.DrawRect(x + 3, y + 3, h - 6, h - 6)
	end

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, h, h)
end

function PANEL:Init()
	self:SetBackgroundColor(bGUI.Colors.DarkGray)

	self:SetSize(100, 12)
	self:SetClickBounds(12, 12)
end

function PANEL:Paint(x, y, _, h)
	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetLabelColor())

	local label = self:GetLabel()
	local _, th = surface.GetTextSize(label)

	surface.SetTextPos(x + h + 5, y + ((h / 2) - (th / 2)))
	surface.DrawText(label)
end

function PANEL:OnLeftClick()
	self:SetValue(not self:GetValue())
end

function PANEL:OnSizeUpdate(_, newHeight)
	self:SetClickBounds(newHeight, newHeight)
end

function PANEL:PreValueChange(newValue)
	return true
end

function PANEL:OnValueChange(newValue)

end

bGUI.RegisterElement("bCheckbox", PANEL, "bButton")