Class = require "libs/hump/class"
require "libs/LUBE/LUBE"
require "player/Player"

--Table
GameState = {}

--New
function GameState:new()
	local gs = {}

	gs = setmetatable(gs, self)
	self.__index = self
	_gs = gs
	
	return gs
end

--Load
function GameState:load()
end

--Close
function GameState:close()
end

--Enable
function GameState:enable()
	myID = ""
	spawnCursor = love.graphics.newImage("gui/spawnCursor.png")
	subState = "connecting"
	loveframes.SetState("game")
	player = Player:new(0,0,playerColor,playerName,"idle")
	players = {}
	connectToServer()	
end

--Disable
function GameState:disable()
end

--Update
function GameState:update(dt)
	if subState == "sending request" then
		conn:send("getPlayers")
		subState = "receiving data"
	elseif subState == "playing" then
		player:update(dt)
		
		conn:send("updatePos//"..player.x.."//"..player.y)
	end
	
	conn:update(dt)
end

--Draw
function GameState:draw()
	if subState == "receiving data" then
		love.graphics.setFont(bigFont)
		love.graphics.setColor(textColor) 
		love.graphics.printf("receiving data.. (if you can see this, server is probably not responding)", winX/2 - 400, winY/2, 800, "center")
	elseif subState == "spawning" then 
		love.graphics.setFont(bigFont)
		love.graphics.setColor(textColor) 
		love.graphics.printf("Select your spawn location", winX/2 - 400, 50, 800, "center")
		love.mouse.setVisible(false)
		love.graphics.draw(spawnCursor, love.mouse.getX()-10, love.mouse.getY()-10)
		
		for i,p in pairs(players) do
			p:draw()
		end
	else
		for i,p in pairs(players) do
			p:draw()
		end
		
		player:draw()
	end
	
	--print debug
	if (DEBUG) then
		love.graphics.setFont(debugFont)
		love.graphics.print("subState: " .. subState, 0, 32)		
		love.graphics.print("position: " .. player.x .. "," .. player.y, 0, 40)				
		love.graphics.setFont(defaultFont)
	end
end

--KeyPressed
function GameState:keypressed(key, unicode)
	if key == "escape" then
		disableState("game")
		conn:disconnect()
		love.event.push("quit") 
	end
	
	if subState == "playing" then
		player:keypressed(key, unicode)
	end
end

--KeyReleased
function GameState:keyreleased(key, unicode)
	if subState == "playing" then
		player:keyreleased(key, unicode)
	end
end

--MousePressed
function GameState:mousepressed(x, y, button)
end

--MouseReleased
function GameState:mousereleased(x, y, button)
	if subState == "spawning" then
		player.state = "playing"
		player.x = x
		player.y = y
		conn:send("addSelf//"..x..","..y.."//"..player.color[1]..","..player.color[2]..","..player.color[3].."//"..player.name.."//"..player.state)
		
		subState = "playing"
		love.mouse.setVisible(true)
	end
end

function connectToServer()
	local host = "lorencs.no-ip.org"
		
	conn = lube.udpClient()
	conn.handshake = "test handshake"
	conn:setPing(true, 2, "areYouStillThere?\n")
	assert(conn:connect(host, 25565, true))
	conn.callbacks.recv = clientRecv
	subState = "sending request"
end

function clientRecv(data)
	--print("received data: "..data)
	--data = data:match("^(.-)\n*$")
	data = string.explode(data, "//")
	
	if data[1] == "addPlayer" then
		
		local clientid, x, y, r, g, b, name, state
		clientid = data[2]
		pos = string.explode(data[3], ",")
		x = pos[1]
		y = pos[2]
		color = string.explode(data[4], ",")
		name = data[5]
		state = data[6]
		
		if clientid ~= myID then
			print("adding player to list")
			local newPlayer = Player:new(x,y,color,name,state)
			players[clientid] = newPlayer
		end
	
	elseif data[1] == "endOfPlayerList" then
		subState = "spawning"
	elseif data[1] == "yourID" then
		myID = data[2]
	elseif data[1] == "removePlayer" then
		playerID = data[2]
		players[playerID] = nil
	elseif data[1] == "updatePos" then
		local clientid = data[2]
		local x = data[3]
		local y = data[4]
		
		if clientid ~= myID then
			players[clientid]:updatePos(x,y)
		end
	elseif data[1] == "updateState" then
		local clientid = data[2]
		local state = data[3]
		
		if clientid ~= myID then
			players[clientid]:updateState(state)
		end
	end
end