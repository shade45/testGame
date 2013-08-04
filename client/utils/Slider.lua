Slider = {}

-- constructor
function Slider:new()
	local object = {
		x = 103,
		y = 15,
		width = 200,
		height = 30,
		value = 50,
		color = {100,100,100},
		align = "center",
		thick = 10,
		active = false,
		onChange = nil
	}	
	
	setmetatable(object, { __index = Slider })
	return object
end

function Slider:setSize(w,h)
	self.width = w
	self.height = h
end

function Slider:setPos(_x,_y)
	self.x = _x
	self.y = _y
end

function Slider:setColor(color)
	self.color = color
end

function Slider:setThickness(thick)
	self.thick = thick
end

function Slider:getValue()
	return self.value 
end

function Slider:setValue(value)
	self.value = value
end

function Slider:setAlign(align)
	if (align == 'left') or (align == 'center') then
		self.align = align
	end
end

function Slider:update(dt)
	if self.active then
		if self.align == "center" then
			local tempVal = (love.mouse.getX() - (self.x - (self.width/2))) / self.width*100
			if tempVal < 50 then tempVal = math.ceil(tempVal)
			else tempVal = math.floor(tempVal) end
			if (tempVal >= 0 and tempVal <= 100 and tempVal ~= self.value) then
				self.value = tempVal
				if self.onChange then self.onChange() end
			end
		elseif self.align == "left" then
			local tempVal = (love.mouse.getX() - (self.x - (self.width/2))) / self.width*100
			if (tempVal > 0 and tempVal < 100 and tempVal ~= self.value) then
				self.value = tempVal
				if self.onChange then self.onChange() end
			end
		end
	end
end

function Slider:draw()
	love.graphics.setColor(self.color)
	if self.align == "center" then
		love.graphics.rectangle("fill", self.x - (self.width/2), self.y - (self.thick/2), self.width, self.thick)
		love.graphics.rectangle("fill", self.x - (self.width/2) + ((self.width*self.value/100) - (self.thick/2)), self.y - (self.height/2), self.thick, self.height)
		--print("love.graphics.rectangle(" .. self.x - (self.width/2) .. "," .. self.y - (self.thick/2) .. ",".. self.width ..",".. self.thick)
	elseif self.align == "left" then
		love.graphics.rectangle(self.x - (self.width/2), self.y - (self.thick/2), self.width, self.thick)
		love.graphics.rectangle(self.x - (self.width/2) + ((self.width*self.value/100) - (self.thick/2)), self.y - (self.height/2), self.thick, self.height)	
	end
end

--MousePressed
function Slider:mousepressed(x, y, button)
	if x > (self.x - (self.width/2) - self.thick/2) and x < ((self.x - (self.width/2)) + self.width + self.thick/2) and y > (self.y - (self.height/2)) and y < ((self.y - (self.height/2)) + self.height) then
		self.active = true
	end
end

--MouseReleased
function Slider:mousereleased(x, y, button)
	self.active = false
end

