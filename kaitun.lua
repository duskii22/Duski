-- Visual startup confirmation
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Duski Kaitun",
    Text = "Connected to Firebase & Running!",
    Duration = 5
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local CommF_ = Remotes:WaitForChild("CommF_", 9e9)

-- Your Firebase Database URL
local API_URL = "https://duskikaitun-default-rtdb.firebaseio.com/"

-- Local Settings table
local KaitunSettings = {
    AutoFarmLevel = true,
    AutoStoreFruit = false,
    AutoHaki = true
}

-- Function to send player data to Firebase root for your Dashboard
local function sendTelemetry()
    pcall(function()
        local levelVal = 1
        local raceVal = "Human"
        
        -- Safely fetch Blox Fruits player data paths
        if Player:FindFirstChild("Data") then
            if Player.Data:FindFirstChild("Level") then
                levelVal = Player.Data.Level.Value
            end
            if Player.Data:FindFirstChild("Race") then
                raceVal = Player.Data.Race.Value
            end
        end

        local data = {
            Level = levelVal,
            Race = raceVal,
            Status = "Running",
            Settings = KaitunSettings
        }
        
        -- Push data directly to the root .json endpoint
        request({
            Url = API_URL .. ".json",
            Method = "PUT",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Main Execution & Telemetry Loop
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            -- Sync data to cloud dashboard every 3 seconds
            sendTelemetry()

            -- Auto Haki Logic
            if KaitunSettings.AutoHaki then
                local character = Player.Character
                if character and not character:FindFirstChild("HasBuso") then
                    if CommF_ then
                        CommF_:InvokeServer("Buso")
                    end
                end
            end
        end)
    end
end)
