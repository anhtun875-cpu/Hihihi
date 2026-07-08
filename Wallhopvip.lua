-- Khởi tạo Giao diện chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltimateSystemMenuV2"
-- ĐÃ SỬA: Chuyển từ CoreGui sang PlayerGui để tránh bị Delta X chặn hiển thị
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 1. Nút tròn MENU (Main Button)
local MainFrame = Instance.new("TextButton")
local MainCorner = Instance.new("UICorner")

MainFrame.Name = "MainButton"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 60, 0, 60)
MainFrame.Font = Enum.Font.SourceSansBold
MainFrame.Text = "MENU"
MainFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.TextSize = 14
MainCorner.CornerRadius = UDim.new(1, 0)
MainCorner.Parent = MainFrame

-- 2. Bảng Menu Chức Năng (Cố định chiều cao, nội dung bên trong tự cuốn)
local MenuPanel = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuTitle = Instance.new("TextLabel")

MenuPanel.Name = "MenuPanel"
MenuPanel.Parent = ScreenGui
MenuPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuPanel.Position = UDim2.new(0.15, 0, 0.35, 0)
MenuPanel.Size = UDim2.new(0, 200, 0, 180) 
MenuPanel.Visible = false
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MenuPanel

-- Tiêu đề bảng
MenuTitle.Name = "MenuTitle"
MenuTitle.Parent = MenuPanel
MenuTitle.BackgroundTransparency = 1
MenuTitle.Size = UDim2.new(1, 0, 0, 35)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Text = "ULTIMATE SYSTEM"
MenuTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MenuTitle.TextSize = 15

-- 3. KHUNG VUỐT CUỘN CHẾ ĐỘ VUỐT LÊN VUỐT XUỐNG (ScrollingFrame)
local ScrollContainer = Instance.new("ScrollingFrame")
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Parent = MenuPanel
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 0, 0, 35)
ScrollContainer.Size = UDim2.new(1, 0, 1, -35)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 260) 
ScrollContainer.ScrollBarThickness = 4
ScrollContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)

-- Hàm tạo nhanh nút bấm đặt bên trong khung vuốt cuộn
local function createScrollButton(name, text, positionY)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Name = name
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Position = UDim2.new(0.1, 0, 0, positionY)
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- Tạo các nút bấm xếp chồng theo thứ tự chiều dọc trong khung vuốt
local ToggleVerticalButton = createScrollButton("ToggleVerticalButton", "Auto Wall Hop", 10)
local ToggleESPButton = createScrollButton("ToggleESPButton", "Player ESP", 60)
local ToggleInfJumpButton = createScrollButton("ToggleInfJumpButton", "Infinity Jump", 110)
local ToggleNoClipButton = createScrollButton("ToggleNoClipButton", "NoClip xuyên tường", 160)
local ToggleTeleToolButton = createScrollButton("ToggleTeleToolButton", "Tele Tool VIP", 210)

-- Cấu hình Trạng thái hệ thống
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local verticalEnabled = false 
local espEnabled = false
local infJumpEnabled = false
local noclipEnabled = false
local teleToolEnabled = false

local DETECTION_DISTANCE = 2.8 
local JUMP_COOLDOWN = 0.35     
local VERTICAL_SPEED = 20      
local lastJumpTime = 0
local teleTool = nil

-- Kéo thả nút MENU (Drag GUI)
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

MainFrame.MouseButton1Click:Connect(function()
    MenuPanel.Visible = not MenuPanel.Visible
    if MenuPanel.Visible then
        MenuPanel.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 70, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 60)
    end
end)

-- 1. Xử lý Wall Hop Dọc
ToggleVerticalButton.MouseButton1Click:Connect(function()
    verticalEnabled = not verticalEnabled
    ToggleVerticalButton.Text = verticalEnabled and "Auto Wall Hop: ON" or "Auto Wall Hop: OFF"
    ToggleVerticalButton.BackgroundColor3 = verticalEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

local function findNearbyWall(rootPart, character)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local directions = {rootPart.CFrame.LookVector, -rootPart.CFrame.LookVector, rootPart.CFrame.RightVector, -rootPart.CFrame.RightVector}
    for _, dir in ipairs(directions) do
        local raycastResult = workspace:Raycast(rootPart.Position, dir * DETECTION_DISTANCE, raycastParams)
        if raycastResult and raycastResult.Instance and raycastResult.Instance.CanCollide then return true end
    end
    return false
end

-- 2. Xử lý Player ESP
ToggleESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ToggleESPButton.Text = espEnabled and "Player ESP: ON" or "Player ESP: OFF"
    ToggleESPButton.BackgroundColor3 = espEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    if not espEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HighlightESP") then p.Character.HighlightESP:Destroy() end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and not p.Character:FindFirstChild("HighlightESP") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "HighlightESP"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.Parent = p.Character
        end
    end
end)

-- 3. Xử lý Infinity Jump
ToggleInfJumpButton.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    ToggleInfJumpButton.Text = infJumpEnabled and "Infinity Jump: ON" or "Infinity Jump: OFF"
    ToggleInfJumpButton.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

UserInputService.JumpRequest:Connect(function()
    if not infJumpEnabled then return end
    local character = player.Character
    if character and character:FindFirstChildOfClass("Humanoid") then
        character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 4. Xử lý NoClip
ToggleNoClipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    ToggleNoClipButton.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
    ToggleNoClipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- 5. XỬ LÝ CHỨC NĂNG TELE TOOL VIP (Click/Touch Dịch chuyển)
local function createTeleTool()
    local tool = Instance.new("Tool")
    tool.Name = "⭐ Teleport VIP ⭐"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local mouse = player:GetMouse()
        
        if rootPart and mouse.Hit then
            rootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
        end
    end)
    return tool
end

ToggleTeleToolButton.MouseButton1Click:Connect(function()
    teleToolEnabled = not teleToolEnabled
    ToggleTeleToolButton.Text = teleToolEnabled and "Tele Tool VIP: ON" or "Tele Tool VIP: OFF"
    ToggleTeleToolButton.BackgroundColor3 = teleToolEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    local backpack = player:WaitForChild("Backpack")
    
    if teleToolEnabled then
        if not backpack:FindFirstChild("⭐ Teleport VIP ⭐") then
            teleTool = createTeleTool()
            teleTool.Parent = backpack
        end
    else
        local existingTool = backpack:FindFirstChild("⭐ Teleport VIP ⭐") or (player.Character and player.Character:FindFirstChild("⭐ Teleport VIP ⭐"))
        if existingTool then existingTool:Destroy() end
    end
end)

player.CharacterAdded:Connect(function()
    if teleToolEnabled then
        task.wait(0.5)
        local backpack = player:WaitForChild("Backpack")
        if not backpack:FindFirstChild("⭐ Teleport VIP ⭐") then
            teleTool = createTeleTool()
            teleTool.Parent = backpack
        end
    end
end)

-- Vòng lặp Core vật lý xử lý NoClip và Wall Hop
