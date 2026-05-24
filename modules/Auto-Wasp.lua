local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Starlight-UI-Milk/refs/heads/master/Source.lua"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Nebula-Icons-Milk/refs/heads/master/Loader.luau"))()

if not game:IsLoaded() then 
    game.Loaded:wait()
end

local InsertService = game:GetService("InsertService")
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
        ConfigFolder = "C3Cfgs"
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"Opiumware", "MacSploit", "Delta", "Xeno", "Solara", "Seliware", "Madium"},
    UnsupportedExecutors = {},
    DiscordInvite = "9NyRdmfTgp",
    Backdrop = "81840397943482",
    IconStyle = 1,
    Changelog = {
        {
            Title = "Module 3 'Auto-Kill Wasps'",
            Date = "23 May 2026",
            Description = "Open source Auto-Kill wasps!",
        }
    }
})

local TabSection = Window:CreateTabSection("Panels")

local Auto = TabSection:CreateTab({
    Name = "Automation",
    Icon = NebulaIcons:GetIcon("refresh-cw", "Lucide"),
    Columns = 1,
}, "Automation Tab")

local MiscGroupbox = Auto:CreateGroupbox({
    Name = "Miscellaneous",
    Icon = NebulaIcons:GetIcon("gem", "Lucide"),
    Column = 1,
}, "Misc Groupbox")

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

local WaspBattleLoopRunning
local AutoWaspBattleEnabled
local FightingWasps
local WaspEggConnection

local function AutoWaspBattle()
	if WaspBattleLoopRunning then
		return
	end
	WaspBattleLoopRunning = true
	local Character = LocalPlayer.Character
	for _, Object in ipairs(workspace:GetChildren()) do
		if not AutoWaspBattleEnabled then
			break
		end
		if Object.Name == "WaspEgg" then
			while FightingWasps do
				task.wait(2)
			end
			if not AutoWaspBattleEnabled then
				break
			end
			FightingWasps = true
			Character:PivotTo(Object:GetPivot() + Vector3.new(0, 5, 0))
			repeat
				task.wait(2)
			until not Object.Parent or not AutoWaspBattleEnabled
			FightingWasps = nil
		end
	end
	WaspEggConnection = workspace.ChildAdded:Connect(function(Child)
		if not AutoWaspBattleEnabled then
			WaspBattleLoopRunning = nil
			WaspEggConnection:Disconnect()
			WaspEggConnection = nil
			return
		end
		if Child.Name == "WaspEgg" then
			while FightingWasps do
				task.wait(2)
			end
			if not Child.Parent then
				return
			end
			FightingWasps = true
			Character:PivotTo(Child:GetPivot() + Vector3.new(0, 5, 0))
			repeat
				task.wait(2)
			until not Child.Parent or not AutoWaspBattleEnabled
			FightingWasps = nil
		end
	end)
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

local AutoKillWasps = MiscGroupbox:CreateToggle({
    Name = "Auto-Kill Wasps",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoWaspBattleEnabled = Value
        if Value then
            task.spawn(AutoWaspBattle)
        end
    end,
}, "Auto Wasp Toggle")

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
    WaspBattleLoopRunning = nil
    AutoWaspBattleEnabled = nil
	FightingWasps = nil
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()