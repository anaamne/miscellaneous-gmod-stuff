--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
	
	Has some cool renderings for M9K specialties
	
	- Frag grendae, sticky grenade, nerve gas timers
	- Nerve gas and proximity mine hitbox range
]]

local Cache = {
	Colors = {
		Red = Color(255, 0, 0, 255),
		RedA = Color(255, 0, 0, 100),
	},
	
	Materials = {
		Quad = CreateMaterial(tostring({}), "UnlitGeneric", { -- Default color material but with alpha
			["$alpha"] = 0.4,
			["$basetexture"] = "color/white",
			["$model"] = 1,
			["$translucent"] = 1,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1
		})
	}
}

local Classes = { -- Holds the classes and time information
	["m9k_thrown_sticky_grenade"] = 3,
	["m9k_thrown_m61"] = GAMEMODE.Name == "Murderthon 9000" and 1.5 or 3, -- No ConVar check
	["m9k_oribital_cannon"] = 8.25,
	["m9k_released_poison"] = 18, -- self.Big is never true (By default)
	["m9k_proxy"] = -1, -- No timer for this
	
	["m9k_mad_c4"] = function(self)
		return self:GetDTInt(0)
	end
}

local PositionOverrides = { -- Use a position other than OBBCenter for the text
	["m9k_oribital_cannon"] = function(self)
		-- No clientside access to self.Target :(

		Cache.OrbitalCannonDownVector = Cache.OrbitalCannonDownVector or (vector_up * 32767)

		return util.TraceLine({ -- Not 100% accurate but I couldn't find anything to use other than some variables that aren't networked
			start = self:GetPos(),
			endpos = self:GetPos() - Cache.OrbitalCannonDownVector
		}).HitPos
	end
}


local function DrawCircle(pos, rad, seg, color) -- Basically surface.DrawCircle but 3D
    local angle = 2 * math.pi / seg
    local startang = 0
    local endang = angle
	
    for i = 1, seg do
        local startpos = pos + Vector(math.cos(startang), math.sin(startang), 0) * rad
        local endpos = pos + Vector(math.cos(endang), math.sin(endang), 0) * rad
		
        render.DrawLine(startpos, endpos, color, true)
		
        startang = endang
        endang = endang + angle
    end
end

local Render = { -- Render custom things for these entities
	["m9k_released_poison"] = function(self)
		local len = 225 -- self.Big is never true
	
		-- These direction names probably aren't proper, I just called them whatever
	
		Cache.ReleasedPoisonForward = Cache.ReleasedPoisonForward or Vector(len, 0, 0)
		Cache.ReleasedPoisonLeft = Cache.ReleasedPoisonLeft or Vector(0, len, 0)
	
		cam.Start3D()
			render.SetMaterial(Cache.Materials.Quad)
		
			render.DrawQuadEasy(self:GetPos(), vector_up, len * 2, len * 2, Cache.Colors.RedA, 180)
		
			render.DrawLine(self:GetPos() + Cache.ReleasedPoisonForward + Cache.ReleasedPoisonLeft, self:GetPos() + Cache.ReleasedPoisonForward - Cache.ReleasedPoisonLeft, Cache.Colors.Red, true)
			render.DrawLine(self:GetPos() - Cache.ReleasedPoisonForward + Cache.ReleasedPoisonLeft, self:GetPos() - Cache.ReleasedPoisonForward - Cache.ReleasedPoisonLeft, Cache.Colors.Red, true)
			render.DrawLine(self:GetPos() + Cache.ReleasedPoisonLeft + Cache.ReleasedPoisonForward, self:GetPos() + Cache.ReleasedPoisonLeft - Cache.ReleasedPoisonForward, Cache.Colors.Red, true)
			render.DrawLine(self:GetPos() - Cache.ReleasedPoisonLeft + Cache.ReleasedPoisonForward, self:GetPos() - Cache.ReleasedPoisonLeft - Cache.ReleasedPoisonForward, Cache.Colors.Red, true)
		cam.End3D()
	end,
	
	["m9k_proxy"] = function(self)
		cam.Start3D() -- I don't know how to do 3D circles for the cool filled in shape thinger
			DrawCircle(self:GetPos(), 200, 64, Cache.Colors.Red)
		cam.End3D()
	end
}

hook.Add("HUDPaint", "@@@@@@", function()
	surface.SetFont("BudgetLabel")
	surface.SetTextColor(color_white)

	local grenades = {}
	
	for k, _ in pairs(Classes) do
		for _, e in ipairs(ents.FindByClass(k)) do
			grenades[#grenades + 1] = e
		end
	end
	
	for _, v in ipairs(grenades) do
		if not IsValid(v) then
			continue
		end
	
		local class = v:GetClass()
		
		if Render[class] then
			Render[class](v)
		end
	
		local etime = Classes[class]
		
		if type(etime) == "function" then
			etime = etime(v)
		end
		
		if etime == -1 then
			continue
		end
		
		local ctime = math.Round(math.Clamp(etime - (CurTime() - v:GetCreationTime()), 0, math.huge), 1)
		local spos
		
		if PositionOverrides[class] then
			spos = PositionOverrides[class](v):ToScreen()
		else
			spos = v:LocalToWorld(v:OBBCenter()):ToScreen()
		end
		
		local tw, th = surface.GetTextSize(ctime)
		
		surface.SetTextPos(spos.x - (tw / 2), spos.y - (th / 2))
		surface.DrawText(ctime)
	end
end)