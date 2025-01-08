local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/sol"))()

-- Create main window
local main = library:New("Rake Remastered Helper")

-- Player Section
local playerSection = main:Tab("Player")

-- Basic Movement Settings
local movementFolder = playerSection:Folder("Movement")

movementFolder:Toggle("Speed Boost", function(enabled)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if enabled then
        character.Humanoid.WalkSpeed = 50
    else
        character.Humanoid.WalkSpeed = 16
    end
end)

movementFolder:Toggle("Jump Boost", function(enabled)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    if enabled then
        character.Humanoid.JumpPower = 100
    else
        character.Humanoid.JumpPower = 50
    end
end)

-- Visuals Section
local visualsFolder = playerSection:Folder("Visuals")

visualsFolder:Toggle("Night Vision", function(enabled)
    local lighting = game:GetService("Lighting")
    
    if enabled then
        lighting.Brightness = 3
        lighting.Ambient = Color3.new(1, 1, 1)
    else
        lighting.Brightness = 0
        lighting.Ambient = Color3.new(0, 0, 0)
    end
end)

visualsFolder:Toggle("ESP", function(enabled)
    local function createESP(part)
        local esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.AlwaysOnTop = true
        esp.Size = UDim2.new(0, 50, 0, 50)
        esp.StudsOffset = Vector3.new(0, 2, 0)
        
        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.new(1, 0, 0)
        label.TextScaled = true
        label.Parent = esp
        
        return esp
    end
    
    if enabled then
        -- ESP for Scraps
        for _, scrap in pairs(workspace:GetChildren()) do
            if scrap.Name == "Scrap" and not scrap:FindFirstChild("ESP") then
                local esp = createESP(scrap)
                esp.Parent = scrap
                esp.TextLabel.Text = "Scrap"
            end
        end
        
        -- ESP for Tools
        for _, tool in pairs(workspace:GetChildren()) do
            if tool:IsA("Tool") and not tool:FindFirstChild("ESP") then
                local esp = createESP(tool)
                esp.Parent = tool
                esp.TextLabel.Text = tool.Name
            end
        end
    else
        -- Remove all ESP
        for _, object in pairs(workspace:GetDescendants()) do
            if object.Name == "ESP" then
                object:Destroy()
            end
        end
    end
end)

-- Utility Section
local utilityFolder = playerSection:Folder("Utility")

utilityFolder:Toggle("Auto Collect Scraps", function(enabled)
    _G.autoCollect = enabled
    
    while _G.autoCollect and wait() do
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            for _, scrap in pairs(workspace:GetChildren()) do
                if scrap.Name == "Scrap" then
                    local distance = (scrap.Position - character.HumanoidRootPart.Position).magnitude
                    if distance <= 10 then
                        firetouchinterest(character.HumanoidRootPart, scrap, 0)
                        firetouchinterest(character.HumanoidRootPart, scrap, 1)
                    end
                end
            end
        end
    end
end)

utilityFolder:Toggle("Rake Detection", function(enabled)
    _G.rakeDetection = enabled
    
    local function createWarning()
        local warning = Instance.new("ScreenGui")
        warning.Name = "RakeWarning"
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.2, 0, 0.1, 0)
        frame.Position = UDim2.new(0.4, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(1, 0, 0)
        frame.Parent = warning
        
        local text = Instance.new("TextLabel")
        text.Text = "⚠️ RAKE NEARBY! ⚠️"
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextColor3 = Color3.new(1, 1, 1)
        text.Parent = frame
        
        warning.Parent = game.Players.LocalPlayer.PlayerGui
        
        return warning
    end
    
    while _G.rakeDetection and wait(0.5) do
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == "Rake" and v:FindFirstChild("HumanoidRootPart") then
                    local distance = (v.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
                    
                    if distance <= 100 then
                        local warning = createWarning()
                        wait(1)
                        warning:Destroy()
                    end
                end
            end
        end
    end
end)

-- Stats Section
local statsFolder = playerSection:Folder("Stats")

statsFolder:Toggle("Auto Heal", function(enabled)
    _G.autoHeal = enabled
    
    while _G.autoHeal and wait(1) do
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character and character:FindFirstChild("Humanoid") then
            if character.Humanoid.Health < character.Humanoid.MaxHealth then
                for _, item in pairs(player.Backpack:GetChildren()) do
                    if item.Name == "MedKit" then
                        item.Parent = character
                        item:Activate()
                        wait(1)
                        item.Parent = player.Backpack
                    end
                end
            end
        end
    end
end)

-- Settings Section
local settingsFolder = playerSection:Folder("Settings")

settingsFolder:Slider("Render Distance", {min = 100, max = 1000, default = 500}, function(value)
    game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = value
end)

settingsFolder:Button("Reset All Settings", function()
    -- Reset all toggles and settings to default
    local player = game.Players.LocalPlayer
    local character = player.Character
    if character then
        character.Humanoid.WalkSpeed = 16
        character.Humanoid.JumpPower = 50
    end
    
    game:GetService("Lighting").Brightness = 0
    game:GetService("Lighting").Ambient = Color3.new(0, 0, 0)
    
    _G.autoCollect = false
    _G.rakeDetection = false
    _G.autoHeal = false
    
    -- Remove all ESP
    for _, object in pairs(workspace:GetDescendants()) do
        if object.Name == "ESP" then
            object:Destroy()
        end
    end
end)

-- Credits Section
main:Tab("Credits"):Label("Made by Assistant\nFor educational purposes only")

-- Initialize character handling
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    -- Reset settings when character respawns if needed
end)
