PlayerList = {}

-- constructor
function PlayerList:new()
	local object = {
		headerPadding = 5,
		listPadding = 1,
		sidePadding = 10,
		spaceFromBorder = 10,
	}	
	
	setmetatable(object, { __index = PlayerList })
	return object
end



function PlayerList:update(dt)		
	
end

function PlayerList:draw()
	mediumHeight = mediumFont:getHeight()
	smallHeight = smallMedFont:getHeight()
	n = playerCount
	height = self.headerPadding*2 + mediumHeight + n*smallHeight + ((n - 1) * self.listPadding) + self.headerPadding
	width = self.sidePadding*2 + mediumFont:getWidth("Players:") + 10

	namesColors = {}
	namesColors[1] = {player.color, player.name}
	
	j = 2
	
	for i, p in pairs(players) do
		namesColors[j] = {p.color, p.name}		
		j = j+1
	end	
	
	for i, p in pairs(namesColors) do
		newWidth = self.sidePadding + smallFont:getWidth(p[2]) + 10
		width = ((width < newWidth) and newWidth or width)
	end	
	
	love.graphics.setColor({0,0,0,100})
	love.graphics.rectangle("fill", winX - width - self.spaceFromBorder, winY - height - self.spaceFromBorder, width, height)
	love.graphics.setColor(textColor)
	love.graphics.setFont(mediumFont)
	textWidth = mediumFont:getWidth("Players:") + 5
	love.graphics.printf("Players:", winX - width/2 - self.spaceFromBorder - textWidth/2, winY - self.spaceFromBorder - height + self.headerPadding --[[+ mediumHeight/2]], textWidth, "center")

	love.graphics.setFont(smallMedFont)
	j = 1
	for i, p in pairs(namesColors) do
		love.graphics.setColor(p[1])
		textWidth = self.sidePadding + smallMedFont:getWidth(p[2])
		love.graphics.rectangle("fill", winX - self.spaceFromBorder - width + self.sidePadding, 
			winY - self.spaceFromBorder - height + self.headerPadding + mediumHeight + 5 + (j-1)*(self.listPadding) + (j-1)*(smallHeight), 5, 5)
		love.graphics.setColor(textColor)
		love.graphics.print(p[2], winX - self.spaceFromBorder - width + self.sidePadding + 10, 
			winY - self.spaceFromBorder - height + self.headerPadding + mediumHeight + 3 + (j-1)*(self.listPadding) + (j-1)*(smallHeight))
		j = j+1
	end	
end

