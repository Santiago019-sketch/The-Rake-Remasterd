-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Variables
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/sol"))()

-- Main Window
local Window = Library:New("Rake Remastered Ultimate")

-- Combat Tab
local CombatTab = Window:Tab("Combat")
local CombatMain = CombatTab:Folder("Combat")

CombatMain:Toggle("Kill Aura", function(bool)
    _G.KillAura = bool
    while _G.KillAura and wait(0.1) do
        local char = Player.Character
        if char then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Rake" and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist <= 15 then
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            tool:Activate()
                            for i = 1, 5 do
                                firetouchinterest(tool.Handle, v.HumanoidRootPart, 0)
                                firetouchinterest(tool.Handle, v.HumanoidRootPart, 1)
                                wait()
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Movement Tab
local MovementTab = Window:Tab("Movement")
local MovementMain = MovementTab:Folder("Movement")

MovementMain:Toggle("Speed Hack", function(bool)
    _G.SpeedHack = bool
    local char = Player.Character or Player.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    
    if bool then
        hum.WalkSpeed = 50
    else
        hum.WalkSpeed = 16
    end
end)

MovementMain:Toggle("Infinite Jump", function(bool)
    _G.InfiniteJump = bool
    local connection
    
    if bool then
        connection = UserInputService.JumpRequest:Connect(function()
            local char = Player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end)

-- Visuals Tab
local VisualsTab = Window:Tab("Visuals")
local VisualsMain = VisualsTab:Folder("ESP")

-- Advanced ESP System
local function CreateESP(part, text, color)
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "ESP"
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 100, 0, 50)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Text = text
    TextLabel.TextColor3 = color or Color3.new(1, 0, 0)
    TextLabel.TextStrokeTransparency = 0
    TextLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    TextLabel.Parent = BillboardGui
    
    BillboardGui.Parent = part
    return BillboardGui
end

VisualsMain:Toggle("Player ESP", function(bool)
    _G.PlayerESP = bool
    while _G.PlayerESP and wait(1) do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not plr.Character.HumanoidRootPart:FindFirstChild("ESP") then
                    CreateESP(plr.Character.HumanoidRootPart, plr.Name, Color3.new(0, 1, 0))
                end
            end
        end
    end
    
    if not bool then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local esp = plr.Character:FindFirstChild("ESP", true)
                if esp then esp:Destroy() end
            end
        end
    end
end)

VisualsMain:Toggle("Scrap ESP", function(bool)
    _G.ScrapESP = bool
    while _G.ScrapESP and wait(1) do
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "Scrap" and not v:FindFirstChild("ESP") then
                CreateESP(v, "Scrap [" .. math.floor((Player.Character.HumanoidRootPart.Position - v.Position).Magnitude) .. " studs]", Color3.new(1, 1, 0))
            end
        end
    end
    
    if not bool then
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "Scrap" then
                local esp = v:FindFirstChild("ESP")
                if esp then esp:Destroy() end
            end
        end
    end
end)

-- Utility Tab
local UtilityTab = Window:Tab("Utility")
local UtilityMain = UtilityTab:Folder("Auto Farm")

UtilityMain:Toggle("Auto Collect Scraps", function(bool)
    _G.AutoCollect = bool
    while _G.AutoCollect and wait() do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Scrap" then
                    local dist = (char.HumanoidRootPart.Position - v.Position).Magnitude
                    if dist <= 20 then
                        char.HumanoidRootPart.CFrame = CFrame.new(v.Position)
                        wait(0.1)
                        firetouchinterest(char.HumanoidRootPart, v, 0)
                        firetouchinterest(char.HumanoidRootPart, v, 1)
                    end
                end
            end
        end
    end
end)

-- Safe Mode
UtilityMain:Toggle("Safe Mode", function(bool)
    _G.SafeMode = bool
    while _G.SafeMode and wait(0.1) do
        local char = Player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Rake" and v:FindFirstChild("HumanoidRootPart") then
                    local dist = (char.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if dist <= 50 then
                        local safeSpot = workspace:FindFirstChild("SafeSpot") or Instance.new("Part")
                        if not workspace:FindFirstChild("SafeSpot") then
                            safeSpot.Name = "SafeSpot"
                            safeSpot.Anchored = true
                            safeSpot.Size = Vector3.new(10, 1, 10)
                            safeSpot.Position = Vector3.new(0, 500, 0)
                            safeSpot.Parent = workspace
                        end
                        char.HumanoidRootPart.CFrame = CFrame.new(safeSpot.Position + Vector3.new(0, 3, 0))
                    end
                end
            end
        end
    end
end)

-- Settings Tab
local SettingsTab = Window:Tab("Settings")
local SettingsMain = SettingsTab:Folder("Game Settings")

SettingsMain:Button("Full Bright", function()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

SettingsMain:Button("Reset Character", function()
    local char = Player.Character
    if char then
        char:BreakJoints()
    end
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Character Added Handler
Player.CharacterAdded:Connect(function(char)
    if _G.SpeedHack then
        local hum = char:WaitForChild("Humanoid")
        hum.WalkSpeed = 50
    end
end)
