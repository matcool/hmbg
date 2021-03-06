State = require "state"
Field = require "field"

class GameState extends State
	new: =>
		@rotationSystem = "SRS"
		@colors = "SRS"
		@das = 120
		@arr = 0
		@arrTimer = @arr / 1000
		@setAfter = 1
		@fallAfter = 1
		-- TODO: come up with better name
		@softDropAfter = 0.1
		@field = Field self

	update: (dt) =>
		@field\update dt

	draw: =>
		@field\draw!
		
		love.graphics.setColor 1, 1, 1
		love.graphics.draw @field.canvas,
			love.graphics.getWidth! / 2 - @field.canvas\getWidth! / 2,
			love.graphics.getHeight! / 2 - @field.canvas\getHeight! / 2

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

		-- Draw held piece
		if @field.held != nil
			love.graphics.setColor Colors[@colors][@field.held]
			shape = Shapes[@rotationSystem][@field.held]
			-- Adding two to shape width for some spacing between the field
			xOff = love.graphics.getWidth! / 2 - @field.canvas\getWidth! / 2 - (#shape[1] + 2) * @field.cellSize
			for y, row in ipairs shape
				for x, cell in ipairs row
					if cell == 1
						love.graphics.rectangle "fill", x * @field.cellSize + xOff, y * @field.cellSize, 
							@field.cellSize, @field.cellSize

GameState