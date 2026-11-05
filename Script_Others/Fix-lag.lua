_G.Ignore        = _G.Ignore or {}
_G.ConsoleLogs   = _G.ConsoleLogs or false

_G.Settings = _G.Settings or {
    Players = {
        IgnoreMe     = false,
        IgnoreOthers = true,
        IgnoreTools  = true,
    },
    Meshes = {
        NoMesh    = false,
        NoTexture = true,
        Destroy   = false,
    },
    Images = {
        Invisible = true,
        Destroy   = false,
    },
    Explosions = {
        Smaller   = true,
        Invisible = false,
        Destroy   = false,
    },
    Particles = {
        Invisible = true,
        Destroy   = true,
    },
    TextLabels = {
        LowerQuality = false,
        Invisible    = false,
        Destroy      = false,
    },
    MeshParts = {
        LowerQuality = true,
        Invisible    = false,
        NoTexture    = true,
        NoMesh       = false,
        Destroy      = false,
    },
    Other = {
        FPSCap              = true,
        NoCameraEffects     = true,
        NoCameraShake       = true,
        NoClothes           = true,
        LowWaterGraphics    = true,
        NoShadows           = true,
        LowRendering        = true,
        LowQualityParts     = true,
        LowQualityModels    = true,
        ResetMaterials      = true,
        LowQualityMeshParts = true,
        ClearNilInstances   = false,
        NoVFX               = true,
        NoLoopSounds        = true,
    },
}

local Players           = game:GetService("Players")
local Lighting          = game:GetService("Lighting")
local MaterialService   = game:GetService("MaterialService")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer    = Players.LocalPlayer
local PARTICLE_TYPES = { "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles" }
local VFX_DESTROY    = {
    "Beam", "SelectionBox", "SelectionSphere", "Highlight",
    "BillboardGui", "SurfaceGui",
}
local VFX_DISABLE    = {
    "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles",
    "PointLight", "SpotLight", "SurfaceLight",
    "BlurEffect", "ColorCorrectionEffect", "SunRaysEffect",
    "BloomEffect", "DepthOfFieldEffect",
}
local SOUND_EFFECTS  = {
    "ReverbSoundEffect", "DistortionSoundEffect", "EchoSoundEffect",
    "EqualizerSoundEffect", "FlangeSoundEffect", "PitchShiftSoundEffect",
    "TremoloSoundEffect", "ChorusSoundEffect", "CompressorSoundEffect",
}

local function isIgnored(inst)
    if table.find(_G.Ignore, inst) then return true end
    for _, ignored in ipairs(_G.Ignore) do
        if inst:IsDescendantOf(ignored) then return true end
    end
    return false
end

local function shouldProcess(inst)
    if inst:IsDescendantOf(Players) then return false end
    if isIgnored(inst) then return false end
    if _G.Settings.Players.IgnoreOthers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and inst:IsDescendantOf(player.Character) then
                return false
            end
        end
    end
    if _G.Settings.Players.IgnoreTools and (inst:IsA("BackpackItem") or inst:FindFirstAncestorWhichIsA("BackpackItem")) then
        return false
    end
    return true
end

local function handleSound(inst)
    if not inst:IsA("Sound") then return end
    if not _G.Settings.Other.NoLoopSounds then return end
    pcall(function()
        if inst.Looped then
            inst.Looped  = false
            inst.Playing = false
            inst:Stop()
        end
        for _, fx in ipairs(inst:GetChildren()) do
            if table.find(SOUND_EFFECTS, fx.ClassName) then
                fx:Destroy()
            end
        end
    end)
end

local function nukeTextures(inst)
    pcall(function()
        if inst:IsA("MeshPart") then
            inst.TextureID      = ""
            inst.Reflectance    = 0
            inst.RenderFidelity = Enum.RenderFidelity.Automatic
            inst.CastShadow     = false
        elseif inst:IsA("SpecialMesh") then
            inst.TextureId = ""
            inst.MeshId    = ""
        elseif inst:IsA("SurfaceAppearance") then
            inst:Destroy()
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            inst:Destroy()
        elseif inst:IsA("BasePart") then
            inst.Material    = Enum.Material.Plastic
            inst.Reflectance = 0
            inst.CastShadow  = false
        end
    end)
end

local trackedEffects = setmetatable({}, { __mode = "k" })

local function nukeVFX(inst)
    pcall(function()
        if table.find(VFX_DESTROY, inst.ClassName) then
            inst:Destroy()
            return
        end
        if table.find(SOUND_EFFECTS, inst.ClassName) then
            inst:Destroy()
            return
        end
        if inst:IsA("PostEffect") or table.find(VFX_DISABLE, inst.ClassName) then
            if inst:IsA("ParticleEmitter") then
                inst.Enabled = false
                inst:Clear()
            elseif inst:IsA("Trail") or inst:IsA("Beam") then
                inst.Enabled = false
            elseif inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
                inst.Enabled = false
            elseif inst:IsA("PointLight") or inst:IsA("SpotLight") or inst:IsA("SurfaceLight") or inst:IsA("PostEffect") then
                inst.Enabled = false
            end
            if not trackedEffects[inst] and inst.Parent then
                trackedEffects[inst] = true
                pcall(function()
                    inst:GetPropertyChangedSignal("Enabled"):Connect(function()
                        if inst.Parent and inst.Enabled then
                            inst.Enabled = false
                            if inst:IsA("ParticleEmitter") then inst:Clear() end
                        end
                    end)
                end)
                if inst:IsA("ParticleEmitter") then
                    pcall(function()
                        inst:GetPropertyChangedSignal("Rate"):Connect(function()
                            if inst.Parent and inst.Rate > 0 then inst.Rate = 0 end
                        end)
                        inst.Rate = 0
                    end)
                end
            end
        end
    end)
end

local function processInstance(inst)
    if not shouldProcess(inst) then return end

    nukeVFX(inst)
    nukeTextures(inst)
    handleSound(inst)

    local cfg = _G.Settings

    if inst:IsA("SpecialMesh") then
        if cfg.Meshes.NoMesh    then pcall(function() inst.MeshId    = "" end) end
        if cfg.Meshes.NoTexture then pcall(function() inst.TextureId = "" end) end
        if cfg.Meshes.Destroy   then inst:Destroy() return end
    elseif inst:IsA("FaceInstance") then
        if cfg.Images.Invisible then pcall(function() inst.Transparency = 1; inst.Shiny = 1 end) end
        if cfg.Images.Destroy   then inst:Destroy() return end
    elseif inst:IsA("ShirtGraphic") then
        if cfg.Images.Invisible then pcall(function() inst.Graphic = "" end) end
        if cfg.Images.Destroy   then inst:Destroy() return end
    elseif table.find(PARTICLE_TYPES, inst.ClassName) then
        if cfg.Particles.Invisible then pcall(function() inst.Enabled = false end) end
        if cfg.Particles.Destroy   then inst:Destroy() return end
    elseif inst:IsA("Explosion") then
        if cfg.Explosions.Smaller or cfg.Explosions.Invisible then
            pcall(function() inst.BlastPressure = 1; inst.BlastRadius = 1 end)
        end
        if cfg.Explosions.Invisible then pcall(function() inst.Visible = false end) end
        if cfg.Explosions.Destroy   then inst:Destroy() return end
    elseif inst:IsA("Clothing") or inst:IsA("SurfaceAppearance") or inst:IsA("BaseWrap") then
        if cfg.Other.NoClothes then inst:Destroy() return end
    elseif inst:IsA("MeshPart") then
        if cfg.MeshParts.LowerQuality then
            pcall(function()
                inst.RenderFidelity = Enum.RenderFidelity.Automatic
                inst.Reflectance    = 0
                inst.CastShadow     = false
            end)
        end
        if cfg.MeshParts.NoTexture then pcall(function() inst.TextureID = "" end) end
        if cfg.MeshParts.NoMesh    then pcall(function() inst.MeshId    = "" end) end
        if cfg.MeshParts.Destroy   then inst:Destroy() return end
    elseif inst:IsA("BasePart") then
        if cfg.Other.LowQualityParts then
            pcall(function()
                inst.Material    = Enum.Material.Plastic
                inst.Reflectance = 0
                inst.CastShadow  = false
            end)
        end
    elseif inst:IsA("TextLabel") and inst:IsDescendantOf(workspace) then
        if cfg.TextLabels.LowerQuality then
            pcall(function()
                inst.Font       = Enum.Font.SourceSans
                inst.TextScaled = false
                inst.RichText   = false
                inst.TextSize   = 14
            end)
        end
        if cfg.TextLabels.Invisible then pcall(function() inst.Visible = false end) end
        if cfg.TextLabels.Destroy   then inst:Destroy() return end
    elseif inst:IsA("Model") then
        if cfg.Other.LowQualityModels then
            pcall(function() inst.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled end)
        end
    end
end

local function handleCharacterInst(inst)
    pcall(function()
        if inst:IsA("Clothing") or inst:IsA("SurfaceAppearance") or inst:IsA("BaseWrap") then
            inst:Destroy()
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            inst:Destroy()
        elseif inst:IsA("FaceInstance") then
            inst.Transparency = 1
        elseif inst:IsA("ShirtGraphic") then
            inst.Graphic = ""
        elseif inst:IsA("MeshPart") then
            inst.TextureID      = ""
            inst.Reflectance    = 0
            inst.RenderFidelity = Enum.RenderFidelity.Automatic
            inst.CastShadow     = false
        elseif inst:IsA("SpecialMesh") then
            inst.TextureId = ""
        elseif table.find(VFX_DESTROY, inst.ClassName) then
            inst:Destroy()
        elseif table.find(VFX_DISABLE, inst.ClassName) then
            inst.Enabled = false
        elseif table.find(SOUND_EFFECTS, inst.ClassName) then
            inst:Destroy()
        elseif inst:IsA("Sound") then
            handleSound(inst)
        end
    end)
end

local function stripCharacter(character)
    for _, inst in ipairs(character:GetDescendants()) do
        handleCharacterInst(inst)
    end
    character.DescendantAdded:Connect(function(inst)
        task.defer(handleCharacterInst, inst)
    end)
end

local function isNPC(model)
    if not model:FindFirstChildOfClass("Humanoid") then return false end
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character == model then return false end
    end
    return true
end

local function handleNPCInst(inst)
    pcall(function()
        if inst:IsA("Clothing") or inst:IsA("SurfaceAppearance") or inst:IsA("BaseWrap") then
            inst:Destroy()
        elseif inst:IsA("Decal") or inst:IsA("Texture") then
            inst:Destroy()
        elseif inst:IsA("FaceInstance") then
            inst.Transparency = 1
        elseif inst:IsA("ShirtGraphic") then
            inst.Graphic = ""
        elseif inst:IsA("MeshPart") then
            inst.TextureID      = ""
            inst.Reflectance    = 0
            inst.RenderFidelity = Enum.RenderFidelity.Automatic
            inst.Material       = Enum.Material.Plastic
            inst.Color          = Color3.fromRGB(163, 162, 165)
            inst.CastShadow     = false
        elseif inst:IsA("BasePart") then
            inst.Reflectance = 0
            inst.Material    = Enum.Material.Plastic
            inst.Color       = Color3.fromRGB(163, 162, 165)
            inst.CastShadow  = false
        elseif table.find(VFX_DESTROY, inst.ClassName) then
            inst:Destroy()
        elseif table.find(VFX_DISABLE, inst.ClassName) then
            inst.Enabled = false
        elseif table.find(SOUND_EFFECTS, inst.ClassName) then
            inst:Destroy()
        elseif inst:IsA("Sound") then
            handleSound(inst)
        end
    end)
end

local function stripNPC(model)
    for _, inst in ipairs(model:GetDescendants()) do
        handleNPCInst(inst)
    end
    model.DescendantAdded:Connect(function(inst)
        task.defer(handleNPCInst, inst)
    end)
end

local function stripPostEffects(parent)
    for _, inst in ipairs(parent:GetDescendants()) do
        if inst:IsA("PostEffect") then pcall(function() inst.Enabled = false end) end
    end
    parent.DescendantAdded:Connect(function(inst)
        if inst:IsA("PostEffect") then pcall(function() inst.Enabled = false end) end
    end)
end

stripPostEffects(Lighting)
stripPostEffects(workspace.CurrentCamera)
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then stripPostEffects(workspace.CurrentCamera) end
end)

if _G.Settings.Other.NoCameraShake then
    local shakeConn
    local function startShakeLock()
        if shakeConn then shakeConn:Disconnect() end
        shakeConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.CameraOffset = Vector3.zero end
            end
            local cam = workspace.CurrentCamera
            if cam then
                if cam.FieldOfView ~= 70 then cam.FieldOfView = 70 end
                local cx, cy, cz = cam.CFrame:ToEulerAnglesYXZ()
                if math.abs(cz) > 0.001 then
                    cam.CFrame = CFrame.new(cam.CFrame.Position) * CFrame.Angles(cx, cy, 0)
                end
            end
        end)
    end

    startShakeLock()
    LocalPlayer.CharacterAdded:Connect(startShakeLock)

    task.spawn(function()
        local util = ReplicatedStorage:FindFirstChild("Util")
        if not util then
            repeat task.wait() until ReplicatedStorage:FindFirstChild("Util")
            util = ReplicatedStorage:FindFirstChild("Util")
        end
        local shakeFolder = util and util:FindFirstChild("CameraShake")
        if not shakeFolder then return end
        local cameraShakeModule = shakeFolder:FindFirstChild("CameraShake")
        if not cameraShakeModule then return end
        local cameraShakeInstance = cameraShakeModule:FindFirstChild("CameraShakeInstance")
        if not cameraShakeInstance then return end
        local ok, inst = pcall(require, cameraShakeInstance)
        if ok and inst and inst.UpdateShake then
            inst.UpdateShake = function() return Vector3.zero, Vector3.zero end
        end
        local ok2, ctrl = pcall(require, cameraShakeModule)
        if ok2 and ctrl then
            local noop = function() end
            if ctrl.ShakeOnce     then ctrl.ShakeOnce     = noop end
            if ctrl.StartShake    then ctrl.StartShake    = noop end
            if ctrl.Shake         then ctrl.Shake         = noop end
            if ctrl.StopAllShakes then ctrl.StopAllShakes = noop end
        end
    end)

    task.spawn(function()
        if not hookfunction or not getrawmetatable or not setreadonly or not newcclosure then return end
        local ok, mt = pcall(getrawmetatable, game)
        if not ok or not mt then return end
        local oldNamecall = rawget(mt, "__namecall")
        if not oldNamecall then return end
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local ok2, method = pcall(getnamecallmethod)
            if ok2 and method and (method == "FireServer" or method == "InvokeServer") then
                local ok3, name = pcall(function() return self.Name:lower() end)
                if ok3 and name and (name:find("shake") or name:find("effect") or name:find("camera")) then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

if not game:IsLoaded() then game.Loaded:Wait() end

task.spawn(pcall, function()
    if not _G.Settings.Other.LowWaterGraphics then return end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if not terrain then
        repeat task.wait() until workspace:FindFirstChildOfClass("Terrain")
        terrain = workspace:FindFirstChildOfClass("Terrain")
    end
    terrain.WaterWaveSize     = 0
    terrain.WaterWaveSpeed    = 0
    terrain.WaterReflectance  = 0
    terrain.WaterTransparency = 0
    if sethiddenproperty then sethiddenproperty(terrain, "Decoration", false) end
end)

task.spawn(pcall, function()
    if not _G.Settings.Other.NoShadows then return end
    Lighting.GlobalShadows  = false
    Lighting.FogEnd         = 9e9
    Lighting.ShadowSoftness = 0
    if sethiddenproperty then sethiddenproperty(Lighting, "Technology", 2) end
end)

task.spawn(pcall, function()
    if not _G.Settings.Other.LowRendering then return end
    settings().Rendering.QualityLevel        = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
end)

task.spawn(pcall, function()
    if not _G.Settings.Other.ResetMaterials then return end
    for _, v in ipairs(MaterialService:GetChildren()) do v:Destroy() end
    MaterialService.Use2022Materials = false
end)

task.spawn(pcall, function()
    if not _G.Settings.Other.FPSCap then return end
    if not setfpscap then return end
    local cap = _G.Settings.Other.FPSCap
    if type(cap) == "number" then setfpscap(cap) else setfpscap(120) end
end)

task.spawn(pcall, function()
    if not _G.Settings.Other.ClearNilInstances then return end
    if not getnilinstances then return end
    for _, v in ipairs(getnilinstances()) do pcall(v.Destroy, v) end
end)

if LocalPlayer.Character then stripCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(stripCharacter)

local trackedNPCs = setmetatable({}, { __mode = "k" })

local function trackNPC(model)
    if not model or not model:IsA("Model") or trackedNPCs[model] or not isNPC(model) then return end
    trackedNPCs[model] = true
    stripNPC(model)
end

for _, inst in ipairs(workspace:GetDescendants()) do
    if inst:IsA("Model") then
        trackNPC(inst)
    end
end

workspace.DescendantAdded:Connect(function(inst)
    if inst:IsA("Model") then
        task.defer(trackNPC, inst)
    elseif inst:IsA("Humanoid") then
        local model = inst.Parent
        if model and model:IsA("Model") then
            task.defer(trackNPC, model)
        end
    end
end)

local initial = workspace:GetDescendants()
for i = 1, #initial do
    processInstance(initial[i])
    if i % 400 == 0 then task.wait() end
end

local pending = {}
local queued = setmetatable({}, { __mode = "k" })
local processing = false

local function queueProcess(inst)
    if not inst or queued[inst] then return end
    queued[inst] = true
    pending[#pending + 1] = inst
    if processing then return end
    processing = true
    task.spawn(function()
        local head = 1
        while head <= #pending do
            local batchEnd = math.min(head + 149, #pending)
            for i = head, batchEnd do
                local item = pending[i]
                queued[item] = nil
                if item and item.Parent then
                    processInstance(item)
                end
                pending[i] = false
            end
            head = batchEnd + 1
            task.wait()
        end
        table.clear(pending)
        processing = false
        if #pending > 0 then queueProcess(pending[1]) end
    end)
end

workspace.DescendantAdded:Connect(queueProcess)
Lighting.DescendantAdded:Connect(queueProcess)
ReplicatedStorage.DescendantAdded:Connect(queueProcess)
