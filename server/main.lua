Class = require "libs/hump/class"
require "libs/LUBE/LUBE"
require "player/Player"

function love.load()
	love.graphics.setBackgroundColor(48,53,59)
	numConnected = 0
	players = {}
	
	conn = lube.udpServer()
	conn.handshake = "test handshake"
	conn:setPing(true, 16, "areYouStillThere?\n")
	conn:listen(25565)
	conn.callbacks.recv = serverRecv
	conn.callbacks.connect = function()
		numConnected = numConnected + 1 
		print("user connected")
	end
	
	conn.callbacks.disconnect = clientDC
end

function love.update(dt)
	conn:update(dt)
end

function love.draw()
	for i,player in pairs(players) do
		player:draw()
	end
end

function serverRecv(data, clientid)
	--print("["..clientid.."] received data: "..data)
	data = string.explode(data, "//")
	if data[1] == "getPlayers" then
		print("["..clientid.."] requested player list")
		--send players one by one to the connected player
		for i,player in pairs(players) do
			conn:send("addPlayer//"..i.."//"..player.x..","..player.y.."//"..player.color[1]..","..player.color[2]..","..player.color[3].."//"
					   ..player.name.."//"..player.state,clientid)
		end
		conn:send("yourID//"..clientid,clientid)
		conn:send("endOfPlayerList",clientid)
	elseif data[1] == "addSelf" then
		print("["..clientid.."] adding self to players")
		--add player to list, send to everyone
		local x, y, r, g, b, name, state
		pos = string.explode(data[2], ",")
		x = pos[1]
		y = pos[2]
		color = string.explode(data[3], ",")
		name = data[4]
		state = data[5]
		
		local newPlayer = Player:new(x,y,color,name,state)
		players[clientid] = newPlayer
		conn:send("addPlayer//"..clientid.."//"..x..","..y.."//"..color[1]..","..color[2]..","..color[3].."//"..name.."//"..state)
	elseif data[1] == "updatePos" then
		local x = data[2]
		local y = data[3]
		
		players[clientid]:updatePos(x,y)
		
		conn:send("updatePos//" .. clientid .. "//" .. x .. "//" .. y)
	elseif data[1] == "updateState" then
		print("["..clientid.."] updated state")
		local state = data[2]
		
		players[clientid]:updateState(state)
		
		conn:send("updateState//" .. clientid .. "//" .. state)
	end
end

function clientDC(clientid)
	print("["..clientid.."] disconnected")
	numConnected = numConnected + 1
	players[clientid] = nil
	conn:send("removePlayer//"..clientid)
end

function string.explode(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local o = {}
    while true do
        local pos1,pos2 = str:find(div)
        if not pos1 then
            o[#o+1] = str
            break
        end
        o[#o+1],str = str:sub(1,pos1-1),str:sub(pos2+1)
    end
    return o
end