--!strict

--[[
    Play some music for the player!
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sounds = require(ReplicatedStorage.Common:WaitForChild("Sounds"))

local music = Sounds.FindSoundByName("TestMusic")
if music then
	music.Looped = true
	music:Play()
end
