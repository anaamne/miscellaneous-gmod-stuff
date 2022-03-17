include("fgui.lua")

-- Shitty quick test menu

local vars = {
	testoption = false,
	testcolor = Color(255, 255, 100, 255)
}

local test = fgui.Create("FHFrame")

test:SetTitle("STORMY IS SUPER FAT AND BLACK AND GAY")
test:SetSize(600, 700)
test:Center()

local testcheck = fgui.Create("FHCheckBox", test)
testcheck:SetPos(25, 25)
testcheck:SetVarTable(vars, "testoption")
testcheck.FHOnChange = function()
	test:SetAccentColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255))
end

local testslider = fgui.Create("FHSlider", test)
testslider:SetText("hi!")
testslider:SetSize(300, 24)
testslider:SetPos(25, 75)

local testdropdown = fgui.Create("FHDropDown", test)
testdropdown:SetSize(100, 15)
testdropdown:SetPos(25, 125)
testdropdown:AddChoice("A")
testdropdown:AddChoice("B")
testdropdown:AddChoice("C")

local testtab = fgui.Create("FHTabbedMenu", test)
testtab:SetSize(300, 100)
testtab:SetPos(250, 300)
testtab:SetTabBackground(true)
local hi = testtab:AddTab("hi")
local hello = testtab:AddTab("hello")

local testtab2 = fgui.Create("FHTabbedMenu", test)
testtab2:SetSize(300, 100)
testtab2:SetPos(250, 425)
testtab2:SetTabBackground(false)
local tab1 = testtab2:AddTab("your")
local tab2 = testtab2:AddTab("mom")

local testcheck2 = fgui.Create("FHCheckBox", tab1)
testcheck2:SetText("I'm on the inside!")
testcheck2:SetPos(25, 25)

local testlist = fgui.Create("FHList", test)
testlist:SetSize(200, 200)
testlist:SetPos(25, 300)
testlist:AddColumn("hello")
testlist:AddColumn("hey")
testlist:AddColumn("hi")
for i = 0, 20 do
	testlist:AddLine("your", "mom", "gay")
end

local testbutton = fgui.Create("FHButton", tab2)
testbutton:SetPos(25, 25)
testbutton:SetSize(100, 24)
testbutton:SetCallback(function(self) -- self gets passed through the click function
	print("hii " .. self:GetName())
end)

local testsection = fgui.Create("FHSection", test)
testsection:SetSize(200, 150)
testsection:SetPos(350, 25)
testsection:SetTitle("I'm a section!")
local testsectionbutton = fgui.Create("FHButton", testsection:GetContentFrame())
testsectionbutton:SetSize(150, 22)
testsectionbutton:SetText("Im in the section!")

local testtextbox = fgui.Create("FHTextBox", hi)
testtextbox:SetSize(150, 24)
testtextbox:SetPos(25, 25)

local testcolor = fgui.Create("FHColorButton", hello)
testcolor:SetPos(25, 25)
testcolor:SetSize(100, 25)
testcolor:SetText("hiyUWP(WHI")
testcolor:SetVarTable(vars, "testcolor")

local testbind = fgui.Create("FHBinder", test)
testbind:SetSize(100, 24)
testbind:SetPos(25, 550)
testbind:SetLabel("Test Bind")

local testmini = fgui.Create("FHMiniMenu")
testmini:SetSize(300, 300)
testmini:SetBackgroundAlpha(100)
testmini:AddColumn("hi")
testmini:AddColumn("hey")
testmini:AddRow({"wow", 327})

test:MakePopup()

concommand.Add("testInvertOption", function()
	vars.testoption = not vars.testoption
end)