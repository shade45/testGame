--Libraries
require("libs/lovelyMoon/stateManager")
require("libs/lovelyMoon/lovelyMoon")
require("utils/utilFuncs")

smallFont = 	love.graphics.newFont("fonts/visitor1.ttf",10)
defaultFont = 	love.graphics.newFont("fonts/bitmap1.ttf",16)
smallMedFont = 	love.graphics.newFont("fonts/visitor1.ttf",10)	
mediumFont = 	love.graphics.newFont("fonts/visitor1.ttf",20)
bigFont = 		love.graphics.newFont("fonts/visitor1.ttf",30)
debugFont = 	love.graphics.newFont("fonts/visitor1.ttf",10)

require("libs/loveframes/init")

playerName = ""
playerColor = {128,128,128}

--GameStates
require("states/game/gameState")
require("states/name/nameState")
require("states/color/colorState")

winX = 800
winY = 600
g = love.graphics
textColor = {94,94,104}
inputBodyColor = {128,136,145}

DEBUG = false

function love.load()
	success = love.graphics.setMode( winX, winY, false, false, 2)
	love.graphics.setFont(defaultFont)
	--Add Gamestates Here
	addState(NameState, "name")
	addState(ColorState, "color")
	addState(GameState, "game")
	
	--Remember to Enable your Gamestates!
	enableState("name")
end

function love.update(dt)
	loveframes.update(dt)
	lovelyMoon.update(dt)
end

function love.draw()
	lovelyMoon.draw()
	
	--print debug
	if (DEBUG) then
		love.graphics.setFont(debugFont)
		love.graphics.setColor(255,255,255)
		love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
		love.graphics.print("Name: " .. playerName, 0, 8)	
		love.graphics.print("Color: " .. playerColor[1] .. "," .. playerColor[2] .. "," .. playerColor[3], 0, 16)
		playersStr = (players and table.getn(players) or "just you... bro")
		love.graphics.print("players: " ..playersStr, 0, 24)			
		love.graphics.setFont(defaultFont)
	end
	
end

function love.keypressed(key, unicode)
	if key == '`' then
		DEBUG = not DEBUG
	end
	
	loveframes.keypressed(key, unicode)
	lovelyMoon.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
	loveframes.keyreleased(key, unicode)
	lovelyMoon.keyreleased(key, unicode)
end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
	lovelyMoon.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
	lovelyMoon.mousereleased(x, y, button)
end