--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Wannabe Badster menu base, but without the vgui!

	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
	I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui I hate the vgui
]]

local type = type

bGUI = bGUI or {}

bGUI.Registry = debug.getregistry()
bGUI.ObjectType = "bgui_object"

bGUI.Components = {}
bGUI.PaintOrder = {}

bGUI.MouseDown = {
	Left = false,
	Right = false,

	Dragging = {
		Active = false,
		Object = nil,

		Origin = {
			x = 0,
			y = 0
		}
	}
}

bGUI.LoadOrder = { -- Retarded "fix" (More of a workaround) for the fact that files load in alphabetical order when they need to not do that
	"bPanel",
	"bFrame",
	"bLabel",
	"bButton",
	"bCheckbox",
	"bSlider"
}

bGUI.Colors = {
	White = Color(255, 255, 255, 255),
	Black = Color(0, 0, 0, 255),

	Gray = Color(200, 200, 200, 255),
	DarkGray = Color(24, 24, 24, 255)
}

surface.CreateFont("bGUI", { -- Shit ass CenterPrintText is additive
	font = "Trebuchet MS",
	size = 18,
	weight = 900,
	antialias = true,
	additive = false
})

surface.CreateFont("bGUI_Small", {
	font = "Trebuchet MS",
	size = 16,
	weight = 600,
	antialias = true,
	additive = false
})

--[[
	Returns the type of all bGUI objects
]]

function bGUI.GetType()
	return bGUI.ObjectType
end

--[[
	Rather than overriding the global type function to support the custom type,
	this function is used instead
]]

function bGUI.TypeOf(obj)
	if type(obj) == "table" and obj.__type then
		return obj.__type
	end

	local objtable = getmetatable(obj)

	return objtable and objtable.__type or type(obj)
end

--[[
	Quick and easy way to verify function arguments, basically an easier version of assert()
]]

function bGUI.CheckValueType(index, value, requiredType, eMessage)
	assert(type(index) == "number", "Bad argument #1 to CheckValueType (number expeced, got " .. type(index) .. ")")
	assert(type(requiredType) == "string", "Bad argument #3 to CheckValueType (string expeced, got " .. type(requiredType) .. ")")

	local vType = bGUI.TypeOf(value)
	local dbg = debug.getinfo(2)

	if not dbg or not dbg.name then
		ErrorNoHalt("bGUI.GetValueType - Failed to get debug information")
		return
	end

	eMessage = eMessage or "Bad argument #%d to " .. dbg.name .. " (%s expected, got %s)"

	if vType ~= requiredType then
		error(string.format(eMessage, index, requiredType, vType))
	end
end

--[[
	Similar to above except it checks the values themselves rather than just their types
]]

function bGUI.AssertValue(index, value, testValue, eMessage)
	assert(type(index) == "number", "Bad argument #1 to AssertValue (number expeced, got " .. type(index) .. ")")

	local dbg = debug.getinfo(2)

	if not dbg or not dbg.name then
		ErrorNoHalt("bGUI.AssertValue - Failed to get debug information")
		return
	end

	eMessage = eMessage or "Bad argument #%d to " .. dbg.name .. " (%s expected, got %s)"

	if value ~= testValue then
		error(string.format(eMessage, index, bGUI.TypeOf(testValue), bGUI.TypeOf(value)))
	end
end

--[[
	Returns if something is being drug by the mouse cursor
]]

function bGUI.GetDraggingActive()
	return bGUI.MouseDown.Dragging.Active
end

--[[
	Returns WHAT is being drug by the mouse cursor
]]

function bGUI.GetDraggingObject()
	return bGUI.MouseDown.Dragging.Object
end

--[[
	Returns the drag origin
]]

function bGUI.GetDraggingOrigin()
	return bGUI.MouseDown.Dragging.Origin.x, bGUI.MouseDown.Dragging.Origin.y
end

--[[
	Used to update drag origin
]]

function bGUI.UpdateDraggingOrigin()
	bGUI.MouseDown.Dragging.Origin.x = gui.MouseX()
	bGUI.MouseDown.Dragging.Origin.y = gui.MouseY()
end

--[[
	Used to change drag status
]]

function bGUI.SetDraggingActive(newState)
	bGUI.CheckValueType(1, newState, "boolean")

	bGUI.MouseDown.Dragging.Active = newState
end

--[[
	Used to change drag object
]]

function bGUI.SetDraggingObject(newObject)
	bGUI.CheckValueType(1, newObject, bGUI.GetType())

	bGUI.MouseDown.Dragging.Object = newObject
end

--[[
	Quick and easy way to enable dragging for the requested object
]]

function bGUI.RequestDragging(object)
	bGUI.CheckValueType(1, object, bGUI.GetType())

	if not bGUI.GetDraggingActive() or not IsValid(bGUI.GetDraggingObject()) then
		bGUI.UpdateDraggingOrigin()
		bGUI.SetDraggingObject(object)
		bGUI.SetDraggingActive(true)
	end
end

--[[
	Tests if cursor is within a certain area
]]

function bGUI.CursorInBounds(x, y, x2, y2)
	bGUI.CheckValueType(1, x, "number")
	bGUI.CheckValueType(2, y, "number")
	bGUI.CheckValueType(3, x2, "number")
	bGUI.CheckValueType(4, y2, "number")

	local mX, mY = gui.MouseX(), gui.MouseY()

	return mX >= x and mY >= y and mX <= x2 and mY <= y2
end

--[[
	Tests if cursor is within an object's bounds
]]

function bGUI.CursorInObject(object)
	bGUI.CheckValueType(1, object, bGUI.GetType())

	local x, y = object:GetX(), object:GetY()
	local w, h = object:GetClickBounds()

	return bGUI.CursorInBounds(x, y, x + w, y + h)
end

--[[
	A combination of table.HasValue and table.KeyFromValue
]]

function bGUI.TableHasValue(tbl, value)
	bGUI.CheckValueType(1, tbl, "table")
	assert(value, "Bad argument #1 to TableHasValue (value expeced, got " .. type(value) .. ")")

	local key = table.KeyFromValue(tbl, value)

	return key ~= nil, key
end

--[[
	Used to register an object for painting
]]

function bGUI.RegisterElementPaint(object)
	bGUI.CheckValueType(1, object, bGUI.GetType())

	if not object:GetVisible() then
		return
	end

	if not table.HasValue(bGUI.PaintOrder, object) then
		bGUI.PaintOrder[#bGUI.PaintOrder + 1] = object
	end
end

--[[
	Used to shift an object forward / backward in the paint queue
]]

function bGUI.ShiftElementPaintPosition(object, shift)
	bGUI.CheckValueType(1, object, bGUI.GetType())
	bGUI.CheckValueType(2, shift, "number")

	if not object:GetVisible() then return end

	local has, key = bGUI.TableHasValue(bGUI.PaintOrder, object)

	if has then
		local newKey = math.Round(math.Clamp(key + shift, 1, #bGUI.PaintOrder))

		table.remove(bGUI.PaintOrder, key)
		table.insert(bGUI.PaintOrder, newKey, object)
	end
end

--[[
	Used to set an object's position in the paint queue
]]

function bGUI.SetElementPaintPosition(object, pos)
	bGUI.CheckValueType(1, object, bGUI.GetType())
	bGUI.CheckValueType(2, pos, "number")

	if not object:GetVisible() then return end

	local has, key = bGUI.TableHasValue(bGUI.PaintOrder, object)

	if has then
		table.remove(bGUI.PaintOrder, key)
		table.insert(bGUI.PaintOrder, math.Round(pos), object)
	end
end

--[[
	Used internally to register elements, can be used to create custom bGUI elements
]]

function bGUI.RegisterElement(eType, meta, inherit)
	bGUI.CheckValueType(1, eType, "string")
	bGUI.CheckValueType(2, meta, "table")

	bGUI.Components[eType] = meta

	meta.__type = bGUI.GetType()
	meta.__index = meta

	if type(inherit) == "string" then
		meta._bBase = inherit

		setmetatable(meta, bGUI.Components[inherit])
	end

	meta._bElementType = eType

	meta.__tostring = function()
		return meta.__type .. " [ " .. meta._bElementType .. " ]"
	end
end

--[[
	Used to paint objects while avoiding problems, intentional scarce IsValid checking for performance.
	Also runs the object's Think() hook
]]

function bGUI.PaintObject(object, x, y, w, h)
	if not object:GetVisible() then return end

	local parent = object:GetParent()

	if IsValid(parent) and not parent:GetVisible() then return end

	xpcall(function()
		object:PaintBackground(x, y, w, h)
		object:Paint(x, y, w, h)
		object:PaintOverlay(x, y, w, h)

		object:Think()
	end, function(e)
		ErrorNoHalt(e)
	end)
end

--[[
	Used to register all elements within the garrysmod/lua/bGUI/Elements folder
]]

function bGUI.RegisterElementsFromFiles()
	local files, _ = file.Find("lua/bGUI/Elements/*", "MOD")

	for _, v in ipairs(bGUI.LoadOrder) do
		xpcall(function()
			include("Elements/" .. v .. ".lua")
		end, function(e)
			ErrorNoHalt(e)
		end)
	end

	local comCount = table.Count(bGUI.Components)

	if comCount < #files then
		local dif = #files - comCount

		ErrorNoHalt("bGUI.RegisterElementsFromFiles - Failed to regsiter " .. dif .. " component" .. (dif ~= 1 and "s" or ""))
	end
end

--[[
	Used to create bGUI components
]]

function bGUI.CreateElement(eType, parent)
	bGUI.CheckValueType(1, eType, "string")

	local ElementMeta = bGUI.Components[eType]

	assert(ElementMeta ~= nil, "Bad argument #1 to CreateElement (invalid component specified)")
	assert(ElementMeta.__type == bGUI.GetType(), "Bad argument #1 to CreateElement (invalid component specified)") -- Check for invalid insertions

	local NewElement = setmetatable({}, ElementMeta)

	if IsValid(parent) then
		NewElement:SetParent(parent)
	end

	timer.Simple(0, function()
		NewElement:Init()
	end)

	return NewElement
end

-- Final steps

do
	bGUI.RegisterElementsFromFiles()

	-- Fix up some metatables to make things easier down the road

	bGUI.Registry.Color.MetaID = TYPE_COLOR
	bGUI.Registry.Color.__type = "Color"

	-- Render the panels

	hook.Add("PostRenderVGUI", "bGUI_Paint", function()
		local PanelToClick = nil

		local iLeftMouseDown = input.IsMouseDown(MOUSE_LEFT)
		local iRightMouseDown = input.IsMouseDown(MOUSE_RIGHT)
		local LeftMouseDown = false
		local RightMouseDown = false

		if iLeftMouseDown then
			if not bGUI.MouseDown.Left and vgui.CursorVisible() then
				LeftMouseDown = true
				bGUI.MouseDown.Left = true
			end
		else
			bGUI.MouseDown.Left = false
		end

		if iRightMouseDown then
			if not bGUI.MouseDown.Right and vgui.CursorVisible() then
				RightMouseDown = true
				bGUI.MouseDown.Right = true
			end
		else
			bGUI.MouseDown.Right = false
		end

		local Clicking = LeftMouseDown or RightMouseDown

		if not (iLeftMouseDown or iRightMouseDown) and bGUI.GetDraggingActive() then
			bGUI.SetDraggingActive(false)
			bGUI.SetDraggingObject(nil)
		end

		local remove = {}

		for k, v in ipairs(bGUI.PaintOrder) do
			if not IsValid(v) or not v:GetVisible() or not v.Paint then
				remove[#remove + 1] = k

				continue
			end

			local vX, vY, vW, vH = v:GetX(), v:GetY(), v:GetWidth(), v:GetHeight()

			render.SetScissorRect(vX, vY, vX + vW, vY + vH, true)

			bGUI.PaintObject(v, vX, vY, vW, vH)

			if Clicking and bGUI.CursorInObject(v) then
				PanelToClick = v
			end

			for _, c in ipairs(v:GetChildren()) do
				vX, vY, vW, vH = c:GetX(), c:GetY(), c:GetWidth(), c:GetHeight()
				bGUI.PaintObject(c, vX, vY, vW, vH)

				if Clicking and bGUI.CursorInObject(v) then
					PanelToClick = v
				end
			end
		end

		render.SetScissorRect(0, 0, 0, 0, false)

		for _, v in ipairs(remove) do
			table.remove(bGUI.PaintOrder, v)
		end

		if IsValid(PanelToClick) then
			if LeftMouseDown then
				PanelToClick:OnLeftClick()
			end

			if RightMouseDown then
				PanelToClick:OnRightClick()
			end
		end
	end)
end