--[[
    MEYY HUB - AUTO BOUNTY - SCRIPT COMPLETO DESCIFRADO (100% AUTOCONTENIDO)
    ------------------------------------------------------------------
    - Extraido del servidor de meyyhub con tu key (naa-21ETAU5C) y tu HWID.
    - Sin autenticacion, sin anti-tamper, sin checks de key: codigo puro.
    - SIN DEPENDENCIAS EXTERNAS: los modulos que antes se descargaban de
      pastefy estan incrustados dentro (buscar "[INLINE" para verlos).
    - Funciones: caza automatica de jugadores (bounty) con tracking en vivo, ataque a players/mobs, fruit M1, sky hop, fast mode
    - Para usarlo: pega/ejecuta este archivo completo en tu executor.
]]
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer
Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name))
    end
end})
local Players = Services.Players
local player = Services.Players.LocalPlayer
local LocalPlayer = Services.Players.LocalPlayer
local ReplicatedStorage = Services.ReplicatedStorage
local VirtualUser = Services.VirtualUser
local vim1 = Services.VirtualInputManager
local TweenService = Services.TweenService
local RunService = Services.RunService
local UserInputService = Services.UserInputService

local playerModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"))

while not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
    Services.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", getgenv().Team )
    task.wait(1)
end
local placeId = game.PlaceId
local worldMap = {[2753915549] = "World1",[85211729168715] = "World1",[4442272183] = "World2",[79091703265657] = "World2",[7449423635] = "World3",[100117331123089] = "World3"}
sea = getgenv().Config["Select Sea"]
if sea == "Sea 1" then
   if placeId == 4442272183 or placeId == 79091703265657 or placeId == 7449423635 or placeId == 100117331123089 then
   Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
   end
elseif sea == "Sea 2" then
   if placeId == 2753915549 or placeId == 85211729168715 or placeId == 7449423635 or placeId == 100117331123089 then
   Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
   end
elseif sea == "Sea 3" then
    if placeId == 4442272183 or placeId == 79091703265657 or placeId == 2753915549 or placeId == 85211729168715 then
    Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZou")
    end
end



    local function Boostfps()
local CFG = {
  disable3D       = true,
  soundOff        = true,
  disableCoreGui  = true,
  lowQuality      = true,
  postFXOff       = true,
  zeroWater       = true,
  hide = {
    geometry      = true,
    castShadowOff = true,
    reflectance0  = true,
    materialPlastic = true,
    includeCharacter = true,
  },
  kill = {
    particles     = true,
    lights        = true,
    decals        = true,
    ui3d          = true,
    prompts       = true,
    highlights    = true,
    clothes       = true,
    accessories   = true,
  },
  batchSize       = 2000,
  hookNewSpawn    = true,
  antiAFK         = true,
}

---------
local S = setmetatable({}, {__index=function(t,k)local s=game:GetService(k) rawset(t,k,s) return s end})
local RunService, Workspace, Lighting, Players, StarterGui, SoundService, UIS, ReplicatedStorage =
  S.RunService, S.Workspace, S.Lighting, S.Players, S.StarterGui, S.SoundService, S.UserInputService, S.ReplicatedStorage

local LP = Players.LocalPlayer

local function safe(_, f) local ok = pcall(f); return ok end

---------
repeat task.wait() until game:IsLoaded()
if not game:IsLoaded() then game:IsLoaded():Wait(5) end

if CFG.soundOff then safe(nil, function() UserSettings():GetService("UserGameSettings").MasterVolume = 0 end) end
if CFG.lowQuality then safe(nil, function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end) end

local t = Workspace.Terrain
if CFG.zeroWater then
  t.WaterWaveSize, t.WaterWaveSpeed = 0, 0
  t.WaterReflectance = 0
  t.WaterTransparency = 1
end

sethiddenproperty(Lighting, "Technology", 2)
sethiddenproperty(t, "Decoration", false)
Lighting.GlobalShadows = 0
Lighting.FogEnd = 9e9
Lighting.Brightness = 0

---------
local function killPostFX()
  for _, e in ipairs(Lighting:GetChildren()) do
    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
      or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
      e.Enabled = false
    end
  end
end
if CFG.postFXOff then killPostFX() end

---------
local function EnableFastMode()
    if _G.FastMode then return end
    _G.FastMode = true
    _G.reducing = true
    _G.FastModeCache = {}

    local Map = Workspace:FindFirstChild("Map")
    local Unloaded = ReplicatedStorage:FindFirstChild("Unloaded")
    local SmoothPlastic = Enum.Material.SmoothPlastic

    local function optimize(descendants)
        local start = os.clock()
        for _, obj in ipairs(descendants) do
            if obj:IsA("BasePart") then
                _G.FastModeCache[obj] = obj.Material
                obj.Material = SmoothPlastic
            elseif obj:IsA("Texture") and not obj:GetAttribute("Offset") then
                obj:Destroy()
            end
            if os.clock() - start > 0.008 then
                task.wait()
                start = os.clock()
            end
        end
    end

    if Map then optimize(Map:GetDescendants()) end
    if Unloaded then optimize(Unloaded:GetDescendants()) end

    local Optimizer = LP.PlayerScripts:FindFirstChild("OptimizerClientActor")
    if Optimizer and Optimizer.SendMessage then
        Optimizer:SendMessage("Optimize", true)
    end
end

local function DisableVFX()
    LP:SetAttribute("DisableAllyEffects", true)
end

local function DisableCameraShake()
    pcall(function()
        local cs1 = require(ReplicatedStorage.Util.CameraShake)
        if cs1.SetEnabled then cs1:SetEnabled(false) end
    end)
    pcall(function()
        local cs2 = require(ReplicatedStorage.Util.CameraShaker)
        if cs2.SetEnabled then cs2:SetEnabled(false) end
    end)
    pcall(function()
        ReplicatedStorage.Remotes.ChangeSetting:FireServer("CameraShake", false)
    end)
end

local function DisableMusic()
    pcall(function() game.ReplicatedStorage.Events.ToggleMusic.Event:Fire(true) end)
    for _, s in pairs(Workspace._WorldOrigin.Sounds.Locations:GetChildren()) do
        if s:IsA("Sound") then s:Pause() end
    end
end

EnableFastMode()
DisableVFX()
DisableCameraShake()
DisableMusic()

---------
---------
---------
local function hideGeometry(inst)
  if not CFG.hide.geometry then return end
  if inst:IsA("BasePart") then
      -- Nếu là hitbox ẩn của chiêu thức (vốn dĩ tàng hình) thì cứ để nó tàng hình, hông đụng vào
      if inst.Transparency == 1 then 
          return 
      end 
      
      if CFG.hide.castShadowOff and inst.CastShadow ~= false then inst.CastShadow = false end
      if CFG.hide.reflectance0 and inst.Reflectance ~= 0 then inst.Reflectance = 0 end
      if inst.Material ~= Enum.Material.Plastic then
        inst.Material = Enum.Material.Plastic
      end
  end
end
---------

---------

local function cull(inst)
  if not inst or inst.Parent == nil then return end
  hideGeometry(inst)

  if CFG.kill.particles and (inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles")) then
    if inst:IsA("ParticleEmitter") then
      inst.Lifetime = NumberRange.new(0)
      inst.Rate = 0
    elseif inst:IsA("Trail") then
      inst.Lifetime = 0
      inst.Enabled = false
    else
      if inst.Enabled ~= nil then inst.Enabled = false end
    end
    return
  end

  if CFG.kill.lights and (inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight")) then
    inst.Enabled = false
    return
  end

  if CFG.kill.decals then
    if inst:IsA("Decal") or inst:IsA("Texture") then inst.Transparency = 1; return end
    if inst:IsA("SurfaceAppearance") then
      safe(nil, function() inst.ColorMap = "rbxassetid://0" end)
      return
    end
  end

  if inst:IsA("Explosion") then
    inst.BlastPressure = 1
    inst.BlastRadius = 1
    return
  end
end

---------
local processed = setmetatable({}, {__mode="k"})
local queue = {}

local function push(x) 
    if x and not processed[x] then 
        queue[#queue+1] = x; processed[x] = true 
    end 
end

local function pop()
  local n = #queue
  if n == 0 then return end
  local v = queue[n]; queue[n] = nil; return v
end

for _, v in ipairs(Workspace:GetDescendants()) do push(v) end
for _, v in ipairs(Lighting:GetDescendants()) do push(v) end

if CFG.hookNewSpawn then
  Workspace.DescendantAdded:Connect(push)
  Lighting.DescendantAdded:Connect(push)
end

RunService.Heartbeat:Connect(function()
  local n = 0
  while n < CFG.batchSize do
    local obj = pop()
    if not obj then break end
    if obj.Parent ~= nil then cull(obj) end
    n += 1
  end
end)

---------
local function simplifyCharacter(char)
  if not char then return end
  if CFG.kill.accessories then
    for _, ch in ipairs(char:GetChildren()) do
      if ch:IsA("Accessory") then safe(nil, function() ch:Destroy() end) end
    end
  end
  if CFG.kill.clothes then
    for _, ch in ipairs(char:GetChildren()) do
      if ch:IsA("Shirt") or ch:IsA("Pants") or ch:IsA("ShirtGraphic") then
        safe(nil, function() ch:Destroy() end)
      end
    end
  end
  local animate = char:FindFirstChild("Animate")
  if animate and animate:IsA("LocalScript") then
    safe(nil, function() animate.Disabled = true end)
  end
end

if LP then
  if LP.Character then simplifyCharacter(LP.Character) end
  LP.CharacterAdded:Connect(function(c)
    c:WaitForChild("HumanoidRootPart", 10)
    simplifyCharacter(c)
  end)
end
end

if getgenv().Config["BoostFps"] == true then
     Boostfps()
end


	
if not Util or not Util.FPSTracker then
    Util = { FPSTracker = { FPS = 60 } }
end
task.spawn(function()
    local lastTime = tick()
    local frames = 0
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local now = tick()
        if now - lastTime >= 1 then
            if Util and Util.FPSTracker then
                Util.FPSTracker.FPS = math.clamp(frames / (now - lastTime), 1, 60)
            end
            frames = 0
            lastTime = now
        end
    end)
end)
if not setfpscap then setfpscap = function() 
    setfpscap(60)
end 
end





local character = LocalPlayer.Character or player.CharacterAdded:Wait()
local char = character


local controls = playerModule:GetControls()
local function disableControls()
    controls:Disable()
end

local function startWalking(char)
    local humanoid = char:WaitForChild("Humanoid")
    local rootPart = char:WaitForChild("HumanoidRootPart")   
    disableControls()
    task.spawn(function()
        while char:IsDescendantOf(game) and humanoid.Health > 0 do
            local randomX = math.random(-20, 20)
            local randomZ = math.random(-20, 20)
            local targetPos = rootPart.Position + Vector3.new(randomX, 0, randomZ)           
            humanoid:MoveTo(targetPos)           
            humanoid.MoveToFinished:Wait()
            task.wait()
        end
    end)
end

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    char = newChar
    startWalking(newChar)
end)
if player.Character then
    startWalking(player.Character)
end
wait(.5)

    local function StartAttack()
        task.spawn(function()
        -- [INLINE FastAttack — original: https://pastefy.app/45hCw1JE/raw]
(function() --begin FastAttack
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Net = Modules and Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")
local ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")
local GunValidator = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator2")

local LocalPlayer = Players.LocalPlayer
local NetModule
pcall(function()
    if Modules and Modules:FindFirstChild("Net") then
        NetModule = require(Modules.Net)
    end
end)

local Remotes = {}
local Assets = ReplicatedStorage:WaitForChild("Assets")

local RemoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
if RemoteFolder then
    for _, child in ipairs(RemoteFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then
            local id = child:GetAttribute("Id")
            if id then
                Remotes[id] = child
            end
        end
    end

    RemoteFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then
            local id = child:GetAttribute("Id")
            if id then
                Remotes[id] = child
            end
        end
    end)
end

local KillTrap = {
    LockedTargets = {}, 
    StuckTimeout = 1.5
}

function KillTrap:Process(enemy)
    local hum = enemy:FindFirstChild("Humanoid")
    if not hum then 
        if self.LockedTargets[enemy] then
            self.LockedTargets[enemy] = nil
        end
        return false 
    end
    
    local currentHealth = hum.Health
    local data = self.LockedTargets[enemy]

    if currentHealth <= 0 then
        if self.LockedTargets[enemy] then
            self.LockedTargets[enemy] = nil
        end
        return false
    end

    if not data then
        self.LockedTargets[enemy] = {
            lastHealth = currentHealth,
            lastChangeTime = tick()
        }
        return true
    end

    if currentHealth < data.lastHealth then
        data.lastHealth = currentHealth
        data.lastChangeTime = tick()
        return true
    elseif currentHealth == data.lastHealth then
        if tick() - data.lastChangeTime > self.StuckTimeout then
            self.LockedTargets[enemy] = nil
            return false
        end
        return true
    else
        data.lastHealth = currentHealth
        data.lastChangeTime = tick()
        return true
    end
end

---------
local function GetClosestEnemy()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return nil end

    local closestEnemy = nil
    local shortestDistance = math.huge

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    local charsFolder = workspace:FindFirstChild("Characters")
    local seaBeastsFolder = workspace:FindFirstChild("SeaBeasts")
    
    local function Scan(folder)
        if not folder then return end
        for _, enemy in ipairs(folder:GetChildren()) do
            if enemy:IsA("Model") and enemy ~= character then
                local n = enemy.Name
                local isSeaBeast = (folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")
                
                if isSeaBeast then
                    local pivotSuccess, pivot = pcall(function() return enemy:GetPivot() end)
                    if pivotSuccess and pivot then
                        local dist = (rootPart.Position - pivot.Position).Magnitude
                        if dist <= 6000 and dist < shortestDistance then
                            closestEnemy = enemy
                            shortestDistance = dist
                        end
                    end
                elseif isShip then
                    local healthVal = enemy:FindFirstChild("Health")
                    if healthVal and healthVal.Value > 0 then
                        local pivotSuccess, pivot = pcall(function() return enemy:GetPivot() end)
                        if pivotSuccess and pivot then
                            local dist = (rootPart.Position - pivot.Position).Magnitude
                            if dist <= 6000 and dist < shortestDistance then
                                closestEnemy = enemy
                                shortestDistance = dist
                            end
                        end
                    end
                else
                    local root = enemy:FindFirstChild("HumanoidRootPart")
                    local hum = enemy:FindFirstChild("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local dist = (rootPart.Position - root.Position).Magnitude
                        if dist <= 6000 then
                            KillTrap:Process(enemy)
                        end
                    end
                end
            end
        end
    end

    Scan(enemiesFolder)
    Scan(seaBeastsFolder)
    Scan(charsFolder)

    for enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(enemy) then
            local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                if distance < shortestDistance then
                    closestEnemy = enemy
                    shortestDistance = distance
                end
            end
        end
    end
    
    return closestEnemy
end

local function Attack()
    local character = LocalPlayer.Character
    if not character then return end
    
    ---------
    local tool = character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
    ---------
    if not tool or tool:GetAttribute("WeaponType") ~= "Melee" then return end

    local enemy = GetClosestEnemy()
    if enemy then
        local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
        if regAttack then
            regAttack:FireServer()
        end

        local hitPart = enemy:FindFirstChild("Head") or enemy:FindFirstChild("HumanoidRootPart") or enemy.PrimaryPart or enemy:FindFirstChildWhichIsA("BasePart")
        if hitPart then
            local regHit = Remotes["RE/RegisterHit"] or RegisterHit
            if regHit then
                regHit:FireServer(enemy, hitPart)
            end
            if NetModule and NetModule.RemoteEvent then
                NetModule:RemoteEvent("RegisterHit"):FireServer(enemy, hitPart)
            end
        end
    end
end

local function GetBladeHits()
    local targets = {}
    local char = game.Players.LocalPlayer.Character
    if not char then return targets end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return targets end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    local charsFolder = workspace:FindFirstChild("Characters")
    local seaBeastsFolder = workspace:FindFirstChild("SeaBeasts")
    
    local function CheckFolder(folder)
        if not folder then return end
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("Model") and v ~= char then
                local n = v.Name
                local isSeaBeast = (folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")

                if isSeaBeast then
                    local pivotSuccess, pivot = pcall(function() return v:GetPivot() end)
                    if pivotSuccess and pivot then
                        if (pivot.Position - root.Position).Magnitude <= 6000 then
                            table.insert(targets, v)
                        end
                    end
                elseif isShip then
                    local healthVal = v:FindFirstChild("Health")
                    if healthVal and healthVal.Value > 0 then
                        local pivotSuccess, pivot = pcall(function() return v:GetPivot() end)
                        if pivotSuccess and pivot then
                            if (pivot.Position - root.Position).Magnitude <= 6000 then
                                table.insert(targets, v)
                            end
                        end
                    end
                elseif v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                    local dist = (v.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist <= 6000 then
                        KillTrap:Process(v)
                    end
                end
            end
        end
    end

    CheckFolder(enemiesFolder)
    CheckFolder(seaBeastsFolder)
    CheckFolder(charsFolder)

    for enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(enemy) then
            table.insert(targets, enemy)
        end
    end

    return targets
end

local function AttackAll()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    ---------
    local equippedWeapon = character:FindFirstChild("EquippedWeapon") or player.Backpack:FindFirstChildOfClass("Tool")
    ---------
    if not equippedWeapon then return end

    local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
    local regHit = Remotes["RE/RegisterHit"] or RegisterHit
    
    local enemies = GetBladeHits()
    if #enemies > 0 then
        if regAttack then
            regAttack:FireServer(-math.huge)
        end
        
        local args = {nil, {}}
        for i, v in pairs(enemies) do
            local hitPart = v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
            if not args[1] then
                args[1] = hitPart
            end
            args[2][i] = {v, hitPart}
        end
        
        if args[1] and regHit then
            regHit:FireServer(unpack(args))
        end
    end
end
---------

---------
RunService.Stepped:Connect(function()
    AttackAll()
end)
---------

local Config = {
    AttackDistance = 65,
    AttackMobs = true,
    AttackPlayers = true,
    AttackCooldown = 0,
    ComboResetTime = 0,
    MaxCombo = 2,
    HitboxLimbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"},
    AutoClickEnabled = true
}

local FastAttack = {}
FastAttack.__index = FastAttack

function FastAttack.new()
    local self = setmetatable({
        Debounce = 0,
        ComboDebounce = 0,
        ShootDebounce = 0,
        M1Combo = 0,
        EnemyRootPart = nil,
        Connections = {},
        Overheat = {Dragonstorm = {MaxOverheat = 3, Cooldown = 0, TotalOverheat = 0, Distance = 350, Shooting = false}},
        ShootsPerTarget = {["Dual Flintlock"] = 2},
        SpecialShoots = {["Skull Guitar"] = "TAP", ["Bazooka"] = "Position", ["Cannon"] = "Position", ["Dragonstorm"] = "Overheat"}
    }, FastAttack)
    
    pcall(function()
        local CombatController = require(ReplicatedStorage.Controllers.CombatController)
        if getupvalue then
            self.ShootFunction = getupvalue(CombatController.Attack, 9)
        end
        
        local Flags = Modules:FindFirstChild("Flags")
        if Flags then
            self.CombatFlags = require(Flags).COMBAT_REMOTE_THREAD
        end

        local LocalScript = Player:WaitForChild("PlayerScripts"):FindFirstChildOfClass("LocalScript")
        if LocalScript and getsenv then
            local env = getsenv(LocalScript)
            if env._G and env._G.SendHitsToServer then
                self.HitFunction = env._G.SendHitsToServer
            end
        end
    end)
    
    return self
end

function FastAttack:IsEntityAlive(entity)
    local humanoid = entity and entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

function FastAttack:CheckStun(Character, Humanoid, ToolTip)
    local Stun = Character:FindFirstChild("Stun")
    local Busy = Character:FindFirstChild("Busy")
    if Humanoid.Sit and (ToolTip == "Sword" or ToolTip == "Melee" or ToolTip == "Blox Fruit") then
        return false
    elseif (Stun and Stun.Value > 0) or (Busy and Busy.Value) then
        return false
    end
    return true
end

function FastAttack:GetBladeHits(Character, Distance)
    local Position = Character:GetPivot().Position
    local BladeHits = {}
    local MaxDist = Distance or 6000
    
    local function ScanForNewTargets(Folder)
        if not Folder then return end
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy ~= Character then
                local n = Enemy.Name
                local isSeaBeast = (Folder.Name == "SeaBeasts") or n:find("SeaBeast") or n == "Leviathan Segment" or n == "Leviathan"
                local isShip = n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("Brigade")
                
                if isSeaBeast or isShip then
                    local pivotSuccess, pivot = pcall(function() return Enemy:GetPivot() end)
                    if pivotSuccess and pivot then
                        if (Position - pivot.Position).Magnitude <= MaxDist then
                            local BasePart = Enemy:FindFirstChild("Head") or Enemy:FindFirstChild("Hitbox") or Enemy:FindFirstChild("HumanoidRootPart") or Enemy.PrimaryPart or Enemy:FindFirstChildWhichIsA("BasePart")
                            if BasePart then
                                if not self.EnemyRootPart then
                                    self.EnemyRootPart = BasePart
                                else
                                    table.insert(BladeHits, {Enemy, BasePart})
                                end
                            end
                        end
                    end
                elseif self:IsEntityAlive(Enemy) then
                    local root = Enemy:FindFirstChild("HumanoidRootPart")
                    if root and (Position - root.Position).Magnitude <= MaxDist then
                        KillTrap:Process(Enemy)
                    end
                end
            end
        end
    end

    if Config.AttackMobs then 
        ScanForNewTargets(Workspace:FindFirstChild("Enemies")) 
        ScanForNewTargets(Workspace:FindFirstChild("SeaBeasts")) 
    end
    if Config.AttackPlayers then ScanForNewTargets(Workspace:FindFirstChild("Characters")) end

    for Enemy, _ in pairs(KillTrap.LockedTargets) do
        if KillTrap:Process(Enemy) then
            local BasePart = Enemy:FindFirstChild(Config.HitboxLimbs[math.random(#Config.HitboxLimbs)]) or Enemy:FindFirstChild("HumanoidRootPart")
            if BasePart then
                if not self.EnemyRootPart then
                    self.EnemyRootPart = BasePart
                else
                    table.insert(BladeHits, {Enemy, BasePart})
                end
            end
        end
    end
    
    return BladeHits
end

function FastAttack:GetClosestEnemy(Character, Distance)
    local BladeHits = self:GetBladeHits(Character, Distance)
    local Closest, MinDistance = nil, math.huge
    
    for _, Hit in ipairs(BladeHits) do
        local Magnitude = (Character:GetPivot().Position - Hit[2].Position).Magnitude
        if Magnitude < MinDistance then
            MinDistance = Magnitude
            Closest = Hit[2]
        end
    end
    return Closest
end

function FastAttack:GetCombo()
    self.ComboDebounce = tick()
    self.M1Combo = 3
    return 3
end

function FastAttack:ShootInTarget(TargetPosition)
    local Character = Player.Character
    if not Character then return end
    
    local Equipped = Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
    if not Equipped or Equipped.ToolTip ~= "Gun" then return end
    
    local Cooldown = Equipped:FindFirstChild("Cooldown") and Equipped.Cooldown.Value or 0.3
    if (tick() - self.ShootDebounce) < Cooldown then return end
    
    local ShootType = self.SpecialShoots[Equipped.Name] or "Normal"
    if ShootType == "Position" or (ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent")) then
        Equipped:SetAttribute("LocalTotalShots", (Equipped:GetAttribute("LocalTotalShots") or 0) + 1)
        
        if self.ShootFunction and getupvalue and GunValidator then
            GunValidator:FireServer(self:GetValidator2())
        end
        
        if ShootType == "TAP" and Equipped:FindFirstChild("RemoteEvent") then
            Equipped.RemoteEvent:FireServer("TAP", TargetPosition)
        elseif ShootGunEvent then
            ShootGunEvent:FireServer(TargetPosition)
        end
        self.ShootDebounce = tick()
    else
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        self.ShootDebounce = tick()
    end
end

function FastAttack:GetValidator2()
    if not getupvalue or not setupvalue or not self.ShootFunction then return 0, 0 end
    
    local u27 = getupvalue(self.ShootFunction, 13)
    local u23 = getupvalue(self.ShootFunction, 14)
    local u26 = getupvalue(self.ShootFunction, 15)
    local u22 = getupvalue(self.ShootFunction, 16)
    local u24 = getupvalue(self.ShootFunction, 17)
    local u25 = getupvalue(self.ShootFunction, 18)
    local u28 = getupvalue(self.ShootFunction, 19)
    
    local u81 = u27 * u23
    local u82 = (u26 * u23 + u27 * u22) % u24
    u82 = (u82 * u24 + u81) % u25
    u26 = math.floor(u82 / u24)
    u27 = u82 - u26 * u24
    u28 = u28 + 1
    
    setupvalue(self.ShootFunction, 13, u27)
    setupvalue(self.ShootFunction, 14, u23)
    setupvalue(self.ShootFunction, 15, u26)
    setupvalue(self.ShootFunction, 16, u22)
    setupvalue(self.ShootFunction, 17, u24)
    setupvalue(self.ShootFunction, 18, u25)
    setupvalue(self.ShootFunction, 19, u28)
    
    return math.floor(u82 / u25 * 16777215), u28
end

function FastAttack:UseNormalClick(Character, Humanoid, Cooldown)
    self.EnemyRootPart = nil
    local BladeHits = self:GetBladeHits(Character)
    
    local regAttack = Remotes["RE/RegisterAttack"] or RegisterAttack
    local regHit = Remotes["RE/RegisterHit"] or RegisterHit

    if self.EnemyRootPart or #BladeHits > 0 then
        if regAttack then
            regAttack:FireServer(-math.huge) 
        end

        if self.EnemyRootPart then
            local HitTable = {}
            if self.EnemyRootPart.Parent then
                table.insert(HitTable, {self.EnemyRootPart.Parent, self.EnemyRootPart})
            end
            for _, hitData in ipairs(BladeHits) do
                table.insert(HitTable, {hitData[1], hitData[2]})
            end

            if self.CombatFlags and self.HitFunction then
                self.HitFunction(self.EnemyRootPart, HitTable)
            elseif regHit then
                regHit:FireServer(self.EnemyRootPart, HitTable)
            end
        end
    end
end

function FastAttack:UseFruitM1(Character, Equipped, Combo)
    local Targets = self:GetBladeHits(Character)
    
    if #Targets > 0 or self.EnemyRootPart then
        local Direction
        if Targets[1] then
            Direction = (Targets[1][2].Position - Character:GetPivot().Position).Unit
        else
            Direction = Character:GetPivot().LookVector
        end
        local remote = Equipped:FindFirstChild("LeftClickRemote")
        if remote then
            remote:FireServer(Direction, Combo)
        end
    end
end

function FastAttack:Attack()
    if not Config.AutoClickEnabled or (tick() - self.Debounce) < Config.AttackCooldown then return end
    local Character = Player.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid then return end
    
    local Equipped = Character:FindFirstChildOfClass("Tool") or Player.Backpack:FindFirstChildOfClass("Tool")
    if not Equipped then return end
    
    local ToolTip = Equipped.ToolTip
    if not table.find({"Melee", "Blox Fruit", "Sword", "Gun"}, ToolTip) then return end
    
    local CooldownVal = Equipped:FindFirstChild("Cooldown")
    local Cooldown = CooldownVal and CooldownVal.Value or Config.AttackCooldown
    if not self:CheckStun(Character, Humanoid, ToolTip) then return end
    
    local Combo = self:GetCombo()
    Cooldown = Cooldown + (Combo >= Config.MaxCombo and 0.05 or 0)
    self.Debounce = Combo >= Config.MaxCombo and ToolTip ~= "Gun" and (tick() + 0.05) or tick()
    
    if ToolTip == "Blox Fruit" and Equipped:FindFirstChild("LeftClickRemote") then
        self:UseFruitM1(Character, Equipped, Combo)
    elseif ToolTip == "Gun" then
        local Target = self:GetClosestEnemy(Character, 120)
        if Target then
            self:ShootInTarget(Target.Position)
        end
    else
        self:UseNormalClick(Character, Humanoid, Cooldown)
    end
end

local AttackInstance = FastAttack.new()

table.insert(AttackInstance.Connections, RunService.Stepped:Connect(function()
    AttackInstance:Attack()
end))

if getgc and hookfunction then
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" and iscclosure(v) then
            local info = debug.getinfo(v)
            local name = info and info.name
            if name == "Attack" or name == "attack" or name == "RegisterHit" then
                pcall(function()
                    hookfunction(v, function(...)
                        AttackInstance:Attack()
                        return v(...)
                    end)
                end)
            end
        end
    end
end
end)() --end FastAttack
        end)
    end

    if getgenv().Config["FastAttack"] == true then
        StartAttack()
    end


---------
local function SafeLoadBypass()
        task.spawn(function()
            print("SafeLoadBypass: Done Loading")
        end)
    end

if getgenv().Config and getgenv().Config["BypassTween"] == true then
    SafeLoadBypass()
end
---------
---------
local function ApplyUnbreakable()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    char:SetAttribute("UnbreakableAll", true)
    char:SetAttribute("UnbreakableFruit", true)
    char:SetAttribute("UnbreakableMelee", true)
    char:SetAttribute("UnbreakableSword", true)
    char:SetAttribute("UnbreakableGun", true)
end

ApplyUnbreakable()

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplyUnbreakable()
end)
---------

local function applyMasterpieceAll()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    character:SetAttribute("MasterpieceAll", true)
end
---------
applyMasterpieceAll()
local CONFIG = {
    FollowDelay = 0.0,
    SwitchDelay = 8,
    Offset = Vector3.new(3, 0, 0),
    SkimDelay = 0.0001
}

local isHopping = false 
local currentTarget = nil
local running = false
local followThread = nil
local switchTimer = 0
local rejoinEnabled = true
local kenEnabled = true
local lastDamageTime = tick()
local lastTargetHealth = 0

local Whitelist = {}
local Blacklist = {}
local ScanCompleted = false
local IsScanning = false

local NotificationSystem = {
    notifications = {},
    spacing = 90, 
    gui = nil
}

---------
getgenv().AutoAimbot = true
getgenv().MacroAimPos = nil
getgenv().CurrentTargetPart = nil
getgenv().LatestPredictedPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local PREDICT_RATIO = 65 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}
local latestPredictedPos = nil

local DISTANCE = 10
local Y_MIN = -4
local Y_MAX = 7

local function getPredictedPosition(target)
    if not target or not target.Character then return nil end
    local tChar = target.Character
    local tPart = tChar:FindFirstChild("HumanoidRootPart") or tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso") or tChar:FindFirstChild("Head")
    local tHum = tChar:FindFirstChild("Humanoid")
    if not tPart then return nil end
    
    local curTime = tick()
    local curPos = tPart.Position
    
    if not enemyHistory[target.Name] then 
        enemyHistory[target.Name] = {lastPos = curPos, lastTime = curTime, speeds = {}} 
        return curPos 
    end
    
    local data = enemyHistory[target.Name]
    local dT = curTime - data.lastTime
    local predictedPos = curPos

    if dT > 0.01 then
        local distMoved = (curPos - data.lastPos).Magnitude
        local currentSpeed = distMoved / dT
        
        if currentSpeed > 350 then currentSpeed = 350 end
        
        table.insert(data.speeds, currentSpeed)
        if #data.speeds > MAX_SAMPLES then table.remove(data.speeds, 1) end
        
        local sum = 0 
        for _, s in ipairs(data.speeds) do sum = sum + s end
        local avgSpd = sum / #data.speeds
        
        local moveActDir = Vector3.new(0, 0, 0)
        if distMoved > 0 then
            moveActDir = (curPos - data.lastPos).Unit
        end
        
        data.lastPos = curPos
        data.lastTime = curTime
        
        local timeToHit = PREDICT_RATIO

        local horizontalDir = Vector3.new(0, 0, 0)
        if avgSpd > 0.5 then
            if tHum and tHum.MoveDirection.Magnitude > 0 then
                horizontalDir = Vector3.new(tHum.MoveDirection.X, 0, tHum.MoveDirection.Z).Unit
            else
                horizontalDir = Vector3.new(moveActDir.X, 0, moveActDir.Z)
                if horizontalDir.Magnitude > 0 then horizontalDir = horizontalDir.Unit end
            end
        end

        local predictedX = curPos.X + (horizontalDir.X * avgSpd * timeToHit)
        local predictedZ = curPos.Z + (horizontalDir.Z * avgSpd * timeToHit)
        local predictedY = curPos.Y

        if tHum and tHum.FloorMaterial == Enum.Material.Air then
            local velY = tPart.AssemblyLinearVelocity.Y
            if velY < -250 then velY = -250 end
            if velY > 250 then velY = 250 end
            
            local gravityY = -workspace.Gravity
            predictedY = curPos.Y + (velY * timeToHit) + (0.5 * gravityY * (timeToHit^2))
        end

        if predictedX == predictedX and predictedY == predictedY and predictedZ == predictedZ then
            predictedPos = Vector3.new(predictedX, predictedY, predictedZ)
        else
            predictedPos = curPos
        end
    end
    
    return predictedPos
end

local ESPhighlight = Instance.new("Highlight")
ESPhighlight.Name = "MacroESP"
ESPhighlight.FillColor = Color3.fromRGB(255, 50, 50)
ESPhighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
ESPhighlight.FillTransparency = 0.5
ESPhighlight.OutlineTransparency = 0
ESPhighlight.Parent = CoreGui

local TracerLine = Instance.new("LineHandleAdornment")
TracerLine.Name = "MacroTracer"
TracerLine.Color3 = Color3.fromRGB(255, 0, 0)
TracerLine.Thickness = 6 
TracerLine.Transparency = 0 
TracerLine.ZIndex = 10
TracerLine.AlwaysOnTop = true
TracerLine.Parent = CoreGui

local PredVisual = Instance.new("Part")
PredVisual.Name = "MacroPredVisual"
PredVisual.Size = Vector3.new(1.2, 1.2, 1.2)
PredVisual.Shape = Enum.PartType.Ball
PredVisual.Material = Enum.Material.Neon
PredVisual.Color = Color3.fromRGB(0, 255, 255)
PredVisual.CanCollide = false
PredVisual.Anchored = true
PredVisual.Transparency = 1
PredVisual.Parent = Workspace

local PredGlow = Instance.new("PointLight")
PredGlow.Color = Color3.fromRGB(0, 255, 255)
PredGlow.Range = 8
PredGlow.Brightness = 2
PredGlow.Enabled = false
PredGlow.Parent = PredVisual

RunService.RenderStepped:Connect(function()
    local targetPlayer = currentTarget 
    getgenv().CurrentTargetPart = targetPlayer and targetPlayer.Character and (targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("UpperTorso"))
    
    local char = LocalPlayer.Character
    local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))

    if targetPlayer and targetPlayer.Character and myRoot then
        local tarRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart") or targetPlayer.Character:FindFirstChild("UpperTorso")
        
        if tarRoot then
            local dist = (myRoot.Position - tarRoot.Position).Magnitude
            ESPhighlight.Adornee = targetPlayer.Character
            TracerLine.Adornee = myRoot
            TracerLine.Length = dist
            TracerLine.CFrame = CFrame.lookAt(Vector3.zero, myRoot.CFrame:PointToObjectSpace(tarRoot.Position))
            TracerLine.Visible = true 

            local pPos = nil
            pcall(function()
                pPos = getPredictedPosition(targetPlayer)
            end)

            if pPos and pPos == pPos and pPos.Magnitude < 10000000 then
                latestPredictedPos = pPos
                getgenv().LatestPredictedPos = pPos

                PredVisual.Position = pPos
                PredVisual.Transparency = 0.2
                PredGlow.Enabled = true
                
                local camPos = Camera.CFrame.Position
                if (pPos - camPos).Magnitude > 0.01 then
                    local lookDir = (pPos - camPos).Unit
                    getgenv().MacroAimPos = CFrame.lookAt(pPos, pPos + lookDir)
                end
            else
                latestPredictedPos = nil
                getgenv().LatestPredictedPos = nil
                PredVisual.Transparency = 1
                PredGlow.Enabled = false
                getgenv().MacroAimPos = nil
            end
        else
            ESPhighlight.Adornee = nil
            TracerLine.Visible = false
            PredVisual.Transparency = 1
            PredGlow.Enabled = false
            getgenv().MacroAimPos = nil
        end
    else
        latestPredictedPos = nil
        getgenv().LatestPredictedPos = nil
        ESPhighlight.Adornee = nil
        TracerLine.Visible = false
        PredVisual.Transparency = 1
        PredGlow.Enabled = false
        getgenv().MacroAimPos = nil
    end
end)


-------------------------
task.spawn(function()
    local LP = LocalPlayer or (Services and Services.Players and Services.Players.LocalPlayer) or game:GetService("Players").LocalPlayer
    local RS = ReplicatedStorage or (Services and Services.ReplicatedStorage) or game:GetService("ReplicatedStorage")
    local VIM = vim1 or (Services and Services.VirtualInputManager) or game:GetService("VirtualInputManager")

    local Modules = RS:WaitForChild("Modules", 5)
    local Net = Modules and Modules:FindFirstChild("Net")
    local ShootGunEvent = Net and Net:FindFirstChild("RE/ShootGunEvent")
    local GunValidator = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Validator2")

    local NetModule = nil
    local CombatController = nil
    local ShootFunction = nil

    pcall(function()
        if Modules and Modules:FindFirstChild("Net") then
            NetModule = require(Modules.Net)
        end
        local Controllers = RS:FindFirstChild("Controllers")
        if Controllers and Controllers:FindFirstChild("CombatController") then
            CombatController = require(Controllers.CombatController)
            if getupvalue then
                ShootFunction = getupvalue(CombatController.Attack, 9)
            end
        end
    end)

    local Remotes = {}
    local RemoteFolder = RS:FindFirstChild("Remotes")
    if RemoteFolder then
        for _, child in ipairs(RemoteFolder:GetChildren()) do
            if child:IsA("RemoteEvent") then
                local id = child:GetAttribute("Id")
                if id then
                    Remotes[id] = child
                end
            end
        end

        RemoteFolder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") then
                local id = child:GetAttribute("Id")
                if id then
                    Remotes[id] = child
                end
            end
        end)
    end


    local function GetValidator2()
        if not getupvalue or not setupvalue or not ShootFunction then return nil, nil end
        local success, v1_val, v7_val = pcall(function()
            local u27 = getupvalue(ShootFunction, 13)
            local u23 = getupvalue(ShootFunction, 14)
            local u26 = getupvalue(ShootFunction, 15)
            local u22 = getupvalue(ShootFunction, 16)
            local u24 = getupvalue(ShootFunction, 17)
            local u25 = getupvalue(ShootFunction, 18)
            local u28 = getupvalue(ShootFunction, 19)
            
            local u81 = u27 * u23
            local u82 = (u26 * u23 + u27 * u22) % u24
            u82 = (u82 * u24 + u81) % u25
            u26 = math.floor(u82 / u24)
            u27 = u82 - u26 * u24
            u28 = u28 + 1
            
            setupvalue(ShootFunction, 13, u27)
            setupvalue(ShootFunction, 14, u23)
            setupvalue(ShootFunction, 15, u26)
            setupvalue(ShootFunction, 16, u22)
            setupvalue(ShootFunction, 17, u24)
            setupvalue(ShootFunction, 18, u25)
            setupvalue(ShootFunction, 19, u28)
            
            return math.floor(u82 / u25 * 16777215), u28
        end)
        if success and v1_val and v7_val then return v1_val, v7_val end
        return nil, nil
    end


    local lastGunShoot = 0

    while task.wait(0.03) do
        pcall(function()
            if not (getgenv().Config and getgenv().Config["AutoShoot"] == true) then return end
            local char = LP.Character
            if not char then return end

            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then return end

            local equippedTool = char:FindFirstChildOfClass("Tool")
            if not equippedTool or equippedTool.ToolTip ~= "Gun" then return end

            local targetPart = getgenv().CurrentTargetPart
            if not targetPart then
                local targetPlayer = getgenv().targ
                if targetPlayer and targetPlayer.Character then
                    targetPart = targetPlayer.Character:FindFirstChild("Head") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                end
            end

            if not targetPart then return end

            local cd = (equippedTool:FindFirstChild("Cooldown") and equippedTool.Cooldown.Value) or 0.25
            if tick() - lastGunShoot < cd then return end
            lastGunShoot = tick()

            local targetPos = (getgenv().LatestPredictedPos or targetPart.Position)
            getgenv().MacroAimPos = CFrame.new(targetPos)

            if ShootFunction and GunValidator then
                local val1, val2 = GetValidator2()
                if val1 and val2 then
                    GunValidator:FireServer(val1, val2)
                end
            end

            if equippedTool:FindFirstChild("RemoteEvent") then
                equippedTool.RemoteEvent:FireServer("TAP", targetPos)
            end

            local netShoot = Remotes["RE/ShootGunEvent"] or ShootGunEvent
            if netShoot then
                netShoot:FireServer(targetPos, {targetPart})
            elseif NetModule and NetModule.RemoteEvent then
                NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos, {targetPart})
            end

            if VIM then
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    end
end)


task.spawn(function()
    local lp = LocalPlayer

    local function down(use, waitTime)
        pcall(function()
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                vim1:SendKeyEvent(true, use, false, lp.Character.HumanoidRootPart)
                task.wait(waitTime or 0.1)
                vim1:SendKeyEvent(false, use, false, lp.Character.HumanoidRootPart)
            end
        end)
    end

    local function Useskills(weapon, skill)
        if weapon == "nil" and skill == "Y" then
            vim1:SendKeyEvent(true, "Y", false, game)
            vim1:SendKeyEvent(false, "Y", false, game)
        end
    end

    local function equip(typeCheck)
        local tooltipToFind = typeCheck
        if typeCheck == "Fruit" then tooltipToFind = "Blox Fruit" end
        
        for _, item in pairs(lp.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip == tooltipToFind then
                local humanoid = lp.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and not humanoid:IsDescendantOf(item) then
                    humanoid:EquipTool(item)
                    return item.Name
                end
            end
        end
        for _, item in pairs(lp.Character:GetChildren()) do
            if item:IsA("Tool") and item.ToolTip == tooltipToFind then
                return item.Name
            end
        end
        return nil
    end

---------
task.spawn(function()
    local CollectionService = Services.CollectionService or game:GetService("CollectionService")
    local LP = LocalPlayer or game:GetService("Players").LocalPlayer

    local function applyPvpSession(targetChar)
        pcall(function()
            if not CollectionService:HasTag(LP, "PvpSessionComponent") then
                CollectionService:AddTag(LP, "PvpSessionComponent")
            end

            LP:SetAttribute("State", "Playing")
            LP:SetAttribute("TeamId", 1)
            LP:SetAttribute("MatchEndTime", workspace:GetServerTimeNow() + 300)

            local character = targetChar or LP.Character
            if character then
                if not CollectionService:HasTag(character, "PvpSessionComponent") then
                    CollectionService:AddTag(character, "PvpSessionComponent")
                end
                character:SetAttribute("State", "Playing")
                character:SetAttribute("TeamId", 1)
                character:SetAttribute("MatchEndTime", workspace:GetServerTimeNow() + 300)
            end
        end)
    end

    applyPvpSession(LP.Character)

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.2)
        applyPvpSession(newChar)
    end)

    while task.wait(1) do
        applyPvpSession(LP.Character)
    end
end)
---------

    
    task.spawn(function()
        while task.wait() do
            pcall(function()
                getgenv().CurrentTarget = currentTarget
                getgenv().targ = currentTarget
            end)
        end
    end)

    task.spawn(function()
        while task.wait() do 
            pcall(function()
                if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    
                    local targetPos = currentTarget.Character.HumanoidRootPart.Position
                    if getgenv().Config and getgenv().Config["SpinLock"] == "Prediction" and getgenv().LatestPredictedPos then
                        targetPos = getgenv().LatestPredictedPos
                    end
                    
                    if (targetPos - lp.Character.HumanoidRootPart.Position).Magnitude < 50 then
                        
                        if getgenv().Config and getgenv().Config["Auto Enable V3"] then
                            if getgenv().Config["Custom Health"] and lp.Character:FindFirstChild("Humanoid") and
                                lp.Character.Humanoid.Health <= getgenv().Config["Health"] then
                                down("T", 0.1)
                            end
                        end
                        
                    end
                end
            end)
        end
    end)

---------
---------
    task.spawn(function()
        local lastWeapon = nil
        while task.wait() do
            pcall(function()
                local inRange = false
                local targetPos = nil
                
                if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") and 
                   lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    
                    targetPos = currentTarget.Character.HumanoidRootPart.Position
                    if getgenv().Config and getgenv().Config["SpinLock"] == "Prediction" and getgenv().LatestPredictedPos then
                        targetPos = getgenv().LatestPredictedPos
                    end
                    
                    local myPos = lp.Character.HumanoidRootPart.CFrame.Position
                    local distXZ = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
                    
                    if distXZ <= 40 then 
                        inRange = true
                    end
                end

             local queue = {}
                local hasSkillEnabled = false
                
                if getgenv().Config then
                    for typeName, typeData in pairs(getgenv().Config) do
                        if type(typeData) == "table" and typeData.Enable then
                            for skillKey, skillData in pairs(typeData) do
                                if type(skillData) == "table" and skillData.Enable and skillData.Priority then
                                    if getgenv().Config["ModeGhost"] and typeName == "Fruit" and skillKey == "V" then
                                        continue
                                    end
                                    
                                    hasSkillEnabled = true
                                    table.insert(queue, {
                                        Type = typeName,
                                        Key = skillKey,
                                        Data = skillData,
                                        Priority = skillData.Priority
                                    })
                                end
                            end
                        end
                    end
                    
                    if getgenv().Config["ModeGhost"] then
                        hasSkillEnabled = true
                        local vData = {["HoldTime"] = 0, ["Count"] = 10, ["CountInterval"] = 0.005, ["DelayChange"] = 0.2}
                        if getgenv().Config["Fruit"] and type(getgenv().Config["Fruit"]["V"]) == "table" then
                            vData = getgenv().Config["Fruit"]["V"]
                        end
                        
                        table.insert(queue, {
                            Type = "Fruit",
                            Key = "V",
                            Data = vData,
                            Priority = 1
                        })
                    end
                end
                
                table.sort(queue, function(a, b) return a.Priority < b.Priority end)
                
                local allOnCooldown = true
                
                if not hasSkillEnabled and getgenv().Config then
                    for typeName, typeData in pairs(getgenv().Config) do
                        if type(typeData) == "table" and typeData.Enable then
                            local anySkillActive = false
                            for k, v in pairs(typeData) do
                                if type(v) == "table" and v.Enable then
                                    anySkillActive = true
                                    break
                                end
                            end
                            if not anySkillActive then
                                equip(typeName)
                                break
                            end
                        end
                    end
                end

                if hasSkillEnabled then
                    for _, item in ipairs(queue) do
                        local tooltipToFind = item.Type
                        if item.Type == "Fruit" then tooltipToFind = "Blox Fruit" end
                        
                        local toolName = nil
                        for _, tool in pairs(lp.Backpack:GetChildren()) do
                            if tool:IsA("Tool") and tool.ToolTip == tooltipToFind then
                                toolName = tool.Name
                                break
                            end
                        end
                        if not toolName then
                            for _, tool in pairs(lp.Character:GetChildren()) do
                                if tool:IsA("Tool") and tool.ToolTip == tooltipToFind then
                                    toolName = tool.Name
                                    break
                                end
                            end
                        end

                        if toolName then
                            local skillGui = lp.PlayerGui.Main.Skills:FindFirstChild(toolName)
                            local isReady = false
                            
                            if skillGui and skillGui:FindFirstChild(item.Key) then
                                local cdGui = skillGui[item.Key]:FindFirstChild("Cooldown")
                                if cdGui and cdGui.AbsoluteSize.X <= 0 then
                                    isReady = true
                                end
                            elseif not skillGui then
                                isReady = true
                            end

                            if isReady then
                                equip(item.Type)
                                
                                skillGui = lp.PlayerGui.Main.Skills:FindFirstChild(toolName)
                                local waitTime = tick()
                                while not skillGui and tick() - waitTime < 0.2 do
                                    task.wait()
                                    skillGui = lp.PlayerGui.Main.Skills:FindFirstChild(toolName)
                                end

                                if skillGui and skillGui:FindFirstChild(item.Key) then
                                    local cdGui = skillGui[item.Key]:FindFirstChild("Cooldown")
                                    
                                    if cdGui and cdGui.AbsoluteSize.X <= 0 then
                                        allOnCooldown = false

                                        if currentTarget and inRange and not _G.IsSkyHopping and not getgenv()._SafeJumped and (tick() - (getgenv()._LastSafeLanded or 0) >= 0.2) then

                                                lastWeapon = toolName

                                            for i = 1, (item.Data.Count or 1) do
                                                if cdGui.AbsoluteSize.X > 0 then
                                                    break
                                                end
                                                down(item.Key, item.Data.HoldTime)
                                                task.wait(item.Data.CountInterval or 0.05)
                                            end
                                            
                                            local delayTime = item.Data.DelayChange or 0
                                            getgenv()._LastSkillTick = tick()
                                            getgenv()._SkillDelayNeeded = (delayTime == 0) and 0.5 or delayTime
                                            
                                            if delayTime > 0 then
                                                task.wait(delayTime)
                                            end
                                                    
                                            end
                                        break
                                    end
                                end
                            end
                        end
                    end
                    

                    if allOnCooldown then
                        getgenv().SkillsOnCooldown = true
                    else
                        getgenv().SkillsOnCooldown = false
                    end

                    if lastCooldownState ~= getgenv().SkillsOnCooldown then
                        lastCooldownState = getgenv().SkillsOnCooldown
                        print("SkillsOnCooldown: " .. tostring(getgenv().SkillsOnCooldown))
                    end
                    
                    if getgenv().SkillsOnCooldown then
                    end
                else
                    getgenv().SkillsOnCooldown = false
                    if lastCooldownState ~= false then
                        lastCooldownState = false
                        print("SkillsOnCooldown: false (No Skills)")
                    end
                end
            end)
        end
    end)
end)


local function M1Fruit()
-- Services 
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local LocalPlayer        = Players.LocalPlayer
local cfg = getgenv().Config or Config

if cfg and cfg["FruitM1"] == true then
    _G.G_FruitM1 = true
end

if cfg and cfg["FruitInstantKill"] == true then
    _G.G_VoidFruitM1 = true
end
_G.G_AttackMobs = true
_G.G_AttackPlayers = true

-- FruitM1 Logic
local FruitM1 = { maxVec = Vector3.new(-9e30, -9e30, -9e30) }

function FruitM1.GetFruit()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
            return tool
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                return tool
            end
        end
    end
    return nil
end

function FruitM1.GetInterval(tool)
    if not tool then return 0.1 end
    local char = LocalPlayer.Character
    if not char then return 0.1 end
    local base
    pcall(function()
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        local container = gui and gui:FindFirstChild("MovesetModules")
        local mod = container and container:FindFirstChild(tool.Name)
        local agg = mod and mod:FindFirstChild("LegacyDataAggregate")
        local data = agg and require(agg)
        if type(data) ~= "table" then return end
        local cd
        local aw = tool:FindFirstChild("AwakenedMoves")
        if aw and aw:FindFirstChild("TAP") and type(data.Awakening) == "table" and type(data.Awakening.Cooldown) == "table" then
            cd = data.Awakening.Cooldown.TAP
        elseif type(data.Cooldown) == "table" then
            cd = data.Cooldown.TAP
        end
        if type(cd) == "function" then cd = cd(tool) end
        if type(cd) == "number" then base = cd end
    end)
    if type(base) ~= "number" then return 0.1 end
    local tip = tool.ToolTip
    if tip == "Blox Fruit" then tip = "Fruit" end
    local tapCd = char:GetAttribute(tip .. "TAPCooldown") or 0
    local nsuns = LocalPlayer:GetAttribute("NSUNS")
    local speed = (1 - tapCd) * (nsuns and 0 or 1)
    return base * speed * 1.5
end

function FruitM1.IsTrex(tool)      return tool ~= nil and tool.Name == "T-Rex-T-Rex" end
function FruitM1.IsTransformed(tool)
    local rig = tool and tool:FindFirstChild("TransformedRigObject")
    return rig ~= nil and rig.Value ~= nil
end
function FruitM1.IsDragon(tool)    return tool ~= nil and tool.Name == "Dragon-Dragon" end
function FruitM1.IsBlade(tool)     return tool ~= nil and tool.Name == "Blade-Blade" end
function FruitM1.IsPain(tool)      return tool ~= nil and tool.Name == "Pain-Pain" end
function FruitM1.IsControl(tool)   return tool ~= nil and tool.Name == "Control-Control" end
function FruitM1.IsGas(tool)       return tool ~= nil and tool.Name == "Gas-Gas" end

function FruitM1.MaxCombo(tool)
    if FruitM1.IsTrex(tool)    then return 4 end
    if FruitM1.IsBlade(tool)   then return 2 end
    if FruitM1.IsPain(tool)    then return 4 end
    if FruitM1.IsControl(tool) then return 4 end
    if FruitM1.IsGas(tool)     then return 5 end
    if FruitM1.IsDragon(tool) then
        local char = LocalPlayer.Character
        return (char and char:FindFirstChild("DragonHybrid")) and 5 or 3
    end
    return 5
end

function FruitM1.ScanTapFn(tool, fn)
    local comboIdx, nextIdx, timerIdx, hasTool
    local stateTable
    for n = 1, 30 do
        local ok2, v = pcall(debug.getupvalue, fn, n)
        if not ok2 then break end
        if v == tool then hasTool = true end
        if type(v) == "number" then
            if not comboIdx and v >= 1 and v <= 5 and v == math.floor(v) then
                comboIdx = n
            elseif not nextIdx and v > 1 then
                nextIdx = n
            end
        elseif type(v) == "thread" and not timerIdx then
            timerIdx = n
        elseif type(v) == "table" and not stateTable then
            local ok3, ability = pcall(function() return v.thisAbility end)
            if ok3 and type(ability) == "number" and type(v.lastUseTime) == "number" then
                stateTable = v
            end
        end
    end
    if stateTable then
        return { tbl = stateTable, fn = fn }
    end
    if hasTool and comboIdx and nextIdx and timerIdx then
        return { fn = fn, combo = comboIdx, next = nextIdx, timer = timerIdx }
    end
    return nil
end

function FruitM1.GetTapState(tool)
    local ok, conns = pcall(getconnections, tool.Activated)
    if not ok or type(conns) ~= "table" then return nil end
    for _, c in ipairs(conns) do
        local fn = c.Function
        if fn then
            local st = FruitM1.ScanTapFn(tool, fn)
            if st then return st end
            for n = 1, 8 do
                local ok2, v = pcall(debug.getupvalue, fn, n)
                if not ok2 then break end
                if type(v) == "function" then
                    st = FruitM1.ScanTapFn(tool, v)
                    if st then return st end
                end
            end
        end
    end
    return nil
end

function FruitM1.TapInterval(combo, maxCombo)
    if _G.G_VoidFruitM1 and combo and maxCombo and combo >= maxCombo then return 1 end
    local char = LocalPlayer.Character
    local cd = 0
    if char then cd = char:GetAttribute("FruitTAPCooldown") or 0 end
    return 0.2 - cd
end

local function checkTargetKen(targetPlayer)
    if not targetPlayer then return false end
    local char = targetPlayer.Character
    if not char then return false end
    if char:FindFirstChild("KenDisabled") then
        return false
    end
    local isKenActive = targetPlayer:GetAttribute("KenActive")
    if not isKenActive then
        return false
    end
    local dodgesLeft = targetPlayer:GetAttribute("KenDodgesLeft") or 0
    if dodgesLeft <= 0 then
        return false
    end
    return true
end

-- Effects (per-fruit)
function FruitM1.Effect(tool, index, dir)
    if not tool then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if FruitM1.IsGas(tool) then
        task.defer(function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
                local gas = container and container:FindFirstChild("Gas")
                local name = char:FindFirstChild("GasRig") and "Transformed" or nil
                local folder = name and gas:FindFirstChild(name) or gas
                local tmpl = folder and folder:FindFirstChild("M1")
                Effect.new(tmpl):play({
                    Character = char,
                    Index = index or 1,
                    CFrame = CFrame.new(Vector3.new(0, 0, 0), dir or hrp.CFrame.LookVector) + hrp.Position,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    if FruitM1.IsControl(tool) then
        task.delay(0.05, function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
                local cr = container and container:FindFirstChild("ControlRework")
                local m1 = cr and cr:FindFirstChild("M1")
                local tmpl = m1 and m1:FindFirstChild("Dagger_Outside")
                Effect.new(tmpl):play({
                    Origin = hrp.Position,
                    Player = LocalPlayer,
                    Combo = index or 1,
                    Character = char,
                    Root = hrp,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    if FruitM1.IsPain(tool) then
        task.delay(0.08, function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
                local pain = container and container:FindFirstChild("Pain")
                local name = char:FindFirstChild("PainTransformed") and "M1_Awakened" or "M1"
                local tmpl = pain and pain:FindFirstChild(name)
                Effect.new(tmpl):play({
                    origin = hrp.Position,
                    player = LocalPlayer,
                    Combo = index or 1,
                    Character = char,
                    Root = hrp,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    if FruitM1.IsBlade(tool) then
        task.delay(0.1, function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
                local blade = container and container:FindFirstChild("Blade")
                local tmpl = blade and blade:FindFirstChild("M1")
                Effect.new(tmpl):replicate({
                    Root = hrp,
                    Combo = index or 1,
                    CFrame = CFrame.new(Vector3.new(0, 0, 0), dir or hrp.CFrame.LookVector) + hrp.Position,
                    player = LocalPlayer,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    if FruitM1.IsDragon(tool) then
        task.delay(0.1, function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
                local dragon2 = container and container:FindFirstChild("Dragon2")
                local tmpl = dragon2 and dragon2:FindFirstChild("M1")
                Effect.new(tmpl):replicate({
                    player = LocalPlayer,
                    Root = hrp,
                    Combo = index or 1,
                    MaxCombo = FruitM1.MaxCombo(tool),
                    Hybrid = char:FindFirstChild("DragonHybrid") ~= nil,
                    CFrame = CFrame.new(Vector3.new(0, 0, 0), dir or hrp.CFrame.LookVector) + hrp.Position,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    if FruitM1.IsTrex(tool) then
        local path = "Dino." .. (FruitM1.IsTransformed(tool) and "Transformed." or "") .. "TAP"
        task.delay(0.1, function()
            local ok, err = pcall(function()
                local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
                Effect.new(Effect.getModule(path)):play({
                    Character = char,
                    ID = index or 1,
                    player = LocalPlayer,
                })
            end)
            if not ok then warn("[FruitM1] effect error:", err) end
        end)
        return
    end

    -- Generic fruit effect
    local fruit = tool.Name:match("^([^%-]+)")
    local container = game.ReplicatedStorage:FindFirstChild("EffectContainer")
    local folder = container and fruit and container:FindFirstChild(fruit)
    local template = folder and folder:FindFirstChild("M1Combo")
    if not template then return end

    local filter = { char }
    for _, childName in ipairs({ "_WorldOrigin", "Characters", "Enemies" }) do
        local child = workspace:FindFirstChild(childName)
        if child then table.insert(filter, child) end
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = filter
    local onGround = workspace:Raycast(hrp.Position, -(hum.HipHeight + hrp.Size.Y * 0.5 + 4) * Vector3.new(0, 1, 0), params) ~= nil
    local transformed = false
    local flag = tool:FindFirstChild("IsTransformed")
    if flag then transformed = flag.Value end

    task.delay(0.1, function()
        local ok, err = pcall(function()
            local Effect = require(game.ReplicatedStorage:WaitForChild("Effect"))
            Effect.new(template):replicate({
                player = LocalPlayer,
                hrp = hrp,
                index = index or 1,
                playerOnGround = onGround,
                transformed = transformed,
            })
        end)
        if not ok then warn("[FruitM1] effect error:", err) end
    end)
end

-- Main loop
function FruitM1.SetNormal(enabled)
    FruitM1.on = enabled
    if enabled then
        if FruitM1.conn then task.cancel(FruitM1.conn) end
        if FruitM1.clickConn then task.cancel(FruitM1.clickConn) end

        FruitM1.clickConn = task.spawn(function()
            local vu = game:GetService("VirtualUser")
            while FruitM1.on do
                pcall(function() vu:Button1Down(Vector2.new(1280, 672)) end)
                task.wait(5)
            end
        end)

        FruitM1.conn = task.spawn(function()
            task.wait(2)
            while FruitM1.on do
                local fruit = FruitM1.GetFruit()
                local char  = LocalPlayer.Character
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                local remote = fruit and fruit:FindFirstChild("LeftClickRemote")

                if not fruit or not remote or not myHRP then
                    task.wait(0.1)
                    continue
                end

                -- Refresh tap state
                if FruitM1.tapTool ~= fruit or (not FruitM1.tapState and tick() - (FruitM1.tapAt or 0) > 1) then
                    FruitM1.tapTool  = fruit
                    FruitM1.tapAt    = tick()
                    FruitM1.tapState = FruitM1.GetTapState(fruit)
                end

                local st = FruitM1.tapState
                local combo, nextT
                if st then
                    if st.tbl then
                        if type(st.tbl.thisAbility) == "number" then combo = st.tbl.thisAbility end
                        if type(st.tbl.lastUseTime) == "number" then nextT = st.tbl.lastUseTime end
                    else
                        local ok1, c = pcall(debug.getupvalue, st.fn, st.combo)
                        local ok2, n = pcall(debug.getupvalue, st.fn, st.next)
                        if ok1 and type(c) == "number" then combo = c end
                        if ok2 and type(n) == "number" then nextT = n end
                    end
                end

                if not combo or not nextT then
                    if tick() - (FruitM1.fbAt or 0) > 1 then FruitM1.fbCombo = 1 end
                    combo = FruitM1.fbCombo or 1
                    nextT = 0
                end

                local stun  = char:FindFirstChild("Stun")
                local busy  = char:FindFirstChild("Busy")
                local isTrex   = FruitM1.IsTrex(fruit)
                local isDragon = FruitM1.IsDragon(fruit)
                local isBlade  = FruitM1.IsBlade(fruit)
                local isGas    = FruitM1.IsGas(fruit)
                local dragonRig = isDragon and (char:FindFirstChild("EasternBloxfruitsDragon") or char:FindFirstChild("WesternDragonRig"))
                local blocked = (stun and stun.Value > 0) or (busy and busy.Value) or dragonRig
                local range = 500
                local hit = false

                if combo and nextT and not blocked and time() >= nextT then
                    local maxCombo = _G.G_VoidFruitM1 and FruitM1.MaxCombo(fruit) or (FruitM1.MaxCombo(fruit) - 1)
                    if maxCombo < 1 then maxCombo = 1 end
                    
                    local isInstantKill = (getgenv().Config and getgenv().Config["FruitInstantKill"] == true) or (Config and Config["FruitInstantKill"] == true)
                    local targetCanDodge = checkTargetKen(currentTarget)

                    if isInstantKill and not targetCanDodge then
                        combo = maxCombo
                        if st then
                            if st.tbl then
                                st.tbl.thisAbility = combo
                            else
                                pcall(debug.setupvalue, st.fn, st.combo, combo)
                            end
                        end
                    elseif st and combo > maxCombo then
                        combo = maxCombo
                        if st.tbl then
                            st.tbl.thisAbility = combo
                        else
                            pcall(debug.setupvalue, st.fn, st.combo, combo)
                        end
                    end

                    local targets = {}
                    if _G.G_AttackPlayers then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                                local hum       = player.Character:FindFirstChild("Humanoid")
                                if targetHRP and hum and hum.Health > 0 and (targetHRP.Position - myHRP.Position).Magnitude < range then
                                    table.insert(targets, targetHRP)
                                end
                            end
                        end
                    end

                    if _G.G_AttackMobs then
                        local enemiesFolder = workspace:FindFirstChild("Enemies")
                        if enemiesFolder then
                            for _, npc in pairs(enemiesFolder:GetChildren()) do
                                local targetHRP = npc:FindFirstChild("HumanoidRootPart")
                                local hum       = npc:FindFirstChild("Humanoid")
                                if targetHRP and hum and hum.Health > 0 and (targetHRP.Position - myHRP.Position).Magnitude < range then
                                    table.insert(targets, targetHRP)
                                end
                            end
                        end
                    end

                    if #targets > 0 then
                        for _, targetHRP in ipairs(targets) do
                            local dir = (targetHRP.Position - myHRP.Position).Unit
                            local fireDir = (_G.G_VoidFruitM1 and combo >= maxCombo) and FruitM1.maxVec or dir
                            if isTrex or isDragon or isBlade or isGas then
                                pcall(function() remote:FireServer(fireDir, combo) end)
                            else
                                pcall(function() remote:FireServer(fireDir, combo, true) end)
                            end
                        end

                        local dir = ((targets[1].Position - myHRP.Position) * Vector3.new(1, 0, 1)).Unit

                        if st then
                            local nextCombo = combo < maxCombo and combo + 1 or 1
                            local nextTime  = time() + FruitM1.TapInterval(combo, maxCombo)
                            if st.tbl then
                                st.tbl.thisAbility  = nextCombo
                                st.tbl.lastUseTime  = nextTime
                                if st.tbl.prevTask then pcall(task.cancel, st.tbl.prevTask) end
                                st.tbl.prevTask = task.delay(1, function()
                                    st.tbl.thisAbility = 1
                                end)
                            else
                                pcall(debug.setupvalue, st.fn, st.combo, nextCombo)
                                pcall(debug.setupvalue, st.fn, st.next, nextTime)
                                local okT, timer = pcall(debug.getupvalue, st.fn, st.timer)
                                if okT and timer then pcall(task.cancel, timer) end
                                pcall(debug.setupvalue, st.fn, st.timer, task.delay(1, function()
                                    pcall(debug.setupvalue, st.fn, st.combo, 1)
                                end))
                            end
                        else
                            FruitM1.fbCombo = combo < maxCombo and combo + 1 or 1
                            FruitM1.fbAt    = tick()
                        end

                        FruitM1.Effect(fruit, combo, dir)
                        hit = true
                    end
                end

                if hit then
                    if st then
                        task.wait(0.05)
                    else
                        local w = FruitM1.TapInterval(combo, FruitM1.MaxCombo(fruit))
                        if w < 0 then w = 0 end
                        task.wait(w)
                    end
                else
                    task.wait(0.1)
                end
            end
        end)
    else
        if FruitM1.conn then
            task.cancel(FruitM1.conn)
            FruitM1.conn = nil
        end
        if FruitM1.clickConn then
            task.cancel(FruitM1.clickConn)
            FruitM1.clickConn = nil
        end
    end
end

-- Auto start if already ON
if _G.G_FruitM1 then
    FruitM1.SetNormal(true)
end
end


if Config and (Config["FruitInstantKill"] == true or Config["FruitM1"] == true) then
    M1Fruit()
end

---------
local function getOffsets()
    return {
        Vector3.new(0.707, 0, 0.707),
        Vector3.new(-0.707, 0, 0.707),
        Vector3.new(0.707, 0, -0.707),
        Vector3.new(-0.707, 0, -0.707),
        Vector3.new(0, 0, 1),
        Vector3.new(0, 0, -1),
        Vector3.new(-1, 0, 0),
        Vector3.new(1, 0, 0)
    }
end

---------
local function getWaterSafeY()
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
        if waterPlane then
            return waterPlane.Position.Y + (waterPlane.Size.Y / 2) + 2
        end
    end
    return 15 
end

---------
_G.IsSkyHopping = false

task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().AutoAimbot then continue end
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("Humanoid") and myChar:FindFirstChild("HumanoidRootPart") then
            local hum = myChar.Humanoid
            local root = myChar.HumanoidRootPart

            if hum.Health > 0 and hum.MaxHealth > 0 then
                local hpPercent = hum.Health / hum.MaxHealth
                if hpPercent < 0.4 and not _G.IsSkyHopping then
                    _G.IsSkyHopping = true
                    pcall(function()
                        if _G.MainMoveTween and _G.MainMoveTween.PlaybackState == Enum.PlaybackState.Playing then
                            _G.MainMoveTween:Cancel()
                        end
                    end)

                    local safeX = root.Position.X
                    local safeZ = root.Position.Z
                    local startY = root.Position.Y
                    root.CFrame = CFrame.new(safeX, startY + 2000, safeZ)

                    task.wait(0.2)

                    local skyTween
                    while _G.IsSkyHopping do
                        task.wait(0.1)
                        if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 then
                            _G.IsSkyHopping = false
                            if skyTween then skyTween:Cancel() end
                            break
                        end

                        local currentHpPercent = myChar.Humanoid.Health / myChar.Humanoid.MaxHealth
                        if currentHpPercent >= 0.7 then
                            _G.IsSkyHopping = false
                            if skyTween then skyTween:Cancel() end

                            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                                local targetRoot = currentTarget.Character.HumanoidRootPart
                                root.CFrame = CFrame.new(root.Position.X, targetRoot.Position.Y, root.Position.Z)
                            end
                            break
                        end

                        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                            local targetRoot = currentTarget.Character.HumanoidRootPart
                            local targetDistX = targetRoot.Position.X
                            local targetDistZ = targetRoot.Position.Z
                            local targetDistY = targetRoot.Position.Y + 2000
                            local currentSpeed = tonumber(getgenv().Config and getgenv().Config["TweenSpeed"]) or 300
                            local dist = (Vector3.new(targetDistX, targetDistY, targetDistZ) - root.Position).Magnitude
                            local timeToTween = dist / currentSpeed
                            
                            if timeToTween > 0 then
                                if skyTween then skyTween:Cancel() end
                                skyTween = Services.TweenService:Create(root, TweenInfo.new(timeToTween, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetDistX, targetDistY, targetDistZ)})
                                skyTween:Play()
                            end
                        end
                    end
                end
            end
        end
    end
end)



task.spawn(function()
    while task.wait() do
        pcall(function()
            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                local targetY = currentTarget.Character.HumanoidRootPart.Position.Y
                
                if targetY > 500000 then
                    _G.DisableSpecialTP = true
                else
                    _G.DisableSpecialTP = false
                end
            else
                _G.DisableSpecialTP = false
            end
        end)
    end
end)
---------
---------
task.spawn(function()
    local runService = Services and Services.RunService or game:GetService("RunService")
    local players = Services and Services.Players or game:GetService("Players")
    local lp = LocalPlayer or players.LocalPlayer

    local function applyNoclip()
        local char = lp.Character
        if char and char.Parent then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end

    local connection
    local function initNoclip()
        if connection then
            pcall(function() connection:Disconnect() end)
            connection = nil
        end
        connection = runService.Stepped:Connect(function()
            pcall(applyNoclip)
        end)
    end

    initNoclip()

    lp.CharacterAdded:Connect(function()
        task.wait()
        initNoclip()
    end)

    while task.wait() do
        if not connection or not connection.Connected then
            initNoclip()
        end
    end
end)
---------
task.spawn(function()
    local RunService = Services and Services.RunService or game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local LP = LocalPlayer or game:GetService("Players").LocalPlayer

    RunService.Heartbeat:Connect(function()
        pcall(function()
            Workspace.Gravity = 0

            local char = LP.Character
            if not char then return end

            local hum = char:FindFirstChild("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")

            if hum and hrp and hum.Health > 0 then
                hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

                local curState = hum:GetState()
                if curState == Enum.HumanoidStateType.Freefall or curState == Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end

                local vel = hrp.AssemblyLinearVelocity
                if vel.Y < 0 then
                    hrp.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
                end
            end
        end)
    end)
end)
---------
---------
local function CreateNotifyGui()
    local pGui = player:WaitForChild("PlayerGui")
    if pGui:FindFirstChild("MeyyCloudNotify") then return pGui:FindFirstChild("MeyyCloudNotify") end
    local sg = Instance.new("ScreenGui")
    sg.Name = "MeyyCloudNotify"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.Parent = Services.CoreGui or pGui
    return sg
end

NotificationSystem.gui = CreateNotifyGui()

function NotificationSystem:UpdatePositions()
    for i, notif in ipairs(self.notifications) do
        if notif and notif.Parent then
            local targetPos = UDim2.new(1, -15, 1, -15 - ((i - 1) * self.spacing))
            TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        end
    end
end

---------
function NotificationSystem:Notify(title, message, duration)
    self.spacing = 65 
    local dur = duration or 3
    
    for _, notif in ipairs(self.notifications) do
        if notif and notif.Parent and notif:GetAttribute("NotifTitle") == title then
            local msgLbl = notif:FindFirstChild("MessageLabel")
            if msgLbl then
                msgLbl.Text = message
            end
            notif:SetAttribute("ExpireTime", tick() + dur)
            return
        end
    end

    local m = Instance.new("Frame", self.gui)
    m.BackgroundColor3 = Color3.fromRGB(15, 15, 15) 
    m.BackgroundTransparency = 0.25 
    m.Size = UDim2.new(0, 220, 0, 55) 
    m.Position = UDim2.new(1, 250, 1, -15) 
    m.AnchorPoint = Vector2.new(1, 1)
    m.ClipsDescendants = true
    m:SetAttribute("NotifTitle", title)
    m:SetAttribute("ExpireTime", tick() + dur)
    Instance.new("UICorner", m).CornerRadius = UDim.new(0, 8)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 1.2
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)
    e.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(85, 85, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(84, 98, 111))
    })

    local function CreateLabel(txt, pos, sz, isTitle)
        local l = Instance.new("TextLabel", m)
        l.Name = isTitle and "TitleLabel" or "MessageLabel"
        l.Size = UDim2.new(1, -24, 0, 20)
        l.Position = UDim2.new(0.5, 0, 0, pos)
        l.AnchorPoint = Vector2.new(0.5, 0)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.GothamBold
        l.Text = txt
        l.TextSize = sz
        l.TextColor3 = Color3.new(1, 1, 1)
        l.TextXAlignment = Enum.TextXAlignment.Left
        
        local grad = Instance.new("UIGradient", l)
        grad.Rotation = 90
        if isTitle then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(211, 211, 211)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 128, 128))
            })
        else
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 170, 170)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 100))
            })
        end
        return l
    end

    CreateLabel(title, 8, 13, true)
    CreateLabel(message, 27, 11, false)

    local r = 0
    local conn
    conn = RunService.RenderStepped:Connect(function()
        r = (r + 1.5) % 360
        e.Rotation = r
    end)

    table.insert(self.notifications, m)
    self:UpdatePositions()

    task.spawn(function()
        while m and m.Parent do
            if tick() >= m:GetAttribute("ExpireTime") then
                for i, notif in ipairs(self.notifications) do
                    if notif == m then table.remove(self.notifications, i) break end
                end
                self:UpdatePositions()
                local hide = TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 250, m.Position.Y.Scale, m.Position.Y.Offset)})
                hide:Play()
                hide.Completed:Connect(function()
                    if conn then conn:Disconnect() end
                    m:Destroy()
                end)
                break
            end
            task.wait(0.1)
        end
    end)
end

---------
function notify(title, msg, time)
    pcall(function()
        local sys = _G.Notify or NotificationSystem
        if sys and sys.Notify then
            sys:Notify(title, msg, time or 3)
        end
    end)
end
---------
---------

local function getBounty(p)
    local ok, val = pcall(function()
        local ls = p:FindFirstChild("leaderstats")
        if ls then
            local b = ls:FindFirstChild("Bounty/Honor") or ls:FindFirstChild("Bounty") or ls:FindFirstChild("Honor")
            if b then return b.Value end
        end
        return 0
    end)
    return ok and val or 0
end


local function isInSafeZone(p)
    if not p or not p.Character then 
        return false 
    end
    
    local char = p.Character
    if char:FindFirstChild("TempSafeZone") then 
        return true 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        return false 
    end
    
    local safeZones = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("SafeZones")
    if safeZones then
        local pos = hrp.Position
        for _, v in safeZones:GetChildren() do
            if v:IsA("BasePart") then
                local mesh = v:FindFirstChildOfClass("SpecialMesh")
                local radius = mesh and (mesh.Scale.X * 0.5) or (v.Size.X * 0.5)
                if (v.Position - pos).Magnitude <= radius then
                    return true
                end
            end
        end
    end
    
    return false
end


local function isPvPDisabled(p)
    return p:GetAttribute("PvpDisabled") == true
end


function risk() 
       local success, val = pcall(function()
        local mainGui = player.PlayerGui:FindFirstChild("Main")
        if mainGui then
            for _, v in ipairs(mainGui:GetDescendants()) do
                if v:IsA("TextLabel") and v.Visible then
                    local text = v.Text
                    if string.find(text, "risk") or string.find(text, "Risk") then
                        return true
                    end
                end
            end
        end
        return false
    end)
    return success and val
end
local function getTargetCFrame(target)
    local success, result = pcall(function()
        if typeof(target) == "CFrame" then return target
        elseif typeof(target) == "Vector3" then return CFrame.new(target)
        elseif typeof(target) == "Instance" then
            if target:IsA("Player") and target.Character then
                local root = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
                if root then return root.CFrame end
            elseif target:IsA("Model") then
                local root = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head")
                if root then return root.CFrame else return target:GetPivot() end
            elseif target:IsA("BasePart") then return target.CFrame
            end
        elseif type(target) == "table" and target.Character then
            local root = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Head")
            if root then return root.CFrame end
        end
        return nil
    end)
    return success and result or nil
end

local place_check = game.PlaceId
local SeaIndex = (place_check == 7449423635 or place_check == 100117331123089) and 3 or (place_check == 4442272183 or place_check == 79091703265657) and 2 or 1

---------
local TP_Connection = nil
local TP_Target = nil
local TP_NoclipLoop = nil
local lastOffsetChange = tick()
local currentOffsetIndex = 1

local alignPosition = nil
local targetAttachment = nil
local rootAttachment = nil

local function EnableNoclip(hrp)
    if not TP_NoclipLoop then
        TP_NoclipLoop = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function DisableNoclip()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if alignPosition then alignPosition:Destroy(); alignPosition = nil end
    if targetAttachment then targetAttachment:Destroy(); targetAttachment = nil end
    if rootAttachment then rootAttachment:Destroy(); rootAttachment = nil end
    
    if TP_NoclipLoop then
        TP_NoclipLoop:Disconnect()
        TP_NoclipLoop = nil
    end
end


local currentTween = nil
function teleportTo(target)
    if _G.IsSkyHopping then return end
    
    local char = LocalPlayer.Character
    local statesToDisable = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.GettingUp
    }

    local function restoreStates(c)
        if not c then return end
        local h = c:FindFirstChild("Humanoid")
        local r = c:FindFirstChild("HumanoidRootPart")
        if h then
            h.PlatformStand = false
            for _, state in ipairs(statesToDisable) do
                h:SetStateEnabled(state, true)
            end
        end
        if r and r:FindFirstChild("TP_BodyGyro") then
            r.TP_BodyGyro:Destroy()
        end
    end

    if not getgenv().AutoAimbot or not currentTarget then
        TP_Target = nil
        tpMethodLock = nil
        restoreStates(char)
        DisableNoclip()
        if currentTween then currentTween:Cancel(); currentTween = nil end
        if TP_Connection then
            TP_Connection:Disconnect()
            TP_Connection = nil
        end
        return
    end

    if TP_Target ~= currentTarget then
        tpMethodLock = nil
        if currentTween then currentTween:Cancel(); currentTween = nil end
        getgenv().LastTweenTargetPos = nil
    end
    TP_Target = currentTarget

    if not TP_Connection then
        TP_Connection = RunService.Stepped:Connect(function(time, deltaTime)
            local char = LocalPlayer.Character
            
            if not getgenv().AutoAimbot or not currentTarget or _G.IsSkyHopping then
                restoreStates(char)
                DisableNoclip()
                if currentTween then currentTween:Cancel(); currentTween = nil end
                return
            end

            if isTeleportingMap then 
                if currentTween then currentTween:Cancel(); currentTween = nil end
                return 
            end

            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if not hrp or not hum or hum.Health <= 0 then
                restoreStates(char)
                DisableNoclip()
                if currentTween then currentTween:Cancel(); currentTween = nil end
                return
            end

            local targetCFrame = getTargetCFrame(currentTarget)
            if not targetCFrame then return end
            
            local offsetY = (getgenv().Config and getgenv().Config["yHightDistance"]) or 5
            local lockMode = getgenv().Config and getgenv().Config["SpinLock"] or "Body"
            
            local rawTargetPos = targetCFrame.Position
            if lockMode == "Prediction" and getgenv().LatestPredictedPos then
                rawTargetPos = Vector3.new(getgenv().LatestPredictedPos.X, targetCFrame.Position.Y, getgenv().LatestPredictedPos.Z)
            end
            
            local baseTargetPos = rawTargetPos + Vector3.new(0, offsetY, 0)
            local dist = (hrp.Position - baseTargetPos).Magnitude
            tpMethodLock = nil
            isTeleportingMap = false

            EnableNoclip(hrp)

            for _, state in ipairs(statesToDisable) do
                hum:SetStateEnabled(state, false)
            end
            hum.PlatformStand = true

            local bg = hrp:FindFirstChild("TP_BodyGyro")
            if not bg then
                bg = Instance.new("BodyGyro")
                bg.Name = "TP_BodyGyro"
                bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.P = 50000
                bg.D = 500
                bg.Parent = hrp
            end

            local currentMyPos = hrp.Position
            local needReset = false

            if not _G.Meyy_LastMovePos then
                _G.Meyy_LastMovePos = currentMyPos
                _G.Meyy_LastMoveTick = tick()
            else
                if (currentMyPos - _G.Meyy_LastMovePos).Magnitude > 3 then
                    _G.Meyy_LastMovePos = currentMyPos
                    _G.Meyy_LastMoveTick = tick()
                elseif dist > 10 and tick() - _G.Meyy_LastMoveTick >= 2.5 then
                    needReset = true
                    _G.Meyy_LastMovePos = currentMyPos
                    _G.Meyy_LastMoveTick = tick()
                end
            end

            if tick() - (lastAlignRefresh or 0) >= 7 then
                needReset = true
                lastAlignRefresh = tick()
            end

            if needReset or not alignPosition or alignPosition.Parent ~= hrp then
                if alignPosition then alignPosition:Destroy(); alignPosition = nil end
                if targetAttachment then targetAttachment:Destroy(); targetAttachment = nil end
                if rootAttachment then rootAttachment:Destroy(); rootAttachment = nil end

                for _, v in ipairs(char:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end

                targetAttachment = Instance.new("Attachment")
                targetAttachment.Name = "MeyyTargetAtt"
                targetAttachment.Parent = workspace.Terrain

                rootAttachment = Instance.new("Attachment")
                rootAttachment.Name = "MeyyRootAtt"
                rootAttachment.Parent = hrp

                alignPosition = Instance.new("AlignPosition")
                alignPosition.Name = "MeyyAlign"
                alignPosition.Mode = Enum.PositionAlignmentMode.TwoAttachment
                alignPosition.Attachment0 = rootAttachment
                alignPosition.Attachment1 = targetAttachment
                alignPosition.MaxForce = 9e99
                alignPosition.MaxVelocity = tonumber(getgenv().Config and getgenv().Config["TweenSpeed"]) or 250
                alignPosition.Responsiveness = 200
                alignPosition.ApplyAtCenterOfMass = true
                alignPosition.Parent = hrp
            end

            local TP_Speed = tonumber(getgenv().Config and getgenv().Config["TweenSpeed"]) or 250
            alignPosition.MaxVelocity = TP_Speed
            alignPosition.Enabled = true

            if dist > 60 then
                _G.Meyy_LockTween = false
                if currentTween then currentTween:Cancel(); currentTween = nil end
                
                if hrp.Position.Y < baseTargetPos.Y - 10 then
                    targetAttachment.WorldPosition = Vector3.new(hrp.Position.X, baseTargetPos.Y, hrp.Position.Z)
                    alignPosition.MaxVelocity = 200 -- Y height distance tween
                    
                    local flatAngle = CFrame.Angles(0, math.atan2(hrp.CFrame.LookVector.X, hrp.CFrame.LookVector.Z), 0)
                    if bg then
                        bg.CFrame = CFrame.new(hrp.Position) * flatAngle
                    end
                else
                    targetAttachment.WorldPosition = baseTargetPos
                    
                    local lookVector = Vector3.new(baseTargetPos.X - hrp.Position.X, baseTargetPos.Y - hrp.Position.Y, baseTargetPos.Z - hrp.Position.Z)
                    if lookVector.Magnitude > 0 then
                        lookVector = lookVector.Unit
                        if bg then
                            bg.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + lookVector)
                        end
                    end
                end
            else
                _G.Meyy_LockTween = true
                if currentTween then currentTween:Cancel(); currentTween = nil end
                
                local offsets = getOffsets()
                if tick() - lastOffsetChange >= 0.5 then
                    currentOffsetIndex = currentOffsetIndex % #offsets + 1
                    lastOffsetChange = tick()
                end
                
                local directionOffset = offsets[currentOffsetIndex]
                local randomY = math.random(Y_MIN, Y_MAX)
                
                local baseLook = targetCFrame.LookVector
                if baseLook.Magnitude < 0.1 then baseLook = Vector3.new(0,0,-1) end
                
                local baseCFrame = CFrame.new(baseTargetPos, baseTargetPos + baseLook)
                
                local currentDist = getgenv().Config and getgenv().Config["SpinDistance"] or 10
                if math.abs(directionOffset.X) > 0 and math.abs(directionOffset.Z) > 0 then
                    currentDist = currentDist * 0.75
                end
                
                local relativeOffset = Vector3.new(directionOffset.X * currentDist, randomY, directionOffset.Z * currentDist)
                local tCFrame = baseCFrame * CFrame.new(relativeOffset)
                
                local safeY = getWaterSafeY()
                local finalY = math.max(tCFrame.Position.Y, safeY)
                
                targetAttachment.WorldPosition = Vector3.new(tCFrame.Position.X, finalY, tCFrame.Position.Z)
                if bg then
                    bg.CFrame = CFrame.new(hrp.Position, baseTargetPos)
                end
            end
            
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end
---------
---------
---------
local fixedBountyMsg = "Meyy Hub Earned {Bounty} Bounty From Target {Target}"

local function sendKillMessage(bounty, target)
    if not getgenv().Config["Message"] or not getgenv().Config["Message"]["Enabled"] then return end
    
    local finalMsg = string.gsub(fixedBountyMsg, "{Bounty}", tostring(bounty))
    finalMsg = string.gsub(finalMsg, "{Target}", tostring(target))
    
    pcall(function()
        if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(finalMsg)
        else
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(finalMsg, "All")
        end
    end)
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if getgenv().Config and getgenv().Config["Message"] and getgenv().Config["Message"]["Enabled"] then
                local msgList = getgenv().Config["Message"]["PriorityList"]
                local delayTime = tonumber(getgenv().Config["Message"]["Delay"]) or 5
                
                if type(msgList) == "table" and #msgList > 0 then
                    for i = 1, #msgList do
                        if not getgenv().Config["Message"]["Enabled"] then break end
                        local msg = msgList[i]
                        
                        pcall(function()
                            if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then
                                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
                            else
                                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
                            end
                        end)
                        
                        task.wait(delayTime)
                    end
                end
            end
        end)
    end
end)
---------
getgenv().SavedServers = getgenv().SavedServers or {}
local isScanningServers = false

local function StartBackgroundServerScanner()
    if isScanningServers then return end
    isScanningServers = true
    task.spawn(function()
        while task.wait(2) do
            pcall(function()
                if #getgenv().SavedServers > 50 then return end
                for r = 1, 300 do 
                    local success, servers = pcall(function() 
                        return game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) 
                    end) 
                    
                    if success and servers then
                        for k, v in pairs(servers) do
                            if k ~= game.JobId and v["Count"] > 8 then 
                                local region = v["Region"] and string.lower(tostring(v["Region"])) or ""
                                if string.find(region, "singapore") then
                                    local playerCount = v["Count"]
                                    local serverBounty = v["Bounty"] or 0
                                    if serverBounty > (playerCount * 1500000) then
                                        local alreadySaved = false
                                        for _, savedId in ipairs(getgenv().SavedServers) do
                                            if savedId == k then alreadySaved = true break end
                                        end
                                        if not alreadySaved then
                                            table.insert(getgenv().SavedServers, k)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end)
end
StartBackgroundServerScanner()

local function flyToSkySafety(targetY)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end

    local statesToDisable = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.Climbing,
        Enum.HumanoidStateType.GettingUp
    }

    for _, state in ipairs(statesToDisable) do
        hum:SetStateEnabled(state, false)
    end
    hum.PlatformStand = true

    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end

    local bg = hrp:FindFirstChild("TP_BodyGyro")
    if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "TP_BodyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.P = 50000
        bg.D = 500
        bg.Parent = hrp
    end

    local targetAtt = workspace.Terrain:FindFirstChild("HopSkyTargetAtt")
    if not targetAtt then
        targetAtt = Instance.new("Attachment")
        targetAtt.Name = "HopSkyTargetAtt"
        targetAtt.Parent = workspace.Terrain
    end

    local rootAtt = hrp:FindFirstChild("HopSkyRootAtt")
    if not rootAtt then
        rootAtt = Instance.new("Attachment")
        rootAtt.Name = "HopSkyRootAtt"
        rootAtt.Parent = hrp
    end

    local alignPos = hrp:FindFirstChild("HopSkyAlign")
    if not alignPos then
        alignPos = Instance.new("AlignPosition")
        alignPos.Name = "HopSkyAlign"
        alignPos.Mode = Enum.PositionAlignmentMode.TwoAttachment
        alignPos.Attachment0 = rootAtt
        alignPos.Attachment1 = targetAtt
        alignPos.MaxForce = 9e99
        alignPos.MaxVelocity = tonumber(getgenv().Config and getgenv().Config["TweenSpeed"]) or 250
        alignPos.Responsiveness = 200
        alignPos.ApplyAtCenterOfMass = true
        alignPos.Parent = hrp
    end

    targetAtt.WorldPosition = Vector3.new(hrp.Position.X, targetY, hrp.Position.Z)
    alignPos.Enabled = true

    task.spawn(function()
        while isHopping and hrp and hrp.Parent do
            targetAtt.WorldPosition = Vector3.new(hrp.Position.X, targetY, hrp.Position.Z)
            bg.CFrame = CFrame.new(hrp.Position, Vector3.new(hrp.Position.X, targetY, hrp.Position.Z))
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0.01, 0)
            hrp.AssemblyAngularVelocity = Vector3.zero

            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end

            if hrp.Position.Y >= (targetY - 1000) then
                break
            end
            task.wait(0.1)
        end
    end)
end

local function hopServer()
    if isHopping then return end 
    isHopping = true 

    task.spawn(function()
        if not getgenv().Config["Reset"] then 
            notify("Hop System", "Moving to safety (300000 height)...", 5) 
            
            _G.DisableSpecialTP = true
            flyToSkySafety(300000)

            if risk() then
                notify("Hop System", "Risk detected! Waiting to clear...", 5)
                while risk() do
                    pcall(function()
                        local currentChar = LocalPlayer.Character
                        local currentHrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                        if currentHrp and currentHrp.Position.Y < 250000 then
                            flyToSkySafety(300000)
                        end
                    end)
                    task.wait(1)
                end
                notify("Hop System", "Risk cleared! Ready to hop...", 3)
            end
        end

        notify("Hop System", "Searching Singapore servers...", 5) 
        
        pcall(function()
            LocalPlayer.PlayerGui.ServerBrowser.Frame.Filters.SearchRegion.TextBox.Text = "Singapore" 
        end)
        
        while isHopping do
            task.wait()
            
            if risk() then
                task.wait(1)
                continue
            end

            if not risk() then
                if #getgenv().SavedServers > 0 then
                    local serverToTry = table.remove(getgenv().SavedServers, 1)
                    notify("Hop System", "Trying fast hop...", 1) 
                    pcall(function()
                        game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", serverToTry) 
                    end)
                    task.wait(1.5)
                else
                    notify("Hop System", "List empty, scanning directly...", 2) 
                    for r = 1, 300 do 
                        if risk() then break end

                        local success, servers = pcall(function() 
                            return game.ReplicatedStorage.__ServerBrowser:InvokeServer(r) 
                        end) 
                        
                        if success and servers then
                            for k, v in pairs(servers) do
                                if k ~= game.JobId and v["Count"] > 10 then 
                                    local region = v["Region"] and string.lower(tostring(v["Region"])) or ""
                                    if string.find(region, "singapore") then
                                        local playerCount = v["Count"]
                                        local serverBounty = v["Bounty"] or 0
                                        if serverBounty > (playerCount * 1500000) then
                                            if risk() then break end
                                            
                                            notify("Hop System", "Found Singapore server! Teleporting...", 3) 
                                            pcall(function()
                                                game.ReplicatedStorage.__ServerBrowser:InvokeServer("teleport", k) 
                                            end)
                                            task.wait(1.5)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end
            end
        end
        isHopping = false 
    end)
end

task.spawn(function()
    game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, result, err)
        if result == Enum.TeleportResult.GameFull then
            joinFailed = true
            print("Full nguoi")
            isHopping = false
            task.wait(1)
            if hopServer then 
                hopServer() 
            end
        end
    end)
end)

---------
task.spawn(function()
    game:GetService("TeleportService").TeleportInitFailed:Connect(function(playerInstance, teleportResult, errorMessage)
        if teleportResult or errorMessage then
            isHopping = false
            task.wait(1)
            if hopServer then 
                hopServer() 
            end
        end
    end)
end)

local function getPlayersWithFruit()
    local result = {}
    local skipConfig = (getgenv().Config and getgenv().Config["SkipIfUse"]) or {}

    for _, player in ipairs(Players:GetPlayers()) do
        local backpack = player:FindFirstChild("Backpack")
        local character = player.Character

        local function checkFolder(container)
            if not container then return false end
            for _, item in ipairs(container:GetChildren()) do
                local itemName = item.Name
                for fruitName, isEnabled in pairs(skipConfig) do
                    if isEnabled and (string.lower(itemName) == string.lower(fruitName) or string.find(string.lower(itemName), string.lower(fruitName), 1, true)) then
                        return true
                    end
                end
            end
            return false
        end

        if checkFolder(backpack) or checkFolder(character) then
            table.insert(result, player.Name)
        end
    end

    return result
end
local validRaces = {
    ["human"] = "Human",
    ["mink"] = "Mink",
    ["skypiea"] = "Skypiea",
    ["shark"] = "Shark",
    ["cyborg"] = "Cyborg",
    ["ghoul"] = "Ghoul",
    ["draco"] = "Draco"
}

local function getActiveV4PlayersByRace(targetRace)
    if not targetRace or typeof(targetRace) ~= "string" then 
        return {} 
    end

    local cleanTarget = string.lower(string.gsub(targetRace, "%s+", ""))
    local matchedRace = validRaces[cleanTarget]
    if not matchedRace then
        return {}
    end

    local activePlayers = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local raceTransformed = char:FindFirstChild("RaceTransformed")
            local isActivating = false

            if raceTransformed then
                if raceTransformed:IsA("ValueBase") then
                    isActivating = raceTransformed.Value == true
                else
                    isActivating = true
                end
            end

            if isActivating then
                local raceData = plr:FindFirstChild("Data") and plr.Data:FindFirstChild("Race")
                if raceData and raceData:IsA("ValueBase") then
                    local playerRace = string.lower(string.gsub(tostring(raceData.Value), "%s+", ""))
                    if playerRace == "fishman" then
                        playerRace = "shark"
                    end

                    if validRaces[playerRace] == matchedRace then
                        table.insert(activePlayers, plr.Name)
                    end
                end
            end
        end
    end

    return activePlayers
end

local function isInSoloPvp(targetPlayer)
    local pvpComponentInstance = targetPlayer:FindFirstChild("PvpSessionComponent", true)
    if not pvpComponentInstance then 
        return false 
    end

    local state = pvpComponentInstance:GetAttribute("State")
    if state and state ~= "Playing" then 
        return false 
    end

    local arenaPointer = pvpComponentInstance:FindFirstChild("pvpArenaPointer")
    local arena = arenaPointer and arenaPointer.Value
    if not arena then 
        return false 
    end

    local pvpTeamsInfo = arena:FindFirstChild("pvpTeamsInfo")
    if not pvpTeamsInfo then 
        return false 
    end

    local matchPlayers = {}
    for _, teamFolder in ipairs(pvpTeamsInfo:GetChildren()) do
        for _, playerVal in ipairs(teamFolder:GetChildren()) do
            if playerVal:IsA("ObjectValue") and playerVal.Value and playerVal.Value:IsA("Player") then
                table.insert(matchPlayers, playerVal.Value)
            end
        end
    end

    return #matchPlayers == 2
end

local function isValidTarget(p)
    if p == LocalPlayer then return false end

    local avoidCfg = getgenv().Config and getgenv().Config["avoid account"]
    if avoidCfg and type(avoidCfg["Users"]) == "table" then
        for _, memberName in ipairs(avoidCfg["Users"]) do
            if memberName ~= "" and (string.lower(p.Name) == string.lower(memberName) or string.lower(p.DisplayName) == string.lower(memberName)) then
                return false
            end
        end
    end

    local playersToSkip = getPlayersWithFruit()
    for _, skipName in ipairs(playersToSkip) do
        if p.Name == skipName then
            return false
        end
    end

local avoidV4Cfg = getgenv().Config and getgenv().Config["avoidPlayerV4"]
    if avoidV4Cfg and avoidV4Cfg["Enabled"] == true and type(avoidV4Cfg["TransformRace"]) == "table" then
        for _, raceName in ipairs(avoidV4Cfg["TransformRace"]) do
            local v4Players = getActiveV4PlayersByRace(raceName)
            for _, v4PlayerName in ipairs(v4Players) do
                if p.Name == v4PlayerName then
                    return false
                end
            end
        end
    end

	if LocalPlayer.Team and LocalPlayer.Team.Name == "Marines" then
        if p.Team and p.Team.Name == "Marines" then
            return false
        end
    end
    if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    if Blacklist[p.Name] then return false end 

    
    local hum = p.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local localChar = LocalPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")
        if localHrp then
        local distance = (localHrp.Position - hrp.Position).Magnitude
        if distance > 50000 then
            return false
        end
    end
    local mapFolder = workspace:FindFirstChild("Map")
    if mapFolder then
        local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
        if waterPlane then
            local waterY = waterPlane.Position.Y + (waterPlane.Size.Y / 2)
            if hrp.Position.Y < waterY then
                return false
            end
        end
    end
    
    if isInSafeZone(p) then return false end
    if isPvPDisabled(p) then return false end
    if isInSoloPvp(p) then return false end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            if enemy.Name == "Order" and enemy:FindFirstChild("HumanoidRootPart") then
                local distToOrder = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distToOrder <= 1000 then
                    return false
                end
            end
        end
    end
    
    local function getLv(plr)
        local d = plr:FindFirstChild("Data")
        local l = d and d:FindFirstChild("Level")
        return l and l.Value or 0
    end
    
    if math.abs(getLv(LocalPlayer) - getLv(p)) > 500 then 
        return false 
    end
    
    local isNearSeat = false
    local boats = workspace:FindFirstChild("Boats")
    
    if boats then
        for _, boat in ipairs(boats:GetChildren()) do
            for _, part in ipairs(boat:GetDescendants()) do
                if part:IsA("Seat") or part:IsA("VehicleSeat") then
                    if (hrp.Position - part.Position).Magnitude <= 200 then
                        isNearSeat = true
                        break
                    end
                end
            end
            if isNearSeat then break end
        end
    end
    
    if isNearSeat then return false end

    local restrictedArea = Vector3.new(923.5252, 125.1196, 32846.4492)
    if (hrp.Position - restrictedArea).Magnitude <= 5000 then return false end

    return true
end


---------
local function getRandomPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localChar = LocalPlayer.Character
    local localHrp = localChar and localChar:FindFirstChild("HumanoidRootPart")

    if not localHrp then return nil end

    for _, p in pairs(Players:GetPlayers()) do
        if isValidTarget(p) then
            local targetChar = p.Character
            local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            
            if targetHrp then
                local distance = (localHrp.Position - targetHrp.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = p
                end
            end
        end
    end

    return closestPlayer
end
---------

local function getSingleTarget()
    local singleCfg = getgenv().Config and getgenv().Config["SinglePlayer"]
    if singleCfg and singleCfg.Enabled and singleCfg.TargetName and singleCfg.TargetName ~= "" then
        local targetName = string.lower(singleCfg.TargetName)
        for _, p in pairs(Players:GetPlayers()) do
            if string.lower(p.Name) == targetName or string.lower(p.DisplayName) == targetName then
                return p
            end
        end
    end
    return nil
end

---------
_G.cantsafezone = false
getgenv().LastValidDamageTick = 0

local function pickNewTarget(reason)
    _G.cantsafezone = false
    getgenv().LastValidDamageTick = 0
    
    local old = currentTarget and currentTarget.Name or "none"
    local singleCfg = getgenv().Config and getgenv().Config["SinglePlayer"]
    
    if singleCfg and singleCfg.Enabled then
        local targetPlr = getSingleTarget()
        if targetPlr then
            currentTarget = targetPlr
            switchTimer = 0
            lastTargetHealth = 0
            lastDamageTime = tick()
            print(string.format("Single Target Lock -> %s", currentTarget.Name))
            return
        else
            currentTarget = nil
            print("Waiting for single target to join...")
            return
        end
    end

    currentTarget = getRandomPlayer()
    switchTimer = 0
    
    lastTargetHealth = 0
    lastDamageTime = tick() 
    
    if currentTarget then
        print(string.format("Target [%s] %s -> %s", reason, old, currentTarget.Name))
    else
        print("Waiting for valid targets...")
        notify("Auto Bounty", "No targets left, hopping server...", 5)
        hopServer()
    end
end


local function checkCurrentTarget()
    local singleCfg = getgenv().Config and getgenv().Config["SinglePlayer"]
    if singleCfg and singleCfg.Enabled then
        local targetPlr = getSingleTarget()
        if not targetPlr then
            currentTarget = nil
            return false
        end
        currentTarget = targetPlr
        return true
    end
    if not currentTarget then return false end
    if not currentTarget.Parent then pickNewTarget("left game"); return false end
    local targetChar = currentTarget.Character
    if not targetChar then pickNewTarget("no character"); return false end
    local hum = targetChar:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then
        pickNewTarget("died"); return false
    end
    
    if Config and Config["FruitInstantKill"] == true then
        local hrp = targetChar:FindFirstChild("HumanoidRootPart")
        if hrp then
            local mapFolder = workspace:FindFirstChild("Map")
            if mapFolder then
                local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
                if waterPlane then
                    local waterY = waterPlane.Position.Y + (waterPlane.Size.Y / 2)
                    if hrp.Position.Y < waterY then
                        pickNewTarget("target in water")
                        return false
                    end
                end
            end
        end
    end

    if isInSafeZone(currentTarget) then 
        if not _G.cantsafezone then
            pickNewTarget("entered safezone")
            return false 
        end
    end
    
    if isPvPDisabled(currentTarget) then pickNewTarget("pvp disabled"); return false end
    return true
end

local function RunFullScan()
    if ScanCompleted or IsScanning then return end
    IsScanning = true
    notify("Scan System", "Starting 5-cycle skimming scan...", 7)

    for cycle = 1, 7 do
        if not running then IsScanning = false return end
        notify("Scan System", "Cycle: " .. cycle .. "/7", 2)
        
        for _, p in pairs(Players:GetPlayers()) do
            if not running then break end
            local isMarine = LocalPlayer.Team and LocalPlayer.Team.Name == "Marines"
            local isSameTeam = p.Team == LocalPlayer.Team

            if p ~= LocalPlayer and not (isMarine and isSameTeam) then
                if Whitelist[p.Name] then
                    local hum = char and char:FindFirstChild("Humanoid")
                    if not char or not hum or hum.Health <= 0 then
                        Whitelist[p.Name] = nil
                    end
                    continue
                end

                if not Whitelist[p.Name] then
                    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
                        if not isInSafeZone(p) and not isPvPDisabled(p) then
                        notify("Scan System", "Checking: " .. p.Name, 1.5)
                            local hum = char.Humanoid
                            local startHealth = hum.Health
                            
                            for i = 1, 60 do
                                if not running then break end
                                teleportTo(p)
                                task.wait(CONFIG.SkimDelay) 
                            end
                            
                            task.wait(0.01) 
                            local newHealth = hum.Health
                            if newHealth < startHealth then
                                Whitelist[p.Name] = true
                                notify("Scan System", "Whitelist added: " .. p.Name, 2)
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.01)
    end



    IsScanning = false
    ScanCompleted = true
    notify("Scan System", "Scan finished! Ready to hunt.", 7)
end

local function getPingInMs()
	if LocalPlayer then
		local ping = LocalPlayer:GetNetworkPing() 
		return math.round(ping * 1000)
	end
	return 0
end 

local function stopAll()
    running = false
    IsScanning = false
    if followThread then
        task.cancel(followThread)
        followThread = nil
    end
    currentTarget = nil
    getgenv().CurrentTarget = nil
    getgenv().targ = nil
    getgenv().CurrentTargetPart = nil
    getgenv().MacroAimPos = nil
    getgenv().LatestPredictedPos = nil
    teleportTo(nil)
    switchTimer = 0
end
---------------------------

task.spawn(function()
    while task.wait() do
        pcall(function()
            local pingCfg = getgenv().Config and getgenv().Config["HopServerLowPing"]
            if pingCfg and pingCfg["Enabled"] == true then
                local maxPing = tonumber(pingCfg["PingMs"]) 
                local currentPing = getPingInMs()
                if currentPing > 0 and currentPing > maxPing then
                    if running or IsScanning then
                        notify("Ping Monitor", "High Ping: " .. tostring(currentPing) .. "ms! Hopping...", 5)
                        stopAll()
                        hopServer()
                    end
                end
            end
        end)
    end
end)
---------

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if getgenv().Config and getgenv().Config["Bounty Find"] then
                local targetBounty = tonumber(getgenv().Config["Bounty Find"])
                if targetBounty and targetBounty > 0 then
                    local myBounty = getBounty(LocalPlayer)
                    if myBounty >= targetBounty then
                        if running or IsScanning then
                            task.wait(3)
                            stopAll()
                        end
                    end
                end
            end
        end)
    end
end)
---------
---------
local function CheckDamageFromUI()
    local player = Players.LocalPlayer
    if not player then return 0 end

    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return 0 end

    local mainGui = playerGui:FindFirstChild("Main")
    if not mainGui then return 0 end

    local dmgCounter = mainGui:FindFirstChild("DmgCounter")
    if not dmgCounter then return 0 end

    local function FindDamageText(element)
        if element:IsA("TextLabel") or element:IsA("TextButton") or element:IsA("TextBox") then
            local text = element.Text
            local numStr = string.gsub(text, "[^%d]", "")
            local damageValue = tonumber(numStr)
            if damageValue then
                return damageValue
            end
        end
        
        for _, child in ipairs(element:GetChildren()) do
            local found = FindDamageText(child)
            if found then return found end
        end
        return nil
    end

    local currentDamage = FindDamageText(dmgCounter)
    return currentDamage or 0
end


local function SmartTeleport()
    local safeConfig = getgenv().Config and getgenv().Config["SafeCoolDown"]
    if type(safeConfig) == "table" and safeConfig["Enabled"] then
        local targetCFrame = getTargetCFrame(currentTarget)
        
        local canSafeJump = getgenv().SkillsOnCooldown
        if canSafeJump then
            local timeSinceLastSkill = tick() - (getgenv()._LastSkillTick or 0)
            local requiredDelay = getgenv()._SkillDelayNeeded or 0.5
            if timeSinceLastSkill < requiredDelay then
                canSafeJump = false
            end
        end

        if canSafeJump then
            local heightY = safeConfig["HightDistance"] or 150
            if not getgenv()._SafeJumped then
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHrp then
                    myHrp.CFrame = myHrp.CFrame + Vector3.new(0, heightY, 0)
                end
                getgenv()._SafeJumped = true
            end
            
            if targetCFrame then
                teleportTo(targetCFrame + Vector3.new(0, heightY, 0))
            end
            return
        else
            if getgenv()._SafeJumped then
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                if myHrp and targetCFrame then
                    local offsetY = (getgenv().Config and getgenv().Config["yHightDistance"]) or 5
                    local lockMode = getgenv().Config and getgenv().Config["SpinLock"] or "Body"
                    
                    local rawTargetPos = targetCFrame.Position
                    if lockMode == "Prediction" and getgenv().LatestPredictedPos then
                        rawTargetPos = getgenv().LatestPredictedPos
                    end
                    
                    local baseTargetPos = rawTargetPos + Vector3.new(0, offsetY, 0)
                    myHrp.CFrame = CFrame.new(myHrp.Position.X, baseTargetPos.Y, myHrp.Position.Z)
                end
                getgenv()._SafeJumped = false
                getgenv()._LastSafeLanded = tick()
            end
        end
    end
    teleportTo(currentTarget)
end
local function startRandom()
    stopAll() 
    running = true

    if getgenv().Config.mode == "method1" then
        pickNewTarget("start")
        local nearStartTime = tick()
        local approachStartTime = tick()
        local lastUiDamage = 0

        followThread = task.spawn(function()
            while running do
                task.wait() 
                if not running then break end
                if not checkCurrentTarget() then task.wait(1); continue end
                
                SmartTeleport(currentTarget)
                 
                local hum = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                local targetHrp = currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                local currentUiDamage = CheckDamageFromUI()
                
---------
                    if hum then
                        local currentHp = hum.Health
                        local isHealthDropped = (lastTargetHealth > 0 and currentHp < lastTargetHealth)
                        local isUiDamaged = (currentUiDamage > 0 and currentUiDamage ~= lastUiDamage)

                     if isHealthDropped and isUiDamaged then
                        nearStartTime = tick()
                        approachStartTime = tick()
                        lastDamageTime = tick()
                        _G.cantsafezone = true
                        getgenv().LastValidDamageTick = tick()
                    end
                    lastTargetHealth = currentHp
                    lastUiDamage = currentUiDamage
                end
                
                if _G.cantsafezone and getgenv().LastValidDamageTick then
                    if tick() - getgenv().LastValidDamageTick >= 30 then
                        _G.cantsafezone = false
                    end
                end
---------

---------
                if myHrp and targetHrp then
                    local myPos = myHrp.Position
                    local tarPos = targetHrp.Position
                    local distZX = (Vector3.new(myPos.X, 0, myPos.Z) - Vector3.new(tarPos.X, 0, tarPos.Z)).Magnitude

                    if distZX < 100 then
                        approachStartTime = tick()
                        local remainNear = math.max(0, math.floor(240 - (tick() - nearStartTime)))
                        notify("Target Timeout", "Near: " .. tostring(remainNear) .. "s | " .. currentTarget.Name, 2)
                        
                        if tick() - nearStartTime >= 240 then
                            if currentTarget then
                                Blacklist[currentTarget.Name] = true
                            end
                            nearStartTime = tick()
                            approachStartTime = tick()
                            pickNewTarget("240s timeout near target")
                        end
                    else
                        nearStartTime = tick()
                        local remainApproach = math.max(0, math.floor(600 - (tick() - approachStartTime)))
                        notify("Target Timeout", "Approach: " .. tostring(remainApproach) .. "s | " .. currentTarget.Name, 2)
                        
                        if tick() - approachStartTime >= 600 then
                            if currentTarget then
                                Blacklist[currentTarget.Name] = true
                            end
                            nearStartTime = tick()
                            approachStartTime = tick()
                            pickNewTarget("600s approach timeout (distance >= 100)")
                        end
                    end
                end
---------
            end
        end)
    else
        followThread = task.spawn(function()
            if not ScanCompleted then RunFullScan() end
            if not running then return end
            pickNewTarget("start")
            
            local lastUiDamage = 0
            local switchStartTime = tick()

            while running do
                task.wait(0.1) 
                if not running then break end
                if not checkCurrentTarget() then task.wait(1); continue end
                
                if Whitelist[currentTarget.Name] then
                    for i = 1, 5 do
                        if not running or not checkCurrentTarget() then break end
                        SmartTeleport(currentTarget) 
                        task.wait(CONFIG.SkimDelay) 
                    end
                else
                    SmartTeleport(currentTarget)
                end
               
                local hum = currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid")
                local currentUiDamage = CheckDamageFromUI()

                if hum then
                    local currentHp = hum.Health
                    if (lastTargetHealth > 0 and currentHp < lastTargetHealth) or (currentUiDamage > 0 and currentUiDamage ~= lastUiDamage) then
                        lastDamageTime = tick()
                        switchStartTime = tick()
                    end
                    lastTargetHealth = currentHp
                    lastUiDamage = currentUiDamage
                end

                if tick() - switchStartTime >= CONFIG.SwitchDelay then 
                    if currentTarget then
                        Whitelist[currentTarget.Name] = nil
                    end
                    switchStartTime = tick()
                    pickNewTarget("8s timeout & blacklist") 
                end
            end
        end)
    end
end



local SKIP_NOTIF_KEYWORDS = {
    "pvp", "chua bat", "cannot attack", "unable to attack",
    "khong the tan cong", "nguoi choi", "player recently",
    "vua tu tran", "protection", "bao ve",
    "player", "safezone"
}

spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local notifs = LocalPlayer.PlayerGui:FindFirstChild("Notifications")
            if notifs then
                for _, v in pairs(notifs:GetChildren()) do
                    local lbl = v:IsA("TextLabel") and v or v:FindFirstChildWhichIsA("TextLabel", true)
                    if lbl and lbl.Text and lbl.Text ~= "" then
                        local text = lbl.Text:lower()
                        for _, kw in pairs(SKIP_NOTIF_KEYWORDS) do
                            if text:find(kw, 1, true) then
                                if currentTarget then 
                                    Blacklist[currentTarget.Name] = true
                                end
                                pickNewTarget("notification bypass")
                                pcall(function() v:Destroy() end)
                                break
                            end
                        end
                    end
                end
            end
        end)
    end
end)

---------
task.spawn(function()
    local lastX = nil
    local lastZ = nil
    local timeStuck = 0
    
    while task.wait(1) do
        pcall(function()
            if running and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local currentX = LocalPlayer.Character.HumanoidRootPart.Position.X
                local currentZ = LocalPlayer.Character.HumanoidRootPart.Position.Z
                
                if lastX and lastZ then
                    if math.abs(currentX - lastX) < 1 and math.abs(currentZ - lastZ) < 1 then
                        timeStuck = timeStuck + 1
                    else
                        lastX = currentX
                        lastZ = currentZ
                        timeStuck = 0
                    end
                    
                    if timeStuck >= 600 then
                        stopAll()
                        timeStuck = 0
                    end
                else
                    lastX = currentX
                    lastZ = currentZ
                    timeStuck = 0
                end
            else
                lastX = nil
                lastZ = nil
                timeStuck = 0
            end
        end)
    end
end)
---------
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if kenEnabled and getgenv().Config["Observation"] == true then
                local LP = Services.Players.LocalPlayer or game:GetService("Players").LocalPlayer
                local char = LP.Character
                if char and not char:FindFirstChild("HasObservation") then
                    local args = {
                        "Ken",
                        true
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommE"):FireServer(unpack(args))
                end
            end
        end)
    end
end)


------------------------------------------------------------------------
------------------------------------------------------------------------
task.spawn(function()
    while task.wait(0.2) do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("RaceEnergy") and char.RaceEnergy.Value >= 1 and getgenv().Config["TurnOnV4"] == true then
            pcall(function()
                local awakening = LocalPlayer.Backpack:FindFirstChild("Awakening") or char:FindFirstChild("Awakening")
                if awakening and awakening:FindFirstChild("RemoteFunction") then
                    awakening.RemoteFunction:InvokeServer(true)
                end
            end)
        end
    end
end)

local fileName = "hitbox.meyy"
local baseHitboxSize = 0

-------------------------------------------------------------------------
local function getHitboxSize()
    local success, result = pcall(function()
        if character and character:FindFirstChild("HumanoidRootPart") then
            return character.HumanoidRootPart.Size.Magnitude
        end
        return 0
    end)
    return success and result or 0
end

local function saveHitbox(size)
    pcall(function()
        writefile(fileName, tostring(size))
    end)
end

local function readHitbox()
    local success, result = pcall(function()
        if isfile(fileName) then
            return tonumber(readfile(fileName))
        end
    end)
    return success and result or nil
end

-------------------------------------------------------------------------
task.spawn(function()
    pcall(function()
        local savedSize = readHitbox()
        if not savedSize then
            baseHitboxSize = getHitboxSize()
            saveHitbox(baseHitboxSize)
        else
            baseHitboxSize = savedSize
        end
    end)
end)

-------------------------------------------------------------------------
task.spawn(function()
    while true do
        local success, err = pcall(function()
            
            if getgenv().Config and getgenv().Config["transform"] == true then
                local currentSize = getHitboxSize()
                
                if currentSize > 0 and math.abs(currentSize - baseHitboxSize) < 0.1 then
                    local vim = Services.VirtualInputManager
                    vim:SendKeyEvent(true, Enum.KeyCode.V, false, game)
                    task.wait(0.1)
                    vim:SendKeyEvent(false, Enum.KeyCode.V, false, game)
                end
            end
        end)
        
        if not success then
            warn("Á~ Lỗi vòng lặp rùi mò: " .. tostring(err))
        end
        
        task.wait(2)
    end
end)
-------------------------------------------------------------------------

task.spawn(function()
    local vim = game:GetService("VirtualInputManager")
    local Players = game:GetService("Players")
    
    while task.wait(0.1) do
        pcall(function()
            if getgenv().Config and getgenv().Config["SoruDracoDame"] == true then
                local lp = Players.LocalPlayer
                local target = currentTarget
                
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (lp.Character.HumanoidRootPart.Position - target.Character.HumanoidRootPart.Position).Magnitude
                        
                        if dist < 150 then
                            vim:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                            task.wait(0.05)
                            vim:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                        end
                    end
                end
            end
        end)
    end
end)

-------------------------------------------------------------------------

local function ForceEnablePvP()
    pcall(function()
        local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
        Services.ReplicatedStorage.Remotes.CommF_:InvokeServer("EnablePvp")
        if mainGui then
            local pvpBtn = mainGui:FindFirstChild("PvpDisabled") or mainGui:FindFirstChild("SafeZone")
            if pvpBtn and pvpBtn.Visible then
                for _, connection in pairs(getconnections(pvpBtn.MouseButton1Click)) do
                    connection:Fire()
                end
            end
        end
    end)
end
pcall(function()
    local _WaterBasePlane = workspace.Map and workspace.Map['WaterBase-Plane']
    if _WaterBasePlane then
        _WaterBasePlane.Size = Vector3.new(1000, 112, 1000)
    end
end)
task.spawn(function()
    while task.wait(2) do 
        ForceEnablePvP()
    end
end)

spawn(function()
    while task.wait(2) do
        if not kenEnabled then continue end
        pcall(function()
            if char and not char:FindFirstChild("HasObservation") then
                VirtualUser:CaptureController()
                VirtualUser:SetKeyDown("0x65")
                task.wait(0.05)
                VirtualUser:SetKeyUp("0x65")
            end
        end)
    end
end)



---------
if getgenv().MainUI then
    pcall(function() getgenv().MainUI:Destroy() end)
    getgenv().MainUI = nil
end

if getgenv().Config.BlackScreen then
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScreenGui"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Services.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Name = "Frame"
    Frame.Position = UDim2.new(-0.206146, 0, -0.150063, 0)
    Frame.Size = UDim2.new(0, 2544, 0, 1355)
    Frame.BackgroundColor3 = Color3.new(0.0235294, 0.0235294, 0.0235294)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Position = UDim2.new(0.462572, 0, 0.343508, 0)
    TextLabel.Size = UDim2.new(0, 200, 0, 50)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "Time Elapsed : ..."
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.TextSize = 28
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel.Parent = ScreenGui
    getgenv()._BS_TimeLabel = TextLabel

    local TextLabel2 = Instance.new("TextLabel")
    TextLabel2.Position = UDim2.new(0.462572, 0, 0.266818, 0)
    TextLabel2.Size = UDim2.new(0, 200, 0, 50)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = "Bounty Earned : ...."
    TextLabel2.TextColor3 = Color3.new(1, 1, 1)
    TextLabel2.TextSize = 28
    TextLabel2.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel2.Parent = ScreenGui
    getgenv()._BS_BountyLabel = TextLabel2

    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Position = UDim2.new(0.462572, 0, 0.204578, 0)
    TextLabel3.Size = UDim2.new(0, 200, 0, 50)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "Target : "
    TextLabel3.TextColor3 = Color3.new(1, 1, 1)
    TextLabel3.TextSize = 25
    TextLabel3.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel3.Parent = ScreenGui
    getgenv()._BS_TargetLabel = TextLabel3

    local TextLabel4 = Instance.new("TextLabel")
    TextLabel4.Position = UDim2.new(0.350045, 0, 0.0638366, 0)
    TextLabel4.Size = UDim2.new(0, 571, 0, 102)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "Meyy Hub - Auto Bounty"
    TextLabel4.TextColor3 = Color3.new(1, 1, 1)
    TextLabel4.TextSize = 35
    TextLabel4.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextLabel4.Parent = ScreenGui

    local Line = Instance.new("Frame")
    Line.Position = UDim2.new(0.361577, 0, 0.191517, 0)
    Line.Size = UDim2.new(0, 533, 0, 1)
    Line.BackgroundColor3 = Color3.new(0.686275, 0.0980392, 0.658824)
    Line.BorderSizePixel = 0
    Line.Parent = ScreenGui
    
    getgenv().MainUI = ScreenGui
end
---------


LocalPlayer.Chatted:Connect(function(msg)
    local mText = msg:lower()
    if mText == "/randtp" then startRandom() 
    elseif mText == "/stoptp" then stopAll() hopServer()
    elseif mText == "/newtp" then pickNewTarget("manual") end
end)
function stopRandomTp() stopAll() hopServer() end
function newTarget() pickNewTarget("manual") end

startRandom()


spawn(function()
    while task.wait(1) do
        pcall(function()
            if char and not char:FindFirstChild("HasBuso") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
            end
        end)
    end
end)

---------
task.spawn(function()
    local RS = ReplicatedStorage or (Services and Services.ReplicatedStorage) or game:GetService("ReplicatedStorage")
    local LP = LocalPlayer or (Services and Services.Players and Services.Players.LocalPlayer) or game:GetService("Players").LocalPlayer
    local commE = RS:WaitForChild("Remotes"):WaitForChild("CommE")
    local abilityArgs = {
        "ActivateAbility"
    }

    while task.wait(1) do
        pcall(function()
            local target = currentTarget
            local myChar = LP.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

            if target and target.Character and myHrp then
                local tarHrp = target.Character:FindFirstChild("HumanoidRootPart")
                if tarHrp then
                    local dist = (myHrp.Position - tarHrp.Position).Magnitude
                    if dist < 30 then
                        commE:FireServer(unpack(abilityArgs))
                    end
                end
            end
        end)
    end
end)
---------
---------
function sendKillWebhook(targetName, bountyEarned, currentBounty, totalEarned, totalKills, bph)
    if not getgenv().Config.Webhook.Enabled or getgenv().Config.Webhook.Url == "" then
        return
    end    
    local url = getgenv().Config.Webhook.Url
    local function formatBounty(bounty)
        if bounty >= 1000000 then
            return string.format("%.1fM", bounty / 1000000)
        elseif bounty >= 1000 then
            return string.format("%.1fK", bounty / 1000)
        else
            return tostring(bounty)
        end
    end
    local data = {
        ["username"] = "ʚ ᙏᥱყყ♡Bot ɞ ", 
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120553734766713/cte_2.jfif?ex=6a09783f&is=6a0826bf&hm=8d8bf1376c3a05cbf82f7f36dc174b1c4d026c73fd391c5daea947010c6b4d41&",
        ["embeds"] = {{
            ["title"] = " <a:a_afx_heart_pink:1213626268205973504> αυтσ вσυηту <a:a_afx_heart_pink:1213626268205973504> ",
            ["description"] = "Kill Player",
            ["color"] = 11986679,
            ["fields"] = {
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Target",
                    ["value"] = "```" .. targetName .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Bounty Earned",
                    ["value"] = "```" .. formatBounty(bountyEarned) .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Total Earned",
                    ["value"] = "```" .. formatBounty(totalEarned) .. "```",
                    ["inline"] = false
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Current Bounty",
                    ["value"] = "```" .. formatBounty(currentBounty) .. "```", 
                    ["inline"] = true
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Total Kill",
                    ["value"] = "```" .. tostring(totalKills) .. "```",
                    ["inline"] = true
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Bounty Per Hour",
                    ["value"] = "```" .. formatBounty(bph) .. " / hr```",
                    ["inline"] = false
                },
                {
                    ["name"] = " <a:ast_dcr_thovotay:1418115206671892521> Hunter",
                    ["value"] = "```" .. player.Name .. "```",
                    ["inline"] = false
                }
            },

            ["footer"] = {
                ["text"] = "ʚ ᙏᥱყყ♡Hub ɞ | " .. os.date("%H:%M:%S %d/%m/%Y"),
                ["icon_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120554104127528/cute.jfif?ex=6a09783f&is=6a0826bf&hm=5cf5e8f83ba3c797a5901813eb66d4df716f617473ce7c089d6f66912f205dc5&"
            },
            ["thumbnail"] = {
                ["url"] = "https://cdn.discordapp.com/attachments/1503282260856672367/1504877443993833714/1778860380021.png?ex=6a0895d5&is=6a074455&hm=86c9de11e9c2f8b291bda710bb406d11144c7af5fe5fd26edb34ea84b7c8aeef&"
            },
				["image"] = {
              ["url"] = "https://cdn.discordapp.com/attachments/1325479541195673610/1504873598450663595/1778860201529.png?ex=6a089241&is=6a0740c1&hm=5b09db29f8c9e48e88f5026c45977d2a41c9343746dae3bae37bbdbf4f7cfc3e&"
				}
			}
        }
    }

    pcall(function()
        local jsonData = Services.HttpService:JSONEncode(data)
        local success, response = pcall(function()
            if syn then
                return syn.request({
                    Url = url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = jsonData
                })
            else
                return request({
                    Url = url,
                    Method = "POST", 
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = jsonData
                })
            end
        end)
        
        if success then
            print(" Sent kill webhook: " .. targetName)
        else
            print(" Webhook error: " .. tostring(response))
        end
    end)
end
---------

---------
local SAVE_FOLDER = "MeyyHub_DataBounty"
local SAVE_FILE = SAVE_FOLDER .. "/TotalBounty_" .. game.Players.LocalPlayer.Name .. ".json"
if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end

local totalBountyEarned = 0
local allTimeKills = 0
local sessionBountyEarned = 0
local totalTimeElapsed = 0
local bsStartTime = os.time()
local lastSaveTime = os.time()

local function loadEarnedData()
    local success, err = pcall(function()
        if isfile(SAVE_FILE) then
            local fileContent = readfile(SAVE_FILE)
            if fileContent and fileContent ~= "" then
                local data = Services.HttpService:JSONDecode(fileContent)
                totalBountyEarned = tonumber(data.TotalEarned) or 0
                allTimeKills = tonumber(data.AllTimeKills) or 0
                totalTimeElapsed = tonumber(data.TotalTimeElapsed) or 0
                
                sessionBountyEarned = 0 
            end
        else
            local defaultData = {
                TotalEarned = 0,
                AllTimeKills = 0,
                TotalTimeElapsed = 0,
                SessionEarned = 0,
                LastSaveTimestamp = os.time(),
                LastSave = os.date("%H:%M %d/%m/%Y"),
                Player = game.Players.LocalPlayer.Name
            }
            writefile(SAVE_FILE, Services.HttpService:JSONEncode(defaultData))
        end
    end)
    
    if not success then
        totalBountyEarned = 0
        allTimeKills = 0
        sessionBountyEarned = 0
        totalTimeElapsed = 0
    end
end

loadEarnedData()

local function saveEarnedData()
    pcall(function()
        local currentTimeInServer = math.floor(os.time() - bsStartTime)
        lastSaveTime = os.time()
        
        local dataToSave = {
            TotalEarned = totalBountyEarned,
            AllTimeKills = allTimeKills,
            TotalTimeElapsed = totalTimeElapsed + currentTimeInServer,
            SessionEarned = sessionBountyEarned,
            LastSaveTimestamp = lastSaveTime,
            LastSave = os.date("%H:%M %d/%m/%Y"),
            Player = game.Players.LocalPlayer.Name
        }
        
        writefile(SAVE_FILE, Services.HttpService:JSONEncode(dataToSave))
    end)
end
---------



local function formatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%dh %dm %02ds", h, m, s)
end

spawn(function()
    task.wait(2)
    while task.wait(1) do
        pcall(function()
            saveEarnedData()
            
            if not getgenv().Config.BlackScreen then return end
            local tLbl = getgenv()._BS_TimeLabel
            local bLbl = getgenv()._BS_BountyLabel
            local tgLbl = getgenv()._BS_TargetLabel
            if not tLbl or not bLbl or not tgLbl then return end

            tLbl.Text = "Time Elapsed : " .. formatTime(totalTimeElapsed + math.floor(os.time() - bsStartTime))
            bLbl.Text = "Bounty Earned : +" .. tostring(sessionBountyEarned) .. "$ | Total: " .. tostring(totalBountyEarned) .. "$"

            if IsScanning then
                tgLbl.Text = "Target : Scanning..."
            elseif currentTarget then
                tgLbl.Text = "Target : " .. currentTarget.Name .. " (" .. tostring(getBounty(currentTarget)) .. "$)"
            else
                tgLbl.Text = "Target : Searching..."
            end
        end)
    end
end)

---------
local lastTickBounty = 0

spawn(function()
    task.wait(1) 
    pcall(function()
        lastTickBounty = tonumber(getBounty(game.Players.LocalPlayer)) or 0
    end)
    
    while task.wait(0.1) do
        pcall(function()
            local currentBounty = tonumber(getBounty(game.Players.LocalPlayer)) or 0
            
            if lastTickBounty > 0 then
                if currentBounty > lastTickBounty then
                    local earnedBounty = currentBounty - lastTickBounty
                    

                    local deadTargetName = "Unknown"

                    pcall(function()
                        local notifs = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Notifications")
                        if notifs then
                            for _, v in ipairs(notifs:GetChildren()) do
                                local lbl = v:IsA("TextLabel") and v or v:FindFirstChildWhichIsA("TextLabel", true)
                                if lbl and lbl.Text and lbl.Text ~= "" then
                                    local txt = lbl.Text
                                    local matchedName = txt:match("([%w_]+)!")
                                    if matchedName then
                                        deadTargetName = matchedName
                                        break
                                    end
                                end
                            end
                        end
                    end)

                    if deadTargetName == "Unknown" and currentTarget and currentTarget.Name then
                        deadTargetName = currentTarget.Name
                    end
                    
                    task.spawn(function()
                        sendKillMessage(earnedBounty, deadTargetName)
                    end)

                    sessionBountyEarned = (tonumber(sessionBountyEarned) or 0) + earnedBounty
                    totalBountyEarned = (tonumber(totalBountyEarned) or 0) + earnedBounty
                    allTimeKills = (tonumber(allTimeKills) or 0) + 1
                    
                    local totalSeconds = totalTimeElapsed + math.floor(os.time() - bsStartTime)
                    local currentBPH = 0
                    if totalSeconds > 0 and totalBountyEarned > 0 then
                        currentBPH = math.floor((totalBountyEarned / totalSeconds) * 3600)
                    end
                    
                    sendKillWebhook(deadTargetName, earnedBounty, currentBounty, totalBountyEarned, allTimeKills, currentBPH)
                    saveEarnedData()

                    
                    if getgenv().DynamicBounty_API then
                        getgenv().DynamicBounty_API.SetStatus("Earned " .. tostring(earnedBounty) .. " From " .. deadTargetName, 5)
                    end
                elseif currentBounty < lastTickBounty then
                    local lostBounty = lastTickBounty - currentBounty
                    totalBountyEarned = (tonumber(totalBountyEarned) or 0) - lostBounty
                    saveEarnedData()
                end
            end
            
            if currentBounty > 0 then
                lastTickBounty = currentBounty
            end
        end)
    end
end)



local function IsPvpOn(player)
    return player:GetAttribute("PvpDisabled") ~= true
end

---------
if not getgenv().Config.BlackScreen then
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    local Themes = {
        ["Dark"] = {
            MainBg = Color3.fromHex("#000000"),
            MainBgTrans = 0.25,
            ContainerBg = Color3.fromHex("#525252"),
            ContainerTrans = 0.6,
            PillBack = Color3.fromRGB(15, 15, 15),
            TextColor = Color3.fromHex("#FFFFFF"),
            DescTextColor = Color3.fromHex("#AAAAAA"),
            MainStroke = Color3.fromHex("#FFFFFF"),
            TextContrast = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#808080")),
                ColorSequenceKeypoint.new(0.50, Color3.fromHex("#D3D3D3")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
            }),
            Wave = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#0D0D0D")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#1A1A1A")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#0D0D0D"))
            }),
            TextGrad = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8A8A8A")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#1A1A1A"))
            }),
            RowStroke = Color3.fromHex("#FFFFFF"),
            RowStrokeGrad = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#555555")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#54626F"))
            }),
            ToggleActive = Color3.fromHex("#888888"),
            LoopSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#AAAAAA")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#222222")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
            }),
            HoloBeam = Color3.fromHex("#B4DCFF")
        }
    }

    local CurrentTheme = "Dark"
    local UI_Elements = {
        Containers = {},
        TextGradients = {},
        RotatingGradients = {},
        AnimatedGradients = {},
        RowStrokes = {},
        RowStrokeGradients = {},
        Descriptions = {},
        Switches = {}
    }

    local BountyGui = Instance.new("ScreenGui")
    BountyGui.Name = "Meyy_DynamicBounty_" .. math.random(1000, 9999)
    BountyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    BountyGui.ResetOnSpawn = false

    if gethui then
        BountyGui.Parent = gethui()
    else
        pcall(function() BountyGui.Parent = CoreGui end)
        if not BountyGui.Parent then
            BountyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        end
    end
    getgenv().MainUI = BountyGui

    local function ApplyTextGradient(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            obj.TextColor3 = Themes[CurrentTheme].TextColor
            local grad = Instance.new("UIGradient", obj)
            grad.Rotation = 90
            grad.Color = Themes[CurrentTheme].TextContrast
            table.insert(UI_Elements.TextGradients, grad)
            local shadow = Instance.new("UIStroke")
            shadow.Color = Color3.fromRGB(10, 10, 10)
            shadow.Thickness = 0.5
            shadow.Transparency = 0
            shadow.Parent = obj
        end
    end

    local NotchFrame = Instance.new("Frame", BountyGui)
    NotchFrame.Name = "DynamicIslandNotch"
    NotchFrame.Size = UDim2.new(0, 200, 0, 32)
    NotchFrame.Position = UDim2.new(0.5, 0, 0, 12)
    NotchFrame.AnchorPoint = Vector2.new(0.5, 0)
    NotchFrame.BackgroundColor3 = Themes[CurrentTheme].PillBack
    NotchFrame.BackgroundTransparency = 0.1
    NotchFrame.BorderSizePixel = 0
    NotchFrame.ZIndex = 20
    Instance.new("UICorner", NotchFrame).CornerRadius = UDim.new(1, 0)

    local NotchStroke = Instance.new("UIStroke", NotchFrame)
    NotchStroke.Thickness = 1.5
    NotchStroke.Color = Themes[CurrentTheme].MainStroke

    local NotchStrokeGrad = Instance.new("UIGradient", NotchStroke)
    NotchStrokeGrad.Color = Themes[CurrentTheme].LoopSeq
    table.insert(UI_Elements.RotatingGradients, NotchStrokeGrad)

    local NotchScale = Instance.new("UIScale", NotchFrame)
    NotchScale.Scale = 1

    local NotchClickBtn = Instance.new("TextButton", NotchFrame)
    NotchClickBtn.Size = UDim2.new(1, 0, 1, 0)
    NotchClickBtn.BackgroundTransparency = 1
    NotchClickBtn.Text = ""
    NotchClickBtn.ZIndex = 25

    local CameraLens = Instance.new("Frame", NotchFrame)
    CameraLens.Size = UDim2.new(0, 11, 0, 11)
    CameraLens.Position = UDim2.new(0, 14, 0.5, 0)
    CameraLens.AnchorPoint = Vector2.new(0, 0.5)
    CameraLens.BackgroundColor3 = Color3.fromRGB(20, 30, 45)
    Instance.new("UICorner", CameraLens).CornerRadius = UDim.new(1, 0)

    local CameraLensCore = Instance.new("Frame", CameraLens)
    CameraLensCore.Size = UDim2.new(0, 5, 0, 5)
    CameraLensCore.Position = UDim2.new(0.5, 0, 0.5, 0)
    CameraLensCore.AnchorPoint = Vector2.new(0.5, 0.5)
    CameraLensCore.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
    Instance.new("UICorner", CameraLensCore).CornerRadius = UDim.new(1, 0)

    local SensorDot = Instance.new("Frame", NotchFrame)
    SensorDot.Size = UDim2.new(0, 7, 0, 7)
    SensorDot.Position = UDim2.new(0, 32, 0.5, 0)
    SensorDot.AnchorPoint = Vector2.new(0, 0.5)
    SensorDot.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", SensorDot).CornerRadius = UDim.new(1, 0)

    local NotchTextContainer = Instance.new("CanvasGroup", NotchFrame)
    NotchTextContainer.Name = "TextContainer"
    NotchTextContainer.Size = UDim2.new(1, -50, 1, 0)
    NotchTextContainer.Position = UDim2.new(0, 44, 0, 0)
    NotchTextContainer.BackgroundTransparency = 1

    local NotchMaskGrad = Instance.new("UIGradient", NotchTextContainer)
    NotchMaskGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0),
        NumberSequenceKeypoint.new(0.85, 0),
        NumberSequenceKeypoint.new(1, 1)
    })

    local DefaultStatusLabel = Instance.new("TextLabel", NotchTextContainer)
    DefaultStatusLabel.Name = "DefaultStatus"
    DefaultStatusLabel.Size = UDim2.new(1, 0, 1, 0)
    DefaultStatusLabel.Position = UDim2.new(0, -17.5, 0, 0)
    DefaultStatusLabel.BackgroundTransparency = 1
    DefaultStatusLabel.Font = Enum.Font.GothamBold
    DefaultStatusLabel.Text = "мєyy huɓ"
    DefaultStatusLabel.TextSize = 14
    DefaultStatusLabel.TextTransparency = 0
    DefaultStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    DefaultStatusLabel.TextYAlignment = Enum.TextYAlignment.Center
    ApplyTextGradient(DefaultStatusLabel)

    local NotchStatusText = Instance.new("TextLabel", NotchTextContainer)
    NotchStatusText.Name = "StatusMarquee"
    NotchStatusText.Size = UDim2.new(0, 0, 1, 0)
    NotchStatusText.Position = UDim2.new(0, 0, 0, 0)
    NotchStatusText.BackgroundTransparency = 1
    NotchStatusText.Font = Enum.Font.GothamBold
    NotchStatusText.Text = ""
    NotchStatusText.TextSize = 11.5
    NotchStatusText.TextXAlignment = Enum.TextXAlignment.Left
    NotchStatusText.AutomaticSize = Enum.AutomaticSize.X
    ApplyTextGradient(NotchStatusText)

 ---------
local statusQueue = {}
local isStatusProcessing = false
local lastStatusText = ""
local currentStatusTween = nil

local function ProcessStatusQueue()
    if isStatusProcessing then return end
    isStatusProcessing = true

    local defaultStroke = DefaultStatusLabel:FindFirstChildOfClass("UIStroke")

    while #statusQueue > 0 do
        local nextItem = table.remove(statusQueue, 1)
        local statusText = nextItem.text
        local duration = nextItem.duration

        NotchStatusText.Position = UDim2.new(2, 0, 0, 0)
        NotchStatusText.Text = ""

        local fadeOutText = TweenService:Create(
            DefaultStatusLabel,
            TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {TextTransparency = 1}
        )
        fadeOutText:Play()

        if defaultStroke then
            TweenService:Create(
                defaultStroke,
                TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Transparency = 1}
            ):Play()
        end

        fadeOutText.Completed:Wait()
        DefaultStatusLabel.Visible = false

        NotchStatusText.Text = tostring(statusText)
        task.wait()

        local textWidth = NotchStatusText.AbsoluteSize.X
        local containerWidth = NotchTextContainer.AbsoluteSize.X
        
        local targetOffset = -(textWidth + 150)
        
        local totalDistance = containerWidth + math.abs(targetOffset)
        local scrollSpeed = 50 -- Tốc độ chữ chạy mượt mà, êm ái (càng nhỏ càng chậm)
        local scrollTime = (type(duration) == "number" and duration > 0) and duration or (totalDistance / scrollSpeed)

        NotchStatusText.Position = UDim2.new(0, containerWidth + 10, 0, 0)

        currentStatusTween = TweenService:Create(
            NotchStatusText,
            TweenInfo.new(scrollTime, Enum.EasingStyle.Linear),
            {Position = UDim2.new(0, targetOffset, 0, 0)}
        )
        currentStatusTween:Play()
        currentStatusTween.Completed:Wait()
        currentStatusTween = nil 

        NotchStatusText.Text = ""
        NotchStatusText.Position = UDim2.new(0, 0, 0, 0)

        DefaultStatusLabel.Visible = true
        DefaultStatusLabel.TextTransparency = 1
        if defaultStroke then defaultStroke.Transparency = 1 end

        local fadeInText = TweenService:Create(
            DefaultStatusLabel,
            TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {TextTransparency = 0}
        )
        fadeInText:Play()

        if defaultStroke then
            TweenService:Create(
                defaultStroke,
                TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Transparency = 0}
            ):Play()
        end

        fadeInText.Completed:Wait()
    end

    isStatusProcessing = false
    lastStatusText = ""
end

local function SetStatus(statusText, duration)
    local textStr = tostring(statusText)
    
    if textStr == "" then return end
    
    local isTargetStr = string.sub(textStr, 1, 7) == "Target:"
    local wasLastTarget = string.sub(lastStatusText, 1, 7) == "Target:"

    if isTargetStr and wasLastTarget then
        if isStatusProcessing and currentStatusTween then
            if NotchStatusText and string.sub(NotchStatusText.Text, 1, 7) == "Target:" then
                NotchStatusText.Text = textStr
            end
        end
        return 
    end
    
    if textStr == lastStatusText then return end
    for _, item in ipairs(statusQueue) do
        if item.text == textStr then
            return
        end
    end

    lastStatusText = textStr
    table.insert(statusQueue, {text = textStr, duration = duration})
    
    if not isStatusProcessing then
        task.spawn(ProcessStatusQueue)
    end
end
---------
---------

    local HologramEmitters = Instance.new("Frame", BountyGui)
    HologramEmitters.Name = "HologramEmitters"
    HologramEmitters.Size = UDim2.new(1, 0, 1, 0)
    HologramEmitters.BackgroundTransparency = 1
    HologramEmitters.ZIndex = 5

    local function CreateLightRay(anchorOffset, angleDeg, baseWidth)
        local RayFrame = Instance.new("Frame", HologramEmitters)
        RayFrame.Name = "LightRay"
        RayFrame.AnchorPoint = Vector2.new(0.5, 0)
        RayFrame.Position = UDim2.new(0.5, anchorOffset, 0, 44)
        RayFrame.Size = UDim2.new(0, baseWidth, 0, 0)
        RayFrame.BackgroundColor3 = Themes[CurrentTheme].HoloBeam
        RayFrame.BackgroundTransparency = 1
        RayFrame.BorderSizePixel = 0
        RayFrame.Rotation = angleDeg

        local RayGrad = Instance.new("UIGradient", RayFrame)
        RayGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.4, 0.6),
            NumberSequenceKeypoint.new(0.85, 0.9),
            NumberSequenceKeypoint.new(1, 1)
        })
        RayGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Themes[CurrentTheme].HoloBeam),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#54626F"))
        })
        RayGrad.Rotation = 90
        return RayFrame
    end

    local CenterRay = CreateLightRay(0, 0, 220)
    local LeftRay = CreateLightRay(-50, -18, 140)
    local RightRay = CreateLightRay(50, 18, 140)

    local HoloProjectorRing = Instance.new("Frame", HologramEmitters)
    HoloProjectorRing.Name = "ProjectorRing"
    HoloProjectorRing.AnchorPoint = Vector2.new(0.5, 0.5)
    HoloProjectorRing.Position = UDim2.new(0.5, 0, 0, 44)
    HoloProjectorRing.Size = UDim2.new(0, 0, 0, 0)
    HoloProjectorRing.BackgroundTransparency = 1

    local RingStroke = Instance.new("UIStroke", HoloProjectorRing)
    RingStroke.Color = Color3.fromHex("#FFFFFF")
    RingStroke.Thickness = 2
    RingStroke.Transparency = 1
    Instance.new("UICorner", HoloProjectorRing).CornerRadius = UDim.new(1, 0)

    local HoloWindow = Instance.new("CanvasGroup", BountyGui)
    HoloWindow.Name = "HoloBountyWindow"
    HoloWindow.Size = UDim2.new(0, 360, 0, 280)
    HoloWindow.Position = UDim2.new(0.5, 0, 0, 68)
    HoloWindow.AnchorPoint = Vector2.new(0.5, 0)
    HoloWindow.BackgroundColor3 = Themes[CurrentTheme].MainBg
    HoloWindow.BackgroundTransparency = Themes[CurrentTheme].MainBgTrans
    HoloWindow.BorderSizePixel = 0
    HoloWindow.GroupTransparency = 1
    HoloWindow.Visible = false
    HoloWindow.ZIndex = 15
    Instance.new("UICorner", HoloWindow).CornerRadius = UDim.new(0, 14)

    local WindowScale = Instance.new("UIScale", HoloWindow)
    WindowScale.Scale = 0.7

    local HoloWindowStroke = Instance.new("UIStroke", HoloWindow)
    HoloWindowStroke.Thickness = 1.5
    HoloWindowStroke.Color = Themes[CurrentTheme].MainStroke

    local HoloWindowStrokeGrad = Instance.new("UIGradient", HoloWindowStroke)
    HoloWindowStrokeGrad.Color = Themes[CurrentTheme].LoopSeq
    HoloWindowStrokeGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.15, 0.4),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.85, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    table.insert(UI_Elements.RotatingGradients, HoloWindowStrokeGrad)

    local ScanlineEffect = Instance.new("Frame", HoloWindow)
    ScanlineEffect.Name = "Scanline"
    ScanlineEffect.Size = UDim2.new(1, 0, 0, 2)
    ScanlineEffect.Position = UDim2.new(0, 0, 0, 0)
    ScanlineEffect.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    ScanlineEffect.BackgroundTransparency = 0.7
    ScanlineEffect.BorderSizePixel = 0
    ScanlineEffect.ZIndex = 20

    local ScanlineGrad = Instance.new("UIGradient", ScanlineEffect)
    ScanlineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 1)
    })

    local Header = Instance.new("Frame", HoloWindow)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 42)
    Header.BackgroundTransparency = 1

    local HeaderTitle = Instance.new("TextLabel", Header)
    HeaderTitle.Size = UDim2.new(0, 200, 1, 0)
    HeaderTitle.Position = UDim2.new(0, 14, 0, 0)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.Text = "BOUNTY STATS"
    HeaderTitle.TextSize = 13
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    ApplyTextGradient(HeaderTitle)

    local TargetBadge = Instance.new("Frame", Header)
    TargetBadge.Size = UDim2.new(0, 100, 0, 22)
    TargetBadge.Position = UDim2.new(1, -112, 0.5, 0)
    TargetBadge.AnchorPoint = Vector2.new(0, 0.5)
    TargetBadge.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
    TargetBadge.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
    Instance.new("UICorner", TargetBadge).CornerRadius = UDim.new(0, 6)

    local TargetBadgeStroke = Instance.new("UIStroke", TargetBadge)
    TargetBadgeStroke.Color = Themes[CurrentTheme].RowStroke
    TargetBadgeStroke.Thickness = 1
    local TargetBadgeGrad = Instance.new("UIGradient", TargetBadgeStroke)
    TargetBadgeGrad.Color = Themes[CurrentTheme].RowStrokeGrad
    table.insert(UI_Elements.RowStrokeGradients, TargetBadgeGrad)

    local TargetBadgeText = Instance.new("TextLabel", TargetBadge)
    TargetBadgeText.Size = UDim2.new(1, 0, 1, 0)
    TargetBadgeText.BackgroundTransparency = 1
    TargetBadgeText.Font = Enum.Font.GothamBold
    TargetBadgeText.Text = "LIVE TRACKING"
    TargetBadgeText.TextSize = 9.5
    ApplyTextGradient(TargetBadgeText)

    local HeaderDiv = Instance.new("Frame", HoloWindow)
    HeaderDiv.Name = "HeaderDiv"
    HeaderDiv.Size = UDim2.new(1, -20, 0, 1)
    HeaderDiv.Position = UDim2.new(0, 10, 0, 42)
    HeaderDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HeaderDiv.BorderSizePixel = 0

    local HeaderDivGrad = Instance.new("UIGradient", HeaderDiv)
    HeaderDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })

    local ContentScroll = Instance.new("ScrollingFrame", HoloWindow)
    ContentScroll.Name = "Content"
    ContentScroll.Size = UDim2.new(1, -20, 1, -48)
    ContentScroll.Position = UDim2.new(0, 10, 0, 44)
    ContentScroll.BackgroundTransparency = 1
    ContentScroll.BorderSizePixel = 0
    ContentScroll.ScrollBarThickness = 0
    ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ContentPadding = Instance.new("UIPadding", ContentScroll)
    ContentPadding.PaddingTop = UDim.new(0, 4)
    ContentPadding.PaddingBottom = UDim.new(0, 6)

    local ContentLayout = Instance.new("UIListLayout", ContentScroll)
    ContentLayout.Padding = UDim.new(0, 9)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local function CreateStatRow(parent, titleText, defaultVal, layoutOrder)
        local Row = Instance.new("Frame", parent)
        Row.Size = UDim2.new(1, -4, 0, 34)
        Row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        Row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
        Row.LayoutOrder = layoutOrder
        Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
        table.insert(UI_Elements.Containers, Row)

        local RowStroke = Instance.new("UIStroke", Row)
        RowStroke.Color = Themes[CurrentTheme].RowStroke
        RowStroke.Thickness = 1.2
        table.insert(UI_Elements.RowStrokes, RowStroke)

        local RowStrokeGrad = Instance.new("UIGradient", RowStroke)
        RowStrokeGrad.Color = Themes[CurrentTheme].RowStrokeGrad
        table.insert(UI_Elements.RowStrokeGradients, RowStrokeGrad)
        table.insert(UI_Elements.AnimatedGradients, RowStrokeGrad)

        local TitleLbl = Instance.new("TextLabel", Row)
        TitleLbl.Size = UDim2.new(0.5, -5, 1, 0)
        TitleLbl.Position = UDim2.new(0, 12, 0, 0)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.Text = titleText
        TitleLbl.TextColor3 = Themes[CurrentTheme].DescTextColor
        TitleLbl.TextSize = 11
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(UI_Elements.Descriptions, TitleLbl)

        local ValLbl = Instance.new("TextLabel", Row)
        ValLbl.Size = UDim2.new(0.5, -15, 1, 0)
        ValLbl.Position = UDim2.new(0.5, 5, 0, 0)
        ValLbl.BackgroundTransparency = 1
        ValLbl.Font = Enum.Font.GothamBold
        ValLbl.Text = defaultVal
        ValLbl.TextSize = 12
        ValLbl.TextXAlignment = Enum.TextXAlignment.Right
        ApplyTextGradient(ValLbl)

        return {
            Row = Row,
            Value = ValLbl
        }
    end

    local CurrentBountyRow = CreateStatRow(ContentScroll, "Current Bounty", "0", 1)
    local BountyEarnedRow = CreateStatRow(ContentScroll, "Bounty Earned", "+0", 2)
    local BountyPerHourRow = CreateStatRow(ContentScroll, "Bounty Per Hour", "0 / hr", 3)
    local TotalKillRow = CreateStatRow(ContentScroll, "Total Kill", "0", 4)
    local TotalEarnedRow = CreateStatRow(ContentScroll, "Total Earned", "0", 5)

    local ValueLabels = {
        ["Current Bounty"] = CurrentBountyRow.Value,
        ["Bounty Earned"] = BountyEarnedRow.Value,
        ["Bounty Per Hour"] = BountyPerHourRow.Value,
        ["Total Kill"] = TotalKillRow.Value,
        ["Total Earned"] = TotalEarnedRow.Value
    }

    local isOpen = false
    local isAnimating = false

    local function ToggleHologramUI()
        if isAnimating then return end
        isAnimating = true
        isOpen = not isOpen

        if isOpen then
            HoloWindow.Visible = true
            
            local notchExpand = TweenService:Create(NotchFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 260, 0, 36)
            })
            notchExpand:Play()

            HoloProjectorRing.Size = UDim2.new(0, 10, 0, 10)
            RingStroke.Transparency = 0.2
            local ringTween = TweenService:Create(HoloProjectorRing, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 160, 0, 28)
            })
            ringTween:Play()

            CenterRay.Size = UDim2.new(0, 240, 0, 0)
            LeftRay.Size = UDim2.new(0, 150, 0, 0)
            RightRay.Size = UDim2.new(0, 150, 0, 0)
            
            CenterRay.BackgroundTransparency = 0.4
            LeftRay.BackgroundTransparency = 0.5
            RightRay.BackgroundTransparency = 0.5

            local rayTween1 = TweenService:Create(CenterRay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 300, 0, 240),
                BackgroundTransparency = 0.8
            })
            local rayTween2 = TweenService:Create(LeftRay, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 160, 0, 250),
                BackgroundTransparency = 0.85
            })
            local rayTween3 = TweenService:Create(RightRay, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 160, 0, 250),
                BackgroundTransparency = 0.85
            })

            rayTween1:Play()
            rayTween2:Play()
            rayTween3:Play()

            HoloWindow.Position = UDim2.new(0.5, 0, 0, 48)
            HoloWindow.GroupTransparency = 1
            WindowScale.Scale = 0.65

            task.delay(0.12, function()
                TweenService:Create(HoloWindow, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, 0, 0, 68),
                    GroupTransparency = 0
                }):Play()
                TweenService:Create(WindowScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            end)

            task.delay(0.5, function()
                isAnimating = false
            end)
        else
            local notchShrink = TweenService:Create(NotchFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 200, 0, 32)
            })
            notchShrink:Play()

            TweenService:Create(HoloProjectorRing, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()

            TweenService:Create(CenterRay, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(LeftRay, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(RightRay, TweenInfo.new(0.25, Enum.EasingStyle.Sine), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()

            local closeTween = TweenService:Create(HoloWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, 0, 48),
                GroupTransparency = 1
            })
            TweenService:Create(WindowScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Scale = 0.65
            }):Play()

            closeTween:Play()
            closeTween.Completed:Connect(function()
                if not isOpen then
                    HoloWindow.Visible = false
                end
                isAnimating = false
            end)
        end
    end

    local clickCount = 0
    local lastClickTime = 0

    NotchClickBtn.MouseButton1Click:Connect(function()
        TweenService:Create(NotchScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.9}):Play()
        task.delay(0.1, function()
            TweenService:Create(NotchScale, TweenInfo.new(0.25, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)

        local currentTime = tick()
        if currentTime - lastClickTime > 0.4 then
            clickCount = 0
        end
        clickCount = clickCount + 1
        lastClickTime = currentTime

        task.delay(0.4, function()
            if clickCount == 1 and tick() - lastClickTime >= 0.4 then
                ToggleHologramUI()
                clickCount = 0
            elseif clickCount == 2 and tick() - lastClickTime >= 0.4 then
                if currentTarget then
                    Blacklist[currentTarget.Name] = true
                end
                pickNewTarget("manual skip from notch")
                notify("Auto Bounty", "Player Skipped!", 2)
                clickCount = 0
            elseif clickCount >= 3 then
                stopAll()
                notify("Auto Bounty", "Script Stopped!", 2)
                stopAll()
                clickCount = 0
            end
        end)
    end)

    local rot = 0
    RunService.RenderStepped:Connect(function(dt)
        rot = (rot + 1.5) % 360
        
        for _, grad in pairs(UI_Elements.RotatingGradients) do
            if grad and grad.Parent then
                grad.Rotation = rot
                grad.Color = Themes[CurrentTheme].LoopSeq
            end
        end

        local animatedOffset = Vector2.new(math.sin(tick() * 2) * 0.4, 0)
        for _, grad in pairs(UI_Elements.AnimatedGradients) do
            if grad and grad.Parent then
                grad.Offset = animatedOffset
            end
        end
        for _, grad in pairs(UI_Elements.RowStrokeGradients) do
            if grad and grad.Parent then
                grad.Offset = animatedOffset
            end
        end

        if isOpen and HoloWindow.Visible then
            local scanY = (tick() * 0.4) % 1
            ScanlineEffect.Position = UDim2.new(0, 0, scanY, 0)

            local pulse = (math.sin(tick() * 4) + 1) / 2
            CenterRay.BackgroundTransparency = 0.8 + (pulse * 0.1)
            LeftRay.BackgroundTransparency = 0.85 + (pulse * 0.1)
            RightRay.BackgroundTransparency = 0.85 + (pulse * 0.1)
        end
    end)

    getgenv().DynamicBounty_API = {
        Toggle = ToggleHologramUI,
        SetStatus = SetStatus,
        UpdateStat = function(key, val)
            if ValueLabels[key] then
                ValueLabels[key].Text = tostring(val)
            end
        end
    }

    local startBountyTime = tick()
    local startBountyVal = getBounty(LocalPlayer) or 0

    task.spawn(function()
        while task.wait() do
            pcall(function()
                if getgenv().DynamicBounty_API then
                    local currentBountyVal = getBounty(LocalPlayer) or 0
                    
                    local formattedCurrent = tostring(currentBountyVal):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                    getgenv().DynamicBounty_API.UpdateStat("Current Bounty", formattedCurrent)
                    
                    local formattedEarned = tostring(sessionBountyEarned):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                    getgenv().DynamicBounty_API.UpdateStat("Bounty Earned", "+" .. formattedEarned)
                    
                    local formattedTotalEarned = tostring(totalBountyEarned):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                    getgenv().DynamicBounty_API.UpdateStat("Total Earned", formattedTotalEarned)
                    
                    getgenv().DynamicBounty_API.UpdateStat("Total Kill", tostring(allTimeKills))
                    

                    local totalSeconds = totalTimeElapsed + math.floor(os.time() - bsStartTime)
                    local bph = 0
                    if totalSeconds > 0 and totalBountyEarned > 0 then
                        bph = math.floor((totalBountyEarned / totalSeconds) * 3600)
                    end
                    local formattedBPH = tostring(bph):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                    getgenv().DynamicBounty_API.UpdateStat("Bounty Per Hour", formattedBPH .. " / hr")

                    

                    if IsScanning then
                        getgenv().DynamicBounty_API.SetStatus("Scanning Server...", 3)
                    elseif not currentTarget then
                        getgenv().DynamicBounty_API.SetStatus("Searching for target...", 3)
                    else
                        local distStr = "--"
                        local hpStr = "--"
                        if currentTarget.Character and LocalPlayer.Character then
                            local tHrp = currentTarget.Character:FindFirstChild("HumanoidRootPart")
                            local tHum = currentTarget.Character:FindFirstChild("Humanoid")
                            local mHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if tHrp and mHrp then
                                distStr = tostring(math.floor((mHrp.Position - tHrp.Position).Magnitude)) .. "m"
                            end
                            if tHum and tHum.MaxHealth > 0 then
                                hpStr = tostring(math.floor((tHum.Health / tHum.MaxHealth) * 100)) .. "%"
                            end
                        end
                        getgenv().DynamicBounty_API.SetStatus("Target: " .. currentTarget.Name .. " | HP: " .. hpStr .. " | Dist: " .. distStr, 3)
                    end
                end
            end)
        end
    end)

if getgenv().Config and getgenv().Config["HideUI"] == false then
        task.delay(1.5, function()
            if not isOpen then
                ToggleHologramUI()
            end
        end)
    end
end



local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
local OldIndex = MT.__index
setreadonly(MT, false)

local LocalPlayer = game:GetService("Players").LocalPlayer
local PlayerMouse = LocalPlayer:GetMouse()

MT.__index = newcclosure(function(self, key)
    if getgenv().AutoAimbot and (key == "Hit" or key == "Target") then
        if not checkcaller() and self == PlayerMouse then
            local targetPart = getgenv().CurrentTargetPart
            if targetPart then
                if key == "Hit" then
                    if getgenv().Config and getgenv().Config["GunAim"] == false then
                        return getgenv().MacroAimPos
                    else
                        return targetPart.CFrame
                    end
                elseif key == "Target" then
                    return targetPart
                end
            end
        end
    end
    return OldIndex(self, key)
end)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    
    if getgenv().AutoAimbot and (Method == "FireServer" or Method == "InvokeServer") and not checkcaller() then
        local rawTarget = getgenv().CurrentTargetPart
        
        if rawTarget then
            local Args = {...}
            local fireAimPos
            local fireAimCFrame
            
            if getgenv().Config and getgenv().Config["PredictionAim"] == true and getgenv().MacroAimPos then
                fireAimPos = getgenv().MacroAimPos.Position
                fireAimCFrame = getgenv().MacroAimPos
            else
                fireAimPos = rawTarget.Position
                fireAimCFrame = rawTarget.CFrame
            end

            if Method == "FireServer" and typeof(self) == "Instance" and (self.Name == "RemoteEvent" or self.ClassName == "RemoteEvent") then
                local arg1str = tostring(Args[1])
                if arg1str ~= "true" and arg1str ~= "false" then
                    for i, v in ipairs(Args) do
                        local t1 = typeof(v)
                        if t1 == "Vector3" then
                            Args[i] = fireAimPos
                        elseif t1 == "vector" then
                            Args[i] = vector.create(fireAimPos.X, fireAimPos.Y, fireAimPos.Z)
                        elseif t1 == "CFrame" then
                            Args[i] = fireAimCFrame
                        end
                    end
                    return OldNameCall(self, unpack(Args))
                end
                
            elseif Method == "InvokeServer" and typeof(self) == "Instance" and self.ClassName == "RemoteFunction" then
                local skill = tostring(Args[1])
                local isSkill = (typeof(skill) == "string" and string.len(skill) == 1 and skill:match("%u"))
                
                if isSkill then
                    local function scanTable(t)
                        for tk, tv in pairs(t) do
                            local typeTv = typeof(tv)
                            if typeTv == "Vector3" then
                                t[tk] = fireAimPos
                            elseif typeTv == "CFrame" then
                                t[tk] = fireAimCFrame
                            elseif typeTv == "table" then
                                scanTable(tv)
                            end
                        end
                    end

                    for i, v in ipairs(Args) do
                        local typeV = typeof(v)
                        if typeV == "Vector3" then
                            Args[i] = fireAimPos
                        elseif typeV == "vector" then
                            Args[i] = vector.create(fireAimPos.X, fireAimPos.Y, fireAimPos.Z)
                        elseif typeV == "CFrame" then
                            Args[i] = fireAimCFrame
                        elseif typeV == "Instance" and (v:IsA("BasePart") or v:IsA("Model")) then
                            Args[i] = rawTarget
                        elseif typeV == "table" then
                            scanTable(v)
                        end
                    end
                    
                    if typeof(Args[2]) == "Vector3" or typeof(Args[2]) == "CFrame" then
                        Args[3] = rawTarget
                    end
                    
                    return OldNameCall(self, unpack(Args))
                else
                    for i, v in ipairs(Args) do
                        local typeV = typeof(v)
                        if typeV == "Vector3" then
                            Args[i] = fireAimPos
                        elseif typeV == "vector" then
                            Args[i] = vector.create(fireAimPos.X, fireAimPos.Y, fireAimPos.Z)
                        elseif typeV == "CFrame" then
                            Args[i] = fireAimCFrame
                        end
                    end
                    return OldNameCall(self, unpack(Args))
                end
            end
        end
    end
    
    return OldNameCall(self, ...)
end)

setreadonly(MT, true)


task.spawn(function()
    local lastTracerLostTick = 0
    local lastCheckPos = nil
    local lastMoveTick = 0

    while task.wait(0.1) do
        pcall(function()
            if not currentTarget then
                lastTracerLostTick = 0
                lastCheckPos = nil
                lastMoveTick = 0
                return
            end

            if running and not _G.IsSkyHopping and not IsScanning then
                local isTracerActive = TracerLine and TracerLine.Visible and TracerLine.Adornee ~= nil
                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local curTick = tick()

                local isTracerLostOver1s = false
                if not isTracerActive then
                    if lastTracerLostTick == 0 then
                        lastTracerLostTick = curTick
                    elseif curTick - lastTracerLostTick >= 1 then
                        isTracerLostOver1s = true
                    end
                else
                    lastTracerLostTick = 0
                end

                local isStuckOver2_5s = false
                if myHrp then
                    local currentPos = myHrp.Position
                    if not lastCheckPos then
                        lastCheckPos = currentPos
                        lastMoveTick = curTick
                    else
                        if (currentPos - lastCheckPos).Magnitude > 5 then
                            lastCheckPos = currentPos
                            lastMoveTick = curTick
                        elseif curTick - lastMoveTick >= 2.5 then
                            isStuckOver2_5s = true
                        end
                    end
                else
                    lastCheckPos = nil
                    lastMoveTick = 0
                end

                if isTracerLostOver1s or isStuckOver2_5s then
                    lastTracerLostTick = 0
                    lastCheckPos = nil
                    lastMoveTick = 0

                    if not risk() then
                        if myChar and myChar:FindFirstChild("Humanoid") then
                            myChar.Humanoid.Health = 0
                        end
                    else
                        if currentTarget then
                            Blacklist[currentTarget.Name] = true
                        end
                        currentTarget = nil
                        getgenv().CurrentTarget = nil
                        getgenv().targ = nil
                        pickNewTarget("stuck > 2.5s or tracer lost > 1s")
                    end
                end
            else
                lastTracerLostTick = 0
                lastCheckPos = nil
                lastMoveTick = 0
            end
        end)
    end
end)
