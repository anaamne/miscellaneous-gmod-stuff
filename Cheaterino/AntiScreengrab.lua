--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Works for:
		https://steamcommunity.com/sharedfiles/filedetails/?id=1342030824
		https://steamcommunity.com/sharedfiles/filedetails/?id=2114254167
]]

local Len = 4294967295 -- UINT32_MAX; Length of data to send for each part
local Delay = 1 -- How many second to wait in between sending next part

local BigData = util.Compress(util.Base64Encode(string.rep("a", Len)))
local BigLen = #BigData

local color_white = Color(255, 255, 255, 255)
local color_yellow = Color(255, 255, 0, 255)
local color_green = Color(0, 255, 0, 255)

-- Basic screengrab addon

local function cl_rtxappend2(color, text, ply)
	net.Start("rtxappend2")
		net.WriteColor(color)
		net.WriteString(text)
		net.WriteEntity(ply)
	net.SendToServer()
end

net.Receive("StartScreengrab", function()
	cl_rtxappend2(color_green, "Initializing", LocalPlayer())

	net.Start("ScreengrabInitCallback")
		net.WriteEntity(LocalPlayer())
		net.WriteUInt(Len, 32)
		net.WriteUInt(Len, 32)
		net.WriteFloat(CurTime())
	net.SendToServer()

	cl_rtxappend2(color_white, "Captured " .. Len .. " bytes", LocalPlayer())
	cl_rtxappend2(color_white, Len .. " parts", LocalPlayer())
	cl_rtxappend2(color_green, "Preparing to send data", LocalPlayer())

	local i = 1

	timer.Create("ScreengrabSendPart", Delay, Len, function()
		net.Start("ScreengrabSendPart")
			net.WriteUInt(BigLen, 32)
			net.WriteData(BigData, BigLen)
		net.SendToServer()

		net.Start("Progress")
			net.WriteEntity(LocalPlayer())
			net.WriteFloat((i / Len) / 2)
		net.SendToServer()

		cl_rtxappend2(color_yellow, "Sent " .. i .. STNDRD(i) .. " part", LocalPlayer())

		i = i + 1

		if i == Len then
			net.Start("ScreengrabFinished")
			net.SendToServer()
		end
	end)
end)

net.Receive("ScreengrabInterrupted", function()
	timer.Remove("ScreengrabSendPart")
end)

-- Gimme that screen

net.Receive("GimmeThatScreen_Request", function()
	--[[
		Just don't do anything and it'll load infinitely

		GTS has an "Authed" check and if the screengrab wasn't authorized it won't screengrab
		Doing nothing in here is the same as saying "That screengrab isn't authorized"
	]]
end)
