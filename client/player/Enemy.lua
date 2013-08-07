--similar to player, but used to update enemies

Enemy = {}

-- constructor
function Enemy:new(_x, _y, _color, _name, _state)
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
	
	setmetatable(object, { __index = Enemy })
	return object
end



function Enemy:update(dt)		
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
	
	if (self.curTrail > 0) then	
		self.trails[self.curTrail][3] = self.x
		self.trails[self.curTrail][4] = self.y	
	end	
end

function Enemy:updatePos(_x,_y)
	self.x = _x
	self.y = _y
end

function Enemy:updateState(_state)
	self.state= _state
end

function Enemy:updateTrail(ct, trail)
	self.trails[ct] = trail
end

function Enemy:draw()
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


