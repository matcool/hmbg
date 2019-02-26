State = require "state"
Field = require "field"

class GameState extends State
	new: =>
		@rotationSystem = "SRS"
		@colors = "SRS"
		@das = 80
		@arr = 0
		@arrTimer = @arr / 1000
		@setAfter = 1
		@fallAfter = 0.5
		@field = Field self

	update: (dt) =>
		@field\update dt

	draw: =>
		@field\draw!
		
		love.graphics.setColor 1, 1, 1
		love.graphics.draw @field.canvas,
			love.graphics.getWidth! / 2 - @field.canvas\getWidth! / 2,
			love.graphics.getHeight! / 2 - @field.canvas\getHeight! /2

		-- Draw upcoming pieces
		yOff = 0
		for _, p in pairs @field.generator\getUpcoming(false, 5)
			love.graphics.setColor Colors[@colors][p]
			shape = Shapes[@rotationSystem][p]
			xOff = love.graphics.getWidth! / 2 + @field.canvas\getWidth! / 2
			for y, row in ipairs shape
				for x, cell in ipairs row
					if cell == 1
						love.graphics.rectangle "fill", x * @field.cellSize + xOff, y * @field.cellSize + yOff, 
							@field.cellSize, @field.cellSize
			yOff += #shape * @field.cellSize
			if p == "O" yOff += @field.cellSize

return GameState