-- Visual startup confirmation
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Duski Kaitun",
    Text = "Script successfully executed!",
    Duration = 5
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

-- Default settings (running locally since backend isn't connected yet)
local KaitunSettings = {
    AutoFarmLevel = true,  -- Set to true to test your loop
    AutoStoreFruit = false,
    AutoEliteHunter = false,
    AutoHaki = true
}

-- The Execution Engine (Runs your automation loops)
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if KaitunSettings.AutoFarmLevel then
                print("Kaitun: Auto Farm Level is active.")
            end

            if KaitunSettings.AutoHaki then
                local character = Player.Character
                if character and not character:FindFirstChild("HasBuso") then
                    CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)
