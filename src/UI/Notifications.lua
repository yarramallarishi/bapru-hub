local function requireComponent(moduleName)
    local root = script.Parent
    if root and root:FindFirstChild(moduleName) then
        return require(root:WaitForChild(moduleName))
    end

    local parent = root and root.Parent
    if parent and parent:FindFirstChild(moduleName) then
        return require(parent:WaitForChild(moduleName))
    end

    error("Missing required component module: " .. tostring(moduleName))
end

local Components = requireComponent("Components")

local Notifications = {}
Notifications.__index = Notifications

function Notifications.new(holder, theme)
    local self = setmetatable({
        Holder = holder,
        Theme = theme,
    }, Notifications)
    return self
end

function Notifications:Notify(title, message, kind, seconds)
    if not self.Holder then
        return
    end

    local accent = kind == "success" and self.Theme.Success or (kind == "error" and self.Theme.Error or self.Theme.Accent)
    local toast = Components.make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 330, 0, 12),
        Size = UDim2.fromOffset(292, 72),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
    }, self.Holder)
    Components.round(toast, 11)
    Components.outline(toast, self.Theme.Border)

    Components.make("Frame", {
        Size = UDim2.new(0, 4, 1, -18),
        Position = UDim2.fromOffset(0, 9),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
    }, toast)

    local titleText = Components.textLabel(toast, title or "Bapru Hub", 13, self.Theme.Text, Enum.Font.GothamBold)
    titleText.Position = UDim2.fromOffset(15, 9)
    titleText.Size = UDim2.new(1, -25, 0, 20)

    local body = Components.textLabel(toast, message or "", 11, self.Theme.Muted)
    body.Position = UDim2.fromOffset(15, 31)
    body.Size = UDim2.new(1, -25, 0, 30)
    body.TextWrapped = true

    Components.animate(toast, 0.25, { Position = UDim2.new(1, -12, 0, 12) })
    task.delay(seconds or 3, function()
        if toast.Parent then
            Components.animate(toast, 0.2, { Position = UDim2.new(1, 330, 0, 12) })
            task.wait(0.22)
            if toast.Parent then
                toast:Destroy()
            end
        end
    end)
end

return Notifications
