-- Place this LocalScript in StarterPlayerScripts.
-- Expected hierarchy:
-- ReplicatedStorage
--   BapruHub
--     BapruHub (ModuleScript)
--     Config (ModuleScript)
--     FeatureCatalog (ModuleScript)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local modules = ReplicatedStorage:WaitForChild("BapruHub")
local Config = require(modules:WaitForChild("Config"))
local Catalog = require(modules:WaitForChild("FeatureCatalog"))
local BapruHub = require(modules:WaitForChild("BapruHub"))

local ok, result = pcall(function()
    return BapruHub.new(Config, Catalog)
end)

if not ok then
    warn("[BapruHub] Failed to initialize: " .. tostring(result))
end
