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

local TabSection = Window:CreateTabSection("Panels", false)

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

local BizzyBeeWaspDungeon = PlayerGui:FindFirstChild("BizzyBeeWaspDungeon_UI")
local Participation = BizzyBeeWaspDungeon:FindFirstChild("Participation")
local ParticipateButton = Participation:FindFirstChild("ParticipateButton")
local WaspWaveSurvival = ParticipateButton:FindFirstChild("WaspWaveSurvivalUI")

local WaspDgLoopRunning
local AutoWaspDgEnabled
local WaspBattleLoopRunning
local AutoWaspBattleEnabled
local FightingWasps
local WaspEggConnection

local MyImportant

local function AutoWaspDungeon()
	if WaspDgLoopRunning then
		return
	end
	WaspDgLoopRunning = true
	local Title = ParticipateButton:FindFirstChild("Title")
	while AutoWaspDgEnabled do
		repeat
			task.wait(2)
		until Title.Text == "Ignite Portal" or Title.Text == "Enter Portal" or not AutoWaspDgEnabled
		if AutoWaspDgEnabled then
			if Title.Text == "Enter Portal" then
				while FightingWasps do
					task.wait(2)
				end
				GameEvents.WaspWaveSurvival.RequestStart:InvokeServer()
				FightingWasps = true
				repeat
					task.wait(2)
				until not WaspWaveSurvival.Enabled or not AutoWaspDgEnabled
				FightingWasps = nil
			else
				GameEvents.WaspWaveSurvival.RequestStart:InvokeServer()
			end
		end
	end
	WaspDgLoopRunning = nil
end

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

for _, Farm in ipairs(workspace:WaitForChild("Farm"):GetChildren()) do
	local Important = Farm.Important
	local Owner = Important.Data.Owner
	if Owner.Value == LocalPlayer.Name then
		MyImportant = Important
		break
	end
end

local MyPlants = MyImportant.Plants_Physical
local MyCosmetics = MyImportant.Cosmetic_Physical

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

local AutoStartDungeon = MiscGroupbox:CreateToggle({
	Name = "Auto-Start Dungeon",
	CurrentValue = false,
	Style = 2,
	Callback = function(Value)
		AutoWaspDgEnabled = Value
		if Value then
			task.spawn(AutoWaspDungeon)
		end
	end,
}, "Auto Dungeon Toggle")

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
    WaspBattleLoopRunning = nil
    AutoWaspBattleEnabled = nil
	FightingWasps = nil
	SetPlantVisibility(nil)
	SetCosmeticVisibility(nil)
    RunService:Set3dRenderingEnabled(true)
end)

Settings:BuildConfigGroupbox()
Starlight:LoadAutoloadConfig()