--Example of a GameState file

--Table
NameState = {}

--New
function NameState:new()
	local gs = {
		
	}

	gs = setmetatable(gs, self)
	self.__index = self
	_gs = gs
	
	return gs
end

--Load
function NameState:load()
	background = love.graphics.newImage("states/name/pattern4.png")
	
	enterText = "Enter your name:"
		
	textinput = loveframes.Create("textinput")
	textinput:SetWidth(200)
	textinput:SetHeight(20)
	textinput:SetState("name")
	textinput:SetPos((winX-200)/2, winY/2)	
	textinput.OnChange = function(object)
		playerName = object:GetText()
	end
	
	button = loveframes.Create("button")
	button:SetSize(50, 20)
	button:SetPos((winX-50)/2, winY/2 + 50)
	button:SetText("OK")
	button:SetState("name")
	button.OnClick = function(object)
		if textinput:GetText() == "" then
			enterText = "I said enter your FUCKING name:"
		else 
			playerName = textinput:GetText()
			enableState("color")
			disableState("name")
		end
	end
end

--Close
function NameState:close()
end

--Enable
function NameState:enable()

	loveframes.SetState("name")
end

--Disable
function NameState:disable()
end

--Update
function NameState:update(dt)
end

--Draw
function NameState:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.draw(background, 0, 0)	
	love.graphics.setFont(bigFont)
	love.graphics.printf(enterText, winX/2 - 250, winY/2 - 50, 500, "center")
	love.graphics.setFont(defaultFont)
	loveframes.draw()
end

--KeyPressed
function NameState:keypressed(key, unicode)
end

--KeyRelease
function NameState:keyrelease(key, unicode)
end

--MousePressed
function NameState:mousepressed(x, y, button)
end

--MouseReleased
function NameState:mousereleased(x, y, button)
end

