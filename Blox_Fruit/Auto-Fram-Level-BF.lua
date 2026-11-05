--[[ VỊ TRÍ ĐẶC BIỆT 
Gương Big Mirror / Cake Prince / Dough King: CFrame.new(-2711, 63, -12896) 
Temple of Time / Cổng V4: CFrame.new(4050.31, 5, -1814.12) and CFrame.new(61726.28, 528, -1559.27)
Khu vực Sanguine Art / Tiki Outpost / Đảo ngầm: CFrame.new(11427, -2157, 9726) and CFrame.new(11256, -2138, 9888)
Bia mộ Haunted Castle (CDK & Soul Guitar): CFrame.new(-8800, 178, 6033) and CFrame.new(-8654, 140, 6167)
Trạm dừng Boat Castle & Circle Island: CFrame.new(-5050, 322, -2960) and CFrame.new(-6440, 250, -4500)
]]
repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer:FindFirstChild("Data")

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local TWEEN_SPEED = 300
local FARM_HEIGHT = 15
local ATTACK_DIST = 65

local isWorld1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
local isWorld2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
local isWorld3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

local Quests = require(ReplicatedStorage:WaitForChild("Quests"))
local GuideModule = require(ReplicatedStorage:WaitForChild("GuideModule"))
local NPCList = GuideModule.Data.NPCList
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

local net = ReplicatedStorage:FindFirstChild("Modules")
net = net and net:FindFirstChild("Net")
local reRegisterAttack = net and net:FindFirstChild("RE/RegisterAttack")
local reRegisterHit = net and net:FindFirstChild("RE/RegisterHit")

local AutoFarmEnabled = false

pcall(function()
    setscriptable(LocalPlayer, "SimulationRadius", true)
    sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
end)

local function getHUI()
    if gethui then return gethui() end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
    return LocalPlayer.PlayerGui
end

local function getPlayerLevel()
    local ok, lvl = pcall(function()
        return LocalPlayer.Data.Level.Value
    end)
    return (ok and tonumber(lvl)) or 1
end

local function getCurrentWorldName()
    if isWorld1 then return "World 1" end
    if isWorld2 then return "World 2" end
    if isWorld3 then return "World 3" end
    return "Unknown"
end

local TweenController = {
    Playing = false,
    Hovering = false,
    HoverCFrame = nil,
    HeartbeatConn = nil,
    CollisionParts = {},
    CollisionConn = nil
}

local function prepareNoclip()
    local character = LocalPlayer.Character
    if not character then return end

    if TweenController.CollisionConn then
        TweenController.CollisionConn:Disconnect()
        TweenController.CollisionConn = nil
    end

    table.clear(TweenController.CollisionParts)

    for _, desc in ipairs(character:GetDescendants()) do
        if desc:IsA("BasePart") then
            table.insert(TweenController.CollisionParts, desc)
            desc.CanCollide = false
        end
    end

    TweenController.CollisionConn = character.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(TweenController.CollisionParts, part)
            part.CanCollide = false
        end
    end)
end

local function stopTween(keepHover)
    if TweenController.HeartbeatConn then
        pcall(function() TweenController.HeartbeatConn:Disconnect() end)
        TweenController.HeartbeatConn = nil
    end

    TweenController.Playing = false

    if not keepHover then
        TweenController.Hovering = false
        TweenController.HoverCFrame = nil
    end

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local muse = hrp:FindFirstChild("muse")
            if muse then muse:Destroy() end
        end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
    end
end

RunService.Stepped:Connect(function()
    if not AutoFarmEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if TweenController.Playing or TweenController.Hovering then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        if TweenController.Hovering and TweenController.HoverCFrame and not TweenController.Playing then
            hrp.CFrame = TweenController.HoverCFrame
        end

        for i = #TweenController.CollisionParts, 1, -1 do
            local part = TweenController.CollisionParts[i]
            if part and part.Parent then
                if part.CanCollide then part.CanCollide = false end
            else
                table.remove(TweenController.CollisionParts, i)
            end
        end
    end
end)

local function tweenTo(targetCFrame, speedOverride)
    if not targetCFrame then return end
    local targetPos = (typeof(targetCFrame) == "CFrame" and targetCFrame.Position) or targetCFrame
    local finalCFrame = (typeof(targetCFrame) == "CFrame" and targetCFrame) or CFrame.new(targetPos)

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    stopTween(false)
    prepareNoclip()
    hum.AutoRotate = false

    local muse = hrp:FindFirstChild("muse")
    if not muse then
        muse = Instance.new("BodyVelocity")
        muse.Name = "muse"
        muse.MaxForce = Vector3.new(0, math.huge, 0)
        muse.Velocity = Vector3.zero
        muse.Parent = hrp
    end

    TweenController.Playing = true
    local speed = speedOverride or TWEEN_SPEED

    local finished = false
    TweenController.HeartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
        if not TweenController.Playing or not hrp.Parent then
            stopTween(false)
            finished = true
            return
        end

        local currentPos = hrp.Position
        local delta = targetPos - currentPos
        local dist = delta.Magnitude

        local currentSpeed = speed
        if dist < 18 then
            currentSpeed = 35
        end

        local stepDist = currentSpeed * math.min(deltaTime, 0.07)

        if dist <= math.max(stepDist, 1.8) then
            hrp.CFrame = finalCFrame
            TweenController.Hovering = true
            TweenController.HoverCFrame = finalCFrame
            stopTween(true)
            finished = true
            return
        end

        local nextPos = currentPos + (delta.Unit * stepDist)
        hrp.CFrame = CFrame.new(nextPos, targetPos)
    end)

    while not finished and TweenController.Playing and AutoFarmEnabled do
        task.wait(0.05)
    end
end

local CombatController = {
    M1Combo = 0,
    ComboDebounce = 0,
    Debounce = 0
}

local function getBladeHits(char, attackDist)
    local hits = {}
    local myPos = char:GetPivot().Position
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return hits end

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and root then
            if (myPos - root.Position).Magnitude <= attackDist then
                table.insert(hits, {enemy, root})
            end
        end
    end
    return hits
end

local function executeFastAttack()
    local char = LocalPlayer.Character
    if not char then return end

    local tool = char:FindFirstChildOfClass("Tool")
    if not tool or (tool.ToolTip ~= "Melee" and tool.ToolTip ~= "Sword") then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") and (t.ToolTip == "Melee" or t.ToolTip == "Sword") then
                    char.Humanoid:EquipTool(t)
                    tool = t
                    break
                end
            end
        end
    end

    if not char:FindFirstChild("HasBuso") then
        pcall(function() CommF_:InvokeServer("Buso") end)
    end

    if (tick() - CombatController.ComboDebounce) <= 0.01 then
        CombatController.M1Combo = (CombatController.M1Combo >= 2 and 1) or (CombatController.M1Combo + 1)
    else
        CombatController.M1Combo = 1
    end
    CombatController.ComboDebounce = tick()

    local bladeHits = getBladeHits(char, ATTACK_DIST)

    if #bladeHits > 0 and reRegisterAttack and reRegisterHit then
        local primaryTarget = bladeHits[1][2]
        reRegisterAttack:FireServer(CombatController.M1Combo)
        reRegisterHit:FireServer(primaryTarget, bladeHits)
    else
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.zero)
    end
end

local function bringMobs(mobName, centerCFrame)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == mobName then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart

            if hum and hum.Health > 0 and root then
                if (root.Position - centerCFrame.Position).Magnitude <= 350 then
                    for _, part in ipairs(mob:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end

                    root.AssemblyLinearVelocity = Vector3.zero
                    root.AssemblyAngularVelocity = Vector3.zero
                    hum.WalkSpeed = 0

                    local bv = root:FindFirstChild("FarmingVelocity")
                    if not bv then
                        bv = Instance.new("BodyVelocity")
                        bv.Name = "FarmingVelocity"
                        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
                        bv.Velocity = Vector3.zero
                        bv.Parent = root
                    end

                    root.CFrame = centerCFrame
                end
            end
        end
    end
end

local function getMobSpawnPosition(mobName)
    if not mobName then return nil end

    local worldOrigin = workspace:FindFirstChild("_WorldOrigin")
    local enemySpawns = worldOrigin and worldOrigin:FindFirstChild("EnemySpawns")
    if enemySpawns then
        for _, child in ipairs(enemySpawns:GetChildren()) do
            if child.Name:find(mobName, 1, true) then
                if child:IsA("BasePart") then
                    return child.Position
                elseif child:IsA("Model") then
                    return child:GetPivot().Position
                end
            end
        end
    end

    local fortFolder = ReplicatedStorage:FindFirstChild("FortBuilderReplicatedSpawnPositionsFolder")
    if fortFolder then
        local child = fortFolder:FindFirstChild(mobName)
        if child then
            if child:IsA("BasePart") then
                return child.Position
            elseif child:IsA("Model") then
                return child:GetPivot().Position
            end
        end
    end

    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") then
                return mob.HumanoidRootPart.Position
            end
        end
    end

    return nil
end

local function getQuestData()
    local level = getPlayerLevel()
    local team = (LocalPlayer.Team and LocalPlayer.Team.Name) or "Pirates"
    local isLowLevel = level < 10
    local lowLevelFilter = isLowLevel and (team == "Marines" and "trainee" or "bandit")

    local bestQuestId = nil
    local bestQuestList = nil
    local maxLevelReq = -1

    for questId, qList in pairs(Quests) do
        if questId ~= "BartiloQuest" and questId ~= "CitizenQuest" and questId ~= "ImpelQuest" then
            local firstSub = qList[1]
            if firstSub and firstSub.LevelReq and firstSub.LevelReq <= level then
                local matches = true
                if lowLevelFilter then
                    matches = false
                    for mKey in pairs(firstSub.Task or {}) do
                        if tostring(mKey):lower():find(lowLevelFilter, 1, true) then
                            matches = true
                            break
                        end
                    end
                end

                if matches and firstSub.LevelReq > maxLevelReq then
                    maxLevelReq = firstSub.LevelReq
                    bestQuestId = questId
                    bestQuestList = qList
                end
            end
        end
    end

    if not bestQuestList then return nil end

    local subIndex = 1
    for i, subQuest in ipairs(bestQuestList) do
        if subQuest and subQuest.LevelReq and subQuest.LevelReq <= level then
            subIndex = i
        end
    end

    local targetSub = bestQuestList[subIndex] or bestQuestList[#bestQuestList]
    local targetMob = nil
    for mName in pairs(targetSub.Task or {}) do
        targetMob = mName
        break
    end

    local targetNpcCF = nil
    local minDistance = math.huge
    local mobPos = getMobSpawnPosition(targetMob)
    local char = LocalPlayer.Character
    local charPos = (char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position) or Vector3.zero
    local refPos = mobPos or charPos

    for npcInstance, npcInfo in pairs(NPCList) do
        if npcInfo and npcInfo.Levels and table.find(npcInfo.Levels, targetSub.LevelReq) then
            local cf = nil
            if typeof(npcInstance) == "Instance" then
                if npcInstance:IsA("BasePart") then
                    cf = npcInstance.CFrame
                elseif npcInstance:IsA("Model") then
                    cf = npcInstance:GetPivot() or (npcInstance.PrimaryPart and npcInstance.PrimaryPart.CFrame)
                end
            end
            if cf then
                local dist = (cf.Position - refPos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    targetNpcCF = cf
                end
            end
        end
    end

    return {
        QuestId = bestQuestId,
        SubIndex = subIndex,
        MobName = targetMob,
        NpcCFrame = targetNpcCF,
        LevelReq = targetSub.LevelReq
    }
end

local function hasClaimedQuest()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return false end

    local tracked = playerGui:FindFirstChild("TrackedQuestFrame")
    if tracked and tracked.Enabled and tracked:FindFirstChild("Frame") and tracked.Frame.Visible then
        return true
    end

    local main = playerGui:FindFirstChild("Main")
    if main then
        local quest = main:FindFirstChild("Quest")
        if quest and quest.Visible and quest:FindFirstChild("Container") then
            local titleObj = quest.Container:FindFirstChild("QuestTitle")
            local title = titleObj and titleObj:FindFirstChild("Title")
            if title and title.Text and title.Text ~= "" and title.Text ~= "QUEST" then
                return true
            end
        end
    end

    return false
end

local function getTargetMob(mobName)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = (hrp and hrp.Position) or Vector3.zero

    local nearestMob = nil
    local minDistance = math.huge

    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == mobName then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                local dist = (root.Position - myPos).Magnitude
                if dist < minDistance then
                    minDistance = dist
                    nearestMob = mob
                end
            end
        end
    end

    return nearestMob
end

local function checkWorldHop(currentLevel)
    if isWorld1 and currentLevel >= 700 then
        pcall(function() CommF_:InvokeServer("TravelDressrosa") end)
        task.wait(3)
        pcall(function() TeleportService:Teleport(4442272183, LocalPlayer) end)
        return true
    elseif isWorld2 and currentLevel >= 1500 then
        pcall(function() CommF_:InvokeServer("TravelZou") end)
        task.wait(3)
        pcall(function() TeleportService:Teleport(7449423635, LocalPlayer) end)
        return true
    end
    return false
end

local parentGui = getHUI()
local oldGui = parentGui:FindFirstChild("AutoFarmLevelMenu")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmLevelMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = parentGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 205)
MainFrame.Position = UDim2.new(0.5, -140, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 29)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 190, 60)
Stroke.Thickness = 1.2
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 32)
Title.BackgroundTransparency = 1
Title.Text = "BLOX FRUITS | AUTO FARM LEVEL"
Title.TextColor3 = Color3.fromRGB(255, 215, 110)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 58)
StatusLabel.Position = UDim2.new(0, 10, 0, 34)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Khu vực: " .. getCurrentWorldName() .. " | Cấp độ: " .. tostring(getPlayerLevel()) .. "\nTrạng thái: Đang chờ bật"
StatusLabel.TextColor3 = Color3.fromRGB(200, 205, 220)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(1, -30, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
ToggleBtn.Text = "AUTO FARM: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 13
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local Footnote = Instance.new("TextLabel")
Footnote.Size = UDim2.new(1, 0, 0, 20)
Footnote.Position = UDim2.new(0, 0, 0, 165)
Footnote.BackgroundTransparency = 1
Footnote.Text = "Tốc độ: " .. tostring(TWEEN_SPEED) .. " studs/s | Đánh Fast Attack"
Footnote.TextColor3 = Color3.fromRGB(110, 115, 135)
Footnote.Font = Enum.Font.GothamMedium
Footnote.TextSize = 9
Footnote.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled

    if AutoFarmEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 85)
        ToggleBtn.Text = "AUTO FARM: ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
        ToggleBtn.Text = "AUTO FARM: OFF"
        StatusLabel.Text = "Khu vực: " .. getCurrentWorldName() .. " | Cấp: " .. tostring(getPlayerLevel()) .. "\nTrạng thái: ĐÃ DỪNG"
        stopTween(false)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") or char.Humanoid.Health <= 0 then
                    StatusLabel.Text = "Đang chờ hồi sinh..."
                    stopTween(false)
                    task.wait(1)
                    return
                end

                local currentLevel = getPlayerLevel()

                if checkWorldHop(currentLevel) then
                    StatusLabel.Text = "Lv." .. currentLevel .. " -> Đang chuyển World..."
                    stopTween(false)
                    task.wait(5)
                    return
                end

                local qData = getQuestData()
                if not qData then
                    StatusLabel.Text = "Lv." .. currentLevel .. " | Không có nhiệm vụ phù hợp!"
                    return
                end

                if not hasClaimedQuest() then
                    StatusLabel.Text = "Lv." .. currentLevel .. " [" .. getCurrentWorldName() .. "]\nBay nhận Q: " .. tostring(qData.QuestId)
                    if qData.NpcCFrame then
                        tweenTo(qData.NpcCFrame + Vector3.new(0, 4, 3))
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and (hrp.Position - qData.NpcCFrame.Position).Magnitude <= 18 then
                            task.wait(0.3)
                            CommF_:InvokeServer("StartQuest", qData.QuestId, qData.SubIndex)
                            task.wait(0.5)
                        end
                    end
                else
                    local mobName = qData.MobName
                    local mob = getTargetMob(mobName)

                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        local maxSuffix = (isWorld3 and currentLevel >= 2550 and " [MAX LV]") or ""
                        StatusLabel.Text = "Lv." .. currentLevel .. maxSuffix .. " [" .. getCurrentWorldName() .. "]\nFast Attack: " .. tostring(mobName)

                        local mobCF = mob.HumanoidRootPart.CFrame
                        bringMobs(mobName, mobCF)

                        local hoverCF = CFrame.new(mobCF.Position + Vector3.new(0, FARM_HEIGHT, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                        local hrp = LocalPlayer.Character.HumanoidRootPart

                        if (hrp.Position - hoverCF.Position).Magnitude > 25 then
                            tweenTo(hoverCF)
                        else
                            TweenController.Hovering = true
                            TweenController.HoverCFrame = hoverCF
                        end

                        executeFastAttack()
                    else
                        local spawnPos = getMobSpawnPosition(mobName)
                        if spawnPos then
                            StatusLabel.Text = "Lv." .. currentLevel .. " [" .. getCurrentWorldName() .. "]\nĐợi quái hồi sinh: " .. tostring(mobName)
                            tweenTo(CFrame.new(spawnPos + Vector3.new(0, 25, 0)))
                        else
                            StatusLabel.Text = "Lv." .. currentLevel .. " | Tìm vị trí quái: " .. tostring(mobName)
                        end
                    end
                end
            end)
        end
    end
end)
