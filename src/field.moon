State = require "state"
Piece = require "piece"

class Field extends State
	new: (parent) =>
		@parent = parent
		@width = 10
		@height = 20
		@hidden = 2
		@grid = [nil for _ = 1, @width * (@height + @hidden)]
		@cellSize = 32
		@active = Piece self, "T"
		-- Center piece position, rounded to left
		@active.x = (math.floor @width / 2) - @active.size
		-- Put one row of piece on lower hidden row
		@active.y = @hidden
		@canvas = love.graphics.newCanvas @width * @cellSize, @height * @cellSize

	getCell: (x, y) => @grid[((y - 1) * @width + (x - 1)) + 1]

	setCell: (x, y, newCell) => @grid[((y - 1) * @width + (x - 1)) + 1] = newCell

	clearLines: =>
		for y = 1, @height + @hidden
			row = [1 for x = 1, @width when @getCell x, y]
			if #row == @width
				@move "down", y

	move: (dir, yOff=@height+@hidden) =>
		default = nil
		if dir == "up"
			for y = 1, yOff
				for x = 1, @width
					if y == @height + @hidden
						@setCell x, y, default
					else
						@setCell x, y, @getCell x, y + 1
		elseif dir == "down"
			for y = yOff, 1, -1
				for x = 1, @width
					if y == 1
						@setCell x, y, default
					else
						@setCell x, y, (@getCell x, y-1)


	update: (dt) =>
		@active\update dt
		if @active.hasSet
			@clearLines!
			@active = Piece self, "T"
			@active.x = (math.floor @width / 2) - @active.size
			@active.y = @hidden

	draw: =>
		love.graphics.setCanvas @canvas
		love.graphics.clear!

		-- Draw grid
		for x = 1, @width
			-- Draw rows below hidden
			for y = 1 + @hidden, @height + @hidden
				-- Draw grid
				love.graphics.setColor .25, .25, .25
				love.graphics.rectangle "line", (x - 1) * @cellSize,
					(y - 1 - @hidden) * @cellSize, @cellSize, @cellSize

				-- Draw blocks
				cell = @getCell x, y
				if cell
					love.graphics.setColor Colors[@parent.colors][cell]
					love.graphics.rectangle "fill", (x - 1) * @cellSize,
						(y - 1 - @hidden) * @cellSize, @cellSize, @cellSize

		-- Draw grid outline
		love.graphics.setLineWidth 3
		love.graphics.setColor .35, .35, .35
		love.graphics.rectangle "line", 0, 0, @canvas\getWidth!, @canvas\getHeight!
		love.graphics.setLineWidth 1

		love.graphics.setCanvas!

		@active\draw!

return Field
