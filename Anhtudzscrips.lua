-- TỐI ƯU CƯỠNG BỨC 10.000.000%: Bản sửa lỗi giới hạn Cấp Tốc Độ 1 - 50
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")

if CoreGui:FindFirstChild("AnhTuMenuGui") then CoreGui.AnhTuMenuGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnhTuMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- NÚT TRÒN MENU NỔI AT
local ToggleButton = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 210, 100)
ToggleButton.Position = UDim2.new(0.12, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0, 52, 0, 52)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "AT"
ToggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.TextSize = 18
ToggleButton.Active = true
ToggleButton.Draggable = true

ButtonCorner.CornerRadius = UDim.new(1, 0)
ButtonCorner.Parent = ToggleButton

-- KHUNG MENU CHÍNH
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Position = UDim2.new(0.5, -135, 0.5, -170)
MainFrame.Size = UDim2.new(0, 270, 0, 340)
MainFrame.Visible = false

FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "★ ANH TÚ MENU ★"
Title.TextColor3 = Color3.fromRGB(0, 210, 100)
Title.TextSize = 16

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local HitboxActive = false
local NoclipActive = false
local InfJumpActive = false
local AutoWinActive = false

-- ĐIỀU CHỈNH CHUẨN: Bắt đầu từ Cấp 1 (Tốc độ gốc) [2]
local SpeedLevel = 1 
local ActualWalkSpeed = 16 

local function createMenuButton(text, posY, color, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 5) c.Parent = btn
    
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return btn
end

-- HỆ THỐNG NÚT GIẢM (-) VÀ TĂNG (+) THEO CẤP 1 - 50 [5, 6]
local GiamBtn = Instance.new("TextButton")
local TangBtn = Instance.new("TextButton")
local cG = Instance.new("UICorner") local cT = Instance.new("UICorner")

GiamBtn.Parent = MainFrame; GiamBtn.BackgroundColor3 = Color3.fromRGB(150, 20, 20)
GiamBtn.Position = UDim2.new(0.05, 0, 0, 45); GiamBtn.Size = UDim2.new(0.43, 0, 0, 32)
GiamBtn.Font = Enum.Font.SourceSansBold; GiamBtn.Text = "GIẢM (-)"; GiamBtn.TextColor3 = Color3.fromRGB(255, 255, 255); GiamBtn.TextSize = 12
cG.CornerRadius = UDim.new(0, 5); cG.Parent = GiamBtn

TangBtn.Parent = MainFrame; TangBtn.BackgroundColor3 = Color3.fromRGB(20, 120, 20)
TangBtn.Position = UDim2.new(0.52, 0, 0, 45); TangBtn.Size = UDim2.new(0.43, 0, 0, 32)
TangBtn.Font = Enum.Font.SourceSansBold; TangBtn.Text = "TĂNG (+)"; TangBtn.TextColor3 = Color3.fromRGB(255, 255, 255); TangBtn.TextSize = 12
cT.CornerRadius = UDim.new(0, 5); cT.Parent = TangBtn

local SpeedTextLabel = Instance.new("TextLabel")
SpeedTextLabel.Parent = MainFrame
SpeedTextLabel.BackgroundTransparency = 1
SpeedTextLabel.Position = UDim2.new(0, 0, 0, 305)
SpeedTextLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedTextLabel.Font = Enum.Font.SourceSansBold
SpeedTextLabel.Text = "Cấp Tốc Độ Chạy: 1"
SpeedTextLabel.TextColor3 = Color3.fromRGB(0, 210, 100)
SpeedTextLabel.TextSize = 13

-- Hàm tính toán ép tốc độ thực tế dựa trên Cấp từ 1 - 50 [5, 6]
local function ApplySpeed()
    if SpeedLevel == 1 then
        ActualWalkSpeed = 16 -- Cấp 1 là tốc độ đi bộ bình thường [2]
    else
        -- Công thức tăng tiến đều: Cấp càng cao chạy càng nhanh (Tối đa Cấp 50 = Speed 310)
        ActualWalkSpeed = 16 + (SpeedLevel - 1) * 6 
    end
    SpeedTextLabel.Text = "Cấp Tốc Độ Chạy: " .. tostring(SpeedLevel)
end

GiamBtn.MouseButton1Click:Connect(function()
    if SpeedLevel > 1 then
        SpeedLevel = SpeedLevel - 1
        ApplySpeed()
    end
end)

TangBtn.MouseButton1Click:Connect(function()
    if SpeedLevel < 50 then
        SpeedLevel = SpeedLevel + 1
        ApplySpeed()
    end
end)

-- CÁC NÚT TÍNH NĂNG KHÁC Y CHANG ẢNH
createMenuButton("Hitbox 40: TẮT", 90, Color3.fromRGB(20, 110, 220), function(btn)
    HitboxActive = not HitboxActive
    btn.Text = HitboxActive and "Hitbox 40: BẬT" or "Hitbox 40: TẮT"
end)

createMenuButton("Noclip: TẮT", 132, Color3.fromRGB(40, 40, 40), function(btn)
    NoclipActive = not NoclipActive
    btn.Text = NoclipActive and "Noclip: BẬT" or "Noclip: TẮT"
end)

createMenuButton("Jump Infinity: TẮT", 174, Color3.fromRGB(20, 110, 220), function(btn)
    InfJumpActive = not InfJumpActive
    btn.Text = InfJumpActive and "Jump Infinity: BẬT" or "Jump Infinity: TẮT"
end)

createMenuButton("Nhận TP Tool VIP", 216, Color3.fromRGB(210, 110, 15), function()
    local tool = Instance.new("Tool")
    tool.Name = "⚡ TP Tool VIP"
    tool.RequiresHandle = false
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

createMenuButton("Auto Win: TẮT", 258, Color3.fromRGB(160, 20, 20), function(btn)
    AutoWinActive = not AutoWinActive
    btn.Text = AutoWinActive and "Auto Win: BẬT" or "Auto Win: TẮT"
end)

-- XỬ LÝ NHẢY VÔ HẠN
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfJumpActive and LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
        if h then h:ChangeState("Jumping") end
    end
end)

-- LUỒNG DUY TRÌ ỔN ĐỊNH TOÀN MENU
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                -- Khóa tốc độ chạy theo Cấp độ đã tính toán ở trên
                local h = char:FindFirstChildOfClass('Humanoid')
                if h and h.WalkSpeed ~= ActualWalkSpeed then h.WalkSpeed = ActualWalkSpeed end
                
                if NoclipActive then
                    for _, part in pairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
                
                if HitboxActive then
                    for _, v in pairs(workspace:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= LocalPlayer.Name then
                            v.HumanoidRootPart.Size = Vector3.new(40, 40, 40)
                            v.HumanoidRootPart.Transparency = 0.7
                            v.HumanoidRootPart.CanCollide = false
                        end
                    end
                end
                
                if AutoWinActive and tick() % 0.5 < 0.1 then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        for _, o in ipairs(workspace:GetDescendants()) do
                            if not AutoWinActive then break end
                            if o:IsA("BasePart") and (o.Name:lower():match("finish") or o.Name:lower():match("win") or o.Name:lower():match("top") or o.Name:lower():match("end") or o.Name:lower():match("checkpoint")) then
                                hrp.CFrame = o.CFrame + Vector3.new(0, 4, 0)
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
