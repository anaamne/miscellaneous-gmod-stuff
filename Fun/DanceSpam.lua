--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local Wait = false
local Gamemode = engine.ActiveGamemode()

local meta_cd = debug.getregistry().CUserCmd
local Backup = table.Copy(meta_cd)

local ACT_GMOD_TAUNT_DANCE = ACT_GMOD_TAUNT_DANCE

local debug_getinfo = debug.getinfo

meta_cd.ClearButtons = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.ClearButtons(...)
end

meta_cd.ClearMovement = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.ClearMovement(...)
end

meta_cd.SetViewAngles = function(...)
	if debug_getinfo(2).short_src:find("taunt_camera") then return end

	return Backup.SetViewAngles(...)
end

hook.Add("Tick", "DanceSpam", function()
	if Gamemode == "darkrp" then
		if Wait then return end
		LocalPlayer():ConCommand("_DarkRP_DoAnimation " .. ACT_GMOD_TAUNT_DANCE)

		local sID, sLen = LocalPlayer():LookupSequence(LocalPlayer():GetSequenceName(LocalPlayer():SelectWeightedSequence(ACT_GMOD_TAUNT_DANCE)))
		if not sID or not sLen then return end

		Wait = true

		timer.Simple(sLen, function()
			Wait = false
		end)
	else
		if not LocalPlayer():IsPlayingTaunt() then
			LocalPlayer():ConCommand("act dance")
		end
	end
end)
