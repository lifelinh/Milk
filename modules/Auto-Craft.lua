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
    SupportedExecutors = {"MacSploit", "Opiumware", "Delta", "Seliware", "Madium"}, 
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

local AutoCraftCampfireEnabled
local AutoCraftGearEnabled
local AutoCraftSeedsEnabled
local CampfireRecipeSelected = {}
local GearRecipeSelected = {}
local SeedRecipeSelected = {}
local OrangutanSlot
local ForgerHamsterSlot
local PachySlot
local IsCraftingCampfire
local IsCraftingGear
local IsCraftingSeeds

local SummerCrafting = PlayerGui:FindFirstChild("SummerCrafting")
local Crafting = SummerCrafting:FindFirstChild("Crafting")
local Main = Crafting:FindFirstChild("Main")
local Campfire = Main:FindFirstChild("Campfire")
local CampfireCrafting = Campfire:FindFirstChild("Crafting")
local Craft1 = CampfireCrafting:FindFirstChild("Craft1")
local Craft2 = CampfireCrafting:FindFirstChild("Craft2")
local Craft3 = CampfireCrafting:FindFirstChild("Craft3")

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
	local CraftingTables = workspace.NPCS:FindFirstChild("CraftingTables")
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

local MyImportant

local function AutoCraftCampfireLoop()
	if IsCraftingCampfire then
		return
	end 
	IsCraftingCampfire = true
	local SummerCraftingService = GameEvents.SummerCraftingService
	local TimesLeft = {Craft1.TimeLeft, Craft2.TimeLeft, Craft3.TimeLeft}
	while AutoCraftCampfireEnabled and CampfireRecipeSelected[1] do
		local HasOpenSlot = nil
		local HasClaim = nil
		for Index, TimeLeft in ipairs(TimesLeft) do
			if TimeLeft.Visible and TimeLeft.Text == "CLAIM!" then
				HasClaim = true
				SummerCraftingService.ClaimCraft:FireServer(Index)
				task.wait(0.2)
			end
			if not TimeLeft.Visible then
				HasOpenSlot = true
			end
		end
		if HasOpenSlot then
			SummerCraftingService.StartCraft:FireServer(CampfireRecipeSelected[1])
			task.wait(0.5)
		elseif not HasClaim then
			repeat
				task.wait(2)
			until not AutoCraftCampfireEnabled or not CampfireRecipeSelected[1] or not TimesLeft[1].Visible or not TimesLeft[2].Visible or not TimesLeft[3].Visible or TimesLeft[1].Text == "CLAIM!" or TimesLeft[2].Text == "CLAIM!" or TimesLeft[3].Text == "CLAIM!"
		end
	end
	IsCraftingCampfire = nil
end

local function SwapToLoadout(LoadoutNum)
	local LoadoutSlot = ActivePetButtonHolder:FindFirstChild("PET_LOADOUT_" .. LoadoutNum)
	if LoadoutSlot and LoadoutSlot.BackgroundColor3 ~= Color3.fromRGB(36, 227, 36) then
		repeat
			GameEvents.PetsService:FireServer("SwapPetLoadout", tonumber(LoadoutNum))
			task.wait(5)
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
	local SeedEventCraftingWorkBench = workspace.NPCS.CraftingTables.SeedEventCraftingWorkBench
	local Model = SeedEventCraftingWorkBench.Model
	local BenchTable = Model.BenchTable
	local SeedCraftingProximityPrompt = BenchTable.CraftingProximityPrompt
    while AutoCraftSeedsEnabled and SeedRecipeSelected[1] do
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

local AutoCraftCampfire = CraftGroupbox:CreateToggle({
    Name = "Auto-Craft Campfire Recipe",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoCraftCampfireEnabled = Value
        if Value then
            task.spawn(AutoCraftCampfireLoop)
        end
    end,
}, "Auto-Craft Campfire Toggle")

local CampfireRecipes = AutoCraftCampfire:AddDropdown({
	Options = {"1:1:Firepit Flower", "1:2:Cauliflower", "2:1:Campfire Crate", "2:2:Common Summer Egg", "2:3:Green Apple", "2:4:Avocado", "3:1:Super Watering Can", "3:2:Areaclaimer", "3:3:Banana", "3:4:Kiwi", "4:1:Hearth Reed", "4:2:Smoke Stalk", "4:3:Rare Summer Egg", "4:4:Prickly Pear", "4:5:Flame Bear", "5:1:Feijoa", "5:2:Paradise Egg", "5:3:Energy Chew", "5:4:Pitcher Plant", "5:5:Campfire Egg"},
	CurrentOptions = {},
	MultipleOptions = false,
	Placeholder = "no campfire recipe selected",
	Callback = function(Options)
		CampfireRecipeSelected = Options
		if AutoCraftCampfireEnabled then
			task.spawn(AutoCraftCampfireLoop)
		end
	end,
}, "Campfire Recipe Dropdown")

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
    Options = {"Lightning Rod", "Tanning Mirror", "Reclaimer", "Event Lantern", "Small Toy", "Small Treat", "Pet Pouch", "Pack Bee", "Silver Ingot", "Gold Ingot", "Chimera Stone", "Black Spotty Egg", "Anti Bee Egg", "Tropical Mist Sprinkler", "Berry Blusher Sprinkler", "Spice Spritzer Sprinkler", "Flower Froster Sprinkler", "Stalk Sprout Sprinkler", "Sweet Soaker Sprinkler", "Mutation Spray Pollinated", "Honey Crafters Crate", "Mutation Spray Glimmering", "Mutation Spray Chilled", "Mutation Spray Shocked", "Mutation Spray Choc"},
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
	Options = {"Egg Melon", "Mandrake", "Evo Apple I", "Evo Apple II", "Evo Apple III", "Evo Apple IV", "Olive", "Hollow Bamboo", "Yarrow", "Shadow Spine", "Grand Volcania", "Peace Lily", "Aloe Vera", "Guanabana", "Crafters Seed Pack", "Manuka Flower", "Dandelion", "Lumira", "Honeysuckle", "Bee Balm", "Nectar Thorn", "Suncoil", "Twisted Tangle", "Veinpetal", "Horsetail", "Lingonberry", "Amber Spine"},
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
	AutoCraftCampfireEnabled = nil
    AutoCraftGearEnabled = nil
    AutoCraftSeedsEnabled = nil
	CampfireRecipeSelected = {}
    GearRecipeSelected = {}
    SeedRecipeSelected = {}
    OrangutanSlot = nil
    ForgerHamsterSlot = nil
    PachySlot = nil
	IsCraftingCampfire = nil
    IsCraftingGear = nil
    IsCraftingSeeds = nil
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