--[[
	leme's FlowHooks vgui base

	Valid Objects (These support the functions of their default Derma counterparts as well. If no functions are listed under it then it simply doesn't have any custom FlowHooks ablities)
		FHFrame (DFrame that comes with a content frame) (Not parented to anything)
			Functions:
				- SetAccentColor(newColor)			=>			Sets the frame's accent color (Added fgui elements will use the same color)
				- GetAccentColor()					=>			Returns the frame's accent color
				- SetTitle(newTitle)				=>			Modified version of DFrame:SetTitle (Works the exact same)
				- GetTitle()						=>			Modified version of DFrame:GetTitle (Works the exact same)
				- SetTitleColor(newColor)			=>			Sets the frame's title color
				- GetTitleColor()					=>			Returns the frame's title color
				- SetFont(newFont)					=>			Set the frame's font to be used for all added fgui elements
				- GetFont()							=>			Modified version of Panel:GetFont - Returns the frame's fgui child font
				- GetContentFrame()					=>			Returns the frame's DPanel content frame (Gray box in the middle)
				- ShowCloseButton(newState)			=>			Modified version of DFrame:ShowCloseButton (Works the exact same)

		FHContentFrame (DPanel)
			Functions:
				- SetDrawOutline(newState)			=>			Sets rendering out the content frame's outline
				- GetDrawOutline()					=>			Returns current rendering state of the content frame's outline

		FHSection (DPanel with an FHContentFrame inside)
			Functions:
				- SetTitle(newTitle)				=>			Sets the title of the section
				- GetTitle()						=>			Returns the title of the section
				- GetContentFrame()					=>			Return's the section's content frame

		FHCheckBox (DCheckBoxLabel; DO *NOT* OVERRIDE OnChange FOR THIS OBJECT! USE FHOnChange INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the checkbox's table key to update on click (Returns the checkbox state (True / False))
				- GetVarTable()						=>			Returns the checkbox's VarTable and key name

		FHSlider (DNumSlider; DO *NOT* OVERRIDE OnValueChanged FOR THIS OBJECT! USE FHOnValueChanged INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the slider's table key to update on value change (Returns the value of the slider)
				- GetVarTable()						=>			Returns the slider's VarTable and key name

		FHDropDown (DComboBox; DO *NOT* OVERRIDE OnSelect FOR THIS OBJECT! USE FHOnSelect INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the dropdown's table key to update on value change (Returns the text of the option)
				- GetVarTable()						=>			Returns the dropdown's VarTable and key name
				- AddChoice()						=>			A modified version of DComboBox:AddChoice (Works the exact same)

		FHTabbedMenu (DPropertySheet)
			Functions:
				- SetVarTable(table, key)			=>			Sets the tabbed menu's table key to update on value change (Returns the name of the tab)
				- GetVarTable()						=>			Returns the tabbed menu's VarTable and key name
				- AddTab(newTabName)				=>			Creates a tab and returns the content frame of the tab (Works like DPropertySheet:AddSheet)
				- SetTabBackground(newState)		=>			Sets rendering of the background behind tabs
				- GetTabBackground()				=>			Returns current rendering state of the background behind tabs
				- SetValue(value)					=>			Used internally to update the tabbed menu to the specified tab

		FHList (DListView; DO *NOT* OVERRIDE OnRowSelected FOR THIS OBJECT! USE FHOnRowSelected INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the list's table key to update on value change (Returns DListView_Line objects instead of the index)
				- GetVarTable()						=>			Returns the list's VarTable and key name
				- AddColumn(newColumn, position)	=>			Modified version of DListView:AddColumn (Works the exact same)
				- AddLine(...)						=>			Modified version of DListView:AddLine (Works the exact same)
				- SetValue(value)					=>			Used internally to update the list to the specified line (Works the same as DListView:SelectItem)

		FHTextBox (DTextEntry; DO *NOT* OVERRIDE OnValueChanged FOR THIS OBJECT! USE FHOnValueChanged INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the text box's table key to update on value change (Returns the text inside the text box)
				- GetVarTable()						=>			Returns the text box's VarTable and key name

		FHButton (DButton)
			Functions:
				- SetCallback(function)				=>			Sets the callback function for the button (Same as overriding DoClick, you can do either to accomplish the same task)

		FHColorButton (DButton; DO *NOT* OVERRIDE DoClick FOR THIS OBJECT!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the color button's table key to update on value change (Returns the color)
				- GetVarTable()						=>			Returns the color button's VarTable and key name
				- SetColor(newColor)				=>			Sets the color button's color (Also updates the VarTable if provided)
				- GetColor()						=>			Returns the color button's color
				- SetValue(value)					=>			Used internally to update the button's color to the specified color (Works the same as FHColorButton:SetColor)

		FHColorPicker (DFrame; Used internally for FHFrames and FHColorButtons, may cause jank if used manually) (Not parented to anything)
			Functions:
				- Invoke(table, key)				=>			Used internally to show the color picker and sets its VarTable and key to update when OK is clicked
				- GetFont()							=>			Used internally to get the color picker's parent frame's font
				- GetContentFrame()					=>			Used internally to parent the color picker's components

		FHBinder (DBinder; DO *NOT* OVERRIDE OnChange FOR THIS OBJECT! USE FhOnChange INSTEAD!)
			Functions:
				- SetVarTable(table, key)			=>			Sets the binder's table key to update on value change (Returns the key code instead of key name)
				- GetVarTable()						=>			Returns the binder's VarTable and key name
				- SetLabel(newLabel)				=>			Sets the binder's overhead label
				- GetLabel()						=>			Returns the binder's overhead label

		FHMiniMenu (DFrame) (Not parented to anything)
			Functions:
				- SetFont(newFont)					=>			Set the mini menu's font to be used
				- GetFont()							=>			Modified version of Panel:GetFont - Returns the mini menu's fgui font
				- SetTextColor(newColor)			=>			Sets the mini menu's text color
				- GetTextColor()					=>			Returns the mini menu's text color
				- AddColumn(columnName, index)		=>			Creates a column at optional index (Places at end if no index is given)
				- AddRow(...)						=>			Creates a row with given data (Format as a table with 1 key for each column, ex: {"Column 1", "Column 2", "Column 3"})
				- SetBackgroundAlpha(newAlpha)		=>			Sets backround alpha for the rows in the mini menu

]]

fgui = fgui or {}

surface.CreateFont("FlowHooks", {
	font = "Verdana",
	size = 12,
	antialias = false,
	outline = true
})

fgui.timer = "fgui_SlowTick"
fgui.vth = {} -- VarTable holders

fgui.colors = {
	black = Color(0, 0, 0, 255),
	white = Color(255, 255, 255, 255),

	accent = Color(255, 150, 0, 255), -- Default orange accent

	back = Color(45, 45, 45, 255), -- Menu backing
	back_min = Color(55, 55, 55, 255),
	back_obj = Color(24, 24, 24, 255), -- Object backing
	outline = Color(0, 0, 0, 255), -- Regular outlines
	outline_b = Color(12, 12, 12, 255), -- Special outlines (I didn't know what to call this)
	gray = Color(150, 150, 150, 255) -- For text boxes
}

fgui.colors.grey = fgui.colors.gray -- We are anonymous

fgui.functions = {
	GetFurthestParent = function(base) -- Used to get FHFrame's accent color from any child object
		if not base then
			return error("Invalid Panel Provided")
		end

		local cparent = base:GetParent()

		if cparent:GetParent() == vgui.GetWorldPanel() then
			return cparent
		end

		return fgui.functions.GetFurthestParent(cparent)
	end,

	CopyColor = function(color) -- Used for modification of the accent's alpha without affecting the original
		if not color then
			return error("No Color Provided")
		end

		return Color(color.r, color.g, color.b, color.a)
	end
}

fgui.objects = {
	FHFrame = {
		base = "DFrame",
		noParent = true,
		contentFrame = true,

		customParams = {
			AccentColor = fgui.functions.CopyColor(fgui.colors.accent),
			Title = "Frame " .. math.random(0, 12345),
			TitleColor = fgui.functions.CopyColor(fgui.colors.white),
			Font = "FlowHooks"
		},

		customFunctions = {
			SetAccentColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.AccentColor = color
			end,

			GetAccentColor = function(self)
				return self.FH.AccentColor
			end,

			SetTitle = function(self, title)
				if not title then
					return error("No Text Provided")
				end

				self.FH.Title = title
			end,

			GetTitle = function(self)
				return self.FH.Title
			end,

			SetTitleColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.TitleColor = color
			end,

			GetTitleColor = function(self)
				return self.FH.TitleColor
			end,

			SetFont = function(self, font)
				if not font then
					return error("No Font Provided")
				end

				self.FH.Font = font
			end,

			GetFont = function(self)
				return self.FH.Font
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end,

			ShowCloseButton = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.CloseButton:SetVisible(active)
				self.FH.CloseButton:SetEnabled(active)
			end
		},

		Init = function(self)
			self:SetTitle("") -- Hide default window title
			self:GetChildren()[4]:SetVisible(false)

			local closeButton = vgui.Create("DButton", self) -- Custom close button
			closeButton:SetSize(24, 24)
			closeButton:SetFont(self.FH.Font)
			closeButton:SetTextColor(fgui.colors.white)
			closeButton:SetText("X")
			closeButton:SetCursor("arrow")

			closeButton.DoClick = function()
				self:Close()
			end

			closeButton.Paint = function(self, w, h)
				surface.SetDrawColor(fgui.colors.back_obj)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end
				
			self.FH.CloseButton = closeButton

			local children = self:GetChildren() -- Hide default close button
	
			for i = 1, 3 do
				children[i]:SetVisible(false)
				children[i]:SetEnabled(false)
			end
		end,

		Paint = function(self, w, h)
			self.FH.CloseButton:SetPos(w - self.FH.CloseButton:GetWide(), 0)

			surface.SetDrawColor(fgui.colors.black)
			surface.DrawRect(0, 0, w, h)

			local grad = 55

			for i = 1, grad do
				local c = grad - i

				surface.SetDrawColor(c, c, c, 255)
				surface.DrawLine(0, i, w, i)
			end

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetFont(self.FH.Font)
			surface.SetTextColor(self.FH.TitleColor)

			local tw, th = surface.GetTextSize(self.FH.Title)

			surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2)) -- Not perfectly proportional to the real FlowHook's menu because of the Close Button
			surface.DrawText(self.FH.Title)
		end
	},

	FHContentFrame = {
		base = "DPanel",

		customParams = {
			DrawOutlined = true
		},

		customFunctions = {
			SetDrawOutline = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.DrawOutline = active
			end,

			GetDrawOutline = function(self)
				return self.FH.DrawOutline
			end
		},

		Init = function(self)
			self:DockMargin(5, -5, 5, 5)
			self:Dock(FILL)
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back)
			surface.DrawRect(0, 0, w, h)

			if self.FH.DrawOutline then
				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		end
	},

	FHSection = {
		base = "DPanel",
		contentFrame = true,

		customParams = {
			Title = "Section " .. math.random(0, 12345)
		},

		customFunctions = {
			SetTitle = function(self, title)
				if not title then
					return error("No Text Provided")
				end

				self.FH.Title = title
			end,

			GetTitle = function(self)
				return self.FH.Title
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end
		},

		Init = function(self)
			self.FH.ContentFrame:DockMargin(5, 10, 5, 5)
			self.FH.ContentFrame:SetDrawOutline(false)
		end,

		Paint = function(self, w, h)
			surface.SetFont(fgui.functions.GetFurthestParent(self):GetFont())
			surface.SetTextColor(fgui.colors.white)

			local tw, th = surface.GetTextSize(self.FH.Title)
			local tx, ty = 8, 5 - (th / 2)

			surface.SetTextPos(tx, ty)
			surface.DrawText(self.FH.Title)

			w = w - 1
			h = h - 1
			ty = ty + (th / 2)

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawLine(0, ty, tx - 3, ty)
			surface.DrawLine(tx + tw + 3, ty, w, ty)
			surface.DrawLine(w, ty, w, h)
			surface.DrawLine(w, h, 0, h)
			surface.DrawLine(0, h, 0, ty)
		end
	},

	FHCheckBox = {
		base = "DCheckBoxLabel",

		customParams = {
			AccentColor = fgui.colors.accent
		},

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end
		},

		Init = function(self)
			local MP = fgui.functions.GetFurthestParent(self)

			self.OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end

				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end

			local Checkbox = self:GetChildren()[1]

			Checkbox:SetCursor("arrow")

			Checkbox.Paint = function(self, w, h)
				surface.SetDrawColor(fgui.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if self:GetChecked() then
					surface.SetDrawColor(MP:GetAccentColor())
					surface.DrawRect(2, 2, w - 4, h - 4)
				end
	
				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end

			self:SetTextColor(fgui.colors.white)
			self:SetFont(MP:GetFont())
		end,
	},

	FHSlider = {
		base = "DNumSlider",

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end
		},

		Init = function(self)
			local MP = fgui.functions.GetFurthestParent(self)

			self.OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end

				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end

			self:GetTextArea().Paint = function(self, w, h) -- Paint number area
				local y = (h / 2) - 7.5
				h = 15

				surface.SetDrawColor(fgui.colors.back_obj)
				surface.DrawRect(0, y, w, h)

				surface.SetFont(MP:GetFont())
				surface.SetTextColor(fgui.colors.white)

				local val = self:GetValue()
				local tw, th = surface.GetTextSize(val)

				surface.SetTextPos((w / 2) - (tw / 2), y + (h / 2) - (th / 2))
				surface.DrawText(val)

				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawOutlinedRect(0, y, w, h)
			end

			local children = self:GetChildren()

			local label = children[3]

			label:GetChildren()[1]:SetEnabled(false) -- Disable that stupid popup panel
			label:SetTextColor(fgui.colors.white) -- Setup label
			label:SetFont(MP:GetFont())

			local bar = children[2]

			bar:SetCursor("arrow")

			bar.Paint = function(self, w, h) -- Paint custom horizontal bar
				local y = h / 2

				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawLine(5, y, w - 5, y)
			end

			local handle = bar:GetChildren()[1]

			handle:SetCursor("arrow")

			handle.Paint = function(self, w, h) -- Paint bar handle
				local x = (w / 2) - 5
				w = 10

				surface.SetDrawColor(fgui.colors.back)
				surface.DrawRect(x, 0, w, h)

				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawOutlinedRect(x, 0, w, h)
			end
		end
	},

	FHDropDown = {
		base = "DComboBox",

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddChoice = function(self, value, data, select, icon)
				if not value then
					return error("Invalid Value Provided")
				end

				local MP = fgui.functions.GetFurthestParent(self)

				local i = self.FH.AddChoice(self, value, data, select, icon)

				local newChild = self.DMenu:AddOption(value, function()
					self:ChooseOptionID(i)
				end)

				newChild:SetCursor("arrow")

				newChild:SetTextColor(fgui.colors.white)
				newChild:SetFont(MP:GetFont())

				newChild.Paint = function(self, w, h)
					surface.SetDrawColor(fgui.colors.back_obj)
					surface.DrawRect(0, 0, w, h)

					if self:IsHovered() then
						local accent = fgui.functions.CopyColor(MP:GetAccentColor())
						accent.a = accent.a / 4

						surface.SetDrawColor(accent)
						surface.DrawRect(0, 0, w, h)
					end
	
					surface.SetDrawColor(fgui.colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end
		},

		Init = function(self)
			local MP = fgui.functions.GetFurthestParent(self)

			self.OnSelect = function(self, index, value, data)
				if index == nil then -- Prevent fucky business
					return
				end

				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = value
				end

				if self.FHOnSelect then
					self.FHOnValueChanged(self, index, value, data)
				end
			end

			self:SetCursor("arrow")

			self:SetTextColor(fgui.colors.white)
			self:SetFont(MP:GetFont())

			self:GetChildren()[1].Paint = function() end -- Hide the dropdown's arrow

			-- Custom DMenu Handling

			self.DMenuOpen = false
			self.DMenu = vgui.Create("DMenu", MP)

			self.DMenu:SetDeleteSelf(false)
			self.DMenu:Hide()

			self.IsMenuOpen = function(self)
				return self.DMenuOpen
			end
		
			self.OpenMenu = function(self)
				self.DMenu:Open(MP:GetX() + self:GetX() + self:GetParent():GetX(), MP:GetY() + self:GetY() + self:GetParent():GetY() + self:GetTall())
				self.DMenu:SetVisible(true)
			end
		
			self.CloseMenu = function(self)
				self.DMenu:Hide()
				self.DMenu:SetVisible(false)
			end

			self.FH.AddChoice = self.AddChoice
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_obj)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(fgui.colors.back)
			surface.DrawRect(w - h, 0, w - h, h)

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)
			surface.DrawLine(w - h, 0, w - h, h)

			if self:IsMenuOpen() then
				surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
			else
				surface.DrawLine(w - (h / 2), 3, w - (h / 2), h - 3)
				surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
			end

			if self.DMenu then
				self.DMenuOpen = self.DMenu:IsVisible()
				self.DMenu:SetMinimumWidth(self:GetWide())
			end
		end
	},

	FHTabbedMenu = {
		base = "DPropertySheet",

		customParams = {
			TabBackground = false
		},

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddTab = function(self, name, icon, noStretchX, noStretchY, tooltip)
				local ContentFrame = fgui.Create("FHContentFrame", self)
				ContentFrame:SetDrawOutline(false)

				local data = self:AddSheet(name, ContentFrame, icon, noStretchX, noStretchY, tooltip)

				local MP = fgui.functions.GetFurthestParent(self)

				data.Tab:SetCursor("arrow")

				data.Tab:SetTextColor(fgui.colors.white)
				data.Tab:SetFont(MP:GetFont())

				local ogclick = data.Tab.DoClick

				data.Tab.DoClick = function(selfP) -- selfP because I'm lazy
					if self.FH.VarTable then
						self.FH.VarTable[self.FH.Var] = self:GetText()
					end

					ogclick(selfP)
				end

				data.Tab.Paint = function(self, w, h)
					h = 21

					if self:IsActive() then
						surface.SetDrawColor(fgui.colors.back)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(fgui.colors.outline)
						surface.DrawLine(0, 0, 0, h)
						surface.DrawLine(w - 1, 0, w - 1, h)

						surface.SetDrawColor(fgui.functions.GetFurthestParent(self):GetAccentColor())
						surface.DrawLine(0, 0, w, 0)
						surface.DrawLine(0, 1, w, 1)
					else
						surface.SetDrawColor(fgui.colors.back_obj)
						surface.DrawRect(0, 0, w, h)
					end
				end

				return ContentFrame
			end,

			SetTabBackground = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.TabBackground = active
			end,

			GetTabBackground = function(self)
				return self.FH.TabBackground
			end,

			SetValue = function(self, value)
				if value == nil then
					return error("No Value Provided")
				end

				for _, v in ipairs(self:GetItems()) do
					if v.Name == value then
						v:SetActiveTab(v.Tab)

						if self.FH.VarTable then
							self.FH.VarTable[self.FH.Var] = v.Name
						end

						break
					end
				end
			end
		},

		Init = function(self)
			self:SetFadeTime(0)

			if self.tabScroller then
				self.tabScroller:DockMargin(0, 0, 0, 0)
				self.tabScroller:SetOverlap(0)
			end

			self.tabScroller.Paint = function(self, w, h)
				if not self:GetParent().FH.TabBackground then
					return
				end

				h = 20

				surface.SetDrawColor(fgui.colors.back_min)
				surface.DrawRect(0, 0, w, h)

				surface.SetDrawColor(fgui.colors.outline)
				surface.DrawLine(0, 0, w, 0)
				surface.DrawLine(0, 0, 0, h)
				surface.DrawLine(w - 1, 0, w - 1, h)
			end
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 20, w, h - 20)
			surface.DrawLine(0, 20, w, 20)
		end
	},

	FHList = {
		base = "DListView",

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddColumn = function(self, name, pos)
				if not name then
					return error("No Column Name Provided")
				end

				if pos and (pos <= 0 or self.Columns[pos]) then
					return error("Tried to Override Existing Column")
				end

				local MP = fgui.functions.GetFurthestParent(self)

				local Column = self.FH.AddColumn(self, name, pos)

				local ColumnButton = Column:GetChildren()[1]

				ColumnButton:SetCursor("arrow")
				ColumnButton:SetTextColor(fgui.colors.white)
				ColumnButton:SetFont(MP:GetFont())

				ColumnButton.Paint = function(self, w, h)
					surface.SetDrawColor(fgui.colors.back_min)
					surface.DrawRect(0, 0, w, h)

					surface.SetDrawColor(fgui.colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end

				return Column
			end,

			AddLine = function(self, ...)
				local vararg = {...}

				if #vararg < 1 then
					return error ("No Content Provided")
				end

				local MP = fgui.functions.GetFurthestParent(self)

				local Line = self.FH.AddLine(self, ...)

				for _, v in ipairs(Line:GetChildren()) do
					v:SetTextColor(fgui.colors.white)
					v:SetFont(MP:GetFont())
				end

				Line.Paint = function(self, w, h)
					if not self:IsLineSelected() and not self:IsHovered() then
						return 
					end

					local accent = fgui.functions.CopyColor(MP:GetAccentColor())

					if self:IsHovered() and not self:IsLineSelected() then
						accent.a = accent.a / 4
					end

					surface.SetDrawColor(accent)
					surface.DrawRect(0, 0, w, h)
				end

				return Line
			end,

			SetValue = function(self, value)
				self:SelectItem(value)

				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = value
				end
			end
		},

		Init = function(self)
			self.FH.AddColumn = self.AddColumn
			self.FH.AddLine = self.AddLine

			local scrollbar = self:GetChildren()[2]

			scrollbar.Paint = function(self, w, h)
				surface.SetDrawColor(fgui.colors.outline_b)
				surface.DrawRect(0, 0, w, h)
			end

			for _, v in ipairs(scrollbar:GetChildren()) do
				v:SetCursor("arrow")

				v.Paint = function(self, w, h)
					surface.SetDrawColor(fgui.colors.back)
					surface.DrawRect(0, 0, w, h)
	
					surface.SetDrawColor(fgui.colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end

			self.OnRowSelected = function(self, index, panel)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = panel
				end

				if self.FHRowSelected then
					self.FHRowSelected(self, index, panel)
				end
			end
		end,		

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_obj)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	},

	FHTextBox = {
		base = "DTextEntry",

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end
		},

		Init = function(self)
			local MP = fgui.functions.GetFurthestParent(self)

			self:SetTextColor(fgui.colors.white)
			self:SetFont(MP:GetFont())

			self:SetPaintBackground(false)

			self.OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end

				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end

			-- Setup highlight colors

			self.m_colHighlight = MP:GetAccentColor()
			self.colTextEntryTextHighlight = MP:GetAccentColor()

			-- Setup content frame

			-- This creates a content frame at the exact same position and with the same size as the text box
			-- This is needed because overriding Paint on a DTextEntry causes the text to disappear as well
			-- and to avoid rendering the text manually, this workaround will suffice

			timer.Simple(0, function()
				local ContentFrame = fgui.Create("FHContentFrame", self:GetParent())
				ContentFrame:Dock(NODOCK)
				ContentFrame:SetSize(self:GetSize())
				ContentFrame:SetPos(self:GetPos())
	
				ContentFrame.Paint = function(self, w, h)
					surface.SetDrawColor(fgui.colors.gray)
					surface.DrawRect(0, 0, w, h)
				end
	
				self:SetParent(ContentFrame)
				self:DockMargin(0, 0, 0, 0)
				self:Dock(FILL)
			end)
		end
	},

	FHButton = {
		base = "DButton",

		customFunctions = {
			SetCallback = function(self, callback)
				if not callback then
					return error("No Callback Provided")
				end

				if not type(callback) == "function" then
					return error("Invalid Callback Provided")
				end

				self.DoClick = function(self)
					callback(self)
				end
			end
		},

		Init = function(self)
			self:SetTextColor(fgui.colors.white)
			self:SetFont(fgui.functions.GetFurthestParent(self):GetFont())

			self:SetCursor("arrow")
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_obj)
			surface.DrawRect(0, 0, w, h)

			local grad = 55
			local step = 55 / h
			grad = math.floor(grad / step) - 1

			local c = 55

			for i = 1, grad do
				c = c - step

				surface.SetDrawColor(c, c, c, 255)
				surface.DrawLine(0, i, w, i)
			end

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	},

	FHColorButton = {
		base = "DButton",

		customParams = {
			Color = fgui.functions.CopyColor(fgui.colors.white)
		},

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				self.FH.Color = varloc[var]

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.VarTable[self.FH.Var] = color

				self.FH.Color = color
			end,

			GetColor = function(self)
				return self.FH.Color
			end,

			SetValue = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.VarTable[self.FH.Var] = color

				self.FH.Color = color
			end
		},

		Init = function(self)
			local MP = fgui.functions.GetFurthestParent(self)

			self:SetTextColor(fgui.colors.white)
			self:SetFont(MP:GetFont())

			self:SetCursor("arrow")

			self.DoClick = function(self)
				local MPPicker = MP.FH.ColorPicker

				if IsValid(MPPicker) then
					local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
					local var = self.FH.Var and self.FH.Var or "Color"

					MPPicker:Invoke(varloc, var)
				end
			end
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_obj)
			surface.DrawRect(0, 0, w, h)

			local grad = 55
			local step = 55 / h
			grad = math.floor(grad / step) - 1

			local c = 55

			for i = 1, grad do
				c = c - step

				surface.SetDrawColor(c, c, c, 255)
				surface.DrawLine(0, i, w, i)
			end

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)

			local _, th = surface.GetTextSize(self:GetText())
			local ty = ((h / 2) - (th / 2)) + th

			surface.SetDrawColor(self.FH.Color)
			surface.DrawRect(5, ty - 1, w - 10, 3)
		end
	},

	FHColorPicker = {
		base = "DFrame",
		noParent = true,
		contentFrame = true,

		customParams = {
			Title = "Color Picker"
		},

		customFunctions = {
			Invoke = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				self:SetVisible(true)
				self:Center()

				self:MakePopup()

				self.FH.ColorMixer:SetColor(varloc[var])
			end,

			GetFont = function(self)
				return self.FH.MP:GetFont()
			end,

			GetContentFrame = function(self)
				return self.FH.ContentFrame
			end
		},

		Init = function(self, oparent)
			self:SetTitle("") -- Hide default window title
			self:GetChildren()[4]:SetVisible(false)

			self:SetSize(210, 186)
			self:ShowCloseButton(false)
			self:SetDeleteOnClose(false)

			self:SetVisible(false)
			self:Close()

			timer.Simple(0, function() -- Do setup on next tick to avoid fucky business
				local ContentFrame = self:GetContentFrame()
				local cfw, cfh = self:GetWide() - 20, self:GetTall() - 10 -- Uses self instead of content frame because jank
	
				local OK = fgui.Create("FHButton", ContentFrame)
				OK:SetSize(100, 22)
				OK:SetPos((cfw / 2) - 50, cfh - 50)
				OK:SetText("OK")
		
				OK.DoClick = function()
					self.FH.VarTable[self.FH.Var] = self.FH.ColorMixer:GetColor()

					self:Close()
				end

				local ColorMixer = vgui.Create("DColorMixer", ContentFrame)
				ColorMixer:SetPalette(false)
				ColorMixer:SetWangs(false)
				ColorMixer:SetSize(180, 116)
				ColorMixer:SetPos((cfw / 2) - 90, 6)

				self.FH.ColorMixer = ColorMixer

				local ColorMixerChildren = ColorMixer:GetChildren()

				local ColorMixerHandle = ColorMixerChildren[4]:GetChildren()[1]
				ColorMixerHandle:SetSize(15, 15)
				ColorMixerHandle:SetCursor("arrow")

				ColorMixerHandle.Paint = function(self, w, h)
					surface.DrawCircle((w / 2), (h / 2), 5, fgui.colors.white)
					surface.DrawCircle((w / 2), (h / 2), 4, fgui.colors.black)
					surface.DrawCircle((w / 2), (h / 2), 6, fgui.colors.black)
				end
			end)
		end,

		Paint = function(self, w, h) -- Same(ish) as FHFrame
			local MP = self.FH.MP

			if not IsValid(MP) then
				self:Remove()
				return
			end

			surface.SetDrawColor(fgui.colors.black)
			surface.DrawRect(0, 0, w, h)

			local grad = 55

			for i = 1, grad do
				local c = grad - i

				surface.SetDrawColor(c, c, c, 255)
				surface.DrawLine(0, i, w, i)
			end

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetFont(MP:GetFont())
			surface.SetTextColor(MP:GetTitleColor())

			local tw, th = surface.GetTextSize(self.FH.Title)

			surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2))
			surface.DrawText(self.FH.Title)
		end
	},

	FHBinder = {
		base = "DBinder",

		customParams = {
			LabelText = ""
		},

		customFunctions = {
			SetVarTable = function(self, varloc, var)
				if not varloc then
					return error("Invalid Variable Table Provided")
				end

				if not var then
					return error("No Variable Provided")
				end

				self.FH.VarTable = varloc
				self.FH.Var = var

				fgui.vth[#fgui.vth + 1] = self
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetLabel = function(self, label)
				if not label then
					return error("No Label Provided")
				end

				self.FH.LabelText = label

				if self.FH.Label then
					self.FH.Label:SetText(label)
				end
			end,

			GetLabel = function(self)
				return self.FH.LabelText
			end
		},

		Init = function(self)
			local font = fgui.functions.GetFurthestParent(self):GetFont()

			self:SetTextColor(fgui.colors.white)
			self:SetFont(font)

			self:SetCursor("arrow")

			self.OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end

				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end

			timer.Simple(0, function()
				surface.SetFont(font)

				local tw, th = surface.GetTextSize(self.FH.LabelText)

				local Label = vgui.Create("DLabel", self:GetParent())
				Label:SetTextColor(fgui.colors.white)
				Label:SetFont(font)
				Label:SetText(self.FH.LabelText)
				Label:SetPos(self:GetX() + ((self:GetWide() / 2) - (tw / 2)), self:GetY() - th - 3)
	
				self.FH.Label = Label
			end)
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_obj)
			surface.DrawRect(0, 0, w, h)

			local grad = 55
			local step = 55 / h
			grad = math.floor(grad / step) - 1

			local c = 55

			for i = 1, grad do
				c = c - step

				surface.SetDrawColor(c, c, c, 255)
				surface.DrawLine(0, i, w, i)
			end

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)
		end
	},

	FHMiniMenu = {
		base = "DFrame",
		noParent = true,

		customParams = {
			Columns = {},
			Rows = {},
			BackgroundAlpha = 255,
			Font = "FlowHooks",
			TextColor = fgui.functions.CopyColor(fgui.colors.white)
		},

		customFunctions = {
			SetFont = function(self, font)
				if not font then
					return error("No Font Provided")
				end

				self.FH.Font = font
			end,

			GetFont = function(self)
				return self.FH.Font
			end,

			SetTextColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				self.FH.TextColor = color
			end,

			GetTextColor = function(self)
				return self.FH.TextColor
			end,

			AddColumn = function(self, name, index)
				if not name then
					return error("No Column Name Provided")
				end

				index = index or (#self.FH.Columns + 1)

				for _, v in ipairs(self.FH.Rows) do
					table.insert(v, index, "")
				end

				table.insert(self.FH.Columns, index, name)
			end,

			AddRow = function(self, ...)
				self.FH.Rows[#self.FH.Rows + 1] = ...

				self:SetTall(20 + (20 * #self.FH.Rows))
			end,

			SetBackgroundAlpha = function(self, alpha)
				if not alpha then
					return error("No Alpha Provided")
				end

				self.FH.BackgroundAlpha = alpha
			end
		},

		Init = function(self)
			self:SetTitle("")
			self:GetChildren()[4]:SetVisible(false)

			self:ShowCloseButton(false)

			self:SetVisible(true)
		end,

		Paint = function(self, w, h)
			surface.SetDrawColor(fgui.colors.back_min)
			surface.DrawRect(0, 0, w, 20)

			local bgcol = fgui.functions.CopyColor(fgui.colors.back_obj)
			bgcol.a = self.FH.BackgroundAlpha

			local rows = #self.FH.Rows
			local cols = #self.FH.Columns

			surface.SetDrawColor(bgcol)
			surface.DrawRect(0, 20, w, 20 * rows)

			surface.SetDrawColor(fgui.colors.outline)
			surface.DrawOutlinedRect(0, 0, w, h)

			surface.SetFont(self.FH.Font)
			surface.SetTextColor(self.FH.TextColor)

			local step = w / cols

			for i = 1, cols do
				surface.DrawLine((i - 1) * step, 0, (i - 1) * step, h)

				local cur = self.FH.Columns[i]

				local tw, th = surface.GetTextSize(cur)

				surface.SetTextPos(((step / 2) - (tw / 2)) + ((i - 1) * step), 10 - (th / 2))
				surface.DrawText(cur)
			end

			for i = 1, rows do
				surface.DrawLine(0, i * 20, w, i * 20)

				for k, v in ipairs(self.FH.Rows[i]) do
					local tw, th = surface.GetTextSize(v)
		
					surface.SetTextPos(((step / 2) - (tw / 2)) + ((k - 1) * step), (10 - (th / 2)) + 20)
					surface.DrawText(v)
				end
			end
		end
	}
}

-- Creator Function

fgui.Create = function(type, parent, name)
	if not type or not fgui.objects[type] then
		return error("Invalid FlowHooks Object (" .. type .. ")")
	end

	local current = fgui.objects[type]

	if not parent and not current.noParent then
		return error("Invalid Parent Panel Specified")
	elseif parent and type ~= "FHContentFrame" then
		if parent:GetName() == "DFrame" then
			if parent.GetContentFrame then
				parent = parent:GetContentFrame()
			end
		end
	end

	local FHObject = vgui.Create(current.base, parent, name)

	FHObject.FH = {}
	FHObject.FH.Type = type

	if current.contentFrame then
		local frame = fgui.Create("FHContentFrame", FHObject)
		frame:Dock(FILL)
		frame:SetDrawOutline(true)

		FHObject.FH.ContentFrame = frame
	end

	if current.customParams then -- Create custom parameters
		for k, v in pairs(current.customParams) do
			FHObject.FH[k] = v
		end
	end

	if current.Paint then -- Give the object the FlowHooks look
		FHObject.Paint = current.Paint
	end

	if current.Init then -- Change some default Derma settings for quick setup
		current.Init(FHObject)
	end
	if current.customFunctions then -- Register custom functions
		for k, v in pairs(current.customFunctions) do
			FHObject[k] = v
		end
	end

	if type == "FHFrame" then
		FHObject.FH.ColorPicker = fgui.Create("FHColorPicker")
		FHObject.FH.ColorPicker.FH.MP = FHObject
	end

	return FHObject
end

timer.Create("fgui_SlowTick", 0.2, 0, function()
	for _, v in ipairs(fgui.vth) do
		if not IsValid(v) or not v:IsVisible() or not v.FH or not v.FH.VarTable or not v.FH.Var then -- Just in case something goes wrong
			continue
		end

		if v.FH.Type == "FHCheckBox" then -- Funny SetValue calls OnChange and I'm not gonna override SetValue
			v:SetChecked(v.FH.VarTable[v.FH.Var])
		else
			v:SetValue(v.FH.VarTable[v.FH.Var])
		end
	end
end)
