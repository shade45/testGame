Player = {}

-- constructor
function Player:new(_x, _y, _color, _name, _state)
	local object = {
		x = _x,
		y = _y,
		dir = "N",
		color = {_color[1], _color[2], _color[3]},
		state = _state,
		name = _name,
		speed = 200,
		curTrail = 0,
		trails = {}
	}	
	
	setmetatable(object, { __index = Player })
	return object
end



function Player:update(dt)		
	if self.dir == "N" then
		self.y = self.y - self.speed*dt
	elseif self.dir == "E" then
		self.x = self.x + self.speed*dt
	elseif self.dir == "S" then
		self.y = self.y + self.speed*dt
	elseif self.dir == "W" then
		self.x = self.x - self.speed*dt
	end
	
	self.x = round(self.x, 1)
	self.y = round(self.y, 1)
	
	self.trails[self.curTrail][3] = self.x
	self.trails[self.curTrail][4] = self.y	
	
	--[[if (self.x < 0 or self.x > winX or self.y < 0 or self.y > winY) then
		print("die")
		subState = "spawning"
		conn:send("updateState//spawning//end\n")
	end]]--
	
	if (self.x < 0) then
		self.x = winX
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {winX, self.y, self.x+0.1, self.y+0.1, self.dir}
	end
	
	if (self.x > winX) then
		self.x = 0
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {0, self.y, self.x+0.1, self.y+0.1, self.dir}
	end
	
	if (self.y < 0) then
		self.y = winY
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x, winY, self.x+0.1, self.y+0.1, self.dir}
	end
	
	if (self.y > winY) then
		self.y = 0
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x, 0, self.x+0.1, self.y+0.1, self.dir}
	end
	
	--check collision with self
	collission = false
	collided = 0
	myTrail = self.trails[self.curTrail]
	for i, trail in pairs(self.trails) do
		if self.curTrail > (i+1) then
			if isIntersecting(myTrail[1], myTrail[2], myTrail[3], myTrail[4], myTrail[5], trail[1], trail[2], trail[3], trail[4], trail[5]) then
				collission = true 
				collided = i
				print('('..myTrail[1]..','.. myTrail[2]..') ('.. myTrail[3]..','.. myTrail[4]..") collided with (" ..trail[1]..','.. trail[2]..') ('.. trail[3]..','.. trail[4])
				break
			end
		end
	end
	
	for j, player in pairs(players) do
		if player.state == "playing" then 
			for i, trail in pairs(player.trails) do
				
				if isIntersecting(myTrail[1], myTrail[2], myTrail[3], myTrail[4], myTrail[5], trail[1], trail[2], trail[3], trail[4], trail[5]) then
					collission = true 
					collided = i
					print('('..myTrail[1]..','.. myTrail[2]..') ('.. myTrail[3]..','.. myTrail[4]..") collided with (" ..trail[1]..','.. trail[2]..') ('.. trail[3]..','.. trail[4])
					break
				end

			end
		end
	end
	
	if (collission) then
		print("collided with trail " .. collided)
		subState = "spawning"
		conn:send("updateState//spawning//end\n")
	end
	
end

--KeyPressed
function Player:keypressed(key, unicode)
	if (key == "up" or key == "w") and (self.dir == "E" or self.dir == "W") then
		self.dir = "N"
		conn:send("updateDirection//N//end\n")
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x,self.y,self.x+0.001,self.y+0.001, self.dir}
	end
	
	if (key == "right" or key == "d") and (self.dir == "N" or self.dir == "S") then
		self.dir = "E"
		conn:send("updateDirection//E//end\n")
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x,self.y,self.x+0.001,self.y+0.001, self.dir}
	end
	
	if (key == "down" or key == "s") and (self.dir == "E" or self.dir == "W") then
		self.dir = "S"
		conn:send("updateDirection//S//end\n")
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x,self.y,self.x+0.001,self.y+0.001, self.dir}
	end
	
	if (key == "left" or key == "a") and (self.dir == "N" or self.dir == "S") then
		self.dir = "W"
		conn:send("updateDirection//W//end\n")
		self.curTrail = self.curTrail + 1
		self.trails[self.curTrail] = {self.x,self.y,self.x+0.001,self.y+0.001, self.dir}
	end
end

--KeyReleased
function Player:keyreleased(key, unicode)
end

function Player:updatePos(_x,_y)
	self.x = _x
	self.y = _y
end

function Player:updateState(_state)
	self.state= _state
end

function Player:updateDirection(_dir)
	self.dir= _dir
end

function Player:updateTrail(ct, trail)
	self.trails[ct] = trail
end

function Player:draw()
	if self.state == "playing" then
		love.graphics.setColor({self.color[1],self.color[2],self.color[3],15})
		love.graphics.rectangle("fill", self.x - 8, self.y - 8, 16, 16)
		love.graphics.setColor({self.color[1],self.color[2],self.color[3],50})
		love.graphics.rectangle("fill", self.x - 7, self.y - 7, 14, 14)
		love.graphics.setColor({self.color[1],self.color[2],self.color[3],90})
		love.graphics.rectangle("fill", self.x - 6, self.y - 6, 12, 12)
		love.graphics.setColor(self.color)
		love.graphics.rectangle("fill", self.x - 5, self.y - 5, 10, 10)
		
		--draw trails
		for i, trail in pairs(self.trails) do
			local x1, y1, x2, y2, dir, x1dir, y1dir, x2dir, y2dir
			
			x1 = trail[1]
			y1 = trail[2]
			x2 = trail[3]
			y2 = trail[4]
			dir = trail[5]

			love.graphics.setColor(self.color)
			if dir == "N" then 
				love.graphics.rectangle("fill", x2 - 3, y2 - 3, 6, y1-y2 + 6)			
			elseif dir == "E" then
				love.graphics.rectangle("fill", x1 - 3, y1 - 3, x2-x1 + 6, 6)
			elseif dir == "S" then
				love.graphics.rectangle("fill", x1 - 3, y1 - 3, 6, y2-y1 + 6)
			else 
				love.graphics.rectangle("fill", x2 - 3, y2 - 3, x1-x2 + 6, 6)
			end

		end
	end
end


