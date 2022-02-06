--[[
	This file only exists because SendLua is gay
]]

net.Receive("leme_awesomebot_printcommands", function() -- Help command
	local len = net.ReadUInt(16)
	local data = net.ReadData(len)

	if data then
		local a = string.Split(util.Decompress(data), "\n")
	
		for _, v in ipairs(a) do
			MsgC(Color(222, 222, 222), v .. "\n")
		end
	end
end)

net.Receive("leme_awesomebot_prettycolors", function() -- Used to make pretty colors in chat
	local len = net.ReadUInt(16)
	local trollage = net.ReadData(len)

	if trollage then
		local dtrollage = util.JSONToTable(util.Decompress(trollage)) or {}

		chat.AddText(unpack(dtrollage))
	end
end)

-- Config menu stuff

local isConfigMenuOpen = false
local cache = {
	colors = {
		BLACK = Color(0, 0, 0, 255),
		WHITE = Color(255, 255, 255, 255)
	},

	data = {
		botData = {},
		botConfig = {},
		botCommands = {}
	}
}

-- Helper functions to clean up code

local configMenuHelpers = {
	backgroundPaint = function(self, w, h)
		draw.RoundedBox(3, 0, 0, w, h, cache.colors.WHITE)
	end,

	buildCommandListView = function(listview)
		if not listview then
			return
		end

		listview:Clear()

		for k, v in pairs(cache.data.botCommands) do	
			listview:AddLine(string.upper(k[1]) .. string.sub(k, 2), v[1], v[2])
		end

		listview:SortByColumn(1)
	end,

	createListView = function(parent, x, y, w, h, ms, columns, data)
		if not parent then
			return
		end

		x = x or 0
		y = y or 0
		w = w or 0
		h = h or 0
		ms = ms or false
		columns = columns or {}
		data = data or {}

		local listview = vgui.Create("DListView", parent)
		listview:SetSize(w, h)
		listview:SetPos(x, y)
		listview:SetMultiSelect(ms)

		for _, v in ipairs(columns) do
			listview:AddColumn(v)
		end

		for _, v in ipairs(data) do
			listview:AddLine(unpack(v))
		end

		listview:SortByColumn(1)
	end,

	createCheckBox = function(parent, x, y, label, loc, var, extrafunc)
		if not parent or not loc or not var or loc[var] == nil then
			return
		end

		x = x or 0
		y = y or 0
		label = label or ""
		extrafunc = extrafunc or function() return end

		local checkbox = vgui.Create("DCheckBoxLabel", parent)
		checkbox:SetPos(x, y)
		checkbox:SetTextColor(cache.colors.BLACK)
		checkbox:SetText(label)
		checkbox:SetChecked(loc[var])

		checkbox.OnChange = function(self, new)
			loc[var] = new

			extrafunc()
		end
	end,

	createTextBox = function(parent, x, y, w, h, label, loc, var)
		if not parent or not loc or not var or loc[var] == nil then
			return
		end

		x = x or 0
		y = y or 0
		w = w or 0
		h = h or 0
		label = label or ""

		surface.SetFont("DermaDefault")

		local tw, th = surface.GetTextSize(label)

		local textBox = vgui.Create("DTextEntry", parent)
		textBox:SetSize(w, h)
		textBox:SetPos(x + tw + 5, y)
		textBox:SetValue(loc[var])

		textBox.OnChange = function(self, new)
			loc[var] = new
		end

		local tLabel = vgui.Create("DLabel", parent)
		tLabel:SetSize(999, tLabel:GetTall())
		tLabel:SetPos(x, y + math.abs((h / 2) - (th / 2)) - 2)
		tLabel:SetTextColor(cache.colors.BLACK)
		tLabel:SetText(label)
	end,

	createSlider = function(parent, x, y, length, min, max, label, loc, var)
		if not parent or not loc or not var or loc[var] == nil then
			return
		end

		x = x or 0
		y = y or 0
		length = length or 0
		min = min or 0
		max = max or 0
		label = label or ""

		surface.SetFont("DermaDefault")

		local tw, th = surface.GetTextSize(label)

		local slider = vgui.Create("DNumSlider", parent)
		slider:SetDark(true)
		slider:SetSize(length + tw, 24)
		slider:SetPos(x, y)
		slider:SetMinMax(min, max)
		slider:SetDecimals(0)
		slider:SetText(label)
		slider:SetValue(loc[var])

		slider.OnValueChanged = function(self, new)
			loc[var] = new
		end

		slider:GetChildren()[3]:GetChildren()[1]:SetEnabled(false) -- Stupid piece of shit slider
	end,

	createButton = function(parent, x, y, w, h, label, func)
		if not parent or not func then
			return
		end

		x = x or 0
		y = y or 0
		w = w or 0
		h = h or 0
		label = label or ""

		local button = vgui.Create("DButton", parent)
		button:SetSize(w, h)
		button:SetPos(x, y)
		button:SetText(label)

		button.DoClick = func
	end,
}

local function invokeCommandPanel()
	local newCommand = {
		name = "",
		description = "",
		delay = 0,
		userflag = 1,
		func = ""
	}

	local commandsAddFrame = vgui.Create("DFrame")
	commandsAddFrame:SetVisible(false)
	commandsAddFrame:SetTitle("Create a New Command")
	commandsAddFrame:SetSize(600, 400)
	commandsAddFrame:Center()

	local commandsAddPanel = vgui.Create("DPanel", commandsAddFrame)
	commandsAddPanel:Dock(FILL)

	commandsAddPanel.Paint = configMenuHelpers.backgroundPaint

	configMenuHelpers.createTextBox(commandsAddPanel, 25, 25, 325, 24, "Command Name", newCommand, "name")
	configMenuHelpers.createTextBox(commandsAddPanel, 25, 50, 300, 24, "Command Description", newCommand, "description")
	configMenuHelpers.createSlider(commandsAddPanel, 25, 75, 200, 0, 240, "Command Delay", newCommand, "delay")
	configMenuHelpers.createRadioButtons(commandsAddPanel, 25, 100, {"All Users", "All Admins", "Superadmin Only"})

	commandsAddFrame:SetVisible(true)
	commandsAddFrame:MakePopup()
	commandsAddFrame:DoModal()
	commandsAddFrame:SetBackgroundBlur(true)
end

net.Receive("leme_awesomebot_request", function()
	local len = net.ReadUInt(16)
	local data = net.ReadData(len)

	local botData = cache.data.botData

	if data then
		botData = util.JSONToTable(util.Decompress(data)) or {}

		if table.Count(botData) == 0 then
			LocalPlayer():ChatPrint("Failed to fetch bot data")
			return
		end
	else
		return
	end

	cache.data.botConfig = botData[1] or {}
	cache.data.botCommands = botData[2] or {}

	local botConfig = cache.data.botConfig

	-- Actual menu stuff

	local main = vgui.Create("DFrame")
	main:SetVisible(false)
	main:SetTitle(botConfig.botName .. " Configuration")
	main:SetSize(800, 600)
	main:Center()

	local sheet = vgui.Create("DPropertySheet", main)
	sheet:Dock(FILL)

	local mainPanel = vgui.Create("DPanel", sheet)
	local commandsPanel = vgui.Create("DPanel", sheet)
	local commandsLeft = vgui.Create("DPanel", sheet)
	local commandsRight = vgui.Create("DPanel", sheet)
	local weaponPanel = vgui.Create("DPanel", sheet)

	local commandsDiv = vgui.Create("DHorizontalDivider", commandsPanel)
	commandsDiv:Dock(FILL)
	commandsDiv:SetLeft(commandsLeft)
	commandsDiv:SetRight(commandsRight)
	commandsDiv:SetLeftWidth(main:GetWide() / 2)

	mainPanel.Paint = configMenuHelpers.backgroundPaint
	commandsPanel.Paint = configMenuHelpers.backgroundPaint
	commandsLeft.Paint = configMenuHelpers.backgroundPaint
	commandsRight.Paint = configMenuHelpers.backgroundPaint
	weaponPanel.Paint = configMenuHelpers.backgroundPaint

	-- Main

	configMenuHelpers.createTextBox(mainPanel, 25, 25, 200, 24, "Bot Name", botConfig, "botName") -- Very efficient
	configMenuHelpers.createTextBox(mainPanel, 25, 50, 325, 24, "Collection URL", botConfig, "collectionURL")
	configMenuHelpers.createSlider(mainPanel, 25, 75, 200, 0, 60, "Angle Change Delay", botConfig, "changeDelay")
	configMenuHelpers.createSlider(mainPanel, 25, 100, 200, 1, 180, "Explode Ban Ammount", botConfig, "explodebanAmount")

	-- Commands

	local commandsListView = vgui.Create("DListView", commandsLeft)
	commandsListView:Dock(FILL)
	commandsListView:SetMultiSelect(false)
	commandsListView:AddColumn("Command Name")
	commandsListView:AddColumn("Enabled")
	commandsListView:AddColumn("Delay")

	commandsListView.OnRowSelected = function(self, index, pnl)
		for _, v in ipairs(commandsRight:GetChildren()) do
			v:Remove()
		end

		local ccmd = cache.data.botCommands[string.lower(pnl:GetColumnText(1))]

		configMenuHelpers.createCheckBox(commandsRight, 25, 25, "Enable Command", ccmd, 1)
		configMenuHelpers.createSlider(commandsRight, 50, 50, 200, 0, 240, "Command Delay", ccmd, 2)
	end

	--local newCommandButton = vgui.Create("DButton", commandsLeft)
	--newCommandButton:Dock(BOTTOM)
	--newCommandButton:SetText("Add Command")
--
	--newCommandButton.DoClick = function()
	--	invokeCommandPanel()
	--end

	configMenuHelpers.buildCommandListView(commandsListView)

	sheet:AddSheet("Main", mainPanel, "icon16/user.png")
	sheet:AddSheet("Commands", commandsPanel, "icon16/application_xp_terminal.png")
	sheet:AddSheet("Weapons", weaponPanel, "icon16/bomb.png")

	main:SetVisible(true)
	main:MakePopup()

	-- Reset this stuff

	isConfigMenuOpen = true

	main.OnClose = function()
		isConfigMenuOpen = false
	end

	main.OnRemove = function()
		isConfigMenuOpen = false
	end
end)

hook.Add("OnPlayerChat", "leme_awesomebot_onplayerchat", function(ply, msg)
	if not IsValid(ply) or ply ~= LocalPlayer() then
		return
	end

	if msg[1] == "!" then
		if string.TrimRight(string.lower(msg)) == "!botmenu" then
			if ply:IsSuperAdmin() then
				if not isConfigMenuOpen then
					net.Start("leme_awesomebot_request")
					net.SendToServer()
				end
			end
		end
	end
end)
