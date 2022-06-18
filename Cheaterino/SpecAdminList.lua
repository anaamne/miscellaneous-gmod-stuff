--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

local ULXAdminCommands = {
	"ulx ban",
	"ulx kick",
	"ulx jail",
	"ulx jailtp"
}

local Cache = {
	Colors = {
		Red = Color(255, 0, 0, 255)
	},

	Spectators = {},
	Admins = {},
	
	RankCount = -1,
	
	SamAdminRanks = {},
	ULXAdminRanks = {}
}

local function PlayerHasULXCommand(ply, cmd) -- Checks if a player has access to a command
	if not IsValid(ply) or not ULib then
		return false
	end
	
	local access, _ = ULib.ucl.query(ply, cmd)
	
	return access or false
end

local function GetRankCount() -- Gets the number of ranks
	local rCount = 0
	
	if sam then
		rCount = rCount + table.Count(sam.ranks.get_ranks())
	end
	
	if ulx then
		rCount = rCount + #ulx.group_names
	end

	return rCount
end

local function GetAdminRanks() -- Searchs for rank names containing "admin"
	Cache.SamAdminRanks = {}
	Cache.ULXAdminRanks = {}
	
	if sam then
		for k, v in pairs(sam.ranks.get_ranks()) do
			if v.name:lower():find("admin") or (v.inherit and v.inherit:lower():find("admin")) then -- 'inherit' is sometimes 'false'
				Cache.SamAdminRanks[k] = true
			end
		end
	end
	
	if ulx then
		for _, v in ipairs(ulx.group_names) do
			if v:lower():find("admin") then
				Cache.ULXAdminRanks[v] = true
			end
		end
	end
end

local function IsAdmin(ply)
	if not IsValid(ply) then
		return false
	end
	
	if ply:IsAdmin() or ply:IsSuperAdmin() then return true end
	
	if sam then
		return Cache.SamAdminRanks[ply:GetUserGroup()] ~= nil
	end
	
	if ulx then
		if Cache.ULXAdminRanks[ply:GetUserGroup()] ~= nil then
			return true
		else
			for _, v in ipairs(ULXAdminCommands) do -- Check if player has access to any moderation commands
				if PlayerHasULXCommand(ply, v) then
					return true
				end
			end
		end
	end
	
	return false
end

local function IsSpectating(spectator, ply) -- Checks if a spectator is spectating a specific player
	if not IsValid(spectator) or not IsValid(ply) then
		return false
	end
	
	if spectator:GetObserverMode() == OBS_MODE_NONE then
		return false
	end
	
	local specEnt = spectator:GetObserverTarget()
	
	if not IsValid(specEnt) then
		return false
	end
	
	return specEnt == LocalPlayer() or specEnt:GetParent() == LocalPlayer()
end

timer.Create("@", 0.3, 0, function()
	if Cache.RankCount == -1 or Cache.RankCount ~= GetRankCount() then
		GetAdminRanks()
		Cache.RankCount = GetRankCount()
	end

	Cache.Spectators = {}
	Cache.Admins = {}
	
	for _, v in ipairs(player.GetAll()) do
		if v:GetObserverMode() ~= OBS_MODE_NONE then
			Cache.Spectators[#Cache.Spectators + 1] = v
		end
		
		if IsAdmin(v) then
			Cache.Admins[#Cache.Admins + 1] = v
		end
	end
	
	table.sort(Cache.Spectators, function(a) -- Show people spectating you at the top
		return IsSpectating(a, LocalPlayer())
	end)
end)

hook.Add("DrawOverlay", "@", function()
	surface.SetFont("BudgetLabel")
	surface.SetTextColor(color_white)
	
	local ScrW = ScrW()
	local ty = 0
	
	local title = "--Spectators (" .. #Cache.Spectators .. ")--"
	local tw, th = surface.GetTextSize(title)
	
	surface.SetTextPos(ScrW - tw - 2, ty)
	surface.DrawText(title)
	
	ty = ty + th
	
	for _, v in ipairs(Cache.Spectators) do
		if not v:IsValid() or v:GetObserverMode() == OBS_MODE_NONE then
			continue
		end
		
		surface.SetTextColor(IsSpectating(v, LocalPlayer()) and Cache.Colors.Red or color_white)
		
		local name = v:GetName()
		tw, th = surface.GetTextSize(name)
		
		surface.SetTextPos(ScrW - tw - 2, ty)
		surface.DrawText(name)
		
		ty = ty + th
	end
	
	ty = ty + th
	
	surface.SetTextColor(color_white)
	
	title = "--Admins (" .. #Cache.Admins .. ")--"
	tw, th = surface.GetTextSize(title)
	
	surface.SetTextPos(ScrW - tw - 2, ty)
	surface.DrawText(title)
	
	ty = ty + th
	
	for _, v in ipairs(Cache.Admins) do
		if not v:IsValid() then
			continue
		end
		
		local name = v:GetName()
		tw, th = surface.GetTextSize(name)
		
		surface.SetTextPos(ScrW - tw - 2, ty)
		surface.DrawText(name)
		
		ty = ty + th
	end
end)
