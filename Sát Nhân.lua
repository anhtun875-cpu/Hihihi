-- Roblox Suspect/Murder Game ESP (Full ESP: Murderer, Innocent, Dead Body)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local DetectorEnabled = false

-- --- TẠO GIAO DIỆN MENU (UI) ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MurderDetectorGui"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14
ToggleBtn.Text = "Mở Menu"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130)
MainFrame.Position = UDim2.new(0.05, 0, 0.27, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Corner:Clone()
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "[⚡] MENU QUAN SÁT TỔNG HỢP"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local FuncBtn = Instance.new("TextButton")
FuncBtn.Size = UDim2.new(0, 180, 0, 45)
FuncBtn.Position = UDim2.new(0.5, -90, 0.5, -10)
FuncBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FuncBtn.Text = "Hệ Thống ESP: TẮT"
FuncBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FuncBtn.TextSize = 16
FuncBtn.Font = Enum.Font.SourceSansBold
FuncBtn.Parent = MainFrame

local FuncCorner = Corner:Clone()
FuncCorner.Parent = FuncBtn

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "Đóng Menu" or "Mở Menu"
end)

-- Hàm dọn sạch mọi hiệu ứng vẽ màu trên bản đồ
local function ClearAllESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild("GameHighlight")
            if hl then hl:Destroy() end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:FindFirstChild("GameTag") then hrp.GameTag:Destroy() end
        end
    end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "DeadBodyCorpse" or obj:FindFirstChild("DeadBodyTag") or obj:FindFirstChild("DeadBodyHighlight") then
            local hl = obj:FindFirstChild("DeadBodyHighlight") or obj:FindFirstChildOfClass("Highlight")
            if hl then hl:Destroy() end
            local tag = obj:FindFirstChild("DeadBodyTag") or obj:FindFirstChildOfClass("BillboardGui")
            if tag then tag:Destroy() end
        end
    end
end

FuncBtn.MouseButton1Click:Connect(function()
    DetectorEnabled = not DetectorEnabled
    if DetectorEnabled then
        FuncBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        FuncBtn.Text = "Hệ Thống ESP: BẬT"
    else
        FuncBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        FuncBtn.Text = "Hệ Thống ESP: TẮT"
        ClearAllESP()
    end
end)

local function isKnife(toolName)
    local nameLower = string.lower(toolName)
    return string.find(nameLower, "knife") or string.find(nameLower, "dao") or string.find(nameLower, "sword")
end

-- --- LOGIC ESP CHÍNH (CHẠY LIÊN TỤC VÒNG LẶP GAME) ---
RunService.Heartbeat:Connect(function()
    if not DetectorEnabled then return end

    -- 1. QUÉT NGƯỜI CÒN SỐNG (SÁT NHÂN VS DÂN THƯỜNG)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local hasKnife = false

            -- Kiểm tra túi đồ hoặc tay cầm để tìm dao
            local heldTool = char:FindFirstChildOfClass("Tool")
            if heldTool and isKnife(heldTool.Name) then hasKnife = true end
            if not hasKnife and player:FindFirstChild("Backpack") then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and isKnife(tool.Name) then hasKnife = true break end
                end
            end

            -- Thiết lập màu sắc & kích thước chữ theo vai trò
            local color, tagText, tagSize
            if hasKnife then
                color = Color3.fromRGB(150, 0, 0) -- Đỏ đậm cho Sát nhân
                tagText = "🛑 " .. player.Name .. " (SÁT NHÂN!)"
                tagSize = 30 -- Chữ siêu to bự
            else
                color = Color3.fromRGB(0, 180, 0) -- Xanh lá cho Người sống
                tagText = "👤 " .. player.Name
                tagSize = 16 -- Chữ bình thường
            end

            -- Áp dụng hiệu ứng đổi màu cơ thể (Highlight)
            local highlight = char:FindFirstChild("GameHighlight")
            if not highlight then
                highlight = Instance.new("Highlight")
                highlight.Name = "GameHighlight"
                highlight.OutlineTransparency = 0
                highlight.FillTransparency = 0.2
                highlight.Adornee = char
                highlight.Parent = char
            end
            highlight.FillColor = color
            highlight.OutlineColor = hasKnife and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)

            -- Áp dụng hiệu ứng nhãn tên trên đầu
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local tag = hrp:FindFirstChild("GameTag")
                if not tag then
                    tag = Instance.new("BillboardGui")
                    tag.Name = "GameTag"
                    tag.AlwaysOnTop = true
                    tag.StudsOffset = Vector3.new(0, 4.5, 0)
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Font = Enum.Font.SourceSansBold
                    label.TextStrokeTransparency = 0
                    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    label.Parent = tag
                    tag.Parent = hrp
                end
                tag.Size = UDim2.new(0, tagSize * 8, 0, 50)
                tag.TextLabel.Text = tagText
                tag.TextLabel.TextColor3 = hasKnife and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                tag.TextLabel.TextSize = tagSize
            end
        end
    end

    -- 2. QUÉT XÁC NGƯỜI CHẾT TRÊN BẢN ĐỒ (Cơ chế vạn năng)
    -- Tìm trong Workspace các mô hình nhân vật bị gục hoặc các Object Ragdoll rơi ra
    for _, obj in pairs(Workspace:GetChildren()) do
        -- Nhận diện dựa trên cấu trúc hình thể thông thường của xác chết trong Roblox
        if (obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health <= 0 and obj ~= LocalPlayer.Character) 
        or (obj:IsA("Model") and string.find(string.lower(obj.Name), "corpse") or string.find(string.lower(obj.Name), "dead") or string.find(string.lower(obj.Name), "ragdoll")) then
            
            -- Đánh dấu xác chết bằng Màu Xanh Biển (Blue)
            local bodyHighlight = obj:FindFirstChild("DeadBodyHighlight")
            if not bodyHighlight then
                bodyHighlight = Instance.new("Highlight")
                bodyHighlight.Name = "DeadBodyHighlight"
                bodyHighlight.FillColor = Color3.fromRGB(0, 50, 180) -- Xanh biển đậm
                bodyHighlight.OutlineColor = Color3.fromRGB(0, 150, 255) -- Viền xanh biển sáng
                bodyHighlight.FillTransparency = 0.2
                bodyHighlight.OutlineTransparency = 0
                bodyHighlight.Adornee = obj
                bodyHighlight.Parent = obj
            end

            -- Tạo chữ hiển thị vị trí xác chết xuyên tường
            local targetPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso") or obj:FindFirstChild("UpperTorso") or obj:FindFirstChildOfClass("Part")
            if targetPart and not targetPart:FindFirstChild("DeadBodyTag") then
                local deadTag = Instance.new("BillboardGui")
                deadTag.Name = "DeadBodyTag"
                deadTag.Size = UDim2.new(0, 150, 0, 40)
                deadTag.AlwaysOnTop = true
                deadTag.StudsOffset = Vector3.new(0, 3, 0)

                local deadLabel = Instance.new("TextLabel")
                deadLabel.Size = UDim2.new(1, 0, 1, 0)
                deadLabel.BackgroundTransparency = 1
                deadLabel.Text = "💀 XÁC NGƯỜI CHẾT"
                deadLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
                deadLabel.TextSize = 16
                deadLabel.Font = Enum.Font.SourceSansBold
                deadLabel.TextStrokeTransparency = 0
                deadLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                deadLabel.Parent = deadTag
                deadTag.Parent = targetPart
            end
        end
    end
end)
