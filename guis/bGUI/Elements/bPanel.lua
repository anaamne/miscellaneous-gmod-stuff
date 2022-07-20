--[[
	This is the base panel for all other bGUI panels,
	it contains all of the basic functions
]]

local PANEL = {
	_bParent = nil,
	_bChildren = {},
	_bXPos = 0,
	_bYPos = 0,
	_bWidth = 0,
	_bHeight = 0,
	_bClickWidth = 0,
	_bClickHeight = 0,
	_bVisible = false,
	_bBackgroundColor = bGUI.Colors.Gray,
	_bOutlineColor = bGUI.Colors.Black,
	_bFont = "bGUI_Small",
	_bMarkedForDeletion = false
}

function PANEL:IsValid()
	return self ~= nil and not self._bMarkedForDeletion
end

function PANEL:Remove()
	self._bMarkedForDeletion = true

	for _, v in ipairs(self:GetChildren()) do
		v:Remove()
	end

	self = nil
end

-- Accessors

function PANEL:GetElementType()
	return self._bElementType
end

function PANEL:GetParent()
	return self._bParent
end

function PANEL:GetParentX() -- Quick anti error
	return IsValid(self:GetParent()) and self:GetParent():GetX() or 0
end

function PANEL:GetParentY()
	return IsValid(self:GetParent()) and self:GetParent():GetY() or 0
end

function PANEL:GetChildren()
	for i = #self._bChildren, 1, -1 do
		if not IsValid(self._bChildren[i]) then
			self._bChildren[i] = nil
		end
	end

	return self._bChildren
end

function PANEL:GetX()
	return self._bXPos
end

function PANEL:GetY()
	return self._bYPos
end

function PANEL:GetPos()
	return self:GetX(), self:GetY()
end

function PANEL:GetWidth()
	return self._bWidth
end

function PANEL:GetHeight()
	return self._bHeight
end

function PANEL:GetSize()
	return self:GetWidth(), self:GetHeight()
end

function PANEL:GetClickBounds()
	return self._bClickWidth, self._bClickHeight
end

function PANEL:GetVisible()
	return self._bVisible
end

function PANEL:GetBackgroundColor()
	return self._bBackgroundColor -- Make a copy?
end

function PANEL:GetOutlineColor()
	return self._bOutlineColor
end

function PANEL:GetFont()
	return self._bFont
end

-- Modifiers

function PANEL:SetParent(newParent)
	bGUI.CheckValueType(1, newParent, bGUI.GetType())

	local shouldUpdate = self:PreParentChanged(newParent)
	if not shouldUpdate then return end

	self._bParent = newParent

	newParent._bChildren[#newParent._bChildren + 1] = self

	self._bXPos = self._bXPos + self:GetParentX() -- Force override of PrePositionUpdate
	self._bYPos = self._bYPos + self:GetParentY()

	self:OnParentChanged(self._bParent)
end

function PANEL:SetX(newX)
	bGUI.CheckValueType(1, newX, "number")

	newX = math.Round(newX)

	local shouldMove = self:PrePositionUpdate(newX, self._bYPos)
	if not shouldMove then return end

	self._bXPos = newX + self:GetParentX()

	self:OnPositionUpdate(self._bXPos, self._bYPos)
end

function PANEL:SetY(newY)
	bGUI.CheckValueType(1, newY, "number")

	newY = math.Round(newY)

	local shouldMove = self:PrePositionUpdate(self._bXPos, newY)
	if not shouldMove then return end

	self._bYPos = newY + self:GetParentY()

	self:OnPositionUpdate(self._bXPos, self._bYPos)
end

function PANEL:SetPos(newX, newY)
	bGUI.CheckValueType(1, newX, "number")
	bGUI.CheckValueType(2, newY, "number")

	self:SetX(newX)
	self:SetY(newY)
end

function PANEL:SetWidth(newWidth)
	bGUI.CheckValueType(1, newWidth, "number")

	newWidth = math.Round(newWidth)

	local shouldResize = self:PreSizeUpdate(newWidth, self._bHeight)
	if not shouldResize then return end

	self._bWidth = newWidth
	self._bClickWidth = newWidth

	self:OnSizeUpdate(self._bWidth, self._bHeight)
end

function PANEL:SetHeight(newHeight)
	bGUI.CheckValueType(1, newHeight, "number")

	newHeight = math.Round(newHeight)

	local shouldResize = self:PreSizeUpdate(self._bWidth, newHeight)
	if not shouldResize then return end

	self._bHeight = newHeight
	self._bClickHeight = newHeight

	self:OnSizeUpdate(self._bWidth, self._bHeight)
end

function PANEL:SetSize(newWidth, newHeight)
	bGUI.CheckValueType(1, newWidth, "number")
	bGUI.CheckValueType(2, newHeight, "number")

	self:SetWidth(newWidth)
	self:SetHeight(newHeight)
end

function PANEL:SetClickBounds(newWidth, newHeight)
	bGUI.CheckValueType(1, newWidth, "number")
	bGUI.CheckValueType(2, newHeight, "number")

	self._bClickWidth = math.Round(newWidth)
	self._bClickHeight = math.Round(newHeight)
end

function PANEL:SetVisible(newState)
	bGUI.CheckValueType(1, newState, "boolean")

	local shouldUpdate = self:PreVisibilityUpdate(newState)
	if not shouldUpdate then return end

	self._bVisible = newState

	if newState then
		bGUI.RegisterElementPaint(self)
	end

	self:OnVisibilityUpdate(self._bVisible)
end

function PANEL:SetBackgroundColor(newColor)
	bGUI.AssertValue(1, getmetatable(newColor), bGUI.Registry.Color)

	self._bBackgroundColor = newColor -- Make a copy?
end

function PANEL:SetOutlineColor(newColor)
	bGUI.AssertValue(1, getmetatable(newColor), bGUI.Registry.Color)

	self._bOutlineColor = newColor
end

function PANEL:SetFont(newFont)
	bGUI.CheckValueType(1, newFont, "string")

	self._bFont = newFont
end

function PANEL:SetPaintPosition(newPos)
	bGUI.CheckValueType(1, newPos, "number")

	bGUI.SetElementPaintPosition(self, newPos)
end

function PANEL:ShiftPaintPosition(shift)
	bGUI.CheckValueType(1, shift, "number")

	bGUI.ShiftElementPaintPosition(self, shift)
end

-- Other functions

function PANEL:MoveToFront()
	bGUI.SetElementPaintPosition(self, #bGUI.PaintOrder)
end

function PANEL:MoveToBack()
	bGUI.SetElementPaintPosition(self, 1)
end

-- Hooks

function PANEL:Init()
	
end

function PANEL:PaintBackground(x, y, w, h) -- x position, y position, width and height. Relative to screen for unparented objects. For parented objects, the X and Y positions are relative to the parent's position
	surface.SetDrawColor(self:GetBackgroundColor())
	surface.DrawRect(x, y, w, h)
end

function PANEL:Paint(x, y, w, h)
	
end

function PANEL:PaintOverlay(x, y, w, h)

end

function PANEL:Think()

end

function PANEL:OnLeftClick()
	
end

function PANEL:OnRightClick()
	
end

function PANEL:PrePositionUpdate(newX, newY)
	return true
end

function PANEL:OnPositionUpdate(newX, newY)

end

function PANEL:PreSizeUpdate(newWidth, newHeight)
	return true
end

function PANEL:OnSizeUpdate(newWidth, newHeight)

end

function PANEL:PreVisibilityUpdate(newState)
	return true
end

function PANEL:OnVisibilityUpdate(newState)

end

function PANEL:PreParentChanged(newParent)
	return true
end

function PANEL:OnParentChanged(newParent)
	
end

-- Make it actually do something

bGUI.RegisterElement("bPanel", PANEL)