-- Game Configuration Module
-- Centralized configuration for the Tagging Game

local GameConfig = {}

-- Player Settings
GameConfig.MinPlayers = 2
GameConfig.MaxPlayers = 10

-- Timer Settings (in seconds)
GameConfig.PreparationTime = 30  -- Ghost lockdown time
GameConfig.GameTime = 300        -- Main game duration (5 minutes)
GameConfig.PostGameDelay = 10    -- Time to show results before reset

-- Gameplay Settings
GameConfig.TagDistance = 10      -- Distance for tagging players
GameConfig.GhostRoomSize = 20    -- Size of the ghost containment room
GameConfig.MapSize = 200         -- Size of the game map

-- Map Generation Settings
GameConfig.MapGeneration = {
    HidingSpots = {
        Min = 15,
        Max = 25,
        MinSize = Vector3.new(8, 8, 8),
        MaxSize = Vector3.new(15, 12, 15)
    },
    
    Obstacles = {
        Min = 10,
        Max = 20,
        MinSize = Vector3.new(3, 5, 3),
        MaxSize = Vector3.new(8, 15, 8)
    },
    
    -- Safe zones around center where ghost room is located
    CenterSafeZone = 25,
    ObstacleSafeZone = 30
}

-- Visual Settings
GameConfig.Colors = {
    GhostRoom = BrickColor.new("Really red"),
    HidingSpots = BrickColor.new("Brown"),
    Obstacles = BrickColor.new("Dark stone grey"),
    BasePlatform = BrickColor.new("Bright green"),
    SpawnPoints = BrickColor.new("Bright blue"),
    Door = {
        Locked = BrickColor.new("Bright red"),
        Unlocked = BrickColor.new("Lime green")
    }
}

-- Sound Settings (for future sound implementation)
GameConfig.Sounds = {
    GameStart = "rbxasset://sounds/electronicpingshort.wav",
    GhostRelease = "rbxasset://sounds/impact_water_01.wav", 
    PlayerTagged = "rbxasset://sounds/hit_impact_2.wav",
    GameEnd = "rbxasset://sounds/victory.wav",
    Warning = "rbxasset://sounds/beep-28.wav"
}

-- UI Settings
GameConfig.UI = {
    MainFrameSize = UDim2.new(0, 400, 0, 300),
    MainFramePosition = UDim2.new(0, 10, 0, 10),
    Colors = {
        Background = Color3.fromRGB(30, 30, 30),
        Header = Color3.fromRGB(50, 50, 50),
        Waiting = Color3.fromRGB(255, 255, 0),
        Starting = Color3.fromRGB(255, 165, 0),
        Preparation = Color3.fromRGB(255, 100, 100),
        Playing = Color3.fromRGB(100, 255, 100),
        Ghost = Color3.fromRGB(255, 50, 50),
        Player = Color3.fromRGB(100, 255, 100),
        Tagged = Color3.fromRGB(255, 0, 0),
        Warning = Color3.fromRGB(255, 100, 100)
    }
}

-- Development/Debug Settings
GameConfig.Debug = {
    Enabled = true,
    ShowPlayerPositions = true,  -- Enable for testing
    QuickStart = true,  -- Skip waiting for minimum players in testing
    ShowMapGeneration = true
}

return GameConfig
