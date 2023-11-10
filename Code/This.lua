--Server side code for making a camera like system based of parts


-- Import necessary services and modules
local Rs = game:GetService('RunService') -- Gets the Roblox service RunService
local Connections

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Module3d = require(ReplicatedStorage:WaitForChild('Module3D')) -- Requires 3rd party module for ease of use

local Players = game.Players:GetPlayers()

-- Function to perform an action with chosen objects and frames
local function Do(chosen, number, player, Chosens, Frames)
	local chosen = game.Workspace[chosen.Name]

	table.insert(Chosens, chosen.Name)

	local Frame = player.PlayerGui["Image" .. number]
	table.insert(Frames, Frame)

	-- Clone and set up the 3D model for display
	chosen.Archivable = true
	local NewChosen = chosen:Clone()
	chosen.Archivable = false
	NewChosen.Parent = nil

	local Model3D = Module3d:Attach3D(Frame, NewChosen)
	Model3D:SetDepthMultiplier(-1)
	Model3D.Camera.FieldOfView = 60
	Model3D.Visible = true

	-- Configure the camera for the 3D model
	Frame.ViewportFrame.Camera.CameraType = Enum.CameraType.Scriptable
	Frame.ViewportFrame.Camera.CFrame = game.Workspace.Cameras["CameraP" .. number].CFrame
	Frame.ViewportFrame.Camera.Focus = CFrame.new(Vector3.new(0, 0, 0))
	Frame.ViewportFrame.Size = UDim2.new(1, 0, 1, 0)

	return chosen, Frame
end

-- Function to view character chosen objects and frames for a player
local function Extra(repeatt, chosen)
	for _, player in pairs(game.Players:GetPlayers()) do
		local Chosens1 = {}
		local Frames1 = {}

		if repeatt == false then
			for _, v in pairs(player.PlayerGui:GetChildren()) do
				if v:IsA('SurfaceGui') then
					local Chosens = {}
					local Frames = {}
					local Number = string.sub(v.Name, 6, #v.Name)
					Do(chosen, Number, player, Chosens, Frames)
					task.wait(0.1)
				end
			end
		else
			for _, v in pairs(player.PlayerGui:GetChildren()) do
				if v:IsA('SurfaceGui') then
					local Frame = v
					local chosen = game.Workspace[chosen.Name]
					chosen.Archivable = true
					local NewChosen = chosen:Clone()
					chosen.Archivable = false
					Frame.ViewportFrame[chosen.Name]:Destroy()
					NewChosen.Parent = Frame.ViewportFrame
					NewChosen:PivotTo(chosen.PrimaryPart.CFrame)
					task.wait(0.01)
				end
			end
		end
		task.wait(0.05)
	end
end

local Stop = false

-- Function to continuously fire a remote event to clients
local function AddLoop(char)
	print("Connection Added")
	while task.wait(0.1) do
		game.ReplicatedStorage.Remotes.Chosen:FireAllClients(true, char)
		if Stop == true then
			print("Loop broken")
			break
		end
	end
	print("Connection Broken")
	return
end

local Connection

-- Player joining event
game.Players.PlayerAdded:Connect(function(player)
	repeat task.wait(0.01) until player.Character
	game.ServerStorage.Chosen.Value = player.Name
end)

-- Player leaving event
game.Players.PlayerRemoving:Connect(function(player)
	if player.Name == game.ServerStorage.Chosen.Value then
		game.ServerStorage.Chosen.Value = ""
	end
end)
