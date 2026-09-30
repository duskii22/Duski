local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CommF_ = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")

local API_URL = "https://duskikaitun-default-rtdb.firebaseio.com/"

-- Gather full inventory for the dashboard
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

-- Universal Sync Loop
task.spawn(function()
    while task.wait(2) do
        pcall(function()
            -- 1. Push Telemetry & Current Settings TO Firebase
            local payload = {
                Level = Player.Data and Player.Data:FindFirstChild("Level") and Player.Data.Level.Value or 1,
                Race = Player.Data and Player.Data:FindFirstChild("Race") and Player.Data.Race.Value or "Human",
                Inventory = getInventoryData(),
                Settings = SpeedHubX -- Automatically grabs all 700 lines of toggles/settings!
            }

            request({
                Url = API_URL .. "KaitunData.json",
                Method = "PUT",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })

            -- 2. Pull Updated Settings FROM Firebase (Remote Control)
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
