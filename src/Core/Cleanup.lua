local Cleanup = {}
Cleanup.__index = Cleanup

function Cleanup.new()
    return setmetatable({
        Handlers = {},
    }, Cleanup)
end

function Cleanup:Register(handler)
    if type(handler) ~= "function" then
        return false
    end
    table.insert(self.Handlers, handler)
    return true
end

function Cleanup:Run()
    for index = #self.Handlers, 1, -1 do
        local handler = self.Handlers[index]
        if type(handler) == "function" then
            local ok, err = pcall(handler)
            if not ok then
                warn("[BapruHub] Cleanup error: " .. tostring(err))
            end
        end
        self.Handlers[index] = nil
    end
end

return Cleanup
