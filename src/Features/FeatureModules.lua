local FeatureModules = {}

function FeatureModules.GetReferenceCatalog()
    return {
        "Auto Dragon Talon",
        "Auto Godhuman",
        "Auto Store Fruits",
        "Auto Equip Best Gear",
        "Auto Join Crew",
        "Auto Server Boost",
        "Auto Elite Pirates",
        "Auto Cursed Dual Katana",
        "Auto Sharkman Karate",
        "Auto Dark Step",
        "Auto Buy Boats",
        "Auto Spin Fruit",
        "Auto Detect Rare Spawns",
        "Auto Optimize Inventory",
        "Auto Trade Optimizer",
        "Auto Mirage Puzzles",
        "Auto Sea Beast",
    }
end

function FeatureModules.BindDisplayState(item, stateManager)
    if not item then
        return nil
    end

    stateManager:Bootstrap({
        {
            Name = item.Name,
            Items = { item },
        },
    })

    return stateManager:Get(item.Id, item.Default)
end

return FeatureModules
