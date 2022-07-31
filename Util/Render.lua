--[[
	Pass `true` to reset clipping
]]

function render.ResetDrawing(clipping)
	render.SetStencilWriteMask(0xFF)
	render.SetStencilTestMask(0xFF)
	render.SetStencilReferenceValue(0)
	render.SetStencilCompareFunction(STENCIL_ALWAYS)
	render.SetStencilPassOperation(STENCIL_KEEP)
	render.SetStencilFailOperation(STENCIL_KEEP)
	render.SetStencilZFailOperation(STENCIL_KEEP)
	render.ClearStencil()
	render.SetStencilEnable(false)

	render.SetColorModulation(1, 1, 1)
	render.SetMaterial(nil)
	render.ResetModelLighting(1, 1, 1)

	render.SetBlend(1)

	if clipping then
		render.SetScissorRect(0, 0, 0, 0, false)
		render.PopCustomClipPlane()
	end
end

--[[
	Warning: This function automatically sets color material!
]]

function render.DrawOutlinedBox(pos, ang, mins, maxs, outlineColor, fillColor, writez)
	if writez then
		render.SetColorMaterial()
	else
		render.SetColorMaterialIgnoreZ()
	end

	local oBlend = render.GetBlend()

	render.SetBlend(fillColor.a / 255)

	render.DrawBox(pos, ang, mins, maxs, fillColor)

	render.SetBlend(oBlend)

	render.DrawWireframeBox(pos, ang, mins, maxs, outlineColor, writez)
end
