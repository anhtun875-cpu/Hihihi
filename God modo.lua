-- [[ GIỮ NGUYÊN 100% CẤU TRÚC SCRIPT BẤT TỬ HOÀN HẢO TỪ GITHUB ]] --
loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()

-- [[ BỔ SUNG MENU ĐIỀU KHIỂN ĐA CHỨC NĂNG DÀNH CHO ĐIỆN THOẠI ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local ScrollingFrame = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")

ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Nút Thu Nhỏ / Mở Lại Menu Tổng
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.Position = UDim2.new(0, 10, 0, 200)
ToggleButton.Size = UDim2.new(0, 60, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 0, 90)
ToggleButton.Text = "HACK"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 13
local UICorner_Toggle = Instance.new("UICorner")
UICorner_Toggle.CornerRadius = UDim.new(0, 8)
UICorner_Toggle.Parent = ToggleButton

-- Khung Menu Chính (Mở rộng chiều cao lên 240 để chứa đủ các nút)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 240)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
MainFrame.Active = true
MainFrame.Draggable = true 
local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 12)
UICorner_Main.Parent = MainFrame

-- Tiêu đề Menu
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 20, 60)
Title.Text = "Multi Hack v2.727"
Title.TextColor3 = Color3.fromRGB(200, 100, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
local UICorner_Title = Instance.new("UICorner")
UICorner_Title.CornerRadius = UDim.new(0, 12)
UICorner_Title.Parent = Title

-- Khung cuộn chứa các nút bấm (Giúp thao tác mượt trên màn hình dọc cảm ứng)
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollingFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 210)
ScrollingFrame.ScrollBarThickness = 2

UIListLayout.Parent = ScrollingFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- Hàm khởi tạo nhanh các nút bấm cùng phong cách
local function CreateMenuButton(text, layoutOrder)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.LayoutOrder = layoutOrder
    btn.Parent = ScrollingFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    return btn
end

local HitboxBtn = CreateMenuButton("Hitbox 45: TẮT", 1)
local InfJumpBtn = CreateMenuButton("Nhảy Vô Hạn: TẮT", 2)
local NoclipBtn = CreateMenuButton("Đi Xuyên Tường: TẮT", 3)
local EspBtn = CreateMenuButton("Định Vị (ESP): TẮT", 4)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- KHỞI TẠO CÁC BIẾN HOẠT ĐỘNG
local HitboxActive = false
local InfJumpActive = false
local NoclipActive = false
local EspActive = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. LOGIC ĐIỀU KHIỂN HITBOX 45
HitboxBtn.MouseButton1Click:Connect(function()
    HitboxActive = not HitboxActive
    if HitboxActive then
        HitboxBtn.Text = "Hitbox 45: BẬT"
        HitboxBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.spawn(function()
            while HitboxActive do
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local root = player.Character.HumanoidRootPart
                        root.Size = Vector3.new(45, 45, 45)
                        root.CanCollide = false            
                        root.Transparency = 0.7            
                        root.Material = Enum.Material.Neon 
                        root.Color = Color3.fromRGB(255, 0, 0) 
                    end
                end
                task.wait(0.5) 
            end
        end)
    else
        HitboxBtn.Text = "Hitbox 45: TẮT"
        HitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                root.Size = Vector3.new(2, 2, 1) 
                root.Transparency = 1            
                root.CanCollide = true
            end
        end
    end
end)

-- 2. LOGIC JUMP INFINITY (NHẢY VÔ HẠN)
UserInputService.JumpRequest:Connect(function()
    if InfJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

InfJumpBtn.MouseButton1Click:Connect(function()
    InfJumpActive = not InfJumpActive
    if InfJumpActive then
        InfJumpBtn.Text = "Nhảy Vô Hạn: BẬT"
        InfJumpBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        InfJumpBtn.Text = "Nhảy Vô Hạn: TẮT"
        InfJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 3. LOGIC NOCLIP (ĐI XUYÊN TƯỜNG)
RunService.Stepped:Connect(function()
    if NoclipActive and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    NoclipActive = not NoclipActive
    if NoclipActive then
        NoclipBtn.Text = "Đi Xuyên Tường: BẬT"
        NoclipBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        NoclipBtn.Text = "Đi Xuyên Tường: TẮT"
        NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- 4. LOGIC ESP XUYÊN TƯỜNG (HIGHLIGHT CHUẨN ENGINE)
local function ApplyHighlight(player)
    if player == LocalPlayer then return end
    local function CreateGlow(character)
        if character:FindFirstChild("CustomEspGlow") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "CustomEspGlow"
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Enabled = EspActive
        highlight.Parent = character
    end
    if player.Character then CreateGlow(player.Character) end
    player.CharacterAdded:Connect(CreateGlow)
end

for _, player in pairs(Players:GetPlayers()) do ApplyHighlight(player) end
Players.PlayerAdded:Connect(ApplyHighlight)

EspBtn.MouseButton1Click:Connect(function()
    EspActive = not EspActive
    if EspActive then
        EspBtn.Text = "Định Vị (ESP): BẬT"
        EspBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
    else
        EspBtn.Text = "Định Vị (ESP): TẮT"
        EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("CustomEspGlow") then
            player.Character.CustomEspGlow.Enabled = EspActive
        end
    end
end)
