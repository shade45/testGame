require("utils/guiElements")

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
	gE = guiElements:new()
	
	enterText = "Enter your name:"
		
	textinput = loveframes.Create("textinput")
	textinput:SetWidth(200)
	textinput:SetHeight(20)
	textinput:SetState("name")
	textinput:SetPos((winX-200)/2, winY/2)	
	textinput.OnChange = function(object)
		playerName = object:GetText()
	end
	
	button = gE:newButton()
	button:setSize(100, 20)
	button:setPos((winX)/2, winY/2 + 50)
	button:setText("OK")
	button:setFont(love.graphics.newFont("fonts/visitor1.ttf", 20))
	button.onClick = function()
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
	gE:update(dt)
end

--Draw
function NameState:draw()
	love.graphics.setBackgroundColor(48,53,59)	
	love.graphics.setFont(bigFont)
	love.graphics.setColor(textColor)
	love.graphics.printf(enterText, winX/2 - 300, winY/2 - 50, 600, "center")
	love.graphics.setFont(defaultFont)
	loveframes.draw()
	gE:draw()
end

--KeyPressed
function NameState:keypressed(key, unicode)
end

--KeyRelease
function NameState:keyrelease(key, unicode)
end

--MousePressed
function NameState:mousepressed(x, y, button)
	gE:mousepressed(x, y, button)
end

--MouseReleased
function NameState:mousereleased(x, y, button)
	gE:mousereleased(x, y, button)
end

