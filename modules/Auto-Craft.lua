if not game:IsLoaded() then 
    game.Loaded:wait()
end

local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Starlight-UI-Milk/master/Source.lua"))()
local NebulaIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/the-amazing-digital-circus/Nebula-Icons-Milk/master/Loader.luau"))()

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local function FindFunction(t, f)
    if type(f) == t then
        return f
    end
    return nil
end

local Request = FindFunction("function", request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request))
local getconnections = FindFunction("function", getconnections or get_signal_cons)
local queuetp = FindFunction("function", queue_on_teleport)
local TeleportCheck

task.spawn(function()
	local Request = (fluxus and fluxus.request)
		or (http and http.request)
		or http_request
		or request
	if Request then
		pcall(function()
			Request({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					["Origin"] = "https://discord.com",
				},
				Body = HttpService:JSONEncode({
					cmd = "INVITE_BROWSER",
					nonce = HttpService:GenerateGUID(false),
					args = { code = "9NyRdmfTgp" },
				}),
			})
		end)
	end
end)

if game.PlaceId == 129954712878723 then
	return
end

if game.GameId ~= 7436755782 then
	return loadstring(game:HttpGet('https://raw.smokingscripts.org/vertex.lua'))()
end

if getconnections then
    for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
        if connection["Disable"] then
            connection["Disable"](connection)
        elseif connection["Disconnect"] then
            connection["Disconnect"](connection)
        end
    end
else
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function OnErrorMessageChanged(ErrorMessage)
    if ErrorMessage then
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

GuiService.ErrorMessageChanged:Connect(OnErrorMessageChanged)

LocalPlayer.OnTeleport:Connect(function(State)
	if not TeleportCheck and queuetp then
		TeleportCheck = true
		queuetp("loadstring(game:HttpGet('https://raw.githubusercontent.com/the-amazing-digital-circus/Milk/main/126884695634066'))()")
	end
end)

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
        ConfigFolder = "C1Cfgs"
    }
})

Window:CreateHomeTab({
    SupportedExecutors = {"MacSploit", "OpiumwareMac", "Delta", "Seliware", "Madium"}, 
    UnsupportedExecutors = {"Xeno", "Solara"},
    DiscordInvite = "9NyRdmfTgp",
    Backdrop = "81840397943482",
    IconStyle = 1,
    Changelog = {
        {
            Title = "Module 1 'Auto-Craft'",
            Date = "29 Apr. 2026",
            Description = "Open source and usable Auto-Craft!",
        }
    }
})

local TabSection = Window:CreateTabSection("Panels", false)

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

local RequirePassed, CraftingStationHandler = pcall(function()
	return require(ReplicatedStorage.Modules.CraftingStationHandler)
end)

local GearCraftingProximityPrompt
local CraftingTables = workspace.NPCS:FindFirstChild("CraftingTables")
local WorkbenchFound, EventCraftingWorkBench = pcall(function()
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

local ButtonHolder = PlayerGui.ActivePetUI.Frame.Main.PetLoadout.Main.ButtonHolder
local function SwapToLoadout(LoadoutNum)
	if LoadoutNum and LoadoutNum > 1 and LoadoutNum <= 6 and LoadoutNum % 0 == 1 then
		local LoadoutSlot = ButtonHolder:FindFirstChild("PET_LOADOUT_" .. LoadoutNum)
		if LoadoutSlot and LoadoutSlot.BackgroundColor3 ~= Color3.fromRGB(36, 227, 36) then
			repeat
				GameEvents.PetsService:FireServer("SwapPetLoadout", tonumber(LoadoutNum))
				task.wait(5)
				LoadoutSlot = ButtonHolder:FindFirstChild("PET_LOADOUT_" .. LoadoutNum)
			until LoadoutSlot and LoadoutSlot.BackgroundColor3 == Color3.fromRGB(36, 227, 36)
		end
	end
end

local GearCraftingProximityPromptConnection
local function AutoCraftGearLoop()
	IsCraftingGear = true
	if not WorkbenchFound then
		Starlight:Notification({
			Title = "Auto-Craft Gear",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "Crafting is not available in the tutorial servers.",
			Duration = 10,
		}, "Auto Craft Tut Error")
		return
	end
	local GearCrafting
	local function CraftGear()
		if GearCrafting or not AutoCraftGearEnabled or not GearRecipeSelected[1] then
			return
		end
		GearCrafting = true
		while GearCraftingProximityPrompt.ActionText ~= "Skip" and AutoCraftGearEnabled and GearRecipeSelected[1] and task.wait(1) do
			if GearCraftingProximityPrompt.ActionText == "Claim" then
				SwapToLoadout(PachySlot)
				GameEvents.CraftingGlobalObjectService:FireServer("Claim", EventCraftingWorkBench, "GearEventWorkbench", 1)
				task.wait(1)
			elseif GearCraftingProximityPrompt.ActionText ~= "Select Recipe" then
				GameEvents.CraftingGlobalObjectService:FireServer("Cancel", EventCraftingWorkBench, "GearEventWorkbench")
				task.wait(1)
			end
			SwapToLoadout(OrangutanSlot)
			GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", EventCraftingWorkBench, "GearEventWorkbench", GearRecipeSelected[1])
			if not RequirePassed then
				Starlight:Notification({
					Title = "Auto-Craft Gear",
					Icon = NebulaIcons:GetIcon("ban", "Lucide"),
					Content = "This feature is not supported on your executor.",
					Duration = 10,
				}, "Auto Craft Req Error")
				break
			end
			task.wait(1)
			CraftingStationHandler:SubmitAllRequiredItems(EventCraftingWorkBench)
			task.wait(1)
			GameEvents.CraftingGlobalObjectService:FireServer("Craft", EventCraftingWorkBench, "GearEventWorkbench")
		end
		SwapToLoadout(ForgerHamsterSlot)
		GearCrafting = nil
	end
	GearCraftingProximityPromptConnection = GearCraftingProximityPrompt:GetPropertyChangedSignal("ActionText"):Connect(CraftGear)
	CraftGear()
end

local SeedCraftingProximityPromptConnection
local function AutoCraftSeedsLoop()
	IsCraftingSeeds = true
	if not WorkbenchFound then
		Starlight:Notification({
			Title = "Auto-Craft Seeds",
			Icon = NebulaIcons:GetIcon("ban", "Lucide"),
			Content = "Crafting is not available in the tutorial servers.",
			Duration = 10,
		}, "Auto Craft Tut Error")
		return
	end
	local SeedEventCraftingWorkBench = CraftingTables.SeedEventCraftingWorkBench
	local SeedCraftingProximityPrompt = SeedEventCraftingWorkBench.Model.BenchTable.CraftingProximityPrompt
	local SeedCrafting
	local function CraftSeed()
		if SeedCrafting or not AutoCraftSeedsEnabled or not SeedRecipeSelected[1] then
			return
		end
		SeedCrafting = true
		while SeedCraftingProximityPrompt.ActionText ~= "Skip" and AutoCraftSeedsEnabled and SeedRecipeSelected[1] and task.wait(1) do
			if SeedCraftingProximityPrompt.ActionText == "Claim" then
				SwapToLoadout(PachySlot)
				GameEvents.CraftingGlobalObjectService:FireServer("Claim", SeedEventCraftingWorkBench, "SeedEventWorkbench", 1)
				task.wait(1)
			elseif SeedCraftingProximityPrompt.ActionText ~= "Select Recipe" then
				GameEvents.CraftingGlobalObjectService:FireServer("Cancel", SeedEventCraftingWorkBench, "SeedEventWorkbench")
				task.wait(1)
			end
			SwapToLoadout(OrangutanSlot)
			GameEvents.CraftingGlobalObjectService:FireServer("SetRecipe", SeedEventCraftingWorkBench, "SeedEventWorkbench", SeedRecipeSelected[1])
			if not RequirePassed then
				Starlight:Notification({
					Title = "Auto-Craft Seeds",
					Icon = NebulaIcons:GetIcon("ban", "Lucide"),
					Content = "This feature is not supported on your executor.",
					Duration = 10,
				}, "Auto Craft Req Error")
				break
			end
			task.wait(1)
			CraftingStationHandler:SubmitAllRequiredItems(SeedEventCraftingWorkBench)
			task.wait(1)
			GameEvents.CraftingGlobalObjectService:FireServer("Craft", SeedEventCraftingWorkBench, "SeedEventWorkbench")
		end
		SwapToLoadout(ForgerHamsterSlot)
		SeedCrafting = nil
	end
	SeedCraftingProximityPromptConnection = SeedCraftingProximityPrompt:GetPropertyChangedSignal("ActionText"):Connect(CraftSeed)
	CraftSeed()
end

local MyImportant
for _, Farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
	local Important = Farm.Important
	local Owner = Important.Data.Owner
	if Owner.Value == LocalPlayer.Name then
		MyImportant = Important
		break
	end
end

local MyPlants = MyImportant:FindFirstChild("Plants_Physical")
local MyCosmetics = MyImportant:FindFirstChild("Cosmetic_Physical")

local function SetPlantVisibility(Value)
	if Value then
		MyPlants.Parent = nil
	else
		MyPlants.Parent = MyImportant
	end
end

local function SetCosmeticVisibility(Value)
	if Value then
		MyCosmetics.Parent = nil
	else
		MyCosmetics.Parent = MyImportant
	end
end

local AutoCraftGear = CraftGroupbox:CreateToggle({
    Name = "Auto-Craft Gear",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
		AutoCraftGearEnabled = Value
		if Value and GearRecipeSelected[1] and not IsCraftingGear then
			task.spawn(AutoCraftGearLoop)
		elseif not Value or not GearRecipeSelected[1] then
			IsCraftingGear = nil
			if GearCraftingProximityPromptConnection then
				GearCraftingProximityPromptConnection:Disconnect()
				GearCraftingProximityPromptConnection = nil
			end
		end
    end,
}, "Auto-Craft Gear Toggle")

local GearRecipes = AutoCraftGear:AddDropdown({
    Options = {"Lightning Rod", "Tanning Mirror", "Reclaimer", "Event Lantern", "Small Toy", "Small Treat", "Pet Pouch", "Silver Ingot", "Gold Ingot", "Chimera Stone", "Black Spotty Egg", "Anti Bee Egg", "Pack Bee", "Tropical Mist Sprinkler", "Berry Blusher Sprinkler", "Spice Spritzer Sprinkler", "Flower Froster Sprinkler", "Stalk Sprout Sprinkler", "Sweet Soaker Sprinkler", "Mutation Spray Pollinated", "Honey Crafters Crate", "Mutation Spray Glimmering", "Mutation Spray Chilled", "Mutation Spray Shocked", "Mutation Spray Choc"},
	CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "no gear recipe selected",
    Callback = function(Options)
		GearRecipeSelected = Options
		if Options[1] and AutoCraftGearEnabled and not IsCraftingGear then
			task.spawn(AutoCraftGearLoop)
		elseif not Options[1] or not AutoCraftGearEnabled then
			IsCraftingGear = nil
			if GearCraftingProximityPromptConnection then
				GearCraftingProximityPromptConnection:Disconnect()
				GearCraftingProximityPromptConnection = nil
			end
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
		if Value and SeedRecipeSelected[1] and not IsCraftingSeeds then
			task.spawn(AutoCraftSeedsLoop)
		elseif not Value or not SeedRecipeSelected[1] then
			IsCraftingSeeds = nil
			if SeedCraftingProximityPromptConnection then
				SeedCraftingProximityPromptConnection:Disconnect()
				SeedCraftingProximityPromptConnection = nil
			end
		end
    end,
}, "Auto-Craft Seeds Toggle")

local SeedRecipes = AutoCraftSeeds:AddDropdown({
	Options = {"Mandrake", "Evo Apple I", "Evo Apple II", "Evo Apple III", "Evo Apple IV", "Olive", "Hollow Bamboo", "Yarrow", "Shadow Spine", "Egg Melon", "Grand Volcania", "Peace Lily", "Aloe Vera", "Guanabana", "Crafters Seed Pack", "Manuka Flower", "Dandelion", "Lumira", "Honeysuckle", "Bee Balm", "Nectar Thorn", "Suncoil", "Twisted Tangle", "Veinpetal", "Horsetail", "Lingonberry", "Amber Spine"},
    CurrentOptions = {},
    MultipleOptions = false,
    Placeholder = "no seed recipe selected",
    Callback = function(Options)
		SeedRecipeSelected = Options
		if Options[1] and AutoCraftSeedsEnabled and not IsCraftingSeeds then
			task.spawn(AutoCraftSeedsLoop)
		elseif not Options[1] or not AutoCraftSeedsEnabled then
			IsCraftingSeeds = nil
			if SeedCraftingProximityPromptConnection then
				SeedCraftingProximityPromptConnection:Disconnect()
				SeedCraftingProximityPromptConnection = nil
			end
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
        OrangutanSlot = tonumber(Text)
    end,
}, "Orangutan Slot")

local ForgerHamsterSlotInput = CraftGroupbox:CreateInput({
    Name = "Hamster/Forger-mutated Slot",
    Tooltip = "type the loadout slot number where you have craft speed boost pets equipped",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Text)
        ForgerHamsterSlot = tonumber(Text)
    end,
}, "Forger Slot")

local PachySlotInput = CraftGroupbox:CreateInput({
    Name = "Pachycephalosaurus Slot",
    Tooltip = "type the loadout slot number where you have pachys equipped, pack mules work too",
    CurrentValue = "",
    Numeric = true,
    Callback = function(Text)
        PachySlot = tonumber(Text)
    end,
}, "Pachy Slot")

local HidePlants = GameSettings:CreateToggle({
	Name = "Hide Plants",
	CurrentValue = false,
	Style = 2,
	Callback = function(Value)
		SetPlantVisibility(Value)
	end,
}, "Hide Plants")

local HideCosmetics = GameSettings:CreateToggle({
	Name = "Hide Cosmetics",
	CurrentValue = false,
	Style = 2,
	Callback = function(Value)
		SetCosmeticVisibility(Value)
	end,
}, "Hide Cosmetics")

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
	if GearCraftingProximityPromptConnection then
		GearCraftingProximityPromptConnection:Disconnect()
		GearCraftingProximityPromptConnection = nil
	end
	if SeedCraftingProximityPromptConnection then
		SeedCraftingProximityPromptConnection:Disconnect()
		SeedCraftingProximityPromptConnection = nil
	end
	if MyPlants then
		SetPlantVisibility(nil)
	end
	if MyCosmetics then
		SetCosmeticVisibility(nil)
	end
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()