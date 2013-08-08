Class = require "libs/hump/class"
require "libs/LUBE/LUBE"

require "player/Player"
require "player/Enemy"
require "gui/PlayerList"

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
	partialMsg = ""
	spawnCursor = love.graphics.newImage("gui/images/spawnCursor.png")
	subState = "connecting"
	loveframes.SetState("game")
	player = Player:new(0,0,playerColor,playerName,"idle")
	players = {}
	playerCount = 1
	playerList = PlayerList:new()
	connectToServer()	
end

--Disable
function GameState:disable()
end

--Update
function GameState:update(dt)
	if subState == "sending request" then
		conn:send("getPlayers//end\n")
		subState = "receiving data"
	elseif subState == "playing" then
		player:update(dt)
		
		
		
		conn:send("updatePos//"..player.x.."//"..player.y.."//end\n")
		ct = player.curTrail
		conn:send("updateTrail//"..ct .."//"..player.trails[ct][1].."//"..player.trails[ct][2].."//"..player.trails[ct][3].."//"..player.trails[ct][4].."//"..player.trails[ct][5].."//end\n")
	end
	
	--update enemies (approximate their position based on their velocity)
	for i, enemy in pairs (players) do
		enemy:update(dt)
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
		for i,p in pairs(players) do
			p:draw()
		end
		player:draw()
		playerList:draw()
		
		love.graphics.setColor({0,0,0,100}) 
		love.graphics.rectangle("fill", 0, 0, winX, winY)		
		love.graphics.setFont(bigFont)
		love.graphics.setColor(textColor) 
		love.graphics.printf("Select your spawn location", winX/2 - 400, 50, 800, "center")
		
		love.mouse.setVisible(false)
		love.graphics.draw(spawnCursor, love.mouse.getX()-10, love.mouse.getY()-10)
	else
		for i,p in pairs(players) do
			p:draw()
		end
		
		player:draw()
		
		playerList:draw()
	end
	
	--print debug
	if (DEBUG) then
		love.graphics.setFont(debugFont)
		love.graphics.setColor({255,255,255})
		love.graphics.print("subState: " .. subState, 0, 32)		
		love.graphics.print("position: " .. player.x.. "," .. player.y, 0, 40)			
		love.graphics.print("trails: " .. table.getn(player.trails), 0, 48)				
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
		player.curTrail = 1
		player.trails = {}
		player.trails[1] = {x,y,x,y, player.dir}
		conn:send("addSelf//"..x..","..y.."//"..player.color[1]..","..player.color[2]..","..player.color[3].."//"..player.name.."//"..player.state.."//end\n")
		
		subState = "playing"
		love.mouse.setVisible(true)
	end
end

function connectToServer()
	local host = "lorencs.no-ip.org"
		
	conn = lube.udpClient()
	conn.handshake = "test handshake"
	conn:setPing(true, 1, "pingtest//end\n")
	assert(conn:connect(host, 25565, true))
	conn.callbacks.recv = clientRecv
	subState = "sending request"
end

function clientRecv(data)
	print("[".. os.date("%X") .."]received data: "..data)
	
	if partialMsg ~= "" then
		print("concatenated partial msg '" .. partialMsg .."' with data '" .. data .."'")
		data = partialMsg .. data
		partialMsg = ""
	end
	
	datas = string.explode(data, "\n")
	
	for i, data in pairs(datas) do
		dataStr = data
		data = string.explode(data, "//")
		
		-- check if msg is complete, if not, wait for rest of message
		if data[table.getn(data)] ~= "end" then
			partialMsg = dataStr
			return
		end
		
		if data[1] == "addPlayer" then
			
			local clientid, dir, x, y, r, g, b, name, state
			clientid = data[2]
			pos = string.explode(data[3], ",")
			x = tonumber(pos[1])
			y = tonumber(pos[2])
			color = string.explode(data[4], ",")
			name = data[5]
			state = data[6]
			
			if clientid ~= myID then
				print("adding player to list")
				print(x)
				local newPlayer = Enemy:new(x,y,color,name,state)
				newPlayer:updateDirection(dir)
				players[clientid] = newPlayer
				playerCount = playerCount + 1
			end
		
		elseif data[1] == "endOfPlayerList" then
			subState = "spawning"
		elseif data[1] == "yourID" then
			myID = data[2]
		elseif data[1] == "removePlayer" then
			playerID = data[2]
			players[playerID] = nil
			playerCount = playerCount - 1
		elseif data[1] == "updatePos" then
			local clientid = data[2]
			local x = tonumber(data[3])
			local y = tonumber(data[4])
			
			if clientid ~= myID then
				players[clientid]:updatePos(x,y)
			end
		elseif data[1] == "updateState" then
			local clientid = data[2]
			local state = data[3]
			
			if clientid ~= myID then
				players[clientid]:updateState(state)
			end
		elseif data[1] == "updateTrail" then
			local clientid = data[2]
			local ct = tonumber(data[3])
			local x1 = tonumber(data[4])
			local y1 = tonumber(data[5])
			local x2 = tonumber(data[6])
			local y2 = tonumber(data[7])
			local dir = data[8]
			
			if clientid ~= myID then
				players[clientid]:updateTrail(ct, {x1,y1,x2,y2,dir})
			end
		elseif data[1] == "updateDirection" then
			local clientid = data[2]
			local dir = data[3]
			
			if clientid ~= myID then
				players[clientid]:updateDirection(dir)
			end
		end
	end
end

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end