local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()

if not game:IsLoaded() then 
    game.Loaded:wait()
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage.GameEvents
local MarketplaceService = game:GetService("MarketplaceService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local Window = MacLib:Window({
    Title = "Milk",
    Subtitle = "discord.gg/9NyRdmfTgp",
    Size = UDim2.fromOffset(580, 460),
    DragStyle = 2,
    DisabledWindowControls = {},
    ShowUserInfo = true,
    Keybind = Enum.KeyCode.LeftControl,
})

local TabGroup = Window:TabGroup()

local Tab = TabGroup:Tab({
    Name = "Main",
    Image = "rbxassetid://105193356396598"
})

local ShopSection = Tab:Section({
    Side = "Left"
})

local SettingsSection = Tab:Section({
    Side = "Right"
})

local SelectedItem
local SelectedPlayer
local Users = {}
local UsernameIdPairs = {}
local pass, MarketController = pcall(function()
	return require(ReplicatedStorage.Modules.MarketController)
end)

if not pass then
    Window:Notify({
        Title = "Incompatible Executor",
        Description = "Your executor is unable to load the necessary features for this script. All features have been disabled.",
        Lifetime = 10
    })
end

if not getgenv().Products or not getgenv().ProductOptions then
    Window:Notify({
        Title = "Loading Items",
        Description = "Please be patient. There are over 1,200 products to scan and load.",
        Lifetime = 10
    })
	local NameIdPairs = {}
    local ProductOptions = {}
	local Pages = MarketplaceService:GetDeveloperProductsAsync()
	repeat
		local DeveloperProducts = Pages:GetCurrentPage()
		for _, DeveloperProduct in ipairs(DeveloperProducts) do
            local Name = DeveloperProduct.Name
			NameIdPairs[Name] = DeveloperProduct.ProductId
            table.insert(ProductOptions, Name)
		end
		if not Pages.IsFinished then
			Pages:AdvanceToNextPageAsync()
		end
	until Pages.IsFinished
    table.sort(ProductOptions)
	getgenv().Products = NameIdPairs
    getgenv().ProductOptions = ProductOptions
end

local function RefreshUserTable()
	table.clear(Users)
    table.clear(UsernameIdPairs)
	for _, Player in ipairs(Players:GetPlayers()) do
		table.insert(Users, Player.Name)
        UsernameIdPairs[Player.Name] = Player.UserId
	end
end
RefreshUserTable()

Players.PlayerAdded:Connect(RefreshUserTable)
Players.PlayerRemoving:Connect(RefreshUserTable)

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

ShopSection:Button({
    Name = "Buy",
    Callback = function()
        local ProductId = getgenv().Products[SelectedItem]
        if not SelectedItem then
            Window:Notify({
                Title = "No Item Selected",
                Description = "Please choose a product from the searchable dropdown menu.",
                Lifetime = 5
            })
            return
        end
        print(pass)
        print(MarketController.CanPurchaseWithTokens(LocalPlayer, ProductId))
        if pass and MarketController.CanPurchaseWithTokens(LocalPlayer, ProductId) then
            print(ProductId)
            MarketController.PromptPurchase(LocalPlayer, ProductId)
        end
    end,
})

ShopSection:Dropdown({
	Name = "Products",
	Search = true,
	Multi = false,
	Required = false,
	Options = getgenv().ProductOptions,
	Callback = function(value)
		SelectedItem = value
	end,
}, "Product Dropdown")

ShopSection:Dropdown({
	Name = "Gift Player",
	Search = false,
	Multi = false,
	Required = false,
	Options = Users,
	Callback = function(value)
        local TargetId = UsernameIdPairs[value]
		GameEvents.Gift.SendGiftTo:FireServer({targetUserId = TargetId, productId = getgenv().Products[SelectedItem]})
	end,
}, "Gifting Dropdown")

SettingsSection:Toggle({
	Name = "Disable 3D Rendering",
	Default = false,
	Callback = function(value)
		RunService:Set3dRenderingEnabled(not value)
	end,
}, "DeRender")

SettingsSection:Button({
    Name = "Hide GUIs (must rejoin to undo)",
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
})

SettingsSection:Button({
    Name = "Rejoin Server",
	Callback = function()
		TeleportService:Teleport(game.PlaceId, LocalPlayer)
	end,
})

Tab:Select(Tab)
Window.onUnloaded(function()
    SelectedItem = nil
    RunService:Set3dRenderingEnabled(true)
end)