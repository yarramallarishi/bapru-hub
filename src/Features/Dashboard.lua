local function requireComponent(moduleName)
    local root = script.Parent and script.Parent.Parent
    if root and root:FindFirstChild("UI") and root.UI:FindFirstChild(moduleName) then
        return require(root.UI:WaitForChild(moduleName))
    end
    if root and root:FindFirstChild(moduleName) then
        return require(root:WaitForChild(moduleName))
    end
    error("Missing required component module: " .. tostring(moduleName))
end

local Components = requireComponent("Components")

local Dashboard = {}
Dashboard.__index = Dashboard

function Dashboard.new(parent, theme, state)
    local self = setmetatable({
        Parent = parent,
        Theme = theme,
        State = state,
    }, Dashboard)
    self:Build()
    return self
end

function Dashboard:Build()
    local panel = Components.make("Frame", {
        Name = "DashboardPanel",
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
    }, self.Parent)
    Components.round(panel, 12)

    local header = Components.textLabel(panel, "Session overview", 13, self.Theme.Text, Enum.Font.GothamBold)
    header.Position = UDim2.fromOffset(14, 12)
    header.Size = UDim2.new(1, -28, 0, 18)

    local status = Components.textLabel(panel, "Status: " .. tostring(self.State:Get("session_status", "Ready")), 11, self.Theme.Muted)
    status.Position = UDim2.fromOffset(14, 40)
    status.Size = UDim2.new(1, -28, 0, 16)

    self.Panel = panel
    self.Status = status
end

return Dashboard
