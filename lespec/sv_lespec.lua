--[[
	leme's sub par spectate lua thing

	!spectate (player name/steamid/steamid64)
]]

if CLIENT then return end

util.AddNetworkString("lespec_UpdateSpectator")
util.AddNetworkString("lespec_UpdatePosition")

local stuff = {
	lastUpdate = 0,
	tickInterval = engine.TickInterval(),

	spectators = {}
}

player.GetByAnyID = function(param)
	param = param or ""

	local ply = player.GetBySteamID(param) or player.GetBySteamID64(param)

	return IsValid(ply) and ply or nil
end

player.GetByName = function(param)
	param = string.lower(param or "")

	for _, v in ipairs(player.GetAll()) do
		if string.find(string.lower(v:GetName()), param) then
			return v
		end
	end

	return nil
end

debug.getregistry().Player.IsAdminRank = function(ply)
	if not IsValid(ply) then
		return false
	end

	local usergroup = ply:GetUserGroup()

	local rank = sam and sam.ranks.get_rank(usergroup) or nil

	if rank and (rank.data.permissions.admin_mode or rank.inherit:lower():find("admin") or rank.name:lower():find("admin")) then
		return true
	end

	return ply:IsAdmin() or ply:IsSuperAdmin()
end

local function updateSpectate(ply, target)
	if not IsValid(ply) then
		return
	end

	ply.lespec = ply.lespec or {}

	local new = IsValid(target)

	if new then
		local found = false -- Prevent jank

		for _, v in ipairs(stuff.spectators) do
			if v == ply then
				found = true
				break
			end
		end

		if not found then
			-- Register spectator

			stuff.spectators[#stuff.spectators + 1] = ply

			-- Backup weapons

			if not ply.lespec.Weapons then
				local weps = {}
		
				for _, v in ipairs(ply:GetWeapons()) do
					weps[#weps + 1] = v:GetClass()
				end
		
				ply.lespec.Weapons = weps
			end
		end
	else
		for k, v in ipairs(stuff.spectators) do
			if v == ply then
				-- Unregister spectator

				table.remove(stuff.spectators, k)

				-- Restore weapons

				if ply.lespec.Weapons then
					ply:StripWeapons()
					
					for _, v in ipairs(ply.lespec.Weapons) do
						ply:Give(v)
					end
		
					ply:SwitchToDefaultWeapon()

					ply.lespec.Weapons = nil
				end

				break
			end
		end
	end

	ply.lespec.Spectating = new
	ply.lespec.Target = target

	local data = {
		status = new,
		fov = IsValid(target) and target:GetFOV() or 100
	}

	data = util.Compress(util.TableToJSON(data))

	net.Start("lespec_UpdateSpectator")
		net.WriteUInt(#data, 16)
		net.WriteData(data, #data)
		net.WriteEntity(target)
	net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "lespec_PlayerInitialSpawn", function(ply)
	ply.lespec = {}
end)

hook.Add("PlayerSay", "lespec_PlayerSay", function(ply, msg)
	if msg[1] ~= "!"then
		return
	end

	local args = msg:Split(" ")

	if args[1]:lower() == "!spectate" then
		if not ply:IsAdminRank() then
			ply:ChatPrint("You can't spectate")
			return ""
		end

		ply.lespec = ply.lespec or {}

		if ply.lespec.Spectating then
			ply.lespec.Spectating = false
			return ""
		end

		local argstr = ""

		if #args > 1 then
			local argn = {}
			
			for i = 2, #args do
			    argn[#argn + 1] = args[i]
			end

			argstr = table.concat(argn, " ")
		 end

		if not args[2] or argstr == "" then
			return ""
		end

		local target = player.GetByAnyID(args[2]) or player.GetByName(argstr)

		if not IsValid(target) then
			return ""
		end

		updateSpectate(ply, target)

		return ""
	end
end)

hook.Add("SetupMove", "lespec_SetupMove", function(ply, mv, cmd)
	ply.lespec = ply.lespec or {}

	if not ply.lespec.Spectating then
		return
	end

	local target = ply.lespec.Target

	if not IsValid(target) or cmd:GetButtons() ~= 0 then
		updateSpectate(ply, nil)

		return
	end

	-- Spectated player's weapon

	local targetwep = target:GetActiveWeapon()

	if IsValid(targetwep) then
		local class = targetwep:GetClass()

		if not ply:HasWeapon(class) then
			ply:Give(class)
		end

		ply:SelectWeapon(class)
	end
end)	

hook.Add("Tick", "lespec_Tick", function()
	if CurTime() - stuff.lastUpdate <= stuff.tickInterval then
		return
	end

	for _, v in ipairs(stuff.spectators) do
		v.lespec = v.lespec or {}

		local target = v.lespec.Target

		if not IsValid(target) then
			continue
		end

		-- Set positions up properly clientside

		local data = {
			pos = target:EyePos(),
			ang = target:EyeAngles()
		}
		
		data = util.Compress(util.TableToJSON(data))
		
		net.Start("lespec_UpdatePosition")
			net.WriteUInt(#data, 16)
			net.WriteData(data, #data)
		net.Send(v)
	end

	stuff.lastUpdate = CurTime()
end)
