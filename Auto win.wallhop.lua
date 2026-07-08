-- Khởi tạo Giao diện chính
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FinalInfinityMenu_FixedWin"
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Nút tròn MENU chính
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

-- Bảng chức năng
local MenuPanel = Instance.new("Frame")
local MenuCorner = Instance.new("UICorner")
local MenuTitle = Instance.new("TextLabel")

MenuPanel.Name = "MenuPanel"
MenuPanel.Parent = ScreenGui
MenuPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MenuPanel.Position = UDim2.new(0.15, 0, 0.35, 0)
MenuPanel.Size = UDim2.new(0, 200, 0, 280)
MenuPanel.Visible = false
MenuCorner.CornerRadius = UDim.new(0, 10)
MenuCorner.Parent = MenuPanel

MenuTitle.Name = "MenuTitle"
MenuTitle.Parent = MenuPanel
MenuTitle.BackgroundTransparency = 1
MenuTitle.Size = UDim2.new(1, 0, 0, 40)
MenuTitle.Font = Enum.Font.SourceSansBold
MenuTitle.Text = "INFINITY MENU"
MenuTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
MenuTitle.TextSize = 16

local function createButton(name, text, positionY)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    btn.Name = name
    btn.Parent = MenuPanel
    btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btn.Position = UDim2.new(0.1, 0, 0, positionY)
    btn.Size = UDim2.new(0, 160, 0, 38)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local ToggleVerticalButton = createButton("ToggleVerticalButton", "Auto Wall Hop", 45)
local ToggleESPButton = createButton("ToggleESPButton", "Player ESP", 90)
local ToggleInfJumpButton = createButton("ToggleInfJumpButton", "Infinity Jump", 135)
local ToggleNoClipButton = createButton("ToggleNoClipButton", "NoClip", 180)
local ToggleAutoWinButton = createButton("ToggleAutoWinButton", "Auto Win VIP", 225)

-- Trạng thái logic
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

local verticalEnabled, espEnabled, infJumpEnabled, noclipEnabled, autowinEnabled = false, false, false, false, false
local lastJumpTime = 0
local targetWinPart = nil

-- Kéo thả Menu
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

MainFrame.MouseButton1Click:Connect(function()
    MenuPanel.Visible = not MenuPanel.Visible
    if MenuPanel.Visible then
        MenuPanel.Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 70, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - 100)
    end
end)

-- Thao tác nút bấm
ToggleVerticalButton.MouseButton1Click:Connect(function()
    verticalEnabled = not verticalEnabled
    ToggleVerticalButton.Text = verticalEnabled and "Auto Wall Hop: ON" or "Auto Wall Hop: OFF"
    ToggleVerticalButton.BackgroundColor3 = verticalEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

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

ToggleInfJumpButton.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    ToggleInfJumpButton.Text = infJumpEnabled and "Infinity Jump: ON" or "Infinity Jump: OFF"
    ToggleInfJumpButton.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

ToggleNoClipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    ToggleNoClipButton.Text = noclipEnabled and "NoClip: ON" or "NoClip: OFF"
    ToggleNoClipButton.BackgroundColor3 = noclipEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

-- CẢI TIẾN: Thuật toán quét điểm Win thông minh đa mục tiêu khi bấm nút
ToggleAutoWinButton.MouseButton1Click:Connect(function()
    autowinEnabled = not autowinEnabled
    ToggleAutoWinButton.Text = autowinEnabled and "Auto Win: ON" or "Auto Win: OFF"
    ToggleAutoWinButton.BackgroundColor3 = autowinEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    
    if autowinEnabled then
        targetWinPart = nil
        pcall(function()
            -- Bước 1: Tìm kiếm theo từ khóa thông thường
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") or obj:IsA("SpawnLocation") then
                    local name = obj.Name:lower()
                    if name:find("win") or name:find("finish") or name:find("end") or name:find("trophy") or name:find("reward") then
                        targetWinPart = obj
                        break
                    end
                end
            end
            
            -- Bước 2: Nếu không thấy, tìm block xa/cao nhất so với điểm xuất phát (Dành cho game Obby/Speedrun)
            if not targetWinPart then
                local highestY = -99999
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj:IsA("BasePart") and obj.Position.Y > highestY and obj.CanCollide then
                        highestY = obj.Position.Y
                        targetWinPart = obj
                    end
                end
            end
        end)
    end
end)

local function findNearbyWall(rootPart, char)
    local isNear = false
    pcall(function()
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {char}
        params.FilterType = Enum.RaycastFilterType.Exclude
        local dirs = {rootPart.CFrame.LookVector, -rootPart.CFrame.LookVector, rootPart.CFrame.RightVector, -rootPart.CFrame.RightVector}
        for _, d in ipairs(dirs) do
            local res = workspace:Raycast(rootPart.Position, d * 2.8, params)
            if res and res.Instance and res.Instance.CanCollide then isNear = true break end
        end
    end)
    return isNear
end

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        pcall(function() local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    end
end)

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and not p.Character:FindFirstChild("HighlightESP") then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "HighlightESP"
                hl.FillColor, hl.FillTransparency, hl.OutlineColor = Color3.fromRGB(255,0,0), 0.5, Color3.fromRGB(255,255,255)
            end
        end
    end)
end)

-- Vòng lặp vật lý chính
RunService.Heartbeat:Connect(function()
    local char = player.Character if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    if noclipEnabled then
        pcall(function() for _, c in ipairs(char:GetChildren()) do if c:IsA("BasePart") then c.CanCollide = false end end end)
    end

    -- Thực hiện dịch chuyển đến vị trí Win đã tìm thấy
    if autowinEnabled and targetWinPart then
        pcall(function() 
            root.CFrame = targetWinPart.CFrame + Vector3.new(0, 4, 0) 
        end)
    end

    if verticalEnabled and findNearbyWall(root, char) then
        local now = tick()
        if now - lastJumpTime >= 0.35 then
            lastJumpTime = now
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 20, root.AssemblyLinearVelocity.Z) end)
        end
    end
end)
