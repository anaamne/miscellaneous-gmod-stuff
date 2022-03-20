--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Projectile prediction for m9k rpg7, m202, m79gl, ex41 and matador
]]

local lp = LocalPlayer()

local pred = {
	data = {
		m9k_rpg7 = {
			starts = {6, -5}, -- Start position multipliers
			fvm = (115 * 52.5) / 66, -- How the velocity works
			dvm = (147 * 39.37) / 66, -- How much to remove from velocity each tick
			rad = 180, -- Explosion radius to show,
			startm = 2 -- What to multiply startfwd by
		},

		m9k_m202 = {
			starts = {5, 0.5},
			fvm = (115 * 52.5) / 66,
			dvm = 500,
			rad = 180,
			startm = 2
		},

		m9k_m79gl = {
			starts = {6, -5},
			fvm = (75 * 52.5) / 66,
			dvm = 350,
			rad = 105,
			startm = 1
		},

		m9k_ex41 = {
			starts = {6, -5},
			fvm = (80 * 52.5) / 66,
			dvm = 350,
			rad = 105,
			startm = 1
		},

		m9k_matador = {
			starts = {0, 0},
			fvm = (250 * 52.5) / 66,
			dvm = 200,
			rad = 135,
			startm = 1.5
		}
	}
}

local dfvm = pred.data.m9k_rpg7.fvm -- Fallback
local sub = Vector(0, 0, 0.111) -- Falls by this much extra every tick
local gravity = Vector(0, 0, 6)

local color_orange = Color(255, 150, 0, 255)

local hitpos = nil
local hitcol = color_white
local hitposhit = false
local lines = {}

local servertime = 0

local function isInWorld(pos) -- util.IsInWorld but clientside
	pos = pos or vector_origin

	local tr = util.TraceLine({
		start = pos,
		endpos = pos
	})

	return tr.HitWorld
end

local function getWepData()
	local wep = LocalPlayer():GetActiveWeapon()

	if not IsValid(wep) then
		return nil
	end


end

hook.Add("Move", "", function()
	if not IsFirstTimePredicted() then return end

	servertime = CurTime()
end)

hook.Add("CreateMove", "", function(cmd)
	lines = {}

	local wep = LocalPlayer():GetActiveWeapon()

	if not IsValid(wep) then
		hitpos = nil

		return
	end

	local class = wep:GetClass()

	if not pred.data[class] or wep:GetNextPrimaryFire() > servertime then
		hitpos = nil

		return
	end

	local fvm = pred.data[class].fvm
	local dvm = pred.data[class].dvm

	local aimvector = lp:GetAimVector()
	local side = aimvector:Cross(vector_up)
	local up = side:Cross(aimvector)

	local starts = pred.data[class].starts

	local startpos = lp:GetShootPos() + (side * starts[1]) + (up * starts[2]) -- The weapon spawns the rocket here
	local startfwd = lp:EyeAngles():Forward() * fvm

	local curfwd = Vector(startfwd.x, startfwd.y, startfwd.z) -- Copy vector
	local curfvm = fvm
	local curpos = startpos

	lines[1] = startpos

	hitposhit = false

	local sm = pred.data[class].startm

	while not isInWorld(curpos) do
		local tr = util.TraceLine({
			start = curpos,
			endpos = curpos + curfwd,
			filter = lp
		})

		if tr.Hit then -- Pevent going through walls
			curpos = tr.HitPos
			hitposhit = true

			break
		end

		curpos = curpos + curfwd
		curfwd = (curfwd - (curfwd / dvm) + (startfwd * sm) - sub) - gravity -- Doesn't include the randomness for obvious reasons

		lines[#lines + 1] = curpos
	end

	hitpos = curpos
	hitcol = color_white

	local tr = util.TraceLine({
		start = hitpos,
		endpos = hitpos + (startfwd * 15),
		filter = lp
	})

	if tr.Hit then
		hitposhit = not tr.HitSky

		if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
			hitcol = color_red
		end
	end

	lines[#lines + 1] = curpos
end)

hook.Add("PostDrawTranslucentRenderables", "", function(depth, skybox)
	if depth or skybox or not hitpos then return end

	local wep = LocalPlayer():GetActiveWeapon()

	if not IsValid(wep) then
		return
	end

	local class = wep:GetClass()

	if not pred.data[class] then
		return
	end

	render.DrawWireframeSphere(hitpos, 5, 15, 15, hitcol, true)

	for i = 1, #lines - 1 do
		render.DrawLine(lines[i], lines[i + 1], hitcol, true)
	end

	if hitposhit then
		render.DrawWireframeSphere(hitpos, pred.data[class].rad, 15, 15, color_orange, true) -- Explosion kill radius
	end
end)
