Button = {}

-- constructor
function Button:new()
	local object = {
		x = 103,
		y = 15,
		width = 200,
		height = 30,
		bgColor =		{86,92,99},
		textColor = 	{172,182,191},
		bgHoverColor = 	{110,117,125},
		bgDownColor = 	{62,68,74},
		textDownColor = {73,155,242},
		text = "",
		font = love.graphics.newFont(10),
		fontHeight = love.graphics.newFont(10):getHeight(),
		align = "center",
		hover = false,
		down = false,
		onClick = nil
	}	
	
	setmetatable(object, { __index = Button })
	return object
end

function Button:setSize(w,h)
	self.width = w
	self.height = h
end

function Button:setPos(_x,_y)
	self.x = _x
	self.y = _y
end

function Button:setText(text)
	self.text = text
end

function Button:setFont(font)
	self.font = font
	self.fontHeight = font:getHeight()
end

function Button:setColors(bg, text, bgHover, bgDown, textDown)
	if bg then self.bgColor = bg end
	if text then self.textColor = text end
	if bgHover then self.bgHoverColor = bgHover end
	if bgDown then self.bgDownColor = bgDown end
	if textDown then self.textDownColor = textDown end
end

function Button:setAlign(align)
	if (align == 'left') or (align == 'center') then
		self.align = align
	end
end

function Button:update(dt)
	x = love.mouse.getX()
	y = love.mouse.getY()
	
	if x > (self.x - (self.width/2)) and x < ((self.x - (self.width/2)) + self.width) and y > (self.y - (self.height/2)) and y < ((self.y - (self.height/2)) + self.height) then
		self.hover = true
	else 
		self.hover = false
	end
end

function Button:draw()
	g = love.graphics
	
	if self.align == "center" then
		g.setColor((self.down and self.bgDownColor or (self.hover and self.bgHoverColor or self.bgColor)))
		g.rectangle("fill", self.x - self.width/2, self.y - self.height/2, self.width, self.height)
		g.setColor(self.down and self.textDownColor or self.textColor)
		g.setFont(self.font)
		g.printf(self.text, self.x - 400, self.y - self.fontHeight/2, 800, "center")
	elseif self.align == "left" then
		g.setColor(self.bgColor)
		g.rectangle("fill", self.x , self.y, self.width, self.height)
		g.setColor(self.down and self.textDownColor or self.textColor)
		g.printf(self.text, self.x + self.width/2 - 400, self.y + self.height/2, 800, "center")
	end
end

--MousePressed
function Button:mousepressed(x, y, button)
	if self.hover and button == 'l' then self.down = true end
end

--MouseReleased
function Button:mousereleased(x, y, button)
	if self.down and self.onClick and self.hover then self.onClick() end
	self.down = false
end

