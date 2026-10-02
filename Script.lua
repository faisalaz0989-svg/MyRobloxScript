local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "My Script",
   LoadingTitle = "Welcome Faisal",
   LoadingSubtitle = "by Faisal"
})

local Tab = Window:CreateTab("Main", 4483362458)
game:GetService("ReplicatedStorage").SpawnToy:FireServer("Pallet", CFrame.new(0, 10, 0))
local function MakeCircle()
    local char = game.Players.LocalPlayer.Character
    local pos = char.HumanoidRootPart.Position
    for angle = 0, 360, 20 do
        local x = pos.X + math.cos(math.rad(angle)) * 15
        local z = pos.Z + math.sin(math.rad(angle)) * 15
        -- استدعاء ريموت الترسيبن عند المكان (x, pos.Y, z)
    end
end
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bv.Velocity = Vector3.new(0, 50, 0) -- يطير للأعلى بسرعة 50
bv.Parent = RocketPart
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Santer Hub",
   LoadingTitle = "Santer Hub",
   LoadingSubtitle = "by Faisal",
   ConfigurationSaving = { Enabled = false }
})

local ToysTab = Window:CreateTab("Toys Mode", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- المتغيرات
local domainRadius = 20
local domainActive = false
local domainFolder = workspace:FindFirstChild("DomainShieldFolder") or Instance.new("Folder", workspace)
domainFolder.Name = "DomainShieldFolder"

local missileSpeed = 60
local superThrowActive = false

-- البحث عن ريموت الترسيبن في اللعبة (Toys Spawn Remote)
local spawnRemote = ReplicatedStorage:FindFirstChild("SpawnToy", true) or ReplicatedStorage:FindFirstChild("BuildingRemote", true)

-- 1. دالة بناء القبة الخشبية الحقيقية (Domain Expansion / Shield)
local function BuildWoodDomain()
    domainFolder:ClearAllChildren()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local centerPos = hrp.Position
    
    -- إنشاء حلقات كروية مكثفة من خشب الـ Pallet
    local rings = 12
    local itemsPerRing = 16
    
    for i = 0, rings do
        local phi = math.pi * (i / rings)
        for j = 1, itemsPerRing do
            if not domainActive then break end
            
            local theta = (j / itemsPerRing) * math.pi * 2
            local x = domainRadius * math.sin(phi) * math.cos(theta)
            local y = domainRadius * math.cos(phi)
            local z = domainRadius * math.sin(phi) * math.sin(theta)
            
            local spawnCF = CFrame.new(centerPos + Vector3.new(x, y, z), centerPos)
            
            -- محاولة استدعاء البليت الخشبي الحقيقي من اللعبة
            if spawnRemote then
                pcall(function()
                    spawnRemote:FireServer("Pallet", spawnCF)
                end)
            else
                -- حل احتياطي مبسط في حال عدم وجود الريموت Direct Part
                local pallet = Instance.new("Part")
                pallet.Size = Vector3.new(6, 0.8, 4)
                pallet.Material = Enum.Material.WoodPlanks
                pallet.BrickColor = BrickColor.new("Wood")
                pallet.CFrame = spawnCF
                pallet.Anchored = true
                pallet.Parent = domainFolder
            end
        end
    end
end

local function ClearDomain()
    domainActive = false
    domainFolder:ClearAllChildren()
end

-- 2. دالة الصاروخ الحقيقي (ICBM Launch)
local function LaunchICBM()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local startCF = hrp.CFrame * CFrame.new(0, 2, -6)
    
    -- استدعاء الصاروخ الحقيقي من اللعبة
    if spawnRemote then
        pcall(function()
            spawnRemote:FireServer("ICBM", startCF)
            spawnRemote:FireServer("Rocket", startCF)
        end)
    end
    
    task.wait(0.2)
    
    -- البحث عن الصاروخ المرسبن في الورك سبيس والتحكم به
    local rocket = workspace:FindFirstChild("ICBM") or workspace:FindFirstChild("Rocket") or workspace:FindFirstChild("RideableRocket")
    if rocket then
        local bv = rocket:FindFirstChildOfClass("BodyVelocity") or Instance.new("BodyVelocity", rocket)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, missileSpeed, 0)
        
        -- الانفجار عند الاصطدام أو انتهاء المسار
        rocket.Touched:Connect(function(hit)
            if hit and not hit:IsDescendantOf(char) then
                local exp = Instance.new("Explosion")
                exp.Position = rocket.Position
                exp.BlastRadius = 40
                exp.Parent = workspace
            end
        end)
    end
end

-- 3. دالة Super Throw
workspace.ChildAdded:Connect(function(child)
    if superThrowActive then
        task.wait(0.05)
        if child:IsA("BasePart") or child:IsA("Model") then
            local root = child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")) or child
            if root then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.Velocity = LocalPlayer:GetMouse().Hit.LookVector * 300
                bv.Parent = root
            end
        end
    end
end)

-- ================= GUI Controls =================

ToysTab:CreateToggle({
   Name = "Launch ICBM Rocket",
   CurrentValue = false,
   Callback = function(Value)
      if Value then LaunchICBM() end
   end,
})

ToysTab:CreateSlider({
   Name = "ICBM Rocket Speed",
   Range = {10, 200},
   Increment = 5,
   Suffix = " Speed",
   CurrentValue = 60,
   Callback = function(Value)
      missileSpeed = Value
   end,
})

ToysTab:CreateToggle({
   Name = "Domain Shield (Wood Dome)",
   CurrentValue = false,
   Callback = function(Value)
      domainActive = Value
      if Value then
          task.spawn(BuildWoodDomain)
      else
          ClearDomain()
      end
   end,
})

ToysTab:CreateSlider({
   Name = "Shield Radius / Scale",
   Range = {10, 40},
   Increment = 2,
   Suffix = " Studs",
   CurrentValue = 20,
   Callback = function(Value)
      domainRadius = Value
      if domainActive then
          BuildWoodDomain()
      end
   end,
})

ToysTab:CreateToggle({
   Name = "Super Throw",
   CurrentValue = false,
   Callback = function(Value)
      superThrowActive = Value
   end,
})
