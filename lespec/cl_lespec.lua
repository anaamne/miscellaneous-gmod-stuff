--[[
	leme's sub par spectate lua thing

	!spectate (player name/steamid/steamid64)
]]

if SERVER then return end

local eyepos = EyePos()
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
		eyepos = view.origin
		return hook.Run("CalcVehicleView", v, target, view)
	end

	local w = target:GetActiveWeapon()

	if IsValid(w) then
		local wCalcView = w.CalcView

		if wCalcView then
			view.origin, view.angles, view.fov = wCalcView(w, target, pos * 1, ang * 1, fov)
		end
	end

	eyepos = view.origin

	return view
end)

hook.Add("RenderScreenspaceEffects", "lespec_RenderScreenspaceEffects", function()
	if not specData.status or not IsValid(specData.target) then
		return
	end

	local target = specData.target

	if not IsValid(target:GetActiveWeapon()) then
		return
	end

	local vm = LocalPlayer():GetViewModel()

	if not IsValid(vm) then
		return
	end

	cam.Start3D(eyepos, EyeAngles())
		cam.IgnoreZ(true)

		vm:DrawModel()

		cam.IgnoreZ(false)
	cam.End3D()
end)

hook.Add("CalcViewModelView", "lespec_CalcViewModelView", function(wep, vm, opos, oang, pos, ang)
	if not specData.status or not IsValid(specData.target) then
		return
	end

	local target = specData.target

	if not IsValid(target:GetActiveWeapon()) then
		return
	end

	return eyepos, EyeAngles()
end)

hook.Add("PrePlayerDraw", "lespec_PrePlayerDraw", function(ply)
	if not specData.status or not IsValid(specData.target) then
		return
	end

	if ply == specData.target then
		return true
	end
end)
