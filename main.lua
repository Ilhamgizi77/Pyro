local ID = game.GameId
local supportedGames = {
    { id = 18668065416, script = "https://pastebin.com/raw/4mJtZbjz" },
    { id = 16732694052, script = "https://pastebin.com/raw/hTLSP3wp" }
}
local universal = "https://pastebin.com/raw/kyhTQ7Kv"

for _, gameData in ipairs(supportedGames) do
    if ID == gameData.id then
        loadstring(game:HttpGet(gameData.script))()
    end
	if ID == not gameData.id then
		
	end
end
