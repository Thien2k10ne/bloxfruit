--[[
    MEYY HUB - KAITUN DUNGEON - SCRIPT COMPLETO DESCIFRADO (100% AUTOCONTENIDO)
    ------------------------------------------------------------------
    - Extraido del servidor de meyyhub con tu key (naa-21ETAU5C) y tu HWID.
    - Sin autenticacion, sin anti-tamper, sin checks de key: codigo puro.
    - SIN DEPENDENCIAS EXTERNAS: los modulos que antes se descargaban de
      pastefy estan incrustados dentro (buscar "[INLINE" para verlos).
    - Funciones: auto dungeon (join hub, attack boss/props, bring mobs, race click v3/v4, Buso auto, join raid)
    - Para usarlo: pega/ejecuta este archivo completo en tu executor.
]]

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end
if game.Workspace then
    repeat task.wait() until game.Workspace:FindFirstChildOfClass("Part") or task.wait(1)
end



_G.RaceClickAutov3 = true
_G.RaceClickAutov4 = true
_G.BusoAuto = true
local noclipEnabled = true

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local plr = Players.LocalPlayer

local function Useskills(key)
    VIM:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, key, false, game)
end
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)
task.spawn(function()
    while task.wait(0.5) do
        if _G.RaceClickAutov3 then
            pcall(function()
                replicated.Remotes.CommE:FireServer("ActivateAbility")
            end)
            task.wait(30)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if _G.RaceClickAutov4 then
            pcall(function()
                local char = plr.Character
                if char and char:FindFirstChild("RaceEnergy") then
                    if char.RaceEnergy.Value >= 1 then 
                        Useskills("Y")
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    while true do
        pcall(function()
            local dungeonShared = replicated:FindFirstChild("DungeonShared")
            if dungeonShared then
                local returnToHub = dungeonShared:FindFirstChild("ReturnToHub")
                if returnToHub then
                    returnToHub:FireServer()
                end
            end
        end)
        task.wait(5)
    end
end)
task.spawn(function()
    while task.wait(1) do
        if _G.BusoAuto then
            pcall(function()
                if plr.Character and not plr.Character:FindFirstChild("HasBuso") then
                    replicated.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled then
        local char = plr.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

task.wait(5) 
local function JoinToPad()
local CFG = getgenv().Config
local DungeonHubID = 73902483975735
Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name))
    end
end})
local TeleportService = Services.TeleportService
local Players = Services.Players
local CoreGui = Services.CoreGui
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService
local TweenService = Services.TweenService
local HttpService = Services.HttpService
local plr = Players.LocalPlayer

local Themes = {
    Dark = {
        Background = Color3.fromRGB(20, 20, 20),
        BackgroundTrans = 0.4,
        Stroke = Color3.fromRGB(150, 150, 150),
        TextLight = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(100, 100, 100),
        Warning = Color3.fromRGB(255, 80, 80)
    }
}
local UI_Elements = {}

local function GetSyncTargets()
    local targets = {}
    local config = getgenv().Config
    if not config then return targets end

    if config["Account Join Raid"] and config["Account Join Raid"].Users then
        for _, v in pairs(config["Account Join Raid"].Users) do
            if v and tostring(v) ~= "" then targets[string.lower(tostring(v))] = true end
        end
    end
    
    if config["Account Join"] and config["Account Join"].Users then
        for _, v in pairs(config["Account Join"].Users) do
            if v and tostring(v) ~= "" then targets[string.lower(tostring(v))] = true end
        end
    end
    
    return targets
end


if game.PlaceId ~= DungeonHubID then
    local function JoinTeam()
        local remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
        if remote then
            remote:InvokeServer("SetTeam", "Pirates")
        end
    end

    local function AutoJoinDungeon()
        task.spawn(function()
            repeat 
                JoinTeam()
                task.wait(0.5)
            until (plr.Team ~= nil and tostring(plr.Team) ~= "Neutral")
            
            task.wait(1.5)
            
            local dungeonRemote = ReplicatedStorage:WaitForChild("Modules")
                :WaitForChild("Net")
                :WaitForChild("RF/DungeonNPCNetworkFunction")
            
            if dungeonRemote then
                local args = {
                    "TeleportToDungeonHub",
                    false
                }
                dungeonRemote:InvokeServer(unpack(args))
            end
        end)
    end

    task.spawn(function()
        while task.wait(1) do
            if plr.Team == nil or tostring(plr.Team) == "Neutral" then
                JoinTeam()
            else
                break 
            end
        end
    end)

    AutoJoinDungeon()

else
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
        repeat task.wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    end

    local g = Instance.new("ScreenGui")
    g.Name = "Naa_UI_Dark_Theme_Clean_" .. math.random(100, 999)
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = plr:WaitForChild("PlayerGui") end
    getgenv().kc = g

    local m = Instance.new("Frame", g)
    m.Name = "Main"
    m.BackgroundColor3 = Themes.Dark.Background
    m.BackgroundTransparency = Themes.Dark.BackgroundTrans
    m.Position = UDim2.new(0.5, 0, 0, -150)
    m.Size = UDim2.new(0, 320, 0, 100)
    m.AnchorPoint = Vector2.new(0.5, 0)

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.0
    u.Color = Color3.new(1, 1, 1)
    local e = Instance.new("UIGradient", u)
    table.insert(UI_Elements, {Element = e, Type = "Rotation_Color"})

    local bgGradient = Instance.new("UIGradient", m)
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })

    local statusGradients = {}

    local function CreateStatusLabel(name, pos, text)
        local label = Instance.new("TextLabel", m)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = 14
        label.TextColor3 = Color3.new(1, 1, 1)
        
        local txtStroke = Instance.new("UIStroke", label)
        txtStroke.Thickness = 0.5
        txtStroke.Color = Themes.Dark.Background
        
        local txtGradient = Instance.new("UIGradient", label)
        table.insert(statusGradients, txtGradient)
        return label, txtGradient
    end

    _G.StatusItemLabel, _G.TopInfoGradient = CreateStatusLabel("TopInfo", 10, "Meyy Hub - Kaitun Dungeon")
    _G.StatusFarmLabel, _G.FarmGradient = CreateStatusLabel("StatusFarm", 35, "Status Farm: N/A")
    _G.StatusMobLabel, _G.MobGradient = CreateStatusLabel("StatusMob", 60, "Farm Mob: N/A")

    local creditLabel = Instance.new("TextLabel", m)
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(0, 50, 0, 15)
    creditLabel.Position = UDim2.new(1, -10, 1, -5)
    creditLabel.AnchorPoint = Vector2.new(1, 1)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.Text = "by Meyy Hub"
    creditLabel.TextSize = 10
    creditLabel.TextColor3 = Themes.Dark.Stroke
    creditLabel.TextXAlignment = Enum.TextXAlignment.Right

    local lastFarmText = ""
    local lastMobText = ""

    function _G.SetFarmStatus(text)
        if text ~= lastFarmText then
            lastFarmText = text
            _G.StatusFarmLabel.Text = text
        end
    end

    function _G.SetMobStatus(text)
        if text ~= lastMobText then
            lastMobText = text
            _G.StatusMobLabel.Text = text
        end
    end

    local r = 0
    task.spawn(function()
        while true do
            local delta = RunService.RenderStepped:Wait()
            r = (r + 1.5) % 360
            
            local c1, c2 = Themes.Dark.TextDark, Themes.Dark.TextLight
            local colorSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1), 
                ColorSequenceKeypoint.new(0.5, c2), 
                ColorSequenceKeypoint.new(1, c1)
            })

            for _, item in ipairs(UI_Elements) do
                if item.Type == "Rotation" then
                    item.Element.Rotation = r
                elseif item.Type == "Rotation_Color" then
                    item.Element.Rotation = r
                    item.Element.Color = colorSeq
                end
            end
            
            for _, grad in ipairs(statusGradients) do
                grad.Rotation = r
                grad.Color = colorSeq
            end
            bgGradient.Offset = Vector2.new(math.sin(tick() * 1.5) * 0.3, 0)
        end
    end)

    TweenService:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    _G.AccjoinRaid = false
    _G.AccountJoin = false
    _G.StartDuggeon = false
    _G.FoundDungeon = nil
    
    local DungeonRadius = 25 
    local HeightOffset = Vector3.new(0, 100, 0) 
    local WaitingSpot = Vector3.new(-360, 232, -350)

    local Dungeons = {
        {name = "Dungeon 1", padName = "DUNGEON_TELEPORTER3", center = Vector3.new(-487.545, 232.758, -433.559)},-- admin bị ngu. rõ là pad đầu tiên nhưng remote là dungeon 3 dcm
        {name = "Dungeon 2", padName = "DUNGEON_TELEPORTER2", center = Vector3.new(-360.278, 232.758, -447.755)},
        {name = "Dungeon 3", padName = "DUNGEON_TELEPORTER1", center = Vector3.new(-231.965, 232.758, -433.251)},-- pad 3 lại là pad 1 dcm admin khótt
    }

    local function CreatePlatform(pos)
        local pName = "Meyy_Platform_AntiFall"
        local old = workspace:FindFirstChild(pName)
        if old then old:Destroy() end
        local p = Instance.new("Part")
        p.Name = pName
        p.Size = Vector3.new(20, 1, 20)
        p.CFrame = CFrame.new(pos - Vector3.new(0, 3.5, 0))
        p.Anchored = true
        p.Transparency = 1
        p.CanCollide = true
        p.Parent = workspace
    end

local MoveConnection = nil
    local targetCFrame = nil
    local targetAttachment = nil
    local rootAttachment = nil
    local alignPosition = nil
    local isAligningY = false

    local function DungDiChuyen()
        if not _G.ChoPhepDiChuyen and not MoveConnection and (not alignPosition or not alignPosition.Enabled) then
            return
        end

        _G.ChoPhepDiChuyen = false
        targetCFrame = nil
        
        if MoveConnection then
            MoveConnection:Disconnect()
            MoveConnection = nil
        end
        
        if alignPosition then
            alignPosition.Enabled = false
        end
        
        local character = plr.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")
            
            if humanoid then
                local isBoat = humanoid.Sit or (humanoid.SeatPart ~= nil)
                if not isBoat then
                    humanoid.PlatformStand = false
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
            
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    local function DiChuyenDen(mucTieuCFrame)
        if not mucTieuCFrame then DungDiChuyen() return end
        _G.ChoPhepDiChuyen = true
        targetCFrame = mucTieuCFrame
        local character = plr.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        if not hrp or not humanoid then return end
        
        local isBoat = humanoid.Sit or (humanoid.SeatPart ~= nil)
        if not isBoat then
            humanoid.PlatformStand = true
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end

        if not alignPosition or alignPosition.Parent ~= hrp then
            if alignPosition then alignPosition:Destroy() end
            if targetAttachment then targetAttachment:Destroy() end
            if rootAttachment and rootAttachment.Name == "MeyyRootAtt" then rootAttachment:Destroy() end
            
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
            alignPosition.MaxVelocity = _G.TocDoTween or 350
            alignPosition.Responsiveness = 200
            alignPosition.ApplyAtCenterOfMass = true
            alignPosition.Parent = hrp
        end

        local mapFolder = workspace:FindFirstChild("Map")
        local waterPlane = mapFolder and mapFolder:FindFirstChild("WaterBase-Plane")
        local waterLevel = waterPlane and (waterPlane.Position.Y + (waterPlane.Size.Y / 2)) or 20

        local initialTargetPos = mucTieuCFrame.Position
        if initialTargetPos.Y < waterLevel then
            initialTargetPos = Vector3.new(initialTargetPos.X, hrp.Position.Y, initialTargetPos.Z)
        end

        local diffY = math.abs(initialTargetPos.Y - hrp.Position.Y)
        if diffY > 25 then
            isAligningY = true
            targetAttachment.WorldPosition = Vector3.new(hrp.Position.X, initialTargetPos.Y, hrp.Position.Z)
            alignPosition.MaxVelocity = _G.TocDoTween or 350
        else
            isAligningY = false
            targetAttachment.WorldPosition = initialTargetPos
            alignPosition.MaxVelocity = _G.TocDoTween or 350
        end

        alignPosition.Enabled = true
        
        if not MoveConnection then
            MoveConnection = RunService.PostSimulation:Connect(function(dt)
                if not _G.ChoPhepDiChuyen or not targetCFrame then 
                    DungDiChuyen()
                    return 
                end
                
                local cChar = plr.Character
                if not cChar then return end
                local cHrp = cChar:FindFirstChild("HumanoidRootPart")
                if not cHrp then return end
                
                cHrp.AssemblyAngularVelocity = Vector3.zero
                
                local currentPos = cHrp.Position
                local rawFinalPos = targetCFrame.Position
                
                local currentWaterPlane = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBase-Plane")
                local currentWaterLevel = currentWaterPlane and (currentWaterPlane.Position.Y + (currentWaterPlane.Size.Y / 2)) or 20
                
                local finalPos = rawFinalPos
                if rawFinalPos.Y < currentWaterLevel then
                    finalPos = Vector3.new(rawFinalPos.X, currentPos.Y, rawFinalPos.Z)
                end
                
                if isAligningY then
                    local currentDiffY = math.abs(finalPos.Y - currentPos.Y)
                    if currentDiffY <= 3 then
                        isAligningY = false
                        targetAttachment.WorldPosition = finalPos
                        alignPosition.MaxVelocity = _G.TocDoTween or 350
                    else
                        targetAttachment.WorldPosition = Vector3.new(targetAttachment.WorldPosition.X, finalPos.Y, targetAttachment.WorldPosition.Z)
                        alignPosition.MaxVelocity = _G.TocDoTween or 350
                    end
                else
                    targetAttachment.WorldPosition = finalPos
                    alignPosition.MaxVelocity = _G.TocDoTween or 350
                end
                local distance = (finalPos - currentPos).Magnitude
                if distance < 3 then
                    DungDiChuyen()
                end
            end)
        end
    end

    local function tp(cframe)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            CreatePlatform(cframe.Position)
            DiChuyenDen(cframe)
        end
    end

    local function isDungeonSafe(center)
        local allowedUsers = GetSyncTargets()
        local teamInPad = 0
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pPos = player.Character.HumanoidRootPart.Position
                local dist = (Vector2.new(pPos.X, pPos.Z) - Vector2.new(center.X, center.Z)).Magnitude
                if dist <= DungeonRadius then
                    if not allowedUsers[string.lower(player.Name)] then return false, 0 end
                    teamInPad = teamInPad + 1
                end
            end
        end
        return true, teamInPad
    end



local function getServers(leaderName)
        if not leaderName or leaderName == "" then return {} end
        local folderPath = "Meyy_Hub_Dungeon"
        local filePath = folderPath .. "/API_JobID.json"
        
        if isfile and isfile(filePath) then
            local success, content = pcall(function() return readfile(filePath) end)
            if success and content and content ~= "" then
                local s, data = pcall(function() return HttpService:JSONDecode(content) end)
                if s and type(data) == "table" then
                    return data
                end
            end
        end
        return {}
    end

    local function saveServer(leaderName, targets)
        if not leaderName or leaderName == "" then return end
        local folderPath = "Meyy_Hub_Dungeon"
        local filePath = folderPath .. "/API_JobID.json"

        local myTeamInServer = {}
        for _, p in pairs(Players:GetPlayers()) do
            if targets[string.lower(tostring(p.Name))] then
                table.insert(myTeamInServer, string.lower(tostring(p.Name)))
            end
        end

        pcall(function()
            if not isfolder(folderPath) then
                makefolder(folderPath)
            end
            
            local dataToSave = {
                success = true,
                data = {
                    jobid = game.JobId,
                    placeid = game.PlaceId,
                    count = #Players:GetPlayers(),
                    players = myTeamInServer,
                    time = os.time()
                }
            }
            writefile(filePath, HttpService:JSONEncode(dataToSave))
        end)
    end

    local function EnsureTeamGathered()
        local targets = GetSyncTargets()
        local requiredCount = 0
        for _ in pairs(targets) do requiredCount = requiredCount + 1 end

        if requiredCount <= 1 then return true end
        
        local leaderName = ""
        local config = getgenv().Config
        if config and config["Account Join Raid"] and config["Account Join Raid"].Users and config["Account Join Raid"].Users[1] then
            leaderName = string.lower(tostring(config["Account Join Raid"].Users[1]))
        end
        
        task.spawn(function()
            while task.wait(3) do
                if leaderName ~= "" then
                    pcall(function()
                        saveServer(leaderName, targets)
                    end)
                end
            end
        end)
        
        while task.wait(0.5) do
            if leaderName == "" then
                _G.SetFarmStatus("Status: Waiting for Leader Name...")
                if config and config["Account Join Raid"] and config["Account Join Raid"].Users[1] then
                    leaderName = string.lower(tostring(config["Account Join Raid"].Users[1]))
                end
            else
                local physicallyGathered = 0
                local inServerCount = 0
                
                for _, p in pairs(Players:GetPlayers()) do
                    if targets[string.lower(tostring(p.Name))] then
                        inServerCount = inServerCount + 1
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local pPos = p.Character.HumanoidRootPart.Position
                            local dist = (Vector2.new(pPos.X, pPos.Z) - Vector2.new(WaitingSpot.X, WaitingSpot.Z)).Magnitude
                            if dist <= 30 then
                                physicallyGathered = physicallyGathered + 1
                            end
                        end
                    end
                end
                
                if physicallyGathered >= requiredCount then
                    _G.SetFarmStatus("Status: Team Gathered!")
                    task.wait(2)
                    return true
                end
                
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local myPos = plr.Character.HumanoidRootPart.Position
                    local myDist = (Vector2.new(myPos.X, myPos.Z) - Vector2.new(WaitingSpot.X, WaitingSpot.Z)).Magnitude
                    if myDist > 30 then
                        tp(CFrame.new(WaitingSpot + HeightOffset))
                    end
                end
if inServerCount < requiredCount then
                    _G.SetFarmStatus("Syncing Server: " .. inServerCount .. "/" .. requiredCount)
                    local data = getServers(leaderName)
                    local maxPlayers = Players.MaxPlayers
                    local validServers = {}
                    if data and data.success and type(data.data) == "table" then
                        local srv = data.data
                        local serverTime = srv.time or 0
                        if os.time() - serverTime <= 30 and srv.placeid == game.PlaceId then
                            local srvCount = srv.count or 0
                            table.insert(validServers, {
                                JobId = srv.jobid,
                                Count = srvCount
                            })
                        end
                    end
                    if #validServers > 0 then
                        for i, srv in ipairs(validServers) do
                            if srv.JobId ~= game.JobId then
                                _G.SetFarmStatus("Joining Leader: " .. srv.Count .. "/" .. maxPlayers)
                                local teleportSuccess = pcall(function()
                                    ReplicatedStorage:WaitForChild("__ServerBrowser"):InvokeServer("teleport", srv.JobId)
                                end)
                                
                                if teleportSuccess then
                                    task.wait(6)
                                end
                            end
                        end
                    end
                else
                    _G.SetFarmStatus("Gathering at spot: " .. physicallyGathered .. "/" .. requiredCount)
                end
            end
        end
    end

    
    
    local function JoinDungeonTeleport()
        while task.wait(0) do
            if _G.AccjoinRaid then
                local padStatus = {}
                for _, d in pairs(Dungeons) do
                    local count = 0
                    local amIHere = false
                    for _, p in pairs(Players:GetPlayers()) do
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local pPos = p.Character.HumanoidRootPart.Position
                            local dist = (Vector2.new(pPos.X, pPos.Z) - Vector2.new(d.center.X, d.center.Z)).Magnitude
                            if dist <= DungeonRadius then
                                count = count + 1
                                if p == plr then
                                    amIHere = true
                                end
                            end
                        end
                    end
                    padStatus[d.name] = {count = count, amIHere = amIHere, data = d}
                end

                if _G.FoundDungeon then
                    local currentD = nil
                    for _, d in pairs(Dungeons) do 
                        if d.name == _G.FoundDungeon then 
                            currentD = d 
                            break 
                        end 
                    end

if currentD then
                        if CFG["ModeJoin"] == "single" then
                            local mapFolder = workspace:FindFirstChild("Map")
                            local simHub = mapFolder and mapFolder:FindFirstChild("Simulation Hub")
                            local padsFolder = simHub and simHub:FindFirstChild("Pads")
                            local targetDiff = CFG["Select Difficulty"] or "Normal"
                            local padInst = padsFolder and padsFolder:FindFirstChild(currentD.padName)
                            local padDiff = padInst and padInst:GetAttribute("Difficulty")

                            if padDiff ~= targetDiff then
                                _G.SetFarmStatus("Status: Difficulty changed! Finding new pad...")
                                _G.FoundDungeon = nil
                                _G.StartDuggeon = false
                                tp(CFrame.new(WaitingSpot + HeightOffset))
                                task.wait(0.5)
                            else
                                local myPadInfo = padStatus[_G.FoundDungeon]
                                if myPadInfo then
                                    if myPadInfo.amIHere then
                                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                                        if hrp then
                                            local myDist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(currentD.center.X, currentD.center.Z)).Magnitude
                                            if myDist > DungeonRadius then
                                                tp(CFrame.new(currentD.center + HeightOffset))
                                            end
                                        end

                                        if myPadInfo.count <= 1 then
                                            _G.SetFarmStatus("Status: Abandoned! Finding new pad...")
                                            _G.FoundDungeon = nil
                                            _G.StartDuggeon = false
                                            task.wait(0.5)
                                        else
                                            local betterPad = nil
                                            local maxBetterCount = myPadInfo.count
                                            
                                            for dName, info in pairs(padStatus) do
                                                if dName ~= _G.FoundDungeon and info.count > 0 and info.count < 5 then
                                                    local otherPadInst = padsFolder and padsFolder:FindFirstChild(info.data.padName)
                                                    local otherDiff = otherPadInst and otherPadInst:GetAttribute("Difficulty")
                                                    if otherDiff == targetDiff and info.count > maxBetterCount then
                                                        maxBetterCount = info.count
                                                        betterPad = info.data
                                                    end
                                                end
                                            end

                                            if betterPad then
                                                _G.SetFarmStatus("Status: Switching to more crowded pad...")
                                                _G.FoundDungeon = betterPad.name
                                                tp(CFrame.new(betterPad.center + HeightOffset))
                                                task.wait(1)
                                                _G.StartDuggeon = true
                                            else
                                                _G.SetFarmStatus("Status: Secured! Waiting Start...")
                                            end
                                        end
                                    else
                                        if myPadInfo.count >= 5 then
                                            _G.SetFarmStatus("Status: Pad Full! Changing...")
                                            _G.FoundDungeon = nil
                                            _G.StartDuggeon = false
                                            task.wait(0.5)
                                        else
                                            tp(CFrame.new(currentD.center + HeightOffset))
                                        end
                                    end
                                end
                            end
                        else
                        local isSafe, _ = isDungeonSafe(currentD.center)
                        if not isSafe then
                            _G.SetFarmStatus("Status: Stranger detected! Changing...")
                            _G.FoundDungeon = nil
                            _G.StartDuggeon = false
                            task.wait(0.5)
                        else
                            local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local myDist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(currentD.center.X, currentD.center.Z)).Magnitude
                                if myDist > DungeonRadius then
                                    tp(CFrame.new(currentD.center + HeightOffset))
                                end
                            end
                        end
                        end
                    end
                end
                
                if not _G.FoundDungeon then
                    if CFG["ModeJoin"] == "single" then
                        local mapFolder = workspace:FindFirstChild("Map")
                        local simHub = mapFolder and mapFolder:FindFirstChild("Simulation Hub")
                        local padsFolder = simHub and simHub:FindFirstChild("Pads")
                        local targetDiff = CFG["Select Difficulty"] or "Normal"

                        local bestPad = nil
                        local maxPlayers = 0 
                        local emptyPad = nil
                        
                        for dName, info in pairs(padStatus) do
                            local padInst = padsFolder and padsFolder:FindFirstChild(info.data.padName)
                            local padDiff = padInst and padInst:GetAttribute("Difficulty")

                            if padDiff == targetDiff then
                                if info.count > 0 and info.count < 5 then
                                    if info.count > maxPlayers then
                                        maxPlayers = info.count
                                        bestPad = info.data
                                    end
                                elseif info.count == 0 and not emptyPad then
                                    emptyPad = info.data
                                end
                            end
                        end
                        
                        if bestPad then
                            _G.SetFarmStatus("Status: Entering " .. bestPad.name)
                            _G.FoundDungeon = bestPad.name
                            tp(CFrame.new(bestPad.center + HeightOffset))
                            task.wait(1)
                            _G.StartDuggeon = true
                        elseif emptyPad then
                            _G.SetFarmStatus("Status: Entering " .. emptyPad.name)
                            _G.FoundDungeon = emptyPad.name
                            tp(CFrame.new(emptyPad.center + HeightOffset))
                            task.wait(1)
                            _G.StartDuggeon = true
                        else
                            if not diffMatched then
                                _G.SetFarmStatus("Status: No matching difficulty! Waiting...")
                            else
                                _G.SetFarmStatus("Status: Pads full! Waiting...")
                            end
                            tp(CFrame.new(WaitingSpot + HeightOffset))
                        end
                    else
                        local foundAnyFree = false
                        for _, dungeon in pairs(Dungeons) do
                            local isSafe, count = isDungeonSafe(dungeon.center)
                            if isSafe and count == 0 then
                                foundAnyFree = true
                                _G.SetFarmStatus("Status: Entering " .. dungeon.name)
                                _G.FoundDungeon = dungeon.name
                                tp(CFrame.new(dungeon.center + HeightOffset))
                                task.wait(1)
                                _G.StartDuggeon = true
                                break
                            end
                        end
                        if not foundAnyFree then
                            _G.SetFarmStatus("Status: Pads full! Waiting area...")
                            tp(CFrame.new(WaitingSpot + HeightOffset))
                        end
                    end
                end
            end
        end
    end

    
    local function Accountteleaccjoin()
        local leaderName = ""
        if CFG["Account Join Raid"] and CFG["Account Join Raid"].Users and CFG["Account Join Raid"].Users[1] then
            leaderName = string.lower(CFG["Account Join Raid"].Users[1])
        end
        
        while task.wait(0.5) do
            if _G.AccountJoin then
                local leader = nil
                for _, v in pairs(Players:GetPlayers()) do
                    if string.lower(v.Name) == leaderName then 
                        leader = v 
                        break 
                    end
                end
                
                if leader and leader.Character and leader.Character:FindFirstChild("HumanoidRootPart") then
                    local leaderPos = leader.Character.HumanoidRootPart.Position
                    local currentLeaderPad = nil
                    for _, dungeon in pairs(Dungeons) do
                        local dist = (Vector2.new(leaderPos.X, leaderPos.Z) - Vector2.new(dungeon.center.X, dungeon.center.Z)).Magnitude
                        if dist <= DungeonRadius then 
                            currentLeaderPad = dungeon 
                            break 
                        end
                    end
                    if currentLeaderPad then
                        _G.FoundDungeon = currentLeaderPad.name
                        tp(leader.Character.HumanoidRootPart.CFrame)
                        _G.SetFarmStatus("Status: Joining pad")
                        task.wait(0.5)
                        _G.StartDuggeon = true
                    else
                        _G.SetFarmStatus("Status: Waiting Leader")
                        _G.StartDuggeon = false
                        tp(leader.Character.HumanoidRootPart.CFrame * CFrame.new(math.random(-2,2), 0, math.random(-2,2)))
                    end
                else
                    _G.SetFarmStatus("Status: Searching Leader...")
                end
            end
        end
    end

    
    local function Init()
        EnsureTeamGathered()

        local name = string.lower(plr.Name)
        local isLeader, isMember = false, false
        
        if CFG["Account Join Raid"] and CFG["Account Join Raid"].Users then
            for _, v in pairs(CFG["Account Join Raid"].Users) do 
                if string.lower(v) == name then isLeader = true end 
            end
        end
        if CFG["Account Join"] and CFG["Account Join"].Users then
            for _, v in pairs(CFG["Account Join"].Users) do 
                if string.lower(v) == name then isMember = true end 
            end
        end

        if isLeader then
            _G.SetMobStatus("Status: Raid Leader")
            _G.AccjoinRaid = true
            task.spawn(JoinDungeonTeleport)
        elseif isMember then
            _G.SetMobStatus("Status: Join Member")
            _G.AccountJoin = true
            task.spawn(Accountteleaccjoin)
        else
            _G.SetMobStatus("Status: Solo Mode")
            _G.AccjoinRaid = true 
            task.spawn(JoinDungeonTeleport)
        end
    end

    task.spawn(Init)

    
    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local mapFolder = workspace:FindFirstChild("Map")
                if not mapFolder then return end
                local simHub = mapFolder:FindFirstChild("Simulation Hub")
                if not simHub then return end
                local padsFolder = simHub:FindFirstChild("Pads")
                if not padsFolder then return end

                local configDiff = getgenv().Config and getgenv().Config["Select Difficulty"] and tostring(getgenv().Config["Select Difficulty"]) or "Normal"

                for _, d in pairs(Dungeons) do
                    local dist = (Vector2.new(hrp.Position.X, hrp.Position.Z) - Vector2.new(d.center.X, d.center.Z)).Magnitude
                    if dist <= 20 then
                        local pad = padsFolder:FindFirstChild(d.padName)
                        if pad and pad:FindFirstChild("DungeonSettingsChanged") then
                            local currentDiff = pad:GetAttribute("Difficulty")
                            
                            if currentDiff ~= configDiff then
                                pad.DungeonSettingsChanged:FireServer("Difficulty", configDiff)
                            elseif _G.StartDuggeon then
                                pad.DungeonSettingsChanged:FireServer("Start")
                                _G.StartDuggeon = false
                            end
                        end
                        break
                    end
                end
            end)
        end
    end)
end


while true do
    pcall(function()
        if game.PlaceId == DungeonHubID then
            local dungeonShared = game:GetService("ReplicatedStorage"):FindFirstChild("DungeonShared")
            if dungeonShared then
                local returnToHub = dungeonShared:FindFirstChild("ReturnToHub")
                if returnToHub then
                    returnToHub:FireServer()
                end
            end
        end
    end)
    task.wait(5)
end

end


if Workspace.Map:FindFirstChild("Dungeon") or #game:GetService("Players"):GetPlayers() < 5 then
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

    local function getMyPriorityList()
        local myName = string.lower(plr.Name)
        local myDisplayName = string.lower(plr.DisplayName)
        
        if getgenv().Config then
            for _, group in pairs(getgenv().Config) do
                if type(group) == "table" and group.Users then
                    for _, user in ipairs(group.Users) do
                        local configUser = string.lower(tostring(user))
                        if configUser == myName or configUser == myDisplayName then
                            if group.CardPriority then
                                return group.CardPriority
                            end
                            
                            local myRole = group.ToolTip or "Blox Fruit"
                            if myRole == "Sword" then
                                return {"HYPER!", "Sword", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Fruit", "Fruit M1 Speed"}
                            elseif myRole == "Melee" then
                                return {"HYPER!", "Melee", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Sword", "Fruit", "Fruit M1 Speed"}
                            else
                                return {"Fruit M1 Speed", "Fruit", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Sword", "HYPER!"}
                            end
                        end
                    end
                end
            end
        end
        return {"Fruit M1 Speed", "Fruit", "Fortress", "Lifesteal", "Armor", "Defense", "Race Meter", "Overflow", "Shadow", "All Cooldowns", "Melee", "Sword", "HYPER!"}
    end

    local function getBestBuff(offeredBuffs)
        local priorityList = getMyPriorityList()
        if not priorityList or #priorityList == 0 then return nil end
        
        for _, targetName in ipairs(priorityList) do
            local targetLower = string.lower(tostring(targetName))
            for _, buff in ipairs(offeredBuffs) do
                local buffName = buff.buffName or buff.Name or buff.key or tostring(buff)
                if string.find(string.lower(buffName), targetLower) then
                    return buffName
                end
            end
        end
        
        if offeredBuffs[1] then
            return offeredBuffs[1].buffName or offeredBuffs[1].Name or offeredBuffs[1].key or tostring(offeredBuffs[1])
        end
        return nil
    end

    getgenv()._ourBuffCallback = function(offeredBuffs)
        local bestBuff = getBestBuff(offeredBuffs)
        if bestBuff then
            return bestBuff
        end
        if getgenv()._originalBuffCallback then
            return getgenv()._originalBuffCallback(offeredBuffs)
        end
    end

    task.spawn(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local success, buffSelector = pcall(function()
            return replicatedStorage:WaitForChild("DungeonShared", math.huge):WaitForChild("BuffSelector", math.huge)
        end)
        
        if success and buffSelector then
            task.spawn(function()
                while task.wait(0.5) do
                    pcall(function()
                        local currentCallback = nil
                        pcall(function()
                            currentCallback = getcallbackvalue(buffSelector, "OnClientInvoke")
                        end)
                        
                        if currentCallback and currentCallback ~= getgenv()._ourBuffCallback then
                            getgenv()._originalBuffCallback = currentCallback
                            buffSelector.OnClientInvoke = getgenv()._ourBuffCallback
                        elseif not currentCallback then
                            buffSelector.OnClientInvoke = getgenv()._ourBuffCallback
                        end
                    end)
                end
            end)
        end
    end)



    local R = RunService
    local P = Players
    local TS = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    local p = P.LocalPlayer

    workspace.Gravity = 0
    local EF = "Enemies"
    local IE = { 
        ["Blank Buddy"] = true, 
        ["PropHitboxPlaceholder"] = true,
        ["Raider"] = true
    }
    local PROP_NAME = "PropHitboxPlaceholder" 
    local TD = 0.075
    local GR = 35
    local LS = 200
    local PR = 35
    local mT = 0
    local FLY_SPEED = 350

    
local player = game.Players.LocalPlayer
local hasUnequippedForTransform = false 

local function getCurrentToolTip()
    if not getgenv().Config then return nil end
    local myName = string.lower(player.Name)
    local myDisplayName = string.lower(player.DisplayName)
    for _, data in pairs(getgenv().Config) do
        if type(data) == "table" and data.Users then
            for _, user in pairs(data.Users) do
                local configUser = string.lower(tostring(user))
                if configUser == myName or configUser == myDisplayName then 
                    return data.ToolTip 
                end
            end
        end
    end
    return nil
end

local function startAutoEquip()
    task.spawn(function()
        local lastWeapon = _G.SelectWeapon
        
        while task.wait() do
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            local currentSelection = _G.SelectWeapon
            
            if currentSelection ~= "" and currentSelection ~= nil then
                if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
                    local toolInHand = character:FindFirstChildOfClass("Tool")
                    
                    if not toolInHand or toolInHand.ToolTip ~= currentSelection then
                        task.wait(4)
                        if _G.SelectWeapon == currentSelection and player.Character == character then
                            if backpack then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") and tool.ToolTip == currentSelection then
                                        character.Humanoid:EquipTool(tool)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                lastWeapon = currentSelection
            else
                if character and character:FindFirstChild("Humanoid") then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool and tool.ToolTip == lastWeapon then
                        if backpack then
                            tool.Parent = backpack
                        end
                    end
                end
            end
        end
    end)
end

local function equipToolByRole()
    task.spawn(function()
        while task.wait(0.3) do 
            local character = player.Character
            if not character then continue end
            local hum = character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            if _G.IsTransforming then
                if not hasUnequippedForTransform then
                    local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                    if currentlyEquipped then
                        hum:UnequipTools() 
                    end
                    hasUnequippedForTransform = true 
                end
                continue 
            end
            hasUnequippedForTransform = false 

            if getgenv().AutoEquip == false then
                local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                if currentlyEquipped then
                    hum:UnequipTools()
                end
            else
                local myToolTip = getCurrentToolTip()
                local backpack = player:FindFirstChild("Backpack")
                
                if myToolTip and backpack then
                    local currentlyEquipped = character:FindFirstChildOfClass("Tool")
                    
                    if not (currentlyEquipped and currentlyEquipped.ToolTip == myToolTip) then
                        for _, item in pairs(backpack:GetChildren()) do
                            if item:IsA("Tool") and item.ToolTip == myToolTip then
                                hum:EquipTool(item) 
                                break
                            end
                        end
                    end
                end
            end
        end
    end)
end

player.CharacterAdded:Connect(function(char)
    hasUnequippedForTransform = false
    task.wait(0.5)
end)

equipToolByRole()



    local Themes = {
        BgColor = Color3.fromRGB(15, 15, 15),
        BgTransparency = 0.5,
        TextColor = Color3.fromRGB(255, 255, 255),
        CreditColor = Color3.fromRGB(150, 150, 150)
    }

    local UI_Elements = {}

    local g = Instance.new("ScreenGui")
    g.Name = "Kaitun_UI_" .. tostring(math.random(1000, 9999))
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then g.Parent = p:WaitForChild("PlayerGui") end
    getgenv().kc = g

    local m = Instance.new("Frame", g)
    m.Name = "Main"
    m.BackgroundColor3 = Themes.BgColor
    m.BackgroundTransparency = Themes.BgTransparency
    m.Position = UDim2.new(0.5, 0, 0, -150)
    m.Size = UDim2.new(0, 320, 0, 100)
    m.AnchorPoint = Vector2.new(0.5, 0)
    table.insert(UI_Elements, m)

    local mainCorner = Instance.new("UICorner", m)
    mainCorner.CornerRadius = UDim.new(0, 10)

    local u = Instance.new("UIStroke", m)
    u.Thickness = 2.5
    u.Color = Color3.new(1, 1, 1)
    table.insert(UI_Elements, u)

    local strokeGradient = Instance.new("UIGradient", u)
    
    local function createDarkGradient()
        return ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 80, 80))
        })
    end
    strokeGradient.Color = createDarkGradient()

    local statusGradients = {}

    local function CreateStatusLabel(name, pos, text)
        local label = Instance.new("TextLabel", m)
        label.Name = name
        label.Size = UDim2.new(1, -20, 0, 20)
        label.Position = UDim2.new(0.5, 0, 0, pos)
        label.AnchorPoint = Vector2.new(0.5, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.Text = text
        label.TextSize = 15
        label.TextColor3 = Themes.TextColor
        table.insert(UI_Elements, label)
        
        local txtGradient = Instance.new("UIGradient", label)
        txtGradient.Color = createDarkGradient()
        table.insert(statusGradients, txtGradient)
        return label, txtGradient
    end

    _G.StatusItemLabel, _G.TopInfoGradient = CreateStatusLabel("TopInfo", 10, "Meyy Hub - Kaitun Dungeon")
    _G.StatusFarmLabel, _G.FarmGradient = CreateStatusLabel("StatusFarm", 35, "Status Farm: N/A")
    _G.StatusMobLabel, _G.MobGradient = CreateStatusLabel("StatusMob", 60, "Farm Mob: N/A")

    local creditLabel = Instance.new("TextLabel", m)
    creditLabel.Name = "CreditLabel"
    creditLabel.Size = UDim2.new(0, 50, 0, 15)
    creditLabel.Position = UDim2.new(1, -10, 1, -5)
    creditLabel.AnchorPoint = Vector2.new(1, 1)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Font = Enum.Font.GothamBold
    creditLabel.Text = "meyy"
    creditLabel.TextSize = 10
    creditLabel.TextColor3 = Themes.CreditColor
    creditLabel.TextXAlignment = Enum.TextXAlignment.Right
    table.insert(UI_Elements, creditLabel)

    local rRot = 0
    task.spawn(function()
        while true do
            local delta = R.RenderStepped:Wait()
            rRot = (rRot + 1.5) % 360
            strokeGradient.Rotation = rRot
            for _, grad in ipairs(statusGradients) do
                grad.Rotation = rRot
            end
        end
    end)

    TS:Create(m, TweenInfo.new(1.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 20)}):Play()

    

    local function gH()
        local c = p.Character or p.CharacterAdded:Wait()
        return c:WaitForChild("HumanoidRootPart")
    end

    local function isAlive()
        local c = p.Character
        local u = c and c:FindFirstChildOfClass("Humanoid")
        return u and u.Health > 0
    end

    local function iB()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if dungeon then 
            local mR = 0
            for _, r in ipairs(dungeon:GetChildren()) do 
                local n = tonumber(r.Name)
                if n and n > mR then mR = n end 
            end
            if mR > 0 then 
                return (mR == 5 or mR == 10 or mR == 15 or mR == 20 or mR == 100), mR 
            end 
        end
        return false, 0 
    end
    
local function getActivePlayersConfig()
        local count = 0
        local myIndex = 1
        local validUsers = {}
        
        if getgenv().Config and getgenv().Config["Account Join"] and getgenv().Config["Account Join"].Users then
            for _, v in ipairs(getgenv().Config["Account Join"].Users) do
                if type(v) == "string" and v ~= "" then
                    table.insert(validUsers, string.lower(v))
                end
            end
        end
        
        count = #validUsers > 0 and #validUsers or 1
        local myName = string.lower(p.Name)
        local myDisplayName = string.lower(p.DisplayName)
        
        for i, v in ipairs(validUsers) do
            if v == myName or v == myDisplayName then
                myIndex = i
                break
            end
        end
        
        return count, myIndex
    end
    
    local function fE()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return nil end
        local h = gH()
        local n = nil
        local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local ePart = r:FindFirstChild("ExitTeleporter")
            if ePart then 
                local t = ePart:FindFirstChild("Root")
                if t and t:IsA("BasePart") then 
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; n = t end 
                end 
            end 
        end
        return n 
    end


    local function tpTween(targetPos)
        local h = gH()
        if not h then return end
        h.CFrame = CFrame.new(h.Position.X, targetPos.Y, h.Position.Z)
        local distXZ = (Vector3.new(h.Position.X, 0, h.Position.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude 
        if distXZ < 10 then
            h.CFrame = CFrame.new(targetPos)
        else
            local speed = 300
            local duration = distXZ / speed
            TS:Create(h, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)}):Play()
        end
    end

    local function cP(pos)
        local f = workspace:FindFirstChild("AnnSafePlatform")
        if not f then 
            f = Instance.new("Part"); f.Name = "AnnSafePlatform"; f.Size = Vector3.new(100, 1, 100)
            f.Position = pos; f.Anchored = true; f.CanCollide = true; f.Transparency = 0.5
            f.Color = Color3.fromRGB(138, 43, 226); f.Parent = workspace 
        else f.Position = pos end
        return f 
    end

    local function sM() mT = mT + 1 end

    local function flyToNearestExit(targetPos)
        sM()
        local myToken = mT
        local hrp = gH()
        local startPos = hrp.Position
        local delta = targetPos - startPos
        local distance = delta.Magnitude
        
        if distance < 3 then 
            task.wait(0.5)
            return 
        end 
        
        local direction = delta.Unit
        local duration = distance / FLY_SPEED
        local elapsed = 0
        local connection
        
        connection = R.Heartbeat:Connect(function(dt)
            if myToken ~= mT then 
                connection:Disconnect() 
                return 
            end
            elapsed += dt
            local alpha = math.clamp(elapsed / duration, 0, 1)
            hrp.CFrame = CFrame.new(startPos + direction * (distance * alpha))
            if alpha >= 1 then 
                connection:Disconnect() 
            end
        end)
        
        repeat task.wait() until elapsed >= duration or myToken ~= mT
            if myToken == mT then
            task.wait(0.5)
        end
    end

    local function executeFlyToNearestExit()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return end
        local hrp = gH(); local nearestRoot = nil; local minDistance = math.huge
        for _, room in ipairs(dungeon:GetChildren()) do
            local exitPortal = room:FindFirstChild("ExitTeleporter")
            if exitPortal then
                local root = exitPortal:FindFirstChild("Root")
                if root and root:IsA("BasePart") then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < minDistance then minDistance = dist; nearestRoot = root end
                end
            end
        end
        if nearestRoot then flyToNearestExit(nearestRoot.Position + Vector3.new(0, 3, 0)) end
    end

    local function getCurrentRoomNumber()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return 0 end
        local h = gH(); if not h then return 0 end
        local cR = 0; local mD = math.huge
        for _, r in ipairs(dungeon:GetChildren()) do 
            local n = tonumber(r.Name)
            if n then
                local ePart = r:FindFirstChild("ExitTeleporter")
                local t = ePart and ePart:FindFirstChild("Root")
                if t then
                    local dist = (h.Position - t.Position).Magnitude
                    if dist < mD then mD = dist; cR = n end
                end
            end
        end
        return cR
    end

    local function getRoomCenter()
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if not dungeon then return nil end

        local currentRoomNum = getCurrentRoomNumber()
        if currentRoomNum == 0 then return nil end

        local roomModel = dungeon:FindFirstChild(tostring(currentRoomNum))
        if roomModel and roomModel:IsA("Model") then
            local cframe, size = roomModel:GetBoundingBox()
            return cframe.Position
        end
        return nil
    end


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

local function FindNearestMob()
    local targetMob = nil
    local minDistance = math.huge
    local playerHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
    if not playerHRP then return nil end
    
    local MobContainer = workspace:FindFirstChild("Enemies") or workspace 
    for _, v in pairs(MobContainer:GetChildren()) do
        local humanoid = v:FindFirstChildOfClass("Humanoid")
        if v and humanoid and v:FindFirstChild("HumanoidRootPart") and humanoid.Health > 0 then
            local dis = (playerHRP.Position - v.HumanoidRootPart.Position).Magnitude
            if dis <= 500 and dis < minDistance then
                minDistance = dis 
                targetMob = v
            end
        end
    end
    return targetMob
end

local function GetValidator2(shootFunc)
    if not getupvalue or not setupvalue or not shootFunc then return nil, nil end
    local success, v1_val, v7_val = pcall(function()
        local v1 = getupvalue(shootFunc, 15)
        local v2 = getupvalue(shootFunc, 13)
        local v3 = getupvalue(shootFunc, 16)
        local v4 = getupvalue(shootFunc, 17)
        local v5 = getupvalue(shootFunc, 14)
        local v6 = getupvalue(shootFunc, 12)
        local v7 = getupvalue(shootFunc, 18)
        
        local v8 = v6 * v2
        local v9 = (v5 * v2 + v6 * v1) % v3
        v9 = (v9 * v3 + v8) % v4
        v5 = math.floor(v9 / v3)
        v6 = v9 - v5 * v3
        v7 = v7 + 1
        
        setupvalue(shootFunc, 15, v1)
        setupvalue(shootFunc, 13, v2)
        setupvalue(shootFunc, 16, v3)
        setupvalue(shootFunc, 17, v4)
        setupvalue(shootFunc, 14, v5)
        setupvalue(shootFunc, 12, v6)
        setupvalue(shootFunc, 18, v7)
        
        return math.floor(v9 / v4 * 16777215), v7
    end)
    if success then return v1_val, v7_val end
    return nil, nil
end

task.spawn(function()
    while true do
        if _G.dragontorm then
            local targetMob = FindNearestMob()
            if targetMob then
                local mobHRP = targetMob:FindFirstChild("HumanoidRootPart") 
                local mobHead = targetMob:FindFirstChild("Head") 
                local targetPos = (mobHead and mobHead.Position) or (mobHRP and mobHRP.Position) 
                
                if targetPos then
                    AimBotSkillPosition = targetPos 
                    pcall(function()
                        local NetModule = require(game.ReplicatedStorage.Modules.Net)
                        NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos, {mobHead or mobHRP})
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
    local GunValidator = game.ReplicatedStorage:FindFirstChild("Remotes") and game.ReplicatedStorage.Remotes:FindFirstChild("Validator2")
    local CombatController, ShootFunction
    
    pcall(function()
        local Modules = game.ReplicatedStorage:WaitForChild("Modules")
        CombatController = require(game.ReplicatedStorage.Controllers.CombatController)
        if getupvalue then
            ShootFunction = getupvalue(CombatController.Attack, 9)
        end
    end)

    while true do
        if _G.dragontorm then
            local targetMob = FindNearestMob()
            if targetMob then
                local mobHRP = targetMob:FindFirstChild("HumanoidRootPart")
                local targetPos = mobHRP and mobHRP.Position
                
                if targetPos then
                    pcall(function()
                        if ShootFunction and GunValidator then
                            local val1, val2 = GetValidator2(ShootFunction)
                            if val1 and val2 then
                                GunValidator:FireServer(val1, val2)
                            end
                        end
                        local NetModule = require(game.ReplicatedStorage.Modules.Net)
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

task.spawn(function()
    local GunValidator = game.ReplicatedStorage:FindFirstChild("Remotes") and game.ReplicatedStorage.Remotes:FindFirstChild("Validator2")
    local CombatController, ShootFunction
    
    pcall(function()
        CombatController = require(game.ReplicatedStorage.Controllers.CombatController)
        if getupvalue then
            ShootFunction = getupvalue(CombatController.Attack, 9)
        end
    end)

    while true do
        if _G.dragontorm then
            local targetMob = FindNearestMob()
            if targetMob then
                local mobHRP = targetMob:FindFirstChild("HumanoidRootPart")
                local targetPos = mobHRP and mobHRP.Position
                
                if targetPos then
                    pcall(function()
                        if ShootFunction and GunValidator then
                            local val1, val2 = GetValidator2(ShootFunction)
                            if val1 and val2 then
                                GunValidator:FireServer(val1, val2)
                            end
                        end
                        local NetModule = require(game.ReplicatedStorage.Modules.Net)
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


    local Attack = {}
    Attack.Alive = function(model)
        if not model then return false end
        local Humanoid = model:FindFirstChildOfClass("Humanoid")
        return Humanoid and Humanoid.Health > 0
    end

    local function isModelStillThere(model)
        if not model or not model.Parent then return false end
        return model:FindFirstChild("HumanoidRootPart") ~= nil
    end

    local function getActivePlayersConfig()
        local count = 0
        local myIndex = 1
        local validUsers = {}
        
        if getgenv().Config and getgenv().Config["Account Join"] and getgenv().Config["Account Join"].Users then
            for _, v in ipairs(getgenv().Config["Account Join"].Users) do
                if type(v) == "string" and v ~= "" then
                    table.insert(validUsers, string.lower(v))
                end
            end
        end
        
        count = #validUsers > 0 and #validUsers or 1
        local myName = string.lower(p.Name)
        local myDisplayName = string.lower(p.DisplayName)
        
        for i, v in ipairs(validUsers) do
            if v == myName or v == myDisplayName then
                myIndex = i
                break
            end
        end
        
        return count, myIndex
    end

  

    task.spawn(function()
        local lastFarmText = ""
        local lastMobText = ""
        
        local global_lastRoomCheck = 0
        local global_roomEntryTime = 0 

        local function updateUI(farmMsg, mobMsg)
            task.spawn(function()
                local farmFullText = "Status Farm: " .. tostring(farmMsg)
                local mobFullText = "Farm Mob: " .. tostring(mobMsg)
                
                if farmFullText ~= lastFarmText then
                    lastFarmText = farmFullText
                    if _G.StatusFarmLabel then _G.StatusFarmLabel.Text = farmFullText end
                end
                if mobFullText ~= lastMobText then
                    lastMobText = mobFullText
                    if _G.StatusMobLabel then _G.StatusMobLabel.Text = mobFullText end
                end
            end)
        end

        while true do 
            task.wait() 
            
            local isBoss, rNum = iB()
            local currentRoom = getCurrentRoomNumber()
            
            if currentRoom > 0 and currentRoom ~= global_lastRoomCheck then
                global_lastRoomCheck = currentRoom
                global_roomEntryTime = tick() 
            end
        
            if currentRoom >= getgenv().Config["Room Settings"].MaxRoom then
                updateUI("Room " .. tostring(getgenv().Config["Room Settings"].MaxRoom) .. " Reached", getgenv().Config["Room Settings"].StatusMessage)
                task.wait(2)
                continue
            end
            
            if currentRoom > 0 and currentRoom < rNum then
                updateUI("Tween To Portal " .. rNum, "Moving")
                executeFlyToNearestExit()
                task.wait(0.1)
                continue 
            end

            if tick() - global_roomEntryTime < 0.4 then
                task.wait(0.1)
                continue
            end

            local function getMyBuddhaConfig()
                if not getgenv().Config then return false end
                local myName = string.lower(p.Name)
                local myDisplayName = string.lower(p.DisplayName)
                
                for _, data in pairs(getgenv().Config) do
                    if type(data) == "table" and data.Users then
                        for _, user in pairs(data.Users) do
                            local configUser = string.lower(tostring(user))
                            if configUser == myName or configUser == myDisplayName then 
                                return data.ModeBuddha 
                            end
                        end
                    end
                end
                return false
            end

            local modebuddha = getMyBuddhaConfig()
            if modebuddha then
                local char = p.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not _G.OriginalSize then _G.OriginalSize = hrp.Size end
                    
                    if hrp.Size.Magnitude <= _G.OriginalSize.Magnitude * 1.2 then
                        if not _G.IsTransforming then
                            _G.IsTransforming = true
                            getgenv().AutoEquip = false 
                            
                            task.spawn(function()
                                local vi = game:GetService("VirtualInputManager")
                                task.wait(0.5)
                                vi:SendKeyEvent(true, Enum.KeyCode.Two, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Two, false, game)
                                task.wait(0.6)
                                vi:SendKeyEvent(true, Enum.KeyCode.Z, false, game)
                                task.wait(0.1); vi:SendKeyEvent(false, Enum.KeyCode.Z, false, game)
                                task.wait(2) 
                                getgenv().AutoEquip = true 
                                _G.IsTransforming = false
                            end)
                        end
                        updateUI("Activating Buddha", "Waiting...")
                        task.wait(0.1)
                        continue 
                    else
                        local mult = 3
                        local targetMag = _G.OriginalSize.Magnitude * 3 * mult * 0.9
                        if hrp.Size.Magnitude < targetMag then
                            for _, part in pairs(char:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.Size = part.Size * mult
                                    for _, att in pairs(part:GetChildren()) do 
                                        if att:IsA("Attachment") then att.Position = att.Position * mult end 
                                    end
                                    local mesh = part:FindFirstChildOfClass("SpecialMesh")
                                    if mesh then mesh.Scale = mesh.Scale * mult end
                                elseif part:IsA("Motor6D") then
                                    local c0, c1 = part.C0, part.C1
                                    part.C0 = CFrame.new(c0.Position * mult) * (c0 - c0.Position)
                                    part.C1 = CFrame.new(c1.Position * mult) * (c1 - c1.Position)
                                end
                            end
                        end
                    end
                end
            end


if isBoss and (rNum == 5 or rNum == 10 or rNum == 15 or rNum == 20) then 
    updateUI("Clear Boss Room " .. rNum, "Boss Battle M1")
    local f = workspace:FindFirstChild(EF)
    if f then 
        _G.PromotedRooms = _G.PromotedRooms or {}
        
        local function TweenIsBoss(targetPos)
            local mHRP = gH()
            if not mHRP then return end
            local dist = (mHRP.Position - targetPos).Magnitude
            if dist <= 100 then
                mHRP.CFrame = CFrame.new(targetPos)
            else
                local Speed = 350
                local info = TweenInfo.new(dist / Speed, Enum.EasingStyle.Linear)
                TS:Create(mHRP, info, {CFrame = CFrame.new(targetPos)}):Play()
            end
        end

        while isAlive() do
            Workspace.Gravity = 0 
            local checkStillBoss, currentRNum = iB()
            if not checkStillBoss or currentRNum ~= rNum then 
                break 
            end

            local bossTarget = nil
            local propTarget = nil
            local highestMaxHealth = -1

            for _, e in pairs(f:GetChildren()) do
                local hum = e:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if e.Name == PROP_NAME then
                        propTarget = e
                    elseif not IE[e.Name] then
                        if hum.MaxHealth > highestMaxHealth then
                            highestMaxHealth = hum.MaxHealth
                            bossTarget = e
                        end
                    end
                end
            end

            if (rNum == 10 or rNum == 15 or rNum == 20) and propTarget then
                _G.attackboss = false
                _G.attackprop = true
            elseif bossTarget then
                _G.attackprop = false
                _G.attackboss = true
            else
                _G.attackprop = false
                _G.attackboss = false
            end

            local activeTarget = nil
            if _G.attackprop and propTarget then
                activeTarget = propTarget
            elseif _G.attackboss and bossTarget then
                activeTarget = bossTarget
            end

            if activeTarget then
                pcall(function()
                    local hrp = activeTarget:FindFirstChild("HumanoidRootPart") or activeTarget:FindFirstChild("PrimaryPart") or activeTarget:FindFirstChildOfClass("Part")
                    local mHRP = gH()
                    if hrp and mHRP then
                        local myRole = getCurrentToolTip()
                        local heightOffset = 43
                        if myRole == "Blox Fruit" then
                            heightOffset = 5
                        elseif myRole == "Gun" then
                            heightOffset = 100
                        end
                        if modebuddha then heightOffset = 75 end
                        
                        local targetPos = hrp.Position + Vector3.new(0, heightOffset, 0)
                        TweenIsBoss(targetPos)
                    end
                end)
            else
                local exitPortal = fE()
                if exitPortal then
                    if not _G.PromotedRooms[rNum] then
                        _G.PromotedRooms[rNum] = true
                    end
                    pcall(function()
                        flyToNearestExit(exitPortal.Position + Vector3.new(0, 3, 0))
                    end)
                else
                    break
                end
            end
            task.wait()
        end
    end
    task.wait(0.1)

            else
                local f = workspace:FindFirstChild(EF)
                local h = gH()

                if f and h then 
                    local myRole = getCurrentToolTip()

                    if _G.LastToolPrinted ~= myRole then
                        print("Role Tool: " .. tostring(myRole))
                        _G.LastToolPrinted = myRole
                    end

                    _G.SelectWeapon = myRole
                    if myRole == "Gun" then
                        _G.dragontorm = true
                    else
                        _G.dragontorm = false
                    end

                    local yOffset = 33
                    if myRole == "Blox Fruit" then
                        yOffset = 5
                    elseif myRole == "Gun" then
                        yOffset = 100
                    end
                    if modebuddha then yOffset = 75 end

                    local highHpMobs = {}
                    local lowHpMobs = {}
                    local aliveMobsCount = 0
                    
                    for _, e in pairs(f:GetChildren()) do
                        if not IE[e.Name] then
                            local hrpE = e:FindFirstChild("HumanoidRootPart")
                            local humE = e:FindFirstChildOfClass("Humanoid")
                            if hrpE and humE and humE.Health > 0 then
                                aliveMobsCount = aliveMobsCount + 1
                                local maxHp = humE.MaxHealth > 0 and humE.MaxHealth or 100
                                if (humE.Health / maxHp) > 0.25 then
                                    table.insert(highHpMobs, e)
                                else
                                    table.insert(lowHpMobs, e)
                                end
                            end
                        end
                    end

                    local enemiesList = (#highHpMobs > 0) and highHpMobs or lowHpMobs

                    if aliveMobsCount > 0 then
                        updateUI("Clear Room " .. rNum, "Targeting Mobs")
                            
                              local targetedAny = false
                        local totalPlayersConfig, myConfigIndex = getActivePlayersConfig()


                        local myAreaMobs = {}
                        local otherAreaMobs = {}

                        local function applyTeleporterWall(configIdx)
                            local map = workspace:FindFirstChild("Map")
                            local dungeon = map and map:FindFirstChild("Dungeon")
                            if not dungeon then return nil, nil end

                            local currentRoomNum = getCurrentRoomNumber()
                            if currentRoomNum == 0 then return nil, nil end

                            local roomModel = dungeon:FindFirstChild(tostring(currentRoomNum))
                            if not roomModel or not roomModel:IsA("Model") then return nil, nil end

                            local entrance = roomModel:FindFirstChild("EntranceTeleporter")
                            local exitTel = roomModel:FindFirstChild("ExitTeleporter")
                            if not entrance or not exitTel then return nil, nil end

                            local entranceRoot = entrance:FindFirstChild("Root")
                            local exitRoot = exitTel:FindFirstChild("Root")
                            if not entranceRoot or not exitRoot then return nil, nil end

                            local entrancePos = entranceRoot.Position - Vector3.new(0, 30, 0)
                            local exitPos = exitRoot.Position - Vector3.new(0, 30, 0)

                            local centerPos = (entrancePos + exitPos) / 2
                            local distance = (entrancePos - exitPos).Magnitude

                            if _G.HologramWalls then
                                for _, w in ipairs(_G.HologramWalls) do
                                    if w and w.Parent then w:Destroy() end
                                end
                            end
                            
                            for _, obj in pairs(workspace:GetChildren()) do
                                if obj.Name == "MeyyDungeonWall" then
                                    obj:Destroy()
                                end
                            end
                            _G.HologramWalls = {}

                            local color = (configIdx <= 4) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 50, 50)
                            
                            local Wall = Instance.new("Part")
                            Wall.Name = "MeyyDungeonWall"
                            Wall.Size = Vector3.new(0.5, 4000, distance)
                            Wall.CFrame = CFrame.lookAt(centerPos, exitPos)
                            Wall.Anchored = true
                            Wall.CanCollide = false
                            Wall.CastShadow = false
                            Wall.Material = Enum.Material.ForceField
                            Wall.Color = color
                            Wall.Transparency = 1
                            Wall.Parent = workspace

                            local uiElements = {}
                            local textureUrl = "rbxassetid://10849912115"

                            for _, face in ipairs({Enum.NormalId.Front, Enum.NormalId.Back, Enum.NormalId.Left, Enum.NormalId.Right, Enum.NormalId.Top}) do
                                local tex = Instance.new("Texture")
                                tex.Texture = textureUrl
                                tex.Face = face
                                tex.Color3 = color
                                tex.Transparency = 0.6
                                tex.StudsPerTileU = 5
                                tex.StudsPerTileV = 5
                                tex.Parent = Wall
                                table.insert(uiElements, tex)
                            end

                            local TS = game:GetService("TweenService")
                            local RS = game:GetService("RunService")

                            TS:Create(Wall, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0.8}):Play()

                            local conn
                            conn = RS.RenderStepped:Connect(function(deltaTime)
                                if not Wall or not Wall.Parent then
                                    conn:Disconnect()
                                    return
                                end
                                for _, tex in ipairs(uiElements) do
                                    tex.OffsetU = tex.OffsetU + (deltaTime * 0.2)
                                    tex.OffsetV = tex.OffsetV + (deltaTime * 0.1)
                                end
                            end)

                            table.insert(_G.HologramWalls, Wall)

                            return Wall.CFrame, configIdx
                        end

                        local wallCFrame, cIdx = applyTeleporterWall(myConfigIndex)

                        if wallCFrame and cIdx then
                            local myAssignedPart = (cIdx == 1 or cIdx == 2) and 1 or 2
                            for _, mob in ipairs(enemiesList) do
                                local hrp = mob:FindFirstChild("HumanoidRootPart")
                                if hrp then
                                    local localPos = wallCFrame:PointToObjectSpace(hrp.Position)
                                    local mobPart = (localPos.X > 0) and 1 or 2
                                    
                                    if mobPart == myAssignedPart then
                                        table.insert(myAreaMobs, mob)
                                    else
                                        table.insert(otherAreaMobs, mob)
                                    end
                                end
                            end
                        else
                            for _, mob in ipairs(enemiesList) do
                                table.insert(myAreaMobs, mob)
                            end
                        end

                    local currentTargetList = #myAreaMobs > 0 and myAreaMobs or otherAreaMobs

                    if _G.W_Circle == nil then _G.W_Circle = 30 end
                    if _G.LastChange_Circle == nil then _G.LastChange_Circle = tick() end

                    local function RoundVector3Down(Vector)
                        return Vector3.new(math.floor(Vector.X / 10) * 10, math.floor(Vector.Y / 10) * 10, math.floor(Vector.Z / 10) * 10)
                    end

                    local function CaculateCircreDirection(PositionCFrame)
                        if _G.W_Circle > 50000 then _G.W_Circle = 60 end
                        _G.W_Circle = _G.W_Circle + ((tick() - _G.LastChange_Circle) > 0.4 and 80 or 0)
                        if tick() - _G.LastChange_Circle > 0.4 then _G.LastChange_Circle = tick() end
                        local TargetPosition = PositionCFrame.Position + Vector3.new(math.cos(math.rad(_G.W_Circle)) * 40, 0, math.sin(math.rad(_G.W_Circle)) * 40)
                        return CFrame.new(RoundVector3Down(TargetPosition))
                    end

                    for _, e in ipairs(currentTargetList) do
                        if not isAlive() then break end
                        targetedAny = true

                        while e.Parent and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 and isAlive() do
                            local hrpE = e:FindFirstChild("HumanoidRootPart")
                            if not hrpE then break end

                            if #highHpMobs > 0 then
                                local humE = e:FindFirstChildOfClass("Humanoid")
                                if humE then
                                    local maxHp = humE.MaxHealth > 0 and humE.MaxHealth or 100
                                    if (humE.Health / maxHp) <= 0.25 then
                                        break
                                    end
                                end
                            end

                            local circlePos = CaculateCircreDirection(hrpE.CFrame).Position
                            tpTween(circlePos + Vector3.new(0, yOffset, 0))
                            task.wait(0.1)
                        end
                    end




                        if not targetedAny and isAlive() then
                            local rc = getRoomCenter()
                            if rc then
                                local pP = rc - Vector3.new(0, 50, 0)
                                task.spawn(function() cP(pP) end)
                                tpTween(pP + Vector3.new(0, 15, 0))
                            end
                        end
                    else
                        updateUI("Tween To Portal", "Clear")
                    end
                end 
                task.wait(0.2)
            end
        end
    end)

    local TweenService = game:GetService("TweenService")

     local function Nogravity()
        local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local function freezeCharacter(character)
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local bv = Instance.new("BodyVelocity")
    bv.Name = "AntiGravity"
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge) -- Lực vô hạn để giữ im
    bv.Parent = rootPart

    local bg = Instance.new("BodyGyro")
    bg.Name = "AntiRotation"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.CFrame = rootPart.CFrame
    bg.Parent = rootPart
end

player.CharacterAdded:Connect(function(char)
    freezeCharacter(char)
end)

if player.Character then
    freezeCharacter(player.Character)
end

runService.Heartbeat:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)
end
Nogravity()
    local function TweenObject(Object, Pos, Speed)
        Speed = Speed or 350
        if not Object or not Pos then return end
        local Distance = (Pos.Position - Object.Position).Magnitude
        local info = TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Object, info, {CFrame = Pos})
        tween:Play()
    end



local TweenService = game:GetService("TweenService")
_G.BringMobs = true
local ActiveBringMobs = {}
local MobTargetPositions = {}

local IE_Bring = {
    ["Blank Buddy"] = true,
    ["PropHitboxPlaceholder"] = true,
    ["Gas Knight"] = true,
    ["Zeno"] = true,
    ["Kitsune Lord"] = true,
    ["Ancient Beast"] = true
}

local CachedArea = {
    Active = false,
    CFrame = nil,
    StartX = 0,
    ChunkWidth = 0,
    TotalPlayers = 1,
    MyIndex = 1
}

local function RefreshAreaCache()
    local tPlayers, mIndex = getActivePlayersConfig()
    CachedArea.TotalPlayers = tPlayers
    CachedArea.MyIndex = mIndex
    CachedArea.Active = false

    if tPlayers > 1 then
        local map = workspace:FindFirstChild("Map")
        local dungeon = map and map:FindFirstChild("Dungeon")
        if dungeon then
            local rNum = getCurrentRoomNumber()
            if rNum > 0 then
                local roomModel = dungeon:FindFirstChild(tostring(rNum))
                if roomModel and roomModel:IsA("Model") then
                    local rCFrame, rSize = roomModel:GetBoundingBox()
                    CachedArea.CFrame = rCFrame
                    CachedArea.StartX = -rSize.X / 2
                    CachedArea.ChunkWidth = rSize.X / tPlayers
                    CachedArea.Active = true
                end
            end
        end
    end
end

local function IsMyArea(pos)
    if not CachedArea.Active or CachedArea.TotalPlayers <= 1 then return true end
    local localPos = CachedArea.CFrame:PointToObjectSpace(pos)
    local chunkIdx = math.floor((localPos.X - CachedArea.StartX) / CachedArea.ChunkWidth) + 1
    if chunkIdx > CachedArea.TotalPlayers then chunkIdx = CachedArea.TotalPlayers end
    if chunkIdx < 1 then chunkIdx = 1 end
    return chunkIdx == CachedArea.MyIndex
end

local function UpdateMobGroups()
    local mobs = {}
    local ef = workspace:FindFirstChild("Enemies")
    if ef then
        for _, mob in pairs(ef:GetChildren()) do
            if not IE_Bring[mob.Name] then
                local hum = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and hrp then
                    if IsMyArea(hrp.Position) then
                        table.insert(mobs, mob)
                    end
                end
            end
        end
    end

    local n = #mobs
    if n == 0 then return end

    local unassigned = {}
    for _, m in ipairs(mobs) do table.insert(unassigned, m) end

    local groups = {}

    while #unassigned > 0 do
        if #unassigned == 4 then
            table.insert(groups, {unassigned[1], unassigned[2], unassigned[3], unassigned[4]})
            unassigned = {}
        elseif #unassigned == 2 then
            table.insert(groups, {unassigned[1], unassigned[2]})
            unassigned = {}
        elseif #unassigned == 1 then
            if #groups > 0 then
                table.insert(groups[#groups], unassigned[1])
            else
                table.insert(groups, {unassigned[1]})
            end
            unassigned = {}
        else
            local baseMob = table.remove(unassigned, 1)
            local basePos = baseMob.HumanoidRootPart.Position

            table.sort(unassigned, function(a, b)
                local distA = (a.HumanoidRootPart.Position - basePos).Magnitude
                local distB = (b.HumanoidRootPart.Position - basePos).Magnitude
                return distA < distB
            end)

            local closest1 = table.remove(unassigned, 1)
            local closest2 = table.remove(unassigned, 1)

            table.insert(groups, {baseMob, closest1, closest2})
        end
    end

    for _, grp in ipairs(groups) do
        local sumPos = Vector3.new(0, 0, 0)
        local count = 0
        for _, m in ipairs(grp) do
            if m and m:FindFirstChild("HumanoidRootPart") then
                sumPos = sumPos + m.HumanoidRootPart.Position
                count = count + 1
            end
        end
        if count > 0 then
            local center = sumPos / count
            for _, m in ipairs(grp) do
                MobTargetPositions[m] = center
            end
        end
    end
end

local function StartBringMob(mob)
    local rootQuai = mob:FindFirstChild("HumanoidRootPart")
    local humanoidQuai = mob:FindFirstChild("Humanoid")

    if not rootQuai or not humanoidQuai then return end

    pcall(function()
        plr.SimulationRadius = math.huge
    end)

    if not rootQuai:FindFirstChild("BringBody") then
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.Name = "BringBody"
        bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyPosition.Parent = rootQuai

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "BringGyro"
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.Parent = rootQuai

        task.spawn(function()
            while true do
                if not _G.BringMobs or not rootQuai or not rootQuai.Parent or humanoidQuai.Health <= 0 or not IsMyArea(rootQuai.Position) then
                    break
                end

                local targetPosition = MobTargetPositions[mob]

                if targetPosition then
                    local currentDistance = (rootQuai.Position - targetPosition).Magnitude

                    if currentDistance > 5 then
                        bodyPosition.P = 2000000000
                        bodyPosition.D = 500000
                        local speed = 300
                        local duration = currentDistance / speed
                        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
                        local tween = TweenService:Create(rootQuai, tweenInfo, {CFrame = CFrame.new(targetPosition)})
                        tween:Play()
                    else
                        bodyPosition.P = 500000000
                        bodyPosition.D = 1000000
                    end

                    bodyPosition.Position = targetPosition
                    bodyGyro.CFrame = CFrame.new(targetPosition)

                    rootQuai.AssemblyLinearVelocity = Vector3.zero
                    rootQuai.AssemblyAngularVelocity = Vector3.zero
                    rootQuai.Velocity = Vector3.zero
                    rootQuai.RotVelocity = Vector3.zero
                    rootQuai.CanCollide = false
                end

                task.wait(0.02)
            end

            if bodyPosition then bodyPosition:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            ActiveBringMobs[mob] = nil
        end)
    end
end

task.spawn(function()
    while true do
        if _G.BringMobs then
            RefreshAreaCache()
            UpdateMobGroups()
            local ef = workspace:FindFirstChild("Enemies")
            if ef then
                for _, mob in pairs(ef:GetChildren()) do
                    if not IE_Bring[mob.Name] then
                        local humanoid = mob:FindFirstChild("Humanoid")
                        local primaryPart = mob:FindFirstChild("HumanoidRootPart")

                        if humanoid and humanoid.Health > 0 and primaryPart then
                            if IsMyArea(primaryPart.Position) then
                                if not ActiveBringMobs[mob] then
                                    ActiveBringMobs[mob] = true
                                    StartBringMob(mob)
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

else
    task.spawn(JoinToPad)
end
