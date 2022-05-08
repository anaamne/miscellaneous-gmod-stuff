--[[
	https://github.com/awesomeusername69420/miscellaneous-gmod-stuff
]]

-- TODO:
-- 		Find a way to figure out which viewmodels don't work (They don't bonemerge properly)
--		Find a way to fix viewmodels that don't work (Bone magic?)

local VIEWMODELS = {}
local filters = {"arms", "hands"} -- This is bad but it's a good starting place

-- Weapon scan

for _, data in ipairs(weapons.GetList()) do
	local modelpath = data.ViewModel
	
	if not modelpath or #modelpath < 1 then continue end
	
	local breakouter = true
	
	for _, filter in ipairs(filters) do
		if modelpath:find(filter) then
			breakouter = false
			break
		end
	end
	
	if breakouter then continue end
	
	VIEWMODELS[modelpath] = true -- Dumb but makes life easier for the file scan
end

-- File scan

local files, _ = file.Find("models/weapons/*", "GAME")

for _, mdl in ipairs(files) do
	local modelpath = "models/weapons/" .. mdl
	
	if VIEWMODELS[modelpath] or mdl:sub(#mdl - 3) ~= ".mdl" then continue end
	
	local breakouter = true
	
	for _, filter in ipairs(filters) do
		if mdl:find(filter) then
			breakouter = false
			break
		end
	end
	
	if breakouter then continue end

	VIEWMODELS[modelpath] = true
end

local VM = ClientsideModel("models/weapons/viewhands_player_us_rangers.mdl", RENDERGROUP_BOTH)
VM:UseClientSideAnimation()
VM:SetNoDraw(true)
VM:SetRenderMode(RENDERMODE_TRANSCOLOR)

hook.Add("PreDrawPlayerHands", "vmchange", function(hands, pVM)
	VM:SetParent(pVM)
	VM:SetPos(pVM:GetPos())
	VM:SetAngles(pVM:GetAngles())
	
	if not VM:IsEffectActive(EF_BONEMERGE) then
		VM:AddEffects(EF_BONEMERGE)
		VM:AddEffects(EF_BONEMERGE_FASTCULL)
	end
	
	VM:DrawModel()
	
	return true
end)

local Main = vgui.Create("DFrame")
Main:SetSize(500, 200)
Main:Center()
Main:SetTitle("Viewmodel Changer")
Main:SetDeleteOnClose(false)

local DropDown = vgui.Create("DComboBox", Main)
DropDown:SetSize(400, 24)
DropDown:Center()

for k, _ in pairs(VIEWMODELS) do
	DropDown:AddChoice(k)
end

DropDown.OnSelect = function(self, index, value)
	if not VIEWMODELS[value] then return end -- ??????
	
	VM:InvalidateBoneCache()
	VM:SetModel(value)
	VM:SetupBones()
end

DropDown.DoRightClick = function(self)
	local cur, _ = self:GetSelected()
	
	if not cur then return end
	
	SetClipboardText(cur)
end

Main:MakePopup()

concommand.Add("debugcmd", function()
	print("~~~~~~~~~~~~~~~~~BONES~~~~~~~~~~~~~~~~~~~")
	for i = 1, VM:GetBoneCount() - 1 do
		print(VM:GetBoneName(i))
	end
	
	print("\n~~~~~~~~~~~~~~MATERIALS~~~~~~~~~~~~~~~~")
	
	local mats = VM:GetMaterials()
	
    for i = 1, #mats do
        local cur = mats[i]
		
		if not cur then continue end
	
        local mat = Material(mats[i])
	
        if mat then
            local txt = mat:GetTexture("$basetexture")
	
            if not txt or txt:IsError() or txt:IsErrorTexture() then
                print(cur, "", "Valid = false")
            else
                print(cur, "", "Valid = TRUE")
            end
        else
			print(cur, "", "Valid = false")
        end
	end
	
	print("\n~~~~~~~~~~util.IsValidModel~~~~~~~~~~~~")
	print(util.IsValidModel(VM:GetModel()))
end)

concommand.Add("viewmodel_menu", function()
	Main:SetVisible(true)
	Main:MakePopup()
end)
