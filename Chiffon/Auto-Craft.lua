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

local AutoCraftGearEnabled
local AutoCraftSeedsEnabled
local GearRecipeSelected = {}
local SeedRecipeSelected = {}
local OrangutanSlot
local ForgerHamsterSlot
local PachySlot
local IsCraftingGear
local IsCraftingSeeds

local ActivePetUI = PlayerGui:FindFirstChild("ActivePetUI")
local ActivePetFrame = ActivePetUI:FindFirstChild("Frame")
local ActivePetMain = ActivePetFrame:FindFirstChild("Main")
local ActivePetLoadout = ActivePetMain:FindFirstChild("PetLoadout")
local ActivePetLoadoutMain = ActivePetLoadout:FindFirstChild("Main")
local ActivePetButtonHolder = ActivePetLoadoutMain:FindFirstChild("ButtonHolder")
local GearCraftingProximityPrompt

local RequirePassed, CraftingStationHandler = pcall(function()
	return require(ReplicatedStorage.Modules.CraftingStationHandler)
end)

local WorkbenchFound, EventCraftingWorkBench = pcall(function()
	local CraftingTables = workspace:FindFirstChild("CraftingTables")
	local EventCraftingWorkBench = CraftingTables.EventCraftingWorkBench
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
	return EventCraftingWorkBench
end)

local function SwapToLoadout(LoadoutNum)
	local LoadoutSlot = ActivePetButtonHolder:FindFirstChild("PET_LOADOUT_" .. LoadoutNum)
	if LoadoutSlot and LoadoutSlot.BackgroundColor3 ~= Color3.fromRGB(36, 227, 36) then
		repeat
			task.wait(2)
			GameEvents.PetsService:FireServer("SwapPetLoadout", tonumber(LoadoutNum))
			LoadoutSlot = ActivePetButtonHolder:FindFirstChild("PET_LOADOUT_" .. LoadoutNum)
		until LoadoutSlot and LoadoutSlot.BackgroundColor3 == Color3.fromRGB(36, 227, 36)
	end
end

local function AutoCraftGearLoop()
	if not RequirePassed then
		Starlight:Notification({
			Title = "Error",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "Auto-Craft is not supported on your executor.",
			Duration = 10,
		}, "Auto Craft Req Error")
		return
	end
	if not WorkbenchFound then
		Starlight:Notification({
			Title = "Error",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "You cannot craft items in the tutorial servers.",
			Duration = 10,
		}, "Auto Craft Tut Error")
		return
	end
	if IsCraftingGear then
		return
	end
	IsCraftingGear = true
	local CraftAttempts = 0
    while AutoCraftGearEnabled and GearRecipeSelected[1] do
		if GearCraftingProximityPrompt.ActionText ~= "Select Recipe" then
			if GearCraftingProximityPrompt.ActionText == "Claim" then
				if PachySlot then
					SwapToLoadout(PachySlot)
				end
				GameEvents.CraftingGlobalObjectService:FireServer("Claim", EventCraftingWorkBench, "GearEventWorkbench", 1)
				task.wait(1)
			elseif GearCraftingProximityPrompt.ActionText ~= "Skip" then
				GameEvents.CraftingGlobalObjectService:FireServer("Cancel", EventCraftingWorkBench, "GearEventWorkbench")
				task.wait(1)
				CraftAttempts += 1
				if CraftAttempts > 10 then
					Starlight:Notification({
						Title = "Error",
						Icon = NebulaIcons:GetIcon("circle-alert", "Lucide"),
						Content = "You cannot afford to craft this recipe. Auto-Craft Gear has been disabled.",
						Duration = 10,
					}, "Gear Craft Notif")
					break
				end
			end
		end
        GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", EventCraftingWorkBench, "GearEventWorkbench", GearRecipeSelected[1])
        task.wait(1)
		if GearCraftingProximityPrompt.ActionText == "Submit Item" and OrangutanSlot then
			SwapToLoadout(OrangutanSlot)
		end
        CraftingStationHandler:SubmitAllRequiredItems(EventCraftingWorkBench)
        task.wait(1)
		if not AutoCraftGearEnabled or not GearRecipeSelected[1] then
			break
		end
        GameEvents.CraftingGlobalObjectService:FireServer("Craft", EventCraftingWorkBench, "GearEventWorkbench")
		task.wait(1)
		if GearCraftingProximityPrompt.ActionText == "Skip" and ForgerHamsterSlot then
			SwapToLoadout(ForgerHamsterSlot)
		end
        repeat
            task.wait(2)
        until not AutoCraftGearEnabled or not GearRecipeSelected[1] or GearCraftingProximityPrompt.ActionText ~= "Skip"
        if AutoCraftGearEnabled and GearRecipeSelected[1] then
			if GearCraftingProximityPrompt.ActionText == "Claim" and PachySlot then
				SwapToLoadout(PachySlot)
			end
			GameEvents.CraftingGlobalObjectService:FireServer("Claim", EventCraftingWorkBench, "GearEventWorkbench", 1)
			task.wait(1)
		end
    end
	IsCraftingGear = nil
end

local function AutoCraftSeedsLoop()
	if not RequirePassed then
		Starlight:Notification({
			Title = "Error",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "Auto-Craft is not supported on your executor.",
			Duration = 10,
		}, "Auto Craft Req Error")
		return
	end
	if not WorkbenchFound then
		Starlight:Notification({
			Title = "Error",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "You cannot craft items in the tutorial servers.",
			Duration = 10,
		}, "Auto Craft Tut Error")
		return
	end
	if IsCraftingSeeds then
		return
	end
	IsCraftingSeeds = true
	local CraftAttempts = 0
    while AutoCraftSeedsEnabled and SeedRecipeSelected[1] do
        local SeedEventCraftingWorkBench = workspace.CraftingTables.SeedEventCraftingWorkBench
        local Model = SeedEventCraftingWorkBench.Model
        local BenchTable = Model.BenchTable
        local SeedCraftingProximityPrompt = BenchTable.CraftingProximityPrompt
		if SeedCraftingProximityPrompt.ActionText ~= "Select Recipe" then
			if SeedCraftingProximityPrompt.ActionText == "Claim" then
				if PachySlot then
					SwapToLoadout(PachySlot)
				end
				GameEvents.CraftingGlobalObjectService:FireServer("Claim", SeedEventCraftingWorkBench, "SeedEventWorkbench", 1)
				task.wait(1)
			elseif SeedCraftingProximityPrompt.ActionText ~= "Skip" then
				GameEvents.CraftingGlobalObjectService:FireServer("Cancel", SeedEventCraftingWorkBench, "SeedEventWorkbench")
				task.wait(1)
				CraftAttempts += 1
				if CraftAttempts > 10 then
					Starlight:Notification({
						Title = "Error",
						Icon = NebulaIcons:GetIcon("circle-alert", "Lucide"),
						Content = "You cannot afford to craft this recipe. Auto-Craft Seeds has been disabled.",
						Duration = 10,
					}, "Seed Craft Notif")
					break
				end
			end
		end
        GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", SeedEventCraftingWorkBench, "SeedEventWorkbench", SeedRecipeSelected[1])
        task.wait(1)
		if OrangutanSlot and SeedCraftingProximityPrompt.ActionText == "Submit Item" then
			SwapToLoadout(OrangutanSlot)
		end
        CraftingStationHandler:SubmitAllRequiredItems(SeedEventCraftingWorkBench)
        task.wait(1)
		if not AutoCraftSeedsEnabled or not SeedRecipeSelected[1] then
			break
		end
        GameEvents.CraftingGlobalObjectService:FireServer("Craft", SeedEventCraftingWorkBench, "SeedEventWorkbench")
		task.wait(1)
		if ForgerHamsterSlot and SeedCraftingProximityPrompt.ActionText == "Skip" then
			SwapToLoadout(ForgerHamsterSlot)
		end
        repeat
            task.wait(2)
        until not AutoCraftSeedsEnabled or not SeedRecipeSelected[1] or SeedCraftingProximityPrompt.ActionText ~= "Skip"
        if AutoCraftSeedsEnabled and SeedRecipeSelected[1] then
			if PachySlot and SeedCraftingProximityPrompt.ActionText == "Claim" then
				SwapToLoadout(PachySlot)
			end
			GameEvents.CraftingGlobalObjectService:FireServer("Claim", SeedEventCraftingWorkBench, "SeedEventWorkbench", 1)
			task.wait(1)
		end
    end
	IsCraftingSeeds = nil
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

local GearRecipes = AutoCraftGear:AddDropdown({
    Options = {"Lightning Rod", "Tanning Mirror", "Reclaimer", "Event Lantern", "Anti Bee Egg", "Small Toy", "Small Treat", "Pet Pouch", "Pack Bee", "Silver Ingot", "Gold Ingot", "Silver Piggy", "Golden Piggy", "Chimera Stone"},
    CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "no gear recipe selected",
    Callback = function(Options)
        GearRecipeSelected = Options
        if AutoCraftGearEnabled then
            task.spawn(AutoCraftGearLoop)
        end
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

local SeedRecipes = AutoCraftSeeds:AddDropdown({
    Options = {"Egg Melon", "Mandrake", "Evo Apple I", "Evo Apple II", "Evo Apple III", "Evo Apple IV", "Olive", "Hollow Bamboo", "Yarrow"},
    CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "no seed recipe selected",
    Callback = function(Options)
        SeedRecipeSelected = Options
        if AutoCraftSeedsEnabled then
            task.spawn(AutoCraftSeedsLoop)
        end
    end,
}, "Seed Recipe Dropdown")

local Divider = CraftGroupbox:CreateDivider()

local OrangutanSlotInput = CraftGroupbox:CreateInput({
    Name = "Orangutan Slot",
    Tooltip = "type the loadout slot number where you have orangutans equipped",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Text)
        if Text == "2" then
            OrangutanSlot = "3"
        elseif Text == "3" then
            OrangutanSlot = "2"
        else
            OrangutanSlot = Text
        end
    end,
}, "Orangutan Slot")

local ForgerHamsterSlotInput = CraftGroupbox:CreateInput({
    Name = "Hamster/Forger-mutated Slot",
    Tooltip = "type the loadout slot number where you have craft speed boost pets equipped",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Text)
        if Text == "2" then
            ForgerHamsterSlot = "3"
        elseif Text == "3" then
            ForgerHamsterSlot = "2"
        else
            ForgerHamsterSlot = Text
        end
    end,
}, "Forger Slot")

local PachySlotInput = CraftGroupbox:CreateInput({
    Name = "Pachycephalosaurus Slot",
    Tooltip = "type the loadout slot number where you have pachys equipped, pack mules work too",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Text)
        if Text == "2" then
            PachySlot = "3"
        elseif Text == "3" then
            PachySlot = "2"
        else
            PachySlot = Text
        end
    end,
}, "Pachy Slot")

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
    AutoCraftGearEnabled = nil
    AutoCraftSeedsEnabled = nil
    GearRecipeSelected = {}
    SeedRecipeSelected = {}
    OrangutanSlot = nil
    ForgerHamsterSlot = nil
    PachySlot = nil
    IsCraftingGear = nil
    IsCraftingSeeds = nil
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()