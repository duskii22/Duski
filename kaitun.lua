local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

-- REPLACE WITH YOUR ACTUAL FIREBASE OR BACKEND API URL
local API_URL = "https://your-database-endpoint.com/settings" 

-- Default settings if cloud is unreachable
local KaitunSettings = {
    AutoFarmLevel = false,
    AutoStoreFruit = false,
    AutoEliteHunter = false,
    AutoHaki = true
}

-- 1. Fetch settings from your web dashboard database
local function fetchCloudSettings()
    local success, response = pcall(function()
        return request({
            Url = API_URL .. "/get",
            Method = "GET"
        })
    end)
    if success and response and response.Body then
        local decoded = HttpService:JSONDecode(response.Body)
        if decoded then
            KaitunSettings = decoded -- Updates your script switches instantly from the web
        end
    end
end

-- 2. Send status, level, race, and inventory to your dashboard
local function sendTelemetry()
    local leaderstats = Player:FindFirstChild("leaderstats")
    local level = leaderstats and leaderstats:FindFirstChild("Level") and leaderstats.Level.Value or 0
    
    local inventory = {}
    local success, invResult = pcall(function() return CommF_:InvokeServer("getInventory") end)
    if success and type(invResult) == "table" then
        for _, item in pairs(invResult) do
            table.insert(inventory, {Name = item.Name, Type = item.Type, Count = item.Count or 1})
        end
    end

    local race = "Unknown"
    local dataFolder = Player:FindFirstChild("Data")
    if dataFolder and dataFolder:FindFirstChild("Race") then
        race = dataFolder.Race.Value
    end

    local payload = HttpService:JSONEncode({
        Username = Player.Name,
        Level = level,
        Race = race,
        Inventory = inventory,
        CurrentSettings = KaitunSettings,
        Timestamp = os.time()
    })

    pcall(function()
        request({
            Url = API_URL .. "/update",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)
end

-- Sync loop: Syncs settings and sends data every 5 seconds
task.spawn(function()
    while task.wait(5) do
        fetchCloudSettings()
        sendTelemetry()
    end
end)

-- 3. The Execution Engine (Reads your web toggles live)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            -- If you turn on "AutoFarmLevel" from your phone website, this code runs!
            if KaitunSettings.AutoFarmLevel then
                -- Place your automated quest & leveling logic here
                print("Kaitun: Auto Farm Level is active from web dashboard.")
            end

            -- If you turn on "AutoStoreFruit" from your website, this runs!
            if KaitunSettings.AutoStoreFruit then
                CommF_--:InvokeServer("StoreFruit", "1") -- Example fruit store trigger
            end

            if KaitunSettings.AutoHaki then
                -- Keep Haki active
                local character = Player.Character
                if character and not character:FindFirstChild("HasBuso") then
                    CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)
