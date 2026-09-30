-- ==========================================
-- SPEED HUB X - FIXED WEB-SYNC & FARM SCRIPT
-- ==========================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local httpRequest = (syn and syn.request) or (http and http.request) or http_request or request
if not httpRequest then return end

local API_URL = "https://duskikaitun-default-rtdb.firebaseio.com/"

-- Shared configuration state
getgenv().SpeedHubX = getgenv().SpeedHubX or {
    ["Auto Farm Level"] = false,
    ["Fast Attack"] = false
}

local function getInventoryData()
    local inventory = { Swords = {}, Fruits = {} }
    pcall(function()
        local inv = CommF_:InvokeServer("getInventory")
        if type(inv) == "table" then
            for _, item in pairs(inv) do
                if item.Type == "Sword" then table.insert(inventory.Swords, item.Name)
                elseif item.Type == "Blox Fruit" or item.Type == "Fruit" then table.insert(inventory.Fruits, item.Name) end
            end
        end
    end)
    return inventory
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Speed Hub X",
    Text = "Kaitun Bridge Loaded!",
    Duration = 3
})

-- ==========================================
-- 1. CLEAN SYNC LOOP (Pulls from website, pushes telemetry only)
-- ==========================================
task.spawn(function()
    while task.wait(1.5) do
        pcall(function()
            -- Only push character data (Level, Race, Inventory), DO NOT push settings to avoid resetting website
            local telemetry = {
                Level = Player.Data and Player.Data:FindFirstChild("Level") and Player.Data.Level.Value or 1,
                Race = Player.Data and Player.Data:FindFirstChild("Race") and Player.Data.Race.Value or "Human",
                Inventory = getInventoryData()
            }
            httpRequest({
                Url = API_URL .. "KaitunData/Telemetry.json",
                Method = "PUT",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(telemetry)
            })

            -- Pull settings strictly from website
            local res = httpRequest({
                Url = API_URL .. "KaitunData/Settings.json",
                Method = "GET"
            })
            if res and res.Body and res.Body ~= "null" then
                local cloudSettings = HttpService:JSONDecode(res.Body)
                if type(cloudSettings) == "table" then
                    for k, v in pairs(cloudSettings) do
                        SpeedHubX[k] = v
                    end
                end
            end
        end)
    end
end)

-- ==========================================
-- 2. ROBUST FARM & ATTACK LOOPS
-- ==========================================
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if SpeedHubX["Auto Farm Level"] then
                local char = Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                
                if hrp and enemiesFolder then
                    for _, enemy in pairs(enemiesFolder:GetChildren()) do
                        local eHRP = enemy:FindFirstChild("HumanoidRootPart")
                        local eHum = enemy:FindFirstChild("Humanoid")
                        if eHRP and eHum and eHum.Health > 0 then
                            -- Teleport slightly above/behind enemy and bring character
                            hrp.CFrame = eHRP.CFrame * CFrame.new(0, 30, 3)
                            
                            -- Equip current tool and click
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then
                                tool:Activate()
                            end
                            break
                        end
                    end
                end
            end
        end)
    end
end)

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if SpeedHubX["Fast Attack"] then
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
end)
