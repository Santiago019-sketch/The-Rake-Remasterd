-- Load the Orion UI Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- Main Window
local Window = OrionLib:MakeWindow({
    Name = "Rake Remastered Ultimate V2",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RakeConfig"
})

-- Main Exploits Tab
local ExploitsTab = Window:MakeTab({
    Name = "Main Exploits",
    Icon = "rbxassetid://4483345998"
})

-- Points/Currency Section
local PointsSection = ExploitsTab:AddSection({
    Name = "Points & Currency"
})

PointsSection:AddToggle({
    Name = "Auto Points (Safe)",
    Default = false,
    Callback = function(Value)
        _G.AutoPoints = Value
        while _G.AutoPoints and task.wait(0.1) do
            pcall(function()
                ReplicatedStorage.RE:FireServer("PowerReward", 100)
                ReplicatedStorage.RE:FireServer("ScrapReward", math.random(50, 100))
            end)
        end
    end
})

PointsSection:AddButton({
    Name = "Instant 10k Points",
    Callback = function()
        for i = 1, 20 do
            pcall(function()
                ReplicatedStorage.RE:FireServer("PowerReward", 500)
                task.wait(0.1)
            end)
        end
    end
})

-- Item Spawner Section
local ItemSection = ExploitsTab:AddSection({
    Name = "Item Spawner"
})

local items = {
    "Flashlight",
    "MedKit",
    "Battery",
    "PowerBox",
    "Radio"
}

ItemSection:AddDropdown({
    Name = "Select Item",
    Default = "Flashlight",
    Options = items,
    Callback = function(Value)
        _G.SelectedItem = Value
    end
})

ItemSection:AddButton({
    Name = "Spawn Selected Item",
    Callback = function()
        if _G.SelectedItem then
            pcall(function()
                ReplicatedStorage.RE:FireServer("GiveItem", _G.SelectedItem)
            end)
        end
    end
})

-- Game Breaking Section
local GameSection = ExploitsTab:AddSection({
    Name = "Game Breaking"
})

GameSection:AddToggle({
    Name = "Break Rake AI",
    Default = false,
    Callback = function(Value)
        _G.BreakRake = Value
        while _G.BreakRake and task.wait() do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Rake" and v:FindFirstChild("HumanoidRootPart") then
                        v.HumanoidRootPart.Anchored = true
                    end
                end
            end)
        end
    end
})

GameSection:AddToggle({
    Name = "Instant Collect All Items",
    Default = false,
    Callback = function(Value)
        _G.InstantCollect = Value
        while _G.InstantCollect and task.wait() do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Scrap" or v.Name == "Power" or v:IsA("Tool") then
                        v.CFrame = Player.Character.HumanoidRootPart.CFrame
                    end
                end
            end)
        end
    end
})

-- Teleports Tab
local TeleportTab = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998"
})

-- Function to safely teleport
local function SafeTeleport(cf)
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Player.Character.HumanoidRootPart.CFrame = cf
    end
end

local locations = {
    ["Safe Spot"] = CFrame.new(0, 500, 0),
    ["Shop"] = CFrame.new(177, 19, 40),
    ["Power Station"] = CFrame.new(-165, 19, -76),
    ["Cave Entrance"] = CFrame.new(-152, 19, 141),
    ["Center Map"] = CFrame.new(0, 19, 0),
    ["Forest"] = CFrame.new(-100, 19, -100)
}

for name, cf in pairs(locations) do
    TeleportTab:AddButton({
        Name = "Teleport to " .. name,
        Callback = function()
            SafeTeleport(cf)
        end
    })
end

-- Player Mods Tab
local PlayerTab = Window:MakeTab({
    Name = "Player Mods",
    Icon = "rbxassetid://4483345998"
})

PlayerTab:AddToggle({
    Name = "Super Human",
    Default = false,
    Callback = function(Value)
        _G.SuperHuman = Value
        while _G.SuperHuman and task.wait() do
            pcall(function()
                Player.Character.Humanoid.WalkSpeed = 100
                Player.Character.Humanoid.JumpPower = 150
            end)
        end
    end
})

PlayerTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        _G.InfJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                Player.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end
})

PlayerTab:AddToggle({
    Name = "NoClip",
    Default = false,
    Callback = function(Value)
        _G.NoClip = Value
        game:GetService('RunService').Stepped:Connect(function()
            if _G.NoClip then
                pcall(function()
                    Player.Character.Humanoid:ChangeState(11)
                end)
            end
        end)
    end
})

-- Visual Tab
local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998"
})

VisualTab:AddToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").ClockTime = 14
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").ClockTime = 0
            game:GetService("Lighting").FogEnd = 500
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})

VisualTab:AddToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(Value)
        _G.ESP = Value
        while _G.ESP and task.wait() do
            pcall(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and not v.Character:FindFirstChild("ESP") then
                        local esp = Instance.new("BillboardGui")
                        esp.Name = "ESP"
                        esp.AlwaysOnTop = true
                        esp.Size = UDim2.new(0, 100, 0, 50)
                        esp.StudsOffset = Vector3.new(0, 3, 0)
                        
                        local text = Instance.new("TextLabel")
                        text.BackgroundTransparency = 1
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.Text = v.Name
                        text.TextColor3 = Color3.new(1, 0, 0)
                        text.TextStrokeTransparency = 0
                        text.Parent = esp
                        
                        esp.Parent = v.Character
                    end
                end
            end)
        end
        if not Value then
            for _, v in pairs(Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("ESP") then
                    v.Character.ESP:Destroy()
                end
            end
        end
    end
})

-- Protection/Safety Tab
local SafetyTab = Window:MakeTab({
    Name = "Protection",
    Icon = "rbxassetid://4483345998"
})

SafetyTab:AddToggle({
    Name = "Anti Rake",
    Default = false,
    Callback = function(Value)
        _G.AntiRake = Value
        while _G.AntiRake and task.wait() do
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "Rake" and v:FindFirstChild("HumanoidRootPart") then
                        local dist = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if dist <= 50 then
                            SafeTeleport(CFrame.new(0, 500, 0))
                            task.wait(1)
                        end
                    end
                end
            end)
        end
    end
})

SafetyTab:AddToggle({
    Name = "Auto Heal",
    Default = false,
    Callback = function(Value)
        _G.AutoHeal = Value
        while _G.AutoHeal and task.wait() do
            pcall(function()
                if Player.Character.Humanoid.Health < Player.Character.Humanoid.MaxHealth then
                    ReplicatedStorage.RE:FireServer("UseItem", "MedKit")
                end
            end)
        end
    end
})

-- Credits Tab
local CreditsTab = Window:MakeTab({
    Name = "Credits",
    Icon = "rbxassetid://4483345998"
})

CreditsTab:AddParagraph("Credits", "Made by Assistant\nUpdated: January 2025\nVersion 2.0")

-- Initialization
OrionLib:MakeNotification({
    Name = "Script Loaded",
    Content = "Ultimate Rake Remastered script is ready!",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Anti Cheat Bypass
RunService.Heartbeat:Connect(function()
    pcall(function()
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)

-- Clean up
Player.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        OrionLib:Destroy()
    end
end)
