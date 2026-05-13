local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Starlight-UI-Milk/refs/heads/master/Source.lua"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Nebula-Icons-Milk/refs/heads/master/Loader.luau"))()

if not game:IsLoaded() then 
    game.Loaded:wait()
end

local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage.GameEvents
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

Starlight:SetTheme("Crimson")

local Window = Starlight:CreateWindow({
    Name = "Chiffon",
    Subtitle = "discord.gg/Dt79RuG4N3",
	Icon = "86988535813561",
	LoadingEnabled = true,
    LoadingSettings = {
        Title = "Chiffon",
        Subtitle = "Welcome!",
		Logo = "134709478207975"
    },
    FileSettings = {
        ConfigFolder = "C2Cfgs"
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"Opiumware", "MacSploit", "Delta", "Xeno", "Solara", "Seliware", "Madium"},
    UnsupportedExecutors = {},
    DiscordInvite = "Dt79RuG4N3",
    Backdrop = "111065788714232", 
    IconStyle = 1,
    Changelog = {
        {
            Title = "Module 2 'Auto-Incubate'",
            Date = "12 May 2026",
            Description = "Open source Auto-Incubate!",
        }
    }
})

local TabSection = Window:CreateTabSection("Panels")

local Auto = TabSection:CreateTab({
    Name = "Automation",
    Icon = NebulaIcons:GetIcon("refresh-cw", "Lucide"),
    Columns = 1,
}, "Automation Tab")

local FarmGroupbox = Auto:CreateGroupbox({
    Name = "Seeds & Plants",
    Icon = NebulaIcons:GetIcon("tree-palm", "Lucide"),
    Column = 1,
}, "Farm Groupbox")

local Settings = TabSection:CreateTab({
    Name = "Settings",
    Icon = NebulaIcons:GetIcon("wrench", "Lucide"),
    Columns = 1,
}, "Settings Tab")

local GameSettings = Settings:CreateGroupbox({
	Name = "Game",
	Icon = NebulaIcons:GetIcon("computer", "Lucide"),
	Column = 1,
}, "Game Settings")

local AutoIncubateEnabled
local IsIncubating

local Interaction = workspace:WaitForChild("Interaction")
local UpdateItems = Interaction:WaitForChild("UpdateItems")
local BeeEvent = UpdateItems:WaitForChild("BeeEvent")
local Incubator = BeeEvent:WaitForChild("Incubator")
local Machine = Incubator:WaitForChild("Machine")
local InserPart = Machine:WaitForChild("InserPart")

local function IncubateLoop()
	if IsIncubating then
		return
	end
	IsIncubating = true
	while AutoIncubateEnabled do
		local InsertPrompt = InserPart:FindFirstChild("InsertPrompt")
		if InsertPrompt.ActionText == "Remove Seed" then
			task.wait(0.2)
			GameEvents.BeeQueenHiveRemote:FireServer("RemoveSeed")
		end
		if InsertPrompt.ActionText == "Skip Incubator" then
			repeat
				task.wait(2)
			until InsertPrompt.ActionText == "Claim Seed"
		end
		if InsertPrompt.ActionText == "Claim Seed" then
			task.wait(0.2)
			GameEvents.BeeQueenHiveRemote:FireServer("ClaimSeed")
		end
		if InsertPrompt.ActionText == "Insert Seed" then
			local Character = LocalPlayer.Character
			local Tool = Character:FindFirstChildOfClass("Tool")
			if not Tool or not Tool:FindFirstChild("Seed Local Script") then
				task.wait(2)
				continue
			end
			GameEvents.BeeQueenHiveRemote:FireServer("SubmitSeed")
			task.wait(0.2)
			GameEvents.BeeQueenHiveRemote:FireServer("StartIncubator")
			task.wait(0.2)
		end
	end
	IsIncubating = nil
end

LocalPlayer.Idled:Connect(function()
	task.wait(5)
	VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
	task.wait(5)
end)

local function OnErrorMessageChanged(ErrorMessage)
    if ErrorMessage then
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end
GuiService.ErrorMessageChanged:Connect(OnErrorMessageChanged)

local AutoIncubateToggle = FarmGroupbox:CreateToggle({
    Name = "Auto-Incubate Held Seed",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoIncubateEnabled = Value
        if Value then
            task.spawn(IncubateLoop)
        end
    end,
}, "Auto Incubator")

local DeRender = GameSettings:CreateToggle({
	Name = "Disable 3D Rendering",
	CurrentValue = false,
	Style = 2,
	Callback = function(Value)
		RunService:Set3dRenderingEnabled(not Value)
	end,
}, "Unrender World")

local NoGui = GameSettings:CreateButton({
	Name = "Hide GUIs (must rejoin to undo)",
	Icon = NebulaIcons:GetIcon("eye-off", "Lucide"),
	Callback = function()
		for _, Element in pairs(PlayerGui:GetChildren()) do
			if Element:IsA("ScreenGui") then
				if Element.Name == "Sheckles_UI" or Element.Name == "ChocCoinCurrency_UI" then
					Element:Destroy()
				else
					Element.Enabled = false
				end
			end
		end
	end,
}, "Hide GUIs")

local Rejoin = GameSettings:CreateButton({
	Name = "Rejoin Game",
	Icon = NebulaIcons:GetIcon("wifi-sync", "Lucide"),
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end,
}, "Rejoin Game")

Starlight:OnDestroy(function()
    AutoIncubateEnabled = nil
    IsIncubating = nil
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()