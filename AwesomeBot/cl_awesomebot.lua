--[[
	This file only exists because SendLua is gay
]]

net.Receive("awesomebot_printcommands", function() -- Help command
	local a = string.Split(net.ReadString(), "\n")

	for _, v in ipairs(a) do
		MsgC(Color(222, 222, 222), v .. "\n")
	end
end)

net.Receive("awesomebot_prettycolors", function() -- Used to make pretty colors in chat
	local trollage = net.ReadTable()

	if trollage then
		chat.AddText(unpack(trollage))
	end
end)
