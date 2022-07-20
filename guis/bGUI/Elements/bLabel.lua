local PANEL = {
	_bLabel = "Label",
	_bLabelColor = bGUI.Colors.Black
}

function PANEL:GetLabel()
	return self._bLabel
end

function PANEL:GetLabelColor()
	return self._bLabelColor
end

function PANEL:SetLabel(newLabel)
	bGUI.CheckValueType(1, newLabel, "string")

	self._bLabel = newLabel
end

function PANEL:SetLabelColor(newColor)
	bGUI.AssertValue(1, getmetatable(newColor), bGUI.Registry.Color)

	self._bLabelColor = newColor
end

function PANEL:Paint(x, y)
	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetLabelColor())

	surface.SetTextPos(x, y)
	surface.DrawText(self:GetLabel())
end

bGUI.RegisterElement("bLabel", PANEL, "bPanel")