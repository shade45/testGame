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
		speed = 100
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
	
	if (self.x < 0 or self.x > winX or self.y < 0 or self.y > winY) then
		print("die")
		subState = "spawning"
		conn:send("updateState//" .. "spawning")
	end
end

--KeyPressed
function Player:keypressed(key, unicode)
	if (key == "up" or key == "w") and (self.dir == "E" or self.dir == "W") then self.dir = "N" end
	if (key == "right" or key == "d") and (self.dir == "N" or self.dir == "S") then self.dir = "E" end
	if (key == "down" or key == "s") and (self.dir == "E" or self.dir == "W") then self.dir = "S" end
	if (key == "left" or key == "a") and (self.dir == "N" or self.dir == "S") then self.dir = "W" end
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
	end
end

