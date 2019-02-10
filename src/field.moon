State = require "state"

class Field extends State
	new: =>
		@width = 10
		@height = 20
		@grid = [nil for _ = 1, @width * @height]
		@cellSize = 32
		@canvas = love.graphics.newCanvas @width * @cellSize, @height * @cellSize

	getCell: (x, y) => @grid[((y - 1) * @width + (x - 1)) + 1]

	setCell: (x, y, newCell) => @grid[((y - 1) * @width + (x - 1)) + 1] = newCell

	draw: =>
		for x = 1, @width
			for y = 1, @height
				love.graphics.setCanvas @canvas
				if @getCell x, y
					love.graphics.rectangle "fill", (x - 1) * @cellSize, (y - 1) * @cellSize,
						@cellSize, @cellSize
				love.graphics.setCanvas!

return Field