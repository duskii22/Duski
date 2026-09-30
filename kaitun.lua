-- Visual startup confirmation
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Duski Kaitun",
    Text = "Connected to Firebase!",
    Duration = 5
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

-- Your actual Firebase Database URL
local API_URL = "https://duskikaitun-default-rtdb.firebaseio.com/"

-- Local Settings table
local KaitunSettings = {
    AutoFarmLevel = true,
    AutoStoreFruit = false,
    AutoHaki = true
}

-- Function to send player data to Firebase for your Dashboard
local function sendTelemetry()
    pcall(function()
        local data = {
            Level = Player.Data.Level.Value or 1,
            Race = Player.Data.Race.Value or "Human",
            Settings = KaitunSettings,
            Status = "Running"
        }
        
        -- Send data to Firebase root endpoint as JSON
        request({
            Url = API_URL .. "status.json",
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

            -- Auto Farm Level Logic Placeholder
            if KaitunSettings.AutoFarmLevel then
                -- Add your core farming handler here
            end

            -- Auto Haki Logic
            if KaitunSettings.AutoHaki then
                local character = Player.Character
                if character and not character:FindFirstChild("HasBuso") then
                    CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)
