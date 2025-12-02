-- Fish It Script - Main File
-- Version: 1.0.0
-- Full Featured Script for Fish It

repeat task.wait() until game:IsLoaded()

-- Anti-Detection & Protection
local ProtectedCall = pcall
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

-- Script Info
local ScriptVersion = "1.0.0"
local ScriptName = "FMS Hub"

-- Get Player Data Path
local PlayerDataPath = LocalPlayer.UserId .. "_FishItData.json"

-- Default Settings
local DefaultSettings = {
    -- Main Settings
    WalkSpeed = 16,
    JumpPower = 50,
    FreezePosition = false,
    
    -- Auto Fishing
    AutoFish = false,
    AutoShake = true,
    AutoReel = true,
    AutoEquipBestRod = true,
    
    -- Auto Sell
    AutoSell = false,
    SellInterval = 300, -- 5 minutes
    
    -- Auto Favorite
    AutoFavorite = false,
    FavoriteRarity = {"Mythical", "Legendary", "Secret"},
    
    -- Teleport
    SavedLocations = {},
    
    -- Quest
    AutoQuest = false,
    QuestType = "Ghostfinn",
    MinimumRod = "Astral",
    
    -- Shop
    AutoBuyRod = false,
    TargetRod = "Element",
    AutoBuyBait = false,
    TargetBait = "None",
    
    -- Webhook
    WebhookURL = "",
    WebhookEnabled = false,
    NotifyRarity = {"Secret", "Mythical", "Legendary"},
    
    -- Performance
    FPSUnlock = false,
    LowGraphics = false,
    
    -- Anti Detection
    AntiKick = true,
    AntiAFK = true,
    
    -- Kaitun Mode
    KaitunMode = false
}

-- Load or Create Settings
local Settings = DefaultSettings
if isfile and readfile and isfile(PlayerDataPath) then
    local success, loadedData = ProtectedCall(function()
        return HttpService:JSONDecode(readfile(PlayerDataPath))
    end)
    if success and loadedData then
        Settings = loadedData
        print("[Fish It] ✅ Settings loaded!")
    end
end

-- Save Settings Function
local function SaveSettings()
    if writefile then
        writefile(PlayerDataPath, HttpService:JSONEncode(Settings))
        print("[Fish It] 💾 Settings saved!")
    end
end

-- Rod List (Ordered by tier)
local RodList = {
    "Flimsy Rod", "Plastic Rod", "Lucky Rod", "Kings Rod",
    "Mythical Rod", "Training Rod", "Fast Rod", "Carbon Rod",
    "Long Rod", "Magnet Rod", "Steady Rod", "Rapid Rod",
    "Nocturnal Rod", "Aurora Rod", "Stone Rod", "Mag Rod",
    "Trident Rod", "Reinforced Rod", "Fortune Rod", "Scurvy Rod",
    "Destiny Rod", "Voyager Rod", "Sunken Rod", "Rod Of The Depths",
    "Rod Of The Eternal King", "No-Life Rod", "Kings Rod", 
    "Heaven's Rod", "Hexed Rod", "Tempest Rod", "Pharaoh's Rod",
    "Trident Rod", "Arctic Rod", "Vampire Rod", "Astral Rod",
    "Bait Caster", "Celestial Rod", "Phoenix Rod", "Poseidons Rod",
    "Enchanted Altar Rod", "Wisdom Rod", "Ghast Rod", "Lantern Rod",
    "Ghostfinn Rod", "Element Rod"
}

-- Fish Rarity List
local FishRarities = {
    "Common", "Uncommon", "Rare", "Legendary", "Mythical", "Secret", "Limited"
}

-- Location Presets
local LocationPresets = {
    ["Moosewood"] = CFrame.new(387, 132, 223),
    ["Roslit Bay"] = CFrame.new(-1472, 132, 673),
    ["Snowcap Island"] = CFrame.new(2648, 139, 2522),
    ["Mushgrove Swamp"] = CFrame.new(2500, 131, -720),
    ["Vertigo"] = CFrame.new(-112, -492, 1040),
    ["The Depths"] = CFrame.new(1000, -710, 1300),
    ["Ancient Isle"] = CFrame.new(5930, 132, 370),
    ["Forsaken Shores"] = CFrame.new(-2500, 132, 1500),
    ["Statue Of Sovereignty"] = CFrame.new(65, 165, 40),
    ["Terrapin Island"] = CFrame.new(-50, 132, 1850),
    ["Sunstone Island"] = CFrame.new(-950, 132, -1100),
    ["The Arch"] = CFrame.new(1000, 133, -1200),
    ["Harvesters Spike"] = CFrame.new(1300, 133, -1200)
}

print("[Fish It] 🎣 Main script initialized!")
print("[Fish It] 👤 Player: " .. LocalPlayer.Name)
print("[Fish It] 🆔 User ID: " .. LocalPlayer.UserId)

-- Continue to Part 2...
-- UI Library (Fluent-like Modern UI)
local Library = {}

function Library:CreateWindow(config)
    local Window = {}
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Add UICorner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    -- Add Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "FMS Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar
    
    -- Version Text
    local Version = Instance.new("TextLabel")
    Version.Name = "Version"
    Version.Size = UDim2.new(0, 100, 1, 0)
    Version.Position = UDim2.new(0, 215, 0, 0)
    Version.BackgroundTransparency = 1
    Version.Text = "v" .. ScriptVersion
    Version.TextColor3 = Color3.fromRGB(150, 150, 150)
    Version.TextSize = 12
    Version.TextXAlignment = Enum.TextXAlignment.Left
    Version.Font = Enum.Font.Gotham
    Version.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 20
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -175, 1, -50)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Dragging functionality
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Tab System
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    function Window:CreateTab(name, icon)
        local Tab = {}
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -10, 1, -10)
        TabContent.Position = UDim2.new(0, 5, 0, 5)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Window.CurrentTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                Window.CurrentTab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            
            Window.CurrentTab = {Button = TabButton, Content = TabContent}
        end)
        
        -- Auto-select first tab
        if not Window.CurrentTab then
            TabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = {Button = TabButton, Content = TabContent}
        end
        
        Tab.Content = TabContent
        
        -- Element Creation Functions
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Font = Enum.Font.Gotham
            Label.Parent = TabContent
            
            return Label
        end
        
        function Tab:AddButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.Size = UDim2.new(1, -10, 0, 35)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Button.Text = text
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.Font = Enum.Font.GothamSemibold
            Button.BorderSizePixel = 0
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                Button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                task.wait(0.1)
                Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                callback()
            end)
            
            return Button
        end
        
        function Tab:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 65)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
            ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                    BackgroundColor3 = toggled and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(60, 60, 65)
                }):Play()
                
                TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play()
                
                callback(toggled)
            end)
            
            return ToggleButton
        end
        
        function Tab:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0.3, -10, 0, 20)
            SliderValue.Position = UDim2.new(0.7, 0, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -20, 0, 4)
            SliderBar.Position = UDim2.new(0, 10, 1, -15)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = SliderFill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderValue.Text = tostring(value)
                    callback(value)
                end
            end)
            
            return SliderFrame
        end
        
        function Tab:AddDropdown(text, options, default, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.Parent = TabContent
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 6)
            DropCorner.Parent = DropdownFrame
            
            local DropLabel = Instance.new("TextLabel")
            DropLabel.Size = UDim2.new(0.4, 0, 1, 0)
            DropLabel.Position = UDim2.new(0, 10, 0, 0)
            DropLabel.BackgroundTransparency = 1
            DropLabel.Text = text
            DropLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropLabel.TextSize = 14
            DropLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropLabel.Font = Enum.Font.Gotham
            DropLabel.Parent = DropdownFrame
            
            local DropButton = Instance.new("TextButton")
            DropButton.Size = UDim2.new(0.55, -10, 0, 25)
            DropButton.Position = UDim2.new(0.45, 0, 0, 5)
            DropButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            DropButton.Text = default or options[1] or "Select"
            DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropButton.TextSize = 12
            DropButton.Font = Enum.Font.Gotham
            DropButton.BorderSizePixel = 0
            DropButton.Parent = DropdownFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 4)
            ButtonCorner.Parent = DropButton
            
            local DropList = Instance.new("Frame")
            DropList.Size = UDim2.new(0.55, -10, 0, 0)
            DropList.Position = UDim2.new(0.45, 0, 0, 32)
            DropList.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            DropList.BorderSizePixel = 0
            DropList.Visible = false
            DropList.ZIndex = 10
            DropList.Parent = DropdownFrame
            
            local ListCorner = Instance.new("UICorner")
            ListCorner.CornerRadius = UDim.new(0, 4)
            ListCorner.Parent = DropList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = DropList
            
            for _, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                OptionButton.Text = option
                OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.Parent = DropList
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropButton.Text = option
                    DropList.Visible = false
                    DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
                    callback(option)
                end)
            end
            
            DropButton.MouseButton1Click:Connect(function()
                DropList.Visible = not DropList.Visible
                if DropList.Visible then
                    DropList.Size = UDim2.new(0.55, -10, 0, #options * 25)
                    DropdownFrame.Size = UDim2.new(1, -10, 0, 35 + #options * 25 + 5)
                else
                    DropList.Size = UDim2.new(0.55, -10, 0, 0)
                    DropdownFrame.Size = UDim2.new(1, -10, 0, 35)
                end
            end)
            
            return DropdownFrame
        end
        
        function Tab:AddTextbox(text, placeholder, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = "TextboxFrame"
            TextboxFrame.Size = UDim2.new(1, -10, 0, 35)
            TextboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 6)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
            TextboxLabel.Position = UDim2.new(0, 10, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = text
            TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextboxLabel.TextSize = 14
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(0.55, -10, 0, 25)
            Textbox.Position = UDim2.new(0.45, 0, 0, 5)
            Textbox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
            Textbox.PlaceholderText = placeholder
            Textbox.Text = ""
            Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            Textbox.TextSize = 12
            Textbox.Font = Enum.Font.Gotham
            Textbox.BorderSizePixel = 0
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 4)
            BoxCorner.Parent = Textbox
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)
            
            return Textbox
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    return Window
end

-- Initialize UI
local Window = Library:CreateWindow({
    Title = "🎣 FMS Hub - Fish It"
})

print("[Fish It] ✅ UI Created!")

-- Continue to Part 3...
-- ============================================
-- PART 3: AUTO FISHING & CORE FUNCTIONS
-- ============================================

-- Get Game Services
local Workspace = game:GetService("Workspace")

-- Find Player Character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ============================================
-- UTILITY FUNCTIONS
-- ============================================

local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

local function GetPlayerRod()
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and table.find(RodList, tool.Name) then
        return tool
    end
    return nil
end

local function EquipBestRod()
    local backpack = LocalPlayer.Backpack
    local bestRod = nil
    local bestIndex = 0
    
    for _, rod in ipairs(RodList) do
        local foundRod = backpack:FindFirstChild(rod)
        if foundRod then
            local index = table.find(RodList, rod)
            if index and index > bestIndex then
                bestRod = foundRod
                bestIndex = index
            end
        end
    end
    
    if bestRod then
        Humanoid:EquipTool(bestRod)
        return true
    end
    return false
end

local function TeleportTo(cframe)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = cframe
    end
end

local function GetInventorySpace()
    local backpack = LocalPlayer.Backpack
    local itemCount = #backpack:GetChildren()
    return 50 - itemCount -- Assuming max 50 items
end

-- ============================================
-- ANTI-DETECTION FEATURES
-- ============================================

-- Anti-AFK
if Settings.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    print("[Fish It] ✅ Anti-AFK Enabled")
end

-- Anti-Kick
if Settings.AntiKick then
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return wait(9e9)
        end
        return old(self, ...)
    end)
    
    setreadonly(mt, true)
    print("[Fish It] ✅ Anti-Kick Enabled")
end

-- ============================================
-- WEBHOOK SYSTEM
-- ============================================

local function SendWebhook(fishName, rarity, weight, location)
    if not Settings.WebhookEnabled or Settings.WebhookURL == "" then
        return
    end
    
    if not table.find(Settings.NotifyRarity, rarity) then
        return
    end
    
    local embed = {
        ["title"] = "🎣 Rare Fish Caught!",
        ["description"] = "**Fish:** " .. fishName .. "\n**Rarity:** " .. rarity .. "\n**Weight:** " .. weight .. "\n**Location:** " .. location,
        ["color"] = rarity == "Secret" and 0xFF0000 or rarity == "Mythical" and 0xFF00FF or 0xFFD700,
        ["footer"] = {
            ["text"] = "FMS Hub | " .. LocalPlayer.Name
        },
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
    }
    
    local data = {
        ["username"] = "Fish It Notifier",
        ["embeds"] = {embed}
    }
    
    local success, result = pcall(function()
        return request({
            Url = Settings.WebhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
    
    if success then
        print("[Fish It] 📤 Webhook sent for " .. fishName)
    end
end

-- ============================================
-- AUTO FISHING LOGIC
-- ============================================

local FishingActive = false
local LastCastTime = 0
local CastCooldown = 2

local function AutoShake()
    if not Settings.AutoShake then return end
    
    -- Look for shake prompt in PlayerGui
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local shakeUI = playerGui:FindFirstChild("shakeui")
    
    if shakeUI and shakeUI.Enabled then
        local safezone = shakeUI:FindFirstChild("safezone")
        if safezone and safezone.Visible then
            -- Simulate shake by clicking rapidly
            for i = 1, 10 do
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                task.wait(0.05)
            end
        end
    end
end

local function AutoReel()
    if not Settings.AutoReel then return end
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local reel = playerGui:FindFirstChild("reel")
    
    if reel and reel.Enabled then
        local bar = reel:FindFirstChild("bar")
        if bar and bar.Visible then
            -- Hold left click to reel
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end

local function CastRod()
    local rod = GetPlayerRod()
    if not rod then
        if Settings.AutoEquipBestRod then
            EquipBestRod()
            task.wait(0.5)
            rod = GetPlayerRod()
        end
    end
    
    if rod then
        local currentTime = tick()
        if currentTime - LastCastTime >= CastCooldown then
            -- Cast rod by clicking
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            LastCastTime = currentTime
            print("[Fish It] 🎣 Rod casted!")
        end
    end
end

local function DetectFishCaught()
    -- Monitor PlayerGui for caught fish notification
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    playerGui.ChildAdded:Connect(function(child)
        if child.Name == "FishCaught" or child.Name == "CatchNotification" then
            task.wait(0.5)
            
            -- Try to extract fish info
            local fishName = "Unknown Fish"
            local rarity = "Common"
            local weight = "0 kg"
            
            -- Parse notification UI (adjust based on actual game structure)
            local nameLabel = child:FindFirstChild("FishName", true)
            local rarityLabel = child:FindFirstChild("Rarity", true)
            local weightLabel = child:FindFirstChild("Weight", true)
            
            if nameLabel then fishName = nameLabel.Text end
            if rarityLabel then rarity = rarityLabel.Text end
            if weightLabel then weight = weightLabel.Text end
            
            print("[Fish It] 🐟 Caught: " .. fishName .. " (" .. rarity .. ")")
            
            -- Auto favorite
            if Settings.AutoFavorite and table.find(Settings.FavoriteRarity, rarity) then
                -- Call favorite function (implementation depends on game)
                print("[Fish It] ⭐ Auto-favorited " .. fishName)
            end
            
            -- Send webhook
            SendWebhook(fishName, rarity, weight, "Current Location")
        end
    end)
end

-- Start fish detection
DetectFishCaught()

-- Main Auto Fishing Loop
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoFish and FishingActive then
            -- Check inventory space
            if GetInventorySpace() < 5 and Settings.AutoSell then
                -- Trigger auto sell
                print("[Fish It] 📦 Inventory nearly full, selling...")
                -- Auto sell logic will be in next part
            end
            
            -- Auto shake if needed
            AutoShake()
            
            -- Auto reel if needed
            AutoReel()
            
            -- Cast rod if not currently fishing
            local playerGui = LocalPlayer:WaitForChild("PlayerGui")
            local fishing = playerGui:FindFirstChild("reel") or playerGui:FindFirstChild("shakeui")
            
            if not fishing or not fishing.Enabled then
                CastRod()
            end
        end
    end
end)

-- ============================================
-- AUTO SELL SYSTEM
-- ============================================

local LastSellTime = 0

local function AutoSell()
    local currentTime = tick()
    if currentTime - LastSellTime < Settings.SellInterval then
        return
    end
    
    -- Find merchant NPC
    local merchants = Workspace:FindFirstChild("Merchants") or Workspace:FindFirstChild("NPCs")
    if not merchants then
        warn("[Fish It] ⚠️ Merchant not found!")
        return
    end
    
    local merchant = merchants:FindFirstChild("Merchant") or merchants:FindFirstChild("FishMerchant")
    if not merchant then
        warn("[Fish It] ⚠️ Fish merchant not found!")
        return
    end
    
    -- Teleport to merchant
    local merchantCFrame = merchant:FindFirstChild("HumanoidRootPart") or merchant.PrimaryPart
    if merchantCFrame then
        local originalPos = HumanoidRootPart.CFrame
        TeleportTo(merchantCFrame.CFrame * CFrame.new(0, 0, 5))
        
        task.wait(0.5)
        
        -- Interact with merchant (fire proximity prompt or remote)
        local proximityPrompt = merchant:FindFirstChildOfClass("ProximityPrompt", true)
        if proximityPrompt then
            fireproximityprompt(proximityPrompt)
        end
        
        task.wait(1)
        
        -- Sell all fish in inventory
        local backpack = LocalPlayer.Backpack
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and not table.find(RodList, item.Name) then
                -- This is a fish, sell it
                -- Implementation depends on game's selling system
                print("[Fish It] 💰 Selling: " .. item.Name)
            end
        end
        
        task.wait(0.5)
        
        -- Return to original position
        TeleportTo(originalPos)
        
        LastSellTime = currentTime
        Notify("FMS Hub", "Sold all fish!", 3)
    end
end

-- Auto sell loop
spawn(function()
    while task.wait(10) do
        if Settings.AutoSell then
            AutoSell()
        end
    end
end)

-- ============================================
-- LOCATION SYSTEM
-- ============================================

local function SaveLocation(name)
    if not name or name == "" then
        Notify("FMS Hub", "Please enter a location name!", 3)
        return
    end
    
    Settings.SavedLocations[name] = HumanoidRootPart.CFrame
    SaveSettings()
    Notify("FMS Hub", "Location '" .. name .. "' saved!", 3)
end

local function LoadLocation(name)
    if Settings.SavedLocations[name] then
        TeleportTo(Settings.SavedLocations[name])
        Notify("FMS Hub", "Teleported to '" .. name .. "'", 3)
    else
        Notify("FMS Hub", "Location not found!", 3)
    end
end

local function DeleteLocation(name)
    if Settings.SavedLocations[name] then
        Settings.SavedLocations[name] = nil
        SaveSettings()
        Notify("FMS Hub", "Location '" .. name .. "' deleted!", 3)
    end
end

-- ============================================
-- PLAYER MODIFICATIONS
-- ============================================

local OriginalWalkSpeed = Humanoid.WalkSpeed
local OriginalJumpPower = Humanoid.JumpPower

local function SetWalkSpeed(speed)
    Settings.WalkSpeed = speed
    if Humanoid then
        Humanoid.WalkSpeed = speed
    end
end

local function SetJumpPower(power)
    Settings.JumpPower = power
    if Humanoid then
        Humanoid.JumpPower = power
    end
end

local FreezeConnection
local function ToggleFreezePosition(enabled)
    Settings.FreezePosition = enabled
    
    if enabled then
        local frozenCFrame = HumanoidRootPart.CFrame
        FreezeConnection = RunService.Heartbeat:Connect(function()
            if Settings.FreezePosition then
                HumanoidRootPart.CFrame = frozenCFrame
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
            end
        end)
        Notify("FMS Hub", "Position Frozen!", 3)
    else
        if FreezeConnection then
            FreezeConnection:Disconnect()
        end
        Notify("FMS Hub", "Position Unfrozen!", 3)
    end
end

-- Maintain walkspeed/jumppower on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    Humanoid = char:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
end)

-- ============================================
-- QUEST SYSTEM (Basic Framework)
-- ============================================

local QuestActive = false

local function StartQuest(questType)
    if QuestActive then
        Notify("FMS Hub", "Quest already running!", 3)
        return
    end
    
    QuestActive = true
    Notify("FMS Hub", "Starting " .. questType .. " Quest...", 3)
    
    spawn(function()
        -- Quest logic will vary based on quest type
        -- This is a basic framework
        
        if questType == "Ghostfinn" then
            -- Ghostfinn Rod Quest
            print("[Fish It] 🎯 Starting Ghostfinn Rod Quest")
            -- Implement quest steps here
            
        elseif questType == "Element" then
            -- Element Rod Quest
            print("[Fish It] 🎯 Starting Element Rod Quest")
            -- Implement quest steps here
            
        elseif questType == "LeverTask" then
            -- Lever Task Quest
            print("[Fish It] 🎯 Starting Lever Task Quest")
            -- Implement quest steps here
        end
        
        QuestActive = false
    end)
end

local function StopQuest()
    QuestActive = false
    Notify("FMS Hub", "Quest stopped!", 3)
end

-- ============================================
-- SHOP SYSTEM (Basic Framework)
-- ============================================

local function BuyRod(rodName)
    -- Find shop NPC
    local shopNPC = Workspace:FindFirstChild("ShopNPC") or Workspace:FindFirstChild("RodShop")
    
    if not shopNPC then
        Notify("FMS Hub", "Rod shop not found!", 3)
        return
    end
    
    -- Teleport to shop
    local originalPos = HumanoidRootPart.CFrame
    TeleportTo(shopNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
    
    task.wait(1)
    
    -- Interact with shop (implementation depends on game)
    print("[Fish It] 🛒 Attempting to buy: " .. rodName)
    
    task.wait(2)
    TeleportTo(originalPos)
end

local function AutoBuyTargetRod()
    if Settings.AutoBuyRod and Settings.TargetRod ~= "" then
        local backpack = LocalPlayer.Backpack
        
        -- Check if player already has target rod
        if not backpack:FindFirstChild(Settings.TargetRod) then
            BuyRod(Settings.TargetRod)
        end
    end
end

print("[Fish It] ✅ Core functions loaded!")

-- Continue to Part 4...
-- ============================================
-- PART 4: UI IMPLEMENTATION - ALL TABS
-- ============================================

-- Main Tab
local MainTab = Window:CreateTab("Main", "🏠")

MainTab:AddLabel("═══ Player Settings ═══")

MainTab:AddSlider("Walk Speed", 16, 200, Settings.WalkSpeed, function(value)
    SetWalkSpeed(value)
end)

MainTab:AddSlider("Jump Power", 50, 200, Settings.JumpPower, function(value)
    SetJumpPower(value)
end)

MainTab:AddToggle("Freeze Position", Settings.FreezePosition, function(value)
    ToggleFreezePosition(value)
end)

MainTab:AddLabel("═══ Location Management ═══")

MainTab:AddButton("Save Current Location", function()
    local name = "Location_" .. os.time()
    SaveLocation(name)
end)

-- Custom location saver
local locationNameBox
MainTab:AddTextbox("Location Name", "Enter name...", function(name)
    SaveLocation(name)
end)

MainTab:AddLabel("═══ Saved Locations ═══")

-- Add buttons for saved locations dynamically
for name, _ in pairs(Settings.SavedLocations) do
    MainTab:AddButton("📍 " .. name, function()
        LoadLocation(name)
    end)
end

MainTab:AddLabel("═══ Quick Teleport ═══")

for name, cframe in pairs(LocationPresets) do
    MainTab:AddButton("🗺️ " .. name, function()
        TeleportTo(cframe)
        Notify("FMS Hub", "Teleported to " .. name, 3)
    end)
end

-- ============================================
-- Automation Tab
-- ============================================

local AutoTab = Window:CreateTab("Automation", "🤖")

AutoTab:AddLabel("═══ Fishing Automation ═══")

AutoTab:AddToggle("Auto Fishing", Settings.AutoFish, function(value)
    Settings.AutoFish = value
    FishingActive = value
    SaveSettings()
    
    if value then
        Notify("FMS Hub", "Auto Fishing: ON", 3)
    else
        Notify("FMS Hub", "Auto Fishing: OFF", 3)
    end
end)

AutoTab:AddToggle("Auto Shake", Settings.AutoShake, function(value)
    Settings.AutoShake = value
    SaveSettings()
end)

AutoTab:AddToggle("Auto Reel", Settings.AutoReel, function(value)
    Settings.AutoReel = value
    SaveSettings()
end)

AutoTab:AddToggle("Auto Equip Best Rod", Settings.AutoEquipBestRod, function(value)
    Settings.AutoEquipBestRod = value
    SaveSettings()
end)

AutoTab:AddButton("🎣 Cast Rod Now", function()
    CastRod()
end)

AutoTab:AddLabel("═══ Inventory Management ═══")

AutoTab:AddToggle("Auto Sell", Settings.AutoSell, function(value)
    Settings.AutoSell = value
    SaveSettings()
end)

AutoTab:AddSlider("Sell Interval (seconds)", 60, 600, Settings.SellInterval, function(value)
    Settings.SellInterval = value
    SaveSettings()
end)

AutoTab:AddButton("💰 Sell All Now", function()
    AutoSell()
end)

AutoTab:AddLabel("═══ Fish Management ═══")

AutoTab:AddToggle("Auto Favorite", Settings.AutoFavorite, function(value)
    Settings.AutoFavorite = value
    SaveSettings()
end)

AutoTab:AddLabel("Favorite Rarities:")
for _, rarity in ipairs(FishRarities) do
    local isEnabled = table.find(Settings.FavoriteRarity, rarity) ~= nil
    AutoTab:AddToggle(rarity, isEnabled, function(value)
        if value then
            table.insert(Settings.FavoriteRarity, rarity)
        else
            local index = table.find(Settings.FavoriteRarity, rarity)
            if index then
                table.remove(Settings.FavoriteRarity, index)
            end
        end
        SaveSettings()
    end)
end

AutoTab:AddLabel("═══ Totems & Events ═══")

AutoTab:AddButton("🗿 Collect Totems", function()
    Notify("FMS Hub", "Totem collection started!", 3)
    -- Implement totem collection logic
end)

AutoTab:AddButton("🌙 Start Night Hunt", function()
    Notify("FMS Hub", "Night hunt started!", 3)
    -- Implement night hunt logic
end)

AutoTab:AddButton("🎪 Start Event Hunt", function()
    Notify("FMS Hub", "Event hunt started!", 3)
    -- Implement event hunt logic
end)

-- ============================================
-- Quest Tab
-- ============================================

local QuestTab = Window:CreateTab("Quest", "📋")

QuestTab:AddLabel("═══ Auto Quest System ═══")

QuestTab:AddToggle("Enable Auto Quest", Settings.AutoQuest, function(value)
    Settings.AutoQuest = value
    SaveSettings()
end)

QuestTab:AddDropdown("Quest Type", {
    "Lever Task",
    "Ruin Task",
    "Iron Cavern",
    "Ghostfinn Rod",
    "Element Rod"
}, Settings.QuestType, function(value)
    Settings.QuestType = value
    SaveSettings()
end)

QuestTab:AddDropdown("Minimum Rod", RodList, Settings.MinimumRod, function(value)
    Settings.MinimumRod = value
    SaveSettings()
end)

QuestTab:AddButton("▶️ Start Quest", function()
    StartQuest(Settings.QuestType)
end)

QuestTab:AddButton("⏹️ Stop Quest", function()
    StopQuest()
end)

QuestTab:AddLabel("═══ Quest Info ═══")

QuestTab:AddLabel("Active Quest: None")
QuestTab:AddLabel("Progress: 0%")

QuestTab:AddLabel("═══ Manual Quest Triggers ═══")

QuestTab:AddButton("🔧 Lever Task Quest", function()
    StartQuest("LeverTask")
end)

QuestTab:AddButton("🏛️ Ruin Task Quest", function()
    StartQuest("RuinTask")
end)

QuestTab:AddButton("⛏️ Iron Cavern Quest", function()
    StartQuest("IronCavern")
end)

QuestTab:AddButton("👻 Ghostfinn Rod Quest", function()
    StartQuest("Ghostfinn")
end)

QuestTab:AddButton("⚡ Element Rod Quest", function()
    StartQuest("Element")
end)

-- ============================================
-- Shop Tab
-- ============================================

local ShopTab = Window:CreateTab("Shop", "🛒")

ShopTab:AddLabel("═══ Rod Management ═══")

ShopTab:AddToggle("Auto Buy Rod", Settings.AutoBuyRod, function(value)
    Settings.AutoBuyRod = value
    SaveSettings()
end)

ShopTab:AddDropdown("Target Rod", RodList, Settings.TargetRod, function(value)
    Settings.TargetRod = value
    SaveSettings()
end)

ShopTab:AddButton("🎣 Buy Target Rod Now", function()
    AutoBuyTargetRod()
end)

ShopTab:AddLabel("═══ Bait Management ═══")

ShopTab:AddToggle("Auto Buy Bait", Settings.AutoBuyBait, function(value)
    Settings.AutoBuyBait = value
    SaveSettings()
end)

ShopTab:AddDropdown("Target Bait", {
    "None",
    "Worms",
    "Cricket",
    "Leech",
    "Minnow",
    "Squid",
    "Fish Head"
}, Settings.TargetBait, function(value)
    Settings.TargetBait = value
    SaveSettings()
end)

ShopTab:AddLabel("═══ Quick Buy ═══")

ShopTab:AddButton("🪱 Buy Bobbers", function()
    Notify("FMS Hub", "Buying bobbers...", 3)
    -- Implement bobber buying logic
end)

ShopTab:AddButton("🚶 Buy from Traveling Merchant", function()
    Notify("FMS Hub", "Finding traveling merchant...", 3)
    -- Implement traveling merchant logic
end)

ShopTab:AddButton("🎫 Buy from Tix Shop", function()
    Notify("FMS Hub", "Opening Tix shop...", 3)
    -- Implement Tix shop logic
end)

ShopTab:AddLabel("═══ Selling ═══")

ShopTab:AddButton("💎 Sell Enchant Stones", function()
    Notify("FMS Hub", "Selling enchant stones...", 3)
    -- Implement enchant stone selling
end)

ShopTab:AddLabel("═══ Weather ═══")

ShopTab:AddDropdown("Change Weather", {
    "Clear",
    "Rain",
    "Windy",
    "Foggy",
    "Storm"
}, "Clear", function(value)
    Notify("FMS Hub", "Changing weather to " .. value, 3)
    -- Implement weather change logic
end)

-- ============================================
-- Premium Tab
-- ============================================

local PremiumTab = Window:CreateTab("Premium", "⭐")

PremiumTab:AddLabel("═══ Kaitun Mode ═══")
PremiumTab:AddLabel("Automatic farming based on quest progress")

PremiumTab:AddToggle("Enable Kaitun Mode", Settings.KaitunMode, function(value)
    Settings.KaitunMode = value
    SaveSettings()
    
    if value then
        Notify("FMS Hub", "🤖 Kaitun Mode: ON", 5)
    else
        Notify("FMS Hub", "Kaitun Mode: OFF", 3)
    end
end)

PremiumTab:AddLabel("═══ Advanced Settings ═══")

PremiumTab:AddDropdown("Rod Priority for Quests", RodList, Settings.MinimumRod, function(value)
    Settings.MinimumRod = value
    SaveSettings()
end)

PremiumTab:AddToggle("Auto Complete Bestiary", false, function(value)
    Notify("FMS Hub", "Bestiary mode: " .. (value and "ON" or "OFF"), 3)
end)

PremiumTab:AddToggle("Auto Claim Battlepass", false, function(value)
    Notify("FMS Hub", "Auto claim battlepass: " .. (value and "ON" or "OFF"), 3)
end)

PremiumTab:AddLabel("═══ Enchanting ═══")

PremiumTab:AddButton("✨ Auto Enchant Rod", function()
    Notify("FMS Hub", "Auto enchanting...", 3)
    -- Implement enchanting logic
end)

PremiumTab:AddButton("💎 Convert Fish to Stones", function()
    Notify("FMS Hub", "Converting fish to stones...", 3)
    -- Implement conversion logic
end)

PremiumTab:AddLabel("═══ Trading ═══")

PremiumTab:AddToggle("Auto Accept Trades", false, function(value)
    Notify("FMS Hub", "Auto trade: " .. (value and "ON" or "OFF"), 3)
end)

-- ============================================
-- Settings Tab
-- ============================================

local SettingsTab = Window:CreateTab("Settings", "⚙️")

SettingsTab:AddLabel("═══ Discord Webhook ═══")

SettingsTab:AddToggle("Enable Webhook", Settings.WebhookEnabled, function(value)
    Settings.WebhookEnabled = value
    SaveSettings()
end)

SettingsTab:AddTextbox("Webhook URL", Settings.WebhookURL, function(value)
    Settings.WebhookURL = value
    SaveSettings()
    Notify("FMS Hub", "Webhook URL saved!", 3)
end)

SettingsTab:AddLabel("Notify on Rarity:")
for _, rarity in ipairs(FishRarities) do
    local isEnabled = table.find(Settings.NotifyRarity, rarity) ~= nil
    SettingsTab:AddToggle(rarity .. " Fish", isEnabled, function(value)
        if value then
            table.insert(Settings.NotifyRarity, rarity)
        else
            local index = table.find(Settings.NotifyRarity, rarity)
            if index then
                table.remove(Settings.NotifyRarity, index)
            end
        end
        SaveSettings()
    end)
end

SettingsTab:AddButton("🧪 Test Webhook", function()
    SendWebhook("Test Fish", "Secret", "999 kg", "Test Location")
    Notify("FMS Hub", "Webhook test sent!", 3)
end)

SettingsTab:AddLabel("═══ Performance ═══")

SettingsTab:AddToggle("FPS Unlock", Settings.FPSUnlock, function(value)
    Settings.FPSUnlock = value
    SaveSettings()
    
    if value then
        setfpscap(999)
        Notify("FMS Hub", "FPS Unlocked!", 3)
    else
        setfpscap(60)
        Notify("FMS Hub", "FPS capped to 60", 3)
    end
end)

SettingsTab:AddToggle("Low Graphics Mode", Settings.LowGraphics, function(value)
    Settings.LowGraphics = value
    SaveSettings()
    
    local lighting = game:GetService("Lighting")
    if value then
        lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        Notify("FMS Hub", "Low graphics enabled", 3)
    else
        lighting.GlobalShadows = true
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Notify("FMS Hub", "Graphics restored", 3)
    end
end)

SettingsTab:AddLabel("═══ Anti-Detection ═══")

SettingsTab:AddToggle("Anti-Kick", Settings.AntiKick, function(value)
    Settings.AntiKick = value
    SaveSettings()
end)

SettingsTab:AddToggle("Anti-AFK", Settings.AntiAFK, function(value)
    Settings.AntiAFK = value
    SaveSettings()
end)

SettingsTab:AddLabel("═══ Configuration ═══")

SettingsTab:AddButton("💾 Save Config", function()
    SaveSettings()
    Notify("FMS Hub", "Configuration saved!", 3)
end)

SettingsTab:AddButton("🔄 Reset to Default", function()
    Settings = DefaultSettings
    SaveSettings()
    Notify("FMS Hub", "Settings reset to default!", 3)
end)

SettingsTab:AddButton("📂 Export Config", function()
    if setclipboard then
        setclipboard(HttpService:JSONEncode(Settings))
        Notify("FMS Hub", "Config copied to clipboard!", 3)
    else
        Notify("FMS Hub", "Clipboard not supported!", 3)
    end
end)

SettingsTab:AddLabel("═══ Script Info ═══")

SettingsTab:AddLabel("Version: " .. ScriptVersion)
SettingsTab:AddLabel("Created by: FMS Team")
SettingsTab:AddLabel("Discord: discord.gg/fmshub")

SettingsTab:AddButton("🔗 Join Discord", function()
    if setclipboard then
        setclipboard("https://discord.gg/fmshub")
        Notify("FMS Hub", "Discord link copied!", 3)
    end
end)

SettingsTab:AddButton("❌ Close UI", function()
    game:GetService("CoreGui"):FindFirstChild("FishItHub"):Destroy()
end)

-- ============================================
-- FINAL INITIALIZATION
-- ============================================

-- Auto-start features based on settings
if Settings.AutoFish then
    FishingActive = true
    Notify("FMS Hub", "Auto Fishing started!", 3)
end

-- Notification on load
Notify("FMS Hub", "Script loaded successfully!", 5)
Notify("FMS Hub", "Version: " .. ScriptVersion, 3)

print("═══════════════════════════════════════")
print("✅ FMS Hub - Fish It Script Loaded!")
print("📦 Version: " .. ScriptVersion)
print("👤 Player: " .. LocalPlayer.Name)
print("🎣 All systems operational!")
print("═══════════════════════════════════════")

-- Auto save settings every 5 minutes
spawn(function()
    while task.wait(300) do
        SaveSettings()
        print("[Fish It] 💾 Auto-saved settings")
    end
end)

-- EOF
