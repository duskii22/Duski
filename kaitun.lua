-- ==========================================
-- SPEED HUB X - GITHUB KAITUN BRIDGE & LOOPS
-- ==========================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- Your Firebase Realtime Database URL
local API_URL = "https://duskikaitun-default-rtdb.firebaseio.com/"

-- Initialize the SpeedHubX configuration table if it doesn't exist
getgenv().SpeedHubX = getgenv().SpeedHubX or {
    ["Auto Farm Level"] = false,
    ["Auto Farm Neareast"] = false,
    ["Auto Farm Mastery"] = false,
    ["Bring Mob"] = false,
    ["Fast Attack"] = false,
    ["Auto Second World"] = false,
    ["Auto Third World"] = false,
    ["Auto Farm Bones"] = false,
    ["Auto Elite Hunter"] = false,
    ["Auto Collect Azure Ember"] = false,
    ["Auto Drive Boat To Sea"] = false,
    ["Auto Find Leviathan"] = false,
    ["Auto Attack Boss"] = false,
    ["Auto Store Fruit"] = false,
    ["Auto Random Fruit"] = false,
    ["Auto Buy Legendary Sword"] = false
}

-- Gather full inventory data (Swords & Fruits)
local function getInventoryData()
    local inventory = { Swords = {}, Fruits = {} }
    pcall(function()
        local inv = CommF_:InvokeServer("getInventory")
        if type(inv) == "table" then
            for _, item in pairs(inv) do
                if item.Type == "Sword" then 
                    table.insert(inventory.Swords, item.Name)
                elseif item.Type == "Blox Fruit" or item.Type == "Fruit" then 
                    table.insert(inventory.Fruits, item.Name) 
                end
            end
        end
    end)
    return inventory
end

-- ==========================================
-- 1. CLOUD SYNC BRIDGE (Push Status / Pull Toggles)
-- ==========================================
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            -- Push Player Telemetry & Settings TO Firebase
            local payload = {
                Level = Player.Data and Player.Data:FindFirstChild("Level") and Player.Data.Level.Value or 1,
                Race = Player.Data and Player.Data:FindFirstChild("Race") and Player.Data.Race.Value or "Human",
                Inventory = getInventoryData(),
                Settings = SpeedHubX
            }

            request({
                Url = API_URL .. "KaitunData.json",
                Method = "PUT",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })

            -- Pull Updated Settings FROM Firebase (Web Control)
            local res = request({
                Url = API_URL .. "KaitunData/Settings.json",
                Method = "GET"
            })
            if res and res.Body then
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
-- 2. ACTIVE IN-GAME EXECUTION LOOPS
-- ==========================================

-- Auto Farm Level Execution Loop
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if SpeedHubX["Auto Farm Level"] then
                local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if hrp and workspace:FindFirstChild("Enemies") then
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        local enemyHRP = enemy:FindFirstChild("HumanoidRootPart")
                        local enemyHumanoid = enemy:FindFirstChild("Humanoid")
                        if enemyHRP and enemyHumanoid and enemyHumanoid.Health > 0 then
                            if (enemyHRP.Position - hrp.Position).Magnitude < 400 then
                                hrp.CFrame = enemyHRP.CFrame * CFrame.new(0, 5, 3)
                                local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- Fast Attack Execution Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if SpeedHubX["Fast Attack"] then
                local vu = game:GetService("VirtualUser")
                vu:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end
        end)
    end
end)

print("GitHub Kaitun Bridge & Execution Loops Loaded Successfully!")
