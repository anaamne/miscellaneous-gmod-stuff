--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local ScrW = ScrW()
local ScrH = ScrH()

local w, h = ScrW * (300 / 1920), ScrH * (200 / 1080)
local x, y = (ScrW / 2) - (w / 2), (ScrH / 2) - (h / 2)
local dir = math.random(0, 360)
local speed = 1

local mat = Material("models/kleiner/walter_face")

local DirLookup = {}

for i = 0, 360 do
	DirLookup[i] = i * (math.pi / 180)
end

local function GetDeltaTime()
	return RealFrameTime() * 200
end

hook.Add("HUDPaint", "DVD_HUDPaint", function()
	local dist = speed * GetDeltaTime()

	local xDir = math.sin(DirLookup[(dir + 90) % 360]) * dist
	local yDir = math.cos(DirLookup[(dir + 90) % 360]) * dist

	x = math.Round(x + xDir)
	y = math.Round(y + yDir)

	if x < 0 or y < 0 or x + w > ScrW or y + h > ScrH then
		dir = (dir + 270) % 360
	end

	surface.SetMaterial(mat)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(x, y, w, h)

	surface.SetFont("CloseCaption_Bold")
	surface.SetTextColor(color_white)

	local tw, th = surface.GetTextSize("DVD")

	surface.SetTextPos(x + ((w / 2) - (tw / 2)), y + 30)
	surface.DrawText("DVD")
end)

hook.Add("OnScreenSizeChanged", "DVD_OnScreenSizeChanged", function()
	ScrW = ScrW()
	ScrH = ScrH()

	w, h = ScrW * (300 / 1920), ScrH * (200 / 1080)

	x = math.Clamp(x, 0, ScrW - w)
	y = math.Clamp(y, 0, ScrH - h)
end)
