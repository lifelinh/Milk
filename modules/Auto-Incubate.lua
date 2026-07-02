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
        ConfigFolder = "C2Cfgs"
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
            Title = "Module 2 'Auto-Incubate'",
            Date = "12 May 2026",
            Description = "Open source Auto-Incubate!",
        }
    }
})

local TabSection = Window:CreateTabSection("Panels", false)

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

local AutoHoneyIncubateEnabled
local IsIncubatingHoney
local AutoJellyIncubateEnabled
local IsIncubatingJelly

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local WeeklyEvents = Modules:FindFirstChild("WeeklyEvents")
local WeeklyEventController = Modules:FindFirstChild("WeeklyEventController")
local TestEventFolder = WeeklyEventController:FindFirstChild("TestEvent")
local TestEvent = TestEventFolder:FindFirstChild("TestEvent")

local Incubator = TestEvent:WaitForChild("Incubator")
local Machine = Incubator:WaitForChild("Machine")
local InserPart = Machine:WaitForChild("InserPart")

local RoyalJellyMachine = TestEvent:WaitForChild("Royal Jelly Machine")
local JellyCraftingMachine = RoyalJellyMachine:WaitForChild("JellyCraftingMachine")
local PromptHolder = JellyCraftingMachine:FindFirstChild("PromptHolder")

local MyImportant

local function IncubateHoneyLoop()
	if IsIncubatingHoney then
		return
	end
	IsIncubatingHoney = true
	while AutoHoneyIncubateEnabled do
		local InsertPrompt = InserPart:FindFirstChild("InsertPrompt")
		if InsertPrompt.ActionText == "Interact" then
			Starlight:Notification({
				Title = "Error",
				Icon = NebulaIcons:GetIcon("ban", "Lucide"),
				Content = "You need to be on your Bizzy Bees garden to use this feature.",
				Duration = 15,
			}, "Honey Incubator Notif")
			repeat
				task.wait(2)
			until InsertPrompt.ActionText ~= "Interact" or not AutoHoneyIncubateEnabled
		end
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
	IsIncubatingHoney = nil
end

local function IncubateJellyLoop()
	if IsIncubatingJelly then
		return
	end
	IsIncubatingJelly = true
	local InsertPrompt
	for _, Prompt in ipairs(PromptHolder:GetChildren()) do
		if Prompt.ActionText == "Submit" or Prompt.ActionText == "Skip" or Prompt.ActionText == "Claim" then
			InsertPrompt = Prompt
		end
	end
	while AutoJellyIncubateEnabled do
		if InsertPrompt.ActionText == "Interact" then
			Starlight:Notification({
				Title = "Error",
				Icon = NebulaIcons:GetIcon("ban", "Lucide"),
				Content = "You need to be on your Bizzy Bees garden to use this feature.",
				Duration = 15,
			}, "Jelly Incubator Notif")
			repeat
				task.wait(2)
			until InsertPrompt.ActionText ~= "Interact" or not AutoJellyIncubateEnabled
		end
		if not InsertPrompt.Enabled then
			task.wait(0.2)
			GameEvents.JellyCrafting:FindFirstChild("Remove"):FireServer()
		end
		if InsertPrompt.ActionText == "Skip" then
			repeat
				task.wait(2)
			until InsertPrompt.ActionText == "Claim"
		end
		if InsertPrompt.ActionText == "Claim" then
			task.wait(0.2)
			GameEvents.JellyCrafting.Claim:FireServer()
		end
		if InsertPrompt.ActionText == "Submit" then
			local Character = LocalPlayer.Character
			local Tool = Character:FindFirstChildOfClass("Tool")
			if not Tool or not Tool:FindFirstChild("Seed Local Script") then
				task.wait(2)
				continue
			end
			GameEvents.JellyCrafting.Submit:FireServer()
			task.wait(0.2)
			GameEvents.JellyCrafting.Start:FireServer()
			task.wait(0.2)
		end
	end
	IsIncubatingJelly = false
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

local AutoHoneyIncubateToggle = FarmGroupbox:CreateToggle({
    Name = "Auto-Honey Incubate Held Seed",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoHoneyIncubateEnabled = Value
        if Value then
            task.spawn(IncubateHoneyLoop)
        end
    end,
}, "Auto Honey Incubator")

local AutoJellyIncubateToggle = FarmGroupbox:CreateToggle({
    Name = "Auto-Jelly Incubate Held Seed",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        AutoJellyIncubateEnabled = Value
        if Value then
            task.spawn(IncubateJellyLoop)
        end
    end,
}, "Auto Jelly Incubator")

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
    AutoHoneyIncubateEnabled = nil
    IsIncubatingHoney = nil
	AutoJellyIncubateEnabled = nil
	IsIncubatingJelly = nil
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