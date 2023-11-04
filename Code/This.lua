local ds = game:GetService("DataStoreService")
--local newds = ds:GetDataStore("Bob's_Data_Store")
local newds = ds:GetDataStore("Bob's_Data_Store")
local badge = game:GetService("BadgeService")

game.Players.PlayerAdded:Connect(function(player)
	local scoreholder = Instance.new("NumberValue")
	local why,why2
	local success,errormss = pcall(function()
	why = newds:GetAsync("highscore"..player.UserId)
	why2 = newds:GetAsync("highwave"..player.UserId)
	end)	
	local highscore = Instance.new("NumberValue")
	local highwave = Instance.new("NumberValue")
	highwave.Parent = player
	highwave.Name = "HighWave"
	highscore.Parent = player
	highscore.Name = "HighScore"
	if why then
		highscore.Value = why
	elseif not why then
		highscore.Value = 0
	end
	
	if why2 then
		highwave.Value = why2
	elseif not highwave then
		highwave.Value = 0
	end
	
	
	scoreholder.Name = "score"
	scoreholder.Parent = player
end)


game.ReplicatedStorage.Score.OnServerInvoke = (function(player,score)
	player.score.Value = score
	if score > player.HighScore.Value then
		print("higherScore!!")
		print(score)
		player.HighScore.Value = score
		return true
	else
		return false
	end
end)


game.ReplicatedStorage.WaveChanged.OnServerEvent:Connect(function(player,wave)
	if wave > player.HighWave.Value then
		print("Highest Wave")
		player.HighWave.Value = wave
		
	end
end)


game.Players.PlayerRemoving:Connect(function(player)
	print(player:WaitForChild("HighScore").Value)
	--local success,errormsg = pcall(function()
	--game:BindToClose(function()
		--local success,errormsg = pcall(function()
		newds:SetAsync("highscore"..player.UserId,player.HighScore.Value)
			newds:SetAsync("highwave"..player.UserId,player.HighWave.Value)
			--end)	
		--end)
	--end)
end)
