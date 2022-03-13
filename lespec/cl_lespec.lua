--[[
	leme's sub par spectate lua thing

	!spectate (player name/steamid/steamid64)
]]

if SERVER then return end

local stuff = {
	eyepos = EyePos(),
	weaponcolor = nil
}

local specData = {
	status = false,
	target = nil,
	fov = 100
}

net.Receive("lespec_UpdateSpectator", function()
	local len = net.ReadUInt(16)
    local data = net.ReadData(len)

    if data then
    	data = util.JSONToTable(util.Decompress(data))

    	specData.status = data.status
    	specData.fov = data.fov
    end

    specData.target = net.ReadEntity()
end)

hook.Add("CalcView", "lespec_CalcView", function(ply, pos, ang, fov, zn, zf)
	if not specData.status or not IsValid(specData.target) then
		return
	end

	extratick = false

	local target = specData.target

	pos = target:EyePos()
	ang = target:EyeAngles()
	fov = specData.fov

	local view = {
		origin = pos,
		angles = ang,
		fov = fov,
		znear = zn,
		zfar = zf,
		drawviewer = true
	}

	local v = target:GetVehicle()

	if IsValid(v) then
		stuff.eyepos = view.origin

		return hook.Run("CalcVehicleView", v, target, view)
	end

	local w = target:GetActiveWeapon()

	if IsValid(w) then
		local wCalcView = w.CalcView

		if wCalcView then
			_, _, view.fov = wCalcView(w, target, pos * 1, ang * 1, fov)
		end
	end

	stuff.eyepos = view.origin

	return view
end)

hook.Add("CreateMove", "lespec_CreateMove", function(cmd)
	if not specData.status or not IsValid(specData.target) then
		return
	end

	cmd:ClearButtons()
end)

hook.Add("RenderScreenspaceEffects", "lespec_RenderScreenspaceEffects", function()
	if not specData.status or not IsValid(specData.target) or IsValid(specData.target:GetVehicle()) then
		if stuff.weaponcolor then
			LocalPlayer():SetWeaponColor(stuff.weaponcolor)

			stuff.weaponcolor = nil
		end

		return
	end

	-- Fix viewmodel rendering when spectating

	local target = specData.target

	stuff.weaponcolor = stuff.weaponcolor or LocalPlayer():GetWeaponColor()

	LocalPlayer():SetWeaponColor(target:GetWeaponColor())

	if not IsValid(target:GetActiveWeapon()) then
		return
	end

	local vm = LocalPlayer():GetViewModel()

	if not IsValid(vm) then
		return
	end

	cam.Start3D(stuff.eyepos, EyeAngles())
		cam.IgnoreZ(true)

		vm:DrawModel()

		cam.IgnoreZ(false)
	cam.End3D()
end)

hook.Add("CalcViewModelView", "lespec_CalcViewModelView", function()
	if not specData.status or not IsValid(specData.target) or IsValid(specData.target:GetVehicle()) then
		return
	end

	-- Fix viewmodel positioning when spectating

	if not IsValid(specData.target:GetActiveWeapon()) then
		return
	end

	return stuff.eyepos, EyeAngles()
end)

hook.Add("PrePlayerDraw", "lespec_PrePlayerDraw", function(ply)
	if not specData.status or not IsValid(specData.target) then
		return
	end

	if ply == specData.target then
		return true
	end
end)
