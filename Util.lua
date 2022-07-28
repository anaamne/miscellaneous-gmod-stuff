--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Some more utilities
]]

local meta_cl = debug.getregistry().Color
meta_cl.__type = "Color"

local assert = assert
local type = type

util.GetObjectType = function(object) -- Similar to type() but supports __type metafield
	local objectmeta = getmetatable(object)

	if objectmeta and objectmeta.__type then
		if type(objectmeta.__type) == "function" then
			return objectmeta.__type(object)
		else
			return objectmeta.__type
		end
	end

	return type(object)
end

util.TypeAssert = function(index, value, desired) -- Cleans up code a lot, checks if the given value is of the required type
	assert(type(index) == "number", "Bad argument #1 to 'TypeAssert' (number expected, got " .. type(index) .. ")")

	local dtype = util.GetObjectType(desired)

	assert(dtype == "string", "Bad argument #3 to 'TypeAssert' (string expected, got " .. dtype .. ")")

	local dbg = debug.getinfo(2)

	if not dbg or not dbg.name then
		ErrorNoHalt("TypeAssert - Failed to get debug information")
		return
	end

	local real = util.GetObjectType(value)

	if real ~= desired then
		error(string.format("Bad argument #%d to '%s' (%s expected, got %s)", index, dbg.name, desired, real))
	end
end

-- Base HU conversion

util.HUToFeet = function(units) -- Convert Hammer Units into Feet
	util.TypeAssert(1, units, "number")

	return units / 16
end

-- Unit conversions

util.InchesToFeet = function(units)
	util.TypeAssert(1, units, "number")

	return units / 12
end

util.FeetToInches = function(units) -- Convert Feet into Inches
	util.TypeAssert(1, units, "number")

	return units * 12
end

util.FeetToMeters = function(units) -- Convert Feet into Meters
	util.TypeAssert(1, units, "number")

	return units / 3.280839895
end

util.MetersToFeet = function(units) -- Convert Meters into Feet
	util.TypeAssert(1, units, "number")

	return units * 3.280839895
end

util.MetersToCentimeters = function(units) -- Convert Meters into Centimeters
	util.TypeAssert(1, units, "number")

	return units * 100
end

util.InchesToMeters = function(units) -- Convert Inches into Meters
	util.TypeAssert(1, units, "number")

	return util.FeetToMeters(util.InchesToFeet(units))
end

util.MetersToInches = function(units)
	util.TypeAssert(1, units, "number")

	return util.FeetToInches(util.MetersToFeet(units))
end

-- Other HU conversions

util.HUToInches = function(units) -- Convert Hammer Units into Inches
	util.TypeAssert(1, units, "number")

	return util.FeetToInches(util.HUToFeet(units))
end

util.HUToMeters = function(units) -- Convert Hammer Units into Meters
	util.TypeAssert(1, units, "number")

	return util.FeetToMeters(util.HUToFeet(units))
end

util.HUToCentimeters = function(units) -- Convert Hammer Units into Centimeters
	util.TypeAssert(1, units, "number")

	return util.MetersToCentimeters(util.HUToMeters(units))
end

-- Number stuff

util.GetDecimals = function(number) -- Returns how many decimal places a number has
	util.TypeAssert(1, number, "number")

	local decimals = tostring(number):Split(".")

	return decimals[2] and #decimals[2] or 0
end

-- Color stuff

util.FixColor = function(color) -- Fixes a color's R, G, B and A values
	util.TypeAssert(1, color, "Color")

	color.r = math.min(tonumber(color.r) or 0, 255)
	color.g = math.min(tonumber(color.g) or 0, 255)
	color.b = math.min(tonumber(color.b) or 0, 255)
	color.a = math.min(tonumber(color.a) or 0, 255)
end

util.CopyColor = function(color) -- Returns a copy of the provided color
	util.TypeAssert(1, color, "Color")

	local newColor = Color(color:Unpack())

	util.FixColor(newColor)

	return newColor
end

util.TableToColor = function(color) -- Fixes a table to be of the color metatable
	if IsColor(color) then return end -- Already a color, do nothing

	util.TypeAssert(1, color, "table")

	setmetatable(color, meta_cl)
end

-- Client only stuff

if not CLIENT then return end

util.IsInWorld = function(position)
	util.TypeAssert(1, position, "Vector")

	return not util.TraceLine({
		start = position,
		endpos = position,
		collisiongroup = COLLISION_GROUP_WORLD
	}).HitWorld
end
