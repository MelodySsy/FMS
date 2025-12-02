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
