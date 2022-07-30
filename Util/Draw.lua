--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Credit for masking and stencil box:
		https://github.com/2048khz-gachi-rmx/beizwors/blob/784c72a0bde378a6f8a6196bb19b744e55b0b130/addons/core_panellib/lua/moarpanels/exts/clipping.lua
		https://github.com/2048khz-gachi-rmx/beizwors/blob/784c72a0bde378a6f8a6196bb19b744e55b0b130/addons/core_panellib/lua/moarpanels/exts/draw.lua
]]

draw.RoundedStencilCorners =  {
	tex_corner8	= "gui/corner8",
	tex_corner16 = "gui/corner16",
	tex_corner32 = "gui/corner32",
	tex_corner64 = "gui/corner64",
	tex_corner512 = "gui/corner512"
}

do
	for name, mat in pairs(draw.RoundedStencilCorners) do
		draw.RoundedStencilCorners[name] = CreateMaterial("alt05_" .. mat:gsub("gui/", ""), "UnlitGeneric", {
			["$basetexture"] = mat,
			["$alphatest"] = 1,
			["$alphatestreference"] = 0.5,
			["$vertexalpha"] = 1,
			["$vertexcolor"] = 1
		})
	end
end

function draw.SetMaskDraw(newState)
	if newState then
		render.SetStencilCompareFunction(STENCIL_ALWAYS)
		render.SetStencilPassOperation(STENCIL_REPLACE)
	else
		render.SetStencilCompareFunction(STENCIL_NEVER)
		render.SetStencilFailOperation(STENCIL_REPLACE)
	end
end

function draw.BeginMask()
	render.SetStencilPassOperation(STENCIL_KEEP)

	render.SetStencilEnable(true)

	render.ClearStencil()

	render.SetStencilTestMask(0xFF)
	render.SetStencilWriteMask(0xFF)

	draw.SetMaskDraw(false)

	render.SetStencilReferenceValue(1)
end

function draw.DeMask()
	render.SetStencilReferenceValue(0)
end

function draw.ReMask()
	render.SetStencilReferenceValue(1)
end

function draw.DrawOp(val)
	render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilPassOperation(STENCIL_KEEP)

	render.SetStencilReferenceValue(val or 0)
end

function draw.FinishMask()
	render.SetStencilEnable(false)
end

function draw.DrawRoundedStencilBox(bordersize, x, y, w, h, color, tl, tr, bl, br)
	surface.SetDrawColor(color:Unpack())

	if bordersize <= 0 then
		surface.DrawRect(x, y, w, h)
		return
	end

	x = math.Round(x)
	y = math.Round(y)
	w = math.Round(w)
	h = math.Round(h)
	bordersize = math.min(math.Round(bordersize), math.floor(w * 0.5))

	surface.DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface.DrawRect(x, y + bordersize, bordersize, h - bordersize * 2)
	surface.DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)

	local tex = draw.RoundedStencilCorners.tex_corner8
	if bordersize > 8 then tex = draw.RoundedStencilCorners.tex_corner16 end
	if bordersize > 16 then tex = draw.RoundedStencilCorners.tex_corner32 end
	if bordersize > 32 then tex = draw.RoundedStencilCorners.tex_corner64 end
	if bordersize > 64 then tex = draw.RoundedStencilCorners.tex_corner512 end

	surface.SetMaterial(tex)

	if tl then
		surface.DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
	else
		surface.DrawRect(x, y, bordersize, bordersize)
	end

	if tr then
		surface.DrawTexturedRectUV(x + w - bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
	else
		surface.DrawRect(x + w - bordersize, y, bordersize, bordersize)
	end

	if bl then
		surface.DrawTexturedRectUV(x, y + h -bordersize, bordersize, bordersize, 0, 1, 1, 0)
	else
		surface.DrawRect(x, y + h - bordersize, bordersize, bordersize)
	end

	if br then
		surface.DrawTexturedRectUV(x + w - bordersize, y + h - bordersize, bordersize, bordersize, 1, 1, 0, 0)
	else
		surface.DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	end
end

function draw.OutlinedRoundedBox(bordersize, x, y, w, h, col)
	draw.BeginMask()
		render.PerformFullScreenStencilOperation()
	draw.DeMask()
		draw.DrawRoundedStencilBox(bordersize, x + 1, y + 1, w - 2, h - 2, color_white, true, true, true, true)
	draw.DrawOp()
		draw.DrawRoundedStencilBox(bordersize, x, y, w, h, col, true, true, true, true)
	draw.FinishMask()
end

function draw.OutlinedRoundedBoxEx(bordersize, x, y, w, h, col, tl, tr, bl, br)
	draw.BeginMask()
		render.PerformFullScreenStencilOperation()
	draw.DeMask()
		draw.DrawRoundedStencilBox(bordersize, x + 1, y + 1, w - 2, h - 2, color_white, tl, tr, bl, br)
	draw.DrawOp()
		draw.DrawRoundedStencilBox(bordersize, x, y, w, h, col, tl, tr, bl, br)
	draw.FinishMask()
end
