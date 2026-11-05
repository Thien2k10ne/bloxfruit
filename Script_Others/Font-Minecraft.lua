-- Font Minecraft
local FONT_FILE       = "Minecraftia.ttf"
local FONT_URL        = "https://raw.githubusercontent.com/Overv/WebCraft/master/style/minecraftia.ttf"
local APPLY_3D        = true
local APPLY_CORE_GUI  = true
local REFRESH_TIME    = 1

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    return warn("[Font Changer]")
end

local ENV = (getgenv and getgenv()) or _G
if type(ENV) == "table" and type(ENV.FontChangerCleanup) == "function" then
    pcall(ENV.FontChangerCleanup)
end

local getAsset = getcustomasset or (syn and syn.getsynasset) or getsynasset
local TARGET_FONT_FACE = nil
local FALLBACK_FONT   = Enum.Font.Arcade

if getAsset then
    if not (isfile and isfile(FONT_FILE)) then
        local ok, data = pcall(function()
            return game:HttpGet(FONT_URL)
        end)
        if ok and data and writefile then
            pcall(function()
                writefile(FONT_FILE, data)
            end)
        end
    end

    if isfile and isfile(FONT_FILE) then
        local ok, assetUri = pcall(function()
            return getAsset(FONT_FILE)
        end)
        if ok and assetUri then
            pcall(function()
                TARGET_FONT_FACE = Font.new(assetUri, Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            end)
        end
    end
end

local TEXT_CLASSES = {
    TextLabel = true,
    TextButton = true,
    TextBox = true,
}

local stopped = false
local connections = {}

local function connect(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(connections, conn)
    return conn
end

local function applyTo(obj)
    if stopped or not obj or not obj.Parent then return end
    if not TEXT_CLASSES[obj.ClassName] then return end

    if TARGET_FONT_FACE then
        local ok = pcall(function()
            obj.FontFace = TARGET_FONT_FACE
        end)
        if ok then return end
    end

    pcall(function()
        obj.Font = FALLBACK_FONT
    end)
end

local function scan(root)
    if stopped or not root then return end

    if TEXT_CLASSES[root.ClassName] then
        applyTo(root)
    end

    local ok, descendants = pcall(function()
        return root:GetDescendants()
    end)
    if ok and type(descendants) == "table" then
        for _, inst in ipairs(descendants) do
            if TEXT_CLASSES[inst.ClassName] then
                applyTo(inst)
            end
        end
    end
end

local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

local function getRoots()
    local roots = { playerGui }
    if APPLY_3D then table.insert(roots, workspace) end
    if APPLY_CORE_GUI then
        pcall(function()
            local cg = game:GetService("CoreGui")
            if cg then table.insert(roots, cg) end
        end)
    end
    if gethui then
        pcall(function()
            local hui = gethui()
            if hui then table.insert(roots, hui) end
        end)
    end
    return roots
end

local function applyAll()
    for _, root in ipairs(getRoots()) do
        scan(root)
    end
end

local function hookEvents()
    local function onDescendantAdded(inst)
        if TEXT_CLASSES[inst.ClassName] then
            applyTo(inst)
        end
    end

    for _, root in ipairs(getRoots()) do
        connect(root.DescendantAdded, onDescendantAdded)
    end
end

if hookmetamethod then
    pcall(function()
        local oldNewIndex
        oldNewIndex = hookmetamethod(game, "__newindex", function(self, key, value)
            if not stopped and TEXT_CLASSES[self.ClassName] then
                if key == "FontFace" and TARGET_FONT_FACE then
                    return oldNewIndex(self, key, TARGET_FONT_FACE)
                elseif key == "Font" then
                    if TARGET_FONT_FACE then
                        pcall(function() self.FontFace = TARGET_FONT_FACE end)
                        return
                    else
                        return oldNewIndex(self, key, FALLBACK_FONT)
                    end
                end
            end
            return oldNewIndex(self, key, value)
        end)
    end)
end

hookEvents()
applyAll()

connect(LocalPlayer.CharacterAdded, function()
    task.delay(0.5, applyAll)
end)

task.spawn(function()
    while not stopped do
        task.wait(math.max(0.5, REFRESH_TIME))
        pcall(applyAll)
    end
end)

local function cleanup()
    stopped = true
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    connections = {}
    if type(ENV) == "table" and ENV.FontChangerCleanup == cleanup then
        ENV.FontChangerCleanup = nil
    end
end

if type(ENV) == "table" then
    ENV.FontChangerCleanup = cleanup
end

return cleanup
