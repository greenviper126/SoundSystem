--!strict

--[[
    Red library should only be called here.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Guard = require(ReplicatedStorage.Packages._Index["red-blox_guard@1.0.1"].guard)
local Ratelimit = require(ReplicatedStorage.Packages.ratelimit)
local Red = require(ReplicatedStorage.Packages.red)
local Signal = require(ReplicatedStorage.Packages._Index["red-blox_signal@2.0.2"].signal)

--[[network connections]]
----------------------------------------------------------------------------------------------------

--fired from server
local fromNetworkServer = {
	--remote

	--functions

	--unreliable
}

--fired from client
local fromNetworkClient = {
	--remote

	--functions
	SoundsRequest = Red.Function(
		"SoundsRequest",
		function() end,
		function(Table) --send sound table to client on request
			return Guard.Map(Guard.String, Guard.Any)(Table)
		end
	),

	--unreliable
}

--[[signal connections]]
----------------------------------------------------------------------------------------------------

--server side
local fromSignalServer = {}

--client side
local fromSignalClient = {}

----------------------------------------------------------------------------------------------------

--[[
	Anything that needs an event or signal should go through here for security.

	All Events will be created within this Module.

	Signals should be made using NewSignal if it will stay within the module using it.
	If that is not the case it should be created in RedEvents Module.
]]
local RedSignalNetwork = {
	-- client to server and server to client communications
	Network = {
		Server = fromNetworkServer,
		Client = fromNetworkClient,
	},
	-- client to client and server to server communications
	Signal = {
		Server = fromSignalServer,
		Client = fromSignalClient,
	},
	Ratelimit = Ratelimit,
	NewSignal = Signal,
}

return RedSignalNetwork
