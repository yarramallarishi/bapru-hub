local StateManager = {}
StateManager.__index = StateManager

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, item in pairs(value) do
        copy[key] = deepCopy(item)
    end
    return copy
end

function StateManager.new(defaults)
    local self = setmetatable({
        Values = deepCopy(defaults or {}),
        Listeners = {},
    }, StateManager)
    return self
end

function StateManager:Bootstrap(catalog)
    for _, category in ipairs(catalog or {}) do
        for _, item in ipairs(category.Items or {}) do
            if self.Values[item.Id] == nil then
                self.Values[item.Id] = item.Default
            end
        end
    end
    return self.Values
end

function StateManager:Set(id, value)
    self.Values[id] = value
    for _, listener in ipairs(self.Listeners) do
        listener(id, value)
    end
end

function StateManager:Get(id, defaultValue)
    if self.Values[id] == nil then
        return defaultValue
    end
    return self.Values[id]
end

function StateManager:Bind(id, callback)
    table.insert(self.Listeners, function(changedId, value)
        if changedId == id then
            callback(value)
        end
    end)
end

return StateManager
