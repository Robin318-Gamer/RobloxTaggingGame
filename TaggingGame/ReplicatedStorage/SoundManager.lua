-- Sound Manager for Tagging Game
-- Handles all game audio effects and music

local SoundService = game:GetService("SoundService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

local SoundManager = {}

-- Sound objects storage
local sounds = {}

-- Initialize sounds
function SoundManager:Initialize()
    -- Create sound effects
    sounds.gameStart = Instance.new("Sound")
    sounds.gameStart.SoundId = "rbxasset://sounds/electronicpingshort.wav"
    sounds.gameStart.Volume = 0.7
    sounds.gameStart.Parent = SoundService
    
    sounds.ghostRelease = Instance.new("Sound")
    sounds.ghostRelease.SoundId = "rbxasset://sounds/impact_water_01.wav"
    sounds.ghostRelease.Volume = 0.8
    sounds.ghostRelease.Parent = SoundService
    
    sounds.playerTagged = Instance.new("Sound")
    sounds.playerTagged.SoundId = "rbxasset://sounds/hit_impact_2.wav"
    sounds.playerTagged.Volume = 0.6
    sounds.playerTagged.Parent = SoundService
    
    sounds.gameEnd = Instance.new("Sound")
    sounds.gameEnd.SoundId = "rbxasset://sounds/victory.wav"
    sounds.gameEnd.Volume = 0.8
    sounds.gameEnd.Parent = SoundService
    
    sounds.warning = Instance.new("Sound")
    sounds.warning.SoundId = "rbxasset://sounds/beep-28.wav"
    sounds.warning.Volume = 0.5
    sounds.warning.Parent = SoundService
    
    sounds.countdown = Instance.new("Sound")
    sounds.countdown.SoundId = "rbxasset://sounds/beep-7.wav"
    sounds.countdown.Volume = 0.4
    sounds.countdown.Parent = SoundService
    
    -- Background music (ambient)
    sounds.backgroundMusic = Instance.new("Sound")
    sounds.backgroundMusic.SoundId = "rbxasset://sounds/ambient_wind_001.wav"
    sounds.backgroundMusic.Volume = 0.2
    sounds.backgroundMusic.Looped = true
    sounds.backgroundMusic.Parent = SoundService
    
    -- Ghost chase music (tense)
    sounds.chaseMusic = Instance.new("Sound")
    sounds.chaseMusic.SoundId = "rbxasset://sounds/ambient_wind_002.wav"
    sounds.chaseMusic.Volume = 0.3
    sounds.chaseMusic.Looped = true
    sounds.chaseMusic.Parent = SoundService
end

-- Play specific sounds
function SoundManager:PlayGameStart()
    if sounds.gameStart then
        sounds.gameStart:Play()
    end
end

function SoundManager:PlayGhostRelease()
    if sounds.ghostRelease then
        sounds.ghostRelease:Play()
    end
    self:StartChaseMusic()
end

function SoundManager:PlayPlayerTagged()
    if sounds.playerTagged then
        sounds.playerTagged:Play()
    end
end

function SoundManager:PlayGameEnd()
    self:StopAllMusic()
    if sounds.gameEnd then
        sounds.gameEnd:Play()
    end
end

function SoundManager:PlayWarning()
    if sounds.warning then
        sounds.warning:Play()
    end
end

function SoundManager:PlayCountdown()
    if sounds.countdown then
        sounds.countdown:Play()
    end
end

-- Music management
function SoundManager:StartBackgroundMusic()
    self:StopAllMusic()
    if sounds.backgroundMusic then
        sounds.backgroundMusic:Play()
    end
end

function SoundManager:StartChaseMusic()
    self:StopAllMusic()
    if sounds.chaseMusic then
        sounds.chaseMusic:Play()
    end
end

function SoundManager:StopAllMusic()
    if sounds.backgroundMusic then
        sounds.backgroundMusic:Stop()
    end
    if sounds.chaseMusic then
        sounds.chaseMusic:Stop()
    end
end

-- Volume controls
function SoundManager:SetMasterVolume(volume)
    for _, sound in pairs(sounds) do
        sound.Volume = sound.Volume * volume
    end
end

function SoundManager:MuteAll()
    for _, sound in pairs(sounds) do
        sound.Volume = 0
    end
end

function SoundManager:UnmuteAll()
    -- Reset to default volumes
    self:Initialize()
end

-- Cleanup
function SoundManager:Cleanup()
    for _, sound in pairs(sounds) do
        sound:Destroy()
    end
    sounds = {}
end

return SoundManager
