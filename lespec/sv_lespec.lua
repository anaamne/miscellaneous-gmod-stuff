--[[
	leme's sub par spectate lua thing

	!spectate (player name/steamid/steamid64)
]]

if CLIENT then return end

util.AddNetworkString("lespec_UpdateSpectator")

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

local function updateSpectate(ply, target)
	if not IsValid(ply) then
		return
	end

	ply.lespec = ply.lespec or {}

	local new = IsValid(target)

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

	if not ply:GetUserGroup():lower():find("admin") then
		if not ply:IsAdmin() or not ply:IsSuperAdmin() then
			return
		end
	end

	local args = msg:Split(" ")

	if args[1]:lower() == "!spectate" then
		if not args[2] then
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

	local targ = ply.lespec.Target

	if not IsValid(targ) or mv:GetVelocity() ~= vector_origin then
		updateSpectate(ply, nil)

		-- Restore weapons

		if ply.lespec.Weapons then
			ply:StripWeapons()
	
			for _, v in ipairs(ply.lespec.Weapons) do
				ply:Give(v)
			end

			ply:SwitchToDefaultWeapon()
		end

		return
	end

	-- Fuck movement somewhat

	mv:SetVelocity(vector_origin)

	-- Weapon stuff
	-- Backup

	if not ply.lespec.Weapons then
		local weps = {}

		for _, v in ipairs(ply:GetWeapons()) do
			weps[#weps + 1] = v:GetClass()
		end

		ply.lespec.Weapons = weps
	end

	-- Spectated player's weapon

	local targwep = targ:GetActiveWeapon()

	if IsValid(targwep) then
		local class = targwep:GetClass()

		if not ply:HasWeapon(class) then
			ply:Give(class)
		end

		ply:SelectWeapon(class)
	end
end)
