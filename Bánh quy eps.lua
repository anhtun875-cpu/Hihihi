-- =======================================================
-- SCRIPT TỐI ƯU: NOCLIP & INF JUMP TỰ KÍCH HOẠT CHẠY NGẦM
-- MENU CHỈ GIỮ LẠI ĐIỀU KHIỂN TIA X-RAY ESP COOKIES/KEYS
-- HỖ TRỢ DELTA EXECUTOR MOBILE (v2.727)
-- =======================================================

local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- 1. XÓA GIAO DIỆN CŨ ĐỂ TRÁNH TRÙNG LẶP NÚT BẤM
if CoreGui:FindFirstChild("Delta_ESP_Menu") then
    CoreGui:FindFirstChild("Delta_ESP_Menu"):Destroy()
end

-- 2. CẤU HÌNH MÀU SẮC ĐỂ HIỂN THỊ XUYÊN TƯỜNG
local MAU_BANH_QUY = Color3.fromRGB(139, 0, 0)   -- Đỏ đậm
local MAU_CHIA_KHOA = Color3.fromRGB(255, 215, 0) -- Vàng

-- Trạng thái bật/tắt mặc định của tia ESP
local ESP_BanhQuy_Bat = true
local ESP_ChiaKhoa_Bat = true

-- =======================================================
-- [TỰ ĐỘNG KÍCH HOẠT 1]: NOCLIP XUYÊN TƯỜNG CHẠY NGẦM
-- =======================================================
RunService.Stepped:Connect(function()
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                part.CanCollide = false
            end
        end
    end
end)

-- =======================================================
-- [TỰ ĐỘNG KÍCH HOẠT 2]: JUMP INFINITY NHẢY VÔ HẠN CHẠY NGẦM
-- =======================================================
UserInputService.JumpRequest:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 3. KHỞI TẠO MENU THU GỌN (CHỈ CHỨA NÚT BẬT/TẮT ESP)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Delta_ESP_Menu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- NÚT TRÒN ĐÓNG/MỞ MENU CHÍNH
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Text = "MENU"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 25)
ToggleCorner.Parent = ToggleButton

-- KHUNG MENU CHÍNH (Đã thu gọn chiều cao xuống 150)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 220, 0, 150)
MainFrame.Position = UDim2.new(0.35, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- TIÊU ĐỀ MENU
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleLabel.Text = "ESP ITEM CONTROL"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleLabel

-- Hàm phụ tạo nút bấm
local function taoNutBam(text, yPos, color, parent)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 180, 0, 35)
    button.Position = UDim2.new(0, 20, 0, yPos)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Font = Enum.Font.SourceSansBold
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    return button
end

-- Tạo 2 nút chức năng ESP trên Giao diện
local CookieButton = taoNutBam("ESP Bánh Quy: BẬT", 50, Color3.fromRGB(139, 0, 0), MainFrame)
local KeyButton = taoNutBam("ESP Chìa Khóa: BẬT", 95, Color3.fromRGB(200, 160, 0), MainFrame)

-- Hỗ trợ giữ chuột/chạm để kéo thả nút MENU di chuyển trên điện thoại
local Dragging, DragInput, DragStart, StartPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true; DragStart = input.Position; StartPos = ToggleButton.Position
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        ToggleButton.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
end)

ToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- =======================================================
-- LOGIC QUÉT VÀ HIỂN THỊ ESP XUYÊN TƯỜNG
-- =======================================================
local function xoaESP(vatPham)
    if vatPham:FindFirstChild("DeltaESP_Highlight") then vatPham.DeltaESP_Highlight:Destroy() end
    if vatPham:FindFirstChild("DeltaESP_NameTag") then vatPham.DeltaESP_NameTag:Destroy() end
end

local function taoHieuUngESP(vatPham, mauSac, tenVatPham)
    if vatPham:FindFirstChild("DeltaESP_Highlight") then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "DeltaESP_Highlight"
    highlight.FillColor = mauSac
    highlight.FillTransparency = 0.35
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.1
    highlight.Adornee = vatPham
    highlight.Parent = vatPham

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DeltaESP_NameTag"
    billboard.Size = UDim2.new(0, 120, 0, 35)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = tenVatPham
    textLabel.TextColor3 = mauSac
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Parent = billboard
    
    billboard.Parent = vatPham
end

local function kiemTraVaApDung(obj)
    if obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("MeshPart") then
        local tenGoc = string.lower(obj.Name)
        if string.find(tenGoc, "cookie") or string.find(tenGoc, "banh") or string.find(tenGoc, "bánh") then
            if ESP_BanhQuy_Bat then taoHieuUngESP(obj, MAU_BANH_QUY, "Bánh Quy 🍪") else xoaESP(obj) end
        elseif string.find(tenGoc, "key") or string.find(tenGoc, "chia") or string.find(tenGoc, "chìa") then
            if ESP_ChiaKhoa_Bat then taoHieuUngESP(obj, MAU_CHIA_KHOA, "Chìa Khóa 🔑") else xoaESP(obj) end
        end
    end
end

local function quatToanBoBanDo()
    for _, obj in pairs(Workspace:GetDescendants()) do kiemTraVaApDung(obj) end
end

-- SỰ KIỆN TƯƠNG TÁC NÚT BẤM TRÊN MENU
CookieButton.MouseButton1Click:Connect(function()
    ESP_BanhQuy_Bat = not ESP_BanhQuy_Bat
    CookieButton.Text = ESP_BanhQuy_Bat and "ESP Bánh Quy: BẬT" or "ESP Bánh Quy: TẮT"
    CookieButton.BackgroundColor3 = ESP_BanhQuy_Bat and Color3.fromRGB(139, 0, 0) or Color3.fromRGB(70, 70, 70)
    if not ESP_BanhQuy_Bat then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if string.find(string.lower(obj.Name), "cookie") or string.find(string.lower(obj.Name), "banh") then xoaESP(obj) end
        end
    end
    quatToanBoBanDo()
end)

KeyButton.MouseButton1Click:Connect(function()
    ESP_ChiaKhoa_Bat = not ESP_ChiaKhoa_Bat
    KeyButton.Text = ESP_ChiaKhoa_Bat and "ESP Chìa Khóa: BẬT" or "ESP Chìa Khóa: TẮT"
    KeyButton.BackgroundColor3 = ESP_ChiaKhoa_Bat and Color3.fromRGB(200, 160, 0) or Color3.fromRGB(70, 70, 70)
    if not ESP_ChiaKhoa_Bat then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if string.find(string.lower(obj.Name), "key") or string.find(string.lower(obj.Name), "chia") then xoaESP(obj) end
        end
    end
    quatToanBoBanDo()
end)

-- Khởi chạy hệ thống vòng lặp tự động cập nhật phòng chơi
quatToanBoBanDo()
Workspace.DescendantAdded:Connect(function(newObj)
    task.wait(0.2)
    if newObj and newObj.Parent then kiemTraVaApDung(newObj) end
end)
