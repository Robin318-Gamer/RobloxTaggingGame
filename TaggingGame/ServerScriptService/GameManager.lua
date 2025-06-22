-- Main Game Manager for Tagging Game
-- Handles game states, player management, and core game logic

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Wait for modules to load
local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))
local SoundManager = require(ReplicatedStorage:WaitForChild("SoundManager"))

-- Create RemoteEvents for client-server communication
local remoteEvents = Instance.new("Folder")
remoteEvents.Name = "RemoteEvents"
remoteEvents.Parent = ReplicatedStorage

local updateGameState = Instance.new("RemoteEvent")
updateGameState.Name = "UpdateGameState"
updateGameState.Parent = remoteEvents

local playerTagged = Instance.new("RemoteEvent")
playerTagged.Name = "PlayerTagged"
playerTagged.Parent = remoteEvents

local updateTimer = Instance.new("RemoteEvent")
updateTimer.Name = "UpdateTimer"
updateTimer.Parent = remoteEvents

-- Game Configuration
local GameConfig = GameConfig or {
    MinPlayers = 2,
    MaxPlayers = 10,
    PreparationTime = 30,
    GameTime = 300,
    TagDistance = 10
}

-- Game States
local GameStates = {
    WAITING = "Waiting",
    STARTING = "Starting", 
    PREPARATION = "Preparation",
    PLAYING = "Playing",
    FINISHED = "Finished"
}

-- Game Variables
local GameManager = {
    currentState = GameStates.WAITING,
    players = {},
    ghostPlayer = nil,
    alivePlayers = {},
    gameTimer = 0,
    preparationTimer = 0,
    ghostRoom = nil,
    mapGenerator = nil
}

-- Map Generator Module
local MapGenerator = {}

function MapGenerator:GenerateRandomMap()
    -- Clear existing map
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "GameMap" or obj.Name == "HidingSpot" or obj.Name == "GhostRoom" then
            obj:Destroy()
        end
    end
    
    -- Create base platform
    local basePlatform = Instance.new("Part")
    basePlatform.Name = "BasePlatform"
    basePlatform.Size = Vector3.new(200, 2, 200)
    basePlatform.Position = Vector3.new(0, 0, 0)
    basePlatform.Anchored = true
    basePlatform.Material = Enum.Material.Grass
    basePlatform.BrickColor = BrickColor.new("Bright green")
    basePlatform.Parent = Workspace
    
    -- Generate Ghost Room (always in center)
    self:CreateGhostRoom()
    
    -- Generate random hiding spots
    self:GenerateHidingSpots()
    
    -- Generate random obstacles
    self:GenerateObstacles()
    
    -- Generate spawn points for players
    self:GenerateSpawnPoints()
end

function MapGenerator:CreateGhostRoom()
    local room = Instance.new("Model")
    room.Name = "GhostRoom"
    room.Parent = Workspace
    
    -- Room walls
    local walls = {}
    local roomSize = 20
    local wallHeight = 15
    
    -- Create 4 walls
    for i = 1, 4 do
        local wall = Instance.new("Part")
        wall.Name = "Wall" .. i
        wall.Size = Vector3.new(roomSize, wallHeight, 2)
        wall.Material = Enum.Material.Brick
        wall.BrickColor = BrickColor.new("Really red")
        wall.Anchored = true
        wall.Parent = room
        
        if i == 1 then -- Front wall
            wall.Position = Vector3.new(0, wallHeight/2 + 1, roomSize/2)
        elseif i == 2 then -- Back wall
            wall.Position = Vector3.new(0, wallHeight/2 + 1, -roomSize/2)
        elseif i == 3 then -- Left wall
            wall.Size = Vector3.new(2, wallHeight, roomSize)
            wall.Position = Vector3.new(-roomSize/2, wallHeight/2 + 1, 0)
        else -- Right wall
            wall.Size = Vector3.new(2, wallHeight, roomSize)
            wall.Position = Vector3.new(roomSize/2, wallHeight/2 + 1, 0)
        end
        
        table.insert(walls, wall)
    end
    
    -- Create door (gap in front wall)
    local door = Instance.new("Part")
    door.Name = "Door"
    door.Size = Vector3.new(8, wallHeight, 3)
    door.Position = Vector3.new(0, wallHeight/2 + 1, roomSize/2 + 2.5)
    door.Material = Enum.Material.ForceField
    door.BrickColor = BrickColor.new("Bright red")
    door.Anchored = true
    door.CanCollide = false
    door.Transparency = 0.5
    door.Parent = room
    
    -- Ghost spawn point
    local ghostSpawn = Instance.new("SpawnLocation")
    ghostSpawn.Name = "GhostSpawn"
    ghostSpawn.Size = Vector3.new(4, 1, 4)
    ghostSpawn.Position = Vector3.new(0, 2, 0)
    ghostSpawn.BrickColor = BrickColor.new("Really red")
    ghostSpawn.Anchored = true
    ghostSpawn.Parent = room
    
    GameManager.ghostRoom = room
    return room
end

function MapGenerator:GenerateHidingSpots()
    local spots = {}
    local numSpots = math.random(15, 25)
    
    for i = 1, numSpots do
        local spot = Instance.new("Model")
        spot.Name = "HidingSpot"
        spot.Parent = Workspace
        
        -- Random position (avoiding center where ghost room is)
        local x, z
        repeat
            x = math.random(-90, 90)
            z = math.random(-90, 90)
        until math.sqrt(x^2 + z^2) > 25 -- Keep away from center
        
        -- Create hiding spot structure
        local base = Instance.new("Part")
        base.Name = "Base"
        base.Size = Vector3.new(math.random(8, 15), math.random(8, 12), math.random(8, 15))
        base.Position = Vector3.new(x, base.Size.Y/2 + 1, z)
        base.Material = Enum.Material.Wood
        base.BrickColor = BrickColor.new("Brown")
        base.Anchored = true
        base.Parent = spot
        
        -- Add some variety
        if math.random() > 0.5 then
            local top = Instance.new("Part")
            top.Size = Vector3.new(base.Size.X + 2, 2, base.Size.Z + 2)
            top.Position = base.Position + Vector3.new(0, base.Size.Y/2 + 1, 0)
            top.Material = Enum.Material.Wood
            top.BrickColor = BrickColor.new("Dark orange")
            top.Anchored = true
            top.Parent = spot
        end
        
        table.insert(spots, spot)
    end
    
    return spots
end

function MapGenerator:GenerateObstacles()
    local numObstacles = math.random(10, 20)
    
    for i = 1, numObstacles do
        local obstacle = Instance.new("Part")
        obstacle.Name = "Obstacle"
        
        -- Random size and shape
        local sizeX = math.random(3, 8)
        local sizeY = math.random(5, 15)
        local sizeZ = math.random(3, 8)
        obstacle.Size = Vector3.new(sizeX, sizeY, sizeZ)
        
        -- Random position (avoiding center)
        local x, z
        repeat
            x = math.random(-95, 95)
            z = math.random(-95, 95)
        until math.sqrt(x^2 + z^2) > 30
        
        obstacle.Position = Vector3.new(x, sizeY/2 + 1, z)
        obstacle.Material = Enum.Material.Rock
        obstacle.BrickColor = BrickColor.new("Dark stone grey")
        obstacle.Anchored = true
        obstacle.Parent = Workspace
    end
end

function MapGenerator:GenerateSpawnPoints()
    local spawnPoints = {}
    local numSpawns = GameConfig.MaxPlayers
    
    for i = 1, numSpawns do
        local spawn = Instance.new("SpawnLocation")
        spawn.Name = "PlayerSpawn" .. i
        spawn.Size = Vector3.new(4, 1, 4)
        
        -- Position spawns around the perimeter
        local angle = (i - 1) * (360 / numSpawns)
        local radius = 80
        local x = math.cos(math.rad(angle)) * radius
        local z = math.sin(math.rad(angle)) * radius
        
        spawn.Position = Vector3.new(x, 2, z)
        spawn.BrickColor = BrickColor.new("Bright blue")
        spawn.Anchored = true
        spawn.Parent = Workspace
        
        table.insert(spawnPoints, spawn)
    end
    
    return spawnPoints
end

-- Game State Management
function GameManager:ChangeState(newState)
    self.currentState = newState
    updateGameState:FireAllClients(newState)
    
    if newState == GameStates.STARTING then
        self:StartGame()
    elseif newState == GameStates.PREPARATION then
        self:StartPreparation()
    elseif newState == GameStates.PLAYING then
        self:StartMainGame()
    elseif newState == GameStates.FINISHED then
        self:EndGame()
    end
end

function GameManager:StartGame()
    -- Initialize sound manager
    SoundManager:Initialize()
    SoundManager:PlayGameStart()
    
    -- Generate new random map
    MapGenerator:GenerateRandomMap()
    
    -- Select random ghost player
    local playerList = {}
    for _, player in pairs(self.players) do
        table.insert(playerList, player)
    end
    
    if #playerList > 0 then
        self.ghostPlayer = playerList[math.random(1, #playerList)]
        
        -- Initialize alive players (everyone except ghost)
        self.alivePlayers = {}
        for _, player in pairs(self.players) do
            if player ~= self.ghostPlayer then
                table.insert(self.alivePlayers, player)
            end
        end
        
        -- Teleport ghost to ghost room
        if self.ghostPlayer.Character and self.ghostPlayer.Character:FindFirstChild("HumanoidRootPart") then
            self.ghostPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 5, 0)
        end
        
        self:ChangeState(GameStates.PREPARATION)
    end
end

function GameManager:StartPreparation()
    self.preparationTimer = GameConfig.PreparationTime
    
    -- Lock ghost in room
    if self.ghostRoom then
        local door = self.ghostRoom:FindFirstChild("Door")
        if door then
            door.CanCollide = true
            door.Transparency = 0.2
        end
    end
    
    -- Start preparation countdown
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        self.preparationTimer = self.preparationTimer - dt
        updateTimer:FireAllClients("preparation", math.ceil(self.preparationTimer))
        
        if self.preparationTimer <= 0 then
            connection:Disconnect()
            
            -- Release ghost from room
            if self.ghostRoom then
                local door = self.ghostRoom:FindFirstChild("Door")
                if door then
                    door.CanCollide = false
                    door.Transparency = 0.8
                end
            end
            
            self:ChangeState(GameStates.PLAYING)
        end
    end)
end

function GameManager:StartMainGame()
    self.gameTimer = GameConfig.GameTime
    
    -- Play ghost release sound
    SoundManager:PlayGhostRelease()
    
    -- Start main game countdown
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        self.gameTimer = self.gameTimer - dt
        updateTimer:FireAllClients("game", math.ceil(self.gameTimer))
        
        -- Check win conditions
        if #self.alivePlayers == 0 then
            -- Ghost wins
            connection:Disconnect()
            self:ChangeState(GameStates.FINISHED)
            return
        end
        
        if self.gameTimer <= 0 then
            -- Time up, players win
            connection:Disconnect()
            self:ChangeState(GameStates.FINISHED)
        end
    end)
    
    -- Start checking for tags
    self:StartTagging()
end

function GameManager:StartTagging()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if self.currentState ~= GameStates.PLAYING then
            connection:Disconnect()
            return
        end
        
        if not self.ghostPlayer or not self.ghostPlayer.Character then
            return
        end
        
        local ghostPosition = self.ghostPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not ghostPosition then return end
        
        -- Check distance to all alive players
        for i = #self.alivePlayers, 1, -1 do
            local player = self.alivePlayers[i]
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (ghostPosition.Position - player.Character.HumanoidRootPart.Position).Magnitude
                
                if distance <= GameConfig.TagDistance then
                    -- Player tagged!
                    self:TagPlayer(player)
                    table.remove(self.alivePlayers, i)
                end
            end
        end
    end)
end

function GameManager:TagPlayer(player)
    SoundManager:PlayPlayerTagged()
    playerTagged:FireAllClients(player.Name)
    
    -- Teleport tagged player to spectator area
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
end

function GameManager:EndGame()
    SoundManager:PlayGameEnd()
    
    local winner
    if #self.alivePlayers == 0 then
        winner = "Ghost"
    else
        winner = "Players"
    end
    
    updateGameState:FireAllClients("finished", winner)
    
    -- Reset after 10 seconds
    wait(10)
    self:ResetGame()
end

function GameManager:ResetGame()
    self.ghostPlayer = nil
    self.alivePlayers = {}
    self.gameTimer = 0
    self.preparationTimer = 0
    
    if #self.players >= GameConfig.MinPlayers then
        self:ChangeState(GameStates.STARTING)
    else
        self:ChangeState(GameStates.WAITING)
    end
end

-- Player Management
function GameManager:AddPlayer(player)
    self.players[player] = player
    
    if #self.players >= GameConfig.MinPlayers and self.currentState == GameStates.WAITING then
        wait(3) -- Give time for players to load
        self:ChangeState(GameStates.STARTING)
    end
end

function GameManager:RemovePlayer(player)
    self.players[player] = nil
    
    -- Remove from alive players if present
    for i, alivePlayer in pairs(self.alivePlayers) do
        if alivePlayer == player then
            table.remove(self.alivePlayers, i)
            break
        end
    end
    
    -- If ghost leaves, end game
    if player == self.ghostPlayer then
        self:ChangeState(GameStates.FINISHED)
    end
    
    -- If not enough players, go to waiting
    if #self.players < GameConfig.MinPlayers then
        self:ChangeState(GameStates.WAITING)
    end
end

-- Event Connections
Players.PlayerAdded:Connect(function(player)
    GameManager:AddPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    GameManager:RemovePlayer(player)
end)

-- Initialize
print("Tagging Game - Server Started!")
