shapes = require "shapes"

class Piece
	new: (type, rotationSystem, field, x=0, y=0) =>
		@type = type
		@field = field
		@x = x
		@y = y
		@shape = shapes[rotationSystem][type]
		@size = #@shape

	update: (dt) =>
		if input\pressed "game_left"
			@x -= 1
		elseif input\pressed "game_right"
			@x += 1

	draw: =>
		love.graphics.setCanvas @field.canvas
		love.graphics.setColor 1, 1, 1

		for x = 1, @size
			for y = 1, @size
				if @shape[y][x] == 1
					love.graphics.rectangle "fill", (@x + x - 2) * @field.cellSize,
						(@y + y - 2 - @field.hidden) * @field.cellSize, @field.cellSize,
						@field.cellSize

		love.graphics.setCanvas!

return Piece