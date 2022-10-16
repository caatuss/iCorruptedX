loadstring(game:HttpGet('https://raw.githubusercontent.com/iCorruptedX/iCorruptedX/main/PP.lua'))()

local Players = game:GetService("Players")
local Character = Players.LocalPlayer.Character
local function getClosestObject(folder)
    local distance, part = math.huge, nil
    local mainPart
    local Character = Players.LocalPlayer.Character
    for i,v in pairs(folder:GetChildren()) do
        if Character:FindFirstChild("HumanoidRootPart") then
            local HRPPosition = Character:FindFirstChild("HumanoidRootPart").Position

            for i2,v2 in pairs(v:GetChildren()) do
                if v2:IsA("BasePart") then
                    mainPart = v2
                    break
                end
            end
    
            if mainPart and not mainPart.Parent:FindFirstChild("Humanoid") and mainPart.Parent:FindFirstChild("Health") then
                local realDistance = math.abs((HRPPosition - mainPart.Position).Magnitude)
    
                if realDistance < distance then
                    distance = realDistance
                    part = mainPart
                end
            end
        end
    end
    return part
end
local function getClosestPickups(folder)
    local Character = Players.LocalPlayer.Character
    local pickups = {}
    for i,v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Pickup") and v:IsA("BasePart") and table.find(pickups,v) == nil and Character:FindFirstChild("HumanoidRootPart") then
            if (Character.HumanoidRootPart.Position - v.Position).Magnitude <= 30 then
                table.insert(pickups, v)
            end
        end
    end
    return pickups
end
local function getClosest()
    local hrp = Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position
    local closest_distance = math.huge
    local closestperson

    for i,v in pairs(game.Players:GetPlayers()) do
        if v.Character ~= nil and v ~= Players.LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid").Health > 0 then
            local plr_pos = v.Character.HumanoidRootPart.Position
            local plr_distance = (hrp - plr_pos).Magnitude
    
            if plr_distance < closest_distance then
                closest_distance = plr_distance
                closestperson = v
            end
        end
    end

    return closestperson
end
local plrs = game:GetService("Players")
local rpls = game:GetService("ReplicatedStorage")
local lplr = plrs.LocalPlayer
local humanoid = lplr.Character:WaitForChild("Humanoid")

----------------------------------------------------------------------------------------------------------------------------------
local LegitTab = library:AddTab("Ooga Booga");
local LegitColunm1 = LegitTab:AddColumn();
local LegitColunm2 = LegitTab:AddColumn();

local LegitMain = LegitColunm1:AddSection("Main")
local LegitMain2 = LegitColunm2:AddSection("Visual")

LegitMain:AddDivider("Hit Boxes");
LegitMain:AddToggle({text = "HeadHit Box", flag = "HitboxEnabled", callback = function(enabled)
    if enabled then
        getgenv().headSize = 5
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        getgenv().headLoop = game:GetService("RunService").RenderStepped:Connect(function()
            for i, v in pairs(plrs:getPlayers()) do
                if v.Name ~= lplr.Name then
                    pcall(function()
                        v.Character.Head.Size = Vector3.new(headSize, headSize, headSize)
                    end)
                end
            end
        end)
    else
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        headLoop:Disconnect()
        for i, v in pairs(plrs:GetPlayers()) do
            if v.Name ~= lplr.Name then
                pcall(function()
                    v.Character.Head.Size = Vector3.new(2, 1, 1)
                end)
            end
        end
    end
end})
LegitMain:AddSlider({text = "Head Hit Box", flag = "Head Hit Box", min = 0, max = 50, value = 10, suffix = "%", callback = function(size)
    getgenv().headSize = size
end})

LegitMain:AddToggle({text = "Torso Box", flag = "HitboxEnabled", callback = function(enabled)
    if enabled then
        getgenv().torsoSize = 15
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        getgenv().torsoLoop = game:GetService("RunService").RenderStepped:Connect(function()
            for i, v in pairs(plrs:GetPlayers()) do
                if v.Name ~= lplr.Name then
                    pcall(function()
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really blue")
                        v.Character.HumanoidRootPart.CanCollide = false
                        v.Character.HumanoidRootPart.Material = "Neon"
                        v.Character.HumanoidRootPart.Size = Vector3.new(torsoSize, torsoSize, torsoSize)
                        v.Character.HumanoidRootPart.Transparency = 0.7
                    end)
                end
            end
        end)
    else
        local plrs = game:GetService("Players")
        local lplr = plrs.LocalPlayer
        torsoLoop:Disconnect()
        for i, v in pairs(plrs:GetPlayers()) do
            if v.Name ~= lplr.Name then
                pcall(function()
                    v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    v.Character.HumanoidRootPart.Transparency = 1
                end)
            end
        end
    end
end})
LegitMain:AddSlider({text = "Torso Hit Box", flag = "Torso Hit Box", min = 0, max = 50, value = 10, suffix = "%", callback = function(size)
    getgenv().torsoSize = size
end})

LegitMain:AddButton({text = "Remove Armor", callback = function(enabled)
    for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
        if v.ClassName == "Accessory" then
            v:FindFirstChild("Handle"):Destroy()
        end
    end
    
    game:GetService("Players").LocalPlayer.Character.ChildAdded:Connect(function(v)
        if v.ClassName == "Accessory" then
            v:FindFirstChild("Handle"):Destroy()
        end
    end)
end})

LegitMain:AddDivider("Automation");
LegitMain:AddToggle({text = "Mine Aura", callback = function(State)
    if State then
        if library.flags["Mine Aura"] then
            library:AddConnection(runService.RenderStepped, "Mine Aura", function()
                wait(0.5)
                if Character:FindFirstChild("HumanoidRootPart") then
                    local closestPart = getClosestObject(workspace)
                    local hrp = Character:FindFirstChild("HumanoidRootPart").Position
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    if (hrp - closestPart.Position).Magnitude <= 40 then
                        ReplicatedStorage.Events.SwingTool:FireServer(ReplicatedStorage.RelativeTime.Value, {
                            [1] = closestPart
                        })
                    end
                end          
            end) 
        end
    else
        library.connections["Mine Aura"]:Disconnect()
    end
end})

LegitMain:AddToggle({text = "Auto Pickup",callback = function(State)
    if State then
        if library.flags["Auto Pickup"] then
            library:AddConnection(runService.RenderStepped, "Auto Pickup", function()
                for i,v in pairs(getClosestPickups(workspace)) do
                    game:GetService("ReplicatedStorage").Events.Pickup:FireServer(v)
                end
            end)
        end
    else
        library.connections["Auto Pickup"]:Disconnect()
    end
end})

LegitMain:AddDivider("Auto Heal");
LegitMain:AddToggle({text = "Auto Heal", callback = function(State)
    if State then
        if library.flags["Auto Heal"] then
            library:AddConnection(runService.RenderStepped, "Auto Heal", function()
                if humanoid.Health < library.flags["Minimum Health"] then
                    rpls.Events.UseBagItem:FireServer(library.flags["Healing Item"])
                end
            end)
        else
            library.connections["Auto Heal"]:Disconnect()
        end
    end
end}):AddList({text = "Healing Item", values = {"Bloodfruit", "Sunfruit", "Bluefruit", "Berry"}, value = "Bloodfruit"})
LegitMain:AddSlider({text = "Minimum Health", min = 30, max = 100, value = 90})






LegitMain2:AddDivider("Visual");
LegitMain2:AddButton({text = "Unnamed ESP", callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end});

LegitMain2:AddButton({text = "Full Bright", callback = function(enabled)
    local lgt = game:GetService("Lighting")
    pcall(function()
        lgt.Changed:Connect(function()
            lgt.ClockTime = 12
            lgt.FogEnd = 786543
            lgt.GlobalShadows = false
            lgt.Ambient = Color3.fromRGB(178, 178, 178)
        end)
    end)
end})

LegitMain2:AddButton({text = "Remove Grass", callback = function(enabled)
    if getgenv().grassdisabled == nil then
        getgenv().grassdisabled = true
    elseif grassdisabled then
        getgenv().grassdisabled = false
    else
        getgenv().grassdisabled = true
    end
    
    local terrain = game:GetService("Workspace").Terrain
    local grasscheck  = gethiddenproperty(terrain, "Decoration")
    local plrgui = game:GetService("Players").LocalPlayer.PlayerGui
    
    local function notification(message, seconds)
        pcall(function()
            local properties = plrgui.StarterScripts.ItemControl.MessageFrame:Clone()
            properties.Name = os.time()
            properties.MessageText.Text = message
            properties.Parent = plrgui:WaitForChild("Messages").MessagesFrame
            game.Debris:AddItem(properties, seconds)
        end)
    end
    
    if grassdisabled then
        if grasscheck then
            notification("Grass has been removed! (May lag for a few seconds)", 3)
            sethiddenproperty(terrain, "Decoration", false)
        end
    else
        if not grasscheck then
            notification("Grass has been added! (May lag for a few seconds)", 3)
            sethiddenproperty(terrain, "Decoration", true)
        end
    end    
end})





-- [Init] --------------------------------------------------------------------------------------------------------------------------------------------------------------------
library:Init();
library:selectTab(library.tabs[1]);


