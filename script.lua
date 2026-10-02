-- 1. استدعاء مكتبة الواجهة Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. إنشاء النافذة الرئيسية للسكربت
local Window = Rayfield:CreateWindow({
   Name = "Santer Hub",
   LoadingTitle = "Santer Hub",
   LoadingSubtitle = "by Faisal",
   ConfigurationSaving = { Enabled = false }
})

-- 3. إنشاء تبويب الميزات (Toys Mode)
local ToysTab = Window:CreateTab("Toys Mode", 4483362458)
-- متغيرة الصاروخ والدرع
local myRocket = nil
local shieldFolder = Instance.new("Folder", workspace)
shieldFolder.Name = "MyCustomShield"

-- دالة إطلاق الصاروخ
local function LaunchRocket(speed)
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    myRocket = Instance.new("Part")
    myRocket.Name = "CustomICBM"
    myRocket.Size = Vector3.new(3, 10, 3)
    myRocket.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 7, 0)
    myRocket.BrickColor = BrickColor.new("Bright red")
    myRocket.Material = Enum.Material.Neon
    myRocket.CanCollide = false
    myRocket.Parent = workspace
    
    local engine = Instance.new("BodyVelocity")
    engine.Name = "RocketEngine"
    engine.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    engine.Velocity = Vector3.new(0, speed, 0)
    engine.Parent = myRocket
end

local function StopRocket()
    if myRocket then
        myRocket:Destroy()
        myRocket = nil
    end
end

-- دالة بناء الدرع
local function BuildDomainShield()
    shieldFolder:ClearAllChildren()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    local radius = 8
    local layers = 6
    local partsPerLayer = 10
    
    for layer = 0, layers do
        local height = layer * 3
        for i = 1, partsPerLayer do
            local angle = (i / partsPerLayer) * math.pi * 2
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            
            local wall = Instance.new("Part")
            wall.Size = Vector3.new(4, 3.5, 1)
            wall.Material = Enum.Material.Wood
            wall.BrickColor = BrickColor.new("Wood")
            wall.CFrame = CFrame.new(hrp.Position + Vector3.new(x, height - 3, z), hrp.Position + Vector3.new(0, height - 3, 0))
            wall.Anchored = true
            wall.Parent = shieldFolder
        end
    end
    
    local roof = Instance.new("Part")
    roof.Size = Vector3.new(radius * 2.2, 1, radius * 2.2)
    roof.Material = Enum.Material.Wood
    roof.BrickColor = BrickColor.new("Wood")
    roof.CFrame = hrp.CFrame + Vector3.new(0, (layers * 3) - 1, 0)
    roof.Anchored = true
    roof.Parent = shieldFolder
end

local function RemoveShield()
    shieldFolder:ClearAllChildren()
end

-- زر الصاروخ
ToysTab:CreateToggle({
   Name = "Launch ICBM Rocket",
   CurrentValue = false,
   Callback = function(Value)
      if Value then LaunchRocket(50) else StopRocket() end
   end,
})

-- زر الدرع
ToysTab:CreateToggle({
   Name = "Domain Shield",
   CurrentValue = false,
   Callback = function(Value)
      if Value then BuildDomainShield() else RemoveShield() end
   end,
})
