-- Fish It Script Loader
-- Version: 1.0.0
-- Repository: https://github.com/MelodySsy/FMS
-- Created for: Volcano & Delta Executor

local SCRIPT_VERSION = "1.0.0"
local GITHUB_REPO = "MelodySsy/FMS"
local MAIN_SCRIPT_URL = "https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/main/main.lua"

-- Anti-detection
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Check for updates
local function checkVersion()
    local success, latestVersion = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/" .. GITHUB_REPO .. "/main/version.txt")
    end)
    
    if success and latestVersion then
        latestVersion = latestVersion:gsub("%s+", "") -- Remove whitespace
        if latestVersion ~= SCRIPT_VERSION then
            warn("[Fish It] ⚠️ New version available: " .. latestVersion)
            warn("[Fish It] 📦 Current version: " .. SCRIPT_VERSION)
            warn("[Fish It] 🔄 Please update to get the latest features!")
        else
            print("[Fish It] ✅ You are using the latest version!")
        end
    end
end

-- Game validation
local FISH_IT_PLACE_ID = 121864768012064

local function isValidGame()
    return game.PlaceId == FISH_IT_PLACE_ID
end

-- Main loader
print("═══════════════════════════════════════")
print("🎣 Fish It Script - Loading...")
print("📦 Version: " .. SCRIPT_VERSION)
print("═══════════════════════════════════════")

if not isValidGame() then
    warn("[Fish It] ❌ This script only works in Fish It!")
    warn("[Fish It] 🔗 Join: https://www.roblox.com/games/16732694052")
    return
end

-- Check version
checkVersion()

-- Load main script
local success, result = pcall(function()
    return game:HttpGet(MAIN_SCRIPT_URL)
end)

if success then
    print("[Fish It] ✅ Script loaded successfully!")
    print("═══════════════════════════════════════")
    
    local executeSuccess, executeError = pcall(function()
        loadstring(result)()
    end)
    
    if not executeSuccess then
        warn("[Fish It] ❌ Failed to execute script!")
        warn("[Fish It] Error: " .. tostring(executeError))
    end
else
    warn("[Fish It] ❌ Failed to load script from GitHub!")
    warn("[Fish It] Error: " .. tostring(result))
    warn("[Fish It] Please check your internet connection or try again later.")
end
