Class = require "libs/hump/class"
require "libs/LUBE/LUBE"
require "player/Player"

function love.load()
	partialMsg = ""
	love.graphics.setBackgroundColor(48,53,59)
	numConnected = 0
	players = {}
	
	conn = lube.tcpServer()
	conn.handshake = "test handshake"
	conn:setPing(true, 2, "pingtest//end\n")
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
	local ip, port = clientid:getpeername()
	clientip = ip .. ":" .. port
	
	if partialMsg ~= "" then
		print("concatenated partial msg '" .. partialMsg .."' with data '" .. data .."'")
		data = partialMsg .. data
		partialMsg = ""
	end
	
	--print("["..clientip.."][".. os.date("%X") .."] received data: "..data)
	datas = string.explode(data, "\n")
	
	for i, data in pairs(datas) do
		dataStr = data
		data = string.explode(data, "//")
		
		-- check if msg is complete, if not, wait for rest of message
		if data[table.getn(data)] ~= "end" then
			partialMsg = dataStr
			return
		end
		
		if data[1] == "getPlayers" then
			print("["..clientip.."] requested player list")
			--send players one by one to the connected player
			for i,player in pairs(players) do
				conn:send("addPlayer//"..i.."//"..player.x..","..player.y.."//"..player.color[1]..","..player.color[2]..","..player.color[3].."//"
						   ..player.name.."//"..player.state.."//end\n",clientid)
			end
			conn:send("yourID//"..clientip.."//end\n",clientid)
			conn:send("endOfPlayerList//end\n",clientid)
		elseif data[1] == "addSelf" then
			print("["..clientip.."] adding self to players")
			--add player to list, send to everyone
			local x, y, r, g, b, name, state
			pos = string.explode(data[2], ",")
			x = pos[1]
			y = pos[2]
			color = string.explode(data[3], ",")
			name = data[4]
			state = data[5]
			
			local newPlayer = Player:new(x,y,color,name,state)
			players[clientip] = newPlayer
			conn:send("addPlayer//"..clientip.."//"..x..","..y.."//"..color[1]..","..color[2]..","..color[3].."//"..name.."//"..state.."//end\n")
		elseif data[1] == "updatePos" then
			local x = data[2]
			local y = data[3]
			
			players[clientip]:updatePos(x,y)
			
			conn:send("updatePos//" .. clientip .. "//" .. x .. "//" .. y.."//end\n")
		elseif data[1] == "updateState" then
			print("["..clientip.."] updated state")
			local state = data[2]
			
			players[clientip]:updateState(state)
			
			conn:send("updateState//" .. clientip .. "//" .. state.."//end\n")
		elseif data[1] == "updateTrail" then
			local ct = data[2]
			local x1 = data[3]
			local y1 = data[4]
			local x2 = data[5]
			local y2 = data[6]
			local dir = data[7]
			
			players[clientip]:updateTrail(ct, {x1,y1,x2,y2,dir})
			
			conn:send("updateTrail//" .. clientip .. "//" ..ct .."//"..x1.."//"..y1.."//"..x2.."//"..y2.."//"..dir.."//end\n")
		end
	end
	
end

function clientDC(clientid)
	local ip, port = clientid:getpeername()
	clientip = ip .. ":" .. port
	print("["..clientip.."] disconnected")
	numConnected = numConnected + 1
	players[clientip] = nil
	conn:send("removePlayer//"..clientip.."//end\n")
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
