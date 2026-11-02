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

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local Quests = require(ReplicatedStorage:WaitForChild("Quests"))
local GuideModule = require(ReplicatedStorage:WaitForChild("GuideModule"))
local NPCList = GuideModule.Data.NPCList
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")

local AutoFarmEnabled = false
local currentTween = nil
local noclipConnection = nil

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

local function bringMobs(mobName, centerCFrame)
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == mobName then
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and root then
                if (root.Position - centerCFrame.Position).Magnitude <= 320 then
                    root.CFrame = centerCFrame
                    root.CanCollide = false
                    root.Velocity = Vector3.zero
                    if hum.WalkSpeed ~= 0 then
                        hum.WalkSpeed = 0
                    end
                end
            end
        end
    end
end

local function equipBestWeapon()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return end

    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool:FindFirstChild("Combat")) then
            return
        end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool:FindFirstChild("Combat")) then
            char.Humanoid:EquipTool(tool)
            return
        end
    end

    local firstTool = backpack:FindFirstChildOfClass("Tool")
    if firstTool then
        char.Humanoid:EquipTool(firstTool)
    end
end

local function toCFrame(targetCFrame)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local dist = (targetCFrame.Position - hrp.Position).Magnitude
    if dist <= 12 then
        hrp.CFrame = targetCFrame
        return
    end

    local speed = 320
    local tweenTime = dist / speed
    local info = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)

    if currentTween then
        currentTween:Cancel()
    end

    currentTween = TweenService:Create(hrp, info, {CFrame = targetCFrame})
    currentTween:Play()

    local start = os.clock()
    while AutoFarmEnabled and (os.clock() - start) < (tweenTime + 0.3) do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then break end
        if (targetCFrame.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 12 then
            break
        end
        task.wait(0.05)
    end

    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

local function attackEnemy(enemy)
    local char = LocalPlayer.Character
    if not char then return end

    if not char:FindFirstChild("HasBuso") then
        pcall(function()
            CommF_:InvokeServer("Buso")
        end)
    end

    equipBestWeapon()

    local net = ReplicatedStorage:FindFirstChild("Modules")
    net = net and net:FindFirstChild("Net")
    if net then
        local regAttack = net:FindFirstChild("RE/RegisterAttack")
        local regHit = net:FindFirstChild("RE/RegisterHit")
        if regAttack then
            regAttack:FireServer(0)
        end
        if regHit and enemy and enemy:FindFirstChild("Head") and enemy:FindFirstChild("HumanoidRootPart") then
            regHit:FireServer(enemy.Head, {enemy.HumanoidRootPart})
        end
    end

    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.zero)
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
MainFrame.Size = UDim2.new(0, 270, 0, 190)
MainFrame.Position = UDim2.new(0.5, -135, 0.3, 0)
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
Title.Text = "AUTO FARM LEVEL"
Title.TextColor3 = Color3.fromRGB(255, 215, 110)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 48)
StatusLabel.Position = UDim2.new(0, 10, 0, 36)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Cấp độ: ...\nTrạng thái: Đang chờ bật"
StatusLabel.TextColor3 = Color3.fromRGB(200, 205, 220)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 11
StatusLabel.TextWrapped = true
StatusLabel.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(1, -30, 0, 45)
ToggleBtn.Position = UDim2.new(0, 15, 0, 95)
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
Footnote.Position = UDim2.new(0, 0, 0, 152)
Footnote.BackgroundTransparency = 1
Footnote.Text = "Tự dò nhiệm vụ & quái không cần tọa độ"
Footnote.TextColor3 = Color3.fromRGB(110, 115, 135)
Footnote.Font = Enum.Font.GothamMedium
Footnote.TextSize = 9
Footnote.Parent = MainFrame

local function setNoclip(enabled)
    if enabled then
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if AutoFarmEnabled and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    setNoclip(AutoFarmEnabled)

    if AutoFarmEnabled then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 85)
        ToggleBtn.Text = "AUTO FARM: ON"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 45, 45)
        ToggleBtn.Text = "AUTO FARM: OFF"
        StatusLabel.Text = "Cấp độ: " .. tostring(getPlayerLevel()) .. "\nTrạng thái: ĐÃ DỪNG"
        if currentTween then
            currentTween:Cancel()
            currentTween = nil
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoFarmEnabled then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") or char.Humanoid.Health <= 0 then
                    StatusLabel.Text = "Đang chờ nhân vật hồi sinh..."
                    task.wait(1)
                    return
                end

                local currentLevel = getPlayerLevel()
                local qData = getQuestData()

                if not qData then
                    StatusLabel.Text = "Lv." .. currentLevel .. " | Không tìm thấy nhiệm vụ!"
                    return
                end

                if not hasClaimedQuest() then
                    StatusLabel.Text = "Lv." .. currentLevel .. " | Bay nhận Q: " .. tostring(qData.QuestId)
                    if qData.NpcCFrame then
                        toCFrame(qData.NpcCFrame + Vector3.new(0, 4, 3))
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
                        StatusLabel.Text = "Lv." .. currentLevel .. " | Đang đánh: " .. tostring(mobName)
                        local mobCF = mob.HumanoidRootPart.CFrame
                        bringMobs(mobName, mobCF)

                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        hrp.CFrame = CFrame.new(mobCF.Position + Vector3.new(0, 20, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                        hrp.Velocity = Vector3.zero

                        attackEnemy(mob)
                    else
                        local spawnPos = getMobSpawnPosition(mobName)
                        if spawnPos then
                            StatusLabel.Text = "Lv." .. currentLevel .. " | Đợi quái: " .. tostring(mobName)
                            toCFrame(CFrame.new(spawnPos + Vector3.new(0, 25, 0)))
                        else
                            StatusLabel.Text = "Lv." .. currentLevel .. " | Tìm vị trí quái: " .. tostring(mobName)
                        end
                    end
                end
            end)
        end
    end
end)
