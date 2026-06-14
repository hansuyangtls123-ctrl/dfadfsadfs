-- [Rivals] All Weapons + Skin UnlockAll - Optimized v4
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local CosmeticLibrary = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CosmeticLibrary", 10))
local DataController = require(player.PlayerScripts.Controllers:WaitForChild("PlayerDataController", 10))

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 620)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -310)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,60)
Title.BackgroundTransparency = 1
Title.Text = "🔓 Rivals UnlockAll"
Title.TextColor3 = Color3.fromRGB(255, 60, 60)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(1, -30, 0, 260)
LogFrame.Position = UDim2.new(0, 15, 0, 320)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
LogFrame.ScrollBarThickness = 8
LogFrame.Parent = MainFrame
Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0,8)

local UIList = Instance.new("UIListLayout", LogFrame)
UIList.Padding = UDim.new(0,5)

local function log(txt, color)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-10,0,22)
    l.BackgroundTransparency = 1
    l.Text = "• " .. txt
    l.TextColor3 = color or Color3.fromRGB(220,220,220)
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    l.Parent = LogFrame
    LogFrame.CanvasPosition = Vector2.new(0, LogFrame.AbsoluteCanvasSize.Y)
end

-- Remote 찾기 (Rivals에 맞게)
local equipRemote = nil
local function findRemote()
    log("Remote 탐색 중...", Color3.fromRGB(255,255,100))
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:find("Equip") or v.Name:find("Cosmetic") or v.Name:find("Weapon") or v.Name:find("Unlock")) then
            equipRemote = v
            log("Remote 발견: " .. v.Name, Color3.fromRGB(0,255,100))
            break
        end
    end
    if not equipRemote then
        log("Remote를 찾지 못함. 스크립트 허브 추천", Color3.fromRGB(255,100,100))
    end
end
findRemote()

local function tryUnlock(name, cType)
    if not equipRemote then return false end
    for i = 1, 6 do
        pcall(function()
            equipRemote:FireServer("AllWeapons", cType or "Skin", name, {})
            equipRemote:FireServer(name, cType or "Skin", name, {IsInverted = false})
            equipRemote:FireServer("Unlock", name)
        end)
        task.wait(0.11)
    end
    return true
end

-- 버튼
local weaponBtn = Instance.new("TextButton")
weaponBtn.Size = UDim2.new(0.9,0,0,60)
weaponBtn.Position = UDim2.new(0.05,0,0,80)
weaponBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
weaponBtn.Text = "모든 무기 Unlock"
weaponBtn.TextColor3 = Color3.new(1,1,1)
weaponBtn.TextSize = 16
weaponBtn.Font = Enum.Font.GothamBold
weaponBtn.Parent = MainFrame
Instance.new("UICorner", weaponBtn).CornerRadius = UDim.new(0,12)

local skinBtn = Instance.new("TextButton")
skinBtn.Size = UDim2.new(0.9,0,0,60)
skinBtn.Position = UDim2.new(0.05,0,0,160)
skinBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
skinBtn.Text = "모든 Skin Unlock"
skinBtn.TextColor3 = Color3.new(1,1,1)
skinBtn.TextSize = 16
skinBtn.Font = Enum.Font.GothamBold
skinBtn.Parent = MainFrame
Instance.new("UICorner", skinBtn).CornerRadius = UDim.new(0,12)

weaponBtn.MouseButton1Click:Connect(function()
    log("무기 Unlock 시작", Color3.fromRGB(100,200,255))
    task.spawn(function()
        local cnt = 0
        for name, _ in pairs(CosmeticLibrary.Cosmetics) do
            if name:find("Weapon") or name:find("Knife") or name:find("Gun") or name:find("Sword") then
                cnt += 1
                log("무기 시도: " .. name)
                tryUnlock(name, "Weapon")
                task.wait(0.2)
            end
        end
        log("무기 Unlock 완료 ("..cnt.."개 시도)", Color3.fromRGB(0,255,150))
    end)
end)

skinBtn.MouseButton1Click:Connect(function()
    log("Skin Unlock 시작", Color3.fromRGB(255,150,150))
    task.spawn(function()
        local cnt = 0
        for name, data in pairs(CosmeticLibrary.Cosmetics) do
            if data.Type == "Skin" and not name:lower():find("finisher") then
                cnt += 1
                log("Skin 시도: " .. name)
                tryUnlock(name, "Skin")
                task.wait(0.18)
            end
        end
        log("Skin Unlock 완료 ("..cnt.."개 시도)", Color3.fromRGB(0,255,150))
    end)
end)

log("Rivals UnlockAll 로드됨. 버튼을 눌러보세요.", Color3.fromRGB(255,255,100))
