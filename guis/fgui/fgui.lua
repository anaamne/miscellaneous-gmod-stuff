--[[
	leme's FlowHooks vgui base

	Valid Objects (These support the functions of their default Derma counterparts as well. If no functions are listed under it then it simply doesn't have any custom functions)
		FHFrame (DFrame that comes with a content frame)
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
				- AddChoices(choices)				=>			Creates options passed as seperate arguments OR a table of choices (Ex: dropdown:AddChoices("option1", "option2", "option3")) (Returns a table of created indexes)

		FHTabbedMenu (DPropertySheet)
			Functions:
				- SetVarTable(table, key)			=>			Sets the tabbed menu's table key to update on value change (Returns the name of the tab)
				- GetVarTable()						=>			Returns the tabbed menu's VarTable and key name
				- AddTab(name, icon, sX, sY, tt)	=>			Creates a tab and returns the content frame of the tab (Works like DPropertySheet:AddSheet)
				- AddTabs(tabs)						=>			Creates tabs passed as seperate arguments OR a table of arguments (No icon, etc) (Ex: menu:AddTabs("tab1", "tab2", "tab3")) (Returns a table of the content frames)
				- SetTabBackground(newState)		=>			Sets rendering of the background behind tabs
				- GetTabBackground()				=>			Returns current rendering state of the background behind tabs
				- SetValue(value)					=>			Used internally to update the tabbed menu to the specified tab
				- SizeTabsToWidth()					=>			Evenly sizes the tabbed menu's tabs to fill the width of the tabbed menu

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

		FHColorButton (DButton; DO *NOT* OVERRIDE DoClick NOR DoRightClick FOR THIS OBJECT! Use FHDoClick OR FHDoRightClick INSTEAD!)
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
				- SetBackgroundAlpha(newAlpha)		=>			Sets backround alpha for the rows of the mini menu
				- GetBackgroundAlpha()				=>			Returns the background alpha for the rows of the mini menu

		FHLabel (DLabel)
]]

fgui = fgui or {}

local fguitable = fgui

surface.CreateFont("FlowHooks", {
	font = "Verdana",
	size = 12,
	antialias = false,
	outline = true
})

fguitable.timer = "fgui_SlowTick"
fguitable.vth = {} -- VarTable holders
fguitable.clipboard = nil -- For color copy / pasting

fguitable.colors = {
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

fguitable.colors.grey = fguitable.colors.gray -- We are anonymous

fguitable.functions = {
	GetFurthestParent = function(base) -- Used to get FHFrame's accent color from any child object
		if not base then
			return error("Invalid Panel Provided")
		end

		local cparent = base:GetParent()

		if cparent:GetParent() == vgui.GetWorldPanel() then
			return cparent
		end

		return fguitable.functions.GetFurthestParent(cparent)
	end,

	CopyColor = function(color) -- Used for modification of the accent's alpha without affecting the original
		if not color then
			return error("No Color Provided")
		end

		return Color(color.r, color.g, color.b, color.a)
	end,

	RegisterVarTable = function(obj, varloc, var) -- Used to attach a variable in a table to an object
		if not obj then
			return
		end

		if not varloc then
			return error("Invalid Variable Table Provided")
		end

		if not var then
			return error("No Variable Provided")
		end

		obj.FH.VarTable = varloc
		obj.FH.Var = var

		fguitable.vth[#fguitable.vth + 1] = obj
	end,

	GenerateRandomString = function()
		return string.char(math.random(97, 122)) .. tostring(math.random(-123456, 123456))
	end
}

fguitable.objects = {
	FHFrame = {
		Base = "DFrame",

		NotParented = true,
		HasContentFrame = true,

		Registry = {
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
			end,

			Init = function(self)
				self.FH = {
					AccentColor = fguitable.functions.CopyColor(fguitable.colors.accent),
					Title = "Frame " .. math.random(0, 12345),
					TitleColor = fguitable.functions.CopyColor(fguitable.colors.white),
					Font = "FlowHooks",

					ColorPicker = fguitable.Create("FHColorPicker")
				}

				self:SetCursor("arrow") -- Prevent cursor change when dragging
				self.SetCursor = function() end

				self.FH.ColorPicker.FH.MP = self

				self:SetTitle("") -- Hide default window title
				self:GetChildren()[4]:SetVisible(false)

				local closeButton = vgui.Create("DButton", self) -- Custom close button
				closeButton:SetSize(24, 24)
				closeButton:SetFont(self.FH.Font)
				closeButton:SetTextColor(fguitable.colors.white)
				closeButton:SetText("X")
				closeButton:SetCursor("arrow")
	
				closeButton.DoClick = function()
					self:Close()
				end
	
				closeButton.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.colors.back_obj)
					surface.DrawRect(0, 0, w, h)
	
					surface.SetDrawColor(fguitable.colors.outline)
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
	
				surface.SetDrawColor(fguitable.colors.black)
				surface.DrawRect(0, 0, w, h)
	
				local grad = 55
	
				for i = 1, grad do
					local c = grad - i
	
					surface.SetDrawColor(c, c, c, 255)
					surface.DrawLine(0, i, w, i)
				end
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				surface.SetFont(self:GetFont())
				surface.SetTextColor(self:GetTitleColor())

				local title = self:GetTitle()
	
				local tw, th = surface.GetTextSize(title)
	
				surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2)) -- Not perfectly proportional to the real FlowHook's menu because of the Close Button
				surface.DrawText(title)
			end
		}
	},

	FHContentFrame = {
		Base = "DPanel",

		Registry = {
			SetDrawOutline = function(self, active)
				if active == nil then
					return error("No Boolean Provided")
				end

				self.FH.DrawOutline = active
			end,

			GetDrawOutline = function(self)
				return self.FH.DrawOutline
			end,

			Init = function(self)
				self.FH = {
					DrawOutlined = true
				}

				self:DockMargin(5, -5, 5, 5)
				self:Dock(FILL)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back)
				surface.DrawRect(0, 0, w, h)
	
				if self:GetDrawOutline() then
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
			end
		}
	},

	FHSection = {
		Base = "DPanel",

		HasContentFrame = true,

		Registry = {
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
			end,

			Init = function(self)
				self.FH = {
					Title = "Section " .. math.random(0, 12345)
				}

				timer.Simple(0, function()
					local ContentFrame = self:GetContentFrame()
	
					if IsValid(ContentFrame) then
						ContentFrame:DockMargin(5, 10, 5, 5)
						ContentFrame:SetDrawOutline(false)
					end
				end)
			end,

			Paint = function(self, w, h)
				surface.SetFont(fguitable.functions.GetFurthestParent(self):GetFont())
				surface.SetTextColor(fguitable.colors.white)

				local title = self:GetTitle()
	
				local tw, th = surface.GetTextSize(title)
				local tx, ty = 8, 5 - (th / 2)
	
				surface.SetTextPos(tx, ty)
				surface.DrawText(title)
	
				w = w - 1
				h = h - 1
				ty = ty + (th / 2)
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawLine(0, ty, tx - 3, ty)
				surface.DrawLine(tx + tw + 3, ty, w, ty)
				surface.DrawLine(w, ty, w, h)
				surface.DrawLine(w, h, 0, h)
				surface.DrawLine(0, h, 0, ty)
			end
		}
	},

	FHCheckBox = {
		Base = "DCheckBoxLabel",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local MP = fguitable.functions.GetFurthestParent(self)
	
				local checkbox = self:GetChildren()[1]
	
				checkbox:SetCursor("arrow")
	
				checkbox.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.colors.back_obj)
					surface.DrawRect(0, 0, w, h)
		
					if self:GetChecked() then
						surface.SetDrawColor(MP:GetAccentColor())
						surface.DrawRect(2, 2, w - 4, h - 4)
					end
		
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawOutlinedRect(0, 0, w, h)
				end
	
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(MP:GetFont())
			end,

			OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end
		}
	},

	FHSlider = {
		Base = "DNumSlider",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local MP = fguitable.functions.GetFurthestParent(self)

				self:GetTextArea().Paint = function(self, w, h) -- Paint number area
					local y = (h / 2) - 7.5
					h = 15
	
					surface.SetDrawColor(fguitable.colors.back_obj)
					surface.DrawRect(0, y, w, h)
	
					surface.SetFont(MP:GetFont())
					surface.SetTextColor(fguitable.colors.white)
	
					local val = self:GetValue()
					local tw, th = surface.GetTextSize(val)
	
					surface.SetTextPos((w / 2) - (tw / 2), y + (h / 2) - (th / 2))
					surface.DrawText(val)
	
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawOutlinedRect(0, y, w, h)
				end
	
				local children = self:GetChildren()
	
				local label = children[3]
	
				label:GetChildren()[1]:SetEnabled(false) -- Disable that stupid popup panel
				label:SetTextColor(fguitable.colors.white) -- Setup label
				label:SetFont(MP:GetFont())
	
				local bar = children[2]
	
				bar:SetCursor("arrow")
	
				bar.Paint = function(self, w, h) -- Paint custom horizontal bar
					local y = h / 2
	
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawLine(5, y, w - 5, y)
				end
	
				local handle = bar:GetChildren()[1]
	
				handle:SetCursor("arrow")
	
				handle.Paint = function(self, w, h) -- Paint bar handle
					local x = (w / 2) - 5
					w = 10
	
					surface.SetDrawColor(fguitable.colors.back)
					surface.DrawRect(x, 0, w, h)
	
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawOutlinedRect(x, 0, w, h)
				end
			end,

			OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end
		}
	},

	FHDropDown = {
		Base = "DComboBox",
		HasDMenu = true,

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddChoices = function(self, ...)
				local data = {...}

				if type(data[1]) == "table" then
					data = data[1]
				end

				local created = {}

				for _, v in pairs(data) do
					local i = self:AddChoice(v)
					created[#created + 1] = i
				end

				return created
			end,

			Init = function(self)
				self.FH = {
					AddChoice = self.AddChoice
				}

				self.AddChoice = function(self, value, data, select, icon) -- Override default AddChoice
					if not value then
						return error("Invalid Value Provided")
					end

					local i = self.FH.AddChoice(self, value, data, select, icon)
	
					self.DMenu:AddOption(value, function()
						self:ChooseOptionID(i)
					end)

					return i
				end

				self:SetCursor("arrow")
	
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(fguitable.functions.GetFurthestParent(self):GetFont())
	
				self:GetChildren()[1].Paint = function() end -- Hide the dropdown's arrow
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.colors.back)
				surface.DrawRect(w - h, 0, w - h, h)
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
				surface.DrawLine(w - h, 0, w - h, h)
	
				if self:IsMenuOpen() then
					surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
				else
					surface.DrawLine(w - (h / 2), 3, w - (h / 2), h - 3)
					surface.DrawLine((w - h) + 3, h / 2, w - 3, h / 2)
				end
			end,

			OnSelect = function(self, index, value, data)
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
		}
	},

	FHTabbedMenu = {
		Base = "DPropertySheet",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			AddTab = function(self, name, icon, noStretchX, noStretchY, tooltip)
				local ContentFrame = fguitable.Create("FHContentFrame", self)
				ContentFrame:SetDrawOutline(false)

				local data = self:AddSheet(name, ContentFrame, icon, noStretchX, noStretchY, tooltip)

				local MP = self.FH.MP or fguitable.functions.GetFurthestParent(self)
				self.FH.MP = self.FH.MP or MP

				data.Tab:SetCursor("arrow")

				data.Tab:SetTextColor(fguitable.colors.white)
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
						surface.SetDrawColor(fguitable.colors.back)
						surface.DrawRect(0, 0, w, h)

						surface.SetDrawColor(fguitable.colors.outline)
						surface.DrawLine(0, 0, 0, h)
						surface.DrawLine(w - 1, 0, w - 1, h)

						surface.SetDrawColor(fguitable.functions.GetFurthestParent(self):GetAccentColor())
						surface.DrawLine(0, 0, w, 0)
						surface.DrawLine(0, 1, w, 1)
					else
						surface.SetDrawColor(fguitable.colors.back_obj)
						surface.DrawRect(0, 0, w, h)
					end
				end

				return ContentFrame
			end,

			AddTabs = function(self, ...)
				local data = {...}

				if type(data[1]) == "table" then
					data = data[1]
				end

				local created = {}

				for _, v in pairs(data) do
					local i = self:AddTab(v)
					created[#created + 1] = i
				end

				return created
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
			end,

			SizeTabsToWidth = function(self)
				self:InvalidateParent(true)
			
				local tabs = self:GetItems()
				local awidth = math.ceil((self:GetWide() / #tabs) - 20)
				local width = math.floor(awidth)
			
				local MP = fguitable.functions.GetFurthestParent(self)
				surface.SetFont(MP:GetFont())

				local subamount = 0
			
				for k, v in ipairs(tabs) do
					local tab = v.Tab
			
					tab.FH = tab.FH or {}
			
					local text = tab.FH.Text or tab:GetText()
					tab.FH.Text = tab.FH.Text or text
			
					local tw, _ = surface.GetTextSize(text)
					local step = false
			
					local max = (k == #tabs and awidth or width) - subamount

					if subamount ~= 0 then
						max = max - subamount
						subamount = 0
					end

					if tw > max then
						subamount = (tw - max) / 2
					end
			
					while tw < max do
						text = step and text .. " " or " " .. text
						tw, _ = surface.GetTextSize(text)
			
						step = not step
					end
			
					tab:SetText(text)
					tab:InvalidateLayout()
				end
			end,

			Init = function(self)
				self.FH = {
					TabBackground = false
				}

				self:SetFadeTime(0)
	
				if self.tabScroller then
					self.tabScroller:DockMargin(0, 0, 0, 0)
					self.tabScroller:SetOverlap(0)
				end
	
				self.tabScroller.Paint = function(self, w, h)
					if not self:GetParent():GetTabBackground() then
						return
					end
	
					h = 20
	
					surface.SetDrawColor(fguitable.colors.back_min)
					surface.DrawRect(0, 0, w, h)
	
					surface.SetDrawColor(fguitable.colors.outline)
					surface.DrawLine(0, 0, w, 0)
					surface.DrawLine(0, 0, 0, h)
					surface.DrawLine(w - 1, 0, w - 1, h)
				end
			end,
	
			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 20, w, h - 20)
				surface.DrawLine(0, 20, w, 20)
			end
		}
	},

	FHList = {
		Base = "DListView",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetValue = function(self, value)
				self:SelectItem(value)

				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = value
				end
			end,

			Init = function(self)
				self.FH = {
					AddColumn = self.AddColumn,
					AddLine = self.AddLine
				}

				self.AddColumn = function(self, name, pos) -- Override default AddColumn
					if not name then
						return error("No Column Name Provided")
					end
	
					if pos and (pos <= 0 or self.Columns[pos]) then
						return error("Tried to Override Existing Column")
					end
	
					local MP = self.FH.MP or fguitable.functions.GetFurthestParent(self)
					self.FH.MP = self.FH.MP or MP
	
					local Column = self.FH.AddColumn(self, name, pos)
	
					local ColumnButton = Column:GetChildren()[1]
	
					ColumnButton:SetCursor("arrow")
					ColumnButton:SetTextColor(fguitable.colors.white)
					ColumnButton:SetFont(MP:GetFont())
	
					ColumnButton.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.colors.back_min)
						surface.DrawRect(0, 0, w, h)
	
						surface.SetDrawColor(fguitable.colors.outline)
						surface.DrawOutlinedRect(0, 0, w, h)
					end
	
					return Column
				end

				self.AddLine = function(self, ...) -- Override default AddLine
					local vararg = {...}
	
					if #vararg < 1 then
						return error ("No Content Provided")
					end
	
					local MP = self.FH.MP or fguitable.functions.GetFurthestParent(self)
					self.FH.MP = self.FH.MP or MP
	
					local Line = self.FH.AddLine(self, ...)
	
					for _, v in ipairs(Line:GetChildren()) do
						v:SetTextColor(fguitable.colors.white)
						v:SetFont(MP:GetFont())
					end
	
					Line.Paint = function(self, w, h)
						if not self:IsLineSelected() and not self:IsHovered() then
							return 
						end
	
						local accent = fguitable.functions.CopyColor(MP:GetAccentColor())
	
						if self:IsHovered() and not self:IsLineSelected() then
							accent.a = accent.a / 4
						end
	
						surface.SetDrawColor(accent)
						surface.DrawRect(0, 0, w, h)
					end
	
					return Line
				end

				local scrollbar = self:GetChildren()[2]
	
				scrollbar.Paint = function(self, w, h)
					surface.SetDrawColor(fguitable.colors.outline_b)
					surface.DrawRect(0, 0, w, h)
				end
	
				for _, v in ipairs(scrollbar:GetChildren()) do
					v:SetCursor("arrow")
	
					v.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.colors.back)
						surface.DrawRect(0, 0, w, h)
		
						surface.SetDrawColor(fguitable.colors.outline)
						surface.DrawOutlinedRect(0, 0, w, h)
					end
				end
			end,		
	
			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end,

			OnRowSelected = function(self, index, panel)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = panel
				end
	
				if self.FHRowSelected then
					self.FHRowSelected(self, index, panel)
				end
			end
		}
	},

	FHTextBox = {
		Base = "DTextEntry",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			Init = function(self)
				local MP = fguitable.functions.GetFurthestParent(self)
	
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(MP:GetFont())
	
				self:SetPaintBackground(false)
	
				-- Setup highlight colors
	
				self.m_colHighlight = MP:GetAccentColor()
				self.colTextEntryTextHighlight = MP:GetAccentColor()
	
				-- Setup content frame
	
				-- This creates a content frame at the exact same position and with the same size as the text box
				-- This is needed because overriding Paint on a DTextEntry causes the text to disappear as well
				-- and to avoid rendering the text manually, this workaround will suffice
	
				timer.Simple(0, function()
					local ContentFrame = fguitable.Create("FHContentFrame", self:GetParent())
					ContentFrame:Dock(NODOCK)
					ContentFrame:SetSize(self:GetSize())
					ContentFrame:SetPos(self:GetPos())
		
					ContentFrame.Paint = function(self, w, h)
						surface.SetDrawColor(fguitable.colors.gray)
						surface.DrawRect(0, 0, w, h)
					end
		
					self:SetParent(ContentFrame)
					self:DockMargin(0, 0, 0, 0)
					self:Dock(FILL)
				end)
			end,

			OnValueChanged = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnValueChanged then
					self.FHOnValueChanged(self, new)
				end
			end
		}
	},

	FHButton = {
		Base = "DButton",

		Registry = {
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
			end,

			Init = function(self)
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(fguitable.functions.GetFurthestParent(self):GetFont())
	
				self:SetCursor("arrow")
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		}
	},

	FHColorButton = {
		Base = "DButton",
		HasDMenu = true,

		Registry = {
			SetVarTable = function(self, varloc, var)
				self.FH.Color = varloc[var]

				fguitable.functions.RegisterVarTable(self, varloc, var)
			end,

			GetVarTable = function(self)
				return self.FH.VarTable, self.FH.Var
			end,

			SetColor = function(self, color)
				if not color then
					return error("No Color Provided")
				end

				local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
				local var = self.FH.Var and self.FH.Var or "Color"

				varloc[var] = color
			end,

			GetColor = function(self)
				local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
				local var = self.FH.Var and self.FH.Var or "Color"

				return varloc[var]
			end,

			Init = function(self)
				self.FH = {
					Color = fguitable.functions.CopyColor(fguitable.colors.white)
				}

				self.SetValue = self.SetColor

				self:SetTextColor(fguitable.colors.white)
				self:SetFont(fguitable.functions.GetFurthestParent(self):GetFont())
	
				self:SetCursor("arrow")

				timer.Simple(0, function()
					self.DMenu:AddOption("Copy Color", function()
						fguitable.clipboard = fguitable.functions.CopyColor(self:GetColor())
						SetClipboardText(table.concat(fguitable.clipboard:ToTable(), ", "))
					end)

					self.DMenu:AddOption("Paste Color", function()
						if fguitable.clipboard and IsColor(fguitable.clipboard) then
							self:SetColor(fguitable.clipboard)
						end
					end)
				end)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
				
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				local _, th = surface.GetTextSize(self:GetText())
				local ty = ((h / 2) - (th / 2)) + th
	
				surface.SetDrawColor(self:GetColor())
				surface.DrawRect(5, ty - 1, w - 10, 3)
			end,

			DoClick = function(self)
				local MP = self.FH.MP or fguitable.functions.GetFurthestParent(self)
				self.FH.MP = self.FH.MP or MP

				local MPPicker = self.FH.MP.FH.ColorPicker
	
				if IsValid(MPPicker) then
					local varloc = self.FH.VarTable and self.FH.VarTable or self.FH
					local var = self.FH.Var and self.FH.Var or "Color"
	
					MPPicker:Invoke(varloc, var)
				end

				if self.FHDoClick then
					self.FHDoClick(self)
				end
			end,

			DoRightClick = function(self)
				self:OpenMenu()

				if self.FHDoRightClick then
					self.FHDoRightClick(self)
				end
			end
		}
	},

	FHColorPicker = {
		Base = "DFrame",
		NotParented = true,
		HasContentFrame = true,

		Registry = {
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
			end,

			Init = function(self, oparent)
				self.FH = {
					Title = "Color Picker"
				}

				self:SetTitle("")
				self:GetChildren()[4]:SetVisible(false)
	
				self:SetSize(210, 186)
				self:ShowCloseButton(false)
				self:SetDeleteOnClose(false)
	
				self:SetVisible(false)
				self:Close()
	
				timer.Simple(0, function() -- Do setup on next tick to avoid fucky business
					local ContentFrame = self:GetContentFrame()
					local cfw, cfh = self:GetWide() - 20, self:GetTall() - 10 -- Uses self instead of content frame because jank
		
					local OK = fguitable.Create("FHButton", ContentFrame)
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
						surface.DrawCircle((w / 2), (h / 2), 5, fguitable.colors.white)
						surface.DrawCircle((w / 2), (h / 2), 4, fguitable.colors.black)
						surface.DrawCircle((w / 2), (h / 2), 6, fguitable.colors.black)
					end
				end)
			end,

			Paint = function(self, w, h) -- Same(ish) as FHFrame
				local MP = self.FH.MP
	
				if not IsValid(MP) then
					self:Remove()
					return
				end
	
				surface.SetDrawColor(fguitable.colors.black)
				surface.DrawRect(0, 0, w, h)
	
				local grad = 55
	
				for i = 1, grad do
					local c = grad - i
	
					surface.SetDrawColor(c, c, c, 255)
					surface.DrawLine(0, i, w, i)
				end
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
	
				surface.SetFont(MP:GetFont())
				surface.SetTextColor(MP:GetTitleColor())
	
				local tw, th = surface.GetTextSize(self.FH.Title)
	
				surface.SetTextPos((w / 2) - (tw / 2), 13 - (th / 2))
				surface.DrawText(self.FH.Title)
			end
		}
	},

	FHBinder = {
		Base = "DBinder",

		Registry = {
			SetVarTable = function(self, varloc, var)
				fguitable.functions.RegisterVarTable(self, varloc, var)
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
			end,

			Init = function(self)
				local font = fguitable.functions.GetFurthestParent(self):GetFont()
	
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(font)
	
				self:SetCursor("arrow")
	
				timer.Simple(0, function()
					surface.SetFont(font)

					local label = self:GetLabel()
	
					local tw, th = surface.GetTextSize(label)
	
					local Label = vgui.Create("DLabel", self:GetParent())
					Label:SetTextColor(fguitable.colors.white)
					Label:SetFont(font)
					Label:SetText(label)
					Label:SetPos(self:GetX() + ((self:GetWide() / 2) - (tw / 2)), self:GetY() - th - 3)
		
					self.FH.Label = Label
				end)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if not self:IsDown() then
					local grad = 55
					local step = 55 / (h * 1.5)
					grad = math.floor(grad / step) - 1
		
					local c = 55
		
					for i = 1, grad do
						c = c - step
		
						surface.SetDrawColor(c, c, c, 255)
						surface.DrawLine(0, i, w, i)
					end
				end
	
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end,

			OnChange = function(self, new)
				if self.FH.VarTable then
					self.FH.VarTable[self.FH.Var] = new
				end
	
				if self.FHOnChange then
					self.FHOnChange(self, new)
				end
			end
		}
	},

	FHMiniMenu = {
		Base = "DFrame",
		NotParented = true,

		Registry = {
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
			end,

			GetBackgroundAlpha = function(self)
				return self.FH.BackgroundAlpha
			end,

			Init = function(self)
				self.FH = {
					Columns = {},
					Rows = {},
					BackgroundAlpha = 255,
					Font = "FlowHooks",
					TextColor = fguitable.functions.CopyColor(fguitable.colors.white)
				}

				self:SetTitle("")
				self:GetChildren()[4]:SetVisible(false)
	
				self:ShowCloseButton(false)
	
				self:SetVisible(true)
			end,

			Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_min)
				surface.DrawRect(0, 0, w, 20)
	
				local bgcol = fguitable.functions.CopyColor(fguitable.colors.back_obj)
				bgcol.a = self.FH.BackgroundAlpha
	
				local rows = #self.FH.Rows
				local cols = #self.FH.Columns
	
				surface.SetDrawColor(bgcol)
				surface.DrawRect(0, 20, w, 20 * rows)
	
				surface.SetDrawColor(fguitable.colors.outline)
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
	},

	FHLabel = {
		Base = "DLabel",

		Registry = {
			Init = function(self)
				self:SetTextColor(fguitable.colors.white)
				self:SetFont(fguitable.functions.GetFurthestParent(self):GetFont())
			end
		}
	}
}

for k, v in pairs(fguitable.objects) do -- Register objects
	vgui.Register(k, v.Registry, v.Base)
end

fguitable.Create = function(type, parent, name)
	if not type or not fguitable.objects[type] then
		return error("Invalid FlowHooks Object (" .. type .. ")")
	end

	local current = fguitable.objects[type]

	if not parent and not current.NotParented then
		return error("Invalid Parent Panel Specified")
	elseif parent and type ~= "FHContentFrame" then
		if parent.FH.Type == "FHFrame" and parent.GetContentFrame then
			parent = parent:GetContentFrame()
		end
	end

	local FHObject = vgui.Create(type, parent, name)

	FHObject.FH = FHObject.FH or {}
	FHObject.FH.Type = type

	if current.HasContentFrame then
		local frame = fguitable.Create("FHContentFrame", FHObject)
		frame:Dock(FILL)
		frame:SetDrawOutline(true)

		FHObject.FH.ContentFrame = frame
	end

	if current.HasDMenu then
		local MP = fguitable.functions.GetFurthestParent(FHObject)

		FHObject.DMenuOpen = false
		FHObject.DMenu = vgui.Create("DMenu", MP)

		local DMenu = FHObject.DMenu
		local ogAddOption = DMenu.AddOption

		DMenu.AddOption = function(...)
			local NewOption = ogAddOption(...)

			NewOption:SetCursor("arrow")
	
			NewOption:SetTextColor(fguitable.colors.white)
			NewOption:SetFont(MP:GetFont())
	
			NewOption.Paint = function(self, w, h)
				surface.SetDrawColor(fguitable.colors.back_obj)
				surface.DrawRect(0, 0, w, h)
	
				if self:IsHovered() then
					local accent = fguitable.functions.CopyColor(MP:GetAccentColor())
					accent.a = accent.a / 4
	
					surface.SetDrawColor(accent)
					surface.DrawRect(0, 0, w, h)
				end
		
				surface.SetDrawColor(fguitable.colors.outline)
				surface.DrawOutlinedRect(0, 0, w, h)
			end
		end
	
		DMenu:SetDeleteSelf(false)
		DMenu:Hide()
	
		FHObject.IsMenuOpen = function(self)
			return self.DMenuOpen
		end
		
		FHObject.OpenMenu = function(self)
			self.DMenu:Open(self:LocalToScreen(0, self:GetTall()))
			self.DMenu:SetVisible(true)
		end
		
		FHObject.CloseMenu = function(self)
			self.DMenu:Hide()
			self.DMenu:SetVisible(false)
		end

		local ogPaint = FHObject.Paint

		FHObject.Paint = function(self, w, h)
			ogPaint(self, w, h)

			if self.DMenu then
				self.DMenuOpen = self.DMenu:IsVisible()
				self.DMenu:SetMinimumWidth(self:GetWide())
			end
		end
	end
	
	return FHObject
end

fguitable.CreateVarTableTimer = function()
	timer.Create(fguitable.timer, 0.2, 0, function()
		for _, v in ipairs(fguitable.vth) do
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
end

fguitable.Hide = function() -- Destroys the fgui globals and returns the new fgui table (Except the elements)
	local backup = table.Copy(fguitable)
	fgui = nil

	timer.Remove(backup.timer)

	backup.timer = backup.functions.GenerateRandomString()
	backup.CreateVarTableTimer()

	fguitable = backup

	return backup
end

fguitable.CreateVarTableTimer() -- Create the timer when the script is loaded
