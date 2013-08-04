installDir = "utils/"

require(installDir .. "Slider")
require(installDir .. "Button")

guiElements = {}

-- constructor
function guiElements:new()
	local object = {
		buttons = {},
		sliders = {}		
	}	
	
	setmetatable(object, { __index = guiElements })
	return object
end

function guiElements:newSlider()
	local newSlider = Slider:new()	
	table.insert(self.sliders, newSlider)
	return newSlider
end

function guiElements:newButton()
	local newButton = Button:new()	
	table.insert(self.buttons, newButton)
	return newButton
end

-- draw the elements
function guiElements:draw()
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:draw()
	end
	
	for i,_ in pairs(self.buttons) do
		self.buttons[i]:draw()
	end
end

function guiElements:update(dt)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:update(dt)
	end
	
	for i,_ in pairs(self.buttons) do
		self.buttons[i]:update(dt)
	end
end

--MousePressed
function guiElements:mousepressed(x, y, button)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:mousepressed(x, y, button)
	end
	
	for i,_ in pairs(self.buttons) do
		self.buttons[i]:mousepressed(x, y, button)
	end
end

--MouseReleased
function guiElements:mousereleased(x, y, button)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:mousereleased(x, y, button)
	end
	
	for i,_ in pairs(self.buttons) do
		self.buttons[i]:mousereleased(x, y, button)
	end
end

