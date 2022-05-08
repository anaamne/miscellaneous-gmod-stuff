--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local RAIN = Material("particle/water/waterdrop_001a_refract")

local RAIN_MIN = -256
local RAIN_MAX = 256
local RAIN_SPEED = 10
local RAIN_DIR = Vector(-0.55, 0.03, -0.83)

local RAIN_STATE = {}

local CURRENT_TICK = 0

local function MakeRainVector()
	return Vector(math.random(RAIN_MIN, RAIN_MAX), math.random(RAIN_MIN, RAIN_MAX), math.random(RAIN_MIN, RAIN_MAX))
end

local function IsInGround(pos)
	return util.TraceLine({
		start = pos,
		endpos = pos
	}).HitWorld
end

for i = 1, 3000 do
	RAIN_STATE[#RAIN_STATE + 1] = {MakeRainVector(), RAIN_SPEED}
end

hook.Add("Tick", "weather", function()
	for i = 1, #RAIN_STATE do
		local nextpos = RAIN_STATE[i][1] + (RAIN_DIR * RAIN_STATE[i][2])
		
		if IsInGround(nextpos) then
			nextpos = MakeRainVector()
		end
		
		RAIN_STATE[i][1] = nextpos
	end
end)

hook.Add("PreDrawEffects", "weather", function()
	if not util.IsSkyboxVisibleFromPoint(LocalPlayer():EyePos()) then return end

	local lpos = LocalPlayer():GetPos()
	local dir = LocalPlayer():GetForward() * -1
	
	render.SetMaterial(RAIN)
	
	for i = 1, #RAIN_STATE do
		local pos = lpos + RAIN_STATE[i][1]
		
		render.DrawQuadEasy(pos, dir, 8, 8, color_white, 180)
	end
end)
