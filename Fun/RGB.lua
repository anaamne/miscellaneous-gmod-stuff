--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local HSVToColor = HSVToColor
local UnPredictedCurTime = UnPredictedCurTime
local setmetatable = setmetatable
local LocalPlayer = LocalPlayer

local meta_cl = debug.getregistry().Color

local rColor = Vector(1, 1, 1)

hook.Add("Think", "RGB", function()
	rColor = setmetatable(HSVToColor((UnPredictedCurTime() % 6) * 60, 1, 1), meta_cl):ToVector()
end)

hook.Add("PrePlayerDraw", "RGB", function(ply)
	if ply ~= LocalPlayer() then return end

	LocalPlayer():SetWeaponColor(rColor)
	LocalPlayer():SetPlayerColor(rColor)
end)

hook.Add("PostPlayerDraw", "RGB", function(ply)
	if ply ~= LocalPlayer() then return end

	LocalPlayer():SetWeaponColor(rColor)
	LocalPlayer():SetPlayerColor(rColor)
end)
