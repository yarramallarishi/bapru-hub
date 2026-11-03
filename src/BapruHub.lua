local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local function requireModule(moduleName, folderName)
    local root = script.Parent
    local folder = folderName and root:FindFirstChild(folderName)

    if folder and folder:FindFirstChild(moduleName) then
        return require(folder:WaitForChild(moduleName))
    end

    if root:FindFirstChild(moduleName) then
        return require(root:WaitForChild(moduleName))
    end

    error("Missing required module: " .. tostring(moduleName))
end

local Components = requireModule("Components", "UI")
local ThemeLibrary = requireModule("Theme", "UI")
local StateManager = requireModule("StateManager", "Core")
local Cleanup = requireModule("Cleanup", "Core")
local ErrorHandler = requireModule("ErrorHandler", "Core")
local TaskManager = requireModule("TaskManager", "Core")
local Notifications = requireModule("Notifications", "UI")

local BapruHub = {}
BapruHub.__index = BapruHub

local make = Components.make
local round = Components.round
local outline = Components.outline
local animate = Components.animate
local textLabel = Components.textLabel

function BapruHub.new(config, catalog)
    local self = setmetatable({}, BapruHub)
    self.Config = config or {}
    self.Theme = config and config.Theme or ThemeLibrary
    self.Catalog = catalog or {}
    self.State = StateManager.new({})
    self.Cleanup = Cleanup.new()
    self.Tasks = TaskManager.new()
    self.ErrorHandler = ErrorHandler.new()
    self.Notifications = Notifications.new(nil, self.Theme)
    self.Tabs = {}
    self.Controls = {}
    self.Connections = {}
    self.Destroyed = false
    self.Player = Players.LocalPlayer
    self.PlayerGui = self.Player:WaitForChild("PlayerGui")

    local oldGui = self.PlayerGui:FindFirstChild("BapruHub")
    if oldGui then oldGui:Destroy() end

    self.Gui = make("ScreenGui", {
        Name = "BapruHub",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, self.PlayerGui)

    self.Notifications.Holder = self.Gui
    self.State:Bootstrap(self.Catalog)
    self:_build()
    self:_bindDrag()
    self:_bindKeyboard()
    self:Notify("Welcome", (self.Config.Title or "Bapru Hub") .. " is ready.", "success")
    return self
end

function BapruHub:_build()
    local t = self.Theme
    local window = make("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.52),
        Size = UDim2.fromOffset(self.Config.Window.Width, self.Config.Window.Height),
        BackgroundColor3 = t.Background,
        BorderSizePixel = 0,
    }, self.Gui)
    self.Window = window
    round(window, 16)
    outline(window, t.Border)

    self.Scale = make("UIScale", { Scale = 0.96 }, window)
    animate(self.Scale, 0.28, { Scale = 1 })

    local header = make("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, window)
    round(header, 16)
    make("Frame", {
        Position = UDim2.new(0, 0, 1, -16),
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, header)
    self.Header = header

    local title = textLabel(header, self.Config.Title, 17, t.Text, Enum.Font.GothamBlack)
    title.Position = UDim2.fromOffset(20, 8)
    title.Size = UDim2.new(1, -100, 0, 25)

    local subtitle = textLabel(header, self.Config.Subtitle .. "  •  v" .. self.Config.Version, 9, t.Muted, Enum.Font.GothamBold)
    subtitle.Position = UDim2.fromOffset(21, 35)
    subtitle.Size = UDim2.new(1, -100, 0, 14)

    local close = make("TextButton", {
        Position = UDim2.new(1, -48, 0, 16),
        Size = UDim2.fromOffset(32, 32),
        BackgroundColor3 = t.SurfaceRaised,
        Text = "×",
        TextColor3 = t.Text,
        TextSize = 22,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
    }, header)
    round(close, 9)
    close.MouseButton1Click:Connect(function() self:Destroy() end)

    self.Sidebar = make("Frame", {
        Position = UDim2.fromOffset(14, 78),
        Size = UDim2.new(0, 184, 1, -94),
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, window)
    round(self.Sidebar, 12)

    local search = make("TextBox", {
        Name = "Search",
        Position = UDim2.fromOffset(10, 10),
        Size = UDim2.new(1, -20, 0, 34),
        BackgroundColor3 = t.SurfaceRaised,
        PlaceholderText = "Search features...",
        PlaceholderColor3 = t.Muted,
        Text = "",
        TextColor3 = t.Text,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        ClearTextOnFocus = false,
    }, self.Sidebar)
    round(search, 8)
    search:GetPropertyChangedSignal("Text"):Connect(function()
        self:_filter(search.Text)
    end)

    self.TabList = make("ScrollingFrame", {
        Position = UDim2.fromOffset(9, 54),
        Size = UDim2.new(1, -18, 1, -64),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = t.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
    }, self.Sidebar)
    make("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.TabList)

    self.PageHolder = make("Frame", {
        Position = UDim2.new(0, 210, 0, 78),
        Size = UDim2.new(1, -224, 1, -94),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, window)

    self.ToastHolder = make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -14, 0, 14),
        Size = UDim2.fromOffset(310, 280),
        BackgroundTransparency = 1,
    }, self.Gui)

    self:_buildCatalog()
    self:_fitToViewport()
end

function BapruHub:_fitToViewport()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local function update()
        local viewport = camera.ViewportSize
        local maxW = self.Config.Window.Width
        local maxH = self.Config.Window.Height
        local factor = math.min(1, (viewport.X - 24) / maxW, (viewport.Y - 24) / maxH)
        self.Scale.Scale = math.max(0.5, factor)
    end
    update()
    table.insert(self.Connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(update))
end

function BapruHub:_bindDrag()
    local dragging, startInput, startPosition
    table.insert(self.Connections, self.Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = self.Window.Position
        end
    end))
    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            self.Window.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end))
    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end))
end

function BapruHub:_bindKeyboard()
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            self.Window.Visible = not self.Window.Visible
        end
    end))
end

function BapruHub:_newPage(name)
    local page = make("ScrollingFrame", {
        Name = name .. "Page",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = self.Theme.Accent,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Visible = false,
    }, self.PageHolder)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 14),
        PaddingLeft = UDim.new(0, 2),
        PaddingRight = UDim.new(0, 8),
    }, page)
    make("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, page)
    return page
end

function BapruHub:_buildCatalog()
    for index, definition in ipairs(self.Catalog) do
        local tabButton = make("TextButton", {
            Name = definition.Name .. "Tab",
            Size = UDim2.new(1, 0, 0, 39),
            BackgroundColor3 = self.Theme.Accent,
            BackgroundTransparency = 1,
            Text = (definition.Icon or "•") .. "   " .. definition.Name,
            TextColor3 = self.Theme.Muted,
            TextSize = 12,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = index,
        }, self.TabList)
        make("UIPadding", { PaddingLeft = UDim.new(0, 11) }, tabButton)
        round(tabButton, 8)

        local page = self:_newPage(definition.Name)
        local tab = { Name = definition.Name, Button = tabButton, Page = page, Definition = definition }
        table.insert(self.Tabs, tab)

        tabButton.MouseButton1Click:Connect(function()
            self:SelectTab(tab)
        end)

        self:_buildSections(tab, definition)
    end
    if self.Tabs[1] then self:SelectTab(self.Tabs[1]) end
end

function BapruHub:_buildSections(tab, definition)
    local t = self.Theme
    local section = make("Frame", {
        Name = "Overview",
        Size = UDim2.new(1, 0, 0, 60),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, tab.Page)
    round(section, 12)
    outline(section, t.Border)
    make("UIPadding", {
        PaddingTop = UDim.new(0, 12),
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 13),
        PaddingRight = UDim.new(0, 13),
    }, section)
    make("UIListLayout", { Padding = UDim.new(0, 9), SortOrder = Enum.SortOrder.LayoutOrder }, section)

    local heading = textLabel(section, definition.Name, 14, t.Text, Enum.Font.GothamBold)
    heading.Size = UDim2.new(1, 0, 0, 20)
    local description = textLabel(section, definition.Description or "", 11, t.Muted)
    description.Size = UDim2.new(1, 0, 0, 18)

    for _, item in ipairs(definition.Items or {}) do
        self:_buildControl(section, item)
    end
end

function BapruHub:_buildControl(parent, item)
    local t = self.Theme
    local row = make("Frame", {
        Name = item.Id,
        Size = UDim2.new(1, 0, 0, item.Kind == "slider" and 54 or 38),
        BackgroundTransparency = 1,
    }, parent)

    if item.Kind == "label" then
        local value = textLabel(row, item.Name .. ": " .. tostring(item.Default or ""), 12, t.Muted)
        value.Size = UDim2.fromScale(1, 1)
        self.Controls[item.Id] = { Type = "label", Object = value }
        return
    end

    if item.Kind == "button" then
        local name = textLabel(row, item.Name, 12, t.Text)
        name.Size = UDim2.new(1, -90, 1, 0)

        local button = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(74, 26),
            BackgroundColor3 = t.SurfaceRaised,
            Text = tostring(item.Default or "Action"),
            TextColor3 = t.Text,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
        }, row)
        round(button, 8)
        outline(button, t.Border)
        button.MouseButton1Click:Connect(function()
            if item.Callback then
                item.Callback()
            else
                self:Notify("Action", item.Name .. " triggered.", "success")
            end
        end)
        self.Controls[item.Id] = { Type = "button", Object = button }
        return
    end

    local name = textLabel(row, item.Name, 12, t.Text)
    name.Size = UDim2.new(1, -70, 1, 0)

    if item.Kind == "toggle" then
        local state = item.Default == true
        local switch = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(42, 23),
            BackgroundColor3 = state and t.Accent or t.SurfaceRaised,
            Text = "",
            AutoButtonColor = false,
        }, row)
        round(switch, 20)
        local knob = make("Frame", {
            Size = UDim2.fromOffset(17, 17),
            Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
        }, switch)
        round(knob, 20)

        local control = { Type = "toggle", Value = state, Object = switch }
        function control:Set(value)
            self.Value = value == true
            animate(switch, 0.14, { BackgroundColor3 = self.Value and t.Accent or t.SurfaceRaised })
            animate(knob, 0.14, {
                Position = self.Value and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            })
            if self.Callback then self.Callback(self.Value) end
        end
        switch.MouseButton1Click:Connect(function() control:Set(not control.Value) end)
        self.Controls[item.Id] = control

    elseif item.Kind == "slider" then
        local minimum, maximum = item.Min or 0, item.Max or 100
        local value = math.clamp(item.Default or minimum, minimum, maximum)
        local readout = textLabel(row, tostring(value), 11, t.AccentAlt, Enum.Font.GothamBold)
        readout.Size = UDim2.fromOffset(48, 20)
        readout.Position = UDim2.new(1, -48, 0, 0)
        readout.TextXAlignment = Enum.TextXAlignment.Right
        local track = make("Frame", {
            Position = UDim2.fromOffset(0, 34),
            Size = UDim2.new(1, 0, 0, 6),
            BackgroundColor3 = t.SurfaceRaised,
            BorderSizePixel = 0,
        }, row)
        round(track, 6)
        local fill = make("Frame", {
            Size = UDim2.new((value - minimum) / math.max(maximum - minimum, 1), 0, 1, 0),
            BackgroundColor3 = t.Accent,
            BorderSizePixel = 0,
        }, track)
        round(fill, 6)
        local hitbox = make("TextButton", {
            Position = UDim2.fromOffset(0, -9),
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = "",
        }, track)
        local control = { Type = "slider", Value = value }
        local dragging = false
        local function setFromX(x)
            local alpha = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            control.Value = math.floor(minimum + (maximum - minimum) * alpha + 0.5)
            readout.Text = tostring(control.Value)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            if control.Callback then control.Callback(control.Value) end
        end
        hitbox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(input.Position.X)
            end
        end)
        table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                setFromX(input.Position.X)
            end
        end))
        table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end))
        self.Controls[item.Id] = control
    end
end

function BapruHub:SelectTab(tab)
    for _, other in ipairs(self.Tabs) do
        local active = other == tab
        other.Page.Visible = active
        animate(other.Button, 0.14, {
            BackgroundTransparency = active and 0 or 1,
            TextColor3 = active and self.Theme.Text or self.Theme.Muted,
        })
    end
    self.ActiveTab = tab
end

function BapruHub:_filter(query)
    query = string.lower(query or "")
    for _, tab in ipairs(self.Tabs) do
        local tabMatch = string.find(string.lower(tab.Name), query, 1, true) ~= nil
        local anyItem = false
        for _, item in ipairs(tab.Definition.Items or {}) do
            local match = string.find(string.lower(item.Name), query, 1, true) ~= nil
            anyItem = anyItem or match
            local control = tab.Page:FindFirstChild(item.Id, true)
            if control then control.Visible = query == "" or match or tabMatch end
        end
        tab.Button.Visible = query == "" or tabMatch or anyItem
        if query ~= "" and (tabMatch or anyItem) then
            self:SelectTab(tab)
        end
    end
end

function BapruHub:Notify(title, message, kind, seconds)
    if self.Destroyed then return end
    local t = self.Theme
    local accent = kind == "success" and t.Success or (kind == "error" and t.Error or t.Accent)
    local toast = make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 330, 0, 12),
        Size = UDim2.fromOffset(292, 72),
        BackgroundColor3 = t.Surface,
        BorderSizePixel = 0,
    }, self.ToastHolder)
    round(toast, 11)
    outline(toast, t.Border)
    make("Frame", {
        Size = UDim2.new(0, 4, 1, -18),
        Position = UDim2.fromOffset(0, 9),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
    }, toast)
    local titleText = textLabel(toast, title or "Bapru Hub", 13, t.Text, Enum.Font.GothamBold)
    titleText.Position = UDim2.fromOffset(15, 9)
    titleText.Size = UDim2.new(1, -25, 0, 20)
    local body = textLabel(toast, message or "", 11, t.Muted)
    body.Position = UDim2.fromOffset(15, 31)
    body.Size = UDim2.new(1, -25, 0, 30)
    body.TextWrapped = true
    animate(toast, 0.25, { Position = UDim2.new(1, -12, 0, 12) })
    task.delay(seconds or 3, function()
        if toast.Parent then
            animate(toast, 0.2, { Position = UDim2.new(1, 330, 0, 12) })
            task.wait(0.22)
            if toast.Parent then toast:Destroy() end
        end
    end)
end

function BapruHub:SetValue(id, value)
    local control = self.Controls[id]
    if not control then return false end
    if control.Type == "toggle" then
        control:Set(value)
    elseif control.Type == "slider" then
        control.Value = value
    elseif control.Type == "label" then
        control.Object.Text = tostring(value)
    elseif control.Type == "button" then
        control.Object.Text = tostring(value)
    end
    return true
end

function BapruHub:GetValue(id)
    local control = self.Controls[id]
    return control and control.Value
end

function BapruHub:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    for _, connection in ipairs(self.Connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(self.Connections)
    if self.Tasks then
        for name in pairs(self.Tasks.Active or {}) do
            self.Tasks:Cancel(name)
        end
    end
    if self.Cleanup then
        self.Cleanup:Run()
    end
    if self.Gui then self.Gui:Destroy() end
end

return BapruHub
