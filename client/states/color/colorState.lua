

--Table
ColorState = {}

--New
function ColorState:new()
	local gs = {}

	gs = setmetatable(gs, self)
	self.__index = self
	_gs = gs
	
	return gs
end

--Load
function ColorState:load()
	gE2 = guiElements:new()
		
	okbutton = gE2:newButton()
	okbutton:setSize(100, 20)
	okbutton:setPos((winX)/2, winY/2 + 125)
	okbutton:setText("OK")
	okbutton:setFont(love.graphics.newFont("fonts/visitor1.ttf", 20))
	okbutton.onClick = function(object)
		enableState("game")
		disableState("color")
	end
	
	rSlider = gE2:newSlider()
	rSlider:setPos(winX/2, winY/2 - 25)
	rSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
	rSlider.onChange = function()
		playerColor[1] = 255*rSlider:getValue()/100
		rSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		gSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		bSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
	end
	
	gSlider = gE2:newSlider()
	gSlider:setPos(winX/2, winY/2 + 25)
	gSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
	gSlider.onChange = function()
		playerColor[2] = 255*gSlider:getValue()/100
		rSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		gSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		bSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})		
	end
	
	bSlider = gE2:newSlider()
	bSlider:setPos(winX/2, winY/2 + 75)
	bSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
	bSlider.onChange = function()
		playerColor[3] = 255*bSlider:getValue()/100
		rSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		gSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
		bSlider:setColor({playerColor[1],playerColor[2],playerColor[3]})
	end
	
	
end

--Close
function ColorState:close()
end

--Enable
function ColorState:enable()
	loveframes.SetState("color")
end

--Disable
function ColorState:disable()
end

--Update
function ColorState:update(dt)
	gE2:update(dt)
end

--Draw
function ColorState:draw()
	love.graphics.setBackgroundColor(48,53,59)
	gE2:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(bigFont)
	love.graphics.setColor(textColor)
	love.graphics.printf("Choose your color:", winX/2 - 250, winY/2 - 100, 500, "center")
	loveframes.draw()
end

--KeyPressed
function ColorState:keypressed(key, unicode)
end

--KeyRelease
function ColorState:keyrelease(key, unicode)
end

--MousePressed
function ColorState:mousepressed(x, y, button)
	gE2:mousepressed(x, y, button)
end

--MouseReleased
function ColorState:mousereleased(x, y, button)
	gE2:mousereleased(x, y, button)
end

