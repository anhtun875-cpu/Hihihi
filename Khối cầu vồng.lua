-- DELTA 2.727 - PLATFORM HUB (KEEP CURRENT BLOCK ON DELETE)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

if PlayerGui:FindFirstChild("DeltaMainHubUI") then 
    PlayerGui.DeltaMainHubUI:Destroy() 
end

local createdPlatforms = {}
local isActivated = false
local infJumpEnabled = false
local noclipEnabled = false
local espEnabled = false

-- 1. KHỞI TẠO HỆ THỐNG MENU ĐÓNG MỞ
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "DeltaMainHubUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 180, 0, 310)
MainFrame.Position = UDim2.new(0, 20, 0, 150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Text = "  DELTA HUB v2.727"
TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", TitleLabel).CornerRadius = UDim.new(0, 10)

-- NÚT THU GỌN MENU
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 95)
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 12
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local menuVisible = true
ToggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local function createMenuButton(text, yPos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 150, 0, 38)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

-- 2. ĐỊNH NGHĨA CÁC NÚT BẤM CHỨC NĂNG
local FunctionButton = createMenuButton("Tạo Khối Chân: TẮT", 45, Color3.fromRGB(150, 0, 0))
local DeleteButton = createMenuButton("❌ XÓA CÁC KHỐI KHÁC", 90, Color3.fromRGB(50, 50, 50))
local JumpButton = createMenuButton("Infinite Jump: TẮT", 135, Color3.fromRGB(150, 0, 0))
local NoclipButton = createMenuButton("Noclip: TẮT", 180, Color3.fromRGB(150, 0, 0))
local EspButton = createMenuButton("ESP Đỏ Đậm: TẮT", 225, Color3.fromRGB(150, 0, 0))

-- LOGIC CHỨC NĂNG 1: BẬT/TẮT TẠO KHỐI
FunctionButton.MouseButton1Click:Connect(function()
    isActivated = not isActivated
    FunctionButton.Text = isActivated and "Tạo Khối Chân: BẬT" or "Tạo Khối Chân: TẮT"
    FunctionButton.BackgroundColor3 = isActivated and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- 🛠️ LOGIC CHỈNH SỬA: XÓA KHỐI CŨ, GIỮ LẠI KHỐI ĐANG ĐỨNG DƯỚI CHÂN
DeleteButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    
    local closestPlatform = nil
    local minDistance = 5 -- Khoảng cách tối đa để nhận diện khối đang ở ngay dưới chân bạn

    -- Bước 1: Tìm khối ở gần chân bạn nhất
    if rootPart then
        for _, platform in pairs(createdPlatforms) do
            if platform and platform.Parent then
                -- Tính khoảng cách khoảng cách theo phương ngang (X, Z) và đứng (Y)
                local distance = (platform.Position - (rootPart.Position - Vector3.new(0, 3.5, 0))).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    closestPlatform = platform
                end
            end
        end
    end

    -- Bước 2: Tiến hành xóa tất cả các khối, ngoại trừ khối gần chân nhất vừa tìm được
    local remainingPlatforms = {}
    for _, platform in pairs(createdPlatforms) do
        if platform and platform.Parent then
            if platform == closestPlatform then
                -- Giữ lại khối này trong danh sách quản lý
                table.insert(remainingPlatforms, platform)
            else
                -- Làm biến mất từ từ các khối còn lại
                task.spawn(function()
                    platform.CanCollide = false 
                    local tween = TweenService:Create(platform, TweenInfo.new(2, Enum.EasingStyle.Linear), {Transparency = 1})
                    tween:Play()
                    tween.Completed:Wait()
                    platform:Destroy()
                end)
            end
        end
    end
    
    -- Cập nhật lại danh sách bộ nhớ chỉ chứa khối được giữ lại
    createdPlatforms = remainingPlatforms
end)

-- LOGIC CHỨC NĂNG 2: INFINITE JUMP
JumpButton.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    JumpButton.Text = infJumpEnabled and "Infinite Jump: BẬT" or "Infinite Jump: TẮT"
    JumpButton.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- LOGIC CHỨC NĂNG 3: NOCLIP
NoclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    NoclipButton.Text = noclipEnabled and "Noclip: BẬT" or "Noclip: TẮT"
    NoclipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- LOGIC CHỨC NĂNG 4: ESP ĐỎ ĐẬM
local function applyESP(player)
    if player == LocalPlayer then return end
    local function setupHighlight(char)
        if not espEnabled then return end
        local hl = char:FindFirstChild("DeltaESP") or Instance.new("Highlight")
        hl.Name = "DeltaESP"
        hl.FillColor = Color3.fromRGB(130, 0, 0)
        hl.FillTransparency = 0.4
        hl.OutlineColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
    end
    if player.Character then setupHighlight(player.Character) end
    player.CharacterAdded:Connect(setupHighlight)
end

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    EspButton.Text = espEnabled and "ESP Đỏ Đậm: BẬT" or "ESP Đỏ Đậm: TẮT"
    EspButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do applyESP(p) end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("DeltaESP") then
                p.Character.DeltaESP:Destroy()
            end
        end
    end
end)

Players.PlayerAdded:Connect(applyESP)

-- 3. LOGIC SỬ DỤNG: CHẠM MÀN HÌNH ĐỂ TẠO KHỐI RGB DƯỚI CHÂN
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if isActivated and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local spawnPos = rootPart.Position - Vector3.new(0, 3.5, 0)
            
            local platform = Instance.new("Part")
            platform.Name = "DeltaRGBFloor"
            platform.Size = Vector3.new(16, 2, 16)
            platform.CFrame = CFrame.new(spawnPos)
            platform.Material = Enum.Material.Neon
            platform.Transparency = 0.1
            platform.CanCollide = true
            platform.Anchored = true
            platform.Parent = game.Workspace
            
            table.insert(createdPlatforms, platform)
            
            task.spawn(function()
                local hue = 0
                while platform and platform.Parent do
                    hue = (hue + 1) % 360
                    platform.Color = Color3.fromHSV(hue / 360, 1, 1)
                    if not noclipEnabled then
                        platform.CanCollide = true
                    end
                    RunService.Heartbeat:Wait()
                end
            end)
        end
    end
end)
