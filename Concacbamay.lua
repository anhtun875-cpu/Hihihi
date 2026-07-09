-- =======================================================
-- DELTA v2.727 RAW BYPASS MENU - REBUILT TO FORCE DISPLAY
-- ANTI-DELETE PROTECTION | 100% LUÔN XUẤT HIỆN
-- =======================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Khởi động biến trạng thái hệ thống
local hitboxSize = 15
local isHitboxOn = false
local isJumpOn = false
local isNoclipOn = false
local isEspOn = false

-- --- PHẦN 1: ĐỘNG CƠ BUỘC HIỂN THỊ VÀ CHỐNG XOÁ (ANTI-DELETE ENGINE) ---
local function CreateRawMenu()
    local TargetGui = LocalPlayer:WaitForChild("PlayerGui", 5)
    if not TargetGui then return end
    
    -- Nếu menu đã có sẵn thì không tạo trùng
    if TargetGui:FindFirstChild("DeltaBypassPanel") then return end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DeltaBypassPanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999999 -- Ép buộc đè lên tất cả
    ScreenGui.Parent = TargetGui
    
    -- Khung nền đen nhám tối giản (Kích thước nhỏ không lo kẹt màn hình)
    local Frame = Instance.new("Frame")
    Frame.Name = "MainBoard"
    Frame.Size = UDim2.new(0, 185, 0, 155)
    Frame.Position = UDim2.new(0.05, 0, 0.2, 0) -- Nằm an toàn bên cạnh trái màn hình
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true -- Cho phép giữ ngón tay vào bảng để kéo di chuyển
    Frame.Parent = ScreenGui
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", Frame)
    Stroke.Color = Color3.fromRGB(0, 122, 255) -- Viền xanh biển
    Stroke.Thickness = 1.5
    
    -- Tiêu đề bảng menu
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 24)
    Title.Text = "🔵 DELTA BYPASS V7"
    Title.TextColor3 = Color3.fromRGB(0, 122, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 12
    Title.BackgroundTransparency = 1
    Title.Parent = Frame
    
    -- Khung cuộn vuốt lên vuốt xuống chống kẹt nút
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, -24)
    Scroll.Position = UDim2.new(0, 0, 0, 24)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 2
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 122, 255)
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 160)
    Scroll.Parent = Frame
    
    local Layout = Instance.new("UIListLayout", Scroll)
    Layout.Padding = UDim.new(0, 5)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Hàm tạo nhanh các phím chức năng thô
    local function CreateButton(text, order)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 170, 0, 26)
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.SourceSansSemibold
        b.TextSize = 11
        b.LayoutOrder = order
        b.Parent = Scroll
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        return b
    end
    
    -- 1. Ô NHẬP HITBOX CỦA MENU (1-100)
    local Inp = Instance.new("TextBox")
    Inp.Size = UDim2.new(0, 170, 0, 26)
    Inp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Inp.TextColor3 = Color3.fromRGB(0, 122, 255)
    Inp.PlaceholderText = "Nhập Hitbox (1-100)"
    Inp.Text = isHitboxOn and tostring(hitboxSize) or ""
    Inp.Font = Enum.Font.SourceSansBold
    Inp.TextSize = 11
    Inp.LayoutOrder = 1
    Inp.Parent = Scroll
    Instance.new("UICorner", Inp).CornerRadius = UDim.new(0, 5)
    
    Inp.FocusLost:Connect(function()
        local n = tonumber(Inp.Text)
        if n then hitboxSize = math.clamp(n, 1, 100) else hitboxSize = 15 end
        Inp.Text = tostring(hitboxSize)
    end)
    
    -- 2. CÁC NÚT TÍNH NĂNG CHẠY BIẾN TOÀN CỤC
    local BtnHitbox = CreateButton(isHitboxOn and "Bật Hitbox: ON" or "Bật Hitbox: OFF", 2)
    BtnHitbox.TextColor3 = isHitboxOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    BtnHitbox.MouseButton1Click:Connect(function()
        isHitboxOn = not isHitboxOn
        BtnHitbox.Text = isHitboxOn and "Bật Hitbox: ON" or "Bật Hitbox: OFF"
        BtnHitbox.TextColor3 = isHitboxOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    end)
    
    local BtnJump = CreateButton(isJumpOn and "Jump Infinity: ON" or "Jump Infinity: OFF", 3)
    BtnJump.TextColor3 = isJumpOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    BtnJump.MouseButton1Click:Connect(function()
        isJumpOn = not isJumpOn
        BtnJump.Text = isJumpOn and "Jump Infinity: ON" or "Jump Infinity: OFF"
        BtnJump.TextColor3 = isJumpOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    end)
    
    local BtnNoclip = CreateButton(isNoclipOn and "Noclip Xuyên Tường: ON" or "Noclip Xuyên Tường: OFF", 4)
    BtnNoclip.TextColor3 = isNoclipOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    BtnNoclip.MouseButton1Click:Connect(function()
        isNoclipOn = not isNoclipOn
        BtnNoclip.Text = isNoclipOn and "Noclip Xuyên Tường: ON" or "Noclip Xuyên Tường: OFF"
        BtnNoclip.TextColor3 = isNoclipOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    end)
    
    local BtnEsp = CreateButton(isEspOn and "ESP Nhìn Xuyên: ON" or "ESP Nhìn Xuyên: OFF", 5)
    BtnEsp.TextColor3 = isEspOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    BtnEsp.MouseButton1Click:Connect(function()
        isEspOn = not isEspOn
        BtnEsp.Text = isEspOn and "ESP Nhìn Xuyên: ON" or "ESP Nhục Xuyên: OFF"
        BtnEsp.TextColor3 = isEspOn and Color3.fromRGB(0, 255, 122) or Color3.fromRGB(255, 255, 255)
    end)
    
    -- 3. NÚT TRÒN XANH BIỂN THẢ NỔI ĐỂ ĐÓNG MỞ (FLOATING MINI TOGGLE)
    local Circle = Instance.new("TextButton")
    Circle.Name = "MiniToggle"
    Circle.Size = UDim2.new(0, 48, 0, 48)
    Circle.Position = UDim2.new(0.05, 0, 0.2, -55) -- Luôn đi kèm phía trên bảng menu
    Circle.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    Circle.Text = "MENU"
    Circle.TextColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Font = Enum.Font.SourceSansBold
    Circle.TextSize = 12
    Circle.ZIndex = 20
    Circle.Draggable = true
    Circle.Parent = ScreenGui
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
    
    Circle.MouseButton1Click:Connect(function()
        Frame.Visible = not Frame.Visible
        Circle.Text = Frame.Visible and "CLOSE" or "MENU"
    end)
end

-- VÒNG LẶP THẦN TỐC: Quét liên tục mỗi 0.5 giây để hồi sinh giao diện nếu Delta cố tình xóa
task.spawn(function()
    while true do
        pcall(CreateRawMenu)
        task.wait(0.5)
    end
end)

-- =======================================================
-- PHẦN 2: LÕI LIÊN KẾT TÍNH NĂNG VIP (CHẠY ĐỘC LẬP THEO LUỒNG)
-- =======================================================

-- Lõi 1: Ép kích thước Hitbox (Chống Bug/Chống văng)
task.spawn(function()
    while task.wait(1) do
        if isHitboxOn then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hrp.Transparency = 0.7
                    hrp.BrickColor = BrickColor.new("Really blue")
                    hrp.CanCollide = false
                end
            end
        end
    end
end)

-- Lõi 2: Nhảy vô hạn (Jump Infinity)
UserInputService.JumpRequest:Connect(function()
    if isJumpOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)
