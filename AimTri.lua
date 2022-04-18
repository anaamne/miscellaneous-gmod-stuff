--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	leme's sub-par hitscan style aimbot with an FOV triangle
]]

local stuff = {
	Order = { -- Scan in this order
		HITGROUP_HEAD,
		HITGROUP_CHEST,
		HITGROUP_STOMACH
	},

	CalcView = {
		EyePos = EyePos(),
		EyeAngles = EyeAngles(),
		FOV = LocalPlayer():GetFOV()
	},

	NotGuns = { -- Funny classes
		"bomb",
		"c4",
		"climb",
		"fist",
		"gravity gun",
		"grenade",
		"hand",
		"ied",
		"knife",
		"physics gun",
		"slam",
		"sword",
		"tool gun"
	},

	ActuallyGuns = { -- Even funnier classes
		"handgun"
	},

	FOVTri = {
		{x = 0, y = 0},
		{x = 0, y = 0},
		{x = 0, y = 0},
	},

	ConVars = {
		cl_interp = GetConVar("cl_interp"),
		cl_updaterate = GetConVar("cl_updaterate"),
		cl_interp_ratio = GetConVar("cl_interp_ratio"),

		sv_minupdaterate = GetConVar("sv_minupdaterate"),
		sv_maxupdaterate = GetConVar("sv_maxupdaterate"),
		sv_client_min_interp_ratio = GetConVar("sv_client_min_interp_ratio"),
		sv_client_max_interp_ratio = GetConVar("sv_client_max_interp_ratio")
	},

	ServerTime = CurTime(),
	TickInterval = engine.TickInterval(),

	FOV = 16,
	AimKey = MOUSE_5,
	WaitTicks = 0
}

local function GetEyePos() -- Quickerish ways of getting CalcView information from the CalcView hook
	return stuff.CalcView.EyePos
end

local function GetEyeAngles()
	return stuff.CalcView.EyeAngles
end

local function GetFOV()
	return stuff.CalcView.FOV
end

local function FixAngle(ang)
	ang = ang or angle_zero
	
	return Angle(math.Clamp(math.NormalizeAngle(ang.pitch), -89, 89), math.NormalizeAngle(ang.yaw), math.NormalizeAngle(ang.roll)) -- Fixes an angle to (-89, 89), (-180, 180), (-180, 180)
end

local function WeaponCanShoot(weapon)
	if not IsValid(weapon) or not (weapon.CanPrimaryAttack and weapon:CanPrimaryAttack() or true) then
		return false
	end

	local name = weapon:GetPrintName():lower()

	for _, v in ipairs(stuff.NotGuns) do -- Some guns are retarded
		if name == v then
			return false
		end

		if name:find(v) then
			local breakouter = false

			for _, t in ipairs(stuff.ActuallyGuns) do -- language.Add is dumb
				if name:find(t) then
					breakouter = true
					break
				end
			end

			if breakouter then
				continue
			end

			return false
		end
	end

	return stuff.ServerTime >= weapon:GetNextPrimaryFire()
end

local function IsVisible(pos, ent)
	pos = pos or vector_origin
	
	local tr = util.TraceLine({
		start = GetEyePos(),
		endpos = pos,
		filter = LocalPlayer(),
		mask = MASK_SHOT,
		ignoreworld = false
	})
	
	if ent then
		return tr.Entity == ent -- Tracer hit the entity we wanted it to
	else
		return tr.Fraction == 1 -- Trace didn't hit anything
	end
end

local function ValidEntity(ent) -- Don't try to aim at dumb shit
	if not IsValid(ent) then
		return false
	end

	if ent:GetClass() ~= "player" then -- Some checks below are player only checks
		return true
	end

	return ent ~= LocalPlayer() and ent:Alive() and ent:Team() ~= TEAM_SPECTATOR and ent:GetObserverMode() == 0 and not ent:IsDormant()
end

local function GetSortedPlayers() -- Sorts players by distance (Should be used for rendering ESP but I didn't include ESP here so it's not super useful)
	local ret = {}
	
	for _, v in ipairs(player.GetAll()) do
		if not ValidEntity(v) then
			continue
		end
		
		ret[#ret + 1] = v
	end
	
	local lpos = LocalPlayer():GetPos()
	
	table.sort(ret, function(a, b)
		return a:GetPos():DistToSqr(lpos) > b:GetPos():DistToSqr(lpos)
	end)
	
	return ret
end

local function Sign(p1, p2, p3) -- https://en.wikipedia.org/wiki/Barycentric_coordinate_system
	if not p1 or not p2 or not p3 then return 0 end

	return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

local function IsPointInTriangle(pt, tri)
	if not pt or not tri then return false end

	local v1, v2, v3 = tri[1], tri[2], tri[3]
	local n, p

	local test1 = Sign(pt, v1, v2)
	local test2 = Sign(pt, v2, v3)
	local test3 = Sign(pt, v3, v1)

	n = test1 < 0 or test2 < 0 or test3 < 0
	p = test1 > 0 or test2 > 0 or test3 > 0

	return not (n and p)
end

local function GetHitBoxPositions(entity) -- Scans hitboxes for aim points
	if not IsValid(entity) then
		return nil
	end

	local data = {
		[HITGROUP_HEAD] = {},
		[HITGROUP_CHEST] = {},
		[HITGROUP_STOMACH] = {}
	}

	for hitset = 0, entity:GetHitboxSetCount() - 1 do
		for hitbox = 0, entity:GetHitBoxCount(hitset) - 1 do
			local hitgroup = entity:GetHitBoxHitGroup(hitbox, hitset)

			if not hitgroup or not data[hitgroup] then continue end -- Should be impossible but just in case

			local bone = entity:GetHitBoxBone(hitbox, hitset)
			local mins, maxs = entity:GetHitBoxBounds(hitbox, hitset)

			if not bone or not mins or not maxs then continue end

			local bmatrix = entity:GetBoneMatrix(bone)

			if not bmatrix then continue end

			local pos, ang = bmatrix:GetTranslation(), bmatrix:GetAngles()

			if not pos or not ang then continue end

			mins:Rotate(ang)
			maxs:Rotate(ang)

			table.insert(data[hitgroup], pos + ((mins + maxs) * 0.5))
		end
	end

	return data
end

local function GetBoneDataPosition(bonename) -- Turns bone names into hitgroups so I don't have to do some dumb if-else shit
	if not bonename then
		return nil
	end

	bonename = bonename:lower()

	if bonename:find("head") then
		return HITGROUP_HEAD
	end

	if bonename:find("spine") then
		return HITGROUP_CHEST
	end

	if bonename:find("pelvis") then
		return HITGROUP_STOMACH
	end

	return nil
end

local function GetBonePositions(entity) -- Scans bones
	if not IsValid(entity) then
		return nil
	end

	entity:SetupBones() -- Prevent some matrix issues
	entity:InvalidateBoneCache()

	local data = {
		[HITGROUP_HEAD] = {},
		[HITGROUP_CHEST] = {},
		[HITGROUP_STOMACH] = {}
	}

	for bone = 0, entity:GetBoneCount() - 1 do
		local name = entity:GetBoneName(bone)

		if not name or name == "__INVALIDBONE__" then continue end -- Fuck you and your retarded models

		name = name:lower()

		local boneloc = GetBoneDataPosition(name)

		if not boneloc then continue end

		local bonematrix = entity:GetBoneMatrix(bone)

		if not bonematrix then continue end

		local pos = bonematrix:GetTranslation()

		if not pos then continue end

		table.insert(data[boneloc], pos)
	end

	return data
end

local function GetAimPositions(entity)
	if not IsValid(entity) then
		return nil
	end

	local data = GetHitBoxPositions(entity) or GetBonePositions(entity) or { -- OBBCenter fallback (For error models and whatnot)
		[HITGROUP_HEAD] = {
			entity:LocalToWorld(entity:OBBCenter())
		}
	}

	return data
end

local function GetAimPosition(entity)
	if not IsValid(entity) then
		return nil
	end

	local data = GetAimPositions(entity)

	for _, set in ipairs(stuff.Order) do -- Scans through the positions to find visible ones
		if not data[set] then continue end

		for _, v in ipairs(data[set]) do
			if IsVisible(v, entity) then
				return v
			end
		end
	end

	return nil
end

local function GetTarget(quick) -- Gets the player whose OBBCenter is closest to the center of the screen
	local x, y = ScrW() * 0.5, ScrH() * 0.5

	local best = math.huge
	local entity = nil

	for _, v in ipairs(GetSortedPlayers()) do
		local pos = v:LocalToWorld(v:OBBCenter()):ToScreen() -- Quick checks OBB only
	
		local cur = math.Dist(pos.x, pos.y, x, y)
	
		if cur < best and IsPointInTriangle(pos, stuff.FOVTri) then -- Closest player inside the FOV triangle
			best = cur
			entity = v
		end

		if quick then continue end

		local data = GetAimPositions(v)

		for _, set in ipairs(stuff.Order) do
			if not data[set] then continue end
	
			for _, d in ipairs(data[set]) do
				if not IsVisible(d, v) then continue end

				pos = d:ToScreen()
				cur = math.Dist(pos.x, pos.y, x, y)

				if cur < best and IsPointInTriangle(pos, stuff.FOVTri) then
					best = cur
					entity = v
				end
			end
		end
	end

	return entity
end

local function GetLerp()
	local cl_interp = stuff.ConVars.cl_interp:GetFloat()
	local cl_updaterate = stuff.ConVars.cl_updaterate:GetFloat()
	local cl_interp_ratio = stuff.ConVars.cl_interp_ratio:GetInt()

	local sv_minupdaterate = stuff.ConVars.sv_minupdaterate:GetInt()
	local sv_maxupdaterate = stuff.ConVars.sv_maxupdaterate:GetInt()
	local sv_client_min_interp_ratio = stuff.ConVars.sv_client_min_interp_ratio:GetFloat()
	local sv_client_max_interp_ratio = stuff.ConVars.sv_client_max_interp_ratio:GetFloat()
 
	local ratio = math.Clamp(cl_interp_ratio, sv_client_min_interp_ratio, sv_client_max_interp_ratio)
	local rate = math.Clamp(cl_updaterate, sv_minupdaterate, sv_maxupdaterate)
 
	local lerp = ratio / rate
 
	if lerp <= cl_interp then
        lerp = cl_interp
    end
 
	return lerp
end

local function PredictPos(pos, target)
	pos = pos or vector_origin

	if not IsValid(target) then
		return pos
	end

	return pos + (target:GetVelocity() * stuff.TickInterval * GetLerp()) - (LocalPlayer():GetVelocity() * stuff.TickInterval)
end

hook.Add("Move", "", function()
	if not IsFirstTimePredicted() then return end

	stuff.ServerTime = CurTime()
end)

hook.Add("DrawOverlay", "", function()
	local w = ScrW()
	local x, y = w * 0.5, ScrH() * 0.5
	local fovrad = (math.tan(math.rad(stuff.FOV)) / math.tan(math.rad(GetFOV() * 0.5)) * w) / 2.6

	-- I don't understand this either, I just threw some shit together and it happened to work

	local t = fovrad * 2.33333333333333333
	local s = x - (t / 2)
	local m = fovrad
	local offset_y = 0 - (fovrad / 3)

	stuff.FOVTri = {
		{x = s, y = (y + m) + offset_y},
		{x = s + t, y = (y + m) + offset_y},
		{x = x, y = (y - m) + offset_y}
	}

	local v1, v2, v3 = stuff.FOVTri[1], stuff.FOVTri[2], stuff.FOVTri[3]

	surface.SetDrawColor(color_white)
	surface.DrawLine(v1.x, v1.y, v2.x, v2.y)
	surface.DrawLine(v2.x, v2.y, v3.x, v3.y)
	surface.DrawLine(v3.x, v3.y, v1.x, v1.y)
end)

hook.Add("CreateMove", "", function(cmd)
	if input.IsButtonDown(stuff.AimKey) then
		local target = GetTarget()

		if IsValid(target) then
			local pos = GetAimPosition(target)
			
			if pos then
				pos = PredictPos(pos, target)
	
				cmd:SetViewAngles(FixAngle((pos - GetEyePos()):Angle()))
	
				if not cmd:KeyDown(IN_ATTACK) and WeaponCanShoot(LocalPlayer():GetActiveWeapon()) then -- Tap fires with fully automatic weapons but it's fine
					if stuff.WaitTicks > 1 then
						cmd:AddKey(IN_ATTACK)
					elseif stuff.WaitTicks < 5 then
						stuff.WaitTicks = stuff.WaitTicks + 1
					end
				end
			else
				stuff.WaitTicks = 0
			end
		else
			stuff.WaitTicks = 0
		end
	else
		stuff.WaitTicks = 0
	end
end)

hook.Add("CalcView", "", function(ply, pos, ang, fov) -- Gets CalcView information because EyePos() and EyeAngles() are only reliable in certain situations
	stuff.CalcView.EyePos = pos
	stuff.CalcView.EyeAngles = ang
	stuff.CalcView.FOV = fov
end)
