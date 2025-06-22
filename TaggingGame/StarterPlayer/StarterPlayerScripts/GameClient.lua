-- Client-Side Game Handler
-- Manages UI updates, game state visualization, and player interactions

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for RemoteEvents
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local updateGameState = remoteEvents:WaitForChild("UpdateGameState")
local playerTagged = remoteEvents:WaitForChild("PlayerTagged")
local updateTimer = remoteEvents:WaitForChild("UpdateTimer")

-- Create UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TaggingGameUI"
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Parent = screenGui

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "TAGGING GAME"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Game State Label
local gameStateLabel = Instance.new("TextLabel")
gameStateLabel.Name = "GameStateLabel"
gameStateLabel.Size = UDim2.new(1, -20, 0, 40)
gameStateLabel.Position = UDim2.new(0, 10, 0, 60)
gameStateLabel.BackgroundTransparency = 1
gameStateLabel.Text = "Waiting for players..."
gameStateLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
gameStateLabel.TextScaled = true
gameStateLabel.Font = Enum.Font.Gotham
gameStateLabel.Parent = mainFrame

-- Timer Label
local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.Size = UDim2.new(1, -20, 0, 60)
timerLabel.Position = UDim2.new(0, 10, 0, 110)
timerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
timerLabel.Text = "00:00"
timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold
timerLabel.Parent = mainFrame

-- Role Label
local roleLabel = Instance.new("TextLabel")
roleLabel.Name = "RoleLabel"
roleLabel.Size = UDim2.new(1, -20, 0, 40)
roleLabel.Position = UDim2.new(0, 10, 0, 180)
roleLabel.BackgroundTransparency = 1
roleLabel.Text = "Role: Player"
roleLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
roleLabel.TextScaled = true
roleLabel.Font = Enum.Font.Gotham
roleLabel.Parent = mainFrame

-- Players List
local playersLabel = Instance.new("TextLabel")
playersLabel.Name = "PlayersLabel"
playersLabel.Size = UDim2.new(1, -20, 0, 60)
playersLabel.Position = UDim2.new(0, 10, 0, 230)
playersLabel.BackgroundTransparency = 1
playersLabel.Text = "Players: 0"
playersLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
playersLabel.TextScaled = true
playersLabel.Font = Enum.Font.Gotham
playersLabel.Parent = mainFrame

-- Instructions Frame (shows during different game states)
local instructionsFrame = Instance.new("Frame")
instructionsFrame.Name = "InstructionsFrame"
instructionsFrame.Size = UDim2.new(0, 500, 0, 200)
instructionsFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
instructionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
instructionsFrame.BorderSizePixel = 3
instructionsFrame.BorderColor3 = Color3.fromRGB(255, 255, 0)
instructionsFrame.Visible = false
instructionsFrame.Parent = screenGui

local instructionsTitle = Instance.new("TextLabel")
instructionsTitle.Name = "Title"
instructionsTitle.Size = UDim2.new(1, 0, 0, 50)
instructionsTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
instructionsTitle.Text = "GAME STARTING!"
instructionsTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
instructionsTitle.TextScaled = true
instructionsTitle.Font = Enum.Font.GothamBold
instructionsTitle.Parent = instructionsFrame

local instructionsText = Instance.new("TextLabel")
instructionsText.Name = "Text"
instructionsText.Size = UDim2.new(1, -20, 1, -70)
instructionsText.Position = UDim2.new(0, 10, 0, 60)
instructionsText.BackgroundTransparency = 1
instructionsText.Text = "Instructions will appear here..."
instructionsText.TextColor3 = Color3.fromRGB(255, 255, 255)
instructionsText.TextScaled = true
instructionsText.Font = Enum.Font.Gotham
instructionsText.TextWrapped = true
instructionsText.Parent = instructionsFrame

-- Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 400, 0, 80)
notificationFrame.Position = UDim2.new(0.5, -200, 0, -100)
notificationFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
notificationFrame.BorderSizePixel = 2
notificationFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
notificationFrame.Visible = false
notificationFrame.Parent = screenGui

local notificationText = Instance.new("TextLabel")
notificationText.Name = "Text"
notificationText.Size = UDim2.new(1, -20, 1, -20)
notificationText.Position = UDim2.new(0, 10, 0, 10)
notificationText.BackgroundTransparency = 1
notificationText.Text = "Notification"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.TextScaled = true
notificationText.Font = Enum.Font.GothamBold
notificationText.Parent = notificationFrame

-- Game Client Logic
local GameClient = {
    currentState = "Waiting",
    isGhost = false,
    gameTimer = 0,
    preparationTimer = 0
}

function GameClient:ShowNotification(message, duration)
    notificationText.Text = message
    notificationFrame.Visible = true
    notificationFrame.Position = UDim2.new(0.5, -200, 0, -100)
    
    -- Animate in
    local tweenIn = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -200, 0, 50)}
    )
    tweenIn:Play()
    
    -- Auto hide after duration
    wait(duration or 3)
    local tweenOut = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -200, 0, -100)}
    )
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notificationFrame.Visible = false
    end)
end

function GameClient:ShowInstructions(title, text, duration)
    instructionsTitle.Text = title
    instructionsText.Text = text
    instructionsFrame.Visible = true
    
    -- Animate in
    instructionsFrame.Size = UDim2.new(0, 0, 0, 0)
    instructionsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(
        instructionsFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 500, 0, 200),
            Position = UDim2.new(0.5, -250, 0.5, -100)
        }
    )
    tween:Play()
    
    if duration then
        wait(duration)
        self:HideInstructions()
    end
end

function GameClient:HideInstructions()
    local tween = TweenService:Create(
        instructionsFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
    )
    tween:Play()
    
    tween.Completed:Connect(function()
        instructionsFrame.Visible = false
    end)
end

function GameClient:UpdateGameState(state, data)
    self.currentState = state
    
    if state == "Waiting" then
        gameStateLabel.Text = "Waiting for players..."
        gameStateLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        roleLabel.Text = "Role: Waiting"
        roleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        
    elseif state == "Starting" then
        gameStateLabel.Text = "Game Starting..."
        gameStateLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        self:ShowInstructions(
            "GAME STARTING!",
            "A new round is beginning!\nOne player will be chosen as the Ghost.\nOthers must hide during the 30-second preparation phase!",
            5
        )
        
    elseif state == "Preparation" then
        gameStateLabel.Text = "Preparation Phase"
        gameStateLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        
        if self.isGhost then
            roleLabel.Text = "Role: GHOST"
            roleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            self:ShowInstructions(
                "YOU ARE THE GHOST!",
                "You are locked in the ghost room for 30 seconds.\nOnce released, find and tag all the other players within 5 minutes to win!",
                8
            )
        else
            roleLabel.Text = "Role: PLAYER"
            roleLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            self:ShowInstructions(
                "HIDE!",
                "The Ghost is locked in the center room for 30 seconds.\nUse this time to find a good hiding spot!\nSurvive for 5 minutes to win!",
                8
            )
        end
        
    elseif state == "Playing" then
        gameStateLabel.Text = "Game in Progress"
        gameStateLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        if self.isGhost then
            self:ShowNotification("The Ghost has been released! Go find the other players!", 3)
        else
            self:ShowNotification("The Ghost is free! Stay hidden!", 3)
        end
        
    elseif state == "Finished" then
        gameStateLabel.Text = "Game Finished"
        gameStateLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local winner = data
        if winner == "Ghost" then
            self:ShowInstructions(
                "GAME OVER!",
                "The Ghost wins!\nAll players were tagged before time ran out.",
                8
            )
        else
            self:ShowInstructions(
                "GAME OVER!", 
                "Players win!\nThey survived the full 5 minutes without being caught!",
                8
            )
        end
    end
    
    -- Update players count
    local playerCount = #Players:GetPlayers()
    playersLabel.Text = "Players: " .. playerCount
end

function GameClient:UpdateTimer(timerType, timeLeft)
    local minutes = math.floor(timeLeft / 60)
    local seconds = timeLeft % 60
    local timeString = string.format("%02d:%02d", minutes, seconds)
    
    timerLabel.Text = timeString
    
    if timerType == "preparation" then
        timerLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    elseif timerType == "game" then
        timerLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        
        -- Warning colors for last minute
        if timeLeft <= 60 then
            timerLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        if timeLeft <= 10 then
            -- Flash effect for last 10 seconds
            local flash = timeLeft % 2 < 1
            timerLabel.TextColor3 = flash and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
        end
    end
end

function GameClient:OnPlayerTagged(playerName)
    if playerName == player.Name then
        self:ShowNotification("YOU HAVE BEEN TAGGED!", 5)
        roleLabel.Text = "Role: TAGGED"
        roleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    else
        self:ShowNotification(playerName .. " has been tagged!", 3)
    end
end

-- Check if player is ghost
local function checkIfGhost()
    -- This will be updated by the server
    spawn(function()
        while true do
            wait(1)
            -- Simple check - if player is in ghost room area, they're probably the ghost
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local pos = player.Character.HumanoidRootPart.Position
                local distanceFromCenter = math.sqrt(pos.X^2 + pos.Z^2)
                
                if distanceFromCenter < 15 and GameClient.currentState == "Preparation" then
                    GameClient.isGhost = true
                elseif GameClient.currentState == "Starting" then
                    GameClient.isGhost = false
                end
            end
        end
    end)
end

-- Event Connections
updateGameState.OnClientEvent:Connect(function(state, data)
    GameClient:UpdateGameState(state, data)
end)

updateTimer.OnClientEvent:Connect(function(timerType, timeLeft)
    GameClient:UpdateTimer(timerType, timeLeft)
end)

playerTagged.OnClientEvent:Connect(function(playerName)
    GameClient:OnPlayerTagged(playerName)
end)

-- Initialize
checkIfGhost()
print("Tagging Game - Client Started for " .. player.Name)
