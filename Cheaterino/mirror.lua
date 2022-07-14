--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Basic mirror visual
]]

local Stuff = {
	MirrorData = {
		x = 10,
		y = 10,
		w = 300,
		h = 200,

		trace = {
			mins = Vector(-8, -8, -8),
			maxs = Vector(8, 8, 8)
		},

		flip = Angle(0, 180, 0)
	},

	CalcView = {
		pos = LocalPlayer():EyePos(),
		ang = LocalPlayer():EyeAngles(),
		fov = LocalPlayer():GetFOV(),
		znear = 1,
		zfar = 30000,
		offset = vector_origin
	}
}

local Mirror = vgui.Create("DFrame")

Mirror:SetTitle("")
Mirror:ShowCloseButton(false)
Mirror:SetSize(Stuff.MirrorData.w, Stuff.MirrorData.h)
Mirror:SetPos(Stuff.MirrorData.x, Stuff.MirrorData.y)
Mirror:SetMouseInputEnabled(false)
Mirror:SetKeyboardInputEnabled(false)
Mirror:SetDraggable(false)
Mirror:SetSizable(false)
Mirror:SetVisible(true)

Mirror.Paint = function(self, w, h)
	local x, y = self:GetPos()

	local newAng = Stuff.CalcView.ang + Stuff.MirrorData.flip

	local tr = util.TraceHull({
		start = Stuff.CalcView.pos,
		endpos = LocalPlayer():EyePos() - Stuff.CalcView.offset,
		filter = LocalPlayer(),
		mins = Stuff.MirrorData.trace.mins,
		maxs = Stuff.MirrorData.trace.maxs,
	})

	local oClip = DisableClipping(true)

	render.RenderView({
		origin = tr.HitPos + tr.HitNormal,
		angles = newAng,
		fov = Stuff.CalcView.fov,
		znear = Stuff.CalcView.znear,
		zfar = Stuff.CalcView.zfar,

		drawhud = false,
		drawmonitors = true,
		drawviewmodel = false,
		dopostprocess = true,
		bloomtone = false, -- Stop stupid wa-wa effect with the HDR

		x = x,
		y = y,
		w = w,
		h = h
	})

	DisableClipping(oClip)
end

hook.Add("CalcView", "_____@@@@@", function(ply, pos, ang, fov, zn, zf)
	if not IsValid(ply) then return end

	Stuff.CalcView.pos = pos
	Stuff.CalcView.ang = ang
	Stuff.CalcView.fov = fov
	Stuff.CalcView.znear = zn
	Stuff.CalcView.zfar = zf
	Stuff.CalcView.offset = pos - ply:EyePos()
end)
