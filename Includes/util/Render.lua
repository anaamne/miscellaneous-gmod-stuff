--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Requires https://github.com/awesomeusername69420/miscellaneous-gmod-stuff/blob/main/Includes/util/Util.lua
]]

include("Util.lua")

local Isvalid = IsValid

local bit_band = bit.band

local cam_IgnoreZ = cam.IgnoreZ

local render_ClearStencil = render.ClearStencil
local render_DrawBox = render.DrawBox
local render_DrawLine = render.DrawLine
local render_DrawQuad = render.DrawQuad
local render_DrawQuadEasy = render.DrawQuadEasy
local render_DrawWireframeBox = render.DrawWireframeBox
local render_GetBlend = render.GetBlend
local render_PopCustomClipPlane = render.PopCustomClipPlane
local render_ResetModelLighting = render.ResetModelLighting
local render_SetBlend = render.SetBlend
local render_SetColorMaterial = render.SetColorMaterial
local render_SetColorModulation = render.SetColorModulation
local render_SetMaterial = render.SetMaterial
local render_SetScissorRect = render.SetScissorRect
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilEnable = render.SetStencilEnable
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilTestMask = render.SetStencilTestMask
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilZFailOperation = render.SetStencilZFailOperation

--[[
	Pass `true` to reset clipping
]]

function render.ResetDrawing(clipping)
	render_SetStencilWriteMask(0xFF)
	render_SetStencilTestMask(0xFF)
	render_SetStencilReferenceValue(0)
	render_SetStencilCompareFunction(STENCIL_ALWAYS)
	render_SetStencilPassOperation(STENCIL_KEEP)
	render_SetStencilFailOperation(STENCIL_KEEP)
	render_SetStencilZFailOperation(STENCIL_KEEP)
	render_ClearStencil()
	render_SetStencilEnable(false)

	render_SetColorModulation(1, 1, 1)
	render_SetMaterial(nil)
	render_ResetModelLighting(1, 1, 1)

	render_SetBlend(1)

	if clipping then
		render_SetScissorRect(0, 0, 0, 0, false)
		render_PopCustomClipPlane()
	end
end

--[[
	Warning: This function automatically sets color material!
]]

function render.DrawOutlinedBox(pos, ang, mins, maxs, outlineColor, fillColor, writez)
	if not writez then
		cam_IgnoreZ(true)
	end

	render_SetColorMaterial()

	local oBlend = render_GetBlend()

	render_SetBlend(fillColor.a / 255)
		render_DrawBox(pos, ang, mins, maxs, fillColor)
	render_SetBlend(oBlend)

	render_DrawWireframeBox(pos, ang, mins, maxs, outlineColor, writez)

	if not writez then
		cam_IgnoreZ(false)
	end
end

function render.DrawOutlinedQuad(vert1, vert2, vert3, vert4, quadColor, outlineColor, material)
	quadColor = quadColor or color_white
	outlineColor = outlineColor or color_white

	local mValid = util.MaterialIsValid(material)

	if mValid then
		render_SetMaterial(material)
	end

	render_DrawQuad(vert1, vert2, vert3, vert4, quadColor)

	local writeZ = false

	if mValid then
		writeZ = bit_band(material:GetInt("$flags"), 32768) == 0
	end

	render_DrawLine(vert1, vert2, color, writeZ)
	render_DrawLine(vert2, vert3, color, writeZ)
	render_DrawLine(vert3, vert4, color, writeZ)
	render_DrawLine(vert4, vert1, color, writeZ)
end

function render.DrawOutlinedQuadEasy(pos, normal, width, height, quadColor, outlineColor, rotation, material)
	quadColor = quadColor or color_white
	outlineColor = outlineColor or color_white
	rotation = rotation or 0

	local mValid = util.MaterialIsValid(material)

	if mValid then
		render_SetMaterial(material)
	end

	render_DrawQuadEasy(pos, normal, width, height, quadColor, rotation)

	local up = normal:Angle():Up() * (height / 2)
	local right = normal:Angle():Right() * (width / 2)
	local writeZ = false

	if mValid then
		writeZ = bit_band(material:GetInt("$flags"), 32768) == 0
	end

	render_DrawLine(pos + up + right, pos + up - right, outlineColor, writeZ)
	render_DrawLine(pos + up + right, pos - up + right, outlineColor, writeZ)
	render_DrawLine(pos - up + right, pos - up - right, outlineColor, writeZ)
	render_DrawLine(pos - up - right, pos + up - right, outlineColor, writeZ)
end
