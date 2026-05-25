local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Starlight-UI-Milk/master/Source.lua"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Nebula-Icons-Milk/master/Loader.luau"))()

if not game:IsLoaded() then 
    game.Loaded:wait()
end

local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

Starlight:SetTheme("Hollywood Fluent")

local Window = Starlight:CreateWindow({
    Name = "Milk",
    Subtitle = "discord.gg/9NyRdmfTgp",
	Icon = "105193356396598",
	LoadingEnabled = true,
    LoadingSettings = {
        Title = "Milk",
        Subtitle = "Welcome!",
		Logo = "82490480792476"
    },
    FileSettings = {
        ConfigFolder = "C5Cfgs"
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"MacSploit", "Opiumware", "Delta", "Seliware", "Madium"}, 
    UnsupportedExecutors = {"Xeno", "Solara"},
    DiscordInvite = "9NyRdmfTgp",
    Backdrop = "81840397943482",
    IconStyle = 1,
    Changelog = {
        {
            Title = "Module 5 'Roanoke'",
            Date = "25 May 2026",
            Description = "Auto-Rob for Roanoke!",
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
    Name = "Money",
    Icon = NebulaIcons:GetIcon("circle-dollar-sign", "Lucide"),
    Column = 1,
}, "Money Groupbox")

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

local RobberyLoopRunning
local AutoRobberyEnabled

local Map = workspace:WaitForChild("Map")
local Systems = workspace:WaitForChild("Systems")
local Robberies = Systems:WaitForChild("Robberies")

local function GetRoot(Character)
	if Character and Character:FindFirstChildOfClass("Humanoid") then
		return Character:FindFirstChildOfClass("Humanoid").RootPart
	else
		return nil
	end
end

local function TweenTP(Pivot)
    local Character = LocalPlayer.Character
    if Character and GetRoot(Character) then
        local Tween = TweenService:Create(GetRoot(Character), TweenInfo.new(25, Enum.EasingStyle.Linear), {CFrame = Pivot})
        Tween:Play()
        Tween.Completed:Wait()
    end
end

local function AutoRobbery()
    if RobberyLoopRunning then
        return
    end
    RobberyLoopRunning = true
    while AutoRobberyEnabled do
        task.wait(2)
        for _, Part in ipairs(Robberies:GetChildren()) do
            local ATMPrompt = Part:FindFirstChildOfClass("ProximityPrompt")
            if ATMPrompt and ATMPrompt.Enabled then
                TweenTP(Part:GetPivot() + Vector3.new(0, 2.5, 0))
                fireproximityprompt(ATMPrompt)
                task.wait(10)
                local Model
                for _, Object in ipairs(workspace:GetChildren()) do
                    if Object.Name == "Model" and Object:FindFirstChild("Cash") then
                        Model = Object
                    end
                end
                if Model then
                    for _, Item in ipairs(Model:GetChildren()) do
                        if Item.Name == "Cash" then
                            local CashPrompt = Item:FindFirstChildOfClass("ProximityPrompt")
                            task.wait(0.2)
                            fireproximityprompt(CashPrompt)
                        end
                    end
                end
            end
        end
    end
    RobberyLoopRunning = false
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

local AutoRobbery = FarmGroupbox:CreateToggle({
    Name = "Auto-Robbery",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoRobberyEnabled = Value
        if Value then
            task.spawn(AutoRobbery)
        end
    end,
}, "Auto-Robbery Toggle")

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
    RobberyLoopRunning = nil
    AutoRobberyEnabled = nil
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()