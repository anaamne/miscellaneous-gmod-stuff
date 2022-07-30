--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	ConVars:
		as_mode - Controls the autostrafe mode. 0 = Disabled; 1 = Legit; 2 = Rage.
]]

local Mode = CreateClientConVar("as_mode", 1, false, false, "0 = Disabled; 1 = Legit; 2 = Rage.", 0, 2)

local SideMove = GetConVar("cl_sidespeed")
local ForwardMove = GetConVar("cl_forwardspeed")

hook.Add("CreateMove", "as", function(cmd)
	local SetMode = Mode:GetInt()

	if SetMode == 0 then return end
	if LocalPlayer():GetMoveType() ~= MOVETYPE_WALK or IsValid(LocalPlayer():GetVehicle()) or LocalPlayer():WaterLevel() > 1 then return end

	local Grounded = LocalPlayer():IsOnGround()

	local MaxSideMove = SideMove:GetFloat()
	local MaxForwardMove = ForwardMove:GetFloat()

	if not Grounded then
		if cmd:GetMouseX() > 0 then
			cmd:SetSideMove(MaxSideMove)
		elseif cmd:GetMouseX() < 0 then
			cmd:SetSideMove(MaxSideMove * -1)
		end
	end

	if SetMode == 2 and cmd:KeyDown(IN_JUMP) then
		if Grounded then
			cmd:SetForwardMove(MaxForwardMove)
		else
			cmd:SetForwardMove((MaxForwardMove * 0.5) / LocalPlayer():GetVelocity():Length2D())
			cmd:SetSideMove(cmd:CommandNumber() % 2 == 0 and (MaxSideMove * -1) or MaxSideMove)
		end
	end
end)
