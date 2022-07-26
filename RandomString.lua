--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local function CoinFlip()
	return math.random(1, 10) > 5
end

local function RandomString(len)
	assert(type(len) == "number", "Bad argument #1 to RandomString (number expected, got )" .. type(len))
	assert(len > 0, "Bad argument #1 to RandomString (number must be > 0)")

	local str = ""

	for i = 1, len do
		local char = CoinFlip() and math.random(65, 90) or (CoinFlip() and math.random(97, 122) or math.random(48, 57)) -- Uppercase, lowercase and numbers

		str = str .. string.char(char)
	end

	return str
end
