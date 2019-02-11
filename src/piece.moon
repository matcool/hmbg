class Piece
	new: (parent, type, x=0, y=0) =>
		@parent = parent
		@type = type
		@x = x
		@y = y
		@shape = Shapes[parent.parent.rotationSystem][type]
		@size = #@shape

	update: (dt) =>
		if Input\pressed "game_left"
			@x -= 1
		elseif Input\pressed "game_right"
			@x += 1

	draw: =>
		love.graphics.setCanvas @parent.canvas
		love.graphics.setColor Colors[@parent.parent.colors][@type]

		for x = 1, @size
			for y = 1, @size
				if @shape[y][x] == 1
					love.graphics.rectangle "fill", (@x + x - 2) * @parent.cellSize,
						(@y + y - 2 - @parent.hidden) * @parent.cellSize, @parent.cellSize,
						@parent.cellSize

		love.graphics.setCanvas!

return Piece