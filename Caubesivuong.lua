--[[
    WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
    Đã tích hợp Menu đóng/mở, God Mode, Infinite Jump, Noclip và ESP bởi AI.
]]

local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")
local MainFrame = Instance.new("Frame")
local FrameCorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")

-- Khởi tạo các nút bấm chức năng
local GodButton = Instance.new("TextButton")
local GodCorner = Instance.new("UICorner")

local JumpButton = Instance.new("TextButton")
local JumpCorner = Instance.new("UICorner")

local NoclipButton = Instance.new("TextButton")
local NoclipCorner = Instance.new("UICorner")

local EspButton = Instance.new("TextButton")
local EspCorner = Instance.new("UICorner")

-- 1. Khởi tạo GUI cơ bản
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- 2. Cấu hình Nút Tròn (Dùng để Đóng/Mở Menu)
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Image = "rbxassetid://6031094678" -- Biểu tượng hình khiên
ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

-- 3. Cấu hình Bảng Menu Chính (Tăng chiều cao lên 300 để chứa đủ nút)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

FrameCorner.CornerRadius = UDim.new(0, 10)
FrameCorner.Parent = MainFrame

-- Tiêu đề Menu
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "HACK MENU COMPACT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Hàm phụ tạo nút nhanh
local function setupButton(btn, corner, text, posIndex)
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(192, 57, 43) -- Đỏ mặc định khi chưa bật
    btn.Position = UDim2.new(0.1, 0, 0.16 + (posIndex * 0.18), 0)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
end

-- Thiết lập giao diện cho cả 4 nút
setupButton(GodButton, GodCorner, "BẬT GOD MODE", 0)
setupButton(JumpButton, JumpCorner, "BẬT JUMP INFINITY", 1)
setupButton(NoclipButton, NoclipCorner, "BẬT NOCLIP", 2)
setupButton(EspButton, EspCorner, "BẬT ESP (XUYÊN TƯỜNG)", 3)

-- ==================== LOGIC HOẠT ĐỘNG ====================

local godActivated = false
local jumpEnabled = false
local noclipEnabled = false
local espEnabled = false

-- Hàm hỗ trợ tìm kiếm và ẩn/hiện bảng đen của script God gốc
local function setGodGuiVisible(visible)
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and (gui:FindFirstChild("MainFrame") or gui:FindFirstChild("Frame") or gui:FindFirstChild("God Mode Script Universal")) then
            gui.Enabled = visible
        end
    end
    for _, gui in pairs(game.Players.LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
        if gui:IsA("ScreenGui") and gui ~= ScreenGui and (gui:FindFirstChild("MainFrame") or gui:FindFirstChild("Frame")) then
            gui.Enabled = visible
        end
    end
end

-- 1. Logic Đóng/Mở Menu bằng nút tròn (Đồng bộ tắt bảng gốc)
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    
    if MainFrame.Visible then
        ToggleButton.ImageColor3 = Color3.fromRGB(46, 204, 113) -- Xanh lá khi mở
        setGodGuiVisible(true)
    else
        ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255) -- Trắng khi đóng
        setGodGuiVisible(false)
    end
end)

-- 2. Logic God Mode (Không hỗ trợ tắt)
GodButton.MouseButton1Click:Connect(function()
    if not godActivated then
        godActivated = true
        GodButton.Text = "GOD MODE: ĐÃ BẬT"
        GodButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        
        task.spawn(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
        end)
    end
end)

-- 3. Logic Infinite Jump
JumpButton.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        JumpButton.Text = "JUMP INFINITY: ĐÃ BẬT"
        JumpButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        JumpButton.Text = "BẬT JUMP INFINITY"
        JumpButton.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if jumpEnabled then
        local player = game.Players.LocalPlayer
        if player and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- 4. Logic Noclip (Đi xuyên tường)
NoclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        NoclipButton.Text = "NOCLIP: ĐÃ BẬT"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        NoclipButton.Text = "BẬT NOCLIP"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 5. Logic ESP Box (Nhìn xuyên tường người chơi)
local function createEsp(player)
    if player == game.Players.LocalPlayer then return end
    
    local function applyHighlight(character)
        if not character then return end
        -- Kiểm tra xem nhân vật đã bị cài Highlight chưa để tránh trùng lặp
        if not character:FindFirstChild("EspHighlight") then
            local highlight = Instance.new("Highlight")
            highlight.Name = "EspHighlight"
            highlight.Parent = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Màu đỏ trong suốt
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
            highlight.OutlineTransparency = 0
            highlight.Enabled = espEnabled
        end
    end
    
    applyHighlight(player.Character)
    player.CharacterAdded:Connect(applyHighlight)
end

-- Đăng ký ESP cho tất cả người chơi cũ và mới tham gia phòng
for _, player in pairs(game.Players:GetPlayers()) do createEsp(player) end
game.Players.PlayerAdded:Connect(createEsp)

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspButton.Text = "ESP: ĐÃ BẬT"
        EspButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    else
        EspButton.Text = "BẬT ESP (XUYÊN TƯỜNG)"
        EspButton.BackgroundColor3 = Color3.fromRGB(192, 57, 43)
    end
    
    -- Cập nhật trạng thái hiển thị của các khung ESP theo thời gian thực
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("EspHighlight")
            if highlight then highlight.Enabled = espEnabled end
        end
    end
end)
