--!strict

--[[
	This class is local only.

	Creates a button that the local player can see activated.

	To help show how the Sound System Works.
]]

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Trove = require(ReplicatedStorage.Packages.trove)

local Sounds = require(ReplicatedStorage.Common.Sounds)

local Button = {}
Button.__index = Button
Button.TAG_NAME = "Button"

type self = {
	model: Model,
	touchPart: BasePart,

	clicker: ClickDetector,

	_cleaner: typeof(Trove.new()),
}

export type Button = typeof(setmetatable({} :: self, Button))

--[[
	Constructor

	@return self - the new object
]]
function Button.new(model: Instance)
	assert(model:IsA("Model"), "Tagged Instance is not a Model: " .. model:GetFullName())

	local touchPart = model:FindFirstChild("Touch") :: BasePart?
	assert(touchPart, "Could not find touch part for button: " .. model:GetFullName())

	local self = setmetatable({} :: self, Button)
	self._cleaner = Trove.new()

	self.model = model
	self.touchPart = touchPart

	self:_onStart()

	return self
end

--[[
	Activates the button.

	@param self Button - object
]]
function Button.ActivateButton(self: Button)
	local varianceStart = Sounds.Variance()
	local varianceEnd = Sounds.Variance(0.85, 0.95, 0.85, 0.95)

	Sounds.PlaySoundByName("InteractSound", varianceStart, self.touchPart) --sound

	local origin = self.touchPart.CFrame
	local goal = origin * CFrame.new(0, -0.25, 0)

	local tweenInfoStart = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
	TweenService:Create(self.touchPart, tweenInfoStart, { CFrame = goal }):Play()

	task.wait(1)

	local tweenInfoEnd = TweenInfo.new(0.2, Enum.EasingStyle.Sine)
	TweenService:Create(self.touchPart, tweenInfoEnd, { CFrame = origin }):Play()

	task.wait(0.1)

	Sounds.PlaySoundByName("InteractSound", varianceEnd, self.touchPart) --sound

	task.wait(0.5)
end

--[[
	Sets up the button to be intractable.

	@param self Button - object
]]
function Button._onStart(self: Button)
	local clickDetector = self._cleaner:Add(Instance.new("ClickDetector"))
	clickDetector.Parent = self.touchPart
	self.clicker = clickDetector

	local running = false
	self._cleaner:Connect(clickDetector.MouseClick, function(playerWhoClicked: Player)
		if playerWhoClicked ~= player then
			return
		end

		if running then
			return
		end
		running = true

		self:ActivateButton()

		task.wait(0.25)

		running = false
	end)
end

--[[
	Cleans up the Button object.

	@param self Button - object
]]
function Button.Cleanup(self: Button)
	self._cleaner:Destroy()
end

-------------------------------------------------------------------------------------------

local instances = {}

local instanceAddedSignal = CollectionService:GetInstanceAddedSignal(Button.TAG_NAME)
local instanceRemovedSignal = CollectionService:GetInstanceRemovedSignal(Button.TAG_NAME)

local function onInstanceAdded(instance)
	instances[instance] = Button.new(instance)
end

local function onInstanceRemoved(instance)
	instances[instance]:Cleanup()
	instances[instance] = nil
end

for _, instance in pairs(CollectionService:GetTagged(Button.TAG_NAME)) do
	task.spawn(onInstanceAdded, instance)
end
instanceAddedSignal:Connect(onInstanceAdded)
instanceRemovedSignal:Connect(onInstanceRemoved)

-------------------------------------------------------------------------------------------

return {}
