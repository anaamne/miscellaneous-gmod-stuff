--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Surface menu made for s0lum (s0lame (Vine BOOM))
]]

--------------------------- Menu State Fixes ---------------------------

TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT or 0
TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER or 1
TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT or 2
TEXT_ALIGN_TOP = TEXT_ALIGN_TOP or 3
TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM or 4

MOUSE_LEFT = MOUSE_LEFT or 107
MOUSE_RIGHT = MOUSE_RIGHT or 108
MOUSE_WHEEL_UP = MOUSE_WHEEL_UP or 112
MOUSE_WHEEL_DOWN = MOUSE_WHEEL_DOWN or 113

STENCIL_NEVER = STENCIL_NEVER or 1
STENCIL_EQUAL = STENCIL_EQUAL or 3

STENCIL_KEEP = STENCIL_KEEP or 1
STENCIL_REPLACE = STENCIL_REPLACE or 3

MENU_DLL = MENU_DLL or false

--------------------------- Localization ---------------------------

local Color = Color
local ErrorNoHalt = ErrorNoHalt
local IsValid = IsValid
local Material = Material
local MsgC = MsgC
local error = error
local getmetatable = getmetatable
local include = include
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local tobool = tobool
local tostring = tostring
local type = type
local xpcall = xpcall

local input_IsMouseDown = input.IsMouseDown

local debug_getinfo = debug.getinfo
local debug_getregistry = debug.getregistry

local string_format = string.format

local file_Find = file.Find

local table_Copy = table.Copy
local table_Count = table.Count
local table_KeyFromValue = table.KeyFromValue
local table_remove = table.remove

local render_SetScissorRect = render.SetScissorRect

local gui_MouseX = gui.MouseX
local gui_MouseY = gui.MouseY

local vgui_CursorVisible = vgui.CursorVisible

--------------------------- Main stuffs ---------------------------

s0lame = s0lame or {}

s0lame.__type = "S0LAME"

s0lame.Registry = debug_getregistry()

s0lame.Colors = {
	White = Color(255, 255, 255, 255),
	Black = Color(0, 0, 0, 255),
	Red = Color(255, 0, 0, 255),

	Control = Color(240, 240, 240, 255),
	ControlMedium = Color(172, 172, 172, 255),
	ControlDark = Color(45, 45, 45, 255),

	Error = Color(255, 222, 102)
}

s0lame.Materials = {
	Gradients = {
		Right = Material("vgui/gradient-r"),
		Down = Material("vgui/gradient-d")
	}
}

s0lame.LoadOrder = {
	"sPanel",
	"sLabel",
	"sButton",
	"sFrame",
	"sCheckBox",
	"sSlider",
	"sLabelSlider",
	"sDropDown",
	"sScrollBar",
	"sTextBox",
	"sBinder",
	"sListRow",
	"sList",
	"sColorHueBar",
	"sColorAlphaBar",
	"sColorPicker",
	"sColorButton"
}

s0lame.Elements = {}

s0lame.RenderStack = {}

s0lame.SuppressErrors = false
s0lame.FocusedObject = nil
s0lame.LastObjectID = -2147483648

s0lame.Mouse = {
	CanClickThisFrame = false,
	ClickedThisFrame = nil,

	Left = false,
	Right = false,
	
	Scroll = {
		Up = false,
		Down = false
	},
	
	Dragging = {
		Active = false,
		Object = nil,

		Origin = {
			X = 0,
			Y = 0
		}
	}
}

s0lame.KeyBoard = {
	Typing = false,
	ActiveTyper = nil,

	Chars = { -- Translations because input.GetKeyName isn't good enough; Slightly out of order because yeah; This game sucks
		[KEY_A] = "a",
		[KEY_B] = "b",
		[KEY_C] = "c",
		[KEY_D] = "d",
		[KEY_E] = "e",
		[KEY_F] = "f",
		[KEY_G] = "g",
		[KEY_H] = "h",
		[KEY_I] = "i",
		[KEY_J] = "j",
		[KEY_K] = "k",
		[KEY_L] = "l",
		[KEY_M] = "m",
		[KEY_N] = "n",
		[KEY_O] = "o",
		[KEY_P] = "p",
		[KEY_Q] = "q",
		[KEY_R] = "r",
		[KEY_S] = "s",
		[KEY_T] = "t",
		[KEY_U] = "u",
		[KEY_V] = "v",
		[KEY_W] = "w",
		[KEY_X] = "x",
		[KEY_Y] = "y",
		[KEY_Z] = "z",
		[KEY_0] = "0",
		[KEY_1] = "1",
		[KEY_2] = "2",
		[KEY_3] = "3",
		[KEY_4] = "4",
		[KEY_5] = "5",
		[KEY_6] = "6",
		[KEY_7] = "7",
		[KEY_8] = "8",
		[KEY_9] = "9",
		[KEY_SPACE] = " ",
		[KEY_SLASH] = "/",
		[KEY_BACKSLASH] = "\\",
		[KEY_PAD_0] = "0",
		[KEY_PAD_1] = "1",
		[KEY_PAD_2] = "2",
		[KEY_PAD_3] = "3",
		[KEY_PAD_4] = "4",
		[KEY_PAD_5] = "5",
		[KEY_PAD_6] = "6",
		[KEY_PAD_7] = "7",
		[KEY_PAD_8] = "8",
		[KEY_PAD_9] = "9",
		[KEY_PAD_DIVIDE] = "/",
		[KEY_PAD_MULTIPLY] = "*",
		[KEY_PAD_MINUS] = "-",
		[KEY_PAD_PLUS] = "+",
		[KEY_PAD_DECIMAL] = ".",
		[KEY_APOSTROPHE] = "'",
		[KEY_BACKQUOTE] = "`",
		[KEY_COMMA] = ",",
		[KEY_PERIOD] = ".",
		[KEY_MINUS] = "-",
		[KEY_EQUAL] = "=",
		[KEY_LBRACKET] = "[",
		[KEY_RBRACKET] = "]",
		[KEY_SEMICOLON] = ";"
	},

	ExitChars = {
		[MOUSE_FIRST] = true,
		[MOUSE_LEFT] = true,
		[MOUSE_RIGHT] = true,
		[MOUSE_MIDDLE] = true,
		[KEY_ENTER] = true
	},

	HardExitChars = {
		[KEY_ESCAPE] = true
	}
}

--------------------------- Functions ---------------------------

--[[
	Gets s0lame's __type
]]

function s0lame.GetType()
	return tostring(s0lame.__type)
end

--[[
	Gets type using __type
]]

function s0lame.GetRealType(Object)
	local ObjectMeta = getmetatable(Object)

	if ObjectMeta and ObjectMeta.__type then
		if type(ObjectMeta.__type) == "function" then
			return ObjectMeta.__type(Object)
		else
			return ObjectMeta.__type
		end
	end

	return type(Object)
end

--[[
	Easy argument checking
]]

function s0lame.CheckValueType(Index, Value, Desired)
	if not s0lame.Assert(type(Index) == "number", "Bad argument #1 to 'CheckValueType' (number expected, got " .. type(Index) .. ")") then return end
	if not s0lame.Assert(type(Desired) == "string", "Bad argument #3 to 'CheckValueType' (string expected, got " .. type(Desired) .. ")") then return end

	local dbg = debug_getinfo(2)
	local dbgname = dbg and (dbg.name or dbg.short_src or dbg.source) or "UNKNOWN"

	local ProvidedReal = s0lame.GetRealType(Value)
	local Provided = type(Value)

	if ProvidedReal ~= Desired and Provided ~= Desired then
		s0lame.Error(string_format("Bad argument #%d to '%s' (%s expected, got %s)", Index, dbgname, Desired, Provided))
	end
end

--[[
	Controls if errors should be announced normally or quietly printed
]]

function s0lame.SetSuppressErrors(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	s0lame.SuppressErrors = NewState
end

function s0lame.GetSuppressErrors()
	return s0lame.SuppressErrors
end

--[[
	Handy error function
]]

function s0lame.Error(Message, Halt)
	Message = Message .. "\n"

	if s0lame.GetSuppressErrors() then
		MsgC(s0lame.Colors.Error, Message)
	else -- Regular erroring
		if not Halt then
			ErrorNoHalt(Message)
		else
			error(Message)
		end
	end

	return not Halt
end

--[[
	Handy assert function
]]

function s0lame.Assert(Condition, Message, Halt)
	Message = Message or "Assertion failed"
	Halt = tobool(Halt)

	if not Condition then
		s0lame.Error(Message)
		return false
	end

	return true
end

--[[
	Puts an element into the element table
	Can also be used to create custom elements
]]

function s0lame.RegisterElement(ElementName, ElementMeta, InheritName)
	s0lame.CheckValueType(1, ElementName, "string")
	s0lame.CheckValueType(2, ElementMeta, "table")

	ElementMeta.__eq = function(A, B)
		if A._UID == nil or B._UID == nil then return false end
		return A._UID == B._UID
	end

	s0lame.LastObjectID = s0lame.LastObjectID + 1

	ElementMeta.__sName = ElementName
	ElementMeta.__type = s0lame.GetType()
	ElementMeta.__index = ElementMeta

	ElementMeta.__tostring = function(self)
		return ElementMeta.__type .. " [ " .. ElementMeta.__sName .. " ]"
	end

	if InheritName ~= nil then
		s0lame.CheckValueType(3, InheritName, "string")

		s0lame.Elements[ElementName] = setmetatable(ElementMeta, s0lame.Elements[InheritName])
	else
		s0lame.Elements[ElementName] = ElementMeta
	end
end

--[[
	Registers default elements
]]

function s0lame.RegisterDefaultElements()
	local files, _ = file_Find("lua/s0lame/Elements/*", "MOD")

	local Addition = MENU_DLL and "s0lame/" or ""

	for _, v in ipairs(s0lame.LoadOrder) do
		xpcall(function()
			include(Addition .. "Elements/" .. v .. ".lua")
		end, function(e)
			s0lame.Error(e, false)
		end)
	end

	local comCount = table_Count(s0lame.Elements)

	if comCount < #files then
		local dif = #files - comCount

		s0lame.Error("s0lame - Failed to regsiter " .. dif .. " component" .. (dif ~= 1 and "s" or ""), false)
	end
end

--[[
	Used to create elements
]]

function s0lame.Create(ElementType, ElementParent)
	s0lame.CheckValueType(1, ElementType, "string")

	local ElementMeta = s0lame.Elements[ElementType]

	if not s0lame.Assert(ElementMeta ~= nil, "Bad argument #1 to 'CreateObject' (Invalid element specified)") then return end
	if not s0lame.Assert(ElementMeta.__type == s0lame.GetType(), "Bad argument #1 to 'CreateObject' (Invalid element specified)") then return end

	local NewElement = setmetatable({
		_UID = s0lame.LastObjectID
	}, ElementMeta)

	s0lame.LastObjectID = s0lame.LastObjectID + 1

	for k, v in pairs(ElementMeta) do
		if type(v) == "table" then
			NewElement[k] = table_Copy(v)
		end
	end

	NewElement:Init()
	NewElement:PostInit()

	if IsValid(ElementParent) then
		NewElement:SetParent(ElementParent)
		NewElement:PostParentInit(ElementParent)
	end

	return NewElement
end

--[[
	Used to update an object's render state
]]

function s0lame.UpdateRenderState(Object, NewState)
	s0lame.CheckValueType(1, Object, s0lame.GetType())
	s0lame.CheckValueType(2, NewState, "boolean")

	local ObjectKey = table_KeyFromValue(s0lame.RenderStack, Object)

	if NewState then
		if not ObjectKey then
			s0lame.RenderStack[#s0lame.RenderStack + 1] = Object
		end
	else
		if ObjectKey then
			table_remove(s0lame.RenderStack, ObjectKey)
		end
	end
end

--[[
	Check if an object is within another
]]

function s0lame.ObjectInBounds(Object, pObject)
	if Object:GetIgnoreParentBounds() or not IsValid(pObject) then return true end

	s0lame.CheckValueType(1, Object, s0lame.GetType())
	s0lame.CheckValueType(2, pObject, s0lame.GetType())

	local XPos, YPos = Object:GetPos()
	local Left, Top, _, _ = Object:GetMargin()

	XPos = XPos + Left
	YPos = YPos + Top

	local pXPos, pYPos, pWidth, pHeight = pObject:GetX(), pObject:GetY(), pObject:GetWidth(), pObject:GetHeight()
	local pLeft, pTop, pRight, pBottom = pObject:GetMargin()

	pXPos = pXPos + pLeft
	pYPos = pYPos + pTop

	pWidth = pWidth - pRight
	pHeight = pHeight - pBottom

	return XPos >= pXPos and XPos <= pXPos + pWidth and YPos >= pYPos and YPos <= pYPos + pHeight
end

--[[
	Used to safely render objects
]]

function s0lame.RenderObject(Object, UpdateClipping)
	if not IsValid(Object) then return false end
	if not Object:GetVisible() then return false end

	if not Object:ShouldPaint() then return true end -- Can't paint, but don't remove from render stack
	if not s0lame.ObjectInBounds(Object, Object:GetParent()) then return true end

	xpcall(function()
		xOffset = xOffset or 0
		yOffset = yOffset or 0

		local XPos, YPos, Width, Height = Object:GetX(), Object:GetY(), Object:GetWidth(), Object:GetHeight()
		local Left, Top, Right, Bottom = Object:GetMargin()

		if UpdateClipping then
			render_SetScissorRect(XPos, YPos, XPos + Width, YPos + Height, true) -- Can't have more than 1 of these at a time :(
		end

		local oPush = false
		local pPush = false

		if Object:GetHasStencil() then
			oPush = true
			Object:PushStencil()
		end

		if Object:GetParentHasStencil() then
			pPush = true
			Object:GetParent():PushStencil()
		end

		Object:PaintBackground(XPos, YPos, Width, Height)
		Object:Paint(XPos, YPos, Width, Height)
		Object:PaintOverlay(XPos, YPos, Width, Height)

		if oPush then Object:PopStencil() end
		if pPush then Object:GetParent():PopStencil() end
		
		if s0lame.Mouse.CanClickThisFrame and Object:GetClickable() and s0lame.CursorInObject(Object) then
			s0lame.Mouse.ClickedThisFrame = Object
		end

		if UpdateClipping then
			render_SetScissorRect(XPos + Left, YPos + Top, XPos + Width - Right, YPos + Height - Bottom, true)
		end

		for _, v in ipairs(Object:GetChildren()) do
			s0lame.RenderObject(v, false)
		end

		Object:NoClipPaint(XPos, YPos, Width, Height)

		if UpdateClipping then
			render_SetScissorRect(0, 0, 0, 0, false)
		end

		Object:Think()
	end, function(e)
		s0lame.Error(e, false)
	end)

	return true
end

--[[
	Used to test if the cursor is within a box
]]

function s0lame.CursorInBounds(x1, y1, x2, y2)
	s0lame.CheckValueType(1, x1, "number")
	s0lame.CheckValueType(2, y1, "number")
	s0lame.CheckValueType(3, x2, "number")
	s0lame.CheckValueType(4, y2, "number")

	local MouseX, MouseY = gui_MouseX(), gui_MouseY()

	return MouseX >= x1 and MouseY >= y1 and MouseX <= x2 and MouseY <= y2
end

--[[
	Used to test if the cursor is within an object's bounds
]]

function s0lame.CursorInObject(Object)
	s0lame.CheckValueType(1, Object, s0lame.GetType())

	local x, y = Object:GetPos()
	local w, h = Object:GetSize()

	return s0lame.CursorInBounds(x, y, x + w, y + h)
end

--[[
	Returns if something is being drug
]]

function s0lame.GetDragging()
	return s0lame.Mouse.Dragging.Active
end

--[[
	Sets if something is being drug
]]

function s0lame.SetDragging(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	s0lame.Mouse.Dragging.Active = NewState
end

--[[
	Returns what is currently being drug (If anything)
]]

function s0lame.GetDraggingObject()
	return s0lame.Mouse.Dragging.Object
end

--[[
	Sets what is currently being drug (If anything)
]]

function s0lame.SetDraggingObject(Object)
	if Object ~= nil then
		s0lame.CheckValueType(1, Object, s0lame.GetType())
	end

	s0lame.Mouse.Dragging.Object = Object
end

--[[
	Gets the dragging origin
]]

function s0lame.GetDraggingOrigin()
	return s0lame.Mouse.Dragging.Origin.X, s0lame.Mouse.Dragging.Origin.Y
end

--[[
	Sets the dragging origin
]]

function s0lame.SetDraggingOrigin(NewX, NewY)
	s0lame.CheckValueType(1, NewX, "number")
	s0lame.CheckValueType(2, NewY, "number")

	s0lame.Mouse.Dragging.Origin.X = NewX
	s0lame.Mouse.Dragging.Origin.Y = NewY
end

--[[
	Used to request dragging
]]

function s0lame.RequestDragging(Object)
	s0lame.CheckValueType(1, Object, s0lame.GetType())

	if not s0lame.GetDragging() or not IsValid(s0lame.GetDraggingObject()) then
		s0lame.SetDraggingOrigin(gui_MouseX(), gui_MouseY())
		s0lame.SetDraggingObject(Object)
		s0lame.SetDragging(true)

		return true
	else
		return false
	end
end

--[[
	Returns if typing is active
]]

function s0lame.GetTyping()
	return s0lame.KeyBoard.Typing
end

--[[
	Sets if typing is active
]]

function s0lame.SetTyping(NewState)
	s0lame.CheckValueType(1, NewState, "boolean")

	s0lame.KeyBoard.Typing = NewState
end

--[[
	Returns what is being typed to, if anything
]]

function s0lame.GetTypingObject()
	return s0lame.KeyBoard.ActiveTyper
end

--[[
	Sets what is being typed to, if anything
]]

function s0lame.SetTypingObject(Object)
	if Object ~= nil then
		s0lame.CheckValueType(1, Object, s0lame.GetType())
	end

	s0lame.KeyBoard.ActiveTyper = Object
end

--[[
	Requests typing to the given object
]]

function s0lame.RequestTyping(Object)
	s0lame.CheckValueType(1, Object, s0lame.GetType())

	if not s0lame.GetTyping() or not IsValid(s0lame.GetTypingObject()) then
		s0lame.SetTypingObject(Object)
		s0lame.SetTyping(true)

		return true
	else
		return false
	end
end

--[[
	Checks if the given key code is valid or not
]]

function s0lame.CheckKeyCode(Code)
	s0lame.CheckValueType(1, Code, "number")

	return s0lame.KeyBoard.Chars[Code] ~= nil
end

--[[
	Gets the key code from the char table
]]

function s0lame.GetKeyCode(Code)
	s0lame.CheckValueType(1, Code, "number")

	if not s0lame.CheckKeyCode(Code) then
		return ""
	end

	return s0lame.KeyBoard.Chars[Code]
end

--[[
	Checks if a key code is a hard exit key
]]

function s0lame.IsHardExitKeyCode(Code)
	s0lame.CheckValueType(1, Code, "number")

	return s0lame.KeyBoard.HardExitChars[Code] ~= nil
end

--[[
	Checks if a key code is an exit key
]]

function s0lame.IsExitKeyCode(Code)
	s0lame.CheckValueType(1, Code, "number")

	return s0lame.KeyBoard.ExitChars[Code] ~= nil or s0lame.IsHardExitKeyCode(Code)
end

--[[
	Resets typing
]]

function s0lame.ResetTyping()
	s0lame.SetTyping(false)
	s0lame.SetTypingObject(nil)
end

--[[
	Sets focused object
]]

function s0lame.SetFocusedObject(Object)
	if Object ~= nil then
		s0lame.CheckValueType(1, Object, s0lame.GetType())
	end

	s0lame.FocusedObject = Object
end

--[[
	Gets focused object
]]

function s0lame.GetFocusedObject()
	return s0lame.FocusedObject
end

--------------------------- Final Setup ---------------------------

do
	s0lame.Registry.Color.__type = "Color" -- Awesome video game Garry quite amazing honestly the custom `type()` function doesn't work for Colors fantastic

	s0lame.RegisterDefaultElements()

	--[[
		Handles scrolling

		Why does input.IsMouseDown(MOUSE_WHEEL_x) not work, Garry?
		These are janky as fuck because of the whole Derma keyboard focus makes these hooks not work thing
	]]

	hook.Add("PlayerButtonDown", "s0lame_Scroll", function(_, button)
		if button == MOUSE_WHEEL_UP then
			s0lame.Mouse.Scroll.Up = true
		end

		if button == MOUSE_WHEEL_DOWN then
			s0lame.Mouse.Scroll.Down = true
		end
	end)

	hook.Add("PlayerButtonUp", "s0lame_Scroll", function(_, button)
		if button == MOUSE_WHEEL_UP then
			s0lame.Mouse.Scroll.Up = false
		end

		if button == MOUSE_WHEEL_DOWN then
			s0lame.Mouse.Scroll.Down = false
		end
	end)

	--[[
		Renders everything
	]]

	hook.Add("DrawOverlay", "s0lame_Render", function()
		local Invalid = {}

		s0lame.Mouse.CanClickThisFrame = false
		s0lame.Mouse.ClickedThisFrame = nil

		local InputLeftDown = input_IsMouseDown(MOUSE_LEFT)
		local InputRightDown = input_IsMouseDown(MOUSE_RIGHT)

		local LeftDown = false
		local RightDown = false
		local Scroll = s0lame.Mouse.Scroll.Up or s0lame.Mouse.Scroll.Down

		local CursorVisible = vgui_CursorVisible()

		if InputLeftDown then
			if not s0lame.Mouse.Left and CursorVisible then
				LeftDown = true
				s0lame.Mouse.Left = true
			end
		else
			s0lame.Mouse.Left = false
		end

		if InputRightDown then
			if not s0lame.Mouse.Right and CursorVisible then
				RightDown = true
				s0lame.Mouse.Right = true
			end
		else
			s0lame.Mouse.Right = false
		end

		s0lame.Mouse.CanClickThisFrame = LeftDown or RightDown or Scroll

		if s0lame.GetDragging() and not (InputLeftDown or InputRightDown) then
			s0lame.SetDraggingObject(nil)
			s0lame.SetDragging(false)
		end

		for i = 1, #s0lame.RenderStack do
			if not s0lame.RenderObject(s0lame.RenderStack[i], true) then
				Invalid[#Invalid + 1] = i
			end
		end

		if IsValid(s0lame.Mouse.ClickedThisFrame) then
			s0lame.SetFocusedObject(s0lame.Mouse.ClickedThisFrame)

			if LeftDown then
				s0lame.Mouse.ClickedThisFrame:OnLeftClick()
			end

			if RightDown then
				s0lame.Mouse.ClickedThisFrame:OnRightClick()
			end

			if Scroll and IsValid(s0lame.Mouse.ClickedThisFrame.ScrollBar) then
				local ScrollOrigin = s0lame.Mouse.ClickedThisFrame.ScrollBar:GetValue()

				if s0lame.Mouse.Scroll.Up then
					s0lame.Mouse.ClickedThisFrame.ScrollBar:SetValue(ScrollOrigin - 30)
				end

				if s0lame.Mouse.Scroll.Down then
					s0lame.Mouse.ClickedThisFrame.ScrollBar:SetValue(ScrollOrigin + 30)
				end
			end
		end

		for i = 1, #Invalid do
			table_remove(s0lame.RenderStack, Invalid[i])
		end
	end)
end