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

local Window = MacLib:Window({
    Title = "Milk",
    Subtitle = "discord.gg/9NyRdmfTgp",
    Size = UDim2.fromOffset(800, 400),
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

local StatusSection = Tab:Section({
    Side = "Right"
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
        Description = "Token purchasing is not supported. Items will be bought with Robux instead.",
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

local GiftDropdown
local function RefreshUserTable()
	table.clear(Users)
	table.clear(UsernameIdPairs)
	for _, Player in ipairs(Players:GetPlayers()) do
        if Player == LocalPlayer then
            continue
        end
		table.insert(Users, Player.Name)
		UsernameIdPairs[Player.Name] = Player.UserId
	end
	if GiftDropdown then
		GiftDropdown:ClearOptions()
		GiftDropdown:InsertOptions(Users)
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
        if not SelectedItem then
            return
        end
        if not pass or not MarketController.CanPurchaseWithTokens(LocalPlayer, SelectedItem) then
            local robuxpassed, failure = pcall(function()
                MarketplaceService:PromptProductPurchase(LocalPlayer, SelectedItem)
            end)
            if not robuxpassed then
                Window:Notify({
                    Title = "Error",
                    Description = "Robux purchasing is disabled on your executor.",
                    Lifetime = 10
                })
            end
        else
            MarketController.PromptPurchase(LocalPlayer, SelectedItem)
        end
    end,
})

ShopSection:Button({
    Name = "Send Gift",
    Callback = function()
        GameEvents.Gift.SendGiftTo:FireServer({targetUserId = SelectedPlayer, productId = SelectedItem})
    end
})

local ItemStatus = StatusSection:Paragraph({
    Header = "",
    Body = ""
})

ShopSection:Dropdown({
	Name = "Products",
	Search = true,
	Multi = false,
	Required = false,
	Options = getgenv().ProductOptions,
	Callback = function(value)
		SelectedItem = getgenv().Products[value]
        if value then
            local ProductInformation = MarketplaceService:GetProductInfoAsync(SelectedItem, Enum.InfoType.Product)
            local TokenStatus, Reason = MarketController.CanPurchaseWithTokens(LocalPlayer, SelectedItem)
            local ReasonText = typeof(Reason) == "string" and (Reason) or "Item is Robux-only"
            ItemStatus:UpdateHeader(value)
            ItemStatus:UpdateBody(string.format("Price: %s\nPurchasable w/ tokens: %s %s", tostring(ProductInformation.PriceInRobux), tostring(TokenStatus), ReasonText or ""))
        end
	end,
}, "Product Dropdown")

GiftDropdown = ShopSection:Dropdown({
	Name = "Gift Target",
	Search = false,
	Multi = false,
	Required = false,
	Options = Users,
	Callback = function(value)
        SelectedPlayer = UsernameIdPairs[value]
	end,
}, "Gifting Dropdown")

ShopSection:Paragraph({
    Header = "Gift Instructions",
    Body = "Choose the non-gift version of a product that can be gifted. Select the player to send the gift to, then press the Send Gift button."
})

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
    SelectedPlayer = nil
    RunService:Set3dRenderingEnabled(true)
end)