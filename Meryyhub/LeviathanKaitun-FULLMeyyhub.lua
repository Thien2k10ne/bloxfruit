--[[
    MEYY HUB - KAITUN LEVIATHAN - SCRIPT COMPLETO DESCIFRADO (100% AUTOCONTENIDO)
    ------------------------------------------------------------------
    - Extraido del servidor de meyyhub con tu key (naa-21ETAU5C) y tu HWID.
    - Sin autenticacion, sin anti-tamper, sin checks de key: codigo puro.
    - SIN DEPENDENCIAS EXTERNAS: los modulos que antes se descargaban de
      pastefy estan incrustados dentro (buscar "[INLINE" para verlos).
    - Funciones: Hunt Leviathan, Craft Scrolls, Shop & Status, Webhook Config, Selection Skill
    - Para usarlo: pega/ejecuta este archivo completo en tu executor.
]]
Services = setmetatable({}, {__index = function(self, name)
    local s, c = pcall(function() return cloneref(game:GetService(name)) end)
    if s then rawset(self, name, c) return c
    else error("Invalid Roblox Service: " .. tostring(name)) end
end})
Players = Services.Players
LP = Players.LocalPlayer
ReplicatedStorage = Services.ReplicatedStorage
RunService = game:GetService("RunService")
TweenService = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
VirtualInputManager = game:GetService("VirtualInputManager")
VirtualUser = game:GetService("VirtualUser")
HttpService = game:GetService("HttpService")
Workspace = workspace
Camera = workspace.CurrentCamera
local MapFolder = Workspace:WaitForChild("Map", 5)
local _WaterBasePlane = MapFolder and MapFolder:FindFirstChild("WaterBase-Plane")

_G.ChonPhe = "Marines"
_G.BatNoclip = true
_G.TocDoTween = 170
_G.TocDoTweenBoat = 250
_G.XoaSuongMu = true
_G.NguoiMuaThuyen = LP.Name
_G.SoNguoiCanThiet = 5
_G.ChieuCaoBay = 20
_G.DangSan = false
_G.ChoPhepDiChuyen = false
_G.TenThuyen = "Beast Hunter"
_G.SpinPosition = true
_G.SelectedWeapon = "Melee"
_G.UseGunEvent = false
_G.UseM1FruitEvent = false
_G.EnableIgnoreIsland = true
_G.EnableIgnoreSeaEvent = true
_G.IgnoreHeight = 500
_G.IgnoreIslandHeight = 800
_G.SelectedEvents = {"Leviathan"}
_G.SelectedMelee = {"Z", "X", "C"}
_G.SelectedFruit = {"Z", "X", "C", "F"}
_G.SelectedGun = {"Z", "X"}
_G.SelectedScrolls = {}
_G.AutoCraftScrollSwitch = false
_G.SelectedSword = {"Z", "X"}
_G.ShootHeart = false
_G.DestroyIDK = false
_G.AutoRandomFruit = true
_G.AutoStoreFruit = true
_G.PullYHeight = 35
_G.SpyCheckResult = -1
_G.FoundLeviathanGate = false
_G.LastHRPPosition = nil
_G.DriveToTiki = false
_G.DriveToHydra = false
_G.DangKeoTim = false
_G.WebhookLevi = {
    Enabled = false,
    Url = "",
    DiscordID = "",
    PingEnabled = false,
    NotifyWatcher = false,
    NotifyShoot = false,
    NotifyDelivered = false,
    NotifyInventory = false
}

local DISCORD_THEME = {
    color = 16762567, -- #FFC6C7 (Pastel Pink)
    thumbnail = "https://cdn.discordapp.com/attachments/1540565014937739394/1540692132568895588/b006e4745cec6a9c6130b5360c63699f.png",
    footerIcon = "https://cdn.discordapp.com/attachments/1540565014937739394/1540690154317160448/tai_xuong.png",
    heart = "<a:a_afx_heart_2_pink:1540683293954015263>",
    rabbit = "<a:ast_dcr_thovotay:1540657913985630299>",
    key = "<a:p_key01:1540681875067113552>",
    diamond = "<a:p_diamond01:1540686688505036830>",
    online = "<a:pent_online_scr:1540681158512214086>",
    cloud = "<a:ast_cloud:1540681581939654737>",
    booster = "<:JBVBoosterIcon:1540681208223236098>",
    leftWing = "<a:p_wing03:1540688176253771846>",
    rightWing = "<a:p_wing04:1540688262421680130>"
}

local function safeCountItem(itemName)
    if CountItem then
        local s, res = pcall(CountItem, itemName)
        if s and type(res) == "number" then return res end
    end
    local s, res = pcall(function()
        local RS = game:GetService("ReplicatedStorage")
        local IRS = require(RS:WaitForChild("ItemReplicationService", 2))
        local KEYS_MOD = require(RS.ItemReplicationService:WaitForChild("KEYS", 2))
        local IC = require(RS:WaitForChild("ItemConfig", 2))
        local qItems = IRS:GetItems(KEYS_MOD.QUANTITY)
        if not qItems then return 0 end
        local targetClean = string.lower(string.gsub(itemName, "%s+", ""))
        for _, item in pairs(qItems) do
            local rawName = IC.match(item.ItemId):unwrap().Index.DebugLabel
            local cleanName = string.match(rawName, "^(.-)%s*%[") or rawName
            if string.lower(string.gsub(cleanName, "%s+", "")) == targetClean then
                return item.Value or 0
            end
        end
        return 0
    end)
    return (s and res) or 0
end

local function sendLeviWebhook(eventType, details)
    if not _G.WebhookLevi or not _G.WebhookLevi.Enabled or _G.WebhookLevi.Url == "" then
        return
    end

    if (eventType == "Found Frozen Dimension" or eventType == "Found Watcher") and not _G.WebhookLevi.NotifyWatcher then
        return
    elseif (eventType == "Heart Shooted" or eventType == "Heart Harpooned") and not _G.WebhookLevi.NotifyShoot then
        return
    elseif (eventType == "Heart Delivered") and not _G.WebhookLevi.NotifyDelivered then
        return
    end

    local url = _G.WebhookLevi.Url
    local pingString = ""
    if _G.WebhookLevi.PingEnabled then
        if _G.WebhookLevi.DiscordID and _G.WebhookLevi.DiscordID ~= "" then
            pingString = "<@" .. tostring(_G.WebhookLevi.DiscordID) .. ">"
        else
            pingString = "@everyone"
        end
    end

    local data = {
        ["username"] = "ʚ ᙏᥱყყ♡Bot ɞ",
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120553734766713/cte_2.jfif",
        ["embeds"] = {{
            ["author"] = {
                ["name"] = "Meyy Hub • Leviathan Tracking Service",
                ["icon_url"] = DISCORD_THEME.footerIcon
            },
            ["title"] = DISCORD_THEME.heart .. " MEYY HUB - LEVIATHAN EVENT " .. DISCORD_THEME.heart,
            ["description"] = "> " .. DISCORD_THEME.online .. " Status Update: **" .. tostring(eventType) .. "**\n> *" .. DISCORD_THEME.leftWing .. " Automated Leviathan Hunt Assistant " .. DISCORD_THEME.rightWing .. "*\n\u{200B}",
            ["color"] = DISCORD_THEME.color,
            ["fields"] = {
                {
                    ["name"] = DISCORD_THEME.rabbit .. " Player",
                    ["value"] = "```text\n" .. tostring(LP.Name) .. "\n```",
                    ["inline"] = true
                },
                {
                    ["name"] = DISCORD_THEME.booster .. " Boat Buyer",
                    ["value"] = "```text\n" .. tostring(_G.NguoiMuaThuyen) .. "\n```",
                    ["inline"] = true
                },
                {
                    ["name"] = DISCORD_THEME.diamond .. " Event Details",
                    ["value"] = "```text\n" .. tostring(details or "Success") .. "\n```",
                    ["inline"] = false
                },
                {
                    ["name"] = DISCORD_THEME.cloud .. " Server JobId",
                    ["value"] = "```text\n" .. tostring(game.JobId) .. "\n```",
                    ["inline"] = false
                }
            },
            ["thumbnail"] = {
                ["url"] = DISCORD_THEME.thumbnail
            },
            ["footer"] = {
                ["text"] = "Meyy Hub Webhook • Fast & Automated Environment | " .. os.date("%H:%M:%S %d/%m/%Y"),
                ["icon_url"] = DISCORD_THEME.footerIcon
            }
        }}
    }
    
    if pingString ~= "" then
        data["content"] = pingString
    end

    pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
        if req then
            req({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        end
    end)
end

local function sendLeviInventoryWebhook(destination)
    if not _G.WebhookLevi or not _G.WebhookLevi.Enabled or _G.WebhookLevi.Url == "" or not _G.WebhookLevi.NotifyInventory then
        return
    end

    local url = _G.WebhookLevi.Url
    local pingString = ""
    if _G.WebhookLevi.PingEnabled then
        if _G.WebhookLevi.DiscordID and _G.WebhookLevi.DiscordID ~= "" then
            pingString = "<@" .. tostring(_G.WebhookLevi.DiscordID) .. ">"
        else
            pingString = "@everyone"
        end
    end

    local items = {
        "Leviathan Heart",
        "Leviathan Scale",
        "Mutant Tooth",
        "Terror Eyes",
        "Electric Wing",
        "Shark Tooth",
        "Fool's Gold",
        "Common Scroll",
        "Rare Scroll",
        "Legendary Scroll",
        "Mythical Scroll"
    }

    local fields = {
        {
            ["name"] = DISCORD_THEME.rabbit .. " Player",
            ["value"] = "```text\n" .. tostring(LP.Name) .. "\n```",
            ["inline"] = true
        },
        {
            ["name"] = DISCORD_THEME.booster .. " Delivered At",
            ["value"] = "```text\n" .. tostring(destination or "Island") .. "\n```",
            ["inline"] = true
        }
    }

    for _, itemName in ipairs(items) do
        local count = safeCountItem(itemName)
        table.insert(fields, {
            ["name"] = DISCORD_THEME.key .. " " .. itemName,
            ["value"] = "```text\n" .. tostring(count) .. "\n```",
            ["inline"] = true
        })
    end

    local data = {
        ["username"] = "ʚ ᙏᥱყყ♡Bot ɞ",
        ["avatar_url"] = "https://cdn.discordapp.com/attachments/1483412809957113917/1505120553734766713/cte_2.jfif",
        ["embeds"] = {{
            ["author"] = {
                ["name"] = "Meyy Store • Inventory Tracking Summary",
                ["icon_url"] = DISCORD_THEME.footerIcon
            },
            ["title"] = DISCORD_THEME.heart .. " LEVIATHAN MATERIALS STATS " .. DISCORD_THEME.heart,
            ["description"] = "> " .. DISCORD_THEME.online .. " Inventory summary updated after claiming heart!\n> *" .. DISCORD_THEME.leftWing .. " All drops and marine materials synchronized " .. DISCORD_THEME.rightWing .. "*\n\u{200B}",
            ["color"] = DISCORD_THEME.color,
            ["fields"] = fields,
            ["thumbnail"] = {
                ["url"] = DISCORD_THEME.thumbnail
            },
            ["footer"] = {
                ["text"] = "Meyy Hub Webhook • Fast & Automated Environment | " .. os.date("%H:%M:%S %d/%m/%Y"),
                ["icon_url"] = DISCORD_THEME.footerIcon
            }
        }}
    }
    
    if pingString ~= "" then
        data["content"] = pingString
    end

    pcall(function()
        local jsonData = HttpService:JSONEncode(data)
        local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
        if req then
            req({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = jsonData
            })
        end
    end)
end
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local spycheck = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("InfoLeviathan", "1")
            if spycheck then
                _G.SpyCheckResult = spycheck
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(30) do
        pcall(function()
            if _G.SpyCheckResult ~= 5 and _G.SpyCheckResult > -1 then
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("InfoLeviathan", "2")
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local mapFolder = workspace:FindFirstChild("Map") or workspace:WaitForChild("Map", 5)
            if mapFolder then
                local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
                if waterPlane and waterPlane.Size ~= Vector3.new(1000, 112, 1000) then
                    waterPlane.Size = Vector3.new(1000, 112, 1000)
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("SetTeam", _G.ChonPhe)
            end)
        end
    end
end)

repeat
    task.wait(0.5)
until LP.Team ~= nil and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")


local Themes = {
    ["Dark"] = {
        Background = Color3.fromRGB(15, 15, 15),
        Darker = Color3.fromRGB(8, 8, 8),
        ContainerBg = Color3.fromHex("#525252"),
        ContainerTrans = 0.6,
        PillBack = Color3.fromRGB(20, 25, 30),
        Text = Color3.fromHex("#FFFFFF"),
        TextDim = Color3.fromHex("#808080"),
        Red = Color3.fromRGB(255, 60, 60),
        Green = Color3.fromRGB(130, 255, 100),
        Active = Color3.fromHex("#888888"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#808080")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#D3D3D3")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#000000"))
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
        StrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.25, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.75, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
        })
    },


    ["Dream"] = {
        Background = Color3.fromHex("#0A1428"),
        Darker = Color3.fromHex("#050A14"),
        ContainerBg = Color3.fromHex("#151C3B"),
        ContainerTrans = 0.5,
        PillBack = Color3.fromHex("#0D162C"),
        Text = Color3.fromHex("#E6FFFF"),
        TextDim = Color3.fromHex("#FFFFFF"),
        Red = Color3.fromHex("#FF3C3C"),
        Green = Color3.fromHex("#82FF64"),
        Active = Color3.fromHex("#8C64FF"),
        TextContrast = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.50, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        TextGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#B4FFFF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#A08CFF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        }),
        RowStroke = Color3.fromHex("#808080"),
        RowStrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#46E6FF"))
        }),
        StrokeGrad = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#8C64FF")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#46E6FF")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#8C64FF"))
        })
    },
["Candy"] = {
		Background = Color3.fromHex("#1C0F14"),
		Darker = Color3.fromHex("#12090D"),
		ContainerBg = Color3.fromHex("#331822"),
		ContainerTrans = 0.5,
		PillBack = Color3.fromHex("#26111A"),
		Text = Color3.fromHex("#FFFFFF"),
		TextDim = Color3.fromHex("#F2B8CA"),
		Red = Color3.fromRGB(255, 60, 60),
		Green = Color3.fromRGB(130, 255, 100),
		Active = Color3.fromHex("#FFFFFF"),
		TextContrast = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.50, Color3.fromHex("#E16389")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#E16389")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#C8A2C8"))
		}),
		RowStroke = Color3.fromHex("#808080"),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#E16389")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		StrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#E16389")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#C8A2C8"))
		})
	},
	["Lavender"] = {
		Background = Color3.fromHex("#14101A"),
		Darker = Color3.fromHex("#0D0A12"),
		ContainerBg = Color3.fromHex("#251D30"),
		ContainerTrans = 0.5,
		PillBack = Color3.fromHex("#1B1524"),
		Text = Color3.fromHex("#FFFFFF"),
		TextDim = Color3.fromHex("#D8C8EA"),
		Red = Color3.fromRGB(255, 60, 60),
		Green = Color3.fromRGB(130, 255, 100),
		Active = Color3.fromHex("#FFFFFF"),
		TextContrast = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.50, Color3.fromHex("#B589D6")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#B589D6")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#9966CC"))
		}),
		RowStroke = Color3.fromHex("#808080"),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#B589D6")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		StrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#B589D6")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#8A2BE2"))
		})
	},



	["Sky"] = {
		Background = Color3.fromHex("#0F161C"),
		Darker = Color3.fromHex("#090E12"),
		ContainerBg = Color3.fromHex("#1B2733"),
		ContainerTrans = 0.5,
		PillBack = Color3.fromHex("#141D26"),
		Text = Color3.fromHex("#FFFFFF"),
		TextDim = Color3.fromHex("#C2E2F5"),
		Red = Color3.fromRGB(255, 60, 60),
		Green = Color3.fromRGB(130, 255, 100),
		Active = Color3.fromHex("#FFFFFF"),
		TextContrast = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.50, Color3.fromHex("#70C1B3")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#70C1B3")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#5B9BD5"))
		}),
		RowStroke = Color3.fromHex("#808080"),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#70C1B3")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		StrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#70C1B3")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#4A90E2"))
		})
	},



	["Luxury"] = {
		Background = Color3.fromHex("#1A1712"),
		Darker = Color3.fromHex("#100E0A"),
		ContainerBg = Color3.fromHex("#302A20"),
		ContainerTrans = 0.5,
		PillBack = Color3.fromHex("#221E16"),
		Text = Color3.fromHex("#FFFFFF"),
		TextDim = Color3.fromHex("#EAE0C8"),
		Red = Color3.fromRGB(255, 60, 60),
		Green = Color3.fromRGB(130, 255, 100),
		Active = Color3.fromHex("#FFFFFF"),
		TextContrast = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.50, Color3.fromHex("#F4D03F")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#F4D03F")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#D4AC0D"))
		}),
		RowStroke = Color3.fromHex("#808080"),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#F4D03F")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		StrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#F4D03F")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#B7950B"))
		})
	},



	["Mint"] = {
		Background = Color3.fromHex("#0F1A17"),
		Darker = Color3.fromHex("#09100E"),
		ContainerBg = Color3.fromHex("#1B302B"),
		ContainerTrans = 0.5,
		PillBack = Color3.fromHex("#142420"),
		Text = Color3.fromHex("#FFFFFF"),
		TextDim = Color3.fromHex("#C2EAE2"),
		Red = Color3.fromRGB(255, 60, 60),
		Green = Color3.fromRGB(130, 255, 100),
		Active = Color3.fromHex("#FFFFFF"),
		TextContrast = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.50, Color3.fromHex("#56C596")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		TextGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#56C596")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#329D9C"))
		}),
		RowStroke = Color3.fromHex("#808080"),
		RowStrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#56C596")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
		}),
		StrokeGrad = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#FFFFFF")),
			ColorSequenceKeypoint.new(0.5, Color3.fromHex("#56C596")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("#205072"))
		})
	},
}

local CurrentThemeName = "Dark"
local Theme = Themes[CurrentThemeName]
local UI_Elements = {
    Backgrounds = {},
    ContainerBgs = {},
    PillBacks = {},
    Texts = {},
    TextDims = {},
    RowStrokes = {},
    DarkerStrokes = {},
    TextGrads = {},
    ContrastGrads = {},
    RowStrokeGrads = {},
    MainStrokeGrads = {}
}
local StrokeGradients = {}
local AnimatedGradients = {}
local ValueLabels = {}



local function ChangeTheme(themeName)
    if not Themes[themeName] or CurrentThemeName == themeName then return end
    CurrentThemeName = themeName
    local newT = Themes[themeName]
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local function applySpatialWave(obj, tweenProps, directProps)
        local guiObj = obj
        if not guiObj:IsA("GuiObject") then
            guiObj = guiObj.Parent
        end

        local delayTime = 0
        if guiObj and guiObj:IsA("GuiObject") then
            local posX = guiObj.AbsolutePosition.X
            local posY = guiObj.AbsolutePosition.Y
            delayTime = (posX + posY) / 3500 
        end

        task.delay(delayTime, function()
            if tweenProps then
                TweenService:Create(obj, tweenInfo, tweenProps):Play()
            end
            if directProps then
                for k, v in pairs(directProps) do
                    obj[k] = v
                end
            end
        end)
    end

    for _, obj in pairs(UI_Elements.Backgrounds) do applySpatialWave(obj, {BackgroundColor3 = newT.Background}) end
    for _, obj in pairs(UI_Elements.ContainerBgs) do applySpatialWave(obj, {BackgroundColor3 = newT.ContainerBg, BackgroundTransparency = newT.ContainerTrans}) end
    for _, obj in pairs(UI_Elements.PillBacks) do applySpatialWave(obj, {BackgroundColor3 = newT.PillBack}) end
    for _, obj in pairs(UI_Elements.Texts) do applySpatialWave(obj, {TextColor3 = newT.Text}) end
    for _, obj in pairs(UI_Elements.TextDims) do applySpatialWave(obj, {TextColor3 = newT.TextDim}) end
    for _, obj in pairs(UI_Elements.RowStrokes) do applySpatialWave(obj, {Color = newT.RowStroke}) end
    for _, obj in pairs(UI_Elements.DarkerStrokes) do applySpatialWave(obj, {Color = newT.Darker}) end

    for _, grad in pairs(UI_Elements.TextGrads) do applySpatialWave(grad, nil, {Color = newT.TextGrad}) end
    for _, grad in pairs(UI_Elements.ContrastGrads) do applySpatialWave(grad, nil, {Color = newT.TextContrast}) end
    for _, grad in pairs(UI_Elements.RowStrokeGrads) do applySpatialWave(grad, nil, {Color = newT.RowStrokeGrad}) end
    for _, grad in pairs(UI_Elements.MainStrokeGrads) do applySpatialWave(grad, nil, {Color = newT.StrokeGrad}) end
end

local KaitunGui = Instance.new("ScreenGui")
KaitunGui.Name = "Meyy6RaceV3"
KaitunGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KaitunGui.ResetOnSpawn = false

if gethui then
    KaitunGui.Parent = gethui()
else
    KaitunGui.Parent = CoreGui
end


local function MakeDraggable(topbar, object)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(object, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end

    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end


local function CreateButtonEffects(button, visualTarget)
    local target = visualTarget or button
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = target

    button.MouseEnter:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1.05}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 1}):Play()
    end)

    button.MouseButton1Down:Connect(function()
        TweenService:Create(scale, TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Scale = 0.8}):Play()
    end)

    button.MouseButton1Up:Connect(function()
        local t1 = TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1.3})
        t1:Play()
        t1.Completed:Connect(function()
            TweenService:Create(scale, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end)
    end)
end


local function ApplyTextGradient(obj, isContrast)
    obj.TextColor3 = Theme.Text
    table.insert(UI_Elements.Texts, obj)
    
    local grad = Instance.new("UIGradient", obj)
    grad.Rotation = 90
    grad.Color = isContrast and Theme.TextContrast or Theme.TextGrad
    if isContrast then
        table.insert(UI_Elements.ContrastGrads, grad)
    else
        table.insert(UI_Elements.TextGrads, grad)
    end
    
    local shadow = Instance.new("UIStroke")
    shadow.Color = Theme.Darker
    shadow.Thickness = 0.5
    shadow.Transparency = 0
    shadow.Parent = obj
    table.insert(UI_Elements.DarkerStrokes, shadow)
    
    return grad
end
local MainWidth = 300
local MainHeight = 375

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, MainWidth, 0, MainHeight)
MainFrame.Position = UDim2.new(0, 60, 0, 15)
MainFrame.AnchorPoint = Vector2.new(0, 0)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.Visible = true
MainFrame.Parent = KaitunGui
table.insert(UI_Elements.Backgrounds, MainFrame)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 255, 255)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local MainStrokeGrad = Instance.new("UIGradient")
MainStrokeGrad.Color = Theme.StrokeGrad
MainStrokeGrad.Parent = MainStroke
table.insert(StrokeGradients, MainStrokeGrad)
table.insert(UI_Elements.MainStrokeGrads, MainStrokeGrad)

local ToggleContainer = Instance.new("Frame")
ToggleContainer.Name = "ToggleTab"
ToggleContainer.Size = UDim2.new(0, 35, 0, 35)
ToggleContainer.Position = UDim2.new(0, 15, 0, 120)
ToggleContainer.BackgroundColor3 = Theme.Background
ToggleContainer.BackgroundTransparency = 0.2
ToggleContainer.BorderSizePixel = 0
ToggleContainer.Parent = KaitunGui
table.insert(UI_Elements.Backgrounds, ToggleContainer)

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleContainer

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleContainer

local ToggleGrad = Instance.new("UIGradient")
ToggleGrad.Color = Theme.StrokeGrad
ToggleGrad.Parent = ToggleStroke
table.insert(StrokeGradients, ToggleGrad)
table.insert(UI_Elements.MainStrokeGrads, ToggleGrad)

local ToggleIcon = Instance.new("TextLabel")
ToggleIcon.Size = UDim2.new(1, 0, 1, 0)
ToggleIcon.BackgroundTransparency = 1
ToggleIcon.Text = "<"
ToggleIcon.Font = Enum.Font.GothamBold
ToggleIcon.TextSize = 16
ToggleIcon.Rotation = 180
ToggleIcon.Parent = ToggleContainer
ApplyTextGradient(ToggleIcon, false)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = ""
ToggleBtn.Parent = ToggleContainer
CreateButtonEffects(ToggleBtn, ToggleContainer)

local ContentWrapper = Instance.new("Frame")
ContentWrapper.Size = UDim2.new(1, -20, 1, -20)
ContentWrapper.Position = UDim2.new(0, 10, 0, 10)
ContentWrapper.BackgroundTransparency = 1
ContentWrapper.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ContentWrapper
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder


local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 25)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.LayoutOrder = 0
HeaderFrame.Parent = ContentWrapper

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, 0, 1, 0)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "MEYY HUB | Leviathan Tracker"
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextSize = 14
TitleLbl.TextXAlignment = Enum.TextXAlignment.Center
TitleLbl.Parent = HeaderFrame
ApplyTextGradient(TitleLbl, false)

local TopSpacer = Instance.new("Frame")
TopSpacer.Size = UDim2.new(1, 0, 0, 3)
TopSpacer.BackgroundTransparency = 1
TopSpacer.LayoutOrder = 1
TopSpacer.Parent = ContentWrapper

local TopDivider = Instance.new("Frame")
TopDivider.Size = UDim2.new(1, -10, 0, 1)
TopDivider.Position = UDim2.new(0, 5, 0, 0)
TopDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopDivider.BorderSizePixel = 0
TopDivider.LayoutOrder = 2
TopDivider.Parent = ContentWrapper

local TopDivGrad = Instance.new("UIGradient")
TopDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 1)
})
TopDivGrad.Parent = TopDivider


local TaskBlock = Instance.new("Frame")
TaskBlock.Size = UDim2.new(1, 0, 0, 42)
TaskBlock.BackgroundColor3 = Theme.PillBack
TaskBlock.BackgroundTransparency = 0.2
TaskBlock.BorderSizePixel = 0
TaskBlock.LayoutOrder = 3
TaskBlock.Parent = ContentWrapper
Instance.new("UICorner", TaskBlock).CornerRadius = UDim.new(0, 8)
table.insert(UI_Elements.PillBacks, TaskBlock)

local StatusDotFrame = Instance.new("Frame")
StatusDotFrame.Size = UDim2.new(0, 24, 0, 24)
StatusDotFrame.Position = UDim2.new(0, 12, 0.5, -12)
StatusDotFrame.BackgroundTransparency = 1
StatusDotFrame.Parent = TaskBlock

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 10, 0, 10)
StatusDot.Position = UDim2.new(0.5, -5, 0.5, -5)
StatusDot.BackgroundColor3 = Theme.Green
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusDotFrame
Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

local StatusAction = Instance.new("TextLabel")
StatusAction.Size = UDim2.new(1, -45, 1, 0)
StatusAction.Position = UDim2.new(0, 42, 0, 0)
StatusAction.BackgroundTransparency = 1
StatusAction.Text = "Idle"
StatusAction.TextColor3 = Theme.Text
StatusAction.Font = Enum.Font.GothamBold
StatusAction.TextSize = 15
StatusAction.TextXAlignment = Enum.TextXAlignment.Left
StatusAction.Parent = TaskBlock
table.insert(UI_Elements.Texts, StatusAction)
ValueLabels["CurrentTask"] = StatusAction

local function CreateSingleContainer(parent, layoutOrder, keyText, defaultVal)
    local Block = Instance.new("Frame")
    Block.Size = UDim2.new(1, 0, 0, 32)
    Block.BackgroundColor3 = Theme.ContainerBg
    Block.BackgroundTransparency = Theme.ContainerTrans
    Block.LayoutOrder = layoutOrder
    Block.Parent = parent
    Instance.new("UICorner", Block).CornerRadius = UDim.new(0, 6)
    table.insert(UI_Elements.ContainerBgs, Block)

    local Stroke = Instance.new("UIStroke", Block)
    Stroke.Color = Theme.RowStroke
    Stroke.Thickness = 1
    table.insert(UI_Elements.RowStrokes, Stroke)
    
    local StrokeGrad = Instance.new("UIGradient", Stroke)
    StrokeGrad.Color = Theme.RowStrokeGrad
    table.insert(AnimatedGradients, StrokeGrad)
    table.insert(UI_Elements.RowStrokeGrads, StrokeGrad)

    local KeyLbl = Instance.new("TextLabel")
    KeyLbl.Size = UDim2.new(0.5, -5, 1, 0)
    KeyLbl.Position = UDim2.new(0, 12, 0, 0)
    KeyLbl.BackgroundTransparency = 1
    KeyLbl.Text = keyText .. ":"
    KeyLbl.TextColor3 = Theme.TextDim
    KeyLbl.Font = Enum.Font.GothamBold
    KeyLbl.TextSize = 12
    KeyLbl.TextXAlignment = Enum.TextXAlignment.Left
    KeyLbl.Parent = Block
    table.insert(UI_Elements.TextDims, KeyLbl)
    
    local ValLbl = Instance.new("TextLabel")
    ValLbl.Size = UDim2.new(0.5, -15, 1, 0)
    ValLbl.Position = UDim2.new(0.5, 5, 0, 0)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = defaultVal
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 13
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.Parent = Block
    ApplyTextGradient(ValLbl, false)
    
    ValueLabels[keyText] = ValLbl
    return Block
end


CreateSingleContainer(ContentWrapper, 4, "Fool's Gold", "0")
CreateSingleContainer(ContentWrapper, 5, "Shark Tooth", "0")
CreateSingleContainer(ContentWrapper, 6, "Electric Wing", "0")
CreateSingleContainer(ContentWrapper, 7, "Mutant Tooth", "0")
CreateSingleContainer(ContentWrapper, 8, "Terror Eyes", "0")

local BottomSpacer = Instance.new("Frame")
BottomSpacer.Size = UDim2.new(1, 0, 0, 3)
BottomSpacer.BackgroundTransparency = 1
BottomSpacer.LayoutOrder = 9
BottomSpacer.Parent = ContentWrapper

local BottomDivider = Instance.new("Frame")
BottomDivider.Size = UDim2.new(1, -10, 0, 1)
BottomDivider.Position = UDim2.new(0, 5, 0, 0)
BottomDivider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BottomDivider.BorderSizePixel = 0
BottomDivider.LayoutOrder = 10
BottomDivider.Parent = ContentWrapper

local BottomDivGrad = Instance.new("UIGradient")
BottomDivGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.4),
    NumberSequenceKeypoint.new(1, 1)
})
BottomDivGrad.Parent = BottomDivider

local CreditsBlock = Instance.new("Frame")
CreditsBlock.Size = UDim2.new(1, 0, 0, 42)
CreditsBlock.BackgroundTransparency = 1
CreditsBlock.LayoutOrder = 11
CreditsBlock.Parent = ContentWrapper

local DesignerLbl = Instance.new("TextLabel")
DesignerLbl.Size = UDim2.new(1, 0, 0, 18)
DesignerLbl.Position = UDim2.new(0, 0, 0, 0)
DesignerLbl.BackgroundTransparency = 1
DesignerLbl.Text = "Designer & Logic: naa/aneex211"
DesignerLbl.Font = Enum.Font.GothamBold
DesignerLbl.TextSize = 11
DesignerLbl.TextTransparency = 0.2
DesignerLbl.Parent = CreditsBlock
ApplyTextGradient(DesignerLbl, true)

local DiscordLbl = Instance.new("TextLabel")
DiscordLbl.Size = UDim2.new(1, 0, 0, 18)
DiscordLbl.Position = UDim2.new(0, 0, 0, 18)
DiscordLbl.BackgroundTransparency = 1
DiscordLbl.Text = "Discord Meyyhub: https://discord.gg/fhJ7aYwUxC"
DiscordLbl.Font = Enum.Font.GothamBold
DiscordLbl.TextSize = 10
DiscordLbl.TextTransparency = 0.2
DiscordLbl.Parent = CreditsBlock
ApplyTextGradient(DiscordLbl, true)

local isMainVisible = true

local function ToggleMainUI()
    isMainVisible = not isMainVisible
    if isMainVisible then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 60, 0, 15)
        }):Play()
        TweenService:Create(ToggleIcon, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Rotation = 180}):Play()
    else
        local hideTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, -MainWidth - 50, 0, 15)
        })
        hideTween:Play()
        TweenService:Create(ToggleIcon, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Rotation = 0}):Play()
        
        task.spawn(function()
            hideTween.Completed:Wait()
            if not isMainVisible then
                MainFrame.Visible = false
            end
        end)
    end
end

ToggleBtn.MouseButton1Click:Connect(ToggleMainUI)

RunService.RenderStepped:Connect(function(dt)
local t = tick()

for _, grad in ipairs(StrokeGradients) do
    if grad and grad.Parent then
        grad.Rotation = (t * 100) % 360
    end
end

for _, grad in ipairs(AnimatedGradients) do
    if grad and grad.Parent then
        grad.Rotation = math.sin(t * 2) * 15
    end
end

StatusDot.BackgroundTransparency = math.abs(math.sin(t * 4))
end)


getgenv().Meyy6Race_API = {
    SetValue = function(key, val)
        local label = ValueLabels[key]
        if label and label.Text ~= tostring(val) then
            local t1 = TweenService:Create(label, TweenInfo.new(0.1), {TextTransparency = 1})
            t1:Play()
            t1.Completed:Wait()
            label.Text = tostring(val)
            TweenService:Create(label, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
        end
    end,
    SetTask = function(taskText)
        if ValueLabels["CurrentTask"] then
            ValueLabels["CurrentTask"].Text = tostring(taskText)
        end
    end,
    SetTheme = function(themeName)
        ChangeTheme(themeName)
    end
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ItemReplicationService = require(ReplicatedStorage:WaitForChild("ItemReplicationService"))
local KEYS = require(ReplicatedStorage.ItemReplicationService.KEYS)
local ItemConfig = require(ReplicatedStorage:WaitForChild("ItemConfig"))

while ItemReplicationService.IsInitialized ~= true do
    task.wait()
end



local function getItemName(itemId)
    local ok, name = pcall(function()
        return ItemConfig.match(itemId):unwrap().Index.DebugLabel
    end)
    if ok and name then
        return name
    end
    return "Unknown_" .. tostring(itemId)
end


local function GetIdItem(targetName)
    local quantityItems = ItemReplicationService:GetItems(KEYS.QUANTITY)
    if not quantityItems then return nil end

    local targetClean = string.lower(string.gsub(targetName, "%s+", ""))

    for _, item in pairs(quantityItems) do
        local rawName = getItemName(item.ItemId)
        local cleanName = string.match(rawName, "^(.-)%s*%[") or rawName
        local cleanMatch = string.lower(string.gsub(cleanName, "%s+", ""))

        if cleanMatch == targetClean then
            if string.find(rawName, "%[Material%-") or not string.find(rawName, "%[Accessory%-") then
                return item.ItemId
            end
        end
    end

    for _, item in pairs(quantityItems) do
        local rawName = getItemName(item.ItemId)
        if string.find(rawName, "%[Material%-") then
            local cleanName = string.match(rawName, "^(.-)%s*%[") or rawName
            local cleanMatch = string.lower(string.gsub(cleanName, "%s+", ""))
            if string.find(cleanMatch, targetClean, 1, true) then
                return item.ItemId
            end
        end
    end

    return nil
end



local function getItemCount(targetItemId)
    local quantityItems = ItemReplicationService:GetItems(KEYS.QUANTITY)
    if quantityItems then
        for _, item in pairs(quantityItems) do
            if item.ItemId == targetItemId then
                return item.Value or 0
            end
        end
    end
    return 0
end



local function CountItem(ItemName)
    local itemId = GetIdItem(ItemName)
    if itemId then
        return getItemCount(itemId)
    else
        return 0
    end
end


task.spawn(function()
    local itemsToCheck = {
        "Fool's Gold",
        "Shark Tooth",
        "Electric Wing",
        "Mutant Tooth",
        "Terror Eyes"
    }
    
    local lastCounts = {}
    
    while task.wait(0.5) do
        for _, itemName in ipairs(itemsToCheck) do
            local currentCount = CountItem(itemName)
            
            if lastCounts[itemName] == nil or currentCount ~= lastCounts[itemName] then
                lastCounts[itemName] = currentCount
                                
                if getgenv().Meyy6Race_API and getgenv().Meyy6Race_API.SetValue then
                    local targetName = itemName
                    local targetCount = currentCount
                    task.defer(function()
                        getgenv().Meyy6Race_API.SetValue(targetName, targetCount)
                    end)
                end
            end
        end
    end
end)

getgenv().CurrentTarget = nil
getgenv().CurrentTargetPart = nil
getgenv().MacroAimPos = nil

getgenv().IsPureM1 = false
getgenv().UseOnlyGunSkill = false

getgenv().currentEquippedGun = nil

local function checkEquippedGun()
    local character = game:GetService("Players").LocalPlayer.Character
    if not character then
        return nil
    end

    local equippedTool = character:FindFirstChildOfClass("Tool")
    if equippedTool then
        return equippedTool.Name
    else
        return nil
    end
end

task.spawn(function()
    while task.wait(0.1) do
        getgenv().currentEquippedGun = checkEquippedGun()
    end
end)

task.spawn(function()
    pcall(function()
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
end)

repeat
    task.wait(0.5)
until LP.Team ~= nil and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

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

local Window = Library:CreateWindow({
    Title = "Meyy Hub - Kaitun Leviathan"
})

local W = 0
local lastChange = tick()

local function RoundVector3Down(vec)
    return Vector3.new(math.floor(vec.X), math.floor(vec.Y), math.floor(vec.Z))
end

local function CaculateCircreDirection(PositionCFrame, distanceY, radius)
    radius = radius or 25
    if W > 50000 then W = 60000 end
    W = W + ((tick() - lastChange) > 0.4 and 80 or 0)
    if tick() - lastChange > 0.4 then lastChange = tick() end
    local TargetPosition = PositionCFrame.Position + Vector3.new(math.cos(math.rad(W)) * radius, distanceY, math.sin(math.rad(W)) * radius)
    return CFrame.new(RoundVector3Down(TargetPosition))
end

local function EquipGun(gunName)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local targetPart = getgenv().CurrentTargetPart

    if hrp and targetPart then
        local myPos = hrp.Position
        local targetPos = targetPart.Position
        local distXZ = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude

        if distXZ > 200 then
            return 
        end
    end

    if not gunName then return end
    
    local char = LP.Character
    if not char then return end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if char:FindFirstChild(gunName) then
        return
    end

    local toolInBackpack = LP.Backpack:FindFirstChild(gunName)
    if toolInBackpack and toolInBackpack:IsA("Tool") then
        humanoid:EquipTool(toolInBackpack)
        return
    end

    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", gunName)
end


local function equip(typeCheck)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        while true do
            local tooClose = false
            local boats = workspace:FindFirstChild("Boats")
            if boats then
                for _, boat in pairs(boats:GetChildren()) do
                    for _, part in pairs(boat:GetDescendants()) do
                        if part:IsA("VehicleSeat") or part:IsA("Seat") then
                            if (part.Position - hrp.Position).Magnitude <= 20 then
                                tooClose = true
                                break
                            end
                        end
                    end
                    if tooClose then break end
                end
            end
            
            if not tooClose then
                break
            end
            task.wait(0.1)
        end
    end

    local tooltipToFind = typeCheck
    if typeCheck == "Fruit" then tooltipToFind = "Blox Fruit" end
    
    for _, item in pairs(LP.Backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltipToFind then
            local humanoid = LP.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and not humanoid:IsDescendantOf(item) then
                humanoid:EquipTool(item)
                return item.Name
            end
        end
    end
    for _, item in pairs(LP.Character:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == tooltipToFind then
            return item.Name
        end
    end
    return nil
end

local function GetNearestSeaEvent()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil, nil, nil end

    local target = nil
    local minDist = 2000
    local eventType = nil
    local targetPosition = nil

   local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        local isFishBoatAlive = false
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob.Name:find("FishBoat") then
                local healthVal = mob:FindFirstChild("Health")
                if healthVal and healthVal.Value > 0 then
                    isFishBoatAlive = true
                    break
                end
            end
        end

        for _, mob in ipairs(enemies:GetChildren()) do
            local n = mob.Name
            local mobPos = nil
            local isValid = false
            local eType = nil

            if n:find("Piranha") or n:find("Terrorshark") or n:find("Shark") or n:find("Fish Crew Member") then
                local hum = mob:FindFirstChild("Humanoid")
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hum and root and hum.Health > 0 then
                    mobPos = root.Position
                    if n:find("Piranha") and table.find(_G.SelectedEvents, "Piranha") then isValid = true; eType = "M1"
                    elseif n:find("Terrorshark") and table.find(_G.SelectedEvents, "Terrorshark") then isValid = true; eType = "M1"
                    elseif n:find("Shark") and table.find(_G.SelectedEvents, "Shark") then isValid = true; eType = "M1"
                    elseif n:find("Fish Crew Member") and table.find(_G.SelectedEvents, "FishBoat") then
                        if not isFishBoatAlive then
                            isValid = true; eType = "M1"
                        end
                    end
                end
            elseif n:find("PirateBrigade") or n:find("PirateGrandBrigade") or n:find("FishBoat") then
                local healthVal = mob:FindFirstChild("Health")
                if healthVal and healthVal.Value > 0 then
                    mobPos = mob:GetPivot().Position
                    if n:find("PirateGrandBrigade") then
                        if table.find(_G.SelectedEvents, "PirateGrandBrigade") then isValid = true; eType = "Skill" end
                    elseif n:find("PirateBrigade") then
                        if table.find(_G.SelectedEvents, "PirateBrigade") then isValid = true; eType = "Skill" end
                    elseif n:find("FishBoat") then
                        if table.find(_G.SelectedEvents, "FishBoat") then isValid = true; eType = "Skill" end
                    end
                end
            end

            if isValid and mobPos then
                local dist = (mobPos - hrp.Position).Magnitude
                if dist <= minDist then
                    minDist = dist
                    target = mob
                    eventType = eType
                    targetPosition = mobPos
                end
            end
        end
    end


	if workspace:FindFirstChild("SeaBeasts") then
		local seaBeastsFolder = workspace:FindFirstChild("SeaBeasts")
		local segmentFound = false

		for _, mob in ipairs(seaBeastsFolder:GetChildren()) do
			if mob.Name == "Leviathan Segment" then
				local isAlive = false
				local success, health = pcall(function()
					local healthObj = mob:FindFirstChild("Health")
					if healthObj and (healthObj.ClassName == "IntValue" or healthObj.ClassName == "IntConstrainedValue") then
						return healthObj.Value
					end
					return mob:FindFirstChild("Humanoid").Health
				end)

				local mobRoot = mob:FindFirstChild("HumanoidRootPart")
				if mobRoot then
					if success and health > 0 then
						isAlive = true
					elseif not success then
						isAlive = true
					end
				end

				if isAlive then
					segmentFound = true
					break
				end
			end
		end

		for _, mob in ipairs(seaBeastsFolder:GetChildren()) do
			if mob.Name:find("SeaBeast1") or mob.Name == "Leviathan Segment" or mob.Name == "Leviathan" then
				local isAlive = false
				local success, health = pcall(function()
					local healthObj = mob:FindFirstChild("Health")
					if healthObj and (healthObj.ClassName == "IntValue" or healthObj.ClassName == "IntConstrainedValue") then
						return healthObj.Value
					end
					return mob:FindFirstChild("Humanoid").Health
				end)

				local mobRoot = mob:FindFirstChild("HumanoidRootPart")
				if mobRoot then
					if success and health > 0 then
						isAlive = true
					elseif not success then
						isAlive = true
					end
				end

				if isAlive and mobRoot then
					local mobPos = mobRoot.Position

					local isLevi = (mob.Name == "Leviathan Segment" or mob.Name == "Leviathan")
					local isSB = mob.Name:find("SeaBeast1")
					
					local canAttack = false
					if isLevi and table.find(_G.SelectedEvents, "Leviathan") then canAttack = true end
					if isSB and table.find(_G.SelectedEvents, "Sea Beast") then canAttack = true end

					if canAttack then
						if mob.Name == "Leviathan" and segmentFound then
							continue
						end

						local dist = (mobPos - hrp.Position).Magnitude
						if dist <= minDist or mob.Name == "Leviathan Segment" or mob.Name == "Leviathan" then
							minDist = dist
							target = mob
							eventType = "SeaBeast"
							targetPosition = mobPos
						end
					end
				end
			end
		end
	end



    return target, eventType, targetPosition
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local FOLDER_NAME = "Meyy_Leviathan_Kaitun"
local FILE_NAME = FOLDER_NAME .. "/Name.json"
local API_URL = "https://multi-api-web.onrender.com/api/leviathan" 
local SECRET_KEY = "iemnacutez.19.09.2011"

local function getHash(str)
    if syn and syn.crypt and syn.crypt.hash then return syn.crypt.hash(str, "sha256") end
    if crypt and crypt.hash then return crypt.hash(str, "sha256") end
    return "" -- Fallback nếu executor hông hỗ trợ hash
end

local function requestAPI(method, bodyInfo)
    local req = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
    if not req then return false, nil end
    
    local groupId = tostring(_G.NguoiMuaThuyen)
    local timestamp = math.floor(os.time())
    
    local dataToHash = tostring(timestamp) .. groupId
    if method == "POST" and bodyInfo then
        dataToHash = dataToHash .. tostring(bodyInfo.Name or "")
    end
    
    local signature = getHash(dataToHash .. SECRET_KEY)
    
    local success, res = pcall(function()
        return req({
            Url = API_URL,
            Method = method,
            Headers = {
                ["Content-Type"] = "application/json",
                ["x-group"] = groupId,
                ["x-timestamp"] = tostring(timestamp),
                ["x-signature"] = signature
            },
            Body = bodyInfo and HttpService:JSONEncode(bodyInfo) or nil
        })
    end)
    if success and res and type(res) == "table" and res.StatusCode == 200 then
        local s, d = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if s and d then return true, d end
    end
    return false, nil
end

local function ReadJSONFile(path)
    if isfile and isfile(path) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(path))
        end)
        if success and type(result) == "table" then
            return result
        end
    end
    return nil
end

local function WriteJSONFile(path, data)
    if writefile then
        pcall(function()
            writefile(path, HttpService:JSONEncode(data))
        end)
    end
end

getgenv().FetchUnifiedPartyData = function()
    local success, apiData = requestAPI("GET")
    if success and apiData then return apiData end
    return ReadJSONFile(FILE_NAME)
end

local function ManagePartyDatabase()
    if not makefolder or not isfolder or not writefile or not readfile then return end
    if not isfolder(FOLDER_NAME) then makefolder(FOLDER_NAME) end

    local currentTime = os.time()
    local myName = LP.Name
    local myIDK = (_G.SpyCheckResult == -1)
    
    -- 1. Ưu tiên gửi Web API trước để đồng bộ liên máy
    local apiSuccess, finalApiData = requestAPI("POST", {Name = myName, LastTime = currentTime, IDK = myIDK})
    if apiSuccess and finalApiData then
        WriteJSONFile(FILE_NAME, finalApiData) -- Fallback backup ra workspace
        return
    end

    -- 2. Fallback Workspace nếu web down
    local rawData = ReadJSONFile(FILE_NAME)
    local accountList = {}

    if rawData then
        for _, info in pairs(rawData) do
            if type(info) == "table" and info.Name then
                table.insert(accountList, {
                    Name = tostring(info.Name),
                    LastTime = tonumber(info.LastTime) or 0,
                    IDK = (info.IDK == true)
                })
            end
        end
    end

    local isMeFound = false
    for _, acc in ipairs(accountList) do
        if acc.Name == myName then
            acc.LastTime = currentTime
            acc.IDK = myIDK
            isMeFound = true
            break
        end
    end

    if not isMeFound then
        table.insert(accountList, { Name = myName, LastTime = currentTime, IDK = myIDK })
    end

    local onlinePlayers = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        onlinePlayers[plr.Name] = true
    end

    local filteredList = {}
    for _, acc in ipairs(accountList) do
        local timeDiff = currentTime - acc.LastTime
        if not ((timeDiff > 300) and not onlinePlayers[acc.Name]) then
            table.insert(filteredList, acc)
        end
    end

    table.sort(filteredList, function(a, b) return a.LastTime < b.LastTime end)

    local finalOutput = {}
    for index, acc in ipairs(filteredList) do
        finalOutput["acc " .. tostring(index)] = {
            Name = acc.Name,
            LastTime = acc.LastTime,
            IDK = acc.IDK
        }
    end
    WriteJSONFile(FILE_NAME, finalOutput)
end

task.spawn(function()
    ManagePartyDatabase()
    while task.wait(10) do
        pcall(ManagePartyDatabase)
    end
end)

local function getFrozenWatcherPosition()
    local mapFolder = workspace:FindFirstChild("Map")
    
    if mapFolder then
        local frozenWatcher = mapFolder:FindFirstChild("FrozenWatcherPart", true)
        
        if frozenWatcher then
            local position = frozenWatcher.Position
            local waterPlane = mapFolder:FindFirstChild("WaterBase-Plane")
            local waterBaseY = waterPlane and waterPlane.Position.Y or 20
            
            if position.Y > waterBaseY then
                return true, position
            end
        end
    end
    
    return false, nil
end

---------
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
    
    local character = LP.Character
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
    local character = LP.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not hrp or not humanoid then return end
    
    local isBoat = humanoid.Sit or (humanoid.SeatPart ~= nil)
    local currentSpeed = isBoat and (_G.TocDoTweenBoat or 400) or (_G.TocDoTween or 400)

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
        alignPosition.MaxVelocity = currentSpeed 
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
        alignPosition.MaxVelocity = currentSpeed
    else
        isAligningY = false
        targetAttachment.WorldPosition = initialTargetPos
        alignPosition.MaxVelocity = currentSpeed
    end

    alignPosition.Enabled = true
    
    if not MoveConnection then
        MoveConnection = RunService.PostSimulation:Connect(function(dt)
            if not _G.ChoPhepDiChuyen or not targetCFrame then 
                DungDiChuyen()
                return 
            end
            
            local cChar = LP.Character
            if not cChar then return end
            local cHrp = cChar:FindFirstChild("HumanoidRootPart")
            local cHum = cChar:FindFirstChild("Humanoid")
            if not cHrp or not cHum then return end
            
            local loopIsBoat = cHum.Sit or (cHum.SeatPart ~= nil)
            local loopSpeed = (loopIsBoat and not _G.DangKeoTim) and (_G.TocDoTweenBoat or 400) or (_G.TocDoTween or 400)
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
                    alignPosition.MaxVelocity = loopSpeed
                else
                    targetAttachment.WorldPosition = Vector3.new(targetAttachment.WorldPosition.X, finalPos.Y, targetAttachment.WorldPosition.Z)
                    alignPosition.MaxVelocity = loopSpeed
                end
            else
                targetAttachment.WorldPosition = finalPos
                alignPosition.MaxVelocity = loopSpeed
            end
            local distance = (finalPos - currentPos).Magnitude
            if distance < 3 then
                DungDiChuyen()
            end
        end)
    end
end

RunService.Stepped:Connect(function()
    if _G.BatNoclip and LP.Character then
        for _, part in ipairs(LP.Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    
    if _G.XoaSuongMu then
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
    end
end)

task.spawn(function()
    while task.wait(2) do
        if _G.XoaSuongMu then
            local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
            if atmos then atmos:Destroy() end
        end
    end
end)

local function KiemTraThuyen()
    local thuyenMoi = workspace:FindFirstChild("Boats")
    if not thuyenMoi then return nil end
    
    for _, v in ipairs(thuyenMoi:GetChildren()) do
        if v:FindFirstChild("Owner") and tostring(v.Owner.Value) == _G.NguoiMuaThuyen then
            return v
        end
    end
    return nil
end
local function checkBoatJitter(boatModel, duration, threshold)
    duration = duration or 0.5
    threshold = threshold or 0.8

    local character = LP.Character
    if not character then
        return false
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp or not boatModel then
        return false
    end

    local boatPart = boatModel.PrimaryPart or boatModel:FindFirstChildWhichIsA("BasePart")
    if not boatPart then
        return false
    end

    local lastRelPos = boatPart.Position - hrp.Position
    local lastDir = 0
    local reversals = 0
    local samples = 0
    local startTime = tick()

    while tick() - startTime < duration do
        RunService.Heartbeat:Wait()
        
        if not hrp.Parent or not boatPart.Parent then
            break
        end

        local currentRelPos = boatPart.Position - hrp.Position
        local delta = currentRelPos - lastRelPos
        local mag = delta.Magnitude

        if mag > 0.05 and mag < 5 then
            local currentDir = math.sign(delta.Y ~= 0 and delta.Y or delta.Z)
            if lastDir ~= 0 and currentDir ~= 0 and currentDir ~= lastDir then
                reversals = reversals + 1
            end
            if currentDir ~= 0 then
                lastDir = currentDir
            end
        end

        lastRelPos = currentRelPos
        samples = samples + 1
    end

    local isJittering = (reversals >= 3)
    if isJittering then
        return true
    else
        return false
    end
end

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.NguoiMuaThuyen == LP.Name then
                local isFoundHeart, _ = GetFrozenHeartData()
                if _G.ShootHeart and isFoundHeart then
                    return
                end
                local thuyen = KiemTraThuyen()
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                if thuyen and hum and hum.Sit then
                    local isJittering = checkBoatJitter(thuyen, 0.5, 0.8)
                    if isJittering then
                        hum.Sit = false
                        task.wait(0.1)
                        hum.Jump = true
                    end
                end
            end
        end)
    end
end)
local function DemNguoiTrenThuyen(thuyen)
    if not thuyen then return 0 end
    local dem = 0
    for _, part in ipairs(thuyen:GetDescendants()) do
        if (part:IsA("Seat") or part:IsA("VehicleSeat")) and part.Occupant then
            dem = dem + 1
        end
    end
    return dem
end

local RS = game:GetService("ReplicatedStorage")
local MaterialsList = {
    "Fool's Gold",       
    "Shark Tooth",      
    "Electric Wing",    
    "Mutant Tooth",     
    "Terror Eyes",    
    "Leviathan Scale",  
    "Leviathan Heart"    
}

local ScrollReqs = {
    CommonScroll    = {3, 2, 0, 0, 0, 0, 0},
    RareScroll      = {5, 4, 2, 0, 0, 0, 0},
    LegendaryScroll = {7, 0, 3, 1, 0, 5, 0},
    MythicalScroll  = {20, 0, 0, 0, 1, 15, 1}
}


local ScrollCaps = {
    CommonScroll    = 10,
    RareScroll      = 10,
    LegendaryScroll = 15,
    MythicalScroll  = 10
}


local function AutoCraftScroll(scrollName)
    local rawName = tostring(scrollName):gsub("%s+", "")
    if not ScrollReqs[rawName] then 
        print(string.format("[Craft Debug] '%s' No ScrollReqs!", tostring(rawName)))
        return 0, {} 
    end
    
    local reqs = ScrollReqs[rawName]
    local currentScrolls = CountItem(rawName)
    local sliderCap = ScrollCaps[rawName]
    local capLimit = (sliderCap and sliderCap > 0) and sliderCap or 50
    local maxAllowed = capLimit - currentScrolls
    

    if maxAllowed <= 0 then
        print(string.format("[Craft Debug] STOP!! [%s] Max Cap!", rawName))
        return 0, {}
    end

    local maxCraft = math.huge
    local missingMaterials = {}

    for i = 1, #MaterialsList do
        local needAmount = reqs[i]
        if needAmount and needAmount > 0 then
            local matName = MaterialsList[i]
            local currentAmount = CountItem(matName)
            local canCraft = math.floor(currentAmount / needAmount)
            
            if canCraft < maxCraft then
                maxCraft = canCraft
            end
            if currentAmount < needAmount then
                missingMaterials[matName] = needAmount - currentAmount
            end
        end
    end
    
    if maxCraft == math.huge then
        maxCraft = 0
    end
    

    if maxCraft <= 0 then
        for mName, mDiff in pairs(missingMaterials) do
        end
        return 0, missingMaterials
    end

    if maxCraft > maxAllowed then
        maxCraft = maxAllowed
    end

    local args = {
        "Craft",
        rawName,
        maxCraft,
        {}
    }

    local ok, res = pcall(function()
        return RS:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft"):InvokeServer(unpack(args))
    end)


    return maxCraft, {}
end
---------

local function KiemTraDieuKienSan()
    local thuyen = KiemTraThuyen()
    if thuyen then
        local soNguoi = DemNguoiTrenThuyen(thuyen)
        if soNguoi >= _G.SoNguoiCanThiet then
            return true
        end
    end
    return false
end

local function IsFrozenHeartHarpooned()
    local mapFolder = game:GetService("Workspace"):FindFirstChild("Map")
    if mapFolder then
        local frozenHeart = mapFolder:FindFirstChild("FrozenHeart")
        if frozenHeart then
            local inside = frozenHeart:FindFirstChild("Inside")
            if inside then
                return inside:GetAttribute("Harpooned") or false
            end
        end
    end
    return false
end


local function bypassSit(seat, humanoid)
    if not seat or not humanoid then return end
    
    local rootPart = humanoid.Parent:FindFirstChild("HumanoidRootPart")
    local touchPart = humanoid.Parent:FindFirstChild("LeftFoot") or humanoid.Parent:FindFirstChild("Torso") or rootPart
    
    if rootPart and touchPart then
        seat.CanTouch = true
        
        task.spawn(function()
            if firetouchtransmitter then
                firetouchtransmitter(seat, touchPart, 0)
                task.wait()
                firetouchtransmitter(seat, touchPart, 1)
            end
        end)
        
        local oldCFrame = rootPart.CFrame
        local tempTime = tick()
        
        repeat
            rootPart.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
            seat:Sit(humanoid)
            task.wait()
        until humanoid.Sit or (tick() - tempTime > 1.5)
        
        if not humanoid.Sit then
            seat:Sit(humanoid)
        end
    end
end

local function GetFrozenHeartData()
    local mapFolder = game:GetService("Workspace"):FindFirstChild("Map")
    
    if mapFolder then
        local frozenHeart = mapFolder:FindFirstChild("FrozenHeart")
        
        if frozenHeart then
            return true, frozenHeart:GetPivot().Position, frozenHeart
        end
    end
    
    return false, nil, nil
end

local function IsFrozenHeartHarpooned()
    local mapFolder = game:GetService("Workspace"):FindFirstChild("Map")
    if mapFolder then
        local frozenHeart = mapFolder:FindFirstChild("FrozenHeart")
        if frozenHeart then
            local inside = frozenHeart:FindFirstChild("Inside")
            if inside then
                return inside:GetAttribute("Harpooned") or false
            end
        end
    end
    return false
end

local function GetWaterLevel()
    local waterPlane = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane")
    if waterPlane then
        return waterPlane.Position.Y + (waterPlane.Size.Y / 2)
    end
    return 20 
end

local function KiemTraDaoIgnore()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return false end

    local prehistoric = mapFolder:FindFirstChild("PrehistoricIsland")
    if prehistoric then
        local p = prehistoric:GetPivot()
        if (Vector3.new(p.Position.X, 0, p.Position.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude <= 4500 then
            return true
        end
    end

    local mystic = mapFolder:FindFirstChild("MysticIsland")
    if mystic then
        local p = mystic:GetPivot()
        if (Vector3.new(p.Position.X, 0, p.Position.Z) - Vector3.new(hrp.Position.X, 0, hrp.Position.Z)).Magnitude <= 4500 then
            return true
        end
    end

    return false
end

local function KiemTraQuaiKhongChon()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local minDist = 3500

    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            local n = mob.Name
            local isUnselected = false
            if n:find("Piranha") and not table.find(_G.SelectedEvents, "Piranha") then isUnselected = true
            elseif n:find("Terrorshark") and not table.find(_G.SelectedEvents, "Terrorshark") then isUnselected = true
            elseif n:find("Shark") and not table.find(_G.SelectedEvents, "Shark") then isUnselected = true
            elseif n:find("Fish Crew Member") and not table.find(_G.SelectedEvents, "FishBoat") then isUnselected = true
            elseif n:find("PirateGrandBrigade") and not table.find(_G.SelectedEvents, "PirateGrandBrigade") then isUnselected = true
            elseif n:find("PirateBrigade") and not table.find(_G.SelectedEvents, "PirateBrigade") then isUnselected = true
            elseif n:find("FishBoat") and not table.find(_G.SelectedEvents, "FishBoat") then isUnselected = true
            end

            if isUnselected then
                local isAlive = false
                local hum = mob:FindFirstChild("Humanoid")
                local hpVal = mob:FindFirstChild("Health")
                
                if hum then
                    if hum:IsA("Humanoid") then
                        if hum.Health > 0 then isAlive = true end
                    elseif hum:IsA("NumberValue") or hum:IsA("IntValue") then
                        if hum.Value > 0 then isAlive = true end
                    end
                elseif hpVal and (hpVal:IsA("NumberValue") or hpVal:IsA("IntValue")) then
                    if hpVal.Value > 0 then isAlive = true end
                end

                local root = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("VehicleSeat") or mob.PrimaryPart
                if not root then
                    local ok, p = pcall(function() return mob:GetPivot() end)
                    if ok and p then
                        if isAlive and (p.Position - hrp.Position).Magnitude <= minDist then
                            return true
                        end
                    end
                elseif isAlive and root then
                    if (root.Position - hrp.Position).Magnitude <= minDist then
                        return true
                    end
                end
            end
        end
    end

    local sbFolder = workspace:FindFirstChild("SeaBeasts")
    if sbFolder then
        for _, mob in ipairs(sbFolder:GetChildren()) do
            local n = mob.Name
            local isUnselected = false
            if n:find("SeaBeast") and not table.find(_G.SelectedEvents, "Sea Beast") then isUnselected = true
            elseif (n == "Leviathan" or n == "Leviathan Segment") and not table.find(_G.SelectedEvents, "Leviathan") then isUnselected = true
            end
            
            if isUnselected then
                local isAlive = false
                local success, health = pcall(function()
                    local healthObj = mob:FindFirstChild("Health")
                    if healthObj and (healthObj.ClassName == "IntValue" or healthObj.ClassName == "NumberValue" or healthObj.ClassName == "IntConstrainedValue") then
                        return healthObj.Value
                    end
                    return mob:FindFirstChild("Humanoid").Health
                end)

                if success and health > 0 then
                    isAlive = true
                elseif not success then
                    local pivotSuccess = pcall(function() return mob:GetPivot() end)
                    if pivotSuccess then
                        isAlive = true
                    end
                end

                if isAlive then
                    local root = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
                    local mobPos = nil
                    if root then
                        mobPos = root.Position
                    else
                        local ok, p = pcall(function() return mob:GetPivot() end)
                        if ok and p then mobPos = p.Position end
                    end

                    if mobPos and (mobPos - hrp.Position).Magnitude <= minDist then
                        return true
                    end
                end
            end
        end
    end
    return false
end

getgenv().LastTerrorY = nil
getgenv().LastTerrorMob = nil
getgenv().IsTerrorDodging = false

local function HandleTargetPositioning(seaEventTarget, eType, wName, targetPos)
    if not targetPos then return nil end

    local flyCFrame
    local yDist = 40
    local isM1 = getgenv().IsPureM1

    if wName == "Fruit" or wName == "Blox Fruit" then 
        yDist = 5
    elseif wName == "Gun" then 
        yDist = 100
    else 
        if seaEventTarget and seaEventTarget.Name:find("Terrorshark") and isM1 then
            yDist = 57
        else
            yDist = 40
        end
    end
    local waterTopY = GetWaterLevel()


    if eType == "SeaBeast" then
        local isLevi = seaEventTarget and (seaEventTarget.Name == "Leviathan Segment" or seaEventTarget.Name == "Leviathan")

        if isLevi then
            getgenv().MacroAimPos = CFrame.new(targetPos)

            if _G.SpinPosition then
                local radius = isM1 and 23 or 67
                flyCFrame = CaculateCircreDirection(CFrame.new(targetPos), 30, radius)
            else
                flyCFrame = CFrame.new(targetPos.X, targetPos.Y + 30, targetPos.Z)
            end
        else
            local waterBaseY = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("WaterBase-Plane") and Workspace.Map["WaterBase-Plane"].Position.Y or 20

            local aimPos = Vector3.new(targetPos.X, waterBaseY, targetPos.Z)
            getgenv().MacroAimPos = CFrame.new(aimPos)

            local yOffset = 150

            local standPos = Vector3.new(aimPos.X, waterTopY + yOffset, aimPos.Z)
            
            if _G.SpinPosition then
                local radius = isM1 and 23 or 67
                if seaEventTarget and seaEventTarget.Name:find("Terrorshark") then
                    radius = 0
                end
                flyCFrame = CaculateCircreDirection(CFrame.new(Vector3.new(aimPos.X, waterTopY, aimPos.Z)), yOffset, radius)
            else
                flyCFrame = CFrame.new(standPos)
            end
        end

    else
       local finalTargetPos = targetPos
            if (seaEventTarget.Name:find("Brigade") or seaEventTarget.Name == "FishBoat") and isM1 then
                if wName == "Fruit" or wName == "Blox Fruit" then
                    if seaEventTarget.Name == "PirateGrandBrigade" or seaEventTarget.Name == "FishBoat" then
                        local vehicleSeat = seaEventTarget:FindFirstChild("VehicleSeat")
                        if vehicleSeat then
                            finalTargetPos = vehicleSeat.Position
                        end
                    else
                        local engine = seaEventTarget:FindFirstChild("Engine")
                        if engine and engine:IsA("Part") then
                            finalTargetPos = engine.Position
                        end
                    end
                else
                    local mobCFrame = seaEventTarget:GetPivot()
                    finalTargetPos = finalTargetPos + (mobCFrame.LookVector * 10)
                end
            end

        getgenv().MacroAimPos = CFrame.new(finalTargetPos)
        flyCFrame = CFrame.new(finalTargetPos) * CFrame.new(0, yDist, 0)

        if _G.SpinPosition then
            local radius = isM1 and 23 or 67
            if seaEventTarget and seaEventTarget.Name:find("Terrorshark") then
                radius = 0
            end
            flyCFrame = CaculateCircreDirection(CFrame.new(finalTargetPos), yDist, radius)
        end

        if seaEventTarget.Name:find("Terrorshark") then
            local currentTerrorY = targetPos.Y
            
            if currentTerrorY > (waterTopY + 20) then
                getgenv().IsTerrorDodging = true
            else
                getgenv().IsTerrorDodging = false
            end

            if getgenv().IsTerrorDodging then
                flyCFrame = CFrame.new(flyCFrame.Position.X, flyCFrame.Position.Y + 250, flyCFrame.Position.Z)
                if khoiDiChuyen then
                    khoiDiChuyen.CFrame = CFrame.new(khoiDiChuyen.Position.X, flyCFrame.Position.Y, khoiDiChuyen.Position.Z)
                end
            end
        end
    end

    return flyCFrame
end



task.spawn(function()
    while true do
        local map = workspace:FindFirstChild("Map")
        if map then
            local model = map:FindFirstChild("Model")
            if model then
                model:Destroy()
            end
        end
        task.wait(5)
    end
end)

task.spawn(function()
	while true do
		local rocksFolder = workspace:FindFirstChild("Rocks")
		if rocksFolder then
			rocksFolder:Destroy()
		end
		task.wait(30)
	end
end)

_G.WaitResetBoat = false

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.DangSan then
                local thuyen = workspace:FindFirstChild("Boats")
                if thuyen then
                    for _, v in ipairs(thuyen:GetChildren()) do
                        local ownerObj = v:FindFirstChild("Owner")
                        if ownerObj and (tostring(ownerObj.Value) == _G.NguoiMuaThuyen or tostring(ownerObj.Value) == LP.Name) then
                            local boatHp = v:FindFirstChild("Humanoid")
                            if boatHp and (boatHp:IsA("IntValue") or boatHp.ClassName == "IntValue") then
                                if boatHp.Value <= 0 then
                                    _G.WaitResetBoat = true
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)


task.spawn(function()
    local function setupResetLogic(char)
        _G.WaitResetBoat = false
        _G.PatrolState = 1
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid then
            humanoid.Died:Connect(function()
                _G.WaitResetBoat = false
                _G.PatrolState = 1
            end)
        end
    end

    if LP.Character then
        setupResetLogic(LP.Character)
    end

    LP.CharacterAdded:Connect(function(char)
        setupResetLogic(char)
    end)
end)

local NpcPositions = {
    ["Uzoth"] = Vector3.new(5661.89794921875, 1210.876953125, 863.176025390625),
    ["Dragon Wizard"] = Vector3.new(5771.85302734375, 1208.89697265625, 804.2470092773438),
    ["Martial Arts Master"] = Vector3.new(-5004.72119140625, 370.42333984375, -3198.915283203125),
    ["Phoeyu, the Reformed"] = Vector3.new(-4999.23046875, 314.0144958496094, -3221.572265625),
    ["Sharkman Teacher"] = Vector3.new(-4971.2060546875, 313.8869323730469, -3223.0791015625),
    ["Previous Hero"] = Vector3.new(-10371.4716796875, 330.7640075683594, -10131.419921875),
    ["Ancient Monk"] = Vector3.new(-13774.0908203125, 333.7330017089844, -9879.9072265625),
    ["Shafi"] = Vector3.new(-16515.06640625, 22.811996459960938, -188.572998046875)
}

local function GetNpcPosition(npcName)
    return NpcPositions[npcName]
end

local function HandleBoatRespawnLogic(thuyen)
    local viTriMuaThuyen = CFrame.new(-16204.9668, 9.2812, 474.9888)
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local isBoatBroken = _G.WaitResetBoat

    if thuyen then
        local ownerObj = thuyen:FindFirstChild("Owner")
        local ownerName = ownerObj and tostring(ownerObj.Value) or ""
        local targetOwner = _G.NguoiMuaThuyen and tostring(_G.NguoiMuaThuyen) or LP.Name

        if ownerName == targetOwner or ownerName == LP.Name then
            local boatHp = thuyen:FindFirstChild("Humanoid")
            if boatHp and (boatHp:IsA("IntValue") or boatHp.ClassName == "IntValue") then
                if boatHp.Value <= 0 then
                    isBoatBroken = true
                    _G.WaitResetBoat = true
                    thuyen = nil
                end
            end
        end
    end

    if thuyen and thuyen.PrimaryPart then
        local dist = (thuyen.PrimaryPart.Position - hrp.Position).Magnitude
        if dist > 5000 then
            thuyen = nil 
        end
    end

    if not thuyen then
        local distToSpawn = (hrp.Position - viTriMuaThuyen.Position).Magnitude
        if isBoatBroken and distToSpawn > 1000 then
            local w = game:GetService("Players")
            local S = w.LocalPlayer
            if S.Character and S.Character:FindFirstChild("Humanoid") then
                print("Resetting character due to broken boat...")
                if getgenv().Meyy6Race_API then
                    getgenv().Meyy6Race_API.SetTask("Resetting Character")
                    getgenv().Meyy6Race_API.SetTheme("Sky")
                end
                S.Character.Humanoid.Health = 0
                _G.WaitResetBoat = false
            end
        else
            _G.WaitResetBoat = false
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Buying Boat")
                getgenv().Meyy6Race_API.SetTheme("Candy")
            end

            DiChuyenDen(viTriMuaThuyen)
            if distToSpawn < 15 then
                _G.PatrolState = 1
                ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyBoat", _G.TenThuyen)
                task.wait(0.5)
            end
        end
        return true
    end

    return false 
end

---------

local NotifiedWatcher = false
local function HandleFrozenWatcherLogic(hrp, humanoid, watcherPos)
    local distToWatcher = (hrp.Position - watcherPos).Magnitude
    if not NotifiedWatcher then
        NotifiedWatcher = true
        task.spawn(function()
            sendLeviWebhook("Found Frozen Dimension", "Discovered Frozen Dimension at: " .. tostring(RoundVector3Down(watcherPos)))
        end)
    end
    
    if distToWatcher > 200 then
        local myBoat = KiemTraThuyen()
        if not myBoat then
            if _G.NguoiMuaThuyen == LP.Name then
                HandleBoatRespawnLogic(nil)
            end
        else
            if _G.NguoiMuaThuyen == LP.Name then
                local gheLai = myBoat:FindFirstChild("VehicleSeat")
                if gheLai then
                    if not humanoid.Sit then
                        DiChuyenDen(gheLai.CFrame * CFrame.new(0, 3, 0))
                        task.wait(0.5)
                        if (gheLai.Position - hrp.Position).Magnitude <= 10 then
                            gheLai:Sit(humanoid)
                        end
                    else
                        DiChuyenDen(CFrame.new(watcherPos) * CFrame.new(0, 10, 0))
                    end
                end
            else
                local gheTrong = nil
                local harpoon = myBoat:FindFirstChild("Harpoon")
                local harpoonSeat = harpoon and harpoon:FindFirstChild("Seat")
                for _, part in ipairs(myBoat:GetDescendants()) do
                    if part:IsA("Seat") and part.Name ~= "VehicleSeat" and part ~= harpoonSeat and not part.Occupant then
                        gheTrong = part
                        break
                    end
                end
                if gheTrong then
                    if not humanoid.Sit then
                        DiChuyenDen(gheTrong.CFrame * CFrame.new(0, 3, 0))
                        task.wait(0.5)
                        if (gheTrong.Position - hrp.Position).Magnitude <= 10 then
                            gheTrong:Sit(humanoid)
                        end
                    else
                        DungDiChuyen()
                    end
                end
            end
        end
    else
        if humanoid.Sit then
            humanoid.Sit = false
            task.wait(0.1)
        end
        
        if distToWatcher <= 100 then
            local tocDoCu = _G.TocDoTween
            _G.TocDoTween = 55
            DiChuyenDen(CFrame.new(watcherPos) * CFrame.new(0, 10, 0))
            _G.TocDoTween = tocDoCu
        else
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Moving to NPC")
                getgenv().Meyy6Race_API.SetTheme("Dark")
            end
            if khoiDiChuyen then
                local currentY = khoiDiChuyen.Position.Y
                local targetY = watcherPos.Y + 10
                if math.abs(currentY - targetY) > 5 then
                    khoiDiChuyen.CFrame = CFrame.new(khoiDiChuyen.Position.X, targetY, khoiDiChuyen.Position.Z)
                    task.wait(0.1)
                end
            end
            DiChuyenDen(CFrame.new(watcherPos) * CFrame.new(0, 10, 0))
        end
        
        if distToWatcher < 40 then
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Opening Gate")
                getgenv().Meyy6Race_API.SetTheme("Lavender")
            end
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate")
        end
    end
    return true
end

local function CalculateHarpoonAngles(harpoonFolder, targetPos)
    local seat = harpoonFolder:FindFirstChild("Seat")
    local baseCFrame
    
    if seat and seat:FindFirstChild("BoatWeld") and seat.BoatWeld.Part0 then
        baseCFrame = seat.BoatWeld.Part0.CFrame
    elseif seat and seat:IsA("BasePart") then
        baseCFrame = seat.CFrame
    else
        baseCFrame = harpoonFolder:GetPivot()
    end

    local localDir = baseCFrame:PointToObjectSpace(targetPos)

    local yaw = math.atan2(localDir.X, -localDir.Z)

    local x = math.sqrt(localDir.X^2 + localDir.Z^2)
    local y = localDir.Y

    local v = 400
    local g = workspace.Gravity

    local root = v^4 - g * (g * x^2 + 2 * y * v^2)
    local pitch = 0

    if root >= 0 then
        pitch = math.atan2(v^2 - math.sqrt(root), g * x)
    else
        pitch = math.atan2(y, x)
    end

    local clampedPitch = math.clamp(pitch, -0.17453292519943295, 0.7853981633974483)
    local clampedYaw = math.clamp(yaw, -1.1344640137963142, 1.1344640137963142)

    return clampedPitch, clampedYaw
end



local function FiringHarpoonLogic(harpoonFolder, harpoonSeat, heartPos)
    DungDiChuyen()
    if getgenv().Meyy6Race_API then
        getgenv().Meyy6Race_API.SetTask("Shooting Heart")
        getgenv().Meyy6Race_API.SetTheme("Dream")
    end
    
    local currentTime = tick()
    if not getgenv().LastHarpoonShoot or currentTime - getgenv().LastHarpoonShoot >= 1 then
        getgenv().LastHarpoonShoot = currentTime
        
        local pitch, yaw = CalculateHarpoonAngles(harpoonFolder, heartPos)
        local boatWeld = harpoonSeat:FindFirstChild("BoatWeld")
        local cannonWeld = harpoonSeat:FindFirstChild("CannonWeld")
        
        if boatWeld then
            pcall(function()
                boatWeld.C0 = CFrame.Angles(0, yaw, 0)
                boatWeld.C1 = CFrame.Angles(0, yaw * 2, 0)
            end)
        end
        
        if cannonWeld then
            pcall(function()
                local v21 = math.max(pitch - 0.4363323129985824, 0) / 0.6108652381980153 * 2.5
                cannonWeld.C0 = CFrame.new(0, v21, 0) * CFrame.Angles(pitch, 0, 0) * CFrame.new(0, 0, -v21 / 1.4142135623730951)
            end)
        end
        
        pcall(function()
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("FireHarpoon", pitch, yaw, harpoonFolder, workspace:GetServerTimeNow())
        end)
    end
end

---------
local function GetHeartData()
    local mapFolder = Workspace:FindFirstChild("Map")
    if mapFolder then
        local frozenHeart = mapFolder:FindFirstChild("FrozenHeart")
        if frozenHeart then
            local core = frozenHeart:FindFirstChild("Inside") 
                or frozenHeart:FindFirstChild("Cube") 
                or frozenHeart:FindFirstChild("Hitbox")
                or frozenHeart.PrimaryPart
                or frozenHeart:FindFirstChildWhichIsA("BasePart", true)
            if core then
                return core.CFrame, frozenHeart
            end
            return frozenHeart:GetPivot(), frozenHeart
        end
    end
    return nil, nil
end



---------
local function bypassSit(seat, humanoid)
    if not seat or not humanoid then return end
    
    local rootPart = humanoid.Parent:FindFirstChild("HumanoidRootPart")
    local touchPart = humanoid.Parent:FindFirstChild("LeftFoot") or humanoid.Parent:FindFirstChild("Torso") or rootPart
    
    if rootPart and touchPart then
        seat.CanTouch = true
        
        task.spawn(function()
            if firetouchtransmitter then
                firetouchtransmitter(seat, touchPart, 0)
                task.wait()
                firetouchtransmitter(seat, touchPart, 1)
            end
        end)
        
        local oldCFrame = rootPart.CFrame
        local tempTime = tick()
        
        repeat
            rootPart.CFrame = seat.CFrame * CFrame.new(0, 1, 0)
            seat:Sit(humanoid)
            task.wait()
        until humanoid.Sit or (tick() - tempTime > 1.5)
        
        if not humanoid.Sit then
            seat:Sit(humanoid)
        end
    end
end

local function HandleFrozenHeartLogic(hrp, humanoid, heartPosFallback)
    if not _G.ShootHeart then 
        return false 
    end
    
    local myBoat = KiemTraThuyen()
    if not myBoat or not hrp or not humanoid then 
        return false 
    end

    local heartCFrame, frozenHeart = GetHeartData()
    if not heartCFrame and heartPosFallback then
        if typeof(heartPosFallback) == "CFrame" then
            heartCFrame = heartPosFallback
        elseif typeof(heartPosFallback) == "Vector3" then
            heartCFrame = CFrame.new(heartPosFallback)
        end
    end

    local isHarpooned = IsFrozenHeartHarpooned()

    if _G.NguoiMuaThuyen == LP.Name then
        if not heartCFrame or isHarpooned then
            if isHarpooned then
                local vehicleSeat = myBoat:FindFirstChild("VehicleSeat")
                if vehicleSeat then
                    if humanoid.Sit and humanoid.SeatPart ~= vehicleSeat then
                        humanoid.Sit = false
                        task.wait(0.2)
                    end
                    if not humanoid.Sit then
                        bypassSit(vehicleSeat, humanoid)
                    end
                end
                DungDiChuyen()
                return true
            end
            return false
        end

        local heartPos = heartCFrame.Position
        local vehicleSeat = myBoat:FindFirstChild("VehicleSeat")
        local harpoonFolder = myBoat:FindFirstChild("Harpoon")
        local harpoonSeat = harpoonFolder and harpoonFolder:FindFirstChild("Seat")
        
        if not vehicleSeat or not harpoonSeat then return false end

        local targetPos = Vector3.new(heartPos.X, GetWaterLevel() + 27.5, heartPos.Z + 290)
        local aimCFrame = CFrame.new(targetPos, Vector3.new(heartPos.X, targetPos.Y, heartPos.Z))
        
        if not humanoid.Sit then
            if myBoat.PrimaryPart then
                myBoat:PivotTo(hrp.CFrame)
                task.wait(0.05)
            end
            bypassSit(vehicleSeat, humanoid)
        elseif humanoid.Sit and humanoid.SeatPart == vehicleSeat then
            local dist = (Vector3.new(vehicleSeat.Position.X, 0, vehicleSeat.Position.Z) - Vector3.new(targetPos.X, 0, targetPos.Z)).Magnitude
            if dist > 50 then
                DiChuyenDen(aimCFrame)
            else
                DungDiChuyen()
                if myBoat.PrimaryPart then
                    myBoat:PivotTo(aimCFrame)
                end
                humanoid.Sit = false
                task.wait(0.2)
                bypassSit(harpoonSeat, humanoid)
            end
        elseif humanoid.Sit and humanoid.SeatPart == harpoonSeat then
            FiringHarpoonLogic(harpoonFolder, harpoonSeat, heartPos)
            task.delay(1, function()
                if IsFrozenHeartHarpooned() and not getgenv().NotifiedHeartHarpooned then
                    getgenv().NotifiedHeartHarpooned = true
                    sendLeviWebhook("Heart Shooted", "Shoot Frozen Heart successfully! Preparing Drive.")
                end
            end)
        end
        
        return true
    else
        if isHarpooned then
            if getgenv().Meyy6Race_API then getgenv().Meyy6Race_API.SetTask("Boarding & Waiting") end
        end

        if not humanoid.Sit then
            local gheTrong = nil
            local harpoonSeat = myBoat:FindFirstChild("Harpoon") and myBoat.Harpoon:FindFirstChild("Seat")
            for _, part in ipairs(myBoat:GetDescendants()) do
                if part:IsA("Seat") and part.Name ~= "VehicleSeat" and part ~= harpoonSeat and not part.Occupant then
                    gheTrong = part
                    break
                end
            end
            if gheTrong then
                DiChuyenDen(gheTrong.CFrame * CFrame.new(0, 3, 0))
                if (gheTrong.Position - hrp.Position).Magnitude <= 5 then
                    gheTrong:Sit(humanoid)
                end
            elseif isHarpooned and myBoat.PrimaryPart then
                DiChuyenDen(myBoat.PrimaryPart.CFrame * CFrame.new(0, 15, 0))
            end
        else
            if humanoid.SeatPart and (hrp.Position - humanoid.SeatPart.Position).Magnitude > 10 then
                humanoid.Sit = false
            else
                DungDiChuyen()
            end
        end
        
        if isHarpooned then return true end
        return false
    end
end



---------
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()

            if IsFrozenHeartHarpooned() then
                return
            end

            local isFoundHeart, heartPos = GetFrozenHeartData()
            if not isFoundHeart or not heartPos then
                return
            end

            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not char or not hum or not hrp or not hum.Sit then
                return
            end

            local thuyen = KiemTraThuyen()
            if not thuyen then
                return
            end

            local gheLai = thuyen:FindFirstChild("VehicleSeat") or thuyen:FindFirstChildWhichIsA("VehicleSeat", true)
            if not gheLai then
                return
            end

            if hum.SeatPart ~= gheLai and (hrp.Position - gheLai.Position).Magnitude > 8 then
                return
            end

            local boatPivot = thuyen:GetPivot()
            local boatPos = boatPivot.Position
            local boatTarget = Vector3.new(heartPos.X, boatPos.Y, heartPos.Z)

            local lookVec = (boatPivot.LookVector * Vector3.new(1, 0, 1)).Unit
            local dirVec = ((boatTarget - boatPos) * Vector3.new(1, 0, 1)).Unit
            local dotP = math.clamp(lookVec:Dot(dirVec), -1, 1)
            local gocLech = math.deg(math.acos(dotP))

            if gocLech > 5 then
                thuyen:PivotTo(CFrame.lookAt(boatPos, boatTarget))
            end
        end)
    end
end)
---------



getgenv().DangSafeMode = false
getgenv().ViTriSafe = nil

task.spawn(function()
    while task.wait() do
        pcall(function()
            if _G.DangSan and getgenv().CurrentTarget then
                local char = LP.Character
                local hum = char and char:FindFirstChild("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if hum and hrp and hum.Health > 0 then
                    local hpPercent = hum.Health / hum.MaxHealth

                    if hpPercent < 0.30 and not getgenv().DangSafeMode then
                        getgenv().DangSafeMode = true
                        
                        local toaDoHienTai = hrp.CFrame
                        hrp.CFrame = toaDoHienTai * CFrame.new(0, 2000, 0)
                        
                        getgenv().ViTriSafe = toaDoHienTai * CFrame.new(0, 2500, 0)
                        
                    elseif hpPercent > 0.65 and getgenv().DangSafeMode then
                        getgenv().DangSafeMode = false
                        getgenv().ViTriSafe = nil
                    end
                end
            else
                getgenv().DangSafeMode = false
                getgenv().ViTriSafe = nil
            end
        end)
    end
end)

local function HandleSeaEventCombat(hrp, seaEventTarget, eType, targetPos, isLeviathan)
    if getgenv().Meyy6Race_API then
        if isLeviathan then
            getgenv().Meyy6Race_API.SetTask("Killing Leviathan")
            getgenv().Meyy6Race_API.SetTheme("Sky")
        else
            local mobName = seaEventTarget.Name
            mobName = string.gsub(mobName, "%d+", "")
            getgenv().Meyy6Race_API.SetTask("Killing " .. mobName)
            getgenv().Meyy6Race_API.SetTheme("Lavender")
        end
    end

    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        if LP.Character.Humanoid.Sit then
            LP.Character.Humanoid.Sit = false
            task.wait(0.1)
        end
    end

    getgenv().CurrentTarget = seaEventTarget
    getgenv().CurrentTargetPart = seaEventTarget:FindFirstChild("HumanoidRootPart", true)
        or seaEventTarget:FindFirstChild("VehicleSeat", true)
        or seaEventTarget.PrimaryPart
        or seaEventTarget:FindFirstChildWhichIsA("BasePart", true)

    local wName = _G.SelectedWeapon
    getgenv().IsPureM1 = false
    getgenv().UseOnlyGunSkill = false

    if _G.UseGunEvent and _G.UseM1FruitEvent then
        if seaEventTarget.Name:find("Sea Beast") or seaEventTarget.Name:find("Rumbling") or seaEventTarget.Name:find("Brigade") then
            wName = "Fruit"
            getgenv().IsPureM1 = true
        else
            wName = "Gun"
            getgenv().UseOnlyGunSkill = true
        end
    elseif _G.UseGunEvent then
        wName = "Gun"
        getgenv().UseOnlyGunSkill = true
    elseif _G.UseM1FruitEvent then
        wName = "Fruit"
        getgenv().IsPureM1 = true
    else
        if seaEventTarget.Name:find("Terrorshark") then
            wName = _G.SelectedWeapon
            getgenv().IsPureM1 = true
            getgenv().UseOnlyGunSkill = false
        else
            if eType == "M1" then getgenv().IsPureM1 = true end
            if wName == "Gun" then getgenv().UseOnlyGunSkill = true end
        end
    end


    local flyCFrame = HandleTargetPositioning(seaEventTarget, eType, wName, targetPos)

    if getgenv().DangSafeMode and getgenv().ViTriSafe then
        flyCFrame = getgenv().ViTriSafe
    end

    if flyCFrame then
        if khoiDiChuyen then
            local currentY = khoiDiChuyen.Position.Y
            local targetY = flyCFrame.Position.Y
            if math.abs(currentY - targetY) > 5 then
                khoiDiChuyen.CFrame = CFrame.new(khoiDiChuyen.Position.X, targetY, khoiDiChuyen.Position.Z)
                task.wait(0.1)
            end
        end
        DiChuyenDen(flyCFrame)
    end


    if wName == "Gun" and _G.UseGunEvent then
        local gunEquipName = (seaEventTarget.Name:find("Sea Beast") or seaEventTarget.Name:find("Rumbling")) and "Skull Guitar" or "Dragonstorm"
        EquipGun(gunEquipName)
    else
        if getgenv().IsPureM1 then
            equip(wName)
        end
    end
end
local Tiki_Points = {
    Vector3.new(4574.8701, 22.5545, -4429.2261),
    Vector3.new(-3904.3430, 22.5565, -287.6272),
    Vector3.new(-10974.2920, 22.5565, 245.2649),
    Vector3.new(-15071.9961, 22.5554, 373.7648),
    Vector3.new(-16204.4648, 22.5554, 438.3202)
}

local Hydra_Points = {
    Vector3.new(13560.2676, 27.5490, -5763.9375),
    Vector3.new(12969.5615, 27.5565, -2921.5220),
    Vector3.new(12027.5146, 27.5565, 412.7256),
    Vector3.new(8967.5996, 27.5565, 3901.3904),
    Vector3.new(6061.9238, 27.5565, 5328.6504),
    Vector3.new(4839.1465, 27.5561, 5212.8022),
    Vector3.new(4698.8105, 27.5565, 4252.9385),
    Vector3.new(5005.5952, 27.5557, 3725.4436),
    Vector3.new(5176.7275, 27.5540, 3269.4182),
    Vector3.new(5141.3120, 27.5525, 2943.8655),
    Vector3.new(5190.1035, 27.5564, 2052.7825),
    Vector3.new(5201.9844, 27.7811, 1589.3344)
}

local currentPathIndex = 0
local lastDest = nil
local daBatDauKeoTim = false
local doiTimBayGan = false

local function TinhGocLech(thuyen, mucTieu)
    local cframeThuyen = thuyen.PrimaryPart.CFrame
    local posThuyen = cframeThuyen.Position
    local lookVec = (cframeThuyen.LookVector * Vector3.new(1, 0, 1)).Unit
    local dirVec = ((mucTieu - posThuyen) * Vector3.new(1, 0, 1)).Unit
    local dotP = lookVec:Dot(dirVec)
    local goc = math.deg(math.acos(math.clamp(dotP, -1, 1)))
    local crossP = lookVec:Cross(dirVec)
    return crossP.Y < 0 and -goc or goc
end

local function XoayThuyen(thuyen, mucTieu)
    local pos = thuyen.PrimaryPart.Position
    local targetFlat = Vector3.new(mucTieu.X, pos.Y, mucTieu.Z)
    thuyen:SetPrimaryPartCFrame(CFrame.lookAt(pos, targetFlat))
end

local function NoclipThuyenKeoTim(thuyen)
    for _, v in ipairs(thuyen:GetDescendants()) do
        if (v:IsA("BasePart") or v:IsA("MeshPart") or v:IsA("Part")) and v.CanCollide then
            v.CanCollide = false
        end
    end
end

local function KeoTimVeDao()
    if not _G.DangSan or not _G.ShootHeart then 
        daBatDauKeoTim = false
        doiTimBayGan = false
        currentPathIndex = 0
        lastDest = nil
        return false 
    end
    if not _G.DriveToTiki and not _G.DriveToHydra then 
        daBatDauKeoTim = false
        doiTimBayGan = false
        currentPathIndex = 0
        lastDest = nil
        return false 
    end
    
    local isFoundHeart, heartPos = GetFrozenHeartData()
    if not isFoundHeart then
        if daBatDauKeoTim then
            DungDiChuyen()
            daBatDauKeoTim = false
            doiTimBayGan = false
            currentPathIndex = 0
            lastDest = nil

            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Sit then
                repeat
                    hum.Sit = false
                    task.wait(0.1)
                until not hum.Sit or not hum.Parent
            end
            task.wait(1)
            pcall(function()
                local thuyenCu = KiemTraThuyen()
                if thuyenCu then
                    thuyenCu:Destroy()
                end
            end)
            local destClaimed = _G.DriveToTiki and "Tiki Outpost" or "Hydra Island"
            task.spawn(function()
                sendLeviWebhook("Heart Delivered", "Heart dragged successfully to " .. destClaimed .. "!")
                task.wait(2)
                if sendLeviInventoryWebhook then
                    sendLeviInventoryWebhook(destClaimed)
                end
            end)
            getgenv().NotifiedHeartHarpooned = false
            if hum and hum.Parent then
                hum.Health = 0
            end
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Heart Claimed - Resetting")
                getgenv().Meyy6Race_API.SetTheme("Dark")
            end
        else
            currentPathIndex = 0
        end
        return false
    end
    
    local isHarpooned = IsFrozenHeartHarpooned()
    if not isHarpooned then
        currentPathIndex = 0
        return false
    end
    
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")
    local boat = KiemTraThuyen()
    
    if not boat or not boat.PrimaryPart or not hrp or not humanoid then return false end
    
    local vehicleSeat = boat:FindFirstChild("VehicleSeat")
    if not vehicleSeat then return false end

    if not humanoid.Sit or humanoid.SeatPart ~= vehicleSeat then
        return false
    end
    
    daBatDauKeoTim = true
    _G.DangKeoTim = true
    local currentDest = _G.DriveToTiki and "Tiki" or "Hydra"
    if lastDest ~= currentDest then
        lastDest = currentDest
        currentPathIndex = 0
    end
    
    local targetPath = _G.DriveToTiki and Tiki_Points or Hydra_Points
    local boatPos = boat.PrimaryPart.Position
    
    if currentPathIndex == 0 then
        local minDist = math.huge
        local nearestIdx = 1
        for i, point in ipairs(targetPath) do
            local dist = (Vector3.new(boatPos.X, 0, boatPos.Z) - Vector3.new(point.X, 0, point.Z)).Magnitude
            if dist < minDist then
                minDist = dist
                nearestIdx = i
            end
        end
        currentPathIndex = nearestIdx
    end

    local targetPoint = targetPath[currentPathIndex]
    local flyHeight = _G.PullYHeight or 35
    local distToTarget = (Vector3.new(boatPos.X, 0, boatPos.Z) - Vector3.new(targetPoint.X, 0, targetPoint.Z)).Magnitude
    
    if heartPos then
        local distToHeart = (boatPos - heartPos).Magnitude
        if distToHeart > 550 then
            doiTimBayGan = true
        elseif distToHeart < 225 then
            doiTimBayGan = false
        end
    end

    if doiTimBayGan then
        DungDiChuyen()
        task.spawn(function()
            vehicleSeat.MaxSpeed = 135
            NoclipThuyenKeoTim(boat)
        end)
        
        if boat.PrimaryPart then
            -- Lùi lại gần tim (Reverse)
            boat.PrimaryPart.ThrottleFloat = -1
            boat.PrimaryPart.Throttle = -1
        end
        if getgenv().Meyy6Race_API then
            getgenv().Meyy6Race_API.SetTask("Backing up to Heart")
            getgenv().Meyy6Race_API.SetTheme("Red")
        end
        return true
    end
    
    if getgenv().Meyy6Race_API then
        local destName = currentDest == "Tiki" and "Tiki" or "Hydra"
        local themeName = currentDest == "Tiki" and "Luxury" or "Mint"
        local finalPoint = targetPath[#targetPath]
        local distToFinal = math.floor((Vector3.new(boatPos.X, 0, boatPos.Z) - Vector3.new(finalPoint.X, 0, finalPoint.Z)).Magnitude)
        getgenv().Meyy6Race_API.SetTask("Driving to " .. destName .. " (" .. distToFinal .. "m)")
        getgenv().Meyy6Race_API.SetTheme(themeName)
    end

    if currentPathIndex < #targetPath and distToTarget <= 50 then
        currentPathIndex = currentPathIndex + 1
        targetPoint = targetPath[currentPathIndex]
    end

    local flatTargetPos = Vector3.new(targetPoint.X, flyHeight, targetPoint.Z)
    
    local gocLech = TinhGocLech(boat, flatTargetPos)
    
    task.spawn(function()
        vehicleSeat.MaxSpeed = _G.TocDoTweenBoat or 250
        NoclipThuyenKeoTim(boat)
    end)
    
    if currentPathIndex < #targetPath or distToTarget > 50 then
        DungDiChuyen()
        
        if math.abs(gocLech) > 5 then
            XoayThuyen(boat, flatTargetPos)
            boat.PrimaryPart.ThrottleFloat = 0
            boat.PrimaryPart.Throttle = 0
        else
            boat.PrimaryPart.ThrottleFloat = 1
            boat.PrimaryPart.Throttle = 1
        end
    else
        boat.PrimaryPart.ThrottleFloat = 0
        boat.PrimaryPart.Throttle = 0
        DungDiChuyen()
        if getgenv().Meyy6Race_API then
            getgenv().Meyy6Race_API.SetTask("Arrived at Destination")
            getgenv().Meyy6Race_API.SetTheme("Green")
        end
    end
    
    return true
end
local function HandlePatrolAndIdle(hrp, isLeviathan, isFoundWatcher)
    getgenv().CurrentTarget = nil
    getgenv().CurrentTargetPart = nil
    getgenv().MacroAimPos = nil
    getgenv().IsPureM1 = false
    getgenv().UseOnlyGunSkill = false
    if isFoundWatcher then
        if LP.Character and LP.Character:FindFirstChild("Humanoid") then
            if LP.Character.Humanoid.Sit then
                LP.Character.Humanoid.Sit = false
            end
        end
        DungDiChuyen()
    else
        local thuyen = KiemTraThuyen()
        
        if _G.NguoiMuaThuyen == LP.Name then
            local dangMuaThuyen = false
            if not isLeviathan then
                dangMuaThuyen = HandleBoatRespawnLogic(thuyen)
            end

            if not dangMuaThuyen and thuyen then
                local gheLai = thuyen:FindFirstChild("VehicleSeat")
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if gheLai and hrp and hum then
                        if not hum.Sit then
                            if getgenv().Meyy6Race_API then
                            getgenv().Meyy6Race_API.SetTask("Boarding Boat")
                            getgenv().Meyy6Race_API.SetTheme("Dream")
                        end
                        DiChuyenDen(gheLai.CFrame * CFrame.new(0, 3, 0))
                        task.wait(0.2)
                        if (gheLai.Position - hrp.Position).Magnitude <= 10 and hum and hum.Parent then
                            gheLai:Sit(hum)
                        end
                    else 
                        if KiemTraDieuKienSan() then
                        local viTriXuatPhat = Vector3.new(-16204.9668, 0, 474.9888)
                        local distToSpawn = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - viTriXuatPhat).Magnitude

                        if not _G.PatrolState or distToSpawn < 500 then
                            _G.PatrolState = 1
                        end
                            local hrpPos = hrp.Position
                            local isIgnoring = _G.EnableIgnoreSeaEvent and KiemTraQuaiKhongChon()
                            local isIgnoringIsland = _G.EnableIgnoreIsland and KiemTraDaoIgnore()
                            local currentBay = isIgnoringIsland and _G.IgnoreIslandHeight or (isIgnoring and _G.IgnoreHeight or _G.ChieuCaoBay)
                            local yHigh = currentBay
                            local yNormal = currentBay
                            
                            local sea1 = Vector3.new(-14202.8643, yHigh, 447.1369)
                            local sea6 = Vector3.new(-16143.5469, yNormal, 37085.2148)
                            local sea9999 = Vector3.new(-16256.7344, yNormal, 106649.3828)
                            if _G.PatrolState == 1 then
                                if getgenv().Meyy6Race_API then
                                    getgenv().Meyy6Race_API.SetTask("Patrolling Sea")
                                    getgenv().Meyy6Race_API.SetTheme("Candy")
                                end
                                if math.abs(hrpPos.Y - yHigh) > 20 and khoiDiChuyen then
                                    khoiDiChuyen.CFrame = CFrame.new(khoiDiChuyen.Position.X, yHigh, khoiDiChuyen.Position.Z)
                                    task.wait(0.1)
                                end
                                DiChuyenDen(CFrame.new(sea1))
                                
                                if (Vector3.new(hrpPos.X, 0, hrpPos.Z) - Vector3.new(sea1.X, 0, sea1.Z)).Magnitude <= 200 then
                                    _G.PatrolState = 2
                                end
                            elseif _G.PatrolState == 2 then
                                if khoiDiChuyen then
                                    khoiDiChuyen.CFrame = CFrame.new(khoiDiChuyen.Position.X, yNormal, khoiDiChuyen.Position.Z)
                                    task.wait(0.1)
                                end
                                _G.PatrolState = 3
                            elseif _G.PatrolState == 3 then
                                if getgenv().Meyy6Race_API then
                                    getgenv().Meyy6Race_API.SetTask("Find Leviathan")
                                    getgenv().Meyy6Race_API.SetTheme("Dark")
                                end
                                DiChuyenDen(CFrame.new(sea6))
                                
                                if hrpPos.Z >= sea6.Z or (Vector3.new(hrpPos.X, 0, hrpPos.Z) - Vector3.new(sea6.X, 0, sea6.Z)).Magnitude <= 200 then
                                    _G.PatrolState = 4
                                end
                            elseif _G.PatrolState == 4 then
                                if getgenv().Meyy6Race_API then
                                    getgenv().Meyy6Race_API.SetTask("Find Leviathan")
                                    getgenv().Meyy6Race_API.SetTheme("Dark")
                                end
                                DiChuyenDen(CFrame.new(sea9999))
                                
                                if hrpPos.Z >= sea9999.Z or (Vector3.new(hrpPos.X, 0, hrpPos.Z) - Vector3.new(sea9999.X, 0, sea9999.Z)).Magnitude <= 200 then
                                    _G.PatrolState = 5
                                end
                            elseif _G.PatrolState == 5 then
                                if getgenv().Meyy6Race_API then
                                    getgenv().Meyy6Race_API.SetTask("Find Leviathan")
                                    getgenv().Meyy6Race_API.SetTheme("Dark")
                                end
                                DiChuyenDen(CFrame.new(sea6))
                                
                                if hrpPos.Z <= sea6.Z or (Vector3.new(hrpPos.X, 0, hrpPos.Z) - Vector3.new(sea6.X, 0, sea6.Z)).Magnitude <= 200 then
                                    _G.PatrolState = 4
                                end
                            end
                        else
                            if getgenv().Meyy6Race_API then
                                getgenv().Meyy6Race_API.SetTask("Waiting for Members")
                                getgenv().Meyy6Race_API.SetTheme("Lavender")
                            end
                            DungDiChuyen()
                        end
                    end
                end
            end
        else
            if thuyen and hrp then
                local dist = thuyen.PrimaryPart and (thuyen.PrimaryPart.Position - hrp.Position).Magnitude or 0
                if dist > 30000000000 then
                    DungDiChuyen()
                else
                    local quaiHienTai = GetNearestSeaEvent()
                    if LP.Character and LP.Character:FindFirstChild("Humanoid") and not LP.Character.Humanoid.Sit and not quaiHienTai then
                        local gheTrong = nil
                        local harpoon = thuyen:FindFirstChild("Harpoon")
                        local harpoonSeat = harpoon and harpoon:FindFirstChild("Seat")
                        for _, part in ipairs(thuyen:GetDescendants()) do
                            if part:IsA("Seat") and part.Name ~= "VehicleSeat" and part ~= harpoonSeat and not part.Occupant then
                                gheTrong = part
                                break
                            end
                        end
                        
                        if gheTrong then
                            if getgenv().Meyy6Race_API then
                                getgenv().Meyy6Race_API.SetTask("Boarding Boat")
                                getgenv().Meyy6Race_API.SetTheme("Dream")
                            end
                            DiChuyenDen(gheTrong.CFrame * CFrame.new(0, 3, 0))
                            task.wait(0.5)
                        local quaiSauKhiCho = GetNearestSeaEvent()
                            if (gheTrong.Position - hrp.Position).Magnitude <= 10 and not quaiSauKhiCho then
                                gheTrong:Sit(LP.Character.Humanoid)
                            end
                        else
                            if thuyen.PrimaryPart then
                                DiChuyenDen(thuyen.PrimaryPart.CFrame * CFrame.new(0, 5, 0))
                            end
                        end
                    elseif quaiHienTai then
                        if LP.Character and LP.Character.Humanoid.Sit then
                            LP.Character.Humanoid.Sit = false
                        end

                    else
                        DungDiChuyen()
                    end
                end
            else
                DungDiChuyen()
            end
        end
    end
end
---------
task.spawn(function()
    while task.wait() do
        if getgenv().DangDiMuaDo then
            continue
        end
        if _G.DangSan then
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LP.Character and LP.Character:FindFirstChild("Humanoid")

            local isFoundWatcher, watcherPos = getFrozenWatcherPosition()
            if isFoundWatcher then
                if HandleFrozenWatcherLogic(hrp, humanoid, watcherPos) then continue end
            end

            local isFoundHeart, heartPos, frozenHeartObj = GetFrozenHeartData()
            
            if _G.ShootHeart then
                if isFoundHeart or daBatDauKeoTim then
                    local isHarpooned = IsFrozenHeartHarpooned()
                    
                    if (_G.DriveToTiki or _G.DriveToHydra) and (isHarpooned or daBatDauKeoTim) then
                        if KeoTimVeDao() then continue end
                    end
                    
                    if isFoundHeart then
                        if HandleFrozenHeartLogic(hrp, humanoid, heartPos) then continue end
                    end
                end
            end
            
            if daBatDauKeoTim then continue end
            
            local seaEventTarget, eType, targetPos = GetNearestSeaEvent()
            local skipSeaEvents = false
            
            if _G.DestroyIDK then
                local allCleared = true
                local rawData = nil
                
                if getgenv().FetchUnifiedPartyData then
                    rawData = getgenv().FetchUnifiedPartyData()
                end
                
                if rawData then
                    for _, acc in pairs(rawData) do
                        if acc.IDK == true then
                            allCleared = false
                            break
                        end
                    end
                else
                    allCleared = (_G.SpyCheckResult > -1 and _G.SpyCheckResult <= 5)
                end

                if allCleared then
                    skipSeaEvents = true
                end
            end
            local isLeviathan = false
            if seaEventTarget and (seaEventTarget.Name == "Leviathan Segment" or seaEventTarget.Name == "Leviathan") then 
                isLeviathan = true 
                task.wait() 
            end

            if getgenv().DangSafeMode and getgenv().ViTriSafe then
                if getgenv().Meyy6Race_API then
                    getgenv().Meyy6Race_API.SetTask("Low HP - Healing")
                end
                DiChuyenDen(getgenv().ViTriSafe)
            elseif seaEventTarget and targetPos and (not skipSeaEvents or isLeviathan) then
                HandleSeaEventCombat(hrp, seaEventTarget, eType, targetPos, isLeviathan)
            else
                HandlePatrolAndIdle(hrp, isLeviathan, isFoundWatcher)
            end
        else
            getgenv().CurrentTarget = nil
            getgenv().CurrentTargetPart = nil
            getgenv().MacroAimPos = nil
            getgenv().IsPureM1 = false
            getgenv().UseOnlyGunSkill = false
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Idle")
                getgenv().Meyy6Race_API.SetTheme("Dark")
            end
            DungDiChuyen()
        end
    end
end)
---------

local function down(use, waitTime)
    pcall(function()
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            VirtualInputManager:SendKeyEvent(true, use, false, LP.Character.HumanoidRootPart)
            task.wait(waitTime or 0.1)
            VirtualInputManager:SendKeyEvent(false, use, false, LP.Character.HumanoidRootPart)
        end
    end)
end

local function Useskills(weapon, skill)
    if weapon == "nil" and skill == "Y" then
        VirtualInputManager:SendKeyEvent(true, "Y", false, game)
        VirtualInputManager:SendKeyEvent(false, "Y", false, game)
    end
end

local SkillConfig = {
    ["Auto Enable V3"] = false, 
    ["Auto Enable V4"] = false,
    ["Custom Health"] = true,
    ["Health"] = 3000,
    ["Melee"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 1, ["Count"] = 30},
        ["X"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 2, ["Count"] = 30},
        ["C"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 3, ["Count"] = 30}
    },        
    ["Sword"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 4, ["Count"] = 20},
        ["X"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 5, ["Count"] = 20}
    },        
    ["Gun"] = {
        ["Enable"] = true,
        ["GunMode"] = false,
        ["Z"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 6, ["Count"] = 20},
        ["X"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 7, ["Count"] = 20}
    },        
    ["Fruit"] = {
        ["Enable"] = true,
        ["Z"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 8, ["Count"] = 20},
        ["X"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 9, ["Count"] = 20},
        ["C"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 10, ["Count"] = 20},
        ["V"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 11, ["Count"] = 20},
        ["F"] = {["Enable"] = false, ["HoldTime"] = 0.1, ["Priority"] = 12, ["Count"] = 20}
    }
}

local function getDelay(toolName)
    if _G.NoSkillDelay then return 0.05 end
    local delayMs = 100
    if toolName == "Melee" then delayMs = _G.SkillDelayMelee or 100 end
    if toolName == "Sword" then delayMs = _G.SkillDelaySword or 100 end
    if toolName == "Gun" then delayMs = _G.SkillDelayGun or 100 end
    if toolName == "Fruit" then delayMs = _G.SkillDelayFruit or 100 end
    return delayMs / 1000
end

task.spawn(function()
    while task.wait() do 
        pcall(function()
            if getgenv().CurrentTarget and getgenv().CurrentTargetPart and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                if (getgenv().CurrentTargetPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude < 50 then
                    if SkillConfig["Auto Enable V3"] then
                        if SkillConfig["Custom Health"] and LP.Character:FindFirstChild("Humanoid") and LP.Character.Humanoid.Health <= SkillConfig["Health"] then
                            down("T", 0.1)
                        end
                    end
                    if SkillConfig["Auto Enable V4"] then
                        if LP.Character:FindFirstChild("RaceEnergy") and LP.Character.RaceEnergy.Value == 1 then
                            Useskills("nil", "Y")
                        end
                    end
                end
            end
        end)
    end
end)

local HttpService = game:GetService("HttpService")
local FILE_NAME = "Meyy_Leviathan_Kaitun/Name.json"

local function GetPartyFromJSON()
    if getgenv().FetchUnifiedPartyData then
        return getgenv().FetchUnifiedPartyData()
    end
    return nil
end

getgenv().LastSpawnTime = os.time()

task.spawn(function()
    local LP = game:GetService("Players").LocalPlayer
    if LP.Character then
        getgenv().LastSpawnTime = os.time()
    end
    LP.CharacterAdded:Connect(function()
        getgenv().LastSpawnTime = os.time()
    end)
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if not _G.DangSan then
                return
            end
            if os.time() - getgenv().LastSpawnTime < 20 then
                return
            end
            local w = game:GetService("Players")
            local S = w.LocalPlayer
            local isSomeoneDead = false
            local rawData = GetPartyFromJSON()

            if rawData then
                for _, acc in pairs(rawData) do
                    local memberName = acc.Name
                    if memberName ~= S.Name then
                        local member = w:FindFirstChild(memberName)
                        if member then
                            local mChar = member.Character
                            local mHum = mChar and mChar:FindFirstChild("Humanoid")
                            if mChar and mHum and mHum.Health <= 0 then
                                isSomeoneDead = true
                                break
                            end
                        end
                    end
                end
            end

            if isSomeoneDead then
                local target = GetNearestSeaEvent()
                local isLeviathan = target and (target.Name == "Leviathan Segment" or target.Name == "Leviathan")
                local isFoundWatcher, _ = getFrozenWatcherPosition()
                local isFoundHeart, _1, _2 = GetFrozenHeartData()
                
                if not isLeviathan and not isFoundWatcher and not isFoundHeart then
                    print("Someone in the party is dead. Attempting to kill self to respawn.")
                    if S.Character and S.Character:FindFirstChild("Humanoid") then
                        if S.Character.Humanoid.Health > 0 then
                            S.Character.Humanoid.Health = 0
                            getgenv().LastSpawnTime = os.time()
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            if getgenv().DangSafeMode then return end
            if not getgenv().CurrentTarget or not getgenv().CurrentTargetPart then return end
            if getgenv().IsPureM1 then return end
            
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local targetPos = getgenv().CurrentTargetPart.Position
            local myPos = hrp.Position
            local distXZ = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(myPos.X, 0, myPos.Z)).Magnitude
            
            if distXZ > 150 then return end

            local toolMappings = {
                ["Melee"] = _G.SelectedMelee or {},
                ["Sword"] = _G.SelectedSword or {},
                ["Gun"] = _G.SelectedGun or {},
                ["Fruit"] = _G.SelectedFruit or {}
            }
            
            local queue = {}
            for typeName, selectedList in pairs(toolMappings) do
                if getgenv().UseOnlyGunSkill and typeName ~= "Gun" then
                    continue
                end
                
                if SkillConfig[typeName] and SkillConfig[typeName].Enable then
                    for skillKey, skillData in pairs(SkillConfig[typeName]) do
                        if type(skillData) == "table" and skillData.Priority then
                            skillData.Enable = table.find(selectedList, skillKey) ~= nil
                            
                            if skillData.Enable then
                                table.insert(queue, {
                                    Type = typeName,
                                    Key = skillKey,
                                    Data = skillData
                                })
                            end
                        end
                    end
                end
            end
            
            table.sort(queue, function(a, b) return a.Data.Priority < b.Data.Priority end)
            
            for _, item in ipairs(queue) do
                local toolName = equip(item.Type)
                if toolName then
                    local skillGui = LP.PlayerGui.Main.Skills:FindFirstChild(toolName)
                    if skillGui and skillGui:FindFirstChild(item.Key) then
                        local titleLabel = skillGui[item.Key]:FindFirstChild("Title")
                        if titleLabel and titleLabel:IsA("TextLabel") and titleLabel.TextColor3 == Color3.fromRGB(255, 255, 255) then
                            local cdGui = skillGui[item.Key]:FindFirstChild("Cooldown")
                            if cdGui and cdGui.AbsoluteSize.X <= 0 then
                                local useDelay = getDelay(item.Type)
                                for i = 1, (item.Data.Count or 1) do
                                    if cdGui.AbsoluteSize.X > 0 then
                                        break
                                    end
                                    down(item.Key, item.Data.HoldTime)
                                    task.wait(useDelay)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

local PlayerMouse = game:GetService("Players").LocalPlayer:GetMouse()
local MT = getrawmetatable(game)
local OldNameCall = MT.__namecall
local OldIndex = MT.__index
setreadonly(MT, false)

MT.__index = newcclosure(function(self, key)
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
    return OldIndex(self, key)
end)

MT.__namecall = newcclosure(function(self, ...)
    local Method = getnamecallmethod()
    
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
    
    return OldNameCall(self, ...)
end)

setreadonly(MT, true)

local GunValidator = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Validator2")
local AimBotSkillPosition = nil 

pcall(function()
    local gg = getrawmetatable(game);
    local old = gg.__namecall;
    setreadonly(gg, false);

    gg.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod();
        local args = { ... }
        
        if _G.UseGunEvent and tostring(method) == "FireServer" and tostring(self) == "ShootGunEvent" then
            if AimBotSkillPosition then
                args[1] = AimBotSkillPosition 
                return old(self, unpack(args))
            end
        end
        return old(self, ...)
    end);
end)

local function FindNearestMob()
    return getgenv().CurrentTarget 
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
        if _G.UseGunEvent then
            local targetMob = FindNearestMob()
            if targetMob and getgenv().CurrentTargetPart then
                local targetPos = getgenv().CurrentTargetPart.Position
                local partToShoot = getgenv().CurrentTargetPart
                
                if targetPos then
                    AimBotSkillPosition = targetPos 
                    pcall(function()
                        local NetModule = require(ReplicatedStorage.Modules.Net)
                        NetModule:RemoteEvent("ShootGunEvent"):FireServer(targetPos, {partToShoot})
                    end)
                end
            end
        else
            AimBotSkillPosition = nil 
        end
        task.wait()
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
        if _G.UseGunEvent then
            local targetMob = FindNearestMob()
            if targetMob and getgenv().CurrentTargetPart then
                local targetPos = getgenv().CurrentTargetPart.Position
                
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

local SettingsTab = Window:CreateTab("Settings", true, "rbxthumb://type=Asset&id=125575515639947&w=420&h=420")
SettingsTab:CreatePageTitle("General Config")

SettingsTab:CreateDropdown("Select Team", "Marines", {"Marines", "Pirates"}, "Select your default team", function(val)
    _G.ChonPhe = val
    Library:SendNotification("Team Setup", "Auto team set to " .. val)
end)
SettingsTab:CreateDropdown("Select Weapon", "Melee", {"Melee", "Sword", "Blox Fruit", "Gun"}, "Select weapon for M1 sea events", function(val)
    _G.SelectedWeapon = val
end)
SettingsTab:CreateSwitch("Spin Position", true, "Spin around sea events target", function(val)
    _G.SpinPosition = val
end)
SettingsTab:CreateSwitch("Enable Ignore Sea Event", true, "Fly up if unselected event spawns", function(val)
    _G.EnableIgnoreSeaEvent = val
end)
SettingsTab:CreateSwitch("Enable Ignore Island", true, "Fly up when near Prehistoric or Mystic Island", function(val)
    _G.EnableIgnoreIsland = val
end)
_G.SafeFlyingBoat = true
SettingsTab:CreateSwitch("Safe Flying Boat", true, "Auto fly and orbit to dodge when unsit", function(val)
    _G.SafeFlyingBoat = val
end)
SettingsTab:CreateSwitch("Enable Noclip", true, "Prevent getting stuck", function(val)
    _G.BatNoclip = val
    Library:SendNotification("Noclip Status", val and "Enabled" or "Disabled")
end)
_G.AutoBuso = true
SettingsTab:CreateSwitch("Auto Buso Haki", true, "Auto turn on buso haki", function(val)
    _G.AutoBuso = val
end)

_G.AutoV3 = true
SettingsTab:CreateSwitch("Auto V3", true, "Auto turn on v3", function(val)
    _G.AutoV3 = val
end)

_G.AutoKen = true
SettingsTab:CreateSwitch("Auto Observation Haki", true, "Auto turn on Observation haki", function(val)
    _G.AutoKen = val
end)
SettingsTab:CreateSlider("Tween Speed", 50, 500, 170, "Movement speed (studs/s)", function(val)
    _G.TocDoTween = val 
end)

SettingsTab:CreateSlider("Tween Boat Speed", 50, 500, 250, "Boat movement speed (studs/s)", function(val)
    _G.TocDoTweenBoat = val 
end)

SettingsTab:CreateSlider("Flight Height", 10, 500, 20, "Set Y axis for boat flying", function(val)
    _G.ChieuCaoBay = val
end)
SettingsTab:CreateSlider("Ignore Height", 50, 1500, 500, "Y axis when ignoring monsters", function(val)
    _G.IgnoreHeight = val
end)
SettingsTab:CreateSlider("Ignore Island Height", 50, 2000, 800, "Y axis when ignoring islands", function(val)
    _G.IgnoreIslandHeight = val
end)
_G.SafeHeightY = 400
SettingsTab:CreateSlider("Safe Height Y", 50, 1000, 400, "Y-axis height for boat to dodge", function(val)
    _G.SafeHeightY = val
end)

_G.SafeRadius = 250
SettingsTab:CreateSlider("Safe Orbit Radius", 0, 500, 250, "Radius to orbit around sea event", function(val)
    _G.SafeRadius = val
end)
local ShopTab = Window:CreateTab("Shop & Status", false, "rbxassetid://130982467998100")
ShopTab:CreatePageTitle("Server Status")

local SpyPara = ShopTab:CreateParagraph("Spy Status", "Loading...")
local FrozenPara = ShopTab:CreateParagraph("Frozen Dimension", "Loading...")

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local spyText = "I Don't Know"
            if _G.SpyCheckResult == -1 then
                spyText = "I Don't Know"
            elseif _G.SpyCheckResult >= 1 and _G.SpyCheckResult <= 4 then
                spyText = "Done Destroy - Can Bride " .. tostring(5 - _G.SpyCheckResult) .. " More"
            elseif _G.SpyCheckResult == 5 then
                spyText = "Done Bride - Can Find Levi"
            end

            if SpyPara and SpyPara.Set then
                pcall(function() SpyPara:Set({Title = "Spy Status", Content = spyText}) end)
                pcall(function() SpyPara:Set("Spy Status", spyText) end)
            end

            local isFoundWatcher, _ = getFrozenWatcherPosition()
            local frozenText = isFoundWatcher and "Have Frozen Dimension In Server" or "No Frozen Dimension In Server"

            if FrozenPara and FrozenPara.Set then
                pcall(function() FrozenPara:Set({Title = "Frozen Dimension", Content = frozenText}) end)
                pcall(function() FrozenPara:Set("Frozen Dimension", frozenText) end)
            end
        end)
    end
end)
---------
ShopTab:CreatePageTitle("Random Fruit")



ShopTab:CreateSwitch("Auto Random Fruit", true, "Automatically roll fruit every 60s", function(val)
    _G.AutoRandomFruit = val
end)

ShopTab:CreateSwitch("Auto Store Fruit", true, "Automatically store fruits to inventory", function(val)
    _G.AutoStoreFruit = val
end)

task.spawn(function()
    while task.wait(60) do
        if _G.AutoRandomFruit then
            pcall(function()
                local args1 = {
                    {
                        BoxName = "ZiolesGacha",
                        Context = "Check",
                        SpokeNPC = "Blox Fruit Gacha"
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/GachaNetworkRF"):InvokeServer(unpack(args1))

                task.wait(1)

                local args2 = {
                    {
                        Context = "Purchase",
                        BoxName = "ZiolesGacha"
                    }
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/GachaNetworkRF"):InvokeServer(unpack(args2))
            end)
        end
    end
end)

local lastStoredFruit = nil
local fruitStoreAttempts = 0

task.spawn(function()
    while task.wait(1) do
        if _G.AutoStoreFruit then
            pcall(function()
                local char = LP.Character
                local backpack = LP:FindFirstChild("Backpack")
                local targetFruitTool = nil

                if char then
                    for _, item in ipairs(char:GetChildren()) do
                        if item:IsA("Tool") and (item:GetAttribute("Fruit") or string.find(item.Name, "Fruit")) then
                            targetFruitTool = item
                            break
                        end
                    end
                end

                if not targetFruitTool and backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and (item:GetAttribute("Fruit") or string.find(item.Name, "Fruit")) then
                            targetFruitTool = item
                            break
                        end
                    end
                end

                if targetFruitTool then
                    if lastStoredFruit ~= targetFruitTool then
                        lastStoredFruit = targetFruitTool
                        fruitStoreAttempts = 0
                    end

                    if fruitStoreAttempts < 10 then
                        local fruitInternalName = targetFruitTool:GetAttribute("OriginalName") or targetFruitTool:GetAttribute("FruitName") or targetFruitTool.Name
                        local storeArgs = {
                            "StoreFruit",
                            fruitInternalName,
                            targetFruitTool
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(storeArgs))
                        fruitStoreAttempts = fruitStoreAttempts + 1
                    end
                else
                    lastStoredFruit = nil
                    fruitStoreAttempts = 0
                end
            end)
        end
    end
end)
ShopTab:CreatePageTitle("Shop")

ShopTab:CreateButton("Reroll Race", "change race ", function()
    local args1 = {
        "BlackbeardReward",
        "Reroll",
        "1"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args1))
    
    local args2 = {
        "BlackbeardReward",
        "Reroll",
        "2"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args2))
end)

ShopTab:CreateButton("Reset Stats", "reset stats", function()
    local args1 = {
        "BlackbeardReward",
        "Refund",
        "1"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args1))

    local args2 = {
        "BlackbeardReward",
        "Refund",
        "2"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args2))
end)

ShopTab:CreateButton("Buy Ghoul Race", "Change To Ghoul Race", function()
    local args = {
        "Ectoplasm",
        "Change",
        4
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
end)

ShopTab:CreateButton("Buy Cyborg Race", "Change To Cyborg Race", function()
    local args = {
        "CyborgTrainer",
        "Buy"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
end)


ShopTab:CreateButton("Buy Draco Race", "Change To Draco Race", function()
    task.spawn(function()
        local npcPos = GetNpcPosition("Dragon Wizard")
        if npcPos then
            getgenv().DangDiMuaDo = true
            if getgenv().Meyy6Race_API then
                getgenv().Meyy6Race_API.SetTask("Moving to NPC")
                getgenv().Meyy6Race_API.SetTheme("Dark")
            end
            DiChuyenDen(CFrame.new(npcPos))
            while task.wait(0.1) do
                local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then break end
                
                if (hrp.Position - npcPos).Magnitude <= 15 then
                    DungDiChuyen()
                    local args1 = {{NPC = "Dragon Wizard", Command = "Speak"}}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest"):InvokeServer(unpack(args1))
                    task.wait(0.5)
                    local args2 = {{NPC = "Dragon Wizard", Command = "DragonRace"}}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/InteractDragonQuest"):InvokeServer(unpack(args2))
                    getgenv().DangDiMuaDo = false
                    break
                end
            end
        end
    end)
end)

ShopTab:CreatePageTitle("Buy Melee")

local MeleeConfig = {
    {Name = "Sanguine Art", NPC = "Shafi", Remote = "BuySanguineArt", Extra = nil},
    {Name = "Godhuman", NPC = "Ancient Monk", Remote = "BuyGodhuman", Extra = nil},
    {Name = "Dragon Talon", NPC = "Uzoth", Remote = "BuyDragonTalon", Extra = nil},
    {Name = "Electric Claw", NPC = "Previous Hero", Remote = "BuyElectricClaw", Extra = nil},
    {Name = "Sharkman Karate", NPC = "Sharkman Teacher", Remote = "BuySharkmanKarate", Extra = nil},
    {Name = "Death Step", NPC = "Phoeyu, the Reformed", Remote = "BuyDeathStep", Extra = nil},
    {Name = "Superhuman", NPC = "Martial Arts Master", Remote = "BuySuperhuman", Extra = nil}
}

for _, melee in ipairs(MeleeConfig) do
    local toggleVar = "AutoBuy_" .. string.gsub(melee.Name, " ", "")
    _G[toggleVar] = false
    
    ShopTab:CreateSwitch("Buy " .. melee.Name, false, "Go To Buying Melee " .. melee.Name, function(val)
        _G[toggleVar] = val
        if val then
            task.spawn(function()
                local npcPos = GetNpcPosition(melee.NPC)
                if npcPos then
                    getgenv().DangDiMuaDo = true
                    DiChuyenDen(CFrame.new(npcPos))
                    while _G[toggleVar] do
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            if (hrp.Position - npcPos).Magnitude <= 15 then
                                DungDiChuyen()
                                local args = {melee.Remote}
                                if melee.Extra ~= nil then
                                    table.insert(args, melee.Extra)
                                end
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
                                _G[toggleVar] = false
                                getgenv().DangDiMuaDo = false
                                break
                            end
                        end
                        task.wait(0.2)
                    end
                end
            end)
        else
            getgenv().DangDiMuaDo = false
            DungDiChuyen()
        end
    end)
end

local HuntTab = Window:CreateTab("Hunt Leviathan", false, "rbxassetid://110509017095259")
HuntTab:CreatePageTitle("Boost Fps & Remove Fog")
repeat
    task.wait(0.5)
until LP.Team ~= nil and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")

HuntTab:CreateSwitch("Remove Fog", true, "Clear all fog for better vision", function(val)
    _G.XoaSuongMu = val
end)
_G.BoostFPS_Executed = false
HuntTab:CreateSwitch("Boost Fps", false, "Extreme FPS boost & Remove Sound", function(val)
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
HuntTab:CreatePageTitle("Sea Event & Setup")

HuntTab:CreateSwitch("Use Gun For Sea Event", false, "Auto use Dragonstorm or Skull Guitar", function(val)
    _G.UseGunEvent = val
end)

HuntTab:CreateSwitch("Use M1 Fruit For Sea Event", false, "Auto use M1 Fruit for all sea events", function(val)
    _G.UseM1FruitEvent = val
end)

HuntTab:CreateMultiDropdown("Select Sea Events", {"Leviathan"}, {"Piranha", "Terrorshark", "Shark", "PirateBrigade", "PirateGrandBrigade", "FishBoat", "Sea Beast", "Leviathan"}, "Select events to hunt", function(val)
    _G.SelectedEvents = val
end)
local danhSachNguoiChoi = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(danhSachNguoiChoi, p.Name)
end


local danhSachNguoiChoi = {}
for _, p in ipairs(Players:GetPlayers()) do
    table.insert(danhSachNguoiChoi, p.Name)
end

---------
local function FormatBoatForRemote(boatDisplayName)
    if boatDisplayName == "Beast Hunter" then
        return "Beast Hunter"
    end
    return string.gsub(boatDisplayName, "%s+", "")
end

local function GetBoatDisplayList()
    local teamPrefix = (_G.ChonPhe == "Marines" or _G.ChonPhe == "Marine") and "Marine " or "Pirate "
    return {
        teamPrefix .. "Sloop",
        teamPrefix .. "Brigade",
        teamPrefix .. "Grand Brigade",
        "Beast Hunter"
    }
end

local CurrentBoatDisplay = "Beast Hunter"
_G.TenThuyen = FormatBoatForRemote(CurrentBoatDisplay)

local BoatDropdown = HuntTab:CreateDropdown("Select Boat", CurrentBoatDisplay, GetBoatDisplayList(), "Select boat to buy", function(val)
    CurrentBoatDisplay = val
    _G.TenThuyen = FormatBoatForRemote(val)
end)

task.spawn(function()
    local lastTeam = _G.ChonPhe
    while task.wait(1) do
        if _G.ChonPhe ~= lastTeam then
            lastTeam = _G.ChonPhe
            local newOptions = GetBoatDisplayList()
            if BoatDropdown and BoatDropdown.Refresh then
                BoatDropdown:Refresh(newOptions)
            end
            CurrentBoatDisplay = "Beast Hunter"
            _G.TenThuyen = FormatBoatForRemote(CurrentBoatDisplay)
        end
    end
end)
---------

local BoatBuyerDropdown = HuntTab:CreateDropdown("Account Buy Boat", LP.Name, danhSachNguoiChoi, "Select the boat buyer account", function(val)
    _G.NguoiMuaThuyen = val
    if val == LP.Name then
        Library:SendNotification("Role Update", "You are the boat buyer")
    else
        Library:SendNotification("Role Update", "You are the helper clone")
    end
end)

HuntTab:CreateButton("Refresh Player List", "Update players in server", function()
    local newList = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(newList, p.Name)
    end
    if BoatBuyerDropdown and BoatBuyerDropdown.Refresh then
        BoatBuyerDropdown:Refresh(newList)
        Library:SendNotification("System Update", "Player list refreshed")
    end
end)


HuntTab:CreateDropdown("Required Players", "5", {"1", "2", "3", "4", "5", "6"}, "Players needed on boat to start", function(val)
    _G.SoNguoiCanThiet = tonumber(val)
    Library:SendNotification("Hunt Config", "Required players set to " .. val)
end)
HuntTab:CreatePageTitle("Drive Boat & Shoot Heart")

HuntTab:CreateSwitch("Drive Boat To Tiki", false, "Auto Shoot & drive to Tiki with heart", function(val)
    _G.DriveToTiki = val
    if val then 
        _G.DriveToHydra = false 
    end
end)

HuntTab:CreateSwitch("Drive Boat To Hydra", false, "Auto Shoot & drive to Hydra with heart", function(val)
    _G.DriveToHydra = val
    if val then 
        _G.DriveToTiki = false 
    end
end)
HuntTab:CreateSlider("Pull Y Height", 0, 100, 35, "Set flight height for dragging heart", function(val)
    _G.PullYHeight = val
end)
HuntTab:CreateSwitch("Shoot Heart", false, "Enable shooting and dragging heart", function(val)
    _G.ShootHeart = val
end)
HuntTab:CreatePageTitle("Hunt Leviathan")
HuntTab:CreateSwitch("Destroy IDK", false, "Destroy IDK to hunt Leviathan if spy says I Don't Know", function(val)
    _G.DestroyIDK = val
end)

HuntTab:CreateParagraph("Destroy IDK Explanation", 
    "🇻🇳 [VIETNAMESE]\n" ..
    "• Khi BẬT: Bỏ qua Sea Event, tập trung 100% tìm/đánh Leviathan. Đánh xong nếu bị IDK sẽ tự đi phá IDK.\n" ..
    "• Khi TẮT: Chạy đa nhiệm (Multi-task), vừa đi tìm Leviathan vừa tự động đánh sạch các Sea Event xuất hiện trên đường.\n\n" ..
    "🇬🇧 [ENGLISH]\n" ..
    "• When ON: Ignores minor Sea Events, focuses 100% on finding/killing Leviathan. Destroy IDK if stuck after killing.\n" ..
    "• When OFF: Multi-tasks by hunting all nearby Sea Events while simultaneously searching for Leviathan."
)

HuntTab:CreateSwitch("Start Hunt", false, "Start hunting Leviathan process", function(val)
    _G.DangSan = val
    if val then
        Library:SendNotification("Hunt Status", "Hunting Started")
    else
        Library:SendNotification("Hunt Status", "Hunting Stopped")
    end
end)

local CraftTab = Window:CreateTab("Craft Scrolls", false, "rbxassetid://92082782484537")
CraftTab:CreatePageTitle("Auto Craft Config")

CraftTab:CreateMultiDropdown("Select Scrolls", {}, {"Common Scroll", "Rare Scroll", "Legendary Scroll", "Mythical Scroll"}, "Select which scrolls to auto craft", function(val)
    _G.SelectedScrolls = val
end)

CraftTab:CreateSwitch("Enable Auto Craft", false, "Toggle auto craft for selected scrolls", function(val)
    _G.AutoCraftScrollSwitch = val
end)

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            if _G.AutoCraftScrollSwitch and type(_G.SelectedScrolls) == "table" then
                for _, scrollName in ipairs(_G.SelectedScrolls) do
                    AutoCraftScroll(scrollName)
                end
            end
        end)
    end
end)

CraftTab:CreateSlider("Common Scroll Cap", 0, 50, 0, "Max limit for Common Scrolls", function(val)
    ScrollCaps.CommonScroll = val
end)

CraftTab:CreateSlider("Rare Scroll Cap", 0, 50, 0, "Max limit for Rare Scrolls", function(val)
    ScrollCaps.RareScroll = val
end)

CraftTab:CreateSlider("Legendary Scroll Cap", 0, 15, 15, "Max limit for Legendary Scrolls", function(val)
    ScrollCaps.LegendaryScroll = val
end)

CraftTab:CreateSlider("Mythical Scroll Cap", 0, 10, 10, "Max limit for Mythical Scrolls", function(val)
    ScrollCaps.MythicalScroll = val
end)

local WebhookTab = Window:CreateTab("Webhook Config", false, "rbxassetid://7733779610")
WebhookTab:CreatePageTitle("Discord Webhook")

WebhookTab:CreateSwitch("Enable Webhook", false, "Turn on/off webhook notifications", function(val)
    _G.WebhookLevi.Enabled = val
end)

WebhookTab:CreateInput("Webhook URL", "Paste your webhook link here...", "", "URL to send discord messages", false, function(val)
    _G.WebhookLevi.Url = val
end)

WebhookTab:CreateInput("Discord User ID", "E.g: 123456789012345678", "", "Leave blank to ping everyone", true, function(val)
    _G.WebhookLevi.DiscordID = val
end)

WebhookTab:CreateSwitch("Enable Ping", false, "Ping everyone or specific user ID", function(val)
    _G.WebhookLevi.PingEnabled = val
end)

WebhookTab:CreatePageTitle("Notification Events")

WebhookTab:CreateSwitch("Notify Found Dimension", false, "Send alert when Frozen dimension is found", function(val)
    _G.WebhookLevi.NotifyWatcher = val
end)

WebhookTab:CreateSwitch("Notify Shoot Heart", false, "Send alert when successfully shooted heart", function(val)
    _G.WebhookLevi.NotifyShoot = val
end)

WebhookTab:CreateSwitch("Notify Heart Delivered", false, "Send alert when boat dragged heart to island", function(val)
    _G.WebhookLevi.NotifyDelivered = val
end)

WebhookTab:CreateSwitch("Notify Material Stats", false, "Send material summary after heart claimed", function(val)
    _G.WebhookLevi.NotifyInventory = val
end)

local SkillTab = Window:CreateTab("Selection Skill", false, "rbxassetid://88966134653623")
SkillTab:CreatePageTitle("Auto Skill Config")

SkillTab:CreateMultiDropdown("Melee Skills", {"Z", "X", "C"}, {"Z", "X", "C"}, "Select Melee Skills", function(val)
    _G.SelectedMelee = val
end)

SkillTab:CreateMultiDropdown("Blox Fruit Skills", {"Z", "X", "C", "F"}, {"Z", "X", "C", "V", "F"}, "Select Blox Fruit Skills", function(val)
    _G.SelectedFruit = val
end)

SkillTab:CreateMultiDropdown("Gun Skills", {"Z", "X"}, {"Z", "X"}, "Select Gun Skills", function(val)
    _G.SelectedGun = val
end)

SkillTab:CreateMultiDropdown("Sword Skills", {"Z", "X"}, {"Z", "X"}, "Select Sword Skills", function(val)
    _G.SelectedSword = val
end)
SkillTab:CreatePageTitle("Delay Skill Config")
_G.SkillDelayMelee = 100
SkillTab:CreateSlider("Melee Delay (ms)", 0, 1000, 100, "Delay for Melee Skills (ms)", function(val)
    _G.SkillDelayMelee = val
end)

_G.SkillDelayFruit = 100
SkillTab:CreateSlider("Fruit Delay (ms)", 0, 1000, 100, "Delay for Fruit Skills (ms)", function(val)
    _G.SkillDelayFruit = val
end)

_G.SkillDelayGun = 100
SkillTab:CreateSlider("Gun Delay (ms)", 0, 1000, 100, "Delay for Gun Skills (ms)", function(val)
    _G.SkillDelayGun = val
end)

_G.SkillDelaySword = 100
SkillTab:CreateSlider("Sword Delay (ms)", 0, 1000, 100, "Delay for Sword Skills (ms)", function(val)
    _G.SkillDelaySword = val
end)

_G.NoSkillDelay = true
SkillTab:CreateSwitch("Use Skill No Delay", true, "Use 0.05s ultra fast delay", function(val)
    _G.NoSkillDelay = val
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.AutoBuso then
                local char = LP.Character
                if char and not char:FindFirstChild("HasBuso") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.AutoV3 then
                ReplicatedStorage.Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)

_G.DaResetLeviathan = false
local dangResetLevi = false

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if dangResetLevi then return end

            if not _G.DangSan then
                _G.DaResetLeviathan = false
                return
            end

            local target, eType, targetPos = GetNearestSeaEvent()
            local isLeviathan = target and (target.Name == "Leviathan Segment" or target.Name == "Leviathan")

            if isLeviathan then
                if not _G.DaResetLeviathan then
                    dangResetLevi = true
                    _G.DaResetLeviathan = true
                    
                    task.wait()
                    if _G.DangSan then 
                        _G.DangSan = false
                        if getgenv().Meyy6Race_API then
                            getgenv().Meyy6Race_API.SetTask("Waiting Leviathan")
                            getgenv().Meyy6Race_API.SetTheme("Mint")
                        end
                        task.wait(9)
                        _G.DangSan = true
                    end
                    
                    dangResetLevi = false
                end
            else
                _G.DaResetLeviathan = false
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.AutoKen then
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

local dodgeAngle = 0
local isFlyingSafe = false

local function RestoreBoatPhysics(seat)
    if not seat or not seat.Parent then return end

    local bg = seat:FindFirstChild("BodyGyro")
    if not bg or not bg:IsA("BodyGyro") then
        if bg then bg:Destroy() end
        bg = Instance.new("BodyGyro")
        bg.Name = "BodyGyro"
        bg.Parent = seat
    end
    bg.MaxTorque = Vector3.new(165942064, 165942064, 165942064)
    bg.P = 10000
    bg.D = 300
    bg.CFrame = seat.CFrame

    local bp = seat:FindFirstChild("BodyPosition")
    if not bp or not bp:IsA("BodyPosition") then
        if bp then bp:Destroy() end
        bp = Instance.new("BodyPosition")
        bp.Name = "BodyPosition"
        bp.Parent = seat
    end
    bp.MaxForce = Vector3.new(0, 165942064, 0)
    bp.P = 10000
    bp.D = 300
    local waterPlane = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WaterBase-Plane")
    local waterY = waterPlane and (waterPlane.Position.Y + (waterPlane.Size.Y / 2)) or 24
    bp.Position = Vector3.new(seat.Position.X, waterY, seat.Position.Z)

    local bv = seat:FindFirstChild("BodyVelocity")
    if not bv or not bv:IsA("BodyVelocity") then
        if bv then bv:Destroy() end
        bv = Instance.new("BodyVelocity")
        bv.Name = "BodyVelocity"
        bv.Parent = seat
    end
    bv.MaxForce = Vector3.new(165942064, 0, 165942064)
    bv.P = 10000
    bv.Velocity = Vector3.zero
end

task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local thuyen = KiemTraThuyen()
            local vehicleSeat = thuyen and (thuyen:FindFirstChild("VehicleSeat") or thuyen:FindFirstChildWhichIsA("VehicleSeat", true))
            local mainPart = thuyen and (thuyen.PrimaryPart or vehicleSeat or thuyen:FindFirstChild("Engine"))

            local targetPart = getgenv().CurrentTargetPart or (getgenv().CurrentTarget and (getgenv().CurrentTarget:FindFirstChild("HumanoidRootPart") or getgenv().CurrentTarget.PrimaryPart))

            if _G.SafeFlyingBoat and _G.DangSan and hrp and hum and thuyen and vehicleSeat and mainPart and targetPart then
                local distToSeat = (hrp.Position - vehicleSeat.Position).Magnitude
                local isSeated = (hum.Sit and hum.SeatPart == vehicleSeat)

                if not isSeated and distToSeat > 20 then
                    isFlyingSafe = true

                    for _, v in ipairs(thuyen:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                            pcall(function()
                                v.CanTouch = false
                                v.CanQuery = false
                            end)
                        end
                    end

                    local bv = vehicleSeat:FindFirstChild("SafeFlyBV")
                    local bg = vehicleSeat:FindFirstChild("SafeFlyBG")

                    if not bv or not bg or bv.Parent ~= vehicleSeat or bg.Parent ~= vehicleSeat then
                        if bv then bv:Destroy() end
                        if bg then bg:Destroy() end

                        for _, v in pairs(vehicleSeat:GetChildren()) do
                            if (v:IsA("BodyVelocity") and v.Name ~= "SafeFlyBV") or (v:IsA("BodyPosition") and v.Name ~= "SafeFlyBP") or (v:IsA("BodyGyro") and v.Name ~= "SafeFlyBG") then
                                v:Destroy()
                            end
                        end

                        bv = Instance.new("BodyVelocity")
                        bv.Name = "SafeFlyBV"
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.P = 9e9
                        bv.Velocity = Vector3.zero
                        bv.Parent = vehicleSeat

                        bg = Instance.new("BodyGyro")
                        bg.Name = "SafeFlyBG"
                        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                        bg.P = 9e9
                        bg.D = 500
                        bg.Parent = vehicleSeat
                    end

                    dodgeAngle = dodgeAngle + (math.rad(_G.TocDoTween or 170) * 0.015)
                    if dodgeAngle >= math.pi * 2 then dodgeAngle = 0 end

                    local targetCenter = targetPart.Position
                    local rad = tonumber(_G.SafeRadius) or 100
                    local targetY = tonumber(_G.SafeHeightY) or 200

                    local orbitX = targetCenter.X + (math.cos(dodgeAngle) * rad)
                    local orbitZ = targetCenter.Z + (math.sin(dodgeAngle) * rad)
                    local orbitPos = Vector3.new(orbitX, targetY, orbitZ)

                    local currentBoatPos = mainPart.Position
                    local speed = tonumber(_G.TocDoTween) or 170

                    if currentBoatPos.Y < targetY - 10 then
                        bv.Velocity = Vector3.new(0, speed, 0)
                        local flatAngle = CFrame.Angles(0, math.atan2(vehicleSeat.CFrame.LookVector.X, vehicleSeat.CFrame.LookVector.Z), 0)
                        bg.CFrame = CFrame.new(currentBoatPos) * flatAngle
                    else
                        local toTargetVec = orbitPos - currentBoatPos
                        local distToOrbit = toTargetVec.Magnitude
                        local moveDir = distToOrbit > 0 and toTargetVec.Unit or Vector3.zero
                        
                        bv.Velocity = moveDir * speed
                        if Vector3.new(moveDir.X, 0, moveDir.Z).Magnitude > 0 then
                            bg.CFrame = CFrame.lookAt(currentBoatPos, currentBoatPos + Vector3.new(moveDir.X, 0, moveDir.Z))
                        end
                    end

                    mainPart.AssemblyLinearVelocity = bv.Velocity
                    mainPart.AssemblyAngularVelocity = Vector3.zero
                    
                    if vehicleSeat:IsA("BasePart") then
                        vehicleSeat.AssemblyLinearVelocity = bv.Velocity
                        vehicleSeat.AssemblyAngularVelocity = Vector3.zero
                    end
                else
                    if isFlyingSafe then
                        isFlyingSafe = false
                        local bv = vehicleSeat:FindFirstChild("SafeFlyBV")
                        local bg = vehicleSeat:FindFirstChild("SafeFlyBG")
                        if bv then bv:Destroy() end
                        if bg then bg:Destroy() end
                        
                        RestoreBoatPhysics(vehicleSeat)

                        for _, v in ipairs(thuyen:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = true
                            end
                        end
                    end
                end
            else
                if isFlyingSafe and vehicleSeat then
                    isFlyingSafe = false
                    local bv = vehicleSeat:FindFirstChild("SafeFlyBV")
                    local bg = vehicleSeat:FindFirstChild("SafeFlyBG")
                    if bv then bv:Destroy() end
                    if bg then bg:Destroy() end
                    
                    RestoreBoatPhysics(vehicleSeat)

                    if thuyen then
                        for _, v in ipairs(thuyen:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = true
                            end
                        end
                    end
                end
            end
        end)
    end
end)




local plr = game:GetService("Players").LocalPlayer

task.spawn(function()
    while task.wait(0.2) do
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
end)

