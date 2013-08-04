--Libraries
require("libs/lovelyMoon/stateManager")
require("libs/lovelyMoon/lovelyMoon")

--GameStates
require("states/gameState")
require("states/startState")

function love.load()
	font = love.graphics.newFont("fonts/babyblue.ttf",16)	
	love.graphics.setFont(font)
	--Add Gamestates Here
	addState(MenuState, "start")
	addState(GameState, "game")
	
	--Remember to Enable your Gamestates!
	enableState("start")
end

function love.update(dt)
	lovelyMoon.update(dt)
end

function love.draw()
	lovelyMoon.draw()
end

function love.keypressed(key, unicode)
	lovelyMoon.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	lovelyMoon.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	lovelyMoon.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	lovelyMoon.mousereleased(x, y, button)
end