-- Khởi tạo Giao diện chính (Sử dụng PlayerGui chống lỗi ẩn trên Delta)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomMobileHub"
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 1. Nút tròn MENU đóng/mở
local MainButton = Instance.new("TextButton")
local MainCorner = Instance.new("UICorner")

MainButton.Name = "MainButton"
MainButton.Parent = ScreenGui
MainButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainButton.Position = UDim2.new(0.05, 0, 0.4, 0)
MainButton.Size = UDim2.new(0, 55, 0, 55)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.Text = "MENU"
MainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainButton.TextSize = 14
MainCorner.CornerRadius = UDim.new(1, 0)
MainCorner.Parent = MainButton

-- 2. Bảng Menu Chính màu đen thanh lịch
local MenuPanel = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuTitle = Instance.new("TextLabel")

-- Khung chứa cuộn vuốt lên xuống
local ScrollContainer = Instance.new("ScrollingFrame")
local ScrollLayout = Instance.new("UIListLayout")

MenuPanel.Name = "MenuPanel"
MenuPanel.Parent = ScreenGui
MenuPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Bảng màu đen theo yêu cầu
MenuPanel.Position = UDim2.new(0.2, 0, 0.25, 0)
MenuPanel.Size = UDim2.new(0, 210, 0, 240)
MenuPanel.Visible = false
MenuCorner.CornerRadius = UDim.new(0, 12)
MenuCorner.Parent = MenuPanel

-- Tiêu đề Bảng
MenuTitle.Name = "MenuTitle"
MenuTitle.Parent = MenuPanel
MenuTitle.BackgroundTransparency = 1
MenuTitle.Size = UDim2.new(1, 0, 0, 45)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Text = "MOBILE TOOL HUB"
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.TextSize = 16

-- Cấu hình vùng vuốt (Scrolling)
ScrollContainer.Name = "ScrollContainer"
ScrollContainer.Parent = MenuPanel
ScrollContainer.BackgroundTransparency = 1
ScrollContainer.Position = UDim2.new(0, 0, 0, 45)
ScrollContainer.Size = UDim2.new(1, 0, 1, -45)
ScrollContainer.CanvasSize = UDim2.new(0, 0, 0, 270) -- Độ dài để vuốt lên xuống thoải mái
ScrollContainer.ScrollBarThickness = 3
ScrollContainer.ScrollingDirection = Enum.ScrollingDirection.Y

ScrollLayout.Parent = ScrollContainer
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 8)
ScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Hàm tạo nút bấm có bo góc nhanh
local function createButton(name, text)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Name = name
    btn.Parent = ScrollContainer
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Màu nút mặc định
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

-- Khởi tạo các phím chức năng
local BtnInfJump = createButton("BtnInfJump", "Infinite Jump: OFF")
local BtnNoclip = createButton("BtnNoclip", "Noclip: OFF")
local BtnEsp = createButton("BtnEsp", "ESP Xuyên Tường Đỏ: OFF")
local BtnTpTool = createButton("BtnTpTool", "Nhận TP Tool (Click dịch chuyển)")

-- Dịch vụ hệ thống Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local infJumpEnabled = false
local noclipEnabled = false
local espEnabled = false

-- 1. Kéo thả nút Menu bằng tay trên điện thoại
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Nhấn nút tròn để Đóng/Mở bảng đen
MainButton.MouseButton1Click:Connect(function()
    MenuPanel.Visible = not MenuPanel.Visible
end)

-- 2. Logic: Jump Infinity
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

BtnInfJump.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        BtnInfJump.Text = "Infinite Jump: ON"
        BtnInfJump.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        BtnInfJump.Text = "Infinite Jump: OFF"
        BtnInfJump.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- 3. Logic: Noclip (Xuyên tường)
BtnNoclip.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        BtnNoclip.Text = "Noclip: ON"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        BtnNoclip.Text = "Noclip: OFF"
        BtnNoclip.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

RunService.Heartbeat:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
        end
    end
end)

-- 4. Logic: ESP Hộp Đỏ xuyên tường
local function applyESP(plr)
    if plr == player then return end
    local function setupHighlight(char)
        if not espEnabled then return end
        if char:FindFirstChild("ESPHighlight") then return end
        local hl = Instance.new("Highlight")
        hl.Name = "ESPHighlight"
        hl.Parent = char
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.FillTransparency = 0.5
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
    if plr.Character then setupHighlight(plr.Character) end
    plr.CharacterAdded:Connect(setupHighlight)
end

BtnEsp.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        BtnEsp.Text = "ESP Xuyên Tường Đỏ: ON"
        BtnEsp.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
    else
        BtnEsp.Text = "ESP Xuyên Tường Đỏ: OFF"
        BtnEsp.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("ESPHighlight") then p.Character.ESPHighlight:Destroy() end
        end
    end
end)
Players.PlayerAdded:Connect(function(p) if espEnabled then applyESP(p) end end)

-- 5. Logic: TP Tool (Click / Chạm màn hình để dịch chuyển tức thời)
BtnTpTool.MouseButton1Click:Connect(function()
    local tpTool = Instance.new("Tool")
    tpTool.Name = "Teleport Tool"
    tpTool.RequiresHandle = false
    
    tpTool.Activated:Connect(function()
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local pos = player:GetMouse().Hit.Position
            root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0)) -- Dịch chuyển đến điểm chỉ định và cao lên 3 block để tránh kẹt đất
        end
    end)
    
    tpTool.Parent = player.Backpack
    BtnTpTool.Text = "Đã nhận Tool trong Túi đồ!"
    task.delay(2, function() BtnTpTool.Text = "Nhận TP Tool (Click dịch chuyển)" end)
end)
