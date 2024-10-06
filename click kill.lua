local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local originalColors = {}
local healingActive = false

-- Function to change a player's color to red
local function highlightPlayer(player)
    if player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                originalColors[part] = part.Color
                part.Color = Color3.new(1, 0, 0) -- Red
            end
        end
    end
end

-- Function to reset a player's color to original
local function resetPlayerColor(player)
    if player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and originalColors[part] then
                part.Color = originalColors[part]
                originalColors[part] = nil
            end
        end
    end
end

-- Function to kill ahhh
local function healPlayer(player)
    if player then
        local args = {
            [1] = "HEAL_PLAYER",
            [2] = player,
            [3] = -10000000000
        }
        ReplicatedStorage.NetworkEvents.RemoteFunction:InvokeServer(unpack(args))
    end
end

-- Function to handle continuous healing
local function handleContinuousHealing()
    while healingActive do
        local target = Mouse.Target
        if target and target.Parent and Players:FindFirstChild(target.Parent.Name) then
            local playerToHeal = Players[target.Parent.Name]
            healPlayer(playerToHeal)
        end
        RunService.RenderStepped:Wait() -- Ensure the game remains responsive
    end
end

-- Function to handle mouse events
local function handleMouseEvents()
    Mouse.Move:Connect(function()
        local target = Mouse.Target
        if target and target.Parent and Players:FindFirstChild(target.Parent.Name) then
            local hoveredPlayer = Players[target.Parent.Name]
            highlightPlayer(hoveredPlayer)
        else
            if hoveredPlayer then
                resetPlayerColor(hoveredPlayer)
            end
        end
    end)

    Mouse.Button1Down:Connect(function()
        healingActive = true
        handleContinuousHealing()
    end)

    Mouse.Button1Up:Connect(function()
        healingActive = false
    end)
end

-- Start handling mouse events
handleMouseEvents()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local backpack = localPlayer.Backpack -- Added for clarity and reuse

-- List of item names to clone into the Backpack
local itemsToClone = {"Gun", "RPG", "Squirter"}

for _, itemName in ipairs(itemsToClone) do
    -- Attempt to find each item in ReplicatedStorage
    local itemTemplate = ReplicatedStorage.Assets:FindFirstChild(itemName)
    
    if itemTemplate then
        -- Clone the item and move it to the player's Backpack
        local itemClone = itemTemplate:Clone()
        itemClone.Parent = backpack
    else
        -- Warn if the item wasn't found in ReplicatedStorage
        warn(itemName .. " not found in ReplicatedStorage.")
    end
end
