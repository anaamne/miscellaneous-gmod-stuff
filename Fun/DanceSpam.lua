--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	ConVars:
		dancespam_gesture	-	Controls the gesture to spam (Default: "dance")
]]

local Act = CreateClientConVar("dancespam_gesture", "dance", true, false, "")

local Wait = false
local Gamemode = engine.ActiveGamemode()

local meta_cd = debug.getregistry().CUserCmd
local Backup = table.Copy(meta_cd)

local IsValid = IsValid
local debug_getinfo = debug.getinfo
local drive_CalcView = drive.CalcView
local player_manager_RunClass = player_manager.RunClass
local table_Copy = table.Copy
local timer_Simple = timer.Simple

local GestureLookup = {
	agree = ACT_GMOD_GESTURE_AGREE,
	becon = ACT_GMOD_GESTURE_BECON,
	bow = ACT_GMOD_GESTURE_BOW,
	cheer = ACT_GMOD_TAUNT_CHEER,
	dance = ACT_GMOD_TAUNT_DANCE,
	disagree = ACT_GMOD_GESTURE_DISAGREE,
	forward = ACT_SIGNAL_FORWARD,
	group = ACT_SIGNAL_GROUP,
	halt = ACT_SIGNAL_HALT,
	laugh = ACT_GMOD_TAUNT_LAUGH,
	muscle = ACT_GMOD_TAUNT_MUSCLE,
	pose = ACT_GMOD_TAUNT_PERSISTENCE,
	robot = ACT_GMOD_TAUNT_ROBOT,
	salute = ACT_GMOD_TAUNT_SALUTE,
	wave = ACT_GMOD_GESTURE_WAVE,
	zombie = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
}

meta_cd.ClearButtons = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.ClearButtons(...)
end

meta_cd.ClearMovement = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.ClearMovement(...)
end

meta_cd.SetViewAngles = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.SetViewAngles(...)
end

hook.Add("Tick", "DanceSpam", function()
	local Gesture = Act:GetString()

	local dGesture = GestureLookup[Gesture]
	if not dGesture then return end

	if Gamemode == "darkrp" then
		if Wait then return end

		LocalPlayer():ConCommand("_DarkRP_DoAnimation " .. dGesture)

		local sID, sLen = LocalPlayer():LookupSequence(LocalPlayer():GetSequenceName(LocalPlayer():SelectWeightedSequence(dGesture)))
		if not sID or not sLen then return end

		Wait = true

		timer_Simple(sLen, function()
			Wait = false
		end)
	else
		if LocalPlayer():IsPlayingTaunt() then
			Wait = true
		else
			LocalPlayer():ConCommand("act " .. Gesture)
			Wait = false
		end
	end
end)

hook.Add("CalcView", "DanceSpam", function(ply, pos, ang, fov, zn, zf)
	if not IsValid(ply) or not Wait then return end

	local view = {
		origin = pos,
		angles = ang,
		fov = fov,
		znear = zn,
		zfar = zf
	}

	local vehicle = ply:GetVehicle()

	if IsValid(vehicle) then
		return hook.Run("CalcVehicleView", vehicle, ply, view)
	end

	if drive_CalcView(ply, view) then return view end

	-- Fix for taunt_camera breaking thirdperson camera with these detours in place

	local pView = { origin = view.origin }
	player_manager_RunClass(ply, "CalcView", pView)

	local offset = (pView.origin - view.origin):Length()

	view.origin = view.origin - (view.angles:Forward() * offset)

	local weapon = ply:GetActiveWeapon()

	if IsValid(weapon) then
		local wCalcView = weapon.CalcView

		if wCalcView then
			view.origin, view.angles, view.fov = wCalcView(weapon, ply, view.origin * 1, view.angles * 1, view.fov)
		end
	end

	return view
end)
