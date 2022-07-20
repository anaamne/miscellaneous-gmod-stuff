local PANEL = {
	_bValue = 0,
	_bMinValue = 0,
	_bMaxValue = 100,
	_bDecimals = 0,
	_bHandleX = 0
}

function PANEL:GetValue()
	return self._bValue
end

function PANEL:GetMinimumValue()
	return self._bMinValue
end

function PANEL:GetMaximumValue()
	return self._bMaxValue
end

function PANEL:GetDecimals()
	return self._bDecimals
end

function PANEL:SetValue(newValue)
	bGUI.CheckValueType(1, newValue, "number")

	local shouldChange = self:PreValueChange(newValue)
	if not shouldChange then return end

	self._bValue = math.Round(math.Clamp(newValue, self:GetMinimumValue(), self:GetMaximumValue()), self:GetDecimals())

	self:OnValueChange(self._bValue)
end

function PANEL:SetMinimumValue(newValue)
	bGUI.CheckValueType(1, newValue, "number")

	self._bMinValue = newValue
end

function PANEL:SetMaximumValue(newValue)
	bGUI.CheckValueType(1, newValue, "number")

	self._bMaxValue = newValue
end

function PANEL:SetDecimals(newValue)
	bGUI.CheckValueType(1, newValue, "number")

	self._bDecimals = newValue
end

function PANEL:Init()
	self:SetSize(75, 13)
	self:SetBackgroundColor(bGUI.Colors.DarkGray)

	self:SetLabel("Slider")
end

function PANEL:PaintBackground(x, y, w, h)
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	local cy = y + (h / 2)

	surface.SetDrawColor(bGUI.Colors.White)
	surface.DrawRect(x + 4, cy - 1, w - 8, 3)

	surface.DrawRect(x + 4 + self._bHandleX, y, 3, h)

	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetLabelColor())

	local label = self:GetLabel()
	local tw, th = surface.GetTextSize(label)

	surface.SetTextPos(x, y - th)
	surface.DrawText(label)

	local value = self:GetValue()
	tw, th = surface.GetTextSize(value)

	surface.SetTextPos((x + w) - tw, y - th)
	surface.DrawText(value)
end

function PANEL:Think()
	if bGUI.GetDraggingActive() and bGUI.GetDraggingObject() == self then
		local x = self:GetX() + 4

		local min = self:GetMinimumValue()
		local max = self:GetMaximumValue()
		local decimals = self:GetDecimals()

		local sLen = self:GetWidth() - 11

		local newX = min + ((gui.MouseX() - x) / (((x + sLen) - x) / (max - min)))

		if newX == -0 then newX = 0 end -- Fix jank

		self:SetValue(newX)

		local newHandle = math.Round(((self:GetValue() - min) * (((x + sLen) - x) / (max - min))))

		self._bHandleX = newHandle
	end
end

function PANEL:OnLeftClick()
	if not bGUI.GetDraggingActive() then
		bGUI.MouseDown.Dragging.Object = self
		bGUI.MouseDown.Dragging.Active = true

		bGUI.MouseDown.Dragging.Origin.x = self:GetX()
		bGUI.MouseDown.Dragging.Origin.y = self:GetY()
	end
end

function PANEL:PreValueChange(newValue)
	return true
end

function PANEL:OnValueChange(newValue)
	
end

bGUI.RegisterElement("bSlider", PANEL, "bButton")