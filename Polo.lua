-- Tối ưu hóa biến toàn cục để tăng tốc độ thực thi
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Biến lưu trữ sự kiện kết nối
local jumpConnection

-- Hàm thiết lập Nhảy vô hạn an toàn
local function enableInfiniteJump()
    if jumpConnection then jumpConnection:Disconnect() end

    jumpConnection = UserInputService.JumpRequest:Connect(function()
        pcall(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    end)
end

-- Hàm tạo và cấp vật phẩm TP Tool (Hoạt động trên mọi tựa game)
local function giveTpTool()
    pcall(function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if backpack and not backpack:FindFirstChild("Teleport Tool") and not LocalPlayer.Character:FindFirstChild("Teleport Tool") then
            local tool = Instance.new("Tool")
            tool.Name = "Teleport Tool"
            tool.RequiresHandle = false
            
            tool.Activated:Connect(function()
                local mouse = LocalPlayer:GetMouse()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") and mouse.Hit then
                    -- Dịch chuyển nhân vật đến vị trí con trỏ chuột/vị trí nhấn màn hình
                    character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end)
            
            tool.Parent = backpack
        end
    end)
end

-- Kích hoạt ngay lập tức khi chạy script
enableInfiniteJump()
giveTpTool()

-- Tự động kích hoạt lại và cấp lại TP Tool khi nhân vật reset/hồi sinh
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    enableInfiniteJump()
    giveTpTool()
end)

-- Chạy script gốc an toàn và vô hiệu hóa cơ chế quét click của Auto Shoot cũ
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/polo242c/mvs/main/mvs"))()
end)
