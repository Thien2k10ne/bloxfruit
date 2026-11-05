local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local localPlayer = Players.LocalPlayer
if not localPlayer then
    warn("[Auto Secret Quest] LocalPlayer is required.")
    return
end

if type(getgenv) ~= "function" then
    getgenv = function() return _G end
end
local Env = getgenv()
local previous = rawget(Env, "__AutoSecretQuestStandalone")
if type(previous) == "table" and type(previous.Stop) == "function" then
    pcall(previous.Stop)
end

local State = {
    Alive = true,
    Connections = {},
    Inputs = {},
    ModuleCache = {},
    SizedParts = setmetatable({}, { __mode = "k" }),
    EnemyCollision = setmetatable({}, { __mode = "k" }),
    LastMoveRequest = -100,
    LastPortalAttempt = -100,
    LastPortalRefresh = -100,
    TweenSpeed = 150,
    PreviousClickM1 = rawget(Env, "ClickM1"),
    PreviousAimPos = rawget(Env, "AimPos"),
    PreviousToggle = rawget(Env, "ToggleSecretQuest"),
    PreviousDelaytimeBiting = rawget(Env, "delaytimeBiting"),
    PreviousLiteFpsBoost = rawget(Env, "LiteFpsBoost"),
    ModuleRetry = {},
}
rawset(Env, "__AutoSecretQuestStandalone", State)

local fluentOK, Fluent = pcall(function()
    return loadstring(game:HttpGet("https://pastefy.app/htS1Tdkg/raw"))()
end)
if not fluentOK or type(Fluent) ~= "table" or type(Fluent.CreateWindow) ~= "function" then
    warn("[Auto Secret Quest] Could not load Fluent: " .. tostring(Fluent))
    rawset(Env, "__AutoSecretQuestStandalone", nil)
    return
end
State.Fluent = Fluent

local Settings = {
    ["Auto Secret Quest"] = false,
    ["Select Weapon"] = "Melee",
    ["Select Bait"] = "Basic Bait",
    ["Hidden Hop Dead Hour"] = false,
    ["Bring Mob"] = false,
    ["Bring Mob Count"] = 2,
    ["Bring Monster Radius"] = 200,
    ["Selected Quest"] = "Escape from Alcatraz",
    ["Single Quest"] = false,
    ["Auto Buso"] = true,
    ["Anti AFK"] = true,
    ["Farm Distance"] = 20,
    ["Team"] = "Marines",
    ["Auto Join Team"] = true,
    ["Fast Attack Delay"] = 0,
    ["Remove Fast Attack Animation"] = true,
    ["No Fog"] = false,
    ["Boost FPS"] = false,
    ["Discord Webhook URL"] = "",
    ["Webhook Quest Complete"] = false,
    ["Webhook Progress 5m"] = false,
}

local CONFIG_FOLDER = "AutoSecretQuest"
local function SafeConfigPlayerName(playerName)
    local safeName = tostring(playerName or "Unknown"):gsub("[^%w_%-]", "_")
    return safeName ~= "" and safeName or "Unknown"
end
local CONFIG_FILE = CONFIG_FOLDER .. "/" .. SafeConfigPlayerName(localPlayer.Name) .. ".json"
State.ConfigFile = CONFIG_FILE

local function SaveSecretConfig()
    if type(writefile) ~= "function" then
        State.LastConfigError = "writefile is unavailable"
        return false, State.LastConfigError
    end
    local payload = {
        Version = 2,
        PlayerName = localPlayer.Name,
        AutoSecretQuest = Settings["Auto Secret Quest"],
        Weapon = Settings["Select Weapon"],
        Bait = Settings["Select Bait"],
        AutoHop = Settings["Hidden Hop Dead Hour"],
        BringMob = Settings["Bring Mob"],
        BringMobCount = Settings["Bring Mob Count"],
        BringMonsterRadius = Settings["Bring Monster Radius"],
        SelectedQuest = Settings["Selected Quest"],
        SingleQuest = Settings["Single Quest"],
        AutoBuso = Settings["Auto Buso"],
        AntiAFK = Settings["Anti AFK"],
        FarmDistance = Settings["Farm Distance"],
        Team = Settings["Team"],
        AutoJoinTeam = Settings["Auto Join Team"],
        FastAttackDelay = Settings["Fast Attack Delay"],
        RemoveFastAttackAnimation = Settings["Remove Fast Attack Animation"],
        NoFog = Settings["No Fog"],
        BoostFPS = Settings["Boost FPS"],
        DiscordWebhookUrl = Settings["Discord Webhook URL"],
        WebhookQuestComplete = Settings["Webhook Quest Complete"],
        WebhookProgress5m = Settings["Webhook Progress 5m"],
        TweenSpeed = State.TweenSpeed,
    }
    local ok, err = pcall(function()
        if type(makefolder) == "function" then
            local shouldCreateFolder = true
            if type(isfolder) == "function" then
                local folderOK, folderExists = pcall(isfolder, CONFIG_FOLDER)
                shouldCreateFolder = not folderOK or folderExists ~= true
            end
            if shouldCreateFolder then pcall(makefolder, CONFIG_FOLDER) end
        end
        writefile(CONFIG_FILE, HttpService:JSONEncode(payload))
    end)
    State.LastConfigError = not ok and tostring(err) or nil
    if not ok then warn("[Auto Secret Quest / config] Save failed: " .. tostring(err)) end
    return ok, err
end
State.SaveConfig = SaveSecretConfig

local function LoadSecretConfig()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then
        State.LastConfigError = "Config file reading is unavailable"
        return false, State.LastConfigError
    end
    local ok, err = pcall(function()
        if not isfile(CONFIG_FILE) then return end
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(data) ~= "table" then return end
        if data.PlayerName ~= nil and data.PlayerName ~= localPlayer.Name then return end
        if type(data.AutoSecretQuest) == "boolean" then Settings["Auto Secret Quest"] = data.AutoSecretQuest end
        if type(data.Weapon) == "string" and table.find({ "Melee", "Sword", "Gun", "Blox Fruit" }, data.Weapon) then
            Settings["Select Weapon"] = data.Weapon
        end
        if type(data.Bait) == "string" and data.Bait ~= "" then Settings["Select Bait"] = data.Bait end
        if type(data.AutoHop) == "boolean" then Settings["Hidden Hop Dead Hour"] = data.AutoHop end
        if type(data.BringMob) == "boolean" then Settings["Bring Mob"] = data.BringMob end
        if type(data.BringMobCount) == "number" then Settings["Bring Mob Count"] = math.clamp(math.floor(data.BringMobCount), 1, 4) end
        if type(data.BringMonsterRadius) == "number" then Settings["Bring Monster Radius"] = math.clamp(data.BringMonsterRadius, 50, 400) end
        if type(data.SelectedQuest) == "string" and data.SelectedQuest ~= "" then Settings["Selected Quest"] = data.SelectedQuest end
        if type(data.SingleQuest) == "boolean" then Settings["Single Quest"] = data.SingleQuest end
        if type(data.AutoBuso) == "boolean" then Settings["Auto Buso"] = data.AutoBuso end
        if type(data.AntiAFK) == "boolean" then Settings["Anti AFK"] = data.AntiAFK end
        if type(data.FarmDistance) == "number" then Settings["Farm Distance"] = math.clamp(data.FarmDistance, 10, 45) end
        if data.Team == "Pirates" or data.Team == "Marines" then Settings["Team"] = data.Team end
        if type(data.AutoJoinTeam) == "boolean" then Settings["Auto Join Team"] = data.AutoJoinTeam end
        if type(data.FastAttackDelay) == "number" then Settings["Fast Attack Delay"] = math.max(0, data.FastAttackDelay) end
        if type(data.RemoveFastAttackAnimation) == "boolean" then Settings["Remove Fast Attack Animation"] = data.RemoveFastAttackAnimation end
        if type(data.NoFog) == "boolean" then Settings["No Fog"] = data.NoFog end
        if type(data.BoostFPS) == "boolean" then Settings["Boost FPS"] = data.BoostFPS end
        if type(data.DiscordWebhookUrl) == "string" then Settings["Discord Webhook URL"] = data.DiscordWebhookUrl end
        if type(data.WebhookQuestComplete) == "boolean" then Settings["Webhook Quest Complete"] = data.WebhookQuestComplete end
        if type(data.WebhookProgress5m) == "boolean" then Settings["Webhook Progress 5m"] = data.WebhookProgress5m end
        if type(data.TweenSpeed) == "number" then State.TweenSpeed = math.clamp(data.TweenSpeed, 100, 300) end
    end)
    State.LastConfigError = not ok and tostring(err) or nil
    if not ok then warn("[Auto Secret Quest / config] Load failed: " .. tostring(err)) end
    return ok, err
end
State.LoadConfig = LoadSecretConfig
local configExists = false
if type(isfile) == "function" then
    local ok, result = pcall(isfile, CONFIG_FILE)
    configExists = ok and result == true
end
LoadSecretConfig()
if not configExists then
    SaveSecretConfig()
end

local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", 15)
local CommF = remotesFolder and remotesFolder:WaitForChild("CommF_", 15)
if not CommF then
    warn("[Auto Secret Quest] Blox Fruits Remotes.CommF_ was not found; script stopped.")
    pcall(function() Fluent:Destroy() end)
    if rawget(Env, "__AutoSecretQuestStandalone") == State then rawset(Env, "__AutoSecretQuestStandalone", nil) end
    return
end
local function SelectedSecretTeam()
    return Settings["Team"] == "Marines" and "Marines" or "Pirates"
end

local function FireSecretTeamButton(team)
    if type(firesignal) ~= "function" then return false end
    local playerGui = localPlayer:FindFirstChild("PlayerGui")
    local minimal = playerGui and playerGui:FindFirstChild("Main (minimal)")
    local chooseTeam = minimal and minimal:FindFirstChild("ChooseTeam")
    local container = chooseTeam and chooseTeam:FindFirstChild("Container")
    local teamFrame = container and container:FindFirstChild(team)
    local frame = teamFrame and teamFrame:FindFirstChild("Frame")
    local button = frame and frame:FindFirstChild("TextButton")
    if not button or not button.Activated then return false end
    return pcall(firesignal, button.Activated)
end

local function JoinSecretTeam()
    if not State.Alive or not Settings["Auto Join Team"] then return false end
    local team = SelectedSecretTeam()
    local currentTeam = localPlayer.Team
    if currentTeam and (currentTeam.Name == team or tostring(currentTeam) == team) then return true end
    if os.clock() < (State.NextTeamAttempt or 0) then return false end
    State.NextTeamAttempt = os.clock() + 5

    if FireSecretTeamButton(team) then
        State.LastTeamRequest = team
        return true
    end

    local ok = pcall(CommF.InvokeServer, CommF, "SetTeam", team)
    if ok then State.LastTeamRequest = team end
    return ok
end

local function SecretTeamWorker()
    while State.Alive do
        if Settings["Auto Join Team"] then
            local ok, err = pcall(JoinSecretTeam)
            if not ok and os.clock() >= (State.TeamWarningAt or 0) then
                State.TeamWarningAt = os.clock() + 30
                warn("[Auto Secret Quest / team] " .. tostring(err))
            end
        end
        task.wait(1)
    end
end

State.TeamJob = task.spawn(SecretTeamWorker)

local NoclipChanged = {}
local TweenHoldUntil = 0
local interactionClock = { LastCall = 0 }
local TweenManager = { PauseUntil = 0 }

local function TrackConnection(connection)
    if not connection then return nil end
    if not State.Alive then
        pcall(connection.Disconnect, connection)
        return connection
    end
    table.insert(State.Connections, connection)
    return connection
end

local function FindPath(root, path)
    local current = root
    for _, name in ipairs(path) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end

local function RequirePath(path)
    local key = table.concat(path, "/")
    if State.ModuleCache[key] ~= nil then return State.ModuleCache[key] end
    if os.clock() < (State.ModuleRetry[key] or 0) then return nil end
    local object = FindPath(ReplicatedStorage, path)
    if not object then
        State.ModuleRetry[key] = os.clock() + 2
        return nil
    end
    local ok, result = pcall(require, object)
    if not ok or result == nil then
        State.ModuleRetry[key] = os.clock() + 5
        return nil
    end
    State.ModuleCache[key] = result
    State.ModuleRetry[key] = nil
    return result
end

local function IsSea1()
    return game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
end

SaveSettings = function(key, value)
    Settings[key] = value
    if State.SaveConfig and not State.SuppressConfigSave then
        State.SaveConfig()
    end
end

NatAovLog = function(tag, message)
    warn("[Auto Secret Quest / " .. tostring(tag) .. "] " .. tostring(message))
end

NatAovNotify = function(title, content, _kind, options)
    options = type(options) == "table" and options or {}
    local payload = {
        Title = tostring(title or "NatAov Hub"),
        Content = tostring(content or ""),
        SubContent = options.SubContent,
        Duration = options.Duration or 5,
    }
    local ok = pcall(function() Fluent:Notify(payload) end)
    if not ok then warn(payload.Title .. ": " .. payload.Content) end
end

FormatMagnetTime = function(seconds)
    local value = math.max(0, math.floor(tonumber(seconds) or 0))
    return string.format("%02d:%02d", value // 60, value % 60)
end

local function SecretCharacter()
    local character = localPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return nil end
    return character, humanoid, root
end

local function RestoreEnemyCollisions()
    for part, saved in pairs(State.EnemyCollision) do
        pcall(function() if part.Parent then part.CanCollide = saved end end)
    end
    table.clear(State.EnemyCollision)
end

RestorePhysics = function()
    for part, saved in pairs(NoclipChanged) do
        pcall(function() if part.Parent then part.CanCollide = saved end end)
    end
    table.clear(NoclipChanged)
    if State.BodyClip then
        pcall(State.BodyClip.Destroy, State.BodyClip)
        State.BodyClip = nil
    end
    if State.PhysicsHumanoid then
        pcall(function()
            if State.PhysicsHumanoid.Parent and State.PhysicsHumanoid.Health > 0 then
                State.PhysicsHumanoid.AutoRotate = true
                State.PhysicsHumanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        State.PhysicsHumanoid = nil
    end
end

MaintainPhysics = function()
    local character, humanoid, root = SecretCharacter()
    local active = character and (State.Tween ~= nil
        or os.clock() - State.LastMoveRequest < 0.7 or tick() < TweenHoldUntil)
    if not active then
        RestorePhysics()
        return
    end
    if not State.BodyClip or State.BodyClip.Parent ~= root then
        if State.BodyClip then pcall(State.BodyClip.Destroy, State.BodyClip) end
        State.BodyClip = Instance.new("BodyVelocity")
        State.BodyClip.Name = "AutoSecretQuestBodyClip"
        State.BodyClip.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        State.BodyClip.Velocity = Vector3.zero
        State.BodyClip.Parent = root
    end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if NoclipChanged[part] == nil then NoclipChanged[part] = part.CanCollide end
            part.CanCollide = false
        end
    end
    State.PhysicsHumanoid = humanoid
    pcall(function() humanoid.AutoRotate = false end)
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

CancelTween = function(restore)
    local tween = State.Tween
    State.Tween, State.TweenTarget = nil, nil
    if State.TweenConnection then
        pcall(State.TweenConnection.Disconnect, State.TweenConnection)
        State.TweenConnection = nil
    end
    if tween then pcall(tween.Cancel, tween) end
    if restore then
        State.LastMoveRequest = -100
        TweenHoldUntil = 0
        RestorePhysics()
    end
end

StopTweenNow = function()
    State.Route = nil
    CancelTween(true)
    local _, _, root = SecretCharacter()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

TweenManager.CancelTweenOnly = function()
    CancelTween(false)
end

TweenManager.CancelCurrent = function()
    StopTweenNow()
end

local function AsCFrame(value)
    local kind = typeof(value)
    if kind == "CFrame" then return value end
    if kind == "Vector3" then return CFrame.new(value) end
    if kind == "Instance" then
        local ok, result = pcall(function()
            if value:IsA("BasePart") then return value.CFrame end
            if value:IsA("Model") then return value:GetPivot() end
            if value:IsA("Attachment") then return value.WorldCFrame end
            return nil
        end)
        if ok and typeof(result) == "CFrame" then return result end
    end
    return nil
end

local function HasRestrictedItem()
    local backpack = localPlayer:FindFirstChild("Backpack")
    local character = localPlayer.Character
    for _, name in ipairs({
        "God's Chalice", "Sweet Chalice", "Hallow Essence", "Red Key",
        "Apple", "Banana", "Pineapple", "Flower 1", "Flower 2", "Flower 3",
    }) do
        if (backpack and backpack:FindFirstChild(name)) or (character and character:FindFirstChild(name)) then
            return true
        end
    end
    return false
end

local function GetPhysicalPortalPairs()
    if os.clock() - State.LastPortalRefresh < 2 and State.PortalPairs then return State.PortalPairs end
    State.LastPortalRefresh = os.clock()
    local result = {}
    local map = Workspace:FindFirstChild("Map")
    local portal = map and map:FindFirstChild("TeleportSpawn", true)
    local entrance = portal and portal:FindFirstChild("Entrance", true)
    local exit = portal and portal:FindFirstChild("Exit", true)
    if entrance and exit and entrance:IsA("BasePart") and exit:IsA("BasePart") then
        table.insert(result, { Entrance = entrance, Exit = exit })
    end
    State.PortalPairs = result
    return result
end

local function FindPortalRoute(origin, destination)
    local direct = (destination - origin).Magnitude
    if direct < 3000 then return nil end
    local best, bestCost
    for _, pair in ipairs(GetPhysicalPortalPairs()) do
        for _, reverse in ipairs({ false, true }) do
            local source = reverse and pair.Exit or pair.Entrance
            local target = reverse and pair.Entrance or pair.Exit
            local from, to = AsCFrame(source), AsCFrame(target)
            if from and to then
                local cost = (origin - from.Position).Magnitude + (destination - to.Position).Magnitude + 150
                if cost + 1000 < direct and (not bestCost or cost < bestCost) then
                    bestCost = cost
                    best = { Source = source, Destination = target, From = from, To = to }
                end
            end
        end
    end
    return best
end