--[[
	Bad snake game
	
	Type "awesomesnake_menu_toggle" in console to play
	Type "awesomesnake_blur_toggle" in console to toggle the blur (reduce lag)
	
	Arrow keys to move the snake
	Get apples / red boxes to make snake longer
	Touching the edge or the snake's body = death
]]

-- Localization

local table = table.Copy(table)

local debug = table.Copy(debug)
local pairs = pairs
local type = type

local function tCopy(n, t)
	if not n then
		return nil
	end
	
	local c = {}
	
	debug.setmetatable(c, debug.getmetatable(n))
	
	for k, v in pairs(n) do
		if type(v) ~= "table" then
			c[k] = v
		else
			t = t or {}
			t[n] = c
			
			if t[v] then
				c[k] = t[v]
			else
				c[k] = tCopy(v, t)
			end
		end
	end
	
	return c
end

local concommand = tCopy(concommand)
local coroutine = tCopy(coroutine)
local draw = tCopy(draw)
local gui = tCopy(gui)
local hook = tCopy(hook)
local input = tCopy(input)
local Material = Material
local math = tCopy(math)
local render = tCopy(render)
local ScrH = ScrH
local ScrW = ScrW
local surface = tCopy(surface)
local UnPredictedCurTime = UnPredictedCurTime

local meta_cd = tCopy(debug.getregistry()["CUserCmd"])
local meta_im = tCopy(debug.getregistry()["IMaterial"])

local KEY_DOWN = 90
local KEY_LEFT = 89
local KEY_RIGHT = 91
local KEY_SPACE = 65
local KEY_UP = 88

-- Variables and stuff

local blurmat = Material("pp/blurscreen")
meta_im.SetFloat(blurmat, "$blur", 4)
meta_im.Recompute(blurmat)

local vars = {
	["doblur"] = true,
	["window_open"] = false,
	["window_x"] = 0,
	["window_y"] = 0,
	["window_w"] = 0,
	["window_h"] = 0,
	["window_grid_w"] = 0,
	["window_grid_h"] = 0,
	["first"] = true,
	["paused"] = false,
	["active"] = false,
	["waitkey"] = false,
}

local appleco
local lasttime = -1
local lastmove
local lastscrw = -1
local lastscrh = -1

local gamevars = {
	["score"] = 0,
	["length"] = 1,
	["time"] = 0,
}
local gamedata = {}

-- Functions

local function centerText(text, x, y, w)
	surface.SetFont("BudgetLabel")
	
	local tw, th = surface.GetTextSize(text)
	
	if not y then
		y = ScrH() / 2
	end
	
	surface.SetTextPos((x + (w / 2)) - (tw / 2), y)
	surface.DrawText(text)
end

local function canRender()
	return not gui.IsGameUIVisible() and not gui.IsConsoleVisible()
end

local function isTileSnake(x, y, ignorehead)
	if not x or not y then
		return false
	end
	
	if not ignorehead then
		if x == gamedata.snakehead_x and y == gamedata.snakehead_y then
			return true
		end
	end
	
	for _, v in ipairs(gamedata.snakebody) do
		if x == v.x and y == v.y then
			return true
		end
	end
	
	return false
end

local function appleCoroutine()
	if vars["active"] and not vars["paused"] then
		if not gamedata.apple_x then
			local w, h = vars["window_w"], vars["window_h"]
			local gw, gh = vars["window_grid_w"], vars["window_grid_h"]
		
			local x, y = math.random(0, gw), math.random(0, gh)
			
			while isTileSnake(x, y, false) do -- Tries to put an apple where there isn't snake
				x, y = math.random(0, gw), math.random(0, gh)
			end
			
			gamedata.apple_x = x
			gamedata.apple_y = y
		end
	end
end

local function setupGame()
	local w, h = vars["window_w"], vars["window_h"]
	local gw, gh = vars["window_grid_w"], vars["window_grid_h"]
	
	gamevars["score"] = 0
	gamevars["time"] = 0
	gamevars["length"] = 1
	
	gamedata.apple_x = nil
	gamedata.snakehead_x = math.floor(gw / 2)
	gamedata.snakehead_y = math.floor(gh / 2)
	gamedata.snakehead_dir = 90
	gamedata.snakebody = {}
	
	lastmove = UnPredictedCurTime()
end

local function translateGrid(num, vert) -- Turns grid coordinates into screen coordinates
	if not num then
		return 0
	end

	local x, y = vars["window_x"], vars["window_y"]
	
	if vert then
		return ((y + 40) + (15 * num)) + 2
	else
		return (x + (15 * num)) + 2
	end
end

local function updateBody()
	for i = #gamedata.snakebody, 1, -1 do
		local v = gamedata.snakebody[i]
		local k = gamedata.snakebody[i - 1]
		
		if k then
			v.x = k.x -- Move parts to the part in front of them
			v.y = k.y
		else
			v.x = gamedata.snakehead_x -- Move 1st part to where the head is
			v.y = gamedata.snakehead_y
		end
	end
end

-- Hooks

hook.Add("CreateMove", "awesomesnake_createmove", function(cmd)
	if meta_cd.CommandNumber(cmd) == 0 then
		return
	end
	
	if vars["window_open"] then -- Prevent movement while game is open
		meta_cd.ClearButtons(cmd)
		meta_cd.ClearMovement(cmd)
	end
end)

hook.Add("Tick", "awesomesnake_tick", function()
	if lastscrw ~= ScrW() then -- Fix the window and grid to screen size
		vars["window_w"] = ScrW() * (1200 / 1920)
		vars["window_grid_w"] = math.floor(vars["window_w"] / 15)
		vars["window_w"] = vars["window_grid_w"] * 15
		
		vars["window_x"] = (ScrW() / 2) - (vars["window_w"] / 2)
		
		if gamedata.apple_x then
			gamedata.apple_x = gamedata.apple_x % vars["window_grid_w"]
		end
		
		lastscrw = ScrW()
	end
	
	if lastscrh ~= ScrH() then
		vars["window_h"] = ScrH() * (800 / 1080)
		vars["window_grid_h"] = math.floor((vars["window_h"] - 40) / 15)
		vars["window_h"] = (vars["window_grid_h"] * 15) + 40
		
		vars["window_y"] = (ScrH() / 2) - (vars["window_h"] / 2)
		
		if gamedata.apple_y then
			gamedata.apple_y = gamedata.apple_y % vars["window_grid_h"]
		end
		
		lastscrh = ScrH()
	end
	
	if vars["window_open"] then
		if vars["waitkey"] then
			if not input.IsKeyDown(KEY_SPACE) then
				vars["waitkey"] = false
			end
		end
	
		if not vars["active"] then
			if input.IsKeyDown(KEY_SPACE) and not vars["waitkey"] then
				setupGame() -- Unpause and setup game
			
				vars["active"] = true
				vars["paused"] = false
				vars["waitkey"] = true
				
				if vars["first"] then
					vars["first"] = false
				end
			end
		else
			if not vars["paused"] then
				if not canRender() then -- Pause game if focus lost
					vars["paused"] = true
					
					return
				end
				
				if input.IsKeyDown(KEY_SPACE) and not vars["waitkey"] then -- Pause game if space is pressed
					vars["waitkey"] = true
					vars["paused"] = true
					
					return
				end
			
				local curtime = UnPredictedCurTime()
				
				if curtime - lasttime > 0.9 then -- In game timer
					gamevars["time"] = gamevars["time"] + 1
				
					lasttime = curtime
				end
				
				if input.IsKeyDown(KEY_UP) then -- Change direction of snake
					gamedata.snakehead_dir = 90
				elseif input.IsKeyDown(KEY_DOWN) then
					gamedata.snakehead_dir = 270
				elseif input.IsKeyDown(KEY_LEFT) then
					gamedata.snakehead_dir = 180
				elseif input.IsKeyDown(KEY_RIGHT) then
					gamedata.snakehead_dir = 0
				end
				
				if not lastmove or (curtime - lastmove) > 0.2 then -- Move the snake every now and then
					local lastpos = {["x"] = gamedata.snakehead_x, ["y"] = gamedata.snakehead_y}
					local nextpos = {["x"] = gamedata.snakehead_x, ["y"] = gamedata.snakehead_y}
					
					if gamedata.snakehead_dir == 0 then
						nextpos.x = gamedata.snakehead_x + 1
					elseif gamedata.snakehead_dir == 90 then
						nextpos.y = gamedata.snakehead_y - 1
					elseif gamedata.snakehead_dir == 180 then
						nextpos.x = gamedata.snakehead_x - 1
					elseif gamedata.snakehead_dir == 270 then
						nextpos.y = gamedata.snakehead_y + 1
					else
						gamedata.snakehead_dir = 0 -- This should never happen
					end
					
					if (nextpos.x >= vars["window_grid_w"] or nextpos.x < 0) or (nextpos.y >= vars["window_grid_h"] or nextpos.y < 0) or isTileSnake(nextpos.x, nextpos.y, true) then -- Kill the player if they touch the edge or themselves
						vars["active"] = false
					end
					
					if nextpos.x == gamedata.apple_x and nextpos.y == gamedata.apple_y then -- Create new snake part
						gamevars["length"] = gamevars["length"] + 1
						gamevars["score"] = gamevars["score"] + 100
						table.insert(gamedata.snakebody, lastpos)
						
						gamedata.apple_x = nil
					end
					
					nextpos.x = math.Clamp(nextpos.x, 0, vars["window_grid_w"] - 1) -- Prevent head from going off the grid
					nextpos.y = math.Clamp(nextpos.y, 0, vars["window_grid_h"] - 1)
					
					updateBody() -- Move body before moving head to avoid issues
					
					gamedata.snakehead_x = nextpos.x
					gamedata.snakehead_y = nextpos.y

					lastmove = curtime
				end
				
				if not appleco or not coroutine.resume(appleco) then -- Create new apples without freezing game
					appleco = coroutine.create(appleCoroutine)
					coroutine.resume(appleco)
				end
			else
				if input.IsKeyDown(KEY_SPACE) and not vars["waitkey"] then
					vars["paused"] = false
					vars["waitkey"] = true
				end
			end
		end
	else
		if vars["active"] then
			vars["paused"] = true
		end
		
		vars["waitkey"] = true
	end
end)

hook.Add("HUDPaint", "awesomesnake_hudpaint", function()
	if vars["window_open"] then
		if canRender() then
			local x, y, w, h = vars["window_x"], vars["window_y"], vars["window_w"], vars["window_h"]
		
			render.SetScissorRect(x, y, x + w, y + h, true) -- Make sure rendering can't escape the menu
			
			if vars["doblur"] then
				surface.SetMaterial(blurmat) -- Blur background
				surface.SetDrawColor(255, 255, 255, 255)
				
				for i = 1, 5 do
					render.UpdateScreenEffectTexture()
					
					surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
				end
			end
		
			draw.NoTexture()
			
			-- The base
			
			surface.SetDrawColor(55, 55, 55, 255)
			surface.DrawRect(x, y, w, 20)
			
			surface.SetDrawColor(24, 24, 24, 255)
			surface.DrawRect(x, y + 20, w, 20)
			
			surface.SetDrawColor(24, 24, 24, 150)
			surface.DrawRect(x, y + 40, w, h - 40)
			
			surface.SetDrawColor(12, 12, 12, 255)
			
			local gw, gh = vars["window_grid_w"], vars["window_grid_h"] -- Get the grid size
			local ofx, ofy = 1, 1
			
			for i = 1, gw - 1 do -- Draw vertical grid
				surface.DrawLine(x + (15 * ofx), y + 40, x + (15 * ofx), y + h)
				
				ofx = ofx + 1
			end
			
			for i = 1, gh - 1 do -- Draw horizontal grid
				surface.DrawLine(x, (y + 40) + (15 * ofy), x + w, (y + 40) + (15 * ofy))
			
				ofy = ofy + 1
			end
			
			-- Outlines & Sectors
			
			surface.DrawOutlinedRect(x, y, w, h)
			surface.DrawLine(x, y + 20, x + w, y + 20)
			surface.DrawLine(x, y + 40, x + w, y + 40)
	
			local fdiv = w - (w / 3)
			local rdiv = w - fdiv
			
			surface.DrawLine(x + (w - fdiv), y + 20, x + (w - fdiv), y + 40)
			surface.DrawLine(x + (w - rdiv), y + 20, x + (w - rdiv), y + 40)
			
			-- Display Game Stats
			
			surface.SetFont("BudgetLabel")
			surface.SetTextColor(255, 255, 255, 255)
			
			centerText("Awesome Snake Game", x, y + 3, w)
			
			local tw, th = surface.GetTextSize("Score: " .. gamevars["score"])
			
			surface.SetTextPos((x + (rdiv / 2)) - (tw / 2), y + 23)
			surface.DrawText("Score: " .. gamevars["score"])
			
			tw, th = surface.GetTextSize("Length: " .. gamevars["length"])
			
			surface.SetTextPos((x + (w / 2)) - (tw / 2), y + 23)
			surface.DrawText("Length: " .. gamevars["length"])
			
			tw, th = surface.GetTextSize("Time: " .. gamevars["time"])
			
			surface.SetTextPos((x + (w - (rdiv / 2))) - (tw / 2), y + 23)
			surface.DrawText("Time: " .. gamevars["time"])
			
			-- Render game
			
			render.SetScissorRect(x, y, x + w, y + h, true)
			
			if gamedata.snakehead_x then
				surface.SetDrawColor(255, 150, 0, 255)
				
				for _, v in ipairs(gamedata.snakebody) do
					surface.DrawRect(translateGrid(v.x), translateGrid(v.y, true), 12, 12)
				end
				
				local tx, ty = translateGrid(gamedata.snakehead_x), translateGrid(gamedata.snakehead_y, true)
				
				surface.DrawRect(tx, ty, 12, 12)
				
				surface.SetDrawColor(255, 255, 255, 255) -- White part of the eyes
				
				if gamedata.snakehead_dir == 0 then
					surface.DrawRect(tx + 9, ty + 2, 3, 3)
					surface.DrawRect(tx + 9, ty + 7, 3, 3)
				elseif gamedata.snakehead_dir == 90 then
					surface.DrawRect(tx + 2, ty, 3, 3)
					surface.DrawRect(tx + 7, ty, 3, 3)
				elseif gamedata.snakehead_dir == 180 then
					surface.DrawRect(tx, ty + 2, 3, 3)
					surface.DrawRect(tx, ty + 7, 3, 3)
				elseif gamedata.snakehead_dir == 270 then
					surface.DrawRect(tx + 2, ty + 9, 3, 3)
					surface.DrawRect(tx + 7, ty + 9, 3, 3)
				end
				
				surface.SetDrawColor(0, 0, 0, 255) -- Pupils
				
				if gamedata.snakehead_dir == 0 then
					surface.DrawRect(tx + 11, ty + 3, 1, 1)
					surface.DrawRect(tx + 11, ty + 8, 1, 1)
				elseif gamedata.snakehead_dir == 90 then
					surface.DrawRect(tx + 3, ty, 1, 1)
					surface.DrawRect(tx + 8, ty, 1, 1)
				elseif gamedata.snakehead_dir == 180 then
					surface.DrawRect(tx, ty + 3, 1, 1)
					surface.DrawRect(tx, ty + 8, 1, 1)
				elseif gamedata.snakehead_dir == 270 then
					surface.DrawRect(tx + 3, ty + 11, 1, 1)
					surface.DrawRect(tx + 8, ty + 11, 1, 1)
				end
			end
			
			if gamedata.apple_y then
				surface.SetDrawColor(255, 0, 0, 255)
				surface.DrawRect(translateGrid(gamedata.apple_x), translateGrid(gamedata.apple_y, true), 12, 12)
			end

			-- Render welcome, game over and pause screen
			
			if vars["paused"] or not vars["active"] then
				if vars["doblur"] then
					render.SetScissorRect(x + (w / 3), y + 150, (x + w) - (w / 3), (y + (h / 2)), true) -- Move rendering cutoff for overlay blur
					
					for i = 1, 5 do
						surface.SetMaterial(blurmat)
						surface.SetDrawColor(255, 255, 255, 255)
						
						for i = 1, 5 do
							render.UpdateScreenEffectTexture()
							
							surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
						end
					end
				end
			end
			
			if vars["paused"] then
				centerText("Game Paused", x, (y + (h / 3)) - (th / 2), w)
				centerText("Press SPACE to resume", x, ((y + (h / 3)) - (th / 2)) + 40, w)
			else
				if not vars["active"] then
					if not vars["first"] then
						surface.SetTextColor(255, 0, 0, 255)
						centerText("Game Over", x, (y + (h / 3)) - (th / 2), w)
						
						surface.SetTextColor(255, 255, 255, 255)
						centerText("Press SPACE to play again", x, ((y + (h / 3)) - (th / 2)) + 40, w)
					else
						centerText("Welcome to Snake", x, (y + (h / 3)) - (th / 2), w)
						centerText("Press SPACE to play", x, ((y + (h / 3)) - (th / 2)) + 40, w)
					end
				end
			end
		end
	end
	
	render.SetScissorRect(0, 0, 0, 0, false)
end)

-- ConCommands

concommand.Add("awesomesnake_menu_toggle", function()
	local new = not vars["window_open"]
	
	vars["window_open"] = new
	gui.EnableScreenClicker(new)
end)

concommand.Add("awesomesnake_blur_toggle", function()
	vars["doblur"] = not vars["doblur"]
end)
