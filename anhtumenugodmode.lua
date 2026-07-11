-- [[ LUỒNG 1: KHỞI CHẠY KHUNG ĐIỀU KHIỂN ★ ANH TÚ MENU ★ ]] --
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/anhtun875-cpu/Hihihi/refs/heads/main/Anhtudzscrips.lua"))()
    end)
    if not success then
        warn("Lỗi tải Anh Tú Menu: ", err)
    end
end)

-- [[ LUỒNG 2: KHỞI CHẠY BẢNG ĐEN GOD MODE SCRIPT UNIVERSAL ]] --
task.spawn(function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Rawbr10/Roblox-Scripts/refs/heads/main/God%20Mode%20Script%20Universal"))()
    end)
    if not success then
        warn("Lỗi tải God Mode Universal: ", err)
    end
end)

-- Thông báo xác nhận hệ thống trộn lệnh thành công
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Delta X v2.727",
    Text = "⚙️ Đã đồng bộ thành công Anh Tú Menu & God Mode!",
    Duration = 5
})
