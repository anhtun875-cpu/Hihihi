-- Khởi tạo Giao diện chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Speed20HorizontalWallHop"
ScreenGui.Parent = game:GetService("CoreGui")
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

-- 2. Bảng Menu Chức Năng
local MenuPanel = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuTitle = Instance.new("TextLabel")
local ToggleVerticalButton = Instance.new("TextButton")
local VerticalCorner = Instance.new("UICorner")
local ToggleHorizontalButton = Instance.new("TextButton")
local HorizontalCorner = Instance.new("UICorner")

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
MenuTitle.Size = UDim2.new(1, 0, 0, 40)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Text = "WALL HOP SYSTEM"
MenuTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MenuTitle.TextSize = 16

-- Nút bấm Wall Hop Dọc
ToggleVerticalButton.Name = "ToggleVerticalButton"
ToggleVerticalButton.Parent = MenuPanel
ToggleVerticalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleVerticalButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleVerticalButton.Size = UDim2.new(0, 160, 0, 40)
ToggleVerticalButton.Font = Enum.Font.SourceSansBold
ToggleVerticalButton.Text = "Wall Hop Dọc: OFF"
ToggleVerticalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleVerticalButton.TextSize = 13
VerticalCorner.CornerRadius = UDim.new(0, 8)
VerticalCorner.Parent = ToggleVerticalButton

-- Nút bấm Wall Hop Ngang
ToggleHorizontalButton.Name = "ToggleHorizontalButton"
ToggleHorizontalButton.Parent = MenuPanel
ToggleHorizontalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleHorizontalButton.Position = UDim2.new(0.1, 0, 0.55, 0)
ToggleHorizontalButton.Size = UDim2.new(0, 160, 0, 40)
ToggleHorizontalButton.Font = Enum.Font.SourceSansBold
ToggleHorizontalButton.Text = "Wall Hop Ngang: OFF"
ToggleHorizontalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHorizontalButton.TextSize = 13
HorizontalCorner.CornerRadius = UDim.new(0, 8)
HorizontalCorner.Parent = ToggleHorizontalButton

-- Cấu hình Logic hệ thống lướt tốc độ 20
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local verticalEnabled = false 
local horizontalEnabled = false 

local DETECTION_DISTANCE = 2.5 
local JUMP_COOLDOWN = 0.4 
local HORIZONTAL_SPEED = 20  -- ĐÃ TĂNG LÊN 20 THEO YÊU CẦU
local SHAKE_INTENSITY = 3.5  -- Giữ nguyên độ giật màn hình cực mạnh
local lastJumpTime = 0

-- Tạo bộ điều khiển lực vật lý ổn định
local attachment = Instance.new("Attachment")
local linearVelocity = Instance.new("LinearVelocity")
linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
linearVelocity.MaxForce = 0

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

-- Nhấn nút MENU để Đóng/Mở bảng
MainFrame.MouseButton1Click:Connect(function()
    MenuPanel.Visible = not MenuPanel.Visible
    if MenuPanel.Visible then
        MenuPanel.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 70, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 55)
    end
end)

-- Bật/Tắt Wall Hop Dọc
ToggleVerticalButton.MouseButton1Click:Connect(function()
    verticalEnabled = not verticalEnabled
    if verticalEnabled then
        ToggleVerticalButton.Text = "Wall Hop Dọc: ON"
        ToggleVerticalButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        horizontalEnabled = false
        ToggleHorizontalButton.Text = "Wall Hop Ngang: OFF"
        ToggleHorizontalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        linearVelocity.MaxForce = 0
    else
        ToggleVerticalButton.Text = "Wall Hop Dọc: OFF"
        ToggleVerticalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

-- Bật/Tắt Wall Hop Ngang
ToggleHorizontalButton.MouseButton1Click:Connect(function()
    horizontalEnabled = not horizontalEnabled
    if horizontalEnabled then
        ToggleHorizontalButton.Text = "Wall Hop Ngang: ON"
        ToggleHorizontalButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        verticalEnabled = false
        ToggleVerticalButton.Text = "Wall Hop Dọc: OFF"
        ToggleVerticalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    else
        ToggleHorizontalButton.Text = "Wall Hop Ngang: OFF"
        ToggleHorizontalButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        linearVelocity.MaxForce = 0
    end
end)

-- Quản lý Physics khi nhân vật hồi sinh
local function setupPhysics(char)
    local rootPart = char:WaitForChild("HumanoidRootPart", 5)
    if rootPart then
        attachment.Parent = rootPart
        linearVelocity.Attachment0 = attachment
        linearVelocity.Parent = rootPart
    end
end

if player.Character then setupPhysics(player.Character) end
player.CharacterAdded:Connect(setupPhysics)

-- Vòng lặp Core xử lý dịch chuyển phương ngang
RunService.Heartbeat:Connect(function()
    if not verticalEnabled and not horizontalEnabled then 
        linearVelocity.MaxForce = 0
        return 
    end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then 
        linearVelocity.MaxForce = 0
        return 
    end
    
    -- Quét tia tìm tường phẳng trước mặt
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local forwardDirection = rootPart.CFrame.LookVector * DETECTION_DISTANCE
    local raycastResult = workspace:Raycast(rootPart.Position, forwardDirection, raycastParams)
    
    if raycastResult and raycastResult.Instance and raycastResult.Instance.CanCollide then
        if verticalEnabled then
            -- LOGIC DỌC CHẬM CHÂN THỰC
            local currentTime = tick()
            if currentTime - lastJumpTime >= JUMP_COOLDOWN then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                lastJumpTime = currentTime
            end
        elseif horizontalEnabled then
            -- LOGIC NGANG: Lướt mượt mà tốc độ 20
            linearVelocity.MaxForce = 45000
            local sideVector = rootPart.CFrame.RightVector * HORIZONTAL_SPEED
            linearVelocity.VectorVelocity = Vector3.new(sideVector.X, 0, sideVector.Z)
            humanoid.Jump = true 
            
            -- HIỆU ỨNG GIẬT NGANG MÀN HÌNH LIÊN TỤC
            local extremeShakeX = math.sin(tick() * 70) * SHAKE_INTENSITY
            Camera.CFrame = Camera.CFrame * CFrame.new(extremeShakeX, 0, 0)
        end
    else
        if horizontalEnabled then
            linearVelocity.MaxForce = 0
        end
    end
end)
