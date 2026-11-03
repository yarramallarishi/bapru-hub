local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler

function ErrorHandler.new()
    return setmetatable({
        LogPrefix = "[BapruHub]",
    }, ErrorHandler)
end

function ErrorHandler:Report(message, context)
    local label = context and (" [" .. tostring(context) .. "]") or ""
    warn(self.LogPrefix .. " " .. tostring(message) .. label)
end

function ErrorHandler:Wrap(callback, context)
    local ok, result = xpcall(callback, debug.traceback)
    if not ok then
        self:Report(result, context)
        return false, result
    end
    return true, result
end

return ErrorHandler
