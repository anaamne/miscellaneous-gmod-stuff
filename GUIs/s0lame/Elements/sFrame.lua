if not s0lame then return end

local PANEL = {
	Draggable = true,
	Dragging = false,

	Title = "sFrame",
	TitleColor = s0lame.Colors.White,

	TitleBarColor = s0lame.Colors.ControlDark,

	CloseButton = nil,
	CloseButtonVisible = true
}

--------------------------- Accessors ---------------------------

function PANEL:GetDraggable()
	return self.Draggable
end

function PANEL:GetDragging()
	return s0lame.GetDragging() and s0lame.GetDraggingObject() == self
end

function PANEL:GetTitle()
	return self.Title
end

function PANEL:GetTitleColor()
	return self.TitleColor
end

function PANEL:GetTitleBarColor()
	return self.TitleBarColor
end

function PANEL:GetShowCloseButton()
	return self.CloseButtonVisible
end

--------------------------- Modifiers ---------------------------

function PANEL:SetDraggable(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.Draggable = NewState
end

function PANEL:SetTitle(NewTitle)
	s0lame.CheckValueType(1, NewTitle, "string")

	local OldTitle = self:GetTitle()

	self.Title = NewTitle

	self:OnTitleChanged(OldTitle, NewTitle)
end

function PANEL:SetTitleColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.TitleColor = NewColor
end

function PANEL:SetTitleBarColor(NewColor)
	s0lame.CheckValueType(1, NewColor, "Color")

	self.TitleBarColor = NewColor
end

function PANEL:SetShowCloseButton(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	self.CloseButtonVisible = NewState
	self.CloseButton:SetVisible(NewState)
end

--------------------------- Hooks ---------------------------

function PANEL:PostInit()
	self:SetMargin(0, 20, 0, 0)

	self.CloseButton = s0lame.Create("sButton", self)
	self.CloseButton:SetSize(15, 15)
	self.CloseButton:SetPos(self:GetWidth() - 18, 3)
	self.CloseButton:SetVisible(true)
	self.CloseButton:SetText("X")
	self.CloseButton:SetScrollable(false)
	self.CloseButton:SetBackgroundColor(s0lame.Colors.Red)
	self.CloseButton:SetIgnoreParentBounds(true)

	self.CloseButton.OnLeftClick = function()
		self:SetVisible(false)
	end
end

function PANEL:OnTitleChanged(OldTitle, NewTitle)
	-- For override
end

function PANEL:PaintOverlay(x, y, w, h)
	surface.SetDrawColor(self:GetTitleBarColor())
	surface.DrawRect(x, y, w, 20)

	draw.DrawText(self:GetTitle(), self:GetFont(), x + 5, y + 4, self:GetTitleColor())

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawOutlinedRect(x, y, w, h)
	surface.DrawLine(x, y + 20, x + w, y + 20)

	if self:GetShowCloseButton() then
		local cx, cy = self.CloseButton:GetPos()
		local cw, ch = self.CloseButton:GetSize()

		self.CloseButton:PaintBackground(cx, cy, cw, ch)
		self.CloseButton:Paint(cx, cy, cw, ch)
		self.CloseButton:PaintOverlay(cx, cy, cw, ch)
	end
end

function PANEL:Think()
	if self:GetDragging() then
		local ox = s0lame.Mouse.Dragging.Origin.X
		local oy = s0lame.Mouse.Dragging.Origin.Y

		self:SetPos(gui.MouseX() - ox, gui.MouseY() - oy)
	end
end

function PANEL:OnLeftClick()
	if not self:GetDraggable() then return end

	local x, y = self:GetPos()
	local w = self:GetWidth()

	if s0lame.CursorInBounds(x, y, x + w, y + 20) and s0lame.RequestDragging(self) then
		local ox, oy = s0lame.GetDraggingOrigin()

		if IsValid(self:GetParent()) then
			local px, py = self:GetParent():GetPos()

			x = x - px
			y = y - py
		end

		s0lame.SetDraggingOrigin(ox - x, oy - y)
	end
end

function PANEL:OnSizeChanged(_, _, NewWidth, NewHeight)
	self:BroadcastSizeChange(NewWidth, NewHeight - 20)
	self.CloseButton:SetX(NewWidth - 18)
end

return s0lame.RegisterElement("sFrame", PANEL, "sPanel")