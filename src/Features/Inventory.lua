local Inventory = {}
Inventory.__index = Inventory

function Inventory.new(theme, parent)
    local self = setmetatable({
        Theme = theme,
        Parent = parent,
    }, Inventory)
    return self
end

function Inventory:Render()
    local panel = Instance.new("Frame")
    panel.Name = "InventoryPanel"
    panel.Size = UDim2.new(1, 0, 0, 90)
    panel.BackgroundColor3 = self.Theme.Surface
    panel.BorderSizePixel = 0
    panel.Parent = self.Parent

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -24, 0, 20)
    label.Position = UDim2.fromOffset(12, 12)
    label.Text = "Inventory status"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = panel

    return panel
end

return Inventory
