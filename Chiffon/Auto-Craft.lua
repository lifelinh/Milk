local Executor = identifyexecutor()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if Executor == "Xeno" or Executor == "Solara" then
    LocalPlayer:Kick("This module does not work on Xeno or Solara. Please use the main loadstring for Milk.")
end

local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Starlight-UI-Milk/refs/heads/master/Source.lua"))()  
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/lifelinh/Nebula-Icons-Milk/refs/heads/master/Loader.luau"))()

Starlight:SetTheme("Crimson")

if not game:IsLoaded() then 
    game.Loaded:wait()
end

local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage.GameEvents
local CraftingStationHandler = require(ReplicatedStorage.Modules.CraftingStationHandler)
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local PlayerGui = LocalPlayer.PlayerGui

local AutoCraftGearEnabled
local GearRecipeSelected = {}
local AutoCraftSeedsEnabled
local SeedRecipeSelected = {}

local CraftingTables = workspace.CraftingTables

local EventCraftingWorkBench = CraftingTables.EventCraftingWorkBench
local GearCraftingProximityPrompt
for _, Model in ipairs(EventCraftingWorkBench:GetChildren()) do
    if Model.Name == "Model" then
        for _, Part in ipairs(Model:GetChildren()) do
            if #Part:GetChildren() > 0 then
                GearCraftingProximityPrompt = Part.CraftingProximityPrompt
                break
            end
        end
    end 
end

local function AutoCraftGearLoop()
    while AutoCraftGearEnabled and GearRecipeSelected[1] do
        GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", EventCraftingWorkBench, "GearEventWorkbench", GearRecipeSelected[1])
        task.wait(1)
        CraftingStationHandler:SubmitAllRequiredItems(EventCraftingWorkBench)
        task.wait(1)
        GameEvents.CraftingGlobalObjectService:FireServer("Craft", EventCraftingWorkBench, "GearEventWorkbench")
        repeat
            task.wait(1)
        until not AutoCraftGearEnabled or not GearRecipeSelected[1] or GearCraftingProximityPrompt.ActionText == "Claim" or GearCraftingProximityPrompt.ActionText == "Submit Item" or GearCraftingProximityPrompt.ActionText == "Select Recipe"
        GameEvents.CraftingGlobalObjectService:FireServer("Claim", EventCraftingWorkBench, "GearEventWorkbench", 1)
    end
end

local function AutoCraftSeedsLoop()
    while AutoCraftSeedsEnabled and SeedRecipeSelected[1] do
        local SeedEventCraftingWorkBench = CraftingTables.SeedEventCraftingWorkBench
        local Model = SeedEventCraftingWorkBench.Model
        local BenchTable = Model.BenchTable
        local SeedCraftingProximityPrompt = BenchTable.CraftingProximityPrompt
        GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", SeedEventCraftingWorkBench, "SeedEventWorkbench", SeedRecipeSelected[1])
        task.wait(1)
        CraftingStationHandler:SubmitAllRequiredItems(SeedEventCraftingWorkBench)
        task.wait(1)
        GameEvents.CraftingGlobalObjectService:FireServer("Craft", SeedEventCraftingWorkBench, "SeedEventWorkbench")
        repeat
            task.wait(1)
        until not AutoCraftSeedsEnabled or not SeedRecipeSelected[1] or SeedCraftingProximityPrompt.ActionText == "Claim" or SeedCraftingProximityPrompt.ActionText == "Submit Item" or SeedCraftingProximityPrompt.ActionText == "Select Recipe"
        GameEvents.CraftingGlobalObjectService:FireServer("Claim", SeedEventCraftingWorkBench, "SeedEventWorkbench", 1)
    end
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
        ConfigFolder = "C1Cfgs"
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"MacSploit", "Opiumware", "Delta", "Seliware", "Madium"}, 
    UnsupportedExecutors = {"Xeno", "Solara"},
    DiscordInvite = "Dt79RuG4N3",
    Backdrop = "111065788714232", 
    IconStyle = 1, 
    Changelog = {
        {
            Title = "Module 1 'Auto-Craft'",
            Date = "29 Apr. 2026",
            Description = "Open source and usable Auto-Craft!",
        }
    }
})

local TabSection = Window:CreateTabSection("Panels")

local Auto = TabSection:CreateTab({
    Name = "Automation",
    Icon = NebulaIcons:GetIcon("refresh-cw", "Lucide"),
    Columns = 1,
}, "Automation Tab")

local CraftGroupbox = Auto:CreateGroupbox({
    Name = "Crafting",
    Icon = NebulaIcons:GetIcon("grid-3x3", "Lucide"),
    Column = 1,
}, "Crafting Groupbox")

CraftGroupbox:CreateParagraph({
    Name = "Note:",
    Icon = NebulaIcons:GetIcon("info", "Lucide"),
    Content = "Before toggling an Auto-Craft feature, you must select a recipe from its dropdown menu.\nIf you forgot, untoggle and toggle the feature again after selecting a recipe."
}, "Note")

local AutoCraftGear = CraftGroupbox:CreateToggle({
    Name = "Auto-Craft Gear",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoCraftGearEnabled = Value
        if Value then
            task.spawn(AutoCraftGearLoop)
        end
    end,
}, "Auto-Craft Gear Toggle")

AutoCraftGear:AddDropdown({
    Options = {"Lightning Rod", "Tanning Mirror", "Reclaimer", "Event Lantern", "Anti Bee Egg", "Small Toy", "Small Treat", "Pet Pouch", "Pack Bee", "Silver Ingot", "Gold Ingot", "Silver Piggy", "Golden Piggy", "Chimera Stone"},
    CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "Select gear to craft",
    Callback = function(Options)
        GearRecipeSelected = Options
    end,
}, "Gear Recipe Dropdown")

local Divider = CraftGroupbox:CreateDivider()

local AutoCraftSeeds = CraftGroupbox:CreateToggle({
    Name = "Auto-Craft Seeds",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoCraftSeedsEnabled = Value
        if Value then
            task.spawn(AutoCraftSeedsLoop)
        end
    end,
}, "Auto-Craft Seeds Toggle")

AutoCraftSeeds:AddDropdown({
    Options = {"Egg Melon", "Mandrake", "Evo Apple I", "Evo Apple II", "Evo Apple III", "Evo Apple IV", "Olive", "Hollow Bamboo", "Yarrow"},
    CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "Select seed to craft",
    Callback = function(Options)
        SeedRecipeSelected = Options
    end,
}, "Seed Recipe Dropdown")

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

GameSettings:CreateToggle({
	Name = "Disable 3D Rendering",
	CurrentValue = false,
	Style = 2,
	Callback = function(Value)
		RunService:Set3dRenderingEnabled(not Value)
	end,
}, "Unrender World")

GameSettings:CreateButton({
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

GameSettings:CreateButton({
	Name = "Rejoin Game",
	Icon = NebulaIcons:GetIcon("wifi-sync", "Lucide"),
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end,
}, "Rejoin Game")

Starlight:OnDestroy(function()
    AutoCraftEnabled = nil
    SeedRecipeSelected = nil
    GearRecipeSelected = nil
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()

Starlight:LoadAutoloadConfig()