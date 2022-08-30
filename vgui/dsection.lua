--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local PANEL = {}

function PANEL:SetFont(Font)
	self._Font = Font
end

function PANEL:SetText(Text)
	self._Text = Text
end

function PANEL:SetTextColor(Color)
	self._TextColor = Color
end

function PANEL:SetOutlineColor(Color)
	self._OutlineColor = Color
end

function PANEL:GetFont()
	return self._Font
end

function PANEL:GetText()
	return self._Text
end

function PANEL:GetTextColor()
	return self._TextColor
end

function PANEL:GetOutlineColor()
	return self._OutlineColor
end

function PANEL:Init()
	self:SetPaintBackground(false)

	self:SetPaintBackgroundEnabled(false)
	self:SetPaintBorderEnabled(false)

	self:SetText("Section")
	self:SetFont("DermaDefault")

	self:SetTextColor(Color(209, 209, 209, 255)) -- Default Derma text color
	self:SetOutlineColor(Color(0, 0, 0, 255))
end

function PANEL:Paint(Width, Height)
	Width = Width - 1
	Height = Height - 1

	surface.SetFont(self:GetFont())
	surface.SetTextColor(self:GetTextColor())

	local title = self:GetText()
	local tw, th = surface.GetTextSize(title)
	local tx, ty = 8, 5 - (th / 2)

	surface.SetTextPos(tx, ty)
	surface.DrawText(title)

	ty = ty + (th / 2)

	surface.SetDrawColor(self:GetOutlineColor())
	surface.DrawLine(0, ty, tx - 2, ty)
	surface.DrawLine(tx + tw, ty, Width, ty)
	surface.DrawLine(Width, ty, Width, Height)
	surface.DrawLine(Width, Height, 0, Height)
	surface.DrawLine(0, Height, 0, ty)
end

derma.DefineControl("DSection", "", PANEL, "DPanel")
