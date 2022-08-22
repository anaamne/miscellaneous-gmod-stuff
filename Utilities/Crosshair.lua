--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local Cache = {
	Length = 16,
	Thickness = 4,

	X = ScrW() / 2,
	Y = ScrH() / 2,

	Colors = {
		Black = Color(0, 0, 0, 255),
		Red = Color(255, 0, 0, 255)
	}
}

hook.Add("HUDPaint", "ch", function()
	local W = Cache.Length
	local H = Cache.Thickness

	local hW = W / 2
	local hH = H / 2

	surface.SetDrawColor(Cache.Colors.Black)
	surface.DrawRect(Cache.X - hW, Cache.Y - hH, W, H)
	surface.DrawRect(Cache.X - hH, Cache.Y - hW, H, W)

	surface.SetDrawColor(Cache.Colors.Red)
	surface.DrawRect(Cache.X - hW + 1, Cache.Y - hH + 1, W - 2, H - 2)
	surface.DrawRect(Cache.X - hH + 1, Cache.Y - hW + 1, H - 2, W - 2)
end)

hook.Add("OnScreenSizeChanged", "ch", function()
	Cache.X = ScrW() / 2
	Cache.Y = ScrH() / 2
end)
