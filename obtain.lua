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
