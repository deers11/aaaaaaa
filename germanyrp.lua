local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local highlights = {}
local nameTags = {}
local wallhackEnabled = false
local speedEnabled = false
local defaultWalkSpeed = 16
local defaultJumpPower = 50
local currentSpeed = 16
local isDragging = false
local isDraggingMenu = false
local dragStart = nil
local frameStartPos = nil
local selectedVehicle = nil
local vehicleTeleportEnabled = false
local contextMenu = nil
local selectedVehicleForMenu = nil
local currentTab = "Player"
local speedBarOpen = false
local speedBarTween = nil
local speedUpdateConnection = nil --для отслеживания соединения

screenGui.Name = "Test"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false 

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 500, 0, 550) 
frame.Position = UDim2.new(0.5, -250, 0.5, -275) 
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45) 
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui

local titleBar = Instance.new("TextButton")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Text = ""
titleBar.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Name = "TitleLabel"
textLabel.Size = UDim2.new(0, 200, 0, 30)
textLabel.Position = UDim2.new(0, 10, 0, 5)
textLabel.BackgroundTransparency = 1
textLabel.Text = "ANL CHEAT MENU"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 20
textLabel.Font = Enum.Font.Legacy
textLabel.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0, 460, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.Legacy
closeButton.Parent = frame

local playerTabButton = Instance.new("TextButton")
playerTabButton.Name = "PlayerTabButton"
playerTabButton.Size = UDim2.new(0, 75, 0, 15)
playerTabButton.Position = UDim2.new(0, 10, 0, 10)
playerTabButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
playerTabButton.Text = "PLAYER"
playerTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTabButton.Font = Enum.Font.Legacy
playerTabButton.TextSize = 10
playerTabButton.Parent = frame

local mapTabButton = Instance.new("TextButton")
mapTabButton.Name = "MapTabButton"
mapTabButton.Size = UDim2.new(0, 75, 0, 15)
mapTabButton.Position = UDim2.new(0, 100, 0, 10)
mapTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mapTabButton.Text = "MAP"
mapTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mapTabButton.Font = Enum.Font.Legacy
mapTabButton.TextSize = 10
mapTabButton.Parent = frame

local vehicleTabButton = Instance.new("TextButton")
vehicleTabButton.Name = "VehicleTabButton"
vehicleTabButton.Size = UDim2.new(0, 75, 0, 15)
vehicleTabButton.Position = UDim2.new(0, 190, 0, 10)
vehicleTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
vehicleTabButton.Text = "VEHICLE"
vehicleTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
vehicleTabButton.Font = Enum.Font.Legacy
vehicleTabButton.TextSize = 10
vehicleTabButton.Parent = frame

local playerContent = Instance.new("Frame")
playerContent.Name = "PlayerContent"
playerContent.Size = UDim2.new(1, -20, 0, 450)
playerContent.Position = UDim2.new(0, 10, 0, 90)
playerContent.BackgroundTransparency = 1
playerContent.Parent = frame

local mapContent = Instance.new("Frame")
mapContent.Name = "MapContent"
mapContent.Size = UDim2.new(1, -20, 0, 450)
mapContent.Position = UDim2.new(0, 10, 0, 90)
mapContent.BackgroundTransparency = 1
mapContent.Visible = false
mapContent.Parent = frame

local vehicleContent = Instance.new("Frame")
vehicleContent.Name = "VehicleContent"
vehicleContent.Size = UDim2.new(1, -20, 0, 450)
vehicleContent.Position = UDim2.new(0, 10, 0, 90)
vehicleContent.BackgroundTransparency = 1
vehicleContent.Visible = false
vehicleContent.Parent = frame

local wallhackButton = Instance.new("TextButton")
wallhackButton.Name = "WallhackButton"
wallhackButton.Size = UDim2.new(0, 100, 0, 20)
wallhackButton.Position = UDim2.new(0, 0, 0, 0)
wallhackButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
wallhackButton.Text = "ESP"
wallhackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallhackButton.Font = Enum.Font.Legacy
wallhackButton.TextSize = 10
wallhackButton.Parent = playerContent

local wallhackCheckbox = Instance.new("TextLabel")
wallhackCheckbox.Name = "WallhackCheckbox"
wallhackCheckbox.Size = UDim2.new(0, 20, 0, 20)
wallhackCheckbox.Position = UDim2.new(0, 80, 0, 0)
wallhackCheckbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
wallhackCheckbox.Text = ""
wallhackCheckbox.TextColor3 = Color3.fromRGB(0, 0, 0)
wallhackCheckbox.Font = Enum.Font.Legacy
wallhackCheckbox.TextSize = 16
wallhackCheckbox.Parent = wallhackButton

local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0, 100, 0, 20)
speedButton.Position = UDim2.new(0, 0, 0, 30)
speedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
speedButton.Text = "WalkSpeed"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Font = Enum.Font.Legacy
speedButton.TextSize = 10
speedButton.Parent = playerContent

local speedCheckbox = Instance.new("TextLabel")
speedCheckbox.Name = "SpeedCheckbox"
speedCheckbox.Size = UDim2.new(0, 20, 0, 20)
speedCheckbox.Position = UDim2.new(0, 80, 0, 0)
speedCheckbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedCheckbox.Text = ""
speedCheckbox.TextColor3 = Color3.fromRGB(0, 0, 0)
speedCheckbox.Font = Enum.Font.Legacy
speedCheckbox.TextSize = 16
speedCheckbox.Parent = speedButton

local speedBarContainer = Instance.new("Frame")
speedBarContainer.Name = "SpeedBarContainer"
speedBarContainer.Size = UDim2.new(0, 150, 0, 0)
speedBarContainer.Position = UDim2.new(0, 0, 0, 55)
speedBarContainer.BackgroundTransparency = 1
speedBarContainer.BorderSizePixel = 0
speedBarContainer.ClipsDescendants = true
speedBarContainer.Parent = playerContent

local speedBarBg = Instance.new("Frame")
speedBarBg.Name = "SpeedBarBg"
speedBarBg.Size = UDim2.new(0, 150, 0, 20)
speedBarBg.Position = UDim2.new(0, 0, 0, 0)
speedBarBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
speedBarBg.BackgroundTransparency = 0.3
speedBarBg.BorderSizePixel = 0
speedBarBg.Parent = speedBarContainer

local speedSliderBg = Instance.new("Frame")
speedSliderBg.Name = "SpeedSliderBg"
speedSliderBg.Size = UDim2.new(0, 150, 0, 20)
speedSliderBg.Position = UDim2.new(0, 0, 0, 0)
speedSliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedSliderBg.BackgroundTransparency = 0.9
speedSliderBg.BorderSizePixel = 0
speedSliderBg.Parent = speedBarBg

local speedBar = Instance.new("Frame")
speedBar.Name = "SpeedBar"
speedBar.Size = UDim2.new(0.16, 0, 1, 0)
speedBar.Position = UDim2.new(0, 0, 0, 0)
speedBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
speedBar.BackgroundTransparency = 0.2
speedBar.BorderSizePixel = 0
speedBar.Active = true
speedBar.Parent = speedSliderBg

local speedValueLabel = Instance.new("TextLabel")
speedValueLabel.Name = "SpeedValueLabel"
speedValueLabel.Size = UDim2.new(1, 0, 1, 0)
speedValueLabel.Position = UDim2.new(0, 0, 0, 0)
speedValueLabel.BackgroundTransparency = 1
speedValueLabel.Text = "16"
speedValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedValueLabel.TextSize = 12
speedValueLabel.Font = Enum.Font.Legacy
speedValueLabel.Parent = speedSliderBg

local removeBarriersButton = Instance.new("TextButton")
removeBarriersButton.Name = "RemoveBarriersButton"
removeBarriersButton.Size = UDim2.new(0, 200, 0, 40)
removeBarriersButton.Position = UDim2.new(0, 20, 0, 20)
removeBarriersButton.BackgroundColor3 = Color3.fromRGB(200, 50, 200)
removeBarriersButton.Text = "УДАЛИТЬ БАРЬЕРЫ"
removeBarriersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
removeBarriersButton.Font = Enum.Font.Legacy
removeBarriersButton.TextSize = 12
removeBarriersButton.Parent = mapContent

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 100, 0, 20)
teleportButton.Position = UDim2.new(0, 0, 0, -40)
teleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teleportButton.Text = "TP TO Bar"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.Legacy
teleportButton.TextSize = 10
teleportButton.Parent = mapContent



local secondTeleportButton = Instance.new("TextButton")
secondTeleportButton.Name = "SecondTeleportButton"
secondTeleportButton.Size = UDim2.new(0, 100, 0, 20)
secondTeleportButton.Position = UDim2.new(0, 0, 0, -10)
secondTeleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
secondTeleportButton.Text = "Военный-КПП "
secondTeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
secondTeleportButton.Font = Enum.Font.Legacy
secondTeleportButton.TextSize = 10
secondTeleportButton.Parent = mapContent

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 100, 0, 20)
teleportButton.Position = UDim2.new(0, 0, 0, -40)
teleportButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
teleportButton.Text = "TP TO Bar"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.Legacy
teleportButton.TextSize = 10
teleportButton.Parent = mapContent

local vehicleList = Instance.new("ScrollingFrame")
vehicleList.Name = "VehicleList"
vehicleList.Size = UDim2.new(0, 460, 0, 400)
vehicleList.Position = UDim2.new(0, 0, 0, 20)
vehicleList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
vehicleList.BorderSizePixel = 0
vehicleList.ScrollBarThickness = 5
vehicleList.Parent = vehicleContent

local vehicleListLayout = Instance.new("UIListLayout")
vehicleListLayout.Padding = UDim.new(0, 5)
vehicleListLayout.Parent = vehicleList

local function getTeamColor(targetPlayer)
    if player.Team and targetPlayer.Team and player.Team == targetPlayer.Team then
        return Color3.fromRGB(0, 100, 255), Color3.fromRGB(100, 150, 255)
    else
        return Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100)
    end
end

local function createNameTag(targetPlayer, character)
    if not character:FindFirstChild("Head") then return end
    
    if nameTags[targetPlayer] then
        nameTags[targetPlayer]:Destroy()
    end
    
    local fillColor, outlineColor = getTeamColor(targetPlayer)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerNameTag"
    billboard.Size = UDim2.new(0, 150, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = character.Head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.Legacy
    nameLabel.Parent = billboard
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local healthLabel = Instance.new("TextLabel")
        healthLabel.Size = UDim2.new(1, 0, 0, 12)
        healthLabel.Position = UDim2.new(0, 0, 1, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.Text = "❤️ " .. math.floor(humanoid.Health)
        healthLabel.TextColor3 = outlineColor
        healthLabel.TextSize = 10
        healthLabel.Font = Enum.Font.Legacy
        healthLabel.Parent = billboard
        
        humanoid.HealthChanged:Connect(function(health)
            healthLabel.Text = "❤️ " .. math.floor(health)
        end)
    end
    
    nameTags[targetPlayer] = billboard
    
    character.DescendantRemoving:Connect(function(descendant)
        if descendant == character.Head and nameTags[targetPlayer] then
            nameTags[targetPlayer]:Destroy()
            nameTags[targetPlayer] = nil
        end
    end)
end

local function updateHighlightColor(targetPlayer)
    if highlights[targetPlayer] then
        local fillColor, outlineColor = getTeamColor(targetPlayer)
        highlights[targetPlayer].FillColor = fillColor
        highlights[targetPlayer].OutlineColor = outlineColor
    end
end

local function createHighlight(targetPlayer)
    if highlights[targetPlayer] then return end
    
    local fillColor, outlineColor = getTeamColor(targetPlayer)
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerHighlight"
    highlight.FillColor = fillColor
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = outlineColor
    highlight.OutlineTransparency = 0
    highlight.Enabled = true
    
    highlights[targetPlayer] = highlight
    
    local function applyHighlight(character)
        if character and character:FindFirstChild("HumanoidRootPart") then
            highlight.Parent = character
            updateHighlightColor(targetPlayer)
            task.wait(0.1)
            createNameTag(targetPlayer, character)
        end
    end
    
    if targetPlayer.Character then
        applyHighlight(targetPlayer.Character)
    end
    
    targetPlayer.CharacterAdded:Connect(function(character)
        applyHighlight(character)
    end)
    
    targetPlayer:GetPropertyChangedSignal("Team"):Connect(function()
        updateHighlightColor(targetPlayer)
        if targetPlayer.Character then
            createNameTag(targetPlayer, targetPlayer.Character)
        end
    end)
end

local function removeHighlight(targetPlayer)
    if highlights[targetPlayer] then
        highlights[targetPlayer]:Destroy()
        highlights[targetPlayer] = nil
    end
    
    if nameTags[targetPlayer] then
        nameTags[targetPlayer]:Destroy()
        nameTags[targetPlayer] = nil
    end
end

local function setProximityPromptDuration(vehicle)
    local driverSeat = vehicle.TVehicle:FindFirstChild("DriverSeat")
    if driverSeat then
        local proximityPrompt = driverSeat:FindFirstChildOfClass("ProximityPrompt")
        if proximityPrompt then
            proximityPrompt.HoldDuration = 0
        end
    end
end

local function teleportToVehicle(vehicle)
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local driverSeat = vehicle.TVehicle:FindFirstChild("DriverSeat")
            if driverSeat then
                humanoidRootPart.CFrame = driverSeat.CFrame + Vector3.new(0, 5, 0)
            else
                local seat = vehicle.TVehicle:FindFirstChildWhichIsA("Seat")
                if seat then
                    humanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end
end

local function teleportVehicleToPlayerTemporarily(vehicle)
    if player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local playerPosition = humanoidRootPart.CFrame
            
            local driverSeat = vehicle.TVehicle:FindFirstChild("DriverSeat")
            if driverSeat then
                local originalCFrame = driverSeat.CFrame
                driverSeat.CFrame = playerPosition
                setProximityPromptDuration(vehicle)
                
                task.wait(0.5)
                
                driverSeat.CFrame = originalCFrame
            else
                local seat = vehicle.TVehicle:FindFirstChildWhichIsA("Seat")
                if seat then
                    local originalCFrame = seat.CFrame
                    seat.CFrame = playerPosition
                    setProximityPromptDuration(vehicle)
                    
                    task.wait(0.5)
                    
                    seat.CFrame = originalCFrame
                end
            end
        end
    end
end

local function createContextMenu(vehicle)
    if contextMenu then
        contextMenu:Destroy()
    end
    
    contextMenu = Instance.new("Frame")
    contextMenu.Size = UDim2.new(0, 200, 0, 120)
    contextMenu.Position = UDim2.new(0, 250, 0, 250)
    contextMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contextMenu.BorderSizePixel = 0
    contextMenu.Parent = screenGui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Position = UDim2.new(0, 0, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = vehicle.Name
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.Legacy
    titleLabel.Parent = contextMenu
    
    local teleportToButton = Instance.new("TextButton")
    teleportToButton.Size = UDim2.new(1, -20, 0, 25)
    teleportToButton.Position = UDim2.new(0, 10, 0, 35)
    teleportToButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    teleportToButton.Text = "ТЕЛЕПОРТ К МАШИНЕ"
    teleportToButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportToButton.TextSize = 10
    teleportToButton.Font = Enum.Font.Legacy
    teleportToButton.Parent = contextMenu
    
    local teleportHereButton = Instance.new("TextButton")
    teleportHereButton.Size = UDim2.new(1, -20, 0, 25)
    teleportHereButton.Position = UDim2.new(0, 10, 0, 65)
    teleportHereButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    teleportHereButton.Text = "ТЕЛЕПОРТ К СЕБЕ (0.5с)"
    teleportHereButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportHereButton.TextSize = 10
    teleportHereButton.Font = Enum.Font.Legacy
    teleportHereButton.Parent = contextMenu
    
    local closeContextButton = Instance.new("TextButton")
    closeContextButton.Size = UDim2.new(1, -20, 0, 20)
    closeContextButton.Position = UDim2.new(0, 10, 0, 95)
    closeContextButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeContextButton.Text = "ЗАКРЫТЬ"
    closeContextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeContextButton.TextSize = 10
    closeContextButton.Font = Enum.Font.Legacy
    closeContextButton.Parent = contextMenu
    
    teleportToButton.MouseButton1Click:Connect(function()
        teleportToVehicle(vehicle)
        contextMenu:Destroy()
        contextMenu = nil
    end)
    
    teleportHereButton.MouseButton1Click:Connect(function()
        teleportVehicleToPlayerTemporarily(vehicle)
        contextMenu:Destroy()
        contextMenu = nil
    end)
    
    closeContextButton.MouseButton1Click:Connect(function()
        contextMenu:Destroy()
        contextMenu = nil
    end)
end

local function updateVehicleList()
    for _, child in ipairs(vehicleList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local vehiclesFolder = workspace:FindFirstChild("Studio")
    if vehiclesFolder then
        vehiclesFolder = vehiclesFolder:FindFirstChild("SpawnedVehicles")
    end
    
    if vehiclesFolder then
        for _, vehicle in ipairs(vehiclesFolder:GetChildren()) do
            local vehicleButton = Instance.new("TextButton")
            vehicleButton.Size = UDim2.new(1, -10, 0, 30)
            vehicleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            vehicleButton.Text = vehicle.Name
            vehicleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            vehicleButton.Font = Enum.Font.Legacy
            vehicleButton.TextSize = 12
            vehicleButton.Parent = vehicleList
            
            vehicleButton.MouseButton1Click:Connect(function()
                if selectedVehicle == vehicle and vehicleTeleportEnabled then
                    selectedVehicle = nil
                    vehicleTeleportEnabled = false
                    vehicleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                else
                    for _, btn in ipairs(vehicleList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        end
                    end
                    
                    selectedVehicle = vehicle
                    vehicleTeleportEnabled = true
                    vehicleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                end
            end)
            
            vehicleButton.MouseButton2Click:Connect(function()
                createContextMenu(vehicle)
            end)
        end
    end
end

local function switchTab(tabName)
    currentTab = tabName
    playerContent.Visible = (tabName == "Player")
    mapContent.Visible = (tabName == "Map")
    vehicleContent.Visible = (tabName == "Vehicle")
    
    playerTabButton.BackgroundColor3 = (tabName == "Player") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    mapTabButton.BackgroundColor3 = (tabName == "Map") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    vehicleTabButton.BackgroundColor3 = (tabName == "Vehicle") and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    
    if tabName == "Vehicle" then
        updateVehicleList()
    end
end

playerTabButton.MouseButton1Click:Connect(function()
    switchTab("Player")
end)

mapTabButton.MouseButton1Click:Connect(function()
    switchTab("Map")
end)

vehicleTabButton.MouseButton1Click:Connect(function()
    switchTab("Vehicle")
end)

RunService.Heartbeat:Connect(function()
    if vehicleTeleportEnabled and selectedVehicle and player.Character then
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local driverSeat = selectedVehicle.TVehicle:FindFirstChild("DriverSeat")
            if driverSeat then
                driverSeat.CFrame = humanoidRootPart.CFrame
                setProximityPromptDuration(selectedVehicle)
            else
                local seat = selectedVehicle.TVehicle:FindFirstChildWhichIsA("Seat")
                if seat then
                    seat.CFrame = humanoidRootPart.CFrame
                    setProximityPromptDuration(selectedVehicle)
                end
            end
        end
    end
    
    -- Постоянное обновление скорости (усиленное)
    if speedEnabled and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
end)

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMenu = true
        dragStart = input.Position
        frameStartPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDraggingMenu = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDraggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            frameStartPos.X.Scale,
            frameStartPos.X.Offset + delta.X,
            frameStartPos.Y.Scale,
            frameStartPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDraggingMenu = false
    end
end)

local function updateSpeed(value)
    currentSpeed = value
    speedValueLabel.Text = "" .. math.floor(value)
    speedBar.Size = UDim2.new(math.clamp(value / 500, 0, 1), 0, 1, 0)
    
    -- Немедленное применение скорости
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = currentSpeed
        end
    end
end

local function startSpeedUpdateLoop()
    -- Останавливаем предыдущий цикл, если он есть
    if speedUpdateConnection then
        speedUpdateConnection:Disconnect()
        speedUpdateConnection = nil
    end
    
    -- Запускаем новый цикл постоянного обновления скорости
    speedUpdateConnection = RunService.RenderStepped:Connect(function()
        if speedEnabled and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = currentSpeed
            end
        end
    end)
end

local function applySpeed()
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speedEnabled and currentSpeed or defaultWalkSpeed
        end
    end
end

local function toggleSpeedBar()
    speedBarOpen = not speedBarOpen
    
    if speedBarTween then
        speedBarTween:Cancel()
    end
    
    local targetHeight = speedBarOpen and 20 or 0
    speedBarTween = TweenService:Create(speedBarContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 150, 0, targetHeight)})
    speedBarTween:Play()
    
    if speedBarOpen then
        speedEnabled = true
        speedCheckbox.Text = "✓"
        startSpeedUpdateLoop() -- Запускаем постоянное обновление
    else
        speedEnabled = false
        speedCheckbox.Text = ""
        if speedUpdateConnection then
            speedUpdateConnection:Disconnect()
            speedUpdateConnection = nil
        end
    end
    
    applySpeed()
end

speedSliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        local mousePos = input.Position.X
        local sliderPos = speedSliderBg.AbsolutePosition.X
        local sliderWidth = speedSliderBg.AbsoluteSize.X
        local relativePos = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newSpeed = relativePos * 500
        updateSpeed(newSpeed)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and not isDraggingMenu and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local sliderPos = speedSliderBg.AbsolutePosition.X
        local sliderWidth = speedSliderBg.AbsoluteSize.X
        local relativePos = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
        local newSpeed = relativePos * 500
        updateSpeed(newSpeed)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

speedButton.MouseButton1Click:Connect(function()
    toggleSpeedBar()
end)

wallhackButton.MouseButton1Click:Connect(function()
    wallhackEnabled = not wallhackEnabled
    wallhackCheckbox.Text = wallhackEnabled and "✓" or ""
    
    if wallhackEnabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player then
                createHighlight(otherPlayer)
            end
        end
    else
        for otherPlayer, _ in pairs(highlights) do
            removeHighlight(otherPlayer)
        end
    end
end)

removeBarriersButton.MouseButton1Click:Connect(function()
    if game:FindFirstChild("KelvBarriers") then
        local kelvBarriers = game.KelvBarriers:FindFirstChild("Barrier")
        if kelvBarriers then
            kelvBarriers:Destroy()
        end
    end
    
    if game:FindFirstChild("RaiderBarriers") then
        local raiderBarriers = game.RaiderBarriers:FindFirstChild("Barrier")
        if raiderBarriers then
            raiderBarriers:Destroy()
        end
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    local character = player.Character
    
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(641.59845, 229.455826, -1031.41589, 0.155402824, -3.04948529e-08, -0.987851202, -3.13878488e-08, 1, -3.58076342e-08, 0.987851202, 3.65711301e-08, 0.155402824)
        end
    end
end)

secondTeleportButton.MouseButton1Click:Connect(function()
    local character = player.Character
    
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(1595.46448, 216.999969, -1842.40845, 0.995562017, 5.46360575e-08, -0.0941075981, -6.44861373e-08, 1, -1.01627208e-07, 0.0941075981, 1.07244823e-07, 0.995562017)
        end
    end
end)

player.CharacterAdded:Connect(function(character)
    task.wait(0.1)
    if speedEnabled then
        applySpeed()
        startSpeedUpdateLoop() -- Перезапускаем цикл для нового персонажа
    end
end)

Players.PlayerAdded:Connect(function(newPlayer)
    if wallhackEnabled and newPlayer ~= player then
        createHighlight(newPlayer)
    end
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if highlights[leavingPlayer] then
        removeHighlight(leavingPlayer)
    end
end)

player:GetPropertyChangedSignal("Team"):Connect(function()
    if wallhackEnabled then        for otherPlayer, _ in pairs(highlights) do
            updateHighlightColor(otherPlayer)
            if otherPlayer.Character then
                createNameTag(otherPlayer, otherPlayer.Character)
            end
        end
    end
end)

closeButton.MouseButton1Click:Connect(function()
    --frame:Destroy()
        frame.Visible = false
end)

switchTab("Player")

--==========взаимодействие с гуи============

local FrameVisible = true

local function toggleFrame()
    FrameVisible = not FrameVisible
    frame.Visible = FrameVisible
end


UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert and not gameProcessed then
        toggleFrame()
    end
end)

--Freecam
--loadstring(game:HttpGet("https://pastebin.com/raw/GX6MytJm"))()
--Freecam

local noclipEnabled = false
local noclipConnection = nil

local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Size = UDim2.new(0, 100, 0, 20)
noclipButton.Position = UDim2.new(0, 110, 0, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
noclipButton.Text = "NOCLIP"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Font = Enum.Font.Legacy
noclipButton.TextSize = 14
noclipButton.Parent = playerContent

local noclipCheckbox = Instance.new("TextLabel")
noclipCheckbox.Name = "NoclipCheckbox"
noclipCheckbox.Size = UDim2.new(0, 20, 0, 20)
noclipCheckbox.Position = UDim2.new(0, 80, 0, 0)
noclipCheckbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
noclipCheckbox.Text = ""
noclipCheckbox.TextColor3 = Color3.fromRGB(0, 0, 0)
noclipCheckbox.Font = Enum.Font.Legacy
noclipCheckbox.TextSize = 16
noclipCheckbox.Parent = noclipButton

local function startNoclip()
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipEnabled then return end
        
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    local character = player.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    noclipCheckbox.Text = noclipEnabled and "✓" or ""
    
    if noclipEnabled then
        startNoclip()
    else
        stopNoclip()
    end
end

noclipButton.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

player.CharacterAdded:Connect(function(character)
    if noclipEnabled then
        task.wait(0.1)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

player.character.FallDamage:Destroy()
