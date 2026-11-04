--[[
    MEYY HUB - MACRO (PvP Premium) - SCRIPT COMPLETO DESCIFRADO (100% AUTOCONTENIDO)
    ------------------------------------------------------------------
    - Extraido del servidor de meyyhub con tu key (naa-21ETAU5C) y tu HWID.
    - Sin autenticacion, sin anti-tamper, sin checks de key: codigo puro.
    - SIN DEPENDENCIAS EXTERNAS: los modulos que antes se descargaban de
      pastefy estan incrustados dentro (buscar "[INLINE" para verlos).
    - Funciones: combos DarkF/Soru, FastAttack, LavaTrap, AutoV4, AntiStun, InfTP, hitbox, aim prediction, FPS boost
    - Para usarlo: pega/ejecuta este archivo completo en tu executor.
]]
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
---------
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Mouse = Players.LocalPlayer:GetMouse()

getgenv().AntiStunEnabled = false
getgenv().InfTPEnabled = false
getgenv().PlayerJumpPower = 0
getgenv().PlayerSpeedPower = 0
getgenv().HitboxEnabled = false
getgenv().HitboxShow = false
getgenv().HitboxSize = 10
_G.dragontorm = false
_G.ChonPhe = "Pirates"


---------
---------
RunService.Stepped:Connect(function(time, deltaTime)
    local char = Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    if getgenv().PlayerSpeedPower > 0 and not getgenv().AntiStunEnabled then
        hum.WalkSpeed = getgenv().PlayerSpeedPower
    elseif getgenv().PlayerSpeedPower == 0 and not getgenv().AntiStunEnabled then
        hum.WalkSpeed = 16 
    end
    
    if getgenv().PlayerJumpPower > 0 then
        hum.UseJumpPower = true
        hum.JumpPower = getgenv().PlayerJumpPower
    elseif getgenv().PlayerJumpPower == 0 then
        hum.UseJumpPower = true
        hum.JumpPower = 50 
    end

    if getgenv().AntiStunEnabled then
        hum.WalkSpeed = 0 
        local speed = getgenv().PlayerSpeedPower > 0 and getgenv().PlayerSpeedPower or 16
        local moveDir = Vector3.zero
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Workspace.CurrentCamera.CFrame.RightVector end
        
        moveDir = Vector3.new(moveDir.X, 0, moveDir.Z)
        if moveDir.Magnitude > 0 then 
            moveDir = moveDir.Unit 
            hrp.CFrame = hrp.CFrame + (moveDir * speed * deltaTime)
        end
    end
end)
---------

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if getgenv().InfTPEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) then
            local char = Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
                char:PivotTo(CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)))
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().HitboxEnabled then return end
    
    local size = getgenv().HitboxSize
    local transparency = getgenv().HitboxShow and 0.5 or 1
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.Size = Vector3.new(size, size, size)
            hrp.Transparency = transparency
            hrp.CanCollide = false
        end
    end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in ipairs(enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                local hrp = enemy.HumanoidRootPart
                hrp.Size = Vector3.new(size, size, size)
                hrp.Transparency = transparency
                hrp.CanCollide = false
            end
        end
    end
end)
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if not getgenv().MacroConfig then
    getgenv().MacroConfig = {
        Settings = {
            Enabled = false,
            ActivationKey = "G",
            LoopCombo = false,
            AimTargetMode = "ClosestPlayer",
            AimEnemies = false,
            AutoSoruSkill = false,
            SoruSkills = {},
            SoruSkillDelay = 0,
            AutoSoruCombo = false,
            SoruComboDelay = 0,
            AutoSoruKey = "R",
            AutoSoruRSpamMs = 50,
            AutoSoruActive = false
        },
        PredictionSettings = {
            PredictionAimbot = false,
            PredictionSoru = true,
            PredictionSilentSoru = false,
            MaxDistance = 500
        },
        ComboBlocks = {}
    }
    
    for i = 1, 12 do
        getgenv().MacroConfig.ComboBlocks[i] = {
            BlockName = "Combo " .. i,
            Enabled = false,
            EquipItem = { Enabled = false, ItemName = "Melee" },
            BeforeSkill = {
                Enabled = true,
                Actions = {
                    { Action = "Soru", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Jump", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 }
                }
            },
            SkillAction = {
                Button = "Z", SpamCount = 1, SpamInterval = 0.01,
                HoldTime = 0, DelayTime = 0, AimMode = "Body", VectorOffset = Vector3.new(0, 0, 0)
            },
            AfterSkill = {
                Enabled = true,
                Actions = {
                    { Action = "Soru", Enabled = false, RunInThread = false, DelayAfter = 0 },
                    { Action = "Jump", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 },
                    { Action = "Click", Enabled = false, RunInThread = false, SpamCount = 1, SpamInterval = 0.1, DelayAfter = 0 }
                }
            },
            BlockDelayAfter = 0
        }
    end
end
---------
---------
---------
getgenv().MacroAimPos = nil
getgenv().SilentAimActive = true
getgenv().IsSpamming = getgenv().IsSpamming or {}

local IsMacroRunning = false
local CurrentTarget = nil
local ActiveAimMode = "Body"
local ActiveVectorOffset = Vector3.new(0,0,0)
local AimUpdaterConnection = nil

local PREDICT_RATIO = 65 / 140
local MAX_SAMPLES = 10
local enemyHistory = {}
local playerSpeedHistory = {}

local FOV_RADIUS = 1500
local SMOOTHNESS = 1

---------
local function getMinValueSpeed(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if not targetPlayer or not targetPlayer.Character then return nil end
    
    local targetChar = targetPlayer.Character
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
    if not targetPart then return nil end

    local currentTime = tick()
    local currentPos = targetPart.Position

    if not playerSpeedHistory[playerName] then
        playerSpeedHistory[playerName] = {
            lastPos = currentPos,
            lastTime = currentTime,
            lastCheckTime = currentTime,
            speeds = {},
            lastFinalValue = nil
        }
        return nil
    end

    local data = playerSpeedHistory[playerName]
    local deltaTime = currentTime - data.lastTime

    if deltaTime > 0 then
        local distance = (currentPos - data.lastPos).Magnitude
        local instantSpeed = distance / deltaTime
        table.insert(data.speeds, instantSpeed)
        data.lastPos = currentPos
        data.lastTime = currentTime
    end

    if currentTime - data.lastCheckTime >= 5 then
        if #data.speeds > 0 then
            local minSpeed = math.huge
            for _, s in ipairs(data.speeds) do
                if s < minSpeed then
                    minSpeed = s
                end
            end
            if minSpeed ~= math.huge then
                data.lastFinalValue = minSpeed + 30
            end
        end
        table.clear(data.speeds)
        data.lastCheckTime = currentTime
    end

    return data.lastFinalValue
end

task.spawn(function()
    while task.wait() do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                getMinValueSpeed(p.Name)
            end
        end
    end
end)

---------
local function isValidTarget(targetPlayer)
    local lPlayer = Players.LocalPlayer
    if lPlayer and lPlayer.Team and lPlayer.Team.Name == "Marines" then
        if targetPlayer.Team and targetPlayer.Team.Name == "Marines" then
            return false
        end
    end

    if targetPlayer:GetAttribute("PvpDisabled") == true then
        return false
    end

    if not targetPlayer or not targetPlayer.Character then 
        return false 
    end
    
    local char = targetPlayer.Character
    if char:FindFirstChild("TempSafeZone") then 
        return false 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        return false 
    end
    
    local safeZones = Workspace:FindFirstChild("_WorldOrigin") and Workspace._WorldOrigin:FindFirstChild("SafeZones")
    if safeZones then
        local pos = hrp.Position
        for _, v in ipairs(safeZones:GetChildren()) do
            if v:IsA("BasePart") then
                local mesh = v:FindFirstChildOfClass("SpecialMesh")
                local radius = mesh and (mesh.Scale.X * 0.5) or (v.Size.X * 0.5)
                if (v.Position - pos).Magnitude <= radius then
                    return false
                end
            end
        end
    end
    
    return true
end

local function GetTarget()
    local config = getgenv().MacroConfig
    local mode = config.Settings.AimTargetMode
    local maxDist = config.PredictionSettings.MaxDistance
    
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local myRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    if not myRoot then return nil, nil end
    local myPos = myRoot.Position

    if mode == "ClosestPlayer" then
        local dist = maxDist
        local targetPlayer = nil
        local targetPart = nil
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 and isValidTarget(p) then
                local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or p.Character:FindFirstChild("Head")
                if root then
                    local mag = (root.Position - myPos).Magnitude
                    if mag <= dist then
                        dist = mag
                        targetPlayer = p
                        targetPart = root
                    end
                end
            end
        end
        
        local enemiesFolder = workspace:FindFirstChild("Enemies")
        if enemiesFolder and not targetPlayer and config.Settings.AimEnemies then
            for _, e in pairs(enemiesFolder:GetChildren()) do
                if e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and e:FindFirstChild("HumanoidRootPart") then
                    local mag = (e.HumanoidRootPart.Position - myPos).Magnitude
                    if mag <= dist then
                        dist = mag
                        targetPart = e.HumanoidRootPart
                    end
                end
            end
            return nil, targetPart
        end

        return targetPlayer, targetPart
    elseif mode == "Mouse" then
        local mouse = LocalPlayer:GetMouse()
        if mouse.Target then
            return nil, mouse.Hit.Position
        end
    end
    
    return nil, nil
end
---------
local function getClosestPlayerForSoru()
    local closestPlayer = nil
    local shortestDistance = 3000
    local char = LocalPlayer.Character
    if not char then return nil end
    local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    if not myPart then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isValidTarget(player) then
            local targetChar = player.Character
            local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
            if targetPart then
                local distance = (myPart.Position - targetPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end
---------
local function FindNearestTarget()
    local targetModel = nil
    local minDistance = math.huge
    local playerHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart") 
    if not playerHRP then return nil end
    
    local function checkTarget(v)
        local humanoid = v:FindFirstChildOfClass("Humanoid")
        if v and humanoid and v:FindFirstChild("HumanoidRootPart") and humanoid.Health > 0 then
            local dis = (playerHRP.Position - v.HumanoidRootPart.Position).Magnitude
            if dis <= 500 and dis < minDistance then
                minDistance = dis 
                targetModel = v
            end
        end
    end

    local MobContainer = Workspace:FindFirstChild("Enemies") or Workspace 
    for _, v in pairs(MobContainer:GetChildren()) do
        checkTarget(v)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= p and player.Character and isValidTarget(player) then
            checkTarget(player.Character)
        end
    end

    return targetModel
end

---------
RunService.RenderStepped:Connect(function()
    if getgenv().MacroConfig.Settings.Enabled then
        if not IsMacroRunning then
            local targetPlayer, targetPart = GetTarget()
            if targetPart then
                local aimPos
                local predVisual = Workspace:FindFirstChild("MacroPredVisual")
                
                if getgenv().MacroConfig.PredictionSettings.PredictionAimbot and predVisual and predVisual.Transparency < 1 then
                    aimPos = predVisual.Position
                else
                    if typeof(targetPart) == "Instance" then
                        aimPos = targetPart.Position
                    elseif typeof(targetPart) == "Vector3" then
                        aimPos = targetPart
                    end
                end
                
                if aimPos then
                    local camPos = Camera.CFrame.Position
                    if (aimPos - camPos).Magnitude > 0.01 then
                        local lookDir = (aimPos - camPos).Unit
                        getgenv().MacroAimPos = CFrame.lookAt(aimPos, aimPos + lookDir)
                    end
                end
            else
                getgenv().MacroAimPos = nil
            end
        end
    else
        getgenv().MacroAimPos = nil
    end
end)
---------
local function getClosestPlayerForSoru()
    local closestPlayer = nil
    local shortestDistance = 3000
    local char = LocalPlayer.Character
    if not char then return nil end
    local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
    if not myPart then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and isValidTarget(player) then
            local targetChar = player.Character
            local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
            if targetPart then
                local distance = (myPart.Position - targetPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

---------
local function getPredictedPosition(target)
    if not target or not target.Character then return nil end
    
    local targetChar = target.Character
    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
    local targetHum = targetChar:FindFirstChild("Humanoid")
    if not targetPart then return nil end
    
    local curTime = tick()
    local curPos = targetPart.Position
    
    if not enemyHistory[target.Name] then 
        enemyHistory[target.Name] = {lastPos = curPos, lastTime = curTime, speeds = {}} 
        return curPos 
    end
    
    local data = enemyHistory[target.Name]
    local dT = curTime - data.lastTime
    if dT > 0 then
        local distMoved = (curPos - data.lastPos).Magnitude
        table.insert(data.speeds, distMoved / dT)
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
        
        if avgSpd > 0.5 then
            local fDir = (targetHum and targetHum.MoveDirection.Magnitude > 0) and (targetHum.MoveDirection.Unit + targetPart.CFrame.LookVector).Unit or moveActDir
            return targetPart.Position + (fDir * (avgSpd * PREDICT_RATIO))
        end
    end
    return curPos
end

---------
local function SimulateKey(keyStr, isHold, releaseDelay)
    local success, keyCode = pcall(function() return Enum.KeyCode[keyStr] end)
    if not success then return end
    
    VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
    if not isHold then
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    elseif releaseDelay then
        task.spawn(function()
            task.wait(releaseDelay)
            VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
        end)
    end
end

local function SimulateClick()
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

---------
local function ExecuteActionPipeline(actionData)
    if not actionData.Enabled or not IsMacroRunning then return true end
    local actionType = actionData.Action
    local count = actionData.SpamCount or 1
    local interval = actionData.SpamInterval or 0
    
    if actionType == "Soru" then
        local targetPlayer = getClosestPlayerForSoru()
        local char = LocalPlayer.Character
        if not char then return false end
        local myPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head")
        
        if not myPart or not targetPlayer then return false end
        
        local config = getgenv().MacroConfig.PredictionSettings
        local soruSuccess = false

        if config.PredictionSoru then
            local predPos = getPredictedPosition(targetPlayer)
            if predPos then
                char:PivotTo(CFrame.new(predPos, predPos + myPart.CFrame.LookVector))
                soruSuccess = true
            end
        else
            local startWaitTime = tick()
            while tick() - startWaitTime <= 5 do
                if not IsMacroRunning then return false end
                local targetChar = targetPlayer.Character
                if targetChar then
                    local targetPart = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("Head")
                    if targetPart then
                        local targetMinSpeed = playerSpeedHistory[targetPlayer.Name] and playerSpeedHistory[targetPlayer.Name].lastFinalValue or math.huge
                        local currentSpeed = 0
                        local histData = playerSpeedHistory[targetPlayer.Name]
                        if histData and #histData.speeds > 0 then
                            currentSpeed = histData.speeds[#histData.speeds]
                        end
                        
                        if currentSpeed < targetMinSpeed then
                            char:PivotTo(CFrame.new(targetPart.Position, targetPart.Position + myPart.CFrame.LookVector))
                            soruSuccess = true
                            break
                        end
                    end
                end
                task.wait()
            end
        end
        
        if soruSuccess then
            task.wait(0.075)
        end
        return soruSuccess
        
    elseif actionType == "Jump" then
        for i = 1, count do
            if not IsMacroRunning then break end
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            if interval > 0 then task.wait(interval) end
        end
        return true

    elseif actionType == "Click" then
        for i = 1, count do
            if not IsMacroRunning then break end
            SimulateClick()
            if interval > 0 then task.wait(interval) end
        end
        return true
    end

    return true
end

---------
local function ProcessActionList(sectionInfo)
    if not sectionInfo.Enabled or not IsMacroRunning then return true end
    
    for _, actionData in ipairs(sectionInfo.Actions) do
        if not IsMacroRunning then break end
        if not actionData.Enabled then continue end
        
        if actionData.RunInThread then
            task.spawn(function()
                ExecuteActionPipeline(actionData)
                if actionData.DelayAfter and actionData.DelayAfter > 0 then
                    task.wait(actionData.DelayAfter)
                end
            end)
        else
            local success = ExecuteActionPipeline(actionData)
            if success == false then return false end
            
            if actionData.DelayAfter and actionData.DelayAfter > 0 then
                task.wait(actionData.DelayAfter)
            end
        end
    end
    return true
end
---------
local function ProcessSkillAction(skillData, toolName)
    if not IsMacroRunning or not skillData.Button then return true end
    
    local skillGui = nil
    local cdGui = nil
    
    if toolName then
        local waitTime = tick()
        while not skillGui and tick() - waitTime < 0.2 do
            task.wait()
            local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
            if mainGui and mainGui:FindFirstChild("Skills") then
                skillGui = mainGui.Skills:FindFirstChild(toolName)
            end
        end
        
        if skillGui and skillGui:FindFirstChild(skillData.Button) then
            cdGui = skillGui[skillData.Button]:FindFirstChild("Cooldown")
        end
    end

    if cdGui and cdGui.AbsoluteSize.X > 0 then
        pcall(function()
            Library:SendNotification("System", "Skill " .. skillData.Button .. " of " .. (toolName or "Weapon") .. " is on cooldown")
        end)
        return false
    end
    
    ActiveAimMode = skillData.AimMode or "Body"
    ActiveVectorOffset = skillData.VectorOffset or Vector3.new(0,0,0)
    
---------
    AimUpdaterConnection = RunService.RenderStepped:Connect(function()
        if not IsMacroRunning then return end
        local targetPlayer, targetPart = GetTarget()
        
        if targetPlayer and targetPart then
            CurrentTarget = targetPlayer
            local aimPos
            
            local predVisual = Workspace:FindFirstChild("MacroPredVisual")
            if getgenv().MacroConfig.PredictionSettings.PredictionAimbot and predVisual and predVisual.Transparency < 1 then
                aimPos = predVisual.Position
            else
                aimPos = targetPart.Position
            end
            
            if aimPos then
                if ActiveAimMode == "Vector" and ActiveVectorOffset then
                    aimPos = aimPos + ActiveVectorOffset
                end
                
                local camPos = Camera.CFrame.Position
                if (aimPos - camPos).Magnitude > 0.01 then
                    local lookDir = (aimPos - camPos).Unit
                    getgenv().MacroAimPos = CFrame.lookAt(aimPos, aimPos + lookDir)
                end
            end
        elseif targetPart and typeof(targetPart) == "Vector3" then
            local aimPos = targetPart
            if ActiveAimMode == "Vector" and ActiveVectorOffset then
                aimPos = aimPos + ActiveVectorOffset
            end
            
            local camPos = Camera.CFrame.Position
            if (aimPos - camPos).Magnitude > 0.01 then
                local lookDir = (aimPos - camPos).Unit
                getgenv().MacroAimPos = CFrame.lookAt(aimPos, aimPos + lookDir)
            end
        else
            getgenv().MacroAimPos = nil
        end
    end)
---------

    local spamCount = skillData.SpamCount or 1
    local spamInterval = skillData.SpamInterval or 0
    local holdTime = skillData.HoldTime or 0
    local delayTime = skillData.DelayTime or 0
    
    local successKey, keyEnum = pcall(function() return Enum.KeyCode[skillData.Button] end)
    if successKey then
        for i = 1, spamCount do
            if not IsMacroRunning then break end
            if cdGui and cdGui.AbsoluteSize.X > 0 then break end
            
            if holdTime > 0 then
                VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                task.wait(holdTime)
                VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
            else
                VirtualInputManager:SendKeyEvent(true, keyEnum, false, game)
                task.wait(0.01)
                VirtualInputManager:SendKeyEvent(false, keyEnum, false, game)
            end
            
            if spamInterval > 0 and i < spamCount then
                task.wait(spamInterval)
            end
        end
    end
    
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
    
    if IsMacroRunning and delayTime > 0 then
        task.wait(delayTime)
    end
    
    return true
end
---------
local function CheckAndClickLava()
    ---------
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then
        return false
    end
    
    local mainUI = playerGui:FindFirstChild("Main")
    if not mainUI then
        return false
    end
    
    local gateway = mainUI:FindFirstChild("Gateway")
    local mainContent = gateway and gateway:FindFirstChild("MainContent")
    local scrollingFrame = mainContent and mainContent:FindFirstChild("ScrollingFrame")
    local lavaButton = scrollingFrame and scrollingFrame:FindFirstChild("Lava")
    
    ---------
    if lavaButton and lavaButton:IsA("GuiObject") and lavaButton.Visible then
        ---------
        if getconnections then
            for _, connection in pairs(getconnections(lavaButton.MouseButton1Click)) do
                connection:Fire()
            end
            for _, connection in pairs(getconnections(lavaButton.Activated)) do
                connection:Fire()
            end
        else
            ---------
            local centerX = lavaButton.AbsolutePosition.X + (lavaButton.AbsoluteSize.X / 2)
            local centerY = lavaButton.AbsolutePosition.Y + (lavaButton.AbsoluteSize.Y / 2)
            VirtualUser:ClickButton1(Vector2.new(centerX, centerY))
        end
        return true
    end
    
    ---------
    return false
end
---------
local function EquipConfiguredItem(equipInfo)
    if not equipInfo.Enabled or not equipInfo.ItemName or not IsMacroRunning then return nil end
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2))
    
    if humanoid and backpack and char then
        local targetTool = nil
        local searchType = string.lower(equipInfo.ItemName)
        
        local function scanTools(container)
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") then
                    local nameLower = string.lower(item.Name)
                    local tipLower = string.lower(item.ToolTip)
                    
                    if searchType == "fruit" or searchType == "blox fruit" then
                        if tipLower == "blox fruit" or string.find(nameLower, "fruit") then return item end
                    elseif searchType == "melee" then
                        if tipLower == "melee" or string.find(nameLower, "combat") or string.find(nameLower, "style") or item:FindFirstChild("MeleeScript") then return item end
                    elseif searchType == "sword" then
                        if tipLower == "sword" or item:FindFirstChild("SwordScript") then return item end
                    elseif searchType == "gun" then
                        if tipLower == "gun" or item:FindFirstChild("GunScript") then return item end
                    else
                        if string.find(nameLower, searchType) then return item end
                    end
                end
            end
            return nil
        end
        
        targetTool = scanTools(char) or scanTools(backpack)
        if targetTool then
            if targetTool.Parent == backpack then
                humanoid:EquipTool(targetTool)
            end
            return targetTool.Name
        end
    end
    return nil
end
---------
---------
local function RunMacroSequence()
    local config = getgenv().MacroConfig
    getgenv().ComboIsActive = true
    getgenv().ComboTimeElapsed = 0

    repeat
        local blocksCount = #config.ComboBlocks
        for i = 1, blocksCount do
            local block = config.ComboBlocks[i]
            if not IsMacroRunning then break end
            if not block.Enabled then continue end
            
            local targetPlayer, targetPart = GetTarget()
            CurrentTarget = targetPlayer
            
            local toolName = EquipConfiguredItem(block.EquipItem)
            
            local beforeResult = ProcessActionList(block.BeforeSkill)
            if not beforeResult then continue end
            
            local skillResult = ProcessSkillAction(block.SkillAction, toolName)
            if not skillResult then continue end
            
            local afterResult = ProcessActionList(block.AfterSkill)
            if not afterResult then continue end
            
            local nextBlockIndex = i + 1
            local nextBlock = nil
            while nextBlockIndex <= blocksCount do
                if config.ComboBlocks[nextBlockIndex].Enabled then
                    nextBlock = config.ComboBlocks[nextBlockIndex]
                    break
                end
                nextBlockIndex = nextBlockIndex + 1
            end
            
            if not nextBlock and config.Settings.LoopCombo then
                for j = 1, i do
                    if config.ComboBlocks[j].Enabled then
                        nextBlock = config.ComboBlocks[j]
                        break
                    end
                end
            end

            if nextBlock and IsMacroRunning then
                EquipConfiguredItem(nextBlock.EquipItem)
            end
            
            if block.BlockDelayAfter and block.BlockDelayAfter > 0 and IsMacroRunning then
                task.wait(block.BlockDelayAfter)
            end
        end
    until not config.Settings.LoopCombo or not IsMacroRunning
    
    IsMacroRunning = false
    getgenv().ComboIsActive = false
    if getgenv().BlinkComboUI then
        task.spawn(getgenv().BlinkComboUI)
    end
    
    if AimUpdaterConnection then
        AimUpdaterConnection:Disconnect()
        AimUpdaterConnection = nil
    end
end
---------

---------
getgenv().ToggleMacroState = function()
    local config = getgenv().MacroConfig
    if not config.Settings.Enabled then return end
    
    IsMacroRunning = not IsMacroRunning
    
    if IsMacroRunning then
        task.spawn(RunMacroSequence)
    else
        if AimUpdaterConnection then
            AimUpdaterConnection:Disconnect()
            AimUpdaterConnection = nil
        end
    end
end
---------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local config = getgenv().MacroConfig
    
    local successToggle, toggleKey = pcall(function() return Enum.KeyCode[config.Settings.ActivationKey] end)
    if successToggle and input.KeyCode == toggleKey then
        if typeof(getgenv().ToggleMacroState) == "function" then
            getgenv().ToggleMacroState()
        end
    end

    local successSoru, soruKey = pcall(function() return Enum.KeyCode[config.Settings.AutoSoruKey] end)
    if successSoru and input.KeyCode == soruKey then
        config.Settings.AutoSoruActive = not config.Settings.AutoSoruActive
    end
end)
---------
---------
local wasSoruInCD = false
local lastSoruUse = 0
local hookInitialized = false

local function check_in_cd()
    if not hookInitialized then
        hookInitialized = true
        local rawNamecall
        rawNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if not checkcaller() and method == "FireServer" and tostring(self) == "CommE" and args[1] == "Soru" then
                lastSoruUse = tick()
            end
            
            return rawNamecall(self, ...)
        end)
    end

    local localPlayer = Players.LocalPlayer
    local character = localPlayer and localPlayer.Character
    if not character then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local raceData = localPlayer:FindFirstChild("Data") and localPlayer.Data:FindFirstChild("Race")

    local baseCooldown = 15
    if raceData and raceData.Value == "Human" and raceData:FindFirstChild("Evolved") then
        baseCooldown = 10
    end

    local flashstepCDAttr = character:GetAttribute("FlashstepCooldown")
    if flashstepCDAttr and type(flashstepCDAttr) == "number" and flashstepCDAttr > 0 then
        baseCooldown = baseCooldown * (1 - flashstepCDAttr)
    end

    local soruCharges = 0
    if humanoid then
        local chargesAttr = humanoid:GetAttribute("SoruCharges")
        if chargesAttr and type(chargesAttr) == "number" then
            soruCharges = chargesAttr
        end
    end

    local remainingCD = math.max(0, baseCooldown - (tick() - lastSoruUse))
    local isReady = (remainingCD <= 0) or (soruCharges > 0)

    return not isReady
end
---------
---------
task.spawn(function()
    while task.wait() do
        local config = getgenv().MacroConfig
        if config and config.Settings.Enabled then
            local isCD = check_in_cd()
            
            if isCD and not wasSoruInCD then
                if config.Settings.AutoSoruSkill and #config.Settings.SoruSkills > 0 then
                    task.spawn(function()
                        for _, skillKeyStr in ipairs(config.Settings.SoruSkills) do
                            local successK, kEnum = pcall(function() return Enum.KeyCode[skillKeyStr] end)
                            if successK then
                                VirtualInputManager:SendKeyEvent(true, kEnum, false, game)
                                task.wait(0.01)
                                VirtualInputManager:SendKeyEvent(false, kEnum, false, game)
                            end
                            task.wait(config.Settings.SoruSkillDelay)
                        end
                    end)
                end
                
                if config.Settings.AutoSoruCombo and not IsMacroRunning then
                    task.spawn(function()
                        if config.Settings.SoruComboDelay > 0 then
                            task.wait(config.Settings.SoruComboDelay)
                        end
                        IsMacroRunning = true
                        RunMacroSequence()
                    end)
                end
            end
            
            wasSoruInCD = isCD
        end
    end
end)

if getgenv().MacroConfig then
    if getgenv().MacroConfig.Settings.SilentAim == nil then
        getgenv().MacroConfig.Settings.SilentAim = true
    end
    if getgenv().MacroConfig.Settings.DrawTracer == nil then
        getgenv().MacroConfig.Settings.DrawTracer = true
    end
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
local PredGlow = Instance.new("PointLight")
PredGlow.Color = Color3.fromRGB(0, 255, 255)
PredGlow.Range = 8
PredGlow.Brightness = 2
PredGlow.Enabled = false
PredGlow.Parent = PredVisual
PredVisual.Parent = Workspace

---------
RunService.RenderStepped:Connect(function()
    if not getgenv().MacroConfig.Settings.Enabled then 
        ESPhighlight.Adornee = nil
        TracerLine.Visible = false
        PredVisual.Transparency = 1
        PredGlow.Enabled = false
        return 
    end

    local targetPlayer, targetPart = GetTarget()
    CurrentTarget = targetPlayer
    getgenv().CurrentTargetPart = targetPart 
    
    local char = LocalPlayer.Character
    local myRoot = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))

    if CurrentTarget and CurrentTarget.Character and myRoot then
        local tarRoot = CurrentTarget.Character:FindFirstChild("HumanoidRootPart") or CurrentTarget.Character:FindFirstChild("UpperTorso")
        
        if tarRoot then
            local dist = (myRoot.Position - tarRoot.Position).Magnitude
            
            if getgenv().MacroConfig.Settings.DrawTracer then
                ESPhighlight.Adornee = CurrentTarget.Character
                TracerLine.Visible = true
            else
                ESPhighlight.Adornee = nil
                TracerLine.Visible = false
            end
            
            TracerLine.Adornee = myRoot
            TracerLine.Length = dist
            TracerLine.CFrame = CFrame.lookAt(Vector3.zero, myRoot.CFrame:PointToObjectSpace(tarRoot.Position))

            if getgenv().MacroConfig.PredictionSettings.PredictionAimbot then
                local pPos = getPredictedPosition(CurrentTarget)
                if pPos then
                    PredVisual.Position = pPos
                    if getgenv().MacroConfig.Settings.DrawTracer then
                        PredVisual.Transparency = 0.2
                        PredGlow.Enabled = true
                    else
                        PredVisual.Transparency = 1
                        PredGlow.Enabled = false
                    end
                else
                    PredVisual.Transparency = 1
                    PredGlow.Enabled = false
                end
            else
                PredVisual.Transparency = 1
                PredGlow.Enabled = false
            end
        else
            ESPhighlight.Adornee = nil
            TracerLine.Visible = false
            PredVisual.Transparency = 1
            PredGlow.Enabled = false
        end
    elseif targetPart and typeof(targetPart) == "Instance" and myRoot then
        local dist = (myRoot.Position - targetPart.Position).Magnitude
        
        if getgenv().MacroConfig.Settings.DrawTracer then
            ESPhighlight.Adornee = targetPart.Parent
            TracerLine.Visible = true
        else
            ESPhighlight.Adornee = nil
            TracerLine.Visible = false
        end
        
        TracerLine.Adornee = myRoot
        TracerLine.Length = dist
        TracerLine.CFrame = CFrame.lookAt(Vector3.zero, myRoot.CFrame:PointToObjectSpace(targetPart.Position))
        PredVisual.Transparency = 1
        PredGlow.Enabled = false
    else
        ESPhighlight.Adornee = nil
        TracerLine.Visible = false
        PredVisual.Transparency = 1
        PredGlow.Enabled = false
    end
end)

---------
task.spawn(function()
    while task.wait(1) do
        if LocalPlayer and (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
            pcall(function()
                local rep = game:GetService("ReplicatedStorage")
                local commF = rep:FindFirstChild("Remotes") and rep.Remotes:FindFirstChild("CommF_")
                if commF then
                    commF:InvokeServer("SetTeam", _G.ChonPhe or "Pirates")
                end
            end)
        end
    end
end)
---------
---------
---------

---------
---------
local PlayerMouse = game:GetService("Players").LocalPlayer:GetMouse()
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
local OldIndex = MT.__index
setreadonly(MT, false)

MT.__index = newcclosure(function(self, key)
    if getgenv().MacroConfig and getgenv().MacroConfig.Settings.Enabled and getgenv().MacroConfig.Settings.SilentAim then
        if (key == "Hit" or key == "Target") then
            if not checkcaller() and self == PlayerMouse then
                local targetPart = getgenv().CurrentTargetPart
                if targetPart then
                    if key == "Hit" then
                        return getgenv().MacroAimPos or CFrame.new(targetPart.Position)
                    elseif key == "Target" then
                        return targetPart
                    end
                end
            end
        end
    end
    return OldIndex(self, key)
end)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    
    if getgenv().MacroConfig and getgenv().MacroConfig.Settings.Enabled and getgenv().MacroConfig.Settings.SilentAim then
        if (Method == "FireServer" or Method == "InvokeServer") and not checkcaller() and getgenv().MacroAimPos then
            local Args = {...}
            local rawTarget = getgenv().CurrentTargetPart
            local fireAimPos = getgenv().MacroAimPos.Position

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
                            Args[i] = getgenv().MacroAimPos or CFrame.new(fireAimPos)
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
                                t[tk] = getgenv().MacroAimPos or CFrame.new(fireAimPos)
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
                            Args[i] = getgenv().MacroAimPos or CFrame.new(fireAimPos)
                        elseif typeV == "Instance" and (v:IsA("BasePart") or v:IsA("Model")) then
                            if rawTarget then Args[i] = rawTarget end
                        elseif typeV == "table" then
                            scanTable(v)
                        end
                    end
                    
                    if typeof(Args[2]) == "Vector3" or typeof(Args[2]) == "CFrame" then
                        if rawTarget then
                            Args[3] = rawTarget
                        end
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
                            Args[i] = getgenv().MacroAimPos or CFrame.new(fireAimPos)
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
---------
---------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local p = Players.LocalPlayer
local GunValidator = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator2")

_G.dragontorm = false 
local AimBotSkillPosition = nil 

pcall(function()
    local gg = getrawmetatable(game);
    local old = gg.__namecall;
    setreadonly(gg, false);

    gg.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod();
        local args = { ... }
        
        if _G.dragontorm and tostring(method) == "FireServer" and tostring(self) == "ShootGunEvent" then
            if AimBotSkillPosition then
                args[1] = AimBotSkillPosition 
                return old(self, unpack(args))
            end
        end
        return old(self, ...)
    end);
end)

local function FindNearestTarget()
    local targetModel = nil
    local minDistance = math.huge
    local playerHRP = p.Character and p.Character:FindFirstChild("HumanoidRootPart") 
    if not playerHRP then return nil end
    
    local function checkTarget(v)
        local humanoid = v:FindFirstChildOfClass("Humanoid")
        if v and humanoid and v:FindFirstChild("HumanoidRootPart") and humanoid.Health > 0 then
            local dis = (playerHRP.Position - v.HumanoidRootPart.Position).Magnitude
            if dis <= 500 and dis < minDistance then
                minDistance = dis 
                targetModel = v
            end
        end
    end

    local MobContainer = Workspace:FindFirstChild("Enemies") or Workspace 
    for _, v in pairs(MobContainer:GetChildren()) do
        checkTarget(v)
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= p and player.Character and isValidTarget(player) then
            checkTarget(player.Character)
        end
    end

    return targetModel
end

local function GetValidator2(shootFunc)
    if not getupvalue or not setupvalue or not shootFunc then return nil, nil end
    local success, v1_val, v7_val = pcall(function()
        local u27 = getupvalue(shootFunc, 13)
        local u23 = getupvalue(shootFunc, 14)
        local u26 = getupvalue(shootFunc, 15)
        local u22 = getupvalue(shootFunc, 16)
        local u24 = getupvalue(shootFunc, 17)
        local u25 = getupvalue(shootFunc, 18)
        local u28 = getupvalue(shootFunc, 19)
        
        local u81 = u27 * u23
        local u82 = (u26 * u23 + u27 * u22) % u24
        u82 = (u82 * u24 + u81) % u25
        u26 = math.floor(u82 / u24)
        u27 = u82 - u26 * u24
        u28 = u28 + 1
        
        setupvalue(shootFunc, 13, u27)
        setupvalue(shootFunc, 14, u23)
        setupvalue(shootFunc, 15, u26)
        setupvalue(shootFunc, 16, u22)
        setupvalue(shootFunc, 17, u24)
        setupvalue(shootFunc, 18, u25)
        setupvalue(shootFunc, 19, u28)
        
        return math.floor(u82 / u25 * 16777215), u28
    end)
    if success and v1_val and v7_val then 
        return v1_val, v7_val 
    end
    return nil, nil
end

task.spawn(function()
    while true do
        if _G.dragontorm then
            local target = FindNearestTarget()
            if target then
                local targetHRP = target:FindFirstChild("HumanoidRootPart") 
                local targetHead = target:FindFirstChild("Head") 
                local targetPos = (targetHead and targetHead.Position) or (targetHRP and targetHRP.Position) 
                
                if targetPos then
                    AimBotSkillPosition = targetPos 
                    pcall(function()
                        local NetModule = require(ReplicatedStorage.Modules.Net)
                        NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos, {targetHead or targetHRP})
                    end)
                end
            end
        else
            AimBotSkillPosition = nil 
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local CombatController, ShootFunction
    pcall(function()
        local Modules = ReplicatedStorage:WaitForChild("Modules")
        CombatController = require(ReplicatedStorage.Controllers.CombatController)
        if getupvalue then
            ShootFunction = getupvalue(CombatController.Attack, 9)
        end
    end)

    while true do
        if _G.dragontorm then
            local target = FindNearestTarget()
            if target then
                local targetHRP = target:FindFirstChild("HumanoidRootPart")
                local targetPos = targetHRP and targetHRP.Position
                
                if targetPos then
                    pcall(function()
                        if ShootFunction and GunValidator then
                            local val1, val2 = GetValidator2(ShootFunction)
                            if val1 and val2 then
                                GunValidator:FireServer(val1, val2)
                            end
                        end
                        local NetModule = require(ReplicatedStorage.Modules.Net)
                        NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos)
                    end)
                end
            end
            task.wait(1.95) 
        else
            task.wait(1) 
        end
    end
end)
---------
local Library = -- [INLINE UI Library — original: https://pastefy.app/frkIutHc/raw]
(function() --begin UI Library

local Library = {}
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

---------
local HttpService = game:GetService("HttpService")

local isfolder = isfolder or function() return false end
local makefolder = makefolder or function() end
local writefile = writefile or function() end
local readfile = readfile or function() return "" end
local isfile = isfile or function() return false end

Library.ConfigFolder = "HubPremium_Configs"
Library.ConfigElements = {}



local saveTick = 0
function Library:AutoSave()
    if Library.IsLoading then return end
    saveTick = tick()
    task.delay(0.5, function()
        if tick() - saveTick >= 0.45 then
            Library:SaveConfig("AutoSave", true)
        end
    end)
end
---------

---------
local UI_Elements = {
    AnimatedGradients = {},
    AnimatedStrokes = {},
    RowStrokes = {},
    RowStrokeGradients = {},
    DivGradients = {},
    TabGradients = {},
    Switches = {},
    TextGradients = {},
    RotatingGradients = {},
    Containers = {},
    TabBackgrounds = {},
    PageElements = {},
    Descriptions = {},
    TabIcons = {},
    TextObjects = {}
}
---------


---------
local CurrentTheme = "Dark"
local Notifications = {}

local exactFruitSeq = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromHex("#B4DCFF")), 
    ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")), 
    ColorSequenceKeypoint.new(1, Color3.fromHex("#B4DCFF"))
})


---------
local Themes = {
    ["Ocean"] = {
        MainBg = Color3.fromHex("#D3D3D3"),
        MainBgTrans = 0.3,
        ContainerBg = Color3.fromHex("#FFFFFF"),
        ContainerTrans = 0.8,
        TextColor = Color3.fromHex("#FFFFFF"),
        DescTextColor = Color3.fromHex("#969696"),
        MainStroke = Color3.fromHex("#FFFFFF"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4DCFF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#B4DCFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
        }),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#E0F0FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#E0F0FF"))
        }),
        TitleStroke = Color3.fromHex("#ADD8E6"),
        TextGrad = exactFruitSeq,
        TabGrad = exactFruitSeq,
        DivGrad = exactFruitSeq,
        RowStroke = Color3.fromHex("#ADD8E6"),
        RowStrokeGrad = exactFruitSeq,
        ToggleActive = Color3.fromHex("#96C8DC"),
        LoopSeq = exactFruitSeq,
        SearchIconColor = Color3.fromHex("#333333")
    },
 
    ["Dream"] = {
        MainBg = Color3.fromHex("#0A1428"),
        MainBgTrans = 0.2,
        ContainerBg = Color3.fromHex("#151C3B"),
        ContainerTrans = 0.5,
        TextColor = Color3.fromHex("#E6FFFF"),
        DescTextColor = Color3.fromHex("#FFFFFF"),
        MainStroke = Color3.fromHex("#D3D3D3"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        Wave = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151C3B")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#151C3B"))
        }),
        TitleStroke = Color3.fromHex("#140A32"),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4FFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#A08CFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        }),
        TabGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        DivGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151C3B")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#151C3B"))
        }),
        RowStroke = Color3.fromHex("#808080"),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        ToggleActive = Color3.fromHex("#8C64FF"),
        LoopSeq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        }),
        SearchIconColor = Color3.fromHex("#8C64FF")
    },

    ["Dark"] = {
        MainBg = Color3.fromHex("#000000"),
        MainBgTrans = 0.3,
        ContainerBg = Color3.fromHex("#525252"), 
        ContainerTrans = 0.6,
        TextColor = Color3.fromHex("#FFFFFF"),
        DescTextColor = Color3.fromHex("#FFFFFF"),
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
        TitleStroke = Color3.fromHex("#222222"),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")), 
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8A8A8A")), 
            ColorSequenceKeypoint.new(1, Color3.fromHex("#1A1A1A")) 
        }),
        TabGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#777777")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
        }),
        DivGrad = ColorSequence.new({ 
            ColorSequenceKeypoint.new(0, Color3.fromHex("#222222")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#888888")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#222222"))
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
        SearchIconColor = Color3.fromHex("#FFFFFF")
    }
}
---------
local CurrentFont = Font.fromName("FredokaOne", Enum.FontWeight.Bold)
local CurrentFontScale = 1

local function ApplyTextGradient(obj)
    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
        obj.FontFace = CurrentFont
        obj.TextColor3 = Themes[CurrentTheme].TextColor
        
        local grad = Instance.new("UIGradient", obj)
        grad.Rotation = 90
        grad.Color = Themes[CurrentTheme].TextContrast
        table.insert(UI_Elements.TextGradients, grad)
        
        local shadow = Instance.new("UIStroke")
        shadow.Color = Themes[CurrentTheme].ToggleActive
        shadow.Thickness = 0.2
        shadow.Transparency = 0
        shadow.Parent = obj

        task.defer(function()
            if not obj or not obj.Parent then return end
            local base = obj.TextSize
            table.insert(UI_Elements.TextObjects, {Obj = obj, BaseSize = base})
            if CurrentFontScale ~= 1 then
                obj.TextSize = math.clamp(math.round(base * CurrentFontScale), 6, 60)
            end
        end)
    end
end

function Library:ApplyFont(fontName)
    local success, newFont = pcall(function()
        return Font.fromName(fontName, Enum.FontWeight.Bold)
    end)
    if not success or not newFont then
        newFont = Font.fromName(fontName)
    end
    CurrentFont = newFont
    for _, item in ipairs(UI_Elements.TextObjects) do
        if item.Obj and item.Obj.Parent then
            item.Obj.FontFace = newFont
        end
    end
end

function Library:ApplyFontScale(percent)
    CurrentFontScale = percent / 100
    for _, item in ipairs(UI_Elements.TextObjects) do
        if item.Obj and item.Obj.Parent then
            item.Obj.TextSize = math.clamp(math.round(item.BaseSize * CurrentFontScale), 6, 60)
        end
    end
end
Library.IsLoading = false

function Library:SaveConfig(fileName, silent)
    if not isfolder(Library.ConfigFolder) then
        makefolder(Library.ConfigFolder)
    end
    local data = {}
    for flag, element in pairs(Library.ConfigElements) do
        data[flag] = element.Value
    end
    local json = HttpService:JSONEncode(data)
    local actualFileName = LocalPlayer.Name .. "-Meyy-Hub-" .. fileName
    writefile(Library.ConfigFolder .. "/" .. actualFileName .. ".json", json)
    if not silent then
        Library:SendNotification("Config System", "Saved " .. actualFileName)
    end
end

function Library:LoadConfig(fileName, silent)
    local actualFileName = LocalPlayer.Name .. "-Meyy-Hub-" .. fileName
    local path = Library.ConfigFolder .. "/" .. actualFileName .. ".json"
    if isfile(path) then
        local json = readfile(path)
        local success, data = pcall(function()
            return HttpService:JSONDecode(json)
        end)
        if success and type(data) == "table" then
            Library.IsLoading = true
            for flag, value in pairs(data) do
                if Library.ConfigElements[flag] then
                    Library.ConfigElements[flag].Set(value)
                end
            end
            Library.IsLoading = false
            if not silent then
                Library:SendNotification("Config System", "Loaded " .. actualFileName)
            end
        else
            if not silent then
                Library:SendNotification("Config Error", "Failed to parse JSON")
            end
        end
    else
        if not silent then
            Library:SendNotification("Config Error", "File not found")
        end
    end
end
---------
function Library:SendNotification(titleText, descText)
    local g2 = Instance.new("ScreenGui")
    g2.Name = "UI_Cloud_Notification_" .. math.random(100, 999)
    g2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function() g2.Parent = CoreGui end)
    if not g2.Parent then g2.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    
    local m2 = Instance.new("Frame", g2)
    m2.Name = "Main"
    m2.BackgroundColor3 = Themes[CurrentTheme].MainBg
    m2.BackgroundTransparency = 0.3
    m2.Size = UDim2.new(0, 260, 0, 80)
    m2.AnchorPoint = Vector2.new(1, 1)
    m2.Position = UDim2.new(1, 50, 1, -20)
    Instance.new("UICorner", m2).CornerRadius = UDim.new(0, 10)
    
    local u2 = Instance.new("UIStroke", m2)
    u2.Thickness = 2.5
    u2.Color = Themes[CurrentTheme].MainStroke
    
    local e2 = Instance.new("UIGradient", u2)
    e2.Color = Themes[CurrentTheme].LoopSeq
    table.insert(UI_Elements.RotatingGradients, e2)
    
    local bgGradient = Instance.new("UIGradient", m2)
    bgGradient.Color = Themes[CurrentTheme].Wave
    
    local function CreateStatusLabel(name, pos, text, size)
        local label = Instance.new("TextLabel", m2)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = size or 12
        -------------------------
        ApplyTextGradient(label)
        -------------------------
        return label
    end
    
    local titleLabel = CreateStatusLabel("Title", 12, titleText, 16)
    local subLabel = CreateStatusLabel("Subtitle", 40, descText, 12)
    
    local renderSteppedConn
    renderSteppedConn = RunService.RenderStepped:Connect(function()
        bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
    end)
    
    for i, notif in ipairs(Notifications) do
        if notif and notif.Parent then
            local newY = -20 - (i * 90)
            TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, newY)}):Play()
        end
    end
    
    table.insert(Notifications, 1, m2)
    if #Notifications > 5 then
        local oldNotif = table.remove(Notifications, 6)
        if oldNotif then
            TweenService:Create(oldNotif, TweenInfo.new(0.3), {Position = UDim2.new(1, 300, 1, oldNotif.Position.Y.Offset)}):Play()
            task.delay(0.3, function() oldNotif.Parent:Destroy() end)
        end
    end
    
    local showTween = TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, -20)})
    showTween:Play()
    
    task.delay(3, function()
        for i, notif in ipairs(Notifications) do
            if notif == m2 then
                table.remove(Notifications, i)
                break
            end
        end
        local hideTween = TweenService:Create(m2, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 300, 1, m2.Position.Y.Offset)})
        hideTween:Play()
        hideTween.Completed:Connect(function()
            if renderSteppedConn then renderSteppedConn:Disconnect() end
            g2:Destroy()
            for i, notif in ipairs(Notifications) do
                if notif and notif.Parent then
                    local newY = -20 - ((i - 1) * 90)
                    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 1, newY)}):Play()
                end
            end
        end)
    end)
end

function Library:CreateWindow(config)
    local Window = {}
    config = config or {}
    local windowTitle = config.Title or "Hub Premium"
    
    if getgenv().MainUI_Library then
        pcall(function() getgenv().MainUI_Library:Destroy() end)
        getgenv().MainUI_Library = nil
    end
    
    local g = Instance.new("ScreenGui")
    g.Name = "Hub_Premium_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.ResetOnSpawn = false
    
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    getgenv().MainUI_Library = g
    
---------
local AuraGlow = Instance.new("ImageLabel", g)
AuraGlow.Name = "AuraGlow"
AuraGlow.BackgroundTransparency = 1
AuraGlow.Image = "rbxassetid://5028857084"
AuraGlow.ImageTransparency = 0.4
AuraGlow.ImageColor3 = Color3.fromHex("#E0E0E0")
AuraGlow.ZIndex = 0
AuraGlow.AnchorPoint = Vector2.new(0.5, 0.5)

Instance.new("UICorner", AuraGlow).CornerRadius = UDim.new(0, 15)

local auraScale = Instance.new("UIScale", AuraGlow)

local m = Instance.new("Frame", g)
m.Name = "MainFrame"
m.BackgroundColor3 = Themes[CurrentTheme].MainBg
m.BackgroundTransparency = Themes[CurrentTheme].MainBgTrans
m.Size = UDim2.new(0, 600, 0, 525) -- Updated Ratio 400:350
m.Position = UDim2.new(0.5, 0, 0.5, 0)
m.AnchorPoint = Vector2.new(0.5, 0.5)
m.ClipsDescendants = true
Instance.new("UICorner", m).CornerRadius = UDim.new(0, 15)

local function UpdateAura()
    local targetWidth = m.Size.X.Scale == 1 and 600 or m.Size.X.Offset
    local factor = math.clamp(targetWidth / 600, 0, 1)
    
    local expandX = 105 * factor 
    local expandY = 95 * factor 

    AuraGlow.Position = m.Position
    AuraGlow.Size = UDim2.new(m.Size.X.Scale, m.Size.X.Offset + expandX, m.Size.Y.Scale, m.Size.Y.Offset + expandY)
    AuraGlow.Visible = m.Visible
end
m:GetPropertyChangedSignal("Position"):Connect(UpdateAura)
m:GetPropertyChangedSignal("Size"):Connect(UpdateAura)
m:GetPropertyChangedSignal("Visible"):Connect(UpdateAura)
UpdateAura()
---------
    ---------
local isMini = false
    local isMax = false

    local mainScale = Instance.new("UIScale", m)
    mainScale.Scale = 1
    
    mainScale:GetPropertyChangedSignal("Scale"):Connect(function()
        if g:FindFirstChild("AuraGlow") and g.AuraGlow:FindFirstChildOfClass("UIScale") then
            g.AuraGlow:FindFirstChildOfClass("UIScale").Scale = mainScale.Scale
        end
    end)
    
    local function UpdateUIScale()
        if not g then return end
        
        if m.Size.X.Scale == 1 and m.Size.Y.Scale == 1 then 
            TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
            return 
        end
        
        local screenSize = g.AbsoluteSize
        if screenSize.X > 0 and screenSize.Y > 0 then
            local targetScale = math.clamp(math.min(screenSize.X / 650, screenSize.Y / 600), 0.45, 1)
            TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = targetScale}):Play()
        end
    end
    
    UpdateUIScale()
    g:GetPropertyChangedSignal("AbsoluteSize"):Connect(UpdateUIScale)
    m:GetPropertyChangedSignal("Size"):Connect(UpdateUIScale)
---------


    local EdgeBarHitbox = Instance.new("TextButton", g)
    EdgeBarHitbox.Name = "EdgeBarHitbox"
    EdgeBarHitbox.Size = UDim2.new(0, 30, 0, 140) 
    EdgeBarHitbox.Position = UDim2.new(1, 0, 0.5, 0)
    EdgeBarHitbox.AnchorPoint = Vector2.new(1, 0.5)
    EdgeBarHitbox.BackgroundTransparency = 1 
    EdgeBarHitbox.Visible = false
    EdgeBarHitbox.Text = ""

    local EdgeBarVisual = Instance.new("Frame", EdgeBarHitbox)
    EdgeBarVisual.Size = UDim2.new(0, 4, 0, 120) 
    EdgeBarVisual.Position = UDim2.new(1, -2, 0.5, 0)
    EdgeBarVisual.AnchorPoint = Vector2.new(1, 0.5)
    EdgeBarVisual.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    EdgeBarVisual.BackgroundTransparency = 0.8
    Instance.new("UICorner", EdgeBarVisual).CornerRadius = UDim.new(1, 0)

    local Mini3DIcon = Instance.new("Frame", g)
    Mini3DIcon.Name = "Mini3DIcon"
    Mini3DIcon.Size = UDim2.new(0, 140, 0, 140)
    Mini3DIcon.Position = UDim2.new(1, 150, 0.5, 0)
    Mini3DIcon.AnchorPoint = Vector2.new(1, 0.5)
    Mini3DIcon.BackgroundTransparency = 1
    Mini3DIcon.Visible = false

    local coreLayers = {}
    local baseSizes = {30, 45, 62, 78, 95, 112}    
    local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
    for i = 1, #baseSizes do
        local layer = Instance.new("Frame")
        layer.AnchorPoint = Vector2.new(0.5, 0.5)
        layer.Position = UDim2.new(0.5, 0, 0.5, 0)
        layer.BorderSizePixel = 0
        layer.ZIndex = 3
        Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
        layer.Parent = Mini3DIcon
        table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
    end
    
    local phi = (1 + math.sqrt(5)) / 2
    local vertices = {
        Vector3.new(0, 1, phi), Vector3.new(0, -1, phi),
        Vector3.new(0, 1, -phi), Vector3.new(0, -1, -phi),
        Vector3.new(1, phi, 0), Vector3.new(-1, phi, 0),
        Vector3.new(1, -phi, 0), Vector3.new(-1, -phi, 0),
        Vector3.new(phi, 0, 1), Vector3.new(-phi, 0, 1),
        Vector3.new(phi, 0, -1), Vector3.new(-phi, 0, -1)
    }
    local edges = {}
    for i = 1, #vertices - 1 do
        for j = i + 1, #vertices do
            if math.abs((vertices[i] - vertices[j]).Magnitude - 2) < 0.1 then
                table.insert(edges, {i, j})
            end
        end
    end
    
    local lines, lineGradients = {}, {}
    for i = 1, #edges do
        local line = Instance.new("Frame")
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        line.BorderSizePixel = 0
        line.ZIndex = 3
        local lineGrad = Instance.new("UIGradient", line)
        table.insert(lineGradients, lineGrad)
        local glow = Instance.new("UIStroke", line)
        glow.Thickness = 2
        glow.Transparency = 0.4
        glow.Color = Color3.fromHex("#FFFFFF")
        local glowGrad = Instance.new("UIGradient", glow)
        table.insert(lineGradients, glowGrad)
        line.Parent = Mini3DIcon
        lines[i] = line
    end

  local MiniClickBtn = Instance.new("TextButton", Mini3DIcon)
    MiniClickBtn.Size = UDim2.new(1, 0, 1, 0)
    MiniClickBtn.BackgroundTransparency = 1
    MiniClickBtn.Text = ""
    MiniClickBtn.ZIndex = 10

    local angleX, angleY, r3D = 0, 0, 0
    local currentTiltX, currentTiltY = 0, 0
    local scale3D, perspective3D = 45, 150
    local function project3D(v3, aX, aY)
        local x, y, z = v3.X, v3.Y, v3.Z
        local cosY, sinY = math.cos(aY), math.sin(aY)
        x, z = x * cosY - z * sinY, x * sinY + z * cosY
        local cosX, sinX = math.cos(aX), math.sin(aX)
        y, z = y * cosX - z * sinX, y * sinX + z * cosX
        local factor = perspective3D / (perspective3D + z)
        return Vector2.new(x * factor * scale3D + 70, -y * factor * scale3D + 70), z
    end

    local clickCount = 0
    EdgeBarHitbox.MouseButton1Click:Connect(function()
        clickCount = clickCount + 1
        if clickCount == 1 then
            TweenService:Create(EdgeBarVisual, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, Size = UDim2.new(0, 6, 0, 140)}):Play()
            task.delay(0.6, function() 
                if clickCount == 1 then
                    clickCount = 0 
                    TweenService:Create(EdgeBarVisual, TweenInfo.new(0.2), {BackgroundTransparency = 0.8, Size = UDim2.new(0, 4, 0, 120)}):Play()
                end
            end)
        elseif clickCount == 2 then
            clickCount = 0
            EdgeBarHitbox.Visible = false
            Mini3DIcon.Visible = true
            TweenService:Create(Mini3DIcon, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)}):Play()
        end
    end)


    ---------
    MiniClickBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(Mini3DIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(1, 150, 0.5, 0)})
        tw:Play()
        tw.Completed:Wait()
        Mini3DIcon.Visible = false
        
        local tgIcon = g:FindFirstChild("ToggleIcon")
        if tgIcon then tgIcon.Visible = true end
        
        m.Visible = true
        m.Size = UDim2.new(0, 0, 0, 0)
        m.Position = UDim2.new(1, 0, 0.5, 0)
        local targetSize = isMax and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 600, 0, 525)
        TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = targetSize,
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        isMini = false
    end)
---------

-------------------------
    local SnowContainer = Instance.new("Frame", m)
    SnowContainer.Name = "SnowContainer"
    SnowContainer.Size = UDim2.new(1, -40, 1, -40)
    SnowContainer.Position = UDim2.new(0, 20, 0, 20)
    SnowContainer.BackgroundTransparency = 1
    SnowContainer.ZIndex = 0
    SnowContainer.ClipsDescendants = true
    Instance.new("UICorner", SnowContainer).CornerRadius = UDim.new(0, 15)
    
    task.spawn(function()
        while task.wait(0.15) do
            if not m.Visible or isMini then continue end
            local flake = Instance.new("ImageLabel", SnowContainer)
            flake.BackgroundTransparency = 1
            local iconId = "137906289429512"
            if CurrentTheme == "Dream" then iconId = "88081350809596"
            elseif CurrentTheme == "Dark" then iconId = "97956199432234" end
            
            flake.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
            
            local depth = math.random()
            
            local size = 13 + (7 * depth)
            flake.Size = UDim2.new(0, size, 0, size)
            
            flake.ImageTransparency = 0.8 - (0.6 * depth)
            flake.ZIndex = math.floor(depth * 3)
            
            local startX = math.random()
            flake.Position = UDim2.new(startX, 0, -0.1, 0)
            
            local fallDuration = 9 - (5 * depth)
            local swaySpeed = 1.2 + math.random()
            local swayAmount = 0.03 + (0.07 * depth)
            local randomOffset = math.random() * math.pi * 2
            local rotSpeed = 30 + (90 * depth)
            local rotDir = math.random(1, 2) == 1 and 1 or -1
            
            local startTime = tick()
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not flake or not flake.Parent then
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                local elapsed = tick() - startTime
                local progress = elapsed / fallDuration
                
                if progress >= 1 then
                    flake:Destroy()
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                local currentY = -0.1 + (1.2 * progress)
                local currentX = startX + math.sin(tick() * swaySpeed + randomOffset) * swayAmount
                
                flake.Position = UDim2.new(currentX, 0, currentY, 0)
                flake.Rotation = elapsed * rotSpeed * rotDir
            end)
        end
    end)
-------------------------
   ---------
local ToggleIcon = Instance.new("ImageButton", g)
ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
ToggleIcon.Position = UDim2.new(0, 20, 1, -65)
ToggleIcon.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
ToggleIcon.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
Instance.new("UICorner", ToggleIcon).CornerRadius = UDim.new(1, 0)

local rawIconId = "77000372466296"
local idClean = string.match(rawIconId, "%d+")
if idClean then
    ToggleIcon.Image = "rbxthumb://type=Asset&id=" .. idClean .. "&w=150&h=150"
else
    ToggleIcon.Image = rawIconId
end
ToggleIcon.ImageColor3 = Themes[CurrentTheme].TextColor

local iconStroke = Instance.new("UIStroke", ToggleIcon)
iconStroke.Thickness = 1.5
iconStroke.Color = Themes[CurrentTheme].MainStroke
table.insert(UI_Elements.AnimatedStrokes, {Obj = iconStroke, Type = "MainStroke"})

local iconStrokeGrad = Instance.new("UIGradient", iconStroke)
table.insert(UI_Elements.RotatingGradients, iconStrokeGrad)

local iconGrad = Instance.new("UIGradient", ToggleIcon)
iconGrad.Rotation = 45
iconGrad.Color = Themes[CurrentTheme].TextContrast

task.spawn(function()
    while task.wait(0.5) do
        if not ToggleIcon.Parent then break end
        if Themes[CurrentTheme] then
            ToggleIcon.ImageColor3 = Themes[CurrentTheme].TextColor
            ToggleIcon.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            ToggleIcon.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            iconGrad.Color = Themes[CurrentTheme].TextContrast
        end
    end
end)

local toggleScale = Instance.new("UIScale", ToggleIcon)
toggleScale.Scale = 1

local function CreateBubbleEffect(centerPos)
local pColor = Themes[CurrentTheme] and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")

for i = 1, 14 do
    task.delay(math.random(0, 10)/100, function()
        if not ToggleIcon or not ToggleIcon.Parent then return end
        
        local toggleRadius = ToggleIcon.AbsoluteSize.X / 2 
        local angle = math.rad(math.random(0, 360))
        
        local startX = centerPos.X + math.cos(angle) * toggleRadius
        local startY = centerPos.Y + math.sin(angle) * toggleRadius
        
        local particle = Instance.new("Frame", ToggleIcon.Parent)
        particle.Size = UDim2.new(0, 10, 0, 10)
        particle.AnchorPoint = Vector2.new(0.5, 0.5)
        particle.Position = UDim2.new(0, startX, 0, startY)
        particle.BackgroundColor3 = pColor
        particle.ZIndex = 50
        
        Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
        
        local distance = math.random(15, 35)
        local targetX = startX + math.cos(angle) * distance
        local targetY = startY + math.sin(angle) * distance
        
        local pTween = TweenService:Create(particle, TweenInfo.new(math.random(3, 5)/10, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, targetX, 0, targetY),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1
        })
        pTween:Play()
        pTween.Completed:Connect(function() particle:Destroy() end)
    end)
end
end

local function PlayJellyBounce()
local tUp = TweenService:Create(toggleScale, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1})
tUp:Play()
CreateBubbleEffect(ToggleIcon.AbsolutePosition + (ToggleIcon.AbsoluteSize / 2))
end

local toggleDragging = false
local toggleDragStart, toggleStartPos, toggleMoved

ToggleIcon.InputBegan:Connect(function(input)
if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
toggleDragging = true
toggleMoved = false
toggleDragStart = input.Position
toggleStartPos = ToggleIcon.Position

    TweenService:Create(toggleScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.85}):Play()
end
end)

UserInputService.InputChanged:Connect(function(input)
if toggleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - toggleDragStart
if delta.Magnitude > 5 then
toggleMoved = true
end
ToggleIcon.Position = UDim2.new(toggleStartPos.X.Scale, toggleStartPos.X.Offset + delta.X, toggleStartPos.Y.Scale, toggleStartPos.Y.Offset + delta.Y)
end
end)
---------
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if toggleDragging then
            toggleDragging = false
            
            if toggleMoved then
                local parentSize = ToggleIcon.Parent and ToggleIcon.Parent.AbsoluteSize or workspace.CurrentCamera.ViewportSize
                local tSize = ToggleIcon.AbsoluteSize
                local tPos = ToggleIcon.AbsolutePosition
                
                local left = tPos.X
                local right = parentSize.X - (tPos.X + tSize.X)
                local top = tPos.Y
                local bottom = parentSize.Y - (tPos.Y + tSize.Y)
                
                local min = math.min(left, right, top, bottom)
                local sinkAmount = tSize.X * 0.35
                local restMargin = 2 
                local bottomMargin = 12 
                
                local sinkUDim, targetUDim
                
                if min == left then
                    sinkUDim = UDim2.new(0, -sinkAmount, 0, tPos.Y)
                    targetUDim = UDim2.new(0, restMargin, 0, tPos.Y)
                elseif min == right then
                    sinkUDim = UDim2.new(0, parentSize.X - tSize.X + sinkAmount, 0, tPos.Y)
                    targetUDim = UDim2.new(0, parentSize.X - tSize.X - restMargin, 0, tPos.Y)
                elseif min == top then
                    sinkUDim = UDim2.new(0, tPos.X, 0, -sinkAmount)
                    targetUDim = UDim2.new(0, tPos.X, 0, restMargin)
                else
                    sinkUDim = UDim2.new(0, tPos.X, 0, parentSize.Y - tSize.Y + sinkAmount)
                    targetUDim = UDim2.new(0, tPos.X, 0, parentSize.Y - tSize.Y - bottomMargin)
                end
                
                local sinkTween = TweenService:Create(ToggleIcon, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = sinkUDim})
                sinkTween:Play()
                
                sinkTween.Completed:Connect(function()
                    TweenService:Create(ToggleIcon, TweenInfo.new(0.35, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = targetUDim}):Play()
                    PlayJellyBounce()
                end)
            else
                PlayJellyBounce()
            end
        end
    end
end)

ToggleIcon.MouseButton1Click:Connect(function()
    if toggleMoved then return end
    if not m then return end
    if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
        TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        m.Visible = false
    else
        m.Visible = true
        local targetSize = isMini and UDim2.new(0, 600, 0, 525) or (isMax and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 600, 0, 525))
        local targetPos = isMini and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
        TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
    end
end)
---------
    ---------
    ToggleIcon.MouseButton1Click:Connect(function()
        if not m then return end
        if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
            TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            m.Visible = false
        else
            m.Visible = true
            local targetSize = isMini and UDim2.new(0, 600, 0, 525) or (isMax and UDim2.new(1, 0, 1, 0) or UDim2.new(0, 600, 0, 525))
            local targetPos = isMini and UDim2.new(0.5, 0, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = targetSize, Position = targetPos}):Play()
        end
    end)
    ---------
    
    local u = Instance.new("UIStroke", m)
    u.Thickness = 4.5
    u.Color = Themes[CurrentTheme].MainStroke
    table.insert(UI_Elements.AnimatedStrokes, {Obj = u, Type = "MainStroke"})
    
    local e = Instance.new("UIGradient", u)
    table.insert(UI_Elements.RotatingGradients, e)
    
    local titleBar = Instance.new("Frame", m)
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 55)
    titleBar.BackgroundTransparency = 1
    titleBar.ZIndex = 2
    
    local hubTitle = Instance.new("TextLabel", titleBar)
    hubTitle.Size = UDim2.new(0, 300, 1, 0)
    hubTitle.Position = UDim2.new(0, 20, 0, 0)
    hubTitle.BackgroundTransparency = 1
    hubTitle.Font = Enum.Font.GothamBold
    hubTitle.Text = windowTitle
    -------------------------
    ApplyTextGradient(hubTitle)
    -------------------------
    hubTitle.TextSize = 15
    hubTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local function CreateWinBtn(text, pos)
        local btn = Instance.new("TextButton", titleBar)
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = UDim2.new(1, pos, 0.5, 0)
        btn.AnchorPoint = Vector2.new(0, 0.5)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        -------------------------
        ApplyTextGradient(btn)
        -------------------------
        btn.TextSize = 16
        return btn
    end
    
    local minBtn = CreateWinBtn("~", -105)
    local maxBtn = CreateWinBtn("⬚", -70)
    local closeBtn = CreateWinBtn("x", -35)


    minBtn.MouseButton1Click:Connect(function()
        if not isMini then
            isMini = true
            
            local tgIcon = g:FindFirstChild("ToggleIcon")
            if tgIcon then tgIcon.Visible = false end
            
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.delay(0.5, function()
                if isMini then
                    m.Visible = false
                    EdgeBarHitbox.Visible = true
                    EdgeBarVisual.BackgroundTransparency = 0.8
                    EdgeBarVisual.Size = UDim2.new(0, 4, 0, 120)
                end
            end)
        end
    end)
---------

    
    maxBtn.MouseButton1Click:Connect(function()
        if not isMax then
            isMax = true; isMini = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            if m:FindFirstChild("Sidebar") then m.Sidebar.Visible = true end
            if m:FindFirstChild("LeftDivider") then m.LeftDivider.Visible = true end
            if m:FindFirstChild("TopDivider") then m.TopDivider.Visible = true end
            if m:FindFirstChild("Sidebar") then
                for _, btn in pairs(m.Sidebar:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("ActiveBg") and btn.ActiveBg.BackgroundTransparency < 1 then
                        local pageName = btn.Text:gsub("%s+", "") .. "Page"
                        if m:FindFirstChild(pageName) then m[pageName].Visible = true end
                    end
                end
            end
        else
            isMax = false
            TweenService:Create(m, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 525), -- Updated
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end
    end)
    ---------
    
    closeBtn.MouseButton1Click:Connect(function()
        if m.Size.X.Offset > 0 or m.Size.X.Scale > 0 then
            TweenService:Create(m, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(1, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            m.Visible = false
        end
    end)
    
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = m.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            m.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local TopDivider = Instance.new("Frame", m)
    TopDivider.Name = "TopDivider"
    TopDivider.Size = UDim2.new(1, -40, 0, 1)
    TopDivider.Position = UDim2.new(0, 20, 0, 55)
    TopDivider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    TopDivider.BorderSizePixel = 0
    TopDivider.ZIndex = 3
    
    local topDivGrad = Instance.new("UIGradient", TopDivider)
    topDivGrad.Color = Themes[CurrentTheme].DivGrad
    topDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    table.insert(UI_Elements.DivGradients, topDivGrad)
    
    ---------
    local LeftDivider = Instance.new("Frame", m)
    LeftDivider.Name = "LeftDivider"
    LeftDivider.Size = UDim2.new(0, 1, 1, -80)
    LeftDivider.Position = UDim2.new(0, 175, 0, 65) -- Adjusted for UI Ratio
    LeftDivider.BackgroundColor3 = Color3.fromHex("#FFFFFF")
    LeftDivider.BorderSizePixel = 0
    LeftDivider.ZIndex = 3
    
    local leftDivGrad = Instance.new("UIGradient", LeftDivider)
    leftDivGrad.Rotation = 90
    leftDivGrad.Color = Themes[CurrentTheme].DivGrad
    leftDivGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 1)
    })
    table.insert(UI_Elements.DivGradients, leftDivGrad)
        local Sidebar = Instance.new("ScrollingFrame", m)
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 170, 1, -65) -- Adjusted width for 600 UI
    Sidebar.Position = UDim2.new(0, 5, 0, 60)
    Sidebar.BackgroundTransparency = 1
    Sidebar.BorderSizePixel = 0
    Sidebar.ScrollBarThickness = 0
    Sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Sidebar.ZIndex = 2
    
    local sideLayout = Instance.new("UIListLayout", Sidebar)
    sideLayout.Padding = UDim.new(0, 5)
    sideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sideLayout.SortOrder = Enum.SortOrder.LayoutOrder -- Ensure layout order respects Logo & Search

    -- Sidebar Logo Area
    local LogoFrame = Instance.new("Frame", Sidebar)
    LogoFrame.Name = "LogoArea"
    LogoFrame.BackgroundTransparency = 1
    LogoFrame.LayoutOrder = 1
    
    LogoFrame.Size = UDim2.new(1, -10, 0, 120)
    local logoIcon = Instance.new("ImageLabel", LogoFrame)
    logoIcon.Size = UDim2.new(1, 0, 1, 0)
    logoIcon.BackgroundTransparency = 1
    logoIcon.ScaleType = Enum.ScaleType.Fit
    
    task.spawn(function()
        while task.wait(0.5) do
            if not LogoFrame.Parent then break end
            local iconId = "121203350952750"
            if CurrentTheme == "Dream" then 
                iconId = "90308084903285"
            elseif CurrentTheme == "Ocean" then 
                iconId = "103281926053314" 
            end
            logoIcon.Image = "rbxthumb://type=Asset&id=" .. iconId .. "&w=150&h=150"
        end
    end)

   -- Sidebar Search Area
    local SearchFrame = Instance.new("Frame", Sidebar)
    SearchFrame.Name = "SearchArea"
    SearchFrame.Size = UDim2.new(1, -20, 0, 32)
    SearchFrame.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
    SearchFrame.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
    SearchFrame.LayoutOrder = 2
    table.insert(UI_Elements.Containers, SearchFrame)
    Instance.new("UICorner", SearchFrame).CornerRadius = UDim.new(0, 6)

    local SearchIconDisplay = Instance.new("ImageLabel", SearchFrame)
    SearchIconDisplay.Size = UDim2.new(0, 25, 0, 25)
SearchIconDisplay.AnchorPoint = Vector2.new(1, 0.5)
    SearchIconDisplay.Position = UDim2.new(1, -10, 0.5, 0)
    SearchIconDisplay.BackgroundTransparency = 1
    SearchIconDisplay.Image = "rbxthumb://type=Asset&id=111352610696552&w=150&h=150"
    
 if Themes[CurrentTheme] and Themes[CurrentTheme].SearchIconColor then
        SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].SearchIconColor
    else
        SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].TextColor
    end
    
    -- Vòng lặp kiểm tra để tự động thay đổi màu khi ann chọn theme khác nhó~
    task.spawn(function()
        while task.wait(0.5) do
            if not SearchIconDisplay.Parent then break end
            if Themes[CurrentTheme] then
                if Themes[CurrentTheme].SearchIconColor then
                    SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].SearchIconColor
                else
                    SearchIconDisplay.ImageColor3 = Themes[CurrentTheme].TextColor
                end
            end
        end
    end)


    local SearchBox = Instance.new("TextBox", SearchFrame)
    SearchBox.Size = UDim2.new(1, -30, 1, 0)
    SearchBox.Position = UDim2.new(0, 26, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Font = Enum.Font.GothamBold
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search Tab..."
    SearchBox.TextSize = 12
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    ApplyTextGradient(SearchBox)
    ---------
    
    local TabsList = {}
    local PagesList = {}
    
    ---------
    -- Handle Search Filter
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = string.lower(SearchBox.Text)
        for _, tabData in ipairs(TabsList) do
            if searchText == "" or string.find(string.lower(tabData.Name), searchText) then
                tabData.Btn.Visible = true
            else
                tabData.Btn.Visible = false
            end
        end
    end)
    ---------

    -- [[ TAB SYSTEM ]] --
    function Window:CreateTab(name, isFirstPage, tabIconId)
        local Tab = {}
        local currentTitle = ""
        local currentSubTitle = ""

        local function GetSecureFlag(elementText, customFlag)
            -- Lớp 1: Đường dẫn cơ bản
            local t = currentTitle ~= "" and currentTitle or "NoTitle"
            local st = currentSubTitle ~= "" and currentSubTitle or "NoSub"
            local basePath = name .. "_" .. t .. "_" .. st .. "_" .. elementText

            -- Lớp 2: Gán Flag thủ công
            if customFlag then
                basePath = basePath .. "_" .. customFlag
            end

            -- Lớp 4: Khóa đường dẫn Namespace
            local namespace = "[" .. name .. "][" .. t .. "][" .. st .. "]"
            local finalFlag = namespace .. "_" .. basePath

            -- Lớp 3: Mã UUID chữa cháy nếu vẫn trùng
            if Library.ConfigElements[finalFlag] then
                finalFlag = finalFlag .. "_" .. HttpService:GenerateGUID(false)
            end

            return finalFlag
        end

        local btn = Instance.new("TextButton", Sidebar)
        btn.Size = UDim2.new(1, -20, 0, 38)
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamBold
        btn.Text = ""
        btn.LayoutOrder = 3 + #TabsList -- Tab order goes below Logo & Search
        
        ---------
        -- Elegant Tab Background Indicator
        local activeBg = Instance.new("Frame", btn)
        activeBg.Name = "ActiveBg"
        activeBg.Size = UDim2.new(1, 0, 1, 0)
        activeBg.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        activeBg.BackgroundTransparency = isFirstPage and 0.8 or 1
        Instance.new("UICorner", activeBg).CornerRadius = UDim.new(0, 8)
        table.insert(UI_Elements.TabBackgrounds, activeBg)
        
        local activeGlow = Instance.new("Frame", activeBg)
        activeGlow.Size = UDim2.new(0, 4, 1, -10)
        activeGlow.Position = UDim2.new(0, 4, 0.5, 0)
        activeGlow.AnchorPoint = Vector2.new(0, 0.5)
        activeGlow.BackgroundColor3 = Color3.fromHex("#FFFFFF")
        activeGlow.BackgroundTransparency = isFirstPage and 0 or 1
        activeGlow.BorderSizePixel = 0
        Instance.new("UICorner", activeGlow).CornerRadius = UDim.new(1, 0)
        
        local glowGrad = Instance.new("UIGradient", activeGlow)
        glowGrad.Rotation = 90
        glowGrad.Color = Themes[CurrentTheme].DivGrad
        glowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.15, 0.5),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.85, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        })
        table.insert(UI_Elements.DivGradients, glowGrad)
        ---------
        
        local btnText = Instance.new("TextLabel", btn)
        btnText.Size = UDim2.new(1, -25, 1, 0)
        btnText.Position = UDim2.new(0, 18, 0, 0)
        btnText.BackgroundTransparency = 1
        btnText.Font = Enum.Font.GothamBold
        btnText.Text = name
        -------------------------
        ApplyTextGradient(btnText)
        -------------------------
        btnText.TextSize = 13 -- Slightly scaled down for new UI ratio
        btnText.TextXAlignment = Enum.TextXAlignment.Left

      ---------
        if tabIconId and tabIconId ~= "" then
            local iconDisplay = Instance.new("ImageLabel", btn)
            iconDisplay.Size = UDim2.new(0, 18, 0, 18)
            iconDisplay.Position = UDim2.new(0, 14, 0.5, 0)
            iconDisplay.AnchorPoint = Vector2.new(0, 0.5)
            iconDisplay.BackgroundTransparency = 1
            
            local idClean = string.match(tabIconId, "%d+")
            if idClean then
                iconDisplay.Image = "rbxthumb://type=Asset&id=" .. idClean .. "&w=150&h=150"
            else
                iconDisplay.Image = tabIconId
            end

            iconDisplay.ImageColor3 = Themes[CurrentTheme].TextColor
            
            local iconGrad = Instance.new("UIGradient", iconDisplay)
            iconGrad.Rotation = 90
            iconGrad.Color = Themes[CurrentTheme].TextContrast
            table.insert(UI_Elements.TextGradients, iconGrad)
            
            table.insert(UI_Elements.TabIcons, iconDisplay)
            
            btnText.Position = UDim2.new(0, 39, 0, 0)
            btnText.Size = UDim2.new(1, -40, 1, 0)
        end
        
        table.insert(TabsList, {Btn = btn, Bg = activeBg, Glow = activeGlow, Name = name})
---------
        
        local page = Instance.new("ScrollingFrame", m)
        page.Name = name .. "Page"
        ---------
        page.Size = UDim2.new(1, -190, 1, -85) -- Adjusted for 600 width
        page.Position = UDim2.new(0, 180, 0, 70)
        ---------
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 0
        page.ZIndex = 2
        page.Visible = isFirstPage
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local pagePadding = Instance.new("UIPadding", page)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 20)
        pagePadding.PaddingTop = UDim.new(0, 5)
        
        local contentLayout = Instance.new("UIListLayout", page)
        contentLayout.Padding = UDim.new(0, 8)
        table.insert(PagesList, page)
        
---------
        -- Smooth Tab Transition with Light Beam Effect
        btn.MouseButton1Click:Connect(function()
            if page.Visible then return end

            local beam = Instance.new("Frame")
            beam.Name = "LightBeamEffect"
            beam.Size = UDim2.new(0, 250, 1, 0)
            beam.Position = UDim2.new(0, -250, 0, 0)
            beam.BackgroundColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#FFFFFF")
            beam.BorderSizePixel = 0
            beam.ZIndex = 50 
            beam.Parent = m

            local beamGrad = Instance.new("UIGradient", beam)
            beamGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.4, 0.5),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(0.6, 0.5),
                NumberSequenceKeypoint.new(1, 1)
            })
            beamGrad.Rotation = 15 

            local sweepTween = TweenService:Create(beam, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Position = UDim2.new(1, m.AbsoluteSize.X + 100, 0, 0)
            })
            sweepTween:Play()
            
            local flashTween = TweenService:Create(beamGrad, TweenInfo.new(0.08, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut, -1, true), {
                Offset = Vector2.new(0, 0.3)
            })
            flashTween:Play()

            task.delay(0.22, function()
                for _, p in pairs(PagesList) do 
                    if p.Visible then
                        TweenService:Create(p, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {ScrollBarImageTransparency = 1}):Play()
                        p.Visible = false 
                    end
                end
                for _, t in pairs(TabsList) do 
                    TweenService:Create(t.Bg, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
                    TweenService:Create(t.Glow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
                end
                
                page.Position = UDim2.new(0, 180, 0, 100) 
                page.ScrollBarImageTransparency = 1
                page.Visible = true
                
                TweenService:Create(page, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 180, 0, 70),
                    ScrollBarImageTransparency = 0
                }):Play()
                
                TweenService:Create(activeBg, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.8}):Play()
                TweenService:Create(activeGlow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                
            end)

            sweepTween.Completed:Connect(function()
                flashTween:Cancel()
                beam:Destroy()
            end)
        end)
        ---------

        function Tab:CreatePageTitle(text)
            currentTitle = text
            currentSubTitle = ""
            local titleWrapper = Instance.new("Frame", page)
            titleWrapper.Size = UDim2.new(1, 0, 0, 45)
            titleWrapper.BackgroundTransparency = 1
            
            local title = Instance.new("TextLabel", titleWrapper)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            -------------------------
            ApplyTextGradient(title)
            -------------------------
            title.TextSize = 26
            title.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        function Tab:CreatePageSubTitle(text)
            currentSubTitle = text
            local titleWrapper = Instance.new("Frame", page)
            titleWrapper.Size = UDim2.new(1, 0, 0, 35)
            titleWrapper.BackgroundTransparency = 1
            
            local title = Instance.new("TextLabel", titleWrapper)
            title.Size = UDim2.new(1, 0, 1, 0)
            title.Position = UDim2.new(0, 10, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            -------------------------
            ApplyTextGradient(title)
            -------------------------
            title.TextSize = 20
            title.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        ---------
     ---------
        function Tab:CreateDropdown(text, default, optionsList, desc, callback, flag)
            local Dropdown = {}
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local containerHeight = (desc and desc ~= "") and 62 or 46

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.Position = UDim2.new(0, 2, 0, 0)
            container.BackgroundTransparency = 1
            container.ClipsDescendants = false
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.Position = UDim2.new(0, 0, 0, 2)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.5, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -150, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end

            local dropBtn = Instance.new("TextButton", row)
            dropBtn.Size = UDim2.new(0, 130, 0, 30)
            dropBtn.Position = UDim2.new(1, -145, 0, 6)
            dropBtn.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            dropBtn.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, dropBtn)
            dropBtn.Text = default
            dropBtn.Font = Enum.Font.GothamBold
            ApplyTextGradient(dropBtn)
            dropBtn.TextSize = 12.5
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
            
            local arrow = Instance.new("TextLabel", dropBtn)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "​​≡"
            ApplyTextGradient(arrow)
            arrow.TextSize = 10
            
            local dropList = Instance.new("ScrollingFrame", container)
            dropList.Size = UDim2.new(1, 0, 1, -containerHeight - 2)
            dropList.Position = UDim2.new(0, 0, 0, containerHeight + 2)
            dropList.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            dropList.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            table.insert(UI_Elements.Containers, dropList)
            dropList.BorderSizePixel = 0
            dropList.ScrollBarThickness = 2
            dropList.Visible = false
            dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
            dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
            Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)
            
            local listLayout = Instance.new("UIListLayout", dropList)
            listLayout.Padding = UDim.new(0, 5)
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local dropListStroke = Instance.new("UIStroke", dropList)
            dropListStroke.Color = Themes[CurrentTheme].RowStroke
            dropListStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, dropListStroke)
            
            local dropListGrad = Instance.new("UIGradient", dropListStroke)
            dropListGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, dropListGrad)
            table.insert(UI_Elements.AnimatedGradients, dropListGrad)

            local flagId = GetSecureFlag(text, flag)
            local function SetValue(val)
                dropBtn.Text = val
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetValue }
            
            local isDropped = false

            local function RenderOptions(list)
                for _, child in pairs(dropList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end

                for _, opt in pairs(list) do
                    local dummyBtn = Instance.new("TextButton", dropList)
                    dummyBtn.Size = UDim2.new(1, -10, 0, 30)
                    dummyBtn.BackgroundTransparency = 1
                    dummyBtn.Text = opt
                    dummyBtn.Font = Enum.Font.GothamBold
                    ApplyTextGradient(dummyBtn)
                    dummyBtn.TextSize = 12
                    
                    dummyBtn.MouseButton1Click:Connect(function()
                        isDropped = false
                        
                        local tweenConn
                        local closeTween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, containerHeight)})
                        closeTween:Play()
                        
                        TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        
                        tweenConn = closeTween.Completed:Connect(function()
                            if not isDropped then
                                dropList.Visible = false
                            end
                            tweenConn:Disconnect()
                        end)

                        SetValue(opt)
                    end)
                end
            end

            RenderOptions(optionsList)
            
            dropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local targetHeight = isDropped and 165 or containerHeight
                
                if isDropped then
                    dropList.Visible = true
                    task.spawn(function()
                        while isDropped and container and container.Parent do
                            if container.AbsoluteSize.Y < targetHeight - 2 or container.AbsoluteSize.X < 20 then
                                dropList.Visible = true
                                task.wait(0.05)
                            else
                                break
                            end
                        end
                        if isDropped then
                            dropList.Visible = true
                        end
                    end)
                end
                
                local tween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, targetHeight)})
                tween:Play()
                
                if not isDropped then
                    local tweenConn
                    tweenConn = tween.Completed:Connect(function()
                        if not isDropped then
                            dropList.Visible = false
                        end
                        tweenConn:Disconnect()
                    end)
                end    
                
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
            end)

            function Dropdown:Refresh(newList, newDefault)
                RenderOptions(newList)
                if newDefault then
                    SetValue(newDefault)
                else
                    local currentVal = Library.ConfigElements[flagId].Value
                    local exists = false
                    for _, opt in pairs(newList) do
                        if opt == currentVal then
                            exists = true
                            break
                        end
                    end
                    if not exists and #newList > 0 then
                        SetValue(newList[1])
                    elseif not exists then
                        SetValue("None")
                    end
                end
            end

            return Dropdown
        end

---------
        function Tab:CreateMultiDropdown(text, defaultSelections, optionsList, desc, callback, flag)
            local MultiDropdown = {}
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local containerHeight = (desc and desc ~= "") and 62 or 46

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.Position = UDim2.new(0, 2, 0, 0)
            container.BackgroundTransparency = 1
            container.ClipsDescendants = false
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.Position = UDim2.new(0, 0, 0, 2)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.5, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -70, 0, 15)
                descLabel.Position = UDim2.new(0, 12, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
            
            local dropBtn = Instance.new("TextButton", row)
            dropBtn.Size = UDim2.new(0, 130, 0, 30)
            dropBtn.Position = UDim2.new(1, -145, 0, 6)
            dropBtn.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            dropBtn.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, dropBtn)
            dropBtn.Font = Enum.Font.GothamBold
            ApplyTextGradient(dropBtn)
            dropBtn.TextSize = 12.5
            dropBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 6)
            
            local arrow = Instance.new("TextLabel", dropBtn)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -25, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "​​≡"
            ApplyTextGradient(arrow)
            arrow.TextSize = 10
            
            local dropList = Instance.new("ScrollingFrame", container)
            dropList.Size = UDim2.new(1, 0, 1, -containerHeight - 2)
            dropList.Position = UDim2.new(0, 0, 0, containerHeight + 2)
            dropList.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            dropList.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            table.insert(UI_Elements.Containers, dropList)
            dropList.BorderSizePixel = 0
            dropList.ScrollBarThickness = 2
            dropList.Visible = false
            dropList.AutomaticCanvasSize = Enum.AutomaticSize.Y
            dropList.CanvasSize = UDim2.new(0, 0, 0, 0)
            Instance.new("UICorner", dropList).CornerRadius = UDim.new(0, 8)
            
            local listLayout = Instance.new("UIListLayout", dropList)
            listLayout.Padding = UDim.new(0, 5)
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local dropListStroke = Instance.new("UIStroke", dropList)
            dropListStroke.Color = Themes[CurrentTheme].RowStroke
            dropListStroke.Thickness = 1.2 
            table.insert(UI_Elements.RowStrokes, dropListStroke)
            
            local dropListGrad = Instance.new("UIGradient", dropListStroke)
            dropListGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, dropListGrad)
            table.insert(UI_Elements.AnimatedGradients, dropListGrad)

            local isDropped = false
            local selectedItems = {}
            optionsList = optionsList or {"Sample Mode 1", "Sample Mode 2"}
            defaultSelections = defaultSelections or {}
            
            for _, v in pairs(defaultSelections) do
                table.insert(selectedItems, v)
            end
            
            local OptionUpdaters = {}
            local flagId = GetSecureFlag(text, flag)

            local function UpdateButtonText()
                if #selectedItems == 0 then
                    dropBtn.Text = "None Selected"
                elseif #selectedItems == 1 then
                    dropBtn.Text = selectedItems[1]
                elseif #selectedItems == 2 then
                    dropBtn.Text = selectedItems[1] .. ", " .. selectedItems[2]
                else
                    dropBtn.Text = "Selected (" .. tostring(#selectedItems) .. ")"
                end
            end
            
            local function SetValue(arr)
                selectedItems = {}
                local saveArr = {}
                for _, v in pairs(arr) do
                    table.insert(selectedItems, v)
                    table.insert(saveArr, v)
                end
                UpdateButtonText()
                for _, updater in pairs(OptionUpdaters) do
                    updater()
                end
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = saveArr
                end
                if callback then callback(selectedItems) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = defaultSelections, Set = SetValue }
            UpdateButtonText()
            
            local function RenderOptions(list)
                for _, child in pairs(dropList:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                OptionUpdaters = {}

                for _, opt in pairs(list) do
                    local dummyBtn = Instance.new("TextButton", dropList)
                    dummyBtn.Size = UDim2.new(1, -10, 0, 30)
                    dummyBtn.BackgroundTransparency = 1
                    dummyBtn.Text = opt
                    dummyBtn.Font = Enum.Font.GothamBold
                    ApplyTextGradient(dummyBtn)
                    dummyBtn.TextSize = 12
                    Instance.new("UICorner", dummyBtn).CornerRadius = UDim.new(0, 6)
                    
                    local isSelected = false
                    local function UpdateVisuals()
                        if isSelected then
                            dummyBtn.BackgroundTransparency = 0.85
                            dummyBtn.BackgroundColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#00BFFF")
                            local textGrad = dummyBtn:FindFirstChildOfClass("UIGradient")
                            if textGrad then textGrad.Enabled = false end
                            dummyBtn.TextColor3 = Color3.fromHex("#FFFFFF")
                        else
                            dummyBtn.BackgroundTransparency = 1
                            local textGrad = dummyBtn:FindFirstChildOfClass("UIGradient")
                            if textGrad then textGrad.Enabled = true end
                            dummyBtn.TextColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].TextColor or Color3.fromHex("#FFFFFF")
                        end
                    end
                    
                    table.insert(OptionUpdaters, function()
                        isSelected = false
                        for _, v in pairs(selectedItems) do
                            if v == opt then isSelected = true break end
                        end
                        UpdateVisuals()
                    end)
                    
                    for _, v in pairs(selectedItems) do
                        if v == opt then isSelected = true break end
                    end
                    UpdateVisuals()
                    
                    dummyBtn.MouseButton1Click:Connect(function()
                        if isSelected then
                            isSelected = false
                            for i, v in ipairs(selectedItems) do
                                if v == opt then table.remove(selectedItems, i) break end
                            end
                        else
                            isSelected = true
                            table.insert(selectedItems, opt)
                        end
                        UpdateVisuals()
                        UpdateButtonText()
                        
                        if Library.ConfigElements[flagId] then
                            local currentSave = {}
                            for _, v in pairs(selectedItems) do table.insert(currentSave, v) end
                            Library.ConfigElements[flagId].Value = currentSave
                        end
                        
                        if callback then callback(selectedItems) end
                        Library:AutoSave()
                    end)
                end
            end
            
            RenderOptions(optionsList)

            dropBtn.MouseButton1Click:Connect(function()
                isDropped = not isDropped
                local targetHeight = isDropped and 165 or containerHeight
                
                if isDropped then
                    dropList.Visible = true
                    task.spawn(function()
                        while isDropped and container and container.Parent do
                            if container.AbsoluteSize.Y < targetHeight - 2 or container.AbsoluteSize.X < 20 then
                                dropList.Visible = true
                                task.wait(0.05)
                            else
                                break
                            end
                        end
                        if isDropped then
                            dropList.Visible = true
                        end
                    end)
                end
                
                local tween = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, targetHeight)})
                tween:Play()
                
                if not isDropped then
                    local tweenConn
                    tweenConn = tween.Completed:Connect(function()
                        if not isDropped then
                            dropList.Visible = false
                        end
                        tweenConn:Disconnect()
                    end)
                end    
                
                TweenService:Create(arrow, TweenInfo.new(0.3), {Rotation = isDropped and 180 or 0}):Play()
            end)

            function MultiDropdown:Refresh(newList, newDefaultSelections)
                if newDefaultSelections then
                    SetValue(newDefaultSelections)
                else
                    local validSelections = {}
                    for _, sel in ipairs(selectedItems) do
                        for _, opt in ipairs(newList) do
                            if sel == opt then
                                table.insert(validSelections, sel)
                                break
                            end
                        end
                    end
                    SetValue(validSelections)
                end
                RenderOptions(newList)
            end
            
            return MultiDropdown
        end
---------
---------

---------
        function Tab:CreateButton(text, desc, callback)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            row.ClipsDescendants = true -- Thêm vào để Liquid Ripple không tràn ra ngoài
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local title = Instance.new("TextLabel", row)
            title.Name = "Title"
            title.Size = UDim2.new(1, -70, 0, 42)
            title.Position = UDim2.new(0, 12, 0, 0)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            ApplyTextGradient(title)
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -70, 0, 15)
                descLabel.Position = UDim2.new(0, 12, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
            
            local btnContainer = Instance.new("TextButton", row)
            btnContainer.Name = "Button"
            btnContainer.Size = UDim2.new(0, 36, 0, 36)
            btnContainer.Position = UDim2.new(1, -10, 0.5, 0)
            btnContainer.AnchorPoint = Vector2.new(1, 0.5)
            btnContainer.BackgroundTransparency = 1
            btnContainer.Text = ""
            btnContainer.ZIndex = 10
            
            local coreContainer = Instance.new("Frame", btnContainer)
            coreContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            coreContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            coreContainer.Size = UDim2.new(1, 0, 1, 0)
            coreContainer.BackgroundTransparency = 1
            
            local uiScale = Instance.new("UIScale", coreContainer)
            uiScale.Scale = 1
            
            local coreLayers = {}
            local baseSizes = {8, 14, 20, 26, 32, 38} 
            local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
            
            for i = 1, #baseSizes do
                local layer = Instance.new("Frame")
                layer.AnchorPoint = Vector2.new(0.5, 0.5)
                layer.Position = UDim2.new(0.5, 0, 0.5, 0)
                layer.BorderSizePixel = 0
                layer.ZIndex = 3
                
                Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
                layer.Parent = coreContainer
                table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
            end
            
            local r = 0
            local isClicked = false
            local clickTime = 0
            
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not btnContainer.Parent then
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                r = (r + 1.5) % 360
                local t = Themes[CurrentTheme]
                
               local c1, c2
                if isClicked then
                    c1 = t.ToggleActive
                    c2 = t.ToggleActive
                else
                    c1 = Color3.fromRGB(150, 150, 150)
                    c2 = Color3.fromRGB(150, 150, 150)
                end
                
                local pulse = (math.sin(tick() * 3) + 1) / 2
                local coreColor = c1:Lerp(c2, math.abs(math.sin((r / 360) * math.pi)))
                
                for _, data in ipairs(coreLayers) do
                    local sizeOffset = pulse * 4
                    local targetSize = data.baseSize + sizeOffset
                    data.frame.Size = UDim2.new(0, targetSize, 0, targetSize)
                    data.frame.BackgroundColor3 = coreColor
                    data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
                end
                
                if isClicked and tick() - clickTime >= 0.5 then
                    isClicked = false
                    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1}):Play()
                end
            end)
            
---------
            local lastMousePos = Vector2.new(0, 0)
            
            btnContainer.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
                    TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
                    
                    -- 3D Glass Press (Chìm và nghiêng nhẹ, CHỈ mờ nền bên trong)
                    TweenService:Create(row, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                        Rotation = -0.5, 
                        BackgroundTransparency = math.clamp(Themes[CurrentTheme].ContainerTrans + 0.15, 0, 1)
                    }):Play()
                end
            end)
            
            btnContainer.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if not isClicked then
                        TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
                    end
                    -- Phục hồi lại nền sau khi nhả chuột
                    TweenService:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Rotation = 0, 
                        BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
                    }):Play()
                end
            end)
---------
            btnContainer.MouseButton1Click:Connect(function()
                isClicked = true
                clickTime = tick()
                TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
                
                -- Liquid Ripple Effect (Neon Glassmorphism)
                local ripple = Instance.new("Frame")
                ripple.Name = "LiquidRipple"
                ripple.Parent = row
                ripple.BackgroundColor3 = Themes[CurrentTheme].ToggleActive
                ripple.BorderSizePixel = 0
                ripple.ZIndex = 4
                Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
                
                local ripGrad = Instance.new("UIGradient", ripple)
                ripGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Themes[CurrentTheme].ToggleActive),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                })
                ripGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.7, 0.4),
                    NumberSequenceKeypoint.new(1, 1)
                })
                
                -- Tính toán tâm Ripple chuẩn xác theo tọa độ chuột
                local relativeX = lastMousePos.X - row.AbsolutePosition.X
                local relativeY = lastMousePos.Y - row.AbsolutePosition.Y
                
                if lastMousePos.X == 0 and lastMousePos.Y == 0 then
                    relativeX = btnContainer.AbsolutePosition.X + btnContainer.AbsoluteSize.X / 2 - row.AbsolutePosition.X
                    relativeY = btnContainer.AbsolutePosition.Y + btnContainer.AbsoluteSize.Y / 2 - row.AbsolutePosition.Y
                end
                
                ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)
                
                local maxDim = math.max(row.AbsoluteSize.X, row.AbsoluteSize.Y) * 1.5
                local ripTween = TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, maxDim, 0, maxDim),
                    BackgroundTransparency = 1
                })
                ripTween:Play()
                ripTween.Completed:Connect(function() ripple:Destroy() end)
                
                if callback then callback() end
            end)
        end
---------
---------
      ---------
        ---------
        function Tab:CreateSwitch(text, default, desc, callback, flag)
            local rowHeight = (desc and desc ~= "") and 58 or 42
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.Position = UDim2.new(0, 2, 0, 0)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.7, -10, 0, 42)
            label.Position = UDim2.new(0, 15, 0, 0)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14.5
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -80, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 32)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end
---------
            
         ---------
            local toggleFrame = Instance.new("TextButton", row)
            toggleFrame.Size = UDim2.new(0, 40, 0, 20)
            toggleFrame.Position = UDim2.new(1, -55, 0.5, 0)
            toggleFrame.AnchorPoint = Vector2.new(0, 0.5)
            toggleFrame.BackgroundColor3 = default and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")
            toggleFrame.Text = ""
            toggleFrame.ClipsDescendants = false 
            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(1, 0)
            
            local flashFrame = Instance.new("Frame", toggleFrame)
            flashFrame.Size = UDim2.new(1, 0, 1, 0)
            flashFrame.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            flashFrame.BackgroundTransparency = 1
            flashFrame.ClipsDescendants = true
            Instance.new("UICorner", flashFrame).CornerRadius = UDim.new(1, 0)
            
            local flashGrad = Instance.new("UIGradient", flashFrame)
            flashGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
            })
            flashGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            flashGrad.Rotation = 45
            flashGrad.Offset = Vector2.new(-1, 0)

            local ball = Instance.new("Frame", toggleFrame)
            ball.Size = UDim2.new(0, 16, 0, 16)
            ball.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
            ball.AnchorPoint = Vector2.new(0, 0.5)
            ball.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            ball.ZIndex = 3
            Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
            
            local active = default
            local switchData = {Frame = toggleFrame, Active = active}
            table.insert(UI_Elements.Switches, switchData)
            
            local flagId = GetSecureFlag(text, flag)
            local function SetState(v)
                active = v
                switchData.Active = active
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = active
                end
                
                local targetColor = active and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")
                TweenService:Create(toggleFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = targetColor}):Play()
                
                local targetPos = active and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
                
                TweenService:Create(ball, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 22, 0, 12)}):Play()
                TweenService:Create(ball, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = targetPos}):Play()
                
                task.delay(0.1, function()
                    TweenService:Create(ball, TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.new(0, 16, 0, 16)}):Play()
                end)

                flashFrame.BackgroundTransparency = 0.5
                flashGrad.Offset = Vector2.new(-1.5, 0)
                local flashTween = TweenService:Create(flashGrad, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {Offset = Vector2.new(1.5, 0)})
                flashTween:Play()
           flashTween.Completed:Connect(function()
                flashFrame.BackgroundTransparency = 1
            end)

            local pColor = active and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#969696")
            for i = 1, 14 do
                task.delay(math.random(0, 10)/100, function()
                    if not ball or not toggleFrame then return end
                    local particle = Instance.new("Frame", toggleFrame)
                    particle.Size = UDim2.new(0, 10, 0, 10)
                    particle.AnchorPoint = Vector2.new(0.5, 0.5)
                    particle.Position = ball.Position + UDim2.new(0, 0, 0, 0)
                    particle.BackgroundColor3 = pColor
                    
                    particle.ZIndex = 5
                    
                    Instance.new("UICorner", particle).CornerRadius = UDim.new(1, 0)
                    
                    local angle = math.rad(math.random(0, 360))
                    local distance = math.random(15, 35)
                    local offsetX = math.cos(angle) * distance
                    local offsetY = math.sin(angle) * distance
                    
                    local pTween = TweenService:Create(particle, TweenInfo.new(math.random(3, 5)/10, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
                        Position = particle.Position + UDim2.new(0, offsetX, 0, offsetY),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1
                    })
                    pTween:Play()
                    pTween.Completed:Connect(function() particle:Destroy() end)
                end)
            end
            
            if callback then callback(active) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetState }

            toggleFrame.MouseButton1Click:Connect(function()
                SetState(not active)
                local status = active and "Enabled" or "Disabled"
            end)
        end
---------
---------

       function Tab:CreateLabel(titleText, descText)
            local row = Instance.new("Frame", page)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Size = UDim2.new(1, -4, 0, 42)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local layout = Instance.new("UIListLayout", row)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 2)
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

            local padding = Instance.new("UIPadding", row)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.PaddingTop = UDim.new(0, 8)
            padding.PaddingBottom = UDim.new(0, 8)

            local labelTitle = nil
            if titleText and titleText ~= "" then
                labelTitle = Instance.new("TextLabel", row)
                labelTitle.Name = "Title"
                labelTitle.LayoutOrder = 1
                labelTitle.Size = UDim2.new(1, 0, 0, 20)
                labelTitle.BackgroundTransparency = 1
                labelTitle.Font = Enum.Font.GothamBold
                labelTitle.Text = titleText
                ApplyTextGradient(labelTitle)
                labelTitle.TextSize = 14
                labelTitle.TextXAlignment = Enum.TextXAlignment.Left
                labelTitle.AutomaticSize = Enum.AutomaticSize.Y
            end
            
            local labelDesc = nil
            if descText and descText ~= "" then
                labelDesc = Instance.new("TextLabel", row)
                labelDesc.Name = "Description"
                labelDesc.LayoutOrder = 2
                labelDesc.Size = UDim2.new(1, 0, 0, 0)
                labelDesc.BackgroundTransparency = 1
                labelDesc.Font = Enum.Font.GothamBold
                labelDesc.Text = descText
                labelDesc.TextColor3 = Themes[CurrentTheme].DescTextColor
                labelDesc.TextSize = 10
                labelDesc.TextXAlignment = Enum.TextXAlignment.Left
                labelDesc.TextWrapped = true
                labelDesc.AutomaticSize = Enum.AutomaticSize.Y
                table.insert(UI_Elements.Descriptions, labelDesc)
            end

            local LabelObj = {}
            function LabelObj:SetText(val)
                if labelDesc then
                    labelDesc.Text = tostring(val)
                elseif labelTitle then
                    labelTitle.Text = tostring(val)
                end
            end
            function LabelObj.SetText(self, val)
                if type(self) == "table" and val ~= nil then
                    self:SetText(val)
                else
                    LabelObj:SetText(self)
                end
            end
            function LabelObj:Set(title, desc)
                if title and labelTitle then labelTitle.Text = tostring(title) end
                if desc and labelDesc then labelDesc.Text = tostring(desc) end
            end
            return LabelObj
        end
---------

        ---------
        function Tab:CreateInput(text, placeholder, default, desc, numericOnly, callback, flag)
            local Input = {}
            local rowHeight = (desc and desc ~= "") and 64 or 48
            local row = Instance.new("Frame", page)
            row.Size = UDim2.new(1, -4, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            row.ClipsDescendants = true
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)

            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)

            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local title = Instance.new("TextLabel", row)
            title.Size = UDim2.new(1, -190, 0, 36)
            title.Position = UDim2.new(0, 15, 0, 4)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = text
            ApplyTextGradient(title)
            title.TextSize = 14
            title.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -190, 0, 16)
                descLabel.Position = UDim2.new(0, 15, 0, 36)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end

            local boxWrapper = Instance.new("Frame", row)
            boxWrapper.Size = UDim2.new(0, 120, 0, 32)
            boxWrapper.Position = UDim2.new(1, -15, 0.5, 0)
            boxWrapper.AnchorPoint = Vector2.new(1, 0.5)
            boxWrapper.BackgroundTransparency = 1

            local boxContainer = Instance.new("Frame", boxWrapper)
            boxContainer.Size = UDim2.new(1, 0, 1, 0)
            boxContainer.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            boxContainer.BackgroundTransparency = math.clamp(Themes[CurrentTheme].ContainerTrans + 0.1, 0.2, 0.95)
            boxContainer.ZIndex = 2
            boxContainer.ClipsDescendants = true
            table.insert(UI_Elements.Containers, boxContainer)
            Instance.new("UICorner", boxContainer).CornerRadius = UDim.new(0, 8)

            local boxStroke = Instance.new("UIStroke", boxContainer)
            boxStroke.Color = Themes[CurrentTheme].RowStroke
            boxStroke.Thickness = 1.2
            boxStroke.Transparency = 0.4
            table.insert(UI_Elements.RowStrokes, boxStroke)

            local boxGrad = Instance.new("UIGradient", boxStroke)
            boxGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, boxGrad)
            table.insert(UI_Elements.AnimatedGradients, boxGrad)

            local boxScale = Instance.new("UIScale", boxWrapper)
            boxScale.Scale = 1

            local iconHolder = Instance.new("Frame", boxContainer)
            iconHolder.Size = UDim2.new(0, 24, 1, 0)
            iconHolder.Position = UDim2.new(0, 4, 0, 0)
            iconHolder.BackgroundTransparency = 1
            iconHolder.ZIndex = 4

            local iconImg = Instance.new("ImageLabel", iconHolder)
            iconImg.Size = UDim2.new(0, 15, 0, 15)
            iconImg.Position = UDim2.new(0.5, 0, 0.5, 0)
            iconImg.AnchorPoint = Vector2.new(0.5, 0.5)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = "rbxassetid://6031154871"
            iconImg.ImageColor3 = Themes[CurrentTheme].DescTextColor
            iconImg.ZIndex = 4

            local flashFrame = Instance.new("Frame", boxContainer)
            flashFrame.Size = UDim2.new(1, 0, 1, 0)
            flashFrame.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            flashFrame.BackgroundTransparency = 1
            flashFrame.ClipsDescendants = true
            flashFrame.ZIndex = 6
            Instance.new("UICorner", flashFrame).CornerRadius = UDim.new(0, 8)

            local flashGrad = Instance.new("UIGradient", flashFrame)
            flashGrad.Color = Themes[CurrentTheme].LoopSeq
            flashGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            flashGrad.Rotation = 35
            flashGrad.Offset = Vector2.new(-1, 0)

            local function PlayNeonFlash()
                flashFrame.BackgroundTransparency = 0.5
                flashGrad.Offset = Vector2.new(-1.8, 0)
                local flashTween = TweenService:Create(flashGrad, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Offset = Vector2.new(1.8, 0)})
                flashTween:Play()
                flashTween.Completed:Connect(function()
                    flashFrame.BackgroundTransparency = 1
                end)
            end

            local function EmitNeonParticles(amount)
                amount = amount or 10
                if not boxWrapper or not boxWrapper.Parent then return end
                for i = 1, amount do
                    local p = Instance.new("Frame", boxWrapper)
                    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
                    p.Position = UDim2.new(0.5, 0, 0.5, 0)
                    p.AnchorPoint = Vector2.new(0.5, 0.5)
                    p.BackgroundColor3 = Themes[CurrentTheme].ToggleActive
                    p.ZIndex = 20
                    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)

                    local angle = math.rad(math.random(0, 360))
                    local dist = math.random(15, 38)
                    local offX = math.cos(angle) * dist
                    local offY = math.sin(angle) * dist

                    local tw = TweenService:Create(p, TweenInfo.new(math.random(4, 7)/10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = p.Position + UDim2.new(0, offX, 0, offY),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1
                    })
                    tw:Play()
                    tw.Completed:Connect(function() p:Destroy() end)
                end
            end

            local textBox = Instance.new("TextBox", boxContainer)
            textBox.Size = UDim2.new(1, -34, 1, 0)
            textBox.Position = UDim2.new(0, 28, 0, 0)
            textBox.BackgroundTransparency = 1
            textBox.Font = Enum.Font.GothamBold
            textBox.Text = default and tostring(default) or ""
            textBox.PlaceholderText = placeholder or "Type here..."
            textBox.PlaceholderColor3 = Themes[CurrentTheme].DescTextColor
            textBox.TextSize = 12
            textBox.ClearTextOnFocus = true
            textBox.ClipsDescendants = true
            textBox.ZIndex = 4
            ApplyTextGradient(textBox)

            local flagId = GetSecureFlag(text, flag)
            local function SetValue(val)
                local strVal = tostring(val)
                if numericOnly then
                    strVal = strVal:gsub("%D+", "")
                end
                textBox.Text = strVal
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = strVal
                end
                if callback then callback(strVal) end
                Library:AutoSave()
            end

            Library.ConfigElements[flagId] = { Value = default or "", Set = SetValue }

            local lastMousePos = Vector2.new(0, 0)
            row.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
                end
            end)

            textBox.Focused:Connect(function()
                TweenService:Create(boxScale, TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.96}):Play()
                TweenService:Create(boxStroke, TweenInfo.new(0.25), {
                    Color = Themes[CurrentTheme].ToggleActive, 
                    Thickness = 1.6, 
                    Transparency = 0
                }):Play()
                TweenService:Create(iconImg, TweenInfo.new(0.25), {ImageColor3 = Themes[CurrentTheme].ToggleActive}):Play()
                
                TweenService:Create(row, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Rotation = -0.4,
                    BackgroundTransparency = math.clamp(Themes[CurrentTheme].ContainerTrans + 0.12, 0, 1)
                }):Play()

                local ripple = Instance.new("Frame")
                ripple.Name = "LiquidRipple"
                ripple.Parent = row
                ripple.BackgroundColor3 = Themes[CurrentTheme].ToggleActive
                ripple.BorderSizePixel = 0
                ripple.ZIndex = 1
                Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

                local ripGrad = Instance.new("UIGradient", ripple)
                ripGrad.Color = Themes[CurrentTheme].LoopSeq
                ripGrad.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.2),
                    NumberSequenceKeypoint.new(0.7, 0.5),
                    NumberSequenceKeypoint.new(1, 1)
                })

                local relativeX = lastMousePos.X - row.AbsolutePosition.X
                local relativeY = lastMousePos.Y - row.AbsolutePosition.Y
                if lastMousePos.X == 0 and lastMousePos.Y == 0 then
                    relativeX = boxWrapper.AbsolutePosition.X - row.AbsolutePosition.X
                    relativeY = boxWrapper.AbsolutePosition.Y - row.AbsolutePosition.Y
                end

                ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
                ripple.Size = UDim2.new(0, 0, 0, 0)
                ripple.AnchorPoint = Vector2.new(0.5, 0.5)

                local maxDim = math.max(row.AbsoluteSize.X, row.AbsoluteSize.Y) * 1.6
                local ripTween = TweenService:Create(ripple, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, maxDim, 0, maxDim),
                    BackgroundTransparency = 1
                })
                ripTween:Play()
                ripTween.Completed:Connect(function() ripple:Destroy() end)
            end)

            textBox:GetPropertyChangedSignal("Text"):Connect(function()
                if numericOnly then
                    local clean = textBox.Text:gsub("%D+", "")
                    if clean ~= textBox.Text then
                        textBox.Text = clean
                    end
                end
            end)

            textBox.FocusLost:Connect(function()
                TweenService:Create(boxScale, TweenInfo.new(0.35, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
                TweenService:Create(boxStroke, TweenInfo.new(0.3), {
                    Color = Themes[CurrentTheme].RowStroke, 
                    Thickness = 1.2, 
                    Transparency = 0.4
                }):Play()
                TweenService:Create(iconImg, TweenInfo.new(0.3), {ImageColor3 = Themes[CurrentTheme].DescTextColor}):Play()
                
                TweenService:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Rotation = 0,
                    BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
                }):Play()

                PlayNeonFlash()
                EmitNeonParticles(12)
                SetValue(textBox.Text)
            end)

            function Input:Set(val)
                SetValue(val)
            end

            function Input:Get()
                return textBox.Text
            end

            return Input
        end
---------


        function Tab:CreateParagraph(titleText, descText)
            local Paragraph = {}
            local row = Instance.new("Frame", page)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.Size = UDim2.new(1, -4, 0, 0)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8) 
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke 
            rowStroke.Thickness = 1.2 
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad 
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local layout = Instance.new("UIListLayout", row)
            layout.SortOrder = Enum.SortOrder.LayoutOrder
            layout.Padding = UDim.new(0, 4)
            layout.VerticalAlignment = Enum.VerticalAlignment.Center
            layout.HorizontalAlignment = Enum.HorizontalAlignment.Left

            local padding = Instance.new("UIPadding", row)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.PaddingTop = UDim.new(0, 10)
            padding.PaddingBottom = UDim.new(0, 10)

            local labelTitle = nil
            if titleText and titleText ~= "" then
                labelTitle = Instance.new("TextLabel", row)
                labelTitle.Name = "ParagraphTitle"
                labelTitle.LayoutOrder = 1
                labelTitle.Size = UDim2.new(1, 0, 0, 20)
                labelTitle.BackgroundTransparency = 1
                labelTitle.Font = Enum.Font.GothamBold 
                labelTitle.Text = titleText
                ApplyTextGradient(labelTitle)
                labelTitle.TextSize = 14 
                labelTitle.TextXAlignment = Enum.TextXAlignment.Left 
                labelTitle.AutomaticSize = Enum.AutomaticSize.Y
            end

            local labelDesc = nil
            if descText and descText ~= "" then
                labelDesc = Instance.new("TextLabel", row)
                labelDesc.Name = "ParagraphContent"
                labelDesc.LayoutOrder = 2
                labelDesc.Size = UDim2.new(1, 0, 0, 0)
                labelDesc.BackgroundTransparency = 1
                labelDesc.Font = Enum.Font.GothamBold
                labelDesc.Text = descText
                labelDesc.TextColor3 = Themes[CurrentTheme].DescTextColor
                labelDesc.TextSize = 10
                labelDesc.TextXAlignment = Enum.TextXAlignment.Left
                labelDesc.TextWrapped = true
                labelDesc.AutomaticSize = Enum.AutomaticSize.Y
                table.insert(UI_Elements.Descriptions, labelDesc)
            end
            
            function Paragraph:Set(arg1, arg2)
                if type(arg1) == "table" then
                    if arg1.Title and labelTitle then
                        labelTitle.Text = arg1.Title
                    end
                    if arg1.Content and labelDesc then
                        labelDesc.Text = arg1.Content
                    end
                elseif type(arg1) == "string" and type(arg2) == "string" then
                    if labelTitle then labelTitle.Text = arg1 end
                    if labelDesc then labelDesc.Text = arg2 end
                elseif type(arg1) == "string" and not arg2 then
                    if labelDesc then labelDesc.Text = arg1 end
                end
            end

            return Paragraph
        end
---------
    ---------
        function Tab:CreateSlider(text, min, max, default, desc, callback, flag)
            local rowHeight = (desc and desc ~= "") and 76 or 60
            local containerHeight = (desc and desc ~= "") and 81 or 65

            local container = Instance.new("Frame", page)
            container.Size = UDim2.new(1, -4, 0, containerHeight)
            container.BackgroundTransparency = 1
            
            local row = Instance.new("Frame", container)
            row.Size = UDim2.new(1, 0, 0, rowHeight)
            row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
            row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
            table.insert(UI_Elements.Containers, row)
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)
            
            local label = Instance.new("TextLabel", row)
            label.Size = UDim2.new(0.6, 0, 0, 30)
            label.Position = UDim2.new(0, 15, 0, 5)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.GothamBold
            label.Text = text
            ApplyTextGradient(label)
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left

            if desc and desc ~= "" then
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -80, 0, 15)
                descLabel.Position = UDim2.new(0, 15, 0, 30)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = desc
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                table.insert(UI_Elements.Descriptions, descLabel)
            end

            local inputField = Instance.new("TextBox", row)
            inputField.Size = UDim2.new(0, 50, 0, 22)
            inputField.Position = UDim2.new(1, -65, 0, 10)
            inputField.BackgroundColor3 = Color3.fromHex("#000000")
            inputField.BackgroundTransparency = 0.9
            inputField.Font = Enum.Font.GothamBold
            inputField.Text = tostring(default)
            ApplyTextGradient(inputField)
            inputField.TextSize = 12
            Instance.new("UICorner", inputField).CornerRadius = UDim.new(0, 5)
            
            local flashFrame = Instance.new("Frame", inputField)
            flashFrame.Size = UDim2.new(1, 0, 1, 0)
            flashFrame.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            flashFrame.BackgroundTransparency = 1
            flashFrame.ClipsDescendants = true
            Instance.new("UICorner", flashFrame).CornerRadius = UDim.new(0, 5)
            
            local flashGrad = Instance.new("UIGradient", flashFrame)
            flashGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#FFFFFF")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
            })
            flashGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1)
            })
            flashGrad.Rotation = 45
            flashGrad.Offset = Vector2.new(-1, 0)

            local function PlayNeonPulse()
                flashFrame.BackgroundTransparency = 0.4
                flashGrad.Offset = Vector2.new(-1.5, 0)
                local flashTween = TweenService:Create(flashGrad, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {Offset = Vector2.new(1.5, 0)})
                flashTween:Play()
                flashTween.Completed:Connect(function()
                    flashFrame.BackgroundTransparency = 1
                end)
            end
            
            local sliderBg = Instance.new("Frame", row)
            sliderBg.Size = UDim2.new(1, -30, 0, 6)
            local sliderYPos = (desc and desc ~= "") and 60 or 45
            sliderBg.Position = UDim2.new(0, 15, 0, sliderYPos)
            sliderBg.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            sliderBg.BackgroundTransparency = 0.9
            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
            
            local sliderHitbox = Instance.new("TextButton", sliderBg)
            sliderHitbox.Size = UDim2.new(1, 0, 1, 20)
            sliderHitbox.Position = UDim2.new(0, 0, 0.5, 0)
            sliderHitbox.AnchorPoint = Vector2.new(0, 0.5)
            sliderHitbox.BackgroundTransparency = 1
            sliderHitbox.Text = ""
            sliderHitbox.ZIndex = 4

            local sliderFill = Instance.new("Frame", sliderBg)
            sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            sliderFill.BorderSizePixel = 0
            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
            
            local fillGrad = Instance.new("UIGradient", sliderFill)
            fillGrad.Color = Themes[CurrentTheme].TextGrad
            table.insert(UI_Elements.AnimatedGradients, fillGrad)

            local circle = Instance.new("Frame", sliderFill)
            circle.Size = UDim2.new(0, 65, 2, 60)
            circle.Position = UDim2.new(1, 0, 0.5, 0)
            circle.AnchorPoint = Vector2.new(0.5, 0.5)
            circle.BackgroundTransparency = 1
            circle.ZIndex = 5

            local circleVisual = Instance.new("Frame", circle)
            circleVisual.Size = UDim2.new(0, 14, 0, 14)
            circleVisual.Position = UDim2.new(0.5, 0, 0.5, 0)
            circleVisual.AnchorPoint = Vector2.new(0.5, 0.5)
            circleVisual.BackgroundColor3 = Color3.fromHex("#FFFFFF")
            Instance.new("UICorner", circleVisual).CornerRadius = UDim.new(1, 0)
            
            local function EmitParticles(amount)
                amount = amount or 15
                if not sliderBg or not sliderBg.Parent then return end
                for i = 1, amount do
                    local p = Instance.new("Frame", sliderBg)
                    p.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
                    p.Position = UDim2.new(sliderFill.Size.X.Scale, 0, 0.5, 0)
                    p.AnchorPoint = Vector2.new(0.5, 0.5)
                    p.BackgroundColor3 = Themes[CurrentTheme] and Themes[CurrentTheme].ToggleActive or Color3.fromHex("#FFFFFF")
                    p.ZIndex = 10
                    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
                    
                    local angle = math.rad(math.random(0, 360))
                    local dist = math.random(15, 35)
                    local offX = math.cos(angle) * dist
                    local offY = math.sin(angle) * dist
                    
                    local tw = TweenService:Create(p, TweenInfo.new(math.random(4, 8)/10, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Position = p.Position + UDim2.new(0, offX, 0, offY),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1
                    })
                    tw:Play()
                    tw.Completed:Connect(function() p:Destroy() end)
                end
            end

            local flagId = GetSecureFlag(text, flag)
            local function SetValue(val)
                val = math.clamp(val, min, max)
                sliderFill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
                inputField.Text = tostring(val)
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
            end

            Library.ConfigElements[flagId] = { Value = default, Set = SetValue }

            local lastEmit = 0
            local function move(input)
                local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                SetValue(value)
                
                if tick() - lastEmit > 0.06 then
                    lastEmit = tick()
                    EmitParticles(2)
                end
            end
            
            local dragging = false
            circle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                    dragging = true 
                    EmitParticles(10)
                    TweenService:Create(circleVisual, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 10, 0, 10)}):Play()
                end
            end)
            
            sliderHitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true 
                    local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (max - min) * pos)
                    
                    TweenService:Create(circleVisual, TweenInfo.new(0.15, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 0)}):Play()
                    
                    SetValue(value)
                    EmitParticles(10)
                    
                    TweenService:Create(circleVisual, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if dragging then
                        dragging = false
                        TweenService:Create(circleVisual, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Size = UDim2.new(0, 14, 0, 14)}):Play()
                        Library:AutoSave()
                    end
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
                    move(input) 
                end
            end)

            inputField.FocusLost:Connect(function()
                local val = tonumber(inputField.Text)
                if not val then val = default end
                val = math.clamp(val, min, max)
                
                inputField.Text = tostring(val)
                TweenService:Create(sliderFill, TweenInfo.new(0.2), {Size = UDim2.new((val - min) / (max - min), 0, 1, 0)}):Play()
                PlayNeonPulse()
                EmitParticles(15)
                
                if Library.ConfigElements[flagId] then
                    Library.ConfigElements[flagId].Value = val
                end
                if callback then callback(val) end
                Library:AutoSave()
            end)
        end
---------

        ---------
    function Tab:CreateCopy(titleText, contentToCopy, descText)
        local rowHeight = (descText and descText ~= "") and 65 or 50
        local row = Instance.new("Frame", page)
        row.Size = UDim2.new(1, -4, 0, rowHeight)
        row.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        row.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
        row.ClipsDescendants = true
        table.insert(UI_Elements.Containers, row)
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
            
            local rowStroke = Instance.new("UIStroke", row)
            rowStroke.Color = Themes[CurrentTheme].RowStroke
            rowStroke.Thickness = 1.2
            rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            table.insert(UI_Elements.RowStrokes, rowStroke)
            
            local rowGrad = Instance.new("UIGradient", rowStroke)
            rowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
            table.insert(UI_Elements.RowStrokeGradients, rowGrad)
            table.insert(UI_Elements.AnimatedGradients, rowGrad)

            local title = Instance.new("TextLabel", row)
            title.Size = UDim2.new(1, -50, 0, 30)
            title.Position = UDim2.new(0, 12, 0, 10)
            title.BackgroundTransparency = 1
            title.Font = Enum.Font.GothamBold
            title.Text = titleText
            ApplyTextGradient(title)
            title.TextSize = 13.5
            title.TextXAlignment = Enum.TextXAlignment.Left

            if descText and descText ~= "" then
                title.Position = UDim2.new(0, 12, 0, 5)
                local descLabel = Instance.new("TextLabel", row)
                descLabel.Size = UDim2.new(1, -60, 0, 20)
                descLabel.Position = UDim2.new(0, 12, 0, 28)
                descLabel.BackgroundTransparency = 1
                descLabel.Font = Enum.Font.GothamBold
                descLabel.Text = descText
                descLabel.TextSize = 10
                descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.TextWrapped = true
                table.insert(UI_Elements.Descriptions, descLabel)
            end

            local copyBtn = Instance.new("TextButton", row)
            copyBtn.Size = UDim2.new(0, 30, 0, 30)
            copyBtn.Position = UDim2.new(1, -5, 0, 5)
            copyBtn.AnchorPoint = Vector2.new(1, 0)
            copyBtn.BackgroundTransparency = 1
            copyBtn.Text = ""
            
            local coreContainer = Instance.new("Frame", copyBtn)
            coreContainer.AnchorPoint = Vector2.new(0.5, 0.5)
            coreContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
            coreContainer.Size = UDim2.new(1, 0, 1, 0)
            coreContainer.BackgroundTransparency = 1
            
            local uiScale = Instance.new("UIScale", coreContainer)
            uiScale.Scale = 1
            
            local coreLayers = {}
            local baseSizes = {8, 12, 16, 20, 24, 28} 
            local baseTransparencies = {0.1, 0.3, 0.5, 0.7, 0.85, 0.93}
            
            for i = 1, #baseSizes do
                local layer = Instance.new("Frame")
                layer.AnchorPoint = Vector2.new(0.5, 0.5)
                layer.Position = UDim2.new(0.5, 0, 0.5, 0)
                layer.BorderSizePixel = 0
                layer.ZIndex = 3
                Instance.new("UICorner", layer).CornerRadius = UDim.new(1, 0)
                layer.Parent = coreContainer
                table.insert(coreLayers, {frame = layer, baseSize = baseSizes[i], baseTrans = baseTransparencies[i]})
            end
            
            local r = 0
            local isClicked = false
            local clickTime = 0
            
            local renderConn
            renderConn = RunService.RenderStepped:Connect(function()
                if not copyBtn.Parent then
                    if renderConn then renderConn:Disconnect() end
                    return
                end
                
                r = (r + 1.5) % 360
                local t = Themes[CurrentTheme]
                
               local c1, c2
                if isClicked then
                    c1 = t.ToggleActive
                    c2 = t.ToggleActive
                else
                    c1 = Color3.fromRGB(150, 150, 150)
                    c2 = Color3.fromRGB(150, 150, 150)
                end
                
                local pulse = (math.sin(tick() * 3) + 1) / 2
                local coreColor = c1:Lerp(c2, math.abs(math.sin((r / 360) * math.pi)))
                
                for _, data in ipairs(coreLayers) do
                    local sizeOffset = pulse * 3
                    local targetSize = data.baseSize + sizeOffset
                    data.frame.Size = UDim2.new(0, targetSize, 0, targetSize)
                    data.frame.BackgroundColor3 = coreColor
                    data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
                end
                
                if isClicked and tick() - clickTime >= 0.5 then
                    isClicked = false
                    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1}):Play()
                end
            end)

           local lastMousePos = Vector2.new(0, 0)
        
        copyBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                lastMousePos = Vector2.new(input.Position.X, input.Position.Y)
                TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
                
                TweenService:Create(row, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Rotation = -0.5, 
                    BackgroundTransparency = math.clamp(Themes[CurrentTheme].ContainerTrans + 0.15, 0, 1)
                }):Play()
            end
        end)
        
        copyBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not isClicked then
                    TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
                end
                TweenService:Create(row, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Rotation = 0, 
                    BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
                }):Play()
            end
        end)
        
        copyBtn.MouseButton1Click:Connect(function()
            isClicked = true
            clickTime = tick()
            TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
            
            local ripple = Instance.new("Frame")
            ripple.Name = "LiquidRipple"
            ripple.Parent = row
            ripple.BackgroundColor3 = Themes[CurrentTheme].ToggleActive
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 4
            Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
            
            local ripGrad = Instance.new("UIGradient", ripple)
            ripGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Themes[CurrentTheme].ToggleActive),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            ripGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0.4),
                NumberSequenceKeypoint.new(1, 1)
            })
            
            local relativeX = lastMousePos.X - row.AbsolutePosition.X
            local relativeY = lastMousePos.Y - row.AbsolutePosition.Y
            
            if lastMousePos.X == 0 and lastMousePos.Y == 0 then
                relativeX = copyBtn.AbsolutePosition.X + copyBtn.AbsoluteSize.X / 2 - row.AbsolutePosition.X
                relativeY = copyBtn.AbsolutePosition.Y + copyBtn.AbsoluteSize.Y / 2 - row.AbsolutePosition.Y
            end
            
            ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            
            local maxDim = math.max(row.AbsoluteSize.X, row.AbsoluteSize.Y) * 1.5
            local ripTween = TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, maxDim, 0, maxDim),
                BackgroundTransparency = 1
            })
            ripTween:Play()
            ripTween.Completed:Connect(function() ripple:Destroy() end)
            
            local clipboardFunc = setclipboard or toclipboard or function(text) warn("Clipboard: " .. tostring(text)) end
            clipboardFunc(contentToCopy)
            Library:SendNotification("Copied Successfully", titleText)
        end)
    end

---------
    function Tab:CreateConfigBoard(descText)
        local closedHeight = 96
        local expandedHeight = 310
        local isExpanded = true

        local container = Instance.new("Frame", page)
        container.Size = UDim2.new(1, -4, 0, expandedHeight)
        container.Position = UDim2.new(0, 2, 0, 0)
        container.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        container.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
        container.ClipsDescendants = true
        table.insert(UI_Elements.Containers, container)
        Instance.new("UICorner", container).CornerRadius = UDim.new(0, 10)

        local containerStroke = Instance.new("UIStroke", container)
        containerStroke.Color = Themes[CurrentTheme].RowStroke
        containerStroke.Thickness = 1.2
        containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        table.insert(UI_Elements.RowStrokes, containerStroke)

        local containerGrad = Instance.new("UIGradient", containerStroke)
        containerGrad.Color = Themes[CurrentTheme].RowStrokeGrad
        table.insert(UI_Elements.RowStrokeGradients, containerGrad)
        table.insert(UI_Elements.AnimatedGradients, containerGrad)

        local headerBtn = Instance.new("TextButton", container)
        headerBtn.Size = UDim2.new(1, 0, 0, 52)
        headerBtn.Position = UDim2.new(0, 0, 0, 0)
        headerBtn.BackgroundTransparency = 1
        headerBtn.Text = ""

        local titleLabel = Instance.new("TextLabel", headerBtn)
        titleLabel.Size = UDim2.new(1, -65, 0, 24)
        titleLabel.Position = UDim2.new(0, 15, 0, 6)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = "Configuration Board"
        ApplyTextGradient(titleLabel)
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left

        if descText and descText ~= "" then
            local descLabel = Instance.new("TextLabel", headerBtn)
            descLabel.Size = UDim2.new(1, -65, 0, 16)
            descLabel.Position = UDim2.new(0, 15, 0, 28)
            descLabel.BackgroundTransparency = 1
            descLabel.Font = Enum.Font.GothamBold
            descLabel.Text = descText
            descLabel.TextSize = 10
            descLabel.TextColor3 = Themes[CurrentTheme].DescTextColor
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            table.insert(UI_Elements.Descriptions, descLabel)
        end


        local arrowWrapper = Instance.new("Frame", headerBtn)
        arrowWrapper.Size = UDim2.new(0, 30, 0, 30)
        arrowWrapper.Position = UDim2.new(1, -15, 0.5, 0)
        arrowWrapper.AnchorPoint = Vector2.new(1, 0.5)
        arrowWrapper.BackgroundColor3 = Themes[CurrentTheme].ContainerBg
        arrowWrapper.BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
        table.insert(UI_Elements.Containers, arrowWrapper)
        Instance.new("UICorner", arrowWrapper).CornerRadius = UDim.new(0, 8)


        local arrowStroke = Instance.new("UIStroke", arrowWrapper)
        arrowStroke.Thickness = 1.2
        arrowStroke.Color = Themes[CurrentTheme].RowStroke
        arrowStroke.Transparency = 0.2
        table.insert(UI_Elements.RowStrokes, arrowStroke)

        local arrowGrad = Instance.new("UIGradient", arrowStroke)
        arrowGrad.Rotation = -90
        arrowGrad.Color = Themes[CurrentTheme].RowStrokeGrad
        table.insert(UI_Elements.RowStrokeGradients, arrowGrad)


        local arrowScale = Instance.new("UIScale", arrowWrapper)
        arrowScale.Scale = 1


        local arrow = Instance.new("TextLabel", arrowWrapper)
        arrow.Size = UDim2.new(1, 0, 1, 0)
        arrow.BackgroundTransparency = 1
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▼"
        arrow.TextSize = 10
        arrow.Rotation = 180
        arrow.AnchorPoint = Vector2.new(0.5, 0.5)
        arrow.Position = UDim2.new(0.5, 0, 0.5, 0)
        ApplyTextGradient(arrow)

        local boardFrame = Instance.new("Frame", container)
        boardFrame.Size = UDim2.new(1, -26, 1, -66)
        boardFrame.Position = UDim2.new(0, 13, 0, 52)
        boardFrame.BackgroundColor3 = Color3.fromHex("#000000")
        boardFrame.BackgroundTransparency = 0.65
        boardFrame.ClipsDescendants = true
        local boardCorner = Instance.new("UICorner", boardFrame)
        boardCorner.CornerRadius = UDim.new(0, 8)

        local boardStroke = Instance.new("UIStroke", boardFrame)
        boardStroke.Color = Themes[CurrentTheme].RowStroke
        boardStroke.Thickness = 1
        boardStroke.Transparency = 0.5
        table.insert(UI_Elements.RowStrokes, boardStroke)

        local inputBox = Instance.new("TextBox", boardFrame)
        inputBox.Size = UDim2.new(1, 0, 1, 0)
        inputBox.BackgroundTransparency = 1
        inputBox.Font = Enum.Font.Code
        inputBox.Text = ""
        inputBox.PlaceholderText = "Paste your JSON config here to sync..."
        ApplyTextGradient(inputBox)
        inputBox.TextSize = 11
        inputBox.TextXAlignment = Enum.TextXAlignment.Left
        inputBox.TextYAlignment = Enum.TextYAlignment.Top
        inputBox.ClearTextOnFocus = false
        inputBox.MultiLine = true
        inputBox.TextWrapped = true


        local boxPadding = Instance.new("UIPadding", inputBox)
        boxPadding.PaddingLeft = UDim.new(0, 14)
        boxPadding.PaddingRight = UDim.new(0, 14)
        boxPadding.PaddingTop = UDim.new(0, 6)
        boxPadding.PaddingBottom = UDim.new(0, 6)

        local lastClickPos = Vector2.new(0, 0)
        headerBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                lastClickPos = Vector2.new(input.Position.X, input.Position.Y)
                TweenService:Create(arrowScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
                TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                    Rotation = -0.5,
                    BackgroundTransparency = math.clamp(Themes[CurrentTheme].ContainerTrans + 0.15, 0, 1)
                }):Play()
            end
        end)

        headerBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                TweenService:Create(arrowScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
                TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Rotation = 0,
                    BackgroundTransparency = Themes[CurrentTheme].ContainerTrans
                }):Play()
            end
        end)

        headerBtn.MouseButton1Click:Connect(function()
            isExpanded = not isExpanded
            local targetHeight = isExpanded and expandedHeight or closedHeight
            local targetRotation = isExpanded and 180 or 0
            local targetBoardHeight = isExpanded and UDim2.new(1, -26, 1, -66) or UDim2.new(1, -26, 0, 32)
            local targetCornerRadius = isExpanded and UDim.new(0, 8) or UDim.new(1, 0)

            inputBox.TextYAlignment = isExpanded and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center

            TweenService:Create(arrowScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3}):Play()
            task.delay(0.25, function()
                TweenService:Create(arrowScale, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
            end)

            local ripple = Instance.new("Frame", container)
            ripple.Name = "LiquidRipple"
            ripple.BackgroundColor3 = Themes[CurrentTheme].ToggleActive
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 4
            Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

            local ripGrad = Instance.new("UIGradient", ripple)
            ripGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Themes[CurrentTheme].ToggleActive),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
            })
            ripGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0.4),
                NumberSequenceKeypoint.new(1, 1)
            })

            local relativeX = lastClickPos.X - container.AbsolutePosition.X
            local relativeY = lastClickPos.Y - container.AbsolutePosition.Y
            if lastClickPos.X == 0 and lastClickPos.Y == 0 then
                relativeX = arrowWrapper.AbsolutePosition.X + arrowWrapper.AbsoluteSize.X / 2 - container.AbsolutePosition.X
                relativeY = arrowWrapper.AbsolutePosition.Y + arrowWrapper.AbsoluteSize.Y / 2 - container.AbsolutePosition.Y
            end

            ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)

            local maxDim = math.max(container.AbsoluteSize.X, 310) * 1.5
            local ripTween = TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, maxDim, 0, maxDim),
                BackgroundTransparency = 1
            })
            ripTween:Play()
            ripTween.Completed:Connect(function() ripple:Destroy() end)

            TweenService:Create(container, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -4, 0, targetHeight)}):Play()
            TweenService:Create(boardFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetBoardHeight}):Play()
            TweenService:Create(boardCorner, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {CornerRadius = targetCornerRadius}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = targetRotation}):Play()
        end)

        inputBox.FocusLost:Connect(function()
            local txt = inputBox.Text
            if txt ~= "" then
                local success, data = pcall(function()
                    return HttpService:JSONDecode(txt)
                end)
                if success and type(data) == "table" then
                    Library.IsLoading = true
                    for flag, value in pairs(data) do
                        if Library.ConfigElements[flag] then
                            Library.ConfigElements[flag].Set(value)
                        end
                    end
                    Library.IsLoading = false
                    Library:SendNotification("Config System", "Synced settings from pasted JSON!")
                    inputBox.Text = ""
                else
                    Library:SendNotification("Config Error", "Invalid JSON format!")
                end
            end
        end)
    end


        return Tab
    end




function Window:ApplyTheme(name)
        local t = Themes[name]
        if not t then return end
        CurrentTheme = name
        
        if m then 
            TweenService:Create(m, TweenInfo.new(0.3), {BackgroundColor3 = t.MainBg, BackgroundTransparency = t.MainBgTrans}):Play()
        end
        
        local AuraGlow = g:FindFirstChild("AuraGlow")
        if AuraGlow then
            local auraColor = Color3.fromHex("#E0E0E0")
            if name == "Ocean" then
                auraColor = Color3.fromHex("#00E5FF")
            elseif name == "Dream" then
                auraColor = Color3.fromHex("#B026FF")
            end
            TweenService:Create(AuraGlow, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageColor3 = auraColor}):Play()
        end
        
        for _, bg in pairs(UI_Elements.Containers) do
            if bg and bg.Parent then
                TweenService:Create(bg, TweenInfo.new(0.3), {BackgroundColor3 = t.ContainerBg, BackgroundTransparency = t.ContainerTrans}):Play()
            end
        end
        
        for _, tabBg in pairs(UI_Elements.TabBackgrounds) do
            if tabBg and tabBg.Parent then
                TweenService:Create(tabBg, TweenInfo.new(0.3), {BackgroundColor3 = t.ContainerBg}):Play()
            end
        end
        
for _, obj in pairs(UI_Elements.TextGradients) do
            if obj and obj.Parent then 
                obj.Color = t.TextContrast 
                if obj.Parent:IsA("TextLabel") or obj.Parent:IsA("TextButton") or obj.Parent:IsA("TextBox") then
                    obj.Parent.TextColor3 = t.TextColor
                elseif obj.Parent:IsA("ImageLabel") then
                    obj.Parent.ImageColor3 = t.TextColor
                end
            end
        end

        for _, item in pairs(UI_Elements.AnimatedStrokes) do
            if item.Obj and item.Obj.Parent then
                TweenService:Create(item.Obj, TweenInfo.new(0.3), {Color = t[item.Type]}):Play()
            end
        end
        
        for _, s in pairs(UI_Elements.RowStrokes) do
            if s and s.Parent then
                TweenService:Create(s, TweenInfo.new(0.3), {Color = t.RowStroke}):Play()
            end
        end
        
        for _, g in pairs(UI_Elements.AnimatedGradients) do
            if g and g.Parent then g.Color = t.TextGrad end
        end
        
        for _, g in pairs(UI_Elements.RowStrokeGradients) do
            if g and g.Parent then g.Color = t.RowStrokeGrad end
        end
        
        for _, g in pairs(UI_Elements.TabGradients) do
            if g and g.Parent then g.Color = t.TabGrad end
        end
        
        for _, d in pairs(UI_Elements.DivGradients) do
            if d and d.Parent then d.Color = t.DivGrad end
        end
        
        ---------
---------
        for _, sw in pairs(UI_Elements.Switches) do
            if sw.Active then
                TweenService:Create(sw.Frame, TweenInfo.new(0.3), {BackgroundColor3 = t.ToggleActive}):Play()
                if sw.Glow then
                    TweenService:Create(sw.Glow, TweenInfo.new(0.3), {Color = t.ToggleActive}):Play()
                end
            end
        end
---------
        
        for _, desc in pairs(UI_Elements.Descriptions) do
            if desc and desc.Parent then
                TweenService:Create(desc, TweenInfo.new(0.3), {TextColor3 = t.DescTextColor}):Play()
            end
        end
    end

    
    local r = 0
    RunService.RenderStepped:Connect(function(dt)
        r = (r + 1.5) % 360
        e.Rotation = r
        
        for _, rotGrad in pairs(UI_Elements.RotatingGradients) do
            if rotGrad and rotGrad.Parent then 
                rotGrad.Rotation = r 
                rotGrad.Color = Themes[CurrentTheme].LoopSeq
            end
        end
        
        local animatedOffset = Vector2.new(math.sin(tick() * 2) * 0.4, 0)
        for _, grad in pairs(UI_Elements.AnimatedGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        for _, grad in pairs(UI_Elements.RowStrokeGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        for _, grad in pairs(UI_Elements.TabGradients) do
            if grad and grad.Parent then grad.Offset = animatedOffset end
        end
        
---------
        if Mini3DIcon.Visible then
            angleY = angleY + dt * 0.6
            angleX = angleX + dt * 0.35
            
            local mousePos = UserInputService:GetMouseLocation()
            local iconCenter = Mini3DIcon.AbsolutePosition + Mini3DIcon.AbsoluteSize / 2
            local dist = (mousePos - iconCenter).Magnitude
            
            local targetTiltX, targetTiltY = 0, 0
            if dist < 250 then
                local delta = mousePos - iconCenter
                targetTiltY = (delta.X / 250) * 0.8
                targetTiltX = (delta.Y / 250) * 0.8
            end
            
            currentTiltX = currentTiltX + (targetTiltX - currentTiltX) * (dt * 8)
            currentTiltY = currentTiltY + (targetTiltY - currentTiltY) * (dt * 8)
            
            local finalAngleX = angleX + currentTiltX
            local finalAngleY = angleY + currentTiltY

            local pulse = (math.sin(tick() * 3) + 1) / 2
            local tVal = (r / 360)
            
            local c1 = Themes[CurrentTheme].TextGrad.Keypoints[1].Value
            local c2 = Themes[CurrentTheme].ToggleActive
            local coreColor = c1:Lerp(c2, math.abs(math.sin(tVal * math.pi)))
            
            for _, grad in ipairs(lineGradients) do
                grad.Rotation = r
                grad.Color = Themes[CurrentTheme].LoopSeq
            end
            
            for _, data in ipairs(coreLayers) do
                local sizeOffset = pulse * 12
                data.frame.Size = UDim2.new(0, data.baseSize + sizeOffset, 0, data.baseSize + sizeOffset)
                data.frame.BackgroundColor3 = coreColor
                data.frame.BackgroundTransparency = math.clamp(data.baseTrans + (pulse * 0.05), 0, 1)
            end
            
            for i, edge in ipairs(edges) do
                local p1, z1 = project3D(vertices[edge[1]], finalAngleX, finalAngleY)
                local p2, z2 = project3D(vertices[edge[2]], finalAngleX, finalAngleY)
                local line = lines[i]
---------
                local diff = p2 - p1
                line.Size = UDim2.new(0, diff.Magnitude, 0, 0.1)
                line.Position = UDim2.new(0, (p1.X + p2.X) / 2, 0, (p1.Y + p2.Y) / 2)
                line.Rotation = math.deg(math.atan2(diff.Y, diff.X))
                local avgZ = (z1 + z2) / 2
                line.BackgroundTransparency = 1 - math.clamp(1 - (avgZ / 2.5), 0.15, 1)
                
                local strk = line:FindFirstChildWhichIsA("UIStroke")
                if avgZ > 0 then
                    line.ZIndex = 2
                    if strk then strk.Transparency = 0.8 end
                else
                    line.ZIndex = 4
                    if strk then strk.Transparency = math.clamp(0.4 - (pulse * 0.2), 0, 1) end
                end
            end
        end
    end)

---------
    m.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(m, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 525)}):Play()
    Library:SendNotification("Status", "Hub Initialized!")
    
    task.spawn(function()
        task.wait(1.5)
        Library:LoadConfig("AutoSave", true)
    end)

    local InfoTab = Window:CreateTab("Information", false, "rbxassetid://132312092981034")
    InfoTab:CreatePageTitle("Information")
    InfoTab:CreateCopy("Server Discord", "https://discord.gg/VnxbTKUe6T", "Click to copy invite link")
    InfoTab:CreateLabel("Designer Discord", "ngocanh_cte")
    InfoTab:CreateLabel("System", "UI for meyy hub")
    
---------
    local dfSettingsTab = Window:CreateTab("Config & Themes", false, "rbxassetid://136384267867469")
    
    dfSettingsTab:CreatePageTitle("Configuration")
    
    dfSettingsTab:CreateButton("Copy Configuration", "Copy to clipboard with beautiful format", function()
        local data = {}
        for flag, element in pairs(Library.ConfigElements) do
            data[flag] = element.Value
        end
        
        local function Beautify(tbl, indent)
            indent = indent or 1
            local formatting = string.rep("    ", indent)
            local json = "{\n"
            local isFirst = true
            for k, v in pairs(tbl) do
                if not isFirst then
                    json = json .. ",\n"
                end
                isFirst = false
                local valStr = ""
                if type(v) == "table" then
                    valStr = "["
                    for i, arrV in ipairs(v) do
                        valStr = valStr .. '"' .. tostring(arrV) .. '"'
                        if i < #v then valStr = valStr .. ", " end
                    end
                    valStr = valStr .. "]"
                elseif type(v) == "string" then
                    valStr = '"' .. tostring(v) .. '"'
                else
                    valStr = tostring(v)
                end
                json = json .. formatting .. '"' .. tostring(k) .. '": ' .. valStr
            end
            json = json .. "\n" .. string.rep("    ", indent - 1) .. "}"
            return json
        end

        local prettyJson = Beautify(data)
        local clipboardFunc = setclipboard or toclipboard or function(text) warn("Clipboard: " .. tostring(text)) end
        clipboardFunc(prettyJson)
        Library:SendNotification("Config System", "Copied beautiful JSON to clipboard!")
    end)
    
    dfSettingsTab:CreateConfigBoard("Paste JSON config below to sync all settings")

    dfSettingsTab:CreatePageTitle("Themes")
    dfSettingsTab:CreateDropdown("Select Theme", "", {"Ocean", "Dream", "Dark"}, "Change UI colors", function(selected)
        Window:ApplyTheme(selected)
    end)
    dfSettingsTab:CreatePageTitle("Fonts")
    local fontList = {
        "FredokaOne",
        "Bangers",
        "DenkOne",
        "Kalam",
        "Creepster",
        "AmaticSC",
        "PatrickHand",
        "Boogaloo",
        "PermanentMarker",
        "IndieFlower",
        "Fondamento",
        "LuckiestGuy",
        "SpecialElite",
        "Jura",
        "Sarpanch"
    }
    dfSettingsTab:CreateDropdown("Select Font", "FredokaOne", fontList, "Change UI font family", function(selected)
        Library:ApplyFont(selected)
    end)
    dfSettingsTab:CreateSlider("Text Size", 50, 300, 100, "Scale text size (Default: 100%, Max: 300%)", function(value)
        Library:ApplyFontScale(value)
    end)
    if TabsList[#TabsList] then
        TabsList[#TabsList].Btn.LayoutOrder = 9999
    end

    return Window
end
-- -------------------------
return Library
end)() --end UI Library
local Window = Library:CreateWindow({Title = "Macro - PvP [Premium] By Meyy Hub"})

local SettingsTab = Window:CreateTab("Settings", true, "rbxthumb://type=Asset&id=125575515639947&w=420&h=420")
local Combo1_6 = Window:CreateTab("Combo 1-6", false, "77000372466296")
local Combo7_12 = Window:CreateTab("Combo 7-12", false, "77000372466296")
---------
local SupportSettingsTab = Window:CreateTab("Support Settings", false, "77000372466296")
SupportSettingsTab:CreatePageTitle("Team Configuration")

SupportSettingsTab:CreateDropdown("Select Team", "Pirates", {"Marines", "Pirates"}, "Select your default team", function(val)
    _G.ChonPhe = val
    Library:SendNotification("Team Setup", "Auto team set to " .. val)
end)
SupportSettingsTab:CreatePageTitle("Movement Configuration")

SupportSettingsTab:CreateSwitch("Anti Stun (Force Move)", getgenv().AntiStunEnabled, "", function(state)
    getgenv().AntiStunEnabled = state
end)

SupportSettingsTab:CreateSwitch("Inf TP (Ctrl + Click)", getgenv().InfTPEnabled, "", function(state)
    getgenv().InfTPEnabled = state
end)

SupportSettingsTab:CreateSlider("Jump Power", 0, 500, getgenv().PlayerJumpPower, "", function(val)
    getgenv().PlayerJumpPower = val
end)

SupportSettingsTab:CreateSlider("Speed Power", 0, 500, getgenv().PlayerSpeedPower, "", function(val)
    getgenv().PlayerSpeedPower = val
end)
---------
---------
SupportSettingsTab:CreatePageTitle("Infinite Dark F")
getgenv().InfDarkFEnabled = false

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getEquippedDarkTool()
    local character = LocalPlayer.Character
    if not character then return nil end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool.Name == "Dark-Dark" then
        return tool
    end
    
    return nil
end

local function handleDarkFCombined(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        local darkTool = getEquippedDarkTool()
        if darkTool then
            LocalPlayer:SetAttribute("GANKS", true)
            darkTool:SetAttribute("IgnoreCooldowns", true)
            
            task.delay(0.1, function()
                if LocalPlayer:GetAttribute("GANKS") then
                    LocalPlayer:SetAttribute("GANKS", nil)
                end
                if darkTool and darkTool.Parent then
                    darkTool:SetAttribute("IgnoreCooldowns", nil)
                end
            end)
        end
    end
    
    return Enum.ContextActionResult.Pass
end

SupportSettingsTab:CreateSwitch("Remove Cooldown Skill F Dark Fruit", getgenv().InfDarkFEnabled, "", function(state)
    getgenv().InfDarkFEnabled = state
    
    if state then
        ContextActionService:UnbindAction("Meyy_PriorityDarkF_Combined")
        ContextActionService:BindActionAtPriority(
            "Meyy_PriorityDarkF_Combined",
            handleDarkFCombined,
            false,
            999999,
            Enum.KeyCode.F
        )
    else
        ContextActionService:UnbindAction("Meyy_PriorityDarkF_Combined")
        LocalPlayer:SetAttribute("GANKS", nil)
        local darkTool = getEquippedDarkTool()
        if darkTool then
            darkTool:SetAttribute("IgnoreCooldowns", nil)
        end
    end
end)
---------

SupportSettingsTab:CreatePageTitle("Lava Trap Configuration")

getgenv().AutoLavaTrapEnabled = false
getgenv().LavaTrapTool = "Melee"
getgenv().LavaTrapSkill = "Z"
getgenv().LavaTrapDelay = 0
getgenv().LavaTrapCVDelay = 0

SupportSettingsTab:CreateSwitch("Enable Auto Lava Trap", getgenv().AutoLavaTrapEnabled, "", function(state)
    getgenv().AutoLavaTrapEnabled = state
end)
---------
SupportSettingsTab:CreateSlider("Lava Trap Delay (ms)", 0, 1000, getgenv().LavaTrapDelay, "", function(val)
    getgenv().LavaTrapDelay = val
end)

SupportSettingsTab:CreateSlider("Lava Trap C to V Delay (ms)", 0, 1000, getgenv().LavaTrapCVDelay, "", function(val)
    getgenv().LavaTrapCVDelay = val
end)

SupportSettingsTab:CreateDropdown("Select Weapon Check", getgenv().LavaTrapTool, {"Melee", "Blox Fruit", "Sword", "Gun"}, "", function(val)
    getgenv().LavaTrapTool = val
end)

SupportSettingsTab:CreateDropdown("Use skill Portal after skill", getgenv().LavaTrapSkill, {"Z", "X", "C", "V", "F"}, "", function(val)
    getgenv().LavaTrapSkill = val
end)

local IsLavaComboActive = false
getgenv().IsLavaSpamming = false

local function EquipBloxFruitTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local humanoid = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 2))
    
    if humanoid and backpack and char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (string.find(string.lower(item.Name), "fruit") or string.lower(item.ToolTip) == "blox fruit") then
                return item.Name
            end
        end
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (string.find(string.lower(item.Name), "fruit") or string.lower(item.ToolTip) == "blox fruit") then
                humanoid:EquipTool(item)
                return item.Name
            end
        end
    end
    return nil
end

local function CheckSkillCooldown(toolName, button)
    if not toolName or not button then return false end
    local skillGui = nil
    local cdGui = nil
    local waitTime = tick()

    while not skillGui and tick() - waitTime < 0.2 do
        task.wait()
        local mainGui = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Skills") then
            skillGui = mainGui.Skills:FindFirstChild(toolName)
        end
    end

    if skillGui and skillGui:FindFirstChild(button) then
        cdGui = skillGui[button]:FindFirstChild("Cooldown")
    end

    if cdGui and cdGui.AbsoluteSize.X > 0 then
        return true
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if getgenv().AutoLavaTrapEnabled and getgenv().IsLavaSpamming then
        CheckAndClickLava()
    end
end)
---------
local function ExecuteLavaTrapLogic()
    if IsLavaComboActive then return end

    local fruitToolName = EquipBloxFruitTool()
    if not fruitToolName then return end

    if CheckSkillCooldown(fruitToolName, "V") then return end

    IsLavaComboActive = true

    local delayMs = getgenv().LavaTrapDelay or 100
    if delayMs > 0 then
        task.wait(delayMs / 1000)
    end

    local pressCountC = 0
    while pressCountC < 50 do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        pressCountC = pressCountC + 1
        
        if CheckSkillCooldown(fruitToolName, "C") then
            break
        end
        task.wait(0.05)
    end

    getgenv().IsLavaSpamming = true
    
    local cvDelay = getgenv().LavaTrapCVDelay or 0
    if cvDelay > 0 then
        task.wait(cvDelay / 1000)
    else
        task.wait(0.075)
    end

    local pressCount = 0
    while pressCount < 50 do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game)
        task.wait(0.02)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
        pressCount = pressCount + 1
        
        if CheckSkillCooldown(fruitToolName, "V") then
            break
        end
        task.wait(0.05)
    end

    task.delay(1, function()
        getgenv().IsLavaSpamming = false
    end)

    IsLavaComboActive = false
end
---------
---------

local function GetTargetTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local checkTool = string.lower(getgenv().LavaTrapTool)
    
    local function check(item)
        if not item:IsA("Tool") then return false end
        local toolName = string.lower(item.Name)
        local toolTip = string.lower(item.ToolTip or "")
        if checkTool == "blox fruit" then
            return (toolTip == "blox fruit" or string.find(toolName, "fruit"))
        elseif checkTool == "melee" then
            return (toolTip == "melee" or string.find(toolName, "combat") or string.find(toolName, "style") or item:FindFirstChild("MeleeScript"))
        elseif checkTool == "sword" then
            return (toolTip == "sword" or item:FindFirstChild("SwordScript"))
        elseif checkTool == "gun" then
            return (toolTip == "gun" or item:FindFirstChild("GunScript"))
        end
        return false
    end
    
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if check(item) then return item end
        end
    end
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if check(item) then return item end
        end
    end
    return nil
end

local lastEquippedTool = nil
local wasSkillOnCooldown = false

task.spawn(function()
    while task.wait() do
        if not getgenv().AutoLavaTrapEnabled then
            wasSkillOnCooldown = false
            lastEquippedTool = nil
            continue
        end
        
        local targetTool = GetTargetTool()
        local isCurrentlyOnCooldown = false
        
        if targetTool and targetTool.Parent == LocalPlayer.Character then
            local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
            local Skills = PlayerGui and PlayerGui:FindFirstChild("Main") and PlayerGui.Main:FindFirstChild("Skills")
            
            if Skills then
                local toolGui = Skills:FindFirstChild(targetTool.Name)
                local skillBtn = toolGui and toolGui:FindFirstChild(getgenv().LavaTrapSkill)
                local cd = skillBtn and skillBtn:FindFirstChild("Cooldown")
                
                if cd and cd.AbsoluteSize.X > 0 then
                    isCurrentlyOnCooldown = true
                end
            end
        end
        
        if targetTool == lastEquippedTool then
            if isCurrentlyOnCooldown and not wasSkillOnCooldown then
                task.spawn(ExecuteLavaTrapLogic)
            end
        end
        
        wasSkillOnCooldown = isCurrentlyOnCooldown
        lastEquippedTool = targetTool
    end
end)
---------
---------
SupportSettingsTab:CreatePageTitle("Power Client Side")

local IgnoreCDEnabled = false
SupportSettingsTab:CreateSwitch("Ignore Cooldowns Z Melee", false, "Remove cooldowns for Z skill melee", function(state)
    IgnoreCDEnabled = state
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local tool = character:FindFirstChildOfClass("Tool")
    
    if state then
        player:SetAttribute("NSUNS", true)
        if tool then
            tool:SetAttribute("IgnoreCooldowns", true)
        end
    else
        player:SetAttribute("NSUNS", false)
        if tool then
            tool:SetAttribute("IgnoreCooldowns", false)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if IgnoreCDEnabled then
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character
            if character then
                player:SetAttribute("NSUNS", true)
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:SetAttribute("IgnoreCooldowns", true)
                end
            end
        end
    end
end)

local UnbreakableEnabled = false
SupportSettingsTab:CreateSwitch("Unbreaking", false, "Prevent items and gear from breaking", function(state)
    UnbreakableEnabled = state
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    
    if char then
        char:SetAttribute("UnbreakableAll", state)
        char:SetAttribute("UnbreakableFruit", state)
        char:SetAttribute("UnbreakableMelee", state)
        char:SetAttribute("UnbreakableSword", state)
        char:SetAttribute("UnbreakableGun", state)
    end
end)

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    if UnbreakableEnabled then
        newChar:SetAttribute("UnbreakableAll", true)
        newChar:SetAttribute("UnbreakableFruit", true)
        newChar:SetAttribute("UnbreakableMelee", true)
        newChar:SetAttribute("UnbreakableSword", true)
        newChar:SetAttribute("UnbreakableGun", true)
    end
end)

local SelectedRace = "Mink"
SupportSettingsTab:CreateDropdown("Select Race V4", SelectedRace, {"Mink", "Cyborg"}, "Choose your preferred Race V4", function(val)
    SelectedRace = val
end)

local RaceV4Enabled = false
SupportSettingsTab:CreateSwitch("Race V4 Ability", false, "Enable specialized Race V4 skill", function(state)
    RaceV4Enabled = state
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    if state then
        if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Race") then
            LocalPlayer.Data.Race.Value = SelectedRace
            
            local A = LocalPlayer.Data.Race:FindFirstChild("A")
            if not A then
                A = Instance.new("IntValue")
                A.Name = "A"
                A.Parent = LocalPlayer.Data.Race
            end
            A.Value = 2

            local B = LocalPlayer.Data.Race:FindFirstChild("B")
            if not B then
                B = Instance.new("IntValue")
                B.Name = "B"
                B.Parent = LocalPlayer.Data.Race
            end
            B.Value = 1
            
            if not LocalPlayer.Data.Race:FindFirstChild("Evolved") then
                local Evolved = Instance.new("Folder")
                Evolved.Name = "Evolved"
                Evolved.Parent = LocalPlayer.Data.Race
            end
        end

        local RaceTransformed = Character:FindFirstChild("RaceTransformed")
        if not RaceTransformed then
            RaceTransformed = Instance.new("BoolValue")
            RaceTransformed.Name = "RaceTransformed"
            RaceTransformed.Parent = Character
        end
        RaceTransformed.Value = true
    else
        local RaceTransformed = Character:FindFirstChild("RaceTransformed")
        if RaceTransformed then
            RaceTransformed.Value = false
        end
    end
end)

getgenv().DashCustomEnabled = false
getgenv().DashDistance = 100

SupportSettingsTab:CreateSwitch("Dash Custom", false, "Modify dash range and attributes", function(state)
    getgenv().DashCustomEnabled = state
end)

SupportSettingsTab:CreateSlider("Dash Size", 0, 500, getgenv().DashDistance, "Adjust custom dash distance length", function(val)
    getgenv().DashDistance = val
    if getgenv().DashCustomEnabled then
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" and islclosure(v) and not isexecutorclosure(v) then
                local constants = debug.getconstants(v)
                if table.find(constants, "BoundActionDodge") or table.find(constants, "Dodging") then
                    for idx, upv in pairs(debug.getupvalues(v)) do
                        if type(upv) == "number" and (upv == 90 or upv == 92.5 or upv == getgenv().DashDistance) then
                            debug.setupvalue(v, idx, getgenv().DashDistance)
                        end
                    end
                end
            end
        end
    end
end)

local oldNamecallDash
oldNamecallDash = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if not checkcaller() and method == "GetAttribute" and args[1] == "DashLength" then
        if getgenv().DashCustomEnabled then
            return getgenv().DashDistance
        end
    end
    return oldNamecallDash(self, ...)
end)
---------------------------------------------------------------
SupportSettingsTab:CreatePageTitle("Support Settings")

SupportSettingsTab:CreateSwitch("Enable Hitbox", getgenv().HitboxEnabled, "", function(state)
    getgenv().HitboxEnabled = state
    if not state then
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                player.Character.HumanoidRootPart.Transparency = 1
            end
        end
        local enemies = game:GetService("Workspace"):FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") then
                    enemy.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    enemy.HumanoidRootPart.Transparency = 1
                end
            end
        end
    end
end)

SupportSettingsTab:CreateSwitch("Show Hitbox (0.5 Opacity)", getgenv().HitboxShow, "", function(state)
    getgenv().HitboxShow = state
end)

SupportSettingsTab:CreateSlider("Hitbox Size", 5, 50, getgenv().HitboxSize, "", function(val)
    getgenv().HitboxSize = val
end)


SupportSettingsTab:CreatePageTitle("Attack Systems")

---------
SupportSettingsTab:CreateSwitch("Fast Attack Auto Click", false, "", function(state)
    getgenv().FastAttackEnabled = state
    if state then
        task.spawn(function()
            local success, err = pcall(function()
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
            if not success then
                warn("Meyy Hub Error: " .. tostring(err))
            end
        end)
    else
        getgenv().FastAttackEnabled = false
    end
end)
---------

SupportSettingsTab:CreateSwitch("Kill Aura Dragon Storm", _G.dragontorm, "", function(state)
    _G.dragontorm = state
end)
---------
getgenv().AutoV4Enabled = true
SupportSettingsTab:CreateSwitch("Auto V4", getgenv().AutoV4Enabled, "", function(state)
    getgenv().AutoV4Enabled = state
end)

task.spawn(function()
    local plr = game:GetService("Players").LocalPlayer
    while task.wait(0.2) do
        if getgenv().AutoV4Enabled then
            local char = plr.Character
            if char and char:FindFirstChild("RaceEnergy") and char.RaceEnergy.Value >= 1 then
                pcall(function()
                    local awakening = plr.Backpack:FindFirstChild("Awakening") or char:FindFirstChild("Awakening")
                    if awakening and awakening:FindFirstChild("RemoteFunction") then
                        awakening.RemoteFunction:InvokeServer(true)
                    end
                end)
            end
        end
    end
end)
---------
---------
SettingsTab:CreatePageTitle("Global Configuration")
if getgenv().ShowComboUI == nil then getgenv().ShowComboUI = true end

SettingsTab:CreateSwitch("Show Combo Timer UI", getgenv().ShowComboUI, "", function(state)
    getgenv().ShowComboUI = state
    local ts = game:GetService("TweenService")
    local hub = game:GetService("CoreGui"):FindFirstChild("CapsuleStatusHub")
    if hub and hub:FindFirstChild("MainCapsule") then
        local cap = hub.MainCapsule
        if state then
            cap.Visible = true
            ts:Create(cap, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -180, 0, -20)}):Play()
        else
            local tween = ts:Create(cap, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -180, 0, -100)})
            tween:Play()
            task.spawn(function()
                tween.Completed:Wait()
                if not getgenv().ShowComboUI then
                    cap.Visible = false
                end
            end)
        end
    end
end)
SettingsTab:CreateSwitch("Master Switch", getgenv().MacroConfig.Settings.Enabled, "", function(state)
    getgenv().MacroConfig.Settings.Enabled = state
end)
---------
_G.BoostFPS_Executed = false
SettingsTab:CreateSwitch("Boost Fps", false, "Extreme FPS boost & Remove Sound", function(val)
    if val and not _G.BoostFPS_Executed then
        _G.BoostFPS_Executed = true
        task.spawn(function()
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

            local S = setmetatable({}, {__index=function(t,k)local s=game:GetService(k) rawset(t,k,s) return s end})
            local RunService, Workspace, Lighting, Players, StarterGui, SoundService, UIS, ReplicatedStorage =
                S.RunService, S.Workspace, S.Lighting, S.Players, S.StarterGui, S.SoundService, S.UserInputService, S.ReplicatedStorage

            local LP = Players.LocalPlayer

            local function safe(_, f) local ok = pcall(f); return ok end

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

            local function killPostFX()
                for _, e in ipairs(Lighting:GetChildren()) do
                    if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                        e.Enabled = false
                    end
                end
            end
            if CFG.postFXOff then killPostFX() end

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

            local function hideGeometry(inst)
                if not CFG.hide.geometry then return end
                if inst:IsA("BasePart") then
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

            local function cull(inst)
                if not inst or inst.Parent == nil then return end
                hideGeometry(inst)

                if CFG.kill.particles and (inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles")) then
                    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") then
                        inst.Lifetime = NumberRange.new(0)
                        if inst:IsA("ParticleEmitter") then inst.Rate = 0 end
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
        end)
    end
end)
SettingsTab:CreateButton("Toggle Combo Macro", "", function()
    if typeof(getgenv().ToggleMacroState) == "function" then
        getgenv().ToggleMacroState()
    end
end)

SettingsTab:CreateDropdown("Activation Key", getgenv().MacroConfig.Settings.ActivationKey, {"Z", "X", "C", "V", "E", "G", "F", "Q", "R", "T", "Y", "H"}, "", function(val)
    getgenv().MacroConfig.Settings.ActivationKey = val
end)

SettingsTab:CreateSwitch("Loop Combo", getgenv().MacroConfig.Settings.LoopCombo, "", function(state)
    getgenv().MacroConfig.Settings.LoopCombo = state
end)

SettingsTab:CreateDropdown("Aim Target Mode", getgenv().MacroConfig.Settings.AimTargetMode, {"ClosestPlayer", "Mouse"}, "", function(val)
    getgenv().MacroConfig.Settings.AimTargetMode = val
end)

SettingsTab:CreateSwitch("Aim Enemies", getgenv().MacroConfig.Settings.AimEnemies, "", function(state)
    getgenv().MacroConfig.Settings.AimEnemies = state
end)

SettingsTab:CreatePageTitle("Slient Soru Body")

SettingsTab:CreateDropdown("Slient Soru Key", getgenv().MacroConfig.Settings.AutoSoruKey, {"R", "LeftControl", "LeftAlt", "H", "K", "L", "B", "N", "M", "J", "U", "I", "O"}, "", function(val)
    getgenv().MacroConfig.Settings.AutoSoruKey = val
end)

SettingsTab:CreateSlider("Spam R Interval (ms)", 10, 500, getgenv().MacroConfig.Settings.AutoSoruRSpamMs, "", function(val)
    getgenv().MacroConfig.Settings.AutoSoruRSpamMs = val
end)

SettingsTab:CreatePageTitle("Auto Actions After Soru Body")
---------

SettingsTab:CreateSwitch("Use Skills After Soru", getgenv().MacroConfig.Settings.AutoSoruSkill, "", function(state)
    getgenv().MacroConfig.Settings.AutoSoruSkill = state
end)

SettingsTab:CreateMultiDropdown("Select Soru Skills", getgenv().MacroConfig.Settings.SoruSkills, {"Z", "X", "C", "V", "F", "T", "R"}, "", function(selected)
    getgenv().MacroConfig.Settings.SoruSkills = selected
end)

SettingsTab:CreateSlider("Skill Switch Delay (ms)", 0, 300, getgenv().MacroConfig.Settings.SoruSkillDelay * 1000, "", function(val)
    getgenv().MacroConfig.Settings.SoruSkillDelay = val / 1000
end)

SettingsTab:CreateSwitch("Use Main Combo After Soru", getgenv().MacroConfig.Settings.AutoSoruCombo, "", function(state)
    getgenv().MacroConfig.Settings.AutoSoruCombo = state
end)

SettingsTab:CreateSlider("Combo Start Delay (ms)", 0, 300, getgenv().MacroConfig.Settings.SoruComboDelay * 1000, "", function(val)
    getgenv().MacroConfig.Settings.SoruComboDelay = val / 1000
end)

SettingsTab:CreatePageTitle("Prediction Engine")

SettingsTab:CreateSwitch("Silent Aim", getgenv().MacroConfig.Settings.SilentAim, "", function(state)
    getgenv().MacroConfig.Settings.SilentAim = state
end)

SettingsTab:CreateSwitch("Draw Tracer", getgenv().MacroConfig.Settings.DrawTracer, "", function(state)
    getgenv().MacroConfig.Settings.DrawTracer = state
end)

SettingsTab:CreateSwitch("Prediction Aimbot", getgenv().MacroConfig.PredictionSettings.PredictionAimbot, "", function(state)
    getgenv().MacroConfig.PredictionSettings.PredictionAimbot = state
end)

SettingsTab:CreateSwitch("Prediction Soru", getgenv().MacroConfig.PredictionSettings.PredictionSoru, "", function(state)
    getgenv().MacroConfig.PredictionSettings.PredictionSoru = state
end)

SettingsTab:CreateSwitch("Prediction Slient Soru", getgenv().MacroConfig.PredictionSettings.PredictionSilentSoru, "", function(state)
    getgenv().MacroConfig.PredictionSettings.PredictionSilentSoru = state
end)

SettingsTab:CreateSlider("Max Target Distance", 100, 2000, getgenv().MacroConfig.PredictionSettings.MaxDistance, "", function(val)
    getgenv().MacroConfig.PredictionSettings.MaxDistance = val
end)

---------
local Keys = {"Z", "X", "C", "V", "F", "E", "Q"}
local Weapons = {"Melee", "Sword", "Gun", "Blox Fruit"}

for i = 1, 12 do
    local currentTab = i <= 6 and Combo1_6 or Combo7_12
    currentTab:CreatePageTitle("Combo Block " .. i)
    currentTab:CreateSwitch("Enable Block", getgenv().MacroConfig.ComboBlocks[i].Enabled, "", function(state)
        getgenv().MacroConfig.ComboBlocks[i].Enabled = state
    end)
    currentTab:CreateSwitch("Enable Equip", getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled, "", function(state)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.Enabled = state
    end)
    currentTab:CreateDropdown("Select Weapon", getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName, Weapons, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].EquipItem.ItemName = val
    end)
    currentTab:CreatePageSubTitle("Before Skill Settings")
    currentTab:CreateMultiDropdown("Before Skill Actions", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    currentTab:CreateSlider("Jump Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamCount = val
    end)
    currentTab:CreateSlider("Jump Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[2].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Click Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamCount = val
    end)
    currentTab:CreateSlider("Click Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BeforeSkill.Actions[3].SpamInterval = val / 1000
    end)
    currentTab:CreatePageSubTitle("Main Skill Action")
    currentTab:CreateDropdown("Skill Key", getgenv().MacroConfig.ComboBlocks[i].SkillAction.Button, Keys, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.Button = val
    end)
    currentTab:CreateSlider("Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].SkillAction.SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.SpamCount = val
    end)
    currentTab:CreateSlider("Hold Time (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].SkillAction.HoldTime * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.HoldTime = val / 1000
    end)
    currentTab:CreateSlider("Delay Time (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].SkillAction.DelayTime * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.DelayTime = val / 1000
    end)
    currentTab:CreateDropdown("Aim Mode", getgenv().MacroConfig.ComboBlocks[i].SkillAction.AimMode, {"Body", "Vector"}, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.AimMode = val
    end)
    
    local currentDir = "Ground"
    local currentDist = 0
    local function UpdateVector()
        local vec = Vector3.new(0,0,0)
        if currentDir == "Ground" then vec = Vector3.new(0, -currentDist, 0)
        elseif currentDir == "Sky" then vec = Vector3.new(0, currentDist, 0)
        elseif currentDir == "Left" then vec = Vector3.new(-currentDist, 0, 0)
        elseif currentDir == "Right" then vec = Vector3.new(currentDist, 0, 0)
        end
        getgenv().MacroConfig.ComboBlocks[i].SkillAction.VectorOffset = vec
    end
    currentTab:CreateDropdown("Vector Direction", "Ground", {"Ground", "Sky", "Left", "Right"}, "", function(val)
        currentDir = val
        UpdateVector()
    end)
    currentTab:CreateSlider("Vector Offset Distance", 0, 50, 0, "", function(val)
        currentDist = val
        UpdateVector()
    end)
    currentTab:CreatePageSubTitle("After Skill Settings")
    currentTab:CreateMultiDropdown("After Skill Actions", {}, {"Soru", "Jump", "Click"}, "", function(selected)
        for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
            act.Enabled = false
        end
        for _, selName in pairs(selected) do
            for _, act in ipairs(getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions) do
                if act.Action == selName then act.Enabled = true end
            end
        end
    end)
    currentTab:CreateSlider("Jump Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamCount = val
    end)
    currentTab:CreateSlider("Jump Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[2].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Click Spam Count", 1, 50, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamCount, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamCount = val
    end)
    currentTab:CreateSlider("Click Delay (ms)", 0, 1000, getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamInterval * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].AfterSkill.Actions[3].SpamInterval = val / 1000
    end)
    currentTab:CreateSlider("Block Cooldown (ms)", 0, 3000, getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter * 1000, "", function(val)
        getgenv().MacroConfig.ComboBlocks[i].BlockDelayAfter = val / 1000
    end)
end


---------
local TweenService = game:GetService("TweenService")
local guiName = "CapsuleStatusHub"

if CoreGui:FindFirstChild(guiName) then
    CoreGui[guiName]:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local Themes = {
    Dark = {
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        TextColor = Color3.fromRGB(255, 255, 255),
        TextGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 128, 128)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(211, 211, 211)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }),
        DividerColor = Color3.fromRGB(255, 255, 255),
        DividerTransparency = 0.5,
        StrokeGradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        })
    }
}

---------
local mainCapsule = Instance.new("Frame")
mainCapsule.Name = "MainCapsule"
mainCapsule.Size = UDim2.new(0, 360, 0, 45)

if getgenv().ShowComboUI == false then
    mainCapsule.Position = UDim2.new(0.5, -180, 0, -100)
    mainCapsule.Visible = false
else
    mainCapsule.Position = UDim2.new(0.5, -180, 0, -20)
    mainCapsule.Visible = true
end

mainCapsule.BackgroundColor3 = Themes.Dark.BackgroundColor
mainCapsule.BackgroundTransparency = Themes.Dark.BackgroundTransparency
---------
---------
mainCapsule.BorderSizePixel = 0
mainCapsule.Active = true
mainCapsule.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = mainCapsule

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Parent = mainCapsule

local strokeGradient = Instance.new("UIGradient")
strokeGradient.Color = Themes.Dark.StrokeGradient
strokeGradient.Parent = stroke

local divider = Instance.new("Frame")
divider.Name = "Divider"
divider.Size = UDim2.new(0, 1, 0.6, 0)
divider.Position = UDim2.new(0.5, 0, 0.2, 0)
divider.BackgroundColor3 = Themes.Dark.DividerColor
divider.BackgroundTransparency = Themes.Dark.DividerTransparency
divider.BorderSizePixel = 0
divider.Parent = mainCapsule

local divGrad = Instance.new("UIGradient")
divGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
})
divGrad.Rotation = 90
divGrad.Parent = divider

local function createLabel(name, pos, align)
    local lbl = Instance.new("TextLabel")
    lbl.Name = name
    lbl.Size = UDim2.new(0.5, -20, 1, 0)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = Themes.Dark.TextColor
    lbl.TextXAlignment = align
    lbl.Text = ""
    lbl.Parent = mainCapsule

    local txtGrad = Instance.new("UIGradient")
    txtGrad.Rotation = 90
    txtGrad.Color = Themes.Dark.TextGradient
    txtGrad.Parent = lbl

    return lbl
end

local executedLabel = createLabel("ExecutedLabel", UDim2.new(0, 15, 0, 0), Enum.TextXAlignment.Left)
local totalLabel = createLabel("TotalLabel", UDim2.new(0.5, 5, 0, 0), Enum.TextXAlignment.Right)

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainCapsule

local lastClickTime = 0
mainCapsule.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 0.8}):Play()
    end
end)

mainCapsule.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        TweenService:Create(uiScale, TweenInfo.new(0.1, Enum.EasingStyle.Sine), {Scale = 1}):Play()
    elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local currentTime = tick()
        if currentTime - lastClickTime <= 0.3 then
            getgenv().ComboTimeElapsed = 0
            local bounceTw = TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {Scale = 1.3})
            bounceTw:Play()
            bounceTw.Completed:Wait()
            TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
        else
            TweenService:Create(uiScale, TweenInfo.new(0.2, Enum.EasingStyle.Sine), {Scale = 1}):Play()
        end
        lastClickTime = currentTime
    end
end)

getgenv().ComboTimeElapsed = getgenv().ComboTimeElapsed or 0
getgenv().ComboIsActive = false

getgenv().BlinkComboUI = function()
    for i = 1, 2 do
        TweenService:Create(mainCapsule, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
        task.wait(0.15)
        TweenService:Create(mainCapsule, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundTransparency = Themes.Dark.BackgroundTransparency}):Play()
        task.wait(0.15)
    end
end

local lastRSpam = 0
RunService.RenderStepped:Connect(function(dt)
    strokeGradient.Rotation = (tick() * 45) % 360

    if getgenv().ComboIsActive then
        getgenv().ComboTimeElapsed = getgenv().ComboTimeElapsed + dt
    end
    
    executedLabel.Text = "Combo Timer:"
    totalLabel.Text = string.format("%.3fs", getgenv().ComboTimeElapsed)

    local config = getgenv().MacroConfig
    if config and config.Settings.AutoSoruActive then
        local targetPlayer, targetPart = GetTarget()
        if targetPart then
            local predPos = targetPart.Position
            if targetPlayer and config.PredictionSettings.PredictionSilentSoru then
                predPos = getPredictedPosition(targetPlayer) or targetPart.Position
            end
            
            getgenv().SoruSilentPos = predPos
            getgenv().SoruSilentTargetPart = targetPart

            local currentMs = tick() * 1000
            local targetMs = config.Settings.AutoSoruRSpamMs or 50
            if currentMs - lastRSpam >= targetMs then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.R, false, game)
                task.spawn(function()
                    task.wait(0.01)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.R, false, game)
                end)
                lastRSpam = currentMs
            end

            if check_in_cd() then
                config.Settings.AutoSoruActive = false
                getgenv().SoruSilentPos = nil
                getgenv().SoruSilentTargetPart = nil
            end
        else
            getgenv().SoruSilentPos = nil
            getgenv().SoruSilentTargetPart = nil
        end
    else
        getgenv().SoruSilentPos = nil
        getgenv().SoruSilentTargetPart = nil
    end
end)
---------
