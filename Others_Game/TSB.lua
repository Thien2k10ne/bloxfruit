--[[untitled boxing game auto né tránh 
bản  thử nghiệm vì chưa dump được game!!!
tôi không để link nguồn được nhưng đây là opne scoure]] 
loadstring(game:HttpGet("https://raw.githubusercontent.com/SBeZ-Real/sostest/refs/heads/main/ubgtestscript"))()
--[[ local player = game.Players.LocalPlayer
local RS = game.RunService
local ReplicatedStorage = game.ReplicatedStorage

local lastPerfect
local perfectConnection

if getgenv().dodge then
    getgenv().dodge:Disconnect()
end

if getgenv().dodgeChar then
    getgenv().dodgeChar:Disconnect()
end

if getgenv().dodgePerfect then
    getgenv().dodgePerfect:Disconnect()
end

local function getState()
    local states = game.Workspace:FindFirstChild("States")

    if not states then
        return
    end

    return states:FindFirstChild(player.Name)
end

local function getOpponent()
    local state = getState()

    if not state then
        return
    end

    local occupied = state:FindFirstChild("Occupied")

    if not occupied then
        return
    end

    local locked = occupied:FindFirstChild("LockedOn")

    if locked then
        return locked.Value
    end
end

local function dashing()
    local state = getState()

    if not state then
        return false
    end

    local occupied = state:FindFirstChild("Occupied")

    if not occupied then
        return false
    end

    local dash = occupied:FindFirstChild("Dashing")

    if dash then
        return dash.Value
    end

    return false
end

local function dodge()
    local character = player.Character

    if not character then
        return
    end

    local perfect = character:GetAttribute("Perfect")

    if perfect == nil or perfect == lastPerfect then
        return
    end

    local direction = character:GetAttribute("NeededDirection")

    if direction ~= "Left" and direction ~= "Right" and direction ~= "Backward" and direction ~= "Forward" then
        return
    end

    local opponent = getOpponent()

    if not opponent then
        return
    end

    if opponent:GetAttribute("IsFeinting") == true or opponent:GetAttribute("LocalIsFeinting") == true then
        return
    end

    if dashing() then
        return
    end

    local events = ReplicatedStorage:FindFirstChild("Events")
    local dash = events and events:FindFirstChild("ForceDash")

    if not dash then
        return
    end

    lastPerfect = perfect

    local function tryDash()
        if player.Character ~= character then
            return false
        end

        if character:GetAttribute("Perfect") ~= perfect then
            return false
        end

        local currentDirection = character:GetAttribute("NeededDirection")

        if currentDirection ~= "Left" and currentDirection ~= "Right" and currentDirection ~= "Backward" and currentDirection ~= "Forward" then
            return false
        end

        local currentOpponent = getOpponent()

        if not currentOpponent then
            return false
        end

        if currentOpponent:GetAttribute("IsFeinting") == true or currentOpponent:GetAttribute("LocalIsFeinting") == true then
            return false
        end

        if dashing() then
            return false
        end

        dash:Fire({Direction = currentDirection})

        return true
    end

    tryDash()

    RS.Heartbeat:Once(function()
        if not tryDash() then
            return
        end

        RS.Heartbeat:Once(function()
            tryDash()
        end)
    end)
end

local function bindCharacter(character)
    lastPerfect = nil

    if getgenv().dodgePerfect then
        getgenv().dodgePerfect:Disconnect()
        getgenv().dodgePerfect = nil
    end

    getgenv().dodgePerfect = character:GetAttributeChangedSignal("Perfect"):Connect(function()
        dodge()
    end)
end

getgenv().dodge = RS.Heartbeat:Connect(function()
    local character = player.Character

    if not character then
        return
    end

    if not getgenv().dodgePerfect or not getgenv().dodgePerfect.Connected then
        bindCharacter(character)
    end
end)

getgenv().dodgeChar = player.CharacterAdded:Connect(function(character)
    bindCharacter(character)
end)

if player.Character then
    bindCharacter(player.Character)
end]]
