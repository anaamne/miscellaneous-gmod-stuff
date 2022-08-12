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
	if not writez then
		cam.IgnoreZ(true)
	end

	render.SetColorMaterial()

	local oBlend = render.GetBlend()

	render.SetBlend(fillColor.a / 255)
		render.DrawBox(pos, ang, mins, maxs, fillColor)
	render.SetBlend(oBlend)

	render.DrawWireframeBox(pos, ang, mins, maxs, outlineColor, writez)

	if not writez then
		cam.IgnoreZ(false)
	end
end

function render.DrawOutlinedQuadEasy(pos, normal, width, height, fillColor, outlineColor, rotation)
	render.DrawQuadEasy(pos, normal, width, height, fillColor, rotation)

	local up = normal:Angle():Up() * (height / 2)
	local right = normal:Angle():Right() * (width / 2) 

	render.DrawLine(pos + up + right, pos + up - right, outlineColor, true)
	render.DrawLine(pos + up + right, pos - up + right, outlineColor, true)
	render.DrawLine(pos - up + right, pos - up - right, outlineColor, true)
	render.DrawLine(pos - up - right, pos + up - right, outlineColor, true)
end
