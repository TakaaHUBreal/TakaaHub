--// =========================================
--// TAKAA HUB V1 - EVADE ULTIMATE OP EDITION
--// Added Auto Farm, Carry, Token & Trap Features
--// =========================================

pcall(function()
    if getgenv().TAKAA_LOADED_V1_OP then
        getgenv().TAKAA_LOADED_V1_OP = false
        task.wait(0.2)
    end
end)
getgenv().TAKAA_LOADED_V1_OP = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- Clean previous instances smoothly
pcall(function()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui and pGui:FindFirstChild("TAKAA_HUB_V1") then
        pGui.TAKAA_HUB_V1:Destroy()
    end
    if Workspace:FindFirstChild("TAKAA_ESP_SYSTEM_V1") then
        Workspace.TAKAA_ESP_SYSTEM_V1:Destroy()
    end
    if Workspace:FindFirstChild("TAKAA_STABLE_5K_BASE") then
        Workspace.TAKAA_STABLE_5K_BASE:Destroy()
    end
end)

-- Global Flags Configuration
getgenv().AutoFarmSky = false
getgenv().AutoCarry = false
getgenv().AutoServiceToken = false
getgenv().AutoTrapLastSec = false
getgenv().AutoRespawnMe = true
getgenv().AutoCollect = true
getgenv().AutoWhistle = true
getgenv().AntiAfkActive = true
getgenv().EspPlayer = true
getgenv().NextbotEsp = true
getgenv().AntiNextbot = false
getgenv().CustomSpeed = false

-- ESP Folder Creation
local EspFolder = Instance.new("Folder")
EspFolder.Name = "TAKAA_ESP_SYSTEM_V1"
EspFolder.Parent = Workspace

-- Notification Helper
local function SendNotification(title, text, isRed)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title;
            Text = text;
            Duration = 3;
        })
        local sound = Instance.new("Sound")
        sound.SoundId = isRed and "rbxassetid://9114221327" or "rbxassetid://4590657391"
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    end)
end

-- Anti-AFK Kick Bypass
local function SetupAntiAFK()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if getgenv().AntiAfkActive then
                vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end)
end
SetupAntiAFK()

-- Helper Functions
local function IsDowned(plr)
    if not plr or not plr.Character then return false end
    local char = plr.Character
    if char:GetAttribute("Downed") == true or char:GetAttribute("Incapacitated") == true then return true end
    if char:FindFirstChild("RevivePrompt") or char:FindFirstChild("Revive") then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health <= 0 then return true end
    return false
end

-- Shared Sky Part Reference (កម្ពស់ 5,000)
local skyPart = nil

-- Auto Farm (Sky Base Positioning)
task.spawn(function()
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoFarmSky then
                if not skyPart or not skyPart.Parent then
                    skyPart = Instance.new("Part")
                    skyPart.Name = "TAKAA_STABLE_5K_BASE"
                    skyPart.Size = Vector3.new(120, 1, 120)
                    skyPart.Position = Vector3.new(0, 5000, 0)
                    skyPart.Anchored = true
                    skyPart.Transparency = 0.3
                    skyPart.BrickColor = BrickColor.new("Bright red")
                    skyPart.Parent = Workspace
                end
                
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and not IsDowned(LocalPlayer) then
                    if math.abs(root.Position.Y - skyPart.Position.Y) > 30 or (Vector2.new(root.Position.X, root.Position.Z) - Vector2.new(skyPart.Position.X, skyPart.Position.Z)).Magnitude > 40 then
                        root.CFrame = skyPart.CFrame + Vector3.new(0, 4, 0)
                    end
                end
            else
                if not getgenv().AutoCarry and skyPart then
                    skyPart:Destroy()
                    skyPart = nil
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- Auto Carry
task.spawn(function()
    local trackedDown = {}
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoCarry then
                if not skyPart or not skyPart.Parent then
                    skyPart = Instance.new("Part")
                    skyPart.Name = "TAKAA_STABLE_5K_BASE"
                    skyPart.Size = Vector3.new(120, 1, 120)
                    skyPart.Position = Vector3.new(0, 5000, 0)
                    skyPart.Anchored = true
                    skyPart.Transparency = 0.3
                    skyPart.BrickColor = BrickColor.new("Bright red")
                    skyPart.Parent = Workspace
                end

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local isDown = IsDowned(p)
                        local nameTag = p.DisplayName .. " (@" .. p.Name .. ")"
                        
                        if isDown and not trackedDown[p] then
                            trackedDown[p] = true
                            SendNotification("🔴 PLAYER DOWN", nameTag .. " is down! Auto Carrying...", true)
                        elseif not isDown then
                            trackedDown[p] = nil
                        end

                        if isDown and skyPart then
                            local targetRoot = p.Character:FindFirstChild("HumanoidRootPart")
                            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            
                            if targetRoot and myRoot then
                                targetRoot.CFrame = skyPart.CFrame + Vector3.new(math.random(-2,2), 4, math.random(-2,2))
                                
                                local start = tick()
                                while getgenv().AutoCarry and IsDowned(p) and (tick() - start) < 5 do
                                    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)

                                    for _, item in ipairs(p.Character:GetDescendants()) do
                                        if item:IsA("ProximityPrompt") then
                                            item.HoldDuration = 0
                                            if fireproximityprompt then fireproximityprompt(item) end
                                        end
                                    end

                                    local reviveEvent = ReplicatedStorage:FindFirstChild("Revive", true)
                                    if reviveEvent and reviveEvent:IsA("RemoteEvent") then
                                        reviveEvent:FireServer(p.Name, false)
                                    end
                                    task.wait(0.1)
                                end
                                
                                if not IsDowned(p) then
                                    SendNotification("TAKAA HUB V1", "Successfully Carried & Revived ✅ (" .. p.DisplayName .. ")", false)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.3)
    end
end)

-- Auto Service Player Token
task.spawn(function()
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoServiceToken then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("token") or obj.Parent.Name:lower():find("token") or obj.ActionText:lower():find("token")) then
                        obj.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(obj) end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- Auto Trap Player Change Last 1s
task.spawn(function()
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoTrapLastSec then
                local trapEvent = ReplicatedStorage:FindFirstChild("UseAbility", true) or ReplicatedStorage:FindFirstChild("PlaceTrap", true)
                if trapEvent and trapEvent:IsA("RemoteEvent") then
                    trapEvent:FireServer()
                end
            end
        end)
        task.wait(1)
    end
end)

-- Auto Respawn ME
task.spawn(function()
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoRespawnMe and IsDowned(LocalPlayer) then
                local spawnEvent = ReplicatedStorage:FindFirstChild("Respawn", true) or ReplicatedStorage:FindFirstChild("SpawnCharacter", true)
                if spawnEvent and spawnEvent:IsA("RemoteEvent") then
                    spawnEvent:FireServer()
                end
                task.wait(1)
            end
        end)
        task.wait(0.5)
    end
end)

-- Auto Collect & Auto Whistle
task.spawn(function()
    while getgenv().TAKAA_LOADED_V1_OP do
        pcall(function()
            if getgenv().AutoCollect then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") and (obj.Parent.Name:lower():find("coin") or obj.Parent.Name:lower():find("pickup") or obj.Name:lower():find("collect")) then
                        obj.HoldDuration = 0
                        if fireproximityprompt then fireproximityprompt(obj) end
                    end
                end
            end
            
            if getgenv().AutoWhistle then
                local whistleEvent = ReplicatedStorage:FindFirstChild("Whistle", true) or ReplicatedStorage:FindFirstChild("UseWhistle", true)
                if whistleEvent and whistleEvent:IsA("RemoteEvent") then
                    whistleEvent:FireServer()
                end
            end
        end)
        task.wait(1)
    end
end)

-- Custom Speed & Anti-Nextbot Logic
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            if getgenv().CustomSpeed then
                hum.WalkSpeed = 305
            end
        end

        if getgenv().AntiNextbot and char and char:FindFirstChild("HumanoidRootPart") then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
                    local dist = (obj.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist < 25 then
                        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0, 100, 0)
                    end
                end
            end
        end
    end)
end)

-- ESP & Nextbot ESP Track System
local downedTimers = {}
RunService.RenderStepped:Connect(function()
    if not getgenv().TAKAA_LOADED_V1_OP then return end
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local char = p.Character
                local hlName = "ESP_HL_" .. p.Name
                local tagName = "ESP_TAG_" .. p.Name
                local hl = EspFolder:FindFirstChild(hlName)
                local tag = EspFolder:FindFirstChild(tagName)

                if getgenv().EspPlayer and char and char:FindFirstChild("HumanoidRootPart") then
                    local isDown = IsDowned(p)
                    
                    if isDown then
                        if not downedTimers[p] then downedTimers[p] = tick() end
                    else
                        downedTimers[p] = nil
                    end

                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = hlName
                        hl.Parent = EspFolder
                    end
                    hl.Adornee = char
                    hl.FillColor = isDown and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(0, 255, 120)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.25

                    if not tag then
                        tag = Instance.new("BillboardGui")
                        tag.Name = tagName
                        tag.Size = UDim2.new(0, 220, 0, 40)
                        tag.AlwaysOnTop = true
                        tag.StudsOffset = Vector3.new(0, 3.8, 0)

                        local lbl = Instance.new("TextLabel")
                        lbl.Name = "Info"
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 12
                        lbl.TextStrokeTransparency = 0
                        lbl.Parent = tag
                        tag.Parent = EspFolder
                    end

                    local targetPart = char:FindFirstChild("Head") or char.HumanoidRootPart
                    tag.Adornee = targetPart
                    local myChar = LocalPlayer.Character
                    local dist = (myChar and myChar:FindFirstChild("HumanoidRootPart")) and math.floor((myChar.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) or 0
                    
                    local lbl = tag:FindFirstChild("Info")
                    if lbl then
                        if isDown and downedTimers[p] then
                            local dieTime = math.floor(tick() - downedTimers[p])
                            lbl.Text = p.DisplayName .. " [" .. dist .. "m]\n⚠️ DOWNED [Time: " .. dieTime .. "s]"
                            lbl.TextColor3 = Color3.fromRGB(255, 40, 40)
                        else
                            lbl.Text = p.DisplayName .. " [" .. dist .. "m]"
                            lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
                        end
                    end
                else
                    if hl then hl:Destroy() end
                    if tag then tag:Destroy() end
                    downedTimers[p] = nil
                end
            end
        end

        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:FindFirstChild("HumanoidRootPart") and not Players:GetPlayerFromCharacter(obj) then
                local nbHlName = "NB_HL_" .. obj.Name
                local nbHl = EspFolder:FindFirstChild(nbHlName)
                if getgenv().NextbotEsp then
                    if not nbHl then
                        nbHl = Instance.new("Highlight")
                        nbHl.Name = nbHlName
                        nbHl.FillColor = Color3.fromRGB(255, 0, 0)
                        nbHl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        nbHl.Parent = EspFolder
                    end
                    nbHl.Adornee = obj
                else
                    if nbHl then nbHl:Destroy() end
                end
            end
        end
    end)
end)

-- User Interface V1 (GUI Design)
local Gui = Instance.new("ScreenGui")
Gui.Name = "TAKAA_HUB_V1"
Gui.ResetOnSpawn = false
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 440, 0, 290)
Main.Position = UDim2.new(0.5, -220, 0.5, -145)
Main.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(230, 35, 45)
Stroke.Thickness = 1.5

local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 32)
Topbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Topbar.BorderSizePixel = 0
Topbar.Parent = Main
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -120, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ TAKAA HUB V1 - OP EVADE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Online Server Time Label ⏰
local TimeLbl = Instance.new("TextLabel")
TimeLbl.Size = UDim2.new(0, 90, 1, 0)
TimeLbl.Position = UDim2.new(1, -122, 0, 0)
TimeLbl.BackgroundTransparency = 1
TimeLbl.TextColor3 = Color3.fromRGB(40, 220, 80)
TimeLbl.Font = Enum.Font.GothamBold
TimeLbl.TextSize = 9
TimeLbl.TextXAlignment = Enum.TextXAlignment.Right
TimeLbl.Parent = Topbar

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local t = os.date("*t")
            TimeLbl.Text = string.format("⏰ %02d:%02d:%02d", t.hour, t.min, t.sec)
        end)
    end
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -27, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = Topbar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 90, 0, 32)
OpenBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
OpenBtn.Text = "TAKAA V1"
OpenBtn.TextColor3 = Color3.fromRGB(255, 40, 40)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 11
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.ZIndex = 100
OpenBtn.Parent = Gui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)
local OpenStroke = Instance.new("UIStroke", OpenBtn)
OpenStroke.Color = Color3.fromRGB(230, 35, 45)
OpenStroke.Thickness = 1.5

CloseBtn.Activated:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.Activated:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- Sidebar & Big Avatar Profile Setup
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 135, 1, -32)
Sidebar.Position = UDim2.new(0, 0, 0, 32)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local AvatarCard = Instance.new("Frame")
AvatarCard.Size = UDim2.new(1, -8, 0, 72)
AvatarCard.Position = UDim2.new(0, 4, 0, 4)
AvatarCard.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
AvatarCard.Parent = Sidebar
Instance.new("UICorner", AvatarCard).CornerRadius = UDim.new(0, 6)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 56, 0, 56)
AvatarImg.Position = UDim2.new(0, 6, 0.5, -28)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.BorderSizePixel = 0
AvatarImg.Parent = AvatarCard
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(0, 6)

task.spawn(function()
    local success, thumbUrl = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    end)
    if success and thumbUrl then
        AvatarImg.Image = thumbUrl
    end
end)

local AvatarNameLbl = Instance.new("TextLabel")
AvatarNameLbl.Size = UDim2.new(1, -66, 1, 0)
AvatarNameLbl.Position = UDim2.new(0, 66, 0, 0)
AvatarNameLbl.BackgroundTransparency = 1
AvatarNameLbl.Text = LocalPlayer.DisplayName .. "\n@" .. LocalPlayer.Name
AvatarNameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
AvatarNameLbl.Font = Enum.Font.GothamBold
AvatarNameLbl.TextSize = 8
AvatarNameLbl.TextWrapped = true
AvatarNameLbl.TextXAlignment = Enum.TextXAlignment.Left
AvatarNameLbl.TextYAlignment = Enum.TextYAlignment.Center
AvatarNameLbl.Parent = AvatarCard

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 4)
SidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarList.Parent = Sidebar

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -143, 1, -38)
TabContainer.Position = UDim2.new(0, 139, 0, 35)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local Tabs = {}

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.CanvasSize = UDim2.new(0, 0, 0, 320)
    frame.ScrollBarThickness = 2
    frame.ScrollBarImageColor3 = Color3.fromRGB(230, 35, 45)
    frame.Parent = TabContainer

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 5)
    list.Parent = frame

    btn.Activated:Connect(function()
        for _, t in pairs(Tabs) do
            t.btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.frame.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        frame.Visible = true
    end)

    Tabs[name] = {btn = btn, frame = frame}
    return frame
end

local MainTab = CreateTab("Main")
local CombatTab = CreateTab("Combat / OP")
local UtilityTab = CreateTab("Utility")
local VisualsTab = CreateTab("Visuals Pro")

Tabs["Main"].btn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
Tabs["Main"].btn.TextColor3 = Color3.fromRGB(255, 255, 255)
Tabs["Main"].frame.Visible = true

local function CreateToggle(parent, text, flag)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -5, 0, 28)
    f.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 4)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 32, 0, 16)
    sw.Position = UDim2.new(1, -38, 0.5, -8)
    sw.BackgroundColor3 = getgenv()[flag] and Color3.fromRGB(40, 220, 80) or Color3.fromRGB(220, 40, 40)
    sw.Parent = f
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = getgenv()[flag] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = sw
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local click = Instance.new("TextButton")
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.Parent = f

    click.Activated:Connect(function()
        getgenv()[flag] = not getgenv()[flag]
        sw.BackgroundColor3 = getgenv()[flag] and Color3.fromRGB(40, 220, 80) or Color3.fromRGB(220, 40, 40)
        dot.Position = getgenv()[flag] and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    end)
end

local function CreateBtn(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(230, 35, 45)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.Activated:Connect(cb)
end

-- Adding Controls to Tabs
CreateToggle(MainTab, "Auto Farm 🌾", "AutoFarmSky")
CreateToggle(MainTab, "Auto Carry 🏆", "AutoCarry")
CreateToggle(MainTab, "Auto Service Token 🪙", "AutoServiceToken")
CreateToggle(MainTab, "Auto Trap Last 1s 🪤", "AutoTrapLastSec")
CreateToggle(MainTab, "Auto Respawn ME 🔄", "AutoRespawnMe")
CreateBtn(MainTab, "Copy Discord Link ✔️💬", function()
    if setclipboard then setclipboard("https://discord.gg/DgdtUSTS") end
    SendNotification("TAKAA HUB V1", "Copy Discord Link Done ✔️", false)
end)

-- Combat / OP Tab
CreateToggle(CombatTab, "Anti-Nextbot 🛡️", "AntiNextbot")
CreateToggle(CombatTab, "Enter Speed (Speed 305) ⚡", "CustomSpeed")

-- Utility Tab
CreateToggle(UtilityTab, "Auto Collect Items/Coins 💰", "AutoCollect")
CreateToggle(UtilityTab, "Auto Whistle (Alert) 📢", "AutoWhistle")

-- Visuals Pro Tab
CreateToggle(VisualsTab, "Players ESP & Die Timer 👤", "EspPlayer")
CreateToggle(VisualsTab, "Nextbot ESP (Red Highlight) 👹", "NextbotEsp")

-- Draggable UI Support
local function MakeDraggable(dragTarget, moveTarget)
    local Dragging, DragStart, StartPos
    dragTarget.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = moveTarget.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - DragStart
            moveTarget.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
end

MakeDraggable(Topbar, Main)
MakeDraggable(OpenBtn, OpenBtn)
