local TaskManager = {}
TaskManager.__index = TaskManager

function TaskManager.new()
    return setmetatable({
        Active = {},
    }, TaskManager)
end

function TaskManager:Schedule(name, callback, interval)
    if type(callback) ~= "function" then
        return false
    end
    if self.Active[name] then
        return false
    end

    local taskToken = {
        Name = name,
        Callback = callback,
        Interval = interval or 0,
        Running = true,
        Thread = nil,
    }

    taskToken.Thread = task.spawn(function()
        while taskToken.Running do
            local ok, err = xpcall(callback, debug.traceback)
            if not ok then
                warn("[BapruHub] Task error (" .. tostring(name) .. "): " .. tostring(err))
            end

            if taskToken.Interval > 0 then
                task.wait(taskToken.Interval)
            else
                break
            end
        end
        self.Active[name] = nil
    end)

    self.Active[name] = taskToken
    return true
end

function TaskManager:Cancel(name)
    local taskToken = self.Active[name]
    if not taskToken then
        return false
    end

    taskToken.Running = false
    if taskToken.Thread then
        task.defer(function()
            if taskToken.Thread and coroutine.status(taskToken.Thread) ~= "dead" then
                task.cancel(taskToken.Thread)
            end
        end)
    end
    self.Active[name] = nil
    return true
end

return TaskManager
