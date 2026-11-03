local TweenService = game:GetService("TweenService")

local Components = {}

function Components.make(className, properties, parent)
    local instance = Instance.new(className)
    for key, value in pairs(properties or {}) do
        instance[key] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

function Components.round(parent, radius)
    Components.make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10),
    }, parent)
end

function Components.outline(parent, color)
    Components.make("UIStroke", {
        Color = color,
        Transparency = 0.15,
        Thickness = 1,
    }, parent)
end

function Components.animate(object, duration, properties)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

function Components.textLabel(parent, text, size, color, font)
    return Components.make("TextLabel", {
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color,
        TextSize = size or 13,
        Font = font or Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

return Components
