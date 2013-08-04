--Example of a GameState file

--Table
GameState = {}

--New
function GameState:new()
	local gs = {}

	gs = setmetatable(gs, self)
	self.__index = self
	_gs = gs
	
	return gs
end

--Load
function GameState:load()
end

--Close
function GameState:close()
end

--Enable
function GameState:enable()
	print("setting state: game")
	loveframes.SetState("game")
end

--Disable
function GameState:disable()
end

--Update
function GameState:update(dt)
end

--Draw
function GameState:draw()
	love.graphics.setFont(bigFont)
	love.graphics.setColor(textColor)
	love.graphics.printf("Congratulations, you're a faggot, Harry!", winX/2 - 250, winY/2 - 20, 500, "center")
end

--KeyPressed
function GameState:keypressed(key, unicode)
	if key == "escape" then
		disableState("game")
		love.event.push("quit") 
	end
end

--KeyReleased
function GameState:keyreleased(key, unicode)
end

--MousePressed
function GameState:mousepressed(x, y, button)
end

--MouseReleased
function GameState:mousereleased(x, y, button)
end