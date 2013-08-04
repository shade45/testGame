installDir = "utils/"

require(installDir .. "Slider")

guiElements = {}

-- constructor
function guiElements:new()
	local object = {
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

-- draw the elements
function guiElements:draw()
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:draw()
	end
end

function guiElements:update(dt)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:update(dt)
	end
end

--MousePressed
function guiElements:mousepressed(x, y, button)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:mousepressed(x, y, button)
	end
end

--MouseReleased
function guiElements:mousereleased(x, y, button)
	for i,_ in pairs(self.sliders) do
		self.sliders[i]:mousereleased(x, y, button)
	end
end

