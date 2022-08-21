--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff

	Made for INFERNO (http://steamcommunity.com/profiles/76561198935068541)

	ConVars:
		inferno_fov_enabled					-	Controls custom FOV						(Default: 0)
		inferno_fov							-	Controls custom FOV amount				(Default: 75)
		inferno_viewmodel_fov_enabled		-	Controls custom viewmodel FOV			(Default: 0)
		inferno_viewmodel_fov				-	Controls custom viewmodel FOV amount	(Default: 54)
		inferno_viewmodel_offsets_enabled	-	Controls viewmodel offsets				(Default: 0)
		inferno_viewmodel_offsets_x			-	Controls viewmodel x offset				(Default: 0)
		inferno_viewmodel_offsets_y			-	Controls viewmodel y offset				(Default: 0)
		inferno_viewmodel_offsets_z			-	Controls viewmodel z offset				(Default: 0)
		inferno_viewmodel_offsets_pitch		-	Controls viewmodel pitch offset			(Default: 0)
		inferno_viewmodel_offsets_yaw		-	Controls viewmodel yaw offset			(Default: 0)
		inferno_viewmodel_offsets_roll		-	Controls viewmodel roll offset			(Default: 0)

	ConCommands:
		inferno_menu						-	Opens the menu
]]

--------------------------- Localization ---------------------------

local FILL = FILL
local EF_NODRAW = EF_NODRAW

local Angle = Angle
local Color = Color
local CreateClientConVar = CreateClientConVar
local GetConVar = GetConVar
local HSVToColor = HSVToColor
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local ScrH = ScrH
local ScrW = ScrW
local SysTime = SysTime
local Vector = Vector
local setmetatable = setmetatable

local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize

local hook_Run = hook.Run
local hook_Add = hook.Add

local player_manager_RunClass = player_manager.RunClass

local drive_CalcView = drive.CalcView

local math_Clamp = math.Clamp

local vgui_Create = vgui.Create

--------------------------- Registry ---------------------------

local _Registry = debug.getregistry()
local meta_cl = _Registry.Color

--------------------------- Cache ---------------------------

local Cache = {
	LocalPlayer = LocalPlayer(),

	Menu = nil,

	ScrW = ScrW(),
	ScrH = ScrH(),

	Colors = {
		RGB = Vector(1, 1, 1), -- Wtf vector color
		
		Black = Color(0, 0, 0, 255)
	},

	CalcViewData = {
		Origin = LocalPlayer():EyePos(),
		Angles = LocalPlayer():EyeAngles(),
		FOV = LocalPlayer():GetFOV(),
		ZNear = 3,
		ZFar = 30000
	},

	ConVars = {
		fov_desired = GetConVar("fov_desired"),
		viewmodel_fov = GetConVar("viewmodel_fov"),

		FOV = {
			Enabled = CreateClientConVar("inferno_fov_enabled", 0, true, false, "", 0, 1),
			Amount = CreateClientConVar("inferno_fov", 75, true, false, "", 2, 179)
		},

		Viewmodel = {
			FOV = {
				Enabled = CreateClientConVar("inferno_viewmodel_fov_enabled", 0, true, false, "", 0, 1),
				Amount = CreateClientConVar("inferno_viewmodel_fov", 54, true, false, "", 2, 164)
			},
			
			Offsets = {
				Enabled = CreateClientConVar("inferno_viewmodel_offsets_enabled", 0, true, false, "", 0, 1),
				X = CreateClientConVar("inferno_viewmodel_offsets_x", 0, true, false, "", -30, 30),
				Y = CreateClientConVar("inferno_viewmodel_offsets_y", 0, true, false, "", -30, 30),
				Z = CreateClientConVar("inferno_viewmodel_offsets_z", 0, true, false, "", -30, 30),
				Pitch = CreateClientConVar("inferno_viewmodel_offsets_pitch", 0, true, false, "", -90, 90),
				Yaw = CreateClientConVar("inferno_viewmodel_offsets_yaw", 0, true, false, "", -180, 180),
				Roll = CreateClientConVar("inferno_viewmodel_offsets_roll", 0, true, false, "", -180, 180)
			}
		}
	}
}

--------------------------- Functions ---------------------------

local function UpdateCalcViewData(View)
	Cache.CalcViewData.Origin = View.origin * 1
	Cache.CalcViewData.Angles = View.angles * 1
	Cache.CalcViewData.FOV = View.fov
	Cache.CalcViewData.ZNear = View.znear
	Cache.CalcViewData.ZFar = View.zfar
end

--------------------------- Hooks ---------------------------

hook_Add("Think", "INFERNO_Think", function()
	Cache.LocalPlayer = Cache.LocalPlayer or LocalPlayer()

	Cache.Colors.RGB = setmetatable(HSVToColor((SysTime() % 6) * 60, 1, 1), meta_cl):ToVector()

	Cache.LocalPlayer:SetWeaponColor(Cache.Colors.RGB)
	Cache.LocalPlayer:SetPlayerColor(Cache.Colors.RGB)
end)

hook_Add("PreDrawViewModels", "INFERO_PreDrawViewModels", function()
	local ViewModel = Cache.LocalPlayer:GetViewModel()
	if not IsValid(ViewModel) then return end

	local NoDraw = not ViewModel:IsEffectActive(EF_NODRAW)

	for i = 0, 2 do
		Cache.LocalPlayer:DrawViewModel(NoDraw, i)
	end
	
	if not NoDraw or Cache.LocalPlayer:ShouldDrawLocalPlayer() then return end

	for i = 0, 2 do
		Cache.LocalPlayer:DrawViewModel(false, i)
	end

	local CalcViewData = Cache.CalcViewData

	local ViewmodelFOV

	local DoFOV = Cache.ConVars.Viewmodel.FOV.Enabled:GetBool()
	local DoOffsets = Cache.ConVars.Viewmodel.Offsets.Enabled:GetBool()

	if DoFOV then
		ViewmodelFOV = Cache.ConVars.Viewmodel.FOV.Amount:GetInt() + 15.75
	else
		local BaseFOV = Cache.LocalPlayer:GetActiveWeapon().ViewModelFOV or Cache.ConVars.viewmodel_fov:GetInt() or 54
		
		local FOVOffset = (CalcViewData.FOV + 1) / 100
				
		ViewmodelFOV = BaseFOV + (((CalcViewData.FOV + 1) - BaseFOV) - ((0 - BaseFOV) + 83)) - (FOVOffset + (FOVOffset % 1) + 0.15)
	end

	local ViewAngles = CalcViewData.Angles

	local ViewPos = CalcViewData.Origin

	if DoOffsets then
		local ViewmodelAngleOffset = Angle(Cache.ConVars.Viewmodel.Offsets.Pitch:GetInt(), Cache.ConVars.Viewmodel.Offsets.Yaw:GetInt(), Cache.ConVars.Viewmodel.Offsets.Roll:GetInt()) -- TODO: Make these cached
		ViewAngles = ViewAngles + ViewmodelAngleOffset

		local ViewmodelOffset = Vector(0 - Cache.ConVars.Viewmodel.Offsets.X:GetInt(), 0 - Cache.ConVars.Viewmodel.Offsets.Y:GetInt(), 0 - Cache.ConVars.Viewmodel.Offsets.Z:GetInt())

		local Right = ViewAngles:Right()
		local Forward = ViewAngles:Forward()
		local Up = ViewAngles:Up()

		ViewPos = ViewPos + ViewmodelOffset.x * Right
		ViewPos = ViewPos + ViewmodelOffset.y * Forward
		ViewPos = ViewPos + ViewmodelOffset.z * Up
	end

	cam.Start3D(ViewPos, ViewAngles, ViewmodelFOV, 0, 0, Cache.ScrW, Cache.ScrH, CalcViewData.ZNear, CalcViewData.ZFar)
		cam.IgnoreZ(true)
	
		ViewModel:DrawModel()
		
		cam.IgnoreZ(false)
	cam.End3D()
end)

hook_Add("CalcView", "INFERNO_CalcView", function(Player, Pos, Angle, FOV, ZN, ZF)
	if not IsValid(Player) then return end

	local pFOV = FOV

	if Cache.ConVars.FOV.Enabled:GetBool() then
		pFOV = math_Clamp(FOV + (Cache.ConVars.FOV.Amount:GetInt() - Cache.ConVars.fov_desired:GetInt()), 2, 179)
	end

	local View = {
		origin = Pos,
		angles = Angle,
		fov = pFOV,
		znear = ZN,
		zfar = ZF
	}

	local Vehicle = Player:GetVehicle()

	if IsValid(Vehicle) then
		UpdateCalcViewData(View)
		return hook_Run("CalcVehicleView", Vehicle, Player, View)
	end

	if drive_CalcView(Player, View) then
		UpdateCalcViewData(View)
		return View
	end

	-- Fix for taunt_camera breaking thirdperson camera with these detours in place

	local pView = { origin = View.origin * 1, angles = View.angles * 1 }
	player_manager_RunClass(Player, "CalcView", pView)

	local pOffset = (pView.origin - View.origin):Length()

	View.origin = View.origin - (View.angles:Forward() * pOffset)

	local Weapon = Player:GetActiveWeapon()

	if IsValid(Weapon) then
		local wCalcView = Weapon.CalcView

		if wCalcView then
			View.origin, View.angles, View.fov = wCalcView(Weapon, Player, View.origin * 1, View.angles * 1, View.fov)
		end
	end

	UpdateCalcViewData(View)

	return View
end)

hook_Add("OnScreenSizeChanged", "INFERNO_OnScreenSizeChanged", function()
	Cache.ScrW = ScrW()
	Cache.ScrH = ScrH()
end)

--------------------------- Menu Setup ---------------------------

do
	local function CreateCheckBox(Panel, X, Y, Label, ConVar)
		local CheckBox = vgui_Create("DCheckBoxLabel", Panel)
		CheckBox:SetPos(X, Y)
		CheckBox:SetTextColor(Cache.Colors.Black)
		CheckBox:SetText(Label)
		CheckBox:SetConVar(ConVar:GetName())
	end

	local function CreateSlider(Panel, X, Y, W, Decimals, Label, ConVar)
		local NSlider = vgui_Create("DNumSlider", Panel)
		NSlider:SetWide(W)
		NSlider:SetPos(X, Y)
		NSlider:SetMinMax(ConVar:GetMin(), ConVar:GetMax())
		NSlider:SetDecimals(Decmials)
		NSlider:SetDark(true)
		NSlider:SetConVar(ConVar:GetName())
		NSlider:SetValue(ConVar:GetFloat())

		NSlider.Label:SetVisible(false)
		local NLabel = vgui_Create("DLabel", NSlider)

		surface_SetFont(NLabel:GetFont())
		local tw, _ = surface_GetTextSize(Label)

		NLabel:Dock(LEFT)
		NLabel:SetWide(tw)
		NLabel:SetText(Label)
		NLabel:SetTextColor(Cache.Colors.Black)
	end

	local Main = vgui_Create("DFrame")
	Main:SetSize(400, 425)
	Main:SetTitle("INFERNO's Utilities - Featuring a shitty Derma menu!")
	Main:Center()
	Main:SetVisible(false)
	Main:SetDeleteOnClose(false)

	local TopFrame = vgui_Create("DPanel", Main)
	TopFrame:SetSize(Main:GetWide() - 10, (Main:GetTall() / 3) - 5)
	TopFrame:SetPos(5, 24)

	--------------------------- FOV ---------------------------

	CreateCheckBox(TopFrame, 25, 25, "Custom FOV", Cache.ConVars.FOV.Enabled)

	local CurConVar = Cache.ConVars.FOV.Amount
	CreateSlider(TopFrame, 50, 50, TopFrame:GetWide() - 75,  0, "FOV Amount", CurConVar)

	--------------------------- Viewmodel FOV ---------------------------

	local BottomFrame = vgui_Create("DPanel", Main)
	BottomFrame:SetSize(Main:GetWide() - 10, (Main:GetTall() * (2 / 3)) - 29)
	BottomFrame:SetPos(5, 24 + (TopFrame:GetTall() + 5))

	local bWidth = BottomFrame:GetWide() - 75

	CreateCheckBox(BottomFrame, 25, 25, "Custom Viewmodel FOV", Cache.ConVars.Viewmodel.FOV.Enabled)
	CreateSlider(BottomFrame, 50, 40, bWidth, 0, "FOV Amount", Cache.ConVars.Viewmodel.FOV.Amount)

	CreateCheckBox(BottomFrame, 25, 75, "Viewmodel Offsets", Cache.ConVars.Viewmodel.Offsets.Enabled)
	CreateSlider(BottomFrame, 50, 90, bWidth, 0, "X", Cache.ConVars.Viewmodel.Offsets.X)
	CreateSlider(BottomFrame, 50, 115, bWidth, 0, "Y", Cache.ConVars.Viewmodel.Offsets.Y)
	CreateSlider(BottomFrame, 50, 140, bWidth, 0, "Z", Cache.ConVars.Viewmodel.Offsets.Z)
	CreateSlider(BottomFrame, 50, 165, bWidth, 0, "Pitch", Cache.ConVars.Viewmodel.Offsets.Pitch)
	CreateSlider(BottomFrame, 50, 190, bWidth, 0, "Yaw", Cache.ConVars.Viewmodel.Offsets.Yaw)
	CreateSlider(BottomFrame, 50, 215, bWidth, 0, "Roll", Cache.ConVars.Viewmodel.Offsets.Roll)

	Cache.Menu = Main
end

--------------------------- ConCommand ---------------------------

concommand.Add("inferno_menu", function()
	if IsValid(Cache.Menu) then
		Cache.Menu:SetVisible(true)
		Cache.Menu:MakePopup()
	end
end)
