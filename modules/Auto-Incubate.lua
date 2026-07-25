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

local BeeEvent
do
	local function Find(Parent, Child)
		return Parent and Parent:FindFirstChild(Child)
	end
	local Interaction = workspace.Interaction
	local SaveSlotControllers = Find(ReplicatedStorage:WaitForChild("Modules"), "SaveSlotControllers")
	local SaveSlotController = Find(SaveSlotControllers, "SaveSlotController")
	local EventSlotController = Find(SaveSlotController, "EventSlotController")
	local BizzyBee2026 = Find(EventSlotController, "BizzyBee2026")
	BeeEvent = Find(BizzyBee2026, "BeeEvent") or Find(Interaction, "BeeEvent")
end

local HoneyIncubateEnabled
local IsHoneyIncubating
local HoneyIncubateConnection
local function HoneyIncubateLoop()
	IsHoneyIncubating = true
	local InsertPrompt = BeeEvent.Incubator.Machine.InserPart.InsertPrompt
	local HoneyIncubating
	local function HoneyIncubate()
		if HoneyIncubating or not HoneyIncubateEnabled then
			return
		end
		if InsertPrompt.ActionText == "Interact" and HoneyIncubateEnabled then
			Starlight:Notification({
				Title = "Auto-Honey Incubate Held Seed",
				Icon = NebulaIcons:GetIcon("ban", "Lucide"),
				Content = "You need to be on your Bizzy Bees garden to use this feature.",
				Duration = 15,
			}, "Honey Incubator Notif")
			return
		end
		HoneyIncubating = true
		local Character = LocalPlayer.Character
		while InsertPrompt.ActionText ~= "Skip Incubator" and HoneyIncubateEnabled and task.wait(1) do
			if InsertPrompt.ActionText == "Claim Seed" then
				GameEvents.BeeQueenHiveRemote:FireServer("ClaimSeed")
				task.wait(1)
			end
			if InsertPrompt.ActionText == "Remove Seed" then
				GameEvents.BeeQueenHiveRemote:FireServer("RemoveSeed")
				task.wait(1)
			end
			local Tool = Character:FindFirstChildOfClass("Tool")
			if Tool and Tool:FindFirstChild("Seed Local Script") and HoneyIncubateEnabled then
				GameEvents.BeeQueenHiveRemote:FireServer("SubmitSeed")
				task.wait(1)
				GameEvents.BeeQueenHiveRemote:FireServer("StartIncubator")
				task.wait(1)
			end
		end
		HoneyIncubating = nil
	end
	HoneyIncubateConnection = InsertPrompt:GetPropertyChangedSignal("ActionText"):Connect(HoneyIncubate)
	HoneyIncubate()
end

local JellyIncubateEnabled
local IsJellyIncubating
local JellyIncubateConnection
local function JellyIncubateLoop()
	IsJellyIncubating = true
	local PromptHolder = BeeEvent["Royal Jelly Machine"].JellyCraftingMachine.PromptHolder
	local InsertPrompt
	for _, Prompt in ipairs(PromptHolder:GetChildren()) do
		if Prompt.ActionText == "Submit" or Prompt.ActionText == "Skip" or Prompt.ActionText == "Claim" then
			InsertPrompt = Prompt
			break
		end
	end
	local JellyIncubating
	local function JellyIncubate()
		if JellyIncubating or not JellyIncubateEnabled then
			return
		end
		if InsertPrompt.ActionText == "Interact" and JellyIncubateEnabled then
			Starlight:Notification({
				Title = "Auto-Jelly Incubate Held Seed",
				Icon = NebulaIcons:GetIcon("ban", "Lucide"),
				Content = "You need to be on your Bizzy Bees garden to use this feature.",
				Duration = 15,
			}, "Jelly Incubator Notif")
			return
		end
		JellyIncubating = true
		local Character = LocalPlayer.Character
		while InsertPrompt.ActionText ~= "Skip" and JellyIncubateEnabled and task.wait(1) do
			if InsertPrompt.ActionText == "Claim" then
				GameEvents.JellyCrafting.Claim:FireServer()
				task.wait(1)
			end
			if not InsertPrompt.Enabled then
				GameEvents.JellyCrafting:FindFirstChild("Remove"):FireServer()
				task.wait(1)
			end
			local Tool = Character:FindFirstChildOfClass("Tool")
			if Tool and Tool:FindFirstChild("Seed Local Script") and JellyIncubateEnabled then
				GameEvents.JellyCrafting.Submit:FireServer()
				task.wait(1)
				GameEvents.JellyCrafting.Start:FireServer()
				task.wait(1)
			end
		end
		JellyIncubating = nil
	end
	JellyIncubateConnection = InsertPrompt:GetPropertyChangedSignal("ActionText"):Connect(JellyIncubate)
	JellyIncubate()
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

local AutoHoneyIncubateToggle = FarmGroupbox:CreateToggle({
    Name = "Auto-Honey Incubate Held Seed",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
		HoneyIncubateEnabled = Value
		if Value and not IsHoneyIncubating then
			task.spawn(HoneyIncubateLoop)
		elseif not Value then
			IsHoneyIncubating = nil
			if HoneyIncubateConnection then
				HoneyIncubateConnection:Disconnect()
				HoneyIncubateConnection = nil
			end
		end
    end,
}, "Auto Honey Incubator")

local AutoJellyIncubateToggle = FarmGroupbox:CreateToggle({
    Name = "Auto-Jelly Incubate Held Seed",
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
		JellyIncubateEnabled = Value
		if Value and not IsJellyIncubating then
			task.spawn(JellyIncubateLoop)
		elseif not Value then
			IsJellyIncubating = nil
			if JellyIncubateConnection then
				JellyIncubateConnection:Disconnect()
				JellyIncubateConnection = nil
			end
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
    HoneyIncubateEnabled = nil
    IsHoneyIncubating = nil
	JellyIncubateEnabled = nil
	IsJellyIncubating = nil
	if HoneyIncubateConnection then
		HoneyIncubateConnection:Disconnect()
		HoneyIncubateConnection = nil
	end
	if JellyIncubateConnection then
		JellyIncubateConnection:Disconnect()
		JellyIncubateConnection = nil
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